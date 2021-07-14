Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A570C3C8666
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 16:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239518AbhGNO5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 10:57:16 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:17322 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231797AbhGNO5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 10:57:15 -0400
X-IronPort-AV: E=Sophos;i="5.84,239,1620658800"; 
   d="scan'208";a="87641427"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 14 Jul 2021 23:54:22 +0900
Received: from localhost.localdomain (unknown [10.226.92.185])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 0B1C44001B52;
        Wed, 14 Jul 2021 23:54:18 +0900 (JST)
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: [PATCH/RFC 2/2] ravb: Add GbEthernet driver support
Date:   Wed, 14 Jul 2021 15:54:08 +0100
Message-Id: <20210714145408.4382-3-biju.das.jz@bp.renesas.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
References: <20210714145408.4382-1-biju.das.jz@bp.renesas.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Gigabit Ethernet driver support.

The Gigabit Etherner IP consists of Ethernet controller (E-MAC),
Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory
access controller (DMAC).

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
---
 drivers/net/ethernet/renesas/ravb.h      |  92 ++-
 drivers/net/ethernet/renesas/ravb_main.c | 683 ++++++++++++++++++++---
 2 files changed, 682 insertions(+), 93 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index 80e62ca2e3d3..4e65683fb458 100644
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
@@ -181,25 +183,39 @@ enum ravb_reg {
 
 	/* E-MAC registers */
 	ECMR	= 0x0500,
+	CXR20	= 0x0500,	/* Documented for RZ/G2L only */
 	RFLR	= 0x0508,
+	CXR2A	= 0x0508,	/* Documented for RZ/G2L only */
 	ECSR	= 0x0510,
 	ECSIPR	= 0x0518,
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
+	CDCR	= 0x0708,	/* Documented for RZ/G2L only */
+	LCCR	= 0x0710,	/* Documented for RZ/G2L only */
 	CEFCR	= 0x0740,
 	FRECR	= 0x0748,
 	TSFRCR	= 0x0750,
 	TLFRCR	= 0x0758,
 	RFCR	= 0x0760,
+	CERCR	= 0x0768,	/* Documented for RZ/G2L only */
+	CEECR	= 0x0770,	/* Documented for RZ/G2L only */
 	MAFCR	= 0x0778,
+	LPTXMOD2 = 0x07B4,	/* Documented for RZ/G2L only */
+	LPTXGTH1 = 0x07C0,	/* Documented for RZ/G2L only */
+	LPTXMTH1 = 0x07D0,	/* Documented for RZ/G2L only */
+	CSR0     = 0x0800,	/* Documented for RZ/G2L only */
+	CSR1     = 0x0804,	/* Documented for RZ/G2L only */
+	CSR2     = 0x0808,	/* Documented for RZ/G2L only */
 };
 
 
@@ -216,6 +232,7 @@ enum CCC_BIT {
 	CCC_CSEL_HPB	= 0x00010000,
 	CCC_CSEL_ETH_TX	= 0x00020000,
 	CCC_CSEL_GMII_REF = 0x00030000,
+	CCC_BOC		= 0x00100000,	/* Documented for RZ/G2L only */
 	CCC_LBME	= 0x01000000,
 };
 
@@ -804,16 +821,21 @@ enum TID_BIT {
 enum ECMR_BIT {
 	ECMR_PRM	= 0x00000001,
 	ECMR_DM		= 0x00000002,
+	CXR20_LPM	= 0x00000010,	/* Documented for RZ/G2L only */
 	ECMR_TE		= 0x00000020,
 	ECMR_RE		= 0x00000040,
 	ECMR_MPDE	= 0x00000200,
+	CXR20_CER	= 0x00001000,	/* Documented for RZ/G2L only */
 	ECMR_TXF	= 0x00010000,	/* Documented for R-Car Gen3 only */
 	ECMR_RXF	= 0x00020000,
 	ECMR_PFR	= 0x00040000,
 	ECMR_ZPF	= 0x00080000,	/* Documented for R-Car Gen3 only */
 	ECMR_RZPF	= 0x00100000,
 	ECMR_DPAD	= 0x00200000,
+	CXR20_CXSER	= 0x00400000,	/* Documented for RZ/G2L only */
 	ECMR_RCSC	= 0x00800000,
+	CXR20_TCPT	= 0x01000000,	/* Documented for RZ/G2L only */
+	CXR20_RCPT	= 0x02000000,	/* Documented for RZ/G2L only */
 	ECMR_TRCCM	= 0x04000000,
 };
 
@@ -823,6 +845,7 @@ enum ECSR_BIT {
 	ECSR_MPD	= 0x00000002,
 	ECSR_LCHNG	= 0x00000004,
 	ECSR_PHYI	= 0x00000008,
+	ECSR_RFRI	= 0x00000010,	/* Documented for RZ/G2L only */
 };
 
 /* ECSIPR */
@@ -862,6 +885,14 @@ enum GECMR_BIT {
 	GECMR_SPEED_1000 = 0x00000001,
 };
 
+/* GECMR */
+enum RGETH_GECMR_BIT {
+	RGETH_GECMR_SPEED	= 0x00000030,
+	RGETH_GECMR_SPEED_10	= 0x00000000,
+	RGETH_GECMR_SPEED_100	= 0x00000010,
+	RGETH_GECMR_SPEED_1000	= 0x00000020,
+};
+
 /* The Ethernet AVB descriptor definitions. */
 struct ravb_desc {
 	__le16 ds;	/* Descriptor size */
@@ -949,6 +980,54 @@ enum RAVB_QUEUE {
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
@@ -956,8 +1035,11 @@ enum RAVB_QUEUE {
 
 #define RX_BUF_SZ	(2048 - ETH_FCS_LEN + sizeof(__sum16))
 
+#define RGETH_RCV_BUFF_MAX 8192
+#define RGETH_RCV_DESCRIPTOR_DATA_SIZE 4080
+
 /* TX descriptors per packet */
-#define NUM_TX_DESC_GEN2	2
+#define NUM_TX_DESC_GEN2	2	/* RCar Gen2 or RZ/G2L */
 #define NUM_TX_DESC_GEN3	1
 
 struct ravb_tstamp_skb {
@@ -986,6 +1068,7 @@ struct ravb_ptp {
 enum ravb_chip_id {
 	RCAR_GEN2,
 	RCAR_GEN3,
+	RZ_G2L,
 };
 
 struct ravb_private {
@@ -1040,6 +1123,11 @@ struct ravb_private {
 	unsigned txcidm:1;		/* TX Clock Internal Delay Mode */
 	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
 	int num_tx_desc;		/* TX descriptors per packet */
+
+	int duplex;
+	struct ravb_rx_desc *rgeth_rx_ring[NUM_RX_QUEUE];
+	struct sk_buff *rxtop_skb;
+	struct reset_control *rstc;
 };
 
 static inline u32 ravb_read(struct net_device *ndev, enum ravb_reg reg)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 7e6feda59f4a..e28a63de553d 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/sys_soc.h>
+#include <linux/reset.h>
 
 #include <asm/div64.h>
 
@@ -82,6 +83,23 @@ static int ravb_config(struct net_device *ndev)
 	return error;
 }
 
+static void rgeth_set_rate(struct net_device *ndev)
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
@@ -217,6 +235,29 @@ static int ravb_tx_free(struct net_device *ndev, int q, bool free_txed_only)
 }
 
 /* Free skb's and DMA buffers for Ethernet AVB */
+static void rgeth_ring_free_ex(struct net_device *ndev, int q)
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
+					 RGETH_RCV_BUFF_MAX,
+					 DMA_FROM_DEVICE);
+	}
+	ring_size = sizeof(struct ravb_rx_desc) *
+		    (priv->num_rx_ring[q] + 1);
+	dma_free_coherent(ndev->dev.parent, ring_size, priv->rgeth_rx_ring[q],
+			  priv->rx_desc_dma[q]);
+	priv->rgeth_rx_ring[q] = NULL;
+}
+
 static void ravb_ring_free_ex(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -247,8 +288,12 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 	int ring_size;
 	int i;
 
-	if (priv->rx_ring[q]) {
-		ravb_ring_free_ex(ndev, q);
+	if (priv->chip_id == RZ_G2L) {
+		if (priv->rgeth_rx_ring[q])
+			rgeth_ring_free_ex(ndev, q);
+	} else {
+		if (priv->rx_ring[q])
+			ravb_ring_free_ex(ndev, q);
 	}
 
 	if (priv->tx_ring[q]) {
@@ -281,6 +326,36 @@ static void ravb_ring_free(struct net_device *ndev, int q)
 }
 
 /* Format skb and descriptor buffer for Ethernet AVB */
+static void rgeth_ring_format_ex(struct net_device *ndev, int q)
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
+		rx_desc->ds_cc = cpu_to_le16(RGETH_RCV_DESCRIPTOR_DATA_SIZE);
+		dma_addr = dma_map_single(ndev->dev.parent, priv->rx_skb[q][i]->data,
+					  RGETH_RCV_BUFF_MAX,
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
 static void ravb_ring_format_ex(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -326,7 +401,10 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 	priv->dirty_tx[q] = 0;
 
 	/* Build RX ring buffer */
-	ravb_ring_format_ex(ndev, q);
+	if (priv->chip_id == RZ_G2L)
+		rgeth_ring_format_ex(ndev, q);
+	else
+		ravb_ring_format_ex(ndev, q);
 
 	memset(priv->tx_ring[q], 0, tx_ring_size);
 	/* Build TX ring buffer */
@@ -356,7 +434,7 @@ static void ravb_ring_format(struct net_device *ndev, int q)
 static int ravb_ring_init(struct net_device *ndev, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	size_t skb_sz = RX_BUF_SZ;
+	size_t skb_sz = (priv->chip_id == RZ_G2L) ? RGETH_RCV_BUFF_MAX : RX_BUF_SZ;
 	int num_tx_desc = priv->num_tx_desc;
 	struct sk_buff *skb;
 	int ring_size;
@@ -387,12 +465,23 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 	}
 
 	/* Allocate all RX descriptors. */
-	ring_size = sizeof(struct ravb_ex_rx_desc) * (priv->num_rx_ring[q] + 1);
-	priv->rx_ring[q] = dma_alloc_coherent(ndev->dev.parent, ring_size,
-					      &priv->rx_desc_dma[q],
-					      GFP_KERNEL);
-	if (!priv->rx_ring[q])
-		goto error;
+	if (priv->chip_id == RZ_G2L) {
+		ring_size = sizeof(struct ravb_rx_desc) * (priv->num_rx_ring[q] + 1);
+
+		priv->rgeth_rx_ring[q] = dma_alloc_coherent(ndev->dev.parent, ring_size,
+							    &priv->rx_desc_dma[q],
+							    GFP_KERNEL);
+		if (!priv->rgeth_rx_ring[q])
+			goto error;
+	} else {
+		ring_size = sizeof(struct ravb_ex_rx_desc) * (priv->num_rx_ring[q] + 1);
+
+		priv->rx_ring[q] = dma_alloc_coherent(ndev->dev.parent, ring_size,
+						      &priv->rx_desc_dma[q],
+						      GFP_KERNEL);
+		if (!priv->rx_ring[q])
+			goto error;
+	}
 
 	priv->dirty_rx[q] = 0;
 
@@ -414,6 +503,45 @@ static int ravb_ring_init(struct net_device *ndev, int q)
 }
 
 /* E-MAC init function */
+static void rgeth_emac_init_ex(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	/* Receive frame limit set register */
+	ravb_write(ndev, RGETH_RCV_BUFF_MAX + ETH_FCS_LEN, RFLR);
+
+	/* PAUSE prohibition */
+	ravb_write(ndev, ECMR_ZPF | (priv->duplex ? ECMR_DM : 0) |
+			 ECMR_TE | ECMR_RE | CXR20_RCPT |
+			 ECMR_TXF | ECMR_RXF | ECMR_PRM, ECMR);
+
+	rgeth_set_rate(ndev);
+
+	/* Set MAC address */
+	ravb_write(ndev,
+		   (ndev->dev_addr[0] << 24) | (ndev->dev_addr[1] << 16) |
+		   (ndev->dev_addr[2] << 8)  | (ndev->dev_addr[3]), MAHR);
+	ravb_write(ndev,
+		   (ndev->dev_addr[4] << 8)  | (ndev->dev_addr[5]), MALR);
+
+	/* E-MAC status register clear */
+	ravb_write(ndev, ECSR_ICD | ECSR_LCHNG | ECSR_RFRI, ECSR);
+	ravb_write(ndev, CSR0_TPE | CSR0_RPE, CSR0);
+
+	/* E-MAC interrupt enable register */
+	ravb_write(ndev, ECSIPR_ICDIP, ECSIPR);
+
+	ravb_write(ndev, ravb_read(ndev, CXR31)
+			 & ~CXR31_SEL_LINK1, CXR31);
+	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID) {
+		ravb_write(ndev, ravb_read(ndev, CXR31)
+			 | CXR31_SEL_LINK0, CXR31);
+	} else {
+		ravb_write(ndev, ravb_read(ndev, CXR31)
+			 & ~CXR31_SEL_LINK0, CXR31);
+	}
+}
+
 static void ravb_emac_init_ex(struct net_device *ndev)
 {
 	/* Receive frame limit set register */
@@ -442,10 +570,41 @@ static void ravb_emac_init_ex(struct net_device *ndev)
 
 static void ravb_emac_init(struct net_device *ndev)
 {
-	ravb_emac_init_ex(ndev);
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	if (priv->chip_id == RZ_G2L)
+		rgeth_emac_init_ex(ndev);
+	else
+		ravb_emac_init_ex(ndev);
+
 }
 
 /* Device init function for Ethernet AVB */
+static void rgeth_dmac_init_ex(struct net_device *ndev)
+{
+	/* Set AVB RX */
+	ravb_write(ndev, 0x60000000, RCR);
+
+	/* Set Max Frame Length (RTC) */
+	ravb_write(ndev, 0x7ffc0000 | RGETH_RCV_BUFF_MAX, RTC);
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
@@ -479,6 +638,7 @@ static void ravb_dmac_init_ex(struct net_device *ndev)
 
 static int ravb_dmac_init(struct net_device *ndev)
 {
+	struct ravb_private *priv = netdev_priv(ndev);
 	int error;
 
 	/* Set CONFIG mode */
@@ -499,7 +659,10 @@ static int ravb_dmac_init(struct net_device *ndev)
 	ravb_ring_format(ndev, RAVB_BE);
 	ravb_ring_format(ndev, RAVB_NC);
 
-	ravb_dmac_init_ex(ndev);
+	if (priv->chip_id == RZ_G2L)
+		rgeth_dmac_init_ex(ndev);
+	else
+		ravb_dmac_init_ex(ndev);
 
 	/* Setting the control will start the AVB-DMAC process. */
 	ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_OPERATION);
@@ -545,6 +708,23 @@ static void ravb_get_tx_tstamp(struct net_device *ndev)
 	}
 }
 
+static void rgeth_rx_csum(struct sk_buff *skb)
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
@@ -561,6 +741,143 @@ static void ravb_rx_csum(struct sk_buff *skb)
 }
 
 /* Packet receive function for Ethernet AVB */
+struct sk_buff *rgeth_get_skb(struct net_device *ndev,  int q, int entry,
+			      struct ravb_rx_desc *desc)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	struct sk_buff *skb;
+
+	skb = priv->rx_skb[q][entry];
+	priv->rx_skb[q][entry] = NULL;
+	dma_unmap_single(ndev->dev.parent, le32_to_cpu(desc->dptr),
+			 ALIGN(RGETH_RCV_BUFF_MAX, 16), DMA_FROM_DEVICE);
+
+	return skb;
+}
+
+static bool rgeth_rx_ex(struct net_device *ndev, int *quota, int q)
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
+			if (die_dt == DT_FSINGLE) {
+				skb = rgeth_get_skb(ndev, q, entry, desc);
+				skb_put(skb, pkt_len);
+				skb->protocol = eth_type_trans(skb, ndev);
+				if (ndev->features & NETIF_F_RXCSUM)
+					rgeth_rx_csum(skb);
+				napi_gro_receive(&priv->napi[q], skb);
+				stats->rx_packets++;
+				stats->rx_bytes += pkt_len;
+			} else if (die_dt == DT_FSTART) {
+				priv->rxtop_skb = rgeth_get_skb(ndev, q, entry, desc);
+				skb_put(priv->rxtop_skb, pkt_len);
+			} else if (die_dt == DT_FMID) {
+				skb = rgeth_get_skb(ndev, q, entry, desc);
+				skb_copy_to_linear_data_offset(priv->rxtop_skb,
+							       priv->rxtop_skb->len,
+							       skb->data,
+							       pkt_len);
+				skb_put(priv->rxtop_skb, pkt_len);
+				dev_kfree_skb(skb);
+			} else if (die_dt == DT_FEND) {
+				skb = rgeth_get_skb(ndev, q, entry, desc);
+				skb_copy_to_linear_data_offset(priv->rxtop_skb,
+							       priv->rxtop_skb->len,
+							       skb->data,
+							       pkt_len);
+				skb_put(priv->rxtop_skb, pkt_len);
+				dev_kfree_skb(skb);
+				priv->rxtop_skb->protocol =
+					eth_type_trans(priv->rxtop_skb, ndev);
+				if (ndev->features & NETIF_F_RXCSUM)
+					rgeth_rx_csum(skb);
+				napi_gro_receive(&priv->napi[q],
+						 priv->rxtop_skb);
+				stats->rx_packets++;
+				stats->rx_bytes += priv->rxtop_skb->len;
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
+		desc->ds_cc = cpu_to_le16(RGETH_RCV_DESCRIPTOR_DATA_SIZE);
+
+		if (!priv->rx_skb[q][entry]) {
+			skb = netdev_alloc_skb(ndev,
+					       RGETH_RCV_BUFF_MAX + RAVB_ALIGN - 1);
+			if (!skb)
+				break;  /* Better luck next round. */
+			ravb_set_buffer_align(skb);
+			dma_addr = dma_map_single(ndev->dev.parent,
+						  skb->data,
+						  le16_to_cpu(RGETH_RCV_BUFF_MAX),
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
 static bool ravb_rx_ex(struct net_device *ndev, int *quota, int q)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
@@ -678,7 +995,10 @@ static bool ravb_rx_ex(struct net_device *ndev, int *quota, int q)
 
 static bool ravb_rx(struct net_device *ndev, int *quota, int q)
 {
-	return ravb_rx_ex(ndev, quota, q);
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	return (priv->chip_id == RZ_G2L) ?
+		rgeth_rx_ex(ndev, quota, q) : ravb_rx_ex(ndev, quota, q);
 }
 
 static void ravb_rcv_snd_disable(struct net_device *ndev)
@@ -696,11 +1016,15 @@ static void ravb_rcv_snd_enable(struct net_device *ndev)
 /* function for waiting dma process finished */
 static int ravb_stop_dma(struct net_device *ndev)
 {
+	struct ravb_private *priv = netdev_priv(ndev);
 	int error;
 
 	/* Wait for stopping the hardware TX process */
-	error = ravb_wait(ndev, TCCR,
-			  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
+	if (priv->chip_id == RZ_G2L)
+		error = ravb_wait(ndev, TCCR, TCCR_TSRQ0, 0);
+	else
+		error = ravb_wait(ndev, TCCR,
+				  TCCR_TSRQ0 | TCCR_TSRQ1 | TCCR_TSRQ2 | TCCR_TSRQ3, 0);
 	if (error)
 		return error;
 
@@ -730,7 +1054,7 @@ static void ravb_emac_interrupt_unlocked(struct net_device *ndev)
 	ecsr = ravb_read(ndev, ECSR);
 	ravb_write(ndev, ecsr, ECSR);	/* clear interrupt */
 
-	if (ecsr & ECSR_MPD)
+	if (priv->chip_id != RZ_G2L && (ecsr & ECSR_MPD))
 		pm_wakeup_event(&priv->pdev->dev, 0);
 	if (ecsr & ECSR_ICD)
 		ndev->stats.tx_carrier_errors++;
@@ -823,11 +1147,13 @@ static bool ravb_queue_interrupt(struct net_device *ndev, int q)
 
 static bool ravb_timestamp_interrupt(struct net_device *ndev)
 {
+	struct ravb_private *priv = netdev_priv(ndev);
 	u32 tis = ravb_read(ndev, TIS);
 
 	if (tis & TIS_TFUF) {
 		ravb_write(ndev, ~(TIS_TFUF | TIS_RESERVED), TIS);
-		ravb_get_tx_tstamp(ndev);
+		if (priv->chip_id != RZ_G2L)
+			ravb_get_tx_tstamp(ndev);
 		return true;
 	}
 	return false;
@@ -872,7 +1198,7 @@ static irqreturn_t ravb_interrupt(int irq, void *dev_id)
 	}
 
 	/* gPTP interrupt status summary */
-	if (iss & ISS_CGIS) {
+	if (priv->chip_id != RZ_G2L && (iss & ISS_CGIS)) {
 		ravb_ptp_interrupt(ndev);
 		result = IRQ_HANDLED;
 	}
@@ -947,12 +1273,20 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	int q = napi - priv->napi;
 	int mask = BIT(q);
 	int quota = budget;
+	int entry;
+	struct ravb_rx_desc *desc;
 
+	if (priv->chip_id == RZ_G2L) {
+		entry = priv->cur_rx[q] % priv->num_rx_ring[q];
+		desc = &priv->rgeth_rx_ring[q][entry];
+	}
 	/* Processing RX Descriptor Ring */
 	/* Clear RX interrupt */
 	ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
-	if (ravb_rx(ndev, &quota, q))
-		goto out;
+	if (priv->chip_id != RZ_G2L || desc->die_dt != DT_FEMPTY) {
+		if (ravb_rx(ndev, &quota, q))
+			goto out;
+	}
 
 	/* Processing TX Descriptor Ring */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -986,6 +1320,18 @@ static int ravb_poll(struct napi_struct *napi, int budget)
 	return budget - quota;
 }
 
+static void rgeth_set_duplex(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	u32 ecmr = ravb_read(ndev, ECMR);
+
+	if (priv->duplex)       /* Full */
+		ecmr |=  ECMR_DM;
+	else                    /* Half */
+		ecmr &= ~ECMR_DM;
+	ravb_write(ndev, ecmr, ECMR);
+}
+
 /* PHY state control function */
 static void ravb_adjust_link(struct net_device *ndev)
 {
@@ -1001,10 +1347,19 @@ static void ravb_adjust_link(struct net_device *ndev)
 		ravb_rcv_snd_disable(ndev);
 
 	if (phydev->link) {
+		if (priv->chip_id == RZ_G2L && phydev->duplex != priv->duplex) {
+			new_state = true;
+			priv->duplex = phydev->duplex;
+			rgeth_set_duplex(ndev);
+		}
+
 		if (phydev->speed != priv->speed) {
 			new_state = true;
 			priv->speed = phydev->speed;
-			ravb_set_rate(ndev);
+			if (priv->chip_id == RZ_G2L)
+				rgeth_set_rate(ndev);
+			else
+				ravb_set_rate(ndev);
 		}
 		if (!priv->link) {
 			ravb_modify(ndev, ECMR, ECMR_TXF, 0);
@@ -1015,6 +1370,8 @@ static void ravb_adjust_link(struct net_device *ndev)
 		new_state = true;
 		priv->link = 0;
 		priv->speed = 0;
+		if (priv->chip_id == RZ_G2L)
+			priv->duplex = -1;
 	}
 
 	/* Enable TX and RX right over here, if E-MAC change is ignored */
@@ -1044,6 +1401,7 @@ static int ravb_phy_init(struct net_device *ndev)
 
 	priv->link = 0;
 	priv->speed = 0;
+	priv->duplex = -1;
 
 	/* Try connecting to PHY */
 	pn = of_parse_phandle(np, "phy-handle", 0);
@@ -1082,15 +1440,23 @@ static int ravb_phy_init(struct net_device *ndev)
 		netdev_info(ndev, "limited PHY to 100Mbit/s\n");
 	}
 
-	/* 10BASE, Pause and Asym Pause is not supported */
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Pause_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
+	if (priv->chip_id == RZ_G2L) {
+		if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID)
+			ravb_write(ndev, ravb_read(ndev, CXR35) | CXR35_SEL_MODIN, CXR35);
+		else if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII)
+			ravb_write(ndev, 0x3E80000, CXR35);
+	} else {
 
-	/* Half Duplex is not supported */
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
-	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+		/* 10BASE, Pause and Asym Pause is not supported */
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Half_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_10baseT_Full_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Pause_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_Asym_Pause_BIT);
+
+		/* Half Duplex is not supported */
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
+		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
+	}
 
 	phy_attached_info(phydev);
 
@@ -1133,6 +1499,24 @@ static void ravb_set_msglevel(struct net_device *ndev, u32 value)
 	priv->msg_enable = value;
 }
 
+static const char rgeth_gstrings_stats[][ETH_GSTRING_LEN] = {
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
@@ -1168,12 +1552,15 @@ static const char ravb_gstrings_stats[][ETH_GSTRING_LEN] = {
 };
 
 #define RAVB_STATS_LEN	ARRAY_SIZE(ravb_gstrings_stats)
+#define RGETH_STATS_LEN	ARRAY_SIZE(rgeth_gstrings_stats)
 
 static int ravb_get_sset_count(struct net_device *netdev, int sset)
 {
+	struct ravb_private *priv = netdev_priv(netdev);
+
 	switch (sset) {
 	case ETH_SS_STATS:
-		return RAVB_STATS_LEN;
+		return (priv->chip_id == RZ_G2L) ? RGETH_STATS_LEN : RAVB_STATS_LEN;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1183,7 +1570,7 @@ static void ravb_get_ethtool_stats(struct net_device *ndev,
 				   struct ethtool_stats *estats, u64 *data)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
-	int num_queue = NUM_RX_QUEUE;
+	int num_queue = (priv->chip_id == RZ_G2L) ? 1 : NUM_RX_QUEUE;
 	int i = 0;
 	int q;
 
@@ -1211,9 +1598,14 @@ static void ravb_get_ethtool_stats(struct net_device *ndev,
 
 static void ravb_get_strings(struct net_device *ndev, u32 stringset, u8 *data)
 {
+	struct ravb_private *priv = netdev_priv(ndev);
+
 	switch (stringset) {
 	case ETH_SS_STATS:
-		memcpy(data, ravb_gstrings_stats, sizeof(ravb_gstrings_stats));
+		if (priv->chip_id == RZ_G2L)
+			memcpy(data, rgeth_gstrings_stats, sizeof(rgeth_gstrings_stats));
+		else
+			memcpy(data, ravb_gstrings_stats, sizeof(ravb_gstrings_stats));
 		break;
 	}
 }
@@ -1304,7 +1696,8 @@ static int ravb_get_ts_info(struct net_device *ndev,
 		(1 << HWTSTAMP_FILTER_NONE) |
 		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
 		(1 << HWTSTAMP_FILTER_ALL);
-	info->phc_index = ptp_clock_index(priv->ptp.clock);
+	if (priv->chip_id != RZ_G2L)
+		info->phc_index = ptp_clock_index(priv->ptp.clock);
 
 	return 0;
 }
@@ -1348,6 +1741,21 @@ static const struct ethtool_ops ravb_ethtool_ops = {
 	.set_wol		= ravb_set_wol,
 };
 
+static const struct ethtool_ops rgeth_ethtool_ops = {
+	.nway_reset		= phy_ethtool_nway_reset,
+	.get_msglevel		= ravb_get_msglevel,
+	.set_msglevel		= ravb_set_msglevel,
+	.get_link		= ethtool_op_get_link,
+	.get_strings		= ravb_get_strings,
+	.get_ethtool_stats	= ravb_get_ethtool_stats,
+	.get_sset_count		= ravb_get_sset_count,
+	.get_ringparam		= ravb_get_ringparam,
+	.set_ringparam		= ravb_set_ringparam,
+	.get_ts_info		= ravb_get_ts_info,
+	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+};
+
 static inline int ravb_hook_irq(unsigned int irq, irq_handler_t handler,
 				struct net_device *ndev, struct device *dev,
 				const char *ch)
@@ -1599,28 +2007,30 @@ static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	desc->dptr = cpu_to_le32(dma_addr);
 
 	/* TX timestamp required */
-	if (q == RAVB_NC) {
-		ts_skb = kmalloc(sizeof(*ts_skb), GFP_ATOMIC);
-		if (!ts_skb) {
-			if (num_tx_desc > 1) {
-				desc--;
-				dma_unmap_single(ndev->dev.parent, dma_addr,
-						 len, DMA_TO_DEVICE);
+	if (priv->chip_id != RZ_G2L) {
+		if (q == RAVB_NC) {
+			ts_skb = kmalloc(sizeof(*ts_skb), GFP_ATOMIC);
+			if (!ts_skb) {
+				if (num_tx_desc > 1) {
+					desc--;
+					dma_unmap_single(ndev->dev.parent, dma_addr,
+							 len, DMA_TO_DEVICE);
+				}
+				goto unmap;
 			}
-			goto unmap;
+			ts_skb->skb = skb_get(skb);
+			ts_skb->tag = priv->ts_skb_tag++;
+			priv->ts_skb_tag &= 0x3ff;
+			list_add_tail(&ts_skb->list, &priv->ts_skb_list);
+
+			/* TAG and timestamp required flag */
+			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+			desc->tagh_tsr = (ts_skb->tag >> 4) | TX_TSR;
+			desc->ds_tagl |= cpu_to_le16(ts_skb->tag << 12);
 		}
-		ts_skb->skb = skb_get(skb);
-		ts_skb->tag = priv->ts_skb_tag++;
-		priv->ts_skb_tag &= 0x3ff;
-		list_add_tail(&ts_skb->list, &priv->ts_skb_list);
 
-		/* TAG and timestamp required flag */
-		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-		desc->tagh_tsr = (ts_skb->tag >> 4) | TX_TSR;
-		desc->ds_tagl |= cpu_to_le16(ts_skb->tag << 12);
+		skb_tx_timestamp(skb);
 	}
-
-	skb_tx_timestamp(skb);
 	/* Descriptor type must be set after all the above writes */
 	dma_wmb();
 	if (num_tx_desc > 1) {
@@ -1669,6 +2079,20 @@ static struct net_device_stats *ravb_get_stats(struct net_device *ndev)
 	stats0 = &priv->stats[RAVB_BE];
 	stats1 = &priv->stats[RAVB_NC];
 
+	if (priv->chip_id == RZ_G2L) {
+		nstats->tx_dropped += ravb_read(ndev, TROCR);
+		ravb_write(ndev, 0, TROCR);	/* (write clear) */
+		nstats->collisions += ravb_read(ndev, CDCR);
+		ravb_write(ndev, 0, CDCR);	/* (write clear) */
+		nstats->tx_carrier_errors += ravb_read(ndev, LCCR);
+		ravb_write(ndev, 0, LCCR);	/* (write clear) */
+
+		nstats->tx_carrier_errors += ravb_read(ndev, CERCR);
+		ravb_write(ndev, 0, CERCR);	/* (write clear) */
+		nstats->tx_carrier_errors += ravb_read(ndev, CEECR);
+		ravb_write(ndev, 0, CEECR);	/* (write clear) */
+	}
+
 	if (priv->chip_id == RCAR_GEN3) {
 		nstats->tx_dropped += ravb_read(ndev, TROCR);
 		ravb_write(ndev, 0, TROCR);	/* (write clear) */
@@ -1729,10 +2153,12 @@ static int ravb_close(struct net_device *ndev)
 			   "device will be stopped after h/w processes are done.\n");
 
 	/* Clear the timestamp list */
-	list_for_each_entry_safe(ts_skb, ts_skb2, &priv->ts_skb_list, list) {
-		list_del(&ts_skb->list);
-		kfree_skb(ts_skb->skb);
-		kfree(ts_skb);
+	if (priv->chip_id != RZ_G2L) {
+		list_for_each_entry_safe(ts_skb, ts_skb2, &priv->ts_skb_list, list) {
+			list_del(&ts_skb->list);
+			kfree_skb(ts_skb->skb);
+			kfree(ts_skb);
+		}
 	}
 
 	/* PHY disconnect */
@@ -1899,6 +2325,44 @@ static int ravb_set_features(struct net_device *ndev,
 	return 0;
 }
 
+static int rgeth_set_features(struct net_device *ndev,
+			      netdev_features_t features)
+{
+	int error;
+	unsigned int reg = 0;
+	netdev_features_t changed = features ^ ndev->features;
+
+	reg = ravb_read(ndev, CSR0);
+
+	ravb_write(ndev, ravb_read(ndev, CSR0) & ~(CSR0_RPE | CSR0_TPE), CSR0);
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
 static const struct net_device_ops ravb_netdev_ops = {
 	.ndo_open		= ravb_open,
 	.ndo_stop		= ravb_close,
@@ -1914,6 +2378,20 @@ static const struct net_device_ops ravb_netdev_ops = {
 	.ndo_set_features	= ravb_set_features,
 };
 
+static const struct net_device_ops rgeth_netdev_ops = {
+	.ndo_open               = ravb_open,
+	.ndo_stop               = ravb_close,
+	.ndo_start_xmit         = ravb_start_xmit,
+	.ndo_select_queue       = ravb_select_queue,
+	.ndo_get_stats          = ravb_get_stats,
+	.ndo_set_rx_mode        = ravb_set_rx_mode,
+	.ndo_tx_timeout         = ravb_tx_timeout,
+	.ndo_do_ioctl           = ravb_do_ioctl,
+	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_set_mac_address    = eth_mac_addr,
+	.ndo_set_features       = rgeth_set_features,
+};
+
 /* MDIO bus init function */
 static int ravb_mdio_init(struct ravb_private *priv)
 {
@@ -1930,7 +2408,10 @@ static int ravb_mdio_init(struct ravb_private *priv)
 		return -ENOMEM;
 
 	/* Hook up MII support for ethtool */
-	priv->mii_bus->name = "ravb_mii";
+	if (priv->chip_id == RZ_G2L)
+		priv->mii_bus->name = "rgeth_mii";
+	else
+		priv->mii_bus->name = "ravb_mii";
 	priv->mii_bus->parent = dev;
 	snprintf(priv->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
 		 pdev->name, pdev->id);
@@ -1965,6 +2446,7 @@ static const struct of_device_id ravb_match_table[] = {
 	{ .compatible = "renesas,etheravb-rcar-gen2", .data = (void *)RCAR_GEN2 },
 	{ .compatible = "renesas,etheravb-r8a7795", .data = (void *)RCAR_GEN3 },
 	{ .compatible = "renesas,etheravb-rcar-gen3", .data = (void *)RCAR_GEN3 },
+	{ .compatible = "renesas,rzg2l-gether", .data = (void *)RZ_G2L },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ravb_match_table);
@@ -2001,7 +2483,8 @@ static void ravb_set_config_mode(struct net_device *ndev)
 	if (priv->chip_id != RCAR_GEN3) {
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG);
 		/* Set CSEL value */
-		ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
+		if (priv->chip_id == RCAR_GEN2)
+			ravb_modify(ndev, CCC, CCC_CSEL, CCC_CSEL_HPB);
 	} else {
 		ravb_modify(ndev, CCC, CCC_OPC, CCC_OPC_CONFIG |
 			    CCC_GAC | CCC_CSEL_HPB);
@@ -2082,20 +2565,11 @@ static int ravb_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	/* Get base address */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "invalid resource\n");
-		return -EINVAL;
-	}
-
 	ndev = alloc_etherdev_mqs(sizeof(struct ravb_private),
 				  NUM_TX_QUEUE, NUM_RX_QUEUE);
 	if (!ndev)
 		return -ENOMEM;
 
-	/* The Ether-specific entries in the device structure. */
-	ndev->base_addr = res->start;
 
 	chip_id = (enum ravb_chip_id)of_device_get_match_data(&pdev->dev);
 
@@ -2104,11 +2578,19 @@ static int ravb_probe(struct platform_device *pdev)
 	priv = netdev_priv(ndev);
 	priv->chip_id = chip_id;
 
-	ndev->features = NETIF_F_RXCSUM;
-	ndev->hw_features = NETIF_F_RXCSUM;
-
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
+	if (chip_id == RZ_G2L) {
+		ndev->hw_features |= (NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
+		priv->rstc = devm_reset_control_get(&pdev->dev, NULL);
+		if (IS_ERR(priv->rstc)) {
+			dev_err(&pdev->dev, "failed to get cpg reset\n");
+			free_netdev(ndev);
+			return PTR_ERR(priv->rstc);
+		}
+		reset_control_deassert(priv->rstc);
+	} else {
+		ndev->features = NETIF_F_RXCSUM;
+		ndev->hw_features = NETIF_F_RXCSUM;
+	}
 
 	if (chip_id == RCAR_GEN3)
 		irq = platform_get_irq_byname(pdev, "ch22");
@@ -2120,18 +2602,24 @@ static int ravb_probe(struct platform_device *pdev)
 	}
 	ndev->irq = irq;
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
+
 	priv->ndev = ndev;
 	priv->pdev = pdev;
 	priv->num_tx_ring[RAVB_BE] = BE_TX_RING_SIZE;
 	priv->num_rx_ring[RAVB_BE] = BE_RX_RING_SIZE;
 	priv->num_tx_ring[RAVB_NC] = NC_TX_RING_SIZE;
 	priv->num_rx_ring[RAVB_NC] = NC_RX_RING_SIZE;
-	priv->addr = devm_ioremap_resource(&pdev->dev, res);
+	priv->addr = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(priv->addr)) {
 		error = PTR_ERR(priv->addr);
 		goto out_release;
 	}
 
+	/* The Ether-specific entries in the device structure. */
+	ndev->base_addr = res->start;
+
 	spin_lock_init(&priv->lock);
 	INIT_WORK(&priv->work, ravb_tx_timeout_work);
 
@@ -2168,6 +2656,8 @@ static int ravb_probe(struct platform_device *pdev)
 		}
 	}
 
+	priv->chip_id = chip_id;
+
 	priv->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(priv->clk)) {
 		error = PTR_ERR(priv->clk);
@@ -2181,30 +2671,39 @@ static int ravb_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(priv->refclk);
 
-	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
-	ndev->min_mtu = ETH_MIN_MTU;
+	if (chip_id != RZ_G2L) {
+		ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
+		ndev->min_mtu = ETH_MIN_MTU;
+	}
 
 	priv->num_tx_desc = chip_id == RCAR_GEN3 ?
 		NUM_TX_DESC_GEN3 : NUM_TX_DESC_GEN2;
 
 	/* Set function */
-	ndev->netdev_ops = &ravb_netdev_ops;
-	ndev->ethtool_ops = &ravb_ethtool_ops;
+	if  (chip_id == RZ_G2L) {
+		ndev->netdev_ops = &rgeth_netdev_ops;
+		ndev->ethtool_ops = &rgeth_ethtool_ops;
+	} else {
+		ndev->netdev_ops = &ravb_netdev_ops;
+		ndev->ethtool_ops = &ravb_ethtool_ops;
+	}
 
 	/* Set AVB config mode */
 	ravb_set_config_mode(ndev);
 
-	/* Set GTI value */
-	error = ravb_set_gti(ndev);
-	if (error)
-		goto out_disable_refclk;
+	if (priv->chip_id != RZ_G2L) {
+		/* Set GTI value */
+		error = ravb_set_gti(ndev);
+		if (error)
+			goto out_disable_refclk;
 
-	/* Request GTI loading */
-	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+		/* Request GTI loading */
+		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
 
-	if (priv->chip_id == RCAR_GEN3) {
-		ravb_parse_delay_mode(np, ndev);
-		ravb_set_delay_mode(ndev);
+		if (priv->chip_id == RCAR_GEN3) {
+			ravb_parse_delay_mode(np, ndev);
+			ravb_set_delay_mode(ndev);
+		}
 	}
 
 	/* Allocate descriptor base address table */
@@ -2389,13 +2888,15 @@ static int __maybe_unused ravb_resume(struct device *dev)
 	/* Set AVB config mode */
 	ravb_set_config_mode(ndev);
 
-	/* Set GTI value */
-	ret = ravb_set_gti(ndev);
-	if (ret)
-		return ret;
+	if (priv->chip_id != RZ_G2L) {
+		/* Set GTI value */
+		ret = ravb_set_gti(ndev);
+		if (ret)
+			return ret;
 
-	/* Request GTI loading */
-	ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+		/* Request GTI loading */
+		ravb_modify(ndev, GCCR, GCCR_LTI, GCCR_LTI);
+	}
 
 	if (priv->chip_id == RCAR_GEN3)
 		ravb_set_delay_mode(ndev);
-- 
2.17.1

