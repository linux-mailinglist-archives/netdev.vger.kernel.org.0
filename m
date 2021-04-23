Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49453689D8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240089AbhDWA1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240162AbhDWA1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:27:42 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E7DC06138C;
        Thu, 22 Apr 2021 17:27:06 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id lr7so6070620pjb.2;
        Thu, 22 Apr 2021 17:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zJ/FLQpUCf2nLMd7Q6hp42O9p8TA+6qeniT0GG9ATIE=;
        b=tr2rMlTyoPWM04cGZtiUjpi+svP+kgXX6GvzCdobipEVl7zdkKuDZLtQhe4JC8LYg5
         0BBW/k7z+XBAFRb8cNCbjrAiqGOxe0jc+jhRw7JB+iKPyFV3JilOtYoDnpKShfLvjiDU
         FriCyWOimAKvacov8DXIx8KObbOfobr3J2GJeTmjEHSgWwGYMUmu8W4F0JRj5Rqzbr7S
         NdURjhLQh44kPOCZTmFbCRr1dVdlobYP6j7sAAiF2vXwaAedjRs7/RW5QcUBm+ij9FDq
         ROAq0EQ+KM73ohLS7nSN+FQYW0TXKfAJBhKc5krn8kXAoDL1wjdRG6oQGR5jvG9zZY33
         CUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zJ/FLQpUCf2nLMd7Q6hp42O9p8TA+6qeniT0GG9ATIE=;
        b=R7kNEhypGjqXgU3at+BQ5yOf9iHp+JQoeQ1Z/ZHOqX6nHJdy4vYhwy0US8KfeHmSIf
         uF3J7WEyJFuKj71z9uWms9wxEE7vZO4NdNLa1O9ccGlPCl+ZO+cvZgn6KUnL6BlF7BUG
         NK+FSBLt965bRP7ISf92tY97YWjHRtv9m14fJAhDYU67eFBYoo6jprQoe3+6dGnSPMao
         SczS3xv7wXJ3KhIbcEJe+qKwQmqmsbGUbPvqhtyiuK6ylel43e4nIIVE/kJJ4rYDdogR
         WCGeV9uORDEGiuQN7WKZNMsTI3jbEoshagaMprMNPna2y6PBuws3n/nUFUjxmgO4GMl/
         B6Ww==
X-Gm-Message-State: AOAM531cgENIwAaRf0tu3r9ZKnWL1OfUdVPfYiCtod9MMrp1EUnaqIyp
        5f0WLY7OYI/4yrIpXiHxCLg=
X-Google-Smtp-Source: ABdhPJx3lUiFx4HSvd1fhNtKihcV8rXbkUwANhMUNziIiCfE4pODDVK8ZdWYnl8UM+P7N2U3Du76QA==
X-Received: by 2002:a17:90b:a0d:: with SMTP id gg13mr1475617pjb.124.1619137626324;
        Thu, 22 Apr 2021 17:27:06 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id u12sm6390987pji.45.2021.04.22.17.27.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 17:27:05 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 bpf-next 13/16] libbpf: Add bpf_object pointer to kernel_supports().
Date:   Thu, 22 Apr 2021 17:26:43 -0700
Message-Id: <20210423002646.35043-14-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add a pointer to 'struct bpf_object' to kernel_supports() helper.
It will be used in the next patch.
No functional changes.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/lib/bpf/libbpf.c | 52 +++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c73a85b97ca5..7f58c389ff67 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -181,7 +181,7 @@ enum kern_feature_id {
 	__FEAT_CNT,
 };
 
-static bool kernel_supports(enum kern_feature_id feat_id);
+static bool kernel_supports(const struct bpf_object *obj, enum kern_feature_id feat_id);
 
 enum reloc_type {
 	RELO_LD64,
@@ -2407,20 +2407,20 @@ static bool section_have_execinstr(struct bpf_object *obj, int idx)
 
 static bool btf_needs_sanitization(struct bpf_object *obj)
 {
-	bool has_func_global = kernel_supports(FEAT_BTF_GLOBAL_FUNC);
-	bool has_datasec = kernel_supports(FEAT_BTF_DATASEC);
-	bool has_float = kernel_supports(FEAT_BTF_FLOAT);
-	bool has_func = kernel_supports(FEAT_BTF_FUNC);
+	bool has_func_global = kernel_supports(obj, FEAT_BTF_GLOBAL_FUNC);
+	bool has_datasec = kernel_supports(obj, FEAT_BTF_DATASEC);
+	bool has_float = kernel_supports(obj, FEAT_BTF_FLOAT);
+	bool has_func = kernel_supports(obj, FEAT_BTF_FUNC);
 
 	return !has_func || !has_datasec || !has_func_global || !has_float;
 }
 
 static void bpf_object__sanitize_btf(struct bpf_object *obj, struct btf *btf)
 {
-	bool has_func_global = kernel_supports(FEAT_BTF_GLOBAL_FUNC);
-	bool has_datasec = kernel_supports(FEAT_BTF_DATASEC);
-	bool has_float = kernel_supports(FEAT_BTF_FLOAT);
-	bool has_func = kernel_supports(FEAT_BTF_FUNC);
+	bool has_func_global = kernel_supports(obj, FEAT_BTF_GLOBAL_FUNC);
+	bool has_datasec = kernel_supports(obj, FEAT_BTF_DATASEC);
+	bool has_float = kernel_supports(obj, FEAT_BTF_FLOAT);
+	bool has_func = kernel_supports(obj, FEAT_BTF_FUNC);
 	struct btf_type *t;
 	int i, j, vlen;
 
@@ -2626,7 +2626,7 @@ static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 	if (!obj->btf)
 		return 0;
 
-	if (!kernel_supports(FEAT_BTF)) {
+	if (!kernel_supports(obj, FEAT_BTF)) {
 		if (kernel_needs_btf(obj)) {
 			err = -EOPNOTSUPP;
 			goto report;
@@ -4257,7 +4257,7 @@ static struct kern_feature_desc {
 	},
 };
 
-static bool kernel_supports(enum kern_feature_id feat_id)
+static bool kernel_supports(const struct bpf_object *obj, enum kern_feature_id feat_id)
 {
 	struct kern_feature_desc *feat = &feature_probes[feat_id];
 	int ret;
@@ -4376,7 +4376,7 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 
 	memset(&create_attr, 0, sizeof(create_attr));
 
-	if (kernel_supports(FEAT_PROG_NAME))
+	if (kernel_supports(obj, FEAT_PROG_NAME))
 		create_attr.name = map->name;
 	create_attr.map_ifindex = map->map_ifindex;
 	create_attr.map_type = def->type;
@@ -4941,7 +4941,7 @@ static int load_module_btfs(struct bpf_object *obj)
 	obj->btf_modules_loaded = true;
 
 	/* kernel too old to support module BTFs */
-	if (!kernel_supports(FEAT_MODULE_BTF))
+	if (!kernel_supports(obj, FEAT_MODULE_BTF))
 		return 0;
 
 	while (true) {
@@ -6333,7 +6333,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 
 		switch (relo->type) {
 		case RELO_LD64:
-			if (kernel_supports(FEAT_FD_IDX)) {
+			if (kernel_supports(obj, FEAT_FD_IDX)) {
 				insn[0].src_reg = BPF_PSEUDO_MAP_IDX;
 				insn[0].imm = relo->map_idx;
 			} else {
@@ -6343,7 +6343,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 			break;
 		case RELO_DATA:
 			insn[1].imm = insn[0].imm + relo->sym_off;
-			if (kernel_supports(FEAT_FD_IDX)) {
+			if (kernel_supports(obj, FEAT_FD_IDX)) {
 				insn[0].src_reg = BPF_PSEUDO_MAP_IDX_VALUE;
 				insn[0].imm = relo->map_idx;
 			} else {
@@ -6354,7 +6354,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 		case RELO_EXTERN_VAR:
 			ext = &obj->externs[relo->sym_off];
 			if (ext->type == EXT_KCFG) {
-				if (kernel_supports(FEAT_FD_IDX)) {
+				if (kernel_supports(obj, FEAT_FD_IDX)) {
 					insn[0].src_reg = BPF_PSEUDO_MAP_IDX_VALUE;
 					insn[0].imm = obj->kconfig_map_idx;
 				} else {
@@ -6478,7 +6478,7 @@ reloc_prog_func_and_line_info(const struct bpf_object *obj,
 	/* no .BTF.ext relocation if .BTF.ext is missing or kernel doesn't
 	 * supprot func/line info
 	 */
-	if (!obj->btf_ext || !kernel_supports(FEAT_BTF_FUNC))
+	if (!obj->btf_ext || !kernel_supports(obj, FEAT_BTF_FUNC))
 		return 0;
 
 	/* only attempt func info relocation if main program's func_info
@@ -7076,12 +7076,12 @@ static int bpf_object__sanitize_prog(struct bpf_object* obj, struct bpf_program
 		switch (func_id) {
 		case BPF_FUNC_probe_read_kernel:
 		case BPF_FUNC_probe_read_user:
-			if (!kernel_supports(FEAT_PROBE_READ_KERN))
+			if (!kernel_supports(obj, FEAT_PROBE_READ_KERN))
 				insn->imm = BPF_FUNC_probe_read;
 			break;
 		case BPF_FUNC_probe_read_kernel_str:
 		case BPF_FUNC_probe_read_user_str:
-			if (!kernel_supports(FEAT_PROBE_READ_KERN))
+			if (!kernel_supports(obj, FEAT_PROBE_READ_KERN))
 				insn->imm = BPF_FUNC_probe_read_str;
 			break;
 		default:
@@ -7116,12 +7116,12 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 
 	load_attr.prog_type = prog->type;
 	/* old kernels might not support specifying expected_attach_type */
-	if (!kernel_supports(FEAT_EXP_ATTACH_TYPE) && prog->sec_def &&
+	if (!kernel_supports(prog->obj, FEAT_EXP_ATTACH_TYPE) && prog->sec_def &&
 	    prog->sec_def->is_exp_attach_type_optional)
 		load_attr.expected_attach_type = 0;
 	else
 		load_attr.expected_attach_type = prog->expected_attach_type;
-	if (kernel_supports(FEAT_PROG_NAME))
+	if (kernel_supports(prog->obj, FEAT_PROG_NAME))
 		load_attr.name = prog->name;
 	load_attr.insns = insns;
 	load_attr.insn_cnt = insns_cnt;
@@ -7138,7 +7138,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 
 	/* specify func_info/line_info only if kernel supports them */
 	btf_fd = bpf_object__btf_fd(prog->obj);
-	if (btf_fd >= 0 && kernel_supports(FEAT_BTF_FUNC)) {
+	if (btf_fd >= 0 && kernel_supports(prog->obj, FEAT_BTF_FUNC)) {
 		load_attr.prog_btf_fd = btf_fd;
 		load_attr.func_info = prog->func_info;
 		load_attr.func_info_rec_size = prog->func_info_rec_size;
@@ -7168,7 +7168,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 			pr_debug("verifier log:\n%s", log_buf);
 
 		if (prog->obj->rodata_map_idx >= 0 &&
-		    kernel_supports(FEAT_PROG_BIND_MAP)) {
+		    kernel_supports(prog->obj, FEAT_PROG_BIND_MAP)) {
 			struct bpf_map *rodata_map =
 				&prog->obj->maps[prog->obj->rodata_map_idx];
 
@@ -7337,7 +7337,7 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 			return err;
 	}
 
-	if (kernel_supports(FEAT_FD_IDX) && obj->nr_maps) {
+	if (kernel_supports(obj, FEAT_FD_IDX) && obj->nr_maps) {
 		fd_array = malloc(sizeof(int) * obj->nr_maps);
 		if (!fd_array)
 			return -ENOMEM;
@@ -7542,11 +7542,11 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
 	bpf_object__for_each_map(m, obj) {
 		if (!bpf_map__is_internal(m))
 			continue;
-		if (!kernel_supports(FEAT_GLOBAL_DATA)) {
+		if (!kernel_supports(obj, FEAT_GLOBAL_DATA)) {
 			pr_warn("kernel doesn't support global data\n");
 			return -ENOTSUP;
 		}
-		if (!kernel_supports(FEAT_ARRAY_MMAP))
+		if (!kernel_supports(obj, FEAT_ARRAY_MMAP))
 			m->def.map_flags ^= BPF_F_MMAPABLE;
 	}
 
-- 
2.30.2

