Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB918FD4A3
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfKOFyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:54:09 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5245 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727528AbfKOFyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:54:07 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dce3d6e0000>; Thu, 14 Nov 2019 21:53:50 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 14 Nov 2019 21:53:47 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 14 Nov 2019 21:53:47 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Nov
 2019 05:53:45 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 15 Nov 2019 05:53:45 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dce3d690003>; Thu, 14 Nov 2019 21:53:45 -0800
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
Subject: [PATCH v5 20/24] powerpc: book3s64: convert to pin_user_pages() and put_user_page()
Date:   Thu, 14 Nov 2019 21:53:36 -0800
Message-ID: <20191115055340.1825745-21-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115055340.1825745-1-jhubbard@nvidia.com>
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573797230; bh=IJJb9r+CEPs17zzIv7S9Yy1snV6WhIVmX2ftMMVKd1c=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=AKYEYmiAg5GfJHJ+iT/QmOBI7rOQBFB3ijN/pJEV8PScPSrcAWafv5cXVpu3MlqSB
         3iGqLkS2e5AcPkGUNrQF1PPF2a4bRyiZb3WMfLnx7mdMl8iYAoR5LlRUo6A+JwDw1u
         UsiYiA7LOHWw0BSeHGG4Oy2ZF85G3SDsdqoEVulQjPtejF6xGJ6loBRRBDsRcOQXcz
         i/wf3Y2KScuXSpBtmHxaYHvPt0rrhYvvRImjgFKKdEFhHZ1Xy1S0gBBGJVvpdk6g5L
         7kdTa+59Jz/PB/3/GzINz9i8zsYNG/qE3vEozuOnjzeyt7Nj/pGVqRmle9BMMOAORZ
         CzNhOnyKFs2gQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Convert from get_user_pages() to pin_user_pages().

2. As required by pin_user_pages(), release these pages via
put_user_page(). In this case, do so via put_user_pages_dirty_lock().

That has the side effect of calling set_page_dirty_lock(), instead
of set_page_dirty(). This is probably more accurate.

As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [1]

3. Release each page in mem->hpages[] (instead of mem->hpas[]), because
that is the array that pin_longterm_pages() filled in. This is more
accurate and should be a little safer from a maintenance point of
view.

[1] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 arch/powerpc/mm/book3s64/iommu_api.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s6=
4/iommu_api.c
index 56cc84520577..196383e8e5a9 100644
--- a/arch/powerpc/mm/book3s64/iommu_api.c
+++ b/arch/powerpc/mm/book3s64/iommu_api.c
@@ -103,7 +103,7 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, uns=
igned long ua,
 	for (entry =3D 0; entry < entries; entry +=3D chunk) {
 		unsigned long n =3D min(entries - entry, chunk);
=20
-		ret =3D get_user_pages(ua + (entry << PAGE_SHIFT), n,
+		ret =3D pin_user_pages(ua + (entry << PAGE_SHIFT), n,
 				FOLL_WRITE | FOLL_LONGTERM,
 				mem->hpages + entry, NULL);
 		if (ret =3D=3D n) {
@@ -167,9 +167,8 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, uns=
igned long ua,
 	return 0;
=20
 free_exit:
-	/* free the reference taken */
-	for (i =3D 0; i < pinned; i++)
-		put_page(mem->hpages[i]);
+	/* free the references taken */
+	put_user_pages(mem->hpages, pinned);
=20
 	vfree(mem->hpas);
 	kfree(mem);
@@ -212,10 +211,9 @@ static void mm_iommu_unpin(struct mm_iommu_table_group=
_mem_t *mem)
 		if (!page)
 			continue;
=20
-		if (mem->hpas[i] & MM_IOMMU_TABLE_GROUP_PAGE_DIRTY)
-			SetPageDirty(page);
+		put_user_pages_dirty_lock(&mem->hpages[i], 1,
+					  MM_IOMMU_TABLE_GROUP_PAGE_DIRTY);
=20
-		put_page(page);
 		mem->hpas[i] =3D 0;
 	}
 }
--=20
2.24.0

