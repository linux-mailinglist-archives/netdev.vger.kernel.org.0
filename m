Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1688AFA7FB
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfKME10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:27:26 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4083 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfKME1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:27:25 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcb85ea0002>; Tue, 12 Nov 2019 20:26:18 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 20:27:14 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 12 Nov 2019 20:27:14 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 04:27:13 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 04:27:13 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 13 Nov 2019 04:27:13 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dcb86210001>; Tue, 12 Nov 2019 20:27:13 -0800
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
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v4 15/23] net/xdp: set FOLL_PIN via pin_user_pages()
Date:   Tue, 12 Nov 2019 20:27:02 -0800
Message-ID: <20191113042710.3997854-16-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191113042710.3997854-1-jhubbard@nvidia.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573619178; bh=7NW5FVByU2q47q8YXJg0DLnVCFYBzjS19tQtlG28KDY=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=H0nRSEIpnMKT6SAHavEEr3bZ7kirPPuot4ebr2ENUD2wm1s40TTVQ1aMHIn3VjpJk
         UzRrDdQk92vKocQnrSDsZZBGVrEk/yqipov2xdbca4Yo5OYtK84GbW314oc2APgE2c
         8wCV0hTiZh/CcGOezqPAwUISwsAdxlnvvpr+ZrOzO/Nz6bn/XBbcaZXK8XCuAJUyCs
         EKfEp53I331CKcGEsd7EXF4qwPHDAHxfMxZ0aUmXwyq6is/2C/k2ErFE3aiE63Y1tY
         R9ZUC02RUsoHRXz9D6j4v3Q+EKs7tdfwWn2XWTPCCERaWbCw3CoG4aFiDNCj9Dfrub
         YkX87/EssHAcw==
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
here is to change get_user_pages() to pin_longterm_pages().

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/xdp/xdp_umem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 3049af269fbf..66c814863cfd 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -291,8 +291,8 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem)
 		return -ENOMEM;
=20
 	down_read(&current->mm->mmap_sem);
-	npgs =3D get_user_pages(umem->address, umem->npgs,
-			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
+	npgs =3D pin_longterm_pages(umem->address, umem->npgs, gup_flags,
+				  &umem->pgs[0], NULL);
 	up_read(&current->mm->mmap_sem);
=20
 	if (npgs !=3D umem->npgs) {
--=20
2.24.0

