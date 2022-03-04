Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6B84CD13A
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbiCDJhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239095AbiCDJgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:36:55 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FAA1959DD;
        Fri,  4 Mar 2022 01:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646386560; x=1677922560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=kbek2reO3JqVY/ve/CX0KzErgO3uBlCQPBna/LXWSfc=;
  b=yCL2CsF0WLX+o64Kx5bCYVjrrR3hxV9ZhmNUa77NZbWVmYN5/rz+cH/Z
   +4ThXzIvZ+TR4zdUmGa4V8orJbmqB4yD4N6rdZgMYWcT9Jq0+BIEGQ84q
   ACIARiIoUeFitX9yzmz2LPLEzZDE6KJw30yO8UPhgUPo02IX/S56WpQCI
   F+ILnbuG4TG/iHwtSa8RU8JCawA539bDn9u+knVIBDAj1O2k9GP5ZCQnx
   OuGe/Is40HvkGwqnz6+hYln77ii/s/VSEyAf7ZLlPLQZv4siCoVtE+bmN
   ruEGe7OfcNFDuxh4NF8K53znSFTGOaLSUTwfcU0ovVN3SD9ErzypaaTZa
   A==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="150846879"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:35:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:35:58 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 02:35:53 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <richardcochran@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <madhuri.sripada@microchip.com>, <manohar.puri@microchip.com>
Subject: [PATCH net-next 3/3] net: phy: micrel: 1588 support for LAN8814 phy
Date:   Fri, 4 Mar 2022 15:04:18 +0530
Message-ID: <20220304093418.31645-4-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304093418.31645-1-Divya.Koppera@microchip.com>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for 1588 in LAN8814 phy driver.
It supports 1-step and 2-step timestamping.

Co-developed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
 drivers/net/phy/micrel.c | 1088 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 1066 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 281cebc3d00c..81a76322254c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -28,6 +28,10 @@
 #include <linux/of.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/ptp_clock.h>
+#include <linux/ptp_classify.h>
+#include <linux/net_tstamp.h>
 
 /* Operation Mode Strap Override */
 #define MII_KSZPHY_OMSO				0x16
@@ -79,6 +83,119 @@
 #define LAN8814_INTR_CTRL_REG_POLARITY		BIT(1)
 #define LAN8814_INTR_CTRL_REG_INTR_ENABLE	BIT(0)
 
+/* Represents 1ppm adjustment in 2^32 format with
+ * each nsec contains 4 clock cycles.
+ * The value is calculated as following: (1/1000000)/((2^-32)/4)
+ */
+#define LAN8814_1PPM_FORMAT			17179
+
+#define PTP_RX_MOD				0x024F
+#define PTP_RX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_ BIT(3)
+#define PTP_RX_TIMESTAMP_EN			0x024D
+#define PTP_TX_TIMESTAMP_EN			0x028D
+
+#define PTP_TIMESTAMP_EN_SYNC_			BIT(0)
+#define PTP_TIMESTAMP_EN_DREQ_			BIT(1)
+#define PTP_TIMESTAMP_EN_PDREQ_			BIT(2)
+#define PTP_TIMESTAMP_EN_PDRES_			BIT(3)
+
+#define PTP_RX_LATENCY_1000			0x0224
+#define PTP_TX_LATENCY_1000			0x0225
+
+#define PTP_RX_LATENCY_100			0x0222
+#define PTP_TX_LATENCY_100			0x0223
+
+#define PTP_RX_LATENCY_10			0x0220
+#define PTP_TX_LATENCY_10			0x0221
+
+#define PTP_TX_PARSE_L2_ADDR_EN			0x0284
+#define PTP_RX_PARSE_L2_ADDR_EN			0x0244
+
+#define PTP_TX_PARSE_IP_ADDR_EN			0x0285
+#define PTP_RX_PARSE_IP_ADDR_EN			0x0245
+#define LTC_HARD_RESET				0x023F
+#define LTC_HARD_RESET_				BIT(0)
+
+#define TSU_HARD_RESET				0x02C1
+#define TSU_HARD_RESET_				BIT(0)
+
+#define PTP_CMD_CTL				0x0200
+#define PTP_CMD_CTL_PTP_DISABLE_		BIT(0)
+#define PTP_CMD_CTL_PTP_ENABLE_			BIT(1)
+#define PTP_CMD_CTL_PTP_CLOCK_READ_		BIT(3)
+#define PTP_CMD_CTL_PTP_CLOCK_LOAD_		BIT(4)
+#define PTP_CMD_CTL_PTP_LTC_STEP_SEC_		BIT(5)
+#define PTP_CMD_CTL_PTP_LTC_STEP_NSEC_		BIT(6)
+
+#define PTP_CLOCK_SET_SEC_MID			0x0206
+#define PTP_CLOCK_SET_SEC_LO			0x0207
+#define PTP_CLOCK_SET_NS_HI			0x0208
+#define PTP_CLOCK_SET_NS_LO			0x0209
+
+#define PTP_CLOCK_READ_SEC_MID			0x022A
+#define PTP_CLOCK_READ_SEC_LO			0x022B
+#define PTP_CLOCK_READ_NS_HI			0x022C
+#define PTP_CLOCK_READ_NS_LO			0x022D
+
+#define PTP_OPERATING_MODE			0x0241
+#define PTP_OPERATING_MODE_STANDALONE_		BIT(0)
+
+#define PTP_TX_MOD				0x028F
+#define PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_	BIT(12)
+#define PTP_TX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_ BIT(3)
+
+#define PTP_RX_PARSE_CONFIG			0x0242
+#define PTP_RX_PARSE_CONFIG_LAYER2_EN_		BIT(0)
+#define PTP_RX_PARSE_CONFIG_IPV4_EN_		BIT(1)
+#define PTP_RX_PARSE_CONFIG_IPV6_EN_		BIT(2)
+
+#define PTP_TX_PARSE_CONFIG			0x0282
+#define PTP_TX_PARSE_CONFIG_LAYER2_EN_		BIT(0)
+#define PTP_TX_PARSE_CONFIG_IPV4_EN_		BIT(1)
+#define PTP_TX_PARSE_CONFIG_IPV6_EN_		BIT(2)
+
+#define PTP_CLOCK_RATE_ADJ_HI			0x020C
+#define PTP_CLOCK_RATE_ADJ_LO			0x020D
+#define PTP_CLOCK_RATE_ADJ_DIR_			BIT(15)
+
+#define PTP_LTC_STEP_ADJ_HI			0x0212
+#define PTP_LTC_STEP_ADJ_LO			0x0213
+#define PTP_LTC_STEP_ADJ_DIR_			BIT(15)
+
+#define LAN8814_INTR_STS_REG			0x0033
+#define LAN8814_INTR_STS_REG_1588_TSU0_		BIT(0)
+#define LAN8814_INTR_STS_REG_1588_TSU1_		BIT(1)
+#define LAN8814_INTR_STS_REG_1588_TSU2_		BIT(2)
+#define LAN8814_INTR_STS_REG_1588_TSU3_		BIT(3)
+
+#define PTP_CAP_INFO				0x022A
+#define PTP_CAP_INFO_TX_TS_CNT_GET_(reg_val)	(((reg_val) & 0x0f00) >> 8)
+#define PTP_CAP_INFO_RX_TS_CNT_GET_(reg_val)	((reg_val) & 0x000f)
+
+#define PTP_TX_EGRESS_SEC_HI			0x0296
+#define PTP_TX_EGRESS_SEC_LO			0x0297
+#define PTP_TX_EGRESS_NS_HI			0x0294
+#define PTP_TX_EGRESS_NS_LO			0x0295
+#define PTP_TX_MSG_HEADER2			0x0299
+
+#define PTP_RX_INGRESS_SEC_HI			0x0256
+#define PTP_RX_INGRESS_SEC_LO			0x0257
+#define PTP_RX_INGRESS_NS_HI			0x0254
+#define PTP_RX_INGRESS_NS_LO			0x0255
+#define PTP_RX_MSG_HEADER2			0x0259
+
+#define PTP_TSU_INT_EN				0x0200
+#define PTP_TSU_INT_EN_PTP_TX_TS_OVRFL_EN_	BIT(3)
+#define PTP_TSU_INT_EN_PTP_TX_TS_EN_		BIT(2)
+#define PTP_TSU_INT_EN_PTP_RX_TS_OVRFL_EN_	BIT(1)
+#define PTP_TSU_INT_EN_PTP_RX_TS_EN_		BIT(0)
+
+#define PTP_TSU_INT_STS				0x0201
+#define PTP_TSU_INT_STS_PTP_TX_TS_OVRFL_INT_	BIT(3)
+#define PTP_TSU_INT_STS_PTP_TX_TS_EN_		BIT(2)
+#define PTP_TSU_INT_STS_PTP_RX_TS_OVRFL_INT_	BIT(1)
+#define PTP_TSU_INT_STS_PTP_RX_TS_EN_		BIT(0)
+
 /* PHY Control 1 */
 #define MII_KSZPHY_CTRL_1			0x1e
 #define KSZ8081_CTRL1_MDIX_STAT			BIT(4)
@@ -108,6 +225,7 @@
 #define MII_KSZPHY_TX_DATA_PAD_SKEW		0x106
 
 #define PS_TO_REG				200
+#define FIFO_SIZE				8
 
 struct kszphy_hw_stat {
 	const char *string;
@@ -128,7 +246,57 @@ struct kszphy_type {
 	bool has_rmii_ref_clk_sel;
 };
 
+/* Shared structure between the PHYs of the same package. */
+struct lan8814_shared_priv {
+	struct phy_device *phydev;
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_clock_info;
+
+	/* Reference counter to how many ports in the package are enabling the
+	 * timestamping
+	 */
+	u8 ref;
+
+	/* Lock for ptp_clock and ref */
+	struct mutex shared_lock;
+};
+
+struct lan8814_ptp_rx_ts {
+	struct list_head list;
+	u32 seconds;
+	u32 nsec;
+	u16 seq_id;
+};
+
+struct kszphy_latencies {
+	u16 rx_10;
+	u16 tx_10;
+	u16 rx_100;
+	u16 tx_100;
+	u16 rx_1000;
+	u16 tx_1000;
+};
+
+struct kszphy_ptp_priv {
+	struct mii_timestamper mii_ts;
+	struct phy_device *phydev;
+
+	struct sk_buff_head tx_queue;
+	struct sk_buff_head rx_queue;
+
+	struct list_head rx_ts_list;
+	/* Lock for Rx ts fifo */
+	spinlock_t rx_ts_lock;
+
+	int hwts_tx_type;
+	enum hwtstamp_rx_filters rx_filter;
+	int layer;
+	int version;
+};
+
 struct kszphy_priv {
+	struct kszphy_ptp_priv ptp_priv;
+	struct kszphy_latencies latencies;
 	const struct kszphy_type *type;
 	int led_mode;
 	bool rmii_ref_clk_sel;
@@ -136,6 +304,14 @@ struct kszphy_priv {
 	u64 stats[ARRAY_SIZE(kszphy_hw_stats)];
 };
 
+static struct kszphy_latencies lan8814_latencies = {
+	.rx_10		= 0x22AA,
+	.tx_10		= 0x2E4A,
+	.rx_100		= 0x092A,
+	.tx_100		= 0x02C1,
+	.rx_1000	= 0x01AD,
+	.tx_1000	= 0x00C9,
+};
 static const struct kszphy_type ksz8021_type = {
 	.led_mode_reg		= MII_KSZPHY_CTRL_2,
 	.has_broadcast_disable	= true,
@@ -1624,29 +1800,667 @@ static int lanphy_write_page_reg(struct phy_device *phydev, int page, u16 addr,
 	return val;
 }
 
-static int lan8814_config_init(struct phy_device *phydev)
+static int lan8814_config_ts_intr(struct phy_device *phydev, bool enable)
 {
-	int val;
+	u16 val = 0;
 
-	/* Reset the PHY */
-	val = lanphy_read_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET);
-	val |= LAN8814_QSGMII_SOFT_RESET_BIT;
-	lanphy_write_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET, val);
+	if (enable)
+		val = PTP_TSU_INT_EN_PTP_TX_TS_EN_ |
+		      PTP_TSU_INT_EN_PTP_TX_TS_OVRFL_EN_ |
+		      PTP_TSU_INT_EN_PTP_RX_TS_EN_ |
+		      PTP_TSU_INT_EN_PTP_RX_TS_OVRFL_EN_;
 
-	/* Disable ANEG with QSGMII PCS Host side */
-	val = lanphy_read_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG);
-	val &= ~LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA;
-	lanphy_write_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG, val);
+	return lanphy_write_page_reg(phydev, 5, PTP_TSU_INT_EN, val);
+}
 
-	/* MDI-X setting for swap A,B transmit */
-	val = lanphy_read_page_reg(phydev, 2, LAN8814_ALIGN_SWAP);
-	val &= ~LAN8814_ALIGN_TX_A_B_SWAP_MASK;
-	val |= LAN8814_ALIGN_TX_A_B_SWAP;
-	lanphy_write_page_reg(phydev, 2, LAN8814_ALIGN_SWAP, val);
+static void lan8814_ptp_rx_ts_get(struct phy_device *phydev,
+				  u32 *seconds, u32 *nano_seconds, u16 *seq_id)
+{
+	*seconds = lanphy_read_page_reg(phydev, 5, PTP_RX_INGRESS_SEC_HI);
+	*seconds = (*seconds << 16) |
+		   lanphy_read_page_reg(phydev, 5, PTP_RX_INGRESS_SEC_LO);
+
+	*nano_seconds = lanphy_read_page_reg(phydev, 5, PTP_RX_INGRESS_NS_HI);
+	*nano_seconds = ((*nano_seconds & 0x3fff) << 16) |
+			lanphy_read_page_reg(phydev, 5, PTP_RX_INGRESS_NS_LO);
+
+	*seq_id = lanphy_read_page_reg(phydev, 5, PTP_RX_MSG_HEADER2);
+}
+
+static void lan8814_ptp_tx_ts_get(struct phy_device *phydev,
+				  u32 *seconds, u32 *nano_seconds, u16 *seq_id)
+{
+	*seconds = lanphy_read_page_reg(phydev, 5, PTP_TX_EGRESS_SEC_HI);
+	*seconds = *seconds << 16 |
+		   lanphy_read_page_reg(phydev, 5, PTP_TX_EGRESS_SEC_LO);
+
+	*nano_seconds = lanphy_read_page_reg(phydev, 5, PTP_TX_EGRESS_NS_HI);
+	*nano_seconds = ((*nano_seconds & 0x3fff) << 16) |
+			lanphy_read_page_reg(phydev, 5, PTP_TX_EGRESS_NS_LO);
+
+	*seq_id = lanphy_read_page_reg(phydev, 5, PTP_TX_MSG_HEADER2);
+}
+
+static int lan8814_ts_info(struct mii_timestamper *mii_ts, struct ethtool_ts_info *info)
+{
+	struct kszphy_ptp_priv *ptp_priv = container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
+	struct phy_device *phydev = ptp_priv->phydev;
+	struct lan8814_shared_priv *shared = phydev->shared->priv;
+
+	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	info->phc_index = ptp_clock_index(shared->ptp_clock);
+
+	info->tx_types =
+		(1 << HWTSTAMP_TX_OFF) |
+		(1 << HWTSTAMP_TX_ON) |
+		(1 << HWTSTAMP_TX_ONESTEP_SYNC);
+
+	info->rx_filters =
+		(1 << HWTSTAMP_FILTER_NONE) |
+		(1 << HWTSTAMP_FILTER_PTP_V1_L4_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
+
+	return 0;
+}
+
+static void lan8814_flush_fifo(struct phy_device *phydev, bool egress)
+{
+	int i;
+
+	for (i = 0; i < FIFO_SIZE; ++i)
+		lanphy_read_page_reg(phydev, 5,
+				     egress ? PTP_TX_MSG_HEADER2 : PTP_RX_MSG_HEADER2);
+
+	/* Read to clear overflow status bit */
+	lanphy_read_page_reg(phydev, 5, PTP_TSU_INT_STS);
+}
+
+static int lan8814_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
+{
+	struct kszphy_ptp_priv *ptp_priv =
+			  container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
+	struct phy_device *phydev = ptp_priv->phydev;
+	struct lan8814_shared_priv *shared = phydev->shared->priv;
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
+	if (ptp_priv->layer & PTP_CLASS_L2) {
+		rxcfg = PTP_RX_PARSE_CONFIG_LAYER2_EN_;
+		txcfg = PTP_TX_PARSE_CONFIG_LAYER2_EN_;
+	} else if (ptp_priv->layer & PTP_CLASS_L4) {
+		rxcfg |= PTP_RX_PARSE_CONFIG_IPV4_EN_ | PTP_RX_PARSE_CONFIG_IPV6_EN_;
+		txcfg |= PTP_TX_PARSE_CONFIG_IPV4_EN_ | PTP_TX_PARSE_CONFIG_IPV6_EN_;
+	}
+	lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_RX_PARSE_CONFIG, rxcfg);
+	lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_PARSE_CONFIG, txcfg);
+
+	pkt_ts_enable = PTP_TIMESTAMP_EN_SYNC_ | PTP_TIMESTAMP_EN_DREQ_ |
+			PTP_TIMESTAMP_EN_PDREQ_ | PTP_TIMESTAMP_EN_PDRES_;
+	lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_RX_TIMESTAMP_EN, pkt_ts_enable);
+	lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_TIMESTAMP_EN, pkt_ts_enable);
+
+	if (ptp_priv->hwts_tx_type == HWTSTAMP_TX_ONESTEP_SYNC)
+		lanphy_write_page_reg(ptp_priv->phydev, 5, PTP_TX_MOD,
+				      PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_);
+
+	if (config.rx_filter != HWTSTAMP_FILTER_NONE)
+		lan8814_config_ts_intr(ptp_priv->phydev, true);
+	else
+		lan8814_config_ts_intr(ptp_priv->phydev, false);
+
+	mutex_lock(&shared->shared_lock);
+	if (config.rx_filter != HWTSTAMP_FILTER_NONE)
+		shared->ref++;
+	else
+		shared->ref--;
+
+	if (shared->ref)
+		lanphy_write_page_reg(ptp_priv->phydev, 4, PTP_CMD_CTL,
+				      PTP_CMD_CTL_PTP_ENABLE_);
+	else
+		lanphy_write_page_reg(ptp_priv->phydev, 4, PTP_CMD_CTL,
+				      PTP_CMD_CTL_PTP_DISABLE_);
+	mutex_unlock(&shared->shared_lock);
+
+	/* In case of multiple starts and stops, these needs to be cleared */
+	list_for_each_entry_safe(rx_ts, tmp, &ptp_priv->rx_ts_list, list) {
+		list_del(&rx_ts->list);
+		kfree(rx_ts);
+	}
+	skb_queue_purge(&ptp_priv->rx_queue);
+	skb_queue_purge(&ptp_priv->tx_queue);
+
+	lan8814_flush_fifo(ptp_priv->phydev, false);
+	lan8814_flush_fifo(ptp_priv->phydev, true);
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ? -EFAULT : 0;
+}
+
+static bool is_sync(struct sk_buff *skb, int type)
+{
+	struct ptp_header *hdr;
+
+	hdr = ptp_parse_header(skb, type);
+	if (!hdr)
+		return false;
+
+	return ((ptp_get_msgtype(hdr, type) & 0xf) == 0);
+}
+
+static void lan8814_txtstamp(struct mii_timestamper *mii_ts,
+			     struct sk_buff *skb, int type)
+{
+	struct kszphy_ptp_priv *ptp_priv = container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
+
+	switch (ptp_priv->hwts_tx_type) {
+	case HWTSTAMP_TX_ONESTEP_SYNC:
+		if (is_sync(skb, type)) {
+			kfree_skb(skb);
+			return;
+		}
+		fallthrough;
+	case HWTSTAMP_TX_ON:
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		skb_queue_tail(&ptp_priv->tx_queue, skb);
+		break;
+	case HWTSTAMP_TX_OFF:
+	default:
+		kfree_skb(skb);
+		break;
+	}
+}
+
+static void lan8814_get_sig_rx(struct sk_buff *skb, u16 *sig)
+{
+	struct ptp_header *ptp_header;
+	u32 type;
+
+	skb_push(skb, ETH_HLEN);
+	type = ptp_classify_raw(skb);
+	ptp_header = ptp_parse_header(skb, type);
+	skb_pull_inline(skb, ETH_HLEN);
+
+	*sig = (__force u16)(ntohs(ptp_header->sequence_id));
+}
+
+static bool lan8814_match_rx_ts(struct kszphy_ptp_priv *ptp_priv,
+				struct sk_buff *skb)
+{
+	struct skb_shared_hwtstamps *shhwtstamps;
+	struct lan8814_ptp_rx_ts *rx_ts, *tmp;
+	unsigned long flags;
+	bool ret = false;
+	u16 skb_sig;
+
+	lan8814_get_sig_rx(skb, &skb_sig);
+
+	/* Iterate over all RX timestamps and match it with the received skbs */
+	spin_lock_irqsave(&ptp_priv->rx_ts_lock, flags);
+	list_for_each_entry_safe(rx_ts, tmp, &ptp_priv->rx_ts_list, list) {
+		/* Check if we found the signature we were looking for. */
+		if (memcmp(&skb_sig, &rx_ts->seq_id, sizeof(rx_ts->seq_id)))
+			continue;
+
+		shhwtstamps = skb_hwtstamps(skb);
+		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+		shhwtstamps->hwtstamp = ktime_set(rx_ts->seconds,
+						  rx_ts->nsec);
+		netif_rx_ni(skb);
+
+		list_del(&rx_ts->list);
+		kfree(rx_ts);
+
+		ret = true;
+		break;
+	}
+	spin_unlock_irqrestore(&ptp_priv->rx_ts_lock, flags);
+
+	return ret;
+}
+
+static bool lan8814_rxtstamp(struct mii_timestamper *mii_ts, struct sk_buff *skb, int type)
+{
+	struct kszphy_ptp_priv *ptp_priv =
+			container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
+
+	if (ptp_priv->rx_filter == HWTSTAMP_FILTER_NONE ||
+	    type == PTP_CLASS_NONE)
+		return false;
+
+	if ((type & ptp_priv->version) == 0 || (type & ptp_priv->layer) == 0)
+		return false;
+
+	/* If we failed to match then add it to the queue for when the timestamp
+	 * will come
+	 */
+	if (!lan8814_match_rx_ts(ptp_priv, skb))
+		skb_queue_tail(&ptp_priv->rx_queue, skb);
+
+	return true;
+}
+
+static void lan8814_ptp_clock_set(struct phy_device *phydev,
+				  u32 seconds, u32 nano_seconds)
+{
+	u32 sec_low, sec_high, nsec_low, nsec_high;
+
+	sec_low = seconds & 0xffff;
+	sec_high = (seconds >> 16) & 0xffff;
+	nsec_low = nano_seconds & 0xffff;
+	nsec_high = (nano_seconds >> 16) & 0x3fff;
+
+	lanphy_write_page_reg(phydev, 4, PTP_CLOCK_SET_SEC_LO, sec_low);
+	lanphy_write_page_reg(phydev, 4, PTP_CLOCK_SET_SEC_MID, sec_high);
+	lanphy_write_page_reg(phydev, 4, PTP_CLOCK_SET_NS_LO, nsec_low);
+	lanphy_write_page_reg(phydev, 4, PTP_CLOCK_SET_NS_HI, nsec_high);
+
+	lanphy_write_page_reg(phydev, 4, PTP_CMD_CTL, PTP_CMD_CTL_PTP_CLOCK_LOAD_);
+}
+
+static void lan8814_ptp_clock_get(struct phy_device *phydev,
+				  u32 *seconds, u32 *nano_seconds)
+{
+	lanphy_write_page_reg(phydev, 4, PTP_CMD_CTL, PTP_CMD_CTL_PTP_CLOCK_READ_);
+
+	*seconds = lanphy_read_page_reg(phydev, 4, PTP_CLOCK_READ_SEC_MID);
+	*seconds = (*seconds << 16) |
+		   lanphy_read_page_reg(phydev, 4, PTP_CLOCK_READ_SEC_LO);
+
+	*nano_seconds = lanphy_read_page_reg(phydev, 4, PTP_CLOCK_READ_NS_HI);
+	*nano_seconds = ((*nano_seconds & 0x3fff) << 16) |
+			lanphy_read_page_reg(phydev, 4, PTP_CLOCK_READ_NS_LO);
+}
+
+static int lan8814_ptpci_gettime64(struct ptp_clock_info *ptpci,
+				   struct timespec64 *ts)
+{
+	struct lan8814_shared_priv *shared = container_of(ptpci, struct lan8814_shared_priv,
+							  ptp_clock_info);
+	struct phy_device *phydev = shared->phydev;
+	u32 nano_seconds;
+	u32 seconds;
+
+	mutex_lock(&shared->shared_lock);
+	lan8814_ptp_clock_get(phydev, &seconds, &nano_seconds);
+	mutex_unlock(&shared->shared_lock);
+	ts->tv_sec = seconds;
+	ts->tv_nsec = nano_seconds;
 
 	return 0;
 }
 
+static int lan8814_ptpci_settime64(struct ptp_clock_info *ptpci,
+				   const struct timespec64 *ts)
+{
+	struct lan8814_shared_priv *shared = container_of(ptpci, struct lan8814_shared_priv,
+							  ptp_clock_info);
+	struct phy_device *phydev = shared->phydev;
+
+	mutex_lock(&shared->shared_lock);
+	lan8814_ptp_clock_set(phydev, ts->tv_sec, ts->tv_nsec);
+	mutex_unlock(&shared->shared_lock);
+
+	return 0;
+}
+
+static void lan8814_ptp_clock_step(struct phy_device *phydev,
+				   s64 time_step_ns)
+{
+	u32 nano_seconds_step;
+	u64 abs_time_step_ns;
+	u32 unsigned_seconds;
+	u32 nano_seconds;
+	u32 remainder;
+	s32 seconds;
+
+	if (time_step_ns >  15000000000LL) {
+		/* convert to clock set */
+		lan8814_ptp_clock_get(phydev, &unsigned_seconds, &nano_seconds);
+		unsigned_seconds += div_u64_rem(time_step_ns, 1000000000LL,
+						&remainder);
+		nano_seconds += remainder;
+		if (nano_seconds >= 1000000000) {
+			unsigned_seconds++;
+			nano_seconds -= 1000000000;
+		}
+		lan8814_ptp_clock_set(phydev, unsigned_seconds, nano_seconds);
+		return;
+	} else if (time_step_ns < -15000000000LL) {
+		/* convert to clock set */
+		time_step_ns = -time_step_ns;
+
+		lan8814_ptp_clock_get(phydev, &unsigned_seconds, &nano_seconds);
+		unsigned_seconds -= div_u64_rem(time_step_ns, 1000000000LL,
+						&remainder);
+		nano_seconds_step = remainder;
+		if (nano_seconds < nano_seconds_step) {
+			unsigned_seconds--;
+			nano_seconds += 1000000000;
+		}
+		nano_seconds -= nano_seconds_step;
+		lan8814_ptp_clock_set(phydev, unsigned_seconds,
+				      nano_seconds);
+		return;
+	}
+
+	/* do clock step */
+	if (time_step_ns >= 0) {
+		abs_time_step_ns = (u64)time_step_ns;
+		seconds = (s32)div_u64_rem(abs_time_step_ns, 1000000000,
+					   &remainder);
+		nano_seconds = remainder;
+	} else {
+		abs_time_step_ns = (u64)(-time_step_ns);
+		seconds = -((s32)div_u64_rem(abs_time_step_ns, 1000000000,
+			    &remainder));
+		nano_seconds = remainder;
+		if (nano_seconds > 0) {
+			/* subtracting nano seconds is not allowed
+			 * convert to subtracting from seconds,
+			 * and adding to nanoseconds
+			 */
+			seconds--;
+			nano_seconds = (1000000000 - nano_seconds);
+		}
+	}
+
+	if (nano_seconds > 0) {
+		/* add 8 ns to cover the likely normal increment */
+		nano_seconds += 8;
+	}
+
+	if (nano_seconds >= 1000000000) {
+		/* carry into seconds */
+		seconds++;
+		nano_seconds -= 1000000000;
+	}
+
+	while (seconds) {
+		if (seconds > 0) {
+			u32 adjustment_value = (u32)seconds;
+			u16 adjustment_value_lo, adjustment_value_hi;
+
+			if (adjustment_value > 0xF)
+				adjustment_value = 0xF;
+
+			adjustment_value_lo = adjustment_value & 0xffff;
+			adjustment_value_hi = (adjustment_value >> 16) & 0x3fff;
+
+			lanphy_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_LO,
+					      adjustment_value_lo);
+			lanphy_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_HI,
+					      PTP_LTC_STEP_ADJ_DIR_ |
+					      adjustment_value_hi);
+			seconds -= ((s32)adjustment_value);
+		} else {
+			u32 adjustment_value = (u32)(-seconds);
+			u16 adjustment_value_lo, adjustment_value_hi;
+
+			if (adjustment_value > 0xF)
+				adjustment_value = 0xF;
+
+			adjustment_value_lo = adjustment_value & 0xffff;
+			adjustment_value_hi = (adjustment_value >> 16) & 0x3fff;
+
+			lanphy_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_LO,
+					      adjustment_value_lo);
+			lanphy_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_HI,
+					      adjustment_value_hi);
+			seconds += ((s32)adjustment_value);
+		}
+		lanphy_write_page_reg(phydev, 4, PTP_CMD_CTL,
+				      PTP_CMD_CTL_PTP_LTC_STEP_SEC_);
+	}
+	if (nano_seconds) {
+		u16 nano_seconds_lo;
+		u16 nano_seconds_hi;
+
+		nano_seconds_lo = nano_seconds & 0xffff;
+		nano_seconds_hi = (nano_seconds >> 16) & 0x3fff;
+
+		lanphy_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_LO,
+				      nano_seconds_lo);
+		lanphy_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_HI,
+				      PTP_LTC_STEP_ADJ_DIR_ |
+				      nano_seconds_hi);
+		lanphy_write_page_reg(phydev, 4, PTP_CMD_CTL,
+				      PTP_CMD_CTL_PTP_LTC_STEP_NSEC_);
+	}
+}
+
+static int lan8814_ptpci_adjtime(struct ptp_clock_info *ptpci, s64 delta)
+{
+	struct lan8814_shared_priv *shared = container_of(ptpci, struct lan8814_shared_priv,
+							  ptp_clock_info);
+	struct phy_device *phydev = shared->phydev;
+
+	mutex_lock(&shared->shared_lock);
+	lan8814_ptp_clock_step(phydev, delta);
+	mutex_unlock(&shared->shared_lock);
+
+	return 0;
+}
+
+static int lan8814_ptpci_adjfine(struct ptp_clock_info *ptpci, long scaled_ppm)
+{
+	struct lan8814_shared_priv *shared = container_of(ptpci, struct lan8814_shared_priv,
+							  ptp_clock_info);
+	struct phy_device *phydev = shared->phydev;
+	u16 kszphy_rate_adj_lo, kszphy_rate_adj_hi;
+	bool positive = true;
+	u32 kszphy_rate_adj;
+
+	if (scaled_ppm < 0) {
+		scaled_ppm = -scaled_ppm;
+		positive = false;
+	}
+
+	kszphy_rate_adj = LAN8814_1PPM_FORMAT * (scaled_ppm >> 16);
+	kszphy_rate_adj += (LAN8814_1PPM_FORMAT * (0xffff & scaled_ppm)) >> 16;
+
+	kszphy_rate_adj_lo = kszphy_rate_adj & 0xffff;
+	kszphy_rate_adj_hi = (kszphy_rate_adj >> 16) & 0x3fff;
+
+	if (positive)
+		kszphy_rate_adj_hi |= PTP_CLOCK_RATE_ADJ_DIR_;
+
+	mutex_lock(&shared->shared_lock);
+	lanphy_write_page_reg(phydev, 4, PTP_CLOCK_RATE_ADJ_HI, kszphy_rate_adj_hi);
+	lanphy_write_page_reg(phydev, 4, PTP_CLOCK_RATE_ADJ_LO, kszphy_rate_adj_lo);
+	mutex_unlock(&shared->shared_lock);
+
+	return 0;
+}
+
+static void lan8814_get_sig_tx(struct sk_buff *skb, u16 *sig)
+{
+	struct ptp_header *ptp_header;
+	u32 type;
+
+	type = ptp_classify_raw(skb);
+	ptp_header = ptp_parse_header(skb, type);
+
+	*sig = (__force u16)(ntohs(ptp_header->sequence_id));
+}
+
+static void lan8814_dequeue_tx_skb(struct kszphy_ptp_priv *ptp_priv)
+{
+	struct phy_device *phydev = ptp_priv->phydev;
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct sk_buff *skb, *skb_tmp;
+	unsigned long flags;
+	u32 seconds, nsec;
+	bool ret = false;
+	u16 skb_sig;
+	u16 seq_id;
+
+	lan8814_ptp_tx_ts_get(phydev, &seconds, &nsec, &seq_id);
+
+	spin_lock_irqsave(&ptp_priv->tx_queue.lock, flags);
+	skb_queue_walk_safe(&ptp_priv->tx_queue, skb, skb_tmp) {
+		lan8814_get_sig_tx(skb, &skb_sig);
+
+		if (memcmp(&skb_sig, &seq_id, sizeof(seq_id)))
+			continue;
+
+		__skb_unlink(skb, &ptp_priv->tx_queue);
+		ret = true;
+		break;
+	}
+	spin_unlock_irqrestore(&ptp_priv->tx_queue.lock, flags);
+
+	if (ret) {
+		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+		shhwtstamps.hwtstamp = ktime_set(seconds, nsec);
+		skb_complete_tx_timestamp(skb, &shhwtstamps);
+	}
+}
+
+static void lan8814_get_tx_ts(struct kszphy_ptp_priv *ptp_priv)
+{
+	struct phy_device *phydev = ptp_priv->phydev;
+	u32 reg;
+
+	do {
+		lan8814_dequeue_tx_skb(ptp_priv);
+
+		/* If other timestamps are available in the FIFO,
+		 * process them.
+		 */
+		reg = lanphy_read_page_reg(phydev, 5, PTP_CAP_INFO);
+	} while (PTP_CAP_INFO_TX_TS_CNT_GET_(reg) > 0);
+}
+
+static bool lan8814_match_skb(struct kszphy_ptp_priv *ptp_priv,
+			      struct lan8814_ptp_rx_ts *rx_ts)
+{
+	struct skb_shared_hwtstamps *shhwtstamps;
+	struct sk_buff *skb, *skb_tmp;
+	unsigned long flags;
+	bool ret = false;
+	u16 skb_sig;
+
+	spin_lock_irqsave(&ptp_priv->rx_queue.lock, flags);
+	skb_queue_walk_safe(&ptp_priv->rx_queue, skb, skb_tmp) {
+		lan8814_get_sig_rx(skb, &skb_sig);
+
+		if (memcmp(&skb_sig, &rx_ts->seq_id, sizeof(rx_ts->seq_id)))
+			continue;
+
+		__skb_unlink(skb, &ptp_priv->rx_queue);
+
+		ret = true;
+		break;
+	}
+	spin_unlock_irqrestore(&ptp_priv->rx_queue.lock, flags);
+
+	if (ret) {
+		shhwtstamps = skb_hwtstamps(skb);
+		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+		shhwtstamps->hwtstamp = ktime_set(rx_ts->seconds, rx_ts->nsec);
+		netif_rx_ni(skb);
+	}
+
+	return ret;
+}
+
+static void lan8814_get_rx_ts(struct kszphy_ptp_priv *ptp_priv)
+{
+	struct phy_device *phydev = ptp_priv->phydev;
+	struct lan8814_ptp_rx_ts *rx_ts;
+	unsigned long flags;
+	u32 reg;
+
+	do {
+		rx_ts = kzalloc(sizeof(*rx_ts), GFP_KERNEL);
+		if (!rx_ts)
+			return;
+
+		lan8814_ptp_rx_ts_get(phydev, &rx_ts->seconds, &rx_ts->nsec,
+				      &rx_ts->seq_id);
+
+		/* If we failed to match the skb add it to the queue for when
+		 * the frame will come
+		 */
+		if (!lan8814_match_skb(ptp_priv, rx_ts)) {
+			spin_lock_irqsave(&ptp_priv->rx_ts_lock, flags);
+			list_add(&rx_ts->list, &ptp_priv->rx_ts_list);
+			spin_unlock_irqrestore(&ptp_priv->rx_ts_lock, flags);
+		} else {
+			kfree(rx_ts);
+		}
+
+		/* If other timestamps are available in the FIFO,
+		 * process them.
+		 */
+		reg = lanphy_read_page_reg(phydev, 5, PTP_CAP_INFO);
+	} while (PTP_CAP_INFO_RX_TS_CNT_GET_(reg) > 0);
+}
+
+static void lan8814_handle_ptp_interrupt(struct phy_device *phydev)
+{
+	struct kszphy_priv *priv = phydev->priv;
+	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
+	u16 status;
+
+	status = lanphy_read_page_reg(phydev, 5, PTP_TSU_INT_STS);
+	if (status & PTP_TSU_INT_STS_PTP_TX_TS_EN_)
+		lan8814_get_tx_ts(ptp_priv);
+
+	if (status & PTP_TSU_INT_STS_PTP_RX_TS_EN_)
+		lan8814_get_rx_ts(ptp_priv);
+
+	if (status & PTP_TSU_INT_STS_PTP_TX_TS_OVRFL_INT_) {
+		lan8814_flush_fifo(phydev, true);
+		skb_queue_purge(&ptp_priv->tx_queue);
+	}
+
+	if (status & PTP_TSU_INT_STS_PTP_RX_TS_OVRFL_INT_) {
+		lan8814_flush_fifo(phydev, false);
+		skb_queue_purge(&ptp_priv->rx_queue);
+	}
+}
+
 static int lan8804_config_init(struct phy_device *phydev)
 {
 	int val;
@@ -1668,17 +2482,31 @@ static int lan8804_config_init(struct phy_device *phydev)
 
 static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 {
+	u16 tsu_irq_status;
 	int irq_status;
 
 	irq_status = phy_read(phydev, LAN8814_INTS);
-	if (irq_status < 0)
-		return IRQ_NONE;
+	if (irq_status > 0 && (irq_status & LAN8814_INT_LINK))
+		phy_trigger_machine(phydev);
 
-	if (!(irq_status & LAN8814_INT_LINK))
+	if (irq_status < 0) {
+		phy_error(phydev);
 		return IRQ_NONE;
+	}
 
-	phy_trigger_machine(phydev);
+	while (1) {
+		tsu_irq_status = lanphy_read_page_reg(phydev, 4,
+						      LAN8814_INTR_STS_REG);
 
+		if (tsu_irq_status > 0 &&
+		    (tsu_irq_status & (LAN8814_INTR_STS_REG_1588_TSU0_ |
+				       LAN8814_INTR_STS_REG_1588_TSU1_ |
+				       LAN8814_INTR_STS_REG_1588_TSU2_ |
+				       LAN8814_INTR_STS_REG_1588_TSU3_)))
+			lan8814_handle_ptp_interrupt(phydev);
+		else
+			break;
+	}
 	return IRQ_HANDLED;
 }
 
@@ -1718,6 +2546,223 @@ static int lan8814_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static void lan8814_ptp_init(struct phy_device *phydev)
+{
+	struct kszphy_priv *priv = phydev->priv;
+	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
+	u32 temp;
+
+	lanphy_write_page_reg(phydev, 5, TSU_HARD_RESET, TSU_HARD_RESET_);
+
+	temp = lanphy_read_page_reg(phydev, 5, PTP_TX_MOD);
+	temp |= PTP_TX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_;
+	lanphy_write_page_reg(phydev, 5, PTP_TX_MOD, temp);
+
+	temp = lanphy_read_page_reg(phydev, 5, PTP_RX_MOD);
+	temp |= PTP_RX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_;
+	lanphy_write_page_reg(phydev, 5, PTP_RX_MOD, temp);
+
+	lanphy_write_page_reg(phydev, 5, PTP_RX_PARSE_CONFIG, 0);
+	lanphy_write_page_reg(phydev, 5, PTP_TX_PARSE_CONFIG, 0);
+
+	/* Removing default registers configs related to L2 and IP */
+	lanphy_write_page_reg(phydev, 5, PTP_TX_PARSE_L2_ADDR_EN, 0);
+	lanphy_write_page_reg(phydev, 5, PTP_RX_PARSE_L2_ADDR_EN, 0);
+	lanphy_write_page_reg(phydev, 5, PTP_TX_PARSE_IP_ADDR_EN, 0);
+	lanphy_write_page_reg(phydev, 5, PTP_RX_PARSE_IP_ADDR_EN, 0);
+
+	skb_queue_head_init(&ptp_priv->tx_queue);
+	skb_queue_head_init(&ptp_priv->rx_queue);
+	INIT_LIST_HEAD(&ptp_priv->rx_ts_list);
+	spin_lock_init(&ptp_priv->rx_ts_lock);
+
+	ptp_priv->phydev = phydev;
+
+	ptp_priv->mii_ts.rxtstamp = lan8814_rxtstamp;
+	ptp_priv->mii_ts.txtstamp = lan8814_txtstamp;
+	ptp_priv->mii_ts.hwtstamp = lan8814_hwtstamp;
+	ptp_priv->mii_ts.ts_info  = lan8814_ts_info;
+
+	phydev->mii_ts = &ptp_priv->mii_ts;
+}
+
+static int lan8814_ptp_probe_once(struct phy_device *phydev)
+{
+	struct lan8814_shared_priv *shared = phydev->shared->priv;
+
+	/* Initialise shared lock for clock*/
+	mutex_init(&shared->shared_lock);
+
+	shared->ptp_clock_info.owner = THIS_MODULE;
+	snprintf(shared->ptp_clock_info.name, 30, "%s", phydev->drv->name);
+	shared->ptp_clock_info.max_adj = 31249999;
+	shared->ptp_clock_info.n_alarm = 0;
+	shared->ptp_clock_info.n_ext_ts = 0;
+	shared->ptp_clock_info.n_pins = 0;
+	shared->ptp_clock_info.pps = 0;
+	shared->ptp_clock_info.pin_config = NULL;
+	shared->ptp_clock_info.adjfine = lan8814_ptpci_adjfine;
+	shared->ptp_clock_info.adjtime = lan8814_ptpci_adjtime;
+	shared->ptp_clock_info.gettime64 = lan8814_ptpci_gettime64;
+	shared->ptp_clock_info.settime64 = lan8814_ptpci_settime64;
+	shared->ptp_clock_info.getcrosststamp = NULL;
+
+	shared->ptp_clock = ptp_clock_register(&shared->ptp_clock_info,
+					       &phydev->mdio.dev);
+	if (IS_ERR_OR_NULL(shared->ptp_clock)) {
+		phydev_err(phydev, "ptp_clock_register failed %lu\n",
+			   PTR_ERR(shared->ptp_clock));
+		return -EINVAL;
+	}
+
+	phydev_dbg(phydev, "successfully registered ptp clock\n");
+
+	shared->phydev = phydev;
+
+	/* The EP.4 is shared between all the PHYs in the package and also it
+	 * can be accessed by any of the PHYs
+	 */
+	lanphy_write_page_reg(phydev, 4, LTC_HARD_RESET, LTC_HARD_RESET_);
+	lanphy_write_page_reg(phydev, 4, PTP_OPERATING_MODE,
+			      PTP_OPERATING_MODE_STANDALONE_);
+
+	return 0;
+}
+
+static int lan8814_read_status(struct phy_device *phydev)
+{
+	struct kszphy_priv *priv = phydev->priv;
+	struct kszphy_latencies *latencies = &priv->latencies;
+	int err;
+	int regval;
+
+	err = genphy_read_status(phydev);
+	if (err)
+		return err;
+
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
+
+	/* Make sure the PHY is not broken. Read idle error count,
+	 * and reset the PHY if it is maxed out.
+	 */
+	regval = phy_read(phydev, MII_STAT1000);
+	if ((regval & 0xFF) == 0xFF) {
+		phy_init_hw(phydev);
+		phydev->link = 0;
+		if (phydev->drv->config_intr && phy_interrupt_is_valid(phydev))
+			phydev->drv->config_intr(phydev);
+		return genphy_config_aneg(phydev);
+	}
+
+	return 0;
+}
+
+static int lan8814_config_init(struct phy_device *phydev)
+{
+	int val;
+
+	/* Reset the PHY */
+	val = lanphy_read_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET);
+	val |= LAN8814_QSGMII_SOFT_RESET_BIT;
+	lanphy_write_page_reg(phydev, 4, LAN8814_QSGMII_SOFT_RESET, val);
+
+	/* Disable ANEG with QSGMII PCS Host side */
+	val = lanphy_read_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG);
+	val &= ~LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA;
+	lanphy_write_page_reg(phydev, 5, LAN8814_QSGMII_PCS1G_ANEG_CONFIG, val);
+
+	/* MDI-X setting for swap A,B transmit */
+	val = lanphy_read_page_reg(phydev, 2, LAN8814_ALIGN_SWAP);
+	val &= ~LAN8814_ALIGN_TX_A_B_SWAP_MASK;
+	val |= LAN8814_ALIGN_TX_A_B_SWAP;
+	lanphy_write_page_reg(phydev, 2, LAN8814_ALIGN_SWAP, val);
+
+	return 0;
+}
+
+static void lan8814_parse_latency(struct phy_device *phydev)
+{
+	const struct device_node *np = phydev->mdio.dev.of_node;
+	struct kszphy_priv *priv = phydev->priv;
+	struct kszphy_latencies *latency = &priv->latencies;
+	u32 val;
+
+	if (!of_property_read_u32(np, "lan8814,latency_rx_10", &val))
+		latency->rx_10 = val;
+	if (!of_property_read_u32(np, "lan8814,latency_tx_10", &val))
+		latency->tx_10 = val;
+	if (!of_property_read_u32(np, "lan8814,latency_rx_100", &val))
+		latency->rx_100 = val;
+	if (!of_property_read_u32(np, "lan8814,latency_tx_100", &val))
+		latency->tx_100 = val;
+	if (!of_property_read_u32(np, "lan8814,latency_rx_1000", &val))
+		latency->rx_1000 = val;
+	if (!of_property_read_u32(np, "lan8814,latency_tx_1000", &val))
+		latency->tx_1000 = val;
+}
+
+static int lan8814_probe(struct phy_device *phydev)
+{
+	const struct device_node *np = phydev->mdio.dev.of_node;
+	struct kszphy_priv *priv;
+	u16 addr;
+	int err;
+
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->led_mode = -1;
+
+	priv->latencies = lan8814_latencies;
+
+	phydev->priv = priv;
+
+	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
+	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING) ||
+	    of_property_read_bool(np, "lan8814,ignore-ts"))
+		return 0;
+
+	/* Strap-in value for PHY address, below register read gives starting
+	 * phy address value
+	 */
+	addr = lanphy_read_page_reg(phydev, 4, 0) & 0x1F;
+	devm_phy_package_join(&phydev->mdio.dev, phydev,
+			      addr, sizeof(struct lan8814_shared_priv));
+
+	if (phy_package_init_once(phydev)) {
+		err = lan8814_ptp_probe_once(phydev);
+		if (err)
+			return err;
+	}
+
+	lan8814_parse_latency(phydev);
+	lan8814_ptp_init(phydev);
+
+	return 0;
+}
+
 static struct phy_driver ksphy_driver[] = {
 {
 	.phy_id		= PHY_ID_KS8737,
@@ -1892,10 +2937,9 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Microchip INDY Gigabit Quad PHY",
 	.config_init	= lan8814_config_init,
-	.driver_data	= &ksz9021_type,
-	.probe		= kszphy_probe,
+	.probe		= lan8814_probe,
 	.soft_reset	= genphy_soft_reset,
-	.read_status	= ksz9031_read_status,
+	.read_status	= lan8814_read_status,
 	.get_sset_count	= kszphy_get_sset_count,
 	.get_strings	= kszphy_get_strings,
 	.get_stats	= kszphy_get_stats,
-- 
2.17.1

