Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79362CE008
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387815AbgLCUtH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Dec 2020 15:49:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53894 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726147AbgLCUtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:49:07 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3KduWf005236
        for <netdev@vger.kernel.org>; Thu, 3 Dec 2020 12:48:25 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 355t7yhgjx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 12:48:25 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 12:48:23 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8EE0C2ECA8BF; Thu,  3 Dec 2020 12:48:21 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v6 bpf-next 12/14] libbpf: support attachment of BPF tracing programs to kernel modules
Date:   Thu, 3 Dec 2020 12:46:32 -0800
Message-ID: <20201203204634.1325171-13-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201203204634.1325171-1-andrii@kernel.org>
References: <20201203204634.1325171-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_12:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 suspectscore=29 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Teach libbpf to search for BTF types in kernel modules for tracing BPF
programs. This allows attachment of raw_tp/fentry/fexit/fmod_ret/etc BPF
program types to tracepoints and functions in kernel modules.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/bpf.c             |   5 +-
 tools/lib/bpf/libbpf.c          | 138 +++++++++++++++++++++++++-------
 tools/lib/bpf/libbpf_internal.h |   1 +
 3 files changed, 112 insertions(+), 32 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5d681ce32b37..bba48ff4c5c0 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -231,8 +231,11 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 	attr.prog_type = load_attr->prog_type;
 	attr.expected_attach_type = load_attr->expected_attach_type;
 
+	if (load_attr->attach_prog_fd)
+		attr.attach_prog_fd = load_attr->attach_prog_fd;
+	else
+		attr.attach_btf_obj_fd = load_attr->attach_btf_obj_fd;
 	attr.attach_btf_id = load_attr->attach_btf_id;
-	attr.attach_prog_fd = load_attr->attach_prog_fd;
 
 	attr.prog_ifindex = load_attr->prog_ifindex;
 	attr.kern_version = load_attr->kern_version;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 103d66e27406..912e01b946fe 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -278,6 +278,7 @@ struct bpf_program {
 	enum bpf_prog_type type;
 	enum bpf_attach_type expected_attach_type;
 	int prog_ifindex;
+	__u32 attach_btf_obj_fd;
 	__u32 attach_btf_id;
 	__u32 attach_prog_fd;
 	void *func_info;
@@ -408,6 +409,7 @@ struct module_btf {
 	struct btf *btf;
 	char *name;
 	__u32 id;
+	int fd;
 };
 
 struct bpf_object {
@@ -4766,8 +4768,7 @@ static int load_module_btfs(struct bpf_object *obj)
 		if (err) {
 			err = -errno;
 			pr_warn("failed to get BTF object #%d info: %d\n", id, err);
-			close(fd);
-			return err;
+			goto err_out;
 		}
 
 		/* ignore non-module BTFs */
@@ -4777,25 +4778,33 @@ static int load_module_btfs(struct bpf_object *obj)
 		}
 
 		btf = btf_get_from_fd(fd, obj->btf_vmlinux);
-		close(fd);
 		if (IS_ERR(btf)) {
 			pr_warn("failed to load module [%s]'s BTF object #%d: %ld\n",
 				name, id, PTR_ERR(btf));
-			return PTR_ERR(btf);
+			err = PTR_ERR(btf);
+			goto err_out;
 		}
 
 		err = btf_ensure_mem((void **)&obj->btf_modules, &obj->btf_module_cap,
 				     sizeof(*obj->btf_modules), obj->btf_module_cnt + 1);
 		if (err)
-			return err;
+			goto err_out;
 
 		mod_btf = &obj->btf_modules[obj->btf_module_cnt++];
 
 		mod_btf->btf = btf;
 		mod_btf->id = id;
+		mod_btf->fd = fd;
 		mod_btf->name = strdup(name);
-		if (!mod_btf->name)
-			return -ENOMEM;
+		if (!mod_btf->name) {
+			err = -ENOMEM;
+			goto err_out;
+		}
+		continue;
+
+err_out:
+		close(fd);
+		return err;
 	}
 
 	return 0;
@@ -6841,7 +6850,10 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.insn_cnt = insns_cnt;
 	load_attr.license = license;
 	load_attr.attach_btf_id = prog->attach_btf_id;
-	load_attr.attach_prog_fd = prog->attach_prog_fd;
+	if (prog->attach_prog_fd)
+		load_attr.attach_prog_fd = prog->attach_prog_fd;
+	else
+		load_attr.attach_btf_obj_fd = prog->attach_btf_obj_fd;
 	load_attr.attach_btf_id = prog->attach_btf_id;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_ifindex = prog->prog_ifindex;
@@ -6937,11 +6949,11 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	return ret;
 }
 
-static int libbpf_find_attach_btf_id(struct bpf_program *prog);
+static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd, int *btf_type_id);
 
 int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 {
-	int err = 0, fd, i, btf_id;
+	int err = 0, fd, i;
 
 	if (prog->obj->loaded) {
 		pr_warn("prog '%s': can't load after object was loaded\n", prog->name);
@@ -6951,10 +6963,14 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 	if ((prog->type == BPF_PROG_TYPE_TRACING ||
 	     prog->type == BPF_PROG_TYPE_LSM ||
 	     prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
-		btf_id = libbpf_find_attach_btf_id(prog);
-		if (btf_id <= 0)
-			return btf_id;
-		prog->attach_btf_id = btf_id;
+		int btf_obj_fd = 0, btf_type_id = 0;
+
+		err = libbpf_find_attach_btf_id(prog, &btf_obj_fd, &btf_type_id);
+		if (err)
+			return err;
+
+		prog->attach_btf_obj_fd = btf_obj_fd;
+		prog->attach_btf_id = btf_type_id;
 	}
 
 	if (prog->instances.nr < 0 || !prog->instances.fds) {
@@ -7467,6 +7483,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 
 	/* clean up module BTFs */
 	for (i = 0; i < obj->btf_module_cnt; i++) {
+		close(obj->btf_modules[i].fd);
 		btf__free(obj->btf_modules[i].btf);
 		free(obj->btf_modules[i].name);
 	}
@@ -8821,8 +8838,8 @@ static int find_btf_by_prefix_kind(const struct btf *btf, const char *prefix,
 	return btf__find_by_name_kind(btf, btf_type_name, kind);
 }
 
-static inline int __find_vmlinux_btf_id(struct btf *btf, const char *name,
-					enum bpf_attach_type attach_type)
+static inline int find_attach_btf_id(struct btf *btf, const char *name,
+				     enum bpf_attach_type attach_type)
 {
 	int err;
 
@@ -8838,9 +8855,6 @@ static inline int __find_vmlinux_btf_id(struct btf *btf, const char *name,
 	else
 		err = btf__find_by_name_kind(btf, name, BTF_KIND_FUNC);
 
-	if (err <= 0)
-		pr_warn("%s is not found in vmlinux BTF\n", name);
-
 	return err;
 }
 
@@ -8856,7 +8870,10 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 		return -EINVAL;
 	}
 
-	err = __find_vmlinux_btf_id(btf, name, attach_type);
+	err = find_attach_btf_id(btf, name, attach_type);
+	if (err <= 0)
+		pr_warn("%s is not found in vmlinux BTF\n", name);
+
 	btf__free(btf);
 	return err;
 }
@@ -8894,11 +8911,49 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
 	return err;
 }
 
-static int libbpf_find_attach_btf_id(struct bpf_program *prog)
+static int find_kernel_btf_id(struct bpf_object *obj, const char *attach_name,
+			      enum bpf_attach_type attach_type,
+			      int *btf_obj_fd, int *btf_type_id)
+{
+	int ret, i;
+
+	ret = find_attach_btf_id(obj->btf_vmlinux, attach_name, attach_type);
+	if (ret > 0) {
+		*btf_obj_fd = 0; /* vmlinux BTF */
+		*btf_type_id = ret;
+		return 0;
+	}
+	if (ret != -ENOENT)
+		return ret;
+
+	ret = load_module_btfs(obj);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < obj->btf_module_cnt; i++) {
+		const struct module_btf *mod = &obj->btf_modules[i];
+
+		ret = find_attach_btf_id(mod->btf, attach_name, attach_type);
+		if (ret > 0) {
+			*btf_obj_fd = mod->fd;
+			*btf_type_id = ret;
+			return 0;
+		}
+		if (ret == -ENOENT)
+			continue;
+
+		return ret;
+	}
+
+	return -ESRCH;
+}
+
+static int libbpf_find_attach_btf_id(struct bpf_program *prog, int *btf_obj_fd, int *btf_type_id)
 {
 	enum bpf_attach_type attach_type = prog->expected_attach_type;
 	__u32 attach_prog_fd = prog->attach_prog_fd;
-	const char *name = prog->sec_name;
+	const char *name = prog->sec_name, *attach_name;
+	const struct bpf_sec_def *sec = NULL;
 	int i, err;
 
 	if (!name)
@@ -8909,17 +8964,37 @@ static int libbpf_find_attach_btf_id(struct bpf_program *prog)
 			continue;
 		if (strncmp(name, section_defs[i].sec, section_defs[i].len))
 			continue;
-		if (attach_prog_fd)
-			err = libbpf_find_prog_btf_id(name + section_defs[i].len,
-						      attach_prog_fd);
-		else
-			err = __find_vmlinux_btf_id(prog->obj->btf_vmlinux,
-						    name + section_defs[i].len,
-						    attach_type);
+
+		sec = &section_defs[i];
+		break;
+	}
+
+	if (!sec) {
+		pr_warn("failed to identify BTF ID based on ELF section name '%s'\n", name);
+		return -ESRCH;
+	}
+	attach_name = name + sec->len;
+
+	/* BPF program's BTF ID */
+	if (attach_prog_fd) {
+		err = libbpf_find_prog_btf_id(attach_name, attach_prog_fd);
+		if (err < 0) {
+			pr_warn("failed to find BPF program (FD %d) BTF ID for '%s': %d\n",
+				 attach_prog_fd, attach_name, err);
+			return err;
+		}
+		*btf_obj_fd = 0;
+		*btf_type_id = err;
+		return 0;
+	}
+
+	/* kernel/module BTF ID */
+	err = find_kernel_btf_id(prog->obj, attach_name, attach_type, btf_obj_fd, btf_type_id);
+	if (err) {
+		pr_warn("failed to find kernel BTF type ID of '%s': %d\n", attach_name, err);
 		return err;
 	}
-	pr_warn("failed to identify btf_id based on ELF section name '%s'\n", name);
-	return -ESRCH;
+	return 0;
 }
 
 int libbpf_attach_type_by_name(const char *name,
@@ -10808,6 +10883,7 @@ int bpf_program__set_attach_target(struct bpf_program *prog,
 		return btf_id;
 
 	prog->attach_btf_id = btf_id;
+	prog->attach_btf_obj_fd = 0;
 	prog->attach_prog_fd = attach_prog_fd;
 	return 0;
 }
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 681073a67ae3..969d0ac592ba 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -160,6 +160,7 @@ struct bpf_prog_load_params {
 	const char *license;
 	__u32 kern_version;
 	__u32 attach_prog_fd;
+	__u32 attach_btf_obj_fd;
 	__u32 attach_btf_id;
 	__u32 prog_ifindex;
 	__u32 prog_btf_fd;
-- 
2.24.1

