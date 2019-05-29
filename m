Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AF92D917
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 11:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfE2Jbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 05:31:32 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:48026 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726474AbfE2Jba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 05:31:30 -0400
X-UUID: a7791a899d114a958fee4bf55bd1eb7a-20190529
X-UUID: a7791a899d114a958fee4bf55bd1eb7a-20190529
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1633047466; Wed, 29 May 2019 17:31:19 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 29 May 2019 17:31:12 +0800
Received: from localhost.localdomain (10.17.3.153) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 29 May 2019 17:31:11 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jose Abreu <joabreu@synopsys.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.com>,
        <boon.leong.ong@intel.com>, <andrew@lunn.ch>
Subject: [v5, PATCH] net: stmmac: add support for hash table size 128/256 in dwmac4
Date:   Wed, 29 May 2019 17:31:08 +0800
Message-ID: <1559122268-22545-2-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1559122268-22545-1-git-send-email-biao.huang@mediatek.com>
References: <1559122268-22545-1-git-send-email-biao.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. get hash table size in hw feature reigster, and add support
for taller hash table(128/256) in dwmac4.
2. only clear GMAC_PACKET_FILTER bits used in this function,
to avoid side effect to functions of other bits.

stmmac selftests output log:
	ethtool -t eth0
	The test result is FAIL
	The test extra info:
	 1. MAC Loopback                 0
	 2. PHY Loopback                 -95
	 3. MMC Counters                 0
	 4. EEE                          -95
	 5. Hash Filter MC               0
	 6. Perfect Filter UC            0
	 7. MC Filter                    0
	 8. UC Filter                    0
	 9. Flow Control                 1

Signed-off-by: Biao Huang <biao.huang@mediatek.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h      |    7 +--
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |    4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |   49 ++++++++++++---------
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  |    1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 +++
 5 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 1961fe9..26bbcd8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -335,6 +335,7 @@ struct dma_features {
 	/* 802.3az - Energy-Efficient Ethernet (EEE) */
 	unsigned int eee;
 	unsigned int av;
+	unsigned int hash_tb_sz;
 	unsigned int tsoen;
 	/* TX and RX csum */
 	unsigned int tx_coe;
@@ -428,9 +429,9 @@ struct mac_device_info {
 	struct mii_regs mii;	/* MII register Addresses */
 	struct mac_link link;
 	void __iomem *pcsr;     /* vpointer to device CSRs */
-	int multicast_filter_bins;
-	int unicast_filter_entries;
-	int mcast_bits_log2;
+	unsigned int multicast_filter_bins;
+	unsigned int unicast_filter_entries;
+	unsigned int mcast_bits_log2;
 	unsigned int rx_csum;
 	unsigned int pcs;
 	unsigned int pmt;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 01c1089..b68785f7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -18,8 +18,7 @@
 /*  MAC registers */
 #define GMAC_CONFIG			0x00000000
 #define GMAC_PACKET_FILTER		0x00000008
-#define GMAC_HASH_TAB_0_31		0x00000010
-#define GMAC_HASH_TAB_32_63		0x00000014
+#define GMAC_HASH_TAB(x)		(0x10 + (x) * 4)
 #define GMAC_RX_FLOW_CTRL		0x00000090
 #define GMAC_QX_TX_FLOW_CTRL(x)		(0x70 + x * 4)
 #define GMAC_TXQ_PRTY_MAP0		0x98
@@ -184,6 +183,7 @@ enum power_event {
 #define GMAC_HW_FEAT_MIISEL		BIT(0)
 
 /* MAC HW features1 bitmap */
+#define GMAC_HW_HASH_TB_SZ		GENMASK(25, 24)
 #define GMAC_HW_FEAT_AVSEL		BIT(20)
 #define GMAC_HW_TSOEN			BIT(18)
 #define GMAC_HW_TXFIFOSIZE		GENMASK(10, 6)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 5e98da4..4183607 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -403,41 +403,50 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 			      struct net_device *dev)
 {
 	void __iomem *ioaddr = (void __iomem *)dev->base_addr;
-	unsigned int value = 0;
+	int numhashregs = (hw->multicast_filter_bins >> 5);
+	int mcbitslog2 = hw->mcast_bits_log2;
+	unsigned int value;
+	int i;
 
+	value = readl(ioaddr + GMAC_PACKET_FILTER);
+	value &= ~GMAC_PACKET_FILTER_HMC;
+	value &= ~GMAC_PACKET_FILTER_HPF;
+	value &= ~GMAC_PACKET_FILTER_PCF;
+	value &= ~GMAC_PACKET_FILTER_PM;
+	value &= ~GMAC_PACKET_FILTER_PR;
 	if (dev->flags & IFF_PROMISC) {
 		value = GMAC_PACKET_FILTER_PR | GMAC_PACKET_FILTER_PCF;
 	} else if ((dev->flags & IFF_ALLMULTI) ||
-			(netdev_mc_count(dev) > HASH_TABLE_SIZE)) {
+		   (netdev_mc_count(dev) > hw->multicast_filter_bins)) {
 		/* Pass all multi */
-		value = GMAC_PACKET_FILTER_PM;
-		/* Set the 64 bits of the HASH tab. To be updated if taller
-		 * hash table is used
-		 */
-		writel(0xffffffff, ioaddr + GMAC_HASH_TAB_0_31);
-		writel(0xffffffff, ioaddr + GMAC_HASH_TAB_32_63);
+		value |= GMAC_PACKET_FILTER_PM;
+		/* Set all the bits of the HASH tab */
+		for (i = 0; i < numhashregs; i++)
+			writel(0xffffffff, ioaddr + GMAC_HASH_TAB(i));
 	} else if (!netdev_mc_empty(dev)) {
-		u32 mc_filter[2];
 		struct netdev_hw_addr *ha;
+		u32 mc_filter[8];
 
 		/* Hash filter for multicast */
-		value = GMAC_PACKET_FILTER_HMC;
+		value |= GMAC_PACKET_FILTER_HMC;
 
 		memset(mc_filter, 0, sizeof(mc_filter));
 		netdev_for_each_mc_addr(ha, dev) {
-			/* The upper 6 bits of the calculated CRC are used to
-			 * index the content of the Hash Table Reg 0 and 1.
+			/* The upper n bits of the calculated CRC are used to
+			 * index the contents of the hash table. The number of
+			 * bits used depends on the hardware configuration
+			 * selected at core configuration time.
 			 */
-			int bit_nr =
-				(bitrev32(~crc32_le(~0, ha->addr, 6)) >> 26);
-			/* The most significant bit determines the register
-			 * to use while the other 5 bits determines the bit
-			 * within the selected register
+			int bit_nr = bitrev32(~crc32_le(~0, ha->addr,
+					ETH_ALEN)) >> (32 - mcbitslog2);
+			/* The most significant bit determines the register to
+			 * use (H/L) while the other 5 bits determine the bit
+			 * within the register.
 			 */
-			mc_filter[bit_nr >> 5] |= (1 << (bit_nr & 0x1F));
+			mc_filter[bit_nr >> 5] |= (1 << (bit_nr & 0x1f));
 		}
-		writel(mc_filter[0], ioaddr + GMAC_HASH_TAB_0_31);
-		writel(mc_filter[1], ioaddr + GMAC_HASH_TAB_32_63);
+		for (i = 0; i < numhashregs; i++)
+			writel(mc_filter[i], ioaddr + GMAC_HASH_TAB(i));
 	}
 
 	value |= GMAC_PACKET_FILTER_HPF;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index edb6053..59afb53 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -354,6 +354,7 @@ static void dwmac4_get_hw_feature(void __iomem *ioaddr,
 
 	/* MAC HW feature1 */
 	hw_cap = readl(ioaddr + GMAC_HW_FEATURE1);
+	dma_cap->hash_tb_sz = (hw_cap & GMAC_HW_HASH_TB_SZ) >> 24;
 	dma_cap->av = (hw_cap & GMAC_HW_FEAT_AVSEL) >> 20;
 	dma_cap->tsoen = (hw_cap & GMAC_HW_TSOEN) >> 18;
 	/* RX and TX FIFO sizes are encoded as log2(n / 128). Undo that by
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8fcbf22..f7aac15 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4166,6 +4166,12 @@ static int stmmac_hw_init(struct stmmac_priv *priv)
 		priv->plat->enh_desc = priv->dma_cap.enh_desc;
 		priv->plat->pmt = priv->dma_cap.pmt_remote_wake_up;
 		priv->hw->pmt = priv->plat->pmt;
+		if (priv->dma_cap.hash_tb_sz) {
+			priv->hw->multicast_filter_bins =
+					(BIT(priv->dma_cap.hash_tb_sz) << 5);
+			priv->hw->mcast_bits_log2 =
+					ilog2(priv->hw->multicast_filter_bins);
+		}
 
 		/* TXCOE doesn't work in thresh DMA mode */
 		if (priv->plat->force_thresh_dma_mode)
-- 
1.7.9.5

