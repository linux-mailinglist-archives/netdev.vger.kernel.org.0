Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B954948C611
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354119AbiALO15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354140AbiALO1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:27:48 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD39FC061751
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:35 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id t66so2634019qkb.4
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=361WBFrE2wyLlAJ9s20Jdt/AO9xNH671IIEc8E5AvSg=;
        b=QLlh9HdPfFFPMIVsYUpeU0sMQAUPlBjDzBSfBK4ENYsYQ5AmAlndiv/EPzP332KUW3
         1SbLbTY4HpcnHQp+V5SKSGyWX7wagVzVI+AOV8VLf1IxKCx4Vgagkc03WD0ElP/l9Gvd
         VW+6pTd0ufbI2iaYRUjHwHKHKjCAOyq9vi0+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=361WBFrE2wyLlAJ9s20Jdt/AO9xNH671IIEc8E5AvSg=;
        b=gPLiJp9SU3DAcl/UKSF/ZRHh7JM4h8elSGIMybVPiOJE6mpz+VKcPKLfBoZLeRYI+p
         hDw7HcizmpdjIx84lbA4/BGDk4MEwET8iLyIX+ojxZhEEdfm/9orfUjYFnAVtaXV+eBk
         G4h+e9P4bO4w647DmH/7zj6zx2wG/HpCWo3+s9X/jUtjMbs7gU1AuGNyTvUuL6sHk8lh
         498NcScPBKpP+hIAi/lEOS1n/Ldyw8JzqV5CI7o4oPrd3GSKt3bhPMZ+b4gk1D3aZPcb
         dzT89JowtuMkFd0joSTk1ao9lhukOMjVrTWKg7gnYTXQKFx+M4kDiVMQ9UWhLVEv8imH
         gMCQ==
X-Gm-Message-State: AOAM532MhBceJ3pQdEwC6ORLDEAPUgvLAdzwRxwcxhtHsCelo56WBVhF
        N3ofleU/BtP9nKuyWDoa+HIcVSMMhh/NktGK0+3Av/Ybq0KEyJWhuc58KEHMI5jtQ71EORMJbSN
        H+PfnhWuR6IBZXzi0qA+5RpitgW9OAmNXVuH5/XNkE5s83/rkq7qc12AeRyHGsr8L3rKXPU5A
X-Google-Smtp-Source: ABdhPJxJcL8C4HcfM5N1qHfFuGjc7UOW+hpCMugpgdyucK0RwlrwHaOXz2t32HyMzhspeNMzRlmoxA==
X-Received: by 2002:a05:620a:4544:: with SMTP id u4mr5841852qkp.49.1641997653317;
        Wed, 12 Jan 2022 06:27:33 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h11sm8776690qko.59.2022.01.12.06.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 06:27:33 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v4 8/8] bpftool: Implement btfgen_get_btf()
Date:   Wed, 12 Jan 2022 09:27:09 -0500
Message-Id: <20220112142709.102423-9-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220112142709.102423-1-mauricio@kinvolk.io>
References: <20220112142709.102423-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last part of the BTFGen algorithm is to create a new BTF object with
all the types that were recorded in the previous steps.

This function performs two different steps:
1. Add the types to the new BTF object by using btf__add_type(). Some
special logic around struct and unions is implemented to only add the
members that are really used in the field-based relocations. The type
ID on the new and old BTF objects is stored on a map.
2. Fix all the type IDs on the new BTF object by using the IDs saved in
the previous step.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/bpf/bpftool/gen.c | 158 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 157 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 8c13dde0b74d..696a66bded32 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1607,10 +1607,166 @@ static int btfgen_record_obj(struct btfgen_info *info, const char *obj_path)
 	return err;
 }
 
+static unsigned int btfgen_get_id(struct hashmap *ids, unsigned int old)
+{
+	uintptr_t new = 0;
+
+	/* deal with BTF_KIND_VOID */
+	if (old == 0)
+		return 0;
+
+	if (!hashmap__find(ids, uint_as_hash_key(old), (void **)&new)) {
+		/* return id for void as it's possible that the ID we're looking for is
+		 * the type of a pointer that we're not adding.
+		 */
+		return 0;
+	}
+
+	return (unsigned int)(uintptr_t)new;
+}
+
+static int btfgen_add_id(struct hashmap *ids, unsigned int old, unsigned int new)
+{
+	return hashmap__add(ids, uint_as_hash_key(old), uint_as_hash_key(new));
+}
+
 /* Generate BTF from relocation information previously recorded */
 static struct btf *btfgen_get_btf(struct btfgen_info *info)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct hashmap_entry *entry;
+	struct btf *btf_new = NULL;
+	struct hashmap *ids = NULL;
+	size_t bkt;
+	int err = 0;
+
+	btf_new = btf__new_empty();
+	if (libbpf_get_error(btf_new))
+		goto err_out;
+
+	ids = hashmap__new(btfgen_hash_fn, btfgen_equal_fn, NULL);
+	if (IS_ERR(ids)) {
+		errno = -PTR_ERR(ids);
+		goto err_out;
+	}
+
+	/* first pass: add all types and add their new ids to the ids map */
+	hashmap__for_each_entry(info->types, entry, bkt) {
+		struct btfgen_type *btfgen_type = entry->value;
+		struct btf_type *btf_type = btfgen_type->type;
+		int new_id;
+
+		/* we're adding BTF_KIND_VOID to the list but it can't be added to
+		 * the generated BTF object, hence we skip it here.
+		 */
+		if (btfgen_type->id == 0)
+			continue;
+
+		/* add members for struct and union */
+		if (btf_is_struct(btf_type) || btf_is_union(btf_type)) {
+			struct hashmap_entry *member_entry;
+			struct btf_type *btf_type_cpy;
+			int nmembers, index;
+			size_t new_size;
+
+			nmembers = btfgen_type->members ? hashmap__size(btfgen_type->members) : 0;
+			new_size = sizeof(struct btf_type) + nmembers * sizeof(struct btf_member);
+
+			btf_type_cpy = malloc(new_size);
+			if (!btf_type_cpy)
+				goto err_out;
+
+			/* copy header */
+			memcpy(btf_type_cpy, btf_type, sizeof(*btf_type_cpy));
+
+			/* copy only members that are needed */
+			index = 0;
+			if (nmembers > 0) {
+				size_t bkt2;
+
+				hashmap__for_each_entry(btfgen_type->members, member_entry, bkt2) {
+					struct btfgen_member *btfgen_member;
+					struct btf_member *btf_member;
+
+					btfgen_member = member_entry->value;
+					btf_member = btf_members(btf_type) + btfgen_member->idx;
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
+			goto err_out;
+
+		new_id = err;
+
+		/* add ID mapping */
+		err = btfgen_add_id(ids, btfgen_type->id, new_id);
+		if (err)
+			goto err_out;
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
+				btf_member->type = btfgen_get_id(ids, btf_member->type);
+			}
+			break;
+		case BTF_KIND_PTR:
+		case BTF_KIND_TYPEDEF:
+		case BTF_KIND_VOLATILE:
+		case BTF_KIND_CONST:
+		case BTF_KIND_RESTRICT:
+		case BTF_KIND_FUNC:
+		case BTF_KIND_VAR:
+			btf_type->type = btfgen_get_id(ids, btf_type->type);
+			break;
+		case BTF_KIND_ARRAY:
+			array = btf_array(btf_type);
+			array->index_type = btfgen_get_id(ids, array->index_type);
+			array->type = btfgen_get_id(ids, array->type);
+			break;
+		case BTF_KIND_FUNC_PROTO:
+			btf_type->type = btfgen_get_id(ids, btf_type->type);
+			params = btf_params(btf_type);
+			for (unsigned short j = 0; j < btf_vlen(btf_type); j++)
+				params[j].type = btfgen_get_id(ids, params[j].type);
+			break;
+		default:
+			break;
+		}
+	}
+
+	hashmap__free(ids);
+	return btf_new;
+
+err_out:
+	btf__free(btf_new);
+	hashmap__free(ids);
+	return NULL;
 }
 
 /* Create BTF file for a set of BPF objects.
-- 
2.25.1

