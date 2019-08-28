Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74876A0C07
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfH1VEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:04:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19742 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727007AbfH1VEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:04:14 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x7SL2O2W023022
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=FtOhHeFUusg5zoqho3Xg0nJRXc/5dplrdyaCMp4MQ8A=;
 b=ibzzvTi5v/j09a1BgJvKtrDNP1AW8rtY1AM1jRHQkPNTgpBtSkidjmxg1Famh2JTXMwe
 fSkq1aoEle3HU50ZCOift2JrOm3vbX8zrAncxmaJomrdia+V8ijzgVpHab19G8rH8Kmp
 8yUaBlXFfjyzmr92llyYx3gkMxbpdd0Q8kQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2unuwq9r0d-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 14:04:12 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 28 Aug 2019 14:04:10 -0700
Received: by devvm2868.prn3.facebook.com (Postfix, from userid 125878)
        id ED8ADA25D5F1; Wed, 28 Aug 2019 14:04:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Julia Kartseva <hex@fb.com>
Smtp-Origin-Hostname: devvm2868.prn3.facebook.com
To:     <rdna@fb.com>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Julia Kartseva <hex@fb.com>
Smtp-Origin-Cluster: prn3c11
Subject: [PATCH bpf-next 04/10] tools/bpf: add libbpf_prog_type_(from|to)_str helpers
Date:   Wed, 28 Aug 2019 14:03:07 -0700
Message-ID: <467620c966825173dbd65b37a3f9bd7dd4fb8184.1567024943.git.hex@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1567024943.git.hex@fb.com>
References: <cover.1567024943.git.hex@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-28_11:2019-08-28,2019-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908280205
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Standardize string representation of prog types by putting commonly used
names to libbpf.
The prog_type to string mapping is taken from bpftool:
tools/bpf/bpftool/main.h

Signed-off-by: Julia Kartseva <hex@fb.com>
---
 tools/lib/bpf/libbpf.c   | 51 ++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h   |  8 +++++++
 tools/lib/bpf/libbpf.map |  2 ++
 3 files changed, 61 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 72e6e5eb397f..946a4d41f223 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -296,6 +296,35 @@ struct bpf_object {
 };
 #define obj_elf_valid(o)	((o)->efile.elf)
 
+static const char *const prog_type_strs[] = {
+	[BPF_PROG_TYPE_UNSPEC] = "unspec",
+	[BPF_PROG_TYPE_SOCKET_FILTER] = "socket_filter",
+	[BPF_PROG_TYPE_KPROBE] = "kprobe",
+	[BPF_PROG_TYPE_SCHED_CLS] = "sched_cls",
+	[BPF_PROG_TYPE_SCHED_ACT] = "sched_act",
+	[BPF_PROG_TYPE_TRACEPOINT] = "tracepoint",
+	[BPF_PROG_TYPE_XDP] = "xdp",
+	[BPF_PROG_TYPE_PERF_EVENT] = "perf_event",
+	[BPF_PROG_TYPE_CGROUP_SKB] = "cgroup_skb",
+	[BPF_PROG_TYPE_CGROUP_SOCK] = "cgroup_sock",
+	[BPF_PROG_TYPE_LWT_IN] = "lwt_in",
+	[BPF_PROG_TYPE_LWT_OUT] = "lwt_out",
+	[BPF_PROG_TYPE_LWT_XMIT] = "lwt_xmit",
+	[BPF_PROG_TYPE_SOCK_OPS] = "sock_ops",
+	[BPF_PROG_TYPE_SK_SKB] = "sk_skb",
+	[BPF_PROG_TYPE_CGROUP_DEVICE] = "cgroup_device",
+	[BPF_PROG_TYPE_SK_MSG] = "sk_msg",
+	[BPF_PROG_TYPE_RAW_TRACEPOINT] = "raw_tracepoint",
+	[BPF_PROG_TYPE_CGROUP_SOCK_ADDR] = "cgroup_sock_addr",
+	[BPF_PROG_TYPE_LWT_SEG6LOCAL] = "lwt_seg6local",
+	[BPF_PROG_TYPE_LIRC_MODE2] = "lirc_mode2",
+	[BPF_PROG_TYPE_SK_REUSEPORT] = "sk_reuseport",
+	[BPF_PROG_TYPE_FLOW_DISSECTOR] = "flow_dissector",
+	[BPF_PROG_TYPE_CGROUP_SYSCTL] = "cgroup_sysctl",
+	[BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE] = "raw_tracepoint_writable",
+	[BPF_PROG_TYPE_CGROUP_SOCKOPT] = "cgroup_sockopt",
+};
+
 void bpf_program__unload(struct bpf_program *prog)
 {
 	int i;
@@ -4632,6 +4661,28 @@ int libbpf_attach_type_by_name(const char *name,
 	return -EINVAL;
 }
 
+int libbpf_prog_type_from_str(const char *str, enum bpf_prog_type *type)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(prog_type_strs); i++)
+		if (prog_type_strs[i] && strcmp(prog_type_strs[i], str) == 0) {
+			*type = i;
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+int libbpf_prog_type_to_str(enum bpf_prog_type type, const char **str)
+{
+	if (type < BPF_PROG_TYPE_UNSPEC || type >= ARRAY_SIZE(prog_type_strs))
+		return -EINVAL;
+
+	*str = prog_type_strs[type];
+	return 0;
+}
+
 static int
 bpf_program__identify_section(struct bpf_program *prog,
 			      enum bpf_prog_type *prog_type,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e8f70977d137..6846c488d8a2 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -122,12 +122,20 @@ LIBBPF_API int bpf_object__set_priv(struct bpf_object *obj, void *priv,
 				    bpf_object_clear_priv_t clear_priv);
 LIBBPF_API void *bpf_object__priv(const struct bpf_object *prog);
 
+/* Program and expected attach types by section name */
 LIBBPF_API int
 libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 			 enum bpf_attach_type *expected_attach_type);
+/* Attach type by section name */
 LIBBPF_API int libbpf_attach_type_by_name(const char *name,
 					  enum bpf_attach_type *attach_type);
 
+/* String representation of program type */
+LIBBPF_API int libbpf_prog_type_from_str(const char *str,
+					 enum bpf_prog_type *type);
+LIBBPF_API int libbpf_prog_type_to_str(enum bpf_prog_type type,
+				       const char **str);
+
 /* Accessors of bpf_program */
 struct bpf_program;
 LIBBPF_API struct bpf_program *bpf_program__next(struct bpf_program *prog,
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 664ce8e7a60e..2ea7c99f1579 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -188,4 +188,6 @@ LIBBPF_0.0.4 {
 LIBBPF_0.0.5 {
 	global:
 		bpf_btf_get_next_id;
+		libbpf_prog_type_from_str;
+		libbpf_prog_type_to_str;
 } LIBBPF_0.0.4;
-- 
2.17.1

