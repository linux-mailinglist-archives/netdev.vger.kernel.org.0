Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFF71FEE70
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 11:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgFRJQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 05:16:56 -0400
Received: from inva020.nxp.com ([92.121.34.13]:43510 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728406AbgFRJQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 05:16:55 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 7BA221A0EF4;
        Thu, 18 Jun 2020 11:16:53 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6F1A71A0031;
        Thu, 18 Jun 2020 11:16:53 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4A6622048B;
        Thu, 18 Jun 2020 11:16:53 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net] enetc: Fix HW_VLAN_CTAG_TX|RX toggling
Date:   Thu, 18 Jun 2020 12:16:52 +0300
Message-Id: <1592471812-13035-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VLAN tag insertion/extraction offload is correctly
activated at probe time but deactivation of this feature
(i.e. via ethtool) is broken.  Toggling works only for
Tx/Rx ring 0 of a PF, and is ignored for the other rings,
including the VF rings.
To fix this, the existing VLAN offload toggling code
was extended to all the rings assigned to a netdevice,
instead of the default ring 0 (likely a leftover from the
early validation days of this feature).  And the code was
moved to the common set_features() function to fix toggling
for the VF driver too.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c    | 26 +++++++++++++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 16 +++++++--------
 drivers/net/ethernet/freescale/enetc/enetc_pf.c |  8 --------
 3 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 298c557..96831f4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1595,6 +1595,24 @@ static int enetc_set_psfp(struct net_device *ndev, int en)
 	return 0;
 }
 
+static void enetc_enable_rxvlan(struct net_device *ndev, bool en)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int i;
+
+	for (i = 0; i < priv->num_rx_rings; i++)
+		enetc_bdr_enable_rxvlan(&priv->si->hw, i, en);
+}
+
+static void enetc_enable_txvlan(struct net_device *ndev, bool en)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int i;
+
+	for (i = 0; i < priv->num_tx_rings; i++)
+		enetc_bdr_enable_txvlan(&priv->si->hw, i, en);
+}
+
 int enetc_set_features(struct net_device *ndev,
 		       netdev_features_t features)
 {
@@ -1604,6 +1622,14 @@ int enetc_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_RXHASH)
 		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
 
+	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
+		enetc_enable_rxvlan(ndev,
+				    !!(features & NETIF_F_HW_VLAN_CTAG_RX));
+
+	if (changed & NETIF_F_HW_VLAN_CTAG_TX)
+		enetc_enable_txvlan(ndev,
+				    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
+
 	if (changed & NETIF_F_HW_TC)
 		err = enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 6314051..ce0d321 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -531,22 +531,22 @@ struct enetc_msg_cmd_header {
 
 /* Common H/W utility functions */
 
-static inline void enetc_enable_rxvlan(struct enetc_hw *hw, int si_idx,
-				       bool en)
+static inline void enetc_bdr_enable_rxvlan(struct enetc_hw *hw, int idx,
+					   bool en)
 {
-	u32 val = enetc_rxbdr_rd(hw, si_idx, ENETC_RBMR);
+	u32 val = enetc_rxbdr_rd(hw, idx, ENETC_RBMR);
 
 	val = (val & ~ENETC_RBMR_VTE) | (en ? ENETC_RBMR_VTE : 0);
-	enetc_rxbdr_wr(hw, si_idx, ENETC_RBMR, val);
+	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, val);
 }
 
-static inline void enetc_enable_txvlan(struct enetc_hw *hw, int si_idx,
-				       bool en)
+static inline void enetc_bdr_enable_txvlan(struct enetc_hw *hw, int idx,
+					   bool en)
 {
-	u32 val = enetc_txbdr_rd(hw, si_idx, ENETC_TBMR);
+	u32 val = enetc_txbdr_rd(hw, idx, ENETC_TBMR);
 
 	val = (val & ~ENETC_TBMR_VIH) | (en ? ENETC_TBMR_VIH : 0);
-	enetc_txbdr_wr(hw, si_idx, ENETC_TBMR, val);
+	enetc_txbdr_wr(hw, idx, ENETC_TBMR, val);
 }
 
 static inline void enetc_set_bdr_prio(struct enetc_hw *hw, int bdr_idx,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 824d211..4fac57d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -649,14 +649,6 @@ static int enetc_pf_set_features(struct net_device *ndev,
 	netdev_features_t changed = ndev->features ^ features;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 
-	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
-		enetc_enable_rxvlan(&priv->si->hw, 0,
-				    !!(features & NETIF_F_HW_VLAN_CTAG_RX));
-
-	if (changed & NETIF_F_HW_VLAN_CTAG_TX)
-		enetc_enable_txvlan(&priv->si->hw, 0,
-				    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
-
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		struct enetc_pf *pf = enetc_si_priv(priv->si);
 
-- 
2.7.4

