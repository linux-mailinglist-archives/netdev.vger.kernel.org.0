Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16CA2DC316
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 16:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgLPP1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 10:27:15 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:52428 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgLPP1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 10:27:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608132434; x=1639668434;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=RnoMk+DiiQ5IWzb3L++XAcXP0aLt62/El3FqW3bxA7E=;
  b=GBiTtlAi6MgkuoU8X2QG2ilvbduA7D3VXj7g5gePmalVeQ5NNeuyMNTS
   OrVc07uFTVw+wp9butg9MdIU+Zq/yP2+nzUxurIHKgB4eFPPF4PlxA8WR
   lPdaXA5YQ6DDaQcT5mU0rJePIbQ+0iCSjLnHqzHwGaB1j8zgK/TaaNVGR
   SKVWCgjNEE42lWsTMP4MqmMjiFS/jDNlye3Pe9pEEG38MRdVC1M1mZdq4
   9xLZKRS8hwheBVfnVpyLKGwFAznHaQWSp8oxO/jHJ9dflF4IDw422WblV
   jIqDEfSKax0E4Fv1Ch0WWsYuBHrUXEr0pUrPUn1GSuPpOAz+eIOEcwqkt
   w==;
IronPort-SDR: Us8k2FUxQgtKST4ERYHWteEgUvok7T9qkrG6nnvAbigTy4dZ0WmCJQD3ebXTsPg+l4Lj2p0iLg
 UEjh61iqRe4OfXdkT/KvsWY89Y7x9HLEri1meEMfwu8IhXm9OC8YOaE/WEH6mmZpijo02dF7hp
 OrLuunTZo6M/4NXtFyiXph62v6T9XuBHCFcNS0TQWcSCm3jcdS1Wf+DHRWnoqUBc/2UeBxdrX+
 X37G1IOOX8C32G5YBbewFAzW5i2QA7qrz25e92/g1i7hjNK601AxqO8+y3SbqmV6BZ+tH78fV1
 bG8=
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="97324479"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Dec 2020 08:25:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 08:25:58 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 16 Dec 2020 08:25:54 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>, <marex@denx.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>
Subject: [PATCH v3 net-next 2/2] net: phy: mchp: Add 1588 support for LAN8814 Quad PHY
Date:   Wed, 16 Dec 2020 20:55:51 +0530
Message-ID: <20201216152551.6517-1-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add supports for 1588 Hardware Timestamping support
to LAN8814 Quad Phy. It supports L2 and Ipv4 encapsulations.

Signed-off-by: Divya Koppera<divya.koppera@microchip.com>
---
v1 -> v2
    * Fixed warnings
      Reported-by: kernel test robot <lkp@intel.com>
v2 -> v3
    * Split the patch to linkup/linkdown interrupt handling
      and 1588 Driver support to LAN8814 phy.
    * Changed lan8814_priv to kszphy_ptp_priv and modified code
      Accordingly.
---
 drivers/net/phy/micrel.c | 942 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 941 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 10cb2c45be36..ab873a7d0e9f 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -86,6 +86,111 @@
 #define LAN8814_INTS_ALL			(LAN8814_INTS_LINK_UP |\
 						 LAN8814_INTS_LINK_DOWN)
 
+#define LAN8814_PTP_MAX_FREQ_ADJ_IN_PPB		(31249999)
+#define LAN8814_PTP_MAX_FINE_ADJ_IN_SCALED_PPM	(2047999934)
+
+#define PTP_RX_MOD				0x024F
+#define PTP_RX_RSVD_BYTE_CFG			0x0250
+#define PTP_RX_TIMESTAMP_EN			0x024D
+#define PTP_TX_TIMESTAMP_EN			0x028D
+
+#define PTP_TX_PARSE_L2_ADDR_EN			0x0284
+#define PTP_RX_PARSE_L2_ADDR_EN			0x0244
+#define PTP_FLAG_ISR_ENABLED			BIT(2)
+#define PTP_FLAG_PTP_CLOCK_REGISTERED		BIT(1)
+
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
+#define PTP_CLOCK_SET_SEC_HI			(0x0205)
+#define PTP_CLOCK_SET_SEC_MID			(0x0206)
+#define PTP_CLOCK_SET_SEC_LO			(0x0207)
+#define PTP_CLOCK_SET_NS_HI			(0x0208)
+#define PTP_CLOCK_SET_NS_LO			(0x0209)
+#define PTP_CLOCK_SET_SUBNS_LO			(0x020B)
+#define PTP_CLOCK_SET_SUBNS_HI			(0x020A)
+
+#define PTP_CLOCK_READ_SEC_HI			(0x0229)
+#define PTP_CLOCK_READ_SEC_MID			(0x022A)
+#define PTP_CLOCK_READ_SEC_LO			(0x022B)
+#define PTP_CLOCK_READ_NS_HI			(0x022C)
+#define PTP_CLOCK_READ_NS_LO			(0x022D)
+#define PTP_CLOCK_READ_SUBNS_HI			(0x022E)
+#define PTP_CLOCK_READ_SUBNS_LO			(0x022F)
+
+#define PTP_OPERATING_MODE			(0x0241)
+#define PTP_OPERATING_MODE_STANDALONE		0x01
+
+#define PTP_TX_MOD				(0x028F)
+#define PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_	BIT(12)
+#define PTP_TX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_ BIT(3)
+
+#define PTP_RX_PARSE_CONFIG			(0x0242)
+#define PTP_RX_PARSE_CONFIG_LAYER2_EN_		BIT(0)
+#define PTP_RX_PARSE_CONFIG_IPV4_EN_		BIT(1)
+
+#define PTP_TX_PARSE_CONFIG			(0x0282)
+#define PTP_TX_PARSE_CONFIG_LAYER2_EN_		BIT(0)
+#define PTP_TX_PARSE_CONFIG_IPV4_EN_		BIT(1)
+
+#define PTP_CLOCK_RATE_ADJ_HI_			(0x020C)
+#define PTP_CLOCK_RATE_ADJ_LO_			(0x020D)
+#define PTP_CLOCK_RATE_ADJ_DIR_			BIT(15)
+
+#define PTP_LTC_STEP_ADJ_HI			(0x0212)
+#define PTP_LTC_STEP_ADJ_LO			(0x0213)
+#define PTP_LTC_STEP_ADJ_DIR_			BIT(15)
+
+#define PTP_TX_MSG_HEADER1			(0x0298)
+#define PTP_TX_MSG_HEADER1_MSG_TYPE_		(0x000F)
+#define PTP_TX_MSG_HEADER1_MSG_TYPE_SYNC_	(0x00000000)
+
+#define LAN8814_INTR_CTRL_REG			(0x34)
+#define LAN8814_INTR_CTRL_REG_POLARITY		BIT(1)
+#define LAN8814_INTR_CTRL_REG_INTR_ENABLE	BIT(0)
+
+#define LAN8814_INTR_STS_REG			(0x33)
+#define LAN8814_INTR_STS_REG_1588_TSU0		BIT(0)
+
+#define PTP_CAP_INFO				(0x022A)
+#define PTP_CAP_INFO_TX_TS_CNT_GET_(reg_val)	(((reg_val) & 0x0f00) >> 8)
+
+#define PTP_TX_EGRESS_SEC_HI			(0x0296)
+#define PTP_TX_EGRESS_SEC_LO			(0x0297)
+#define PTP_TX_EGRESS_NS_HI			(0x0294)
+#define PTP_TX_EGRESS_NS_HI_TX_TS_VALID_	BIT(15)
+#define PTP_TX_EGRESS_NS_LO			(0x0295)
+#define PTP_TX_MSG_HEADER2			(0x0299)
+
+#define PTP_RX_INGRESS_SEC_HI			(0x0256)
+#define PTP_RX_INGRESS_SEC_LO			(0x0257)
+#define PTP_RX_INGRESS_NS_HI			(0x0254)
+#define PTP_RX_INGRESS_NS_LO			(0x0255)
+#define PTP_RX_MSG_HEADER2			(0x0259)
+
+#define PTP_TSU_INT_EN				(0x200)
+#define PTP_TSU_INT_EN_PTP_TX_TS_OVRFL_EN	BIT(3)
+#define PTP_TSU_INT_EN_PTP_TX_TS_EN		BIT(2)
+#define PTP_TSU_INT_EN_PTP_RX_TS_OVRFL_EN	BIT(1)
+#define PTP_TSU_INT_EN_PTP_RX_TS_EN		BIT(0)
+
+#define PTP_TSU_INT_STS				(0x201)
+#define PTP_TSU_INT_STS_PTP_TX_TS_OVRFL_INT	BIT(3)
+#define PTP_TSU_INT_STS_PTP_TX_TS_EN		BIT(2)
+#define PTP_TSU_INT_STS_PTP_RX_TS_OVRFL_INT	BIT(1)
+#define PTP_TSU_INT_STS_PTP_RX_TS_EN		BIT(0)
+
 /* PHY Control 1 */
 #define	MII_KSZPHY_CTRL_1			0x1e
 
@@ -132,7 +237,44 @@ struct kszphy_type {
 	bool has_rmii_ref_clk_sel;
 };
 
+struct lan8814_ptp {
+	int flags;
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info ptp_clock_info;
+	struct ptp_pin_desc pin_config[1];
+	enum hwtstamp_tx_types tx_type;
+	enum hwtstamp_rx_filters rx_filter;
+	struct sk_buff_head tx_queue;
+};
+
+struct lan8814_ptphdr {
+	u8 tsmt; /* transportSpecific | messageType */
+	u8 ver;  /* reserved0 | versionPTP */
+	__be16 msglen;
+	u8 domain;
+	u8 rsrvd1;
+	__be16 flags;
+	__be64 correction;
+	__be32 rsrvd2;
+	__be64 clk_identity;
+	__be16 src_port_id;
+	__be16 seq_id;
+	u8 ctrl;
+	u8 log_interval;
+} __attribute__((__packed__));
+
+struct kszphy_ptp_priv {
+	struct mii_timestamper mii_ts;
+	struct phy_device *phydev;
+	struct lan8814_ptp ptp;
+	int hwts_tx_en;
+	int hwts_rx_en;
+	int layer;
+	int version;
+};
+
 struct kszphy_priv {
+	struct kszphy_ptp_priv ptp_priv;
 	const struct kszphy_type *type;
 	int led_mode;
 	bool rmii_ref_clk_sel;
@@ -171,6 +313,38 @@ static const struct kszphy_type ksz9021_type = {
 	.interrupt_level_mask	= BIT(14),
 };
 
+static void lan8814_ptp_clock_get(struct phy_device *phydev,
+				  u32 *seconds, u32 *nano_seconds,
+				  u32 *sub_nano_seconds);
+
+static int lan8814_read_page_reg(struct phy_device *phydev,
+				 int page, u32 addr)
+{
+	u32 data;
+
+	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_CONTROL, page);
+	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_CONTROL, (page | 0x4000));
+	data = phy_read(phydev, KSZ_EXT_PAGE_ACCESS_ADDRESS_DATA);
+
+	return data;
+}
+
+static int lan8814_write_page_reg(struct phy_device *phydev,
+				  int page, u16 addr, u16 val)
+{
+	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_CONTROL, page);
+	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
+	phy_write(phydev, KSZ_EXT_PAGE_ACCESS_CONTROL, (page | 0x4000));
+	val = phy_write(phydev, KSZ_EXT_PAGE_ACCESS_ADDRESS_DATA, val);
+	if (val != 0) {
+		phydev_err(phydev, "Error: phy_write has returned error %d\n",
+			   val);
+		return val;
+	}
+	return 0;
+}
+
 static int kszphy_extended_write(struct phy_device *phydev,
 				u32 regnum, u16 val)
 {
@@ -185,10 +359,156 @@ static int kszphy_extended_read(struct phy_device *phydev,
 	return phy_read(phydev, MII_KSZPHY_EXTREG_READ);
 }
 
+static void lan8814_ptp_tx_ts_get(struct phy_device *phydev,
+				  u32 *seconds, u32 *nano_seconds,
+				  u32 *seq_id);
+
+static struct lan8814_ptphdr *get_ptp_header_l4(struct sk_buff *skb,
+						struct iphdr *iphdr,
+						struct udphdr *udphdr)
+{
+	if (iphdr->version != 4 || iphdr->protocol != IPPROTO_UDP)
+		return NULL;
+
+	return (struct lan8814_ptphdr *)(((unsigned char *)udphdr) + UDP_HLEN);
+}
+
+static struct lan8814_ptphdr *get_ptp_header_tx(struct sk_buff *skb)
+{
+	struct ethhdr *ethhdr = eth_hdr(skb);
+	struct udphdr *udphdr;
+	struct iphdr *iphdr;
+
+	if (ethhdr->h_proto == htons(ETH_P_1588))
+		return (struct lan8814_ptphdr *)(((unsigned char *)ethhdr) +
+				skb_mac_header_len(skb));
+
+	if (ethhdr->h_proto != htons(ETH_P_IP))
+		return NULL;
+
+	iphdr = ip_hdr(skb);
+	udphdr = udp_hdr(skb);
+
+	return get_ptp_header_l4(skb, iphdr, udphdr);
+}
+
+static int get_sig(struct sk_buff *skb, u8 *sig)
+{
+	struct lan8814_ptphdr *ptphdr = get_ptp_header_tx(skb);
+	struct ethhdr *ethhdr = eth_hdr(skb);
+	unsigned int i;
+
+	if (!ptphdr)
+		return -EOPNOTSUPP;
+
+	sig[0] = (__force u16)ptphdr->seq_id >> 8;
+	sig[1] = (__force u16)ptphdr->seq_id & GENMASK(7, 0);
+	sig[2] = ptphdr->domain;
+	sig[3] = ptphdr->tsmt & GENMASK(3, 0);
+
+	memcpy(&sig[4], ethhdr->h_dest, ETH_ALEN);
+
+	/* Fill the last bytes of the signature to reach a 16B signature */
+	for (i = 10; i < 16; i++)
+		sig[i] = ptphdr->tsmt & GENMASK(3, 0);
+
+	return 0;
+}
+
+static void lan8814_dequeue_skb(struct lan8814_ptp *ptp)
+{
+	struct kszphy_ptp_priv *priv = container_of(ptp, struct kszphy_ptp_priv, ptp);
+	struct phy_device *phydev = priv->phydev;
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct sk_buff *skb;
+	u8 skb_sig[16];
+	int len;
+	u32 reg, cnt;
+	u32 seconds, nsec, seq_id;
+
+	reg = lan8814_read_page_reg(phydev, 5, PTP_CAP_INFO);
+	cnt = PTP_CAP_INFO_TX_TS_CNT_GET_(reg);
+
+	/* FIFO is Empty*/
+	if (cnt == 0)
+		return;
+
+	len = skb_queue_len(&ptp->tx_queue);
+	if (len < 1)
+		return;
+
+	while (len--) {
+		skb = __skb_dequeue(&ptp->tx_queue);
+		if (!skb)
+			return;
+
+		/* Can't get the signature of the packet, won't ever
+		 * be able to have one so let's dequeue the packet.
+		 */
+		if (get_sig(skb, skb_sig) < 0) {
+			kfree_skb(skb);
+			continue;
+		}
+
+		lan8814_ptp_tx_ts_get(phydev, &seconds, &nsec, &seq_id);
+
+		/* Check if we found the signature we were looking for. */
+		if (memcmp(skb_sig, &seq_id, sizeof(seq_id))) {
+			memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+			shhwtstamps.hwtstamp = ktime_set(seconds, nsec);
+			skb_complete_tx_timestamp(skb, &shhwtstamps);
+
+			return;
+		}
+
+		/* Valid signature but does not match the one of the
+		 * packet in the FIFO right now, reschedule it for later
+		 * packets.
+		 */
+		__skb_queue_tail(&ptp->tx_queue, skb);
+	}
+}
+
+static void lan8814_get_tx_ts(struct lan8814_ptp *ptp)
+{
+	u32 reg;
+	struct kszphy_ptp_priv *priv = container_of(ptp, struct kszphy_ptp_priv, ptp);
+	struct phy_device *phydev = priv->phydev;
+
+	do {
+		lan8814_dequeue_skb(ptp);
+
+		/* If other timestamps are available in the FIFO, process them. */
+		reg = lan8814_read_page_reg(phydev, 5, PTP_CAP_INFO);
+	} while (PTP_CAP_INFO_TX_TS_CNT_GET_(reg) > 1);
+}
+
+static irqreturn_t lan8814_handle_ptp_interrupt(struct phy_device *phydev)
+{
+	struct kszphy_ptp_priv *lan8814 = phydev->priv;
+	int rc;
+
+	rc = lan8814_read_page_reg(phydev, 5, PTP_TSU_INT_STS);
+
+	if (!(rc & PTP_TSU_INT_STS_PTP_TX_TS_EN))
+		return IRQ_NONE;
+
+	lan8814_get_tx_ts(&lan8814->ptp);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status;
 
+	irq_status = lan8814_read_page_reg(phydev, 4, LAN8814_INTR_STS_REG);
+	if (irq_status < 0)
+		return IRQ_NONE;
+
+	if (irq_status & LAN8814_INTR_STS_REG_1588_TSU0)
+		return lan8814_handle_ptp_interrupt(phydev);
+
 	irq_status = phy_read(phydev, LAN8814_INTS);
 	if (irq_status < 0)
 		return IRQ_NONE;
@@ -199,10 +519,20 @@ static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+static int lan8814_config_ts_intr(struct phy_device *phydev)
+{
+	return lan8814_write_page_reg(phydev, 5, PTP_TSU_INT_EN, PTP_TSU_INT_EN_PTP_TX_TS_EN |
+					  PTP_TSU_INT_EN_PTP_TX_TS_OVRFL_EN);
+}
+
 static int lan8814_config_intr(struct phy_device *phydev)
 {
 	int temp;
 
+	lan8814_write_page_reg(phydev, 4, LAN8814_INTR_CTRL_REG,
+			       LAN8814_INTR_CTRL_REG_POLARITY |
+			       LAN8814_INTR_CTRL_REG_INTR_ENABLE);
+
 	/* enable / disable interrupts */
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
 		temp = LAN8814_INTC_ALL;
@@ -1187,6 +1517,534 @@ static int kszphy_resume(struct phy_device *phydev)
 	return 0;
 }
 
+static bool lan8814_ptp_is_enable(struct phy_device *phydev)
+{
+	if (phy_read(phydev, PTP_CMD_CTL) & PTP_CMD_CTL_PTP_ENABLE_)
+		return true;
+
+	return false;
+}
+
+static void lan8814_ptp_rx_ts_get(struct phy_device *phydev,
+				  u32 *seconds, u32 *nano_seconds, u32 *seq_id)
+{
+	if (seconds) {
+		(*seconds) = lan8814_read_page_reg(phydev, 5, PTP_RX_INGRESS_SEC_HI);
+		(*seconds) = ((*seconds) << 16) |
+			     lan8814_read_page_reg(phydev, 5, PTP_RX_INGRESS_SEC_LO);
+	}
+
+	if (nano_seconds) {
+		(*nano_seconds) = lan8814_read_page_reg(phydev, 5, PTP_RX_INGRESS_NS_HI);
+		(*nano_seconds) = (((*nano_seconds) & 0x3fff) << 16)
+				   | lan8814_read_page_reg(phydev, 5, PTP_RX_INGRESS_NS_LO);
+	}
+
+	if (seq_id)
+		(*seq_id) = lan8814_read_page_reg(phydev, 5, PTP_RX_MSG_HEADER2);
+}
+
+static void lan8814_ptp_tx_ts_get(struct phy_device *phydev,
+				  u32 *seconds, u32 *nano_seconds, u32 *seq_id)
+{
+	if (seconds) {
+		(*seconds) = lan8814_read_page_reg(phydev, 5, PTP_TX_EGRESS_SEC_HI);
+		(*seconds) = ((*seconds) << 16) |
+			     lan8814_read_page_reg(phydev, 5, PTP_TX_EGRESS_SEC_LO);
+	}
+
+	if (nano_seconds) {
+		(*nano_seconds) = lan8814_read_page_reg(phydev, 5, PTP_TX_EGRESS_NS_HI);
+		(*nano_seconds) = (((*nano_seconds) & 0x3fff) << 16) |
+			lan8814_read_page_reg(phydev, 5, PTP_TX_EGRESS_NS_LO);
+	}
+
+	if (seq_id)
+		(*seq_id) = lan8814_read_page_reg(phydev, 5, PTP_TX_MSG_HEADER2);
+}
+
+static int lan8814_ts_info(struct mii_timestamper *mii_ts, struct ethtool_ts_info *info)
+{
+	struct kszphy_ptp_priv *lan8814 = container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
+
+	info->so_timestamping =
+		SOF_TIMESTAMPING_TX_HARDWARE |
+		SOF_TIMESTAMPING_RX_HARDWARE |
+		SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	info->phc_index = ptp_clock_index(lan8814->ptp.ptp_clock);
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
+static int lan8814_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
+{
+	struct kszphy_ptp_priv *lan8814 = container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
+	struct hwtstamp_config config;
+	int txcfg, rxcfg;
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	lan8814->hwts_tx_en = config.tx_type;
+
+	lan8814->ptp.rx_filter = config.rx_filter;
+	lan8814->ptp.tx_type = config.tx_type;
+
+	switch (config.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		lan8814->hwts_rx_en = 0;
+		lan8814->layer = 0;
+		lan8814->version = 0;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		lan8814->hwts_rx_en = 1;
+		lan8814->layer = PTP_CLASS_L4;
+		lan8814->version = PTP_CLASS_V2;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		lan8814->hwts_rx_en = 1;
+		lan8814->layer = PTP_CLASS_L2;
+		lan8814->version = PTP_CLASS_V2;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		lan8814->hwts_rx_en = 1;
+		lan8814->layer = PTP_CLASS_L4 | PTP_CLASS_L2;
+		lan8814->version = PTP_CLASS_V2;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	lan8814_write_page_reg(lan8814->phydev, 5, PTP_RX_PARSE_CONFIG, 0);
+	lan8814_write_page_reg(lan8814->phydev, 5, PTP_TX_PARSE_CONFIG, 0);
+
+	if (lan8814->hwts_rx_en && (lan8814->layer & PTP_CLASS_L2))
+		rxcfg = PTP_RX_PARSE_CONFIG_LAYER2_EN_;
+
+	if (lan8814->hwts_tx_en && (lan8814->layer & PTP_CLASS_L2))
+		txcfg = PTP_TX_PARSE_CONFIG_LAYER2_EN_;
+
+	if (lan8814->hwts_rx_en && (lan8814->layer & PTP_CLASS_L4))
+		rxcfg |= PTP_RX_PARSE_CONFIG_IPV4_EN_;
+
+	if (lan8814->hwts_tx_en && (lan8814->layer & PTP_CLASS_L4))
+		txcfg |= PTP_TX_PARSE_CONFIG_IPV4_EN_;
+
+	if (lan8814_ptp_is_enable(lan8814->phydev))
+		lan8814_write_page_reg(lan8814->phydev, 4, PTP_CMD_CTL,
+				       PTP_CMD_CTL_PTP_DISABLE_);
+
+	lan8814_write_page_reg(lan8814->phydev, 5, PTP_RX_PARSE_CONFIG, rxcfg);
+	lan8814_write_page_reg(lan8814->phydev, 5, PTP_TX_PARSE_CONFIG, txcfg);
+	lan8814_write_page_reg(lan8814->phydev, 5, PTP_RX_TIMESTAMP_EN, 0x3);
+	lan8814_write_page_reg(lan8814->phydev, 5, PTP_TX_TIMESTAMP_EN, 0x3);
+	lan8814_write_page_reg(lan8814->phydev, 5, PTP_TX_PARSE_L2_ADDR_EN, 0);
+	lan8814_write_page_reg(lan8814->phydev, 5, PTP_RX_PARSE_L2_ADDR_EN, 0);
+
+	lan8814_write_page_reg(lan8814->phydev, 4, PTP_CMD_CTL, PTP_CMD_CTL_PTP_ENABLE_);
+	if (lan8814->hwts_tx_en == HWTSTAMP_TX_ONESTEP_SYNC) {
+		lan8814_write_page_reg(lan8814->phydev, 5, PTP_TX_MOD,
+				       PTP_TX_MOD_TX_PTP_SYNC_TS_INSERT_);
+	} else if (lan8814->hwts_tx_en == HWTSTAMP_TX_ON) {
+		/* Enabling 2 step offloading and all option for TS insertion/correction fields */
+		lan8814_write_page_reg(lan8814->phydev, 5, PTP_TX_MOD, 0x800);
+		lan8814_config_ts_intr(lan8814->phydev);
+	}
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ? -EFAULT : 0;
+}
+
+static bool lan8814_rxtstamp(struct mii_timestamper *mii_ts, struct sk_buff *skb, int type)
+{
+	struct kszphy_ptp_priv *lan8814 = container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
+	struct skb_shared_hwtstamps *shhwtstamps = NULL;
+	u32 seconds, nsec, seq_id;
+
+	if (!lan8814->hwts_rx_en)
+		return false;
+
+	if (!skb)
+		return false;
+
+	if ((type & lan8814->version) == 0 || (type & lan8814->layer) == 0)
+		return false;
+
+	if (lan8814->ptp.rx_filter == HWTSTAMP_FILTER_NONE ||
+	    type == PTP_CLASS_NONE)
+		return false;
+
+	lan8814_ptp_rx_ts_get(lan8814->phydev, &seconds, &nsec, &seq_id);
+
+	/* Saving timestamp and sending through skbuff */
+	shhwtstamps = skb_hwtstamps(skb);
+	memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+	shhwtstamps->hwtstamp = ktime_set(seconds, nsec);
+
+	netif_rx_ni(skb);
+
+	return true;
+}
+
+static int is_sync(struct sk_buff *skb, int type)
+{
+	u8 *data = skb->data, *msgtype;
+	unsigned int offset = 0;
+
+	if (type & PTP_CLASS_VLAN)
+		offset += VLAN_HLEN;
+
+	switch (type & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
+		break;
+	case PTP_CLASS_IPV6:
+		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
+		break;
+	case PTP_CLASS_L2:
+		offset += ETH_HLEN;
+		break;
+	default:
+		return 0;
+	}
+
+	if (type & PTP_CLASS_V1)
+		offset += OFF_PTP_CONTROL;
+
+	if (skb->len < offset + 1)
+		return 0;
+
+	msgtype = data + offset;
+
+	return (*msgtype & 0xf) == 0;
+}
+
+static void lan8814_txtstamp(struct mii_timestamper *mii_ts,
+			     struct sk_buff *skb, int type)
+{
+	struct kszphy_ptp_priv *lan8814 = container_of(mii_ts, struct kszphy_ptp_priv, mii_ts);
+
+	switch (lan8814->hwts_tx_en) {
+	case HWTSTAMP_TX_ONESTEP_SYNC:
+		if (is_sync(skb, type)) {
+			kfree_skb(skb);
+			return;
+		}
+		break;
+
+	case HWTSTAMP_TX_ON:
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		skb_queue_tail(&lan8814->ptp.tx_queue, skb);
+		break;
+
+	case HWTSTAMP_TX_OFF:
+	default:
+		kfree_skb(skb);
+		break;
+	}
+}
+
+static void lan8814_ptp_clock_set(struct phy_device *phydev,
+				  u32 seconds, u32 nano_seconds,
+				 u32 sub_nano_seconds)
+{
+	u32 sec_low, sec_high, nsec_low, nsec_high, snsec_low, snsec_high;
+
+	sec_low = seconds & 0xffff;
+	sec_high = ((seconds >> 16) & 0xffff);
+	nsec_low = nano_seconds & 0xffff;
+	nsec_high = ((nano_seconds >> 16) & 0x3fff);
+	snsec_low = sub_nano_seconds & 0xffff;
+	snsec_high = ((sub_nano_seconds >> 16) & 0xffff);
+
+	lan8814_write_page_reg(phydev, 4, PTP_CLOCK_SET_SEC_LO, sec_low);
+	lan8814_write_page_reg(phydev, 4, PTP_CLOCK_SET_SEC_MID, sec_high);
+	lan8814_write_page_reg(phydev, 4, PTP_CLOCK_SET_NS_LO, nsec_low);
+	lan8814_write_page_reg(phydev, 4, PTP_CLOCK_SET_NS_HI, nsec_high);
+	lan8814_write_page_reg(phydev, 4, PTP_CLOCK_SET_SUBNS_LO, snsec_low);
+	lan8814_write_page_reg(phydev, 4, PTP_CLOCK_SET_SUBNS_HI, snsec_high);
+
+	lan8814_write_page_reg(phydev, 4, PTP_CMD_CTL, PTP_CMD_CTL_PTP_CLOCK_LOAD_);
+}
+
+static void lan8814_ptp_clock_get(struct phy_device *phydev,
+				  u32 *seconds, u32 *nano_seconds,
+				  u32 *sub_nano_seconds)
+{
+	lan8814_write_page_reg(phydev, 4, PTP_CMD_CTL, PTP_CMD_CTL_PTP_CLOCK_READ_);
+
+	if (seconds) {
+		(*seconds) = lan8814_read_page_reg(phydev, 4, PTP_CLOCK_READ_SEC_MID);
+		(*seconds) = ((*seconds) << 16) |
+			     lan8814_read_page_reg(phydev, 4, PTP_CLOCK_READ_SEC_LO);
+	}
+
+	if (nano_seconds) {
+		(*nano_seconds) = lan8814_read_page_reg(phydev, 4, PTP_CLOCK_READ_NS_HI);
+		(*nano_seconds) = (((*nano_seconds) & 0x3fff) << 16) |
+				  lan8814_read_page_reg(phydev, 4, PTP_CLOCK_READ_NS_LO);
+	}
+
+	if (sub_nano_seconds) {
+		(*sub_nano_seconds) = lan8814_read_page_reg(phydev, 4,
+								PTP_CLOCK_READ_SUBNS_HI);
+		(*sub_nano_seconds) = ((*sub_nano_seconds) << 16) |
+				       lan8814_read_page_reg(phydev, 4,
+							     PTP_CLOCK_READ_SUBNS_LO);
+	}
+}
+
+static int lan8814_ptpci_gettime64(struct ptp_clock_info *ptpci,
+				   struct timespec64 *ts)
+{
+	struct lan8814_ptp *ptp =
+		container_of(ptpci, struct lan8814_ptp, ptp_clock_info);
+	struct kszphy_ptp_priv *priv =
+		container_of(ptp, struct kszphy_ptp_priv, ptp);
+	struct phy_device *phydev = priv->phydev;
+	u32 nano_seconds = 0;
+	u32 seconds = 0;
+
+	lan8814_ptp_clock_get(phydev, &seconds, &nano_seconds, NULL);
+	ts->tv_sec = seconds;
+	ts->tv_nsec = nano_seconds;
+
+	return 0;
+}
+
+static void lan8814_ptp_clock_step(struct phy_device *phydev,
+				   s64 time_step_ns)
+{
+	u32 nano_seconds_step	= 0;
+	u64 abs_time_step_ns	= 0;
+	u32 unsigned_seconds	= 0;
+	u32 nano_seconds	= 0;
+	u32 remainder		= 0;
+	s32 seconds		= 0;
+
+	if (time_step_ns >  15000000000LL) {
+		/* convert to clock set */
+		lan8814_ptp_clock_get(phydev, &unsigned_seconds,	&nano_seconds, NULL);
+		unsigned_seconds += div_u64_rem(time_step_ns, 1000000000LL,
+				&remainder);
+		nano_seconds += remainder;
+		if (nano_seconds >= 1000000000) {
+			unsigned_seconds++;
+			nano_seconds -= 1000000000;
+		}
+		lan8814_ptp_clock_set(phydev, unsigned_seconds,
+				      nano_seconds, 0);
+		return;
+	} else if (time_step_ns < -15000000000LL) {
+		/* convert to clock set */
+		time_step_ns = -time_step_ns;
+
+		lan8814_ptp_clock_get(phydev, &unsigned_seconds,
+				      &nano_seconds, NULL);
+		unsigned_seconds -= div_u64_rem(time_step_ns, 1000000000LL,
+				&remainder);
+		nano_seconds_step = remainder;
+		if (nano_seconds < nano_seconds_step) {
+			unsigned_seconds--;
+			nano_seconds += 1000000000;
+		}
+		nano_seconds -= nano_seconds_step;
+		lan8814_ptp_clock_set(phydev, unsigned_seconds,
+				      nano_seconds, 0);
+		return;
+	}
+
+	/* do clock step */
+	if (time_step_ns >= 0) {
+		abs_time_step_ns = (u64)(time_step_ns);
+		seconds = (s32)div_u64_rem(abs_time_step_ns, 1000000000,
+				&remainder);
+		nano_seconds = (u32)remainder;
+	} else {
+		abs_time_step_ns = (u64)(-time_step_ns);
+		seconds = -((s32)div_u64_rem(abs_time_step_ns, 1000000000,
+					&remainder));
+		nano_seconds = (u32)remainder;
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
+			adjustment_value_lo = adjustment_value & 0xffff;
+			adjustment_value_hi = (adjustment_value >> 16) & 0x3fff;
+
+			if (adjustment_value > 0xF)
+				adjustment_value = 0xF;
+			lan8814_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_LO,
+					       adjustment_value_lo);
+			lan8814_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_HI,
+					       PTP_LTC_STEP_ADJ_DIR_ |
+					       adjustment_value_hi);
+			seconds -= ((s32)adjustment_value);
+		} else {
+			u32 adjustment_value = (u32)(-seconds);
+			u16 adjustment_value_lo, adjustment_value_hi;
+
+			adjustment_value_lo = adjustment_value & 0xffff;
+			adjustment_value_hi = (adjustment_value >> 16) & 0x3fff;
+			if (adjustment_value > 0xF)
+				adjustment_value = 0xF;
+			lan8814_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_LO,
+					       adjustment_value_lo);
+			lan8814_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_HI,
+					       PTP_LTC_STEP_ADJ_DIR_ |
+					       adjustment_value_hi);
+			seconds += ((s32)adjustment_value);
+		}
+		lan8814_write_page_reg(phydev, 4, PTP_CMD_CTL,
+				       PTP_CMD_CTL_PTP_LTC_STEP_SEC_);
+	}
+	if (nano_seconds) {
+		u16 nano_seconds_lo;
+		u16 nano_seconds_hi;
+
+		nano_seconds_lo = nano_seconds & 0xffff;
+		nano_seconds_hi = (nano_seconds >> 16) & 0x3fff;
+
+		lan8814_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_LO,
+				       nano_seconds_lo);
+		lan8814_write_page_reg(phydev, 4, PTP_LTC_STEP_ADJ_HI,
+				       PTP_LTC_STEP_ADJ_DIR_ |
+				       nano_seconds_hi);
+		lan8814_write_page_reg(phydev, 4, PTP_CMD_CTL,
+				       PTP_CMD_CTL_PTP_LTC_STEP_NSEC_);
+	}
+}
+
+static int lan8814_ptpci_adjtime(struct ptp_clock_info *ptpci, s64 delta)
+{
+	struct lan8814_ptp *ptp =
+		container_of(ptpci, struct lan8814_ptp, ptp_clock_info);
+	struct kszphy_ptp_priv *priv =
+		container_of(ptp, struct kszphy_ptp_priv, ptp);
+	struct phy_device *phydev = priv->phydev;
+
+	lan8814_ptp_clock_step(phydev, delta);
+
+	return 0;
+}
+
+static int lan8814_ptpci_adjfine(struct ptp_clock_info *ptpci, long scaled_ppm)
+{
+	struct lan8814_ptp *ptp =
+		container_of(ptpci, struct lan8814_ptp, ptp_clock_info);
+	struct kszphy_ptp_priv *priv = container_of(ptp, struct kszphy_ptp_priv, ptp);
+	struct phy_device *phydev = priv->phydev;
+	u32 kszphy_rate_adj = 0;
+	u16 kszphy_rate_adj_lo = 0, kszphy_rate_adj_hi = 0;
+	bool positive = true;
+	u64 u64_delta = 0;
+
+	if ((scaled_ppm < (-LAN8814_PTP_MAX_FINE_ADJ_IN_SCALED_PPM)) ||
+	    scaled_ppm > LAN8814_PTP_MAX_FINE_ADJ_IN_SCALED_PPM) {
+		return -EINVAL;
+	}
+	if (scaled_ppm > 0) {
+		u64_delta = (u64)scaled_ppm;
+		positive = true;
+	} else {
+		u64_delta = (u64)(-scaled_ppm);
+		positive = false;
+	}
+	u64_delta = (u64_delta << 13);
+	kszphy_rate_adj = div_u64(u64_delta, 15625);
+
+	kszphy_rate_adj_lo = kszphy_rate_adj & 0xffff;
+	kszphy_rate_adj_hi = (kszphy_rate_adj >> 16) & 0x3fff;
+
+	if (positive)
+		kszphy_rate_adj_hi |= PTP_CLOCK_RATE_ADJ_DIR_;
+
+	lan8814_write_page_reg(phydev, 4, PTP_CLOCK_RATE_ADJ_HI_, kszphy_rate_adj_hi);
+	lan8814_write_page_reg(phydev, 4, PTP_CLOCK_RATE_ADJ_LO_, kszphy_rate_adj_lo);
+
+	return 0;
+}
+
+static void lan8814_ptp_reset(struct phy_device *phydev)
+{
+	if (lan8814_ptp_is_enable(phydev))
+		lan8814_write_page_reg(phydev, 4, PTP_CMD_CTL, PTP_CMD_CTL_PTP_DISABLE_);
+
+	lan8814_write_page_reg(phydev, 4, LTC_HARD_RESET, LTC_HARD_RESET_);
+	lan8814_write_page_reg(phydev, 5, TSU_HARD_RESET, TSU_HARD_RESET_);
+}
+
+static void lan8814_ptp_enable(struct phy_device *phydev)
+{
+	if (lan8814_ptp_is_enable(phydev))
+		return;
+
+	lan8814_write_page_reg(phydev, 4, PTP_CMD_CTL, PTP_CMD_CTL_PTP_ENABLE_);
+}
+
+static void lan8814_ptp_sync_to_system_clock(struct phy_device *phydev)
+{
+	struct timespec64 ts;
+
+	ktime_get_clocktai_ts64(&ts);
+
+	lan8814_ptp_clock_set(phydev, ts.tv_sec, ts.tv_nsec, 0);
+}
+
+static void lan8814_ptp_init(struct phy_device *phydev)
+{
+	u32 temp;
+
+	lan8814_ptp_reset(phydev);
+	lan8814_ptp_sync_to_system_clock(phydev);
+	temp = lan8814_read_page_reg(phydev, 5, PTP_TX_MOD);
+	temp |= PTP_TX_MOD_BAD_UDPV4_CHKSUM_FORCE_FCS_DIS_;
+	lan8814_write_page_reg(phydev, 5, PTP_TX_MOD, temp);
+	lan8814_write_page_reg(phydev, 4, PTP_OPERATING_MODE,
+			       PTP_OPERATING_MODE_STANDALONE);
+	lan8814_ptp_enable(phydev);
+}
+
 static int kszphy_probe(struct phy_device *phydev)
 {
 	const struct kszphy_type *type = phydev->drv->driver_data;
@@ -1248,6 +2106,88 @@ static int kszphy_probe(struct phy_device *phydev)
 	return 0;
 }
 
+static int lan8814_probe(struct phy_device *phydev)
+{
+	struct kszphy_priv *priv;
+	struct clk *clk;
+	const struct kszphy_type *type = phydev->drv->driver_data;
+	const struct device_node *np = phydev->mdio.dev.of_node;
+
+	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	skb_queue_head_init(&priv->ptp_priv.ptp.tx_queue);
+
+	priv->ptp_priv.phydev = phydev;
+
+	priv->type = type;
+
+	priv->ptp_priv.mii_ts.rxtstamp = lan8814_rxtstamp;
+	priv->ptp_priv.mii_ts.txtstamp = lan8814_txtstamp;
+	priv->ptp_priv.mii_ts.hwtstamp = lan8814_hwtstamp;
+	priv->ptp_priv.mii_ts.ts_info  = lan8814_ts_info;
+
+	phydev->mii_ts = &priv->ptp_priv.mii_ts;
+
+	phydev->priv = priv;
+
+	lan8814_ptp_init(phydev);
+
+	priv->ptp_priv.ptp.flags |= PTP_FLAG_ISR_ENABLED;
+
+	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK))
+		return 0;
+
+	clk = devm_clk_get(&phydev->mdio.dev, "rmii-ref");
+	/* NOTE: clk may be NULL if building without CONFIG_HAVE_CLK */
+	if (!IS_ERR_OR_NULL(clk)) {
+		unsigned long rate = clk_get_rate(clk);
+		bool rmii_ref_clk_sel_25_mhz;
+
+		priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
+		rmii_ref_clk_sel_25_mhz = of_property_read_bool(np,
+				"micrel,rmii-reference-clock-select-25-mhz");
+
+		if (rate > 24500000 && rate < 25500000) {
+			priv->rmii_ref_clk_sel_val = rmii_ref_clk_sel_25_mhz;
+		} else if (rate > 49500000 && rate < 50500000) {
+			priv->rmii_ref_clk_sel_val = !rmii_ref_clk_sel_25_mhz;
+		} else {
+			phydev_err(phydev, "Clock rate out of range: %ld\n",
+				   rate);
+			return -EINVAL;
+		}
+	}
+
+	priv->ptp_priv.ptp.ptp_clock_info.owner = THIS_MODULE;
+	snprintf(priv->ptp_priv.ptp.ptp_clock_info.name, 30, "%s",
+		 phydev->drv->name);
+	priv->ptp_priv.ptp.ptp_clock_info.max_adj = LAN8814_PTP_MAX_FREQ_ADJ_IN_PPB;
+	priv->ptp_priv.ptp.ptp_clock_info.n_alarm = 0;
+	priv->ptp_priv.ptp.ptp_clock_info.n_ext_ts = 0;
+	priv->ptp_priv.ptp.ptp_clock_info.n_per_out = 1;
+	priv->ptp_priv.ptp.ptp_clock_info.n_pins = 0;
+	priv->ptp_priv.ptp.ptp_clock_info.pps = 0;
+	priv->ptp_priv.ptp.ptp_clock_info.pin_config = NULL;
+	priv->ptp_priv.ptp.ptp_clock_info.adjfine = lan8814_ptpci_adjfine;
+	priv->ptp_priv.ptp.ptp_clock_info.adjtime = lan8814_ptpci_adjtime;
+	priv->ptp_priv.ptp.ptp_clock_info.gettime64 = lan8814_ptpci_gettime64;
+	priv->ptp_priv.ptp.ptp_clock_info.getcrosststamp = NULL;
+
+	priv->ptp_priv.ptp.ptp_clock = ptp_clock_register(&priv->ptp_priv.ptp.ptp_clock_info,
+							  &phydev->mdio.dev);
+
+	if (IS_ERR_OR_NULL(priv->ptp_priv.ptp.ptp_clock))
+		phydev_err(phydev, "ptp_clock_register failed %lu\n",
+			   PTR_ERR(priv->ptp_priv.ptp.ptp_clock));
+
+	priv->ptp_priv.ptp.flags |= PTP_FLAG_PTP_CLOCK_REGISTERED;
+	phydev_info(phydev, "successfully registered ptp clock\n");
+
+	return 0;
+}
+
 static struct phy_driver ksphy_driver[] = {
 {
 	.phy_id		= PHY_ID_KS8737,
@@ -1415,7 +2355,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Microchip INDY Gigabit Quad PHY",
 	.driver_data	= &ksz9021_type,
-	.probe		= kszphy_probe,
+	.probe		= lan8814_probe,
 	.soft_reset	= genphy_soft_reset,
 	.read_status	= ksz9031_read_status,
 	.get_sset_count	= kszphy_get_sset_count,
-- 
2.17.1

