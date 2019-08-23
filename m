Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868CD9B334
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 17:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394286AbfHWPTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 11:19:45 -0400
Received: from inva021.nxp.com ([92.121.34.21]:47978 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390470AbfHWPTo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 11:19:44 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 90B2A200740;
        Fri, 23 Aug 2019 17:19:40 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 81942200159;
        Fri, 23 Aug 2019 17:19:40 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 48F51205D9;
        Fri, 23 Aug 2019 17:19:40 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next] dpaa2-eth: Add pause frame support
Date:   Fri, 23 Aug 2019 18:19:39 +0300
Message-Id: <1566573579-9940-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with firmware version MC10.18.0, we have support for
L2 flow control. Asymmetrical configuration (Rx or Tx only) is
supported, but not pause frame autonegotioation.

The hardware can automatically send pause frames when the number
of buffers in the pool goes below a predefined threshold. Due to
this, flow control is incompatible with Rx frame queue taildrop
(both mechanisms target the case when processing of ingress
frames can't keep up with the Rx rate; for large frames, the number
of buffers in the pool may never get low enough to trigger pause
frames as long as taildrop is enabled). So we set pause frame
generation and Rx FQ taildrop as mutually exclusive.

Pause frame configuration is done via ethtool. By default, we start
with flow control enabled on both Rx and Tx. Changes are propagated
to hardware through firmware commands; current FC state is stored
in the driver and we only interrogate the firmware when we receive
a notification that something (flow control or other link options)
has changed.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   | 85 +++++++++++++++++++---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  7 ++
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   | 74 +++++++++++++++----
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h    |  3 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c        | 40 +++++++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.h        |  5 ++
 6 files changed, 186 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 0acb115..e0816d6 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1208,9 +1208,37 @@ static void disable_ch_napi(struct dpaa2_eth_priv *priv)
 	}
 }
 
+static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv, bool enable)
+{
+	struct dpni_taildrop td = {0};
+	int i, err;
+
+	if (priv->rx_td_enabled == enable)
+		return;
+
+	td.enable = enable;
+	td.threshold = DPAA2_ETH_TAILDROP_THRESH;
+
+	for (i = 0; i < priv->num_fqs; i++) {
+		if (priv->fq[i].type != DPAA2_RX_FQ)
+			continue;
+		err = dpni_set_taildrop(priv->mc_io, 0, priv->mc_token,
+					DPNI_CP_QUEUE, DPNI_QUEUE_RX, 0,
+					priv->fq[i].flowid, &td);
+		if (err) {
+			netdev_err(priv->net_dev,
+				   "dpni_set_taildrop() failed\n");
+			break;
+		}
+	}
+
+	priv->rx_td_enabled = enable;
+}
+
 static int link_state_update(struct dpaa2_eth_priv *priv)
 {
 	struct dpni_link_state state = {0};
+	bool tx_pause;
 	int err;
 
 	err = dpni_get_link_state(priv->mc_io, 0, priv->mc_token, &state);
@@ -1220,11 +1248,18 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
 		return err;
 	}
 
+	/* If Tx pause frame settings have changed, we need to update
+	 * Rx FQ taildrop configuration as well. We configure taildrop
+	 * only when pause frame generation is disabled.
+	 */
+	tx_pause = !!(state.options & DPNI_LINK_OPT_PAUSE) ^
+		   !!(state.options & DPNI_LINK_OPT_ASYM_PAUSE);
+	dpaa2_eth_set_rx_taildrop(priv, !tx_pause);
+
 	/* Chech link state; speed / duplex changes are not treated yet */
 	if (priv->link_state.up == state.up)
-		return 0;
+		goto out;
 
-	priv->link_state = state;
 	if (state.up) {
 		netif_carrier_on(priv->net_dev);
 		netif_tx_start_all_queues(priv->net_dev);
@@ -1236,6 +1271,9 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
 	netdev_info(priv->net_dev, "Link Event: state %s\n",
 		    state.up ? "up" : "down");
 
+out:
+	priv->link_state = state;
+
 	return 0;
 }
 
@@ -2443,6 +2481,32 @@ static void set_enqueue_mode(struct dpaa2_eth_priv *priv)
 		priv->enqueue = dpaa2_eth_enqueue_fq;
 }
 
+static int set_pause(struct dpaa2_eth_priv *priv)
+{
+	struct device *dev = priv->net_dev->dev.parent;
+	struct dpni_link_cfg link_cfg = {0};
+	int err;
+
+	/* Get the default link options so we don't override other flags */
+	err = dpni_get_link_cfg(priv->mc_io, 0, priv->mc_token, &link_cfg);
+	if (err) {
+		dev_err(dev, "dpni_get_link_cfg() failed\n");
+		return err;
+	}
+
+	link_cfg.options |= DPNI_LINK_OPT_PAUSE;
+	link_cfg.options &= ~DPNI_LINK_OPT_ASYM_PAUSE;
+	err = dpni_set_link_cfg(priv->mc_io, 0, priv->mc_token, &link_cfg);
+	if (err) {
+		dev_err(dev, "dpni_set_link_cfg() failed\n");
+		return err;
+	}
+
+	priv->link_state.options = link_cfg.options;
+
+	return 0;
+}
+
 /* Configure the DPNI object this interface is associated with */
 static int setup_dpni(struct fsl_mc_device *ls_dev)
 {
@@ -2498,6 +2562,13 @@ static int setup_dpni(struct fsl_mc_device *ls_dev)
 
 	set_enqueue_mode(priv);
 
+	/* Enable pause frame support */
+	if (dpaa2_eth_has_pause_support(priv)) {
+		err = set_pause(priv);
+		if (err)
+			goto close;
+	}
+
 	priv->cls_rules = devm_kzalloc(dev, sizeof(struct dpaa2_eth_cls_rule) *
 				       dpaa2_eth_fs_count(priv), GFP_KERNEL);
 	if (!priv->cls_rules)
@@ -2529,7 +2600,6 @@ static int setup_rx_flow(struct dpaa2_eth_priv *priv,
 	struct device *dev = priv->net_dev->dev.parent;
 	struct dpni_queue queue;
 	struct dpni_queue_id qid;
-	struct dpni_taildrop td;
 	int err;
 
 	err = dpni_get_queue(priv->mc_io, 0, priv->mc_token,
@@ -2554,15 +2624,6 @@ static int setup_rx_flow(struct dpaa2_eth_priv *priv,
 		return err;
 	}
 
-	td.enable = 1;
-	td.threshold = DPAA2_ETH_TAILDROP_THRESH;
-	err = dpni_set_taildrop(priv->mc_io, 0, priv->mc_token, DPNI_CP_QUEUE,
-				DPNI_QUEUE_RX, 0, fq->flowid, &td);
-	if (err) {
-		dev_err(dev, "dpni_set_threshold() failed\n");
-		return err;
-	}
-
 	/* xdp_rxq setup */
 	err = xdp_rxq_info_reg(&fq->channel->xdp_rxq, priv->net_dev,
 			       fq->flowid);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 9af18c2..8a0e65b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -392,6 +392,7 @@ struct dpaa2_eth_priv {
 	struct dpaa2_eth_drv_stats __percpu *percpu_extras;
 
 	u16 mc_token;
+	u8 rx_td_enabled;
 
 	struct dpni_link_state link_state;
 	bool do_link_poll;
@@ -476,6 +477,12 @@ enum dpaa2_eth_rx_dist {
 #define DPAA2_ETH_DIST_L4DST		BIT(8)
 #define DPAA2_ETH_DIST_ALL		(~0ULL)
 
+#define DPNI_PAUSE_VER_MAJOR		7
+#define DPNI_PAUSE_VER_MINOR		13
+#define dpaa2_eth_has_pause_support(priv)			\
+	(dpaa2_eth_cmp_dpni_ver((priv), DPNI_PAUSE_VER_MAJOR,	\
+				DPNI_PAUSE_VER_MINOR) >= 0)
+
 static inline
 unsigned int dpaa2_eth_needed_headroom(struct dpaa2_eth_priv *priv,
 				       struct sk_buff *skb)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 7b182f4..7000638 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -78,29 +78,20 @@ static int
 dpaa2_eth_get_link_ksettings(struct net_device *net_dev,
 			     struct ethtool_link_ksettings *link_settings)
 {
-	struct dpni_link_state state = {0};
-	int err = 0;
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
-	err = dpni_get_link_state(priv->mc_io, 0, priv->mc_token, &state);
-	if (err) {
-		netdev_err(net_dev, "ERROR %d getting link state\n", err);
-		goto out;
-	}
-
 	/* At the moment, we have no way of interrogating the DPMAC
 	 * from the DPNI side - and for that matter there may exist
 	 * no DPMAC at all. So for now we just don't report anything
 	 * beyond the DPNI attributes.
 	 */
-	if (state.options & DPNI_LINK_OPT_AUTONEG)
+	if (priv->link_state.options & DPNI_LINK_OPT_AUTONEG)
 		link_settings->base.autoneg = AUTONEG_ENABLE;
-	if (!(state.options & DPNI_LINK_OPT_HALF_DUPLEX))
+	if (!(priv->link_state.options & DPNI_LINK_OPT_HALF_DUPLEX))
 		link_settings->base.duplex = DUPLEX_FULL;
-	link_settings->base.speed = state.rate;
+	link_settings->base.speed = priv->link_state.rate;
 
-out:
-	return err;
+	return 0;
 }
 
 #define DPNI_DYNAMIC_LINK_SET_VER_MAJOR		7
@@ -125,6 +116,9 @@ dpaa2_eth_set_link_ksettings(struct net_device *net_dev,
 		}
 	}
 
+	/* Make sure current options are not overwritten */
+	cfg.options = priv->link_state.options;
+
 	cfg.rate = link_settings->base.speed;
 	if (link_settings->base.autoneg == AUTONEG_ENABLE)
 		cfg.options |= DPNI_LINK_OPT_AUTONEG;
@@ -145,6 +139,58 @@ dpaa2_eth_set_link_ksettings(struct net_device *net_dev,
 	return err;
 }
 
+static void dpaa2_eth_get_pauseparam(struct net_device *net_dev,
+				     struct ethtool_pauseparam *pause)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	u64 link_options = priv->link_state.options;
+
+	pause->rx_pause = !!(link_options & DPNI_LINK_OPT_PAUSE);
+	pause->tx_pause = pause->rx_pause ^
+			  !!(link_options & DPNI_LINK_OPT_ASYM_PAUSE);
+}
+
+static int dpaa2_eth_set_pauseparam(struct net_device *net_dev,
+				    struct ethtool_pauseparam *pause)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	struct dpni_link_cfg cfg = {0};
+	int err;
+
+	if (!dpaa2_eth_has_pause_support(priv)) {
+		netdev_info(net_dev, "No pause frame support for DPNI version < %d.%d\n",
+			    DPNI_PAUSE_VER_MAJOR, DPNI_PAUSE_VER_MINOR);
+		return -EOPNOTSUPP;
+	}
+
+	if (pause->autoneg)
+		netdev_err(net_dev, "Pause frame autoneg not supported\n");
+
+	cfg.rate = priv->link_state.rate;
+	cfg.options = priv->link_state.options;
+	if (pause->rx_pause)
+		cfg.options |= DPNI_LINK_OPT_PAUSE;
+	else
+		cfg.options &= ~DPNI_LINK_OPT_PAUSE;
+	if (!!pause->rx_pause ^ !!pause->tx_pause)
+		cfg.options |= DPNI_LINK_OPT_ASYM_PAUSE;
+	else
+		cfg.options &= ~DPNI_LINK_OPT_ASYM_PAUSE;
+
+	if (cfg.options == priv->link_state.options)
+		return 0;
+
+	err = dpni_set_link_cfg(priv->mc_io, 0, priv->mc_token, &cfg);
+	if (err) {
+		netdev_err(net_dev, "dpni_set_link_state failed\n");
+		return err;
+	}
+
+	priv->link_state.options = cfg.options;
+
+	return 0;
+}
+
 static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 				  u8 *data)
 {
@@ -722,6 +768,8 @@ const struct ethtool_ops dpaa2_ethtool_ops = {
 	.get_link = ethtool_op_get_link,
 	.get_link_ksettings = dpaa2_eth_get_link_ksettings,
 	.set_link_ksettings = dpaa2_eth_set_link_ksettings,
+	.get_pauseparam = dpaa2_eth_get_pauseparam,
+	.set_pauseparam = dpaa2_eth_set_pauseparam,
 	.get_sset_count = dpaa2_eth_get_sset_count,
 	.get_ethtool_stats = dpaa2_eth_get_ethtool_stats,
 	.get_strings = dpaa2_eth_get_strings,
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 7b44d7d..d9b6918 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -84,6 +84,7 @@
 
 #define DPNI_CMDID_SET_RX_FS_DIST			DPNI_CMD(0x273)
 #define DPNI_CMDID_SET_RX_HASH_DIST			DPNI_CMD(0x274)
+#define DPNI_CMDID_GET_LINK_CFG				DPNI_CMD(0x278)
 
 /* Macros for accessing command fields smaller than 1byte */
 #define DPNI_MASK(field)	\
@@ -284,7 +285,7 @@ struct dpni_rsp_get_statistics {
 	__le64 counter[DPNI_STATISTICS_CNT];
 };
 
-struct dpni_cmd_set_link_cfg {
+struct dpni_cmd_link_cfg {
 	/* cmd word 0 */
 	__le64 pad0;
 	/* cmd word 1 */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 220dfc8..05e3089 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -838,13 +838,13 @@ int dpni_set_link_cfg(struct fsl_mc_io *mc_io,
 		      const struct dpni_link_cfg *cfg)
 {
 	struct fsl_mc_command cmd = { 0 };
-	struct dpni_cmd_set_link_cfg *cmd_params;
+	struct dpni_cmd_link_cfg *cmd_params;
 
 	/* prepare command */
 	cmd.header = mc_encode_cmd_header(DPNI_CMDID_SET_LINK_CFG,
 					  cmd_flags,
 					  token);
-	cmd_params = (struct dpni_cmd_set_link_cfg *)cmd.params;
+	cmd_params = (struct dpni_cmd_link_cfg *)cmd.params;
 	cmd_params->rate = cpu_to_le32(cfg->rate);
 	cmd_params->options = cpu_to_le64(cfg->options);
 
@@ -853,6 +853,42 @@ int dpni_set_link_cfg(struct fsl_mc_io *mc_io,
 }
 
 /**
+ * dpni_get_link_cfg() - return the link configuration
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPNI object
+ * @cfg:	Link configuration from dpni object
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpni_get_link_cfg(struct fsl_mc_io *mc_io,
+		      u32 cmd_flags,
+		      u16 token,
+		      struct dpni_link_cfg *cfg)
+{
+	struct fsl_mc_command cmd = { 0 };
+	struct dpni_cmd_link_cfg *rsp_params;
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPNI_CMDID_GET_LINK_CFG,
+					  cmd_flags,
+					  token);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
+	rsp_params = (struct dpni_cmd_link_cfg *)cmd.params;
+	cfg->rate = le32_to_cpu(rsp_params->rate);
+	cfg->options = le64_to_cpu(rsp_params->options);
+
+	return err;
+}
+
+/**
  * dpni_get_link_state() - Return the link state (either up or down)
  * @mc_io:	Pointer to MC portal's I/O object
  * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index a521242..3e8fc6c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -485,6 +485,11 @@ int dpni_set_link_cfg(struct fsl_mc_io			*mc_io,
 		      u16				token,
 		      const struct dpni_link_cfg	*cfg);
 
+int dpni_get_link_cfg(struct fsl_mc_io			*mc_io,
+		      u32				cmd_flags,
+		      u16				token,
+		      struct dpni_link_cfg		*cfg);
+
 /**
  * struct dpni_link_state - Structure representing DPNI link state
  * @rate: Rate
-- 
2.7.4

