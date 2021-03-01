Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC6B327794
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 07:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhCAG1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 01:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbhCAG0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 01:26:17 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFED6C061756
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 22:25:20 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id s16so9208548plr.9
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 22:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wh9K8k/cLdEa+pvuxX0zgE5b842GEaAUv1TfPTB1I1E=;
        b=a1njz4rSfNhYNlrVmnxZvIibOJ3N5IqT3x9MOJOzivPWjvWO7cRRE4PQQdR1+f2mBM
         E0Jkya+zdkPfmtLMf9tMZGa6ujnyrWnvRcaGnsVip8Nm3c8C5Zn3odFwF1uuAHlzMiYP
         P9Eps74BbRMqv2xdOugMvWCjfQCjogdmgHuo4KAKShWvT7QHAgL8K9X41llRif3QFHN1
         NNG+ohZ4yQsg8hp8jHSmKkinxDvnoEDptm5WTFkiXI1/fCzDo4YnjXgHAHQRxUny4u9B
         WJDupUt8w2sSdcLCT5kr/LZ3bTPVbyJ27SY8iotwHvJWdXL9DasADNr/tiPfSHK30r8v
         8spA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wh9K8k/cLdEa+pvuxX0zgE5b842GEaAUv1TfPTB1I1E=;
        b=WQpan0U/tdw0FEt6ssNdEjHEj68thsiE48kkwaOhbVbqddmLXuM+J1x/eEq6bla4s8
         9vDlpTo6/K31KEAmJEtxiBHDi9pyU8BDekDAqEvH2/oM/gdK8Xea1Rhxa7N7whTlWTKi
         nSEtN4N74iP3oKeMyojIS6KHeY8aZkPV+CCAgkxNAzFLizdvZcNgsHha/ucX65QHR4ym
         kaOT+fwq2rJ55ggL8bsGr2BIx2wWkg7LFwrz/2zQjRMSGjuE5Q6yjGP1yBPuqMvff9e1
         t1jFQWacJU6Tzo1m5TazpWv1yo6SHG/Uqco742L4JJtS/hjXy1HIz0W85iCNXxYR+h+Y
         TK1Q==
X-Gm-Message-State: AOAM532xLpIUH40Wi2sqJeEEgxLs8nuBHMBzqC1gCqoN6uVMzIroCghU
        +bsdfIASYHlZP4hHtNDk9ASZvw==
X-Google-Smtp-Source: ABdhPJz2R6TNlSFuQyimvuh+McsZ5qntIYM0Gtg8I9zxelrrwm2OitPXd7CeqNORMhI0Hu+T/1UfIA==
X-Received: by 2002:a17:902:ed82:b029:e2:d106:e76e with SMTP id e2-20020a170902ed82b02900e2d106e76emr14406195plj.38.1614579920255;
        Sun, 28 Feb 2021 22:25:20 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.227])
        by smtp.gmail.com with ESMTPSA id x6sm14304626pfd.12.2021.02.28.22.25.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Feb 2021 22:25:19 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     viro@zeniv.linux.org.uk, jack@suse.cz, amir73il@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org,
        vdavydov.dev@gmail.com, akpm@linux-foundation.org,
        shakeelb@google.com, guro@fb.com, songmuchun@bytedance.com,
        alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        chris@chrisdown.name, richard.weiyang@gmail.com, vbabka@suse.cz,
        mathieu.desnoyers@efficios.com, posk@google.com, jannh@google.com,
        iamjoonsoo.kim@lge.com, daniel.vetter@ffwll.ch, longman@redhat.com,
        walken@google.com, christian.brauner@ubuntu.com,
        ebiederm@xmission.com, keescook@chromium.org,
        krisman@collabora.com, esyr@redhat.com, surenb@google.com,
        elver@google.com
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        duanxiongchun@bytedance.com
Subject: [PATCH 3/5] mm: memcontrol: reparent the kmem pages on cgroup removal
Date:   Mon,  1 Mar 2021 14:22:25 +0800
Message-Id: <20210301062227.59292-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122)
In-Reply-To: <20210301062227.59292-1-songmuchun@bytedance.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the slab objects already reparent to it's parent memcg on
cgroup removal. But there are still some corner objects which are
not reparent (e.g. allocations larger than order-1 page on SLUB).
Actually those objects are allocated directly from the buddy allocator.
And they are chared as kmem to memcg via __memcg_kmem_charge_page().
Such objects are not reparent on cgroup removal.

So this patch aims to reparent kmem pages on cgroup removal. Doing
this is simple with help of the infrastructures of obj_cgroup.
Finally, the page->memcg_data points to an object cgroup for the
kmem page.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/memcontrol.h |  66 +++++++++++--------
 mm/memcontrol.c            | 155 ++++++++++++++++++++++++---------------------
 2 files changed, 124 insertions(+), 97 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1d2c82464c8c..27043478220f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -370,23 +370,15 @@ static inline bool page_memcg_charged(struct page *page)
 }
 
 /*
- * page_memcg_kmem - get the memory cgroup associated with a kmem page.
- * @page: a pointer to the page struct
+ * After the initialization objcg->memcg is always pointing at
+ * a valid memcg, but can be atomically swapped to the parent memcg.
  *
- * Returns a pointer to the memory cgroup associated with the kmem page,
- * or NULL. This function assumes that the page is known to have a proper
- * memory cgroup pointer. It is only suitable for kmem pages which means
- * PageMemcgKmem() returns true for this page.
+ * The caller must ensure that the returned memcg won't be released:
+ * e.g. acquire the rcu_read_lock or css_set_lock.
  */
-static inline struct mem_cgroup *page_memcg_kmem(struct page *page)
+static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
 {
-	unsigned long memcg_data = page->memcg_data;
-
-	VM_BUG_ON_PAGE(PageSlab(page), page);
-	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
-	VM_BUG_ON_PAGE(!(memcg_data & MEMCG_DATA_KMEM), page);
-
-	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+	return READ_ONCE(objcg->memcg);
 }
 
 /*
@@ -462,6 +454,17 @@ static inline struct mem_cgroup *page_memcg_check(struct page *page)
 	if (memcg_data & MEMCG_DATA_OBJCGS)
 		return NULL;
 
+	if (memcg_data & MEMCG_DATA_KMEM) {
+		struct obj_cgroup *objcg;
+
+		/*
+		 * The caller must ensure that the returned memcg won't be
+		 * released: e.g. acquire the rcu_read_lock or css_set_lock.
+		 */
+		objcg = (void *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+		return obj_cgroup_memcg(objcg);
+	}
+
 	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
@@ -520,6 +523,24 @@ static inline struct obj_cgroup **page_objcgs_check(struct page *page)
 	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
+/*
+ * page_objcg - get the object cgroup associated with a kmem page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the object cgroup associated with the kmem page,
+ * or NULL. This function assumes that the page is known to have an
+ * associated object cgroup. It's only safe to call this function
+ * against kmem pages (PageMemcgKmem() returns true).
+ */
+static inline struct obj_cgroup *page_objcg(struct page *page)
+{
+	unsigned long memcg_data = page->memcg_data;
+
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
+	VM_BUG_ON_PAGE(!(memcg_data & MEMCG_DATA_KMEM), page);
+
+	return (struct obj_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+}
 #else
 static inline struct obj_cgroup **page_objcgs(struct page *page)
 {
@@ -530,6 +551,11 @@ static inline struct obj_cgroup **page_objcgs_check(struct page *page)
 {
 	return NULL;
 }
+
+static inline struct obj_cgroup *page_objcg(struct page *page)
+{
+	return NULL;
+}
 #endif
 
 static __always_inline bool memcg_stat_item_in_bytes(int idx)
@@ -748,18 +774,6 @@ static inline void obj_cgroup_put(struct obj_cgroup *objcg)
 	percpu_ref_put(&objcg->refcnt);
 }
 
-/*
- * After the initialization objcg->memcg is always pointing at
- * a valid memcg, but can be atomically swapped to the parent memcg.
- *
- * The caller must ensure that the returned memcg won't be released:
- * e.g. acquire the rcu_read_lock or css_set_lock.
- */
-static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
-{
-	return READ_ONCE(objcg->memcg);
-}
-
 static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
 	if (memcg)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bfd6efe1e196..39cb8c5bf8b2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -856,10 +856,16 @@ void __mod_lruvec_page_state(struct page *page, enum node_stat_item idx,
 {
 	struct page *head = compound_head(page); /* rmap on tail pages */
 	struct mem_cgroup *memcg;
-	pg_data_t *pgdat = page_pgdat(page);
+	pg_data_t *pgdat;
 	struct lruvec *lruvec;
 
-	memcg = PageMemcgKmem(head) ? page_memcg_kmem(head) : page_memcg(head);
+	if (PageMemcgKmem(head)) {
+		__mod_lruvec_kmem_state(page_to_virt(head), idx, val);
+		return;
+	}
+
+	pgdat = page_pgdat(head);
+	memcg = page_memcg(head);
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
 		__mod_node_page_state(pgdat, idx, val);
@@ -1056,24 +1062,6 @@ static __always_inline struct mem_cgroup *active_memcg(void)
 		return current->active_memcg;
 }
 
-static __always_inline struct mem_cgroup *get_active_memcg(void)
-{
-	struct mem_cgroup *memcg;
-
-	rcu_read_lock();
-	memcg = active_memcg();
-	if (memcg) {
-		/* current->active_memcg must hold a ref. */
-		if (WARN_ON_ONCE(!css_tryget(&memcg->css)))
-			memcg = root_mem_cgroup;
-		else
-			memcg = current->active_memcg;
-	}
-	rcu_read_unlock();
-
-	return memcg;
-}
-
 static __always_inline bool memcg_kmem_bypass(void)
 {
 	/* Allow remote memcg charging from any context. */
@@ -1088,20 +1076,6 @@ static __always_inline bool memcg_kmem_bypass(void)
 }
 
 /**
- * If active memcg is set, do not fallback to current->mm->memcg.
- */
-static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
-{
-	if (memcg_kmem_bypass())
-		return NULL;
-
-	if (unlikely(active_memcg()))
-		return get_active_memcg();
-
-	return get_mem_cgroup_from_mm(current->mm);
-}
-
-/**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
  * @prev: previously returned memcg, NULL on first invocation
@@ -3148,18 +3122,18 @@ static void __memcg_kmem_uncharge(struct mem_cgroup *memcg, unsigned int nr_page
  */
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
 {
-	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 	int ret = 0;
 
-	memcg = get_mem_cgroup_from_current();
-	if (memcg && !mem_cgroup_is_root(memcg)) {
-		ret = __memcg_kmem_charge(memcg, gfp, 1 << order);
+	objcg = get_obj_cgroup_from_current();
+	if (objcg) {
+		ret = obj_cgroup_charge_page(objcg, gfp, 1 << order);
 		if (!ret) {
-			page->memcg_data = (unsigned long)memcg |
+			page->memcg_data = (unsigned long)objcg |
 				MEMCG_DATA_KMEM;
 			return 0;
 		}
-		css_put(&memcg->css);
+		obj_cgroup_put(objcg);
 	}
 	return ret;
 }
@@ -3171,17 +3145,18 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order)
  */
 void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
-	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 	unsigned int nr_pages = 1 << order;
 
 	if (!page_memcg_charged(page))
 		return;
 
-	memcg = page_memcg_kmem(page);
-	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
-	__memcg_kmem_uncharge(memcg, nr_pages);
+	VM_BUG_ON_PAGE(!PageMemcgKmem(page), page);
+
+	objcg = page_objcg(page);
+	obj_cgroup_uncharge_page(objcg, nr_pages);
 	page->memcg_data = 0;
-	css_put(&memcg->css);
+	obj_cgroup_put(objcg);
 }
 
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
@@ -6798,8 +6773,12 @@ struct uncharge_gather {
 	struct mem_cgroup *memcg;
 	unsigned long nr_pages;
 	unsigned long pgpgout;
-	unsigned long nr_kmem;
 	struct page *dummy_page;
+
+#ifdef CONFIG_MEMCG_KMEM
+	struct obj_cgroup *objcg;
+	unsigned long nr_kmem;
+#endif
 };
 
 static inline void uncharge_gather_clear(struct uncharge_gather *ug)
@@ -6811,12 +6790,21 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 {
 	unsigned long flags;
 
+#ifdef CONFIG_MEMCG_KMEM
+	if (ug->objcg) {
+		obj_cgroup_uncharge_page(ug->objcg, ug->nr_kmem);
+		/* drop reference from uncharge_kmem_page */
+		obj_cgroup_put(ug->objcg);
+	}
+#endif
+
+	if (!ug->memcg)
+		return;
+
 	if (!mem_cgroup_is_root(ug->memcg)) {
 		page_counter_uncharge(&ug->memcg->memory, ug->nr_pages);
 		if (do_memsw_account())
 			page_counter_uncharge(&ug->memcg->memsw, ug->nr_pages);
-		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && ug->nr_kmem)
-			page_counter_uncharge(&ug->memcg->kmem, ug->nr_kmem);
 		memcg_oom_recover(ug->memcg);
 	}
 
@@ -6826,26 +6814,40 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 	memcg_check_events(ug->memcg, ug->dummy_page);
 	local_irq_restore(flags);
 
-	/* drop reference from uncharge_page */
+	/* drop reference from uncharge_user_page */
 	css_put(&ug->memcg->css);
 }
 
-static void uncharge_page(struct page *page, struct uncharge_gather *ug)
+#ifdef CONFIG_MEMCG_KMEM
+static void uncharge_kmem_page(struct page *page, struct uncharge_gather *ug)
 {
-	unsigned long nr_pages;
-	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg = page_objcg(page);
 
-	VM_BUG_ON_PAGE(PageLRU(page), page);
+	if (ug->objcg != objcg) {
+		if (ug->objcg) {
+			uncharge_batch(ug);
+			uncharge_gather_clear(ug);
+		}
+		ug->objcg = objcg;
 
-	if (!page_memcg_charged(page))
-		return;
+		/* pairs with obj_cgroup_put in uncharge_batch */
+		obj_cgroup_get(ug->objcg);
+	}
+
+	ug->nr_kmem += compound_nr(page);
+	page->memcg_data = 0;
+	obj_cgroup_put(ug->objcg);
+}
+#else
+static void uncharge_kmem_page(struct page *page, struct uncharge_gather *ug)
+{
+}
+#endif
+
+static void uncharge_user_page(struct page *page, struct uncharge_gather *ug)
+{
+	struct mem_cgroup *memcg = page_memcg(page);
 
-	/*
-	 * Nobody should be changing or seriously looking at
-	 * page memcg at this point, we have fully exclusive
-	 * access to the page.
-	 */
-	memcg = PageMemcgKmem(page) ? page_memcg_kmem(page) : page_memcg(page);
 	if (ug->memcg != memcg) {
 		if (ug->memcg) {
 			uncharge_batch(ug);
@@ -6856,18 +6858,30 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
 		/* pairs with css_put in uncharge_batch */
 		css_get(&ug->memcg->css);
 	}
+	ug->pgpgout++;
+	ug->dummy_page = page;
+
+	ug->nr_pages += compound_nr(page);
+	page->memcg_data = 0;
+	css_put(&ug->memcg->css);
+}
 
-	nr_pages = compound_nr(page);
-	ug->nr_pages += nr_pages;
+static void uncharge_page(struct page *page, struct uncharge_gather *ug)
+{
+	VM_BUG_ON_PAGE(PageLRU(page), page);
 
+	if (!page_memcg_charged(page))
+		return;
+
+	/*
+	 * Nobody should be changing or seriously looking at
+	 * page memcg at this point, we have fully exclusive
+	 * access to the page.
+	 */
 	if (PageMemcgKmem(page))
-		ug->nr_kmem += nr_pages;
+		uncharge_kmem_page(page, ug);
 	else
-		ug->pgpgout++;
-
-	ug->dummy_page = page;
-	page->memcg_data = 0;
-	css_put(&ug->memcg->css);
+		uncharge_user_page(page, ug);
 }
 
 /**
@@ -6910,8 +6924,7 @@ void mem_cgroup_uncharge_list(struct list_head *page_list)
 	uncharge_gather_clear(&ug);
 	list_for_each_entry(page, page_list, lru)
 		uncharge_page(page, &ug);
-	if (ug.memcg)
-		uncharge_batch(&ug);
+	uncharge_batch(&ug);
 }
 
 /**
-- 
2.11.0

