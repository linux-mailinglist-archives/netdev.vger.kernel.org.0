Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045422B584F
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgKQDnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:43:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9352 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726510AbgKQDlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:41:18 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AH3dSB2013761
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=LrQC28K2WsL9UuG+4e/dXoM0Ws5Ciafct7wggEglOtU=;
 b=YY4GSXP6qffjgqF1F6aGd6ThP7d+9TxGsD17/Yo6LjX5Nbcc7RWp+93iFCzU+M9ku4If
 CzTXtbLuBrXOJMSjStep2LwTL+OWllfSzm5LFnlg9s4XfiidN8DQPOKqzu4g4CQYbBPK
 +i8bPS7JnCgf8jY0EsvLaDDyReIQeOBAO8I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 34tbm4usqg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:16 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 19:41:12 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 24307C63A5E; Mon, 16 Nov 2020 19:41:10 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v6 04/34] mm: convert page kmemcg type to a page memcg flag
Date:   Mon, 16 Nov 2020 19:40:38 -0800
Message-ID: <20201117034108.1186569-5-guro@fb.com>
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
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=3 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170027
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PageKmemcg flag is currently defined as a page type (like buddy, offline,
table and guard).  Semantically it means that the page was accounted as a
kernel memory by the page allocator and has to be uncharged on the
release.

As a side effect of defining the flag as a page type, the accounted page
can't be mapped to userspace (look at page_has_type() and comments above).
In particular, this blocks the accounting of vmalloc-backed memory used
by some bpf maps, because these maps do map the memory to userspace.

One option is to fix it by complicating the access to page->mapcount,
which provides some free bits for page->page_type.

But it's way better to move this flag into page->memcg_data flags.
Indeed, the flag makes no sense without enabled memory cgroups and memory
cgroup pointer set in particular.

This commit replaces PageKmemcg() and __SetPageKmemcg() with
PageMemcgKmem() and an open-coded OR operation setting the memcg pointer
with the MEMCG_DATA_KMEM bit.  __ClearPageKmemcg() can be simple deleted,
as the whole memcg_data is zeroed at once.

As a bonus, on !CONFIG_MEMCG build the PageMemcgKmem() check will be
compiled out.

Link: https://lkml.kernel.org/r/20201027001657.3398190-5-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/memcontrol.h | 37 +++++++++++++++++++++++++++++++++----
 include/linux/page-flags.h | 11 ++---------
 mm/memcontrol.c            | 16 +++++-----------
 mm/page_alloc.c            |  4 ++--
 4 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 99a4841d658b..7c9d43476166 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -346,8 +346,10 @@ extern struct mem_cgroup *root_mem_cgroup;
 enum page_memcg_data_flags {
 	/* page->memcg_data is a pointer to an objcgs vector */
 	MEMCG_DATA_OBJCGS =3D (1UL << 0),
+	/* page has been accounted as a non-slab kernel page */
+	MEMCG_DATA_KMEM =3D (1UL << 1),
 	/* the next bit after the last actual flag */
-	__NR_MEMCG_DATA_FLAGS  =3D (1UL << 1),
+	__NR_MEMCG_DATA_FLAGS  =3D (1UL << 2),
 };
=20
 #define MEMCG_DATA_FLAGS_MASK (__NR_MEMCG_DATA_FLAGS - 1)
@@ -369,8 +371,12 @@ enum page_memcg_data_flags {
  */
 static inline struct mem_cgroup *page_memcg(struct page *page)
 {
+	unsigned long memcg_data =3D page->memcg_data;
+
 	VM_BUG_ON_PAGE(PageSlab(page), page);
-	return (struct mem_cgroup *)page->memcg_data;
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_OBJCGS, page);
+
+	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
=20
 /*
@@ -387,7 +393,8 @@ static inline struct mem_cgroup *page_memcg_rcu(struct =
page *page)
 	VM_BUG_ON_PAGE(PageSlab(page), page);
 	WARN_ON_ONCE(!rcu_read_lock_held());
=20
-	return (struct mem_cgroup *)READ_ONCE(page->memcg_data);
+	return (struct mem_cgroup *)(READ_ONCE(page->memcg_data) &
+				     ~MEMCG_DATA_FLAGS_MASK);
 }
=20
 /*
@@ -416,7 +423,21 @@ static inline struct mem_cgroup *page_memcg_check(stru=
ct page *page)
 	if (memcg_data & MEMCG_DATA_OBJCGS)
 		return NULL;
=20
-	return (struct mem_cgroup *)memcg_data;
+	return (struct mem_cgroup *)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
+}
+
+/*
+ * PageMemcgKmem - check if the page has MemcgKmem flag set
+ * @page: a pointer to the page struct
+ *
+ * Checks if the page has MemcgKmem flag set. The caller must ensure that
+ * the page has an associated memory cgroup. It's not safe to call this fu=
nction
+ * against some types of pages, e.g. slab pages.
+ */
+static inline bool PageMemcgKmem(struct page *page)
+{
+	VM_BUG_ON_PAGE(page->memcg_data & MEMCG_DATA_OBJCGS, page);
+	return page->memcg_data & MEMCG_DATA_KMEM;
 }
=20
 #ifdef CONFIG_MEMCG_KMEM
@@ -435,6 +456,7 @@ static inline struct obj_cgroup **page_objcgs(struct pa=
ge *page)
 	unsigned long memcg_data =3D READ_ONCE(page->memcg_data);
=20
 	VM_BUG_ON_PAGE(memcg_data && !(memcg_data & MEMCG_DATA_OBJCGS), page);
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_KMEM, page);
=20
 	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
@@ -454,6 +476,8 @@ static inline struct obj_cgroup **page_objcgs_check(str=
uct page *page)
 	if (!memcg_data || !(memcg_data & MEMCG_DATA_OBJCGS))
 		return NULL;
=20
+	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_KMEM, page);
+
 	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
=20
@@ -1109,6 +1133,11 @@ static inline struct mem_cgroup *page_memcg_check(st=
ruct page *page)
 	return NULL;
 }
=20
+static inline bool PageMemcgKmem(struct page *page)
+{
+	return false;
+}
+
 static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 {
 	return true;
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4f6ba9379112..fc0e1bd48e73 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -715,9 +715,8 @@ PAGEFLAG_FALSE(DoubleMap)
 #define PAGE_MAPCOUNT_RESERVE	-128
 #define PG_buddy	0x00000080
 #define PG_offline	0x00000100
-#define PG_kmemcg	0x00000200
-#define PG_table	0x00000400
-#define PG_guard	0x00000800
+#define PG_table	0x00000200
+#define PG_guard	0x00000400
=20
 #define PageType(page, flag)						\
 	((page->page_type & (PAGE_TYPE_BASE | flag)) =3D=3D PAGE_TYPE_BASE)
@@ -768,12 +767,6 @@ PAGE_TYPE_OPS(Buddy, buddy)
  */
 PAGE_TYPE_OPS(Offline, offline)
=20
-/*
- * If kmemcg is enabled, the buddy allocator will set PageKmemcg() on
- * pages allocated with __GFP_ACCOUNT. It gets cleared on page free.
- */
-PAGE_TYPE_OPS(Kmemcg, kmemcg)
-
 /*
  * Marks pages in use as page tables.
  */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0054b4846770..e0366e306221 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3090,8 +3090,8 @@ int __memcg_kmem_charge_page(struct page *page, gfp_t=
 gfp, int order)
 	if (memcg && !mem_cgroup_is_root(memcg)) {
 		ret =3D __memcg_kmem_charge(memcg, gfp, 1 << order);
 		if (!ret) {
-			page->memcg_data =3D (unsigned long)memcg;
-			__SetPageKmemcg(page);
+			page->memcg_data =3D (unsigned long)memcg |
+				MEMCG_DATA_KMEM;
 			return 0;
 		}
 		css_put(&memcg->css);
@@ -3116,10 +3116,6 @@ void __memcg_kmem_uncharge_page(struct page *page, i=
nt order)
 	__memcg_kmem_uncharge(memcg, nr_pages);
 	page->memcg_data =3D 0;
 	css_put(&memcg->css);
-
-	/* slab pages do not have PageKmemcg flag set */
-	if (PageKmemcg(page))
-		__ClearPageKmemcg(page);
 }
=20
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_by=
tes)
@@ -6877,12 +6873,10 @@ static void uncharge_page(struct page *page, struct=
 uncharge_gather *ug)
 	nr_pages =3D compound_nr(page);
 	ug->nr_pages +=3D nr_pages;
=20
-	if (!PageKmemcg(page)) {
-		ug->pgpgout++;
-	} else {
+	if (PageMemcgKmem(page))
 		ug->nr_kmem +=3D nr_pages;
-		__ClearPageKmemcg(page);
-	}
+	else
+		ug->pgpgout++;
=20
 	ug->dummy_page =3D page;
 	page->memcg_data =3D 0;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 271133b8243b..3c53018c9c61 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1214,7 +1214,7 @@ static __always_inline bool free_pages_prepare(struct=
 page *page,
 		 * Do not let hwpoison pages hit pcplists/buddy
 		 * Untie memcg state and reset page's owner
 		 */
-		if (memcg_kmem_enabled() && PageKmemcg(page))
+		if (memcg_kmem_enabled() && PageMemcgKmem(page))
 			__memcg_kmem_uncharge_page(page, order);
 		reset_page_owner(page, order);
 		return false;
@@ -1244,7 +1244,7 @@ static __always_inline bool free_pages_prepare(struct=
 page *page,
 	}
 	if (PageMappingFlags(page))
 		page->mapping =3D NULL;
-	if (memcg_kmem_enabled() && PageKmemcg(page))
+	if (memcg_kmem_enabled() && PageMemcgKmem(page))
 		__memcg_kmem_uncharge_page(page, order);
 	if (check_free)
 		bad +=3D check_free_page(page);
--=20
2.26.2

