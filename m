Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECBC2B856
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 17:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfE0PVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 11:21:34 -0400
Received: from inva021.nxp.com ([92.121.34.21]:43722 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbfE0PVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 11:21:34 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 243E2200BCA;
        Mon, 27 May 2019 17:21:32 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 16D87200BC8;
        Mon, 27 May 2019 17:21:32 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D44F52060A;
        Mon, 27 May 2019 17:21:31 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next] enetc: Enable TC offloading with mqprio
Date:   Mon, 27 May 2019 18:21:31 +0300
Message-Id: <1558970491-15931-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Camelia Groza <camelia.groza@nxp.com>

Add support to configure multiple prioritized TX traffic
classes with mqprio.

Configure one BD ring per TC for the moment, one netdev
queue per TC.

Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 56 +++++++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h  |  3 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 12 +++-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  1 +
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  1 +
 5 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index d2ace299bed0..315957dff473 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1425,6 +1425,62 @@ int enetc_close(struct net_device *ndev)
 	return 0;
 }
 
+int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+		   void *type_data)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	struct tc_mqprio_qopt *mqprio = type_data;
+	struct enetc_bdr *tx_ring;
+	u8 num_tc;
+	int i;
+
+	if (type != TC_SETUP_QDISC_MQPRIO)
+		return -EOPNOTSUPP;
+
+	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
+	num_tc = mqprio->num_tc;
+
+	if (!num_tc) {
+		netdev_reset_tc(ndev);
+		netif_set_real_num_tx_queues(ndev, priv->num_tx_rings);
+
+		/* Reset all ring priorities to 0 */
+		for (i = 0; i < priv->num_tx_rings; i++) {
+			tx_ring = priv->tx_ring[i];
+			enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, 0);
+		}
+
+		return 0;
+	}
+
+	/* Check if we have enough BD rings available to accommodate all TCs */
+	if (num_tc > priv->num_tx_rings) {
+		netdev_err(ndev, "Max %d traffic classes supported\n",
+			   priv->num_tx_rings);
+		return -EINVAL;
+	}
+
+	/* For the moment, we use only one BD ring per TC.
+	 *
+	 * Configure num_tc BD rings with increasing priorities.
+	 */
+	for (i = 0; i < num_tc; i++) {
+		tx_ring = priv->tx_ring[i];
+		enetc_set_bdr_prio(&priv->si->hw, tx_ring->index, i);
+	}
+
+	/* Reset the number of netdev queues based on the TC count */
+	netif_set_real_num_tx_queues(ndev, num_tc);
+
+	netdev_set_num_tc(ndev, num_tc);
+
+	/* Each TC is associated with one netdev queue */
+	for (i = 0; i < num_tc; i++)
+		netdev_set_tc_queue(ndev, i, 1, i);
+
+	return 0;
+}
+
 struct net_device_stats *enetc_get_stats(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index ea443268bf70..541b4e2073fe 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -229,6 +229,9 @@ struct net_device_stats *enetc_get_stats(struct net_device *ndev);
 int enetc_set_features(struct net_device *ndev,
 		       netdev_features_t features);
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
+int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
+		   void *type_data);
+
 /* ethtool */
 void enetc_set_ethtool_ops(struct net_device *ndev);
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 6559cef4b07d..88276299f447 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -127,7 +127,7 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_TBSR_BUSY	BIT(0)
 #define ENETC_TBMR_VIH	BIT(9)
 #define ENETC_TBMR_PRIO_MASK		GENMASK(2, 0)
-#define ENETC_TBMR_PRIO_SET(val)	val
+#define ENETC_TBMR_SET_PRIO(val)	((val) & ENETC_TBMR_PRIO_MASK)
 #define ENETC_TBMR_EN	BIT(31)
 #define ENETC_TBSR	0x4
 #define ENETC_TBBAR0	0x10
@@ -544,3 +544,13 @@ static inline void enetc_enable_txvlan(struct enetc_hw *hw, int si_idx,
 	val = (val & ~ENETC_TBMR_VIH) | (en ? ENETC_TBMR_VIH : 0);
 	enetc_txbdr_wr(hw, si_idx, ENETC_TBMR, val);
 }
+
+static inline void enetc_set_bdr_prio(struct enetc_hw *hw, int bdr_idx,
+				      int prio)
+{
+	u32 val = enetc_txbdr_rd(hw, bdr_idx, ENETC_TBMR);
+
+	val &= ~ENETC_TBMR_PRIO_MASK;
+	val |= ENETC_TBMR_SET_PRIO(prio);
+	enetc_txbdr_wr(hw, bdr_idx, ENETC_TBMR, val);
+}
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index d78ec8d43c39..258b3cb38a6f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -703,6 +703,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_vf_spoofchk	= enetc_pf_set_vf_spoofchk,
 	.ndo_set_features	= enetc_pf_set_features,
 	.ndo_do_ioctl		= enetc_ioctl,
+	.ndo_setup_tc		= enetc_setup_tc,
 };
 
 static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 17f72644c5a1..ebd21bf4cfa1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -112,6 +112,7 @@ static const struct net_device_ops enetc_ndev_ops = {
 	.ndo_set_mac_address	= enetc_vf_set_mac_addr,
 	.ndo_set_features	= enetc_vf_set_features,
 	.ndo_do_ioctl		= enetc_ioctl,
+	.ndo_setup_tc		= enetc_setup_tc,
 };
 
 static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
-- 
2.17.1

