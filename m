Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7078159F65
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 04:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBLDEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 22:04:04 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17438 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbgBLDED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 22:04:03 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e436b060000>; Tue, 11 Feb 2020 19:03:34 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 11 Feb 2020 19:04:02 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 11 Feb 2020 19:04:02 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 12 Feb
 2020 03:03:57 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 12 Feb 2020 03:03:57 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5e436b1c0002>; Tue, 11 Feb 2020 19:03:57 -0800
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <linux-rdma@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 1/1] net/rds: Track user mapped pages through special API
Date:   Tue, 11 Feb 2020 19:03:55 -0800
Message-ID: <20200212030355.1600749-2-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200212030355.1600749-1-jhubbard@nvidia.com>
References: <20200212030355.1600749-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1581476615; bh=QM57p0FeYJqwPBc6+A6zFYRgdMBVy4hfNVKBmK2wyyQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=rHWmzWtDITCeBrU2kDXdy4QwNdjPqBqpBzTWlwkNmV3J1y7k1/K3hVJhdP5aLMVBd
         El9kb0zBcQAoEA/FVwxprg2nCADwsvJTAyoJo7EX92QdTYJbChS3ukjFd2qzx2w0if
         2wHC1fppxb9lnhsNt3tcya7i9SJrOy2jT8zv4Es3IdoPcLrGCo2mIl1ktE9lfYIz4S
         kuwaguGUTIPtFW0wi3NBZa7I8a4y6e+NYzp3DjraU24femZY2Z/Yl0XD0Pv9xStVkd
         GBwXQNAclVoYcfIsXS8S7nc5H4+GHeiJlWWi7+MFaAWFOd5KckUxiqy3mXf6binaPg
         JY+Iz+osS13bg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Convert net/rds to use the newly introduces pin_user_pages() API,
which properly sets FOLL_PIN. Setting FOLL_PIN is now required for
code that requires tracking of pinned pages.

Note that this effectively changes the code's behavior: it now
ultimately calls set_page_dirty_lock(), instead of set_page_dirty().
This is probably more accurate.

As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [1]

[1] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Cc: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/rds/rdma.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 3341eee87bf9..585e6b3b69ce 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -162,10 +162,9 @@ static int rds_pin_pages(unsigned long user_addr, unsi=
gned int nr_pages,
 	if (write)
 		gup_flags |=3D FOLL_WRITE;
=20
-	ret =3D get_user_pages_fast(user_addr, nr_pages, gup_flags, pages);
+	ret =3D pin_user_pages_fast(user_addr, nr_pages, gup_flags, pages);
 	if (ret >=3D 0 && ret < nr_pages) {
-		while (ret--)
-			put_page(pages[ret]);
+		unpin_user_pages(pages, ret);
 		ret =3D -EFAULT;
 	}
=20
@@ -300,8 +299,7 @@ static int __rds_rdma_map(struct rds_sock *rs, struct r=
ds_get_mr_args *args,
 		 * to release anything.
 		 */
 		if (!need_odp) {
-			for (i =3D 0 ; i < nents; i++)
-				put_page(sg_page(&sg[i]));
+			unpin_user_pages(pages, nr_pages);
 			kfree(sg);
 		}
 		ret =3D PTR_ERR(trans_private);
@@ -325,7 +323,12 @@ static int __rds_rdma_map(struct rds_sock *rs, struct =
rds_get_mr_args *args,
 	if (cookie_ret)
 		*cookie_ret =3D cookie;
=20
-	if (args->cookie_addr && put_user(cookie, (u64 __user *)(unsigned long) a=
rgs->cookie_addr)) {
+	if (args->cookie_addr &&
+	    put_user(cookie, (u64 __user *)(unsigned long)args->cookie_addr)) {
+		if (!need_odp) {
+			unpin_user_pages(pages, nr_pages);
+			kfree(sg);
+		}
 		ret =3D -EFAULT;
 		goto out;
 	}
@@ -496,9 +499,7 @@ void rds_rdma_free_op(struct rm_rdma_op *ro)
 			 * is the case for a RDMA_READ which copies from remote
 			 * to local memory
 			 */
-			if (!ro->op_write)
-				set_page_dirty(page);
-			put_page(page);
+			unpin_user_pages_dirty_lock(&page, 1, !ro->op_write);
 		}
 	}
=20
@@ -515,8 +516,7 @@ void rds_atomic_free_op(struct rm_atomic_op *ao)
 	/* Mark page dirty if it was possibly modified, which
 	 * is the case for a RDMA_READ which copies from remote
 	 * to local memory */
-	set_page_dirty(page);
-	put_page(page);
+	unpin_user_pages_dirty_lock(&page, 1, true);
=20
 	kfree(ao->op_notifier);
 	ao->op_notifier =3D NULL;
@@ -944,7 +944,7 @@ int rds_cmsg_atomic(struct rds_sock *rs, struct rds_mes=
sage *rm,
 	return ret;
 err:
 	if (page)
-		put_page(page);
+		unpin_user_page(page);
 	rm->atomic.op_active =3D 0;
 	kfree(rm->atomic.op_notifier);
=20
--=20
2.25.0

