Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73BC7133691
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 23:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgAGWsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 17:48:17 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4814 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727620AbgAGWqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 17:46:09 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e150a190000>; Tue, 07 Jan 2020 14:45:45 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 07 Jan 2020 14:46:02 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 07 Jan 2020 14:46:02 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 7 Jan
 2020 22:46:01 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 7 Jan 2020 22:46:01 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5e150a29000c>; Tue, 07 Jan 2020 14:46:01 -0800
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
        "Kirill A . Shutemov" <kirill@shutemov.name>,
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
Subject: [PATCH v12 19/22] vfio, mm: pin_user_pages (FOLL_PIN) and put_user_page() conversion
Date:   Tue, 7 Jan 2020 14:45:55 -0800
Message-ID: <20200107224558.2362728-20-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107224558.2362728-1-jhubbard@nvidia.com>
References: <20200107224558.2362728-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578437145; bh=ENBSgRCtmfM034uozTO4hXHrimG7hXnL4nYIQJVrTfw=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=QVxUNlOhnnAQ64WGmzO0tzjgAX/vCFxBjJf1eWQT6o9ympPoBKkTsm2ekk0dunKdU
         QiL+zFCD6eR1OgGHBHZEqfbkE+7pkCTjWYjEA8Kwgke5y+aWezPFxilQNalMNnM7OH
         G47rJYa8NWjDOBVYTiyh5HYDYqiCPUhOaHPH/5ohkK4rgNpuT/dS+YTK79ObIl/GZT
         QAxPDbTXK45f2G/vVYWlZ/YB9LeLV4a2R3uN3wUhyBG5Aq8VS0j6WjeG9eZfZINwzc
         dNItyjaTK/hoNDq7Qi88+GthppBCArFyPG7mTEFHYDm74lXDs91C8qlXedPW4lRrpE
         B2fiGJMgLCOmA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Change vfio from get_user_pages_remote(), to
pin_user_pages_remote().

2. Because all FOLL_PIN-acquired pages must be released via
put_user_page(), also convert the put_page() call over to
put_user_pages_dirty_lock().

Note that this effectively changes the code's behavior in
vfio_iommu_type1.c: put_pfn(): it now ultimately calls
set_page_dirty_lock(), instead of set_page_dirty(). This is
probably more accurate.

As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [1]

[1] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Tested-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type=
1.c
index b800fc9a0251..18bfc2fc8e6d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -309,9 +309,8 @@ static int put_pfn(unsigned long pfn, int prot)
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
@@ -329,7 +328,7 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned=
 long vaddr,
 		flags |=3D FOLL_WRITE;
=20
 	down_read(&mm->mmap_sem);
-	ret =3D get_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
+	ret =3D pin_user_pages_remote(NULL, mm, vaddr, 1, flags | FOLL_LONGTERM,
 				    page, NULL, NULL);
 	if (ret =3D=3D 1) {
 		*pfn =3D page_to_pfn(page[0]);
--=20
2.24.1

