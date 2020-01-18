Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3005D141581
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 02:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbgARB5Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jan 2020 20:57:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63222 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727033AbgARB5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 20:57:16 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00I1qZZC018808
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 17:57:14 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xkmdm10j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 17:57:14 -0800
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 17 Jan 2020 17:57:14 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id DA978760922; Fri, 17 Jan 2020 16:07:01 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] libbpf: Add support for program extensions
Date:   Fri, 17 Jan 2020 16:06:56 -0800
Message-ID: <20200118000657.2135859-3-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200118000657.2135859-1-ast@kernel.org>
References: <20200118000657.2135859-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=1 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001180013
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add minimal support for program extensions. bpf_object_open_opts() needs to be
called with attach_prog_fd = target_prog_fd and BPF program extension needs to
have in .c file section definition like SEC("replace/func_to_be_replaced").
libbpf will search for "func_to_be_replaced" in the target_prog_fd's BTF and
will pass it in attach_btf_id to the kernel. This approach works for tests, but
more compex use case may need to request function name (and attach_btf_id that
kernel sees) to be more dynamic. Such API will be added in future patches.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/include/uapi/linux/bpf.h |  1 +
 tools/lib/bpf/bpf.c            |  3 ++-
 tools/lib/bpf/libbpf.c         | 14 +++++++++++---
 tools/lib/bpf/libbpf.h         |  2 ++
 tools/lib/bpf/libbpf.map       |  2 ++
 tools/lib/bpf/libbpf_probes.c  |  1 +
 6 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 033d90a2282d..e81628eb059c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -180,6 +180,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 	BPF_PROG_TYPE_TRACING,
 	BPF_PROG_TYPE_STRUCT_OPS,
+	BPF_PROG_TYPE_EXT,
 };
 
 enum bpf_attach_type {
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index ed42b006533c..c6dafe563176 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -237,7 +237,8 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	attr.expected_attach_type = load_attr->expected_attach_type;
 	if (attr.prog_type == BPF_PROG_TYPE_STRUCT_OPS) {
 		attr.attach_btf_id = load_attr->attach_btf_id;
-	} else if (attr.prog_type == BPF_PROG_TYPE_TRACING) {
+	} else if (attr.prog_type == BPF_PROG_TYPE_TRACING ||
+		   attr.prog_type == BPF_PROG_TYPE_EXT) {
 		attr.attach_btf_id = load_attr->attach_btf_id;
 		attr.attach_prog_fd = load_attr->attach_prog_fd;
 	} else {
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index faab96a42141..bbf7e996553a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4837,7 +4837,8 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.license = license;
 	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS) {
 		load_attr.attach_btf_id = prog->attach_btf_id;
-	} else if (prog->type == BPF_PROG_TYPE_TRACING) {
+	} else if (prog->type == BPF_PROG_TYPE_TRACING ||
+		   prog->type == BPF_PROG_TYPE_EXT) {
 		load_attr.attach_prog_fd = prog->attach_prog_fd;
 		load_attr.attach_btf_id = prog->attach_btf_id;
 	} else {
@@ -4918,7 +4919,8 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 {
 	int err = 0, fd, i, btf_id;
 
-	if (prog->type == BPF_PROG_TYPE_TRACING) {
+	if (prog->type == BPF_PROG_TYPE_TRACING ||
+	    prog->type == BPF_PROG_TYPE_EXT) {
 		btf_id = libbpf_find_attach_btf_id(prog);
 		if (btf_id <= 0)
 			return btf_id;
@@ -5092,7 +5094,8 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 
 		bpf_program__set_type(prog, prog_type);
 		bpf_program__set_expected_attach_type(prog, attach_type);
-		if (prog_type == BPF_PROG_TYPE_TRACING)
+		if (prog_type == BPF_PROG_TYPE_TRACING ||
+		    prog_type == BPF_PROG_TYPE_EXT)
 			prog->attach_prog_fd = OPTS_GET(opts, attach_prog_fd, 0);
 	}
 
@@ -6166,6 +6169,7 @@ BPF_PROG_TYPE_FNS(xdp, BPF_PROG_TYPE_XDP);
 BPF_PROG_TYPE_FNS(perf_event, BPF_PROG_TYPE_PERF_EVENT);
 BPF_PROG_TYPE_FNS(tracing, BPF_PROG_TYPE_TRACING);
 BPF_PROG_TYPE_FNS(struct_ops, BPF_PROG_TYPE_STRUCT_OPS);
+BPF_PROG_TYPE_FNS(extension, BPF_PROG_TYPE_EXT);
 
 enum bpf_attach_type
 bpf_program__get_expected_attach_type(struct bpf_program *prog)
@@ -6265,6 +6269,10 @@ static const struct bpf_sec_def section_defs[] = {
 		.expected_attach_type = BPF_TRACE_FEXIT,
 		.is_attach_btf = true,
 		.attach_fn = attach_trace),
+	SEC_DEF("replace/", EXT,
+		.expected_attach_type = 0,
+		.is_attach_btf = true,
+		.attach_fn = attach_trace),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 01639f9a1062..2a5e3b087002 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -318,6 +318,7 @@ LIBBPF_API int bpf_program__set_xdp(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_perf_event(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_tracing(struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_struct_ops(struct bpf_program *prog);
+LIBBPF_API int bpf_program__set_extension(struct bpf_program *prog);
 
 LIBBPF_API enum bpf_prog_type bpf_program__get_type(struct bpf_program *prog);
 LIBBPF_API void bpf_program__set_type(struct bpf_program *prog,
@@ -339,6 +340,7 @@ LIBBPF_API bool bpf_program__is_xdp(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_perf_event(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_tracing(const struct bpf_program *prog);
 LIBBPF_API bool bpf_program__is_struct_ops(const struct bpf_program *prog);
+LIBBPF_API bool bpf_program__is_extension(const struct bpf_program *prog);
 
 /*
  * No need for __attribute__((packed)), all members of 'bpf_map_def'
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 64ec71ba41f1..b035122142bb 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -228,7 +228,9 @@ LIBBPF_0.0.7 {
 		bpf_prog_attach_xattr;
 		bpf_program__attach;
 		bpf_program__name;
+		bpf_program__is_extension;
 		bpf_program__is_struct_ops;
+		bpf_program__set_extension;
 		bpf_program__set_struct_ops;
 		btf__align_of;
 		libbpf_find_kernel_btf;
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 8cc992bc532a..b782ebef6ac9 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -107,6 +107,7 @@ probe_load(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_TRACING:
 	case BPF_PROG_TYPE_STRUCT_OPS:
+	case BPF_PROG_TYPE_EXT:
 	default:
 		break;
 	}
-- 
2.23.0

