Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE91174C35
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 09:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgCAILC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 03:11:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29522 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725874AbgCAILC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 03:11:02 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0217xJVf027124
        for <netdev@vger.kernel.org>; Sun, 1 Mar 2020 00:11:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=NCKhL9uljUZTFs1tSwGL93m8/fMjHGLelVIb1CX+JEE=;
 b=Kkbllo/J+/fdehZERPjzpw2tRVD8uUQpbdQ0Rl+PSQRYYPs8cBa2+RoT8joERYaMmz5o
 xo3wT9Ztw24HqKPOtce4CyDS1J/Tnxpj/EXpr2+qJi/rhCvq79ZDXmHiXZu2zATVmlxs
 bTZxBWRGcrlA5kRG6VUT0sS/a77MjLmaJKQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfpnqk1s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 00:11:00 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 1 Mar 2020 00:11:00 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1B3FA2EC2D1F; Sun,  1 Mar 2020 00:10:54 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <ethercflow@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/3] bpf: reliably preserve btf_trace_xxx types
Date:   Sun, 1 Mar 2020 00:10:43 -0800
Message-ID: <20200301081045.3491005-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200301081045.3491005-1-andriin@fb.com>
References: <20200301081045.3491005-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_02:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=935 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003010064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

btf_trace_xxx types, crucial for tp_btf BPF programs (raw tracepoint with
verifier-checked direct memory access), have to be preserved in kernel BTF to
allow verifier do its job and enforce type/memory safety. It was reported
([0]) that for kernels built with Clang current type-casting approach doesn't
preserve these types.

This patch fixes it by declaring an anonymous union for each registered
tracepoint, capturing both struct bpf_raw_event_map information, as well as
recording btf_trace_##call type reliably. Structurally, it's still the same
content as for a plain struct bpf_raw_event_map, so no other changes are
necessary.

  [0] https://github.com/iovisor/bcc/issues/2770#issuecomment-591007692

Fixes: e8c423fb31fa ("bpf: Add typecast to raw_tracepoints to help BTF generation")
Reported-by: Wenbo Zhang <ethercflow@gmail.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/trace/bpf_probe.h | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
index b04c29270973..1ce3be63add1 100644
--- a/include/trace/bpf_probe.h
+++ b/include/trace/bpf_probe.h
@@ -75,13 +75,17 @@ static inline void bpf_test_probe_##call(void)				\
 	check_trace_callback_type_##call(__bpf_trace_##template);	\
 }									\
 typedef void (*btf_trace_##call)(void *__data, proto);			\
-static struct bpf_raw_event_map	__used					\
-	__attribute__((section("__bpf_raw_tp_map")))			\
-__bpf_trace_tp_map_##call = {						\
-	.tp		= &__tracepoint_##call,				\
-	.bpf_func	= (void *)(btf_trace_##call)__bpf_trace_##template,	\
-	.num_args	= COUNT_ARGS(args),				\
-	.writable_size	= size,						\
+static union {								\
+	struct bpf_raw_event_map event;					\
+	btf_trace_##call handler;					\
+} __bpf_trace_tp_map_##call __used					\
+__attribute__((section("__bpf_raw_tp_map"))) = {			\
+	.event = {							\
+		.tp		= &__tracepoint_##call,			\
+		.bpf_func	= __bpf_trace_##template,		\
+		.num_args	= COUNT_ARGS(args),			\
+		.writable_size	= size,					\
+	},								\
 };
 
 #define FIRST(x, ...) x
-- 
2.17.1

