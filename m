Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97161FA8DB
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbfKMEau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:30:50 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3961 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfKME1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:27:18 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcb85e80001>; Tue, 12 Nov 2019 20:26:16 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 20:27:12 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 12 Nov 2019 20:27:12 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 04:27:12 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 13 Nov 2019 04:27:12 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dcb861f0003>; Tue, 12 Nov 2019 20:27:11 -0800
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
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v4 02/23] mm/gup: factor out duplicate code from four routines
Date:   Tue, 12 Nov 2019 20:26:49 -0800
Message-ID: <20191113042710.3997854-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191113042710.3997854-1-jhubbard@nvidia.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573619177; bh=kJfdBwtxV0Xf/7sPEfLRjg5QuIfiLXYo87o9tgl9dSA=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=KXAtPqe3/vp+Yt8jEcJBWjH2hIR3D8OC+eB+GnypX8Sn3senSX3NF4pzFvF8bVQv2
         kJRQUmdxsS1TW8jErvtOnCB2sGO+6l1IeK7KKq8IPt0h+inmZA/ZPa1QYoDDQWLTTo
         F/ExSZh3FpJmmdqdF45ezY1Km/sIuxjW5gntXsJAghltdldo6jHfM6lcDGxxKM7Fr3
         I/rK5MZBlm0or7hVVZIHd7MHnRheMXvm7XasmFc+z9NG5d3fEz8vIuohFn8auSC9gb
         cKpq9q7Cc0XHXKQDPiD4voNLun1SYfoC3QWgHFgfXvUfHfMqts4I1iTlRL3R905a4o
         sRAzS2KBCkb0g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are four locations in gup.c that have a fair amount of code
duplication. This means that changing one requires making the same
changes in four places, not to mention reading the same code four
times, and wondering if there are subtle differences.

Factor out the common code into static functions, thus reducing the
overall line count and the code's complexity.

Also, take the opportunity to slightly improve the efficiency of the
error cases, by doing a mass subtraction of the refcount, surrounded
by get_page()/put_page().

Also, further simplify (slightly), by waiting until the the successful
end of each routine, to increment *nr.

Reviewed-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/gup.c | 104 ++++++++++++++++++++++++-------------------------------
 1 file changed, 45 insertions(+), 59 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 85caf76b3012..199da99e8ffc 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1969,6 +1969,34 @@ static int __gup_device_huge_pud(pud_t pud, pud_t *p=
udp, unsigned long addr,
 }
 #endif
=20
+static int __record_subpages(struct page *page, unsigned long addr,
+			     unsigned long end, struct page **pages, int nr)
+{
+	int nr_recorded_pages =3D 0;
+
+	do {
+		pages[nr] =3D page;
+		nr++;
+		page++;
+		nr_recorded_pages++;
+	} while (addr +=3D PAGE_SIZE, addr !=3D end);
+	return nr_recorded_pages;
+}
+
+static void put_compound_head(struct page *page, int refs)
+{
+	/* Do a get_page() first, in case refs =3D=3D page->_refcount */
+	get_page(page);
+	page_ref_sub(page, refs);
+	put_page(page);
+}
+
+static void __huge_pt_done(struct page *head, int nr_recorded_pages, int *=
nr)
+{
+	*nr +=3D nr_recorded_pages;
+	SetPageReferenced(head);
+}
+
 #ifdef CONFIG_ARCH_HAS_HUGEPD
 static unsigned long hugepte_addr_end(unsigned long addr, unsigned long en=
d,
 				      unsigned long sz)
@@ -1998,33 +2026,20 @@ static int gup_hugepte(pte_t *ptep, unsigned long s=
z, unsigned long addr,
 	/* hugepages are never "special" */
 	VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
=20
-	refs =3D 0;
 	head =3D pte_page(pte);
-
 	page =3D head + ((addr & (sz-1)) >> PAGE_SHIFT);
-	do {
-		VM_BUG_ON(compound_head(page) !=3D head);
-		pages[*nr] =3D page;
-		(*nr)++;
-		page++;
-		refs++;
-	} while (addr +=3D PAGE_SIZE, addr !=3D end);
+	refs =3D __record_subpages(page, addr, end, pages, *nr);
=20
 	head =3D try_get_compound_head(head, refs);
-	if (!head) {
-		*nr -=3D refs;
+	if (!head)
 		return 0;
-	}
=20
 	if (unlikely(pte_val(pte) !=3D pte_val(*ptep))) {
-		/* Could be optimized better */
-		*nr -=3D refs;
-		while (refs--)
-			put_page(head);
+		put_compound_head(head, refs);
 		return 0;
 	}
=20
-	SetPageReferenced(head);
+	__huge_pt_done(head, refs, nr);
 	return 1;
 }
=20
@@ -2071,29 +2086,19 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, un=
signed long addr,
 					     pages, nr);
 	}
=20
-	refs =3D 0;
 	page =3D pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	do {
-		pages[*nr] =3D page;
-		(*nr)++;
-		page++;
-		refs++;
-	} while (addr +=3D PAGE_SIZE, addr !=3D end);
+	refs =3D __record_subpages(page, addr, end, pages, *nr);
=20
 	head =3D try_get_compound_head(pmd_page(orig), refs);
-	if (!head) {
-		*nr -=3D refs;
+	if (!head)
 		return 0;
-	}
=20
 	if (unlikely(pmd_val(orig) !=3D pmd_val(*pmdp))) {
-		*nr -=3D refs;
-		while (refs--)
-			put_page(head);
+		put_compound_head(head, refs);
 		return 0;
 	}
=20
-	SetPageReferenced(head);
+	__huge_pt_done(head, refs, nr);
 	return 1;
 }
=20
@@ -2114,29 +2119,19 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, un=
signed long addr,
 					     pages, nr);
 	}
=20
-	refs =3D 0;
 	page =3D pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-	do {
-		pages[*nr] =3D page;
-		(*nr)++;
-		page++;
-		refs++;
-	} while (addr +=3D PAGE_SIZE, addr !=3D end);
+	refs =3D __record_subpages(page, addr, end, pages, *nr);
=20
 	head =3D try_get_compound_head(pud_page(orig), refs);
-	if (!head) {
-		*nr -=3D refs;
+	if (!head)
 		return 0;
-	}
=20
 	if (unlikely(pud_val(orig) !=3D pud_val(*pudp))) {
-		*nr -=3D refs;
-		while (refs--)
-			put_page(head);
+		put_compound_head(head, refs);
 		return 0;
 	}
=20
-	SetPageReferenced(head);
+	__huge_pt_done(head, refs, nr);
 	return 1;
 }
=20
@@ -2151,29 +2146,20 @@ static int gup_huge_pgd(pgd_t orig, pgd_t *pgdp, un=
signed long addr,
 		return 0;
=20
 	BUILD_BUG_ON(pgd_devmap(orig));
-	refs =3D 0;
+
 	page =3D pgd_page(orig) + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
-	do {
-		pages[*nr] =3D page;
-		(*nr)++;
-		page++;
-		refs++;
-	} while (addr +=3D PAGE_SIZE, addr !=3D end);
+	refs =3D __record_subpages(page, addr, end, pages, *nr);
=20
 	head =3D try_get_compound_head(pgd_page(orig), refs);
-	if (!head) {
-		*nr -=3D refs;
+	if (!head)
 		return 0;
-	}
=20
 	if (unlikely(pgd_val(orig) !=3D pgd_val(*pgdp))) {
-		*nr -=3D refs;
-		while (refs--)
-			put_page(head);
+		put_compound_head(head, refs);
 		return 0;
 	}
=20
-	SetPageReferenced(head);
+	__huge_pt_done(head, refs, nr);
 	return 1;
 }
=20
--=20
2.24.0

