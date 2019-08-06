Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE79B83331
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732977AbfHFNoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:44:04 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:59114 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730188AbfHFNm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:42:57 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 63054C21C5;
        Tue,  6 Aug 2019 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565098976; bh=IdzI6RJvtLS6glcud2Ck6HY/xqrooA4DukMJhtajPfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=l1SruBq0Huls/hhWEPtJPl6biPaJiAumk0LZ47KqX9GMym6G30D7QjyDyy6pEgM1b
         VO1ZgoGskBMEX18aa3mhjORMK4e9DIXlgQosLJdR4swS+JR0Zi9IM2J17Q0xPV5cij
         0DznMj27ei6boa1FdEjKzgq3uXzzryJAiC5XNZ69F0ZFzin+LkW6Zsn+D1iqOl2tR2
         1pf9xej+iTP168xlMPx1rugRJPCdUZ8Jw65fyttKUA2OVNeBIoWvgvSXg4Jh9hi6J3
         ieR4sws1OFHrfIwiXdegsHCCkYBUZiw82ofFtaSonC/T1tAI87Iy+5RSjPsHB1zCco
         7fwTkD0LtbS6Q==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 1EF3FA006E;
        Tue,  6 Aug 2019 13:42:55 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 06/10] net: stmmac: Implement VLAN Hash Filtering in XGMAC
Date:   Tue,  6 Aug 2019 15:42:47 +0200
Message-Id: <00cb8ef4f1bac0833fedf4e7f3d2f50c02d5ec1a.1565098881.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565098881.git.joabreu@synopsys.com>
References: <cover.1565098881.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565098881.git.joabreu@synopsys.com>
References: <cover.1565098881.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the VLAN Hash Filtering feature in XGMAC core.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/common.h       |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     | 10 +++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 41 +++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  5 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  2 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 79 ++++++++++++++++++++++
 7 files changed, 139 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 45a997fe571c..e1e6f67041ec 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -355,6 +355,7 @@ struct dma_features {
 	unsigned int frpes;
 	unsigned int addr64;
 	unsigned int rssen;
+	unsigned int vlhash;
 };
 
 /* GMAC TX FIFO is 8K, Rx FIFO is 16K */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 70ac202435aa..f2c281887868 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -44,11 +44,20 @@
 #define XGMAC_CORE_INIT_RX		0
 #define XGMAC_PACKET_FILTER		0x00000008
 #define XGMAC_FILTER_RA			BIT(31)
+#define XGMAC_FILTER_VTFE		BIT(16)
 #define XGMAC_FILTER_PCF		BIT(7)
 #define XGMAC_FILTER_PM			BIT(4)
 #define XGMAC_FILTER_HMC		BIT(2)
 #define XGMAC_FILTER_PR			BIT(0)
 #define XGMAC_HASH_TABLE(x)		(0x00000010 + (x) * 4)
+#define XGMAC_VLAN_TAG			0x00000050
+#define XGMAC_VLAN_EDVLP		BIT(26)
+#define XGMAC_VLAN_VTHM			BIT(25)
+#define XGMAC_VLAN_DOVLTC		BIT(20)
+#define XGMAC_VLAN_ESVL			BIT(18)
+#define XGMAC_VLAN_ETV			BIT(16)
+#define XGMAC_VLAN_VID			GENMASK(15, 0)
+#define XGMAC_VLAN_HASH_TABLE		0x00000058
 #define XGMAC_RXQ_CTRL0			0x000000a0
 #define XGMAC_RXQEN(x)			GENMASK((x) * 2 + 1, (x) * 2)
 #define XGMAC_RXQEN_SHIFT(x)		((x) * 2)
@@ -85,6 +94,7 @@
 #define XGMAC_HWFEAT_MMCSEL		BIT(8)
 #define XGMAC_HWFEAT_MGKSEL		BIT(7)
 #define XGMAC_HWFEAT_RWKSEL		BIT(6)
+#define XGMAC_HWFEAT_VLHASH		BIT(4)
 #define XGMAC_HWFEAT_GMIISEL		BIT(1)
 #define XGMAC_HW_FEATURE1		0x00000120
 #define XGMAC_HWFEAT_RSSEN		BIT(20)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index 42d528310e8c..d0fd059d8c53 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -421,6 +421,46 @@ static int dwxgmac2_rss_configure(struct mac_device_info *hw,
 	return 0;
 }
 
+static void dwxgmac2_update_vlan_hash(struct mac_device_info *hw, u32 hash,
+				      bool is_double)
+{
+	void __iomem *ioaddr = hw->pcsr;
+
+	writel(hash, ioaddr + XGMAC_VLAN_HASH_TABLE);
+
+	if (hash) {
+		u32 value = readl(ioaddr + XGMAC_PACKET_FILTER);
+
+		value |= XGMAC_FILTER_VTFE;
+
+		writel(value, ioaddr + XGMAC_PACKET_FILTER);
+
+		value |= XGMAC_VLAN_VTHM | XGMAC_VLAN_ETV;
+		if (is_double) {
+			value |= XGMAC_VLAN_EDVLP;
+			value |= XGMAC_VLAN_ESVL;
+			value |= XGMAC_VLAN_DOVLTC;
+		}
+
+		writel(value, ioaddr + XGMAC_VLAN_TAG);
+	} else {
+		u32 value = readl(ioaddr + XGMAC_PACKET_FILTER);
+
+		value &= ~XGMAC_FILTER_VTFE;
+
+		writel(value, ioaddr + XGMAC_PACKET_FILTER);
+
+		value = readl(ioaddr + XGMAC_VLAN_TAG);
+
+		value &= ~(XGMAC_VLAN_VTHM | XGMAC_VLAN_ETV);
+		value &= ~(XGMAC_VLAN_EDVLP | XGMAC_VLAN_ESVL);
+		value &= ~XGMAC_VLAN_DOVLTC;
+		value &= ~XGMAC_VLAN_VID;
+
+		writel(value, ioaddr + XGMAC_VLAN_TAG);
+	}
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -452,6 +492,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.set_filter = dwxgmac2_set_filter,
 	.set_mac_loopback = dwxgmac2_set_mac_loopback,
 	.rss_configure = dwxgmac2_rss_configure,
+	.update_vlan_hash = dwxgmac2_update_vlan_hash,
 };
 
 int dwxgmac2_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 45a6634ee397..b50e275e76c2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -359,6 +359,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	dma_cap->rmon = (hw_cap & XGMAC_HWFEAT_MMCSEL) >> 8;
 	dma_cap->pmt_magic_frame = (hw_cap & XGMAC_HWFEAT_MGKSEL) >> 7;
 	dma_cap->pmt_remote_wake_up = (hw_cap & XGMAC_HWFEAT_RWKSEL) >> 6;
+	dma_cap->vlhash = (hw_cap & XGMAC_HWFEAT_VLHASH) >> 4;
 	dma_cap->mbps_1000 = (hw_cap & XGMAC_HWFEAT_GMIISEL) >> 1;
 
 	/* MAC HW feature 1 */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index bfe7efee9481..52fc2344b066 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -336,6 +336,9 @@ struct stmmac_ops {
 	/* RSS */
 	int (*rss_configure)(struct mac_device_info *hw,
 			     struct stmmac_rss *cfg, u32 num_rxq);
+	/* VLAN */
+	void (*update_vlan_hash)(struct mac_device_info *hw, u32 hash,
+				 bool is_double);
 };
 
 #define stmmac_core_init(__priv, __args...) \
@@ -408,6 +411,8 @@ struct stmmac_ops {
 	stmmac_do_void_callback(__priv, mac, set_mac_loopback, __args)
 #define stmmac_rss_configure(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, rss_configure, __args)
+#define stmmac_update_vlan_hash(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, update_vlan_hash, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index d2f6f56ae29c..4179559b11ad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -13,6 +13,7 @@
 #define DRV_MODULE_VERSION	"Jan_2016"
 
 #include <linux/clk.h>
+#include <linux/if_vlan.h>
 #include <linux/stmmac.h>
 #include <linux/phylink.h>
 #include <linux/pci.h>
@@ -191,6 +192,7 @@ struct stmmac_priv {
 	spinlock_t ptp_lock;
 	void __iomem *mmcaddr;
 	void __iomem *ptpaddr;
+	unsigned long active_vlans[BITS_TO_LONGS(VLAN_N_VID)];
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dbgfs_dir;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3cfe75057874..9c4554a128a7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4036,6 +4036,79 @@ static void stmmac_exit_fs(struct net_device *dev)
 }
 #endif /* CONFIG_DEBUG_FS */
 
+static u32 stmmac_vid_crc32_le(__le16 vid_le)
+{
+	unsigned char *data = (unsigned char *)&vid_le;
+	unsigned char data_byte = 0;
+	u32 crc = ~0x0;
+	u32 temp = 0;
+	int i, bits;
+
+	bits = get_bitmask_order(VLAN_VID_MASK);
+	for (i = 0; i < bits; i++) {
+		if ((i % 8) == 0)
+			data_byte = data[i / 8];
+
+		temp = ((crc & 1) ^ data_byte) & 1;
+		crc >>= 1;
+		data_byte >>= 1;
+
+		if (temp)
+			crc ^= 0xedb88320;
+	}
+
+	return crc;
+}
+
+static int stmmac_vlan_update(struct stmmac_priv *priv, bool is_double)
+{
+	u32 crc, hash = 0;
+	u16 vid;
+
+	for_each_set_bit(vid, priv->active_vlans, VLAN_N_VID) {
+		__le16 vid_le = cpu_to_le16(vid);
+		crc = bitrev32(~stmmac_vid_crc32_le(vid_le)) >> 28;
+		hash |= (1 << crc);
+	}
+
+	return stmmac_update_vlan_hash(priv, priv->hw, hash, is_double);
+}
+
+static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid)
+{
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	bool is_double = false;
+	int ret;
+
+	if (!priv->dma_cap.vlhash)
+		return -EOPNOTSUPP;
+	if (be16_to_cpu(proto) == ETH_P_8021AD)
+		is_double = true;
+
+	set_bit(vid, priv->active_vlans);
+	ret = stmmac_vlan_update(priv, is_double);
+	if (ret) {
+		clear_bit(vid, priv->active_vlans);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vid)
+{
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	bool is_double = false;
+
+	if (!priv->dma_cap.vlhash)
+		return -EOPNOTSUPP;
+	if (be16_to_cpu(proto) == ETH_P_8021AD)
+		is_double = true;
+
+	clear_bit(vid, priv->active_vlans);
+	return stmmac_vlan_update(priv, is_double);
+}
+
 static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_open = stmmac_open,
 	.ndo_start_xmit = stmmac_xmit,
@@ -4052,6 +4125,8 @@ static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_poll_controller = stmmac_poll_controller,
 #endif
 	.ndo_set_mac_address = stmmac_set_mac_address,
+	.ndo_vlan_rx_add_vid = stmmac_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid = stmmac_vlan_rx_kill_vid,
 };
 
 static void stmmac_reset_subtask(struct stmmac_priv *priv)
@@ -4306,6 +4381,10 @@ int stmmac_dvr_probe(struct device *device,
 #ifdef STMMAC_VLAN_TAG_USED
 	/* Both mac100 and gmac support receive VLAN tag detection */
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX;
+	if (priv->dma_cap.vlhash) {
+		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		ndev->features |= NETIF_F_HW_VLAN_STAG_FILTER;
+	}
 #endif
 	priv->msg_enable = netif_msg_init(debug, default_msg_level);
 
-- 
2.7.4

