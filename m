Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE48479477
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240491AbhLQS5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240415AbhLQS5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 13:57:08 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5CDC061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 10:57:07 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id 30so6036007uag.13
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 10:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=la4UMxbRzz+SyDZQIeAeIOgzlTjSpc95saxXrGauGMA=;
        b=ERVd4xEhnS+56XO2vjJOiZXyMBsOjkPHpXylDremrtalclMM9VkabF758ZmcNAEQxZ
         10apOmHsm/0syfEUpP2jN4gGWvXh0SxZJmOlWhatfQazswziA33EQLBsFbKYJ7GBUjwo
         LZ37WXp/UxtdRLHGEdmBqKzpRXshx9ADLifeU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=la4UMxbRzz+SyDZQIeAeIOgzlTjSpc95saxXrGauGMA=;
        b=ngNSzcUeS9qo2/O9/KWGBfj6T39D1I5IaaxHUii0hBcFSIopvLxEOOUQ0Xj1aO1skA
         CRfYvxjzzoReV8rXK8yATRBuKYhjompHFJvsLX9fipdp7Qic6HWV+ONfcIckYSMsaVrK
         fUSVy/ZeAi/Yq1rPVcPu3oGrfq4irzAh5YLeBlp1ayYwI1KY2fAro4gqWKvd+NJ/R1mf
         EC4uxybezo3Za5tALdFJKHxFZY2lnUazIcH9F2aOGjg/lSdbaQO954v3wi0nzm24PwMX
         QqIkDCG03NvmCTQHX8l8CKmp2pD8Dn6a3oJ3tloODY7jE8/6bVlLjirwBq92N+6b0kS4
         NVAw==
X-Gm-Message-State: AOAM531CHtO0RAodaCuAxEoJg7AtrghlY9EyTGONrz5RH+SxJMhOQAfd
        MZQs2CBBE0vX5YBDJj6zdMG3ueq2umSZMFMY0qN40SYUYbk7UEzb4X462bjKbV6hIeulyA6b1LK
        qxVKE8WSvaeT75Rdl5V58ieMyk2u9TQir5ruenqDY1HGbT232JJBOZUN6OzQx3XT6zz2akA==
X-Google-Smtp-Source: ABdhPJxqDw60rYotLE8GOS3dRY5pfSD3trdo5djRRKjfg7fQGlNDkS90kq9h0C7kMl1XYEBEwPguDQ==
X-Received: by 2002:a05:6130:38e:: with SMTP id az14mr2057301uab.42.1639767424873;
        Fri, 17 Dec 2021 10:57:04 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id l125sm1382575vke.40.2021.12.17.10.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 10:57:03 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v3 2/3] libbpf: Implement changes needed for BTFGen in bpftool
Date:   Fri, 17 Dec 2021 13:56:53 -0500
Message-Id: <20211217185654.311609-3-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211217185654.311609-1-mauricio@kinvolk.io>
References: <20211217185654.311609-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given that BTFGen is a so unique use case, let's expose some of the
libbpf internal APIs to bpftool. This commit extends libbpf with the
features that are needed to implement it.

Specifically, this commit introduces the following functions:
- bpf_object__btf_ext(): Public method to access the BTF.ext section of
an bpf object.
- bpf_program__sec_idx(): Public method to get the sec index of a
program within the elf file.
- Implement bpf_core_create_cand_cache() and bpf_core_free_cand_cache()
to handle candidates cache.
- Expose bpf_core_calc_relo_res() in libbpfinternal.h and add "struct
bpf_core_spec *targ_spec" parameter.
- bpf_object_set_vmlinux_override(): Internal function to set
obj->btf_vmlinux_override.
- bpf_object__get_nr_programs() and bpf_object__get_program(): To give
access to the program inside an object. bpf_object__for_each_program
is not good enough because BTFGen needs to access subprograms too.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/lib/bpf/Makefile          |  2 +-
 tools/lib/bpf/libbpf.c          | 88 ++++++++++++++++++++++++++-------
 tools/lib/bpf/libbpf.h          |  3 ++
 tools/lib/bpf/libbpf.map        |  2 +
 tools/lib/bpf/libbpf_internal.h | 22 +++++++++
 tools/lib/bpf/relo_core.c       |  6 +--
 tools/lib/bpf/relo_core.h       |  4 ++
 7 files changed, 104 insertions(+), 23 deletions(-)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index f947b61b2107..dba019ee2832 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -239,7 +239,7 @@ install_lib: all_cmd
 
 SRC_HDRS := bpf.h libbpf.h btf.h libbpf_common.h libbpf_legacy.h xsk.h	     \
 	    bpf_helpers.h bpf_tracing.h bpf_endian.h bpf_core_read.h	     \
-	    skel_internal.h libbpf_version.h
+	    skel_internal.h libbpf_version.h relo_core.h libbpf_internal.h
 GEN_HDRS := $(BPF_GENERATED)
 
 INSTALL_PFX := $(DESTDIR)$(prefix)/include/bpf
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 77e2df13715a..7c8f8797475f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4027,8 +4027,8 @@ static bool prog_contains_insn(const struct bpf_program *prog, size_t insn_idx)
 	       insn_idx < prog->sec_insn_off + prog->sec_insn_cnt;
 }
 
-static struct bpf_program *find_prog_by_sec_insn(const struct bpf_object *obj,
-						 size_t sec_idx, size_t insn_idx)
+struct bpf_program *find_prog_by_sec_insn(const struct bpf_object *obj,
+					  size_t sec_idx, size_t insn_idx)
 {
 	int l = 0, r = obj->nr_programs - 1, m;
 	struct bpf_program *prog;
@@ -5498,12 +5498,13 @@ static int record_relo_core(struct bpf_program *prog,
 	return 0;
 }
 
-static int bpf_core_calc_relo_res(struct bpf_program *prog,
-				  const struct bpf_core_relo *relo,
-				  int relo_idx,
-				  const struct btf *local_btf,
-				  struct hashmap *cand_cache,
-				  struct bpf_core_relo_res *targ_res)
+int bpf_core_calc_relo_res(struct bpf_program *prog,
+			   const struct bpf_core_relo *relo,
+			   int relo_idx,
+			   const struct btf *local_btf,
+			   struct hashmap *cand_cache,
+			   struct bpf_core_relo_res *targ_res,
+			   struct bpf_core_spec *targ_spec)
 {
 	struct bpf_core_spec specs_scratch[3] = {};
 	const void *type_key = u32_as_hash_key(relo->type_id);
@@ -5548,8 +5549,32 @@ static int bpf_core_calc_relo_res(struct bpf_program *prog,
 		}
 	}
 
-	return bpf_core_calc_relo_insn(prog_name, relo, relo_idx, local_btf, cands,
-				       specs_scratch, targ_res);
+	err = bpf_core_calc_relo_insn(prog_name, relo, relo_idx, local_btf, cands,
+				      specs_scratch, targ_res);
+	if (err)
+		return err;
+
+	if (targ_spec)
+		*targ_spec = specs_scratch[2];
+	return 0;
+}
+
+struct hashmap *bpf_core_create_cand_cache(void)
+{
+	return hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
+}
+
+void bpf_core_free_cand_cache(struct hashmap *cand_cache)
+{
+	struct hashmap_entry *entry;
+	int i;
+
+	if (!IS_ERR_OR_NULL(cand_cache)) {
+		hashmap__for_each_entry(cand_cache, entry, i) {
+			bpf_core_free_cands(entry->value);
+		}
+		hashmap__free(cand_cache);
+	}
 }
 
 static int
@@ -5559,7 +5584,6 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 	struct bpf_core_relo_res targ_res;
 	const struct bpf_core_relo *rec;
 	const struct btf_ext_info *seg;
-	struct hashmap_entry *entry;
 	struct hashmap *cand_cache = NULL;
 	struct bpf_program *prog;
 	struct bpf_insn *insn;
@@ -5578,7 +5602,7 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 		}
 	}
 
-	cand_cache = hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
+	cand_cache = bpf_core_create_cand_cache();
 	if (IS_ERR(cand_cache)) {
 		err = PTR_ERR(cand_cache);
 		goto out;
@@ -5627,7 +5651,8 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 			if (!prog->load)
 				continue;
 
-			err = bpf_core_calc_relo_res(prog, rec, i, obj->btf, cand_cache, &targ_res);
+			err = bpf_core_calc_relo_res(prog, rec, i, obj->btf, cand_cache, &targ_res,
+						     NULL);
 			if (err) {
 				pr_warn("prog '%s': relo #%d: failed to relocate: %d\n",
 					prog->name, i, err);
@@ -5660,12 +5685,8 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 	btf__free(obj->btf_vmlinux_override);
 	obj->btf_vmlinux_override = NULL;
 
-	if (!IS_ERR_OR_NULL(cand_cache)) {
-		hashmap__for_each_entry(cand_cache, entry, i) {
-			bpf_core_free_cands(entry->value);
-		}
-		hashmap__free(cand_cache);
-	}
+	bpf_core_free_cand_cache(cand_cache);
+
 	return err;
 }
 
@@ -8190,6 +8211,11 @@ struct btf *bpf_object__btf(const struct bpf_object *obj)
 	return obj ? obj->btf : NULL;
 }
 
+struct btf_ext *bpf_object__btf_ext(const struct bpf_object *obj)
+{
+	return obj ? obj->btf_ext : NULL;
+}
+
 int bpf_object__btf_fd(const struct bpf_object *obj)
 {
 	return obj->btf ? btf__fd(obj->btf) : -1;
@@ -8281,6 +8307,20 @@ bpf_object__next_program(const struct bpf_object *obj, struct bpf_program *prev)
 	return prog;
 }
 
+size_t bpf_object__get_nr_programs(const struct bpf_object *obj)
+{
+	return obj->nr_programs;
+}
+
+struct bpf_program *
+bpf_object__get_program(const struct bpf_object *obj, unsigned int i)
+{
+	if (i >= obj->nr_programs)
+		return NULL;
+
+	return &obj->programs[i];
+}
+
 struct bpf_program *
 bpf_program__prev(struct bpf_program *next, const struct bpf_object *obj)
 {
@@ -8360,6 +8400,11 @@ int bpf_program__set_autoload(struct bpf_program *prog, bool autoload)
 	return 0;
 }
 
+int bpf_program__sec_idx(const struct bpf_program *prog)
+{
+	return prog->sec_idx;
+}
+
 static int bpf_program_nth_fd(const struct bpf_program *prog, int n);
 
 int bpf_program__fd(const struct bpf_program *prog)
@@ -11779,3 +11824,8 @@ void bpf_object__destroy_skeleton(struct bpf_object_skeleton *s)
 	free(s->progs);
 	free(s);
 }
+
+void bpf_object_set_vmlinux_override(struct bpf_object *obj, struct btf *btf)
+{
+	obj->btf_vmlinux_override = btf;
+}
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 42b2f36fd9f0..2b048ee5a9b2 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -225,6 +225,8 @@ LIBBPF_API int bpf_object__set_kversion(struct bpf_object *obj, __u32 kern_versi
 
 struct btf;
 LIBBPF_API struct btf *bpf_object__btf(const struct bpf_object *obj);
+struct btf_ext;
+LIBBPF_API struct btf_ext *bpf_object__btf_ext(const struct bpf_object *obj);
 LIBBPF_API int bpf_object__btf_fd(const struct bpf_object *obj);
 
 LIBBPF_DEPRECATED_SINCE(0, 7, "use bpf_object__find_program_by_name() instead")
@@ -290,6 +292,7 @@ LIBBPF_API LIBBPF_DEPRECATED("BPF program title is confusing term; please use bp
 const char *bpf_program__title(const struct bpf_program *prog, bool needs_copy);
 LIBBPF_API bool bpf_program__autoload(const struct bpf_program *prog);
 LIBBPF_API int bpf_program__set_autoload(struct bpf_program *prog, bool autoload);
+LIBBPF_API int bpf_program__sec_idx(const struct bpf_program *prog);
 
 /* returns program size in bytes */
 LIBBPF_DEPRECATED_SINCE(0, 7, "use bpf_program__insn_cnt() instead")
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b3938b3f8fc9..15da4075e0b5 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -392,6 +392,7 @@ LIBBPF_0.6.0 {
 		bpf_map__map_extra;
 		bpf_map__set_map_extra;
 		bpf_map_create;
+		bpf_object__btf_ext;
 		bpf_object__next_map;
 		bpf_object__next_program;
 		bpf_object__prev_map;
@@ -401,6 +402,7 @@ LIBBPF_0.6.0 {
 		bpf_program__flags;
 		bpf_program__insn_cnt;
 		bpf_program__insns;
+		bpf_program__sec_idx;
 		bpf_program__set_flags;
 		btf__add_btf;
 		btf__add_decl_tag;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 5dbe4f463880..b1962adb110c 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -524,4 +524,26 @@ static inline int ensure_good_fd(int fd)
 	return fd;
 }
 
+struct hashmap;
+
+int bpf_core_calc_relo_res(struct bpf_program *prog,
+			   const struct bpf_core_relo *relo,
+			   int relo_idx,
+			   const struct btf *local_btf,
+			   struct hashmap *cand_cache,
+			   struct bpf_core_relo_res *targ_res,
+			   struct bpf_core_spec *targ_spec);
+void bpf_object_set_vmlinux_override(struct bpf_object *obj, struct btf *btf);
+struct hashmap *bpf_core_create_cand_cache(void);
+void bpf_core_free_cand_cache(struct hashmap *cand_cache);
+
+struct bpf_program *find_prog_by_sec_insn(const struct bpf_object *obj,
+					  size_t sec_idx, size_t insn_idx);
+
+size_t bpf_object__get_nr_programs(const struct bpf_object *obj);
+
+struct bpf_program *
+bpf_object__get_program(const struct bpf_object *obj, unsigned int n);
+
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
diff --git a/tools/lib/bpf/relo_core.c b/tools/lib/bpf/relo_core.c
index 4f3552468624..66dfb7fa89a2 100644
--- a/tools/lib/bpf/relo_core.c
+++ b/tools/lib/bpf/relo_core.c
@@ -102,7 +102,7 @@ static const char *core_relo_kind_str(enum bpf_core_relo_kind kind)
 	}
 }
 
-static bool core_relo_is_field_based(enum bpf_core_relo_kind kind)
+bool core_relo_is_field_based(enum bpf_core_relo_kind kind)
 {
 	switch (kind) {
 	case BPF_CORE_FIELD_BYTE_OFFSET:
@@ -117,7 +117,7 @@ static bool core_relo_is_field_based(enum bpf_core_relo_kind kind)
 	}
 }
 
-static bool core_relo_is_type_based(enum bpf_core_relo_kind kind)
+bool core_relo_is_type_based(enum bpf_core_relo_kind kind)
 {
 	switch (kind) {
 	case BPF_CORE_TYPE_ID_LOCAL:
@@ -130,7 +130,7 @@ static bool core_relo_is_type_based(enum bpf_core_relo_kind kind)
 	}
 }
 
-static bool core_relo_is_enumval_based(enum bpf_core_relo_kind kind)
+bool core_relo_is_enumval_based(enum bpf_core_relo_kind kind)
 {
 	switch (kind) {
 	case BPF_CORE_ENUMVAL_EXISTS:
diff --git a/tools/lib/bpf/relo_core.h b/tools/lib/bpf/relo_core.h
index a28bf3711ce2..e969dfb032f4 100644
--- a/tools/lib/bpf/relo_core.h
+++ b/tools/lib/bpf/relo_core.h
@@ -84,4 +84,8 @@ int bpf_core_patch_insn(const char *prog_name, struct bpf_insn *insn,
 			int insn_idx, const struct bpf_core_relo *relo,
 			int relo_idx, const struct bpf_core_relo_res *res);
 
+bool core_relo_is_field_based(enum bpf_core_relo_kind kind);
+bool core_relo_is_type_based(enum bpf_core_relo_kind kind);
+bool core_relo_is_enumval_based(enum bpf_core_relo_kind kind);
+
 #endif
-- 
2.25.1

