Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C034537F6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 17:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbhKPQpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 11:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235813AbhKPQpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 11:45:30 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976A7C061746
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:42:33 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id a2so19492112qtx.11
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 08:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VNIFvJHTViq4ZUikEVSAjHLl5lPz7kvTObI4mC3qcIg=;
        b=FA6Fl8Iix03z936EctLNC6pCi5n1E22e6gjXHpk0uRw8u+2FyJNKhK/X2oZKi/3QLm
         HSisHtp/VYZG3oPzokygnbIfl38PyBiyWnKEuT1/qLr2n9Xw8UkSJ3LiBduOqYnV8pJ7
         U1sYoI4mTd01u7cata4k3nAVZTIGlwS4bsZi4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VNIFvJHTViq4ZUikEVSAjHLl5lPz7kvTObI4mC3qcIg=;
        b=5QPfsBWKxzCd1am+2sbmDWfp8xrTn48GymG6t9NPv3Wqz/Y+Jw1beUTYd5emJnq4AM
         IGCS5gFYlYhML8HtyKDk/ywHJyePxzgTVXFzn2wPexX26lxo2euTbuhZh+5wfbL6SU6+
         ZchK3tG/YhAtv/O+G37WpMVsc1MC9t1Uj8UlZBjufsgYVmBv5HsUOKxqzeeMuVT0InA8
         450lJ5zwkaaGiimEskECMmOBxbslIVo/mqpSPRNmEoCFvBg/qgBNF0gxpgMuon/IM0+Z
         C/VnmcimV9QyLXy7d9sbsnge3aLWtbB29ZnOyJWVHNd0cekHcP0CJAMNE9Dfsj/FkWVB
         hwhQ==
X-Gm-Message-State: AOAM531x8j61P8LPXwf8ZqLiyIctOMxfuJImeHzoaPZjh8uQolssguMK
        gURWPPrOy8WtNuPwkKK9mpittYHDQxtCFHBItMHlLkPOoOGUorKQVf+dDTKpt9HnGFSvLV/I3iU
        d132Sa/1GMlsS0QUlJ/MgLm9GgjwaqL9FCRgpF4HliIwV8ptaaw/H1P28IJeQ3yahHrhuzegR
X-Google-Smtp-Source: ABdhPJwmHSw0ISoCYUeRtD5puUGU17fkh2JOr6xmnWB+j492SbozmV1edBVS/ItSSB4hQ0udacS+ug==
X-Received: by 2002:ac8:5855:: with SMTP id h21mr9049322qth.8.1637080950235;
        Tue, 16 Nov 2021 08:42:30 -0800 (PST)
Received: from localhost.localdomain ([191.91.82.96])
        by smtp.gmail.com with ESMTPSA id bk18sm7309121qkb.35.2021.11.16.08.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 08:42:29 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v2 4/4] libbpf: Expose CO-RE relocation results
Date:   Tue, 16 Nov 2021 11:42:08 -0500
Message-Id: <20211116164208.164245-5-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116164208.164245-1-mauricio@kinvolk.io>
References: <20211116164208.164245-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The result of the CO-RE relocations can be useful for some use cases
like BTFGen[0]. This commit adds a new ‘record_core_relos’ option to
save the result of such relocations and a couple of functions to access
them.

[0]: https://github.com/kinvolk/btfgen/

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/lib/bpf/libbpf.c    | 63 ++++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.h    | 49 +++++++++++++++++++++++++++++-
 tools/lib/bpf/libbpf.map  |  2 ++
 tools/lib/bpf/relo_core.c | 28 +++++++++++++++--
 tools/lib/bpf/relo_core.h | 21 ++-----------
 5 files changed, 140 insertions(+), 23 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f50f9428bb03..a5da977a9f5d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -306,6 +306,10 @@ struct bpf_program {
 
 	struct reloc_desc *reloc_desc;
 	int nr_reloc;
+
+	struct bpf_core_relo_result *core_relos;
+	int nr_core_relos;
+
 	int log_level;
 
 	struct {
@@ -519,6 +523,9 @@ struct bpf_object {
 	bool has_subcalls;
 	bool has_rodata;
 
+	/* Record CO-RE relocations for the different programs in prog->core_relos */
+	bool record_core_relos;
+
 	struct bpf_gen *gen_loader;
 
 	/* Information when doing ELF related work. Only valid if efile.elf is not NULL */
@@ -614,8 +621,10 @@ static void bpf_program__exit(struct bpf_program *prog)
 	zfree(&prog->pin_name);
 	zfree(&prog->insns);
 	zfree(&prog->reloc_desc);
+	zfree(&prog->core_relos);
 
 	prog->nr_reloc = 0;
+	prog->nr_core_relos = 0;
 	prog->insns_cnt = 0;
 	prog->sec_idx = -1;
 }
@@ -5408,6 +5417,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 			       struct hashmap *cand_cache)
 {
 	const void *type_key = u32_as_hash_key(relo->type_id);
+	struct bpf_core_relo_result *core_relo = NULL;
 	struct bpf_core_cand_list *cands = NULL;
 	const char *prog_name = prog->name;
 	const struct btf_type *local_type;
@@ -5459,7 +5469,18 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 		}
 	}
 
-	return bpf_core_apply_relo_insn(prog_name, insn, insn_idx, relo, relo_idx, local_btf, cands);
+	if (prog->obj->record_core_relos) {
+		prog->core_relos = libbpf_reallocarray(prog->core_relos,
+						       sizeof(*prog->core_relos),
+						       prog->nr_core_relos + 1);
+		if (!prog->core_relos)
+			return -ENOMEM;
+
+		core_relo = &prog->core_relos[prog->nr_core_relos++];
+	}
+
+	return bpf_core_apply_relo_insn(prog_name, insn, insn_idx, relo, relo_idx, local_btf, cands,
+					core_relo);
 }
 
 static int
@@ -5815,6 +5836,28 @@ static int append_subprog_relos(struct bpf_program *main_prog, struct bpf_progra
 	return 0;
 }
 
+static int append_subprog_core_relos(struct bpf_program *main_prog, struct bpf_program *subprog)
+{
+	int new_cnt = main_prog->nr_core_relos + subprog->nr_core_relos;
+	struct bpf_core_relo_result *relos;
+	int i;
+
+	if (main_prog == subprog)
+		return 0;
+	relos = libbpf_reallocarray(main_prog->core_relos, new_cnt, sizeof(*relos));
+	if (!relos)
+		return -ENOMEM;
+	memcpy(relos + main_prog->nr_core_relos, subprog->core_relos,
+	       sizeof(*relos) * subprog->nr_core_relos);
+
+	for (i = main_prog->nr_core_relos; i < new_cnt; i++)
+		relos[i].insn_idx += subprog->sub_insn_off;
+
+	main_prog->core_relos = relos;
+	main_prog->nr_core_relos = new_cnt;
+	return 0;
+}
+
 static int
 bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
 		       struct bpf_program *prog)
@@ -5918,6 +5961,11 @@ bpf_object__reloc_code(struct bpf_object *obj, struct bpf_program *main_prog,
 			err = append_subprog_relos(main_prog, subprog);
 			if (err)
 				return err;
+
+			err = append_subprog_core_relos(main_prog, subprog);
+			if (err)
+				return err;
+
 			err = bpf_object__reloc_code(obj, main_prog, subprog);
 			if (err)
 				return err;
@@ -6168,6 +6216,7 @@ bpf_object__finish_relocate(struct bpf_object *obj)
 					insn[0].src_reg = BPF_PSEUDO_MAP_VALUE;
 					insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
 				}
+				break;
 			default:
 				break;
 			}
@@ -6845,6 +6894,8 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		}
 	}
 
+	obj->record_core_relos = OPTS_GET(opts, record_core_relos, false);
+
 	err = bpf_object__elf_init(obj);
 	err = err ? : bpf_object__check_endianness(obj);
 	err = err ? : bpf_object__elf_collect(obj);
@@ -8253,6 +8304,16 @@ size_t bpf_program__insn_cnt(const struct bpf_program *prog)
 	return prog->insns_cnt;
 }
 
+const struct bpf_core_relo_result *bpf_program__core_relos(struct bpf_program *prog)
+{
+	return prog->core_relos;
+}
+
+int bpf_program__core_relos_cnt(struct bpf_program *prog)
+{
+	return prog->nr_core_relos;
+}
+
 int bpf_program__set_prep(struct bpf_program *prog, int nr_instances,
 			  bpf_program_prep_t prep)
 {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index d206b4400a4d..47c8ac41f61b 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -111,8 +111,12 @@ struct bpf_object_open_opts {
 	 * struct_ops, etc) will need actual kernel BTF at /sys/kernel/btf/vmlinux.
 	 */
 	struct btf *btf_custom;
+	/* Keep track of CO-RE relocation results. This information can be retrieved
+	 * with bpf_program__core_relos() after the object is prepared.
+	 */
+	bool record_core_relos;
 };
-#define bpf_object_open_opts__last_field btf_custom
+#define bpf_object_open_opts__last_field record_core_relos
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
@@ -286,6 +290,49 @@ LIBBPF_API int bpf_program__pin(struct bpf_program *prog, const char *path);
 LIBBPF_API int bpf_program__unpin(struct bpf_program *prog, const char *path);
 LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
 
+/* bpf_core_relo_kind encodes which aspect of captured field/type/enum value
+ * has to be adjusted by relocations.
+ */
+enum bpf_core_relo_kind {
+	BPF_FIELD_BYTE_OFFSET = 0,	/* field byte offset */
+	BPF_FIELD_BYTE_SIZE = 1,	/* field size in bytes */
+	BPF_FIELD_EXISTS = 2,		/* field existence in target kernel */
+	BPF_FIELD_SIGNED = 3,		/* field signedness (0 - unsigned, 1 - signed) */
+	BPF_FIELD_LSHIFT_U64 = 4,	/* bitfield-specific left bitshift */
+	BPF_FIELD_RSHIFT_U64 = 5,	/* bitfield-specific right bitshift */
+	BPF_TYPE_ID_LOCAL = 6,		/* type ID in local BPF object */
+	BPF_TYPE_ID_TARGET = 7,		/* type ID in target kernel */
+	BPF_TYPE_EXISTS = 8,		/* type existence in target kernel */
+	BPF_TYPE_SIZE = 9,		/* type size in bytes */
+	BPF_ENUMVAL_EXISTS = 10,	/* enum value existence in target kernel */
+	BPF_ENUMVAL_VALUE = 11,		/* enum value integer value */
+};
+
+#define BPF_CORE_SPEC_MAX_LEN 64
+
+struct bpf_core_relo_spec {
+	const struct btf *btf;
+	__u32 root_type_id;
+	/* accessor spec */
+	int spec[BPF_CORE_SPEC_MAX_LEN];
+	int spec_len;
+};
+
+struct bpf_core_relo_result {
+	struct bpf_core_relo_spec local_spec, targ_spec;
+	int insn_idx;
+	enum bpf_core_relo_kind relo_kind;
+	/* true if libbpf wasn't able to perform the relocation */
+	bool poison;
+	/* original value in the instruction */
+	__u32 orig_val;
+	/* new value that the instruction needs to be patched up to */
+	__u32 new_val;
+};
+
+LIBBPF_API const struct bpf_core_relo_result *bpf_program__core_relos(struct bpf_program *prog);
+LIBBPF_API int bpf_program__core_relos_cnt(struct bpf_program *prog);
+
 struct bpf_link;
 
 LIBBPF_API struct bpf_link *bpf_link__open(const char *path);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 459b41228933..4aeb5db9c4e3 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -416,4 +416,6 @@ LIBBPF_0.6.0 {
 		perf_buffer__new_raw_deprecated;
 		btf__save_raw;
 		bpf_object__prepare;
+		bpf_program__core_relos;
+		bpf_program__core_relos_cnt;
 } LIBBPF_0.5.0;
diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index b5b8956a1be8..11b04c5961a1 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -13,8 +13,6 @@
 #include "str_error.h"
 #include "libbpf_internal.h"
 
-#define BPF_CORE_SPEC_MAX_LEN 64
-
 /* represents BPF CO-RE field or array element accessor */
 struct bpf_core_accessor {
 	__u32 type_id;		/* struct/union type or array element type */
@@ -1092,6 +1090,18 @@ static void bpf_core_dump_spec(int level, const struct bpf_core_spec *spec)
 	}
 }
 
+static void copy_core_spec(const struct bpf_core_spec *src, struct bpf_core_relo_spec *dst)
+{
+	int i;
+
+	dst->root_type_id = src->root_type_id;
+	dst->btf = src->btf;
+	dst->spec_len = src->raw_len;
+
+	for (i = 0; i < src->raw_len; i++)
+		dst->spec[i] = src->raw_spec[i];
+}
+
 /*
  * CO-RE relocate single instruction.
  *
@@ -1147,7 +1157,8 @@ int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
 			     const struct bpf_core_relo *relo,
 			     int relo_idx,
 			     const struct btf *local_btf,
-			     struct bpf_core_cand_list *cands)
+			     struct bpf_core_cand_list *cands,
+			     struct bpf_core_relo_result *core_relo)
 {
 	struct bpf_core_spec local_spec, cand_spec, targ_spec = {};
 	struct bpf_core_relo_res cand_res, targ_res;
@@ -1291,5 +1302,16 @@ int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
 		return -EINVAL;
 	}
 
+	if (core_relo) {
+		copy_core_spec(&local_spec, &core_relo->local_spec);
+		copy_core_spec(&targ_spec, &core_relo->targ_spec);
+
+		core_relo->insn_idx = insn_idx;
+		core_relo->poison = targ_res.poison;
+		core_relo->relo_kind = targ_spec.relo_kind;
+		core_relo->orig_val = targ_res.orig_val;
+		core_relo->new_val = targ_res.new_val;
+	}
+
 	return 0;
 }
diff --git a/tools/lib/bpf/relo_core.h b/tools/lib/bpf/relo_core.h
index 3b9f8f18346c..89d7c4c31ccd 100644
--- a/tools/lib/bpf/relo_core.h
+++ b/tools/lib/bpf/relo_core.h
@@ -4,23 +4,7 @@
 #ifndef __RELO_CORE_H
 #define __RELO_CORE_H
 
-/* bpf_core_relo_kind encodes which aspect of captured field/type/enum value
- * has to be adjusted by relocations.
- */
-enum bpf_core_relo_kind {
-	BPF_FIELD_BYTE_OFFSET = 0,	/* field byte offset */
-	BPF_FIELD_BYTE_SIZE = 1,	/* field size in bytes */
-	BPF_FIELD_EXISTS = 2,		/* field existence in target kernel */
-	BPF_FIELD_SIGNED = 3,		/* field signedness (0 - unsigned, 1 - signed) */
-	BPF_FIELD_LSHIFT_U64 = 4,	/* bitfield-specific left bitshift */
-	BPF_FIELD_RSHIFT_U64 = 5,	/* bitfield-specific right bitshift */
-	BPF_TYPE_ID_LOCAL = 6,		/* type ID in local BPF object */
-	BPF_TYPE_ID_TARGET = 7,		/* type ID in target kernel */
-	BPF_TYPE_EXISTS = 8,		/* type existence in target kernel */
-	BPF_TYPE_SIZE = 9,		/* type size in bytes */
-	BPF_ENUMVAL_EXISTS = 10,	/* enum value existence in target kernel */
-	BPF_ENUMVAL_VALUE = 11,		/* enum value integer value */
-};
+#include "libbpf.h"
 
 /* The minimum bpf_core_relo checked by the loader
  *
@@ -92,7 +76,8 @@ int bpf_core_apply_relo_insn(const char *prog_name,
 			     struct bpf_insn *insn, int insn_idx,
 			     const struct bpf_core_relo *relo, int relo_idx,
 			     const struct btf *local_btf,
-			     struct bpf_core_cand_list *cands);
+			     struct bpf_core_cand_list *cands,
+			     struct bpf_core_relo_result *core_relo);
 int bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id,
 			      const struct btf *targ_btf, __u32 targ_id);
 
-- 
2.25.1

