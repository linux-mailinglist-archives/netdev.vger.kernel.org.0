Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE33DE295
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 05:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfJUDjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 23:39:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31504 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbfJUDjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 23:39:13 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9L3PVB9020839
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=3M+7s9lAERjR8PXfvnS9rd+0pqa1+n9UOLh9HznLXaQ=;
 b=fgg1ZMuw2tOCkcFoOyqix5k3Y4ItC6zZ8s5rOSaFK1Y7S1/aSbNZkw/JX3Y8r4AOL1k5
 ouHVYsKEhg7f/ACVHZqol37hdrERP+Pzhcz0qVqbNdL7wQmrYPZdRpUFlkXcIiKgCAmH
 lIb9d2Wpyt3WOOdqaF0SoGgJLxiVqToE8uo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vrj6hjh3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 20:39:12 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 20 Oct 2019 20:39:11 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 011FE861976; Sun, 20 Oct 2019 20:39:09 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 2/7] libbpf: add bpf_program__get_{type, expected_attach_type) APIs
Date:   Sun, 20 Oct 2019 20:38:57 -0700
Message-ID: <20191021033902.3856966-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191021033902.3856966-1-andriin@fb.com>
References: <20191021033902.3856966-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-21_01:2019-10-18,2019-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 suspectscore=8 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910210029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are bpf_program__set_type() and
bpf_program__set_expected_attach_type(), but no corresponding getters,
which seems rather incomplete. Fix this.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 11 +++++++++++
 tools/lib/bpf/libbpf.h   |  5 +++++
 tools/lib/bpf/libbpf.map |  2 ++
 3 files changed, 18 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index cccfd9355134..39163e68dc1e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4468,6 +4468,11 @@ int bpf_program__nth_fd(const struct bpf_program *prog, int n)
 	return fd;
 }
 
+enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog)
+{
+	return prog->type;
+}
+
 void bpf_program__set_type(struct bpf_program *prog, enum bpf_prog_type type)
 {
 	prog->type = type;
@@ -4502,6 +4507,12 @@ BPF_PROG_TYPE_FNS(raw_tracepoint, BPF_PROG_TYPE_RAW_TRACEPOINT);
 BPF_PROG_TYPE_FNS(xdp, BPF_PROG_TYPE_XDP);
 BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
 
+enum bpf_attach_type
+bpf_program__get_expected_attach_type(struct bpf_program *prog)
+{
+	return prog->expected_attach_type;
+}
+
 void bpf_program__set_expected_attach_type(struct bpf_program *prog,
 					   enum bpf_attach_type type)
 {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 53ce212764e0..0fdf086beba7 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -302,8 +302,13 @@ LIBBPF_API int bpf_program__set_sched_cls(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_sched_act(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_xdp(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
+
+LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
 				      enum bpf_prog_type type);
+
+LIBBPF_API enum bpf_attach_type
+bpf_program__get_expected_attach_type(struct bpf_program *prog);
 LIBBPF_API void
 bpf_program__set_expected_attach_type(struct bpf_program *prog,
 				      enum bpf_attach_type type);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 4d241fd92dd4..d1473ea4d7a5 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -195,4 +195,6 @@ LIBBPF_0.0.6 {
 	global:
 		bpf_object__open_file;
 		bpf_object__open_mem;
+		bpf_program__get_expected_attach_type;
+		bpf_program__get_type;
 } LIBBPF_0.0.5;
-- 
2.17.1

