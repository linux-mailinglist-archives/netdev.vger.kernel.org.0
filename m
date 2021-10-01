Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B1841F07D
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354931AbhJAPIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:31 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:6324 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1354920AbhJAPIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:30 -0400
X-IronPort-AV: E=Sophos;i="5.85,339,1624287600"; 
   d="scan'208";a="95822184"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 02 Oct 2021 00:06:45 +0900
Received: from localhost.localdomain (unknown [10.226.92.36])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 04DC34405283;
        Sat,  2 Oct 2021 00:06:42 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: [PATCH 01/10] ravb: Rename "ravb_set_features_rx_csum" function to "ravb_set_features_rcar"
Date:   Fri,  1 Oct 2021 16:06:27 +0100
Message-Id: <20211001150636.7500-2-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
References: <20211001150636.7500-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename "ravb_set_features_rx_csum" function to "ravb_set_features_rcar" and
replace the function pointer "set_rx_csum_feature" with "set_feature".

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Suggested-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
RFC->V1:
 * Added Rb tags of Sergei
---
 drivers/net/ethernet/renesas/ravb.h      |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 47c5377e4f42..7363abae6e59 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -985,7 +985,7 @@ struct ravb_hw_info {
 	void *(*alloc_rx_desc)(struct net_device *ndev, int q);
 	bool (*receive)(struct net_device *ndev, int *quota, int q);
 	void (*set_rate)(struct net_device *ndev);
-	int (*set_rx_csum_feature)(struct net_device *ndev, netdev_features_t features);
+	int (*set_feature)(struct net_device *ndev, netdev_features_t features);
 	void (*dmac_init)(struct net_device *ndev);
 	void (*emac_init)(struct net_device *ndev);
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0f85f2d97b18..8f2358caef34 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1918,8 +1918,8 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static int ravb_set_features_rx_csum(struct net_device *ndev,
-				     netdev_features_t features)
+static int ravb_set_features_rcar(struct net_device *ndev,
+				  netdev_features_t features)
 {
 	netdev_features_t changed = ndev->features ^ features;
 
@@ -1937,7 +1937,7 @@ static int ravb_set_features(struct net_device *ndev,
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
 
-	return info->set_rx_csum_feature(ndev, features);
+	return info->set_feature(ndev, features);
 }
 
 static const struct net_device_ops ravb_netdev_ops = {
@@ -2006,7 +2006,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.alloc_rx_desc = ravb_alloc_rx_desc,
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate,
-	.set_rx_csum_feature = ravb_set_features_rx_csum,
+	.set_feature = ravb_set_features_rcar,
 	.dmac_init = ravb_rcar_dmac_init,
 	.emac_init = ravb_rcar_emac_init,
 	.gstrings_stats = ravb_gstrings_stats,
@@ -2027,7 +2027,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.alloc_rx_desc = ravb_alloc_rx_desc,
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate,
-	.set_rx_csum_feature = ravb_set_features_rx_csum,
+	.set_feature = ravb_set_features_rcar,
 	.dmac_init = ravb_rcar_dmac_init,
 	.emac_init = ravb_rcar_emac_init,
 	.gstrings_stats = ravb_gstrings_stats,
-- 
2.17.1

