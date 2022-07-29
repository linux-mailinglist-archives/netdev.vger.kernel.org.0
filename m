Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8F8585268
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237350AbiG2PYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237432AbiG2PXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:23:41 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B7183F33;
        Fri, 29 Jul 2022 08:23:36 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 12so4280851pga.1;
        Fri, 29 Jul 2022 08:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XcXG9h+ovnptbv0fZ4hOiyXlQOwZMvCOBp/cMXUb/u8=;
        b=IWFv+lclDgiPa3ymhPY9q6aCXqaeG/qISakVlu0Nxc7vWmoHPhw+T4sGoi6JRopsnP
         beNYUbztVH4F05vhDRIEp5hpbNu8la/64Le0T/TATOhuurnQSIn4f4qzv3WX+Zxu5YlA
         BzTeCxjeYl9BaU8uiZ1pVgzP/UKYZnzLA2YkKOufmRKU7RGSyTMesWuhc7upiOeKpLNr
         hZtaAoJLyXQgVZ0QK/wkFk1ll2QD+5tmLlkr0eaIISFO6LKcrhBECvUjmQ5GANuf84KW
         AOsNdYkzh6EcccD3engjSYNrarMZbKYDurIFIbooVl9jO899EeL5EM2L1C6q03lTpL4l
         o9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XcXG9h+ovnptbv0fZ4hOiyXlQOwZMvCOBp/cMXUb/u8=;
        b=SjIOF6OTBawk1+6hrp3mt/XojpyRC0BcK3ud1++oF5M2ayYNaWWJP47xqEBGXyhTll
         F+cAW8uad7u0TkJqCptm93MUxoOekQUz8lS4LlyjCinVst1HiisN4amhh4vzVkX+3Cd/
         8bWHKYNHnaW1LiYKrEpBLZsr3SihkbZj+SbDZP4t9qIjPdBswmWeeZEGQVx27OSagXqQ
         dV5XlJbhzSVAOzB8Ds1zgbYoECFvbi2lsg7pxjMcZqjH/qO02y9KRFSImbt6uLudWIzJ
         2XjdPRjZwxBirlSWWtgCdqUR+TN2GqQPvbHdvpa/krO568a/+nJ9xyKkapfurIa3nws4
         PqsQ==
X-Gm-Message-State: ACgBeo0liLWZh5tDOOsG8QWRAW0nvS5MoogFODiL9OnoROUuavjGs7pX
        3h+8Zjivn7UqeAzZHe3i9zY=
X-Google-Smtp-Source: AA6agR7SIQhSbBEU1Bv1FwPss3jvTX+PEYUQva3Awy8g6XTzQUfPeNSOJJ5hWGFT56tk2s0IpV4uIQ==
X-Received: by 2002:aa7:8289:0:b0:52c:e97c:dbe4 with SMTP id s9-20020aa78289000000b0052ce97cdbe4mr860524pfm.49.1659108215736;
        Fri, 29 Jul 2022 08:23:35 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:2912:5400:4ff:fe16:4344])
        by smtp.gmail.com with ESMTPSA id b12-20020a1709027e0c00b0016d3a354cffsm3714219plm.89.2022.07.29.08.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:23:34 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
        mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next 07/15] bpf: Define bpf_map_get_memcg for !CONFIG_MEMCG_KMEM
Date:   Fri, 29 Jul 2022 15:23:08 +0000
Message-Id: <20220729152316.58205-8-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220729152316.58205-1-laoar.shao@gmail.com>
References: <20220729152316.58205-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Then we can use this helper when CONFIG_MEMCG_KMEM is not set.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/memcontrol.h | 10 ++++++++++
 kernel/bpf/syscall.c       |  7 ++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9ecead1042b9..2f0a611f12e5 100644
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
index a6f68ade200f..7289ee1a300a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -433,7 +433,7 @@ static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
 	if (map->objcg)
 		return get_mem_cgroup_from_objcg(map->objcg);
 
-	return root_mem_cgroup;
+	return root_memcg();
 }
 
 void *bpf_map_kmalloc_node(const struct bpf_map *map, size_t size, gfp_t flags,
@@ -488,6 +488,11 @@ static void bpf_map_save_memcg(struct bpf_map *map)
 static void bpf_map_release_memcg(struct bpf_map *map)
 {
 }
+
+static struct mem_cgroup *bpf_map_get_memcg(const struct bpf_map *map)
+{
+	return root_memcg();
+}
 #endif
 
 /*
-- 
2.17.1

