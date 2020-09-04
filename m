Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02C325D263
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgIDH3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729732AbgIDH3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 03:29:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1799AC061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 00:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=s6WOTZxDCuy9oWnfDwdoTtxm569TMaSQ/hZzYSwKk2I=; b=qUcD/VHzElA2EOmdt+fO2Hbssi
        M+zDJbtmERUX9Hx0cA+rYHIIvvL+A4Rqewf9QW/TP/yMyHqpa6yc7kVsiYWcAgDsoN0g9uacXGhHn
        20dPgtVQCy5tOViXucuZhJ1I+VKI167fYOI4dhaAYrjXjsOYurVt/vqp97HgujEmY1mo9ucOqP5ks
        xKOd+xJEkKghBUiJTtqaS2zEtCNRnAWTZvnPLaP1+zOv7VTvshHrY6qezkMLLaraFHBu7x6nVMC0p
        yI4KYKv7nAfdcdclWJ2FqSvpQV9SKhM6X8mBmAduCbQdu5urRlxeHuNky8pCRXSqudjEwwr0Cmb9x
        W2WRlGew==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:57914 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kE6AD-0007Pd-Nf; Fri, 04 Sep 2020 08:29:37 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kE6AD-00058A-GV; Fri, 04 Sep 2020 08:29:37 +0100
In-Reply-To: <20200904072828.GQ1551@shell.armlinux.org.uk>
References: <20200904072828.GQ1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 6/6] net: mvpp2: ptp: add support for transmit
 timestamping
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kE6AD-00058A-GV@rmk-PC.armlinux.org.uk>
Date:   Fri, 04 Sep 2020 08:29:37 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for timestamping transmit packets.  We allocate SYNC
messages to queue 1, every other message to queue 0.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  56 ++++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 199 +++++++++++++++++-
 2 files changed, 244 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 75467411900e..834775843067 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -12,6 +12,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/phylink.h>
 #include <net/flow_offload.h>
@@ -463,8 +464,10 @@
 #define     MVPP22_CTRL4_QSGMII_BYPASS_ACTIVE	BIT(7)
 #define MVPP22_GMAC_INT_SUM_STAT		0xa0
 #define	    MVPP22_GMAC_INT_SUM_STAT_INTERNAL	BIT(1)
+#define	    MVPP22_GMAC_INT_SUM_STAT_PTP	BIT(2)
 #define MVPP22_GMAC_INT_SUM_MASK		0xa4
 #define     MVPP22_GMAC_INT_SUM_MASK_LINK_STAT	BIT(1)
+#define	    MVPP22_GMAC_INT_SUM_MASK_PTP	BIT(2)
 
 /* Per-port XGMAC registers. PPv2.2 only, only for GOP port 0,
  * relative to port->base.
@@ -492,9 +495,11 @@
 #define     MVPP22_XLG_CTRL3_MACMODESELECT_10G	(1 << 13)
 #define MVPP22_XLG_EXT_INT_STAT			0x158
 #define     MVPP22_XLG_EXT_INT_STAT_XLG		BIT(1)
+#define     MVPP22_XLG_EXT_INT_STAT_PTP		BIT(7)
 #define MVPP22_XLG_EXT_INT_MASK			0x15c
 #define     MVPP22_XLG_EXT_INT_MASK_XLG		BIT(1)
 #define     MVPP22_XLG_EXT_INT_MASK_GIG		BIT(2)
+#define     MVPP22_XLG_EXT_INT_MASK_PTP		BIT(7)
 #define MVPP22_XLG_CTRL4_REG			0x184
 #define     MVPP22_XLG_CTRL4_FWD_FC		BIT(5)
 #define     MVPP22_XLG_CTRL4_FWD_PFC		BIT(6)
@@ -598,7 +603,11 @@
 /* PTP registers. PPv2.2 only */
 #define MVPP22_PTP_BASE(port)			(0x7800 + (port * 0x1000))
 #define MVPP22_PTP_INT_CAUSE			0x00
+#define     MVPP22_PTP_INT_CAUSE_QUEUE1		BIT(6)
+#define     MVPP22_PTP_INT_CAUSE_QUEUE0		BIT(5)
 #define MVPP22_PTP_INT_MASK			0x04
+#define     MVPP22_PTP_INT_MASK_QUEUE1		BIT(6)
+#define     MVPP22_PTP_INT_MASK_QUEUE0		BIT(5)
 #define MVPP22_PTP_GCR				0x08
 #define     MVPP22_PTP_GCR_RX_RESET		BIT(13)
 #define     MVPP22_PTP_GCR_TX_RESET		BIT(1)
@@ -796,6 +805,43 @@ enum mvpp2_prs_l3_cast {
 	MVPP2_PRS_L3_BROAD_CAST
 };
 
+/* PTP descriptor constants. The low bits of the descriptor are stored
+ * separately from the high bits.
+ */
+#define MVPP22_PTP_DESC_MASK_LOW	0xfff
+
+/* PTPAction */
+enum mvpp22_ptp_action {
+	MVPP22_PTP_ACTION_NONE = 0,
+	MVPP22_PTP_ACTION_FORWARD = 1,
+	MVPP22_PTP_ACTION_CAPTURE = 3,
+	/* The following have not been verified */
+	MVPP22_PTP_ACTION_ADDTIME = 4,
+	MVPP22_PTP_ACTION_ADDCORRECTEDTIME = 5,
+	MVPP22_PTP_ACTION_CAPTUREADDTIME = 6,
+	MVPP22_PTP_ACTION_CAPTUREADDCORRECTEDTIME = 7,
+	MVPP22_PTP_ACTION_ADDINGRESSTIME = 8,
+	MVPP22_PTP_ACTION_CAPTUREADDINGRESSTIME = 9,
+	MVPP22_PTP_ACTION_CAPTUREINGRESSTIME = 10,
+};
+
+/* PTPPacketFormat */
+enum mvpp22_ptp_packet_format {
+	MVPP22_PTP_PKT_FMT_PTPV2 = 0,
+	MVPP22_PTP_PKT_FMT_PTPV1 = 1,
+	MVPP22_PTP_PKT_FMT_Y1731 = 2,
+	MVPP22_PTP_PKT_FMT_NTPTS = 3,
+	MVPP22_PTP_PKT_FMT_NTPRX = 4,
+	MVPP22_PTP_PKT_FMT_NTPTX = 5,
+	MVPP22_PTP_PKT_FMT_TWAMP = 6,
+};
+
+#define MVPP22_PTP_ACTION(x)		(((x) & 15) << 0)
+#define MVPP22_PTP_PACKETFORMAT(x)	(((x) & 7) << 4)
+#define MVPP22_PTP_MACTIMESTAMPINGEN	BIT(11)
+#define MVPP22_PTP_TIMESTAMPENTRYID(x)	(((x) & 31) << 12)
+#define MVPP22_PTP_TIMESTAMPQUEUESELECT	BIT(18)
+
 /* BM constants */
 #define MVPP2_BM_JUMBO_BUF_NUM		512
 #define MVPP2_BM_LONG_BUF_NUM		1024
@@ -1014,6 +1060,11 @@ struct mvpp2_ethtool_fs {
 	struct ethtool_rxnfc rxnfc;
 };
 
+struct mvpp2_hwtstamp_queue {
+	struct sk_buff *skb[32];
+	u8 next;
+};
+
 struct mvpp2_port {
 	u8 id;
 
@@ -1100,6 +1151,8 @@ struct mvpp2_port {
 
 	bool hwtstamp;
 	bool rx_hwtstamp;
+	enum hwtstamp_tx_types tx_hwtstamp_type;
+	struct mvpp2_hwtstamp_queue tx_hwtstamp_queue[2];
 };
 
 /* The mvpp2_tx_desc and mvpp2_rx_desc structures describe the
@@ -1168,7 +1221,8 @@ struct mvpp22_tx_desc {
 	u8  packet_offset;
 	u8  phys_txq;
 	__le16 data_size;
-	__le64 reserved1;
+	__le32 ptp_descriptor;
+	__le32 reserved2;
 	__le64 buf_dma_addr_ptp;
 	__le64 buf_cookie_misc;
 };
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index c20fde0fc73c..7130e31c7431 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -28,6 +28,7 @@
 #include <linux/phy.h>
 #include <linux/phylink.h>
 #include <linux/phy/phy.h>
+#include <linux/ptp_classify.h>
 #include <linux/clk.h>
 #include <linux/hrtimer.h>
 #include <linux/ktime.h>
@@ -1379,6 +1380,10 @@ static void mvpp22_gop_setup_irq(struct mvpp2_port *port)
 {
 	u32 val;
 
+	mvpp2_modify(port->base + MVPP22_GMAC_INT_SUM_MASK,
+		     MVPP22_GMAC_INT_SUM_MASK_PTP,
+		     MVPP22_GMAC_INT_SUM_MASK_PTP);
+
 	if (port->phylink ||
 	    phy_interface_mode_is_rgmii(port->phy_interface) ||
 	    phy_interface_mode_is_8023z(port->phy_interface) ||
@@ -1392,6 +1397,10 @@ static void mvpp22_gop_setup_irq(struct mvpp2_port *port)
 		val = readl(port->base + MVPP22_XLG_INT_MASK);
 		val |= MVPP22_XLG_INT_MASK_LINK;
 		writel(val, port->base + MVPP22_XLG_INT_MASK);
+
+		mvpp2_modify(port->base + MVPP22_XLG_EXT_INT_MASK,
+			     MVPP22_XLG_EXT_INT_MASK_PTP,
+			     MVPP22_XLG_EXT_INT_MASK_PTP);
 	}
 
 	mvpp22_gop_unmask_irq(port);
@@ -2974,6 +2983,56 @@ static irqreturn_t mvpp2_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static void mvpp2_isr_handle_ptp_queue(struct mvpp2_port *port, int nq)
+{
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct mvpp2_hwtstamp_queue *queue;
+	struct sk_buff *skb;
+	void __iomem *ptp_q;
+	unsigned int id;
+	u32 r0, r1, r2;
+
+	ptp_q = port->priv->iface_base + MVPP22_PTP_BASE(port->gop_id);
+	if (nq)
+		ptp_q += MVPP22_PTP_TX_Q1_R0 - MVPP22_PTP_TX_Q0_R0;
+
+	queue = &port->tx_hwtstamp_queue[nq];
+
+	while (1) {
+		r0 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R0) & 0xffff;
+		if (!r0)
+			break;
+
+		r1 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R1) & 0xffff;
+		r2 = readl_relaxed(ptp_q + MVPP22_PTP_TX_Q0_R2) & 0xffff;
+
+		id = (r0 >> 1) & 31;
+
+		skb = queue->skb[id];
+		queue->skb[id] = NULL;
+		if (skb) {
+			u32 ts = r2 << 19 | r1 << 3 | r0 >> 13;
+
+			mvpp22_tai_tstamp(port->priv->tai, ts, &shhwtstamps);
+			skb_tstamp_tx(skb, &shhwtstamps);
+			dev_kfree_skb_any(skb);
+		}
+	}
+}
+
+static void mvpp2_isr_handle_ptp(struct mvpp2_port *port)
+{
+	void __iomem *ptp;
+	u32 val;
+
+	ptp = port->priv->iface_base + MVPP22_PTP_BASE(port->gop_id);
+	val = readl(ptp + MVPP22_PTP_INT_CAUSE);
+	if (val & MVPP22_PTP_INT_CAUSE_QUEUE0)
+		mvpp2_isr_handle_ptp_queue(port, 0);
+	if (val & MVPP22_PTP_INT_CAUSE_QUEUE1)
+		mvpp2_isr_handle_ptp_queue(port, 1);
+}
+
 static void mvpp2_isr_handle_link(struct mvpp2_port *port, bool link)
 {
 	struct net_device *dev = port->dev;
@@ -3049,6 +3108,8 @@ static irqreturn_t mvpp2_port_isr(int irq, void *dev_id)
 		val = readl(port->base + MVPP22_XLG_EXT_INT_STAT);
 		if (val & MVPP22_XLG_EXT_INT_STAT_XLG)
 			mvpp2_isr_handle_xlg(port);
+		if (val & MVPP22_XLG_EXT_INT_STAT_PTP)
+			mvpp2_isr_handle_ptp(port);
 	} else {
 		/* If it's not the XLG, we must be using the GMAC.
 		 * Check the summary status.
@@ -3056,6 +3117,8 @@ static irqreturn_t mvpp2_port_isr(int irq, void *dev_id)
 		val = readl(port->base + MVPP22_GMAC_INT_SUM_STAT);
 		if (val & MVPP22_GMAC_INT_SUM_STAT_INTERNAL)
 			mvpp2_isr_handle_gmac_internal(port);
+		if (val & MVPP22_GMAC_INT_SUM_STAT_PTP)
+			mvpp2_isr_handle_ptp(port);
 	}
 
 	mvpp22_gop_unmask_irq(port);
@@ -3610,6 +3673,92 @@ tx_desc_unmap_put(struct mvpp2_port *port, struct mvpp2_tx_queue *txq,
 	mvpp2_txq_desc_put(txq);
 }
 
+static void mvpp2_txdesc_clear_ptp(struct mvpp2_port *port,
+				   struct mvpp2_tx_desc *desc)
+{
+	/* We only need to clear the low bits */
+	if (port->priv->hw_version != MVPP21)
+		desc->pp22.ptp_descriptor &=
+			cpu_to_le32(~MVPP22_PTP_DESC_MASK_LOW);
+}
+
+static bool mvpp2_tx_hw_tstamp(struct mvpp2_port *port,
+			       struct mvpp2_tx_desc *tx_desc,
+			       struct sk_buff *skb)
+{
+	struct mvpp2_hwtstamp_queue *queue;
+	unsigned int mtype, type, i;
+	struct ptp_header *hdr;
+	u64 ptpdesc;
+
+	if (port->priv->hw_version == MVPP21 ||
+	    port->tx_hwtstamp_type == HWTSTAMP_TX_OFF)
+		return false;
+
+	type = ptp_classify_raw(skb);
+	if (!type)
+		return false;
+
+	hdr = ptp_parse_header(skb, type);
+	if (!hdr)
+		return false;
+
+	ptpdesc = MVPP22_PTP_MACTIMESTAMPINGEN |
+		  MVPP22_PTP_ACTION_CAPTURE;
+	queue = &port->tx_hwtstamp_queue[0];
+
+	switch (type & PTP_CLASS_VMASK) {
+	case PTP_CLASS_V1:
+		ptpdesc |= MVPP22_PTP_PACKETFORMAT(MVPP22_PTP_PKT_FMT_PTPV1);
+		break;
+
+	case PTP_CLASS_V2:
+		ptpdesc |= MVPP22_PTP_PACKETFORMAT(MVPP22_PTP_PKT_FMT_PTPV2);
+		mtype = hdr->tsmt & 15;
+		/* Direct PTP Sync messages to queue 1 */
+		if (mtype == 0) {
+			ptpdesc |= MVPP22_PTP_TIMESTAMPQUEUESELECT;
+			queue = &port->tx_hwtstamp_queue[1];
+		}
+		break;
+	}
+
+	/* Take a reference on the skb and insert into our queue */
+	i = queue->next;
+	queue->next = (i + 1) & 31;
+	if (queue->skb[i])
+		dev_kfree_skb_any(queue->skb[i]);
+	queue->skb[i] = skb_get(skb);
+
+	ptpdesc |= MVPP22_PTP_TIMESTAMPENTRYID(i);
+
+	/*
+	 * 3:0		- PTPAction
+	 * 6:4		- PTPPacketFormat
+	 * 7		- PTP_CF_WraparoundCheckEn
+	 * 9:8		- IngressTimestampSeconds[1:0]
+	 * 10		- Reserved
+	 * 11		- MACTimestampingEn
+	 * 17:12	- PTP_TimestampQueueEntryID[5:0]
+	 * 18		- PTPTimestampQueueSelect
+	 * 19		- UDPChecksumUpdateEn
+	 * 27:20	- TimestampOffset
+	 *			PTP, NTPTransmit, OWAMP/TWAMP - L3 to PTP header
+	 *			NTPTs, Y.1731 - L3 to timestamp entry
+	 * 35:28	- UDP Checksum Offset
+	 *
+	 * stored in tx descriptor bits 75:64 (11:0) and 191:168 (35:12)
+	 */
+	tx_desc->pp22.ptp_descriptor &=
+		cpu_to_le32(~MVPP22_PTP_DESC_MASK_LOW);
+	tx_desc->pp22.ptp_descriptor |=
+		cpu_to_le32(ptpdesc & MVPP22_PTP_DESC_MASK_LOW);
+	tx_desc->pp22.buf_dma_addr_ptp &= cpu_to_le64(~0xffffff0000000000ULL);
+	tx_desc->pp22.buf_dma_addr_ptp |= cpu_to_le64((ptpdesc >> 12) << 40);
+
+	return true;
+}
+
 /* Handle tx fragmentation processing */
 static int mvpp2_tx_frag_process(struct mvpp2_port *port, struct sk_buff *skb,
 				 struct mvpp2_tx_queue *aggr_txq,
@@ -3626,6 +3775,7 @@ static int mvpp2_tx_frag_process(struct mvpp2_port *port, struct sk_buff *skb,
 		void *addr = skb_frag_address(frag);
 
 		tx_desc = mvpp2_txq_next_desc_get(aggr_txq);
+		mvpp2_txdesc_clear_ptp(port, tx_desc);
 		mvpp2_txdesc_txq_set(port, tx_desc, txq->id);
 		mvpp2_txdesc_size_set(port, tx_desc, skb_frag_size(frag));
 
@@ -3675,6 +3825,7 @@ static inline void mvpp2_tso_put_hdr(struct sk_buff *skb,
 	struct mvpp2_tx_desc *tx_desc = mvpp2_txq_next_desc_get(aggr_txq);
 	dma_addr_t addr;
 
+	mvpp2_txdesc_clear_ptp(port, tx_desc);
 	mvpp2_txdesc_txq_set(port, tx_desc, txq->id);
 	mvpp2_txdesc_size_set(port, tx_desc, hdr_sz);
 
@@ -3699,6 +3850,7 @@ static inline int mvpp2_tso_put_data(struct sk_buff *skb,
 	struct mvpp2_tx_desc *tx_desc = mvpp2_txq_next_desc_get(aggr_txq);
 	dma_addr_t buf_dma_addr;
 
+	mvpp2_txdesc_clear_ptp(port, tx_desc);
 	mvpp2_txdesc_txq_set(port, tx_desc, txq->id);
 	mvpp2_txdesc_size_set(port, tx_desc, sz);
 
@@ -3815,6 +3967,9 @@ static netdev_tx_t mvpp2_tx(struct sk_buff *skb, struct net_device *dev)
 
 	/* Get a descriptor for the first part of the packet */
 	tx_desc = mvpp2_txq_next_desc_get(aggr_txq);
+	if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) ||
+	    !mvpp2_tx_hw_tstamp(port, tx_desc, skb))
+		mvpp2_txdesc_clear_ptp(port, tx_desc);
 	mvpp2_txdesc_txq_set(port, tx_desc, txq->id);
 	mvpp2_txdesc_size_set(port, tx_desc, skb_headlen(skb));
 
@@ -4574,6 +4729,7 @@ static int mvpp2_set_ts_config(struct mvpp2_port *port, struct ifreq *ifr)
 {
 	struct hwtstamp_config config;
 	void __iomem *ptp;
+	u32 gcr, int_mask;
 
 	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
 		return -EFAULT;
@@ -4581,30 +4737,51 @@ static int mvpp2_set_ts_config(struct mvpp2_port *port, struct ifreq *ifr)
 	if (config.flags)
 		return -EINVAL;
 
-	if (config.tx_type != HWTSTAMP_TX_OFF)
+	if (config.tx_type != HWTSTAMP_TX_OFF &&
+	    config.tx_type != HWTSTAMP_TX_ON)
 		return -ERANGE;
 
 	ptp = port->priv->iface_base + MVPP22_PTP_BASE(port->gop_id);
+
+	int_mask = gcr = 0;
+	if (config.tx_type != HWTSTAMP_TX_OFF) {
+		gcr |= MVPP22_PTP_GCR_TSU_ENABLE | MVPP22_PTP_GCR_TX_RESET;
+		int_mask |= MVPP22_PTP_INT_MASK_QUEUE1 |
+			    MVPP22_PTP_INT_MASK_QUEUE0;
+	}
+
+	/* It seems we must also release the TX reset when enabling the TSU */
+	if (config.rx_filter != HWTSTAMP_FILTER_NONE)
+		gcr |= MVPP22_PTP_GCR_TSU_ENABLE | MVPP22_PTP_GCR_RX_RESET |
+		       MVPP22_PTP_GCR_TX_RESET;
+
+	if (gcr & MVPP22_PTP_GCR_TSU_ENABLE)
+		mvpp22_tai_start(port->priv->tai);
+
 	if (config.rx_filter != HWTSTAMP_FILTER_NONE) {
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
-		mvpp22_tai_start(port->priv->tai);
 		mvpp2_modify(ptp + MVPP22_PTP_GCR,
 			     MVPP22_PTP_GCR_RX_RESET |
 			     MVPP22_PTP_GCR_TX_RESET |
-			     MVPP22_PTP_GCR_TSU_ENABLE,
-			     MVPP22_PTP_GCR_RX_RESET |
-			     MVPP22_PTP_GCR_TX_RESET |
-			     MVPP22_PTP_GCR_TSU_ENABLE);
+			     MVPP22_PTP_GCR_TSU_ENABLE, gcr);
 		port->rx_hwtstamp = true;
 	} else {
 		port->rx_hwtstamp = false;
 		mvpp2_modify(ptp + MVPP22_PTP_GCR,
 			     MVPP22_PTP_GCR_RX_RESET |
 			     MVPP22_PTP_GCR_TX_RESET |
-			     MVPP22_PTP_GCR_TSU_ENABLE, 0);
-		mvpp22_tai_stop(port->priv->tai);
+			     MVPP22_PTP_GCR_TSU_ENABLE, gcr);
 	}
 
+	mvpp2_modify(ptp + MVPP22_PTP_INT_MASK,
+		     MVPP22_PTP_INT_MASK_QUEUE1 |
+		     MVPP22_PTP_INT_MASK_QUEUE0, int_mask);
+
+	if (!(gcr & MVPP22_PTP_GCR_TSU_ENABLE))
+		mvpp22_tai_stop(port->priv->tai);
+
+	port->tx_hwtstamp_type = config.tx_type;
+
 	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
 		return -EFAULT;
 
@@ -4617,7 +4794,7 @@ static int mvpp2_get_ts_config(struct mvpp2_port *port, struct ifreq *ifr)
 
 	memset(&config, 0, sizeof(config));
 
-	config.tx_type = HWTSTAMP_TX_OFF;
+	config.tx_type = port->tx_hwtstamp_type;
 	config.rx_filter = port->rx_hwtstamp ?
 		HWTSTAMP_FILTER_ALL : HWTSTAMP_FILTER_NONE;
 
@@ -4639,9 +4816,11 @@ static int mvpp2_ethtool_get_ts_info(struct net_device *dev,
 	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
 				SOF_TIMESTAMPING_RX_SOFTWARE |
 				SOF_TIMESTAMPING_SOFTWARE |
+				SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
 				SOF_TIMESTAMPING_RAW_HARDWARE;
-	info->tx_types = BIT(HWTSTAMP_TX_OFF);
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) |
+			 BIT(HWTSTAMP_TX_ON);
 	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
 			   BIT(HWTSTAMP_FILTER_ALL);
 
-- 
2.20.1

