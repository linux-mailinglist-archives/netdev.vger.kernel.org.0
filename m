Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C49479479
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240463AbhLQS5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240436AbhLQS5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 13:57:14 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C127BC061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 10:57:13 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id a14so6223262uak.0
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 10:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G/GPdGidHC8T+01PfwI96dDour/nMEcpbiFscAB6RZk=;
        b=ldG2wmGTsC0IsQbXLV75KjDjU2nI05gt5lS4fyW6BCZa6ZdyV8QkULXp2V2XTs2CeL
         Ygfi9AebTI/M+ZGPcPHaxNWipg3XvjsXXwQRCxnmdqBORgbinnrWO+gWXvh20hwJq+M4
         XSOfz3oLasFd0KkdR0Me1xvAOvSfTk/7XXimY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G/GPdGidHC8T+01PfwI96dDour/nMEcpbiFscAB6RZk=;
        b=vybDyhor3O6FWeyiSIhOGBWwDpOHprlrjLqDSxOViS89swbmcVkdtmJy2aLC5OXPJw
         8CLtcwj9CsLclKUh6zRzd2fplrw2KIA0vhdW5qujiYIh6+cbh4NAqd3h0RX7vv0ziCzi
         JLIzdKxdLK7NFdBg6rvOapO71I6n0vK3oQdndGcfbL3XC3M95dy/2zUWoMs8e+y4yFJx
         QzTeUOSnYuScDoSRoVtugcUbjblHS+zGlsOQ55X3Yl3hXBP+xd0hwLCWvC7cnHrK/O9d
         uJ7Iqzg67Pzsex7kk03dK5aEtc0UPlToUrbeW+omN2JiUHjzEutHAGrU0rBmRvPWmCSA
         eVsA==
X-Gm-Message-State: AOAM53073NYhDq/GU6x5M+qLiKoaFpJO0A5sFpXfmXsD2lj9sBRGUYy4
        dXl1M8ORjpw/DM36PDPoTs7AB+xC5nqFJr2+04fmYKkny2S5ly+HdU0T2j69nyvy5kov4+SEjpI
        OPoynJdb5IpaAhG4jd6NLh7bDngXWmQfakKvWCvxYC3aK/t7hZOpQ1kQGgD0m6zLWfE+pRQ==
X-Google-Smtp-Source: ABdhPJy6eOEgpQDvtHjJrD3+3Dh2FYOB2qKk4GKQlaM5LYcwBKS1Qld6HxCtPylq4JjbkpbRPXEnHw==
X-Received: by 2002:a05:6102:3554:: with SMTP id e20mr1636059vss.50.1639767427868;
        Fri, 17 Dec 2021 10:57:07 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id l125sm1382575vke.40.2021.12.17.10.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 10:57:06 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v3 3/3] bpftool: Implement btfgen
Date:   Fri, 17 Dec 2021 13:56:54 -0500
Message-Id: <20211217185654.311609-4-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211217185654.311609-1-mauricio@kinvolk.io>
References: <20211217185654.311609-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BTFGen's goal is to produce a BTF file that contains **only** the
information that is needed by an eBPF program. This algorithm does a
first step collecting the types involved for each relocation present on
the object and "marking" them as needed. Types are collected in
different ways according to the type relocation, for field based
relocations only the union and structures members involved are
considered, for type based relocations the whole types are added, enum
field relocations are not supported in this iteration yet.

A second step generates a BTF file from the "marked" types. This step
accesses the original BTF file extracting the types and their members
that were "marked" as needed in the first step.

This command is implemented under the "gen" command in bpftool and the
syntax is the following:

$ bpftool gen btf INPUT OUTPUT OBJECT(S)

INPUT can be either a single BTF file or a folder containing BTF files,
when it's a folder, a BTF file is generated for each BTF file contained
in this folder. OUTPUT is the file (or folder) where generated files are
stored and OBJECT(S) is the list of bpf objects we want to generate the
BTF file(s) for (each generated BTF file contains all the types needed
by all the objects).

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/bpf/bpftool/gen.c | 892 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 892 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index b4695df2ea3d..2794fe88f609 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -5,6 +5,7 @@
 #define _GNU_SOURCE
 #endif
 #include <ctype.h>
+#include <dirent.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <linux/err.h>
@@ -14,6 +15,7 @@
 #include <unistd.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
+#include <bpf/libbpf_internal.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
@@ -1084,6 +1086,7 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %1$s %2$s object OUTPUT_FILE INPUT_FILE [INPUT_FILE...]\n"
 		"       %1$s %2$s skeleton FILE [name OBJECT_NAME]\n"
+		"       %1$s %2$s btf INPUT OUTPUT OBJECT(S)\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_OPTIONS " |\n"
@@ -1094,9 +1097,898 @@ static int do_help(int argc, char **argv)
 	return 0;
 }
 
+static int btf_save_raw(const struct btf *btf, const char *path)
+{
+	const void *data;
+	FILE *f = NULL;
+	__u32 data_sz;
+	int err = 0;
+
+	data = btf__raw_data(btf, &data_sz);
+	if (!data) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	f = fopen(path, "wb");
+	if (!f) {
+		err = -errno;
+		goto out;
+	}
+
+	if (fwrite(data, 1, data_sz, f) != data_sz) {
+		err = -errno;
+		goto out;
+	}
+
+out:
+	if (f)
+		fclose(f);
+	return libbpf_err(err);
+}
+
+struct btf_reloc_member {
+	struct btf_member *member;
+	int idx;
+};
+
+struct btf_reloc_type {
+	struct btf_type *type;
+	unsigned int id;
+	bool added_by_all;
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
+static void bpf_reloc_type_free(struct btf_reloc_type *type)
+{
+	struct hashmap_entry *entry;
+	size_t bkt;
+
+	if (IS_ERR_OR_NULL(type))
+		return;
+
+	if (!IS_ERR_OR_NULL(type->members)) {
+		hashmap__for_each_entry(type->members, entry, bkt) {
+			free(entry->value);
+		}
+		hashmap__free(type->members);
+	}
+
+	free(type);
+}
+
+static void btfgen_reloc_info_free(struct btf_reloc_info *info)
+{
+	struct hashmap_entry *entry;
+	size_t bkt;
+
+	if (!info)
+		return;
+
+	hashmap__free(info->ids_map);
+
+	if (!IS_ERR_OR_NULL(info->types)) {
+		hashmap__for_each_entry(info->types, entry, bkt) {
+			bpf_reloc_type_free(entry->value);
+		}
+		hashmap__free(info->types);
+	}
+
+	btf__free(info->src_btf);
+
+	free(info);
+}
+
+static struct btf_reloc_info *
+btfgen_reloc_info_new(const char *targ_btf_path)
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
+		btfgen_reloc_info_free(info);
+		return (void *) src_btf;
+	}
+
+	info->src_btf = src_btf;
+
+	ids_map = hashmap__new(bpf_reloc_info_hash_fn, bpf_reloc_info_equal_fn, NULL);
+	if (IS_ERR(ids_map)) {
+		btfgen_reloc_info_free(info);
+		return (void *) ids_map;
+	}
+
+	info->ids_map = ids_map;
+
+	types = hashmap__new(bpf_reloc_info_hash_fn, bpf_reloc_info_equal_fn, NULL);
+	if (IS_ERR(types)) {
+		btfgen_reloc_info_free(info);
+		return (void *) types;
+	}
+
+	info->types = types;
+
+	return info;
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
+	if (hashmap__find(info->types, uint_as_hash_key(id), (void **) &reloc_type))
+		return reloc_type;
+
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
+		p_err("unsupported relocation: %d", reloc_type->id);
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
+	struct btf_reloc_member *reloc_member;
+	int err;
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
+/*
+ * Same as btf_reloc_put_type, but adding all fields, from given complex type, recursively
+ */
+static int btf_reloc_put_type_all(struct btf *btf,
+				  struct btf_reloc_info *info,
+				  struct btf_type *btf_type,
+				  unsigned int id)
+{
+	struct btf_reloc_type *reloc_type;
+	struct btf_array *array;
+	unsigned int child_id;
+	struct btf_member *m;
+	int err, i, n;
+
+	if (id == 0)
+		return 0;
+
+	if (!hashmap__find(info->types, uint_as_hash_key(id), (void **) &reloc_type)) {
+		reloc_type = calloc(1, sizeof(*reloc_type));
+		if (!reloc_type)
+			return -ENOMEM;
+
+		reloc_type->type = btf_type;
+		reloc_type->id = id;
+		/* avoid infinite recursion and yet be able to add all
+		 * fields/members for types also managed by this function twin
+		 * brother btf_reloc_put_type()
+		 */
+		reloc_type->added_by_all = true;
+
+		err = hashmap__add(info->types, uint_as_hash_key(reloc_type->id), reloc_type);
+		if (err)
+			return err;
+	} else {
+		if (reloc_type->added_by_all)
+			return 0;
+
+		reloc_type->added_by_all = true;
+	}
+
+	switch (btf_kind(reloc_type->type)) {
+	case BTF_KIND_UNKN:
+	case BTF_KIND_INT:
+	case BTF_KIND_FLOAT:
+	case BTF_KIND_ENUM:
+		/* not a complex type, already solved */
+		break;
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		n = btf_vlen(btf_type);
+		m = btf_members(btf_type);
+		for (i = 0; i < n; i++, m++) {
+			btf_type = (struct btf_type *) btf__type_by_id(btf, m->type);
+			if (!btf_type)
+				return -EINVAL;
+
+			/* add all member types */
+			err = btf_reloc_put_type_all(btf, info, btf_type, m->type);
+			if (err)
+				return err;
+
+			/* add all members */
+			err = bpf_reloc_type_add_member(info, reloc_type, m, i);
+			if (err)
+				return err;
+		}
+		break;
+	case BTF_KIND_PTR:
+	case BTF_KIND_CONST:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_TYPEDEF:
+		/* modifier types */
+		child_id = btf_type->type;
+		btf_type = (struct btf_type *) btf__type_by_id(btf, child_id);
+		if (!btf_type)
+			return -EINVAL;
+
+		err = btf_reloc_put_type_all(btf, info, btf_type, child_id);
+		if (err)
+			return err;
+		break;
+	case BTF_KIND_ARRAY:
+		array = btf_array(btf_type);
+
+		/* add array member type */
+		btf_type = (struct btf_type *) btf__type_by_id(btf, array->type);
+		if (!btf_type)
+			return -EINVAL;
+		err = btf_reloc_put_type_all(btf, info, btf_type, array->type);
+		if (err)
+			return err;
+
+		/* add array index type */
+		btf_type = (struct btf_type *) btf__type_by_id(btf, array->index_type);
+		if (!btf_type)
+			return -EINVAL;
+		err = btf_reloc_put_type_all(btf, info, btf_type, array->type);
+		if (err)
+			return err;
+		break;
+	default:
+		p_err("unsupported kind (all): %s (%d)",
+		      btf_kind_str(reloc_type->type), reloc_type->id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int btf_reloc_info_gen_field(struct btf_reloc_info *info, struct bpf_core_spec *targ_spec)
+{
+	struct btf *btf = (struct btf *) info->src_btf;
+	struct btf_reloc_type *reloc_type;
+	struct btf_member *btf_member;
+	struct btf_type *btf_type;
+	struct btf_array *array;
+	unsigned int id;
+	int idx, err;
+
+	btf_type = (struct btf_type *) btf__type_by_id(btf, targ_spec->root_type_id);
+
+	/* create reloc type for root type */
+	reloc_type = btf_reloc_put_type(btf, info, btf_type, targ_spec->root_type_id);
+	if (IS_ERR(reloc_type))
+		return PTR_ERR(reloc_type);
+
+	/* add types for complex types (arrays, unions, structures) */
+	for (int i = 1; i < targ_spec->raw_len; i++) {
+		/* skip typedefs and mods */
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
+			btf_type =  (struct btf_type *) btf__type_by_id(btf, btf_member->type);
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
+			p_err("spec type wasn't handled");
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+static int btf_reloc_info_gen_type(struct btf_reloc_info *info, struct bpf_core_spec *targ_spec)
+{
+	struct btf *btf = (struct btf *) info->src_btf;
+	struct btf_type *btf_type;
+	int err = 0;
+
+	btf_type = (struct btf_type *) btf__type_by_id(btf, targ_spec->root_type_id);
+
+	return btf_reloc_put_type_all(btf, info, btf_type, targ_spec->root_type_id);
+}
+
+static int btf_reloc_info_gen_enumval(struct btf_reloc_info *info, struct bpf_core_spec *targ_spec)
+{
+	p_err("untreated enumval based relocation");
+	return -EOPNOTSUPP;
+}
+
+static int btf_reloc_info_gen(struct btf_reloc_info *info, struct bpf_core_spec *res)
+{
+	if (core_relo_is_type_based(res->relo_kind))
+		return btf_reloc_info_gen_type(info, res);
+
+	if (core_relo_is_enumval_based(res->relo_kind))
+		return btf_reloc_info_gen_enumval(info, res);
+
+	if (core_relo_is_field_based(res->relo_kind))
+		return btf_reloc_info_gen_field(info, res);
+
+	return -EINVAL;
+}
+
+#define BPF_INSN_SZ (sizeof(struct bpf_insn))
+
+static int btfgen_obj_reloc_info_gen(struct btf_reloc_info *reloc_info, struct bpf_object *obj)
+{
+	const struct btf_ext_info_sec *sec;
+	const struct bpf_core_relo *rec;
+	const struct btf_ext_info *seg;
+	struct hashmap *cand_cache;
+	int err, insn_idx, sec_idx;
+	struct bpf_program *prog;
+	struct btf_ext *btf_ext;
+	const char *sec_name;
+	size_t nr_programs;
+	struct btf *btf;
+	unsigned int i;
+
+	btf = bpf_object__btf(obj);
+	btf_ext = bpf_object__btf_ext(obj);
+
+	if (btf_ext->core_relo_info.len == 0)
+		return 0;
+
+	cand_cache = bpf_core_create_cand_cache();
+	if (IS_ERR(cand_cache))
+		return PTR_ERR(cand_cache);
+
+	bpf_object_set_vmlinux_override(obj, reloc_info->src_btf);
+
+	seg = &btf_ext->core_relo_info;
+	for_each_btf_ext_sec(seg, sec) {
+		bool prog_found;
+
+		sec_name = btf__name_by_offset(btf, sec->sec_name_off);
+		if (str_is_empty(sec_name)) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		prog_found = false;
+		nr_programs = bpf_object__get_nr_programs(obj);
+		for (i = 0; i < nr_programs; i++)	{
+			prog = bpf_object__get_program(obj, i);
+			if (strcmp(bpf_program__section_name(prog), sec_name) == 0) {
+				prog_found = true;
+				break;
+			}
+		}
+
+		if (!prog_found) {
+			pr_warn("sec '%s': failed to find a BPF program\n", sec_name);
+			err = -EINVAL;
+			goto out;
+		}
+
+		sec_idx = bpf_program__sec_idx(prog);
+
+		for_each_btf_ext_rec(seg, sec, i, rec) {
+			struct bpf_core_relo_res targ_res;
+			struct bpf_core_spec targ_spec;
+
+			insn_idx = rec->insn_off / BPF_INSN_SZ;
+
+			prog = find_prog_by_sec_insn(obj, sec_idx, insn_idx);
+			if (!prog) {
+				pr_warn("sec '%s': failed to find program at insn #%d for CO-RE offset relocation #%d\n",
+					sec_name, insn_idx, i);
+				err = -EINVAL;
+				goto out;
+			}
+
+			err = bpf_core_calc_relo_res(prog, rec, i, btf, cand_cache, &targ_res,
+						     &targ_spec);
+			if (err)
+				goto out;
+
+			err = btf_reloc_info_gen(reloc_info, &targ_spec);
+			if (err)
+				goto out;
+		}
+	}
+
+out:
+	bpf_core_free_cand_cache(cand_cache);
+
+	return err;
+}
+
+static struct btf *btfgen_reloc_info_get_btf(struct btf_reloc_info *info)
+{
+	struct hashmap_entry *entry;
+	struct btf *btf_new;
+	size_t bkt;
+	int err;
+
+	btf_new = btf__new_empty();
+	if (IS_ERR(btf_new)) {
+		p_err("failed to allocate btf structure");
+		return btf_new;
+	}
+
+	/* first pass: add all types and add their new ids to the ids map */
+	hashmap__for_each_entry(info->types, entry, bkt) {
+		struct btf_reloc_type *reloc_type = entry->value;
+		struct btf_type *btf_type = reloc_type->type;
+		int new_id;
+
+		/* add members for struct and union */
+		if (btf_is_struct(btf_type) || btf_is_union(btf_type)) {
+			struct hashmap_entry *member_entry;
+			struct btf_type *btf_type_cpy;
+			int nmembers, index;
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
+				size_t bkt2;
+
+				hashmap__for_each_entry(reloc_type->members, member_entry, bkt2) {
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
+	for (unsigned int i = 0; i < btf__type_cnt(btf_new); i++) {
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
+			for (unsigned short j = 0; j < btf_vlen(btf_type); j++) {
+				btf_member = btf_members(btf_type) + j;
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
+			for (unsigned short j = 0; j < btf_vlen(btf_type); j++)
+				params[j].type = btf_reloc_id_get(info, params[j].type);
+			break;
+		default:
+			break;
+		}
+	}
+
+	return btf_new;
+
+out:
+	btf__free(btf_new);
+	return ERR_PTR(err);
+}
+
+static int is_file(const char *path)
+{
+	struct stat st;
+
+	if (stat(path, &st) < 0)
+		return -1;
+
+	switch (st.st_mode & S_IFMT) {
+	case S_IFDIR:
+		return 0;
+	case S_IFREG:
+		return 1;
+	default:
+		return -1;
+	}
+
+	return -1;
+}
+
+static int generate_btf(const char *src_btf, const char *dst_btf, const char *objspaths[])
+{
+	struct btf_reloc_info *reloc_info;
+	struct btf *btf_new = NULL;
+	struct bpf_object *obj;
+	int err;
+
+	struct bpf_object_open_opts ops = {
+		.sz = sizeof(ops),
+		.btf_custom_path = src_btf,
+	};
+
+	reloc_info = btfgen_reloc_info_new(src_btf);
+	err = libbpf_get_error(reloc_info);
+	if (err) {
+		p_err("failed to allocate info structure");
+		goto out;
+	}
+
+	for (int i = 0; objspaths[i] != NULL; i++) {
+		printf("OBJ : %s\n", objspaths[i]);
+		obj = bpf_object__open_file(objspaths[i], &ops);
+		err = libbpf_get_error(obj);
+		if (err) {
+			p_err("error opening object: %s", strerror(errno));
+			goto out;
+		}
+
+		err = btfgen_obj_reloc_info_gen(reloc_info, obj);
+		if (err)
+			goto out;
+
+		bpf_object__close(obj);
+	}
+
+	btf_new = btfgen_reloc_info_get_btf(reloc_info);
+	err = libbpf_get_error(btf_new);
+	if (err) {
+		p_err("error generating btf: %s", strerror(errno));
+		goto out;
+	}
+
+	printf("DBTF: %s\n", dst_btf);
+	err = btf_save_raw(btf_new, dst_btf);
+	if (err) {
+		p_err("error saving btf file: %s", strerror(errno));
+		goto out;
+	}
+
+out:
+	if (!libbpf_get_error(btf_new))
+		btf__free(btf_new);
+	btfgen_reloc_info_free(reloc_info);
+
+	return err;
+}
+
+static int do_gen_btf(int argc, char **argv)
+{
+	char src_btf_path[PATH_MAX], dst_btf_path[PATH_MAX];
+	bool input_is_file, output_is_file = false;
+	const char *input, *output;
+	const char **objs = NULL;
+	struct dirent *dir;
+	DIR *d = NULL;
+	int i, err;
+
+	if (!REQ_ARGS(3)) {
+		usage();
+		return -1;
+	}
+
+	input = GET_ARG();
+	err = is_file(input);
+	if (err < 0) {
+		p_err("failed to stat %s: %s", input, strerror(errno));
+		return err;
+	}
+	input_is_file = err;
+
+	output = GET_ARG();
+	err = is_file(output);
+	if (err != 0)
+		output_is_file = true;
+
+	objs = (const char **) malloc((argc + 1) * sizeof(*objs));
+	if (!objs)
+		return -ENOMEM;
+
+	i = 0;
+	while (argc > 0)
+		objs[i++] = GET_ARG();
+
+	objs[i] = NULL;
+
+	// single BTF file
+	if (input_is_file) {
+		char *d_input;
+
+		printf("SBTF: %s\n", input);
+
+		if (output_is_file) {
+			err = generate_btf(input, output, objs);
+			goto out;
+		}
+		d_input = strdup(input);
+		snprintf(dst_btf_path, sizeof(dst_btf_path), "%s/%s", output,
+			 basename(d_input));
+		free(d_input);
+		err = generate_btf(input, dst_btf_path, objs);
+		goto out;
+	}
+
+	if (output_is_file) {
+		p_err("can't have just one file as output");
+		err = -EINVAL;
+		goto out;
+	}
+
+	// directory with BTF files
+	d = opendir(input);
+	if (!d) {
+		p_err("error opening input dir: %s", strerror(errno));
+		err = -errno;
+		goto out;
+	}
+
+	while ((dir = readdir(d)) != NULL) {
+		if (dir->d_type != DT_REG)
+			continue;
+
+		if (strncmp(dir->d_name + strlen(dir->d_name) - 4, ".btf", 4))
+			continue;
+
+		snprintf(src_btf_path, sizeof(src_btf_path), "%s/%s", input, dir->d_name);
+		snprintf(dst_btf_path, sizeof(dst_btf_path), "%s/%s", output, dir->d_name);
+
+		printf("SBTF: %s\n", src_btf_path);
+
+		err = generate_btf(src_btf_path, dst_btf_path, objs);
+		if (err)
+			goto out;
+	}
+
+out:
+	if (!err)
+		printf("STAT: done!\n");
+	free(objs);
+	closedir(d);
+	return err;
+}
+
 static const struct cmd cmds[] = {
 	{ "object",	do_object },
 	{ "skeleton",	do_skeleton },
+	{ "btf",	do_gen_btf},
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.25.1

