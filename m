Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0E8C11A218
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 03:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfLKCzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 21:55:05 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17158 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbfLKCxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 21:53:36 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df05a190002>; Tue, 10 Dec 2019 18:53:14 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 10 Dec 2019 18:53:35 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 10 Dec 2019 18:53:35 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Dec
 2019 02:53:34 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 11 Dec 2019 02:53:34 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5df05a2d0000>; Tue, 10 Dec 2019 18:53:33 -0800
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
Subject: [PATCH v9 20/25] powerpc: book3s64: convert to pin_user_pages() and put_user_page()
Date:   Tue, 10 Dec 2019 18:53:13 -0800
Message-ID: <20191211025318.457113-21-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211025318.457113-1-jhubbard@nvidia.com>
References: <20191211025318.457113-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576032794; bh=ZC502pnG3lzyZPc0rKFPYTMvPQMW7bt9uWUpRzgAdGk=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=fKedKOWKlEjG2jyPhFKMdzrR++wUcbANBWq5feSrewLbb83bWkn1hHUYv8XVYC6pj
         JLS3nsfDqsgBr2ddjA7wgLgUEgdtD38gvy/9tyl/ddAk49KAXPvIIQouylAemgrp4X
         5kw/KpUP1KsVCINrnTOiK/pL60/mdjsLzz9o9y9d28Lm9ha4FEiVQMcKgLh3m90inR
         U33+PFeh85sc0M7HSoF5WTfOD4/uMBA0ziiYNagCIA3PNkzh6AM3ysMqjGU7mZL0iT
         LOtYnVoxLbznfec4PU8NPFMBgZBIfrIv0lUptVo6sz4ZvRD+yIh7R/d0jUZP3WyQwV
         +HmVZkSX92KZw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Convert from get_user_pages() to pin_user_pages().

2. As required by pin_user_pages(), release these pages via
put_user_page().

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 arch/powerpc/mm/book3s64/iommu_api.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s6=
4/iommu_api.c
index 56cc84520577..a86547822034 100644
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
@@ -215,7 +214,8 @@ static void mm_iommu_unpin(struct mm_iommu_table_group_=
mem_t *mem)
 		if (mem->hpas[i] & MM_IOMMU_TABLE_GROUP_PAGE_DIRTY)
 			SetPageDirty(page);
=20
-		put_page(page);
+		put_user_page(page);
+
 		mem->hpas[i] =3D 0;
 	}
 }
--=20
2.24.0

