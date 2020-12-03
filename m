Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F3A2CCD98
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729761AbgLCDx0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 22:53:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22042 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729733AbgLCDxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:53:25 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B33jt30018912
        for <netdev@vger.kernel.org>; Wed, 2 Dec 2020 19:52:43 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355vfkaj4j-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 19:52:43 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 19:52:42 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 830BE2ECA822; Wed,  2 Dec 2020 19:52:30 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v5 bpf-next 11/14] libbpf: factor out low-level BPF program loading helper
Date:   Wed, 2 Dec 2020 19:52:01 -0800
Message-ID: <20201203035204.1411380-12-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201203035204.1411380-1-andrii@kernel.org>
References: <20201203035204.1411380-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_01:2020-11-30,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=29 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor low-level API for BPF program loading to not rely on public API
types. This allows painless extension without constant efforts to cleverly not
break backwards compatibility.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/bpf.c             | 100 ++++++++++++++++++++++----------
 tools/lib/bpf/libbpf.c          |  34 +++++------
 tools/lib/bpf/libbpf_internal.h |  29 +++++++++
 3 files changed, 113 insertions(+), 50 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index d27e34133973..e371ef91f5e8 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -214,59 +214,52 @@ alloc_zero_tailing_info(const void *orecord, __u32 cnt,
 	return info;
 }
 
-int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
-			   char *log_buf, size_t log_buf_sz)
+int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 {
 	void *finfo = NULL, *linfo = NULL;
 	union bpf_attr attr;
-	__u32 log_level;
 	int fd;
 
-	if (!load_attr || !log_buf != !log_buf_sz)
+	if (!load_attr->log_buf != !load_attr->log_buf_sz)
 		return -EINVAL;
 
-	log_level = load_attr->log_level;
-	if (log_level > (4 | 2 | 1) || (log_level && !log_buf))
+	if (load_attr->log_level > (4 | 2 | 1) || (load_attr->log_level && !load_attr->log_buf))
 		return -EINVAL;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = load_attr->prog_type;
 	attr.expected_attach_type = load_attr->expected_attach_type;
-	if (attr.prog_type == BPF_PROG_TYPE_STRUCT_OPS ||
-	    attr.prog_type == BPF_PROG_TYPE_LSM) {
-		attr.attach_btf_id = load_attr->attach_btf_id;
-	} else if (attr.prog_type == BPF_PROG_TYPE_TRACING ||
-		   attr.prog_type == BPF_PROG_TYPE_EXT) {
-		attr.attach_btf_id = load_attr->attach_btf_id;
-		attr.attach_prog_fd = load_attr->attach_prog_fd;
-	} else {
-		attr.prog_ifindex = load_attr->prog_ifindex;
-		attr.kern_version = load_attr->kern_version;
-	}
-	attr.insn_cnt = (__u32)load_attr->insns_cnt;
+
+	attr.attach_btf_id = load_attr->attach_btf_id;
+	attr.attach_prog_fd = load_attr->attach_prog_fd;
+
+	attr.prog_ifindex = load_attr->prog_ifindex;
+	attr.kern_version = load_attr->kern_version;
+
+	attr.insn_cnt = (__u32)load_attr->insn_cnt;
 	attr.insns = ptr_to_u64(load_attr->insns);
 	attr.license = ptr_to_u64(load_attr->license);
 
-	attr.log_level = log_level;
-	if (log_level) {
-		attr.log_buf = ptr_to_u64(log_buf);
-		attr.log_size = log_buf_sz;
-	} else {
-		attr.log_buf = ptr_to_u64(NULL);
-		attr.log_size = 0;
+	attr.log_level = load_attr->log_level;
+	if (attr.log_level) {
+		attr.log_buf = ptr_to_u64(load_attr->log_buf);
+		attr.log_size = load_attr->log_buf_sz;
 	}
 
 	attr.prog_btf_fd = load_attr->prog_btf_fd;
+	attr.prog_flags = load_attr->prog_flags;
+
 	attr.func_info_rec_size = load_attr->func_info_rec_size;
 	attr.func_info_cnt = load_attr->func_info_cnt;
 	attr.func_info = ptr_to_u64(load_attr->func_info);
+
 	attr.line_info_rec_size = load_attr->line_info_rec_size;
 	attr.line_info_cnt = load_attr->line_info_cnt;
 	attr.line_info = ptr_to_u64(load_attr->line_info);
+
 	if (load_attr->name)
 		memcpy(attr.prog_name, load_attr->name,
-		       min(strlen(load_attr->name), BPF_OBJ_NAME_LEN - 1));
-	attr.prog_flags = load_attr->prog_flags;
+		       min(strlen(load_attr->name), (size_t)BPF_OBJ_NAME_LEN - 1));
 
 	fd = sys_bpf_prog_load(&attr, sizeof(attr));
 	if (fd >= 0)
@@ -306,19 +299,19 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 		}
 
 		fd = sys_bpf_prog_load(&attr, sizeof(attr));
-
 		if (fd >= 0)
 			goto done;
 	}
 
-	if (log_level || !log_buf)
+	if (load_attr->log_level || !load_attr->log_buf)
 		goto done;
 
 	/* Try again with log */
-	attr.log_buf = ptr_to_u64(log_buf);
-	attr.log_size = log_buf_sz;
+	attr.log_buf = ptr_to_u64(load_attr->log_buf);
+	attr.log_size = load_attr->log_buf_sz;
 	attr.log_level = 1;
-	log_buf[0] = 0;
+	load_attr->log_buf[0] = 0;
+
 	fd = sys_bpf_prog_load(&attr, sizeof(attr));
 done:
 	free(finfo);
@@ -326,6 +319,49 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	return fd;
 }
 
+int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
+			   char *log_buf, size_t log_buf_sz)
+{
+	struct bpf_prog_load_params p = {};
+
+	if (!load_attr || !log_buf != !log_buf_sz)
+		return -EINVAL;
+
+	p.prog_type = load_attr->prog_type;
+	p.expected_attach_type = load_attr->expected_attach_type;
+	switch (p.prog_type) {
+	case BPF_PROG_TYPE_STRUCT_OPS:
+	case BPF_PROG_TYPE_LSM:
+		p.attach_btf_id = load_attr->attach_btf_id;
+		break;
+	case BPF_PROG_TYPE_TRACING:
+	case BPF_PROG_TYPE_EXT:
+		p.attach_btf_id = load_attr->attach_btf_id;
+		p.attach_prog_fd = load_attr->attach_prog_fd;
+		break;
+	default:
+		p.prog_ifindex = load_attr->prog_ifindex;
+		p.kern_version = load_attr->kern_version;
+	}
+	p.insn_cnt = load_attr->insns_cnt;
+	p.insns = load_attr->insns;
+	p.license = load_attr->license;
+	p.log_level = load_attr->log_level;
+	p.log_buf = log_buf;
+	p.log_buf_sz = log_buf_sz;
+	p.prog_btf_fd = load_attr->prog_btf_fd;
+	p.func_info_rec_size = load_attr->func_info_rec_size;
+	p.func_info_cnt = load_attr->func_info_cnt;
+	p.func_info = load_attr->func_info;
+	p.line_info_rec_size = load_attr->line_info_rec_size;
+	p.line_info_cnt = load_attr->line_info_cnt;
+	p.line_info = load_attr->line_info;
+	p.name = load_attr->name;
+	p.prog_flags = load_attr->prog_flags;
+
+	return libbpf__bpf_prog_load(&p);
+}
+
 int bpf_load_program(enum bpf_prog_type type, const struct bpf_insn *insns,
 		     size_t insns_cnt, const char *license,
 		     __u32 kern_version, char *log_buf,
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 375698999375..0280df77cf5f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6808,7 +6808,7 @@ static int
 load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	     char *license, __u32 kern_version, int *pfd)
 {
-	struct bpf_load_program_attr load_attr;
+	struct bpf_prog_load_params load_attr = {};
 	char *cp, errmsg[STRERR_BUFSIZE];
 	size_t log_buf_size = 0;
 	char *log_buf = NULL;
@@ -6817,7 +6817,6 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	if (!insns || !insns_cnt)
 		return -EINVAL;
 
-	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
 	load_attr.prog_type = prog->type;
 	/* old kernels might not support specifying expected_attach_type */
 	if (!kernel_supports(FEAT_EXP_ATTACH_TYPE) && prog->sec_def &&
@@ -6828,19 +6827,14 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	if (kernel_supports(FEAT_PROG_NAME))
 		load_attr.name = prog->name;
 	load_attr.insns = insns;
-	load_attr.insns_cnt = insns_cnt;
+	load_attr.insn_cnt = insns_cnt;
 	load_attr.license = license;
-	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS ||
-	    prog->type == BPF_PROG_TYPE_LSM) {
-		load_attr.attach_btf_id = prog->attach_btf_id;
-	} else if (prog->type == BPF_PROG_TYPE_TRACING ||
-		   prog->type == BPF_PROG_TYPE_EXT) {
-		load_attr.attach_prog_fd = prog->attach_prog_fd;
-		load_attr.attach_btf_id = prog->attach_btf_id;
-	} else {
-		load_attr.kern_version = kern_version;
-		load_attr.prog_ifindex = prog->prog_ifindex;
-	}
+	load_attr.attach_btf_id = prog->attach_btf_id;
+	load_attr.attach_prog_fd = prog->attach_prog_fd;
+	load_attr.attach_btf_id = prog->attach_btf_id;
+	load_attr.kern_version = kern_version;
+	load_attr.prog_ifindex = prog->prog_ifindex;
+
 	/* specify func_info/line_info only if kernel supports them */
 	btf_fd = bpf_object__btf_fd(prog->obj);
 	if (btf_fd >= 0 && kernel_supports(FEAT_BTF_FUNC)) {
@@ -6864,7 +6858,9 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 		*log_buf = 0;
 	}
 
-	ret = bpf_load_program_xattr(&load_attr, log_buf, log_buf_size);
+	load_attr.log_buf = log_buf;
+	load_attr.log_buf_sz = log_buf_size;
+	ret = libbpf__bpf_prog_load(&load_attr);
 
 	if (ret >= 0) {
 		if (log_buf && load_attr.log_level)
@@ -6905,9 +6901,9 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 		pr_warn("-- BEGIN DUMP LOG ---\n");
 		pr_warn("\n%s\n", log_buf);
 		pr_warn("-- END LOG --\n");
-	} else if (load_attr.insns_cnt >= BPF_MAXINSNS) {
+	} else if (load_attr.insn_cnt >= BPF_MAXINSNS) {
 		pr_warn("Program too large (%zu insns), at most %d insns\n",
-			load_attr.insns_cnt, BPF_MAXINSNS);
+			load_attr.insn_cnt, BPF_MAXINSNS);
 		ret = -LIBBPF_ERRNO__PROG2BIG;
 	} else if (load_attr.prog_type != BPF_PROG_TYPE_KPROBE) {
 		/* Wrong program type? */
@@ -6915,7 +6911,9 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 
 		load_attr.prog_type = BPF_PROG_TYPE_KPROBE;
 		load_attr.expected_attach_type = 0;
-		fd = bpf_load_program_xattr(&load_attr, NULL, 0);
+		load_attr.log_buf = NULL;
+		load_attr.log_buf_sz = 0;
+		fd = libbpf__bpf_prog_load(&load_attr);
 		if (fd >= 0) {
 			close(fd);
 			ret = -LIBBPF_ERRNO__PROGTYPE;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index e569ae63808e..681073a67ae3 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -151,6 +151,35 @@ int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz);
 int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
 			 const char *str_sec, size_t str_len);
 
+struct bpf_prog_load_params {
+	enum bpf_prog_type prog_type;
+	enum bpf_attach_type expected_attach_type;
+	const char *name;
+	const struct bpf_insn *insns;
+	size_t insn_cnt;
+	const char *license;
+	__u32 kern_version;
+	__u32 attach_prog_fd;
+	__u32 attach_btf_id;
+	__u32 prog_ifindex;
+	__u32 prog_btf_fd;
+	__u32 prog_flags;
+
+	__u32 func_info_rec_size;
+	const void *func_info;
+	__u32 func_info_cnt;
+
+	__u32 line_info_rec_size;
+	const void *line_info;
+	__u32 line_info_cnt;
+
+	__u32 log_level;
+	char *log_buf;
+	size_t log_buf_sz;
+};
+
+int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
+
 int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 			     __u32 *size);
 int bpf_object__variable_offset(const struct bpf_object *obj, const char *name,
-- 
2.24.1

