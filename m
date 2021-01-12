Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3662F3D86
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391815AbhALVmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbhALVl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 16:41:58 -0500
Received: from mail-vk1-xa4a.google.com (mail-vk1-xa4a.google.com [IPv6:2607:f8b0:4864:20::a4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CECC06179F
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:41:18 -0800 (PST)
Received: by mail-vk1-xa4a.google.com with SMTP id b62so65750vkh.19
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 13:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=gvscUF4Dof4MYNJwCr6QYW2p2MKb7baxEXgHhEh82es=;
        b=KH5d8sNlDIOIreu+i0yZi/gbTnZUY/Hi6pEOwbRLfwQikG0mxW2QCj/OxIURgfvEWw
         zK5mSpwrmmf73a4YsIvqqWS8QWgL9WUGKOt7gu3Lds3V99gpgrX2WS73wQqfbo40w5zy
         HWmRGnMw4Mzy90rhToQc6D495jP6D5uYEDl1KAwGWsQHk53UwmVdXJNjwnzuzi2wkoeD
         k158+eLQXBfY/1//T47lQF1eFmY8u8ZPQfBFOQ2prOVYFutpCXeQRXhLwEXtHibZIEjf
         RnuxMr3qKh7HRXzqbEXPe2JXVOQmqtsUG+jbU3hSIOaS/nL4jxEJEfgProip4ymjznKk
         b+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=gvscUF4Dof4MYNJwCr6QYW2p2MKb7baxEXgHhEh82es=;
        b=tfYX9Nf6pNXajQ/k/IsDb0jHzFRjUyrYfsoM2kTrX8BD3qX2UsJ5mg8u0CXjSyxM7G
         gAX4td0eg37crJJ58sWQOoiYfPBr1/AoDnxhgLVuemq32qJiQixtSfJZnOaqdcfLFugO
         6zZrHboImoxHv+F0sHQyUVQVWMXc8nUDi73YSSWeDqPs9Ve5F0oRE3V9ezgkKvDjQ0Ob
         IRGcbsPazfwK+52RWyzzIdsYfWsH1LXcYwe5IFTtwGEFOz46c2qKtHETAzknN7JGjS9R
         Q/jouPjfvdQFv84l5b5Jh11H8Q/wKz1efReedcaVq3ZGZ8+lZqlT1+rNUrnGXIsA7ev3
         GpOg==
X-Gm-Message-State: AOAM53273cd/oqLKNrUac1m8zONx95lg/td8rUEj7MsUxl6TUCOWkmAG
        0qI5lDaSTmJmCgtjsbyZvkVRt2xbSkEl7w==
X-Google-Smtp-Source: ABdhPJwAf25VQw04IJmdVyIfhTdzw4p1Vdkij3R78t25Rs81yDggdGPuxrEtjS8GTpzhgl2O1kiYRJF8wFP1Zg==
Sender: "shakeelb via sendgmr" <shakeelb@shakeelb.svl.corp.google.com>
X-Received: from shakeelb.svl.corp.google.com ([2620:15c:2cd:202:a28c:fdff:fee8:36f0])
 (user=shakeelb job=sendgmr) by 2002:a1f:bdd3:: with SMTP id
 n202mr1347561vkf.9.1610487677355; Tue, 12 Jan 2021 13:41:17 -0800 (PST)
Date:   Tue, 12 Jan 2021 13:41:05 -0800
Message-Id: <20210112214105.1440932-1-shakeelb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH] mm: net: memcg accounting for TCP rx zerocopy
From:   Shakeel Butt <shakeelb@google.com>
To:     Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjun Roy <arjunroy@google.com>,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

TCP zerocopy receive is used by high performance network applications to
further scale. For RX zerocopy, the memory containing the network data
filled by network driver is directly mapped into the address space of
high performance applications. To keep the TLB cost low, these
applications unmaps the network memory in big batches. So, this memory
can remain mapped for long time. This can cause memory isolation issue
as this memory becomes unaccounted after getting mapped into the
application address space. This patch adds the memcg accounting for such
memory.

Accounting the network memory comes with its own unique challenge. The
high performance NIC drivers use page pooling to reuse the pages to
eliminate/reduce the expensive setup steps like IOMMU. These drivers
keep an extra reference on the pages and thus we can not depends on the
page reference for the uncharging. The page in the pool may keep a memcg
pinned for arbitrary long time or may get used by other memcg.

This patch decouples the uncharging of the page from the refcnt and
associate it with the map count i.e. the page gets uncharged when the
last address space unmaps it. Now the question what if the driver drops
its reference while the page is still mapped. That is fine as the
address space also holds a reference to the page i.e. the reference
count can not drop to zero before the map count.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Co-developed-by: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 include/linux/memcontrol.h | 34 +++++++++++++++++++--
 mm/memcontrol.c            | 60 ++++++++++++++++++++++++++++++++++++++
 mm/rmap.c                  |  3 ++
 net/ipv4/tcp.c             | 27 +++++++++++++----
 4 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7a38a1517a05..0b0e3b4615cf 100644
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
@@ -1095,6 +1102,11 @@ static inline bool PageMemcgKmem(struct page *page)
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
@@ -1561,6 +1573,10 @@ extern struct static_key_false memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
 void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
+int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
+				 unsigned int nr_pages);
+void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages);
+
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
@@ -1589,6 +1605,18 @@ static inline void memcg_set_shrinker_bit(struct mem_cgroup *memcg,
 					  int nid, int shrinker_id)
 {
 }
+
+static inline int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg,
+					       struct page **pages,
+					       unsigned int nr_pages)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_uncharge_sock_pages(struct page **pages,
+						  unsigned int nr_pages)
+{
+}
 #endif
 
 #ifdef CONFIG_MEMCG_KMEM
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index db9836f4b64b..38e94538e081 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7061,6 +7061,66 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 	refill_stock(memcg, nr_pages);
 }
 
+/**
+ * mem_cgroup_charge_sock_pages - charge socket memory
+ * @memcg: memcg to charge
+ * @pages: array of pages to charge
+ * @nr_pages: number of pages
+ *
+ * Charges all @pages to current's memcg. The caller should have a reference on
+ * the given memcg.
+ *
+ * Returns 0 on success.
+ */
+int mem_cgroup_charge_sock_pages(struct mem_cgroup *memcg, struct page **pages,
+				 unsigned int nr_pages)
+{
+	int ret = 0;
+
+	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
+		goto out;
+
+	ret = try_charge(memcg, GFP_KERNEL, nr_pages);
+
+	if (!ret) {
+		int i;
+
+		for (i = 0; i < nr_pages; i++)
+			pages[i]->memcg_data = (unsigned long)memcg |
+				MEMCG_DATA_SOCK;
+		css_get_many(&memcg->css, nr_pages);
+	}
+out:
+	return ret;
+}
+
+/**
+ * mem_cgroup_uncharge_sock_pages - uncharge socket pages
+ * @pages: array of pages to uncharge
+ * @nr_pages: number of pages
+ *
+ * This assumes all pages are charged to the same memcg.
+ */
+void mem_cgroup_uncharge_sock_pages(struct page **pages, unsigned int nr_pages)
+{
+	int i;
+	struct mem_cgroup *memcg;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	memcg = page_memcg(pages[0]);
+
+	if (unlikely(!memcg))
+		return;
+
+	refill_stock(memcg, nr_pages);
+
+	for (i = 0; i < nr_pages; i++)
+		pages[i]->memcg_data = 0;
+	css_put_many(&memcg->css, nr_pages);
+}
+
 static int __init cgroup_memory(char *s)
 {
 	char *token;
diff --git a/mm/rmap.c b/mm/rmap.c
index 5ebf16fae4b9..ea6b09757215 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1284,6 +1284,9 @@ static void page_remove_file_rmap(struct page *page, bool compound)
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
+
+	if (unlikely(PageMemcgSock(page)))
+		mem_cgroup_uncharge_sock_pages(&page, 1);
 }
 
 static void page_remove_anon_compound_rmap(struct page *page)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2267d21c73a6..af0cec677aa0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1934,6 +1934,8 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
 					      u32 total_bytes_to_map,
 					      int err)
 {
+	unsigned int pages_mapped = 0;
+
 	/* At least one page did not map. Try zapping if we skipped earlier. */
 	if (err == -EBUSY &&
 	    zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT) {
@@ -1954,7 +1956,8 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
 		err = vm_insert_pages(vma, *address,
 				      pending_pages,
 				      &pages_remaining);
-		bytes_mapped = PAGE_SIZE * (leftover_pages - pages_remaining);
+		pages_mapped = leftover_pages - pages_remaining;
+		bytes_mapped = PAGE_SIZE * pages_mapped;
 		*seq += bytes_mapped;
 		*address += bytes_mapped;
 	}
@@ -1968,11 +1971,16 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
 
 		*length -= bytes_not_mapped;
 		zc->recv_skip_hint += bytes_not_mapped;
+
+		/* Cancel the memcg charge for remaining pages. */
+		mem_cgroup_uncharge_sock_pages(pending_pages + pages_mapped,
+					       pages_remaining);
 	}
 	return err;
 }
 
 static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
+					struct mem_cgroup *memcg,
 					struct page **pages,
 					unsigned int pages_to_map,
 					unsigned long *address,
@@ -1986,6 +1994,11 @@ static int tcp_zerocopy_vm_insert_batch(struct vm_area_struct *vma,
 	unsigned int bytes_mapped;
 	int err;
 
+	err = mem_cgroup_charge_sock_pages(memcg, pages, pages_to_map);
+
+	if (unlikely(err))
+		return err;
+
 	err = vm_insert_pages(vma, *address, pages, &pages_remaining);
 	pages_mapped = pages_to_map - (unsigned int)pages_remaining;
 	bytes_mapped = PAGE_SIZE * pages_mapped;
@@ -2011,6 +2024,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	u32 length = 0, offset, vma_len, avail_len, copylen = 0;
 	unsigned long address = (unsigned long)zc->address;
 	struct page *pages[TCP_ZEROCOPY_PAGE_BATCH_SIZE];
+	struct mem_cgroup *memcg;
 	s32 copybuf_len = zc->copybuf_len;
 	struct tcp_sock *tp = tcp_sk(sk);
 	const skb_frag_t *frags = NULL;
@@ -2062,6 +2076,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		zc->length = avail_len;
 		zc->recv_skip_hint = avail_len;
 	}
+	memcg = get_mem_cgroup_from_mm(current->mm);
 	ret = 0;
 	while (length + PAGE_SIZE <= zc->length) {
 		int mappable_offset;
@@ -2101,7 +2116,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 			/* Either full batch, or we're about to go to next skb
 			 * (and we cannot unroll failed ops across skbs).
 			 */
-			ret = tcp_zerocopy_vm_insert_batch(vma, pages,
+			ret = tcp_zerocopy_vm_insert_batch(vma, memcg, pages,
 							   pages_to_map,
 							   &address, &length,
 							   &seq, zc,
@@ -2112,9 +2127,10 @@ static int tcp_zerocopy_receive(struct sock *sk,
 		}
 	}
 	if (pages_to_map) {
-		ret = tcp_zerocopy_vm_insert_batch(vma, pages, pages_to_map,
-						   &address, &length, &seq,
-						   zc, total_bytes_to_map);
+		ret = tcp_zerocopy_vm_insert_batch(vma, memcg, pages,
+						   pages_to_map, &address,
+						   &length, &seq, zc,
+						   total_bytes_to_map);
 	}
 out:
 	mmap_read_unlock(current->mm);
@@ -2138,6 +2154,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
 			ret = -EIO;
 	}
 	zc->length = length;
+	mem_cgroup_put(memcg);
 	return ret;
 }
 #endif
-- 
2.30.0.284.gd98b1dd5eaa7-goog

