Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EDD43D2FE
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243977AbhJ0UkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243973AbhJ0UkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:40:12 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914E2C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:37:46 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id v29so2423493qtc.10
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vIHOFLtY6MTa34VVycBjpKGlgQ/KRPZF0gH5mLURcjY=;
        b=HQmJ5UmmEEOIz2vP0RNCjxZwUXvPMD+S7TA1wh+IGwetdzd0hW2t1aFzt07yYkmmGl
         VrV/FTYGmwDuXA4nmFjq85+02xklWMp9edCZ40F0sfyJpSQ6zTnQ+Ti5oYO9vH8DQq0/
         uKzCYl1E/PtpeUOCnoMMFb/T9aJ026HJ1T78w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vIHOFLtY6MTa34VVycBjpKGlgQ/KRPZF0gH5mLURcjY=;
        b=gd2GukhAH5X+V6z35bsMbkJ9o+QzE0csnVQuwuZiNS31DK0G19YGU7fxrs1UptEPtx
         3VD1YBDGi88ZGZ48PwSa+hUF3V0BEwuimx5C/YFdwaTbxRvMQkfZBnvfvsSHUwpWJpX/
         GDZ4N8UuiZpVCvicbLT8sg+NK3w8CCOuPa2/uEByKqayCapLzHD/qf4RNgQ3x0zJrNLG
         G0nBAfm4MfxkIuupXlkH7FV0c9pRrp3HIVkNsyooxtzYraDQlzSlwNRY/FjrpcGSchxt
         tpSvVZPk50Cy/0ZaQthXBo4KdOSGgt0A/ry5NjlvlWsHY8cwEX3gTZOjErI2KWtHU1SN
         noQw==
X-Gm-Message-State: AOAM530GcMj4gHLb9m7ecwE6NXoU5WTqXHXRuJUubR08Gv6WDNBpVosf
        2T3UhjYLquT4FwlPcZMri/EK2GetRHOrrUBGVexk/G7nA9EH7U1vQPMS4R+Mw/IOKF9wi+1CLTU
        Z2dSDbewAshV1z01rk9Rd8JDgfZ4Iys6pNS//JtYDZKtnI+nCK3WsHkiEZg1Jm6aKdAzW3Vx3
X-Google-Smtp-Source: ABdhPJwfTZVyiJIzRMpNB9Btf2yeK+HJEOl0/LiYYkR9X51K0EmmpuZ603sRVLPP3WtjfyhUgdQoGQ==
X-Received: by 2002:a05:622a:86:: with SMTP id o6mr46687qtw.290.1635367063138;
        Wed, 27 Oct 2021 13:37:43 -0700 (PDT)
Received: from localhost.localdomain ([191.91.82.96])
        by smtp.gmail.com with ESMTPSA id 14sm696790qtp.97.2021.10.27.13.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:37:42 -0700 (PDT)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Rafael David Tinoco <rafael.tinoco@aquasec.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>
Subject: [PATCH bpf-next 2/2] libbpf: Implement API for generating BTF for ebpf objects
Date:   Wed, 27 Oct 2021 15:37:27 -0500
Message-Id: <20211027203727.208847-3-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211027203727.208847-1-mauricio@kinvolk.io>
References: <20211027203727.208847-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements a new set of "bpf_reloc_info__" functions for
generating a BTF file with the types a given set of eBPF objects need
for their CO-RE relocations. This code reuses all the existing CO-RE
logic (candidate lookup, matching, etc). The workflow is the same as
when an eBPF program is being loaded, but instead of patching the eBPF
instruction, we save the type involved in the relocation.

A new struct btf_reloc_info is defined to save the BTF types needed by a
set of eBPF objects. It is created with the bpf_reloc_info__new()
function and populated with bpf_object__reloc_info_gen() for each eBPF
object, finally the BTF file is generated with
bpf_reloc_info__get_btf(). Please take at a look at BTFGen[0] to get a
complete example of how this API can be used.

bpf_object__reloc_info_gen() ends up calling btf_reloc_info_gen_field()
that uses the access spec to add all the types needed by a given
relocation. The root type is added and, if it is a complex type, like a
struct or union, the members involved in the relocation are added as
well. References are resolved and all referenced types are added. This
function can be called multiple times to add the types needed for
different objects into the same struct btf_reloc_info, this allows the
user to create a BTF file that contains the BTF information for multiple
eBPF objects.

The bpf_reloc_info__get_btf() generates the BTF file from a given struct
btf_reloc_info. This function first creates a new BTF object and copies
all the types saved in the struct btf_reloc_info there. For structures
and unions, only the members involved in a relocation are copied. While
adding the types to the new BTF object, a map is filled with the type
IDs on the old and new BTF structures.  This map is then used later on
to fix all the IDs in the new BTF object.

Right now only support for field based CO-RE relocations is supported.

[0]: https://github.com/kinvolk/btfgen

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
---
 tools/lib/bpf/Makefile    |   2 +-
 tools/lib/bpf/libbpf.c    |  28 ++-
 tools/lib/bpf/libbpf.h    |   4 +
 tools/lib/bpf/libbpf.map  |   5 +
 tools/lib/bpf/relo_core.c | 514 +++++++++++++++++++++++++++++++++++++-
 tools/lib/bpf/relo_core.h |  11 +-
 6 files changed, 554 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index b393b5e82380..b01a1ece2cff 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -237,7 +237,7 @@ install_lib: all_cmd
 
 SRC_HDRS := bpf.h libbpf.h btf.h libbpf_common.h libbpf_legacy.h xsk.h	     \
 	    bpf_helpers.h bpf_tracing.h bpf_endian.h bpf_core_read.h	     \
-	    skel_internal.h libbpf_version.h
+	    skel_internal.h libbpf_version.h relo_core.h
 GEN_HDRS := $(BPF_GENERATED)
 
 INSTALL_PFX := $(DESTDIR)$(prefix)/include/bpf
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2fbed2d4a645..51522b60edfa 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -545,6 +545,9 @@ struct bpf_object {
 	size_t btf_module_cnt;
 	size_t btf_module_cap;
 
+	/* Relocation info when using bpf_object__reloc_info_gen() */
+	struct btf_reloc_info *reloc_info;
+
 	void *priv;
 	bpf_object_clear_priv_t clear_priv;
 
@@ -5386,7 +5389,8 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 			       const struct bpf_core_relo *relo,
 			       int relo_idx,
 			       const struct btf *local_btf,
-			       struct hashmap *cand_cache)
+			       struct hashmap *cand_cache,
+			       struct btf_reloc_info *reloc_info)
 {
 	const void *type_key = u32_as_hash_key(relo->type_id);
 	struct bpf_core_cand_list *cands = NULL;
@@ -5440,7 +5444,8 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 		}
 	}
 
-	return bpf_core_apply_relo_insn(prog_name, insn, insn_idx, relo, relo_idx, local_btf, cands);
+	return bpf_core_apply_relo_insn(prog_name, insn, insn_idx, relo, relo_idx, local_btf, cands,
+					reloc_info);
 }
 
 static int
@@ -5465,6 +5470,8 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 			pr_warn("failed to parse target BTF: %d\n", err);
 			return err;
 		}
+	} else if (obj->reloc_info && bpf_reloc_info_get_src_btf(obj->reloc_info)) {
+		obj->btf_vmlinux_override = bpf_reloc_info_get_src_btf(obj->reloc_info);
 	}
 
 	cand_cache = hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
@@ -5516,7 +5523,8 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 			if (!prog->load)
 				continue;
 
-			err = bpf_core_apply_relo(prog, rec, i, obj->btf, cand_cache);
+			err = bpf_core_apply_relo(prog, rec, i, obj->btf, cand_cache,
+						  obj->reloc_info);
 			if (err) {
 				pr_warn("prog '%s': relo #%d: failed to relocate: %d\n",
 					prog->name, i, err);
@@ -5526,9 +5534,11 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 	}
 
 out:
-	/* obj->btf_vmlinux and module BTFs are freed after object load */
-	btf__free(obj->btf_vmlinux_override);
-	obj->btf_vmlinux_override = NULL;
+	if (!obj->reloc_info) {
+		/* obj->btf_vmlinux and module BTFs are freed after object load */
+		btf__free(obj->btf_vmlinux_override);
+		obj->btf_vmlinux_override = NULL;
+	}
 
 	if (!IS_ERR_OR_NULL(cand_cache)) {
 		hashmap__for_each_entry(cand_cache, entry, i) {
@@ -7227,6 +7237,12 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
 	return 0;
 }
 
+int bpf_object__reloc_info_gen(struct btf_reloc_info *info, struct bpf_object *obj)
+{
+	obj->reloc_info = info;
+	return bpf_object__relocate_core(obj, NULL);
+}
+
 int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 {
 	struct bpf_object *obj;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index e1900819bfab..6fba2a4c9018 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -19,6 +19,7 @@
 
 #include "libbpf_common.h"
 #include "libbpf_legacy.h"
+#include "relo_core.h"
 
 #ifdef __cplusplus
 extern "C" {
@@ -1016,6 +1017,9 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker,
 LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
 LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
 
+LIBBPF_API int bpf_object__reloc_info_gen(struct btf_reloc_info *info,
+					  struct bpf_object *obj);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 0e9bed7c9b9e..067f8b20c894 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -400,4 +400,9 @@ LIBBPF_0.6.0 {
 		btf__raw_data;
 		btf__type_cnt;
 		btf__save_to_file;
+		bpf_reloc_info__new;
+		bpf_reloc_info__free;
+		bpf_object__reloc_info_gen;
+		bpf_reloc_info__get_btf;
+
 } LIBBPF_0.5.0;
diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index b5b8956a1be8..c345826e92fb 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -10,6 +10,7 @@
 #include "libbpf.h"
 #include "bpf.h"
 #include "btf.h"
+#include "hashmap.h"
 #include "str_error.h"
 #include "libbpf_internal.h"
 
@@ -763,6 +764,8 @@ struct bpf_core_relo_res
 	__u32 orig_type_id;
 	__u32 new_sz;
 	__u32 new_type_id;
+
+	const struct bpf_core_spec *targ_spec;
 };
 
 /* Calculate original and target relocation values, given local and target
@@ -854,6 +857,8 @@ static int bpf_core_calc_relo(const char *prog_name,
 			relo->kind, relo->insn_off / 8);
 	}
 
+	res->targ_spec = targ_spec;
+
 	return err;
 }
 
@@ -1092,6 +1097,502 @@ static void bpf_core_dump_spec(int level, const struct bpf_core_spec *spec)
 	}
 }
 
+struct btf_reloc_member {
+	struct btf_member *member;
+	int idx;
+};
+
+struct btf_reloc_type {
+	struct btf_type *type;
+	unsigned int id;
+
+	struct hashmap *members;
+};
+
+struct btf_reloc_info {
+	struct hashmap *types;
+	struct hashmap *ids_map;
+
+	struct btf *src_btf;
+};
+
+static size_t bpf_reloc_info_hash_fn(const void *key, void *ctx)
+{
+	return (size_t)key;
+}
+
+static bool bpf_reloc_info_equal_fn(const void *k1, const void *k2, void *ctx)
+{
+	return k1 == k2;
+}
+
+static void *uint_as_hash_key(int x)
+{
+	return (void *)(uintptr_t)x;
+}
+
+struct btf_reloc_info *bpf_reloc_info__new(const char *targ_btf_path)
+{
+	struct btf_reloc_info *info;
+	struct btf *src_btf;
+	struct hashmap *ids_map;
+	struct hashmap *types;
+
+	info = calloc(1, sizeof(*info));
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	src_btf = btf__parse(targ_btf_path, NULL);
+	if (libbpf_get_error(src_btf)) {
+		bpf_reloc_info__free(info);
+		return (void *) src_btf;
+	}
+
+	info->src_btf = src_btf;
+
+	ids_map = hashmap__new(bpf_reloc_info_hash_fn, bpf_reloc_info_equal_fn, NULL);
+	if (IS_ERR(ids_map)) {
+		bpf_reloc_info__free(info);
+		return (void *) ids_map;
+	}
+
+	info->ids_map = ids_map;
+
+	types = hashmap__new(bpf_reloc_info_hash_fn, bpf_reloc_info_equal_fn, NULL);
+	if (IS_ERR(types)) {
+		bpf_reloc_info__free(info);
+		return (void *) types;
+	}
+
+	info->types = types;
+
+	return info;
+}
+
+static void bpf_reloc_type_free(struct btf_reloc_type *type)
+{
+	struct hashmap_entry *entry;
+	int i;
+
+	if (IS_ERR_OR_NULL(type))
+		return;
+
+	if (!IS_ERR_OR_NULL(type->members)) {
+		hashmap__for_each_entry(type->members, entry, i) {
+			free(entry->value);
+		}
+		hashmap__free(type->members);
+	}
+
+	free(type);
+}
+
+void bpf_reloc_info__free(struct btf_reloc_info *info)
+{
+	struct hashmap_entry *entry;
+	int i;
+
+	if (!info)
+		return;
+
+	btf__free(info->src_btf);
+
+	hashmap__free(info->ids_map);
+
+	if (!IS_ERR_OR_NULL(info->types)) {
+		hashmap__for_each_entry(info->types, entry, i) {
+			bpf_reloc_type_free(entry->value);
+		}
+		hashmap__free(info->types);
+	}
+
+	free(info);
+}
+
+/* Return id for type in new btf instance */
+static unsigned int btf_reloc_id_get(struct btf_reloc_info *info, unsigned int old)
+{
+	uintptr_t new = 0;
+
+	/* deal with BTF_KIND_VOID */
+	if (old == 0)
+		return 0;
+
+	if (!hashmap__find(info->ids_map, uint_as_hash_key(old), (void **)&new)) {
+		/* return id for void as it's possible that the ID we're looking for is
+		 * the type of a pointer that we're not adding.
+		 */
+		return 0;
+	}
+
+	return (unsigned int)(uintptr_t)new;
+}
+
+/* Add new id map to the list of mappings */
+static int btf_reloc_id_add(struct btf_reloc_info *info, unsigned int old, unsigned int new)
+{
+	return hashmap__add(info->ids_map, uint_as_hash_key(old), uint_as_hash_key(new));
+}
+
+/*
+ * Put type in the list. If the type already exists it's returned, otherwise a
+ * new one is created and added to the list. This is called recursively adding
+ * all the types that are needed for the current one.
+ */
+static struct btf_reloc_type *btf_reloc_put_type(struct btf *btf,
+						 struct btf_reloc_info *info,
+						 struct btf_type *btf_type,
+						 unsigned int id)
+{
+	struct btf_reloc_type *reloc_type, *tmp;
+	struct btf_array *array;
+	unsigned int child_id;
+	int err;
+
+	/* check if we already have this type */
+	if (hashmap__find(info->types, uint_as_hash_key(id), (void **)&reloc_type))
+		return reloc_type;
+
+	/* do nothing. void is implicit in BTF */
+	if (id == 0)
+		return NULL;
+
+	reloc_type = calloc(1, sizeof(*reloc_type));
+	if (!reloc_type)
+		return ERR_PTR(-ENOMEM);
+
+	reloc_type->type = btf_type;
+	reloc_type->id = id;
+
+	/* append this type to the relocation type's list before anything else */
+	err = hashmap__add(info->types, uint_as_hash_key(reloc_type->id), reloc_type);
+	if (err)
+		return ERR_PTR(err);
+
+	/* complex types might need further processing */
+	switch (btf_kind(reloc_type->type)) {
+	/* already processed */
+	case BTF_KIND_UNKN:
+	case BTF_KIND_INT:
+	case BTF_KIND_FLOAT:
+	/* processed by callee */
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+	/* doesn't need resolution. If the data of the pointer is used
+	 * then it'll added by the caller in another relocation.
+	 */
+	case BTF_KIND_PTR:
+		break;
+	/* needs resolution */
+	case BTF_KIND_CONST:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_TYPEDEF:
+		child_id = btf_type->type;
+		btf_type = (struct btf_type *) btf__type_by_id(btf, child_id);
+		if (!btf_type)
+			return ERR_PTR(-EINVAL);
+
+		tmp = btf_reloc_put_type(btf, info, btf_type, child_id);
+		if (IS_ERR(tmp))
+			return tmp;
+		break;
+	/* needs resolution */
+	case BTF_KIND_ARRAY:
+		array = btf_array(reloc_type->type);
+
+		/* add type for array type */
+		btf_type = (struct btf_type *) btf__type_by_id(btf, array->type);
+		tmp = btf_reloc_put_type(btf, info, btf_type, array->type);
+		if (IS_ERR(tmp))
+			return tmp;
+
+		/* add type for array's index type */
+		btf_type = (struct btf_type *) btf__type_by_id(btf, array->index_type);
+		tmp = btf_reloc_put_type(btf, info, btf_type, array->index_type);
+		if (IS_ERR(tmp))
+			return tmp;
+
+		break;
+	/* tells if some other type needs to be handled */
+	default:
+		pr_warn("unsupported relocation: %s\n", btf_kind_str(reloc_type->type));
+		return ERR_PTR(-EINVAL);
+	}
+
+	return reloc_type;
+}
+
+/* Return pointer to btf_reloc_type by id */
+static struct btf_reloc_type *btf_reloc_get_type(struct btf_reloc_info *info, int id)
+{
+	struct btf_reloc_type *type = NULL;
+
+	if (!hashmap__find(info->types, uint_as_hash_key(id), (void **)&type))
+		return ERR_PTR(-ENOENT);
+
+	return type;
+}
+
+static int bpf_reloc_type_add_member(struct btf_reloc_info *info,
+				     struct btf_reloc_type *reloc_type,
+				     struct btf_member *btf_member, int idx)
+{
+	int err;
+	struct btf_reloc_member *reloc_member;
+
+	/* create new members hashmap for this relocation type if needed */
+	if (reloc_type->members == NULL) {
+		struct hashmap *tmp = hashmap__new(bpf_reloc_info_hash_fn,
+						   bpf_reloc_info_equal_fn,
+						   NULL);
+		if (IS_ERR(tmp))
+			return PTR_ERR(tmp);
+
+		reloc_type->members = tmp;
+	}
+	/* add given btf_member as a member of the parent relocation_type's type */
+	reloc_member = calloc(1, sizeof(*reloc_member));
+	if (!reloc_member)
+		return -ENOMEM;
+	reloc_member->member = btf_member;
+	reloc_member->idx = idx;
+	/* add given btf_member as member to given relocation type */
+	err = hashmap__add(reloc_type->members, uint_as_hash_key(reloc_member->idx), reloc_member);
+	if (err) {
+		free(reloc_member);
+		if (err != -EEXIST)
+			return err;
+	}
+
+	return 0;
+}
+
+struct btf *bpf_reloc_info__get_btf(struct btf_reloc_info *info)
+{
+	struct btf_dedup_opts dedup_opts = {};
+	struct hashmap_entry *entry;
+	struct btf *btf_new;
+	int err, i;
+
+	btf_new = btf__new_empty();
+	if (IS_ERR(btf_new)) {
+		pr_warn("failed to allocate btf structure\n");
+		return btf_new;
+	}
+
+	/* first pass: add all types and add their new ids to the ids map */
+	hashmap__for_each_entry(info->types, entry, i) {
+		struct btf_reloc_type *reloc_type = entry->value;
+		struct btf_type *btf_type = reloc_type->type;
+		int new_id;
+
+		/* add members for struct and union */
+		if (btf_is_struct(btf_type) || btf_is_union(btf_type)) {
+			struct hashmap_entry *member_entry;
+			struct btf_type *btf_type_cpy;
+			int nmembers, bkt, index;
+			size_t new_size;
+
+			nmembers = reloc_type->members ? hashmap__size(reloc_type->members) : 0;
+			new_size = sizeof(struct btf_type) + nmembers * sizeof(struct btf_member);
+
+			btf_type_cpy = malloc(new_size);
+			if (!btf_type_cpy) {
+				err = -ENOMEM;
+				goto out;
+			}
+
+			/* copy header */
+			memcpy(btf_type_cpy, btf_type, sizeof(*btf_type_cpy));
+
+			/* copy only members that are needed */
+			index = 0;
+			if (nmembers > 0) {
+				hashmap__for_each_entry(reloc_type->members, member_entry, bkt) {
+					struct btf_reloc_member *reloc_member;
+					struct btf_member *btf_member;
+
+					reloc_member = member_entry->value;
+					btf_member = btf_members(btf_type) + reloc_member->idx;
+
+					memcpy(btf_members(btf_type_cpy) + index, btf_member,
+					       sizeof(struct btf_member));
+
+					index++;
+				}
+			}
+
+			/* set new vlen */
+			btf_type_cpy->info = btf_type_info(btf_kind(btf_type_cpy), nmembers,
+							   btf_kflag(btf_type_cpy));
+
+			err = btf__add_type(btf_new, info->src_btf, btf_type_cpy);
+			free(btf_type_cpy);
+		} else {
+			err = btf__add_type(btf_new, info->src_btf, btf_type);
+		}
+
+		if (err < 0)
+			goto out;
+
+		new_id = err;
+
+		/* add ID mapping */
+		err = btf_reloc_id_add(info, reloc_type->id, new_id);
+		if (err)
+			goto out;
+	}
+
+	/* second pass: fix up type ids */
+	for (i = 0; i <= btf__get_nr_types(btf_new); i++) {
+		struct btf_member *btf_member;
+		struct btf_type *btf_type;
+		struct btf_param *params;
+		struct btf_array *array;
+
+		btf_type = (struct btf_type *) btf__type_by_id(btf_new, i);
+
+		switch (btf_kind(btf_type)) {
+		case BTF_KIND_STRUCT:
+		case BTF_KIND_UNION:
+			for (int idx = 0; idx < btf_vlen(btf_type); idx++) {
+				btf_member = btf_members(btf_type) + idx;
+				btf_member->type = btf_reloc_id_get(info, btf_member->type);
+			}
+			break;
+		case BTF_KIND_PTR:
+		case BTF_KIND_TYPEDEF:
+		case BTF_KIND_VOLATILE:
+		case BTF_KIND_CONST:
+		case BTF_KIND_RESTRICT:
+		case BTF_KIND_FUNC:
+		case BTF_KIND_VAR:
+			btf_type->type = btf_reloc_id_get(info, btf_type->type);
+			break;
+		case BTF_KIND_ARRAY:
+			array = btf_array(btf_type);
+			array->index_type = btf_reloc_id_get(info, array->index_type);
+			array->type = btf_reloc_id_get(info, array->type);
+			break;
+		case BTF_KIND_FUNC_PROTO:
+			btf_type->type = btf_reloc_id_get(info, btf_type->type);
+			params = btf_params(btf_type);
+			for (i = 0; i < btf_vlen(btf_type); i++)
+				params[i].type = btf_reloc_id_get(info, params[i].type);
+			break;
+		default:
+			break;
+		}
+	}
+
+	/* deduplicate generated BTF */
+	err = btf__dedup(btf_new, NULL, &dedup_opts);
+	if (err) {
+		pr_warn("error calling btf__dedup()\n");
+		goto out;
+	}
+
+	return btf_new;
+
+out:
+	btf__free(btf_new);
+	return ERR_PTR(err);
+}
+
+struct btf *bpf_reloc_info_get_src_btf(struct btf_reloc_info *info)
+{
+	return info->src_btf;
+}
+
+static int btf_reloc_info_gen_field(struct btf_reloc_info *info, struct bpf_core_spec *targ_spec)
+{
+	struct btf *btf = (struct btf *) targ_spec->btf;
+	struct btf_reloc_type *reloc_type;
+	struct btf_member *btf_member;
+	struct btf_type *btf_type;
+	struct btf_array *array;
+	unsigned int id;
+	int idx, err;
+
+	btf_type = btf_type_by_id(btf, targ_spec->root_type_id);
+
+	/* create reloc type for root type */
+	reloc_type = btf_reloc_put_type(btf, info, btf_type, targ_spec->root_type_id);
+	if (IS_ERR(reloc_type))
+		return PTR_ERR(reloc_type);
+
+	/* add types for complex types (arrays, unions, structures) */
+	for (int i = 1; i < targ_spec->raw_len; i++) {
+
+		/* skip typedefs and mods. */
+		while (btf_is_mod(btf_type) || btf_is_typedef(btf_type)) {
+			id = btf_type->type;
+			reloc_type = btf_reloc_get_type(info, id);
+			if (IS_ERR(reloc_type))
+				return PTR_ERR(reloc_type);
+			btf_type = (struct btf_type *) btf__type_by_id(btf, id);
+		}
+
+		switch (btf_kind(btf_type)) {
+		case BTF_KIND_STRUCT:
+		case BTF_KIND_UNION:
+			idx = targ_spec->raw_spec[i];
+			btf_member = btf_members(btf_type) + idx;
+			btf_type = btf_type_by_id(btf, btf_member->type);
+
+			/* add member to relocation type */
+			err = bpf_reloc_type_add_member(info, reloc_type, btf_member, idx);
+			if (err)
+				return err;
+			/* add relocation type */
+			reloc_type = btf_reloc_put_type(btf, info, btf_type, btf_member->type);
+			if (IS_ERR(reloc_type))
+				return PTR_ERR(reloc_type);
+			break;
+		case BTF_KIND_ARRAY:
+			array = btf_array(btf_type);
+			reloc_type = btf_reloc_get_type(info, array->type);
+			if (IS_ERR(reloc_type))
+				return PTR_ERR(reloc_type);
+			btf_type = (struct btf_type *) btf__type_by_id(btf, array->type);
+			break;
+		default:
+			pr_warn("spec type wasn't handled: %s\n", btf_kind_str(btf_type));
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int btf_reloc_info_gen_type(struct btf_reloc_info *info, struct bpf_core_spec *targ_spec)
+{
+	pr_warn("untreated type based relocation\n");
+	return -EOPNOTSUPP;
+}
+
+static int btf_reloc_info_gen_enumval(struct btf_reloc_info *info, struct bpf_core_spec *targ_spec)
+{
+	pr_warn("untreated enumval based relocation\n");
+	return -EOPNOTSUPP;
+}
+
+static int btf_reloc_info_gen(struct btf_reloc_info *info, struct bpf_core_relo_res *res)
+{
+	struct bpf_core_spec *spec = (struct bpf_core_spec *) res->targ_spec;
+
+	if (core_relo_is_type_based(spec->relo_kind))
+		return btf_reloc_info_gen_type(info, spec);
+
+	if (core_relo_is_enumval_based(spec->relo_kind))
+		return btf_reloc_info_gen_enumval(info, spec);
+
+	if (core_relo_is_field_based(spec->relo_kind))
+		return btf_reloc_info_gen_field(info, spec);
+
+	return -EINVAL;
+}
+
 /*
  * CO-RE relocate single instruction.
  *
@@ -1147,10 +1648,11 @@ int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
 			     const struct bpf_core_relo *relo,
 			     int relo_idx,
 			     const struct btf *local_btf,
-			     struct bpf_core_cand_list *cands)
+			     struct bpf_core_cand_list *cands,
+			     struct btf_reloc_info *reloc_info)
 {
 	struct bpf_core_spec local_spec, cand_spec, targ_spec = {};
-	struct bpf_core_relo_res cand_res, targ_res;
+	struct bpf_core_relo_res cand_res, targ_res = { .targ_spec = NULL };
 	const struct btf_type *local_type;
 	const char *local_name;
 	__u32 local_id;
@@ -1283,6 +1785,14 @@ int bpf_core_apply_relo_insn(const char *prog_name, struct bpf_insn *insn,
 	}
 
 patch_insn:
+	if (reloc_info && targ_res.targ_spec) {
+		err = btf_reloc_info_gen(reloc_info, &targ_res);
+		if (err)
+			pr_warn("error to generate BTF info\n");
+
+		return err;
+	}
+
 	/* bpf_core_patch_insn() should know how to handle missing targ_spec */
 	err = bpf_core_patch_insn(prog_name, insn, insn_idx, relo, relo_idx, &targ_res);
 	if (err) {
diff --git a/tools/lib/bpf/relo_core.h b/tools/lib/bpf/relo_core.h
index 3b9f8f18346c..ad29150f20f8 100644
--- a/tools/lib/bpf/relo_core.h
+++ b/tools/lib/bpf/relo_core.h
@@ -88,11 +88,20 @@ struct bpf_core_cand_list {
 	int len;
 };
 
+struct btf_reloc_info;
+
+LIBBPF_API struct btf_reloc_info *bpf_reloc_info__new(const char *targ_btf_path);
+LIBBPF_API void bpf_reloc_info__free(struct btf_reloc_info *info);
+LIBBPF_API struct btf *bpf_reloc_info__get_btf(struct btf_reloc_info *info);
+
+struct btf *bpf_reloc_info_get_src_btf(struct btf_reloc_info *info);
+
 int bpf_core_apply_relo_insn(const char *prog_name,
 			     struct bpf_insn *insn, int insn_idx,
 			     const struct bpf_core_relo *relo, int relo_idx,
 			     const struct btf *local_btf,
-			     struct bpf_core_cand_list *cands);
+			     struct bpf_core_cand_list *cands,
+			     struct btf_reloc_info *reloc_info);
 int bpf_core_types_are_compat(const struct btf *local_btf, __u32 local_id,
 			      const struct btf *targ_btf, __u32 targ_id);
 
-- 
2.25.1

