Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00BCD35BECA
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 11:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238759AbhDLJCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 05:02:02 -0400
Received: from inva021.nxp.com ([92.121.34.21]:44526 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238817AbhDLI5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 04:57:19 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 1DE25201AED;
        Mon, 12 Apr 2021 10:57:00 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 953BF201AFB;
        Mon, 12 Apr 2021 10:56:56 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 33F14402F0;
        Mon, 12 Apr 2021 10:56:52 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [net-next, v3, 2/2] enetc: support PTP Sync packet one-step timestamping
Date:   Mon, 12 Apr 2021 17:03:27 +0800
Message-Id: <20210412090327.22330-3-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210412090327.22330-1-yangbo.lu@nxp.com>
References: <20210412090327.22330-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add support for PTP Sync packet one-step timestamping.
Since ENETC single-step register has to be configured dynamically per
packet for correctionField offeset and UDP checksum update, current
one-step timestamping packet has to be sent only when the last one
completes transmitting on hardware. So, on the TX, this patch handles
one-step timestamping packet as below:

- Trasmit packet immediately if no other one in transfer, or queue to
  skb queue if there is already one in transfer.
  The test_and_set_bit_lock() is used here to lock and check state.
- Start a work when complete transfer on hardware, to release the bit
  lock and to send one skb in skb queue if has.

And the configuration for one-step timestamping on ENETC before
transmitting is,

- Set one-step timestamping flag in extension BD.
- Write 30 bits current timestamp in tstamp field of extension BD.
- Update PTP Sync packet originTimestamp field with current timestamp.
- Configure single-step register for correctionField offeset and UDP
  checksum update.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- Rebased.
	- Fixed issues from patchwork checks.
	- netif_tx_lock for one-step timestamping packet sending.
Changes for v3:
	- Used system workqueue.
	- Set bit lock when transmitted one-step packet, and scheduled
	  work when completed. The worker cleared the bit lock, and
	  transmitted one skb in skb queue if has, instead of a loop.
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 191 ++++++++++++++++--
 drivers/net/ethernet/freescale/enetc/enetc.h  |  20 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |   3 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   7 +
 4 files changed, 195 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 6e3a5303e2bb..4a0adb0b8bd7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -6,6 +6,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/vmalloc.h>
+#include <linux/ptp_classify.h>
 #include <net/pkt_sched.h>
 
 static struct sk_buff *enetc_tx_swbd_get_skb(struct enetc_tx_swbd *tx_swbd)
@@ -67,15 +68,52 @@ static void enetc_update_tx_ring_tail(struct enetc_bdr *tx_ring)
 	enetc_wr_reg_hot(tx_ring->tpir, tx_ring->next_to_use);
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
@@ -100,12 +138,21 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
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
@@ -142,7 +189,40 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
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
+			*(__be16 *)(data + offset2) =
+				htons((sec >> 32) & 0xffff);
+			*(__be32 *)(data + offset2 + 2) =
+				htonl(sec & 0xffffffff);
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
@@ -214,15 +294,13 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb)
 	return 0;
 }
 
-netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t enetc_start_xmit(struct sk_buff *skb,
+				    struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_bdr *tx_ring;
 	int count;
 
-	/* cb[0] used for TX timestamp type */
-	skb->cb[0] = priv->active_offloads & ENETC_F_TX_TSTAMP_MASK;
-
 	tx_ring = priv->tx_ring[skb->queue_mapping];
 
 	if (unlikely(skb_shinfo(skb)->nr_frags > ENETC_MAX_SKB_FRAGS))
@@ -252,6 +330,40 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
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
+	/* Fall back to two-step timestamp if not one-step Sync packet */
+	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
+		if (enetc_ptp_parse(skb, &udp, &msgtype, &twostep,
+				    &offset1, &offset2) ||
+		    msgtype != PTP_MSGTYPE_SYNC || twostep != 0)
+			skb->cb[0] = ENETC_F_TX_TSTAMP;
+	}
+
+	/* Queue one-step Sync packet if already locked */
+	if (skb->cb[0] & ENETC_F_TX_ONESTEP_SYNC_TSTAMP) {
+		if (test_and_set_bit_lock(ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS,
+					  &priv->flags)) {
+			skb_queue_tail(&priv->tx_skbs, skb);
+			return NETDEV_TX_OK;
+		}
+	}
+
+	return enetc_start_xmit(skb, ndev);
+}
+
 static irqreturn_t enetc_msix(int irq, void *data)
 {
 	struct enetc_int_vector	*v = data;
@@ -392,10 +504,11 @@ static void enetc_recycle_xdp_tx_buff(struct enetc_bdr *tx_ring,
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
@@ -403,7 +516,7 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 
 	bds_to_clean = enetc_bd_ready_count(tx_ring, i);
 
-	do_tstamp = false;
+	do_twostep_tstamp = false;
 
 	while (bds_to_clean && tx_frm_cnt < ENETC_DEFAULT_TX_WORK) {
 		struct xdp_frame *xdp_frame = enetc_tx_swbd_get_xdp_frame(tx_swbd);
@@ -417,10 +530,10 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
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
 
@@ -433,9 +546,16 @@ static bool enetc_clean_tx_ring(struct enetc_bdr *tx_ring, int napi_budget)
 			xdp_return_frame(xdp_frame);
 			tx_swbd->xdp_frame = NULL;
 		} else if (skb) {
-			if (unlikely(do_tstamp)) {
+			if (unlikely(tx_swbd->skb->cb[0] &
+				     ENETC_F_TX_ONESTEP_SYNC_TSTAMP)) {
+				/* Start work to release lock for next one-step
+				 * timestamping packet. And send one skb in
+				 * tx_skbs queue if has.
+				 */
+				queue_work(system_wq, &priv->tx_onestep_tstamp);
+			} else if (unlikely(do_twostep_tstamp)) {
 				enetc_tstamp_tx(skb, tstamp);
-				do_tstamp = false;
+				do_twostep_tstamp = false;
 			}
 			napi_consume_skb(skb, napi_budget);
 			tx_swbd->skb = NULL;
@@ -1864,6 +1984,29 @@ static int enetc_phylink_connect(struct net_device *ndev)
 	return 0;
 }
 
+static void enetc_tx_onestep_tstamp(struct work_struct *work)
+{
+	struct enetc_ndev_priv *priv;
+	struct sk_buff *skb;
+
+	priv = container_of(work, struct enetc_ndev_priv, tx_onestep_tstamp);
+
+	netif_tx_lock(priv->ndev);
+
+	clear_bit_unlock(ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS, &priv->flags);
+	skb = skb_dequeue(&priv->tx_skbs);
+	if (skb)
+		enetc_start_xmit(skb, priv->ndev);
+
+	netif_tx_unlock(priv->ndev);
+}
+
+static void enetc_tx_onestep_tstamp_init(struct enetc_ndev_priv *priv)
+{
+	INIT_WORK(&priv->tx_onestep_tstamp, enetc_tx_onestep_tstamp);
+	skb_queue_head_init(&priv->tx_skbs);
+}
+
 void enetc_start(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -1916,6 +2059,7 @@ int enetc_open(struct net_device *ndev)
 	if (err)
 		goto err_set_queues;
 
+	enetc_tx_onestep_tstamp_init(priv);
 	enetc_setup_bdrs(priv);
 	enetc_start(ndev);
 
@@ -2214,11 +2358,16 @@ static int enetc_hwtstamp_set(struct net_device *ndev, struct ifreq *ifr)
 
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
@@ -2249,7 +2398,9 @@ static int enetc_hwtstamp_get(struct net_device *ndev, struct ifreq *ifr)
 
 	config.flags = 0;
 
-	if (priv->active_offloads & ENETC_F_TX_TSTAMP)
+	if (priv->active_offloads & ENETC_F_TX_ONESTEP_SYNC_TSTAMP)
+		config.tx_type = HWTSTAMP_TX_ONESTEP_SYNC;
+	else if (priv->active_offloads & ENETC_F_TX_TSTAMP)
 		config.tx_type = HWTSTAMP_TX_ON;
 	else
 		config.tx_type = HWTSTAMP_TX_OFF;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 96889529383e..d52717bc73c7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -30,7 +30,7 @@ struct enetc_tx_swbd {
 	enum dma_data_direction dir;
 	u8 is_dma_page:1;
 	u8 check_wb:1;
-	u8 do_tstamp:1;
+	u8 do_twostep_tstamp:1;
 	u8 is_eof:1;
 	u8 is_xdp_tx:1;
 	u8 is_xdp_redirect:1;
@@ -275,11 +275,16 @@ struct psfp_cap {
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
+};
+
+enum enetc_flags_bit {
+	ENETC_TX_ONESTEP_TSTAMP_IN_PROGRESS = 0,
 };
 
 /* interrupt coalescing modes */
@@ -324,6 +329,11 @@ struct enetc_ndev_priv {
 	u32 tx_ictt;
 
 	struct bpf_prog *xdp_prog;
+
+	unsigned long flags;
+
+	struct work_struct	tx_onestep_tstamp;
+	struct sk_buff_head	tx_skbs;
 };
 
 /* Messaging */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 7cc81b453bd7..49835e878bbb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -671,7 +671,8 @@ static int enetc_get_ts_info(struct net_device *ndev,
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

