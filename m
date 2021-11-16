Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B0F4537F4
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbhKPQpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:45:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbhKPQp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 11:45:28 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFFCC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:42:31 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id f20so19237616qtb.4
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zw1pFcmVYjr5R1C/2oANRh/RyFIkAQ0abG3XLwK4tDI=;
        b=Czxxt+Pr7paG062G2kLYgN+RKOd5mXXX3eYxqjpS9erjhVYUz19dD3cCB+83gfY5RV
         SGMdd0ZtNePjwvvYVTZpU6g5kSMVrFreP0cBUZYAgND5LJvas1rEbwKKv2Bu9QSimJtn
         HVL2x5ALlTn41LRZfQCES3zNdqhSEd7yCPKNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zw1pFcmVYjr5R1C/2oANRh/RyFIkAQ0abG3XLwK4tDI=;
        b=cGgkx+pyyswwUAUdQXmUyzQky70LqKVXgSmnJOdPXG8vv/9YHWRlGCPABj3vo1xfS5
         OUfrKJ2FMjjFfZmbfNlo/B6FJ9DkkJ8cRKmYCe9PSoLr84S/kn3kp0T16uUTInHUYd0J
         9pNlTbYpkQO4BflJP7nSt3X23+n/xYuwikL6Fq2B0INRrmkTg1YxiF7ciSJz5Xmf07lA
         pnU26RTtJqS9lWGLxIJm+Cvh1Gk4j+cVkkNiD7N55m2GPVcXXvp5ta7JXcFD2EPSnzEM
         UejwaK3J5zXLYJ7HSOBAwSbTY1CGQtYCr5i8cmKjZj1LhJ6awDXzV6xXujslnMHxEdBC
         ntsg==
X-Gm-Message-State: AOAM531xg5NUPMPWIr5/RdLdRkMYWOeW/gTqJ6/CBaFB1lYvH6BNmeBm
        ZZOHJzSZjnRC/LzyFikd8GM7iiSZ7AKeAwpoDd4OBvEMCb32cRtrJsmMeKxBBMa3SZC8Qnf3Nlp
        bzk+yQ94WvbFKJbcslPr7MELnZa0mTEwvLXtb4rh9czwDNtjFQFFQTQ0V4R4LitsP3MsyeLcs
X-Google-Smtp-Source: ABdhPJzfW1Jamnx1xV/i/biIk+BigAQeL636cBcw9BNhojWgm7HlNhYqQyLCBFTFQ5GB8NQdlGkcIQ==
X-Received: by 2002:ac8:7f52:: with SMTP id g18mr9040672qtk.190.1637080948665;
        Tue, 16 Nov 2021 08:42:28 -0800 (PST)
Received: from localhost.localdomain ([191.91.82.96])
        by smtp.gmail.com with ESMTPSA id bk18sm7309121qkb.35.2021.11.16.08.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:42:28 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v2 3/4] libbpf: Introduce 'bpf_object__prepare()'
Date:   Tue, 16 Nov 2021 11:42:07 -0500
Message-Id: <20211116164208.164245-4-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116164208.164245-1-mauricio@kinvolk.io>
References: <20211116164208.164245-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTFGen[0] requires access to the result of the CO-RE relocations without
actually loading the bpf programs. The current libbpf API doesn't allow
it because all the object preparation (subprogs, relocations: co-re,
elf, maps) happens inside bpf_object__load().

This commit introduces a new bpf_object__prepare() function to perform
all the preparation steps than an ebpf object requires, allowing users
to access the result of those preparation steps without having to load
the program. Almost all the steps that were done in bpf_object__load()
are now done in bpf_object__prepare(), except map creation and program
loading.

Map relocations require a bit more attention as maps are only created in
bpf_object__load(). For this reason bpf_object__prepare() relocates maps
using BPF_PSEUDO_MAP_IDX, if someone dumps the instructions before
loading the program they get something meaningful. Map relocations are
completed in bpf_object__load() once the maps are created and we have
their fd to use with BPF_PSEUDO_MAP_FD.

Users won’t see any visible changes if they’re using bpf_object__open()
+ bpf_object__load() because this commit keeps backwards compatibility
by calling bpf_object__prepare() in bpf_object_load() if it wasn’t
called by the user.

bpf_object__prepare_xattr() is not implemented as their counterpart
bpf_object__load_xattr() will be deprecated[1]. New options will be
added only to bpf_object_open_opts.

[0]: https://github.com/kinvolk/btfgen/
[1]: https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#libbpfh-high-level-apis

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/lib/bpf/libbpf.c   | 130 ++++++++++++++++++++++++++++-----------
 tools/lib/bpf/libbpf.h   |   2 +
 tools/lib/bpf/libbpf.map |   1 +
 3 files changed, 98 insertions(+), 35 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6ca76365c6da..f50f9428bb03 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -514,6 +514,7 @@ struct bpf_object {
 	int nr_extern;
 	int kconfig_map_idx;
 
+	bool prepared;
 	bool loaded;
 	bool has_subcalls;
 	bool has_rodata;
@@ -5576,34 +5577,19 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 
 		switch (relo->type) {
 		case RELO_LD64:
-			if (obj->gen_loader) {
-				insn[0].src_reg = BPF_PSEUDO_MAP_IDX;
-				insn[0].imm = relo->map_idx;
-			} else {
-				insn[0].src_reg = BPF_PSEUDO_MAP_FD;
-				insn[0].imm = obj->maps[relo->map_idx].fd;
-			}
+			insn[0].src_reg = BPF_PSEUDO_MAP_IDX;
+			insn[0].imm = relo->map_idx;
 			break;
 		case RELO_DATA:
 			insn[1].imm = insn[0].imm + relo->sym_off;
-			if (obj->gen_loader) {
-				insn[0].src_reg = BPF_PSEUDO_MAP_IDX_VALUE;
-				insn[0].imm = relo->map_idx;
-			} else {
-				insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
-				insn[0].imm = obj->maps[relo->map_idx].fd;
-			}
+			insn[0].src_reg = BPF_PSEUDO_MAP_IDX_VALUE;
+			insn[0].imm = relo->map_idx;
 			break;
 		case RELO_EXTERN_VAR:
 			ext = &obj->externs[relo->sym_off];
 			if (ext->type == EXT_KCFG) {
-				if (obj->gen_loader) {
-					insn[0].src_reg = BPF_PSEUDO_MAP_IDX_VALUE;
-					insn[0].imm = obj->kconfig_map_idx;
-				} else {
-					insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
-					insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
-				}
+				insn[0].src_reg = BPF_PSEUDO_MAP_IDX_VALUE;
+				insn[0].imm = obj->kconfig_map_idx;
 				insn[1].imm = ext->kcfg.data_off;
 			} else /* EXT_KSYM */ {
 				if (ext->ksym.type_id && ext->is_set) { /* typed ksyms */
@@ -6144,8 +6130,50 @@ bpf_object__relocate(struct bpf_object *obj, const char *targ_btf_path)
 			return err;
 		}
 	}
-	if (!obj->gen_loader)
-		bpf_object__free_relocs(obj);
+
+	return 0;
+}
+
+/* relocate instructions that refer to map fds */
+static int
+bpf_object__finish_relocate(struct bpf_object *obj)
+{
+	int i, j;
+
+	if (obj->gen_loader)
+		return 0;
+
+	for (i = 0; i < obj->nr_programs; i++) {
+		struct bpf_program *prog = &obj->programs[i];
+
+		if (prog_is_subprog(obj, prog))
+			continue;
+		for (j = 0; j < prog->nr_reloc; j++) {
+			struct reloc_desc *relo = &prog->reloc_desc[j];
+			struct bpf_insn *insn = &prog->insns[relo->insn_idx];
+			struct extern_desc *ext;
+
+			switch (relo->type) {
+			case RELO_LD64:
+				insn[0].src_reg = BPF_PSEUDO_MAP_FD;
+				insn[0].imm = obj->maps[relo->map_idx].fd;
+				break;
+			case RELO_DATA:
+				insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
+				insn[0].imm = obj->maps[relo->map_idx].fd;
+				break;
+			case RELO_EXTERN_VAR:
+				ext = &obj->externs[relo->sym_off];
+				if (ext->type == EXT_KCFG) {
+					insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
+					insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
+				}
+			default:
+				break;
+			}
+		}
+	}
+
 	return 0;
 }
 
@@ -6706,8 +6734,8 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 		if (err)
 			return err;
 	}
-	if (obj->gen_loader)
-		bpf_object__free_relocs(obj);
+
+	bpf_object__free_relocs(obj);
 	return 0;
 }
 
@@ -7258,6 +7286,39 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
 	return 0;
 }
 
+static int __bpf_object__prepare(struct bpf_object *obj, int log_level,
+				 const char *target_btf_path)
+{
+	int err;
+
+	if (obj->prepared) {
+		pr_warn("object '%s': prepare can't be attempted twice\n", obj->name);
+		return libbpf_err(-EINVAL);
+	}
+
+	if (obj->gen_loader)
+		bpf_gen__init(obj->gen_loader, log_level);
+
+	err = bpf_object__probe_loading(obj);
+	err = err ? : bpf_object__load_vmlinux_btf(obj, false);
+	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
+	err = err ? : bpf_object__sanitize_and_load_btf(obj);
+	err = err ? : bpf_object__sanitize_maps(obj);
+	err = err ? : bpf_object__init_kern_struct_ops_maps(obj);
+	err = err ? : bpf_object__relocate(obj, obj->btf_custom_path ? : target_btf_path);
+
+	obj->prepared = true;
+
+	return err;
+}
+
+LIBBPF_API int bpf_object__prepare(struct bpf_object *obj)
+{
+	if (!obj)
+		return libbpf_err(-EINVAL);
+	return __bpf_object__prepare(obj, 0, NULL);
+}
+
 int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 {
 	struct bpf_object *obj;
@@ -7274,17 +7335,14 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 		return libbpf_err(-EINVAL);
 	}
 
-	if (obj->gen_loader)
-		bpf_gen__init(obj->gen_loader, attr->log_level);
+	if (!obj->prepared) {
+		err = __bpf_object__prepare(obj, attr->log_level, attr->target_btf_path);
+		if (err)
+			return err;
+	}
 
-	err = bpf_object__probe_loading(obj);
-	err = err ? : bpf_object__load_vmlinux_btf(obj, false);
-	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
-	err = err ? : bpf_object__sanitize_and_load_btf(obj);
-	err = err ? : bpf_object__sanitize_maps(obj);
-	err = err ? : bpf_object__init_kern_struct_ops_maps(obj);
-	err = err ? : bpf_object__create_maps(obj);
-	err = err ? : bpf_object__relocate(obj, obj->btf_custom_path ? : attr->target_btf_path);
+	err = bpf_object__create_maps(obj);
+	err = err ? : bpf_object__finish_relocate(obj);
 	err = err ? : bpf_object__load_progs(obj, attr->log_level);
 
 	if (obj->gen_loader) {
@@ -7940,6 +7998,8 @@ void bpf_object__close(struct bpf_object *obj)
 	bpf_object__elf_finish(obj);
 	bpf_object_unload(obj);
 	btf__free(obj->btf);
+	if (!obj->user_provided_btf_vmlinux)
+		btf__free(obj->btf_vmlinux_override);
 	btf_ext__free(obj->btf_ext);
 
 	for (i = 0; i < obj->nr_maps; i++)
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 908ab04dc9bd..d206b4400a4d 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -148,6 +148,8 @@ LIBBPF_API int bpf_object__unpin_programs(struct bpf_object *obj,
 LIBBPF_API int bpf_object__pin(struct bpf_object *object, const char *path);
 LIBBPF_API void bpf_object__close(struct bpf_object *object);
 
+LIBBPF_API int bpf_object__prepare(struct bpf_object *obj);
+
 struct bpf_object_load_attr {
 	struct bpf_object *obj;
 	int log_level;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index c9555f8655af..459b41228933 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -415,4 +415,5 @@ LIBBPF_0.6.0 {
 		perf_buffer__new_raw;
 		perf_buffer__new_raw_deprecated;
 		btf__save_raw;
+		bpf_object__prepare;
 } LIBBPF_0.5.0;
-- 
2.25.1

