Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633433D2572
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhGVNeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:34:46 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:54735 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232363AbhGVNeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:34:06 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88414780"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:40 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 767AE401224C;
        Thu, 22 Jul 2021 23:14:37 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH net-next 12/18] ravb: Factorise {emac,dmac} init function
Date:   Thu, 22 Jul 2021 15:13:45 +0100
Message-Id: <20210722141351.13668-13-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The R-Car AVB module has Magic packet detection, multiple irq's and
timestamp enable features which is not present on RZ/G2L Gigabit
Ethernet module. Factorise emac and dmac initialization function to
support the later SoC.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  2 +
 drivers/net/ethernet/renesas/ravb_main.c | 58 ++++++++++++++++--------
 2 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index d82bfa6e57c1..4d5910dcda86 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -992,6 +992,8 @@ struct ravb_ops {
 	void (*ring_free)(struct net_device *ndev, int q);
 	void (*ring_format)(struct net_device *ndev, int q);
 	bool (*alloc_rx_desc)(struct net_device *ndev, int q);
+	void (*emac_init)(struct net_device *ndev);
+	void (*dmac_init)(struct net_device *ndev);
 };
 
 struct ravb_drv_data {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 3d0f6598b936..e200114376e4 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -454,7 +454,7 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 }
 
 /* E-MAC init function */
-static void ravb_emac_init(struct net_device *ndev)
+static void ravb_emac_init_ex(struct net_device *ndev)
 {
 	/* Receive frame limit set register */
 	ravb_write(ndev, ndev->mtu + ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN, RFLR);
@@ -480,30 +480,19 @@ static void ravb_emac_init(struct net_device *ndev)
 	ravb_write(ndev, ECSIPR_ICDIP | ECSIPR_MPDIP | ECSIPR_LCHNGIP, ECSIPR);
 }
 
-/* Device init function for Ethernet AVB */
-static int ravb_dmac_init(struct net_device *ndev)
+static void ravb_emac_init(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_drv_data *info = priv->info;
-	int error;
 
-	/* Set CONFIG mode */
-	error = ravb_config(ndev);
-	if (error)
-		return error;
-
-	error = ravb_ring_init(ndev, RAVB_BE);
-	if (error)
-		return error;
-	error = ravb_ring_init(ndev, RAVB_NC);
-	if (error) {
-		ravb_ring_free(ndev, RAVB_BE);
-		return error;
-	}
+	info->ravb_ops->emac_init(ndev);
+}
 
-	/* Descriptor format */
-	ravb_ring_format(ndev, RAVB_BE);
-	ravb_ring_format(ndev, RAVB_NC);
+/* Device init function for Ethernet AVB */
+static void ravb_dmac_init_ex(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 
 	/* Set AVB RX */
 	ravb_write(ndev,
@@ -530,6 +519,33 @@ static int ravb_dmac_init(struct net_device *ndev)
 	ravb_write(ndev, RIC2_QFE0 | RIC2_QFE1 | RIC2_RFFE, RIC2);
 	/* Frame transmitted, timestamp FIFO updated */
 	ravb_write(ndev, TIC_FTE0 | TIC_FTE1 | TIC_TFUE, TIC);
+}
+
+static int ravb_dmac_init(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
+	int error;
+
+	/* Set CONFIG mode */
+	error = ravb_config(ndev);
+	if (error)
+		return error;
+
+	error = ravb_ring_init(ndev, RAVB_BE);
+	if (error)
+		return error;
+	error = ravb_ring_init(ndev, RAVB_NC);
+	if (error) {
+		ravb_ring_free(ndev, RAVB_BE);
+		return error;
+	}
+
+	/* Descriptor format */
+	ravb_ring_format(ndev, RAVB_BE);
+	ravb_ring_format(ndev, RAVB_NC);
+
+	info->ravb_ops->dmac_init(ndev);
 
 	/* Setting the control will start the AVB-DMAC process. */
 	ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_OPERATION);
@@ -2018,6 +2034,8 @@ static const struct ravb_ops ravb_gen3_ops = {
 	.ring_free = ravb_ring_free_rx,
 	.ring_format = ravb_ring_format_rx,
 	.alloc_rx_desc = ravb_alloc_rx_desc,
+	.emac_init = ravb_emac_init_ex,
+	.dmac_init = ravb_dmac_init_ex,
 };
 
 static const struct ravb_drv_data ravb_gen3_data = {
-- 
2.17.1

