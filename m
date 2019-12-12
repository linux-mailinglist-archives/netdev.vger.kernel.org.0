Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004BF11C80C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 09:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbfLLIXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 03:23:32 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3764 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728295AbfLLITW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 03:19:22 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df1f8020000>; Thu, 12 Dec 2019 00:19:14 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 12 Dec 2019 00:19:20 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 12 Dec 2019 00:19:20 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Dec
 2019 08:19:20 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 12 Dec 2019 08:19:20 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5df1f8080001>; Thu, 12 Dec 2019 00:19:20 -0800
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
Subject: [PATCH v10 16/25] net/xdp: set FOLL_PIN via pin_user_pages()
Date:   Thu, 12 Dec 2019 00:19:08 -0800
Message-ID: <20191212081917.1264184-17-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191212081917.1264184-1-jhubbard@nvidia.com>
References: <20191212081917.1264184-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576138754; bh=JiuMSIu1KROGnYN0FUrQmmZholMbEQnfhCSo9iAG4Tw=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=YtJa8IwOYU85IUjYMF0DnWc/6EYkYQw6Ms5+ZpyE28xMR1VhiR8idS5vGsruOLq4c
         +TAoVqhhCH27Y6Vph5kLUUthDdyH03hd3fldfYPbIHcYMiEYwz2oM+v1nqY0iDdpSa
         xh/QN9ZjeL1QobtGtJamXcW7SAYBIBsViMhEx7CUB/RtqNx3TIY5/gNnY1ekHkn+lp
         FddwNu92pyIo2pMvam9ExDrglCUzuJ4kQsNiVIeSfAfh9IByeonpAKm+bhrjPYLwDQ
         /NSoC9PUG6wdPGl+PcGF2VPCZWErPRqTcEWz+hjD+56BEiI8f4j6wF6NApTiWLpV3J
         Sa0c2kpwXMEdQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert net/xdp to use the new pin_longterm_pages() call, which sets
FOLL_PIN. Setting FOLL_PIN is now required for code that requires
tracking of pinned pages.

In partial anticipation of this work, the net/xdp code was already
calling put_user_page() instead of put_page(). Therefore, in order to
convert from the get_user_pages()/put_page() model, to the
pin_user_pages()/put_user_page() model, the only change required
here is to change get_user_pages() to pin_user_pages().

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/xdp/xdp_umem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 3049af269fbf..d071003b5e76 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -291,7 +291,7 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem)
 		return -ENOMEM;
=20
 	down_read(&current->mm->mmap_sem);
-	npgs =3D get_user_pages(umem->address, umem->npgs,
+	npgs =3D pin_user_pages(umem->address, umem->npgs,
 			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
 	up_read(&current->mm->mmap_sem);
=20
--=20
2.24.0

