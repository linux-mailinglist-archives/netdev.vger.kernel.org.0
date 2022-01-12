Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F7248C605
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 15:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354142AbiALO1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 09:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354144AbiALO11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 09:27:27 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4F6C06175B
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:21 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id h4so3113023qth.11
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 06:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mMJ7CAtkh8neADG+ZdmCPKmqxfEVI9IMD/3a1+r/7z0=;
        b=dvPZKwZmpOr6rQ7kjEV23P3ZkenMGKR7bmQ0UatOAlWfbh7trXz3chm/FajdWGIWEZ
         CZ2XbYSKkxeT+0wKy0GXJhv0cWBbb6sldxIkiYCCOvOdT3cnO3rcuqJMYTeKV37sbRmY
         UsNMFAVNTfp/cqB5D/xbNpTHUVklwYGi6iliw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mMJ7CAtkh8neADG+ZdmCPKmqxfEVI9IMD/3a1+r/7z0=;
        b=pcGeEm7btlQ87Pc8B+Y/IdCkAlMeFEUEcHfdTXwX1pvG1WB8kwS9k0o2GMVnl7vxyi
         TuBmHM5iY10BJA5roN/L7cCgdRwQ95bsKfHgVt2rw3AJxRqlDnYzlcO/UaY+5mJRlx+I
         Kq5eQBYt+dZ1qDwWtLMJvY+WKFW2tUPcIADpxzHpqn37p7o3lXb4fSW44VOi8bP0A7ca
         q+J+8afPHQn/aEb0e0wu7YuesViMU+UofaW5zcpvbhDNNqGpxv2Bc7ns11NteUnmy1TK
         4BghBRNwI0dAyUPQvxsrwmRxpqSWyFmCCkyMbHUkUUXNo8yUDud405ALdEVSjg1NGjkA
         DGSg==
X-Gm-Message-State: AOAM530sKPVaeP1VkBqGthHsOFIjAewe395vnGSSlV8DIn+a7nyX90CX
        u0epsnWitlb6q5YrUpo4+LFCEDR8xeyGxYoisstoPiBNqvwjH1k6oG5UfqfsXZ5srHSwQ/DMyI9
        KyhFZDmQE3mz5kiOP9OgU/BYthvaezCiK35fscOqTjUyOJqXlqcKazSCLKbgy3pqz5TGhRMVI
X-Google-Smtp-Source: ABdhPJzCeeAf3pz4HrESFMOweXd6tDn8jeli3il98bEtCHWEpAyeQlNv/wjXwZdOeAMvn95ANzlBvQ==
X-Received: by 2002:a05:622a:1813:: with SMTP id t19mr7915214qtc.256.1641997638963;
        Wed, 12 Jan 2022 06:27:18 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id h11sm8776690qko.59.2022.01.12.06.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 06:27:18 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v4 2/8] libbpf: Implement changes needed for BTFGen in bpftool
Date:   Wed, 12 Jan 2022 09:27:03 -0500
Message-Id: <20220112142709.102423-3-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220112142709.102423-1-mauricio@kinvolk.io>
References: <20220112142709.102423-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit extends libbpf with the features that are needed to
implement BTFGen:

- Implement bpf_core_create_cand_cache() and bpf_core_free_cand_cache()
to handle candidates cache.
- Expose bpf_core_add_cands() and bpf_core_free_cands to handle
candidates list.
- Expose bpf_core_calc_relo_insn() to bpftool.

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
---
 tools/lib/bpf/Makefile          |  2 +-
 tools/lib/bpf/libbpf.c          | 43 +++++++++++++++++++++------------
 tools/lib/bpf/libbpf_internal.h | 12 +++++++++
 3 files changed, 41 insertions(+), 16 deletions(-)

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
index 4959c03a46f4..344b8b8e8a50 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5185,18 +5185,18 @@ size_t bpf_core_essential_name_len(const char *name)
 	return n;
 }
 
-static void bpf_core_free_cands(struct bpf_core_cand_list *cands)
+void bpf_core_free_cands(struct bpf_core_cand_list *cands)
 {
 	free(cands->cands);
 	free(cands);
 }
 
-static int bpf_core_add_cands(struct bpf_core_cand *local_cand,
-			      size_t local_essent_len,
-			      const struct btf *targ_btf,
-			      const char *targ_btf_name,
-			      int targ_start_id,
-			      struct bpf_core_cand_list *cands)
+int bpf_core_add_cands(struct bpf_core_cand *local_cand,
+		       size_t local_essent_len,
+		       const struct btf *targ_btf,
+		       const char *targ_btf_name,
+		       int targ_start_id,
+		       struct bpf_core_cand_list *cands)
 {
 	struct bpf_core_cand *new_cands, *cand;
 	const struct btf_type *t, *local_t;
@@ -5567,6 +5567,24 @@ static int bpf_core_resolve_relo(struct bpf_program *prog,
 				       targ_res);
 }
 
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
+}
+
 static int
 bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 {
@@ -5574,7 +5592,6 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 	struct bpf_core_relo_res targ_res;
 	const struct bpf_core_relo *rec;
 	const struct btf_ext_info *seg;
-	struct hashmap_entry *entry;
 	struct hashmap *cand_cache = NULL;
 	struct bpf_program *prog;
 	struct bpf_insn *insn;
@@ -5593,7 +5610,7 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 		}
 	}
 
-	cand_cache = hashmap__new(bpf_core_hash_fn, bpf_core_equal_fn, NULL);
+	cand_cache = bpf_core_create_cand_cache();
 	if (IS_ERR(cand_cache)) {
 		err = PTR_ERR(cand_cache);
 		goto out;
@@ -5697,12 +5714,8 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
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
 
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 1565679eb432..0c258c252919 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -526,4 +526,16 @@ static inline int ensure_good_fd(int fd)
 	return fd;
 }
 
+struct hashmap;
+
+struct hashmap *bpf_core_create_cand_cache(void);
+void bpf_core_free_cand_cache(struct hashmap *cand_cache);
+int bpf_core_add_cands(struct bpf_core_cand *local_cand,
+		       size_t local_essent_len,
+		       const struct btf *targ_btf,
+		       const char *targ_btf_name,
+		       int targ_start_id,
+		       struct bpf_core_cand_list *cands);
+void bpf_core_free_cands(struct bpf_core_cand_list *cands);
+
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
-- 
2.25.1

