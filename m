Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0FAA117AAC
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 23:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfLIW4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 17:56:51 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9195 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfLIWyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 17:54:07 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5deed0760001>; Mon, 09 Dec 2019 14:53:42 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 09 Dec 2019 14:54:02 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 09 Dec 2019 14:54:02 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Dec
 2019 22:53:59 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 9 Dec 2019 22:53:57 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5deed0840004>; Mon, 09 Dec 2019 14:53:57 -0800
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
        "Leon Romanovsky" <leonro@mellanox.com>,
        Christoph Hellwig <hch@lst.de>,
        "Jason Gunthorpe" <jgg@mellanox.com>
Subject: [PATCH v8 09/26] IB/umem: use get_user_pages_fast() to pin DMA pages
Date:   Mon, 9 Dec 2019 14:53:27 -0800
Message-ID: <20191209225344.99740-10-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191209225344.99740-1-jhubbard@nvidia.com>
References: <20191209225344.99740-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575932022; bh=KTo+Vd9z7NzEKl8A1/yToX+DbFwwWmKCvDQHXC5NnHk=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=I/a66LZB+BWjjEwaZhCTiAATPaKcaGOYfmxTxoglFKu01vsrHLxJ6Ocms1ZpOKJ13
         LDzbNCogDa0wWDiois2S1i8eV5jG6NwZ2mCwtsgqFYBoWJD74NSMg3b5BcLbKQc4td
         8sB9aUXgP+XrAcw+9CdXONTKdTy10gL/UdY+6R7Z2nTGWCE1ff37MEfm4AG5B6vZDR
         s/sA43qOwfAqtcnItvNy+tDKr/Mop2nhKo+0mAM+JqKgBRR/AbZM7H52crXltqXn3m
         AcXzLxvPUcxO0Ag1O/S6nUv3oKGi3deUwMVzzxIyKkdYdV6BrZSj/Ndpc0uOcxqFzJ
         pee3JlzYL13IQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And get rid of the mmap_sem calls, as part of that. Note
that get_user_pages_fast() will, if necessary, fall back to
__gup_longterm_unlocked(), which takes the mmap_sem as needed.

Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/infiniband/core/umem.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.=
c
index 7a3b99597ead..214e87aa609d 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -266,16 +266,13 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, u=
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
@@ -283,8 +280,6 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, uns=
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

