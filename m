Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E031E93D2
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgE3VIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:08:39 -0400
Received: from inva021.nxp.com ([92.121.34.21]:60824 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728741AbgE3VIi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 17:08:38 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0432A2013B9;
        Sat, 30 May 2020 23:08:36 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id EBDFE2013B7;
        Sat, 30 May 2020 23:08:35 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B5F17203C0;
        Sat, 30 May 2020 23:08:35 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 7/7] dpaa2-eth: Keep congestion group taildrop enabled when PFC on
Date:   Sun, 31 May 2020 00:08:14 +0300
Message-Id: <20200530210814.348-8-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200530210814.348-1-ioana.ciornei@nxp.com>
References: <20200530210814.348-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leave congestion group taildrop enabled for all traffic classes
when PFC is enabled. Notification threshold is low enough such
that it will be hit first and this also ensures that FQs on
traffic classes which are not PFC enabled won't drain the buffer
pool.

FQ taildrop threshold is kept disabled as long as any form of
flow control is on. Since FQ taildrop works with bytes, not number
of frames, we can't guarantee it will not interfere with the
congestion notification mechanism for all frame sizes.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v4:
 - none

 .../ethernet/freescale/dpaa2/dpaa2-eth-dcb.c  |  8 +++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 29 ++++++++++++++-----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  7 ++++-
 3 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c
index 7ee07872af4d..83dee575c2fa 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c
@@ -63,6 +63,7 @@ static int dpaa2_eth_dcbnl_ieee_setpfc(struct net_device *net_dev,
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	struct dpni_link_cfg link_cfg = {0};
+	bool tx_pause;
 	int err;
 
 	if (pfc->mbc || pfc->delay)
@@ -75,8 +76,8 @@ static int dpaa2_eth_dcbnl_ieee_setpfc(struct net_device *net_dev,
 	/* We allow PFC configuration even if it won't have any effect until
 	 * general pause frames are enabled
 	 */
-	if (!dpaa2_eth_rx_pause_enabled(priv->link_state.options) ||
-	    !dpaa2_eth_tx_pause_enabled(priv->link_state.options))
+	tx_pause = dpaa2_eth_tx_pause_enabled(priv->link_state.options);
+	if (!dpaa2_eth_rx_pause_enabled(priv->link_state.options) || !tx_pause)
 		netdev_warn(net_dev, "Pause support must be enabled in order for PFC to work!\n");
 
 	link_cfg.rate = priv->link_state.rate;
@@ -97,6 +98,9 @@ static int dpaa2_eth_dcbnl_ieee_setpfc(struct net_device *net_dev,
 		return err;
 
 	memcpy(&priv->pfc, pfc, sizeof(priv->pfc));
+	priv->pfc_enabled = !!pfc->pfc_en;
+
+	dpaa2_eth_set_rx_taildrop(priv, tx_pause, priv->pfc_enabled);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index cde9d0e2dd6d..8fb48de5d18c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1287,18 +1287,22 @@ static void disable_ch_napi(struct dpaa2_eth_priv *priv)
 	}
 }
 
-static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv,
-				      bool tx_pause)
+void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv,
+			       bool tx_pause, bool pfc)
 {
 	struct dpni_taildrop td = {0};
 	struct dpaa2_eth_fq *fq;
 	int i, err;
 
+	/* FQ taildrop: threshold is in bytes, per frame queue. Enabled if
+	 * flow control is disabled (as it might interfere with either the
+	 * buffer pool depletion trigger for pause frames or with the group
+	 * congestion trigger for PFC frames)
+	 */
 	td.enable = !tx_pause;
-	if (priv->rx_td_enabled == td.enable)
-		return;
+	if (priv->rx_fqtd_enabled == td.enable)
+		goto set_cgtd;
 
-	/* FQ taildrop: threshold is in bytes, per frame queue */
 	td.threshold = DPAA2_ETH_FQ_TAILDROP_THRESH;
 	td.units = DPNI_CONGESTION_UNIT_BYTES;
 
@@ -1316,9 +1320,20 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv,
 		}
 	}
 
+	priv->rx_fqtd_enabled = td.enable;
+
+set_cgtd:
 	/* Congestion group taildrop: threshold is in frames, per group
 	 * of FQs belonging to the same traffic class
+	 * Enabled if general Tx pause disabled or if PFCs are enabled
+	 * (congestion group threhsold for PFC generation is lower than the
+	 * CG taildrop threshold, so it won't interfere with it; we also
+	 * want frames in non-PFC enabled traffic classes to be kept in check)
 	 */
+	td.enable = !tx_pause || (tx_pause && pfc);
+	if (priv->rx_cgtd_enabled == td.enable)
+		return;
+
 	td.threshold = DPAA2_ETH_CG_TAILDROP_THRESH(priv);
 	td.units = DPNI_CONGESTION_UNIT_FRAMES;
 	for (i = 0; i < dpaa2_eth_tc_count(priv); i++) {
@@ -1332,7 +1347,7 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv,
 		}
 	}
 
-	priv->rx_td_enabled = td.enable;
+	priv->rx_cgtd_enabled = td.enable;
 }
 
 static int link_state_update(struct dpaa2_eth_priv *priv)
@@ -1353,7 +1368,7 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
 	 * only when pause frame generation is disabled.
 	 */
 	tx_pause = dpaa2_eth_tx_pause_enabled(state.options);
-	dpaa2_eth_set_rx_taildrop(priv, tx_pause);
+	dpaa2_eth_set_rx_taildrop(priv, tx_pause, priv->pfc_enabled);
 
 	/* When we manage the MAC/PHY using phylink there is no need
 	 * to manually update the netif_carrier.
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 31b7b9b52da0..2d7ada0f0dbd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -436,7 +436,8 @@ struct dpaa2_eth_priv {
 	struct dpaa2_eth_drv_stats __percpu *percpu_extras;
 
 	u16 mc_token;
-	u8 rx_td_enabled;
+	u8 rx_fqtd_enabled;
+	u8 rx_cgtd_enabled;
 
 	struct dpni_link_state link_state;
 	bool do_link_poll;
@@ -448,6 +449,7 @@ struct dpaa2_eth_priv {
 	struct dpaa2_eth_cls_rule *cls_rules;
 	u8 rx_cls_enabled;
 	u8 vlan_cls_enabled;
+	u8 pfc_enabled;
 #ifdef CONFIG_FSL_DPAA2_ETH_DCB
 	u8 dcbx_mode;
 	struct ieee_pfc pfc;
@@ -584,6 +586,9 @@ int dpaa2_eth_cls_key_size(u64 key);
 int dpaa2_eth_cls_fld_off(int prot, int field);
 void dpaa2_eth_cls_trim_rule(void *key_mem, u64 fields);
 
+void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv,
+			       bool tx_pause, bool pfc);
+
 extern const struct dcbnl_rtnl_ops dpaa2_eth_dcbnl_ops;
 
 #endif	/* __DPAA2_H */
-- 
2.17.1

