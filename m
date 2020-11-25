Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7572C4BA2
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 00:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732940AbgKYXZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 18:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731723AbgKYXZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 18:25:54 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E54C0617A7;
        Wed, 25 Nov 2020 15:25:54 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4ChH7h3WTQz1rwbQ;
        Thu, 26 Nov 2020 00:25:52 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4ChH7h1yxCz1vdfr;
        Thu, 26 Nov 2020 00:25:52 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 0tq-JewcryuK; Thu, 26 Nov 2020 00:25:49 +0100 (CET)
X-Auth-Info: tqwjHQgo7y6AUtrE4M0Yu1GOtBSUxuquCxt9UU6FS3o=
Received: from localhost.localdomain (89-64-5-98.dynamic.chello.pl [89.64.5.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 26 Nov 2020 00:25:48 +0100 (CET)
From:   Lukasz Majewski <lukma@denx.de>
To:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Lukasz Majewski <lukma@denx.de>
Subject: [RFC 3/4] net: imx: l2switch: Adjust fec_main.c to provide support for L2 switch
Date:   Thu, 26 Nov 2020 00:24:58 +0100
Message-Id: <20201125232459.378-4-lukma@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201125232459.378-1-lukma@denx.de>
References: <20201125232459.378-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides the code for re-using generic FEC i.MX code for L2
switch.

The trick here is to set eth0 controller as a "fixed-link" and then use
DSA subsystem to create lan{12} network devices for ports. The internal
connection diagram can be found here [0].

This code has been developed on i.MX287 device, but L2 switch (from More
ThanIP) can be also found on e.g. NXP's Vybrid VF610 SoC.

To reuse as much code as possible it was also necessary to introduce
fec_hwp() wrapper, which either returns pointer to MAC or L2 switch
interrupt and buffer descriptors.
Following registers shall be used with it:
FEC_{IEVENT|IMASK}, FEC_R_DES_ACTIVE_0, FEC_X_DES_ACTIVE_0,
FEC_R_DES_START_0, FEC_X_DES_START_0

The biggest issue was to divide the legacy driver's code (from 2.6.35 [1])
between contemporary kernel FEC driver and DSA subsystem [2].

Only the code for setting up interrupts is protected by
#ifdef CONFIG_NET_DSA_MTIP_L2SW

In other cases the fep->l2switch flag is checked (and the code is compiled
into the driver) as there are only a few alterations (i.e. readl/writel)
to the generic FEC code.

The most intrusive changes when L2 switch is used:
- FEC clock enabled
It is necessary to allow DSA normal operation (it shall be enabled as
long as L2 switch is used)

- Disable RACC (Receive Data Accelerator)
When this feature is enabled the data is shifted by 16 bits and
hence received packets are malformed when we try to pass data from one
switch port to another.

- Enable PROMISC mode for ENET-MAC{01} ports

- L2 switch shall pass the whole pkt_len packet. Current FEC code
subtract 4 to remove FCS

Links:
[0] - Chapter 29.3.1 in
"i.MX28 Applications Processor Reference Manual, Rev. 2, 08/2013"
[1]
From 2.6 i.MX kernel:
Repo: git://git.freescale.com/imx/linux-2.6-imx.git
Branch: imx_2.6.35_maintain
SHA1: b3912bb8a4caf3ec50909135e88af959982c43ca

[2] - https://github.com/lmajewski/linux-imx28-l2switch/commits/master

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 drivers/net/ethernet/freescale/fec.h      |  39 ++++++
 drivers/net/ethernet/freescale/fec_main.c | 145 +++++++++++++++++++---
 2 files changed, 166 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index c555a421f647..acca7cbf9e6b 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -29,8 +29,13 @@
  */
 #define FEC_IEVENT		0x004 /* Interrupt event reg */
 #define FEC_IMASK		0x008 /* Interrupt mask reg */
+#ifdef CONFIG_NET_DSA_MTIP_L2SW
+#define FEC_R_DES_ACTIVE_0	0x018 /* L2 switch Receive descriptor reg */
+#define FEC_X_DES_ACTIVE_0	0x01C /* L2 switch Transmit descriptor reg */
+#else
 #define FEC_R_DES_ACTIVE_0	0x010 /* Receive descriptor reg */
 #define FEC_X_DES_ACTIVE_0	0x014 /* Transmit descriptor reg */
+#endif
 #define FEC_ECNTRL		0x024 /* Ethernet control reg */
 #define FEC_MII_DATA		0x040 /* MII manage frame reg */
 #define FEC_MII_SPEED		0x044 /* MII speed control reg */
@@ -59,8 +64,13 @@
 #define FEC_R_DES_START_2	0x16c /* Receive descriptor ring 2 */
 #define FEC_X_DES_START_2	0x170 /* Transmit descriptor ring 2 */
 #define FEC_R_BUFF_SIZE_2	0x174 /* Maximum receive buff ring2 size */
+#ifdef CONFIG_NET_DSA_MTIP_L2SW
+#define FEC_R_DES_START_0	0x0C /* L2 switch Receive descriptor ring */
+#define FEC_X_DES_START_0	0x10 /* L2 switch Transmit descriptor ring */
+#else
 #define FEC_R_DES_START_0	0x180 /* Receive descriptor ring */
 #define FEC_X_DES_START_0	0x184 /* Transmit descriptor ring */
+#endif
 #define FEC_R_BUFF_SIZE_0	0x188 /* Maximum receive buff size */
 #define FEC_R_FIFO_RSFL		0x190 /* Receive FIFO section full threshold */
 #define FEC_R_FIFO_RSEM		0x194 /* Receive FIFO section empty threshold */
@@ -363,13 +373,25 @@ struct bufdesc_ex {
 #define FEC_ENET_BABR   ((uint)0x40000000)      /* Babbling receiver */
 #define FEC_ENET_BABT   ((uint)0x20000000)      /* Babbling transmitter */
 #define FEC_ENET_GRA    ((uint)0x10000000)      /* Graceful stop complete */
+#ifdef CONFIG_NET_DSA_MTIP_L2SW
+#define FEC_ENET_TXF_0	BIT(4)
+#define FEC_ENET_TXF_1	0
+#define FEC_ENET_TXF_2	0
+#else
 #define FEC_ENET_TXF_0	((uint)0x08000000)	/* Full frame transmitted */
 #define FEC_ENET_TXF_1	((uint)0x00000008)	/* Full frame transmitted */
 #define FEC_ENET_TXF_2	((uint)0x00000080)	/* Full frame transmitted */
+#endif
 #define FEC_ENET_TXB    ((uint)0x04000000)      /* A buffer was transmitted */
+#ifdef CONFIG_NET_DSA_MTIP_L2SW
+#define FEC_ENET_RXF_0	BIT(2)
+#define FEC_ENET_RXF_1	0
+#define FEC_ENET_RXF_2	0
+#else
 #define FEC_ENET_RXF_0	((uint)0x02000000)	/* Full frame received */
 #define FEC_ENET_RXF_1	((uint)0x00000002)	/* Full frame received */
 #define FEC_ENET_RXF_2	((uint)0x00000020)	/* Full frame received */
+#endif
 #define FEC_ENET_RXB    ((uint)0x01000000)      /* A buffer was received */
 #define FEC_ENET_MII    ((uint)0x00800000)      /* MII interrupt */
 #define FEC_ENET_EBERR  ((uint)0x00400000)      /* SDMA bus error */
@@ -380,6 +402,7 @@ struct bufdesc_ex {
 #define FEC_ENET_TS_TIMER       ((uint)0x00008000)
 
 #define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF)
+#define FEC_NAPI_IMASK	FEC_ENET_MII
 #define FEC_RX_DISABLED_IMASK (FEC_DEFAULT_IMASK & (~FEC_ENET_RXF))
 
 /* ENET interrupt coalescing macro define */
@@ -587,9 +610,25 @@ struct fec_enet_private {
 	int pps_enable;
 	unsigned int next_counter;
 
+	/* More Than IP L2 switch */
+	void __iomem *hwpsw;
+	bool l2switch;
+
 	u64 ethtool_stats[];
 };
 
+/* L2 switch */
+#define L2SW_CTRL_REG_OFFSET (0x4)
+/* Get proper base address for either L2 switch or MAC ENET */
+static inline void __iomem *fec_hwp(struct fec_enet_private *fep)
+{
+#ifdef CONFIG_NET_DSA_MTIP_L2SW
+	if (fep->l2switch)
+		return fep->hwpsw;
+#endif
+	return fep->hwp;
+}
+
 void fec_ptp_init(struct platform_device *pdev, int irq_idx);
 void fec_ptp_stop(struct platform_device *pdev);
 void fec_ptp_start_cyclecounter(struct net_device *ndev);
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index bd29c84fd89a..32dbb1d18785 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -65,10 +65,12 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <soc/imx/cpuidle.h>
+#include <net/dsa.h>
 
 #include <asm/cacheflush.h>
 
 #include "fec.h"
+#include "../../dsa/mtip-l2switch.h"
 
 static void set_multicast_list(struct net_device *ndev);
 static void fec_enet_itr_coal_init(struct net_device *ndev);
@@ -103,6 +105,11 @@ static const struct fec_devinfo fec_imx28_info = {
 		  FEC_QUIRK_HAS_FRREG,
 };
 
+static const struct fec_devinfo fec_imx28l2sw_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
+		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_FRREG,
+};
+
 static const struct fec_devinfo fec_imx6q_info = {
 	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
@@ -144,6 +151,9 @@ static struct platform_device_id fec_devtype[] = {
 	}, {
 		.name = "imx28-fec",
 		.driver_data = (kernel_ulong_t)&fec_imx28_info,
+	}, {
+		.name = "imx28-l2switch",
+		.driver_data = (kernel_ulong_t)&fec_imx28l2sw_info,
 	}, {
 		.name = "imx6q-fec",
 		.driver_data = (kernel_ulong_t)&fec_imx6q_info,
@@ -166,6 +176,7 @@ enum imx_fec_type {
 	IMX25_FEC = 1,	/* runs on i.mx25/50/53 */
 	IMX27_FEC,	/* runs on i.mx27/35/51 */
 	IMX28_FEC,
+	IMX28_L2SWITCH,
 	IMX6Q_FEC,
 	MVF600_FEC,
 	IMX6SX_FEC,
@@ -176,6 +187,8 @@ static const struct of_device_id fec_dt_ids[] = {
 	{ .compatible = "fsl,imx25-fec", .data = &fec_devtype[IMX25_FEC], },
 	{ .compatible = "fsl,imx27-fec", .data = &fec_devtype[IMX27_FEC], },
 	{ .compatible = "fsl,imx28-fec", .data = &fec_devtype[IMX28_FEC], },
+	{ .compatible = "fsl,imx28-l2switch",
+	  .data = &fec_devtype[IMX28_L2SWITCH], },
 	{ .compatible = "fsl,imx6q-fec", .data = &fec_devtype[IMX6Q_FEC], },
 	{ .compatible = "fsl,mvf600-fec", .data = &fec_devtype[MVF600_FEC], },
 	{ .compatible = "fsl,imx6sx-fec", .data = &fec_devtype[IMX6SX_FEC], },
@@ -893,7 +906,7 @@ static void fec_enet_enable_ring(struct net_device *ndev)
 
 	for (i = 0; i < fep->num_rx_queues; i++) {
 		rxq = fep->rx_queue[i];
-		writel(rxq->bd.dma, fep->hwp + FEC_R_DES_START(i));
+		writel(rxq->bd.dma, fec_hwp(fep) + FEC_R_DES_START(i));
 		writel(PKT_MAXBUF_SIZE, fep->hwp + FEC_R_BUFF_SIZE(i));
 
 		/* enable DMA1/2 */
@@ -904,7 +917,7 @@ static void fec_enet_enable_ring(struct net_device *ndev)
 
 	for (i = 0; i < fep->num_tx_queues; i++) {
 		txq = fep->tx_queue[i];
-		writel(txq->bd.dma, fep->hwp + FEC_X_DES_START(i));
+		writel(txq->bd.dma, fec_hwp(fep) + FEC_X_DES_START(i));
 
 		/* enable DMA1/2 */
 		if (i)
@@ -1078,6 +1091,29 @@ fec_restart(struct net_device *ndev)
 	}
 #endif /* !defined(CONFIG_M5272) */
 
+	if (fep->l2switch) {
+		/*
+		 * Set PROMISC mode for MAC0/1 - it is necessary for L2 switch
+		 * correct operation.
+		 */
+		rcntl |= MCF_FEC_RCR_PROM;
+
+		/*
+		 * In fec_restart, the FEC_R_CNTRL register is only configured
+		 * for MAC0 controller (when 'mac1' DTS node is NOT enabled).
+		 *
+		 * For L2 switch we configure only one DTS node - 'eth_switch'
+		 * so the same value shall be written to MAC1 corresponding
+		 * register.
+		 *
+		 * The port configuration is finished in the DSA's 'link_adjust'
+		 * callback - which also modifies FEC_R_CNTRL register to set
+		 * proper link speed.
+		 */
+		writel(rcntl,
+		       fep->hwp + ENET_L2_SW_PORT1_OFFSET + FEC_R_CNTRL);
+	}
+
 	writel(rcntl, fep->hwp + FEC_R_CNTRL);
 
 	/* Setup multicast filter. */
@@ -1109,8 +1145,12 @@ fec_restart(struct net_device *ndev)
 	if (fep->bufdesc_ex)
 		fec_ptp_start_cyclecounter(ndev);
 
-	/* Enable interrupts we wish to service */
-	if (fep->link)
+	/*
+	 * Enable interrupts we wish to service - for L2 switch only
+	 * MII interrupts are required for MAC{01} to allow proper
+	 * PHY configuration.
+	 */
+	if (!fep->l2switch && fep->link)
 		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
 	else
 		writel(0, fep->hwp + FEC_IMASK);
@@ -1407,7 +1447,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	unsigned short status;
 	struct  sk_buff *skb_new = NULL;
 	struct  sk_buff *skb;
-	ushort	pkt_len;
+	ushort	pkt_len, l2pl;
 	__u8 *data;
 	int	pkt_received = 0;
 	struct	bufdesc_ex *ebdp = NULL;
@@ -1433,7 +1473,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 			break;
 		pkt_received++;
 
-		writel(FEC_ENET_RXF, fep->hwp + FEC_IEVENT);
+		writel(FEC_ENET_RXF, fec_hwp(fep) + FEC_IEVENT);
 
 		/* Check for errors. */
 		status ^= BD_ENET_RX_LAST;
@@ -1473,7 +1513,16 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		 * include that when passing upstream as it messes up
 		 * bridging applications.
 		 */
-		is_copybreak = fec_enet_copybreak(ndev, &skb, bdp, pkt_len - 4,
+		/*
+		 * When the L2 switch support is enabled the FCS is removed
+		 * by it and hence the pkt_len shall be passed without
+		 * substracting 4 bytes.
+		 */
+		l2pl = pkt_len - 4;
+		if (fep->l2switch)
+			l2pl = pkt_len;
+
+		is_copybreak = fec_enet_copybreak(ndev, &skb, bdp, l2pl,
 						  need_swap);
 		if (!is_copybreak) {
 			skb_new = netdev_alloc_skb(ndev, FEC_ENET_RX_FRSIZE);
@@ -1488,7 +1537,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		}
 
 		prefetch(skb->data - NET_IP_ALIGN);
-		skb_put(skb, pkt_len - 4);
+		skb_put(skb, l2pl);
 		data = skb->data;
 
 		if (!is_copybreak && need_swap)
@@ -1605,12 +1654,12 @@ static bool fec_enet_collect_events(struct fec_enet_private *fep)
 {
 	uint int_events;
 
-	int_events = readl(fep->hwp + FEC_IEVENT);
+	int_events = readl(fec_hwp(fep) + FEC_IEVENT);
 
 	/* Don't clear MDIO events, we poll for those */
 	int_events &= ~FEC_ENET_MII;
 
-	writel(int_events, fep->hwp + FEC_IEVENT);
+	writel(int_events, fec_hwp(fep) + FEC_IEVENT);
 
 	return int_events != 0;
 }
@@ -1635,6 +1684,27 @@ fec_enet_interrupt(int irq, void *dev_id)
 	return ret;
 }
 
+#ifdef CONFIG_NET_DSA_MTIP_L2SW
+static irqreturn_t
+l2switch_interrupt_handler(int irq, void *dev_id)
+{
+	struct net_device *ndev = dev_id;
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	irqreturn_t ret = IRQ_NONE;
+
+	if (fec_enet_collect_events(fep) && fep->link) {
+		ret = IRQ_HANDLED;
+
+		if (napi_schedule_prep(&fep->napi)) {
+			/* Disable NAPI interrupts */
+			writel(0, fep->hwpsw + FEC_IMASK);
+			__napi_schedule(&fep->napi);
+		}
+	}
+	return ret;
+}
+#endif
+
 static int fec_enet_rx_napi(struct napi_struct *napi, int budget)
 {
 	struct net_device *ndev = napi->dev;
@@ -1648,7 +1718,7 @@ static int fec_enet_rx_napi(struct napi_struct *napi, int budget)
 
 	if (done < budget) {
 		napi_complete_done(napi, done);
-		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
+		writel(FEC_DEFAULT_IMASK, fec_hwp(fep) + FEC_IMASK);
 	}
 
 	return done;
@@ -3065,6 +3135,10 @@ static void set_multicast_list(struct net_device *ndev)
 	unsigned char hash;
 	unsigned int hash_high = 0, hash_low = 0;
 
+	/* DSA subsystem will handle multicast/broadcast setup for L2 switch */
+	if (fep->l2switch)
+		return;
+
 	if (ndev->flags & IFF_PROMISC) {
 		tmp = readl(fep->hwp + FEC_R_CNTRL);
 		tmp |= 0x8;
@@ -3279,7 +3353,8 @@ static int fec_enet_init(struct net_device *ndev)
 		rxq->bd.dma = bd_dma;
 		rxq->bd.dsize = dsize;
 		rxq->bd.dsize_log2 = dsize_log2;
-		rxq->bd.reg_desc_active = fep->hwp + offset_des_active_rxq[i];
+		rxq->bd.reg_desc_active =
+			fec_hwp(fep) + offset_des_active_rxq[i];
 		bd_dma += size;
 		cbd_base = (struct bufdesc *)(((void *)cbd_base) + size);
 		rxq->bd.last = (struct bufdesc *)(((void *)cbd_base) - dsize);
@@ -3295,7 +3370,8 @@ static int fec_enet_init(struct net_device *ndev)
 		txq->bd.dma = bd_dma;
 		txq->bd.dsize = dsize;
 		txq->bd.dsize_log2 = dsize_log2;
-		txq->bd.reg_desc_active = fep->hwp + offset_des_active_txq[i];
+		txq->bd.reg_desc_active =
+			fec_hwp(fep) + offset_des_active_txq[i];
 		bd_dma += size;
 		cbd_base = (struct bufdesc *)(((void *)cbd_base) + size);
 		txq->bd.last = (struct bufdesc *)(((void *)cbd_base) - dsize);
@@ -3306,8 +3382,7 @@ static int fec_enet_init(struct net_device *ndev)
 	ndev->watchdog_timeo = TX_TIMEOUT;
 	ndev->netdev_ops = &fec_netdev_ops;
 	ndev->ethtool_ops = &fec_enet_ethtool_ops;
-
-	writel(FEC_RX_DISABLED_IMASK, fep->hwp + FEC_IMASK);
+	writel(FEC_RX_DISABLED_IMASK, fec_hwp(fep) + FEC_IMASK);
 	netif_napi_add(ndev, &fep->napi, fec_enet_rx_napi, NAPI_POLL_WEIGHT);
 
 	if (fep->quirks & FEC_QUIRK_HAS_VLAN)
@@ -3544,6 +3619,23 @@ fec_probe(struct platform_device *pdev)
 	fep->pdev = pdev;
 	fep->dev_id = dev_id++;
 
+	if (of_device_is_compatible(np, "fsl,imx28-l2switch")) {
+		fep->l2switch = true;
+		fep->hwpsw = devm_platform_ioremap_resource(pdev, 1);
+		/*
+		 * MAC{01} interrupt and descriptors registers have 4 bytes
+		 * offset when compared to L2 switch IP block.
+		 *
+		 * When L2 switch is added "between" ENET (eth0) and MAC{01}
+		 * the code for interrupts and setting up descriptors is
+		 * reused.
+		 *
+		 * As for example FEC_IMASK are used also on MAC{01} to
+		 * perform MII transmission it is better to subtract the
+		 * offset from the outset and reuse defines.
+		 */
+		fep->hwpsw -= L2SW_CTRL_REG_OFFSET;
+	}
 	platform_set_drvdata(pdev, ndev);
 
 	if ((of_machine_is_compatible("fsl,imx6q") ||
@@ -3669,8 +3761,16 @@ fec_probe(struct platform_device *pdev)
 			ret = irq;
 			goto failed_irq;
 		}
-		ret = devm_request_irq(&pdev->dev, irq, fec_enet_interrupt,
-				       0, pdev->name, ndev);
+#ifdef CONFIG_NET_DSA_MTIP_L2SW
+		if (fep->l2switch && i == 0)
+			ret = devm_request_irq(&pdev->dev, irq,
+					       l2switch_interrupt_handler,
+					       0, "l2switch", ndev);
+		else
+#endif
+			ret = devm_request_irq(&pdev->dev, irq,
+					       fec_enet_interrupt,
+					       0, pdev->name, ndev);
 		if (ret)
 			goto failed_irq;
 
@@ -3683,7 +3783,16 @@ fec_probe(struct platform_device *pdev)
 
 	/* Carrier starts down, phylib will bring it up */
 	netif_carrier_off(ndev);
-	fec_enet_clk_enable(ndev, false);
+	/*
+	 * For L2 switch proper initialization this clk cannot be disabled,
+	 * as it uses is to access shared MAC registers for proper MDIO
+	 * operation.
+	 *
+	 * DSA switch will also use it afterwards to setup its ports.
+	 */
+	if (!fep->l2switch)
+		fec_enet_clk_enable(ndev, false);
+
 	pinctrl_pm_select_sleep_state(&pdev->dev);
 
 	ndev->max_mtu = PKT_MAXBUF_SIZE - ETH_HLEN - ETH_FCS_LEN;
-- 
2.20.1

