Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2896134A3B3
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 10:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhCZJH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 05:07:56 -0400
Received: from inva021.nxp.com ([92.121.34.21]:42840 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229976AbhCZJHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 05:07:36 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E627F203BC3;
        Fri, 26 Mar 2021 10:07:32 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BA966203B95;
        Fri, 26 Mar 2021 10:07:29 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 25DA2406BE;
        Fri, 26 Mar 2021 09:29:56 +0100 (CET)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH 2/2] enetc: support PTP Sync packet one-step timestamping
Date:   Fri, 26 Mar 2021 16:35:54 +0800
Message-Id: <20210326083554.28985-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210326083554.28985-1-yangbo.lu@nxp.com>
References: <20210326083554.28985-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add support for PTP Sync packet one-step timestamping.
Since ENETC single-step register has to be configured dynamically per
packet for correctionField offeset and UDP checksum update, current
one-step timestamping packet has to be sent only when the last one
completes transmitting on hardware. So, on the TX below things are done
by the patch:

- For one-step timestamping packet, queue to skb queue.
- Start a work to transmit skbs in queue.
- For other skbs, transmit immediately.
- mutex lock used to ensure the last one-step timestamping packet has
  already been transmitted on hardware before transmitting current one.

And the configuration for one-step timestamping on ENETC before
transmitting is,

- Set one-step timestamping flag in extension BD.
- Write 30 bits current timestamp in tstamp field of extension BD.
- Update PTP Sync packet originTimestamp field with current timestamp.
- Configure single-step register for correctionField offeset and UDP
  checksum update.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 204 ++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  21 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |   3 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   7 +
 4 files changed, 209 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 61d684086432..7e33842d265e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -5,6 +5,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/vmalloc.h>
+#include <linux/ptp_classify.h>
 #include <net/pkt_sched.h>
 
 /* ENETC overhead: optional extension BD + 1 BD gap */
@@ -37,15 +38,52 @@ static void enetc_free_tx_skb(struct enetc_bdr *tx_ring,
 	}
 }
 
+static int enetc_ptp_parse(struct sk_buff *skb, u8 *udp,
+			   u8 *msgtype, u8 *twostep,
+			   u16 *correction_offset, u16 *body_offset)
+{
+	unsigned int ptp_class;
+	struct ptp_header *hdr;
+	unsigned int type;
+	u8 *base;
+
+	ptp_class = ptp_classify_raw(skb);
+	if (ptp_class == PTP_CLASS_NONE)
+		return -EINVAL;
+
+	hdr = ptp_parse_header(skb, ptp_class);
+	if (!hdr)
+		return -EINVAL;
+
+	type = ptp_class & PTP_CLASS_PMASK;
+	if (type == PTP_CLASS_IPV4 || type == PTP_CLASS_IPV6)
+		*udp = 1;
+	else
+		*udp = 0;
+
+	*msgtype = ptp_get_msgtype(hdr, ptp_class);
+	*twostep = hdr->flag_field[0] & 0x2;
+
+	base = skb_mac_header(skb);
+	*correction_offset = (u8 *)&hdr->correction - base;
+	*body_offset = (u8 *)hdr + sizeof(struct ptp_header) - base;
+
+	return 0;
+}
+
 static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 {
+	bool do_vlan, do_onestep_tstamp = false, do_twostep_tstamp = false;
+	struct enetc_ndev_priv *priv = netdev_priv(tx_ring->ndev);
+	struct enetc_hw *hw = &priv->si->hw;
 	struct enetc_tx_swbd *tx_swbd;
-	skb_frag_t *frag;
 	int len = skb_headlen(skb);
 	union enetc_tx_bd temp_bd;
+	u8 msgtype, twostep, udp;
 	union enetc_tx_bd *txbd;
-	bool do_vlan, do_tstamp;
+	u16 offset1, offset2;
 	int i, count = 0;
+	skb_frag_t *frag;
 	unsigned int f;
 	dma_addr_t dma;
 	u8 flags = 0;
@@ -69,12 +107,21 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 	count++;
 
 	do_vlan = skb_vlan_tag_present(skb);
-	do_tstamp = (skb->cb[0] & ENETC_F_TX_TSTAMP) &&
-		    (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP);
-	tx_swbd->do_tstamp = do_tstamp;
-	tx_swbd->check_wb = tx_swbd->do_tstamp;
+	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
+		if (enetc_ptp_parse(skb, &udp, &msgtype, &twostep, &offset1,
+				    &offset2) ||
+		    msgtype != PTP_MSGTYPE_SYNC || twostep)
+			WARN_ONCE(1, "Bad packet for one-step timestamping\n");
+		else
+			do_onestep_tstamp = true;
+	} else if (skb->cb[0] & ENETC_F_TX_TSTAMP) {
+		do_twostep_tstamp = true;
+	}
+
+	tx_swbd->do_twostep_tstamp = do_twostep_tstamp;
+	tx_swbd->check_wb = tx_swbd->do_twostep_tstamp;
 
-	if (do_vlan || do_tstamp)
+	if (do_vlan || do_onestep_tstamp || do_twostep_tstamp)
 		flags |= ENETC_TXBD_FLAGS_EX;
 
 	if (tx_ring->tsd_enable)
@@ -111,7 +158,38 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 			e_flags |= ENETC_TXBD_E_FLAGS_VLAN_INS;
 		}
 
-		if (do_tstamp) {
+		if (do_onestep_tstamp) {
+			u32 lo, hi, val;
+			u64 sec, nsec;
+			u8 *data;
+
+			lo = enetc_rd_hot(hw, ENETC_SICTR0);
+			hi = enetc_rd_hot(hw, ENETC_SICTR1);
+			sec = (u64)hi << 32 | lo;
+			nsec = do_div(sec, 1000000000);
+
+			/* Configure extension BD */
+			temp_bd.ext.tstamp = cpu_to_le32(lo & 0x3fffffff);
+			e_flags |= ENETC_TXBD_E_FLAGS_ONE_STEP_PTP;
+
+			/* Update originTimestamp field of Sync packet
+			 * - 48 bits seconds field
+			 * - 32 bits nanseconds field
+			 */
+			data = skb_mac_header(skb);
+			*(__be16 *)(data + offset2) = htons((sec >> 32) & 0xffff);
+			*(__be32 *)(data + offset2 + 2) = htonl(sec & 0xffffffff);
+			*(__be32 *)(data + offset2 + 6) = htonl(nsec);
+
+			/* Configure single-step register */
+			val = ENETC_PM0_SINGLE_STEP_EN;
+			val |= ENETC_SET_SINGLE_STEP_OFFSET(offset1);
+			if (udp)
+				val |= ENETC_PM0_SINGLE_STEP_CH;
+
+			enetc_port_wr(hw, ENETC_PM0_SINGLE_STEP, val);
+			enetc_port_wr(hw, ENETC_PM1_SINGLE_STEP, val);
+		} else if (do_twostep_tstamp) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			e_flags |= ENETC_TXBD_E_FLAGS_TWO_STEP_PTP;
 		}
@@ -182,15 +260,12 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 	return 0;
 }
 
-netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
+netdev_tx_t enetc_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_bdr *tx_ring;
 	int count;
 
-	/* cb[0] used for TX timestamp type */
-	skb->cb[0] = priv->active_offloads & ENETC_F_TX_TSTAMP_MASK;
-
 	tx_ring = priv->tx_ring[skb->queue_mapping];
 
 	if (unlikely(skb_shinfo(skb)->nr_frags > ENETC_MAX_SKB_FRAGS))
@@ -220,6 +295,39 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
+netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	u8 udp, msgtype, twostep;
+	u16 offset1, offset2;
+
+	/* Mark tx timestamp type on skb->cb[0] if requires */
+	if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+	    (priv->active_offloads & ENETC_F_TX_TSTAMP_MASK)) {
+		skb->cb[0] = priv->active_offloads & ENETC_F_TX_TSTAMP_MASK;
+	} else {
+		skb->cb[0] = 0;
+	}
+
+	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
+		/* For one-step PTP sync packet, queue it */
+		if (!enetc_ptp_parse(skb, &udp, &msgtype, &twostep,
+				     &offset1, &offset2)) {
+			if (msgtype == PTP_MSGTYPE_SYNC && twostep == 0) {
+				skb_queue_tail(&priv->tx_skbs, skb);
+				queue_work(priv->enetc_ptp_wq,
+					   &priv->tx_onestep_tstamp);
+				return NETDEV_TX_OK;
+			}
+		}
+
+		/* Fall back to two-step timestamp for other packets */
+		skb->cb[0] = ENETC_F_TX_TSTAMP;
+	}
+
+	return enetc_start_xmit(skb, ndev);
+}
+
 static irqreturn_t enetc_msix(int irq, void *data)
 {
 	struct enetc_int_vector	*v = data;
@@ -304,10 +412,11 @@ static void enetc_tstamp_tx(struct sk_buff *skb, u64 tstamp)
 static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 {
 	struct net_device *ndev = tx_ring->ndev;
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	int tx_frm_cnt = 0, tx_byte_cnt = 0;
 	struct enetc_tx_swbd *tx_swbd;
 	int i, bds_to_clean;
-	bool do_tstamp;
+	bool do_twostep_tstamp;
 	u64 tstamp = 0;
 
 	i = tx_ring->next_to_clean;
@@ -315,7 +424,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 
 	bds_to_clean = enetc_bd_ready_count(tx_ring, i);
 
-	do_tstamp = false;
+	do_twostep_tstamp = false;
 
 	while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
 		bool is_eof = !!tx_swbd->skb;
@@ -327,10 +436,10 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 			txbd = ENETC_TXBD(*tx_ring, i);
 
 			if (txbd->flags & ENETC_TXBD_FLAGS_W &&
-			    tx_swbd->do_tstamp) {
+			    tx_swbd->do_twostep_tstamp) {
 				enetc_get_tx_tstamp(&priv->si->hw, txbd,
 						    &tstamp);
-				do_tstamp = true;
+				do_twostep_tstamp = true;
 			}
 		}
 
@@ -338,9 +447,12 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 			enetc_unmap_tx_buff(tx_ring, tx_swbd);
 
 		if (is_eof) {
-			if (unlikely(do_tstamp)) {
+			if (unlikely(tx_swbd->skb->cb[0] &
+				     ENETC_F_TX_ONESTEP_SYNC_TSTAMP)) {
+				mutex_unlock(&priv->onestep_tstamp_lock);
+			} else if (unlikely(do_twostep_tstamp)) {
 				enetc_tstamp_tx(tx_swbd->skb, tstamp);
-				do_tstamp = false;
+				do_twostep_tstamp = false;
 			}
 			napi_consume_skb(tx_swbd->skb, napi_budget);
 			tx_swbd->skb = NULL;
@@ -1310,6 +1422,44 @@ static int enetc_phylink_connect(struct net_device *ndev)
 	return 0;
 }
 
+static void enetc_tx_onestep_tstamp(struct work_struct *work)
+{
+	struct enetc_ndev_priv *priv;
+	struct sk_buff *skb;
+
+	priv = container_of(work, struct enetc_ndev_priv, tx_onestep_tstamp);
+
+	while (true) {
+		skb = skb_dequeue(&priv->tx_skbs);
+		if (!skb)
+			return;
+
+		/* Lock before TX one-step timestamping packet, and release
+		 * when the packet has been sent on hardware, or transmit
+		 * failure.
+		 */
+		mutex_lock(&priv->onestep_tstamp_lock);
+		enetc_start_xmit(skb, priv->ndev);
+	}
+}
+
+static int enetc_tx_onestep_tstamp_init(struct enetc_ndev_priv *priv)
+{
+	priv->enetc_ptp_wq = alloc_workqueue("enetc_ptp_wq", 0, 0);
+	if (!priv->enetc_ptp_wq)
+		return -ENOMEM;
+
+	INIT_WORK(&priv->tx_onestep_tstamp, enetc_tx_onestep_tstamp);
+	skb_queue_head_init(&priv->tx_skbs);
+
+	return 0;
+}
+
+static void enetc_tx_onestep_tstamp_deinit(struct enetc_ndev_priv *priv)
+{
+	destroy_workqueue(priv->enetc_ptp_wq);
+}
+
 void enetc_start(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -1354,6 +1504,10 @@ int enetc_open(struct net_device *ndev)
 	if (err)
 		goto err_alloc_rx;
 
+	err = enetc_tx_onestep_tstamp_init(priv);
+	if (err)
+		goto err_tx_onestep_tstamp;
+
 	err = netif_set_real_num_tx_queues(ndev, priv->num_tx_rings);
 	if (err)
 		goto err_set_queues;
@@ -1368,6 +1522,8 @@ int enetc_open(struct net_device *ndev)
 	return 0;
 
 err_set_queues:
+	enetc_tx_onestep_tstamp_deinit(priv);
+err_tx_onestep_tstamp:
 	enetc_free_rx_resources(priv);
 err_alloc_rx:
 	enetc_free_tx_resources(priv);
@@ -1414,6 +1570,7 @@ int enetc_close(struct net_device *ndev)
 	if (priv->phylink)
 		phylink_disconnect_phy(priv->phylink);
 	enetc_free_rxtx_rings(priv);
+	enetc_tx_onestep_tstamp_deinit(priv);
 	enetc_free_rx_resources(priv);
 	enetc_free_tx_resources(priv);
 	enetc_free_irqs(priv);
@@ -1612,11 +1769,16 @@ static int enetc_hwtstamp_set(struct net_device *ndev, struct ifreq *ifr)
 
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
-		priv->active_offloads &= ~ENETC_F_TX_TSTAMP;
+		priv->active_offloads &= ~ENETC_F_TX_TSTAMP_MASK;
 		break;
 	case HWTSTAMP_TX_ON:
+		priv->active_offloads &= ~ENETC_F_TX_TSTAMP_MASK;
 		priv->active_offloads |= ENETC_F_TX_TSTAMP;
 		break;
+	case HWTSTAMP_TX_ONESTEP_SYNC:
+		priv->active_offloads &= ~ENETC_F_TX_TSTAMP_MASK;
+		priv->active_offloads |= ENETC_F_TX_ONESTEP_SYNC_TSTAMP;
+		break;
 	default:
 		return -ERANGE;
 	}
@@ -1647,7 +1809,9 @@ static int enetc_hwtstamp_get(struct net_device *ndev, struct ifreq *ifr)
 
 	config.flags = 0;
 
-	if (priv->active_offloads & ENETC_F_TX_TSTAMP)
+	if (priv->active_offloads & ENETC_F_TX_ONESTEP_SYNC_TSTAMP)
+		config.tx_type = HWTSTAMP_TX_ONESTEP_SYNC;
+	else if (priv->active_offloads & ENETC_F_TX_TSTAMP)
 		config.tx_type = HWTSTAMP_TX_ON;
 	else
 		config.tx_type = HWTSTAMP_TX_OFF;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 24d77768932b..7dbf6424e2c5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -24,7 +24,7 @@ struct enetc_tx_swbd {
 	u16 len;
 	u8 is_dma_page:1;
 	u8 check_wb:1;
-	u8 do_tstamp:1;
+	u8 do_twostep_tstamp:1;
 };
 
 #define ENETC_RX_MAXFRM_SIZE	ENETC_MAC_MAXFRM_SIZE
@@ -231,11 +231,12 @@ struct psfp_cap {
 /* TODO: more hardware offloads */
 enum enetc_active_offloads {
 	/* 8 bits reserved for TX timestamp types (hwtstamp_tx_types) */
-	ENETC_F_TX_TSTAMP	= BIT(0),
+	ENETC_F_TX_TSTAMP		= BIT(0),
+	ENETC_F_TX_ONESTEP_SYNC_TSTAMP	= BIT(1),
 
-	ENETC_F_RX_TSTAMP	= BIT(8),
-	ENETC_F_QBV		= BIT(9),
-	ENETC_F_QCI		= BIT(10),
+	ENETC_F_RX_TSTAMP		= BIT(8),
+	ENETC_F_QBV			= BIT(9),
+	ENETC_F_QCI			= BIT(10),
 };
 
 /* interrupt coalescing modes */
@@ -278,6 +279,16 @@ struct enetc_ndev_priv {
 	struct phylink *phylink;
 	int ic_mode;
 	u32 tx_ictt;
+
+	/* The single-step register has to be configured dynamically per
+	 * message. So, before transmit current message, use a mutex lock
+	 * to make sure the lock is released by last one-step timestamping
+	 * message completing transmitting on hardware.
+	 */
+	struct mutex		onestep_tstamp_lock;
+	struct workqueue_struct	*enetc_ptp_wq;
+	struct work_struct	tx_onestep_tstamp;
+	struct sk_buff_head	tx_skbs;
 };
 
 /* Messaging */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 89e558135432..a20b2967b888 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -654,7 +654,8 @@ static int enetc_get_ts_info(struct net_device *ndev,
 				SOF_TIMESTAMPING_RAW_HARDWARE;
 
 	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
-			 (1 << HWTSTAMP_TX_ON);
+			 (1 << HWTSTAMP_TX_ON) |
+			 (1 << HWTSTAMP_TX_ONESTEP_SYNC);
 	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
 			   (1 << HWTSTAMP_FILTER_ALL);
 #else
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 00938f7960a4..04ac7fc23ead 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -239,6 +239,12 @@ enum enetc_bdr_type {TX, RX};
 
 #define ENETC_PM_IMDIO_BASE	0x8030
 
+#define ENETC_PM0_SINGLE_STEP		0x80c0
+#define ENETC_PM1_SINGLE_STEP		0x90c0
+#define ENETC_PM0_SINGLE_STEP_CH	BIT(7)
+#define ENETC_PM0_SINGLE_STEP_EN	BIT(31)
+#define ENETC_SET_SINGLE_STEP_OFFSET(v)	(((v) & 0xff) << 8)
+
 #define ENETC_PM0_IF_MODE	0x8300
 #define ENETC_PM0_IFM_RG	BIT(2)
 #define ENETC_PM0_IFM_RLP	(BIT(5) | BIT(11))
@@ -548,6 +554,7 @@ static inline void enetc_clear_tx_bd(union enetc_tx_bd *txbd)
 
 /* Extension flags */
 #define ENETC_TXBD_E_FLAGS_VLAN_INS	BIT(0)
+#define ENETC_TXBD_E_FLAGS_ONE_STEP_PTP	BIT(1)
 #define ENETC_TXBD_E_FLAGS_TWO_STEP_PTP	BIT(2)
 
 union enetc_rx_bd {
-- 
2.25.1

