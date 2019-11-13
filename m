Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9F4FA821
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfKME1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:27:25 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13790 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbfKME1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:27:24 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcb86240000>; Tue, 12 Nov 2019 20:27:16 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 20:27:16 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 12 Nov 2019 20:27:16 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 04:27:12 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 13 Nov 2019 04:27:12 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dcb86200002>; Tue, 12 Nov 2019 20:27:12 -0800
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
        John Hubbard <jhubbard@nvidia.com>,
        "Jason Gunthorpe" <jgg@mellanox.com>
Subject: [PATCH v4 06/23] IB/umem: use get_user_pages_fast() to pin DMA pages
Date:   Tue, 12 Nov 2019 20:26:53 -0800
Message-ID: <20191113042710.3997854-7-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191113042710.3997854-1-jhubbard@nvidia.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573619236; bh=yfY59FEzCJLU6Ev5Ha1oxCyEt547L9Ku0BnikujLehw=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=Oefu4QxrHoO0kNGZ6RM3kN6GOCF1uvImt6G47o7WM+tEZrfvAfzPFgyO+JXvSYG7c
         O47Pgoj7ZZPSNuerwOkv4CSkMfEhOtm6vb1dfWG6cL9iOCqc9k0rGFvgous55Is9xG
         lHyGxVr1SvtGNL7JYR1zBSibc6MgGJQ0yi84ExpbYH8R9qzAS/byqeaX3mhCZWGKMR
         ADv+j3xeoivErWC4LSEdu1YMMrstWOTL3HynPZJiU2LUHKLXQHZGg00Btsvg+2Dtp5
         rF5Nv1q7x4Mcbk/O3Rz5zJrzLF+apqHFbVvc4bBiG9D+UZaLl37QBE5OAzDWh5XcFQ
         bYZ5ljEbuLDyw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And get rid of the mmap_sem calls, as part of that. Note
that get_user_pages_fast() will, if necessary, fall back to
__gup_longterm_unlocked(), which takes the mmap_sem as needed.

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/infiniband/core/umem.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.=
c
index 24244a2f68cc..3d664a2539eb 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -271,16 +271,13 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, u=
nsigned long addr,
 	sg =3D umem->sg_head.sgl;
=20
 	while (npages) {
-		down_read(&mm->mmap_sem);
-		ret =3D get_user_pages(cur_base,
-				     min_t(unsigned long, npages,
-					   PAGE_SIZE / sizeof (struct page *)),
-				     gup_flags | FOLL_LONGTERM,
-				     page_list, NULL);
-		if (ret < 0) {
-			up_read(&mm->mmap_sem);
+		ret =3D get_user_pages_fast(cur_base,
+					  min_t(unsigned long, npages,
+						PAGE_SIZE /
+						sizeof(struct page *)),
+					  gup_flags | FOLL_LONGTERM, page_list);
+		if (ret < 0)
 			goto umem_release;
-		}
=20
 		cur_base +=3D ret * PAGE_SIZE;
 		npages   -=3D ret;
@@ -288,8 +285,6 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, uns=
igned long addr,
 		sg =3D ib_umem_add_sg_table(sg, page_list, ret,
 			dma_get_max_seg_size(context->device->dma_device),
 			&umem->sg_nents);
-
-		up_read(&mm->mmap_sem);
 	}
=20
 	sg_mark_end(sg);
--=20
2.24.0

