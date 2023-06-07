Return-Path: <netdev+bounces-8718-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8564772552A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AFFD28120D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC8036AA3;
	Wed,  7 Jun 2023 07:12:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDC63D99
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:12:49 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21841BC5;
	Wed,  7 Jun 2023 00:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686121967; x=1717657967;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XFr0imQSt+KEMbzAmSPeCg598h5t7DnW8EdP4TuVE1I=;
  b=uOwEVRwNu4QKLRQDVgLiIYWfjbgTra/LKuevPqK5R6p5xbLqZIaIvi2T
   yl01pIXcq13XZB6uVzXe0oTQBlsNwnHkR2/zwCeig5eWhcWyQ8D42S4w0
   VYMxjAv50qvhOonvkX5cvOADPmUN+Cm+u7+V0zKB4dpAMieo96qaAy6G8
   SJmneku5dilFUiCl4bBnE6gGW3oYA4zmlbEVfMKal70OvxpWRFf5666dr
   2MxeIWtOioPLWpsvrIfrLToPpUaL9cB/hlBb15+AfwrqdSChg5XtXKTah
   4UARArzGpBkj1ZpfKZBhd8vJ4f8OyCqaab8XaVbnXr8jzQs4xP0si42BC
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="217195103"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2023 00:12:47 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 7 Jun 2023 00:12:45 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Wed, 7 Jun 2023 00:12:43 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, Horatiu Vultur
	<horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: micrel: Change to receive timestamp in the frame for lan8841
Date: Wed, 7 Jun 2023 09:09:48 +0200
Message-ID: <20230607070948.1746768-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently for each timestamp frame, the SW needs to go and read the
received timestamp over the MDIO bus. But the HW has the capability
to store the received nanoseconds part and the least significant two
bits of the seconds in the reserved field of the PTP header. In this
way we could save few mdio transactions (actually a little more
transactions because the access to the PTP registers are indirect)
for each received frame. But is still required to read the seconds
part of each received frame.
Doing these changes to start to get the received timestamp in the
reserved field of the header, will give a great CPU usage performance.
Running ptp4l with logSyncInterval of -9 will give a ~50% CPU
improvment.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/phy/micrel.c | 231 +++++++++++++++++++++++----------------
 1 file changed, 139 insertions(+), 92 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 0ff4fd9f1a183..28365006b2067 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3502,6 +3502,9 @@ static int lan8814_probe(struct phy_device *phydev)
 #define LAN8841_PTP_CMD_CTL_PTP_RESET		BIT(0)
 #define LAN8841_PTP_RX_PARSE_CONFIG		368
 #define LAN8841_PTP_TX_PARSE_CONFIG		432
+#define LAN8841_PTP_RX_MODE			381
+#define LAN8841_PTP_INSERT_TS_EN		BIT(0)
+#define LAN8841_PTP_INSERT_TS_32BIT		BIT(1)
 
 static int lan8841_config_init(struct phy_device *phydev)
 {
@@ -3650,68 +3653,18 @@ static void lan8841_ptp_process_tx_ts(struct kszphy_ptp_priv *ptp_priv)
 		lan8814_match_tx_skb(ptp_priv, sec, nsec, seq);
 }
 
-#define LAN8841_PTP_RX_INGRESS_SEC_LO			389
-#define LAN8841_PTP_RX_INGRESS_SEC_HI			388
-#define LAN8841_PTP_RX_INGRESS_NS_LO			387
-#define LAN8841_PTP_RX_INGRESS_NS_HI			386
-#define LAN8841_PTP_RX_INGRESS_NSEC_HI_VALID		BIT(15)
-#define LAN8841_PTP_RX_MSG_HEADER2			391
-
-static struct lan8814_ptp_rx_ts *lan8841_ptp_get_rx_ts(struct kszphy_ptp_priv *ptp_priv)
-{
-	struct phy_device *phydev = ptp_priv->phydev;
-	struct lan8814_ptp_rx_ts *rx_ts;
-	u32 sec, nsec;
-	u16 seq;
-
-	nsec = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_NS_HI);
-	if (!(nsec & LAN8841_PTP_RX_INGRESS_NSEC_HI_VALID))
-		return NULL;
-
-	nsec = ((nsec & 0x3fff) << 16);
-	nsec = nsec | phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_NS_LO);
-
-	sec = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_SEC_HI);
-	sec = sec << 16;
-	sec = sec | phy_read_mmd(phydev, 2, LAN8841_PTP_RX_INGRESS_SEC_LO);
-
-	seq = phy_read_mmd(phydev, 2, LAN8841_PTP_RX_MSG_HEADER2);
-
-	rx_ts = kzalloc(sizeof(*rx_ts), GFP_KERNEL);
-	if (!rx_ts)
-		return NULL;
-
-	rx_ts->seconds = sec;
-	rx_ts->nsec = nsec;
-	rx_ts->seq_id = seq;
-
-	return rx_ts;
-}
-
-static void lan8841_ptp_process_rx_ts(struct kszphy_ptp_priv *ptp_priv)
-{
-	struct lan8814_ptp_rx_ts *rx_ts;
-
-	while ((rx_ts = lan8841_ptp_get_rx_ts(ptp_priv)) != NULL)
-		lan8814_match_rx_ts(ptp_priv, rx_ts);
-}
-
 #define LAN8841_PTP_INT_STS			259
 #define LAN8841_PTP_INT_STS_PTP_TX_TS_OVRFL_INT	BIT(13)
 #define LAN8841_PTP_INT_STS_PTP_TX_TS_INT	BIT(12)
-#define LAN8841_PTP_INT_STS_PTP_RX_TS_OVRFL_INT	BIT(9)
-#define LAN8841_PTP_INT_STS_PTP_RX_TS_INT	BIT(8)
 #define LAN8841_PTP_INT_STS_PTP_GPIO_CAP_INT	BIT(2)
 
-static void lan8841_ptp_flush_fifo(struct kszphy_ptp_priv *ptp_priv, bool egress)
+static void lan8841_ptp_flush_fifo(struct kszphy_ptp_priv *ptp_priv)
 {
 	struct phy_device *phydev = ptp_priv->phydev;
 	int i;
 
 	for (i = 0; i < FIFO_SIZE; ++i)
-		phy_read_mmd(phydev, 2,
-			     egress ? LAN8841_PTP_TX_MSG_HEADER2 :
-				      LAN8841_PTP_RX_MSG_HEADER2);
+		phy_read_mmd(phydev, 2, LAN8841_PTP_TX_MSG_HEADER2);
 
 	phy_read_mmd(phydev, 2, LAN8841_PTP_INT_STS);
 }
@@ -3789,23 +3742,17 @@ static void lan8841_handle_ptp_interrupt(struct phy_device *phydev)
 		if (status & LAN8841_PTP_INT_STS_PTP_TX_TS_INT)
 			lan8841_ptp_process_tx_ts(ptp_priv);
 
-		if (status & LAN8841_PTP_INT_STS_PTP_RX_TS_INT)
-			lan8841_ptp_process_rx_ts(ptp_priv);
-
 		if (status & LAN8841_PTP_INT_STS_PTP_GPIO_CAP_INT)
 			lan8841_gpio_process_cap(ptp_priv);
 
 		if (status & LAN8841_PTP_INT_STS_PTP_TX_TS_OVRFL_INT) {
-			lan8841_ptp_flush_fifo(ptp_priv, true);
+			lan8841_ptp_flush_fifo(ptp_priv);
 			skb_queue_purge(&ptp_priv->tx_queue);
 		}
 
-		if (status & LAN8841_PTP_INT_STS_PTP_RX_TS_OVRFL_INT) {
-			lan8841_ptp_flush_fifo(ptp_priv, false);
-			skb_queue_purge(&ptp_priv->rx_queue);
-		}
-
-	} while (status);
+	} while (status & (LAN8841_PTP_INT_STS_PTP_TX_TS_INT |
+			   LAN8841_PTP_INT_STS_PTP_GPIO_CAP_INT |
+			   LAN8841_PTP_INT_STS_PTP_TX_TS_OVRFL_INT));
 }
 
 #define LAN8841_INTS_PTP		BIT(9)
@@ -3869,32 +3816,44 @@ static int lan8841_ts_info(struct mii_timestamper *mii_ts,
 #define LAN8841_PTP_INT_EN			260
 #define LAN8841_PTP_INT_EN_PTP_TX_TS_OVRFL_EN	BIT(13)
 #define LAN8841_PTP_INT_EN_PTP_TX_TS_EN		BIT(12)
-#define LAN8841_PTP_INT_EN_PTP_RX_TS_OVRFL_EN	BIT(9)
-#define LAN8841_PTP_INT_EN_PTP_RX_TS_EN		BIT(8)
 
-static void lan8841_ptp_enable_int(struct kszphy_ptp_priv *ptp_priv,
-				   bool enable)
+static void lan8841_ptp_enable_processing(struct kszphy_ptp_priv *ptp_priv,
+					  bool enable)
 {
 	struct phy_device *phydev = ptp_priv->phydev;
 
-	if (enable)
-		/* Enable interrupts */
+	if (enable) {
+		/* Enable interrupts on the TX side */
 		phy_modify_mmd(phydev, 2, LAN8841_PTP_INT_EN,
 			       LAN8841_PTP_INT_EN_PTP_TX_TS_OVRFL_EN |
-			       LAN8841_PTP_INT_EN_PTP_RX_TS_OVRFL_EN |
-			       LAN8841_PTP_INT_EN_PTP_TX_TS_EN |
-			       LAN8841_PTP_INT_EN_PTP_RX_TS_EN,
+			       LAN8841_PTP_INT_EN_PTP_TX_TS_EN,
 			       LAN8841_PTP_INT_EN_PTP_TX_TS_OVRFL_EN |
-			       LAN8841_PTP_INT_EN_PTP_RX_TS_OVRFL_EN |
-			       LAN8841_PTP_INT_EN_PTP_TX_TS_EN |
-			       LAN8841_PTP_INT_EN_PTP_RX_TS_EN);
-	else
-		/* Disable interrupts */
+			       LAN8841_PTP_INT_EN_PTP_TX_TS_EN);
+
+		/* Enable the modification of the frame on RX side,
+		 * this will add the ns and 2 bits of sec in the reserved field
+		 * of the PTP header
+		 */
+		phy_modify_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+			       LAN8841_PTP_RX_MODE,
+			       LAN8841_PTP_INSERT_TS_EN |
+			       LAN8841_PTP_INSERT_TS_32BIT,
+			       LAN8841_PTP_INSERT_TS_EN |
+			       LAN8841_PTP_INSERT_TS_32BIT);
+	} else {
+		/* Disable interrupts on the TX side */
 		phy_modify_mmd(phydev, 2, LAN8841_PTP_INT_EN,
 			       LAN8841_PTP_INT_EN_PTP_TX_TS_OVRFL_EN |
-			       LAN8841_PTP_INT_EN_PTP_RX_TS_OVRFL_EN |
-			       LAN8841_PTP_INT_EN_PTP_TX_TS_EN |
-			       LAN8841_PTP_INT_EN_PTP_RX_TS_EN, 0);
+			       LAN8841_PTP_INT_EN_PTP_TX_TS_EN, 0);
+
+		/* Disable modification of the RX frames */
+		phy_modify_mmd(phydev, KSZ9131RN_MMD_COMMON_CTRL_REG,
+			       LAN8841_PTP_RX_MODE,
+			       LAN8841_PTP_INSERT_TS_EN |
+			       LAN8841_PTP_INSERT_TS_32BIT, 0);
+
+		ptp_cancel_worker_sync(ptp_priv->ptp_clock);
+	}
 }
 
 #define LAN8841_PTP_RX_TIMESTAMP_EN		379
@@ -3905,7 +3864,6 @@ static int lan8841_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 {
 	struct kszphy_ptp_priv *ptp_priv = container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
 	struct phy_device *phydev = ptp_priv->phydev;
-	struct lan8814_ptp_rx_ts *rx_ts, *tmp;
 	struct hwtstamp_config config;
 	int txcfg = 0, rxcfg = 0;
 	int pkt_ts_enable;
@@ -3969,24 +3927,47 @@ static int lan8841_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 				PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_ : 0);
 
 	/* Now enable/disable the timestamping */
-	lan8841_ptp_enable_int(ptp_priv,
-			       config.rx_filter != HWTSTAMP_FILTER_NONE);
-
-	/* In case of multiple starts and stops, these needs to be cleared */
-	list_for_each_entry_safe(rx_ts, tmp, &ptp_priv->rx_ts_list, list) {
-		list_del(&rx_ts->list);
-		kfree(rx_ts);
-	}
+	lan8841_ptp_enable_processing(ptp_priv,
+				      config.rx_filter != HWTSTAMP_FILTER_NONE);
 
 	skb_queue_purge(&ptp_priv->rx_queue);
 	skb_queue_purge(&ptp_priv->tx_queue);
 
-	lan8841_ptp_flush_fifo(ptp_priv, false);
-	lan8841_ptp_flush_fifo(ptp_priv, true);
+	lan8841_ptp_flush_fifo(ptp_priv);
 
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ? -EFAULT : 0;
 }
 
+#define LAN8841_SKB_CB(skb)	((struct lan8841_skb_cb *)(skb)->cb)
+
+struct lan8841_skb_cb {
+	struct ptp_header *header;
+};
+
+static bool lan8841_rxtstamp(struct mii_timestamper *mii_ts,
+			     struct sk_buff *skb, int type)
+{
+	struct kszphy_ptp_priv *ptp_priv =
+			container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
+	struct ptp_header *header = ptp_parse_header(skb, type);
+
+	if (!header)
+		return false;
+
+	if (ptp_priv->rx_filter == HWTSTAMP_FILTER_NONE ||
+	    type == PTP_CLASS_NONE)
+		return false;
+
+	if ((type & ptp_priv->version) == 0 || (type & ptp_priv->layer) == 0)
+		return false;
+
+	LAN8841_SKB_CB(skb)->header = header;
+	skb_queue_tail(&ptp_priv->rx_queue, skb);
+	ptp_schedule_worker(ptp_priv->ptp_clock, 0);
+
+	return true;
+}
+
 #define LAN8841_EVENT_A		0
 #define LAN8841_EVENT_B		1
 #define LAN8841_PTP_LTC_TARGET_SEC_HI(event)	((event) == LAN8841_EVENT_A ? 278 : 288)
@@ -4127,6 +4108,30 @@ static int lan8841_ptp_gettime64(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static void lan8841_ptp_getseconds(struct ptp_clock_info *ptp,
+				   struct timespec64 *ts)
+{
+	struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
+							ptp_clock_info);
+	struct phy_device *phydev = ptp_priv->phydev;
+	time64_t s;
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
+	mutex_unlock(&ptp_priv->ptp_lock);
+
+	set_normalized_timespec64(ts, s, 0);
+}
+
 #define LAN8841_PTP_LTC_STEP_ADJ_LO			276
 #define LAN8841_PTP_LTC_STEP_ADJ_HI			275
 #define LAN8841_PTP_LTC_STEP_ADJ_DIR			BIT(15)
@@ -4629,6 +4634,37 @@ static int lan8841_ptp_enable(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static long lan8841_ptp_do_aux_work(struct ptp_clock_info *ptp)
+{
+	struct kszphy_ptp_priv *ptp_priv = container_of(ptp, struct kszphy_ptp_priv,
+							ptp_clock_info);
+	struct skb_shared_hwtstamps *shhwtstamps;
+	struct timespec64 ts;
+	struct sk_buff *skb;
+	u32 ts_header;
+
+	while ((skb = skb_dequeue(&ptp_priv->rx_queue)) != NULL) {
+		lan8841_ptp_getseconds(ptp, &ts);
+		ts_header = __be32_to_cpu(LAN8841_SKB_CB(skb)->header->reserved2);
+
+		shhwtstamps = skb_hwtstamps(skb);
+		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+
+		/* Check for any wrap arounds for the second part */
+		if ((ts.tv_sec & GENMASK(1, 0)) < ts_header >> 30)
+			ts.tv_sec -= GENMASK(1, 0) + 1;
+
+		shhwtstamps->hwtstamp =
+			ktime_set((ts.tv_sec & ~(GENMASK(1, 0))) | ts_header >> 30,
+				  ts_header & GENMASK(29, 0));
+		LAN8841_SKB_CB(skb)->header->reserved2 = 0;
+
+		netif_rx(skb);
+	}
+
+	return -1;
+}
+
 static struct ptp_clock_info lan8841_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "lan8841 ptp",
@@ -4639,6 +4675,7 @@ static struct ptp_clock_info lan8841_ptp_clock_info = {
 	.adjfine	= lan8841_ptp_adjfine,
 	.verify         = lan8841_ptp_verify,
 	.enable         = lan8841_ptp_enable,
+	.do_aux_work	= lan8841_ptp_do_aux_work,
 	.n_per_out      = LAN8841_PTP_GPIO_NUM,
 	.n_ext_ts       = LAN8841_PTP_GPIO_NUM,
 	.n_pins         = LAN8841_PTP_GPIO_NUM,
@@ -4705,7 +4742,7 @@ static int lan8841_probe(struct phy_device *phydev)
 	ptp_priv->phydev = phydev;
 	mutex_init(&ptp_priv->ptp_lock);
 
-	ptp_priv->mii_ts.rxtstamp = lan8814_rxtstamp;
+	ptp_priv->mii_ts.rxtstamp = lan8841_rxtstamp;
 	ptp_priv->mii_ts.txtstamp = lan8814_txtstamp;
 	ptp_priv->mii_ts.hwtstamp = lan8841_hwtstamp;
 	ptp_priv->mii_ts.ts_info = lan8841_ts_info;
@@ -4715,6 +4752,16 @@ static int lan8841_probe(struct phy_device *phydev)
 	return 0;
 }
 
+static int lan8841_suspend(struct phy_device *phydev)
+{
+	struct kszphy_priv *priv = phydev->priv;
+	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
+
+	ptp_cancel_worker_sync(ptp_priv->ptp_clock);
+
+	return genphy_suspend(phydev);
+}
+
 static struct phy_driver ksphy_driver[] = {
 {
 	.phy_id		= PHY_ID_KS8737,
@@ -4938,7 +4985,7 @@ static struct phy_driver ksphy_driver[] = {
 	.get_sset_count = kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-	.suspend	= genphy_suspend,
+	.suspend	= lan8841_suspend,
 	.resume		= genphy_resume,
 	.cable_test_start	= lan8814_cable_test_start,
 	.cable_test_get_status	= ksz886x_cable_test_get_status,
-- 
2.38.0


