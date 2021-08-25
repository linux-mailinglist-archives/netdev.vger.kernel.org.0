Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75433F7012
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbhHYHDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:03:35 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:35669 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239243AbhHYHDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:03:30 -0400
X-IronPort-AV: E=Sophos;i="5.84,349,1620658800"; 
   d="scan'208";a="91678782"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 25 Aug 2021 16:02:44 +0900
Received: from localhost.localdomain (unknown [10.226.92.232])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 5D9E342016B7;
        Wed, 25 Aug 2021 16:02:40 +0900 (JST)
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
Subject: [PATCH net-next 12/13] ravb: Factorise ravb_emac_init function
Date:   Wed, 25 Aug 2021 08:01:53 +0100
Message-Id: <20210825070154.14336-13-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The E-MAC IP on the R-Car AVB module has different initialization
parameters for RX frame size, duplex settings, different offset
for transfer speed setting and has magic packet detection support
compared to E-MAC on RZ/G2L Gigabit Ethernet module. Factorise
the ravb_emac_init function to support the later SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  1 +
 drivers/net/ethernet/renesas/ravb_main.c | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 24a3abd00053..117eb22349c5 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -987,6 +987,7 @@ struct ravb_hw_info {
 	void (*set_rate)(struct net_device *ndev);
 	int (*set_rx_csum_feature)(struct net_device *ndev, netdev_features_t features);
 	void (*dmac_init)(struct net_device *ndev);
+	void (*emac_init)(struct net_device *ndev);
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
 	netdev_features_t net_hw_features;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 391e7927ea08..7a144b45e41d 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -425,8 +425,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 	return -ENOMEM;
 }
 
-/* E-MAC init function */
-static void ravb_emac_init(struct net_device *ndev)
+static void ravb_rcar_emac_init(struct net_device *ndev)
 {
 	/* Receive frame limit set register */
 	ravb_write(ndev, ndev->mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN, RFLR);
@@ -452,6 +451,15 @@ static void ravb_emac_init(struct net_device *ndev)
 	ravb_write(ndev, ECSIPR_ICDIP | ECSIPR_MPDIP | ECSIPR_LCHNGIP, ECSIPR);
 }
 
+/* E-MAC init function */
+static void ravb_emac_init(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
+
+	info->emac_init(ndev);
+}
+
 static void ravb_rcar_dmac_init(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -1999,6 +2007,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.set_rate = ravb_set_rate,
 	.set_rx_csum_feature = ravb_set_features_rx_csum,
 	.dmac_init = ravb_rcar_dmac_init,
+	.emac_init = ravb_rcar_emac_init,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
@@ -2019,6 +2028,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.set_rate = ravb_set_rate,
 	.set_rx_csum_feature = ravb_set_features_rx_csum,
 	.dmac_init = ravb_rcar_dmac_init,
+	.emac_init = ravb_rcar_emac_init,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
-- 
2.17.1

