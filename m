Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9D24A03BF
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351720AbiA1Wdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351712AbiA1Wdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:33:42 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F016DC061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:41 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id o25so6915490qkj.7
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vrLxklqtGx3g8zHF9f/1zIORGjCn9ZUm5AdxoQ74euU=;
        b=ABWxw9epg4FeecWbnj2uZ9dUHMNJYJyoRvVjPxdMylrBtUt2/9wvoYWV8dWozXfYBQ
         7KfMNEqds7chU1BplfOCIg/BekX8zTNkaV+5ZL2QQN1jfhYcXp9uSEJxGzH11uxqAYY9
         uQIZ41smug4KXAEnhxkxxXUofk6wOyJCSQf14=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vrLxklqtGx3g8zHF9f/1zIORGjCn9ZUm5AdxoQ74euU=;
        b=4n9HoXyywtVHU23p1iJf21cJDrElRMVG3wPI4yV30XNYGY/95Lj3tOGr2MUf9JAJL6
         dfPrOIoWnW75OYWflEu+lJddIMynTdS1XiQFHhzLkHGXZmJW4h784hDjGBW1Xrrf32pf
         ndP7psaJeDMh8my1MPWFOa957fHdg2IbseIPcyTnVcNSSSf9Wg/nGI2tqy3ZZGq7Pa6i
         fvHDNA/2SuL6bLQKft0LtvE7d7/z2/TUc86pKuHNvhLBOYJHdiNzYpHHmGskcwzk91ab
         hSBMPEDaPVR7Ko2aFPj5ZHFSpV1AwRtiBz/dCsaUQEHFOu2adMG5HfoQ/NXKTJ9JUJv3
         XkcQ==
X-Gm-Message-State: AOAM530WKLQj2/xSvdUp91LhrKN7Zl0pYAcCMYdkzbz6O2Mcxwzysuqo
        JKlNhF5Ms2SO64Hzx2deuuZ3bcJZicYzkIh+Vai1Z1AoNwuonyvtNz9Nx3LBhghLVjuydWn3elC
        QwtJ8SMzF46sK+QPXB3ZFex6VhT+Az3ILX0tc+8Bnv7UxOxEup9/dbK7+GUIXmKTHhxF76A==
X-Google-Smtp-Source: ABdhPJymtWGEdetuD3rbnP4ot4ME4RlaPpo/bmkHyEHFgT5DtXw+y/56hl2eraNzFyk2KdFPVim3JQ==
X-Received: by 2002:a05:620a:4311:: with SMTP id u17mr7118193qko.63.1643409219142;
        Fri, 28 Jan 2022 14:33:39 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id i18sm3723972qka.80.2022.01.28.14.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:33:38 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v5 5/9] bpftool: Implement btfgen()
Date:   Fri, 28 Jan 2022 17:33:08 -0500
Message-Id: <20220128223312.1253169-6-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220128223312.1253169-1-mauricio@kinvolk.io>
References: <20220128223312.1253169-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

btfgen() receives the path of a source and destination BTF files and a
list of BPF objects. This function records the relocations for all
objects and then generates the BTF file by calling btfgen_get_btf()
(implemented in the following commits).

btfgen_record_obj() loads the BTF and BTF.ext sections of the BPF
objects and loops through all CO-RE relocations. It uses
bpf_core_calc_relo_insn() from libbpf and passes the target spec to
btfgen_record_reloc() that saves the types involved in such relocation.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/bpf/bpftool/Makefile |   8 +-
 tools/bpf/bpftool/gen.c    | 221 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 223 insertions(+), 6 deletions(-)

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
index 68bb88e86b27..bb9c56401ee5 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
+#include <bpf/libbpf_internal.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
@@ -1143,6 +1144,11 @@ static void *uint_as_hash_key(int x)
 	return (void *)(uintptr_t)x;
 }
 
+static void *u32_as_hash_key(__u32 x)
+{
+	return (void *)(uintptr_t)x;
+}
+
 static void btfgen_free_type(struct btfgen_type *type)
 {
 	free(type);
@@ -1193,12 +1199,223 @@ btfgen_new_info(const char *targ_btf_path)
 	return info;
 }
 
-/* Create BTF file for a set of BPF objects */
-static int btfgen(const char *src_btf, const char *dst_btf, const char *objspaths[])
+static int btfgen_record_field_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
+{
+	return -EOPNOTSUPP;
+}
+
+static int btfgen_record_type_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
+{
+	return -EOPNOTSUPP;
+}
+
+static int btfgen_record_enumval_relo(struct btfgen_info *info, struct bpf_core_spec *targ_spec)
 {
 	return -EOPNOTSUPP;
 }
 
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
+	case BPF_CORE_TYPE_ID_LOCAL:
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
+	if (cands)
+		bpf_core_free_cands(cands);
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
+	struct hashmap *cand_cache;
+	struct btf_ext *btf_ext;
+	unsigned int relo_idx;
+	struct btf *btf;
+	int err;
+
+	btf = btf__parse(obj_path, &btf_ext);
+	err = libbpf_get_error(btf);
+	if (err) {
+		p_err("failed to parse bpf object '%s': %s", obj_path, strerror(errno));
+		return err;
+	}
+
+	if (btf_ext->core_relo_info.len == 0)
+		return 0;
+
+	cand_cache = bpf_core_create_cand_cache();
+	if (IS_ERR(cand_cache))
+		return PTR_ERR(cand_cache);
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
+			err = btfgen_record_reloc(info, &specs_scratch[2]);
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
+/* Generate BTF from relocation information previously recorded */
+static struct btf *btfgen_get_btf(struct btfgen_info *info)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+/* Create BTF file for a set of BPF objects.
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
+ * BTF file. For type-based and enum-based relocations the whole type is
+ * saved.
+ *
+ * The second part of the algorithm generates the BTF object. It creates
+ * an empty BTF object and fills it with the types recorded in the
+ * previous step. This function takes care of only adding the structure
+ * and union members that were marked as used and it also fixes up the
+ * type IDs on the generated BTF object.
+ */
+static int btfgen(const char *src_btf, const char *dst_btf, const char *objspaths[])
+{
+	struct btfgen_info *info;
+	struct btf *btf_new = NULL;
+	int err;
+
+	info = btfgen_new_info(src_btf);
+	if (!info) {
+		p_err("failed to allocate info structure: %s", strerror(errno));
+		err = -errno;
+		goto out;
+	}
+
+	for (int i = 0; objspaths[i] != NULL; i++) {
+		p_info("Processing BPF object: %s", objspaths[i]);
+
+		err = btfgen_record_obj(info, objspaths[i]);
+		if (err)
+			goto out;
+	}
+
+	btf_new = btfgen_get_btf(info);
+	if (!btf_new) {
+		err = -errno;
+		p_err("error generating btf: %s", strerror(errno));
+		goto out;
+	}
+
+	p_info("Creating BTF file: %s", dst_btf);
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
+}
+
 static int do_min_core_btf(int argc, char **argv)
 {
 	char src_btf_path[PATH_MAX], dst_btf_path[PATH_MAX];
-- 
2.25.1

