Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C525ED54F
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 22:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbfKCVS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 16:18:26 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17504 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbfKCVSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 16:18:20 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dbf441f0002>; Sun, 03 Nov 2019 13:18:23 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Sun, 03 Nov 2019 13:18:18 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Sun, 03 Nov 2019 13:18:18 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 3 Nov
 2019 21:18:18 +0000
Received: from hqnvemgw01.nvidia.com (172.20.150.20) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sun, 3 Nov 2019 21:18:18 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dbf44190004>; Sun, 03 Nov 2019 13:18:17 -0800
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
Subject: [PATCH v2 14/18] vfio, mm: pin_longterm_pages (FOLL_PIN) and put_user_page() conversion
Date:   Sun, 3 Nov 2019 13:18:09 -0800
Message-ID: <20191103211813.213227-15-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191103211813.213227-1-jhubbard@nvidia.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572815904; bh=1iOGN4TRt8PvqjiLdwM6f6zOKk3A3b0FSz4UPjmoAC4=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=OAyRSW4fz9UjixnJPOQaglpLfSXgi7hZ6p50OoOhrLZfb106XYVyWfNelOGyOefln
         4Xf4SxQgL5HfXtUn5ZluPWd49rtAZPWLpP38mGIQrFtKjFzur2WF8ZuraePQI8ImgT
         EGXdW1OXicEbqsELOmkgg2iKfHyO0JV2kCE6oBgl5EZnTOiPdBptLS0mRdNxS8xcbm
         +PUEHlLAjGdEon1mRW51BRYPtc//WiHuZwc3shxSnuSODuNefZNmXSZ1aNdRq8tjjl
         S+8nLOg7/Xt76GP87RNiwGivmY98faMDXIItZR+tvODSGWV/Ef1Gjiov8uMVg5dZCl
         o1rjs1yN+iGCQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Change vfio from get_user_pages(FOLL_LONGTERM), to
pin_longterm_pages(), which sets both FOLL_LONGTERM and FOLL_PIN.

2. Because all FOLL_PIN-acquired pages must be released via
put_user_page(), also convert the put_page() call over to
put_user_pages().

Note that this effectively changes the code's behavior in
vfio_iommu_type1.c: put_pfn(): it now ultimately calls
set_page_dirty_lock(), instead of set_page_dirty(). This is
probably more accurate.

As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [1]

[1] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type=
1.c
index d864277ea16f..795e13f3ef08 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -327,9 +327,8 @@ static int put_pfn(unsigned long pfn, int prot)
 {
 	if (!is_invalid_reserved_pfn(pfn)) {
 		struct page *page =3D pfn_to_page(pfn);
-		if (prot & IOMMU_WRITE)
-			SetPageDirty(page);
-		put_page(page);
+
+		put_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
 		return 1;
 	}
 	return 0;
@@ -349,11 +348,11 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsign=
ed long vaddr,
=20
 	down_read(&mm->mmap_sem);
 	if (mm =3D=3D current->mm) {
-		ret =3D get_user_pages(vaddr, 1, flags | FOLL_LONGTERM, page,
-				     vmas);
+		ret =3D pin_longterm_pages(vaddr, 1, flags, page, vmas);
 	} else {
-		ret =3D get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
-					    vmas, NULL);
+		ret =3D pin_longterm_pages_remote(NULL, mm, vaddr, 1,
+						flags, page, vmas,
+						NULL);
 		/*
 		 * The lifetime of a vaddr_get_pfn() page pin is
 		 * userspace-controlled. In the fs-dax case this could
@@ -363,7 +362,7 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned=
 long vaddr,
 		 */
 		if (ret > 0 && vma_is_fsdax(vmas[0])) {
 			ret =3D -EOPNOTSUPP;
-			put_page(page[0]);
+			put_user_page(page[0]);
 		}
 	}
 	up_read(&mm->mmap_sem);
--=20
2.23.0

