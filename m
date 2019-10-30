Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F62EA6ED
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbfJ3WvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:51:19 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10876 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727705AbfJ3Wtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:49:52 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dba13930000>; Wed, 30 Oct 2019 15:49:55 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 30 Oct 2019 15:49:50 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 30 Oct 2019 15:49:50 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Oct
 2019 22:49:49 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Oct
 2019 22:49:49 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 30 Oct 2019 22:49:48 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dba138b0001>; Wed, 30 Oct 2019 15:49:48 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Paul Mackerras" <paulus@samba.org>, Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 12/19] mm/gup: track FOLL_PIN pages
Date:   Wed, 30 Oct 2019 15:49:23 -0700
Message-ID: <20191030224930.3990755-13-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030224930.3990755-1-jhubbard@nvidia.com>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572475795; bh=QB4piIeYSHaPr0lrpZOxR61169WQMbaj1LD/Isgokvk=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=hKlTHK/NVuiQus97TKJyqcTj1f6CAJWw1pFJrMnif42P4H7Mf0kfc2jVBSSt5cF0G
         I0fx8nn/hj3tMygwTBzda0fwGJpK1NdsJAaYGHjjmuux7fMTo2gpp0ULcs95R2EwqM
         9cEfJnNeNiHbw0SIeDP5XeVqtzy3AUxVJVFFO5gWFYGvKZMXaic1UFr0YrJiaagjKp
         lSX/YIZSjaYKisC9jZTQ4dksmQoTgGGMmW5FRmAoEfxkPpmswokRi483/0aT6EIQlZ
         Exd+DWfHU8arMp6cX+Nrcd7EGmrU/AN3KT2HcEhKd4StqwUpFrPdLTtkypuaBOJ8ZX
         ZWEIANvWEZT/g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tracking of pages that were pinned via FOLL_PIN.

As mentioned in the FOLL_PIN documentation, callers who effectively set
FOLL_PIN are required to ultimately free such pages via put_user_page().
The effect is similar to FOLL_GET, and may be thought of as "FOLL_GET
for DIO and/or RDMA use".

Pages that have been pinned via FOLL_PIN are identifiable via a
new function call:

   bool page_dma_pinned(struct page *page);

What to do in response to encountering such a page, is left to later
patchsets. There is discussion about this in [1].

This also changes a BUG_ON(), to a WARN_ON(), in follow_page_mask().

This also has a couple of trivial, non-functional change fixes to
try_get_compound_head(). That function got moved to the top of the
file.

This includes the following fix from Ira Weiny:

DAX requires detection of a page crossing to a ref count of 1.  Fix this
for GUP pages by introducing put_devmap_managed_user_page() which
accounts for GUP_PIN_COUNTING_BIAS now used by GUP.

[1] https://lwn.net/Articles/784574/ "Some slow progress on
get_user_pages()"

Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 include/linux/mm.h       |  80 +++++++++++----
 include/linux/mmzone.h   |   2 +
 include/linux/page_ref.h |  10 ++
 mm/gup.c                 | 213 +++++++++++++++++++++++++++++++--------
 mm/huge_memory.c         |  32 +++++-
 mm/hugetlb.c             |  28 ++++-
 mm/memremap.c            |   4 +-
 mm/vmstat.c              |   2 +
 8 files changed, 300 insertions(+), 71 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 62c838a3e6c7..882fda919c81 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -972,9 +972,10 @@ static inline bool is_zone_device_page(const struct pa=
ge *page)
 #endif
=20
 #ifdef CONFIG_DEV_PAGEMAP_OPS
-void __put_devmap_managed_page(struct page *page);
+void __put_devmap_managed_page(struct page *page, int count);
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
-static inline bool put_devmap_managed_page(struct page *page)
+
+static inline bool page_is_devmap_managed(struct page *page)
 {
 	if (!static_branch_unlikely(&devmap_managed_key))
 		return false;
@@ -983,7 +984,6 @@ static inline bool put_devmap_managed_page(struct page =
*page)
 	switch (page->pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
 	case MEMORY_DEVICE_FS_DAX:
-		__put_devmap_managed_page(page);
 		return true;
 	default:
 		break;
@@ -991,6 +991,19 @@ static inline bool put_devmap_managed_page(struct page=
 *page)
 	return false;
 }
=20
+static inline bool put_devmap_managed_page(struct page *page)
+{
+	bool is_devmap =3D page_is_devmap_managed(page);
+
+	if (is_devmap) {
+		int count =3D page_ref_dec_return(page);
+
+		__put_devmap_managed_page(page, count);
+	}
+
+	return is_devmap;
+}
+
 #else /* CONFIG_DEV_PAGEMAP_OPS */
 static inline bool put_devmap_managed_page(struct page *page)
 {
@@ -1038,6 +1051,8 @@ static inline __must_check bool try_get_page(struct p=
age *page)
 	return true;
 }
=20
+__must_check bool user_page_ref_inc(struct page *page);
+
 static inline void put_page(struct page *page)
 {
 	page =3D compound_head(page);
@@ -1055,31 +1070,56 @@ static inline void put_page(struct page *page)
 		__put_page(page);
 }
=20
-/**
- * put_user_page() - release a gup-pinned page
- * @page:            pointer to page to be released
+/*
+ * GUP_PIN_COUNTING_BIAS, and the associated functions that use it, overlo=
ad
+ * the page's refcount so that two separate items are tracked: the origina=
l page
+ * reference count, and also a new count of how many get_user_pages() call=
s were
+ * made against the page. ("gup-pinned" is another term for the latter).
+ *
+ * With this scheme, get_user_pages() becomes special: such pages are mark=
ed
+ * as distinct from normal pages. As such, the new put_user_page() call (a=
nd
+ * its variants) must be used in order to release gup-pinned pages.
+ *
+ * Choice of value:
  *
- * Pages that were pinned via get_user_pages*() must be released via
- * either put_user_page(), or one of the put_user_pages*() routines
- * below. This is so that eventually, pages that are pinned via
- * get_user_pages*() can be separately tracked and uniquely handled. In
- * particular, interactions with RDMA and filesystems need special
- * handling.
+ * By making GUP_PIN_COUNTING_BIAS a power of two, debugging of page refer=
ence
+ * counts with respect to get_user_pages() and put_user_page() becomes sim=
pler,
+ * due to the fact that adding an even power of two to the page refcount h=
as
+ * the effect of using only the upper N bits, for the code that counts up =
using
+ * the bias value. This means that the lower bits are left for the exclusi=
ve
+ * use of the original code that increments and decrements by one (or at l=
east,
+ * by much smaller values than the bias value).
  *
- * put_user_page() and put_page() are not interchangeable, despite this ea=
rly
- * implementation that makes them look the same. put_user_page() calls mus=
t
- * be perfectly matched up with get_user_page() calls.
+ * Of course, once the lower bits overflow into the upper bits (and this i=
s
+ * OK, because subtraction recovers the original values), then visual insp=
ection
+ * no longer suffices to directly view the separate counts. However, for n=
ormal
+ * applications that don't have huge page reference counts, this won't be =
an
+ * issue.
+ *
+ * Locking: the lockless algorithm described in page_cache_get_speculative=
()
+ * and page_cache_gup_pin_speculative() provides safe operation for
+ * get_user_pages and page_mkclean and other calls that race to set up pag=
e
+ * table entries.
  */
-static inline void put_user_page(struct page *page)
-{
-	put_page(page);
-}
+#define GUP_PIN_COUNTING_BIAS (1UL << 10)
=20
+void put_user_page(struct page *page);
 void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
 			       bool make_dirty);
-
 void put_user_pages(struct page **pages, unsigned long npages);
=20
+/**
+ * page_dma_pinned() - report if a page is pinned by a call to pin_user_pa=
ges*()
+ * or pin_longterm_pages*()
+ * @page:	pointer to page to be queried.
+ * @Return:	True, if it is likely that the page has been "dma-pinned".
+ *		False, if the page is definitely not dma-pinned.
+ */
+static inline bool page_dma_pinned(struct page *page)
+{
+	return (page_ref_count(compound_head(page))) >=3D GUP_PIN_COUNTING_BIAS;
+}
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index bda20282746b..0485cba38d23 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -244,6 +244,8 @@ enum node_stat_item {
 	NR_DIRTIED,		/* page dirtyings since bootup */
 	NR_WRITTEN,		/* page writings since bootup */
 	NR_KERNEL_MISC_RECLAIMABLE,	/* reclaimable non-slab kernel pages */
+	NR_FOLL_PIN_REQUESTED,	/* via: pin_user_page(), gup flag: FOLL_PIN */
+	NR_FOLL_PIN_RETURNED,	/* pages returned via put_user_page() */
 	NR_VM_NODE_STAT_ITEMS
 };
=20
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 14d14beb1f7f..b9cbe553d1e7 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -102,6 +102,16 @@ static inline void page_ref_sub(struct page *page, int=
 nr)
 		__page_ref_mod(page, -nr);
 }
=20
+static inline int page_ref_sub_return(struct page *page, int nr)
+{
+	int ret =3D atomic_sub_return(nr, &page->_refcount);
+
+	if (page_ref_tracepoint_active(__tracepoint_page_ref_mod))
+		__page_ref_mod(page, -nr);
+
+	return ret;
+}
+
 static inline void page_ref_inc(struct page *page)
 {
 	atomic_inc(&page->_refcount);
diff --git a/mm/gup.c b/mm/gup.c
index 8694bc7b3df3..e51b3820a995 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -29,6 +29,102 @@ struct follow_page_context {
 	unsigned int page_mask;
 };
=20
+/*
+ * Return the compound head page with ref appropriately incremented,
+ * or NULL if that failed.
+ */
+static inline struct page *try_get_compound_head(struct page *page, int re=
fs)
+{
+	struct page *head =3D compound_head(page);
+
+	if (WARN_ON_ONCE(page_ref_count(head) < 0))
+		return NULL;
+	if (unlikely(!page_cache_add_speculative(head, refs)))
+		return NULL;
+	return head;
+}
+
+#ifdef CONFIG_DEBUG_VM
+static inline void __update_proc_vmstat(struct page *page,
+					enum node_stat_item item, int count)
+{
+	mod_node_page_state(page_pgdat(page), item, count);
+}
+#else
+static inline void __update_proc_vmstat(struct page *page,
+					enum node_stat_item item, int count)
+{
+}
+#endif
+
+/**
+ * user_page_ref_inc() - mark a page as being used by get_user_pages(FOLL_=
PIN).
+ *
+ * @page:	pointer to page to be marked
+ * @Return:	true for success, false for failure
+ */
+__must_check bool user_page_ref_inc(struct page *page)
+{
+	page =3D try_get_compound_head(page, GUP_PIN_COUNTING_BIAS);
+	if (!page)
+		return false;
+
+	__update_proc_vmstat(page, NR_FOLL_PIN_REQUESTED, 1);
+	return true;
+}
+
+#ifdef CONFIG_DEV_PAGEMAP_OPS
+static bool __put_devmap_managed_user_page(struct page *page)
+{
+	bool is_devmap =3D page_is_devmap_managed(page);
+
+	if (is_devmap) {
+		int count =3D page_ref_sub_return(page, GUP_PIN_COUNTING_BIAS);
+
+		__update_proc_vmstat(page, NR_FOLL_PIN_RETURNED, 1);
+		__put_devmap_managed_page(page, count);
+	}
+
+	return is_devmap;
+}
+#else
+static bool __put_devmap_managed_user_page(struct page *page)
+{
+	return false;
+}
+#endif /* CONFIG_DEV_PAGEMAP_OPS */
+
+/**
+ * put_user_page() - release a gup-pinned page
+ * @page:            pointer to page to be released
+ *
+ * Pages that were pinned via get_user_pages*() must be released via
+ * either put_user_page(), or one of the put_user_pages*() routines
+ * below. This is so that eventually, pages that are pinned via
+ * get_user_pages*() can be separately tracked and uniquely handled. In
+ * particular, interactions with RDMA and filesystems need special
+ * handling.
+ */
+void put_user_page(struct page *page)
+{
+	page =3D compound_head(page);
+
+	/*
+	 * For devmap managed pages we need to catch refcount transition from
+	 * GUP_PIN_COUNTING_BIAS to 1, when refcount reach one it means the
+	 * page is free and we need to inform the device driver through
+	 * callback. See include/linux/memremap.h and HMM for details.
+	 */
+	if (__put_devmap_managed_user_page(page))
+		return;
+
+	if (page_ref_sub_and_test(page, GUP_PIN_COUNTING_BIAS))
+		__put_page(page);
+
+	__update_proc_vmstat(page, NR_FOLL_PIN_RETURNED, 1);
+}
+EXPORT_SYMBOL(put_user_page);
+
 /**
  * put_user_pages_dirty_lock() - release and optionally dirty gup-pinned p=
ages
  * @pages:  array of pages to be maybe marked dirty, and definitely releas=
ed.
@@ -215,10 +311,11 @@ static struct page *follow_page_pte(struct vm_area_st=
ruct *vma,
 	}
=20
 	page =3D vm_normal_page(vma, address, pte);
-	if (!page && pte_devmap(pte) && (flags & FOLL_GET)) {
+	if (!page && pte_devmap(pte) && (flags & (FOLL_GET | FOLL_PIN))) {
 		/*
-		 * Only return device mapping pages in the FOLL_GET case since
-		 * they are only valid while holding the pgmap reference.
+		 * Only return device mapping pages in the FOLL_GET or FOLL_PIN
+		 * case since they are only valid while holding the pgmap
+		 * reference.
 		 */
 		*pgmap =3D get_dev_pagemap(pte_pfn(pte), *pgmap);
 		if (*pgmap)
@@ -261,6 +358,11 @@ static struct page *follow_page_pte(struct vm_area_str=
uct *vma,
 			page =3D ERR_PTR(-ENOMEM);
 			goto out;
 		}
+	} else if (flags & FOLL_PIN) {
+		if (unlikely(!user_page_ref_inc(page))) {
+			page =3D ERR_PTR(-ENOMEM);
+			goto out;
+		}
 	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
@@ -522,8 +624,8 @@ static struct page *follow_page_mask(struct vm_area_str=
uct *vma,
 	/* make this handle hugepd */
 	page =3D follow_huge_addr(mm, address, flags & FOLL_WRITE);
 	if (!IS_ERR(page)) {
-		BUG_ON(flags & FOLL_GET);
-		return page;
+		WARN_ON_ONCE(flags & (FOLL_GET | FOLL_PIN));
+		return NULL;
 	}
=20
 	pgd =3D pgd_offset(mm, address);
@@ -1824,30 +1926,20 @@ static inline pte_t gup_get_pte(pte_t *ptep)
 #endif /* CONFIG_GUP_GET_PTE_LOW_HIGH */
=20
 static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
+					    unsigned int flags,
 					    struct page **pages)
 {
 	while ((*nr) - nr_start) {
 		struct page *page =3D pages[--(*nr)];
=20
 		ClearPageReferenced(page);
-		put_page(page);
+		if (flags & FOLL_PIN)
+			put_user_page(page);
+		else
+			put_page(page);
 	}
 }
=20
-/*
- * Return the compund head page with ref appropriately incremented,
- * or NULL if that failed.
- */
-static inline struct page *try_get_compound_head(struct page *page, int re=
fs)
-{
-	struct page *head =3D compound_head(page);
-	if (WARN_ON_ONCE(page_ref_count(head) < 0))
-		return NULL;
-	if (unlikely(!page_cache_add_speculative(head, refs)))
-		return NULL;
-	return head;
-}
-
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
 static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 			 unsigned int flags, struct page **pages, int *nr)
@@ -1877,7 +1969,7 @@ static int gup_pte_range(pmd_t pmd, unsigned long add=
r, unsigned long end,
=20
 			pgmap =3D get_dev_pagemap(pte_pfn(pte), pgmap);
 			if (unlikely(!pgmap)) {
-				undo_dev_pagemap(nr, nr_start, pages);
+				undo_dev_pagemap(nr, nr_start, flags, pages);
 				goto pte_unmap;
 			}
 		} else if (pte_special(pte))
@@ -1886,9 +1978,15 @@ static int gup_pte_range(pmd_t pmd, unsigned long ad=
dr, unsigned long end,
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page =3D pte_page(pte);
=20
-		head =3D try_get_compound_head(page, 1);
-		if (!head)
-			goto pte_unmap;
+		if (flags & FOLL_PIN) {
+			head =3D page;
+			if (unlikely(!user_page_ref_inc(head)))
+				goto pte_unmap;
+		} else {
+			head =3D try_get_compound_head(page, 1);
+			if (!head)
+				goto pte_unmap;
+		}
=20
 		if (unlikely(pte_val(pte) !=3D pte_val(*ptep))) {
 			put_page(head);
@@ -1942,12 +2040,20 @@ static int __gup_device_huge(unsigned long pfn, uns=
igned long addr,
=20
 		pgmap =3D get_dev_pagemap(pfn, pgmap);
 		if (unlikely(!pgmap)) {
-			undo_dev_pagemap(nr, nr_start, pages);
+			undo_dev_pagemap(nr, nr_start, flags, pages);
 			return 0;
 		}
 		SetPageReferenced(page);
 		pages[*nr] =3D page;
-		get_page(page);
+
+		if (flags & FOLL_PIN) {
+			if (unlikely(!user_page_ref_inc(page))) {
+				undo_dev_pagemap(nr, nr_start, flags, pages);
+				return 0;
+			}
+		} else
+			get_page(page);
+
 		(*nr)++;
 		pfn++;
 	} while (addr +=3D PAGE_SIZE, addr !=3D end);
@@ -1969,7 +2075,7 @@ static int __gup_device_huge_pmd(pmd_t orig, pmd_t *p=
mdp, unsigned long addr,
 		return 0;
=20
 	if (unlikely(pmd_val(orig) !=3D pmd_val(*pmdp))) {
-		undo_dev_pagemap(nr, nr_start, pages);
+		undo_dev_pagemap(nr, nr_start, flags, pages);
 		return 0;
 	}
 	return 1;
@@ -1987,7 +2093,7 @@ static int __gup_device_huge_pud(pud_t orig, pud_t *p=
udp, unsigned long addr,
 		return 0;
=20
 	if (unlikely(pud_val(orig) !=3D pud_val(*pudp))) {
-		undo_dev_pagemap(nr, nr_start, pages);
+		undo_dev_pagemap(nr, nr_start, flags, pages);
 		return 0;
 	}
 	return 1;
@@ -2072,9 +2178,16 @@ static int gup_hugepte(pte_t *ptep, unsigned long sz=
, unsigned long addr,
 	page =3D head + ((addr & (sz-1)) >> PAGE_SHIFT);
 	refs =3D __record_subpages(page, addr, end, pages, *nr);
=20
-	head =3D try_get_compound_head(head, refs);
-	if (!head)
-		return 0;
+	if (flags & FOLL_PIN) {
+		head =3D page;
+		if (unlikely(!user_page_ref_inc(head)))
+			return 0;
+		head =3D page;
+	} else {
+		head =3D try_get_compound_head(head, refs);
+		if (!head)
+			return 0;
+	}
=20
 	if (unlikely(pte_val(pte) !=3D pte_val(*ptep))) {
 		__remove_refs_from_head(head, refs);
@@ -2129,9 +2242,15 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, uns=
igned long addr,
 	page =3D pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	refs =3D __record_subpages(page, addr, end, pages, *nr);
=20
-	head =3D try_get_compound_head(pmd_page(orig), refs);
-	if (!head)
-		return 0;
+	if (flags & FOLL_PIN) {
+		head =3D page;
+		if (unlikely(!user_page_ref_inc(head)))
+			return 0;
+	} else {
+		head =3D try_get_compound_head(pmd_page(orig), refs);
+		if (!head)
+			return 0;
+	}
=20
 	if (unlikely(pmd_val(orig) !=3D pmd_val(*pmdp))) {
 		__remove_refs_from_head(head, refs);
@@ -2160,9 +2279,15 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, uns=
igned long addr,
 	page =3D pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 	refs =3D __record_subpages(page, addr, end, pages, *nr);
=20
-	head =3D try_get_compound_head(pud_page(orig), refs);
-	if (!head)
-		return 0;
+	if (flags & FOLL_PIN) {
+		head =3D page;
+		if (unlikely(!user_page_ref_inc(head)))
+			return 0;
+	} else {
+		head =3D try_get_compound_head(pud_page(orig), refs);
+		if (!head)
+			return 0;
+	}
=20
 	if (unlikely(pud_val(orig) !=3D pud_val(*pudp))) {
 		__remove_refs_from_head(head, refs);
@@ -2186,9 +2311,15 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, uns=
igned long addr,
 	page =3D pgd_page(orig) + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
 	refs =3D __record_subpages(page, addr, end, pages, *nr);
=20
-	head =3D try_get_compound_head(pgd_page(orig), refs);
-	if (!head)
-		return 0;
+	if (flags & FOLL_PIN) {
+		head =3D page;
+		if (unlikely(!user_page_ref_inc(head)))
+			return 0;
+	} else {
+		head =3D try_get_compound_head(pgd_page(orig), refs);
+		if (!head)
+			return 0;
+	}
=20
 	if (unlikely(pgd_val(orig) !=3D pgd_val(*pgdp))) {
 		__remove_refs_from_head(head, refs);
@@ -2414,7 +2545,7 @@ static int internal_get_user_pages_fast(unsigned long=
 start, int nr_pages,
 	unsigned long addr, len, end;
 	int nr =3D 0, ret =3D 0;
=20
-	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM)))
+	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM | FOLL_PIN)))
 		return -EINVAL;
=20
 	start =3D untagged_addr(start) & PAGE_MASK;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 13cc93785006..66bf4c8b88f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -945,6 +945,11 @@ struct page *follow_devmap_pmd(struct vm_area_struct *=
vma, unsigned long addr,
 	 */
 	WARN_ONCE(flags & FOLL_COW, "mm: In follow_devmap_pmd with FOLL_COW set")=
;
=20
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) =3D=3D
+			 (FOLL_PIN | FOLL_GET)))
+		return NULL;
+
 	if (flags & FOLL_WRITE && !pmd_write(*pmd))
 		return NULL;
=20
@@ -960,7 +965,7 @@ struct page *follow_devmap_pmd(struct vm_area_struct *v=
ma, unsigned long addr,
 	 * device mapped pages can only be returned if the
 	 * caller will manage the page reference count.
 	 */
-	if (!(flags & FOLL_GET))
+	if (!(flags & (FOLL_GET | FOLL_PIN)))
 		return ERR_PTR(-EEXIST);
=20
 	pfn +=3D (addr & ~PMD_MASK) >> PAGE_SHIFT;
@@ -968,7 +973,12 @@ struct page *follow_devmap_pmd(struct vm_area_struct *=
vma, unsigned long addr,
 	if (!*pgmap)
 		return ERR_PTR(-EFAULT);
 	page =3D pfn_to_page(pfn);
-	get_page(page);
+
+	if (flags & FOLL_GET)
+		get_page(page);
+	else if (flags & FOLL_PIN)
+		if (unlikely(!user_page_ref_inc(page)))
+			page =3D ERR_PTR(-ENOMEM);
=20
 	return page;
 }
@@ -1088,6 +1098,11 @@ struct page *follow_devmap_pud(struct vm_area_struct=
 *vma, unsigned long addr,
 	if (flags & FOLL_WRITE && !pud_write(*pud))
 		return NULL;
=20
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) =3D=3D
+			 (FOLL_PIN | FOLL_GET)))
+		return NULL;
+
 	if (pud_present(*pud) && pud_devmap(*pud))
 		/* pass */;
 	else
@@ -1100,7 +1115,7 @@ struct page *follow_devmap_pud(struct vm_area_struct =
*vma, unsigned long addr,
 	 * device mapped pages can only be returned if the
 	 * caller will manage the page reference count.
 	 */
-	if (!(flags & FOLL_GET))
+	if (!(flags & (FOLL_GET | FOLL_PIN)))
 		return ERR_PTR(-EEXIST);
=20
 	pfn +=3D (addr & ~PUD_MASK) >> PAGE_SHIFT;
@@ -1108,7 +1123,12 @@ struct page *follow_devmap_pud(struct vm_area_struct=
 *vma, unsigned long addr,
 	if (!*pgmap)
 		return ERR_PTR(-EFAULT);
 	page =3D pfn_to_page(pfn);
-	get_page(page);
+
+	if (flags & FOLL_GET)
+		get_page(page);
+	else if (flags & FOLL_PIN)
+		if (unlikely(!user_page_ref_inc(page)))
+			page =3D ERR_PTR(-ENOMEM);
=20
 	return page;
 }
@@ -1522,8 +1542,12 @@ struct page *follow_trans_huge_pmd(struct vm_area_st=
ruct *vma,
 skip_mlock:
 	page +=3D (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
+
 	if (flags & FOLL_GET)
 		get_page(page);
+	else if (flags & FOLL_PIN)
+		if (unlikely(!user_page_ref_inc(page)))
+			page =3D NULL;
=20
 out:
 	return page;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b45a95363a84..da335b1cd798 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4462,7 +4462,17 @@ long follow_hugetlb_page(struct mm_struct *mm, struc=
t vm_area_struct *vma,
 same_page:
 		if (pages) {
 			pages[i] =3D mem_map_offset(page, pfn_offset);
-			get_page(pages[i]);
+
+			if (flags & FOLL_GET)
+				get_page(pages[i]);
+			else if (flags & FOLL_PIN)
+				if (unlikely(!user_page_ref_inc(pages[i]))) {
+					spin_unlock(ptl);
+					remainder =3D 0;
+					err =3D -ENOMEM;
+					WARN_ON_ONCE(1);
+					break;
+				}
 		}
=20
 		if (vmas)
@@ -5022,6 +5032,12 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long =
address,
 	struct page *page =3D NULL;
 	spinlock_t *ptl;
 	pte_t pte;
+
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) =3D=3D
+			 (FOLL_PIN | FOLL_GET)))
+		return NULL;
+
 retry:
 	ptl =3D pmd_lockptr(mm, pmd);
 	spin_lock(ptl);
@@ -5034,8 +5050,14 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long =
address,
 	pte =3D huge_ptep_get((pte_t *)pmd);
 	if (pte_present(pte)) {
 		page =3D pmd_page(*pmd) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
+
 		if (flags & FOLL_GET)
 			get_page(page);
+		else if (flags & FOLL_PIN)
+			if (unlikely(!user_page_ref_inc(page))) {
+				page =3D NULL;
+				goto out;
+			}
 	} else {
 		if (is_hugetlb_entry_migration(pte)) {
 			spin_unlock(ptl);
@@ -5056,7 +5078,7 @@ struct page * __weak
 follow_huge_pud(struct mm_struct *mm, unsigned long address,
 		pud_t *pud, int flags)
 {
-	if (flags & FOLL_GET)
+	if (flags & (FOLL_GET | FOLL_PIN))
 		return NULL;
=20
 	return pte_page(*(pte_t *)pud) + ((address & ~PUD_MASK) >> PAGE_SHIFT);
@@ -5065,7 +5087,7 @@ follow_huge_pud(struct mm_struct *mm, unsigned long a=
ddress,
 struct page * __weak
 follow_huge_pgd(struct mm_struct *mm, unsigned long address, pgd_t *pgd, i=
nt flags)
 {
-	if (flags & FOLL_GET)
+	if (flags & (FOLL_GET | FOLL_PIN))
 		return NULL;
=20
 	return pte_page(*(pte_t *)pgd) + ((address & ~PGDIR_MASK) >> PAGE_SHIFT);
diff --git a/mm/memremap.c b/mm/memremap.c
index 03ccbdfeb697..3b1c69df1d2a 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -410,10 +410,8 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 EXPORT_SYMBOL_GPL(get_dev_pagemap);
=20
 #ifdef CONFIG_DEV_PAGEMAP_OPS
-void __put_devmap_managed_page(struct page *page)
+void __put_devmap_managed_page(struct page *page, int count)
 {
-	int count =3D page_ref_dec_return(page);
-
 	/*
 	 * If refcount is 1 then page is freed and refcount is stable as nobody
 	 * holds a reference on the page.
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 6afc892a148a..65c027d9b637 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1167,6 +1167,8 @@ const char * const vmstat_text[] =3D {
 	"nr_dirtied",
 	"nr_written",
 	"nr_kernel_misc_reclaimable",
+	"nr_foll_pin_requested",
+	"nr_foll_pin_returned",
=20
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
--=20
2.23.0

