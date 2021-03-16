Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5363F33CC78
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 05:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhCPEQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 00:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhCPEQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 00:16:50 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97069C06174A;
        Mon, 15 Mar 2021 21:16:50 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id w34so20699998pga.8;
        Mon, 15 Mar 2021 21:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=42tPScMxi95zXHnmIG9Dt2LkFsMNXJvTW07v3hr8wZI=;
        b=uAXi6lndvjpT5fcelINm0XIRObrXLOHeC2v9lRwawRpVrCzR/5PLrIV9Ys2jqkdFWR
         TG1FGhBzqplVXouRS7SL8DB1rRwlS4Q88C/eaOnS8c8WfBpbO9ueyJ1d8zK+BLwsjU83
         rRrugF94ffii5lyFlUuY3EYYSD54VSLGdccJsmoO105A5oNF7fe5Ehespr12SOM+pqmA
         wjMcgOuUf40zg6IJFm+nMbuSM5n5bg9/ed/+p1Poqxy7lFDRn1TlEmWgcyNnQumPpDqu
         yqdAjcTZj91qdS6iK8gahgOMkgNyk2AophUvXr9YjBjdjEKpg63/GqmbYuvNvfOBl/Aj
         kOBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=42tPScMxi95zXHnmIG9Dt2LkFsMNXJvTW07v3hr8wZI=;
        b=kgBMriixT9CwQ/O9WOEdiJOCACoQTyvdcKPUoD8Uww0we9cXKWKw66xnozT//EEChM
         H31TeuDobSHX68E1ZMSwCJMwQMf2e8r6BbeKKiO/WrwZnvlqEdR3SI/nIJY68uksdIMq
         2wFktJQxGJ1L8yDeIuoutHhPQfyRYKLmJ9Q2FHMhXlZQoLcKXkKNON9XgEztnnY98sIc
         C1JQEWuiz4I2KOyJVsM/xoK/zQDHx1lv8hydXnyd1YTzAYbFkWJiWsCfNa9bomtfY+sL
         LPB7HQRsijkiGJc2JitsL4lgEXaKPQbV0NeMGY5/p/FwC+LCwFDUHYweCtKhkhXb1qcG
         KvPQ==
X-Gm-Message-State: AOAM533ydgkgwHkHBQAfUCfVHi7myBAN8yBKgoALz7v0WwJjCGCFX93J
        YVm1SJX2YxV6uZpxPCrMpAU=
X-Google-Smtp-Source: ABdhPJxgnP3kSiZkHvZuAbt+3yA4yhVXeAUmlaV2Y+rIMp9kCYPpiUgPMEfi2TNcXjVdWSpgNLzQVA==
X-Received: by 2002:a62:b50a:0:b029:1ef:1ee8:1164 with SMTP id y10-20020a62b50a0000b02901ef1ee81164mr13233517pfe.72.1615868210023;
        Mon, 15 Mar 2021 21:16:50 -0700 (PDT)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:c9f7:387d:8697:6eae])
        by smtp.gmail.com with ESMTPSA id w128sm15042439pfw.86.2021.03.15.21.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 21:16:49 -0700 (PDT)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     akpm@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Cc:     arjunroy@google.com, shakeelb@google.com, edumazet@google.com,
        soheil@google.com, kuba@kernel.org, mhocko@kernel.org,
        hannes@cmpxchg.org, shy828301@gmail.com, guro@fb.com
Subject: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Date:   Mon, 15 Mar 2021 21:16:45 -0700
Message-Id: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

TCP zerocopy receive is used by high performance network applications
to further scale. For RX zerocopy, the memory containing the network
data filled by the network driver is directly mapped into the address
space of high performance applications. To keep the TLB cost low,
these applications unmap the network memory in big batches. So, this
memory can remain mapped for long time. This can cause a memory
isolation issue as this memory becomes unaccounted after getting
mapped into the application address space. This patch adds the memcg
accounting for such memory.

Accounting the network memory comes with its own unique challenges.
The high performance NIC drivers use page pooling to reuse the pages
to eliminate/reduce expensive setup steps like IOMMU. These drivers
keep an extra reference on the pages and thus we can not depend on the
page reference for the uncharging. The page in the pool may keep a
memcg pinned for arbitrary long time or may get used by other memcg.

This patch decouples the uncharging of the page from the refcnt and
associates it with the map count i.e. the page gets uncharged when the
last address space unmaps it. Now the question is, what if the driver
drops its reference while the page is still mapped? That is fine as
the address space also holds a reference to the page i.e. the
reference count can not drop to zero before the map count.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Co-developed-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
---

Changelog since v1:
- Pages accounted for in this manner are now tracked via MEMCG_SOCK.
- v1 allowed for a brief period of double-charging, now we have a
  brief period of under-charging to avoid undue memory pressure.

 include/linux/memcontrol.h |  48 ++++++++++++-
 mm/memcontrol.c            | 138 +++++++++++++++++++++++++++++++++++++
 mm/rmap.c                  |   7 +-
 net/ipv4/tcp.c             |  79 +++++++++++++++++----
 4 files changed, 253 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e6dc793d587d..d67bc2aec7f6 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -349,11 +349,13 @@ extern struct mem_cgroup *root_mem_cgroup;
 
 enum page_memcg_data_flags {
 	/* page->memcg_data is a pointer to an objcgs vector */
-	MEMCG_DATA_OBJCGS = (1UL << 0),
+	MEMCG_DATA_OBJCGS	= (1UL << 0),
 	/* page has been accounted as a non-slab kernel page */
-	MEMCG_DATA_KMEM = (1UL << 1),
+	MEMCG_DATA_KMEM		= (1UL << 1),
+	/* page has been accounted as network memory */
+	MEMCG_DATA_SOCK		= (1UL << 2),
 	/* the next bit after the last actual flag */
-	__NR_MEMCG_DATA_FLAGS  = (1UL << 2),
+	__NR_MEMCG_DATA_FLAGS	= (1UL << 3),
 };
 
 #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
@@ -444,6 +446,11 @@ static inline bool PageMemcgKmem(struct page *page)
 	return page->memcg_data & MEMCG_DATA_KMEM;
 }
 
+static inline bool PageMemcgSock(struct page *page)
+{
+	return page->memcg_data & MEMCG_DATA_SOCK;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 /*
  * page_objcgs - get the object cgroups vector associated with a page
@@ -1093,6 +1100,11 @@ static inline bool PageMemcgKmem(struct page *page)
 	return false;
 }
 
+static inline bool PageMemcgSock(struct page *page)
+{
+	return false;
+}
+
 static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 {
 	return true;
@@ -1554,6 +1566,15 @@ extern struct static_key_false memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
 void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
+
+void mem_cgroup_post_charge_sock_pages(struct mem_cgroup *memcg,
+				 unsigned int nr_pages);
+void mem_cgroup_uncharge_sock_page(struct page *page);
+int mem_cgroup_prepare_sock_pages(struct mem_cgroup *memcg, struct page **pages,
+			       u8 *page_prepared, unsigned int nr_pages);
+int mem_cgroup_unprepare_sock_pages(struct mem_cgroup *memcg, struct page **pages,
+				 u8 *page_prepared, unsigned int nr_pages);
+
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
@@ -1582,6 +1603,27 @@ static inline void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
 					  int nid, int shrinker_id)
 {
 }
+
+static inline void mem_cgroup_post_charge_sock_pages(struct mem_cgroup *memcg,
+					       unsigned int nr_pages)
+{
+}
+
+static inline void mem_cgroup_uncharge_sock_page(struct page *page)
+{
+}
+
+static inline int mem_cgroup_prepare_sock_pages(struct mem_cgroup *memcg, struct page **pages,
+			       u8 *page_prepared, unsigned int nr_pages)
+{
+	return 0;
+}
+
+static inline int mem_cgroup_unprepare_sock_pages(struct mem_cgroup *memcg, struct page **pages,
+				 u8 *page_prepared, unsigned int nr_pages)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 845eec01ef9d..aee126b0028c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7027,6 +7027,144 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 	refill_stock(memcg, nr_pages);
 }
 
+/**
+ * mem_cgroup_post_charge_sock_pages - charge socket memory
+ * for zerocopy pages mapped to userspace.
+ * @memcg: memcg to charge
+ * @nr_pages: number of pages
+ *
+ * When we perform a zero-copy receive on a socket, the receive payload memory
+ * pages are remapped to the user address space with vm_insert_pages().
+ * mem_cgroup_post_charge_sock_pages() accounts for this memory utilization; it is
+ * *not* mem_cgroup_charge_skmem() which accounts for memory use within socket
+ * buffers.
+ *
+ * Charges all @nr_pages to given memcg. The caller should have a reference
+ * on the given memcg. Unlike mem_cgroup_charge_skmem, the caller must also have
+ * set page->memcg_data for these pages beforehand. Decoupling this page
+ * manipulation from the charging allows us to avoid double-charging the pages,
+ * causing undue memory pressure.
+ */
+void mem_cgroup_post_charge_sock_pages(struct mem_cgroup *memcg,
+				 unsigned int nr_pages)
+{
+	if (mem_cgroup_disabled() || !memcg)
+		return;
+	try_charge(memcg, GFP_KERNEL | __GFP_NOFAIL, nr_pages);
+	mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
+}
+
+/**
+ * mem_cgroup_uncharge_sock_page - uncharge socket page
+ * when unmapping zerocopy pages mapped to userspace.
+ * @page: page to uncharge
+ *
+ * mem_cgroup_uncharge_sock_page() drops the CSS reference taken by
+ * mem_cgroup_prepare_sock_pages(), and uncharges memory usage.
+ * Page cannot be compound. Must be called with page memcg lock held.
+ */
+void mem_cgroup_uncharge_sock_page(struct page *page)
+{
+	struct mem_cgroup *memcg;
+
+	VM_BUG_ON(PageCompound(page));
+	memcg = page_memcg(page);
+	if (!memcg)
+		return;
+
+	mod_memcg_state(memcg, MEMCG_SOCK, -1);
+	refill_stock(memcg, 1);
+	css_put(&memcg->css);
+	page->memcg_data = 0;
+}
+
+/**
+ * mem_cgroup_unprepare_sock_pages - unset memcg for unremapped zerocopy pages.
+ * @memcg: The memcg we were trying to account pages to.
+ * @pages: array of pages, some subset of which we must 'unprepare'
+ * @page_prepared: array of flags indicating if page must be unprepared
+ * @nr_pages: Length of pages and page_prepared arrays.
+ *
+ * If a zerocopy receive attempt failed to remap some pages to userspace, we
+ * must unset memcg on these pages, if we had previously set them with a
+ * matching call to mem_cgroup_prepare_sock_pages().
+ *
+ * The caller must ensure that all input parameters are the same parameters
+ * (or a subset of the parameters) passed to the preceding call to
+ * mem_cgroup_prepare_sock_pages() otherwise undefined behaviour results.
+ * Returns how many pages were unprepared so caller post-charges the right
+ * amount of pages to the memcg.
+ */
+int mem_cgroup_unprepare_sock_pages(struct mem_cgroup *memcg, struct page **pages,
+				 u8 *page_prepared, unsigned int nr_pages)
+{
+	unsigned int idx, cleared = 0;
+
+	if (!memcg || mem_cgroup_disabled())
+		return 0;
+
+	for (idx = 0; idx < nr_pages; ++idx) {
+		if (!page_prepared[idx])
+			continue;
+		/* We prepared this page so it is not LRU. */
+		WRITE_ONCE(pages[idx]->memcg_data, 0);
+		++cleared;
+	}
+	css_put_many(&memcg->css, cleared);
+	return cleared;
+}
+
+/**
+ * mem_cgroup_prepare_sock_pages - set memcg for receive zerocopy pages.
+ * @memcg: The memcg we were trying to account pages to.
+ * @pages: array of pages, some subset of which we must 'prepare'
+ * @page_prepared: array of flags indicating if page was prepared
+ * @nr_pages: Length of pages and page_prepared arrays.
+ *
+ * If we are to remap pages to userspace in zerocopy receive, we must set the
+ * memcg for these pages before vm_insert_pages(), if the page does not already
+ * have a memcg set. However, if a memcg was already set, we do not adjust it.
+ * Explicitly track which pages we have prepared ourselves so we can 'unprepare'
+ * them if need be should page remapping fail.
+ *
+ * The caller must ensure that all input parameter passed to a subsequent call
+ * to mem_cgroup_unprepare_sock_pages() are identical or a subset of these
+ * parameters otherwise undefined behaviour results. page_prepared must also be
+ * zero'd by the caller before invoking this method. Returns how many pages were
+ * prepared so caller post-charges the right amount of pages to the memcg.
+ */
+int mem_cgroup_prepare_sock_pages(struct mem_cgroup *memcg, struct page **pages,
+			       u8 *page_prepared, unsigned int nr_pages)
+{
+	unsigned int idx, to_uncharge = 0;
+	const unsigned long memcg_data = (unsigned long) memcg |
+			MEMCG_DATA_SOCK;
+
+	if (!memcg || mem_cgroup_disabled())
+		return 0;
+
+	css_get_many(&memcg->css, nr_pages);
+	for (idx = 0; idx < nr_pages; ++idx) {
+		struct page *page = pages[idx];
+
+		VM_BUG_ON(PageCompound(page));
+		/*
+		 * page->memcg_data == 0 implies non-LRU page. non-LRU pages are
+		 * not changed by the rest of the kernel, so we only have to
+		 * guard against concurrent access in the networking layer.
+		 * cmpxchg(0) lets us both validate non-LRU and protects against
+		 * concurrent access in networking layer.
+		 */
+		if (cmpxchg(&page->memcg_data, 0, memcg_data) == 0)
+			page_prepared[idx] = 1;
+		else
+			++to_uncharge;
+	}
+	if (to_uncharge)
+		css_put_many(&memcg->css, to_uncharge);
+	return nr_pages - to_uncharge;
+}
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;
diff --git a/mm/rmap.c b/mm/rmap.c
index b0fc27e77d6d..d2a164769dcf 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1290,6 +1290,9 @@ static void page_remove_file_rmap(struct page *page, bool compound)
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
+
+	if (unlikely(PageMemcgSock(page)))
+		mem_cgroup_uncharge_sock_page(page);
 }
 
 static void page_remove_anon_compound_rmap(struct page *page)
@@ -1345,7 +1348,7 @@ static void page_remove_anon_compound_rmap(struct page *page)
  */
 void page_remove_rmap(struct page *page, bool compound)
 {
-	lock_page_memcg(page);
+	struct mem_cgroup *memcg = lock_page_memcg(page);
 
 	if (!PageAnon(page)) {
 		page_remove_file_rmap(page, compound);
@@ -1384,7 +1387,7 @@ void page_remove_rmap(struct page *page, bool compound)
 	 * faster for those pages still in swapcache.
 	 */
 out:
-	unlock_page_memcg(page);
+	__unlock_page_memcg(memcg);
 }
 
 /*
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index de7cc8445ac0..17dd5b57409f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1789,12 +1789,14 @@ static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
 		++frag;
 	}
 	*offset_frag = 0;
+	prefetchw(skb_frag_page(frag));
 	return frag;
 }
 
 static bool can_map_frag(const skb_frag_t *frag)
 {
-	return skb_frag_size(frag) == PAGE_SIZE && !skb_frag_off(frag);
+	return skb_frag_size(frag) == PAGE_SIZE && !skb_frag_off(frag) &&
+		!PageCompound(skb_frag_page(frag));
 }
 
 static int find_next_mappable_frag(const skb_frag_t *frag,
@@ -1944,14 +1946,19 @@ static int tcp_zc_handle_leftover(struct tcp_zerocopy_receive *zc,
 
 static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
 					      struct page **pending_pages,
-					      unsigned long pages_remaining,
+					      u8 *page_prepared,
+					      unsigned long leftover_pages,
 					      unsigned long *address,
 					      u32 *length,
 					      u32 *seq,
 					      struct tcp_zerocopy_receive *zc,
 					      u32 total_bytes_to_map,
-					      int err)
+					      int err,
+					      unsigned long *pages_acctd_total,
+					      struct mem_cgroup *memcg)
 {
+	unsigned long pages_remaining = leftover_pages, pages_mapped = 0;
+
 	/* At least one page did not map. Try zapping if we skipped earlier. */
 	if (err == -EBUSY &&
 	    zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT) {
@@ -1965,14 +1972,14 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
 	}
 
 	if (!err) {
-		unsigned long leftover_pages = pages_remaining;
 		int bytes_mapped;
 
 		/* We called zap_page_range, try to reinsert. */
 		err = vm_insert_pages(vma, *address,
 				      pending_pages,
 				      &pages_remaining);
-		bytes_mapped = PAGE_SIZE * (leftover_pages - pages_remaining);
+		pages_mapped = leftover_pages - pages_remaining;
+		bytes_mapped = PAGE_SIZE * pages_mapped;
 		*seq += bytes_mapped;
 		*address += bytes_mapped;
 	}
@@ -1986,24 +1993,41 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
 
 		*length -= bytes_not_mapped;
 		zc->recv_skip_hint += bytes_not_mapped;
+
+		pending_pages += pages_mapped;
+		page_prepared += pages_mapped;
+
+		/* For the pages that did not map, unset memcg and drop refs. */
+		*pages_acctd_total -= mem_cgroup_unprepare_sock_pages(memcg,
+						pending_pages,
+						page_prepared,
+						pages_remaining);
 	}
 	return err;
 }
 
 static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 					struct page **pages,
+					u8 *page_prepared,
 					unsigned int pages_to_map,
 					unsigned long *address,
 					u32 *length,
 					u32 *seq,
 					struct tcp_zerocopy_receive *zc,
-					u32 total_bytes_to_map)
+					u32 total_bytes_to_map,
+					unsigned long *pages_acctd_total,
+					struct mem_cgroup *memcg)
 {
 	unsigned long pages_remaining = pages_to_map;
 	unsigned int pages_mapped;
 	unsigned int bytes_mapped;
 	int err;
 
+	/* Before mapping, we must take css ref since unmap drops it. */
+	*pages_acctd_total = mem_cgroup_prepare_sock_pages(memcg, pages,
+							   page_prepared,
+							   pages_to_map);
+
 	err = vm_insert_pages(vma, *address, pages, &pages_remaining);
 	pages_mapped = pages_to_map - (unsigned int)pages_remaining;
 	bytes_mapped = PAGE_SIZE * pages_mapped;
@@ -2018,8 +2042,9 @@ static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 
 	/* Error: maybe zap and retry + rollback state for failed inserts. */
 	return tcp_zerocopy_vm_insert_batch_error(vma, pages + pages_mapped,
+		page_prepared + pages_mapped,
 		pages_remaining, address, length, seq, zc, total_bytes_to_map,
-		err);
+		err, pages_acctd_total, memcg);
 }
 
 #define TCP_VALID_ZC_MSG_FLAGS   (TCP_CMSG_TS)
@@ -2058,6 +2083,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	u32 length = 0, offset, vma_len, avail_len, copylen = 0;
 	unsigned long address = (unsigned long)zc->address;
 	struct page *pages[TCP_ZEROCOPY_PAGE_BATCH_SIZE];
+	u8 page_prepared[TCP_ZEROCOPY_PAGE_BATCH_SIZE];
+	unsigned long total_pages_acctd = 0;
 	s32 copybuf_len = zc->copybuf_len;
 	struct tcp_sock *tp = tcp_sk(sk);
 	const skb_frag_t *frags = NULL;
@@ -2065,6 +2092,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	struct vm_area_struct *vma;
 	struct sk_buff *skb = NULL;
 	u32 seq = tp->copied_seq;
+	struct mem_cgroup *memcg;
 	u32 total_bytes_to_map;
 	int inq = tcp_inq(sk);
 	int ret;
@@ -2110,12 +2138,15 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		zc->length = avail_len;
 		zc->recv_skip_hint = avail_len;
 	}
+
+	memcg = get_mem_cgroup_from_mm(current->mm);
 	ret = 0;
 	while (length + PAGE_SIZE <= zc->length) {
+		bool skb_remainder_unmappable = zc->recv_skip_hint < PAGE_SIZE;
 		int mappable_offset;
 		struct page *page;
 
-		if (zc->recv_skip_hint < PAGE_SIZE) {
+		if (skb_remainder_unmappable) {
 			u32 offset_frag;
 
 			if (skb) {
@@ -2144,30 +2175,46 @@ static int tcp_zerocopy_receive(struct sock *sk,
 			break;
 		}
 		page = skb_frag_page(frags);
-		prefetchw(page);
 		pages[pages_to_map++] = page;
 		length += PAGE_SIZE;
 		zc->recv_skip_hint -= PAGE_SIZE;
 		frags++;
+		skb_remainder_unmappable = zc->recv_skip_hint < PAGE_SIZE;
 		if (pages_to_map == TCP_ZEROCOPY_PAGE_BATCH_SIZE ||
-		    zc->recv_skip_hint < PAGE_SIZE) {
+		    skb_remainder_unmappable) {
+			unsigned long pages_acctd = 0;
+
 			/* Either full batch, or we're about to go to next skb
 			 * (and we cannot unroll failed ops across skbs).
 			 */
+			memset(page_prepared, 0, sizeof(page_prepared));
 			ret = tcp_zerocopy_vm_insert_batch(vma, pages,
+							   page_prepared,
 							   pages_to_map,
 							   &address, &length,
 							   &seq, zc,
-							   total_bytes_to_map);
+							   total_bytes_to_map,
+							   &pages_acctd,
+							   memcg);
+			total_pages_acctd += pages_acctd;
 			if (ret)
 				goto out;
 			pages_to_map = 0;
 		}
+		if (!skb_remainder_unmappable)
+			prefetchw(skb_frag_page(frags));
 	}
 	if (pages_to_map) {
-		ret = tcp_zerocopy_vm_insert_batch(vma, pages, pages_to_map,
-						   &address, &length, &seq,
-						   zc, total_bytes_to_map);
+		unsigned long pages_acctd = 0;
+
+		memset(page_prepared, 0, sizeof(page_prepared));
+		ret = tcp_zerocopy_vm_insert_batch(vma, pages,
+						   page_prepared,
+						   pages_to_map, &address,
+						   &length, &seq, zc,
+						   total_bytes_to_map,
+						   &pages_acctd, memcg);
+		total_pages_acctd += pages_acctd;
 	}
 out:
 	mmap_read_unlock(current->mm);
@@ -2190,6 +2237,10 @@ static int tcp_zerocopy_receive(struct sock *sk,
 			ret = -EIO;
 	}
 	zc->length = length;
+
+	/* Account pages to user. */
+	mem_cgroup_post_charge_sock_pages(memcg, total_pages_acctd);
+	mem_cgroup_put(memcg);
 	return ret;
 }
 #endif
-- 
2.31.0.rc2.261.g7f71774620-goog

