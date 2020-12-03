Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E430E2CCE06
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgLCElM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:41:12 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18715 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbgLCElM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:41:12 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc86c400000>; Wed, 02 Dec 2020 20:40:32 -0800
Received: from sx1.vdiclient.nvidia.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:40:31 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Eran Ben Elisha" <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/4] net/mlx5: Fix wrong address reclaim when command interface is down
Date:   Wed, 2 Dec 2020 20:39:43 -0800
Message-ID: <20201203043946.235385-2-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201203043946.235385-1-saeedm@nvidia.com>
References: <20201203043946.235385-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606970432; bh=g9S1EJlXxrJbl1vEpb1R/ThKLSkNAa4+6A4fYIWpmc4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=YOXFjf4p0pD8ZxbiySJmX8uF0fI9e/0eIsXLvNA7qTYPNbPyfYYVjwul5f3XWqefU
         lccjK63wSJ1K7X3pmMPPkiF0CmZz863Pwc0lhPIBUERV4AQvsGX6NjHYUnD3cz50IW
         hz7DtT1q9PLNX81ECma1FWTyOd+vzzuxCGLX4Crg7BHe+cVlxF9j1paZLogVXn60cz
         scRCoPqAsuXc+OcMfN+Iv98AJSTy8x7VAKuY2HoAuaoHv/ssYXOygPT2VnCPaLYBC6
         cEAkayThbGAb0kI/x1tcXlxM4hvpHTLV3+jT+oSk0FgK9y/XzDFp9rKMGVnYwKegfa
         V6W48A5f86Rcw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

When command interface is down, driver to reclaim all 4K page chucks that
were hold by the Firmeware. Fix a bug for 64K page size systems, where
driver repeatedly released only the first chunk of the page.

Define helper function to fill 4K chunks for a given Firmware pages.
Iterate over all unreleased Firmware pages and call the hepler per each.

Fixes: 5adff6a08862 ("net/mlx5: Fix incorrect page count when in internal e=
rror")
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/=
net/ethernet/mellanox/mlx5/core/pagealloc.c
index 150638814517..4d7f8a357df7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -422,6 +422,24 @@ static void release_all_pages(struct mlx5_core_dev *de=
v, u32 func_id,
 		      npages, ec_function, func_id);
 }
=20
+static u32 fwp_fill_manage_pages_out(struct fw_page *fwp, u32 *out, u32 in=
dex,
+				     u32 npages)
+{
+	u32 pages_set =3D 0;
+	unsigned int n;
+
+	for_each_clear_bit(n, &fwp->bitmask, MLX5_NUM_4K_IN_PAGE) {
+		MLX5_ARRAY_SET64(manage_pages_out, out, pas, index + pages_set,
+				 fwp->addr + (n * MLX5_ADAPTER_PAGE_SIZE));
+		pages_set++;
+
+		if (!--npages)
+			break;
+	}
+
+	return pages_set;
+}
+
 static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 			     u32 *in, int in_size, u32 *out, int out_size)
 {
@@ -448,8 +466,7 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 		fwp =3D rb_entry(p, struct fw_page, rb_node);
 		p =3D rb_next(p);
=20
-		MLX5_ARRAY_SET64(manage_pages_out, out, pas, i, fwp->addr);
-		i++;
+		i +=3D fwp_fill_manage_pages_out(fwp, out, i, npages - i);
 	}
=20
 	MLX5_SET(manage_pages_out, out, output_num_entries, i);
--=20
2.26.2

