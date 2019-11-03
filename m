Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5745ED57E
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 22:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbfKCVUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 16:20:08 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6784 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbfKCVSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 16:18:23 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dbf441f0000>; Sun, 03 Nov 2019 13:18:23 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Sun, 03 Nov 2019 13:18:16 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Sun, 03 Nov 2019 13:18:16 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 3 Nov
 2019 21:18:16 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 3 Nov
 2019 21:18:15 +0000
Received: from hqnvemgw01.nvidia.com (172.20.150.20) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sun, 3 Nov 2019 21:18:15 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dbf44170002>; Sun, 03 Nov 2019 13:18:15 -0800
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
Subject: [PATCH v2 05/18] mm/gup: introduce pin_user_pages*() and FOLL_PIN
Date:   Sun, 3 Nov 2019 13:18:00 -0800
Message-ID: <20191103211813.213227-6-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191103211813.213227-1-jhubbard@nvidia.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572815903; bh=mxE/T+Yec2EUEeO+8Vzbv74KHAf8O5AA/xiZvk3cIvQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=YLhOfB1w6D9pLZ3YSmxxyutdNiCCyQ+D4PxZM8vV2nWBD4CKAnZ9h+6JHhUuYgxGN
         9f4RfIm0GdA9iaALj9PJIiRPZNhLNQ4WTtG2QhkqX6r4UcPVrUpOb3UzFTkQpeUOUG
         lLjkf6OKgX5DXDPY1hJzhzUQxA0VAj1QgVq6NPnuaU/xxDjh2oCKu3orBNMtvcMphD
         s32uSExrwwwdtGuX0qMCANxW15+3hD9EQPrWq8R41GUfcUweaCSrX19D7T3KdsmrVe
         y0/zXvJzlUuoIHZyC9gyLdqfccmYchKbk1HkserQCFZ07StZ4tugX5NQTYyGVt8qV7
         mrbdcrZ81hy0A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce pin_user_pages*() variations of get_user_pages*() calls,
and also pin_longterm_pages*() variations.

These variants all set FOLL_PIN, which is also introduced, and
thoroughly documented.

The pin_longterm*() variants also set FOLL_LONGTERM, in addition
to FOLL_PIN:

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

Thanks to Jan Kara and Vlastimil Babka for explaining the 4 cases
in this documentation. (I've reworded it and expanded on it slightly.)

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 Documentation/vm/index.rst          |   1 +
 Documentation/vm/pin_user_pages.rst | 212 ++++++++++++++++++++++
 include/linux/mm.h                  |  62 ++++++-
 mm/gup.c                            | 265 +++++++++++++++++++++++++---
 4 files changed, 514 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/vm/pin_user_pages.rst

diff --git a/Documentation/vm/index.rst b/Documentation/vm/index.rst
index e8d943b21cf9..7194efa3554a 100644
--- a/Documentation/vm/index.rst
+++ b/Documentation/vm/index.rst
@@ -44,6 +44,7 @@ descriptions of data structures and algorithms.
    page_migration
    page_frags
    page_owner
+   pin_user_pages
    remap_file_pages
    slub
    split_page_table_lock
diff --git a/Documentation/vm/pin_user_pages.rst b/Documentation/vm/pin_use=
r_pages.rst
new file mode 100644
index 000000000000..3910f49ca98c
--- /dev/null
+++ b/Documentation/vm/pin_user_pages.rst
@@ -0,0 +1,212 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+pin_user_pages() and related calls
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+.. contents:: :local:
+
+Overview
+=3D=3D=3D=3D=3D=3D=3D=3D
+
+This document describes the following functions: ::
+
+ pin_user_pages
+ pin_user_pages_fast
+ pin_user_pages_remote
+
+ pin_longterm_pages
+ pin_longterm_pages_fast
+ pin_longterm_pages_remote
+
+Basic description of FOLL_PIN
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+
+A new flag for get_user_pages ("gup") has been added: FOLL_PIN. FOLL_PIN h=
as
+significant interactions and interdependencies with FOLL_LONGTERM, so both=
 are
+covered here.
+
+Both FOLL_PIN and FOLL_LONGTERM are "internal" to gup, meaning that neithe=
r
+FOLL_PIN nor FOLL_LONGTERM should not appear at the gup call sites. This a=
llows
+the associated wrapper functions  (pin_user_pages and others) to set the c=
orrect
+combination of these flags, and to check for problems as well.
+
+FOLL_PIN and FOLL_GET are mutually exclusive for a given gup call. However=
,
+multiple threads and call sites are free to pin the same struct pages, via=
 both
+FOLL_PIN and FOLL_GET. It's just the call site that needs to choose one or=
 the
+other, not the struct page(s).
+
+The FOLL_PIN implementation is nearly the same as FOLL_GET, except that FO=
LL_PIN
+uses a different reference counting technique.
+
+FOLL_PIN is a prerequisite to FOLL_LONGTGERM. Another way of saying that i=
s,
+FOLL_LONGTERM is a specific case, more restrictive case of FOLL_PIN.
+
+Which flags are set by each wrapper
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Only FOLL_PIN and FOLL_LONGTERM are covered here. These flags are added to
+whatever flags the caller provides::
+
+ Function                    gup flags (FOLL_PIN or FOLL_LONGTERM only)
+ --------                    ------------------------------------------
+ pin_user_pages              FOLL_PIN
+ pin_user_pages_fast         FOLL_PIN
+ pin_user_pages_remote       FOLL_PIN
+
+ pin_longterm_pages          FOLL_PIN | FOLL_LONGTERM
+ pin_longterm_pages_fast     FOLL_PIN | FOLL_LONGTERM
+ pin_longterm_pages_remote   FOLL_PIN | FOLL_LONGTERM
+
+Tracking dma-pinned pages
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
+
+Some of the key design constraints, and solutions, for tracking dma-pinned
+pages:
+
+* An actual reference count, per struct page, is required. This is because
+  multiple processes may pin and unpin a page.
+
+* False positives (reporting that a page is dma-pinned, when in fact it is=
 not)
+  are acceptable, but false negatives are not.
+
+* struct page may not be increased in size for this, and all fields are al=
ready
+  used.
+
+* Given the above, we can overload the page->_refcount field by using, sor=
t of,
+  the upper bits in that field for a dma-pinned count. "Sort of", means th=
at,
+  rather than dividing page->_refcount into bit fields, we simple add a me=
dium-
+  large value (GUP_PIN_COUNTING_BIAS, initially chosen to be 1024: 10 bits=
) to
+  page->_refcount. This provides fuzzy behavior: if a page has get_page() =
called
+  on it 1024 times, then it will appear to have a single dma-pinned count.
+  And again, that's acceptable.
+
+This also leads to limitations: there are only 31-10=3D=3D21 bits availabl=
e for a
+counter that increments 10 bits at a time.
+
+TODO: for 1GB and larger huge pages, this is cutting it close. That's beca=
use
+when pin_user_pages() follows such pages, it increments the head page by "=
1"
+(where "1" used to mean "+1" for get_user_pages(), but now means "+1024" f=
or
+pin_user_pages()) for each tail page. So if you have a 1GB huge page:
+
+* There are 256K (18 bits) worth of 4 KB tail pages.
+* There are 21 bits available to count up via GUP_PIN_COUNTING_BIAS (that =
is,
+  10 bits at a time)
+* There are 21 - 18 =3D=3D 3 bits available to count. Except that there ar=
en't,
+  because you need to allow for a few normal get_page() calls on the head =
page,
+  as well. Fortunately, the approach of using addition, rather than "hard"
+  bitfields, within page->_refcount, allows for sharing these bits gracefu=
lly.
+  But we're still looking at about 8 references.
+
+This, however, is a missing feature more than anything else, because it's =
easily
+solved by addressing an obvious inefficiency in the original get_user_page=
s()
+approach of retrieving pages: stop treating all the pages as if they were
+PAGE_SIZE. Retrieve huge pages as huge pages. The callers need to be aware=
 of
+this, so some work is required. Once that's in place, this limitation most=
ly
+disappears from view, because there will be ample refcounting range availa=
ble.
+
+* Callers must specifically request "dma-pinned tracking of pages". In oth=
er
+  words, just calling get_user_pages() will not suffice; a new set of func=
tions,
+  pin_user_page() and related, must be used.
+
+FOLL_PIN, FOLL_GET, FOLL_LONGTERM: when to use which flags
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Thanks to Jan Kara, Vlastimil Babka and several other -mm people, for desc=
ribing
+these categories:
+
+CASE 1: Direct IO (DIO)
+-----------------------
+There are GUP references to pages that are serving
+as DIO buffers. These buffers are needed for a relatively short time (so t=
hey
+are not "long term"). No special synchronization with page_mkclean() or
+munmap() is provided. Therefore, flags to set at the call site are: ::
+
+    FOLL_PIN
+
+...but rather than setting FOLL_PIN directly, call sites should use one of
+the pin_user_pages*() routines that set FOLL_PIN.
+
+CASE 2: RDMA
+------------
+There are GUP references to pages that are serving as DMA
+buffers. These buffers are needed for a long time ("long term"). No specia=
l
+synchronization with page_mkclean() or munmap() is provided. Therefore, fl=
ags
+to set at the call site are: ::
+
+    FOLL_PIN | FOLL_LONGTERM
+
+NOTE: Some pages, such as DAX pages, cannot be pinned with longterm pins. =
That's
+because DAX pages do not have a separate page cache, and so "pinning" impl=
ies
+locking down file system blocks, which is not (yet) supported in that way.
+
+CASE 3: ODP
+-----------
+(Mellanox/Infiniband On Demand Paging: the hardware supports
+replayable page faulting). There are GUP references to pages serving as DM=
A
+buffers. For ODP, MMU notifiers are used to synchronize with page_mkclean(=
)
+and munmap(). Therefore, normal GUP calls are sufficient, so neither flag
+needs to be set.
+
+CASE 4: Pinning for struct page manipulation only
+-------------------------------------------------
+Here, normal GUP calls are sufficient, so neither flag needs to be set.
+
+page_dma_pinned(): the whole point of pinning
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+The whole point of marking pages as "DMA-pinned" or "gup-pinned" is to be =
able
+to query, "is this page DMA-pinned?" That allows code such as page_mkclean=
()
+(and file system writeback code in general) to make informed decisions abo=
ut
+what to do when a page cannot be unmapped due to such pins.
+
+What to do in those cases is the subject of a years-long series of discuss=
ions
+and debates (see the References at the end of this document). It's a TODO =
item
+here: fill in the details once that's worked out. Meanwhile, it's safe to =
say
+that having this available: ::
+
+        static inline bool page_dma_pinned(struct page *page)
+
+...is a prerequisite to solving the long-running gup+DMA problem.
+
+Another way of thinking about FOLL_GET, FOLL_PIN, and FOLL_LONGTERM
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Another way of thinking about these flags is as a progression of restricti=
ons:
+FOLL_GET is for struct page manipulation, without affecting the data that =
the
+struct page refers to. FOLL_PIN is a *replacement* for FOLL_GET, and is fo=
r
+short term pins on pages whose data *will* get accessed. As such, FOLL_PIN=
 is
+a "more severe" form of pinning. And finally, FOLL_LONGTERM is an even mor=
e
+restrictive case that has FOLL_PIN as a prerequisite: this is for pages th=
at
+will be pinned longterm, and whose data will be accessed.
+
+Unit testing
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+This file::
+
+ tools/testing/selftests/vm/gup_benchmark.c
+
+has the following new calls to exercise the new pin*() wrapper functions:
+
+* PIN_FAST_BENCHMARK (./gup_benchmark -a)
+* PIN_LONGTERM_BENCHMARK (./gup_benchmark -a)
+* PIN_BENCHMARK (./gup_benchmark -a)
+
+You can monitor how many total dma-pinned pages have been acquired and rel=
eased
+since the system was booted, via two new /proc/vmstat entries: ::
+
+    /proc/vmstat/nr_foll_pin_requested
+    /proc/vmstat/nr_foll_pin_requested
+
+Those are both going to show zero, unless CONFIG_DEBUG_VM is set. This is
+because there is a noticeable performance drop in put_user_page(), when th=
ey
+are activated.
+
+References
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+* `Some slow progress on get_user_pages() (Apr 2, 2019) <https://lwn.net/A=
rticles/784574/>`_
+* `DMA and get_user_pages() (LPC: Dec 12, 2018) <https://lwn.net/Articles/=
774411/>`_
+* `The trouble with get_user_pages() (Apr 30, 2018) <https://lwn.net/Artic=
les/753027/>`_
+
+John Hubbard, October, 2019
diff --git a/include/linux/mm.h b/include/linux/mm.h
index cc292273e6ba..cdfb6fedb271 100644
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
@@ -2615,11 +2635,41 @@ struct page *follow_page(struct vm_area_struct *vma=
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
+ * FOLL_PIN and FOLL_GET are mutually exclusive for a given function call.
+ * (The underlying pages may experience both FOLL_GET-based and FOLL_PIN-b=
ased
+ * calls applied to them, and that's perfectly OK. This is a constraint on=
 the
+ * callers, not on the pages.)
+ *
+ * FOLL_PIN and FOLL_LONGTERM should be set internally by the pin_user_pag=
e*()
+ * and pin_longterm_*() APIs, never directly by the caller. That's in orde=
r to
+ * help avoid mismatches when releasing pages: get_user_pages*() pages mus=
t be
+ * released via put_page(), while pin_user_pages*() pages must be released=
 via
+ * put_user_page().
+ *
+ * Please see Documentation/vm/pin_user_pages.rst for more information.
  */
=20
 static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
diff --git a/mm/gup.c b/mm/gup.c
index 199da99e8ffc..1aea48427879 100644
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
@@ -1151,6 +1164,14 @@ long get_user_pages_remote(struct task_struct *tsk, =
struct mm_struct *mm,
 		unsigned int gup_flags, struct page **pages,
 		struct vm_area_struct **vmas, int *locked)
 {
+	/*
+	 * FOLL_PIN must only be set internally by the pin_user_page*() and
+	 * pin_longterm_*() APIs, never directly by the caller, so enforce that
+	 * with an assertion:
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+		return -EINVAL;
+
 	/*
 	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
 	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
@@ -1608,6 +1629,14 @@ long get_user_pages(unsigned long start, unsigned lo=
ng nr_pages,
 		unsigned int gup_flags, struct page **pages,
 		struct vm_area_struct **vmas)
 {
+	/*
+	 * FOLL_PIN must only be set internally by the pin_user_page*() and
+	 * pin_longterm_*() APIs, never directly by the caller, so enforce that
+	 * with an assertion:
+	 */
+	if (WARN_ON_ONCE(gup_flags & FOLL_PIN))
+		return -EINVAL;
+
 	return __gup_longterm_locked(current, current->mm, start, nr_pages,
 				     pages, vmas, gup_flags | FOLL_TOUCH);
 }
@@ -2373,24 +2402,9 @@ static int __gup_longterm_unlocked(unsigned long sta=
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
@@ -2435,4 +2449,215 @@ int get_user_pages_fast(unsigned long start, int nr=
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
+	 * FOLL_PIN must only be set internally by the pin_user_page*() and
+	 * pin_longterm_*() APIs, never directly by the caller, so enforce that:
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

