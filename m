Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2BF691CB0
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbjBJK2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBJK2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:28:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864D828856;
        Fri, 10 Feb 2023 02:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676024923; x=1707560923;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IxGmmqawE3oybx77EFoxFJx4YtPmytQPLBDLfM0d8Sk=;
  b=k2gqBUXAPYEkSuWiS8GYcafowzLZuiwJHeO3+ydVpeuofaHfgVCwsCcz
   iTFtkPcsZglRJdJ/tNd0GKjMqGnouocOmndJTJ112Coyfcw8qAVeVG/xR
   laNTbEEcUFLy0CiHzeCzZHXzyGXgggkCC4h+Ro/HZ0vgsDcteelmQ8Nv1
   DyfdXrBSqzwNttb6AvWI9w0FcOwHfGwkGVS6MCEGrf/G171lDQTznnk/M
   gu3yueQz0818MxDvzeB5q5yYUaq7oycG32m7s7mt80UwUxIFPm04NLqvW
   ET3She4ddhCdKMucNyDYdzDoOpM2PUIEijW4plX9cIA+22SbKT3sbisXZ
   w==;
X-IronPort-AV: E=Sophos;i="5.97,286,1669100400"; 
   d="scan'208";a="211407272"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2023 03:28:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 03:28:42 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 03:28:39 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: micrel: Add PHC support for lan8841
Date:   Fri, 10 Feb 2023 11:27:01 +0100
Message-ID: <20230210102701.703569-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for PHC and timestamping operations for the lan8841 PHY.
PTP 1-step and 2-step modes are supported, over Ethernet and UDP both
ipv4 and ipv6.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 623 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 599 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 727de4f4a14db..330c76328da04 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -313,6 +313,11 @@ struct kszphy_ptp_priv {
 	enum hwtstamp_rx_filters rx_filter;
 	int layer;
 	int version;
+
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_clock_info;
+	/* Lock for ptp_clock */
+	struct mutex ptp_lock;
 };
 
 struct kszphy_priv {
@@ -2398,8 +2403,8 @@ static void lan8814_get_sig_rx(struct sk_buff *skb, u16 *sig)
 	*sig = (__force u16)(ntohs(ptp_header->sequence_id));
 }
 
-static bool lan8814_match_rx_ts(struct kszphy_ptp_priv *ptp_priv,
-				struct sk_buff *skb)
+static bool lan8814_match_rx_skb(struct kszphy_ptp_priv *ptp_priv,
+				 struct sk_buff *skb)
 {
 	struct skb_shared_hwtstamps *shhwtstamps;
 	struct lan8814_ptp_rx_ts *rx_ts, *tmp;
@@ -2448,7 +2453,7 @@ static bool lan8814_rxtstamp(struct mii_timestamper *mii_ts, struct sk_buff *skb
 	/* If we failed to match then add it to the queue for when the timestamp
 	 * will come
 	 */
-	if (!lan8814_match_rx_ts(ptp_priv, skb))
+	if (!lan8814_match_rx_skb(ptp_priv, skb))
 		skb_queue_tail(&ptp_priv->rx_queue, skb);
 
 	return true;
@@ -2698,18 +2703,14 @@ static void lan8814_get_sig_tx(struct sk_buff *skb, u16 *sig)
 	*sig = (__force u16)(ntohs(ptp_header->sequence_id));
 }
 
-static void lan8814_dequeue_tx_skb(struct kszphy_ptp_priv *ptp_priv)
+static void lan8814_match_tx_skb(struct kszphy_ptp_priv *ptp_priv,
+				 u32 seconds, u32 nsec, u16 seq_id)
 {
-	struct phy_device *phydev = ptp_priv->phydev;
 	struct skb_shared_hwtstamps shhwtstamps;
 	struct sk_buff *skb, *skb_tmp;
 	unsigned long flags;
-	u32 seconds, nsec;
 	bool ret = false;
 	u16 skb_sig;
-	u16 seq_id;
-
-	lan8814_ptp_tx_ts_get(phydev, &seconds, &nsec, &seq_id);
 
 	spin_lock_irqsave(&ptp_priv->tx_queue.lock, flags);
 	skb_queue_walk_safe(&ptp_priv->tx_queue, skb, skb_tmp) {
@@ -2731,6 +2732,16 @@ static void lan8814_dequeue_tx_skb(struct kszphy_ptp_priv *ptp_priv)
 	}
 }
 
+static void lan8814_dequeue_tx_skb(struct kszphy_ptp_priv *ptp_priv)
+{
+	struct phy_device *phydev = ptp_priv->phydev;
+	u32 seconds, nsec;
+	u16 seq_id;
+
+	lan8814_ptp_tx_ts_get(phydev, &seconds, &nsec, &seq_id);
+	lan8814_match_tx_skb(ptp_priv, seconds, nsec, seq_id);
+}
+
 static void lan8814_get_tx_ts(struct kszphy_ptp_priv *ptp_priv)
 {
 	struct phy_device *phydev = ptp_priv->phydev;
@@ -2779,11 +2790,27 @@ static bool lan8814_match_skb(struct kszphy_ptp_priv *ptp_priv,
 	return ret;
 }
 
+static void lan8814_match_rx_ts(struct kszphy_ptp_priv *ptp_priv,
+				struct lan8814_ptp_rx_ts *rx_ts)
+{
+	unsigned long flags;
+
+	/* If we failed to match the skb add it to the queue for when
+	 * the frame will come
+	 */
+	if (!lan8814_match_skb(ptp_priv, rx_ts)) {
+		spin_lock_irqsave(&ptp_priv->rx_ts_lock, flags);
+		list_add(&rx_ts->list, &ptp_priv->rx_ts_list);
+		spin_unlock_irqrestore(&ptp_priv->rx_ts_lock, flags);
+	} else {
+		kfree(rx_ts);
+	}
+}
+
 static void lan8814_get_rx_ts(struct kszphy_ptp_priv *ptp_priv)
 {
 	struct phy_device *phydev = ptp_priv->phydev;
 	struct lan8814_ptp_rx_ts *rx_ts;
-	unsigned long flags;
 	u32 reg;
 
 	do {
@@ -2793,17 +2820,7 @@ static void lan8814_get_rx_ts(struct kszphy_ptp_priv *ptp_priv)
 
 		lan8814_ptp_rx_ts_get(phydev, &rx_ts->seconds, &rx_ts->nsec,
 				      &rx_ts->seq_id);
-
-		/* If we failed to match the skb add it to the queue for when
-		 * the frame will come
-		 */
-		if (!lan8814_match_skb(ptp_priv, rx_ts)) {
-			spin_lock_irqsave(&ptp_priv->rx_ts_lock, flags);
-			list_add(&rx_ts->list, &ptp_priv->rx_ts_list);
-			spin_unlock_irqrestore(&ptp_priv->rx_ts_lock, flags);
-		} else {
-			kfree(rx_ts);
-		}
+		lan8814_match_rx_ts(ptp_priv, rx_ts);
 
 		/* If other timestamps are available in the FIFO,
 		 * process them.
@@ -3192,6 +3209,16 @@ static int lan8814_probe(struct phy_device *phydev)
 #define LAN8841_BTRX_POWER_DOWN_BTRX_CH_C	BIT(5)
 #define LAN8841_BTRX_POWER_DOWN_BTRX_CH_D	BIT(7)
 #define LAN8841_ADC_CHANNEL_MASK		198
+#define LAN8841_PTP_RX_PARSE_L2_ADDR_EN		370
+#define LAN8841_PTP_RX_PARSE_IP_ADDR_EN		371
+#define LAN8841_PTP_TX_PARSE_L2_ADDR_EN		434
+#define LAN8841_PTP_TX_PARSE_IP_ADDR_EN		435
+#define LAN8841_PTP_CMD_CTL			256
+#define LAN8841_PTP_CMD_CTL_PTP_ENABLE		BIT(2)
+#define LAN8841_PTP_CMD_CTL_PTP_DISABLE		BIT(1)
+#define LAN8841_PTP_CMD_CTL_PTP_RESET		BIT(0)
+#define LAN8841_PTP_RX_PARSE_CONFIG		368
+#define LAN8841_PTP_TX_PARSE_CONFIG		432
 
 static int lan8841_config_init(struct phy_device *phydev)
 {
@@ -3201,6 +3228,31 @@ static int lan8841_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	/* Initialize the HW by resetting everything */
+	phy_modify_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+		       LAN8841_PTP_CMD_CTL,
+		       LAN8841_PTP_CMD_CTL_PTP_RESET,
+		       LAN8841_PTP_CMD_CTL_PTP_RESET);
+
+	phy_modify_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+		       LAN8841_PTP_CMD_CTL,
+		       LAN8841_PTP_CMD_CTL_PTP_ENABLE,
+		       LAN8841_PTP_CMD_CTL_PTP_ENABLE);
+
+	/* Don't process any frames */
+	phy_write_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+		      LAN8841_PTP_RX_PARSE_CONFIG, 0);
+	phy_write_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+		      LAN8841_PTP_TX_PARSE_CONFIG, 0);
+	phy_write_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+		      LAN8841_PTP_TX_PARSE_L2_ADDR_EN, 0);
+	phy_write_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+		      LAN8841_PTP_RX_PARSE_L2_ADDR_EN, 0);
+	phy_write_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+		      LAN8841_PTP_TX_PARSE_IP_ADDR_EN, 0);
+	phy_write_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+		      LAN8841_PTP_RX_PARSE_IP_ADDR_EN, 0);
+
 	/* 100BT Clause 40 improvenent errata */
 	phy_write_mmd(phydev, LAN8841_MMD_ANALOG_REG,
 		      LAN8841_ANALOG_CONTROL_1,
@@ -3246,6 +3298,7 @@ static int lan8841_config_init(struct phy_device *phydev)
 
 #define LAN8841_OUTPUT_CTRL			25
 #define LAN8841_OUTPUT_CTRL_INT_BUFFER		BIT(14)
+#define LAN8841_INT_PTP				BIT(9)
 
 static int lan8841_config_intr(struct phy_device *phydev)
 {
@@ -3259,8 +3312,13 @@ static int lan8841_config_intr(struct phy_device *phydev)
 		if (err)
 			return err;
 
+		/* Enable / disable interrupts. It is OK to enable PTP interrupt
+		 * even if it PTP is not enabled. Because the underneath blocks
+		 * will not enable the PTP so we will never get the PTP
+		 * interrupt.
+		 */
 		err = phy_write(phydev, LAN8814_INTC,
-				LAN8814_INT_LINK);
+				LAN8814_INT_LINK | LAN8841_INT_PTP);
 	} else {
 		err = phy_write(phydev, LAN8814_INTC, 0);
 		if (err)
@@ -3272,8 +3330,140 @@ static int lan8841_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+#define LAN8841_PTP_TX_EGRESS_SEC_LO			453
+#define LAN8841_PTP_TX_EGRESS_SEC_HI			452
+#define LAN8841_PTP_TX_EGRESS_NS_LO			451
+#define LAN8841_PTP_TX_EGRESS_NS_HI			450
+#define LAN8841_PTP_TX_EGRESS_NSEC_HI_VALID		BIT(15)
+#define LAN8841_PTP_TX_MSG_HEADER2			455
+
+static bool lan8841_ptp_get_tx_ts(struct kszphy_ptp_priv *ptp_priv,
+				  u32 *sec, u32 *nsec, u16 *seq)
+{
+	struct phy_device *phydev = ptp_priv->phydev;
+
+	*nsec = phy_read_mmd(phydev, 2, LAN8841_PTP_TX_EGRESS_NS_HI);
+	if (!(*nsec & LAN8841_PTP_TX_EGRESS_NSEC_HI_VALID))
+		return false;
+
+	*nsec = ((*nsec & 0x3fff) << 16);
+	*nsec = *nsec | phy_read_mmd(phydev, 2, LAN8841_PTP_TX_EGRESS_NS_LO);
+
+	*sec = phy_read_mmd(phydev, 2, LAN8841_PTP_TX_EGRESS_SEC_HI);
+	*sec = *sec << 16;
+	*sec = *sec | phy_read_mmd(phydev, 2, LAN8841_PTP_TX_EGRESS_SEC_LO);
+
+	*seq = phy_read_mmd(phydev, 2, LAN8841_PTP_TX_MSG_HEADER2);
+
+	return true;
+}
+
+static void lan8841_ptp_process_tx_ts(struct kszphy_ptp_priv *ptp_priv)
+{
+	u32 sec, nsec;
+	u16 seq;
+
+	while (lan8841_ptp_get_tx_ts(ptp_priv, &sec, &nsec, &seq))
+		lan8814_match_tx_skb(ptp_priv, sec, nsec, seq);
+}
+
+#define LAN8841_PTP_RX_INGRESS_SEC_LO			389
+#define LAN8841_PTP_RX_INGRESS_SEC_HI			388
+#define LAN8841_PTP_RX_INGRESS_NS_LO			387
+#define LAN8841_PTP_RX_INGRESS_NS_HI			386
+#define LAN8841_PTP_RX_INGRESS_NSEC_HI_VALID		BIT(15)
+#define LAN8841_PTP_RX_MSG_HEADER2			391
+
+static struct lan8814_ptp_rx_ts *lan8841_ptp_get_rx_ts(struct kszphy_ptp_priv *ptp_priv)
+{
+	struct phy_device *phydev = ptp_priv->phydev;
+	struct lan8814_ptp_rx_ts *rx_ts;
+	u32 sec, nsec;
+	u16 seq;
+
+	nsec = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_NS_HI);
+	if (!(nsec & LAN8841_PTP_RX_INGRESS_NSEC_HI_VALID))
+		return NULL;
+
+	nsec = ((nsec & 0x3fff) << 16);
+	nsec = nsec | phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_NS_LO);
+
+	sec = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_SEC_HI);
+	sec = sec << 16;
+	sec = sec | phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_SEC_LO);
+
+	seq = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_MSG_HEADER2);
+
+	rx_ts = kzalloc(sizeof(*rx_ts), GFP_KERNEL);
+	if (!rx_ts)
+		return NULL;
+
+	rx_ts->seconds = sec;
+	rx_ts->nsec = nsec;
+	rx_ts->seq_id = seq;
+
+	return rx_ts;
+}
+
+static void lan8841_ptp_process_rx_ts(struct kszphy_ptp_priv *ptp_priv)
+{
+	struct lan8814_ptp_rx_ts *rx_ts;
+
+	while ((rx_ts = lan8841_ptp_get_rx_ts(ptp_priv)) != NULL)
+		lan8814_match_rx_ts(ptp_priv, rx_ts);
+}
+
+#define LAN8841_PTP_INT_STS			259
+#define LAN8841_PTP_INT_STS_PTP_TX_TS_OVRFL_INT	BIT(13)
+#define LAN8841_PTP_INT_STS_PTP_TX_TS_INT	BIT(12)
+#define LAN8841_PTP_INT_STS_PTP_RX_TS_OVRFL_INT	BIT(9)
+#define LAN8841_PTP_INT_STS_PTP_RX_TS_INT	BIT(8)
+
+static void lan8841_ptp_flush_fifo(struct kszphy_ptp_priv *ptp_priv, bool egress)
+{
+	struct phy_device *phydev = ptp_priv->phydev;
+	int i;
+
+	for (i = 0; i < FIFO_SIZE; ++i)
+		phy_read_mmd(phydev, 2,
+			     egress ? LAN8841_PTP_TX_MSG_HEADER2 :
+				      LAN8841_PTP_RX_MSG_HEADER2);
+
+	phy_read_mmd(phydev, 2, LAN8841_PTP_INT_STS);
+}
+
+static void lan8841_handle_ptp_interrupt(struct phy_device *phydev)
+{
+	struct kszphy_priv *priv = phydev->priv;
+	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
+	u16 status;
+
+	do {
+		status = phy_read_mmd(phydev, 2, LAN8841_PTP_INT_STS);
+		if (status & LAN8841_PTP_INT_STS_PTP_TX_TS_INT)
+			lan8841_ptp_process_tx_ts(ptp_priv);
+
+		if (status & LAN8841_PTP_INT_STS_PTP_RX_TS_INT)
+			lan8841_ptp_process_rx_ts(ptp_priv);
+
+		if (status & LAN8841_PTP_INT_STS_PTP_TX_TS_OVRFL_INT) {
+			lan8841_ptp_flush_fifo(ptp_priv, true);
+			skb_queue_purge(&ptp_priv->tx_queue);
+		}
+
+		if (status & LAN8841_PTP_INT_STS_PTP_RX_TS_OVRFL_INT) {
+			lan8841_ptp_flush_fifo(ptp_priv, false);
+			skb_queue_purge(&ptp_priv->rx_queue);
+		}
+
+	} while (status);
+}
+
+#define LAN8841_INTS_PTP		BIT(9)
+
 static irqreturn_t lan8841_handle_interrupt(struct phy_device *phydev)
 {
+	irqreturn_t ret = IRQ_NONE;
 	int irq_status;
 
 	irq_status = phy_read(phydev, LAN8814_INTS);
@@ -3284,17 +3474,368 @@ static irqreturn_t lan8841_handle_interrupt(struct phy_device *phydev)
 
 	if (irq_status & LAN8814_INT_LINK) {
 		phy_trigger_machine(phydev);
-		return IRQ_HANDLED;
+		ret = IRQ_HANDLED;
 	}
 
-	return IRQ_NONE;
+	if (irq_status & LAN8841_INTS_PTP) {
+		lan8841_handle_ptp_interrupt(phydev);
+		ret = IRQ_HANDLED;
+	}
+
+	return ret;
 }
 
+static int lan8841_ts_info(struct mii_timestamper *mii_ts,
+			   struct ethtool_ts_info *info)
+{
+	struct kszphy_ptp_priv *ptp_priv;
+
+	ptp_priv = container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
+
+	info->phc_index = ptp_priv->ptp_clock ?
+				ptp_clock_index(ptp_priv->ptp_clock) : -1;
+	if (info->phc_index == -1) {
+		info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
+					 SOF_TIMESTAMPING_RX_SOFTWARE |
+					 SOF_TIMESTAMPING_SOFTWARE;
+		return 0;
+	}
+
+	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
+			 (1 << HWTSTAMP_TX_ON) |
+			 (1 << HWTSTAMP_TX_ONESTEP_SYNC);
+
+	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
+			   (1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
+			   (1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+			   (1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
+
+	return 0;
+}
+
+#define LAN8841_PTP_INT_EN			260
+#define LAN8841_PTP_INT_EN_PTP_TX_TS_OVRFL_EN	BIT(13)
+#define LAN8841_PTP_INT_EN_PTP_TX_TS_EN		BIT(12)
+#define LAN8841_PTP_INT_EN_PTP_RX_TS_OVRFL_EN	BIT(9)
+#define LAN8841_PTP_INT_EN_PTP_RX_TS_EN		BIT(8)
+
+static void lan8841_ptp_enable_int(struct kszphy_ptp_priv *ptp_priv,
+				   bool enable)
+{
+	struct phy_device *phydev = ptp_priv->phydev;
+
+	if (enable)
+		/* Enable interrupts */
+		phy_modify_mmd(phydev, 2, LAN8841_PTP_INT_EN,
+			       LAN8841_PTP_INT_EN_PTP_TX_TS_OVRFL_EN |
+			       LAN8841_PTP_INT_EN_PTP_RX_TS_OVRFL_EN |
+			       LAN8841_PTP_INT_EN_PTP_TX_TS_EN |
+			       LAN8841_PTP_INT_EN_PTP_RX_TS_EN,
+			       LAN8841_PTP_INT_EN_PTP_TX_TS_OVRFL_EN |
+			       LAN8841_PTP_INT_EN_PTP_RX_TS_OVRFL_EN |
+			       LAN8841_PTP_INT_EN_PTP_TX_TS_EN |
+			       LAN8841_PTP_INT_EN_PTP_RX_TS_EN);
+	else
+		/* Disable interrupts */
+		phy_modify_mmd(phydev, 2, LAN8841_PTP_INT_EN,
+			       LAN8841_PTP_INT_EN_PTP_TX_TS_OVRFL_EN |
+			       LAN8841_PTP_INT_EN_PTP_RX_TS_OVRFL_EN |
+			       LAN8841_PTP_INT_EN_PTP_TX_TS_EN |
+			       LAN8841_PTP_INT_EN_PTP_RX_TS_EN, 0);
+}
+
+#define LAN8841_PTP_RX_TIMESTAMP_EN		379
+#define LAN8841_PTP_TX_TIMESTAMP_EN		443
+#define LAN8841_PTP_TX_MOD			445
+
+static int lan8841_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
+{
+	struct kszphy_ptp_priv *ptp_priv = container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
+	struct phy_device *phydev = ptp_priv->phydev;
+	struct lan8814_ptp_rx_ts *rx_ts, *tmp;
+	struct hwtstamp_config config;
+	int txcfg = 0, rxcfg = 0;
+	int pkt_ts_enable;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	ptp_priv->hwts_tx_type = config.tx_type;
+	ptp_priv->rx_filter = config.rx_filter;
+
+	switch (config.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		ptp_priv->layer = 0;
+		ptp_priv->version = 0;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		ptp_priv->layer = PTP_CLASS_L4;
+		ptp_priv->version = PTP_CLASS_V2;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		ptp_priv->layer = PTP_CLASS_L2;
+		ptp_priv->version = PTP_CLASS_V2;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		ptp_priv->layer = PTP_CLASS_L4 | PTP_CLASS_L2;
+		ptp_priv->version = PTP_CLASS_V2;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	/* Setup parsing of the frames and enable the timestamping for ptp
+	 * frames
+	 */
+	if (ptp_priv->layer & PTP_CLASS_L2) {
+		rxcfg |= PTP_RX_PARSE_CONFIG_LAYER2_EN_;
+		txcfg |= PTP_TX_PARSE_CONFIG_LAYER2_EN_;
+	} else if (ptp_priv->layer & PTP_CLASS_L4) {
+		rxcfg |= PTP_RX_PARSE_CONFIG_IPV4_EN_ | PTP_RX_PARSE_CONFIG_IPV6_EN_;
+		txcfg |= PTP_TX_PARSE_CONFIG_IPV4_EN_ | PTP_TX_PARSE_CONFIG_IPV6_EN_;
+	}
+
+	phy_write_mmd(phydev, 2, LAN8841_PTP_RX_PARSE_CONFIG, rxcfg);
+	phy_write_mmd(phydev, 2, LAN8841_PTP_TX_PARSE_CONFIG, txcfg);
+
+	pkt_ts_enable = PTP_TIMESTAMP_EN_SYNC_ | PTP_TIMESTAMP_EN_DREQ_ |
+			PTP_TIMESTAMP_EN_PDREQ_ | PTP_TIMESTAMP_EN_PDRES_;
+	phy_write_mmd(phydev, 2, LAN8841_PTP_RX_TIMESTAMP_EN, pkt_ts_enable);
+	phy_write_mmd(phydev, 2, LAN8841_PTP_TX_TIMESTAMP_EN, pkt_ts_enable);
+
+	/* Enable / disable of the TX timestamp in the SYNC frames */
+	phy_modify_mmd(phydev, 2, LAN8841_PTP_TX_MOD,
+		       PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_,
+		       ptp_priv->hwts_tx_type == HWTSTAMP_TX_ONESTEP_SYNC ?
+				PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_ : 0);
+
+	/* Now enable/disable the timestamping */
+	lan8841_ptp_enable_int(ptp_priv,
+			       config.rx_filter != HWTSTAMP_FILTER_NONE);
+
+	/* In case of multiple starts and stops, these needs to be cleared */
+	list_for_each_entry_safe(rx_ts, tmp, &ptp_priv->rx_ts_list, list) {
+		list_del(&rx_ts->list);
+		kfree(rx_ts);
+	}
+
+	skb_queue_purge(&ptp_priv->rx_queue);
+	skb_queue_purge(&ptp_priv->tx_queue);
+
+	lan8841_ptp_flush_fifo(ptp_priv, false);
+	lan8841_ptp_flush_fifo(ptp_priv, true);
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ? -EFAULT : 0;
+}
+
+#define LAN8841_PTP_LTC_SET_SEC_HI	262
+#define LAN8841_PTP_LTC_SET_SEC_MID	263
+#define LAN8841_PTP_LTC_SET_SEC_LO	264
+#define LAN8841_PTP_LTC_SET_NS_HI	265
+#define LAN8841_PTP_LTC_SET_NS_LO	266
+#define LAN8841_PTP_CMD_CTL_PTP_LTC_LOAD	BIT(4)
+
+static int lan8841_ptp_settime64(struct ptp_clock_info *ptp,
+				 const struct timespec64 *ts)
+{
+	struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
+							ptp_clock_info);
+	struct phy_device *phydev = ptp_priv->phydev;
+
+	/* Set the value to be stored */
+	mutex_lock(&ptp_priv->ptp_lock);
+	phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_SET_SEC_LO, lower_16_bits(ts->tv_sec));
+	phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_SET_SEC_MID, upper_16_bits(ts->tv_sec));
+	phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_SET_SEC_HI, upper_32_bits(ts->tv_sec) & 0xffff);
+	phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_SET_NS_LO, lower_16_bits(ts->tv_nsec));
+	phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_SET_NS_HI, upper_16_bits(ts->tv_nsec) & 0x3fff);
+
+	/* Set the command to load the LTC */
+	phy_write_mmd(phydev, 2, LAN8841_PTP_CMD_CTL,
+		      LAN8841_PTP_CMD_CTL_PTP_LTC_LOAD);
+	mutex_unlock(&ptp_priv->ptp_lock);
+
+	return 0;
+}
+
+#define LAN8841_PTP_LTC_RD_SEC_HI	358
+#define LAN8841_PTP_LTC_RD_SEC_MID	359
+#define LAN8841_PTP_LTC_RD_SEC_LO	360
+#define LAN8841_PTP_LTC_RD_NS_HI	361
+#define LAN8841_PTP_LTC_RD_NS_LO	362
+#define LAN8841_PTP_CMD_CTL_PTP_LTC_READ	BIT(3)
+
+static int lan8841_ptp_gettime64(struct ptp_clock_info *ptp,
+				 struct timespec64 *ts)
+{
+	struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
+							ptp_clock_info);
+	struct phy_device *phydev = ptp_priv->phydev;
+	time64_t s;
+	s64 ns;
+
+	mutex_lock(&ptp_priv->ptp_lock);
+	/* Issue the command to read the LTC */
+	phy_write_mmd(phydev, 2, LAN8841_PTP_CMD_CTL,
+		      LAN8841_PTP_CMD_CTL_PTP_LTC_READ);
+
+	/* Read the LTC */
+	s = phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_SEC_HI);
+	s <<= 16;
+	s |= phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_SEC_MID);
+	s <<= 16;
+	s |= phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_SEC_LO);
+
+	ns = phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_NS_HI) & 0x3fff;
+	ns <<= 16;
+	ns |= phy_read_mmd(phydev, 2, LAN8841_PTP_LTC_RD_NS_LO);
+	mutex_unlock(&ptp_priv->ptp_lock);
+
+	set_normalized_timespec64(ts, s, ns);
+	return 0;
+}
+
+#define LAN8841_PTP_LTC_STEP_ADJ_LO			276
+#define LAN8841_PTP_LTC_STEP_ADJ_HI			275
+#define LAN8841_PTP_LTC_STEP_ADJ_DIR			BIT(15)
+#define LAN8841_PTP_CMD_CTL_PTP_LTC_STEP_SECONDS	BIT(5)
+#define LAN8841_PTP_CMD_CTL_PTP_LTC_STEP_NANOSECONDS	BIT(6)
+
+static int lan8841_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
+							ptp_clock_info);
+	struct phy_device *phydev = ptp_priv->phydev;
+	struct timespec64 ts;
+	bool add = true;
+	u32 nsec;
+	s32 sec;
+
+	/* The HW allows up to 15 sec to adjust the time, but here we limit to
+	 * 10 sec the adjustment. The reason is, in case the adjustment is 14
+	 * sec and 999999999 nsec, then we add 8ns to compansate the actual
+	 * increment so the value can be bigger than 15 sec. Therefore limit the
+	 * possible adjustments so we will not have these corner cases
+	 */
+	if (delta > 10000000000LL || delta < -10000000000LL) {
+		/* The timeadjustment is too big, so fall back using set time */
+		u64 now;
+
+		ptp->gettime64(ptp, &ts);
+
+		now = ktime_to_ns(timespec64_to_ktime(ts));
+		ts = ns_to_timespec64(now + delta);
+
+		ptp->settime64(ptp, &ts);
+		return 0;
+	}
+
+	sec = div_u64_rem(delta < 0 ? -delta : delta, NSEC_PER_SEC, &nsec);
+	if (delta < 0 && nsec != 0) {
+		/* It is not allowed to adjust low the nsec part, therefore
+		 * subtract more from second part and add to nanosecond such
+		 * that would roll over, so the second part will increase
+		 */
+		sec--;
+		nsec = NSEC_PER_SEC - nsec;
+	}
+
+	/* Calculate the adjustments and the direction */
+	if (delta < 0)
+		add = false;
+
+	if (nsec > 0)
+		/* add 8 ns to cover the likely normal increment */
+		nsec += 8;
+
+	if (nsec >= NSEC_PER_SEC) {
+		/* carry into seconds */
+		sec++;
+		nsec -= NSEC_PER_SEC;
+	}
+
+	mutex_lock(&ptp_priv->ptp_lock);
+	if (sec) {
+		phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_STEP_ADJ_LO, sec);
+		phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_STEP_ADJ_HI,
+			      add ? LAN8841_PTP_LTC_STEP_ADJ_DIR : 0);
+		phy_write_mmd(phydev, 2, LAN8841_PTP_CMD_CTL,
+			      LAN8841_PTP_CMD_CTL_PTP_LTC_STEP_SECONDS);
+	}
+
+	if (nsec) {
+		phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_STEP_ADJ_LO,
+			      nsec & 0xffff);
+		phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_STEP_ADJ_HI,
+			      (nsec >> 16) & 0x3fff);
+		phy_write_mmd(phydev, 2, LAN8841_PTP_CMD_CTL,
+			      LAN8841_PTP_CMD_CTL_PTP_LTC_STEP_NANOSECONDS);
+	}
+	mutex_unlock(&ptp_priv->ptp_lock);
+
+	return 0;
+}
+
+#define LAN8841_PTP_LTC_RATE_ADJ_HI		269
+#define LAN8841_PTP_LTC_RATE_ADJ_HI_DIR		BIT(15)
+#define LAN8841_PTP_LTC_RATE_ADJ_LO		270
+
+static int lan8841_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
+							ptp_clock_info);
+	struct phy_device *phydev = ptp_priv->phydev;
+	bool faster = true;
+	u32 rate;
+
+	if (!scaled_ppm)
+		return 0;
+
+	if (scaled_ppm < 0) {
+		scaled_ppm = -scaled_ppm;
+		faster = false;
+	}
+
+	rate = LAN8814_1PPM_FORMAT * (upper_16_bits(scaled_ppm));
+	rate += (LAN8814_1PPM_FORMAT * (lower_16_bits(scaled_ppm))) >> 16;
+
+	mutex_lock(&ptp_priv->ptp_lock);
+	phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_RATE_ADJ_HI,
+		      faster ? LAN8841_PTP_LTC_RATE_ADJ_HI_DIR | (upper_16_bits(rate) & 0x3fff)
+			     : upper_16_bits(rate) & 0x3fff);
+	phy_write_mmd(phydev, 2, LAN8841_PTP_LTC_RATE_ADJ_LO, lower_16_bits(rate));
+	mutex_unlock(&ptp_priv->ptp_lock);
+
+	return 0;
+}
+
+static struct ptp_clock_info lan8841_ptp_clock_info = {
+	.owner		= THIS_MODULE,
+	.name		= "lan8841 ptp",
+	.max_adj	= 31249999,
+	.gettime64	= lan8841_ptp_gettime64,
+	.settime64	= lan8841_ptp_settime64,
+	.adjtime	= lan8841_ptp_adjtime,
+	.adjfine	= lan8841_ptp_adjfine,
+};
+
 #define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER 3
 #define LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER_STRAP_RGMII_EN BIT(0)
 
 static int lan8841_probe(struct phy_device *phydev)
 {
+	struct kszphy_ptp_priv *ptp_priv;
+	struct kszphy_priv *priv;
 	int err;
 
 	err = kszphy_probe(phydev);
@@ -3306,6 +3847,40 @@ static int lan8841_probe(struct phy_device *phydev)
 	    LAN8841_OPERATION_MODE_STRAP_LOW_REGISTER_STRAP_RGMII_EN)
 		phydev->interface = PHY_INTERFACE_MODE_RGMII_RXID;
 
+	/* Register the clock */
+	if (!IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
+		return 0;
+
+	priv = phydev->priv;
+	ptp_priv = &priv->ptp_priv;
+
+	ptp_priv->ptp_clock_info = lan8841_ptp_clock_info;
+	ptp_priv->ptp_clock = ptp_clock_register(&ptp_priv->ptp_clock_info,
+						 &phydev->mdio.dev);
+	if (IS_ERR(ptp_priv->ptp_clock)) {
+		phydev_err(phydev, "ptp_clock_register failed: %lu\n",
+			   PTR_ERR(ptp_priv->ptp_clock));
+		return -EINVAL;
+	}
+
+	if (!ptp_priv->ptp_clock)
+		return 0;
+
+	/* Initialize the SW */
+	skb_queue_head_init(&ptp_priv->tx_queue);
+	skb_queue_head_init(&ptp_priv->rx_queue);
+	INIT_LIST_HEAD(&ptp_priv->rx_ts_list);
+	spin_lock_init(&ptp_priv->rx_ts_lock);
+	ptp_priv->phydev = phydev;
+	mutex_init(&ptp_priv->ptp_lock);
+
+	ptp_priv->mii_ts.rxtstamp = lan8814_rxtstamp;
+	ptp_priv->mii_ts.txtstamp = lan8814_txtstamp;
+	ptp_priv->mii_ts.hwtstamp = lan8841_hwtstamp;
+	ptp_priv->mii_ts.ts_info = lan8841_ts_info;
+
+	phydev->mii_ts = &ptp_priv->mii_ts;
+
 	return 0;
 }
 
-- 
2.38.0

