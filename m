Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE7F174C3A
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 09:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCAIL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 03:11:27 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10374 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbgCAIL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 03:11:26 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0218BLa7021455
        for <netdev@vger.kernel.org>; Sun, 1 Mar 2020 00:11:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=JLwCLWrUsy+2syMhI8UJBUd5ErTVH+l2tWs26GDbWMk=;
 b=ZjvZgfkXTh+6gSEabbu1/5rZg5cDrMS3tM2SCgsfe9+Ft9ekrwviUx0EKheU/8G39rmp
 /8iCWLRfW7oJirNrvgeDZyTZNDPAabKAQSR1sSMFe9KZhsWacgpud4xw4p2xp2DE4Wng
 MD3rxXofxkxe998P8WbdqSx3WehUlKHCXag= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yg8dcr4ap-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 00:11:25 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 1 Mar 2020 00:11:00 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 425412EC2D1F; Sun,  1 Mar 2020 00:10:56 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <ethercflow@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] bpf: generate directly-usable raw_tp_##call structs for raw tracepoints
Date:   Sun, 1 Mar 2020 00:10:44 -0800
Message-ID: <20200301081045.3491005-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200301081045.3491005-1-andriin@fb.com>
References: <20200301081045.3491005-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_02:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 suspectscore=8 phishscore=0
 malwarescore=0 impostorscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003010066
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In addition to btf_trace_##call typedefs to func protos, generate a struct
raw_tp_##call with memory layout directly usable from BPF programs to access
raw tracepoint arguments. This allows for user BPF programs to directly use
such structs for their raw tracepoint BPF programs when using vmlinux.h,
without having to manually copy/paste and maintain raw tracepoint argument
declarations. Additionally, due to CO-RE and preserve_access_index attribute,
such structs are relocatable, all the CO-RE relocations and field existence
checks are available automatically to such BPF programs.

runqslower example in next patch will demonstrate this usage.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/trace/bpf_probe.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
index 1ce3be63add1..a9e83236c181 100644
--- a/include/trace/bpf_probe.h
+++ b/include/trace/bpf_probe.h
@@ -55,6 +55,21 @@
 /* tracepoints with more than 12 arguments will hit build error */
 #define CAST_TO_U64(...) CONCATENATE(__CAST, COUNT_ARGS(__VA_ARGS__))(__VA_ARGS__)
 
+#define __RAW_TP_ARG(a) a __attribute__((aligned(8)))
+#define __RAW_TP_ARGS1(a,...) __RAW_TP_ARG(a);
+#define __RAW_TP_ARGS2(a,...) __RAW_TP_ARG(a); __RAW_TP_ARGS1(__VA_ARGS__);
+#define __RAW_TP_ARGS3(a,...) __RAW_TP_ARG(a); __RAW_TP_ARGS2(__VA_ARGS__);
+#define __RAW_TP_ARGS4(a,...) __RAW_TP_ARG(a); __RAW_TP_ARGS3(__VA_ARGS__);
+#define __RAW_TP_ARGS5(a,...) __RAW_TP_ARG(a); __RAW_TP_ARGS4(__VA_ARGS__);
+#define __RAW_TP_ARGS6(a,...) __RAW_TP_ARG(a); __RAW_TP_ARGS5(__VA_ARGS__);
+#define __RAW_TP_ARGS7(a,...) __RAW_TP_ARG(a); __RAW_TP_ARGS6(__VA_ARGS__);
+#define __RAW_TP_ARGS8(a,...) __RAW_TP_ARG(a); __RAW_TP_ARGS7(__VA_ARGS__);
+#define __RAW_TP_ARGS9(a,...) __RAW_TP_ARG(a); __RAW_TP_ARGS8(__VA_ARGS__);
+#define __RAW_TP_ARGS10(a,...) __RAW_TP_ARG(a); __RAW_TP_ARGS9(__VA_ARGS__);
+#define __RAW_TP_ARGS11(a,...) __RAW_TP_ARG(a); __RAW_TP_ARGS10(__VA_ARGS__);
+#define __RAW_TP_ARGS12(a,...) __RAW_TP_ARG(a); __RAW_TP_ARGS11(__VA_ARGS__);
+#define RAW_TP_ARGS(args...) CONCATENATE(__RAW_TP_ARGS, COUNT_ARGS(args))(args)
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace void							\
@@ -75,9 +90,13 @@ static inline void bpf_test_probe_##call(void)				\
 	check_trace_callback_type_##call(__bpf_trace_##template);	\
 }									\
 typedef void (*btf_trace_##call)(void *__data, proto);			\
+struct raw_tp_##call {							\
+	RAW_TP_ARGS(proto)						\
+};									\
 static union {								\
 	struct bpf_raw_event_map event;					\
 	btf_trace_##call handler;					\
+	struct raw_tp_##call *raw_tp_args;				\
 } __bpf_trace_tp_map_##call __used					\
 __attribute__((section("__bpf_raw_tp_map"))) = {			\
 	.event = {							\
-- 
2.17.1

