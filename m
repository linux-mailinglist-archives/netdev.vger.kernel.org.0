Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7734B0039
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 23:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbiBIW2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 17:28:41 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbiBIW2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 17:28:25 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03F5E01A2DA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 14:27:43 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id j12so3371334qtr.2
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 14:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OEb+73Bs6DjNMKvBc173Y+LLF0SX/J9C9ef6SZv7LKQ=;
        b=erSbulTv2zjtNfGH/YuDolJrQotc9kCxo2KwujX5s6aM9xAfeB1ErPRTv+Kn0G2n43
         dy7THUoVPczgWdRzXZMCRiC4CgL2gmcb0PJdQ9mwUmCn8DuFMH1nRwnJ2UPT1jdq9i7v
         FYfS0dQrYOyC8RHWCz2gFprbllTjhDDnly624=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OEb+73Bs6DjNMKvBc173Y+LLF0SX/J9C9ef6SZv7LKQ=;
        b=q/vOdyK9znfwG3vnZAETZMY2jawVdPYfj4tnPMQoFXsUJsUC4jK77rZvMfnBT0dPxI
         fCKnNN6szFfPIB7QxjQ2H+oZm8C1iuzvvHoRw3tMXNXVGMM1+j/Ze7pAvKDzYTcUYnPA
         /5eGWujpi8Xy12OH/wBZpH7+z1eI0x3JTAufrR/jas92T0OVCc17k5DwmAkXu+JK6CAM
         bbTh9D6iXFoNPMgJd6xX6Hy+10aVsVtyCZu6E2pX3FrR50YErfcpWudGvBDGUUYHvHmA
         pyiC39RW23UbvfFo5QqkOJLB6xz5wZs6z+JMvvXS1F+Du0M7HbuXz1NQn1fQ2j843KWb
         DPSQ==
X-Gm-Message-State: AOAM533nOTfz55H7Luv9JCV4B7uFezxoGfYcn0ZA3c7eezFXv7P6rVoF
        98Hg2IhO2SAeZGBw9IhpMeVE+xscwDBZX48BNZgM9BnI7h+pRIogITiWT38TgkpezA7acIecMrk
        BAoDvEn5AGRmKTFIie21kzvytVuevudjCZiKhCiR0KdfTxFRQcJFeVITSVIQiPNbvJwh+xg==
X-Google-Smtp-Source: ABdhPJzPnfe4p6aUzPkEJIhe7weCCLDVpQitMFxylqlpeS6gqAMENjUNF/LkmVVULWl0ZAOYHcBk7A==
X-Received: by 2002:ac8:7e8f:: with SMTP id w15mr2950124qtj.314.1644445659062;
        Wed, 09 Feb 2022 14:27:39 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h6sm9706287qtx.65.2022.02.09.14.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 14:27:38 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v6 4/7] bpftool: Implement minimize_btf() and relocations recording for BTFGen
Date:   Wed,  9 Feb 2022 17:26:43 -0500
Message-Id: <20220209222646.348365-5-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209222646.348365-1-mauricio@kinvolk.io>
References: <20220209222646.348365-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

minimize_btf() receives the path of a source and destination BTF files
and a list of BPF objects. This function records the relocations for
all objects and then generates the BTF file by calling btfgen_get_btf()
(implemented in the following commit).

btfgen_record_obj() loads the BTF and BTF.ext sections of the BPF
objects and loops through all CO-RE relocations. It uses
bpf_core_calc_relo_insn() from libbpf and passes the target spec to
btfgen_record_reloc(), that calls one of the following functions
depending on the relocation kind.

btfgen_record_field_relo() uses the target specification to mark all the
types that are involved in a field-based CO-RE relocation. In this case
types resolved and marked recursively using btfgen_mark_type().
Only the struct and union members (and their types) involved in the
relocation are marked to optimize the size of the generated BTF file.

btfgen_record_type_relo() marks the types involved in a type-based
CO-RE relocation. In this case no members for the struct and union
types are marked as libbpf doesn't use them while performing this kind
of relocation. Pointed types are marked as they are used by libbpf in
this case.

btfgen_record_enumval_relo() marks the whole enum type for enum-based
relocations.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/bpf/bpftool/Makefile |   8 +-
 tools/bpf/bpftool/gen.c    | 452 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 454 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 83369f55df61..97d447135536 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -34,10 +34,10 @@ LIBBPF_BOOTSTRAP_INCLUDE := $(LIBBPF_BOOTSTRAP_DESTDIR)/include
 LIBBPF_BOOTSTRAP_HDRS_DIR := $(LIBBPF_BOOTSTRAP_INCLUDE)/bpf
 LIBBPF_BOOTSTRAP := $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
 
-# We need to copy hashmap.h and nlattr.h which is not otherwise exported by
-# libbpf, but still required by bpftool.
-LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h)
-LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h)
+# We need to copy hashmap.h, nlattr.h, relo_core.h and libbpf_internal.h
+# which are not otherwise exported by libbpf, but still required by bpftool.
+LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h relo_core.h libbpf_internal.h)
+LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h relo_core.h libbpf_internal.h)
 
 ifeq ($(BPFTOOL_VERSION),)
 BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 582c20602639..c3e34db2ec8a 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -14,6 +14,7 @@
 #include <unistd.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
+#include <bpf/libbpf_internal.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
@@ -1098,10 +1099,457 @@ static int do_help(int argc, char **argv)
 	return 0;
 }
 
-/* Create minimized BTF file for a set of BPF objects */
+static int btf_save_raw(const struct btf *btf, const char *path)
+{
+	const void *data;
+	FILE *f = NULL;
+	__u32 data_sz;
+	int err = 0;
+
+	data = btf__raw_data(btf, &data_sz);
+	if (!data)
+		return -ENOMEM;
+
+	f = fopen(path, "wb");
+	if (!f)
+		return -errno;
+
+	if (fwrite(data, 1, data_sz, f) != data_sz)
+		err = -errno;
+
+	fclose(f);
+	return err;
+}
+
+struct btfgen_info {
+	struct btf *src_btf;
+	struct btf *marked_btf; // btf structure used to mark used types
+};
+
+static size_t btfgen_hash_fn(const void *key, void *ctx)
+{
+	return (size_t)key;
+}
+
+static bool btfgen_equal_fn(const void *k1, const void *k2, void *ctx)
+{
+	return k1 == k2;
+}
+
+static void *uint_as_hash_key(int x)
+{
+	return (void *)(uintptr_t)x;
+}
+
+static void *u32_as_hash_key(__u32 x)
+{
+	return (void *)(uintptr_t)x;
+}
+
+static void btfgen_free_info(struct btfgen_info *info)
+{
+	if (!info)
+		return;
+
+	btf__free(info->src_btf);
+	btf__free(info->marked_btf);
+
+	free(info);
+}
+
+static struct btfgen_info *
+btfgen_new_info(const char *targ_btf_path)
+{
+	struct btfgen_info *info;
+	int err;
+
+	info = calloc(1, sizeof(*info));
+	if (!info)
+		return NULL;
+
+	info->src_btf = btf__parse(targ_btf_path, NULL);
+	if (!info->src_btf) {
+		p_err("failed parsing '%s' BTF file: %s", targ_btf_path, strerror(errno));
+		err = -errno;
+		goto err_out;
+	}
+
+	info->marked_btf = btf__parse(targ_btf_path, NULL);
+	if (!info->marked_btf) {
+		p_err("failed parsing '%s' BTF file: %s", targ_btf_path, strerror(errno));
+		err = -errno;
+		goto err_out;
+	}
+
+	return info;
+
+err_out:
+	btfgen_free_info(info);
+	errno = -err;
+	return NULL;
+}
+
+#define MARKED UINT32_MAX
+
+static void btfgen_mark_member(struct btfgen_info *info, int type_id, int idx)
+{
+	const struct btf_type *t = btf__type_by_id(info->marked_btf, type_id);
+	struct btf_member *m = btf_members(t) + idx;
+
+	m->name_off = MARKED;
+}
+
+static int
+btfgen_mark_type(struct btfgen_info *info, unsigned int id, bool follow_pointers)
+{
+	const struct btf_type *btf_type = btf__type_by_id(info->src_btf, id);
+	struct btf_type *cloned_type;
+	struct btf_param *param;
+	struct btf_array *array;
+	int err, i;
+
+	if (id == 0)
+		return 0;
+
+	/* mark type on cloned BTF as used */
+	cloned_type = (struct btf_type *) btf__type_by_id(info->marked_btf, id);
+	cloned_type->name_off = MARKED;
+
+	/* recursively mark other types needed by it */
+	switch (btf_kind(btf_type)) {
+	case BTF_KIND_UNKN:
+	case BTF_KIND_INT:
+	case BTF_KIND_FLOAT:
+	case BTF_KIND_ENUM:
+	case BTF_KIND_STRUCT:
+	case BTF_KIND_UNION:
+		break;
+	case BTF_KIND_PTR:
+		if (follow_pointers) {
+			err = btfgen_mark_type(info, btf_type->type, follow_pointers);
+			if (err)
+				return err;
+		}
+		break;
+	case BTF_KIND_CONST:
+	case BTF_KIND_VOLATILE:
+	case BTF_KIND_TYPEDEF:
+		err = btfgen_mark_type(info, btf_type->type, follow_pointers);
+		if (err)
+			return err;
+		break;
+	case BTF_KIND_ARRAY:
+		array = btf_array(btf_type);
+
+		/* mark array type */
+		err = btfgen_mark_type(info, array->type, follow_pointers);
+		/* mark array's index type */
+		err = err ? : btfgen_mark_type(info, array->index_type, follow_pointers);
+		if (err)
+			return err;
+		break;
+	case BTF_KIND_FUNC_PROTO:
+		/* mark ret type */
+		err = btfgen_mark_type(info, btf_type->type, follow_pointers);
+		if (err)
+			return err;
+
+		/* mark parameters types */
+		param = btf_params(btf_type);
+		for (i = 0; i < btf_vlen(btf_type); i++) {
+			err = btfgen_mark_type(info, param->type, follow_pointers);
+			if (err)
+				return err;
+			param++;
+		}
+		break;
+	/* tells if some other type needs to be handled */
+	default:
+		p_err("unsupported kind: %s (%d)", btf_kind_str(btf_type), id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int btfgen_record_field_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
+{
+	struct btf *btf = (struct btf *) info->src_btf;
+	const struct btf_type *btf_type;
+	struct btf_member *btf_member;
+	struct btf_array *array;
+	unsigned int id = targ_spec->root_type_id;
+	int idx, err;
+
+	/* mark root type */
+	btf_type = btf__type_by_id(btf, id);
+	err = btfgen_mark_type(info, id, false);
+	if (err)
+		return err;
+
+	/* mark types for complex types (arrays, unions, structures) */
+	for (int i = 1; i < targ_spec->raw_len; i++) {
+		/* skip typedefs and mods */
+		while (btf_is_mod(btf_type) || btf_is_typedef(btf_type)) {
+			id = btf_type->type;
+			btf_type = btf__type_by_id(btf, id);
+		}
+
+		switch (btf_kind(btf_type)) {
+		case BTF_KIND_STRUCT:
+		case BTF_KIND_UNION:
+			idx = targ_spec->raw_spec[i];
+			btf_member = btf_members(btf_type) + idx;
+
+			/* mark member */
+			btfgen_mark_member(info, id, idx);
+
+			/* mark member's type */
+			id = btf_member->type;
+			btf_type = btf__type_by_id(btf, id);
+			err = btfgen_mark_type(info, id, false);
+			if (err)
+				return err;
+			break;
+		case BTF_KIND_ARRAY:
+			array = btf_array(btf_type);
+			id = array->type;
+			btf_type = btf__type_by_id(btf, id);
+			break;
+		default:
+			p_err("unsupported kind: %s (%d)",
+			      btf_kind_str(btf_type), btf_type->type);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int btfgen_record_type_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
+{
+	return btfgen_mark_type(info, targ_spec->root_type_id, true);
+}
+
+static int btfgen_record_enumval_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
+{
+	return btfgen_mark_type(info, targ_spec->root_type_id, false);
+}
+
+static int btfgen_record_reloc(struct btfgen_info *info, struct bpf_core_spec *res)
+{
+	switch (res->relo_kind) {
+	case BPF_CORE_FIELD_BYTE_OFFSET:
+	case BPF_CORE_FIELD_BYTE_SIZE:
+	case BPF_CORE_FIELD_EXISTS:
+	case BPF_CORE_FIELD_SIGNED:
+	case BPF_CORE_FIELD_LSHIFT_U64:
+	case BPF_CORE_FIELD_RSHIFT_U64:
+		return btfgen_record_field_relo(info, res);
+	case BPF_CORE_TYPE_ID_LOCAL: /* BPF_CORE_TYPE_ID_LOCAL doesn't require kernel BTF */
+		return 0;
+	case BPF_CORE_TYPE_ID_TARGET:
+	case BPF_CORE_TYPE_EXISTS:
+	case BPF_CORE_TYPE_SIZE:
+		return btfgen_record_type_relo(info, res);
+	case BPF_CORE_ENUMVAL_EXISTS:
+	case BPF_CORE_ENUMVAL_VALUE:
+		return btfgen_record_enumval_relo(info, res);
+	default:
+		return -EINVAL;
+	}
+}
+
+static struct bpf_core_cand_list *
+btfgen_find_cands(const struct btf *local_btf, const struct btf *targ_btf, __u32 local_id)
+{
+	const struct btf_type *local_type;
+	struct bpf_core_cand_list *cands = NULL;
+	struct bpf_core_cand local_cand = {};
+	size_t local_essent_len;
+	const char *local_name;
+	int err;
+
+	local_cand.btf = local_btf;
+	local_cand.id = local_id;
+
+	local_type = btf__type_by_id(local_btf, local_id);
+	if (!local_type) {
+		err = -EINVAL;
+		goto err_out;
+	}
+
+	local_name = btf__name_by_offset(local_btf, local_type->name_off);
+	if (!local_name) {
+		err = -EINVAL;
+		goto err_out;
+	}
+	local_essent_len = bpf_core_essential_name_len(local_name);
+
+	cands = calloc(1, sizeof(*cands));
+	if (!cands)
+		return NULL;
+
+	err = bpf_core_add_cands(&local_cand, local_essent_len, targ_btf, "vmlinux", 1, cands);
+	if (err)
+		goto err_out;
+
+	return cands;
+
+err_out:
+	bpf_core_free_cands(cands);
+	errno = -err;
+	return NULL;
+}
+
+/* Record relocation information for a single BPF object*/
+static int btfgen_record_obj(struct btfgen_info *info, const char *obj_path)
+{
+	const struct btf_ext_info_sec *sec;
+	const struct bpf_core_relo *relo;
+	const struct btf_ext_info *seg;
+	struct hashmap_entry *entry;
+	struct hashmap *cand_cache = NULL;
+	struct btf_ext *btf_ext = NULL;
+	unsigned int relo_idx;
+	struct btf *btf = NULL;
+	size_t i;
+	int err;
+
+	btf = btf__parse(obj_path, &btf_ext);
+	if (!btf) {
+		p_err("failed to parse BPF object '%s': %s", obj_path, strerror(errno));
+		return -errno;
+	}
+
+	if (btf_ext->core_relo_info.len == 0) {
+		err = 0;
+		goto out;
+	}
+
+	cand_cache = hashmap__new(btfgen_hash_fn, btfgen_equal_fn, NULL);
+	if (IS_ERR(cand_cache)) {
+		err = PTR_ERR(cand_cache);
+		goto out;
+	}
+
+	seg = &btf_ext->core_relo_info;
+	for_each_btf_ext_sec(seg, sec) {
+		for_each_btf_ext_rec(seg, sec, relo_idx, relo) {
+			struct bpf_core_spec specs_scratch[3] = {};
+			struct bpf_core_relo_res targ_res = {};
+			struct bpf_core_cand_list *cands = NULL;
+			const void *type_key = u32_as_hash_key(relo->type_id);
+			const char *sec_name = btf__name_by_offset(btf, sec->sec_name_off);
+
+			if (relo->kind != BPF_CORE_TYPE_ID_LOCAL &&
+			    !hashmap__find(cand_cache, type_key, (void **)&cands)) {
+				cands = btfgen_find_cands(btf, info->src_btf, relo->type_id);
+				if (!cands) {
+					err = -errno;
+					goto out;
+				}
+
+				err = hashmap__set(cand_cache, type_key, cands, NULL, NULL);
+				if (err)
+					goto out;
+			}
+
+			err = bpf_core_calc_relo_insn(sec_name, relo, relo_idx, btf, cands,
+						      specs_scratch, &targ_res);
+			if (err)
+				goto out;
+
+			/* specs_scratch[2] is the target spec */
+			err = btfgen_record_reloc(info, &specs_scratch[2]);
+			if (err)
+				goto out;
+		}
+	}
+
+out:
+	btf__free(btf);
+	btf_ext__free(btf_ext);
+
+	if (!IS_ERR_OR_NULL(cand_cache)) {
+		hashmap__for_each_entry(cand_cache, entry, i) {
+			bpf_core_free_cands(entry->value);
+		}
+		hashmap__free(cand_cache);
+	}
+
+	return err;
+}
+
+/* Generate BTF from relocation information previously recorded */
+static struct btf *btfgen_get_btf(struct btfgen_info *info)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+/* Create minimized BTF file for a set of BPF objects.
+ *
+ * The BTFGen algorithm is divided in two main parts: (1) collect the
+ * BTF types that are involved in relocations and (2) generate the BTF
+ * object using the collected types.
+ *
+ * In order to collect the types involved in the relocations, we parse
+ * the BTF and BTF.ext sections of the BPF objects and use
+ * bpf_core_calc_relo_insn() to get the target specification, this
+ * indicates how the types and fields are used in a relocation.
+ *
+ * Types are recorded in different ways according to the kind of the
+ * relocation. For field-based relocations only the members that are
+ * actually used are saved in order to reduce the size of the generated
+ * BTF file. For type-based relocations empty struct / unions are
+ * generated and for enum-based relocations the whole type is saved.
+ *
+ * The second part of the algorithm generates the BTF object. It creates
+ * an empty BTF object and fills it with the types recorded in the
+ * previous step. This function takes care of only adding the structure
+ * and union members that were marked as used and it also fixes up the
+ * type IDs on the generated BTF object.
+ */
 static int minimize_btf(const char *src_btf, const char *dst_btf, const char *objspaths[])
 {
-	return -EOPNOTSUPP;
+	struct btfgen_info *info;
+	struct btf *btf_new = NULL;
+	int err, i;
+
+	info = btfgen_new_info(src_btf);
+	if (!info) {
+		p_err("failed to allocate info structure: %s", strerror(errno));
+		err = -errno;
+		goto out;
+	}
+
+	for (i = 0; objspaths[i] != NULL; i++) {
+		err = btfgen_record_obj(info, objspaths[i]);
+		if (err) {
+			p_err("error recording relocations for %s: %s", objspaths[i],
+			      strerror(errno));
+			goto out;
+		}
+	}
+
+	btf_new = btfgen_get_btf(info);
+	if (!btf_new) {
+		err = -errno;
+		p_err("error generating BTF: %s", strerror(errno));
+		goto out;
+	}
+
+	err = btf_save_raw(btf_new, dst_btf);
+	if (err) {
+		p_err("error saving btf file: %s", strerror(errno));
+		goto out;
+	}
+
+out:
+	btf__free(btf_new);
+	btfgen_free_info(info);
+
+	return err;
 }
 
 static int do_min_core_btf(int argc, char **argv)
-- 
2.25.1

