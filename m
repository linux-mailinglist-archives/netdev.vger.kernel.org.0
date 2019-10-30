Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFEFEA696
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfJ3Wtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:49:47 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5252 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbfJ3Wtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:49:45 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dba138b0002>; Wed, 30 Oct 2019 15:49:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 30 Oct 2019 15:49:41 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 30 Oct 2019 15:49:41 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Oct
 2019 22:49:40 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 30 Oct 2019 22:49:39 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dba13820000>; Wed, 30 Oct 2019 15:49:39 -0700
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
Subject: [PATCH 05/19] mm/gup: introduce pin_user_pages*() and FOLL_PIN
Date:   Wed, 30 Oct 2019 15:49:16 -0700
Message-ID: <20191030224930.3990755-6-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030224930.3990755-1-jhubbard@nvidia.com>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572475788; bh=q+XLxTTs3VV9NQYlAIix1/xq2y74kPKr4+k38NlDVWo=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=nDqCtGuNSvvDejx1vtY8xGgFUondHPHr+I+PvmvPI6LppRpXTXHrtb7uWRivWS9t6
         4gF30LMcvxWujS+tccoegXL9+UAT8EcFEFJUzGwdMv7TO7uBB0pLyNV7K9kp4jNRTU
         KDw+KtQ6QpNILKiYWF7MADvsWEEcuISGTEcz1HM9CeQiMQSGUiott2qrunFLPKNFrY
         Ez3OuvWjeNqJUnEYJmm2FgcNA4VgmPRn9Om7+tLBDnD0yeaO+tuo/gfBWGhIMT+G9z
         nnSdDH5Y49JsX2G0spTf1fTfOpf2z/AbZxhgx3kJL9MUrCsqp58qgzhjBjY4/EhBAc
         W7g6XMs0i1myQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce pin_user_pages*() variations of get_user_pages*() calls,
and also pin_longterm_pages*() variations.

These variants all set FOLL_PIN, which is also introduced, and
basically documented. (An upcoming patch provides more extensive
documentation.) The second set (pin_longterm*) also sets
FOLL_LONGTERM:

    pin_user_pages()
    pin_user_pages_remote()
    pin_user_pages_fast()

    pin_longterm_pages()
    pin_longterm_pages_remote()
    pin_longterm_pages_fast()

All pages that are pinned via the above calls, must be unpinned via
put_user_page().

The underlying rules are:

* These are gup-internal flags, so the call sites should not directly
set FOLL_PIN nor FOLL_LONGTERM. That behavior is enforced with
assertions, for the new FOLL_PIN flag. However, for the pre-existing
FOLL_LONGTERM flag, which has some call sites that still directly
set FOLL_LONGTERM, there is no assertion yet.

* Call sites that want to indicate that they are going to do DirectIO
  ("DIO") or something with similar characteristics, should call a
  get_user_pages()-like wrapper call that sets FOLL_PIN. These wrappers
  will:
        * Start with "pin_user_pages" instead of "get_user_pages". That
          makes it easy to find and audit the call sites.
        * Set FOLL_PIN

* For pages that are received via FOLL_PIN, those pages must be returned
  via put_user_page().

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 include/linux/mm.h |  53 ++++++++-
 mm/gup.c           | 284 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 311 insertions(+), 26 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cc292273e6ba..62c838a3e6c7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1526,9 +1526,23 @@ long get_user_pages_remote(struct task_struct *tsk, =
struct mm_struct *mm,
 			    unsigned long start, unsigned long nr_pages,
 			    unsigned int gup_flags, struct page **pages,
 			    struct vm_area_struct **vmas, int *locked);
+long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
+			   unsigned long start, unsigned long nr_pages,
+			   unsigned int gup_flags, struct page **pages,
+			   struct vm_area_struct **vmas, int *locked);
+long pin_longterm_pages_remote(struct task_struct *tsk, struct mm_struct *=
mm,
+			       unsigned long start, unsigned long nr_pages,
+			       unsigned int gup_flags, struct page **pages,
+			       struct vm_area_struct **vmas, int *locked);
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 			    unsigned int gup_flags, struct page **pages,
 			    struct vm_area_struct **vmas);
+long pin_user_pages(unsigned long start, unsigned long nr_pages,
+		    unsigned int gup_flags, struct page **pages,
+		    struct vm_area_struct **vmas);
+long pin_longterm_pages(unsigned long start, unsigned long nr_pages,
+			unsigned int gup_flags, struct page **pages,
+			struct vm_area_struct **vmas);
 long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
@@ -1536,6 +1550,10 @@ long get_user_pages_unlocked(unsigned long start, un=
signed long nr_pages,
=20
 int get_user_pages_fast(unsigned long start, int nr_pages,
 			unsigned int gup_flags, struct page **pages);
+int pin_user_pages_fast(unsigned long start, int nr_pages,
+			unsigned int gup_flags, struct page **pages);
+int pin_longterm_pages_fast(unsigned long start, int nr_pages,
+			    unsigned int gup_flags, struct page **pages);
=20
 int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc)=
;
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool in=
c,
@@ -2594,13 +2612,15 @@ struct page *follow_page(struct vm_area_struct *vma=
, unsigned long address,
 #define FOLL_ANON	0x8000	/* don't do file mappings */
 #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below=
 */
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
+#define FOLL_PIN	0x40000	/* pages must be released via put_user_page() */
=20
 /*
- * NOTE on FOLL_LONGTERM:
+ * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with eac=
h
+ * other. Here is what they mean, and how to use them:
  *
  * FOLL_LONGTERM indicates that the page will be held for an indefinite ti=
me
- * period _often_ under userspace control.  This is contrasted with
- * iov_iter_get_pages() where usages which are transient.
+ * period _often_ under userspace control.  This is in contrast to
+ * iov_iter_get_pages(), where usages which are transient.
  *
  * FIXME: For pages which are part of a filesystem, mappings are subject t=
o the
  * lifetime enforced by the filesystem and we need guarantees that longter=
m
@@ -2615,11 +2635,32 @@ struct page *follow_page(struct vm_area_struct *vma=
, unsigned long address,
  * Currently only get_user_pages() and get_user_pages_fast() support this =
flag
  * and calls to get_user_pages_[un]locked are specifically not allowed.  T=
his
  * is due to an incompatibility with the FS DAX check and
- * FAULT_FLAG_ALLOW_RETRY
+ * FAULT_FLAG_ALLOW_RETRY.
  *
- * In the CMA case: longterm pins in a CMA region would unnecessarily frag=
ment
- * that region.  And so CMA attempts to migrate the page before pinning wh=
en
+ * In the CMA case: long term pins in a CMA region would unnecessarily fra=
gment
+ * that region.  And so, CMA attempts to migrate the page before pinning, =
when
  * FOLL_LONGTERM is specified.
+ *
+ * FOLL_PIN indicates that a special kind of tracking (not just page->_ref=
count,
+ * but an additional pin counting system) will be invoked. This is intende=
d for
+ * anything that gets a page reference and then touches page data (for exa=
mple,
+ * Direct IO). This lets the filesystem know that some non-file-system ent=
ity is
+ * potentially changing the pages' data. In contrast to FOLL_GET (whose pa=
ges
+ * are released via put_page()), FOLL_PIN pages must be released, ultimate=
ly, by
+ * a call to put_user_page().
+ *
+ * FOLL_PIN is similar to FOLL_GET: both of these pin pages. They use diff=
erent
+ * and separate refcounting mechanisms, however, and that means that each =
has
+ * its own acquire and release mechanisms:
+ *
+ *     FOLL_GET: get_user_pages*() to acquire, and put_page() to release.
+ *
+ *     FOLL_PIN: pin_user_pages*() or pin_longterm_pages*() to acquire, an=
d
+ *               put_user_pages to release.
+ *
+ * FOLL_PIN and FOLL_GET are mutually exclusive.
+ *
+ * Please see Documentation/vm/pin_user_pages.rst for more information.
  */
=20
 static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
diff --git a/mm/gup.c b/mm/gup.c
index 8fb0d9cdfaf5..8694bc7b3df3 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -179,6 +179,10 @@ static struct page *follow_page_pte(struct vm_area_str=
uct *vma,
 	spinlock_t *ptl;
 	pte_t *ptep, pte;
=20
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) =3D=3D
+			 (FOLL_PIN | FOLL_GET)))
+		return ERR_PTR(-EINVAL);
 retry:
 	if (unlikely(pmd_bad(*pmd)))
 		return no_page_table(vma, flags);
@@ -790,7 +794,7 @@ static long __get_user_pages(struct task_struct *tsk, s=
truct mm_struct *mm,
=20
 	start =3D untagged_addr(start);
=20
-	VM_BUG_ON(!!pages !=3D !!(gup_flags & FOLL_GET));
+	VM_BUG_ON(!!pages !=3D !!(gup_flags & (FOLL_GET | FOLL_PIN)));
=20
 	/*
 	 * If FOLL_FORCE is set then do not force a full fault as the hinting
@@ -1014,7 +1018,16 @@ static __always_inline long __get_user_pages_locked(=
struct task_struct *tsk,
 		BUG_ON(*locked !=3D 1);
 	}
=20
-	if (pages)
+	/*
+	 * FOLL_PIN and FOLL_GET are mutually exclusive. Traditional behavior
+	 * is to set FOLL_GET if the caller wants pages[] filled in (but has
+	 * carelessly failed to specify FOLL_GET), so keep doing that, but only
+	 * for FOLL_GET, not for the newer FOLL_PIN.
+	 *
+	 * FOLL_PIN always expects pages to be non-null, but no need to assert
+	 * that here, as any failures will be obvious enough.
+	 */
+	if (pages && !(flags & FOLL_PIN))
 		flags |=3D FOLL_GET;
=20
 	pages_done =3D 0;
@@ -1133,6 +1146,12 @@ static __always_inline long __get_user_pages_locked(=
struct task_struct *tsk,
  * is written to, set_page_dirty (or set_page_dirty_lock, as appropriate) =
must
  * be called after the page is finished with, and before put_page is calle=
d.
  *
+ * A note on gup_flags: FOLL_PIN must only be set internally by the
+ * pin_user_page*() and pin_longterm_*() APIs, never directly by the calle=
r.
+ * That's in order to help avoid mismatches when releasing pages:
+ * get_user_pages*() pages must be released via put_page(), while
+ * pin_user_pages*() pages must be released via put_user_page().
+ *
  * get_user_pages is typically used for fewer-copy IO operations, to get a
  * handle on the memory by some means other than accesses via the user vir=
tual
  * addresses. The pages may be submitted for DMA to devices or accessed vi=
a
@@ -1151,6 +1170,14 @@ long get_user_pages_remote(struct task_struct *tsk, =
struct mm_struct *mm,
 		unsigned int gup_flags, struct page **pages,
 		struct vm_area_struct **vmas, int *locked)
 {
+	/*
+	 * As detailed above, FOLL_PIN must only be set internally by the
+	 * pin_user_page*() and pin_longterm_*() APIs, never directly by the
+	 * caller, so enforce that with an assertion:
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+		return -EINVAL;
+
 	/*
 	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
 	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
@@ -1603,11 +1630,25 @@ static __always_inline long __gup_longterm_locked(s=
truct task_struct *tsk,
  * and mm being operated on are the current task's and don't allow
  * passing of a locked parameter.  We also obviously don't pass
  * FOLL_REMOTE in here.
+ *
+ * A note on gup_flags: FOLL_PIN should only be set internally by the
+ * pin_user_page*() and pin_longterm_*() APIs, never directly by the calle=
r.
+ * That's in order to help avoid mismatches when releasing pages:
+ * get_user_pages*() pages must be released via put_page(), while
+ * pin_user_pages*() pages must be released via put_user_page().
  */
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 		unsigned int gup_flags, struct page **pages,
 		struct vm_area_struct **vmas)
 {
+	/*
+	 * As detailed above, FOLL_PIN must only be set internally by the
+	 * pin_user_page*() and pin_longterm_*() APIs, never directly by the
+	 * caller, so enforce that with an assertion:
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+		return -EINVAL;
+
 	return __gup_longterm_locked(current, current->mm, start, nr_pages,
 				     pages, vmas, gup_flags | FOLL_TOUCH);
 }
@@ -2366,24 +2407,9 @@ static int __gup_longterm_unlocked(unsigned long sta=
rt, int nr_pages,
 	return ret;
 }
=20
-/**
- * get_user_pages_fast() - pin user pages in memory
- * @start:	starting user address
- * @nr_pages:	number of pages from start to pin
- * @gup_flags:	flags modifying pin behaviour
- * @pages:	array that receives pointers to the pages pinned.
- *		Should be at least nr_pages long.
- *
- * Attempt to pin user pages in memory without taking mm->mmap_sem.
- * If not successful, it will fall back to taking the lock and
- * calling get_user_pages().
- *
- * Returns number of pages pinned. This may be fewer than the number
- * requested. If nr_pages is 0 or negative, returns 0. If no pages
- * were pinned, returns -errno.
- */
-int get_user_pages_fast(unsigned long start, int nr_pages,
-			unsigned int gup_flags, struct page **pages)
+static int internal_get_user_pages_fast(unsigned long start, int nr_pages,
+					unsigned int gup_flags,
+					struct page **pages)
 {
 	unsigned long addr, len, end;
 	int nr =3D 0, ret =3D 0;
@@ -2428,4 +2454,222 @@ int get_user_pages_fast(unsigned long start, int nr=
_pages,
=20
 	return ret;
 }
+
+/**
+ * get_user_pages_fast() - pin user pages in memory
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @gup_flags:	flags modifying pin behaviour
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_pages long.
+ *
+ * Attempt to pin user pages in memory without taking mm->mmap_sem.
+ * If not successful, it will fall back to taking the lock and
+ * calling get_user_pages().
+ *
+ * A note on gup_flags: FOLL_PIN must only be set internally by the
+ * pin_user_page*() and pin_longterm_*() APIs, never directly by the calle=
r.
+ * That's in order to help avoid mismatches when releasing pages:
+ * get_user_pages*() pages must be released via put_page(), while
+ * pin_user_pages*() pages must be released via put_user_page().
+ *
+ * Returns number of pages pinned. This may be fewer than the number reque=
sted.
+ * If nr_pages is 0 or negative, returns 0. If no pages were pinned, retur=
ns
+ * -errno.
+ */
+int get_user_pages_fast(unsigned long start, int nr_pages,
+			unsigned int gup_flags, struct page **pages)
+{
+	/*
+	 * As detailed above, FOLL_PIN must only be set internally by the
+	 * pin_user_page*() and pin_longterm_*() APIs, never directly by the
+	 * caller, so enforce that:
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+		return -EINVAL;
+
+	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
+}
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
+
+/**
+ * pin_user_pages_fast() - pin user pages in memory without taking locks
+ *
+ * Nearly the same as get_user_pages_fast(), except that FOLL_PIN is set. =
See
+ * get_user_pages_fast() for documentation on the function arguments, beca=
use
+ * the arguments here are identical.
+ *
+ * FOLL_PIN means that the pages must be released via put_user_page(). Ple=
ase
+ * see Documentation/vm/pin_user_pages.rst for further details.
+ *
+ * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rs=
t. It
+ * is NOT intended for Case 2 (RDMA: long-term pins).
+ */
+int pin_user_pages_fast(unsigned long start, int nr_pages,
+			unsigned int gup_flags, struct page **pages)
+{
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |=3D FOLL_PIN;
+	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
+}
+EXPORT_SYMBOL_GPL(pin_user_pages_fast);
+
+/**
+ * pin_longterm_pages_fast() - pin user pages in memory without taking loc=
ks
+ *
+ * Nearly the same as get_user_pages_fast(), except that FOLL_PIN and
+ * FOLL_LONGTERM are set. See get_user_pages_fast() for documentation on t=
he
+ * function arguments, because the arguments here are identical.
+ *
+ * FOLL_PIN means that the pages must be released via put_user_page(). Ple=
ase
+ * see Documentation/vm/pin_user_pages.rst for further details.
+ *
+ * FOLL_LONGTERM means that the pages are being pinned for "long term" use=
,
+ * typically by a non-CPU device, and we cannot be sure that waiting for a
+ * pinned page to become unpin will be effective.
+ *
+ * This is intended for Case 2 (RDMA: long-term pins) of the FOLL_PIN
+ * documentation.
+ */
+int pin_longterm_pages_fast(unsigned long start, int nr_pages,
+			    unsigned int gup_flags, struct page **pages)
+{
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |=3D (FOLL_PIN | FOLL_LONGTERM);
+	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
+}
+EXPORT_SYMBOL_GPL(pin_longterm_pages_fast);
+
+/**
+ * pin_user_pages_remote() - pin pages for (typically) use by Direct IO, a=
nd
+ * return the pages to the user.
+ *
+ * Nearly the same as get_user_pages_remote(), except that FOLL_PIN is set=
. See
+ * get_user_pages_remote() for documentation on the function arguments, be=
cause
+ * the arguments here are identical.
+ *
+ * FOLL_PIN means that the pages must be released via put_user_page(). Ple=
ase
+ * see Documentation/vm/pin_user_pages.rst for details.
+ *
+ * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rs=
t. It
+ * is NOT intended for Case 2 (RDMA: long-term pins).
+ */
+long pin_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
+			   unsigned long start, unsigned long nr_pages,
+			   unsigned int gup_flags, struct page **pages,
+			   struct vm_area_struct **vmas, int *locked)
+{
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |=3D FOLL_TOUCH | FOLL_REMOTE | FOLL_PIN;
+
+	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
+				       locked, gup_flags);
+}
+EXPORT_SYMBOL(pin_user_pages_remote);
+
+/**
+ * pin_longterm_pages_remote() - pin pages for (typically) use by Direct I=
O, and
+ * return the pages to the user.
+ *
+ * Nearly the same as get_user_pages_remote(), but note that FOLL_TOUCH is=
 not
+ * set, and FOLL_PIN and FOLL_LONGTERM are set. See get_user_pages_remote(=
) for
+ * documentation on the function arguments, because the arguments here are
+ * identical.
+ *
+ * FOLL_PIN means that the pages must be released via put_user_page(). Ple=
ase
+ * see Documentation/vm/pin_user_pages.rst for further details.
+ *
+ * FOLL_LONGTERM means that the pages are being pinned for "long term" use=
,
+ * typically by a non-CPU device, and we cannot be sure that waiting for a
+ * pinned page to become unpin will be effective.
+ *
+ * This is intended for Case 2 (RDMA: long-term pins) in
+ * Documentation/vm/pin_user_pages.rst.
+ */
+long pin_longterm_pages_remote(struct task_struct *tsk, struct mm_struct *=
mm,
+			       unsigned long start, unsigned long nr_pages,
+			       unsigned int gup_flags, struct page **pages,
+			       struct vm_area_struct **vmas, int *locked)
+{
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	/*
+	 * FIXME: as noted in the get_user_pages_remote() implementation, it
+	 * is not yet possible to safely set FOLL_LONGTERM here. FOLL_LONGTERM
+	 * needs to be set, but for now the best we can do is a "TODO" item.
+	 */
+	gup_flags |=3D FOLL_REMOTE | FOLL_PIN;
+
+	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
+				       locked, gup_flags);
+}
+EXPORT_SYMBOL(pin_longterm_pages_remote);
+
+/**
+ * pin_user_pages() - pin user pages in memory for use by other devices
+ *
+ * Nearly the same as get_user_pages(), except that FOLL_TOUCH is not set,=
 and
+ * FOLL_PIN is set.
+ *
+ * FOLL_PIN means that the pages must be released via put_user_page(). Ple=
ase
+ * see Documentation/vm/pin_user_pages.rst for details.
+ *
+ * This is intended for Case 1 (DIO) in Documentation/vm/pin_user_pages.rs=
t. It
+ * is NOT intended for Case 2 (RDMA: long-term pins).
+ */
+long pin_user_pages(unsigned long start, unsigned long nr_pages,
+		    unsigned int gup_flags, struct page **pages,
+		    struct vm_area_struct **vmas)
+{
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |=3D FOLL_PIN;
+	return __gup_longterm_locked(current, current->mm, start, nr_pages,
+				     pages, vmas, gup_flags);
+}
+EXPORT_SYMBOL(pin_user_pages);
+
+/**
+ * pin_longterm_pages() - pin user pages in memory for long-term use (RDMA=
,
+ * typically)
+ *
+ * Nearly the same as get_user_pages(), except that FOLL_PIN and FOLL_LONG=
TERM
+ * are set. See get_user_pages_fast() for documentation on the function
+ * arguments, because the arguments here are identical.
+ *
+ * FOLL_PIN means that the pages must be released via put_user_page(). Ple=
ase
+ * see Documentation/vm/pin_user_pages.rst for further details.
+ *
+ * FOLL_LONGTERM means that the pages are being pinned for "long term" use=
,
+ * typically by a non-CPU device, and we cannot be sure that waiting for a
+ * pinned page to become unpin will be effective.
+ *
+ * This is intended for Case 2 (RDMA: long-term pins) in
+ * Documentation/vm/pin_user_pages.rst.
+ */
+long pin_longterm_pages(unsigned long start, unsigned long nr_pages,
+			unsigned int gup_flags, struct page **pages,
+			struct vm_area_struct **vmas)
+{
+	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
+	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
+		return -EINVAL;
+
+	gup_flags |=3D FOLL_PIN | FOLL_LONGTERM;
+	return __gup_longterm_locked(current, current->mm, start, nr_pages,
+				     pages, vmas, gup_flags);
+}
+EXPORT_SYMBOL(pin_longterm_pages);
--=20
2.23.0

