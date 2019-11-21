Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570A3104B3F
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfKUHOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:14:14 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4443 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727355AbfKUHOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 02:14:10 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd639360001>; Wed, 20 Nov 2019 23:13:58 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 20 Nov 2019 23:13:57 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 20 Nov 2019 23:13:57 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 Nov
 2019 07:13:57 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 21 Nov 2019 07:13:56 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dd639340008>; Wed, 20 Nov 2019 23:13:56 -0800
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
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v7 17/24] mm/gup: track FOLL_PIN pages
Date:   Wed, 20 Nov 2019 23:13:47 -0800
Message-ID: <20191121071354.456618-18-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191121071354.456618-1-jhubbard@nvidia.com>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574320438; bh=/mF69U5Ee55lNMclEzShGWvimdKwuQUtkBEknX8WpR0=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=Sk4m7B4Kiqq/Qu/Ve+OyweWZ6ZplWOdAlLz+JFpswpkkE+ulwAZiYHr8Y//QyvLh7
         dJDhBr+IZsbdQmp/ePuQR+1JrzlpcON2HFCuuV6AjmhQEDMvbtnTACqhiy/s9g9mh7
         ywSuskVecFJPEj7YkDf0KLgWx4MF5F8vqWc94R8jBMdZ0k7LsjxU+Rp+JhZYB9itYi
         arcKQR3dv/7r3MQlhlLwCCr+OT6oUaPyV0gDYvv1RIjdGk3p4kWLROlBHlKXcE+Wux
         s+hAezzRLeYsF8d/Tz+Sn4tUx9Lmzam0WQROHmWopW9zA9Cc+ZdKuupNFH3Rv4IPRp
         HTQrFOmeiCehA==
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
patchsets. There is discussion about this in [1], [2], and [3].

This also changes a BUG_ON(), to a WARN_ON(), in follow_page_mask().

[1] Some slow progress on get_user_pages() (Apr 2, 2019):
    https://lwn.net/Articles/784574/
[2] DMA and get_user_pages() (LPC: Dec 12, 2018):
    https://lwn.net/Articles/774411/
[3] The trouble with get_user_pages() (Apr 30, 2018):
    https://lwn.net/Articles/753027/

Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 Documentation/core-api/pin_user_pages.rst |   2 +-
 include/linux/mm.h                        | 113 +++++++-
 include/linux/mmzone.h                    |   2 +
 include/linux/page_ref.h                  |  10 +
 mm/gup.c                                  | 323 ++++++++++++++++------
 mm/huge_memory.c                          |  44 ++-
 mm/hugetlb.c                              |  36 ++-
 mm/vmstat.c                               |   2 +
 8 files changed, 421 insertions(+), 111 deletions(-)

diff --git a/Documentation/core-api/pin_user_pages.rst b/Documentation/core=
-api/pin_user_pages.rst
index 4f26637a5005..baa288a44a77 100644
--- a/Documentation/core-api/pin_user_pages.rst
+++ b/Documentation/core-api/pin_user_pages.rst
@@ -53,7 +53,7 @@ Which flags are set by each wrapper
 For these pin_user_pages*() functions, FOLL_PIN is OR'd in with whatever g=
up
 flags the caller provides. The caller is required to pass in a non-null st=
ruct
 pages* array, and the function then pin pages by incrementing each by a sp=
ecial
-value. For now, that value is +1, just like get_user_pages*().::
+value: GUP_PIN_COUNTING_BIAS.::
=20
  Function
  --------
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 568cbb895f03..253ec2d15f36 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1054,6 +1054,21 @@ static inline __must_check bool try_get_page(struct =
page *page)
 	return true;
 }
=20
+__must_check bool try_pin_compound_head(struct page *page, int refs);
+
+/**
+ * try_pin_page() - mark a page as being used by pin_user_pages*().
+ *
+ * This is the FOLL_PIN counterpart to try_get_page().
+ *
+ * @page:	pointer to page to be marked
+ * @Return:	true for success, false for failure
+ */
+static inline __must_check bool try_pin_page(struct page *page)
+{
+	return try_pin_compound_head(page, 1);
+}
+
 static inline void put_page(struct page *page)
 {
 	page =3D compound_head(page);
@@ -1071,29 +1086,70 @@ static inline void put_page(struct page *page)
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
+ * reference count, and also a new count of how many pin_user_pages() call=
s were
+ * made against the page. ("gup-pinned" is another term for the latter).
  *
- * Pages that were pinned via pin_user_pages*() must be released via eithe=
r
- * put_user_page(), or one of the put_user_pages*() routines. This is so t=
hat
- * eventually such pages can be separately tracked and uniquely handled. I=
n
- * particular, interactions with RDMA and filesystems need special handlin=
g.
+ * With this scheme, pin_user_pages() becomes special: such pages are mark=
ed as
+ * distinct from normal pages. As such, the put_user_page() call (and its
+ * variants) must be used in order to release gup-pinned pages.
  *
- * put_user_page() and put_page() are not interchangeable, despite this ea=
rly
- * implementation that makes them look the same. put_user_page() calls mus=
t
- * be perfectly matched up with pin*() calls.
+ * Choice of value:
+ *
+ * By making GUP_PIN_COUNTING_BIAS a power of two, debugging of page refer=
ence
+ * counts with respect to pin_user_pages() and put_user_page() becomes sim=
pler,
+ * due to the fact that adding an even power of two to the page refcount h=
as the
+ * effect of using only the upper N bits, for the code that counts up usin=
g the
+ * bias value. This means that the lower bits are left for the exclusive u=
se of
+ * the original code that increments and decrements by one (or at least, b=
y much
+ * smaller values than the bias value).
+ *
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
+ * page_dma_pinned() - report if a page is pinned for DMA.
+ *
+ * This function checks if a page has been pinned via a call to
+ * pin_user_pages*().
+ *
+ * The return value is partially fuzzy: false is not fuzzy, because it mea=
ns
+ * "definitely not pinned for DMA", but true means "probably pinned for DM=
A, but
+ * possibly a false positive due to having at least GUP_PIN_COUNTING_BIAS =
worth
+ * of normal page references".
+ *
+ * False positives are OK, because: a) it's unlikely for a page to get tha=
t many
+ * refcounts, and b) all the callers of this routine are expected to be ab=
le to
+ * deal gracefully with a false positive.
+ *
+ * For more information, please see Documentation/vm/pin_user_pages.rst.
+ *
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
@@ -2675,6 +2731,33 @@ struct page *follow_page(struct vm_area_struct *vma,=
 unsigned long address,
  * Please see Documentation/vm/pin_user_pages.rst for more information.
  */
=20
+/**
+ * grab_page() - elevate a page's refcount by a flag-dependent amount
+ *
+ * @page:	pointer to page to be grabbed
+ * @flags:	gup flags: these are the FOLL_* flag values.
+ *
+ * Either FOLL_PIN or FOLL_GET (or neither) may be set, but not both at th=
e same
+ * time. (That's true throughout the get_user_pages*() and pin_user_pages*=
()
+ * APIs.) Cases:
+ *
+ *	FOLL_GET: page's refcount will be incremented by 1.
+ *	FOLL_PIN: page's refcount will be incremented by GUP_PIN_COUNTING_BIAS.
+ *
+ * @Return: true for for success, false for failure. If neither FOLL_GET n=
or
+ * FOLL_PIN is set, that's also considered "success", even though nothing =
is
+ * done: no page refcount changes are made in that case.
+ */
+static inline bool grab_page(struct page *page, unsigned int flags)
+{
+	if (flags & FOLL_GET)
+		get_page(page);
+	else if (flags & FOLL_PIN)
+		return try_pin_page(page);
+
+	return true;
+}
+
 static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 {
 	if (vm_fault & VM_FAULT_OOM)
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
index f72d7a1635b4..b06434185e33 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -51,6 +51,96 @@ static inline struct page *try_get_compound_head(struct =
page *page, int refs)
 	return head;
 }
=20
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
+ * try_pin_compound_head() - mark a compound page as being used by
+ * pin_user_pages*().
+ *
+ * This is the FOLL_PIN counterpart to try_get_compound_head().
+ *
+ * @page:	pointer to page to be marked
+ * @Return:	true for success, false for failure
+ */
+__must_check bool try_pin_compound_head(struct page *page, int refs)
+{
+	page =3D try_get_compound_head(page, GUP_PIN_COUNTING_BIAS * refs);
+	if (!page)
+		return false;
+
+	__update_proc_vmstat(page, NR_FOLL_PIN_REQUESTED, refs);
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
+		/*
+		 * devmap page refcounts are 1-based, rather than 0-based: if
+		 * refcount is 1, then the page is free and the refcount is
+		 * stable because nobody holds a reference on the page.
+		 */
+		if (count =3D=3D 1)
+			free_devmap_managed_page(page);
+		else if (!count)
+			__put_page(page);
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
+ * put_user_page() - release a dma-pinned page
+ * @page:            pointer to page to be released
+ *
+ * Pages that were pinned via pin_user_pages*() must be released via eithe=
r
+ * put_user_page(), or one of the put_user_pages*() routines. This is so t=
hat
+ * such pages can be separately tracked and uniquely handled. In particula=
r,
+ * interactions with RDMA and filesystems need special handling.
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
@@ -237,10 +327,11 @@ static struct page *follow_page_pte(struct vm_area_st=
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
@@ -283,6 +374,11 @@ static struct page *follow_page_pte(struct vm_area_str=
uct *vma,
 			page =3D ERR_PTR(-ENOMEM);
 			goto out;
 		}
+	} else if (flags & FOLL_PIN) {
+		if (unlikely(!try_pin_page(page))) {
+			page =3D ERR_PTR(-ENOMEM);
+			goto out;
+		}
 	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
@@ -544,8 +640,8 @@ static struct page *follow_page_mask(struct vm_area_str=
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
@@ -1125,6 +1221,36 @@ static __always_inline long __get_user_pages_locked(=
struct task_struct *tsk,
 	return pages_done;
 }
=20
+static long __get_user_pages_remote(struct task_struct *tsk,
+				    struct mm_struct *mm,
+				    unsigned long start, unsigned long nr_pages,
+				    unsigned int gup_flags, struct page **pages,
+				    struct vm_area_struct **vmas, int *locked)
+{
+	/*
+	 * Parts of FOLL_LONGTERM behavior are incompatible with
+	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
+	 * vmas. However, this only comes up if locked is set, and there are
+	 * callers that do request FOLL_LONGTERM, but do not set locked. So,
+	 * allow what we can.
+	 */
+	if (gup_flags & FOLL_LONGTERM) {
+		if (WARN_ON_ONCE(locked))
+			return -EINVAL;
+		/*
+		 * This will check the vmas (even if our vmas arg is NULL)
+		 * and return -ENOTSUPP if DAX isn't allowed in this case:
+		 */
+		return __gup_longterm_locked(tsk, mm, start, nr_pages, pages,
+					     vmas, gup_flags | FOLL_TOUCH |
+					     FOLL_REMOTE);
+	}
+
+	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
+				       locked,
+				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
+}
+
 /*
  * get_user_pages_remote() - pin user pages in memory
  * @tsk:	the task_struct to use for page fault accounting, or
@@ -1193,28 +1319,8 @@ long get_user_pages_remote(struct task_struct *tsk, =
struct mm_struct *mm,
 	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
 		return -EINVAL;
=20
-	/*
-	 * Parts of FOLL_LONGTERM behavior are incompatible with
-	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
-	 * vmas. However, this only comes up if locked is set, and there are
-	 * callers that do request FOLL_LONGTERM, but do not set locked. So,
-	 * allow what we can.
-	 */
-	if (gup_flags & FOLL_LONGTERM) {
-		if (WARN_ON_ONCE(locked))
-			return -EINVAL;
-		/*
-		 * This will check the vmas (even if our vmas arg is NULL)
-		 * and return -ENOTSUPP if DAX isn't allowed in this case:
-		 */
-		return __gup_longterm_locked(tsk, mm, start, nr_pages, pages,
-					     vmas, gup_flags | FOLL_TOUCH |
-					     FOLL_REMOTE);
-	}
-
-	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
-				       locked,
-				       gup_flags | FOLL_TOUCH | FOLL_REMOTE);
+	return __get_user_pages_remote(tsk, mm, start, nr_pages, gup_flags,
+				       pages, vmas, locked);
 }
 EXPORT_SYMBOL(get_user_pages_remote);
=20
@@ -1842,13 +1948,17 @@ static inline pte_t gup_get_pte(pte_t *ptep)
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
@@ -1881,7 +1991,7 @@ static int gup_pte_range(pmd_t pmd, unsigned long add=
r, unsigned long end,
=20
 			pgmap =3D get_dev_pagemap(pte_pfn(pte), pgmap);
 			if (unlikely(!pgmap)) {
-				undo_dev_pagemap(nr, nr_start, pages);
+				undo_dev_pagemap(nr, nr_start, flags, pages);
 				goto pte_unmap;
 			}
 		} else if (pte_special(pte))
@@ -1890,9 +2000,15 @@ static int gup_pte_range(pmd_t pmd, unsigned long ad=
dr, unsigned long end,
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page =3D pte_page(pte);
=20
-		head =3D try_get_compound_head(page, 1);
-		if (!head)
-			goto pte_unmap;
+		if (flags & FOLL_PIN) {
+			head =3D page;
+			if (unlikely(!try_pin_page(head)))
+				goto pte_unmap;
+		} else {
+			head =3D try_get_compound_head(page, 1);
+			if (!head)
+				goto pte_unmap;
+		}
=20
 		if (unlikely(pte_val(pte) !=3D pte_val(*ptep))) {
 			put_page(head);
@@ -1946,12 +2062,20 @@ static int __gup_device_huge(unsigned long pfn, uns=
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
+			if (unlikely(!try_pin_page(page))) {
+				undo_dev_pagemap(nr, nr_start, flags, pages);
+				return 0;
+			}
+		} else
+			get_page(page);
+
 		(*nr)++;
 		pfn++;
 	} while (addr +=3D PAGE_SIZE, addr !=3D end);
@@ -1973,7 +2097,7 @@ static int __gup_device_huge_pmd(pmd_t orig, pmd_t *p=
mdp, unsigned long addr,
 		return 0;
=20
 	if (unlikely(pmd_val(orig) !=3D pmd_val(*pmdp))) {
-		undo_dev_pagemap(nr, nr_start, pages);
+		undo_dev_pagemap(nr, nr_start, flags, pages);
 		return 0;
 	}
 	return 1;
@@ -1991,7 +2115,7 @@ static int __gup_device_huge_pud(pud_t orig, pud_t *p=
udp, unsigned long addr,
 		return 0;
=20
 	if (unlikely(pud_val(orig) !=3D pud_val(*pudp))) {
-		undo_dev_pagemap(nr, nr_start, pages);
+		undo_dev_pagemap(nr, nr_start, flags, pages);
 		return 0;
 	}
 	return 1;
@@ -2014,8 +2138,8 @@ static int __gup_device_huge_pud(pud_t pud, pud_t *pu=
dp, unsigned long addr,
 }
 #endif
=20
-static int __record_subpages(struct page *page, unsigned long addr,
-			     unsigned long end, struct page **pages)
+static int record_subpages(struct page *page, unsigned long addr,
+			   unsigned long end, struct page **pages)
 {
 	int nr;
=20
@@ -2025,12 +2149,31 @@ static int __record_subpages(struct page *page, uns=
igned long addr,
 	return nr;
 }
=20
-static void put_compound_head(struct page *page, int refs)
+static bool grab_compound_head(struct page *head, int refs, unsigned int f=
lags)
 {
+	if (flags & FOLL_PIN) {
+		if (unlikely(!try_pin_compound_head(head, refs)))
+			return false;
+	} else {
+		head =3D try_get_compound_head(head, refs);
+		if (!head)
+			return false;
+	}
+
+	return true;
+}
+
+static void put_compound_head(struct page *page, int refs, unsigned int fl=
ags)
+{
+	struct page *head =3D compound_head(page);
+
+	if (flags & FOLL_PIN)
+		refs *=3D GUP_PIN_COUNTING_BIAS;
+
 	/* Do a get_page() first, in case refs =3D=3D page->_refcount */
-	get_page(page);
-	page_ref_sub(page, refs);
-	put_page(page);
+	get_page(head);
+	page_ref_sub(head, refs);
+	put_page(head);
 }
=20
 #ifdef CONFIG_ARCH_HAS_HUGEPD
@@ -2064,14 +2207,13 @@ static int gup_hugepte(pte_t *ptep, unsigned long s=
z, unsigned long addr,
=20
 	head =3D pte_page(pte);
 	page =3D head + ((addr & (sz-1)) >> PAGE_SHIFT);
-	refs =3D __record_subpages(page, addr, end, pages + *nr);
+	refs =3D record_subpages(page, addr, end, pages + *nr);
=20
-	head =3D try_get_compound_head(head, refs);
-	if (!head)
+	if (!grab_compound_head(head, refs, flags))
 		return 0;
=20
 	if (unlikely(pte_val(pte) !=3D pte_val(*ptep))) {
-		put_compound_head(head, refs);
+		put_compound_head(head, refs, flags);
 		return 0;
 	}
=20
@@ -2124,14 +2266,14 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, un=
signed long addr,
 	}
=20
 	page =3D pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	refs =3D __record_subpages(page, addr, end, pages + *nr);
+	refs =3D record_subpages(page, addr, end, pages + *nr);
=20
-	head =3D try_get_compound_head(pmd_page(orig), refs);
-	if (!head)
+	head =3D pmd_page(orig);
+	if (!grab_compound_head(head, refs, flags))
 		return 0;
=20
 	if (unlikely(pmd_val(orig) !=3D pmd_val(*pmdp))) {
-		put_compound_head(head, refs);
+		put_compound_head(head, refs, flags);
 		return 0;
 	}
=20
@@ -2158,14 +2300,14 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, un=
signed long addr,
 	}
=20
 	page =3D pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-	refs =3D __record_subpages(page, addr, end, pages + *nr);
+	refs =3D record_subpages(page, addr, end, pages + *nr);
=20
-	head =3D try_get_compound_head(pud_page(orig), refs);
-	if (!head)
+	head =3D pud_page(orig);
+	if (!grab_compound_head(head, refs, flags))
 		return 0;
=20
 	if (unlikely(pud_val(orig) !=3D pud_val(*pudp))) {
-		put_compound_head(head, refs);
+		put_compound_head(head, refs, flags);
 		return 0;
 	}
=20
@@ -2187,14 +2329,14 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, un=
signed long addr,
 	BUILD_BUG_ON(pgd_devmap(orig));
=20
 	page =3D pgd_page(orig) + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
-	refs =3D __record_subpages(page, addr, end, pages + *nr);
+	refs =3D record_subpages(page, addr, end, pages + *nr);
=20
-	head =3D try_get_compound_head(pgd_page(orig), refs);
-	if (!head)
+	head =3D pgd_page(orig);
+	if (!grab_compound_head(head, refs, flags))
 		return 0;
=20
 	if (unlikely(pgd_val(orig) !=3D pgd_val(*pgdp))) {
-		put_compound_head(head, refs);
+		put_compound_head(head, refs, flags);
 		return 0;
 	}
=20
@@ -2494,9 +2636,12 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast);
 /**
  * pin_user_pages_fast() - pin user pages in memory without taking locks
  *
- * For now, this is a placeholder function, until various call sites are
- * converted to use the correct get_user_pages*() or pin_user_pages*() API=
. So,
- * this is identical to get_user_pages_fast().
+ * Nearly the same as get_user_pages_fast(), except that FOLL_PIN is set. =
See
+ * get_user_pages_fast() for documentation on the function arguments, beca=
use
+ * the arguments here are identical.
+ *
+ * FOLL_PIN means that the pages must be released via unpin_user_page(). P=
lease
+ * see Documentation/vm/pin_user_pages.rst for further details.
  *
  * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rs=
t. It
  * is NOT intended for Case 2 (RDMA: long-term pins).
@@ -2504,21 +2649,24 @@ EXPORT_SYMBOL_GPL(get_user_pages_fast);
 int pin_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages)
 {
-	/*
-	 * This is a placeholder, until the pin functionality is activated.
-	 * Until then, just behave like the corresponding get_user_pages*()
-	 * routine.
-	 */
-	return get_user_pages_fast(start, nr_pages, gup_flags, pages);
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |=3D FOLL_PIN;
+	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
 }
 EXPORT_SYMBOL_GPL(pin_user_pages_fast);
=20
 /**
  * pin_user_pages_remote() - pin pages of a remote process (task !=3D curr=
ent)
  *
- * For now, this is a placeholder function, until various call sites are
- * converted to use the correct get_user_pages*() or pin_user_pages*() API=
. So,
- * this is identical to get_user_pages_remote().
+ * Nearly the same as get_user_pages_remote(), except that FOLL_PIN is set=
. See
+ * get_user_pages_remote() for documentation on the function arguments, be=
cause
+ * the arguments here are identical.
+ *
+ * FOLL_PIN means that the pages must be released via unpin_user_page(). P=
lease
+ * see Documentation/vm/pin_user_pages.rst for details.
  *
  * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rs=
t. It
  * is NOT intended for Case 2 (RDMA: long-term pins).
@@ -2528,22 +2676,24 @@ long pin_user_pages_remote(struct task_struct *tsk,=
 struct mm_struct *mm,
 			   unsigned int gup_flags, struct page **pages,
 			   struct vm_area_struct **vmas, int *locked)
 {
-	/*
-	 * This is a placeholder, until the pin functionality is activated.
-	 * Until then, just behave like the corresponding get_user_pages*()
-	 * routine.
-	 */
-	return get_user_pages_remote(tsk, mm, start, nr_pages, gup_flags, pages,
-				     vmas, locked);
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |=3D FOLL_PIN;
+	return __get_user_pages_remote(tsk, mm, start, nr_pages, gup_flags,
+				       pages, vmas, locked);
 }
 EXPORT_SYMBOL(pin_user_pages_remote);
=20
 /**
  * pin_user_pages() - pin user pages in memory for use by other devices
  *
- * For now, this is a placeholder function, until various call sites are
- * converted to use the correct get_user_pages*() or pin_user_pages*() API=
. So,
- * this is identical to get_user_pages().
+ * Nearly the same as get_user_pages(), except that FOLL_TOUCH is not set,=
 and
+ * FOLL_PIN is set.
+ *
+ * FOLL_PIN means that the pages must be released via unpin_user_page(). P=
lease
+ * see Documentation/vm/pin_user_pages.rst for details.
  *
  * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rs=
t. It
  * is NOT intended for Case 2 (RDMA: long-term pins).
@@ -2552,11 +2702,12 @@ long pin_user_pages(unsigned long start, unsigned l=
ong nr_pages,
 		    unsigned int gup_flags, struct page **pages,
 		    struct vm_area_struct **vmas)
 {
-	/*
-	 * This is a placeholder, until the pin functionality is activated.
-	 * Until then, just behave like the corresponding get_user_pages*()
-	 * routine.
-	 */
-	return get_user_pages(start, nr_pages, gup_flags, pages, vmas);
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |=3D FOLL_PIN;
+	return __gup_longterm_locked(current, current->mm, start, nr_pages,
+				     pages, vmas, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 13cc93785006..981a9ea0b83f 100644
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
@@ -968,7 +973,14 @@ struct page *follow_devmap_pmd(struct vm_area_struct *=
vma, unsigned long addr,
 	if (!*pgmap)
 		return ERR_PTR(-EFAULT);
 	page =3D pfn_to_page(pfn);
-	get_page(page);
+
+	/*
+	 * grab_page() is not actually expected to fail here because we hold the
+	 * pmd lock, so no one can unmap the pmd and free the page that it
+	 * points to.
+	 */
+	if (!grab_page(page, flags))
+		page =3D ERR_PTR(-EFAULT);
=20
 	return page;
 }
@@ -1088,6 +1100,11 @@ struct page *follow_devmap_pud(struct vm_area_struct=
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
@@ -1099,8 +1116,10 @@ struct page *follow_devmap_pud(struct vm_area_struct=
 *vma, unsigned long addr,
 	/*
 	 * device mapped pages can only be returned if the
 	 * caller will manage the page reference count.
+	 *
+	 * At least one of FOLL_GET | FOLL_PIN must be set, so assert that here:
 	 */
-	if (!(flags & FOLL_GET))
+	if (!(flags & (FOLL_GET | FOLL_PIN)))
 		return ERR_PTR(-EEXIST);
=20
 	pfn +=3D (addr & ~PUD_MASK) >> PAGE_SHIFT;
@@ -1108,7 +1127,14 @@ struct page *follow_devmap_pud(struct vm_area_struct=
 *vma, unsigned long addr,
 	if (!*pgmap)
 		return ERR_PTR(-EFAULT);
 	page =3D pfn_to_page(pfn);
-	get_page(page);
+
+	/*
+	 * grab_page() is not actually expected to fail here because we hold the
+	 * pmd lock, so no one can unmap the pmd and free the page that it
+	 * points to.
+	 */
+	if (!grab_page(page, flags))
+		page =3D ERR_PTR(-EFAULT);
=20
 	return page;
 }
@@ -1522,8 +1548,14 @@ struct page *follow_trans_huge_pmd(struct vm_area_st=
ruct *vma,
 skip_mlock:
 	page +=3D (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
-	if (flags & FOLL_GET)
-		get_page(page);
+
+	/*
+	 * grab_page() is not actually expected to fail here because we hold the
+	 * pmd lock, so no one can unmap the pmd and free the page that it
+	 * points to.
+	 */
+	if (!grab_page(page, flags))
+		page =3D ERR_PTR(-EFAULT);
=20
 out:
 	return page;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b45a95363a84..eac3310d62f5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4462,7 +4462,19 @@ long follow_hugetlb_page(struct mm_struct *mm, struc=
t vm_area_struct *vma,
 same_page:
 		if (pages) {
 			pages[i] =3D mem_map_offset(page, pfn_offset);
-			get_page(pages[i]);
+
+			/*
+			 * grab_page() is not actually expected to fail here
+			 * because we hold the pmd lock, so no one can unmap the
+			 * pmd and free the page that it points to.
+			 */
+			if (!grab_page(pages[i], flags)) {
+				spin_unlock(ptl);
+				remainder =3D 0;
+				err =3D -ENOMEM;
+				WARN_ON_ONCE(1);
+				break;
+			}
 		}
=20
 		if (vmas)
@@ -5022,6 +5034,12 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long =
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
@@ -5034,8 +5052,20 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long =
address,
 	pte =3D huge_ptep_get((pte_t *)pmd);
 	if (pte_present(pte)) {
 		page =3D pmd_page(*pmd) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
+
 		if (flags & FOLL_GET)
 			get_page(page);
+		else if (flags & FOLL_PIN) {
+			/*
+			 * try_pin_page() is not actually expected to fail
+			 * here because we hold the ptl.
+			 */
+			if (unlikely(!try_pin_page(page))) {
+				WARN_ON_ONCE(1);
+				page =3D NULL;
+				goto out;
+			}
+		}
 	} else {
 		if (is_hugetlb_entry_migration(pte)) {
 			spin_unlock(ptl);
@@ -5056,7 +5086,7 @@ struct page * __weak
 follow_huge_pud(struct mm_struct *mm, unsigned long address,
 		pud_t *pud, int flags)
 {
-	if (flags & FOLL_GET)
+	if (flags & (FOLL_GET | FOLL_PIN))
 		return NULL;
=20
 	return pte_page(*(pte_t *)pud) + ((address & ~PUD_MASK) >> PAGE_SHIFT);
@@ -5065,7 +5095,7 @@ follow_huge_pud(struct mm_struct *mm, unsigned long a=
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
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a8222041bd44..fdad40ccde7b 100644
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
2.24.0

