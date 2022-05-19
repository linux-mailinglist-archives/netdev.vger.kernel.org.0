Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6E152D552
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 15:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbiESN5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 09:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbiESN5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 09:57:10 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9FB2BF4;
        Thu, 19 May 2022 06:57:07 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 71767240013;
        Thu, 19 May 2022 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652968626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/Kd10AwKv2w3Q0mttVB1gl1+W1auqMdjySJEYCTO9o=;
        b=dyizHEMJHFYCCIPWTfmsbIgm6s+HL+xuND5A7ZvZtWqLtwVgFsgIqHuZ7oUxJajIKw85UR
        Z/wW1Nnr3b1fkgwjp17UPMJ5PGp/Z7HBX3IOlO1Tdc4kEYRxs92oeNCCbcQSRMsXXIq30R
        msUR/n19m080Ye0bygpUyYekyT+dUr2FwqfafTSplu4eLsWAE5edca+1yJZhApddYXq32a
        SJklsaSONInJjLdyC/t0UfZLHxQXAJqr1ck6S1c1tSNKutM9vvOwWY3VB5o8ZmWtBjsJ+Z
        lp3leL015Tj753cA9CFjQ+mkZhasBqRZOoQM8qTjFfUDbsKBKQpheAdBl93HAA==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Richard Cochran <richardcochran@gmail.com>,
        Horatiu.Vultur@microchip.com, Allan.Nielsen@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 6/6] net: phy: micrel: Add QUSGMII support and PCH extension
Date:   Thu, 19 May 2022 15:56:47 +0200
Message-Id: <20220519135647.465653-7-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
References: <20220519135647.465653-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for the PCH extension in the Lan8814 PHY,
allowing the PHY to report RX timestamps to the MAC in the ethernet
preamble.

When using the PCH extension, the PHY will only report the nanoseconds
part of the timestamp in-band, and the seconds part out-of-band.
The main goal in the end is to lower the pressure on the MDIO bus, which
may get pushed to its limit on 48 ports switches doing PTP at a high
rate.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/phy/micrel.c | 102 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 96 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index f537e61cb61d..904b46701782 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -116,6 +116,10 @@
 #define LTC_HARD_RESET				0x023F
 #define LTC_HARD_RESET_				BIT(0)
 
+#define TSU_GENERAL_CONFIG			0x2C0
+#define TSU_GENERAL_CONFIG_TSU_ENABLE_		BIT(0)
+#define TSU_GENERAL_CONFIG_TSU_ENABLE_PCH_	BIT(1)
+
 #define TSU_HARD_RESET				0x02C1
 #define TSU_HARD_RESET_				BIT(0)
 
@@ -139,6 +143,7 @@
 
 #define PTP_OPERATING_MODE			0x0241
 #define PTP_OPERATING_MODE_STANDALONE_		BIT(0)
+#define PTP_OPERATING_MODE_PCH_			BIT(1)
 
 #define PTP_TX_MOD				0x028F
 #define PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_	BIT(12)
@@ -227,6 +232,15 @@
 #define PS_TO_REG				200
 #define FIFO_SIZE				8
 
+struct lan8814_skb_cb {
+	u8 rew_op;
+	u16 ts_id;
+	unsigned long jiffies;
+};
+
+#define LAN8814_SKB_CB(skb) \
+	((struct lan8814_skb_cb *)((skb)->cb))
+
 struct kszphy_hw_stat {
 	const char *string;
 	u8 reg;
@@ -1809,6 +1823,16 @@ static void lan8814_ptp_rx_ts_get(struct phy_device *phydev,
 	*seq_id = lanphy_read_page_reg(phydev, 5, PTP_RX_MSG_HEADER2);
 }
 
+static void lan8814_ptp_rx_ts_get_partial(struct phy_device *phydev,
+					  u32 *seconds, u16 *seq_id)
+{
+	*seconds = lanphy_read_page_reg(phydev, 5, PTP_RX_INGRESS_SEC_HI);
+	*seconds = (*seconds << 16) |
+		   lanphy_read_page_reg(phydev, 5, PTP_RX_INGRESS_SEC_LO);
+
+	*seq_id = lanphy_read_page_reg(phydev, 5, PTP_RX_MSG_HEADER2);
+}
+
 static void lan8814_ptp_tx_ts_get(struct phy_device *phydev,
 				  u32 *seconds, u32 *nano_seconds, u16 *seq_id)
 {
@@ -1955,6 +1979,13 @@ static int lan8814_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 	lan8814_flush_fifo(ptp_priv->phydev, false);
 	lan8814_flush_fifo(ptp_priv->phydev, true);
 
+	if (phydev->interface == PHY_INTERFACE_MODE_QUSGMII &&
+	    ptp_priv->hwts_tx_type == HWTSTAMP_TX_ON)
+		phy_inband_ext_set_available(phydev, PHY_INBAND_EXT_PCH,
+					     PHY_INBAND_EXT_PCH);
+	else
+		phy_inband_ext_set_available(phydev, PHY_INBAND_EXT_PCH, 0);
+
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ? -EFAULT : 0;
 }
 
@@ -2283,11 +2314,17 @@ static int lan8814_ptpci_adjfine(struct ptp_clock_info *ptpci, long scaled_ppm)
 	return 0;
 }
 
-static void lan8814_get_sig_tx(struct sk_buff *skb, u16 *sig)
+static void lan8814_get_sig_tx(struct phy_device *phydev,
+			       struct sk_buff *skb, u16 *sig)
 {
 	struct ptp_header *ptp_header;
 	u32 type;
 
+	if (phy_inband_ext_enabled(phydev, PHY_INBAND_EXT_PCH)) {
+		*sig = LAN8814_SKB_CB(skb)->ts_id >> 2;
+		return;
+	}
+
 	type = ptp_classify_raw(skb);
 	ptp_header = ptp_parse_header(skb, type);
 
@@ -2309,7 +2346,7 @@ static void lan8814_dequeue_tx_skb(struct kszphy_ptp_priv *ptp_priv)
 
 	spin_lock_irqsave(&ptp_priv->tx_queue.lock, flags);
 	skb_queue_walk_safe(&ptp_priv->tx_queue, skb, skb_tmp) {
-		lan8814_get_sig_tx(skb, &skb_sig);
+		lan8814_get_sig_tx(phydev, skb, &skb_sig);
 
 		if (memcmp(&skb_sig, &seq_id, sizeof(seq_id)))
 			continue;
@@ -2367,8 +2404,20 @@ static bool lan8814_match_skb(struct kszphy_ptp_priv *ptp_priv,
 
 	if (ret) {
 		shhwtstamps = skb_hwtstamps(skb);
-		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
-		shhwtstamps->hwtstamp = ktime_set(rx_ts->seconds, rx_ts->nsec);
+
+		if (phy_inband_ext_enabled(ptp_priv->phydev, PHY_INBAND_EXT_PCH)) {
+			/* When using the PCH extension, we get the seconds part
+			 * from MDIO accesses, but the seconds part gets
+			 * set by the MAC driver according to the PCH data in the
+			 * preamble
+			 */
+			struct timespec64 ts = ktime_to_timespec64(shhwtstamps->hwtstamp);
+
+			shhwtstamps->hwtstamp = ktime_set(rx_ts->seconds, ts.tv_nsec);
+		} else {
+			memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+			shhwtstamps->hwtstamp = ktime_set(rx_ts->seconds, rx_ts->nsec);
+		}
 		netif_rx(skb);
 	}
 
@@ -2387,8 +2436,17 @@ static void lan8814_get_rx_ts(struct kszphy_ptp_priv *ptp_priv)
 		if (!rx_ts)
 			return;
 
-		lan8814_ptp_rx_ts_get(phydev, &rx_ts->seconds, &rx_ts->nsec,
-				      &rx_ts->seq_id);
+		/* When using PCH mode, the nanoseconds part of the timestamp is
+		 * transmitted inband through the ethernet preamble. We only need
+		 * to retrieve the seconds part along with the seq_id, the MAC
+		 * driver will fill-in the nanoseconds part itself
+		 */
+		if (phy_inband_ext_enabled(ptp_priv->phydev, PHY_INBAND_EXT_PCH))
+			lan8814_ptp_rx_ts_get_partial(phydev, &rx_ts->seconds,
+						      &rx_ts->seq_id);
+		else
+			lan8814_ptp_rx_ts_get(phydev, &rx_ts->seconds,
+					      &rx_ts->nsec, &rx_ts->seq_id);
 
 		/* If we failed to match the skb add it to the queue for when
 		 * the frame will come
@@ -2682,6 +2740,36 @@ static int lan8814_set_tunable(struct phy_device *phydev,
 	}
 }
 
+static int lan8814_inband_ext_config(struct phy_device *phydev, u32 mask, u32 ext)
+{
+	u32 tsu_cfg;
+
+	if (!(mask & PHY_INBAND_EXT_PCH))
+		return -EOPNOTSUPP;
+
+	tsu_cfg = ~TSU_GENERAL_CONFIG_TSU_ENABLE_;
+
+	lanphy_write_page_reg(phydev, 5, TSU_GENERAL_CONFIG, tsu_cfg);
+
+	if (ext & PHY_INBAND_EXT_PCH) {
+		lanphy_write_page_reg(phydev, 4, PTP_OPERATING_MODE,
+				      PTP_OPERATING_MODE_PCH_);
+
+		tsu_cfg |= TSU_GENERAL_CONFIG_TSU_ENABLE_PCH_;
+	} else {
+		lanphy_write_page_reg(phydev, 4, PTP_OPERATING_MODE,
+				      PTP_OPERATING_MODE_STANDALONE_);
+
+		tsu_cfg &= ~TSU_GENERAL_CONFIG_TSU_ENABLE_PCH_;
+	}
+
+	tsu_cfg |= TSU_GENERAL_CONFIG_TSU_ENABLE_;
+
+	lanphy_write_page_reg(phydev, 5, TSU_GENERAL_CONFIG, tsu_cfg);
+
+	return 0;
+}
+
 static int lan8814_config_init(struct phy_device *phydev)
 {
 	int val;
@@ -2914,6 +3002,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id		= PHY_ID_LAN8814,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Microchip INDY Gigabit Quad PHY",
+	.inband_ext	= PHY_INBAND_EXT_PCH,
 	.config_init	= lan8814_config_init,
 	.probe		= lan8814_probe,
 	.soft_reset	= genphy_soft_reset,
@@ -2927,6 +3016,7 @@ static struct phy_driver ksphy_driver[] = {
 	.resume		= kszphy_resume,
 	.config_intr	= lan8814_config_intr,
 	.handle_interrupt = lan8814_handle_interrupt,
+	.inband_ext_config = lan8814_inband_ext_config,
 }, {
 	.phy_id		= PHY_ID_LAN8804,
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
-- 
2.36.1

