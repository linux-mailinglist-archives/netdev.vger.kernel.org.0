Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076D73B079E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 16:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhFVOnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 10:43:52 -0400
Received: from phobos.denx.de ([85.214.62.61]:38992 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230047AbhFVOnv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 10:43:51 -0400
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 2972C82BB3;
        Tue, 22 Jun 2021 16:41:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624372894;
        bh=dG3L77RP3vePSdkRGpzhm3S4Y8rUB4lLeRhJWY6YmMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4Rds+pIB5r3PZSJcaPMwol0/0xKBgwLhFI9uAFdbx5oxCcSXhUPqA4q99EuqaQC+
         6rLjO1aYeQqJV5OK84EtUtnc1nQG1V75hNn6qMy5Ykkwmb/upISfSNlQl+AKpEJt+z
         Lpi212BjK9YmOpN0SwfQz2LlnfYFZFtnFTY5Qeud3puW3vCW86P4o0LgrGtwNiP8me
         c9IlGAJDgzMZuQATfce3xqdIyK5gkH4AKnAaVjeycNPD+ozsbt22VsiN3ZJp/D8B/C
         22JjfYNcTZvfpkfM45/8jy/Wp/ae4XxZdz3Gi3OFRFurZnqUTpfDQq3EeJA4iX+hQl
         fgqkWkvlKDN/w==
From:   Lukasz Majewski <lukma@denx.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Einon <mark.einon@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-kernel@lists.infradead.org, Lukasz Majewski <lukma@denx.de>
Subject: [RFC 3/3] net: imx: Adjust fec_main.c to provide support for L2 switch
Date:   Tue, 22 Jun 2021 16:41:11 +0200
Message-Id: <20210622144111.19647-4-lukma@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210622144111.19647-1-lukma@denx.de>
References: <20210622144111.19647-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides the code for re-using generic FEC i.MX code for
More Than IP L2 switch.

The trick here is to reconfigure FEC driver to use DMA0 as the one
connected to switch's port 0. Port 1 and 2 are then connected to
ENET-MAC.

The internal connection diagram can be found here [0].

This code has been developed on i.MX287 device, but this switch (from
More ThanIP) can be also found on e.g. NXP's Vybrid VF610 SoC.

To reuse as much code as possible it was also necessary to introduce
fec_hwp() wrapper, which either returns pointer to MAC or L2 switch
interrupt and buffer descriptors.
Following registers shall be used with it:
FEC_{IEVENT|IMASK}, FEC_MTIP_R_DES_ACTIVE_0, FEC_MTIP_X_DES_ACTIVE_0,
FEC_MTIP_R_DES_START_0, FEC_MTIP_X_DES_START_0
This driver introduces special wrappers to map on fly DMA0 to either
ENET-MAC0 or L2 switch port 0.

The most intrusive changes when L2 switch is used:

- Disable RACC (Receive Data Accelerator)
When this feature is enabled the data is shifted by 16 bits and
hence received packets are malformed when we try to pass data from
one switch port to another.

- L2 switch shall pass the whole pkt_len packet. Current FEC code
subtract 4 to remove FCS

The control of FEC clock and promisc is handled by bridge driver, so
there is no need for adjustments.

This driver forward ports the legacy driver [1][2] into contemporary
Linux.

Last but not least - some functions had to be exported to allow proper
configuration of ethernet interfaces when bridging was enabled/disabled.

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
 drivers/net/ethernet/freescale/fec.h      |  36 ++++++
 drivers/net/ethernet/freescale/fec_main.c | 139 ++++++++++++++++++----
 2 files changed, 151 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0602d5d5d2ee..dc2d31321cbd 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -29,6 +29,10 @@
  */
 #define FEC_IEVENT		0x004 /* Interrupt event reg */
 #define FEC_IMASK		0x008 /* Interrupt mask reg */
+#ifdef CONFIG_FEC_MTIP_L2SW
+#define FEC_MTIP_R_DES_ACTIVE_0	0x018 /* L2 switch Receive descriptor reg */
+#define FEC_MTIP_X_DES_ACTIVE_0	0x01C /* L2 switch Transmit descriptor reg */
+#endif
 #define FEC_R_DES_ACTIVE_0	0x010 /* Receive descriptor reg */
 #define FEC_X_DES_ACTIVE_0	0x014 /* Transmit descriptor reg */
 #define FEC_ECNTRL		0x024 /* Ethernet control reg */
@@ -59,6 +63,10 @@
 #define FEC_R_DES_START_2	0x16c /* Receive descriptor ring 2 */
 #define FEC_X_DES_START_2	0x170 /* Transmit descriptor ring 2 */
 #define FEC_R_BUFF_SIZE_2	0x174 /* Maximum receive buff ring2 size */
+#ifdef CONFIG_FEC_MTIP_L2SW
+#define FEC_MTIP_R_DES_START_0  0x0C /* L2 switch Receive descriptor ring */
+#define FEC_MTIP_X_DES_START_0	0x10 /* L2 switch Transmit descriptor ring */
+#endif
 #define FEC_R_DES_START_0	0x180 /* Receive descriptor ring */
 #define FEC_X_DES_START_0	0x184 /* Transmit descriptor ring */
 #define FEC_R_BUFF_SIZE_0	0x188 /* Maximum receive buff size */
@@ -376,6 +384,12 @@ struct bufdesc_ex {
 #define FEC_ENET_TS_AVAIL       ((uint)0x00010000)
 #define FEC_ENET_TS_TIMER       ((uint)0x00008000)
 
+#ifdef CONFIG_FEC_MTIP_L2SW
+#define FEC_MTIP_ENET_TXF ((uint)0x00000010)	/* Full frame transmitted */
+#define FEC_MTIP_ENET_RXF ((uint)0x00000004)	/* Full frame received */
+#define FEC_MTIP_DEFAULT_IMASK (FEC_MTIP_ENET_TXF | FEC_MTIP_ENET_RXF)
+#define FEC_MTIP_RX_DISABLED_IMASK (FEC_MTIP_DEFAULT_IMASK & (~FEC_MTIP_ENET_RXF))
+#endif
 #define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF)
 #define FEC_RX_DISABLED_IMASK (FEC_DEFAULT_IMASK & (~FEC_ENET_RXF))
 
@@ -595,9 +609,31 @@ struct fec_enet_private {
 	int pps_enable;
 	unsigned int next_counter;
 
+#ifdef CONFIG_FEC_MTIP_L2SW
+	/* More Than IP L2 switch */
+	void __iomem *hwpsw;
+	struct mtipl2sw_priv *mtipl2;
+	bool mtip_l2sw;
+#endif
 	u64 ethtool_stats[];
 };
 
+/* MTIP L2 switch */
+/* Get proper base address for either L2 switch or MAC ENET */
+static inline void __iomem *fec_hwp(struct fec_enet_private *fep)
+{
+#ifdef CONFIG_FEC_MTIP_L2SW
+	if (fep->mtip_l2sw)
+		return fep->hwpsw;
+#endif
+	return fep->hwp;
+}
+
+int fec_enet_close(struct net_device *ndev);
+int fec_enet_open(struct net_device *ndev);
+const unsigned short fec_offset_des_active_rxq(struct fec_enet_private *, int);
+const unsigned short fec_offset_des_active_txq(struct fec_enet_private *, int);
+struct fec_enet_private *fec_get_priv(const struct net_device *ndev);
 void fec_ptp_init(struct platform_device *pdev, int irq_idx);
 void fec_ptp_stop(struct platform_device *pdev);
 void fec_ptp_start_cyclecounter(struct net_device *ndev);
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 3db882322b2b..797ed7e443ee 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -69,6 +69,9 @@
 #include <asm/cacheflush.h>
 
 #include "fec.h"
+#ifdef CONFIG_FEC_MTIP_L2SW
+#include "./mtipsw/fec_mtip.h"
+#endif
 
 static void set_multicast_list(struct net_device *ndev);
 static void fec_enet_itr_coal_init(struct net_device *ndev);
@@ -99,9 +102,11 @@ static const struct fec_devinfo fec_imx27_info = {
 
 static const struct fec_devinfo fec_imx28_info = {
 	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
-		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
-		  FEC_QUIRK_HAS_FRREG | FEC_QUIRK_CLEAR_SETUP_MII |
-		  FEC_QUIRK_NO_HARD_RESET,
+		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_FRREG |
+#ifndef CONFIG_FEC_MTIP_L2SW
+		  FEC_QUIRK_HAS_RACC |
+#endif
+		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_NO_HARD_RESET,
 };
 
 static const struct fec_devinfo fec_imx6q_info = {
@@ -278,6 +283,46 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 
 static int mii_cnt;
 
+static inline const unsigned short
+offset_des_start_rxq(struct fec_enet_private *fep, int i)
+{
+#ifdef CONFIG_FEC_MTIP_L2SW
+	if (fep->mtip_l2sw)
+		return FEC_MTIP_R_DES_START_0;
+#endif
+	return FEC_R_DES_START(i);
+}
+
+static inline const u32
+fec_rx_disabled_imask(struct fec_enet_private *fep)
+{
+#ifdef CONFIG_FEC_MTIP_L2SW
+	if (fep->mtip_l2sw)
+		return FEC_MTIP_RX_DISABLED_IMASK;
+#endif
+	return FEC_RX_DISABLED_IMASK;
+}
+
+static inline const u32
+fec_default_imask(struct fec_enet_private *fep)
+{
+#ifdef CONFIG_FEC_MTIP_L2SW
+	if (fep->mtip_l2sw)
+		return FEC_MTIP_DEFAULT_IMASK;
+#endif
+	return FEC_DEFAULT_IMASK;
+}
+
+static inline const unsigned short
+offset_des_start_txq(struct fec_enet_private *fep, int i)
+{
+#ifdef CONFIG_FEC_MTIP_L2SW
+	if (fep->mtip_l2sw)
+		return FEC_MTIP_X_DES_START_0;
+#endif
+	return FEC_X_DES_START(i);
+}
+
 static struct bufdesc *fec_enet_get_nextdesc(struct bufdesc *bdp,
 					     struct bufdesc_prop *bd)
 {
@@ -898,8 +943,9 @@ static void fec_enet_enable_ring(struct net_device *ndev)
 
 	for (i = 0; i < fep->num_rx_queues; i++) {
 		rxq = fep->rx_queue[i];
-		writel(rxq->bd.dma, fep->hwp + FEC_R_DES_START(i));
-		writel(PKT_MAXBUF_SIZE, fep->hwp + FEC_R_BUFF_SIZE(i));
+		writel(rxq->bd.dma, fec_hwp(fep) +
+		       offset_des_start_rxq(fep, i));
+		writel(PKT_MAXBUF_SIZE, fec_hwp(fep) + FEC_R_BUFF_SIZE(i));
 
 		/* enable DMA1/2 */
 		if (i)
@@ -909,8 +955,8 @@ static void fec_enet_enable_ring(struct net_device *ndev)
 
 	for (i = 0; i < fep->num_tx_queues; i++) {
 		txq = fep->tx_queue[i];
-		writel(txq->bd.dma, fep->hwp + FEC_X_DES_START(i));
-
+		writel(txq->bd.dma, fec_hwp(fep) +
+		       offset_des_start_txq(fep, i));
 		/* enable DMA1/2 */
 		if (i)
 			writel(DMA_CLASS_EN | IDLE_SLOPE(i),
@@ -1117,9 +1163,9 @@ fec_restart(struct net_device *ndev)
 
 	/* Enable interrupts we wish to service */
 	if (fep->link)
-		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
+		writel(fec_default_imask(fep), fec_hwp(fep) + FEC_IMASK);
 	else
-		writel(0, fep->hwp + FEC_IMASK);
+		writel(0, fec_hwp(fep) + FEC_IMASK);
 
 	/* Init the interrupt coalescing */
 	fec_enet_itr_coal_init(ndev);
@@ -1170,9 +1216,10 @@ fec_stop(struct net_device *ndev)
 			writel(1, fep->hwp + FEC_ECNTRL);
 			udelay(10);
 		}
-		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
+		writel(fec_default_imask(fep), fec_hwp(fep) + FEC_IMASK);
 	} else {
-		writel(FEC_DEFAULT_IMASK | FEC_ENET_WAKEUP, fep->hwp + FEC_IMASK);
+		writel(fec_default_imask(fep) | FEC_ENET_WAKEUP,
+		       fec_hwp(fep) + FEC_IMASK);
 		val = readl(fep->hwp + FEC_ECNTRL);
 		val |= (FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
 		writel(val, fep->hwp + FEC_ECNTRL);
@@ -1413,7 +1460,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 	unsigned short status;
 	struct  sk_buff *skb_new = NULL;
 	struct  sk_buff *skb;
-	ushort	pkt_len;
+	ushort	pkt_len, l2pl;
 	__u8 *data;
 	int	pkt_received = 0;
 	struct	bufdesc_ex *ebdp = NULL;
@@ -1439,7 +1486,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 			break;
 		pkt_received++;
 
-		writel(FEC_ENET_RXF, fep->hwp + FEC_IEVENT);
+		writel(FEC_ENET_RXF, fec_hwp(fep) + FEC_IEVENT);
 
 		/* Check for errors. */
 		status ^= BD_ENET_RX_LAST;
@@ -1479,7 +1526,17 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
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
+#ifdef CONFIG_FEC_MTIP_L2SW
+		if (fep->mtip_l2sw)
+			l2pl = pkt_len;
+#endif
+		is_copybreak = fec_enet_copybreak(ndev, &skb, bdp, l2pl,
 						  need_swap);
 		if (!is_copybreak) {
 			skb_new = netdev_alloc_skb(ndev, FEC_ENET_RX_FRSIZE);
@@ -1494,7 +1551,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 		}
 
 		prefetch(skb->data - NET_IP_ALIGN);
-		skb_put(skb, pkt_len - 4);
+		skb_put(skb, l2pl);
 		data = skb->data;
 
 		if (!is_copybreak && need_swap)
@@ -1654,7 +1711,7 @@ static int fec_enet_rx_napi(struct napi_struct *napi, int budget)
 
 	if (done < budget) {
 		napi_complete_done(napi, done);
-		writel(FEC_DEFAULT_IMASK, fep->hwp + FEC_IMASK);
+		writel(fec_default_imask(fep), fec_hwp(fep) + FEC_IMASK);
 	}
 
 	return done;
@@ -2971,7 +3028,7 @@ static int fec_enet_alloc_buffers(struct net_device *ndev)
 	return 0;
 }
 
-static int
+int
 fec_enet_open(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
@@ -3042,8 +3099,9 @@ fec_enet_open(struct net_device *ndev)
 	pinctrl_pm_select_sleep_state(&fep->pdev->dev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(fec_enet_open)
 
-static int
+int
 fec_enet_close(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
@@ -3072,6 +3130,7 @@ fec_enet_close(struct net_device *ndev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(fec_enet_close);
 
 /* Set or clear the multicast filter for this adaptor.
  * Skeleton taken from sunlance driver.
@@ -3240,14 +3299,45 @@ static const struct net_device_ops fec_netdev_ops = {
 	.ndo_set_features	= fec_set_features,
 };
 
-static const unsigned short offset_des_active_rxq[] = {
+#ifdef CONFIG_FEC_MTIP_L2SW
+struct fec_enet_private *fec_get_priv(const struct net_device *ndev)
+{
+	if (ndev->netdev_ops == &fec_netdev_ops)
+		return netdev_priv(ndev);
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(fec_get_priv)
+#endif
+
+static const unsigned short __offset_des_active_rxq[] = {
 	FEC_R_DES_ACTIVE_0, FEC_R_DES_ACTIVE_1, FEC_R_DES_ACTIVE_2
 };
 
-static const unsigned short offset_des_active_txq[] = {
+static const unsigned short __offset_des_active_txq[] = {
 	FEC_X_DES_ACTIVE_0, FEC_X_DES_ACTIVE_1, FEC_X_DES_ACTIVE_2
 };
 
+const unsigned short
+fec_offset_des_active_rxq(struct fec_enet_private *fep, int i)
+{
+#ifdef CONFIG_FEC_MTIP_L2SW
+	if (fep->mtip_l2sw)
+		return FEC_MTIP_R_DES_ACTIVE_0;
+#endif
+	return __offset_des_active_rxq[i];
+}
+
+const unsigned short
+fec_offset_des_active_txq(struct fec_enet_private *fep, int i)
+{
+#ifdef CONFIG_FEC_MTIP_L2SW
+	if (fep->mtip_l2sw)
+		return FEC_MTIP_X_DES_ACTIVE_0;
+#endif
+	return __offset_des_active_txq[i];
+}
+
  /*
   * XXX:  We need to clean up on failure exits here.
   *
@@ -3307,7 +3397,8 @@ static int fec_enet_init(struct net_device *ndev)
 		rxq->bd.dma = bd_dma;
 		rxq->bd.dsize = dsize;
 		rxq->bd.dsize_log2 = dsize_log2;
-		rxq->bd.reg_desc_active = fep->hwp + offset_des_active_rxq[i];
+		rxq->bd.reg_desc_active =
+			fec_hwp(fep) + fec_offset_des_active_rxq(fep, i);
 		bd_dma += size;
 		cbd_base = (struct bufdesc *)(((void *)cbd_base) + size);
 		rxq->bd.last = (struct bufdesc *)(((void *)cbd_base) - dsize);
@@ -3323,7 +3414,8 @@ static int fec_enet_init(struct net_device *ndev)
 		txq->bd.dma = bd_dma;
 		txq->bd.dsize = dsize;
 		txq->bd.dsize_log2 = dsize_log2;
-		txq->bd.reg_desc_active = fep->hwp + offset_des_active_txq[i];
+		txq->bd.reg_desc_active =
+			fec_hwp(fep) + fec_offset_des_active_txq(fep, i);
 		bd_dma += size;
 		cbd_base = (struct bufdesc *)(((void *)cbd_base) + size);
 		txq->bd.last = (struct bufdesc *)(((void *)cbd_base) - dsize);
@@ -3334,8 +3426,7 @@ static int fec_enet_init(struct net_device *ndev)
 	ndev->watchdog_timeo = TX_TIMEOUT;
 	ndev->netdev_ops = &fec_netdev_ops;
 	ndev->ethtool_ops = &fec_enet_ethtool_ops;
-
-	writel(FEC_RX_DISABLED_IMASK, fep->hwp + FEC_IMASK);
+	writel(fec_rx_disabled_imask(fep), fec_hwp(fep) + FEC_IMASK);
 	netif_napi_add(ndev, &fep->napi, fec_enet_rx_napi, NAPI_POLL_WEIGHT);
 
 	if (fep->quirks & FEC_QUIRK_HAS_VLAN)
-- 
2.20.1

