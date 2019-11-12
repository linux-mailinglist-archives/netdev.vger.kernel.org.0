Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAB6F84AA
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbfKLAKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:10:23 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10648 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727321AbfKLAHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:07:17 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc9f7ab0001>; Mon, 11 Nov 2019 16:07:07 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 11 Nov 2019 16:07:05 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 11 Nov 2019 16:07:05 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 00:07:04 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 12 Nov 2019 00:07:03 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dc9f7a60006>; Mon, 11 Nov 2019 16:07:03 -0800
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
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v3 01/23] mm/gup: pass flags arg to __gup_device_* functions
Date:   Mon, 11 Nov 2019 16:06:38 -0800
Message-ID: <20191112000700.3455038-2-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191112000700.3455038-1-jhubbard@nvidia.com>
References: <20191112000700.3455038-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573517228; bh=/JjGbVZJ8qaDHiJyVc8rKJC41LC1ZjvKm126SlEIWtY=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=XgxPYsGD5Cq3FBIJISLcRetCEazTGocWyf543MWJh0xxa/0V54dx42FHTdiMbtp9G
         bkhWUIOYRWPTqeAghnzLlcKq+4jG/ziNrBs8to4cFX5tjldntCGFxly2FDb/7dtuPB
         ofXOYWSWPiPo4pLPCp6sVUzJBklCoqa+pD5cMreZdifwGntgrWsOQZZezVmEDqPJnr
         WyAc41nboTdDAQA1l/f+ButLI0Guqa0dZMyR8Qo6jQgFrGI5VdU/2VYWZ9h0Rt7eWK
         V/9Hp3cxn3NKCsyExhyTjLc2HiWqAtDKfUPVARyab/T8fsXF3grzwRklGIWCTRClJw
         wkZJz9tcQbExw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A subsequent patch requires access to gup flags, so
pass the flags argument through to the __gup_device_*
functions.

Also placate checkpatch.pl by shortening a nearby line.

Reviewed-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/gup.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 8f236a335ae9..85caf76b3012 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1890,7 +1890,8 @@ static int gup_pte_range(pmd_t pmd, unsigned long add=
r, unsigned long end,
=20
 #if defined(CONFIG_ARCH_HAS_PTE_DEVMAP) && defined(CONFIG_TRANSPARENT_HUGE=
PAGE)
 static int __gup_device_huge(unsigned long pfn, unsigned long addr,
-		unsigned long end, struct page **pages, int *nr)
+			     unsigned long end, unsigned int flags,
+			     struct page **pages, int *nr)
 {
 	int nr_start =3D *nr;
 	struct dev_pagemap *pgmap =3D NULL;
@@ -1916,13 +1917,14 @@ static int __gup_device_huge(unsigned long pfn, uns=
igned long addr,
 }
=20
 static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long ad=
dr,
-		unsigned long end, struct page **pages, int *nr)
+				 unsigned long end, unsigned int flags,
+				 struct page **pages, int *nr)
 {
 	unsigned long fault_pfn;
 	int nr_start =3D *nr;
=20
 	fault_pfn =3D pmd_pfn(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	if (!__gup_device_huge(fault_pfn, addr, end, pages, nr))
+	if (!__gup_device_huge(fault_pfn, addr, end, flags, pages, nr))
 		return 0;
=20
 	if (unlikely(pmd_val(orig) !=3D pmd_val(*pmdp))) {
@@ -1933,13 +1935,14 @@ static int __gup_device_huge_pmd(pmd_t orig, pmd_t =
*pmdp, unsigned long addr,
 }
=20
 static int __gup_device_huge_pud(pud_t orig, pud_t *pudp, unsigned long ad=
dr,
-		unsigned long end, struct page **pages, int *nr)
+				 unsigned long end, unsigned int flags,
+				 struct page **pages, int *nr)
 {
 	unsigned long fault_pfn;
 	int nr_start =3D *nr;
=20
 	fault_pfn =3D pud_pfn(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-	if (!__gup_device_huge(fault_pfn, addr, end, pages, nr))
+	if (!__gup_device_huge(fault_pfn, addr, end, flags, pages, nr))
 		return 0;
=20
 	if (unlikely(pud_val(orig) !=3D pud_val(*pudp))) {
@@ -1950,14 +1953,16 @@ static int __gup_device_huge_pud(pud_t orig, pud_t =
*pudp, unsigned long addr,
 }
 #else
 static int __gup_device_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long ad=
dr,
-		unsigned long end, struct page **pages, int *nr)
+				 unsigned long end, unsigned int flags,
+				 struct page **pages, int *nr)
 {
 	BUILD_BUG();
 	return 0;
 }
=20
 static int __gup_device_huge_pud(pud_t pud, pud_t *pudp, unsigned long add=
r,
-		unsigned long end, struct page **pages, int *nr)
+				 unsigned long end, unsigned int flags,
+				 struct page **pages, int *nr)
 {
 	BUILD_BUG();
 	return 0;
@@ -2062,7 +2067,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsi=
gned long addr,
 	if (pmd_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
-		return __gup_device_huge_pmd(orig, pmdp, addr, end, pages, nr);
+		return __gup_device_huge_pmd(orig, pmdp, addr, end, flags,
+					     pages, nr);
 	}
=20
 	refs =3D 0;
@@ -2092,7 +2098,8 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsi=
gned long addr,
 }
=20
 static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
-		unsigned long end, unsigned int flags, struct page **pages, int *nr)
+			unsigned long end, unsigned int flags,
+			struct page **pages, int *nr)
 {
 	struct page *head, *page;
 	int refs;
@@ -2103,7 +2110,8 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, unsi=
gned long addr,
 	if (pud_devmap(orig)) {
 		if (unlikely(flags & FOLL_LONGTERM))
 			return 0;
-		return __gup_device_huge_pud(orig, pudp, addr, end, pages, nr);
+		return __gup_device_huge_pud(orig, pudp, addr, end, flags,
+					     pages, nr);
 	}
=20
 	refs =3D 0;
--=20
2.24.0

