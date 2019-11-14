Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3F0FCE5D
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfKNS6I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 13:58:08 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9328 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727316AbfKNS6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:58:03 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAEIgto6031772
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:58:02 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2w8jxpqkq2-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:58:01 -0800
Received: from 2401:db00:2050:5076:face:0:7:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 14 Nov 2019 10:58:00 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id EB52376071B; Thu, 14 Nov 2019 10:57:57 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 18/20] libbpf: Add support for attaching BPF programs to other BPF programs
Date:   Thu, 14 Nov 2019 10:57:18 -0800
Message-ID: <20191114185720.1641606-19-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114185720.1641606-1-ast@kernel.org>
References: <20191114185720.1641606-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=3 impostorscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend libbpf api to pass attach_prog_fd into bpf_object__open.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/include/uapi/linux/bpf.h |  1 +
 tools/lib/bpf/bpf.c            |  8 ++--
 tools/lib/bpf/bpf.h            |  5 ++-
 tools/lib/bpf/libbpf.c         | 71 ++++++++++++++++++++++++++++------
 tools/lib/bpf/libbpf.h         |  3 +-
 5 files changed, 71 insertions(+), 17 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 69c200e6e696..4842a134b202 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -425,6 +425,7 @@ union bpf_attr {
 		__aligned_u64	line_info;	/* line info */
 		__u32		line_info_cnt;	/* number of bpf_line_info records */
 		__u32		attach_btf_id;	/* in-kernel BTF type id to attach to */
+		__u32		attach_prog_fd; /* 0 to attach to vmlinux */
 	};
 
 	struct { /* anonymous struct used by BPF_OBJ_* commands */
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index b3e3e99a0f28..98596e15390f 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -228,10 +228,13 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = load_attr->prog_type;
 	attr.expected_attach_type = load_attr->expected_attach_type;
-	if (attr.prog_type == BPF_PROG_TYPE_TRACING)
+	if (attr.prog_type == BPF_PROG_TYPE_TRACING) {
 		attr.attach_btf_id = load_attr->attach_btf_id;
-	else
+		attr.attach_prog_fd = load_attr->attach_prog_fd;
+	} else {
 		attr.prog_ifindex = load_attr->prog_ifindex;
+		attr.kern_version = load_attr->kern_version;
+	}
 	attr.insn_cnt = (__u32)load_attr->insns_cnt;
 	attr.insns = ptr_to_u64(load_attr->insns);
 	attr.license = ptr_to_u64(load_attr->license);
@@ -245,7 +248,6 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 		attr.log_size = 0;
 	}
 
-	attr.kern_version = load_attr->kern_version;
 	attr.prog_btf_fd = load_attr->prog_btf_fd;
 	attr.func_info_rec_size = load_attr->func_info_rec_size;
 	attr.func_info_cnt = load_attr->func_info_cnt;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 1c53bc5b4b3c..3c791fa8e68e 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -77,7 +77,10 @@ struct bpf_load_program_attr {
 	const struct bpf_insn *insns;
 	size_t insns_cnt;
 	const char *license;
-	__u32 kern_version;
+	union {
+		__u32 kern_version;
+		__u32 attach_prog_fd;
+	};
 	union {
 		__u32 prog_ifindex;
 		__u32 attach_btf_id;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 98ee033e021f..7132c6bdec02 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -189,6 +189,7 @@ struct bpf_program {
 
 	enum bpf_attach_type expected_attach_type;
 	__u32 attach_btf_id;
+	__u32 attach_prog_fd;
 	void *func_info;
 	__u32 func_info_rec_size;
 	__u32 func_info_cnt;
@@ -3683,8 +3684,13 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.insns = insns;
 	load_attr.insns_cnt = insns_cnt;
 	load_attr.license = license;
-	load_attr.kern_version = kern_version;
-	load_attr.prog_ifindex = prog->prog_ifindex;
+	if (prog->type == BPF_PROG_TYPE_TRACING) {
+		load_attr.attach_prog_fd = prog->attach_prog_fd;
+		load_attr.attach_btf_id = prog->attach_btf_id;
+	} else {
+		load_attr.kern_version = kern_version;
+		load_attr.prog_ifindex = prog->prog_ifindex;
+	}
 	/* if .BTF.ext was loaded, kernel supports associated BTF for prog */
 	if (prog->obj->btf_ext)
 		btf_fd = bpf_object__btf_fd(prog->obj);
@@ -3699,7 +3705,6 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.line_info_cnt = prog->line_info_cnt;
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
-	load_attr.attach_btf_id = prog->attach_btf_id;
 
 retry_load:
 	log_buf = malloc(log_buf_size);
@@ -3856,9 +3861,9 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	return 0;
 }
 
-static int libbpf_attach_btf_id_by_name(const char *name,
-					enum bpf_attach_type attach_type);
-
+static int libbpf_find_attach_btf_id(const char *name,
+				     enum bpf_attach_type attach_type,
+				     __u32 attach_prog_fd);
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   struct bpf_object_open_opts *opts)
@@ -3869,6 +3874,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	const char *obj_name;
 	char tmp_name[64];
 	bool relaxed_maps;
+	__u32 attach_prog_fd;
 	int err;
 
 	if (elf_version(EV_CURRENT) == EV_NONE) {
@@ -3899,6 +3905,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	obj->relaxed_core_relocs = OPTS_GET(opts, relaxed_core_relocs, false);
 	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
 	pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
+	attach_prog_fd = OPTS_GET(opts, attach_prog_fd, 0);
 
 	CHECK_ERR(bpf_object__elf_init(obj), err, out);
 	CHECK_ERR(bpf_object__check_endianness(obj), err, out);
@@ -3923,11 +3930,13 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		bpf_program__set_type(prog, prog_type);
 		bpf_program__set_expected_attach_type(prog, attach_type);
 		if (prog_type == BPF_PROG_TYPE_TRACING) {
-			err = libbpf_attach_btf_id_by_name(prog->section_name,
-							   attach_type);
+			err = libbpf_find_attach_btf_id(prog->section_name,
+							attach_type,
+							attach_prog_fd);
 			if (err <= 0)
 				goto out;
 			prog->attach_btf_id = err;
+			prog->attach_prog_fd = attach_prog_fd;
 		}
 	}
 
@@ -5086,8 +5095,42 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 	return err;
 }
 
-static int libbpf_attach_btf_id_by_name(const char *name,
-					enum bpf_attach_type attach_type)
+static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
+{
+	struct bpf_prog_info_linear *info_linear;
+	struct bpf_prog_info *info;
+	struct btf *btf = NULL;
+	int err = -EINVAL;
+
+	info_linear = bpf_program__get_prog_info_linear(attach_prog_fd, 0);
+	if (IS_ERR_OR_NULL(info_linear)) {
+		pr_warn("failed get_prog_info_linear for FD %d\n",
+			attach_prog_fd);
+		return -EINVAL;
+	}
+	info = &info_linear->info;
+	if (!info->btf_id) {
+		pr_warn("The target program doesn't have BTF\n");
+		goto out;
+	}
+	if (btf__get_from_id(info->btf_id, &btf)) {
+		pr_warn("Failed to get BTF of the program\n");
+		goto out;
+	}
+	err = btf__find_by_name_kind(btf, name, BTF_KIND_FUNC);
+	btf__free(btf);
+	if (err <= 0) {
+		pr_warn("%s is not found in prog's BTF\n", name);
+		goto out;
+	}
+out:
+	free(info_linear);
+	return err;
+}
+
+static int libbpf_find_attach_btf_id(const char *name,
+				     enum bpf_attach_type attach_type,
+				     __u32 attach_prog_fd)
 {
 	int i, err;
 
@@ -5099,8 +5142,12 @@ static int libbpf_attach_btf_id_by_name(const char *name,
 			continue;
 		if (strncmp(name, section_names[i].sec, section_names[i].len))
 			continue;
-		err = libbpf_find_vmlinux_btf_id(name + section_names[i].len,
-						 attach_type);
+		if (attach_prog_fd)
+			err = libbpf_find_prog_btf_id(name + section_names[i].len,
+						      attach_prog_fd);
+		else
+			err = libbpf_find_vmlinux_btf_id(name + section_names[i].len,
+							 attach_type);
 		if (err <= 0)
 			pr_warn("%s is not found in vmlinux BTF\n", name);
 		return err;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index fbff419f6daf..0dbf4bfba0c4 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -108,8 +108,9 @@ struct bpf_object_open_opts {
 	 * auto-pinned to that path on load; defaults to "/sys/fs/bpf".
 	 */
 	const char *pin_root_path;
+	__u32 attach_prog_fd;
 };
-#define bpf_object_open_opts__last_field pin_root_path
+#define bpf_object_open_opts__last_field attach_prog_fd
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
-- 
2.23.0

