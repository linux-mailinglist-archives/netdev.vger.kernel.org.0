Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B28F275B
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfKGFrf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Nov 2019 00:47:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13918 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726763AbfKGFrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:47:35 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA75i6fv016010
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 21:47:34 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u0kgxc-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 21:47:34 -0800
Received: from 2401:db00:2050:5102:face:0:37:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 21:47:18 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id E546A760BC0; Wed,  6 Nov 2019 21:47:16 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 16/17] libbpf: Add support for attaching BPF programs to other BPF programs
Date:   Wed, 6 Nov 2019 21:46:43 -0800
Message-ID: <20191107054644.1285697-17-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107054644.1285697-1-ast@kernel.org>
References: <20191107054644.1285697-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=3 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend libbpf api to pass attach_prog_fd into bpf_object__open.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/include/uapi/linux/bpf.h |  1 +
 tools/lib/bpf/bpf.c            |  9 ++++--
 tools/lib/bpf/bpf.h            |  5 +++-
 tools/lib/bpf/libbpf.c         | 55 ++++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.h         |  3 +-
 5 files changed, 65 insertions(+), 8 deletions(-)

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
index ca0d635b1d5e..fd556bb89446 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -228,10 +228,14 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = load_attr->prog_type;
 	attr.expected_attach_type = load_attr->expected_attach_type;
-	if (attr.prog_type == BPF_PROG_TYPE_TRACING)
+	if (attr.prog_type == BPF_PROG_TYPE_TRACING) {
 		attr.attach_btf_id = load_attr->attach_btf_id;
-	else
+		if (load_attr->attach_prog_fd)
+			attr.attach_prog_fd = load_attr->attach_prog_fd;
+	} else {
 		attr.prog_ifindex = load_attr->prog_ifindex;
+		attr.kern_version = load_attr->kern_version;
+	}
 	attr.insn_cnt = (__u32)load_attr->insns_cnt;
 	attr.insns = ptr_to_u64(load_attr->insns);
 	attr.license = ptr_to_u64(load_attr->license);
@@ -245,7 +249,6 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
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
index 4baaa14b4ca0..1df0d8798a03 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -189,6 +189,7 @@ struct bpf_program {
 
 	enum bpf_attach_type expected_attach_type;
 	__u32 attach_btf_id;
+	__u32 attach_prog_fd;
 	void *func_info;
 	__u32 func_info_rec_size;
 	__u32 func_info_cnt;
@@ -3681,8 +3682,13 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
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
@@ -3697,7 +3703,6 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.line_info_cnt = prog->line_info_cnt;
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
-	load_attr.attach_btf_id = prog->attach_btf_id;
 
 retry_load:
 	log_buf = malloc(log_buf_size);
@@ -3859,6 +3864,40 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	return 0;
 }
 
+static int libbpf_get_prog_btf_id(u32 attach_prog_fd, const char *btf_name)
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
+	err = btf__find_by_name(btf, btf_name);
+	btf__free(btf);
+	if (err <= 0) {
+		pr_warn("%s is not found in prog's BTF\n", btf_name);
+		goto out;
+	}
+	pr_warn("found %s's id %d\n", btf_name, err);
+out:
+	free(info_linear);
+	return err;
+}
+
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   struct bpf_object_open_opts *opts)
@@ -3869,6 +3908,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	const char *obj_name;
 	char tmp_name[64];
 	bool relaxed_maps;
+	__u32 attach_prog_fd;
 	int err;
 
 	if (elf_version(EV_CURRENT) == EV_NONE) {
@@ -3899,6 +3939,7 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 	obj->relaxed_core_relocs = OPTS_GET(opts, relaxed_core_relocs, false);
 	relaxed_maps = OPTS_GET(opts, relaxed_maps, false);
 	pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
+	attach_prog_fd = OPTS_GET(opts, attach_prog_fd, 0);
 
 	CHECK_ERR(bpf_object__elf_init(obj), err, out);
 	CHECK_ERR(bpf_object__check_endianness(obj), err, out);
@@ -3924,6 +3965,14 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		bpf_program__set_type(prog, prog_type);
 		bpf_program__set_expected_attach_type(prog, attach_type);
 		if (prog_type == BPF_PROG_TYPE_TRACING) {
+			if (attach_prog_fd) {
+				err = libbpf_get_prog_btf_id(attach_prog_fd, prog->section_name + 6);
+				if (err > 0) {
+					btf_id = err;
+					err = 0;
+					prog->attach_prog_fd = attach_prog_fd;
+				}
+			} else
 			err = libbpf_attach_btf_id_by_name(prog->section_name,
 							   attach_type,
 							   &btf_id);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 9576aeadc421..abfda6c04d02 100644
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

