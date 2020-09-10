Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCCD2643EA
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 12:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730889AbgIJKZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 06:25:42 -0400
Received: from inva021.nxp.com ([92.121.34.21]:52870 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730770AbgIJKZH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 06:25:07 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8FDCD2005C7;
        Thu, 10 Sep 2020 12:25:01 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 50B1B200778;
        Thu, 10 Sep 2020 12:24:58 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 2F8A2402F0;
        Thu, 10 Sep 2020 12:24:54 +0200 (CEST)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [v2, 5/5] dpaa2-eth: support PTP Sync packet one-step timestamping
Date:   Thu, 10 Sep 2020 18:16:55 +0800
Message-Id: <20200910101655.13904-6-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910101655.13904-1-yangbo.lu@nxp.com>
References: <20200910101655.13904-1-yangbo.lu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add PTP sync packet one-step timestamping support.
Before egress, one-step timestamping enablement needs,

- Enabling timestamp and FAS (Frame Annotation Status) in
  dpni buffer layout.

- Write timestamp to frame annotation and set PTP bit in
  FAS to mark as one-step timestamping event.

- Enabling one-step timestamping by dpni_set_single_step_cfg()
  API, with offset provided to insert correction time on frame.
  The offset must respect all MAC headers, VLAN tags and other
  protocol headers accordingly. The correction field update can
  consider delays up to one second. So PTP frame needs to be
  filtered and parsed, and written timestamp into Sync frame
  originTimestamp field.

The operation of API dpni_set_single_step_cfg() has to be done
when no one-step timestamping frames are in flight. So we have
to make sure the last one-step timestamping frame has already
been transmitted on hardware before starting to send the current
one. The resolution is,

- Utilize skb->cb[0] to mark timestamping request per packet.
  If it is one-step timestamping PTP sync packet, queue to skb queue.
  If not, transmit immediately.

- Schedule a work to transmit skbs in skb queue.

- mutex lock is used to ensure the last one-step timestamping packet
  has already been transmitted on hardware through TX confirmation queue
  before transmitting current packet.

Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
---
Changes for v2:
	- None.
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 206 +++++++++++++++++++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  32 +++-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |   4 +-
 3 files changed, 226 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index eab9470..e54381c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -15,6 +15,7 @@
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <linux/fsl/ptp_qoriq.h>
+#include <linux/ptp_classify.h>
 #include <net/pkt_cls.h>
 #include <net/sock.h>
 
@@ -563,11 +564,72 @@ static int dpaa2_eth_consume_frames(struct dpaa2_eth_channel *ch,
 	return cleaned;
 }
 
+static int dpaa2_eth_ptp_parse(struct sk_buff *skb, u8 *msg_type, u8 *two_step,
+			       u8 *udp, u16 *correction_offset,
+			       u16 *origin_timestamp_offset)
+{
+	unsigned int ptp_class;
+	u16 offset = 0;
+	u8 *data;
+
+	data = skb_mac_header(skb);
+	ptp_class = ptp_classify_raw(skb);
+
+	switch (ptp_class & PTP_CLASS_VMASK) {
+	case PTP_CLASS_V1:
+	case PTP_CLASS_V2:
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	if (ptp_class & PTP_CLASS_VLAN)
+		offset += VLAN_HLEN;
+
+	switch (ptp_class & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
+		*udp = 1;
+		break;
+	case PTP_CLASS_IPV6:
+		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
+		*udp = 1;
+		break;
+	case PTP_CLASS_L2:
+		offset += ETH_HLEN;
+		*udp = 0;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	/* PTP header is 34 bytes. */
+	if (skb->len < offset + 34)
+		return -EINVAL;
+
+	*msg_type = data[offset] & 0x0f;
+	*two_step = data[offset + 6] & 0x2;
+	*correction_offset = offset + 8;
+	*origin_timestamp_offset = offset + 34;
+	return 0;
+}
+
 /* Configure the egress frame annotation for timestamp update */
-static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_fd *fd, void *buf_start)
+static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
+				       struct dpaa2_fd *fd,
+				       void *buf_start,
+				       struct sk_buff *skb)
 {
+	struct ptp_tstamp origin_timestamp;
+	struct dpni_single_step_cfg cfg;
+	u8 msg_type, two_step, udp;
 	struct dpaa2_faead *faead;
+	struct dpaa2_fas *fas;
+	struct timespec64 ts;
+	u16 offset1, offset2;
 	u32 ctrl, frc;
+	__le64 *ns;
+	u8 *data;
 
 	/* Mark the egress frame annotation area as valid */
 	frc = dpaa2_fd_get_frc(fd);
@@ -583,6 +645,58 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_fd *fd, void *buf_start)
 	ctrl = DPAA2_FAEAD_A2V | DPAA2_FAEAD_UPDV | DPAA2_FAEAD_UPD;
 	faead = dpaa2_get_faead(buf_start, true);
 	faead->ctrl = cpu_to_le32(ctrl);
+
+	if (skb->cb[0] == TX_TSTAMP_ONESTEP_SYNC) {
+		if (dpaa2_eth_ptp_parse(skb, &msg_type, &two_step, &udp,
+					&offset1, &offset2)) {
+			netdev_err(priv->net_dev,
+				   "bad packet for one-step timestamping\n");
+			return;
+		}
+
+		if (msg_type != 0 || two_step) {
+			netdev_err(priv->net_dev,
+				   "bad packet for one-step timestamping\n");
+			return;
+		}
+
+		/* Mark the frame annotation status as valid */
+		frc = dpaa2_fd_get_frc(fd);
+		dpaa2_fd_set_frc(fd, frc | DPAA2_FD_FRC_FASV);
+
+		/* Mark the PTP flag for one step timestamping */
+		fas = dpaa2_get_fas(buf_start, true);
+		fas->status = cpu_to_le32(DPAA2_FAS_PTP);
+
+		/* Write current time to FA timestamp field */
+		if (!dpaa2_ptp) {
+			netdev_err(priv->net_dev,
+				   "ptp driver may not loaded for one-step timestamping\n");
+			return;
+		}
+		dpaa2_ptp->caps.gettime64(&dpaa2_ptp->caps, &ts);
+		ns = dpaa2_get_ts(buf_start, true);
+		*ns = cpu_to_le64(timespec64_to_ns(&ts) /
+				  DPAA2_PTP_CLK_PERIOD_NS);
+
+		/* Update current time to PTP message originTimestamp field */
+		ns_to_ptp_tstamp(&origin_timestamp, le64_to_cpup(ns));
+		data = skb_mac_header(skb);
+		*(__be16 *)(data + offset2) = htons(origin_timestamp.sec_msb);
+		*(__be32 *)(data + offset2 + 2) =
+			htonl(origin_timestamp.sec_lsb);
+		*(__be32 *)(data + offset2 + 6) = htonl(origin_timestamp.nsec);
+
+		cfg.en = 1;
+		cfg.ch_update = udp;
+		cfg.offset = offset1;
+		cfg.peer_delay = 0;
+
+		if (dpni_set_single_step_cfg(priv->mc_io, 0, priv->mc_token,
+					     &cfg))
+			netdev_err(priv->net_dev,
+				   "dpni_set_single_step_cfg failed\n");
+	}
 }
 
 /* Create a frame descriptor based on a fragmented skb */
@@ -820,7 +934,7 @@ static int dpaa2_eth_build_single_fd(struct dpaa2_eth_priv *priv,
  * This can be called either from dpaa2_eth_tx_conf() or on the error path of
  * dpaa2_eth_tx().
  */
-static void dpaa2_eth_free_tx_fd(const struct dpaa2_eth_priv *priv,
+static void dpaa2_eth_free_tx_fd(struct dpaa2_eth_priv *priv,
 				 struct dpaa2_eth_fq *fq,
 				 const struct dpaa2_fd *fd, bool in_napi)
 {
@@ -903,6 +1017,8 @@ static void dpaa2_eth_free_tx_fd(const struct dpaa2_eth_priv *priv,
 		ns = DPAA2_PTP_CLK_PERIOD_NS * le64_to_cpup(ts);
 		shhwtstamps.hwtstamp = ns_to_ktime(ns);
 		skb_tstamp_tx(skb, &shhwtstamps);
+	} else if (skb->cb[0] == TX_TSTAMP_ONESTEP_SYNC) {
+		mutex_unlock(&priv->onestep_tstamp_lock);
 	}
 
 	/* Free SGT buffer allocated on tx */
@@ -922,7 +1038,8 @@ static void dpaa2_eth_free_tx_fd(const struct dpaa2_eth_priv *priv,
 	napi_consume_skb(skb, in_napi);
 }
 
-static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
+static netdev_tx_t __dpaa2_eth_tx(struct sk_buff *skb,
+				  struct net_device *net_dev)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	struct dpaa2_fd fd;
@@ -937,13 +1054,6 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	int err, i;
 	void *swa;
 
-	/* Utilize skb->cb[0] for timestamping request per skb */
-	skb->cb[0] = 0;
-
-	if (priv->tx_tstamp_type == HWTSTAMP_TX_ON &&
-	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
-		skb->cb[0] = TX_TSTAMP;
-
 	percpu_stats = this_cpu_ptr(priv->percpu_stats);
 	percpu_extras = this_cpu_ptr(priv->percpu_extras);
 
@@ -981,8 +1091,8 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 		goto err_build_fd;
 	}
 
-	if (skb->cb[0] == TX_TSTAMP)
-		dpaa2_eth_enable_tx_tstamp(&fd, swa);
+	if (skb->cb[0])
+		dpaa2_eth_enable_tx_tstamp(priv, &fd, swa, skb);
 
 	/* Tracing point */
 	trace_dpaa2_tx_fd(net_dev, &fd);
@@ -1037,6 +1147,58 @@ static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
 	return NETDEV_TX_OK;
 }
 
+static void dpaa2_eth_tx_onestep_tstamp(struct work_struct *work)
+{
+	struct dpaa2_eth_priv *priv = container_of(work, struct dpaa2_eth_priv,
+						   tx_onestep_tstamp);
+	struct sk_buff *skb;
+
+	while (true) {
+		skb = skb_dequeue(&priv->tx_skbs);
+		if (!skb)
+			return;
+
+		mutex_lock(&priv->onestep_tstamp_lock);
+		__dpaa2_eth_tx(skb, priv->net_dev);
+	}
+}
+
+static netdev_tx_t dpaa2_eth_tx(struct sk_buff *skb, struct net_device *net_dev)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	u8 msg_type, two_step, udp;
+	u16 offset1, offset2;
+
+	/* Utilize skb->cb[0] for timestamping request per skb */
+	skb->cb[0] = 0;
+
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+		if (priv->tx_tstamp_type == HWTSTAMP_TX_ON)
+			skb->cb[0] = TX_TSTAMP;
+		else if (priv->tx_tstamp_type == HWTSTAMP_TX_ONESTEP_SYNC)
+			skb->cb[0] = TX_TSTAMP_ONESTEP_SYNC;
+	}
+
+	/* TX for one-step timestamping PTP Sync packet */
+	if (skb->cb[0] == TX_TSTAMP_ONESTEP_SYNC) {
+		if (!dpaa2_eth_ptp_parse(skb, &msg_type, &two_step, &udp,
+					 &offset1, &offset2))
+			if (msg_type == 0 && two_step == 0) {
+				skb_queue_tail(&priv->tx_skbs, skb);
+				queue_work(priv->dpaa2_ptp_wq,
+					   &priv->tx_onestep_tstamp);
+				return NETDEV_TX_OK;
+			}
+		/* Use two-step timestamping if not one-step timestamping
+		 * PTP Sync packet
+		 */
+		skb->cb[0] = TX_TSTAMP;
+	}
+
+	/* TX for other packets */
+	return __dpaa2_eth_tx(skb, net_dev);
+}
+
 /* Tx confirmation frame processing routine */
 static void dpaa2_eth_tx_conf(struct dpaa2_eth_priv *priv,
 			      struct dpaa2_eth_channel *ch __always_unused,
@@ -1906,6 +2068,7 @@ static int dpaa2_eth_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
 	case HWTSTAMP_TX_ON:
+	case HWTSTAMP_TX_ONESTEP_SYNC:
 		priv->tx_tstamp_type = config.tx_type;
 		break;
 	default:
@@ -2731,8 +2894,10 @@ static int dpaa2_eth_set_buffer_layout(struct dpaa2_eth_priv *priv)
 	/* tx buffer */
 	buf_layout.private_data_size = DPAA2_ETH_SWA_SIZE;
 	buf_layout.pass_timestamp = true;
+	buf_layout.pass_frame_status = true;
 	buf_layout.options = DPNI_BUF_LAYOUT_OPT_PRIVATE_DATA_SIZE |
-			     DPNI_BUF_LAYOUT_OPT_TIMESTAMP;
+			     DPNI_BUF_LAYOUT_OPT_TIMESTAMP |
+			     DPNI_BUF_LAYOUT_OPT_FRAME_STATUS;
 	err = dpni_set_buffer_layout(priv->mc_io, 0, priv->mc_token,
 				     DPNI_QUEUE_TX, &buf_layout);
 	if (err) {
@@ -2741,7 +2906,8 @@ static int dpaa2_eth_set_buffer_layout(struct dpaa2_eth_priv *priv)
 	}
 
 	/* tx-confirm buffer */
-	buf_layout.options = DPNI_BUF_LAYOUT_OPT_TIMESTAMP;
+	buf_layout.options = DPNI_BUF_LAYOUT_OPT_TIMESTAMP |
+			     DPNI_BUF_LAYOUT_OPT_FRAME_STATUS;
 	err = dpni_set_buffer_layout(priv->mc_io, 0, priv->mc_token,
 				     DPNI_QUEUE_TX_CONFIRM, &buf_layout);
 	if (err) {
@@ -3969,6 +4135,16 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	priv->tx_tstamp_type = HWTSTAMP_TX_OFF;
 	priv->rx_tstamp = false;
 
+	priv->dpaa2_ptp_wq = alloc_workqueue("dpaa2_ptp_wq", 0, 0);
+	if (!priv->dpaa2_ptp_wq) {
+		err = -ENOMEM;
+		goto err_wq_alloc;
+	}
+
+	INIT_WORK(&priv->tx_onestep_tstamp, dpaa2_eth_tx_onestep_tstamp);
+
+	skb_queue_head_init(&priv->tx_skbs);
+
 	/* Obtain a MC portal */
 	err = fsl_mc_portal_allocate(dpni_dev, FSL_MC_IO_ATOMIC_CONTEXT_PORTAL,
 				     &priv->mc_io);
@@ -4107,6 +4283,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 err_dpni_setup:
 	fsl_mc_portal_free(priv->mc_io);
 err_portal_alloc:
+	destroy_workqueue(priv->dpaa2_ptp_wq);
+err_wq_alloc:
 	dev_set_drvdata(dev, NULL);
 	free_netdev(net_dev);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 57e6e6e..c5a8e38 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -195,6 +195,24 @@ struct dpaa2_faead {
 #define DPAA2_FAEAD_EBDDV		0x00002000
 #define DPAA2_FAEAD_UPD			0x00000010
 
+struct ptp_tstamp {
+	u16 sec_msb;
+	u32 sec_lsb;
+	u32 nsec;
+};
+
+static inline void ns_to_ptp_tstamp(struct ptp_tstamp *tstamp, u64 ns)
+{
+	u64 sec, nsec;
+
+	sec = ns / 1000000000ULL;
+	nsec = ns % 1000000000ULL;
+
+	tstamp->sec_lsb = sec & 0xFFFFFFFF;
+	tstamp->sec_msb = (sec >> 32) & 0xFFFF;
+	tstamp->nsec = nsec;
+}
+
 /* Accessors for the hardware annotation fields that we use */
 static inline void *dpaa2_get_hwa(void *buf_addr, bool swa)
 {
@@ -474,9 +492,21 @@ struct dpaa2_eth_priv {
 #endif
 
 	struct dpaa2_mac *mac;
+	struct workqueue_struct	*dpaa2_ptp_wq;
+	struct work_struct	tx_onestep_tstamp;
+	struct sk_buff_head	tx_skbs;
+	/* The one-step timestamping configuration on hardware
+	 * registers could only be done when no one-step
+	 * timestamping frames are in flight. So we use a mutex
+	 * lock here to make sure the lock is released by last
+	 * one-step timestamping packet through TX confirmation
+	 * queue before transmit current packet.
+	 */
+	struct mutex		onestep_tstamp_lock;
 };
 
 #define TX_TSTAMP		0x1
+#define TX_TSTAMP_ONESTEP_SYNC	0x2
 
 #define DPAA2_RXH_SUPPORTED	(RXH_L2DA | RXH_VLAN | RXH_L3_PROTO \
 				| RXH_IP_SRC | RXH_IP_DST | RXH_L4_B_0_1 \
@@ -580,7 +610,7 @@ static inline unsigned int dpaa2_eth_needed_headroom(struct sk_buff *skb)
 		return 0;
 
 	/* If we have Tx timestamping, need 128B hardware annotation */
-	if (skb->cb[0] == TX_TSTAMP)
+	if (skb->cb[0])
 		headroom += DPAA2_ETH_TX_HWA_SIZE;
 
 	return headroom;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 26bd99b..bf3baf6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
 /* Copyright 2014-2016 Freescale Semiconductor Inc.
  * Copyright 2016 NXP
+ * Copyright 2020 NXP
  */
 
 #include <linux/net_tstamp.h>
@@ -770,7 +771,8 @@ static int dpaa2_eth_get_ts_info(struct net_device *dev,
 	info->phc_index = dpaa2_phc_index;
 
 	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
-			 (1 << HWTSTAMP_TX_ON);
+			 (1 << HWTSTAMP_TX_ON) |
+			 (1 << HWTSTAMP_TX_ONESTEP_SYNC);
 
 	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
 			   (1 << HWTSTAMP_FILTER_ALL);
-- 
2.7.4

