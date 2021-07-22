Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6001C3D257A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhGVNfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:35:22 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:26929 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232432AbhGVNeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 09:34:25 -0400
X-IronPort-AV: E=Sophos;i="5.84,261,1620658800"; 
   d="scan'208";a="88414802"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 22 Jul 2021 23:14:59 +0900
Received: from localhost.localdomain (unknown [10.226.92.164])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id BEF59401224A;
        Thu, 22 Jul 2021 23:14:55 +0900 (JST)
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
Subject: [PATCH net-next 17/18] ravb: Add GbEthernet driver support
Date:   Thu, 22 Jul 2021 15:13:50 +0100
Message-Id: <20210722141351.13668-18-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Gigabit Ethernet driver support found on RZ/G2L.

The Gigabit Etherner IP consists of Ethernet controller (E-MAC),
Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory
access controller (DMAC).

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  84 ++++-
 drivers/net/ethernet/renesas/ravb_main.c | 436 ++++++++++++++++++++++-
 2 files changed, 513 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index af06e849db47..6d730f479a37 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -81,6 +81,7 @@ enum ravb_reg {
 	RQC3	= 0x00A0,
 	RQC4	= 0x00A4,
 	RPC	= 0x00B0,
+	RTC	= 0x00B4,	/* RZ/G2L only */
 	UFCW	= 0x00BC,
 	UFCS	= 0x00C0,
 	UFCV0	= 0x00C4,
@@ -156,6 +157,7 @@ enum ravb_reg {
 	TIS	= 0x037C,
 	ISS	= 0x0380,
 	CIE	= 0x0384,	/* R-Car Gen3 only */
+	RIC3	= 0x0388,	/* RZ/G2L only */
 	GCCR	= 0x0390,
 	GMTT	= 0x0394,
 	GPTC	= 0x0398,
@@ -187,19 +189,28 @@ enum ravb_reg {
 	PIR	= 0x0520,
 	PSR	= 0x0528,
 	PIPR	= 0x052c,
+	CXR31	= 0x0530,	/* Documented for RZ/G2L only */
+	CXR35	= 0x0540,	/* Documented for RZ/G2L only */
 	MPR	= 0x0558,
 	PFTCR	= 0x055c,
 	PFRCR	= 0x0560,
 	GECMR	= 0x05b0,
 	MAHR	= 0x05c0,
 	MALR	= 0x05c8,
-	TROCR	= 0x0700,	/* R-Car Gen3 only */
+	TROCR	= 0x0700,	/* R-Car Gen3 and RZ/G2L only */
+	CXR41	= 0x0708,	/* Documented for RZ/G2L only */
+	CXR42	= 0x0710,	/* Documented for RZ/G2L only */
 	CEFCR	= 0x0740,
 	FRECR	= 0x0748,
 	TSFRCR	= 0x0750,
 	TLFRCR	= 0x0758,
 	RFCR	= 0x0760,
+	CXR55	= 0x0768,	/* Documented for RZ/G2L only */
+	CXR56	= 0x0770,	/* Documented for RZ/G2L only */
 	MAFCR	= 0x0778,
+	CSR0     = 0x0800,	/* Documented for RZ/G2L only */
+	CSR1     = 0x0804,	/* Documented for RZ/G2L only */
+	CSR2     = 0x0808,	/* Documented for RZ/G2L only */
 };
 
 
@@ -804,16 +815,21 @@ enum TID_BIT {
 enum ECMR_BIT {
 	ECMR_PRM	= 0x00000001,
 	ECMR_DM		= 0x00000002,
+	ECMR_LPM	= 0x00000010,	/* Documented for RZ/G2L only */
 	ECMR_TE		= 0x00000020,
 	ECMR_RE		= 0x00000040,
 	ECMR_MPDE	= 0x00000200,
+	ECMR_CER	= 0x00001000,	/* Documented for RZ/G2L only */
 	ECMR_TXF	= 0x00010000,	/* Documented for R-Car Gen3 only */
 	ECMR_RXF	= 0x00020000,
 	ECMR_PFR	= 0x00040000,
 	ECMR_ZPF	= 0x00080000,	/* Documented for R-Car Gen3 only */
 	ECMR_RZPF	= 0x00100000,
 	ECMR_DPAD	= 0x00200000,
+	ECMR_CXSER	= 0x00400000,	/* Documented for RZ/G2L only */
 	ECMR_RCSC	= 0x00800000,
+	ECMR_TCPT	= 0x01000000,	/* Documented for RZ/G2L only */
+	ECMR_RCPT	= 0x02000000,	/* Documented for RZ/G2L only */
 	ECMR_TRCCM	= 0x04000000,
 };
 
@@ -823,6 +839,7 @@ enum ECSR_BIT {
 	ECSR_MPD	= 0x00000002,
 	ECSR_LCHNG	= 0x00000004,
 	ECSR_PHYI	= 0x00000008,
+	ECSR_PFRI	= 0x00000010,
 };
 
 /* ECSIPR */
@@ -857,9 +874,13 @@ enum MPR_BIT {
 
 /* GECMR */
 enum GECMR_BIT {
-	GECMR_SPEED	= 0x00000001,
-	GECMR_SPEED_100	= 0x00000000,
-	GECMR_SPEED_1000 = 0x00000001,
+	GECMR_SPEED		= 0x00000001,
+	GECMR_SPEED_100		= 0x00000000,
+	GECMR_SPEED_1000	= 0x00000001,
+	RGETH_GECMR_SPEED	= 0x00000030,
+	RGETH_GECMR_SPEED_10	= 0x00000000,
+	RGETH_GECMR_SPEED_100	= 0x00000010,
+	RGETH_GECMR_SPEED_1000	= 0x00000020,
 };
 
 /* The Ethernet AVB descriptor definitions. */
@@ -949,6 +970,54 @@ enum RAVB_QUEUE {
 	RAVB_NC,	/* Network Control Queue */
 };
 
+enum CXR31_BIT {
+	CXR31_SEL_LINK0	= 0x00000001,
+	CXR31_SEL_LINK1	= 0x00000008,
+};
+
+enum CXR35_BIT {
+	CXR35_SEL_MODIN	= 0x00000100,
+};
+
+enum CSR0_BIT {
+	CSR0_CCM	= 0x00000001,
+	CSR0_TPE	= 0x00000010,
+	CSR0_RPE	= 0x00000020,
+	CSR0_TBP	= 0x00000100,
+	CSR0_RBP	= 0x00000200,
+	CSR0_FIFOCAP	= 0x00003000,
+};
+
+enum CSR1_BIT {
+	CSR1_TIP4	= 0x00000001,
+	CSR1_TTCP4	= 0x00000010,
+	CSR1_TUDP4	= 0x00000020,
+	CSR1_TICMP4	= 0x00000040,
+	CSR1_TTCP6	= 0x00100000,
+	CSR1_TUDP6	= 0x00200000,
+	CSR1_TICMP6	= 0x00400000,
+	CSR1_THOP	= 0x01000000,
+	CSR1_TROUT	= 0x02000000,
+	CSR1_TAHD	= 0x04000000,
+	CSR1_TDHD	= 0x08000000,
+	CSR1_ALL	= 0x0F700071,
+};
+
+enum CSR2_BIT {
+	CSR2_RIP4	= 0x00000001,
+	CSR2_RTCP4	= 0x00000010,
+	CSR2_RUDP4	= 0x00000020,
+	CSR2_RICMP4	= 0x00000040,
+	CSR2_RTCP6	= 0x00100000,
+	CSR2_RUDP6	= 0x00200000,
+	CSR2_RICMP6	= 0x00400000,
+	CSR2_RHOP	= 0x01000000,
+	CSR2_RROUT	= 0x02000000,
+	CSR2_RAHD	= 0x04000000,
+	CSR2_RDHD	= 0x08000000,
+	CSR2_ALL	= 0x0F700071,
+};
+
 #define DBAT_ENTRY_NUM	22
 #define RX_QUEUE_OFFSET	4
 #define NUM_RX_QUEUE	2
@@ -956,6 +1025,9 @@ enum RAVB_QUEUE {
 
 #define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
 
+#define RGETH_RX_BUFF_MAX 8192
+#define RGETH_RX_DESC_DATA_SIZE 4080
+
 /* TX descriptors per packet */
 #define NUM_TX_DESC_GEN2	2
 #define NUM_TX_DESC_GEN3	1
@@ -1068,6 +1140,10 @@ struct ravb_private {
 
 	const struct ravb_drv_data *info;
 	struct reset_control *rstc;
+
+	int duplex;
+	struct ravb_rx_desc *rgeth_rx_ring[NUM_RX_QUEUE];
+	struct sk_buff *rxtop_skb;
 };
 
 static inline u32 ravb_read(struct net_device *ndev, enum ravb_reg reg)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 5a83dd83c635..0378b2d26b8c 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -51,6 +51,8 @@
 #define RAVB_NO_HALF_DUPLEX		BIT(7)
 #define RAVB_OVERRIDE_MTU_CHANGE	BIT(8)
 #define RAVB_EX_RX_DESC			BIT(9)
+#define RAVB_MII_RGMII_SELECTION	BIT(10)
+#define RAVB_CARRIER_COUNTER		BIT(11)
 
 #define RAVB_PTP	(RAVB_PTP_CONFIG_ACTIVE | RAVB_PTP_CONFIG_INACTIVE)
 #define RAVB_RCAR_COMMON \
@@ -71,6 +73,10 @@
 		(RAVB_PTP_CONFIG_INACTIVE	| \
 		 RAVB_RCAR_COMMON)
 
+#define RAVB_RZ_G2L_FEATURES \
+		(RAVB_MII_RGMII_SELECTION	| \
+		 RAVB_CARRIER_COUNTER)
+
 static const char *ravb_rx_irqs[NUM_RX_QUEUE] = {
 	"ch0", /* RAVB_BE */
 	"ch1", /* RAVB_NC */
@@ -113,6 +119,23 @@ static int ravb_config(struct net_device *ndev)
 	return error;
 }
 
+static void ravb_set_rate_rgeth(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	switch (priv->speed) {
+	case 10:                /* 10BASE */
+		ravb_write(ndev, RGETH_GECMR_SPEED_10, GECMR);
+		break;
+	case 100:               /* 100BASE */
+		ravb_write(ndev, RGETH_GECMR_SPEED_100, GECMR);
+		break;
+	case 1000:              /* 1000BASE */
+		ravb_write(ndev, RGETH_GECMR_SPEED_1000, GECMR);
+		break;
+	}
+}
+
 static void ravb_set_rate(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -248,6 +271,28 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 }
 
 /* Free skb's and DMA buffers for Ethernet AVB */
+static void ravb_ring_free_rx_rgeth(struct net_device *ndev, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	int ring_size;
+	int i;
+
+	for (i = 0; i < priv->num_rx_ring[q]; i++) {
+		struct ravb_rx_desc *desc = &priv->rgeth_rx_ring[q][i];
+
+		if (!dma_mapping_error(ndev->dev.parent,
+				       le32_to_cpu(desc->dptr)))
+			dma_unmap_single(ndev->dev.parent,
+					 le32_to_cpu(desc->dptr),
+					 RGETH_RX_BUFF_MAX,
+					 DMA_FROM_DEVICE);
+	}
+	ring_size = sizeof(struct ravb_rx_desc) * (priv->num_rx_ring[q] + 1);
+	dma_free_coherent(ndev->dev.parent, ring_size, priv->rgeth_rx_ring[q],
+			  priv->rx_desc_dma[q]);
+	priv->rgeth_rx_ring[q] = NULL;
+}
+
 static void ravb_ring_free_rx(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -279,7 +324,7 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 	int ring_size;
 	int i;
 
-	if (priv->rx_ring[q])
+	if (priv->rx_ring[q] || priv->rgeth_rx_ring[q])
 		info->ravb_ops->ring_free(ndev, q);
 
 	if (priv->tx_ring[q]) {
@@ -312,6 +357,36 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 }
 
 /* Format skb and descriptor buffer for Ethernet AVB */
+static void ravb_ring_format_rx_rgeth(struct net_device *ndev, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	struct ravb_rx_desc *rx_desc;
+	int rx_ring_size = sizeof(*rx_desc) * priv->num_rx_ring[q];
+	dma_addr_t dma_addr;
+	int i;
+
+	memset(priv->rgeth_rx_ring[q], 0, rx_ring_size);
+	/* Build RX ring buffer */
+	for (i = 0; i < priv->num_rx_ring[q]; i++) {
+		/* RX descriptor */
+		rx_desc = &priv->rgeth_rx_ring[q][i];
+		rx_desc->ds_cc = cpu_to_le16(RGETH_RX_DESC_DATA_SIZE);
+		dma_addr = dma_map_single(ndev->dev.parent, priv->rx_skb[q][i]->data,
+					  RGETH_RX_BUFF_MAX,
+					  DMA_FROM_DEVICE);
+		/* We just set the data size to 0 for a failed mapping which
+		 * should prevent DMA from happening...
+		 */
+		if (dma_mapping_error(ndev->dev.parent, dma_addr))
+			rx_desc->ds_cc = cpu_to_le16(0);
+		rx_desc->dptr = cpu_to_le32(dma_addr);
+		rx_desc->die_dt = DT_FEMPTY;
+	}
+	rx_desc = &priv->rgeth_rx_ring[q][i];
+	rx_desc->dptr = cpu_to_le32((u32)priv->rx_desc_dma[q]);
+	rx_desc->die_dt = DT_LINKFIX; /* type */
+}
+
 static void ravb_ring_format_rx(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -385,6 +460,19 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 }
 
 /* Init skb and descriptor buffer for Ethernet AVB */
+static bool ravb_alloc_rx_desc_rgeth(struct net_device *ndev, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	int ring_size;
+
+	ring_size = sizeof(struct ravb_rx_desc) * (priv->num_rx_ring[q] + 1);
+
+	priv->rgeth_rx_ring[q] = dma_alloc_coherent(ndev->dev.parent, ring_size,
+						    &priv->rx_desc_dma[q],
+						    GFP_KERNEL);
+	return priv->rgeth_rx_ring[q];
+}
+
 static bool ravb_alloc_rx_desc(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -455,6 +543,37 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 }
 
 /* E-MAC init function */
+static void ravb_emac_init_rgeth(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	/* Receive frame limit set register */
+	ravb_write(ndev, RGETH_RX_BUFF_MAX + ETH_FCS_LEN, RFLR);
+
+	/* PAUSE prohibition */
+	ravb_write(ndev, ECMR_ZPF | ((priv->duplex > 0) ? ECMR_DM : 0) |
+			 ECMR_TE | ECMR_RE | ECMR_RCPT |
+			 ECMR_TXF | ECMR_RXF | ECMR_PRM, ECMR);
+
+	ravb_set_rate_rgeth(ndev);
+
+	/* Set MAC address */
+	ravb_write(ndev,
+		   (ndev->dev_addr[0] << 24) | (ndev->dev_addr[1] << 16) |
+		   (ndev->dev_addr[2] << 8)  | (ndev->dev_addr[3]), MAHR);
+	ravb_write(ndev, (ndev->dev_addr[4] << 8)  | (ndev->dev_addr[5]), MALR);
+
+	/* E-MAC status register clear */
+	ravb_write(ndev, ECSR_ICD | ECSR_LCHNG | ECSR_PFRI, ECSR);
+	ravb_write(ndev, CSR0_TPE | CSR0_RPE, CSR0);
+
+	/* E-MAC interrupt enable register */
+	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
+
+	ravb_write(ndev, ravb_read(ndev, CXR31) & ~CXR31_SEL_LINK1, CXR31);
+	ravb_write(ndev, ravb_read(ndev, CXR31) | CXR31_SEL_LINK0, CXR31);
+}
+
 static void ravb_emac_init_ex(struct net_device *ndev)
 {
 	/* Receive frame limit set register */
@@ -490,6 +609,31 @@ static void ravb_emac_init(struct net_device *ndev)
 }
 
 /* Device init function for Ethernet AVB */
+static void ravb_dmac_init_rgeth(struct net_device *ndev)
+{
+	/* Set AVB RX */
+	ravb_write(ndev, 0x60000000, RCR);
+
+	/* Set Max Frame Length (RTC) */
+	ravb_write(ndev, 0x7ffc0000 | RGETH_RX_BUFF_MAX, RTC);
+
+	/* Set FIFO size */
+	ravb_write(ndev, 0x00222200, TGC);
+
+	ravb_write(ndev, 0, TCCR);
+
+	/* Frame receive */
+	ravb_write(ndev, RIC0_FRE0, RIC0);
+	/* Disable FIFO full warning */
+	ravb_write(ndev, 0x0, RIC1);
+	/* Receive FIFO full error, descriptor empty */
+	ravb_write(ndev, RIC2_QFE0 | RIC2_RFFE, RIC2);
+
+	ravb_write(ndev, 0x0, RIC3);
+
+	ravb_write(ndev, TIC_FTE0, TIC);
+}
+
 static void ravb_dmac_init_ex(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -592,6 +736,23 @@ static void ravb_get_tx_tstamp(struct net_device *ndev)
 	}
 }
 
+static void ravb_rx_csum_rgeth(struct sk_buff *skb)
+{
+	u8 *hw_csum;
+
+	/* The hardware checksum is contained in sizeof(__sum16) (2) bytes
+	 * appended to packet data
+	 */
+	if (unlikely(skb->len < sizeof(__sum16)))
+		return;
+	hw_csum = skb_tail_pointer(skb) - sizeof(__sum16);
+
+	if (*hw_csum == 0)
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	else
+		skb->ip_summed = CHECKSUM_NONE;
+}
+
 static void ravb_rx_csum(struct sk_buff *skb)
 {
 	u8 *hw_csum;
@@ -608,6 +769,148 @@ static void ravb_rx_csum(struct sk_buff *skb)
 }
 
 /* Packet receive function for Ethernet AVB */
+static struct sk_buff *ravb_get_skb_rgeth(struct net_device *ndev,  int q,
+					  int entry, struct ravb_rx_desc *desc)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	struct sk_buff *skb;
+
+	skb = priv->rx_skb[q][entry];
+	priv->rx_skb[q][entry] = NULL;
+	dma_unmap_single(ndev->dev.parent, le32_to_cpu(desc->dptr),
+			 ALIGN(RGETH_RX_BUFF_MAX, 16), DMA_FROM_DEVICE);
+
+	return skb;
+}
+
+static bool ravb_rx_rgeth(struct net_device *ndev, int *quota, int q)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	int entry = priv->cur_rx[q] % priv->num_rx_ring[q];
+	int boguscnt = priv->dirty_rx[q] + priv->num_rx_ring[q] - priv->cur_rx[q];
+	struct net_device_stats *stats = &priv->stats[q];
+	struct ravb_rx_desc *desc;
+	struct sk_buff *skb;
+	dma_addr_t dma_addr;
+	u8  desc_status;
+	u8  die_dt;
+	u16 pkt_len;
+	int limit;
+
+	boguscnt = min(boguscnt, *quota);
+	limit = boguscnt;
+	desc = &priv->rgeth_rx_ring[q][entry];
+	while (desc->die_dt != DT_FEMPTY) {
+		/* Descriptor type must be checked before all other reads */
+		dma_rmb();
+		desc_status = desc->msc;
+		pkt_len = le16_to_cpu(desc->ds_cc) & RX_DS;
+
+		if (--boguscnt < 0)
+			break;
+
+		/* We use 0-byte descriptors to mark the DMA mapping errors */
+		if (!pkt_len)
+			continue;
+
+		if (desc_status & MSC_MC)
+			stats->multicast++;
+
+		if (desc_status & (MSC_CRC | MSC_RFE | MSC_RTSF | MSC_RTLF | MSC_CEEF)) {
+			stats->rx_errors++;
+			if (desc_status & MSC_CRC)
+				stats->rx_crc_errors++;
+			if (desc_status & MSC_RFE)
+				stats->rx_frame_errors++;
+			if (desc_status & (MSC_RTLF | MSC_RTSF))
+				stats->rx_length_errors++;
+			if (desc_status & MSC_CEEF)
+				stats->rx_missed_errors++;
+		} else {
+			die_dt = desc->die_dt & 0xF0;
+			switch (die_dt) {
+			case DT_FSINGLE:
+				skb = ravb_get_skb_rgeth(ndev, q, entry, desc);
+				skb_put(skb, pkt_len);
+				skb->protocol = eth_type_trans(skb, ndev);
+				if (ndev->features & NETIF_F_RXCSUM)
+					ravb_rx_csum_rgeth(skb);
+				napi_gro_receive(&priv->napi[q], skb);
+				stats->rx_packets++;
+				stats->rx_bytes += pkt_len;
+				break;
+			case DT_FSTART:
+				priv->rxtop_skb = ravb_get_skb_rgeth(ndev, q, entry, desc);
+				skb_put(priv->rxtop_skb, pkt_len);
+				break;
+			case DT_FMID:
+				skb = ravb_get_skb_rgeth(ndev, q, entry, desc);
+				skb_copy_to_linear_data_offset(priv->rxtop_skb,
+							       priv->rxtop_skb->len,
+							       skb->data,
+							       pkt_len);
+				skb_put(priv->rxtop_skb, pkt_len);
+				dev_kfree_skb(skb);
+				break;
+			case DT_FEND:
+				skb = ravb_get_skb_rgeth(ndev, q, entry, desc);
+				skb_copy_to_linear_data_offset(priv->rxtop_skb,
+							       priv->rxtop_skb->len,
+							       skb->data,
+							       pkt_len);
+				skb_put(priv->rxtop_skb, pkt_len);
+				dev_kfree_skb(skb);
+				priv->rxtop_skb->protocol =
+					eth_type_trans(priv->rxtop_skb, ndev);
+				if (ndev->features & NETIF_F_RXCSUM)
+					ravb_rx_csum_rgeth(skb);
+				napi_gro_receive(&priv->napi[q],
+						 priv->rxtop_skb);
+				stats->rx_packets++;
+				stats->rx_bytes += priv->rxtop_skb->len;
+				break;
+			}
+		}
+
+		entry = (++priv->cur_rx[q]) % priv->num_rx_ring[q];
+		desc = &priv->rgeth_rx_ring[q][entry];
+	}
+
+	/* Refill the RX ring buffers. */
+	for (; priv->cur_rx[q] - priv->dirty_rx[q] > 0; priv->dirty_rx[q]++) {
+		entry = priv->dirty_rx[q] % priv->num_rx_ring[q];
+		desc = &priv->rgeth_rx_ring[q][entry];
+		desc->ds_cc = cpu_to_le16(RGETH_RX_DESC_DATA_SIZE);
+
+		if (!priv->rx_skb[q][entry]) {
+			skb = netdev_alloc_skb(ndev,
+					       RGETH_RX_BUFF_MAX + RAVB_ALIGN - 1);
+			if (!skb)
+				break;
+			ravb_set_buffer_align(skb);
+			dma_addr = dma_map_single(ndev->dev.parent,
+						  skb->data,
+						  le16_to_cpu(RGETH_RX_BUFF_MAX),
+						  DMA_FROM_DEVICE);
+			skb_checksum_none_assert(skb);
+			/* We just set the data size to 0 for a failed mapping
+			 * which should prevent DMA  from happening...
+			 */
+			if (dma_mapping_error(ndev->dev.parent, dma_addr))
+				desc->ds_cc = cpu_to_le16(0);
+			desc->dptr = cpu_to_le32(dma_addr);
+			priv->rx_skb[q][entry] = skb;
+		}
+		/* Descriptor type must be set after all the above writes */
+		dma_wmb();
+		desc->die_dt = DT_FEMPTY;
+	}
+
+	*quota -= limit - (++boguscnt);
+
+	return boguscnt <= 0;
+}
+
 static bool ravb_ex_rx(struct net_device *ndev, int *quota, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -754,6 +1057,9 @@ static int ravb_stop_dma(struct net_device *ndev)
 	if (info->features & RAVB_MULTI_TSRQ)
 		error = ravb_wait(ndev, TCCR,
 				  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
+	else
+		error = ravb_wait(ndev, TCCR, TCCR_TSRQ0, 0);
+
 	if (error)
 		return error;
 
@@ -1003,16 +1309,24 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	struct net_device *ndev = napi->dev;
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_drv_data *info = priv->info;
+	struct ravb_rx_desc *desc;
 	unsigned long flags;
 	int q = napi - priv->napi;
 	int mask = BIT(q);
 	int quota = budget;
+	int entry;
 
+	if (!(info->features & RAVB_EX_RX_DESC)) {
+		entry = priv->cur_rx[q] % priv->num_rx_ring[q];
+		desc = &priv->rgeth_rx_ring[q][entry];
+	}
 	/* Processing RX Descriptor Ring */
 	/* Clear RX interrupt */
 	ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
-	if (ravb_rx(ndev, &quota, q))
-		goto out;
+	if ((info->features & RAVB_EX_RX_DESC) || desc->die_dt != DT_FEMPTY) {
+		if (ravb_rx(ndev, &quota, q))
+			goto out;
+	}
 
 	/* Processing TX Descriptor Ring */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1046,6 +1360,18 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	return budget - quota;
 }
 
+static void ravb_set_duplex_rgeth(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	u32 ecmr = ravb_read(ndev, ECMR);
+
+	if (priv->duplex > 0)	/* Full */
+		ecmr |=  ECMR_DM;
+	else			/* Half */
+		ecmr &= ~ECMR_DM;
+	ravb_write(ndev, ecmr, ECMR);
+}
+
 /* PHY state control function */
 static void ravb_adjust_link(struct net_device *ndev)
 {
@@ -1062,6 +1388,12 @@ static void ravb_adjust_link(struct net_device *ndev)
 		ravb_rcv_snd_disable(ndev);
 
 	if (phydev->link) {
+		if (!(info->features & RAVB_NO_HALF_DUPLEX) && phydev->duplex != priv->duplex) {
+			new_state = true;
+			priv->duplex = phydev->duplex;
+			ravb_set_duplex_rgeth(ndev);
+		}
+
 		if (phydev->speed != priv->speed) {
 			new_state = true;
 			priv->speed = phydev->speed;
@@ -1076,6 +1408,8 @@ static void ravb_adjust_link(struct net_device *ndev)
 		new_state = true;
 		priv->link = 0;
 		priv->speed = 0;
+		if (!(info->features & RAVB_NO_HALF_DUPLEX))
+			priv->duplex = -1;
 	}
 
 	/* Enable TX and RX right over here, if E-MAC change is ignored */
@@ -1106,6 +1440,7 @@ static int ravb_phy_init(struct net_device *ndev)
 
 	priv->link = 0;
 	priv->speed = 0;
+	priv->duplex = -1;
 
 	/* Try connecting to PHY */
 	pn = of_parse_phandle(np, "phy-handle", 0);
@@ -1144,6 +1479,9 @@ static int ravb_phy_init(struct net_device *ndev)
 		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
 	}
 
+	if (info->features & RAVB_MII_RGMII_SELECTION)
+		ravb_write(ndev, ravb_read(ndev, CXR35) | CXR35_SEL_MODIN, CXR35);
+
 	if (info->features & RAVB_NO_HALF_DUPLEX) {
 		/* 10BASE, Pause and Asym Pause is not supported */
 		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
@@ -1197,6 +1535,24 @@ static void ravb_set_msglevel(struct net_device *ndev, u32 value)
 	priv->msg_enable = value;
 }
 
+static const char ravb_gstrings_stats_rgeth[][ETH_GSTRING_LEN] = {
+	"rx_queue_0_current",
+	"tx_queue_0_current",
+	"rx_queue_0_dirty",
+	"tx_queue_0_dirty",
+	"rx_queue_0_packets",
+	"tx_queue_0_packets",
+	"rx_queue_0_bytes",
+	"tx_queue_0_bytes",
+	"rx_queue_0_mcast_packets",
+	"rx_queue_0_errors",
+	"rx_queue_0_crc_errors",
+	"rx_queue_0_frame_errors",
+	"rx_queue_0_length_errors",
+	"rx_queue_0_csum_offload_errors",
+	"rx_queue_0_over_errors",
+};
+
 static const char ravb_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"rx_queue_0_current",
 	"tx_queue_0_current",
@@ -1752,6 +2108,18 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
 		ravb_write(ndev, 0, TROCR);	/* (write clear) */
 	}
 
+	if (info->features & RAVB_CARRIER_COUNTER) {
+		nstats->collisions += ravb_read(ndev, CXR41);
+		ravb_write(ndev, 0, CXR41);	/* (write clear) */
+		nstats->tx_carrier_errors += ravb_read(ndev, CXR42);
+		ravb_write(ndev, 0, CXR42);	/* (write clear) */
+
+		nstats->tx_carrier_errors += ravb_read(ndev, CXR55);
+		ravb_write(ndev, 0, CXR55);	/* (write clear) */
+		nstats->tx_carrier_errors += ravb_read(ndev, CXR56);
+		ravb_write(ndev, 0, CXR56);	/* (write clear) */
+	}
+
 	nstats->rx_packets = stats0->rx_packets + stats1->rx_packets;
 	nstats->tx_packets = stats0->tx_packets + stats1->tx_packets;
 	nstats->rx_bytes = stats0->rx_bytes + stats1->rx_bytes;
@@ -1967,6 +2335,44 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
+static int ravb_set_features_rx_csum_rgeth(struct net_device *ndev,
+					   netdev_features_t features)
+{
+	netdev_features_t changed = features ^ ndev->features;
+	unsigned int reg;
+	int error;
+
+	reg = ravb_read(ndev, CSR0);
+
+	ravb_write(ndev, reg & ~(CSR0_RPE | CSR0_TPE), CSR0);
+	error = ravb_wait(ndev, CSR0, CSR0_RPE | CSR0_TPE, 0);
+	if (error) {
+		ravb_write(ndev, reg, CSR0);
+		return error;
+	}
+
+	if (changed & NETIF_F_RXCSUM) {
+		if (features & NETIF_F_RXCSUM)
+			ravb_write(ndev, CSR2_ALL, CSR2);
+		else
+			ravb_write(ndev, 0, CSR2);
+	}
+
+	if (changed & NETIF_F_HW_CSUM) {
+		if (features & NETIF_F_HW_CSUM) {
+			ravb_write(ndev, CSR1_ALL, CSR1);
+			ndev->features |= NETIF_F_CSUM_MASK;
+		} else {
+			ravb_write(ndev, 0, CSR1);
+		}
+	}
+	ravb_write(ndev, reg, CSR0);
+
+	ndev->features = features;
+
+	return 0;
+}
+
 static int ravb_set_features_rx_csum(struct net_device *ndev,
 				     netdev_features_t features)
 {
@@ -2060,6 +2466,17 @@ static const struct ravb_ops ravb_gen3_ops = {
 	.set_features = ravb_set_features_rx_csum,
 };
 
+static const struct ravb_ops ravb_ops_rgeth = {
+	.ring_free = ravb_ring_free_rx_rgeth,
+	.ring_format = ravb_ring_format_rx_rgeth,
+	.alloc_rx_desc = ravb_alloc_rx_desc_rgeth,
+	.emac_init = ravb_emac_init_rgeth,
+	.dmac_init = ravb_dmac_init_rgeth,
+	.receive = ravb_rx_rgeth,
+	.set_rate = ravb_set_rate_rgeth,
+	.set_features = ravb_set_features_rx_csum_rgeth,
+};
+
 static const struct ravb_drv_data ravb_gen3_data = {
 	.ravb_ops = &ravb_gen3_ops,
 	.net_features = NETIF_F_RXCSUM,
@@ -2088,12 +2505,25 @@ static const struct ravb_drv_data ravb_gen2_data = {
 	.features = RAVB_RCAR_GEN2_FEATURES,
 };
 
+static const struct ravb_drv_data rgeth_data = {
+	.ravb_ops = &ravb_ops_rgeth,
+	.net_hw_features = (NETIF_F_HW_CSUM | NETIF_F_RXCSUM),
+	.gstrings_stats = ravb_gstrings_stats_rgeth,
+	.gstrings_size = sizeof(ravb_gstrings_stats_rgeth),
+	.stats_len = ARRAY_SIZE(ravb_gstrings_stats_rgeth),
+	.num_gstat_queue = 1,
+	.skb_sz = RGETH_RX_BUFF_MAX + RAVB_ALIGN - 1,
+	.num_tx_desc = 2,
+	.features = RAVB_RZ_G2L_FEATURES,
+};
+
 static const struct of_device_id ravb_match_table[] = {
 	{ .compatible = "renesas,etheravb-r8a7790", .data = &ravb_gen2_data },
 	{ .compatible = "renesas,etheravb-r8a7794", .data = &ravb_gen2_data },
 	{ .compatible = "renesas,etheravb-rcar-gen2", .data = &ravb_gen2_data },
 	{ .compatible = "renesas,etheravb-r8a7795", .data = &ravb_gen3_data },
 	{ .compatible = "renesas,etheravb-rcar-gen3", .data = &ravb_gen3_data },
+	{ .compatible = "renesas,rzg2l-gbeth", .data = &rgeth_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ravb_match_table);
-- 
2.17.1

