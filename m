Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF95C2B580B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgKQDlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:41:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16514 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727159AbgKQDlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:41:21 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3cDSQ024291
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=cDd1NKn6O4LwQjoa3dh03AFPBSMzttLroNcrI6vKELU=;
 b=WyevmXhthTF4xNsyhwZTkN1rL18tt9Q2BSJa8GYXEHPvaSIWRvkwSOy7KQgtw2S7o6yG
 +KdNG9Ao0Vk8K0cCgARVnFx7FcKxjt1aPeakynT1+2UbbRU7pZCorRLMaBhkzogE6Fqw
 bwr2b9YAeL77QLeoBv7SwhxCaF5FdwytRco= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34uphj53p7-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:19 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 19:41:13 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 15B38C63A58; Mon, 16 Nov 2020 19:41:10 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v6 01/34] mm: memcontrol: use helpers to read page's memcg data
Date:   Mon, 16 Nov 2020 19:40:35 -0800
Message-ID: <20201117034108.1186569-2-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117034108.1186569-1-guro@fb.com>
References: <20201117034108.1186569-1-guro@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_01:2020-11-13,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 clxscore=1015 suspectscore=3 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170027
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch series "mm: allow mapping accounted kernel pages to userspace", v6.

Currently a non-slab kernel page which has been charged to a memory cgroup
can't be mapped to userspace.  The underlying reason is simple: PageKmemcg
flag is defined as a page type (like buddy, offline, etc), so it takes a
bit from a page->mapped counter.  Pages with a type set can't be mapped to
userspace.

But in general the kmemcg flag has nothing to do with mapping to
userspace.  It only means that the page has been accounted by the page
allocator, so it has to be properly uncharged on release.

Some bpf maps are mapping the vmalloc-based memory to userspace, and their
memory can't be accounted because of this implementation detail.

This patchset removes this limitation by moving the PageKmemcg flag into
one of the free bits of the page->mem_cgroup pointer.  Also it formalizes
accesses to the page->mem_cgroup and page->obj_cgroups using new helpers,
adds several checks and removes a couple of obsolete functions.  As the
result the code became more robust with fewer open-coded bit tricks.

This patch (of 4):

Currently there are many open-coded reads of the page->mem_cgroup pointer,
as well as a couple of read helpers, which are barely used.

It creates an obstacle on a way to reuse some bits of the pointer for
storing additional bits of information.  In fact, we already do this for
slab pages, where the last bit indicates that a pointer has an attached
vector of objcg pointers instead of a regular memcg pointer.

This commits uses 2 existing helpers and introduces a new helper to
converts all read sides to calls of these helpers:
  struct mem_cgroup *page_memcg(struct page *page);
  struct mem_cgroup *page_memcg_rcu(struct page *page);
  struct mem_cgroup *page_memcg_check(struct page *page);

page_memcg_check() is intended to be used in cases when the page can be a
slab page and have a memcg pointer pointing at objcg vector.  It does
check the lowest bit, and if set, returns NULL.  page_memcg() contains a
VM_BUG_ON_PAGE() check for the page not being a slab page.

To make sure nobody uses a direct access, struct page's
mem_cgroup/obj_cgroups is converted to unsigned long memcg_data.

Link: https://lkml.kernel.org/r/20201027001657.3398190-1-guro@fb.com
Link: https://lkml.kernel.org/r/20201027001657.3398190-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/buffer.c                      |   2 +-
 fs/iomap/buffered-io.c           |   2 +-
 include/linux/memcontrol.h       | 114 ++++++++++++++++++++++++++---
 include/linux/mm.h               |  22 ------
 include/linux/mm_types.h         |   5 +-
 include/trace/events/writeback.h |   2 +-
 kernel/fork.c                    |   7 +-
 mm/debug.c                       |   4 +-
 mm/huge_memory.c                 |   4 +-
 mm/memcontrol.c                  | 121 ++++++++++++++-----------------
 mm/page_alloc.c                  |   4 +-
 mm/page_io.c                     |   6 +-
 mm/slab.h                        |   9 +--
 mm/workingset.c                  |   2 +-
 14 files changed, 184 insertions(+), 120 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 23f645657488..b56f99f82b5b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -657,7 +657,7 @@ int __set_page_dirty_buffers(struct page *page)
 		} while (bh !=3D head);
 	}
 	/*
-	 * Lock out page->mem_cgroup migration to keep PageDirty
+	 * Lock out page's memcg migration to keep PageDirty
 	 * synchronized with per-memcg dirty page counters.
 	 */
 	lock_page_memcg(page);
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 10cc7979ce38..16a1e82e3aeb 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -650,7 +650,7 @@ iomap_set_page_dirty(struct page *page)
 		return !TestSetPageDirty(page);
=20
 	/*
-	 * Lock out page->mem_cgroup migration to keep PageDirty
+	 * Lock out page's memcg migration to keep PageDirty
 	 * synchronized with per-memcg dirty page counters.
 	 */
 	lock_page_memcg(page);
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e391e3c56de5..f95c1433461c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -343,6 +343,79 @@ struct mem_cgroup {
=20
 extern struct mem_cgroup *root_mem_cgroup;
=20
+/*
+ * page_memcg - get the memory cgroup associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the memory cgroup associated with the page,
+ * or NULL. This function assumes that the page is known to have a
+ * proper memory cgroup pointer. It's not safe to call this function
+ * against some type of pages, e.g. slab pages or ex-slab pages.
+ *
+ * Any of the following ensures page and memcg binding stability:
+ * - the page lock
+ * - LRU isolation
+ * - lock_page_memcg()
+ * - exclusive reference
+ */
+static inline struct mem_cgroup *page_memcg(struct page *page)
+{
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	return (struct mem_cgroup *)page->memcg_data;
+}
+
+/*
+ * page_memcg_rcu - locklessly get the memory cgroup associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the memory cgroup associated with the page,
+ * or NULL. This function assumes that the page is known to have a
+ * proper memory cgroup pointer. It's not safe to call this function
+ * against some type of pages, e.g. slab pages or ex-slab pages.
+ */
+static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
+{
+	VM_BUG_ON_PAGE(PageSlab(page), page);
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	return (struct mem_cgroup *)READ_ONCE(page->memcg_data);
+}
+
+/*
+ * page_memcg_check - get the memory cgroup associated with a page
+ * @page: a pointer to the page struct
+ *
+ * Returns a pointer to the memory cgroup associated with the page,
+ * or NULL. This function unlike page_memcg() can take any  page
+ * as an argument. It has to be used in cases when it's not known if a page
+ * has an associated memory cgroup pointer or an object cgroups vector.
+ *
+ * Any of the following ensures page and memcg binding stability:
+ * - the page lock
+ * - LRU isolation
+ * - lock_page_memcg()
+ * - exclusive reference
+ */
+static inline struct mem_cgroup *page_memcg_check(struct page *page)
+{
+	/*
+	 * Because page->memcg_data might be changed asynchronously
+	 * for slab pages, READ_ONCE() should be used here.
+	 */
+	unsigned long memcg_data =3D READ_ONCE(page->memcg_data);
+
+	/*
+	 * The lowest bit set means that memcg isn't a valid
+	 * memcg pointer, but a obj_cgroups pointer.
+	 * In this case the page is shared and doesn't belong
+	 * to any specific memory cgroup.
+	 */
+	if (memcg_data & 0x1UL)
+		return NULL;
+
+	return (struct mem_cgroup *)memcg_data;
+}
+
 static __always_inline bool memcg_stat_item_in_bytes(int idx)
 {
 	if (idx =3D=3D MEMCG_PERCPU_B)
@@ -743,15 +816,19 @@ static inline void mod_memcg_state(struct mem_cgroup =
*memcg,
 static inline void __mod_memcg_page_state(struct page *page,
 					  int idx, int val)
 {
-	if (page->mem_cgroup)
-		__mod_memcg_state(page->mem_cgroup, idx, val);
+	struct mem_cgroup *memcg =3D page_memcg(page);
+
+	if (memcg)
+		__mod_memcg_state(memcg, idx, val);
 }
=20
 static inline void mod_memcg_page_state(struct page *page,
 					int idx, int val)
 {
-	if (page->mem_cgroup)
-		mod_memcg_state(page->mem_cgroup, idx, val);
+	struct mem_cgroup *memcg =3D page_memcg(page);
+
+	if (memcg)
+		mod_memcg_state(memcg, idx, val);
 }
=20
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
@@ -834,16 +911,17 @@ static inline void __mod_lruvec_page_state(struct pag=
e *page,
 					   enum node_stat_item idx, int val)
 {
 	struct page *head =3D compound_head(page); /* rmap on tail pages */
+	struct mem_cgroup *memcg =3D page_memcg(head);
 	pg_data_t *pgdat =3D page_pgdat(page);
 	struct lruvec *lruvec;
=20
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!head->mem_cgroup) {
+	if (!memcg) {
 		__mod_node_page_state(pgdat, idx, val);
 		return;
 	}
=20
-	lruvec =3D mem_cgroup_lruvec(head->mem_cgroup, pgdat);
+	lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
 	__mod_lruvec_state(lruvec, idx, val);
 }
=20
@@ -878,8 +956,10 @@ static inline void count_memcg_events(struct mem_cgrou=
p *memcg,
 static inline void count_memcg_page_event(struct page *page,
 					  enum vm_event_item idx)
 {
-	if (page->mem_cgroup)
-		count_memcg_events(page->mem_cgroup, idx, 1);
+	struct mem_cgroup *memcg =3D page_memcg(page);
+
+	if (memcg)
+		count_memcg_events(memcg, idx, 1);
 }
=20
 static inline void count_memcg_event_mm(struct mm_struct *mm,
@@ -941,6 +1021,22 @@ void mem_cgroup_split_huge_fixup(struct page *head);
=20
 struct mem_cgroup;
=20
+static inline struct mem_cgroup *page_memcg(struct page *page)
+{
+	return NULL;
+}
+
+static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return NULL;
+}
+
+static inline struct mem_cgroup *page_memcg_check(struct page *page)
+{
+	return NULL;
+}
+
 static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 {
 	return true;
@@ -1430,7 +1526,7 @@ static inline void mem_cgroup_track_foreign_dirty(str=
uct page *page,
 	if (mem_cgroup_disabled())
 		return;
=20
-	if (unlikely(&page->mem_cgroup->css !=3D wb->memcg_css))
+	if (unlikely(&page_memcg(page)->css !=3D wb->memcg_css))
 		mem_cgroup_track_foreign_dirty_slowpath(page, wb);
 }
=20
diff --git a/include/linux/mm.h b/include/linux/mm.h
index db6ae4d3fb4e..6b0c9d2c1d10 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1484,28 +1484,6 @@ static inline void set_page_links(struct page *page,=
 enum zone_type zone,
 #endif
 }
=20
-#ifdef CONFIG_MEMCG
-static inline struct mem_cgroup *page_memcg(struct page *page)
-{
-	return page->mem_cgroup;
-}
-static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
-{
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	return READ_ONCE(page->mem_cgroup);
-}
-#else
-static inline struct mem_cgroup *page_memcg(struct page *page)
-{
-	return NULL;
-}
-static inline struct mem_cgroup *page_memcg_rcu(struct page *page)
-{
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	return NULL;
-}
-#endif
-
 /*
  * Some inline functions in vmstat.h depend on page_zone()
  */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5a9238f6caad..80f5d755c037 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -199,10 +199,7 @@ struct page {
 	atomic_t _refcount;
=20
 #ifdef CONFIG_MEMCG
-	union {
-		struct mem_cgroup *mem_cgroup;
-		struct obj_cgroup **obj_cgroups;
-	};
+	unsigned long memcg_data;
 #endif
=20
 	/*
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeb=
ack.h
index e7cbccc7c14c..39a40dfb578a 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -257,7 +257,7 @@ TRACE_EVENT(track_foreign_dirty,
 		__entry->ino		=3D inode ? inode->i_ino : 0;
 		__entry->memcg_id	=3D wb->memcg_css->id;
 		__entry->cgroup_ino	=3D __trace_wb_assign_cgroup(wb);
-		__entry->page_cgroup_ino =3D cgroup_ino(page->mem_cgroup->css.cgroup);
+		__entry->page_cgroup_ino =3D cgroup_ino(page_memcg(page)->css.cgroup);
 	),
=20
 	TP_printk("bdi %s[%llu]: ino=3D%lu memcg_id=3D%u cgroup_ino=3D%lu page_cg=
roup_ino=3D%lu",
diff --git a/kernel/fork.c b/kernel/fork.c
index 6d266388d380..cbd4f6f58409 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -404,9 +404,10 @@ static int memcg_charge_kernel_stack(struct task_struc=
t *tsk)
=20
 		for (i =3D 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
 			/*
-			 * If memcg_kmem_charge_page() fails, page->mem_cgroup
-			 * pointer is NULL, and memcg_kmem_uncharge_page() in
-			 * free_thread_stack() will ignore this page.
+			 * If memcg_kmem_charge_page() fails, page's
+			 * memory cgroup pointer is NULL, and
+			 * memcg_kmem_uncharge_page() in free_thread_stack()
+			 * will ignore this page.
 			 */
 			ret =3D memcg_kmem_charge_page(vm->pages[i], GFP_KERNEL,
 						     0);
diff --git a/mm/debug.c b/mm/debug.c
index ccca576b2899..8a40b3fefbeb 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -182,8 +182,8 @@ void __dump_page(struct page *page, const char *reason)
 		pr_warn("page dumped because: %s\n", reason);
=20
 #ifdef CONFIG_MEMCG
-	if (!page_poisoned && page->mem_cgroup)
-		pr_warn("page->mem_cgroup:%px\n", page->mem_cgroup);
+	if (!page_poisoned && page->memcg_data)
+		pr_warn("pages's memcg:%lx\n", page->memcg_data);
 #endif
 }
=20
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9474dbc150ed..cedfb3503411 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -470,7 +470,7 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struc=
t *vma)
 #ifdef CONFIG_MEMCG
 static inline struct deferred_split *get_deferred_split_queue(struct page =
*page)
 {
-	struct mem_cgroup *memcg =3D compound_head(page)->mem_cgroup;
+	struct mem_cgroup *memcg =3D page_memcg(compound_head(page));
 	struct pglist_data *pgdat =3D NODE_DATA(page_to_nid(page));
=20
 	if (memcg)
@@ -2765,7 +2765,7 @@ void deferred_split_huge_page(struct page *page)
 {
 	struct deferred_split *ds_queue =3D get_deferred_split_queue(page);
 #ifdef CONFIG_MEMCG
-	struct mem_cgroup *memcg =3D compound_head(page)->mem_cgroup;
+	struct mem_cgroup *memcg =3D page_memcg(compound_head(page));
 #endif
 	unsigned long flags;
=20
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3dcbf24d2227..3968d68503cb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -533,7 +533,7 @@ struct cgroup_subsys_state *mem_cgroup_css_from_page(st=
ruct page *page)
 {
 	struct mem_cgroup *memcg;
=20
-	memcg =3D page->mem_cgroup;
+	memcg =3D page_memcg(page);
=20
 	if (!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		memcg =3D root_mem_cgroup;
@@ -560,16 +560,7 @@ ino_t page_cgroup_ino(struct page *page)
 	unsigned long ino =3D 0;
=20
 	rcu_read_lock();
-	memcg =3D page->mem_cgroup;
-
-	/*
-	 * The lowest bit set means that memcg isn't a valid
-	 * memcg pointer, but a obj_cgroups pointer.
-	 * In this case the page is shared and doesn't belong
-	 * to any specific memory cgroup.
-	 */
-	if ((unsigned long) memcg & 0x1UL)
-		memcg =3D NULL;
+	memcg =3D page_memcg_check(page);
=20
 	while (memcg && !(memcg->css.flags & CSS_ONLINE))
 		memcg =3D parent_mem_cgroup(memcg);
@@ -1050,7 +1041,7 @@ EXPORT_SYMBOL(get_mem_cgroup_from_mm);
  */
 struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
 {
-	struct mem_cgroup *memcg =3D page->mem_cgroup;
+	struct mem_cgroup *memcg =3D page_memcg(page);
=20
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1349,7 +1340,7 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *pa=
ge, struct pglist_data *pgd
 		goto out;
 	}
=20
-	memcg =3D page->mem_cgroup;
+	memcg =3D page_memcg(page);
 	/*
 	 * Swapcache readahead pages are added to the LRU - and
 	 * possibly migrated - before they are charged.
@@ -2109,7 +2100,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *me=
mcg)
 }
=20
 /**
- * lock_page_memcg - lock a page->mem_cgroup binding
+ * lock_page_memcg - lock a page and memcg binding
  * @page: the page
  *
  * This function protects unlocked LRU pages from being moved to
@@ -2141,7 +2132,7 @@ struct mem_cgroup *lock_page_memcg(struct page *page)
 	if (mem_cgroup_disabled())
 		return NULL;
 again:
-	memcg =3D head->mem_cgroup;
+	memcg =3D page_memcg(head);
 	if (unlikely(!memcg))
 		return NULL;
=20
@@ -2149,7 +2140,7 @@ struct mem_cgroup *lock_page_memcg(struct page *page)
 		return memcg;
=20
 	spin_lock_irqsave(&memcg->move_lock, flags);
-	if (memcg !=3D head->mem_cgroup) {
+	if (memcg !=3D page_memcg(head)) {
 		spin_unlock_irqrestore(&memcg->move_lock, flags);
 		goto again;
 	}
@@ -2187,14 +2178,14 @@ void __unlock_page_memcg(struct mem_cgroup *memcg)
 }
=20
 /**
- * unlock_page_memcg - unlock a page->mem_cgroup binding
+ * unlock_page_memcg - unlock a page and memcg binding
  * @page: the page
  */
 void unlock_page_memcg(struct page *page)
 {
 	struct page *head =3D compound_head(page);
=20
-	__unlock_page_memcg(head->mem_cgroup);
+	__unlock_page_memcg(page_memcg(head));
 }
 EXPORT_SYMBOL(unlock_page_memcg);
=20
@@ -2884,7 +2875,7 @@ static void cancel_charge(struct mem_cgroup *memcg, u=
nsigned int nr_pages)
=20
 static void commit_charge(struct page *page, struct mem_cgroup *memcg)
 {
-	VM_BUG_ON_PAGE(page->mem_cgroup, page);
+	VM_BUG_ON_PAGE(page_memcg(page), page);
 	/*
 	 * Any of the following ensures page->mem_cgroup stability:
 	 *
@@ -2893,7 +2884,7 @@ static void commit_charge(struct page *page, struct m=
em_cgroup *memcg)
 	 * - lock_page_memcg()
 	 * - exclusive reference
 	 */
-	page->mem_cgroup =3D memcg;
+	page->memcg_data =3D (unsigned long)memcg;
 }
=20
 #ifdef CONFIG_MEMCG_KMEM
@@ -2908,8 +2899,7 @@ int memcg_alloc_page_obj_cgroups(struct page *page, s=
truct kmem_cache *s,
 	if (!vec)
 		return -ENOMEM;
=20
-	if (cmpxchg(&page->obj_cgroups, NULL,
-		    (struct obj_cgroup **) ((unsigned long)vec | 0x1UL)))
+	if (cmpxchg(&page->memcg_data, 0, (unsigned long)vec | 0x1UL))
 		kfree(vec);
 	else
 		kmemleak_not_leak(vec);
@@ -2920,6 +2910,12 @@ int memcg_alloc_page_obj_cgroups(struct page *page, =
struct kmem_cache *s,
 /*
  * Returns a pointer to the memory cgroup to which the kernel object is ch=
arged.
  *
+ * A passed kernel object can be a slab object or a generic kernel page, so
+ * different mechanisms for getting the memory cgroup pointer should be us=
ed.
+ * In certain cases (e.g. kernel stacks or large kmallocs with SLUB) the c=
aller
+ * can not know for sure how the kernel object is implemented.
+ * mem_cgroup_from_obj() can be safely used in such cases.
+ *
  * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock=
(),
  * cgroup_mutex, etc.
  */
@@ -2932,17 +2928,6 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
=20
 	page =3D virt_to_head_page(p);
=20
-	/*
-	 * If page->mem_cgroup is set, it's either a simple mem_cgroup pointer
-	 * or a pointer to obj_cgroup vector. In the latter case the lowest
-	 * bit of the pointer is set.
-	 * The page->mem_cgroup pointer can be asynchronously changed
-	 * from NULL to (obj_cgroup_vec | 0x1UL), but can't be changed
-	 * from a valid memcg pointer to objcg vector or back.
-	 */
-	if (!page->mem_cgroup)
-		return NULL;
-
 	/*
 	 * Slab objects are accounted individually, not per-page.
 	 * Memcg membership data for each individual object is saved in
@@ -2960,8 +2945,14 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
 		return NULL;
 	}
=20
-	/* All other pages use page->mem_cgroup */
-	return page->mem_cgroup;
+	/*
+	 * page_memcg_check() is used here, because page_has_obj_cgroups()
+	 * check above could fail because the object cgroups vector wasn't set
+	 * at that moment, but it can be set concurrently.
+	 * page_memcg_check(page) will guarantee that a proper memory
+	 * cgroup pointer or NULL will be returned.
+	 */
+	return page_memcg_check(page);
 }
=20
 __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
@@ -3099,7 +3090,7 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t=
 gfp, int order)
 	if (memcg && !mem_cgroup_is_root(memcg)) {
 		ret =3D __memcg_kmem_charge(memcg, gfp, 1 << order);
 		if (!ret) {
-			page->mem_cgroup =3D memcg;
+			page->memcg_data =3D (unsigned long)memcg;
 			__SetPageKmemcg(page);
 			return 0;
 		}
@@ -3115,7 +3106,7 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t=
 gfp, int order)
  */
 void __memcg_kmem_uncharge_page(struct page *page, int order)
 {
-	struct mem_cgroup *memcg =3D page->mem_cgroup;
+	struct mem_cgroup *memcg =3D page_memcg(page);
 	unsigned int nr_pages =3D 1 << order;
=20
 	if (!memcg)
@@ -3123,7 +3114,7 @@ void __memcg_kmem_uncharge_page(struct page *page, in=
t order)
=20
 	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
 	__memcg_kmem_uncharge(memcg, nr_pages);
-	page->mem_cgroup =3D NULL;
+	page->memcg_data =3D 0;
 	css_put(&memcg->css);
=20
 	/* slab pages do not have PageKmemcg flag set */
@@ -3274,7 +3265,7 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, si=
ze_t size)
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
-	struct mem_cgroup *memcg =3D head->mem_cgroup;
+	struct mem_cgroup *memcg =3D page_memcg(head);
 	int i;
=20
 	if (mem_cgroup_disabled())
@@ -3282,7 +3273,7 @@ void mem_cgroup_split_huge_fixup(struct page *head)
=20
 	for (i =3D 1; i < HPAGE_PMD_NR; i++) {
 		css_get(&memcg->css);
-		head[i].mem_cgroup =3D memcg;
+		head[i].memcg_data =3D (unsigned long)memcg;
 	}
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -4664,7 +4655,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, un=
signed long *pfilepages,
 void mem_cgroup_track_foreign_dirty_slowpath(struct page *page,
 					     struct bdi_writeback *wb)
 {
-	struct mem_cgroup *memcg =3D page->mem_cgroup;
+	struct mem_cgroup *memcg =3D page_memcg(page);
 	struct memcg_cgwb_frn *frn;
 	u64 now =3D get_jiffies_64();
 	u64 oldest_at =3D now;
@@ -5641,14 +5632,14 @@ static int mem_cgroup_move_account(struct page *pag=
e,
=20
 	/*
 	 * Prevent mem_cgroup_migrate() from looking at
-	 * page->mem_cgroup of its source page while we change it.
+	 * page's memory cgroup of its source page while we change it.
 	 */
 	ret =3D -EBUSY;
 	if (!trylock_page(page))
 		goto out;
=20
 	ret =3D -EINVAL;
-	if (page->mem_cgroup !=3D from)
+	if (page_memcg(page) !=3D from)
 		goto out_unlock;
=20
 	pgdat =3D page_pgdat(page);
@@ -5703,13 +5694,13 @@ static int mem_cgroup_move_account(struct page *pag=
e,
 	/*
 	 * All state has been migrated, let's switch to the new memcg.
 	 *
-	 * It is safe to change page->mem_cgroup here because the page
+	 * It is safe to change page's memcg here because the page
 	 * is referenced, charged, isolated, and locked: we can't race
 	 * with (un)charging, migration, LRU putback, or anything else
-	 * that would rely on a stable page->mem_cgroup.
+	 * that would rely on a stable page's memory cgroup.
 	 *
 	 * Note that lock_page_memcg is a memcg lock, not a page lock,
-	 * to save space. As soon as we switch page->mem_cgroup to a
+	 * to save space. As soon as we switch page's memory cgroup to a
 	 * new memcg that isn't locked, the above state can change
 	 * concurrently again. Make sure we're truly done with it.
 	 */
@@ -5718,7 +5709,7 @@ static int mem_cgroup_move_account(struct page *page,
 	css_get(&to->css);
 	css_put(&from->css);
=20
-	page->mem_cgroup =3D to;
+	page->memcg_data =3D (unsigned long)to;
=20
 	__unlock_page_memcg(from);
=20
@@ -5784,7 +5775,7 @@ static enum mc_target_type get_mctgt_type(struct vm_a=
rea_struct *vma,
 		 * mem_cgroup_move_account() checks the page is valid or
 		 * not under LRU exclusion.
 		 */
-		if (page->mem_cgroup =3D=3D mc.from) {
+		if (page_memcg(page) =3D=3D mc.from) {
 			ret =3D MC_TARGET_PAGE;
 			if (is_device_private_page(page))
 				ret =3D MC_TARGET_DEVICE;
@@ -5828,7 +5819,7 @@ static enum mc_target_type get_mctgt_type_thp(struct =
vm_area_struct *vma,
 	VM_BUG_ON_PAGE(!page || !PageHead(page), page);
 	if (!(mc.flags & MOVE_ANON))
 		return ret;
-	if (page->mem_cgroup =3D=3D mc.from) {
+	if (page_memcg(page) =3D=3D mc.from) {
 		ret =3D MC_TARGET_PAGE;
 		if (target) {
 			get_page(page);
@@ -6774,12 +6765,12 @@ int mem_cgroup_charge(struct page *page, struct mm_=
struct *mm, gfp_t gfp_mask)
 		/*
 		 * Every swap fault against a single page tries to charge the
 		 * page, bail as early as possible.  shmem_unuse() encounters
-		 * already charged pages, too.  page->mem_cgroup is protected
-		 * by the page lock, which serializes swap cache removal, which
-		 * in turn serializes uncharging.
+		 * already charged pages, too.  page and memcg binding is
+		 * protected by the page lock, which serializes swap cache
+		 * removal, which in turn serializes uncharging.
 		 */
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
-		if (compound_head(page)->mem_cgroup)
+		if (page_memcg(compound_head(page)))
 			goto out;
=20
 		id =3D lookup_swap_cgroup_id(ent);
@@ -6863,21 +6854,21 @@ static void uncharge_page(struct page *page, struct=
 uncharge_gather *ug)
=20
 	VM_BUG_ON_PAGE(PageLRU(page), page);
=20
-	if (!page->mem_cgroup)
+	if (!page_memcg(page))
 		return;
=20
 	/*
 	 * Nobody should be changing or seriously looking at
-	 * page->mem_cgroup at this point, we have fully
+	 * page_memcg(page) at this point, we have fully
 	 * exclusive access to the page.
 	 */
=20
-	if (ug->memcg !=3D page->mem_cgroup) {
+	if (ug->memcg !=3D page_memcg(page)) {
 		if (ug->memcg) {
 			uncharge_batch(ug);
 			uncharge_gather_clear(ug);
 		}
-		ug->memcg =3D page->mem_cgroup;
+		ug->memcg =3D page_memcg(page);
=20
 		/* pairs with css_put in uncharge_batch */
 		css_get(&ug->memcg->css);
@@ -6894,7 +6885,7 @@ static void uncharge_page(struct page *page, struct u=
ncharge_gather *ug)
 	}
=20
 	ug->dummy_page =3D page;
-	page->mem_cgroup =3D NULL;
+	page->memcg_data =3D 0;
 	css_put(&ug->memcg->css);
 }
=20
@@ -6937,7 +6928,7 @@ void mem_cgroup_uncharge(struct page *page)
 		return;
=20
 	/* Don't touch page->lru of any random page, pre-check: */
-	if (!page->mem_cgroup)
+	if (!page_memcg(page))
 		return;
=20
 	uncharge_gather_clear(&ug);
@@ -6987,11 +6978,11 @@ void mem_cgroup_migrate(struct page *oldpage, struc=
t page *newpage)
 		return;
=20
 	/* Page cache replacement: new page already charged? */
-	if (newpage->mem_cgroup)
+	if (page_memcg(newpage))
 		return;
=20
 	/* Swapcache readahead pages can get replaced before being charged */
-	memcg =3D oldpage->mem_cgroup;
+	memcg =3D page_memcg(oldpage);
 	if (!memcg)
 		return;
=20
@@ -7186,7 +7177,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_=
t entry)
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return;
=20
-	memcg =3D page->mem_cgroup;
+	memcg =3D page_memcg(page);
=20
 	/* Readahead page, never charged */
 	if (!memcg)
@@ -7207,7 +7198,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_=
t entry)
 	VM_BUG_ON_PAGE(oldid, page);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
=20
-	page->mem_cgroup =3D NULL;
+	page->memcg_data =3D 0;
=20
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, nr_entries);
@@ -7250,7 +7241,7 @@ int mem_cgroup_try_charge_swap(struct page *page, swp=
_entry_t entry)
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return 0;
=20
-	memcg =3D page->mem_cgroup;
+	memcg =3D page_memcg(page);
=20
 	/* Readahead page, never charged */
 	if (!memcg)
@@ -7331,7 +7322,7 @@ bool mem_cgroup_swap_full(struct page *page)
 	if (cgroup_memory_noswap || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return false;
=20
-	memcg =3D page->mem_cgroup;
+	memcg =3D page_memcg(page);
 	if (!memcg)
 		return false;
=20
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 23f5066bd4a5..271133b8243b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1092,7 +1092,7 @@ static inline bool page_expected_state(struct page *p=
age,
 	if (unlikely((unsigned long)page->mapping |
 			page_ref_count(page) |
 #ifdef CONFIG_MEMCG
-			(unsigned long)page->mem_cgroup |
+			(unsigned long)page_memcg(page) |
 #endif
 			(page->flags & check_flags)))
 		return false;
@@ -1117,7 +1117,7 @@ static const char *page_bad_reason(struct page *page,=
 unsigned long flags)
 			bad_reason =3D "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
 	}
 #ifdef CONFIG_MEMCG
-	if (unlikely(page->mem_cgroup))
+	if (unlikely(page_memcg(page)))
 		bad_reason =3D "page still charged to cgroup";
 #endif
 	return bad_reason;
diff --git a/mm/page_io.c b/mm/page_io.c
index 433df1263349..9bca17ecc4df 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -291,12 +291,14 @@ static inline void count_swpout_vm_event(struct page =
*page)
 static void bio_associate_blkg_from_page(struct bio *bio, struct page *pag=
e)
 {
 	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
=20
-	if (!page->mem_cgroup)
+	memcg =3D page_memcg(page);
+	if (!memcg)
 		return;
=20
 	rcu_read_lock();
-	css =3D cgroup_e_css(page->mem_cgroup->css.cgroup, &io_cgrp_subsys);
+	css =3D cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
 	bio_associate_blkg_from_css(bio, css);
 	rcu_read_unlock();
 }
diff --git a/mm/slab.h b/mm/slab.h
index 6d7c6a5056ba..e2535cee0d33 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -242,18 +242,17 @@ static inline bool kmem_cache_debug_flags(struct kmem=
_cache *s, slab_flags_t fla
 static inline struct obj_cgroup **page_obj_cgroups(struct page *page)
 {
 	/*
-	 * page->mem_cgroup and page->obj_cgroups are sharing the same
+	 * Page's memory cgroup and obj_cgroups vector are sharing the same
 	 * space. To distinguish between them in case we don't know for sure
 	 * that the page is a slab page (e.g. page_cgroup_ino()), let's
 	 * always set the lowest bit of obj_cgroups.
 	 */
-	return (struct obj_cgroup **)
-		((unsigned long)page->obj_cgroups & ~0x1UL);
+	return (struct obj_cgroup **)(page->memcg_data & ~0x1UL);
 }
=20
 static inline bool page_has_obj_cgroups(struct page *page)
 {
-	return ((unsigned long)page->obj_cgroups & 0x1UL);
+	return page->memcg_data & 0x1UL;
 }
=20
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
@@ -262,7 +261,7 @@ int memcg_alloc_page_obj_cgroups(struct page *page, str=
uct kmem_cache *s,
 static inline void memcg_free_page_obj_cgroups(struct page *page)
 {
 	kfree(page_obj_cgroups(page));
-	page->obj_cgroups =3D NULL;
+	page->memcg_data =3D 0;
 }
=20
 static inline size_t obj_full_size(struct kmem_cache *s)
diff --git a/mm/workingset.c b/mm/workingset.c
index 975a4d2dd02e..130348cbf40a 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -257,7 +257,7 @@ void *workingset_eviction(struct page *page, struct mem=
_cgroup *target_memcg)
 	struct lruvec *lruvec;
 	int memcgid;
=20
-	/* Page is fully exclusive and pins page->mem_cgroup */
+	/* Page is fully exclusive and pins page's memory cgroup pointer */
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
--=20
2.26.2

