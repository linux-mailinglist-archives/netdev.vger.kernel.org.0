Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9253D2561
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhGVNeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:34:24 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:19429 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232287AbhGVNeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:34:00 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88463950"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:25 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id C5D64401224A;
        Thu, 22 Jul 2021 23:14:22 +0900 (JST)
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
Subject: [PATCH net-next 08/18] ravb: Add R-Car common features
Date:   Thu, 22 Jul 2021 15:13:41 +0100
Message-Id: <20210722141351.13668-9-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The below features are supported by both R-Car Gen2 and Gen3.

1) magic packet detection
2) multiple TSRQ support
3) extended descriptor in rx
4) No half duplex support
5) override mtu change

Add features bits to support the same.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb_main.c | 110 +++++++++++++++--------
 1 file changed, 71 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b3c99f974632..4ef2565534d2 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -45,16 +45,30 @@
 #define RAVB_MULTI_IRQS			BIT(2)
 #define RAVB_INTERNAL_DELAY		BIT(3)
 #define RAVB_TX_DROP_COUNTER		BIT(4)
+#define RAVB_MAGIC			BIT(5)
+#define RAVB_MULTI_TSRQ			BIT(6)
+#define RAVB_NO_HALF_DUPLEX		BIT(7)
+#define RAVB_OVERRIDE_MTU_CHANGE	BIT(8)
+#define RAVB_EX_RX_DESC			BIT(9)
 
 #define RAVB_PTP	(RAVB_PTP_CONFIG_ACTIVE | RAVB_PTP_CONFIG_INACTIVE)
+#define RAVB_RCAR_COMMON \
+		(RAVB_MAGIC			| \
+		 RAVB_MULTI_TSRQ		| \
+		 RAVB_NO_HALF_DUPLEX		| \
+		 RAVB_OVERRIDE_MTU_CHANGE	| \
+		 RAVB_EX_RX_DESC)
 
 #define RAVB_RCAR_GEN3_FEATURES \
 		(RAVB_PTP_CONFIG_ACTIVE		| \
 		 RAVB_MULTI_IRQS		| \
 		 RAVB_INTERNAL_DELAY		| \
-		 RAVB_TX_DROP_COUNTER)
+		 RAVB_TX_DROP_COUNTER		| \
+		 RAVB_RCAR_COMMON)
 
-#define RAVB_RCAR_GEN2_FEATURES	RAVB_PTP_CONFIG_INACTIVE
+#define RAVB_RCAR_GEN2_FEATURES \
+		(RAVB_PTP_CONFIG_INACTIVE	| \
+		 RAVB_RCAR_COMMON)
 
 static const char *ravb_rx_irqs[NUM_RX_QUEUE] = {
 	"ch0", /* RAVB_BE */
@@ -680,11 +694,14 @@ static void ravb_rcv_snd_enable(struct net_device *ndev)
 /* function for waiting dma process finished */
 static int ravb_stop_dma(struct net_device *ndev)
 {
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	int error;
 
 	/* Wait for stopping the hardware TX process */
-	error = ravb_wait(ndev, TCCR,
-			  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
+	if (info->features & RAVB_MULTI_TSRQ)
+		error = ravb_wait(ndev, TCCR,
+				  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
 	if (error)
 		return error;
 
@@ -709,12 +726,13 @@ static int ravb_stop_dma(struct net_device *ndev)
 static void ravb_emac_interrupt_unlocked(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	u32 ecsr, psr;
 
 	ecsr = ravb_read(ndev, ECSR);
 	ravb_write(ndev, ecsr, ECSR);	/* clear interrupt */
 
-	if (ecsr & ECSR_MPD)
+	if ((info->features & RAVB_MAGIC) && (ecsr & ECSR_MPD))
 		pm_wakeup_event(&priv->pdev->dev, 0);
 	if (ecsr & ECSR_ICD)
 		ndev->stats.tx_carrier_errors++;
@@ -808,11 +826,14 @@ static bool ravb_queue_interrupt(struct net_device *ndev, int q)
 
 static bool ravb_timestamp_interrupt(struct net_device *ndev)
 {
+	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	u32 tis = ravb_read(ndev, TIS);
 
 	if (tis & TIS_TFUF) {
 		ravb_write(ndev, ~(TIS_TFUF | TIS_RESERVED), TIS);
-		ravb_get_tx_tstamp(ndev);
+		if (info->features & RAVB_EX_RX_DESC)
+			ravb_get_tx_tstamp(ndev);
 		return true;
 	}
 	return false;
@@ -1024,6 +1045,7 @@ static int ravb_phy_init(struct net_device *ndev)
 {
 	struct device_node *np = ndev->dev.parent->of_node;
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	struct phy_device *phydev;
 	struct device_node *pn;
 	phy_interface_t iface;
@@ -1069,15 +1091,17 @@ static int ravb_phy_init(struct net_device *ndev)
 		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
 	}
 
-	/* 10BASE, Pause and Asym Pause is not supported */
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Pause_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
+	if (info->features & RAVB_NO_HALF_DUPLEX) {
+		/* 10BASE, Pause and Asym Pause is not supported */
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Pause_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
 
-	/* Half Duplex is not supported */
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+		/* Half Duplex is not supported */
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	}
 
 	phy_attached_info(phydev);
 
@@ -1314,8 +1338,9 @@ static void ravb_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 static int ravb_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 
-	if (wol->wolopts & ~WAKE_MAGIC)
+	if ((wol->wolopts & ~WAKE_MAGIC) || (!(info->features & RAVB_MAGIC)))
 		return -EOPNOTSUPP;
 
 	priv->wol_enabled = !!(wol->wolopts & WAKE_MAGIC);
@@ -1519,6 +1544,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	const struct ravb_drv_data *info = priv->info;
 	int num_tx_desc = priv->num_tx_desc;
 	u16 q = skb_get_queue_mapping(skb);
 	struct ravb_tstamp_skb *ts_skb;
@@ -1595,28 +1621,30 @@ static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	desc->dptr = cpu_to_le32(dma_addr);
 
 	/* TX timestamp required */
-	if (q == RAVB_NC) {
-		ts_skb = kmalloc(sizeof(*ts_skb), GFP_ATOMIC);
-		if (!ts_skb) {
-			if (num_tx_desc > 1) {
-				desc--;
-				dma_unmap_single(ndev->dev.parent, dma_addr,
-						 len, DMA_TO_DEVICE);
+	if (info->features & RAVB_EX_RX_DESC) {
+		if (q == RAVB_NC) {
+			ts_skb = kmalloc(sizeof(*ts_skb), GFP_ATOMIC);
+			if (!ts_skb) {
+				if (num_tx_desc > 1) {
+					desc--;
+					dma_unmap_single(ndev->dev.parent, dma_addr,
+							 len, DMA_TO_DEVICE);
+				}
+				goto unmap;
 			}
-			goto unmap;
+			ts_skb->skb = skb_get(skb);
+			ts_skb->tag = priv->ts_skb_tag++;
+			priv->ts_skb_tag &= 0x3ff;
+			list_add_tail(&ts_skb->list, &priv->ts_skb_list);
+
+			/* TAG and timestamp required flag */
+			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+			desc->tagh_tsr = (ts_skb->tag >> 4) | TX_TSR;
+			desc->ds_tagl |= cpu_to_le16(ts_skb->tag << 12);
 		}
-		ts_skb->skb = skb_get(skb);
-		ts_skb->tag = priv->ts_skb_tag++;
-		priv->ts_skb_tag &= 0x3ff;
-		list_add_tail(&ts_skb->list, &priv->ts_skb_list);
 
-		/* TAG and timestamp required flag */
-		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-		desc->tagh_tsr = (ts_skb->tag >> 4) | TX_TSR;
-		desc->ds_tagl |= cpu_to_le16(ts_skb->tag << 12);
+		skb_tx_timestamp(skb);
 	}
-
-	skb_tx_timestamp(skb);
 	/* Descriptor type must be set after all the above writes */
 	dma_wmb();
 	if (num_tx_desc > 1) {
@@ -1727,10 +1755,12 @@ static int ravb_close(struct net_device *ndev)
 			   "device will be stopped after h/w processes are done.\n");
 
 	/* Clear the timestamp list */
-	list_for_each_entry_safe(ts_skb, ts_skb2, &priv->ts_skb_list, list) {
-		list_del(&ts_skb->list);
-		kfree_skb(ts_skb->skb);
-		kfree(ts_skb);
+	if (info->features & RAVB_EX_RX_DESC) {
+		list_for_each_entry_safe(ts_skb, ts_skb2, &priv->ts_skb_list, list) {
+			list_del(&ts_skb->list);
+			kfree_skb(ts_skb->skb);
+			kfree(ts_skb);
+		}
 	}
 
 	/* PHY disconnect */
@@ -2205,8 +2235,10 @@ static int ravb_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(priv->refclk);
 
-	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
-	ndev->min_mtu = ETH_MIN_MTU;
+	if (info->features & RAVB_OVERRIDE_MTU_CHANGE) {
+		ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
+		ndev->min_mtu = ETH_MIN_MTU;
+	}
 
 	priv->num_tx_desc = info->num_tx_desc;
 
-- 
2.17.1

