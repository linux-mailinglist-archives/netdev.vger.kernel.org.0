Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8AA62A4FE6
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgKCTTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:19:04 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15801 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729520AbgKCTTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:19:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1ad260000>; Tue, 03 Nov 2020 11:19:02 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:19:02 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maor Gottlieb" <maorg@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/9] net/mlx5: Fix deletion of duplicate rules
Date:   Tue, 3 Nov 2020 11:18:26 -0800
Message-ID: <20201103191830.60151-6-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103191830.60151-1-saeedm@nvidia.com>
References: <20201103191830.60151-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604431142; bh=hZw4cR2iwc3qCOadGAQRRSPM4uxfq7okWlnuj2wf6/c=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=qzY+661tp/+GYYBW/kMOiReBM+Z7tMkixweRYJnLONkCmGnpTWjJz6IlRuxzhcSuc
         SiCafnJcsrvZD1SuzZgVvkU71sA75gPnXGem/xEnYgm/XHu2jzy+wI7CnB2iLVCW54
         3RJ4lLeC5f3QE8pX3kwKlQVIgkVf+j4bGzG2r7AdyDBQRXm4OyW4L7VNtQ3/uy3y3R
         a0IyXuIPMTEW+AESSA3rT9+pnQQ72prnXGvYw3Zdg5OSiVjWKholmM5+OIIqw0CZx/
         2buRmfiVHy6fpAfgbp2DyiDwAM+wk9KjHrcbwdVmuDDEJqqxYJhspWMdoIZGxAoTmD
         ZlnuWOmMphreQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

When a rule is duplicated, the refcount of the rule is increased so only
the second deletion of the rule should cause destruction of the FTE.
Currently, the FTE will be destroyed in the first deletion of rule since
the modify_mask will be 0.
Fix it and call to destroy FTE only if all the rules (FTE's children)
have been removed.

Fixes: 718ce4d601db ("net/mlx5: Consolidate update FTE for all removal chan=
ges")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index 16091838bfcf..325a5b0d6829 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2010,10 +2010,11 @@ void mlx5_del_flow_rules(struct mlx5_flow_handle *h=
andle)
 	down_write_ref_node(&fte->node, false);
 	for (i =3D handle->num_rules - 1; i >=3D 0; i--)
 		tree_remove_node(&handle->rule[i]->node, true);
-	if (fte->modify_mask && fte->dests_size) {
-		modify_fte(fte);
+	if (fte->dests_size) {
+		if (fte->modify_mask)
+			modify_fte(fte);
 		up_write_ref_node(&fte->node, false);
-	} else {
+	} else if (list_empty(&fte->node.children)) {
 		del_hw_fte(&fte->node);
 		/* Avoid double call to del_hw_fte */
 		fte->node.del_hw_func =3D NULL;
--=20
2.26.2

