Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A93F5668DC
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 13:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiGELGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 07:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiGELGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 07:06:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE84313F11;
        Tue,  5 Jul 2022 04:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657019169; x=1688555169;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=FsZjt1Z0WAlc6O9U+cllSbUxwldvJsjCBP9Rmjvi8O4=;
  b=GuTqAJJpQ3TCfvKclI8T0gVx6f5OJYVN3FXIh1i6mkIMQqFPqihmKabn
   Udo3psNunXt3PXEbEmBv3kTi25d/AE6jHC6u1wKuiC/w+qdCclnAZE5q1
   Q5k3f6U4gH99dddkoXmAahvFM948rSi6N6E1M7DyTLLxD7ZiUL7sH53Ip
   rm+pD5rdPZOCdQBKsKCCYHmGVlsiRufxbcClJW5jbSt9HRIJZfUFt+2Ci
   gzO09UJe+Hwkc4/6YK9flb7jGzj9JjhT38f88h7iJ6y+Nu17wnG4hp2mJ
   TEagQreLy88p9MaDM1TjcYvKUf1V8zTjlTz55Cds+vf7RKyUuQBtYPOY1
   w==;
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="171066498"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Jul 2022 04:06:08 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Jul 2022 04:06:08 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 5 Jul 2022 04:06:04 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: [PATCH net-next] net: phy: micrel: Fix latency issues in LAN8814 PHY
Date:   Tue, 5 Jul 2022 16:35:54 +0530
Message-ID: <20220705110554.5574-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Latency adjustments done for 1-step and 2-step
from default latency register values to fix negative
and high mean path delays.

Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
 drivers/net/phy/micrel.c | 123 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 120 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e78d0bf69bc3..3ae0b419298e 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -121,6 +121,26 @@
 #define PTP_TIMESTAMP_EN_PDREQ_			BIT(2)
 #define PTP_TIMESTAMP_EN_PDRES_			BIT(3)
 
+#define PTP_RX_LATENCY_1000			0x0224
+#define PTP_TX_LATENCY_1000			0x0225
+
+#define PTP_RX_LATENCY_100			0x0222
+#define PTP_TX_LATENCY_100			0x0223
+
+#define PTP_RX_LATENCY_10			0x0220
+#define PTP_TX_LATENCY_10			0x0221
+
+#define PTP_LATENCY_1000_CRCTN_1S		0x000C
+#define PTP_LATENCY_100_CRCTN_1S		0x028D
+#define PTP_LATENCY_10_CRCTN_1S			0x01E
+
+#define PTP_RX_LATENCY_1000_CRCTN_2S		0x0048
+#define PTP_TX_LATENCY_1000_CRCTN_2S		0x0049
+#define PTP_RX_LATENCY_100_CRCTN_2S		0x0707
+#define PTP_TX_LATENCY_100_CRCTN_2S		0x0275
+#define PTP_RX_LATENCY_10_CRCTN_2S		0x17CE
+#define PTP_TX_LATENCY_10_CRCTN_2S		0x17CE
+
 #define PTP_TX_PARSE_L2_ADDR_EN			0x0284
 #define PTP_RX_PARSE_L2_ADDR_EN			0x0244
 
@@ -284,6 +304,15 @@ struct lan8814_ptp_rx_ts {
 	u16 seq_id;
 };
 
+struct kszphy_latencies {
+	u16 rx_10;
+	u16 tx_10;
+	u16 rx_100;
+	u16 tx_100;
+	u16 rx_1000;
+	u16 tx_1000;
+};
+
 struct kszphy_ptp_priv {
 	struct mii_timestamper mii_ts;
 	struct phy_device *phydev;
@@ -303,6 +332,7 @@ struct kszphy_ptp_priv {
 
 struct kszphy_priv {
 	struct kszphy_ptp_priv ptp_priv;
+	struct kszphy_latencies latencies;
 	const struct kszphy_type *type;
 	int led_mode;
 	u16 vct_ctrl1000;
@@ -2087,16 +2117,82 @@ static void lan8814_flush_fifo(struct phy_device *phydev, bool egress)
 	lanphy_read_page_reg(phydev, 5, PTP_TSU_INT_STS);
 }
 
+static void lan8814_get_latency(struct phy_device *phydev)
+{
+	struct kszphy_priv *priv = phydev->priv;
+	struct kszphy_latencies *latencies = &priv->latencies;
+
+	latencies->rx_1000 = lanphy_read_page_reg(phydev, 5, PTP_RX_LATENCY_1000);
+	latencies->rx_100 = lanphy_read_page_reg(phydev, 5, PTP_RX_LATENCY_100);
+	latencies->rx_10 = lanphy_read_page_reg(phydev, 5, PTP_RX_LATENCY_10);
+	latencies->tx_1000 = lanphy_read_page_reg(phydev, 5, PTP_TX_LATENCY_1000);
+	latencies->tx_100 = lanphy_read_page_reg(phydev, 5, PTP_TX_LATENCY_100);
+	latencies->tx_10 = lanphy_read_page_reg(phydev, 5, PTP_TX_LATENCY_10);
+}
+
+static void lan8814_latency_config(struct phy_device *phydev,
+				   struct kszphy_latencies *latencies)
+{
+	switch (phydev->speed) {
+	case SPEED_1000:
+		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_1000,
+				      latencies->rx_1000);
+		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_1000,
+				      latencies->tx_1000);
+		break;
+	case SPEED_100:
+		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_100,
+				      latencies->rx_100);
+		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_100,
+				      latencies->tx_100);
+		break;
+	case SPEED_10:
+		lanphy_write_page_reg(phydev, 5, PTP_RX_LATENCY_10,
+				      latencies->rx_10);
+		lanphy_write_page_reg(phydev, 5, PTP_TX_LATENCY_10,
+				      latencies->tx_10);
+		break;
+	default:
+		break;
+	}
+}
+
+static void lan8814_latency_workaround(struct phy_device *phydev,
+				       struct kszphy_latencies *latencies, bool onestep)
+{
+	struct kszphy_priv *priv = phydev->priv;
+	struct kszphy_latencies *priv_latencies = &priv->latencies;
+
+	if (onestep) {
+		latencies->rx_10 = priv_latencies->rx_10 - PTP_LATENCY_10_CRCTN_1S;
+		latencies->rx_100 = priv_latencies->rx_100 - PTP_LATENCY_100_CRCTN_1S;
+		latencies->rx_1000 = priv_latencies->rx_1000 - PTP_LATENCY_1000_CRCTN_1S;
+		latencies->tx_10 = priv_latencies->tx_10 - PTP_LATENCY_10_CRCTN_1S;
+		latencies->tx_100 = priv_latencies->tx_100 - PTP_LATENCY_100_CRCTN_1S;
+		latencies->tx_1000 = priv_latencies->tx_1000 - PTP_LATENCY_1000_CRCTN_1S;
+	} else {
+		latencies->rx_10 = priv_latencies->rx_10 - PTP_RX_LATENCY_10_CRCTN_2S;
+		latencies->rx_100 = priv_latencies->rx_100 - PTP_RX_LATENCY_100_CRCTN_2S;
+		latencies->rx_1000 = priv_latencies->rx_1000 - PTP_RX_LATENCY_1000_CRCTN_2S;
+		latencies->tx_10 = priv_latencies->tx_10 - PTP_TX_LATENCY_10_CRCTN_2S;
+		latencies->tx_100 = priv_latencies->tx_100 - PTP_TX_LATENCY_100_CRCTN_2S;
+		latencies->tx_1000 = priv_latencies->tx_1000 - PTP_TX_LATENCY_1000_CRCTN_2S;
+	}
+}
+
 static int lan8814_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 {
 	struct kszphy_ptp_priv *ptp_priv =
 			  container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
 	struct phy_device *phydev = ptp_priv->phydev;
 	struct lan8814_shared_priv *shared = phydev->shared->priv;
+	struct kszphy_priv *priv = phydev->priv;
 	struct lan8814_ptp_rx_ts *rx_ts, *tmp;
+	struct kszphy_latencies latencies;
 	struct hwtstamp_config config;
 	int txcfg = 0, rxcfg = 0;
 	int pkt_ts_enable;
+	u16 temp;
 
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
@@ -2146,9 +2242,21 @@ static int lan8814_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 	lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_RX_TIMESTAMP_EN, pkt_ts_enable);
 	lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_TIMESTAMP_EN, pkt_ts_enable);
 
-	if (ptp_priv->hwts_tx_type == HWTSTAMP_TX_ONESTEP_SYNC)
-		lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_MOD,
-				      PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_);
+	temp = lanphy_read_page_reg(phydev, 5, PTP_TX_MOD);
+	if (ptp_priv->hwts_tx_type == HWTSTAMP_TX_ONESTEP_SYNC) {
+		temp |= PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_;
+
+		lan8814_latency_workaround(phydev, &latencies, true);
+		lan8814_latency_config(phydev, &latencies);
+	} else if (ptp_priv->hwts_tx_type == HWTSTAMP_TX_ON) {
+		lan8814_latency_workaround(phydev, &latencies, false);
+		lan8814_latency_config(phydev, &latencies);
+	} else {
+		temp &= ~PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_;
+
+		lan8814_latency_config(phydev, &priv->latencies);
+	}
+	lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_MOD, temp);
 
 	if (config.rx_filter != HWTSTAMP_FILTER_NONE)
 		lan8814_config_ts_intr(ptp_priv->phydev, true);
@@ -2676,6 +2784,13 @@ static int lan8804_config_init(struct phy_device *phydev)
 	return 0;
 }
 
+void lan8814_link_change_notify(struct phy_device *phydev)
+{
+	struct kszphy_priv *priv = phydev->priv;
+
+	lan8814_latency_config(phydev, &priv->latencies);
+}
+
 static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status, tsu_irq_status;
@@ -2923,6 +3038,7 @@ static int lan8814_probe(struct phy_device *phydev)
 	}
 
 	lan8814_ptp_init(phydev);
+	lan8814_get_latency(phydev);
 
 	return 0;
 }
@@ -3117,6 +3233,7 @@ static struct phy_driver ksphy_driver[] = {
 	.resume		= kszphy_resume,
 	.config_intr	= lan8814_config_intr,
 	.handle_interrupt = lan8814_handle_interrupt,
+	.link_change_notify = lan8814_link_change_notify,
 }, {
 	.phy_id		= PHY_ID_LAN8804,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.17.1

