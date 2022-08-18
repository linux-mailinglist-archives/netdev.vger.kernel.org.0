Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95DEB5985E2
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245306AbiHRObt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245180AbiHRObq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:31:46 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CB6B9F89;
        Thu, 18 Aug 2022 07:31:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d20so1703046pfq.5;
        Thu, 18 Aug 2022 07:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=51S9dT2G3aXePCnrE/PN1X8bOnyFVMn8Ux5epyAQWQw=;
        b=Snljo/+katzYm1S8ojYVqCaSaKESK1ljndsaJlzs3c8AhsrzYbRv9I6T1bQBxxgppR
         7T6YPv9CGg2pRiOTwx3jg27WxnB2YzkNqvaGBFMBO3Fw6+lCfz4SR3H/Cpmf/xlPbMaw
         J2aNdyXVOC5eliet6WkG0q/QNdHtRprClQoOLyotQNi7Vi2ynk2mepc4SAZtc773bHyh
         o9ykJMmMhaQz8teEky3Vke6Xn8Ppy5/K3jtvJXBpc2ssuO0anMN7Dpuwo312FLtSlW6B
         3vZ57EgRgMqllC8fRv5gzJQZS4151OfxP0rQE/n+geleYz4CO38s8n3Uo8ai/1Jevdf8
         ipTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=51S9dT2G3aXePCnrE/PN1X8bOnyFVMn8Ux5epyAQWQw=;
        b=JAjoJgZLusL2qPhRX/qTCVGaSepFyti/W4TlFwxZVGtYPlhgq8o7jKSnA4ZqF8HTkJ
         qxqS8iIm6iwNHS5w7lnKKL1Pz07oqLCiNfqYh2fMdfpeqehMnrzpIfDwpZIVtFoUbBGz
         /kZC+a79mNkyi8NBooyYxC8mmxKH/V25/PruWh3q5FV620p92RJrNeM61bP/k/kHBXZg
         FbzcESb4l2asmh/64oCrugyUz9Iaj3I7nfUXe/KnH8uiXwphLNujOPx8ggKPWYLsybGl
         T/XgBMD546C6DR9o44r8DZomRL46eWavnEhG82cBEukiq0T7ApdlUhZSUQHmBrek4XFX
         /tZw==
X-Gm-Message-State: ACgBeo0aZuHctLnbxrAa6qBLks2Up50nLpJy0gIvmiPCCjOMMJkl66wf
        KDRiacbkGItyHoQ67Xn/I7Q=
X-Google-Smtp-Source: AA6agR4/IcIPwFl8NjZf201BmyQdHaE6fvOSIZxi9N2e4RlcPtMrgMGi0rFoxp19D9oRoi7uY7hWEg==
X-Received: by 2002:a05:6a00:3691:b0:535:d465:45c5 with SMTP id dw17-20020a056a00369100b00535d46545c5mr2313132pfb.30.1660833105886;
        Thu, 18 Aug 2022 07:31:45 -0700 (PDT)
Received: from vultr.guest ([45.32.72.237])
        by smtp.gmail.com with ESMTPSA id h5-20020a63f905000000b003fdc16f5de2sm1379124pgi.15.2022.08.18.07.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 07:31:45 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org, tj@kernel.org,
        lizefan.x@bytedance.com
Cc:     cgroups@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next v2 03/12] bpf: Define bpf_map_{get,put}_memcg for !CONFIG_MEMCG_KMEM
Date:   Thu, 18 Aug 2022 14:31:09 +0000
Message-Id: <20220818143118.17733-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220818143118.17733-1-laoar.shao@gmail.com>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can use this helper when CONFIG_MEMCG_KMEM or CONFIG_MEMCG is not set.
It also moves bpf_map_{get,put}_memcg into include/linux/bpf.h, so
these two helpers can be used in other source files.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h        | 26 ++++++++++++++++++++++++++
 include/linux/memcontrol.h | 10 ++++++++++
 kernel/bpf/syscall.c       | 13 -------------
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a627a02..ded7d23 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -27,6 +27,7 @@
 #include <linux/bpfptr.h>
 #include <linux/btf.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/memcontrol.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -2572,4 +2573,29 @@ static inline void bpf_cgroup_atype_get(u32 attach_btf_id, int cgroup_atype) {}
 static inline void bpf_cgroup_atype_put(int cgroup_atype) {}
 #endif /* CONFIG_BPF_LSM */
 
+#ifdef CONFIG_MEMCG_KMEM
+static inline struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
+{
+	if (map->objcg)
+		return get_mem_cgroup_from_objcg(map->objcg);
+
+	return root_mem_cgroup;
+}
+
+static inline void bpf_map_put_memcg(struct mem_cgroup *memcg)
+{
+	mem_cgroup_put(memcg);
+}
+
+#else
+static inline struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
+{
+	return root_memcg();
+}
+
+static inline void bpf_map_put_memcg(struct mem_cgroup *memcg)
+{
+}
+#endif
+
 #endif /* _LINUX_BPF_H */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9ecead1..2f0a611 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -361,6 +361,11 @@ struct mem_cgroup {
 
 extern struct mem_cgroup *root_mem_cgroup;
 
+static inline struct mem_cgroup *root_memcg(void)
+{
+	return root_mem_cgroup;
+}
+
 enum page_memcg_data_flags {
 	/* page->memcg_data is a pointer to an objcgs vector */
 	MEMCG_DATA_OBJCGS = (1UL << 0),
@@ -1138,6 +1143,11 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 #define MEM_CGROUP_ID_SHIFT	0
 #define MEM_CGROUP_ID_MAX	0
 
+static inline struct mem_cgroup *root_memcg(void)
+{
+	return NULL;
+}
+
 static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 {
 	return NULL;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 2f18ae2..19c3a81 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -433,19 +433,6 @@ static void bpf_map_release_memcg(struct bpf_map *map)
 		obj_cgroup_put(map->objcg);
 }
 
-static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
-{
-	if (map->objcg)
-		return get_mem_cgroup_from_objcg(map->objcg);
-
-	return root_mem_cgroup;
-}
-
-static void bpf_map_put_memcg(struct mem_cgroup *memcg)
-{
-	mem_cgroup_put(memcg);
-}
-
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
 			   int node)
 {
-- 
1.8.3.1

