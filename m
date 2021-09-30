Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BEC41D36B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348382AbhI3GcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348167AbhI3Gbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:31:51 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE4AC06176A;
        Wed, 29 Sep 2021 23:30:08 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y5so3280186pll.3;
        Wed, 29 Sep 2021 23:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B3v2H2uYA3eLzhH8S+ZTyml+aYYkGjEf0OmkZgTsTW8=;
        b=l/4NBmvk36CfVWeeK3Mt31tRovONDsfHUfJOoKWdaQj8P0fRckmzYa9hwekmT0G4uQ
         pGc+/pldUjxlKJImNnkmzcuFDnVeE9KDvBvKI8Bw1RM6hcNSbofeHiqbrCLc9m3NSgvO
         mXc0X/kCfZuvRTQ6H0jOvoZsgvSFL68SVqYdbk3CGaj8+PQUFda0WLvXNjKAhmydCbBj
         PGCy7tSVillZhYHvyp1cmFXZjyf9tLH8+OYgg7ggy1KZ35laGgtL9q3q1LytwN03I8QD
         d+I/IMG81q9WyeVK7ZEwR3Au3FWKnN/OrXZjUN7mC81OBBlPStqw1OwzuCm0ZXBiarbf
         1RTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B3v2H2uYA3eLzhH8S+ZTyml+aYYkGjEf0OmkZgTsTW8=;
        b=R5eZkqPCD+g3stEG/lojrSq/59eHrB03WHKx4Iirsotf4bFs9ljeXz9tsWagaFxG+j
         8NhcOGN94f4IlFpOp0Fgrc1zChgDZzVvL9neZIp+0U0C48adGFTR7qMyjftaMbWlgmt4
         wMpYP4+HvjXaWh8mD2NC0xZBbJdtrY1ZBk0oqff8Ex9y5wn2JU9ALo0xajlbALnIUlZJ
         n/nmDlT1+N5CL0cg2ldJmhnARRt9XUHB2s1RFh5LSI/49gA2vkRzFzyTdsVRLEFQEwcZ
         FPlYtyx6nAzF1T3tBdFJ5gezEbkuHHYV6t6LxRYYSxUL68S1gOUDW+8Ai2wFfnWgE+/O
         hjew==
X-Gm-Message-State: AOAM531VjGNyozT0R34vcYAkTOt7lAm5WxXf6syKYzWThioRs+Q9RKKM
        82lj0NIYGqJm7llVp3pCHMnxdy8Te68=
X-Google-Smtp-Source: ABdhPJyrzmtrH2npQQa2EDw7wY/K4X9ONEdddywXN/2xC4sIy9Yb4akc0tqYHkKS55nUngB60++1ag==
X-Received: by 2002:a17:90a:428e:: with SMTP id p14mr11323137pjg.229.1632983407904;
        Wed, 29 Sep 2021 23:30:07 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id o11sm3003661pjp.0.2021.09.29.23.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 23:30:07 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 6/9] libbpf: Support kernel module function calls
Date:   Thu, 30 Sep 2021 11:59:45 +0530
Message-Id: <20210930062948.1843919-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930062948.1843919-1-memxor@gmail.com>
References: <20210930062948.1843919-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10731; h=from:subject; bh=LX6KKoKfZ+NuvynrlP0+6SKpVgHI+L2S4MpYGJ9AtPg=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhVVlBpXbwCGtWuYcqYAk9OGh58Y4ObwNfQtJN7e0s AqsIl6WJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVVZQQAKCRBM4MiGSL8RytmwD/ 93s2EOzTWh2zq9OwvkbYl/x2COae3gUsTw8kbZhoko2nyuK3lGcxxB1HY5RcOmPdDmzOoEEYi6Cr5P rCN4IGlC+x9IHX8M309cplh5tUZgSbRVmHSpczcWJcIvfPfxPHd2SD6sE5kj53v8SmcKMiIlcpWM/p 2GYhnzYBQyM31tOt4UMQonFYTgD5oZvl87MMiIU4clBi2yyjQsxoLmUaJxaQhdd+2oGFbaSG2KcLuD 551RpWBjytqWju+lrtzGi38QqpTNNm6maeE0tGsVpU9TRGRGG35gOVZnvrkZNmTXLUzzwzVjNsfgIt UzyF8WxVbG9h5Gmj5LAecAZ2MdMP00nhzrv2mceFi5d6fOuqCbuURLa+CsDz0phhvYTbVIjEaffYOJ N6LsNgtRP4ycle2KbNBw87gzcQ0k6/qgjWbC2DjyNZItjskF9CQ23Xpq/BKerKssM4eGM8Uk2WqZ7a YoJNmeVGnYHbNrbhMWlvSHgxVR1vlCKhWPG6dZdlNbY7sHZYt4Xb0yGEmrxqQDyHWDnWr/OPUurFMq ykYwdIUeD7Rsvf+ndLSXEb4uZTOzMLv1sDjugDN3l3D9KDxQhEFrLKA7mc+qtly4fnmhgi2X2g97Q7 JRHwxLKbnhgWguMH0e5enISBjETN8Cunfgx1SWZTYePeFmere6kcemn+Q81Q==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds libbpf support for kernel module function call support.
The fd_array parameter is used during BPF program load is used to pass
module BTFs referenced by the program. insn->off is set to index into
this array, but starts from 1, because insn->off as 0 is reserved for
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
 tools/lib/bpf/btf.c             | 19 ++++++--
 tools/lib/bpf/libbpf.c          | 80 +++++++++++++++++++++++----------
 tools/lib/bpf/libbpf_internal.h |  3 ++
 4 files changed, 76 insertions(+), 27 deletions(-)

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
index 6ad63e4d418a..f1d872b3fbf4 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -695,15 +695,16 @@ __s32 btf__find_by_name(const struct btf *btf, const char *type_name)
 	return libbpf_err(-ENOENT);
 }
 
-__s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
-			     __u32 kind)
+static __s32 __btf__find_by_name_kind(const struct btf *btf,
+				      const char *type_name, __u32 kind,
+				      bool own)
 {
 	__u32 i, nr_types = btf__get_nr_types(btf);
 
 	if (kind == BTF_KIND_UNKN || !strcmp(type_name, "void"))
 		return 0;
 
-	for (i = 1; i <= nr_types; i++) {
+	for (i = own ? btf->start_id : 1; i <= nr_types; i++) {
 		const struct btf_type *t = btf__type_by_id(btf, i);
 		const char *name;
 
@@ -717,6 +718,18 @@ __s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
 	return libbpf_err(-ENOENT);
 }
 
+__s32 btf__find_by_name_kind_own(const struct btf *btf, const char *type_name,
+				 __u32 kind)
+{
+	return __btf__find_by_name_kind(btf, type_name, kind, true);
+}
+
+__s32 btf__find_by_name_kind(const struct btf *btf, const char *type_name,
+			     __u32 kind)
+{
+	return __btf__find_by_name_kind(btf, type_name, kind, false);
+}
+
 static bool btf_is_modifiable(const struct btf *btf)
 {
 	return (void *)btf->hdr != btf->raw_data;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7544d7d09160..8943a56f4fcb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -443,6 +443,11 @@ struct extern_desc {
 
 			/* local btf_id of the ksym extern's type. */
 			__u32 type_id;
+			/* offset to be patched in for insn->off, this is 0 for
+			 * vmlinux BTF, and BTF fd index in obj->fd_array for
+			 * module BTF
+			 */
+			__s16 offset;
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
@@ -1168,6 +1178,9 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->kern_version = get_kernel_version();
 	obj->loaded = false;
 
+	/* We cannot use index 0 for module BTF fds */
+	obj->fd_array_cnt = 1;
+
 	INIT_LIST_HEAD(&obj->list);
 	list_add(&obj->list, &bpf_objects_list);
 	return obj;
@@ -5383,6 +5396,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
 			insn[0].imm = ext->ksym.kernel_btf_id;
+			insn[0].off = ext->ksym.offset;
 			break;
 		case RELO_SUBPROG_ADDR:
 			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
@@ -6212,6 +6226,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	}
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
+	load_attr.fd_array = prog->obj->fd_array;
 
 	/* adjust load_attr if sec_def provides custom preload callback */
 	if (prog->sec_def && prog->sec_def->preload_fn) {
@@ -6728,13 +6743,14 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
 
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
@@ -6743,10 +6759,10 @@ static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
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
@@ -6755,7 +6771,7 @@ static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
 		return -ESRCH;
 
 	*res_btf = btf;
-	*res_btf_fd = btf_fd;
+	*res_mod_btf = mod_btf;
 	return id;
 }
 
@@ -6764,11 +6780,12 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
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
@@ -6803,7 +6820,7 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
 	}
 
 	ext->is_set = true;
-	ext->ksym.kernel_btf_obj_fd = btf_fd;
+	ext->ksym.kernel_btf_obj_fd = mod_btf ? mod_btf->fd : 0;
 	ext->ksym.kernel_btf_id = id;
 	pr_debug("extern (var ksym) '%s': resolved to [%d] %s %s\n",
 		 ext->name, id, btf_kind_str(targ_var), targ_var_name);
@@ -6815,40 +6832,52 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
 						struct extern_desc *ext)
 {
 	int local_func_proto_id, kfunc_proto_id, kfunc_id;
+	struct module_btf *mod_btf = NULL;
 	const struct btf_type *kern_func;
-	struct btf *kern_btf = NULL;
-	int ret, kern_btf_fd = 0;
+	struct btf *btf = NULL;
+	int ret;
 
 	local_func_proto_id = ext->ksym.type_id;
 
-	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC,
-				    &kern_btf, &kern_btf_fd);
+	kfunc_id = find_ksym_btf_id(obj, ext->name, BTF_KIND_FUNC, &btf, &mod_btf);
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
-	kern_func = btf__type_by_id(kern_btf, kfunc_id);
+	kern_func = btf__type_by_id(btf, kfunc_id);
 	kfunc_proto_id = kern_func->type;
 
 	ret = bpf_core_types_are_compat(obj->btf, local_func_proto_id,
-					kern_btf, kfunc_proto_id);
+					btf, kfunc_proto_id);
 	if (ret <= 0) {
 		pr_warn("extern (func ksym) '%s': func_proto [%d] incompatible with kernel [%d]\n",
 			ext->name, local_func_proto_id, kfunc_proto_id);
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
+	ext->ksym.offset = mod_btf ? mod_btf->fd_array_idx : 0;
 	pr_debug("extern (func ksym) '%s': resolved to kernel [%d]\n",
 		 ext->name, kfunc_id);
 
@@ -7007,6 +7036,9 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
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

