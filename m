Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7E63F700E
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239363AbhHYHDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:03:31 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:27200 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239316AbhHYHDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:03:22 -0400
X-IronPort-AV: E=Sophos;i="5.84,349,1620658800"; 
   d="scan'208";a="91678758"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 25 Aug 2021 16:02:36 +0900
Received: from localhost.localdomain (unknown [10.226.92.232])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 900114202141;
        Wed, 25 Aug 2021 16:02:33 +0900 (JST)
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
Subject: [PATCH net-next 10/13] ravb: Factorise ravb_set_features
Date:   Wed, 25 Aug 2021 08:01:51 +0100
Message-Id: <20210825070154.14336-11-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RZ/G2L supports HW checksum on RX and TX whereas R-Car supports on RX.
Factorise ravb_set_features to support this feature.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 9879690c5cd8..9e284238ed83 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -985,6 +985,7 @@ struct ravb_hw_info {
 	void *(*alloc_rx_desc)(struct net_device *ndev, int q);
 	bool (*receive)(struct net_device *ndev, int *quota, int q);
 	void (*set_rate)(struct net_device *ndev);
+	int (*set_rx_csum_feature)(struct net_device *ndev, netdev_features_t features);
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
 	netdev_features_t net_hw_features;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 1f9d9f54bf1b..1789309c4c03 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1901,8 +1901,8 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-static int ravb_set_features(struct net_device *ndev,
-			     netdev_features_t features)
+static int ravb_set_features_rx_csum(struct net_device *ndev,
+				     netdev_features_t features)
 {
 	netdev_features_t changed = ndev->features ^ features;
 
@@ -1914,6 +1914,15 @@ static int ravb_set_features(struct net_device *ndev,
 	return 0;
 }
 
+static int ravb_set_features(struct net_device *ndev,
+			     netdev_features_t features)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
+
+	return info->set_rx_csum_feature(ndev, features);
+}
+
 static const struct net_device_ops ravb_netdev_ops = {
 	.ndo_open		= ravb_open,
 	.ndo_stop		= ravb_close,
@@ -1980,6 +1989,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.alloc_rx_desc = ravb_alloc_rx_desc,
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate,
+	.set_rx_csum_feature = ravb_set_features_rx_csum,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
@@ -1998,6 +2008,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.alloc_rx_desc = ravb_alloc_rx_desc,
 	.receive = ravb_rcar_rx,
 	.set_rate = ravb_set_rate,
+	.set_rx_csum_feature = ravb_set_features_rx_csum,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
-- 
2.17.1

