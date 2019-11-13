Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E942FA8F6
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbfKMEbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:31:15 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3956 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbfKME1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:27:16 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcb85ea0003>; Tue, 12 Nov 2019 20:26:18 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 20:27:14 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 12 Nov 2019 20:27:14 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 04:27:13 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 13 Nov 2019 04:27:13 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dcb86210005>; Tue, 12 Nov 2019 20:27:13 -0800
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
Subject: [PATCH v4 19/23] powerpc: book3s64: convert to pin_longterm_pages() and put_user_page()
Date:   Tue, 12 Nov 2019 20:27:06 -0800
Message-ID: <20191113042710.3997854-20-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191113042710.3997854-1-jhubbard@nvidia.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573619178; bh=jP0+G7EUrJzRbss/H6wqbMhvj/DAmG+WrBPGAFIWqJ8=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=XdT+9xtNgQ1XHKD+Ac7dyAYaM8yJJoUfb+7ysHR4ZchEmOg8iGZ3OAYhhHQBi/Kbx
         UltPHZY9SFVfUJjeMZwf4R1aOCsKKLD1du/k7QznDkCr42xziGVH6hiHpJ7tRz9qzC
         Yz6AwUWWS3DBM3hsBO5bNhYB1KGOiSZm7sFvl0rLjrb1Av2GbfUxoIFgNnjnBxozni
         AYAi0jjIgUv8xQkbkzVbW/kpGs42hmNEzXbHglfB8yYeMV2SHe/v3hW3K+sX+DUiqj
         i6mDziB1Vy5Pr1o65Egq6j/c0CeZMBouTG4wBzUOxwvIkyqPxzpZrrACOnkABDSMNW
         PG72/FqvOdGmg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Convert from get_user_pages(FOLL_LONGTERM) to pin_longterm_pages().

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
 arch/powerpc/mm/book3s64/iommu_api.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s6=
4/iommu_api.c
index 56cc84520577..69d79cb50d47 100644
--- a/arch/powerpc/mm/book3s64/iommu_api.c
+++ b/arch/powerpc/mm/book3s64/iommu_api.c
@@ -103,9 +103,8 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, uns=
igned long ua,
 	for (entry =3D 0; entry < entries; entry +=3D chunk) {
 		unsigned long n =3D min(entries - entry, chunk);
=20
-		ret =3D get_user_pages(ua + (entry << PAGE_SHIFT), n,
-				FOLL_WRITE | FOLL_LONGTERM,
-				mem->hpages + entry, NULL);
+		ret =3D pin_longterm_pages(ua + (entry << PAGE_SHIFT), n,
+					 FOLL_WRITE, mem->hpages + entry, NULL);
 		if (ret =3D=3D n) {
 			pinned +=3D n;
 			continue;
@@ -167,9 +166,8 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, uns=
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
@@ -212,10 +210,9 @@ static void mm_iommu_unpin(struct mm_iommu_table_group=
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

