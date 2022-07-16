Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813A4576DD7
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 14:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiGPMUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 08:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiGPMUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 08:20:51 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183DD1B7A1;
        Sat, 16 Jul 2022 05:20:50 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LlS1D3wk8z19TyT;
        Sat, 16 Jul 2022 20:18:08 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Jul 2022 20:20:47 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Jul 2022 20:20:46 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next 2/5] libbpf: Unify memory address casting operation style
Date:   Sat, 16 Jul 2022 20:51:05 +0800
Message-ID: <20220716125108.1011206-3-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220716125108.1011206-1-pulehui@huawei.com>
References: <20220716125108.1011206-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory addresses are conceptually unsigned, (unsigned long) casting
makes more sense, so let's make a change for conceptual uniformity
and there is no functional change.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 tools/lib/bpf/bpf_prog_linfo.c | 8 ++++----
 tools/lib/bpf/btf.c            | 7 ++++---
 tools/lib/bpf/skel_internal.h  | 4 ++--
 tools/lib/bpf/usdt.c           | 4 ++--
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
index 5c503096ef43..5cf41a563ef5 100644
--- a/tools/lib/bpf/bpf_prog_linfo.c
+++ b/tools/lib/bpf/bpf_prog_linfo.c
@@ -127,7 +127,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 	prog_linfo->raw_linfo = malloc(data_sz);
 	if (!prog_linfo->raw_linfo)
 		goto err_free;
-	memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info, data_sz);
+	memcpy(prog_linfo->raw_linfo, (void *)(unsigned long)info->line_info, data_sz);
 
 	nr_jited_func = info->nr_jited_ksyms;
 	if (!nr_jited_func ||
@@ -148,7 +148,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 	if (!prog_linfo->raw_jited_linfo)
 		goto err_free;
 	memcpy(prog_linfo->raw_jited_linfo,
-	       (void *)(long)info->jited_line_info, data_sz);
+	       (void *)(unsigned long)info->jited_line_info, data_sz);
 
 	/* Number of jited_line_info per jited func */
 	prog_linfo->nr_jited_linfo_per_func = malloc(nr_jited_func *
@@ -166,8 +166,8 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 		goto err_free;
 
 	if (dissect_jited_func(prog_linfo,
-			       (__u64 *)(long)info->jited_ksyms,
-			       (__u32 *)(long)info->jited_func_lens))
+			       (__u64 *)(unsigned long)info->jited_ksyms,
+			       (__u32 *)(unsigned long)info->jited_func_lens))
 		goto err_free;
 
 	return prog_linfo;
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 2d14f1a52d7a..61e2ac2b6891 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1568,7 +1568,7 @@ static int btf_rewrite_str(__u32 *str_off, void *ctx)
 		return 0;
 
 	if (p->str_off_map &&
-	    hashmap__find(p->str_off_map, (void *)(long)*str_off, &mapped_off)) {
+	    hashmap__find(p->str_off_map, (void *)(unsigned long)*str_off, &mapped_off)) {
 		*str_off = (__u32)(long)mapped_off;
 		return 0;
 	}
@@ -1581,7 +1581,8 @@ static int btf_rewrite_str(__u32 *str_off, void *ctx)
 	 * performing expensive string comparisons.
 	 */
 	if (p->str_off_map) {
-		err = hashmap__append(p->str_off_map, (void *)(long)*str_off, (void *)(long)off);
+		err = hashmap__append(p->str_off_map, (void *)(unsigned long)*str_off,
+				      (void *)(unsigned long)off);
 		if (err)
 			return err;
 	}
@@ -3133,7 +3134,7 @@ static long hash_combine(long h, long value)
 static int btf_dedup_table_add(struct btf_dedup *d, long hash, __u32 type_id)
 {
 	return hashmap__append(d->dedup_table,
-			       (void *)hash, (void *)(long)type_id);
+			       (void *)hash, (void *)(unsigned long)type_id);
 }
 
 static int btf_dedup_hypot_map_add(struct btf_dedup *d,
diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
index bd6f4505e7b1..e2803e7cd6d9 100644
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -146,7 +146,7 @@ static inline void *skel_finalize_map_data(__u64 *init_val, size_t mmap_sz, int
 	struct bpf_map *map;
 	void *addr = NULL;
 
-	kvfree((void *) (long) *init_val);
+	kvfree((void *) (unsigned long) *init_val);
 	*init_val = ~0ULL;
 
 	/* At this point bpf_load_and_run() finished without error and
@@ -197,7 +197,7 @@ static inline void *skel_finalize_map_data(__u64 *init_val, size_t mmap_sz, int
 {
 	void *addr;
 
-	addr = mmap((void *) (long) *init_val, mmap_sz, flags, MAP_SHARED | MAP_FIXED, fd, 0);
+	addr = mmap((void *) (unsigned long) *init_val, mmap_sz, flags, MAP_SHARED | MAP_FIXED, fd, 0);
 	if (addr == (void *) -1)
 		return NULL;
 	return addr;
diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index d18e37982344..3e54b47f9e1b 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -915,7 +915,7 @@ static int allocate_spec_id(struct usdt_manager *man, struct hashmap *specs_hash
 		*spec_id = man->free_spec_ids[man->free_spec_cnt - 1];
 
 		/* cache spec ID for current spec string for future lookups */
-		err = hashmap__add(specs_hash, target->spec_str, (void *)(long)*spec_id);
+		err = hashmap__add(specs_hash, target->spec_str, (void *)(unsigned long)*spec_id);
 		if (err)
 			 return err;
 
@@ -928,7 +928,7 @@ static int allocate_spec_id(struct usdt_manager *man, struct hashmap *specs_hash
 		*spec_id = man->next_free_spec_id;
 
 		/* cache spec ID for current spec string for future lookups */
-		err = hashmap__add(specs_hash, target->spec_str, (void *)(long)*spec_id);
+		err = hashmap__add(specs_hash, target->spec_str, (void *)(unsigned long)*spec_id);
 		if (err)
 			 return err;
 
-- 
2.25.1

