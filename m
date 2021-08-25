Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D0B3F700D
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 09:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbhHYHDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 03:03:30 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:16704 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239284AbhHYHDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 03:03:19 -0400
X-IronPort-AV: E=Sophos;i="5.84,349,1620658800"; 
   d="scan'208";a="91678742"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 25 Aug 2021 16:02:33 +0900
Received: from localhost.localdomain (unknown [10.226.92.232])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 1FBEC4202141;
        Wed, 25 Aug 2021 16:02:29 +0900 (JST)
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
Subject: [PATCH net-next 09/13] ravb: Factorise ravb_adjust_link function
Date:   Wed, 25 Aug 2021 08:01:50 +0100
Message-Id: <20210825070154.14336-10-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
References: <20210825070154.14336-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R-Car supports 100 and 1000 Mbps transfer speed whereas RZ/G2L
in addition support 10Mbps. Factorise ravb_adjust_link function
in order to support 10Mbps speed.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      | 1 +
 drivers/net/ethernet/renesas/ravb_main.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 00f2d67b4dad..9879690c5cd8 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -984,6 +984,7 @@ struct ravb_hw_info {
 	void (*rx_ring_format)(struct net_device *ndev, int q);
 	void *(*alloc_rx_desc)(struct net_device *ndev, int q);
 	bool (*receive)(struct net_device *ndev, int *quota, int q);
+	void (*set_rate)(struct net_device *ndev);
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
 	size_t gstrings_size;
 	netdev_features_t net_hw_features;
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 1cace5324261..1f9d9f54bf1b 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -996,6 +996,7 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 static void ravb_adjust_link(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_hw_info *info = priv->info;
 	struct phy_device *phydev = ndev->phydev;
 	bool new_state = false;
 	unsigned long flags;
@@ -1010,7 +1011,7 @@ static void ravb_adjust_link(struct net_device *ndev)
 		if (phydev->speed != priv->speed) {
 			new_state = true;
 			priv->speed = phydev->speed;
-			ravb_set_rate(ndev);
+			info->set_rate(ndev);
 		}
 		if (!priv->link) {
 			ravb_modify(ndev, ECMR, ECMR_TXF, 0);
@@ -1978,6 +1979,7 @@ static const struct ravb_hw_info ravb_gen3_hw_info = {
 	.rx_ring_format = ravb_rx_ring_format,
 	.alloc_rx_desc = ravb_alloc_rx_desc,
 	.receive = ravb_rcar_rx,
+	.set_rate = ravb_set_rate,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
@@ -1995,6 +1997,7 @@ static const struct ravb_hw_info ravb_gen2_hw_info = {
 	.rx_ring_format = ravb_rx_ring_format,
 	.alloc_rx_desc = ravb_alloc_rx_desc,
 	.receive = ravb_rcar_rx,
+	.set_rate = ravb_set_rate,
 	.gstrings_stats = ravb_gstrings_stats,
 	.gstrings_size = sizeof(ravb_gstrings_stats),
 	.net_hw_features = NETIF_F_RXCSUM,
-- 
2.17.1

