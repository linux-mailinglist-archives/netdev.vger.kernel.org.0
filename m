Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EA041F915
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 03:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhJBBUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 21:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbhJBBUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 21:20:04 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1CFC061775;
        Fri,  1 Oct 2021 18:18:19 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id c4so7363845pls.6;
        Fri, 01 Oct 2021 18:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S+yMOzJeNd9EOH/R2/fMHBPucZaA8ZRZbd+09J4N8VE=;
        b=WvBLZEPfdFaAj7cMq96ed5RthIFvid++5LckwL5EFzMXzquUS75QOkfgsg+6X7Wszx
         +/UP/IkbwSUgKnBWK2SDJ7kLOLeNcVnwDG6uMhXKnUYoAVo25T0wE3j8XrJg5r7D5WQ2
         Z2mheIl14ZRavGcML9Ho3s6J+qEeAgoPttnKXzQP1TK4N6q/UDitOi04zvxWOxrLmDnr
         51ZI5IiGQj3Pb0w4o3v2i/J2/dpyppYIDsVcQX4VBDKf1bEipo67wpStk4eJ/dcw+kjv
         tO7NlowBtgUhfy0t03h0AGxOSdx8BYmkHPMzB9EVDLpf1i7PnaV8IQvqQPTS3DuNEfEt
         FFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S+yMOzJeNd9EOH/R2/fMHBPucZaA8ZRZbd+09J4N8VE=;
        b=iV2qqWPNJhGt7R8wUDEzBJmyh4sqpB0hAG0FMrsuHvJAC9uDc9nq4wPaUR4af9U7Zs
         8wBaPPHsr/DZ82sVf9zWfO5nJZJ9Fjez2cVL/EJ9JoHHFx9QILef8DucjzKGCg4aRYi0
         QlrTvjq6OI7f4GqVu+lDDBuy919Gr4WvhQIVl8GxduGgpjbXBOgKndRyeuZkIjI24s3J
         tlLLQgyMA8wjfmcDo/2ugDW8umA7V2jHVrqY5LijSvkbfl5ajcea3t9TmTiVw2b+H/3g
         lTXusxBtiOWCTYzUGGnjNmSBPZNyObQLhXigLwoEgOw+peqfRRM/KD4uzIL2ivMBXQAP
         CUgQ==
X-Gm-Message-State: AOAM530EV7ZpXM7A2lQMqD5uKvQ6fffujC3XAl+bwdwp7SdruKDYnoxv
        qrZTBCyyGnjIF+Lep+ixNSiWfdAZkck=
X-Google-Smtp-Source: ABdhPJzD3isGAAyN4VB4YyRVGWjj+41sUIBrqOzlueT5wkRA5UeAY/zdTkQ9AuRICpLKv8AtUEwyjg==
X-Received: by 2002:a17:90a:7348:: with SMTP id j8mr16421080pjs.104.1633137498466;
        Fri, 01 Oct 2021 18:18:18 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id r8sm5547615pfg.91.2021.10.01.18.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:18:18 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v7 6/9] libbpf: Support kernel module function calls
Date:   Sat,  2 Oct 2021 06:47:54 +0530
Message-Id: <20211002011757.311265-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211002011757.311265-1-memxor@gmail.com>
References: <20211002011757.311265-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10216; h=from:subject; bh=CZuj5oP0FWyXpynhoEIkHiS0/xVnkM3MCwpAVI5Bsag=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhV7MRsbC4Gf5uzmSMhS+zly/f1Lwmvre34loP0EKa kEeh0DGJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVezEQAKCRBM4MiGSL8RyoSjD/ 4kzmFTsb863CiMCmBs4YeEQygQ36HR2LDsyVGTAsEgCsM6kR8giA2eZR3dv1fncxNJogxtDo/0uqMX tue0Sf/YmdY4ugZFEa3K8ZKaTlufP5BN24BNRwgullhJk6xYA8Sus0jgzX/XEOSRpQGbfTKZEBogJN LefwmbfmkeXPnGL8e+VscmaUPXi9lkF79eTdBV61CDtGgnMxa/BMnjU42uP7fq/k6tWaug8gk13vTX ztTSbzIExA9888rvq8Pg9sz1VA50iGQyRSkbgJ0xHKko6PdzCq6FxAT6nd7SkstmdFNjjRpwlhIWCP GBjCaoZSTasztxtUZ74kJdxnTI3iZ+mmM8UkrDPLnm4QZQSmaVvdsc6nT6zlJwSFeRT8E4HWKx7pom LAZeFSJu+EcT3GKoVW37duYX/2pgJa5DT6quRu2GslRnEmjBcrX4otFJk6byGZtsEU8YJsLT/4Uwgj kH2BbXOt9yegynfooRD/IkjxCLFKBaOw2hOeFpoiJfb4LhrFeJwGMe91Dh1lUM4LE2Qd2dy+h4PFoM 7/Ib/amkwYJZgUqrLy0taDZPYMblCLDUvLAgVw4iMk6L8xnALRxq8aIZA61144BgahOxUxWMhB97CQ Y7ZXGNBbkDQbsWy1USPMxZRf31Egkpbuobf+mFEd8CAzKsfPXZZvf5DUXgwA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds libbpf support for kernel module function call support.
The fd_array parameter is used during BPF program load to pass module
BTFs referenced by the program. insn->off is set to index into this
array, but starts from 1, because insn->off as 0 is reserved for
btf_vmlinux.

We try to use existing insn->off for a module, since the kernel limits
the maximum distinct module BTFs for kfuncs to 256, and also because
index must never exceed the maximum allowed value that can fit in
insn->off (INT16_MAX). In the future, if kernel interprets signed offset
as unsigned for kfunc calls, this limit can be increased to UINT16_MAX.

Also introduce a btf__find_by_name_kind_own helper to start searching
from module BTF's start id when we know that the BTF ID is not present
in vmlinux BTF (in find_ksym_btf_id).

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf.c             |  1 +
 tools/lib/bpf/btf.c             | 18 ++++++--
 tools/lib/bpf/libbpf.c          | 74 +++++++++++++++++++++++----------
 tools/lib/bpf/libbpf_internal.h |  3 ++
 4 files changed, 72 insertions(+), 24 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 2401fad090c5..7d1741ceaa32 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -264,6 +264,7 @@ int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr)
 	attr.line_info_rec_size = load_attr->line_info_rec_size;
 	attr.line_info_cnt = load_attr->line_info_cnt;
 	attr.line_info = ptr_to_u64(load_attr->line_info);
+	attr.fd_array = ptr_to_u64(load_attr->fd_array);
 
 	if (load_attr->name)
 		memcpy(attr.prog_name, load_attr->name,
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 6ad63e4d418a..7774f99afa6e 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -695,15 +695,15 @@ __s32 btf__find_by_name(const struct btf *btf, const char *type_name)
 	return libbpf_err(-ENOENT);
 }
 
-__s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
-			     __u32 kind)
+static __s32 btf_find_by_name_kind(const struct btf *btf, int start_id,
+				   const char *type_name, __u32 kind)
 {
 	__u32 i, nr_types = btf__get_nr_types(btf);
 
 	if (kind == BTF_KIND_UNKN || !strcmp(type_name, "void"))
 		return 0;
 
-	for (i = 1; i <= nr_types; i++) {
+	for (i = start_id; i <= nr_types; i++) {
 		const struct btf_type *t = btf__type_by_id(btf, i);
 		const char *name;
 
@@ -717,6 +717,18 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
 	return libbpf_err(-ENOENT);
 }
 
+__s32 btf__find_by_name_kind_own(const struct btf *btf, const char *type_name,
+				 __u32 kind)
+{
+	return btf_find_by_name_kind(btf, btf->start_id, type_name, kind);
+}
+
+__s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
+			     __u32 kind)
+{
+	return btf_find_by_name_kind(btf, 1, type_name, kind);
+}
+
 static bool btf_is_modifiable(const struct btf *btf)
 {
 	return (void *)btf->hdr != btf->raw_data;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e23f1b6b9402..ea1c51dbc0f3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -443,6 +443,11 @@ struct extern_desc {
 
 			/* local btf_id of the ksym extern's type. */
 			__u32 type_id;
+			/* BTF fd index to be patched in for insn->off, this is
+			 * 0 for vmlinux BTF, index in obj->fd_array for module
+			 * BTF
+			 */
+			__s16 btf_fd_idx;
 		} ksym;
 	};
 };
@@ -454,6 +459,7 @@ struct module_btf {
 	char *name;
 	__u32 id;
 	int fd;
+	int fd_array_idx;
 };
 
 struct bpf_object {
@@ -539,6 +545,10 @@ struct bpf_object {
 	void *priv;
 	bpf_object_clear_priv_t clear_priv;
 
+	int *fd_array;
+	size_t fd_array_cap;
+	size_t fd_array_cnt;
+
 	char path[];
 };
 #define obj_elf_valid(o)	((o)->efile.elf)
@@ -5407,6 +5417,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
 			insn[0].imm = ext->ksym.kernel_btf_id;
+			insn[0].off = ext->ksym.btf_fd_idx;
 			break;
 		case RELO_SUBPROG_ADDR:
 			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
@@ -6236,6 +6247,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	}
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
+	load_attr.fd_array = prog->obj->fd_array;
 
 	/* adjust load_attr if sec_def provides custom preload callback */
 	if (prog->sec_def && prog->sec_def->preload_fn) {
@@ -6752,13 +6764,14 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
 
 static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
 			    __u16 kind, struct btf **res_btf,
-			    int *res_btf_fd)
+			    struct module_btf **res_mod_btf)
 {
-	int i, id, btf_fd, err;
+	struct module_btf *mod_btf;
 	struct btf *btf;
+	int i, id, err;
 
 	btf = obj->btf_vmlinux;
-	btf_fd = 0;
+	mod_btf = NULL;
 	id = btf__find_by_name_kind(btf, ksym_name, kind);
 
 	if (id == -ENOENT) {
@@ -6767,10 +6780,10 @@ static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
 			return err;
 
 		for (i = 0; i < obj->btf_module_cnt; i++) {
-			btf = obj->btf_modules[i].btf;
-			/* we assume module BTF FD is always >0 */
-			btf_fd = obj->btf_modules[i].fd;
-			id = btf__find_by_name_kind(btf, ksym_name, kind);
+			/* we assume module_btf's BTF FD is always >0 */
+			mod_btf = &obj->btf_modules[i];
+			btf = mod_btf->btf;
+			id = btf__find_by_name_kind_own(btf, ksym_name, kind);
 			if (id != -ENOENT)
 				break;
 		}
@@ -6779,7 +6792,7 @@ static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
 		return -ESRCH;
 
 	*res_btf = btf;
-	*res_btf_fd = btf_fd;
+	*res_mod_btf = mod_btf;
 	return id;
 }
 
@@ -6788,11 +6801,12 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
 {
 	const struct btf_type *targ_var, *targ_type;
 	__u32 targ_type_id, local_type_id;
+	struct module_btf *mod_btf = NULL;
 	const char *targ_var_name;
-	int id, btf_fd = 0, err;
 	struct btf *btf = NULL;
+	int id, err;
 
-	id = find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, &btf, &btf_fd);
+	id = find_ksym_btf_id(obj, ext->name, BTF_KIND_VAR, &btf, &mod_btf);
 	if (id == -ESRCH && ext->is_weak) {
 		return 0;
 	} else if (id < 0) {
@@ -6827,7 +6841,7 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
 	}
 
 	ext->is_set = true;
-	ext->ksym.kernel_btf_obj_fd = btf_fd;
+	ext->ksym.kernel_btf_obj_fd = mod_btf ? mod_btf->fd : 0;
 	ext->ksym.kernel_btf_id = id;
 	pr_debug("extern (var ksym) '%s': resolved to [%d] %s %s\n",
 		 ext->name, id, btf_kind_str(targ_var), targ_var_name);
@@ -6839,26 +6853,20 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 						struct extern_desc *ext)
 {
 	int local_func_proto_id, kfunc_proto_id, kfunc_id;
+	struct module_btf *mod_btf = NULL;
 	const struct btf_type *kern_func;
 	struct btf *kern_btf = NULL;
-	int ret, kern_btf_fd = 0;
+	int ret;
 
 	local_func_proto_id = ext->ksym.type_id;
 
-	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
-				    &kern_btf, &kern_btf_fd);
+	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC, &kern_btf, &mod_btf);
 	if (kfunc_id < 0) {
 		pr_warn("extern (func ksym) '%s': not found in kernel BTF\n",
 			ext->name);
 		return kfunc_id;
 	}
 
-	if (kern_btf != obj->btf_vmlinux) {
-		pr_warn("extern (func ksym) '%s': function in kernel module is not supported\n",
-			ext->name);
-		return -ENOTSUP;
-	}
-
 	kern_func = btf__type_by_id(kern_btf, kfunc_id);
 	kfunc_proto_id = kern_func->type;
 
@@ -6870,9 +6878,30 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 		return -EINVAL;
 	}
 
+	/* set index for module BTF fd in fd_array, if unset */
+	if (mod_btf && !mod_btf->fd_array_idx) {
+		/* insn->off is s16 */
+		if (obj->fd_array_cnt == INT16_MAX) {
+			pr_warn("extern (func ksym) '%s': module BTF fd index %d too big to fit in bpf_insn offset\n",
+				ext->name, mod_btf->fd_array_idx);
+			return -E2BIG;
+		}
+		/* Cannot use index 0 for module BTF fd */
+		if (!obj->fd_array_cnt)
+			obj->fd_array_cnt = 1;
+
+		ret = libbpf_ensure_mem((void **)&obj->fd_array, &obj->fd_array_cap, sizeof(int),
+					obj->fd_array_cnt + 1);
+		if (ret)
+			return ret;
+		mod_btf->fd_array_idx = obj->fd_array_cnt;
+		/* we assume module BTF FD is always >0 */
+		obj->fd_array[obj->fd_array_cnt++] = mod_btf->fd;
+	}
+
 	ext->is_set = true;
-	ext->ksym.kernel_btf_obj_fd = kern_btf_fd;
 	ext->ksym.kernel_btf_id = kfunc_id;
+	ext->ksym.btf_fd_idx = mod_btf ? mod_btf->fd_array_idx : 0;
 	pr_debug("extern (func ksym) '%s': resolved to kernel [%d]\n",
 		 ext->name, kfunc_id);
 
@@ -7031,6 +7060,9 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 			err = bpf_gen__finish(obj->gen_loader);
 	}
 
+	/* clean up fd_array */
+	zfree(&obj->fd_array);
+
 	/* clean up module BTFs */
 	for (i = 0; i < obj->btf_module_cnt; i++) {
 		close(obj->btf_modules[i].fd);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index ec79400517d4..f7fd3944d46d 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -298,6 +298,7 @@ struct bpf_prog_load_params {
 	__u32 log_level;
 	char *log_buf;
 	size_t log_buf_sz;
+	int *fd_array;
 };
 
 int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
@@ -408,6 +409,8 @@ int btf_type_visit_type_ids(struct btf_type *t, type_id_visit_fn visit, void *ct
 int btf_type_visit_str_offs(struct btf_type *t, str_off_visit_fn visit, void *ctx);
 int btf_ext_visit_type_ids(struct btf_ext *btf_ext, type_id_visit_fn visit, void *ctx);
 int btf_ext_visit_str_offs(struct btf_ext *btf_ext, str_off_visit_fn visit, void *ctx);
+__s32 btf__find_by_name_kind_own(const struct btf *btf, const char *type_name,
+				 __u32 kind);
 
 extern enum libbpf_strict_mode libbpf_mode;
 
-- 
2.33.0

