Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1386826F925
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 11:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgIRJYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 05:24:00 -0400
Received: from inva021.nxp.com ([92.121.34.21]:51672 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgIRJX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 05:23:59 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AA873201151;
        Fri, 18 Sep 2020 11:16:23 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1975D201167;
        Fri, 18 Sep 2020 11:16:20 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 8463A4029A;
        Fri, 18 Sep 2020 11:16:15 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [v4, 4/5] dpaa2-eth: utilize skb->cb[0] for hardware timestamping
Date:   Fri, 18 Sep 2020 17:08:01 +0800
Message-Id: <20200918090802.13757-5-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200918090802.13757-1-yangbo.lu@nxp.com>
References: <20200918090802.13757-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is a preparation for next hardware one-step timestamping
support. For DPAA2, the one step timestamping configuration on
hardware registers has to be done when there is no one-step timestamping
packet in flight. So we will have to use workqueue and skb queue
for such packets transmitting, to make sure waiting the last packet has
already been sent on hardware, and starting to transmit the current one.

So the tx timestamping flag in private data may not reflect the actual
request for the one-step timestamping packets of skb queue. This also
affects skb headroom allocation. Let's use skb->cb[0] to mark the
timestamping request for each skb.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Removed unused variable priv in dpaa2_eth_xdp_create_fd().
Changes for v3:
	- None.
Changes for v4:
	- None.
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 26 +++++++++++++++---------
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h | 13 ++++++------
 2 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index a8c311fb..eab9470 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -11,7 +11,6 @@
 #include <linux/msi.h>
 #include <linux/kthread.h>
 #include <linux/iommu.h>
-#include <linux/net_tstamp.h>
 #include <linux/fsl/mc.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
@@ -780,7 +779,7 @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
 	struct dpaa2_eth_swa *swa;
 	dma_addr_t addr;
 
-	buffer_start = skb->data - dpaa2_eth_needed_headroom(priv, skb);
+	buffer_start = skb->data - dpaa2_eth_needed_headroom(skb);
 
 	/* If there's enough room to align the FD address, do it.
 	 * It will help hardware optimize accesses.
@@ -894,7 +893,7 @@ static void dpaa2_eth_free_tx_fd(const struct dpaa2_eth_priv *priv,
 	}
 
 	/* Get the timestamp value */
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+	if (skb->cb[0] == TX_TSTAMP) {
 		struct skb_shared_hwtstamps shhwtstamps;
 		__le64 *ts = dpaa2_get_ts(buffer_start, true);
 		u64 ns;
@@ -938,10 +937,17 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	int err, i;
 	void *swa;
 
+	/* Utilize skb->cb[0] for timestamping request per skb */
+	skb->cb[0] = 0;
+
+	if (priv->tx_tstamp_type == HWTSTAMP_TX_ON &&
+	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
+		skb->cb[0] = TX_TSTAMP;
+
 	percpu_stats = this_cpu_ptr(priv->percpu_stats);
 	percpu_extras = this_cpu_ptr(priv->percpu_extras);
 
-	needed_headroom = dpaa2_eth_needed_headroom(priv, skb);
+	needed_headroom = dpaa2_eth_needed_headroom(skb);
 
 	/* We'll be holding a back-reference to the skb until Tx Confirmation;
 	 * we don't want that overwritten by a concurrent Tx with a cloned skb.
@@ -975,7 +981,7 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 		goto err_build_fd;
 	}
 
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
+	if (skb->cb[0] == TX_TSTAMP)
 		dpaa2_eth_enable_tx_tstamp(&fd, swa);
 
 	/* Tracing point */
@@ -1899,10 +1905,8 @@ static int dpaa2_eth_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
-		priv->tx_tstamp = false;
-		break;
 	case HWTSTAMP_TX_ON:
-		priv->tx_tstamp = true;
+		priv->tx_tstamp_type = config.tx_type;
 		break;
 	default:
 		return -ERANGE;
@@ -2097,7 +2101,6 @@ static int dpaa2_eth_xdp_create_fd(struct net_device *net_dev,
 				   struct xdp_frame *xdpf,
 				   struct dpaa2_fd *fd)
 {
-	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	struct device *dev = net_dev->dev.parent;
 	unsigned int needed_headroom;
 	struct dpaa2_eth_swa *swa;
@@ -2107,7 +2110,7 @@ static int dpaa2_eth_xdp_create_fd(struct net_device *net_dev,
 	/* We require a minimum headroom to be able to transmit the frame.
 	 * Otherwise return an error and let the original net_device handle it
 	 */
-	needed_headroom = dpaa2_eth_needed_headroom(priv, NULL);
+	needed_headroom = dpaa2_eth_needed_headroom(NULL);
 	if (xdpf->headroom < needed_headroom)
 		return -EINVAL;
 
@@ -3963,6 +3966,9 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 
 	priv->iommu_domain = iommu_get_domain_for_dev(dev);
 
+	priv->tx_tstamp_type = HWTSTAMP_TX_OFF;
+	priv->rx_tstamp = false;
+
 	/* Obtain a MC portal */
 	err = fsl_mc_portal_allocate(dpni_dev, FSL_MC_IO_ATOMIC_CONTEXT_PORTAL,
 				     &priv->mc_io);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 7be684b..e33d79e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -10,6 +10,7 @@
 #include <linux/netdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/fsl/mc.h>
+#include <linux/net_tstamp.h>
 
 #include <soc/fsl/dpaa2-io.h>
 #include <soc/fsl/dpaa2-fd.h>
@@ -433,8 +434,8 @@ struct dpaa2_eth_priv {
 	u16 bpid;
 	struct iommu_domain *iommu_domain;
 
-	bool tx_tstamp; /* Tx timestamping enabled */
-	bool rx_tstamp; /* Rx timestamping enabled */
+	enum hwtstamp_tx_types tx_tstamp_type;	/* Tx timestamping type */
+	bool rx_tstamp;				/* Rx timestamping enabled */
 
 	u16 tx_qdid;
 	struct fsl_mc_io *mc_io;
@@ -475,6 +476,8 @@ struct dpaa2_eth_priv {
 	struct dpaa2_mac *mac;
 };
 
+#define TX_TSTAMP		0x1
+
 #define DPAA2_RXH_SUPPORTED	(RXH_L2DA | RXH_VLAN | RXH_L3_PROTO \
 				| RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 \
 				| RXH_L4_B_2_3)
@@ -561,9 +564,7 @@ static inline bool dpaa2_eth_rx_pause_enabled(u64 link_options)
 	return !!(link_options & DPNI_LINK_OPT_PAUSE);
 }
 
-static inline
-unsigned int dpaa2_eth_needed_headroom(struct dpaa2_eth_priv *priv,
-				       struct sk_buff *skb)
+static inline unsigned int dpaa2_eth_needed_headroom(struct sk_buff *skb)
 {
 	unsigned int headroom = DPAA2_ETH_SWA_SIZE;
 
@@ -580,7 +581,7 @@ unsigned int dpaa2_eth_needed_headroom(struct dpaa2_eth_priv *priv,
 		return 0;
 
 	/* If we have Tx timestamping, need 128B hardware annotation */
-	if (priv->tx_tstamp && skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
+	if (skb->cb[0] == TX_TSTAMP)
 		headroom += DPAA2_ETH_TX_HWA_SIZE;
 
 	return headroom;
-- 
2.7.4

