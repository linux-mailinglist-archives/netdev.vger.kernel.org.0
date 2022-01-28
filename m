Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAB24A03C2
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351736AbiA1Wdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351726AbiA1Wdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:33:45 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782C8C06173B
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:45 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id o10so6966143qkg.0
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qdSa3LM10WKHmDxPzwThGlIG5cR+9M6C4C6vs4RR7Dw=;
        b=dlL5CFyT1XQ8GsbHofdmL3fN8XDY0BkvTPCu6WFXlLRw5m2DhgoUJMJXt8ylab04Ht
         QJXWQyMGYH2xePcCr8LOtxQt1g2sKsTIGDhzfuSfho3i9w/gawtM7Gm9/7QkHaZv2VTQ
         6JAKhOdtyKdQKmetBtn/q0idRHrf4wsrBvOwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qdSa3LM10WKHmDxPzwThGlIG5cR+9M6C4C6vs4RR7Dw=;
        b=lpD5SxbsYp9D/G/mzomUk6WqM6L4viehUljKQreVcclizrNBqEYiQlczlBbdeK7Xsq
         W7AaY0zsnwlax6aJJrr8At3S/7nkhKXyxW0rfLSubmwnHGTfJDiyzOnd/ysxmayV/8zh
         Vp/w+WtpwgZOEgEzysql03TbF1eKyKB9TBYB4598UodkUQFs4qwPuz+IhSMilE3w5cM9
         gCoDpZ9f5heThOTXNkRetTabhBKXrHfpcMJzrg8aJMlKed3jfgF2rshG7UDDjPeezcHI
         QGDB5+uSys4busaJbq0WEB2L45y1TOpR1m7rgZSgyA2twt6ukmzUWR+XIEzXCX0nlLp+
         Rhlw==
X-Gm-Message-State: AOAM530tpkERXX0pDmc/AMe3hngRbvpHCKMRSlr9FXiueDuTE4liqL8o
        A3GJqetJjXwKdt5hvkEz2h92rJyK0Vkv+OIzU1bLu3X/jfCSbVN20t9ACMD76H1xdu87/3H9XHm
        ZCWTYTBo8laWJOUEvwl9bCSY+CPn5VbGPzD1RnRwEDUXD9mWSSghvZTvy9DToFDHswqW8Kw==
X-Google-Smtp-Source: ABdhPJwdny92Pt0EJOJX07Bu1cRjZbjmCcsqX8t/+FNgqh1XvTC8uJ9C042zeW5AauH5aU/LSxDwWA==
X-Received: by 2002:a37:ef0a:: with SMTP id j10mr7517546qkk.68.1643409221695;
        Fri, 28 Jan 2022 14:33:41 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id i18sm3723972qka.80.2022.01.28.14.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:33:41 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v5 6/9] bpftool: Implement relocations recording for BTFGen
Date:   Fri, 28 Jan 2022 17:33:09 -0500
Message-Id: <20220128223312.1253169-7-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220128223312.1253169-1-mauricio@kinvolk.io>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit implements the logic to record the relocation information
for the different kind of relocations.

btfgen_record_field_relo() uses the target specification to save all the
types that are involved in a field-based CO-RE relocation. In this case
types resolved and added recursively (using btfgen_put_type()).
Only the struct and union members and their types) involved in the
relocation are added to optimize the size of the generated BTF file.

On the other hand, btfgen_record_type_relo() saves the types involved in
a type-based CO-RE relocation. In this case all the members for the
struct and union types are added. This is not strictly required since
libbpf doesn't use them while performing this kind of relocation,
however that logic could change on the future. Additionally, we expect
that the number of this kind of relocations in an BPF object to be very
low, hence the impact on the size of the generated BTF should be
negligible.

Finally, btfgen_record_enumval_relo() saves the whole enum type for
enum-based relocations.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/bpf/bpftool/gen.c | 260 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 257 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index bb9c56401ee5..7413ec808a80 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1119,9 +1119,17 @@ static int btf_save_raw(const struct btf *btf, const char *path)
 	return err;
 }
 
+struct btfgen_member {
+	struct btf_member *member;
+	int idx;
+};
+
 struct btfgen_type {
 	struct btf_type *type;
 	unsigned int id;
+	bool all_members;
+
+	struct hashmap *members;
 };
 
 struct btfgen_info {
@@ -1151,6 +1159,19 @@ static void *u32_as_hash_key(__u32 x)
 
 static void btfgen_free_type(struct btfgen_type *type)
 {
+	struct hashmap_entry *entry;
+	size_t bkt;
+
+	if (!type)
+		return;
+
+	if (!IS_ERR_OR_NULL(type->members)) {
+		hashmap__for_each_entry(type->members, entry, bkt) {
+			free(entry->value);
+		}
+		hashmap__free(type->members);
+	}
+
 	free(type);
 }
 
@@ -1199,19 +1220,252 @@ btfgen_new_info(const char *targ_btf_path)
 	return info;
 }
 
+static int btfgen_add_member(struct btfgen_type *btfgen_type,
+			     struct btf_member *btf_member, int idx)
+{
+	struct btfgen_member *btfgen_member;
+	int err;
+
+	/* create new members hashmap for this btfgen type if needed */
+	if (!btfgen_type->members) {
+		btfgen_type->members = hashmap__new(btfgen_hash_fn, btfgen_equal_fn, NULL);
+		if (IS_ERR(btfgen_type->members))
+			return PTR_ERR(btfgen_type->members);
+	}
+
+	btfgen_member = calloc(1, sizeof(*btfgen_member));
+	if (!btfgen_member)
+		return -ENOMEM;
+	btfgen_member->member = btf_member;
+	btfgen_member->idx = idx;
+	/* add btf_member as member to given btfgen_type */
+	err = hashmap__add(btfgen_type->members, uint_as_hash_key(btfgen_member->idx),
+			   btfgen_member);
+	if (err) {
+		free(btfgen_member);
+		if (err != -EEXIST)
+			return err;
+	}
+
+	return 0;
+}
+
+static struct btfgen_type *btfgen_get_type(struct btfgen_info *info, int id)
+{
+	struct btfgen_type *type = NULL;
+
+	hashmap__find(info->types, uint_as_hash_key(id), (void **)&type);
+
+	return type;
+}
+
+static struct btfgen_type *
+_btfgen_put_type(struct btf *btf, struct btfgen_info *info, struct btf_type *btf_type,
+		 unsigned int id, bool all_members)
+{
+	struct btfgen_type *btfgen_type, *tmp;
+	struct btf_array *array;
+	unsigned int child_id;
+	struct btf_member *m;
+	int err, i, n;
+
+	/* check if we already have this type */
+	if (hashmap__find(info->types, uint_as_hash_key(id), (void **) &btfgen_type)) {
+		if (!all_members || btfgen_type->all_members)
+			return btfgen_type;
+	} else {
+		btfgen_type = calloc(1, sizeof(*btfgen_type));
+		if (!btfgen_type)
+			return NULL;
+
+		btfgen_type->type = btf_type;
+		btfgen_type->id = id;
+
+		/* append this type to the types list before anything else */
+		err = hashmap__add(info->types, uint_as_hash_key(btfgen_type->id), btfgen_type);
+		if (err) {
+			free(btfgen_type);
+			return NULL;
+		}
+	}
+
+	/* avoid infinite recursion and yet be able to add all
+	 * fields/members for types also managed by this function
+	 */
+	btfgen_type->all_members = all_members;
+
+	/* recursively add other types needed by it */
+	switch (btf_kind(btfgen_type->type)) {
+	case BTF_KIND_UNKN:
+	case BTF_KIND_INT:
+	case BTF_KIND_FLOAT:
+	case BTF_KIND_ENUM:
+		break;
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		/* doesn't need resolution if not adding all members */
+		if (!all_members)
+			break;
+
+		n = btf_vlen(btf_type);
+		m = btf_members(btf_type);
+		for (i = 0; i < n; i++, m++) {
+			btf_type = (struct btf_type *) btf__type_by_id(btf, m->type);
+
+			/* add all member types */
+			tmp = _btfgen_put_type(btf, info, btf_type, m->type, all_members);
+			if (!tmp)
+				return NULL;
+
+			/* add all members */
+			err = btfgen_add_member(btfgen_type, m, i);
+			if (err)
+				return NULL;
+		}
+		break;
+	case BTF_KIND_PTR:
+		if (!all_members)
+			break;
+	/* fall through */
+	/* Also add the type it's pointing to when adding all members */
+	case BTF_KIND_CONST:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_TYPEDEF:
+		child_id = btf_type->type;
+		btf_type = (struct btf_type *) btf__type_by_id(btf, child_id);
+
+		tmp = _btfgen_put_type(btf, info, btf_type, child_id, all_members);
+		if (!tmp)
+			return NULL;
+		break;
+	case BTF_KIND_ARRAY:
+		array = btf_array(btfgen_type->type);
+
+		/* add type for array type */
+		btf_type = (struct btf_type *) btf__type_by_id(btf, array->type);
+		tmp = _btfgen_put_type(btf, info, btf_type, array->type, all_members);
+		if (!tmp)
+			return NULL;
+
+		/* add type for array's index type */
+		btf_type = (struct btf_type *) btf__type_by_id(btf, array->index_type);
+		tmp = _btfgen_put_type(btf, info, btf_type, array->index_type, all_members);
+		if (!tmp)
+			return NULL;
+		break;
+	/* tells if some other type needs to be handled */
+	default:
+		p_err("unsupported kind: %s (%d)",
+		      btf_kind_str(btfgen_type->type), btfgen_type->id);
+		errno = EINVAL;
+		return NULL;
+	}
+
+	return btfgen_type;
+}
+
+/* Put type in the list. If the type already exists it's returned, otherwise a
+ * new one is created and added to the list. This is called recursively adding
+ * all the types that are needed for the current one.
+ */
+static struct btfgen_type *
+btfgen_put_type(struct btf *btf, struct btfgen_info *info, struct btf_type *btf_type,
+		unsigned int id)
+{
+	return _btfgen_put_type(btf, info, btf_type, id, false);
+}
+
+/* Same as btfgen_put_type, but adding all members, from given complex type, recursively */
+static struct btfgen_type *
+btfgen_put_type_all(struct btf *btf, struct btfgen_info *info,
+		    struct btf_type *btf_type, unsigned int id)
+{
+	return _btfgen_put_type(btf, info, btf_type, id, true);
+}
+
 static int btfgen_record_field_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
 {
-	return -EOPNOTSUPP;
+	struct btf *btf = (struct btf *) info->src_btf;
+	struct btfgen_type *btfgen_type;
+	struct btf_member *btf_member;
+	struct btf_type *btf_type;
+	struct btf_array *array;
+	unsigned int id;
+	int idx, err;
+
+	btf_type = (struct btf_type *) btf__type_by_id(btf, targ_spec->root_type_id);
+
+	/* create btfgen_type for root type */
+	btfgen_type = btfgen_put_type(btf, info, btf_type, targ_spec->root_type_id);
+	if (!btfgen_type)
+		return -errno;
+
+	/* add types for complex types (arrays, unions, structures) */
+	for (int i = 1; i < targ_spec->raw_len; i++) {
+		/* skip typedefs and mods */
+		while (btf_is_mod(btf_type) || btf_is_typedef(btf_type)) {
+			id = btf_type->type;
+			btfgen_type = btfgen_get_type(info, id);
+			if (!btfgen_type)
+				return -ENOENT;
+			btf_type = (struct btf_type *) btf__type_by_id(btf, id);
+		}
+
+		switch (btf_kind(btf_type)) {
+		case BTF_KIND_STRUCT:
+		case BTF_KIND_UNION:
+			idx = targ_spec->raw_spec[i];
+			btf_member = btf_members(btf_type) + idx;
+			btf_type = (struct btf_type *) btf__type_by_id(btf, btf_member->type);
+
+			/* add member to relocation type */
+			err = btfgen_add_member(btfgen_type, btf_member, idx);
+			if (err)
+				return err;
+			/* put btfgen type */
+			btfgen_type = btfgen_put_type(btf, info, btf_type, btf_member->type);
+			if (!btfgen_type)
+				return -errno;
+			break;
+		case BTF_KIND_ARRAY:
+			array = btf_array(btf_type);
+			btfgen_type = btfgen_get_type(info, array->type);
+			if (!btfgen_type)
+				return -ENOENT;
+			btf_type = (struct btf_type *) btf__type_by_id(btf, array->type);
+			break;
+		default:
+			p_err("unsupported kind: %s (%d)",
+			      btf_kind_str(btf_type), btf_type->type);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
 }
 
 static int btfgen_record_type_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
 {
-	return -EOPNOTSUPP;
+	struct btf *btf = (struct btf *) info->src_btf;
+	struct btfgen_type *btfgen_type;
+	struct btf_type *btf_type;
+
+	btf_type = (struct btf_type *) btf__type_by_id(btf, targ_spec->root_type_id);
+
+	btfgen_type = btfgen_put_type_all(btf, info, btf_type, targ_spec->root_type_id);
+	return btfgen_type ? 0 : -errno;
 }
 
 static int btfgen_record_enumval_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
 {
-	return -EOPNOTSUPP;
+	struct btf *btf = (struct btf *) info->src_btf;
+	struct btfgen_type *btfgen_type;
+	struct btf_type *btf_type;
+
+	btf_type = (struct btf_type *) btf__type_by_id(btf, targ_spec->root_type_id);
+
+	btfgen_type = btfgen_put_type_all(btf, info, btf_type, targ_spec->root_type_id);
+	return btfgen_type ? 0 : -errno;
 }
 
 static int btfgen_record_reloc(struct btfgen_info *info, struct bpf_core_spec *res)
-- 
2.25.1

