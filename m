Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FA64196F8
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbhI0PCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbhI0PBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:01:50 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF174C06176F;
        Mon, 27 Sep 2021 08:00:04 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y5so9525938pll.3;
        Mon, 27 Sep 2021 08:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LULoxn4nL4Q36b5bUqKCWXkoihb4lldZkQC1RkIgXd8=;
        b=KDq7YwKTDV6ZZfzRm9VkrYmrP8I4virQ7pppMG1A1b9sDFYJIfUarG7sd1tQEnHH6A
         qqmEi1q4qIjPRToyA8XhcDXDldDJctJF7SuWcjtjFdOOQ2/QQHzYaxTfyU1V0SUU7BEQ
         EkWY3Xy1IByFJTDWJFErOnegYsFoLZSmjidY+5YozMWTI3O1exirSCmfqIl+s+nqWeTj
         uCkpMvcU4PLmrkhsNn1USBLQze8+ZM74WZUc/Psl18OT20rPc9wJfXny/r3ake5qnaGD
         Sj4PdogkCufzhXcVVdhF7eS0pAfLBPZHGebk86+0XAYUzQBIhPOV4Odtg4R09YgpaaKt
         0luA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LULoxn4nL4Q36b5bUqKCWXkoihb4lldZkQC1RkIgXd8=;
        b=AVcWVfOfvcz3WIP0p2fO9OqfPsT1rkuNF5fqZa817WS0rq8kScBwr30LSOrbcOjz5y
         c42CT7kwZnCZMhXyt25WCn+XM1I0Dl89qxAoe4AENbmqJfXq6QxpXd+hZHs4uzY7eJWs
         qGXMWpd0wqVO0sD5lPcQZP92BqBMQ8hf/Chclh0otwN0NXazEp8iWPYrHzC6oeJD8YY/
         I24GiART2pQvVEXnpaB/N4Kkv2OUKdRy9GVPet6TJ8VbV3g/eY+nTPvbqGIBFSnpeDtk
         NXv53WI+ISuC8ltNh/iRB7voul1581JJUw/6V9RuqMzMYLEc6XqJTOOmQnPUOFog4eDh
         sQcQ==
X-Gm-Message-State: AOAM530K4S8kRVSQTtZLBH+bx8UrGYOLr/t3y3IcWUUCr9W0NQ9tcfFA
        OHyjcakYPhUkkLu+qbputg3/XtvS3X4=
X-Google-Smtp-Source: ABdhPJyzbmTrOEtLHO7kpsWWnkXfma0xhw60TT1WYFi6OBf0IUJxxacsFeFUWqwp5jh0YSjg1Ug1OA==
X-Received: by 2002:a17:90a:9404:: with SMTP id r4mr425485pjo.240.1632754804155;
        Mon, 27 Sep 2021 08:00:04 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id v7sm16028016pjk.37.2021.09.27.08.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:00:03 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 06/12] libbpf: Support kernel module function calls
Date:   Mon, 27 Sep 2021 20:29:35 +0530
Message-Id: <20210927145941.1383001-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927145941.1383001-1-memxor@gmail.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10698; h=from:subject; bh=LkCWHWBbKelQhH0cNbXGEJiHjG3OhDjbAgl0mOtIX4w=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhUdxOWxo47GVMSoMjTwONEK9cWhmLs+/1REW2RdAQ dOF1ASOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVHcTgAKCRBM4MiGSL8RyhCXD/ 9emdkktcc6AWXzv/oOwOeUwdOwuuqGLqcDPYn3jcpUrXFWABrBy9LDuNjaFFbNRwS3b34pWggeCi1L V6/5m6IPhJ5+boFyhgP6icO7joVGvI+3WaJsCjY9K4z2tCJYdLJpsgfwTe0X2FGGLcYj9W8BxDC18E YTas0wjp0pgVmOqrbfYmwRH1ffSFUpMX3puJm2jdntv/SztWSi2wZqbtH2ELnNBZflCYYD57d7qS5T dL76AOC4Yq4SzGrjOMz8TPcVObN867qL9EtiruzLz956AHcBGDIq0CcBWiEYgQjQ/3MRwEs7RU5bgD ST12bFeRBwMPUWTluvZvhavvmgVQojXGOmSsvQ3McNyQ5IOR+WYVzLMamXughmHUDByLWpmaMznk9B Qx/A97KcUeg6dgcp7IEdybJNsGrpDJLkUYThJD/7jbnhJjEjr7Vddf1EldfjOsMpZ13aTPccNgKo9v XmW0BqnTuaOqI4ks+yapzxxnoz1Tt1ZssctmLti2IvF+OHy5C7VZk51w97wb1164wP0ybXZOwbt+ya Dfl4zoter3DqcP3vf369FRvOyZ9byyrLUq2QXI19ulpr++cdEgP51CFNxln12XptYK7OUwpG/+4o2M lany1v+Nbl25UK2CoATdrlV5qMk6F7besvM+CD9SRXx6jIetOTrx01WmwHoQ==
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
index ef5db34bf913..0f4d203f926e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -420,6 +420,11 @@ struct extern_desc {
 
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
@@ -431,6 +436,7 @@ struct module_btf {
 	char *name;
 	__u32 id;
 	int fd;
+	int fd_array_idx;
 };
 
 struct bpf_object {
@@ -516,6 +522,10 @@ struct bpf_object {
 	void *priv;
 	bpf_object_clear_priv_t clear_priv;
 
+	int *fd_array;
+	size_t fd_array_cap;
+	size_t fd_array_cnt;
+
 	char path[];
 };
 #define obj_elf_valid(o)	((o)->efile.elf)
@@ -1145,6 +1155,9 @@ static struct bpf_object *bpf_object__new(const char *path,
 	obj->kern_version = get_kernel_version();
 	obj->loaded = false;
 
+	/* We cannot use index 0 for module BTF fds */
+	obj->fd_array_cnt = 1;
+
 	INIT_LIST_HEAD(&obj->list);
 	list_add(&obj->list, &bpf_objects_list);
 	return obj;
@@ -5357,6 +5370,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 			ext = &obj->externs[relo->sym_off];
 			insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
 			insn[0].imm = ext->ksym.kernel_btf_id;
+			insn[0].off = ext->ksym.offset;
 			break;
 		case RELO_SUBPROG_ADDR:
 			if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
@@ -6151,6 +6165,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	}
 	load_attr.log_level = prog->log_level;
 	load_attr.prog_flags = prog->prog_flags;
+	load_attr.fd_array = prog->obj->fd_array;
 
 	if (prog->obj->gen_loader) {
 		bpf_gen__prog_load(prog->obj->gen_loader, &load_attr,
@@ -6661,13 +6676,14 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
 
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
@@ -6676,10 +6692,10 @@ static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
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
@@ -6688,7 +6704,7 @@ static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
 		return -ESRCH;
 
 	*res_btf = btf;
-	*res_btf_fd = btf_fd;
+	*res_mod_btf = mod_btf;
 	return id;
 }
 
@@ -6697,11 +6713,12 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
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
@@ -6736,7 +6753,7 @@ static int bpf_object__resolve_ksym_var_btf_id(struct bpf_object *obj,
 	}
 
 	ext->is_set = true;
-	ext->ksym.kernel_btf_obj_fd = btf_fd;
+	ext->ksym.kernel_btf_obj_fd = mod_btf ? mod_btf->fd : 0;
 	ext->ksym.kernel_btf_id = id;
 	pr_debug("extern (var ksym) '%s': resolved to [%d] %s %s\n",
 		 ext->name, id, btf_kind_str(targ_var), targ_var_name);
@@ -6748,40 +6765,52 @@ static int bpf_object__resolve_ksym_func_btf_id(struct bpf_object *obj,
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
 
@@ -6941,6 +6970,9 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 			err = bpf_gen__finish(obj->gen_loader);
 	}
 
+	/* clean up fd_array */
+	zfree(&obj->fd_array);
+
 	/* clean up module BTFs */
 	for (i = 0; i < obj->btf_module_cnt; i++) {
 		close(obj->btf_modules[i].fd);
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index ceb0c98979bc..1969d0ce35cf 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -291,6 +291,7 @@ struct bpf_prog_load_params {
 	__u32 log_level;
 	char *log_buf;
 	size_t log_buf_sz;
+	int *fd_array;
 };
 
 int libbpf__bpf_prog_load(const struct bpf_prog_load_params *load_attr);
@@ -401,6 +402,8 @@ int btf_type_visit_type_ids(struct btf_type *t, type_id_visit_fn visit, void *ct
 int btf_type_visit_str_offs(struct btf_type *t, str_off_visit_fn visit, void *ctx);
 int btf_ext_visit_type_ids(struct btf_ext *btf_ext, type_id_visit_fn visit, void *ctx);
 int btf_ext_visit_str_offs(struct btf_ext *btf_ext, str_off_visit_fn visit, void *ctx);
+__s32 btf__find_by_name_kind_own(const struct btf *btf, const char *type_name,
+				 __u32 kind);
 
 extern enum libbpf_strict_mode libbpf_mode;
 
-- 
2.33.0

