Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DBA1D6511
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 03:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgEQBXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 21:23:39 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11725 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbgEQBXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 21:23:39 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec091cd0000>; Sat, 16 May 2020 18:22:22 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sat, 16 May 2020 18:23:38 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sat, 16 May 2020 18:23:38 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 17 May
 2020 01:23:38 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sun, 17 May 2020 01:23:38 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.48.175]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ec092190001>; Sat, 16 May 2020 18:23:37 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     LKML <linux-kernel@vger.kernel.org>
CC:     John Hubbard <jhubbard@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <rds-devel@oss.oracle.com>
Subject: [PATCH] rds: convert get_user_pages() --> pin_user_pages()
Date:   Sat, 16 May 2020 18:23:36 -0700
Message-ID: <20200517012336.382624-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589678542; bh=7TXMCvjqbZxuHVM5y97rS09KLJM6SOiZujb09twA/Dk=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Transfer-Encoding:
         Content-Type;
        b=p0pBPkQo7mb5Cwoe2du0glhdJwKo1677mvVSBz22sE9cCQM3wGXIlE5laIOCpyHYr
         3qa8VtddbcJJhPx9D+WMM0oxMHvZR38SI08df83Ab9p7pnBmsuhWAIpgl4xV3PBtFa
         KmsStxBTAZzOOuN/qKmICrQuaqSOPsDArBzf7+rLWbiu9xXJ7/Wvc15sev8rRw/Nba
         ogtop5i930W9FQEhrNP73FVSCcYjNYgM7sU1FXzygboz+d+uKyT0Z50TedeVRoiInM
         xkgR8Yv5tGyF5UfbyoXwQE4no8zx1mhMLQRR9lUIB9qGCdxfwU6Yr11M/3oO8C1CXk
         L0IYKYw6T1CYw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code was using get_user_pages_fast(), in a "Case 2" scenario
(DMA/RDMA), using the categorization from [1]. That means that it's
time to convert the get_user_pages_fast() + put_page() calls to
pin_user_pages_fast() + unpin_user_pages() calls.

There is some helpful background in [2]: basically, this is a small
part of fixing a long-standing disconnect between pinning pages, and
file systems' use of those pages.

[1] Documentation/core-api/pin_user_pages.rst

[2] "Explicit pinning of user-space pages":
    https://lwn.net/Articles/807108/

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Cc: rds-devel@oss.oracle.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/rds/info.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/rds/info.c b/net/rds/info.c
index 03f6fd56d237..e1d63563e81c 100644
--- a/net/rds/info.c
+++ b/net/rds/info.c
@@ -162,7 +162,6 @@ int rds_info_getsockopt(struct socket *sock, int optnam=
e, char __user *optval,
 	struct rds_info_lengths lens;
 	unsigned long nr_pages =3D 0;
 	unsigned long start;
-	unsigned long i;
 	rds_info_func func;
 	struct page **pages =3D NULL;
 	int ret;
@@ -193,7 +192,7 @@ int rds_info_getsockopt(struct socket *sock, int optnam=
e, char __user *optval,
 		ret =3D -ENOMEM;
 		goto out;
 	}
-	ret =3D get_user_pages_fast(start, nr_pages, FOLL_WRITE, pages);
+	ret =3D pin_user_pages_fast(start, nr_pages, FOLL_WRITE, pages);
 	if (ret !=3D nr_pages) {
 		if (ret > 0)
 			nr_pages =3D ret;
@@ -235,8 +234,7 @@ int rds_info_getsockopt(struct socket *sock, int optnam=
e, char __user *optval,
 		ret =3D -EFAULT;
=20
 out:
-	for (i =3D 0; pages && i < nr_pages; i++)
-		put_page(pages[i]);
+	unpin_user_pages(pages, nr_pages);
 	kfree(pages);
=20
 	return ret;

base-commit: 3d1c1e5931ce45b3a3f309385bbc00c78e9951c6
--=20
2.26.2

