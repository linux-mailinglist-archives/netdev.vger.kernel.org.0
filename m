Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AF41E93D4
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgE3VIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:08:42 -0400
Received: from inva021.nxp.com ([92.121.34.21]:60802 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729392AbgE3VIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 17:08:40 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B41962013A4;
        Sat, 30 May 2020 23:08:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A7484200200;
        Sat, 30 May 2020 23:08:35 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 70F50203C0;
        Sat, 30 May 2020 23:08:35 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 6/7] dpaa2-eth: Add PFC support through DCB ops
Date:   Sun, 31 May 2020 00:08:13 +0300
Message-Id: <20200530210814.348-7-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200530210814.348-1-ioana.ciornei@nxp.com>
References: <20200530210814.348-1-ioana.ciornei@nxp.com>
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support in dpaa2-eth for PFC (Priority Flow Control)
through the DCB ops.

Instruct the hardware to respond to received PFC frames.
Current firmware doesn't allow us to selectively enable PFC
on the Rx side for some priorities only, so we will react to
all incoming PFC frames (and stop transmitting on the traffic
classes specified in the frame).

Also, configure the hardware to generate PFC frames based on Rx
congestion notifications. When a certain number of frames accumulate in
the ingress queues corresponding to a traffic class, priority flow
control frames are generated for that TC.

The number of PFC traffic classes available can be queried through
lldptool. Also, which of those traffic classes have PFC enabled is also
controlled through the same dcbnl_rtnl_ops callbacks.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v4:
 - none

 drivers/net/ethernet/freescale/dpaa2/Kconfig  |  10 ++
 drivers/net/ethernet/freescale/dpaa2/Makefile |   1 +
 .../ethernet/freescale/dpaa2/dpaa2-eth-dcb.c  | 146 ++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   9 ++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  18 +++
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   |  25 +++
 drivers/net/ethernet/freescale/dpaa2/dpni.c   |  46 ++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  61 ++++++++
 8 files changed, 316 insertions(+)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index c6fb8e4021ac..feea797cde02 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -9,6 +9,16 @@ config FSL_DPAA2_ETH
 	  The driver manages network objects discovered on the Freescale
 	  MC bus.
 
+if FSL_DPAA2_ETH
+config FSL_DPAA2_ETH_DCB
+	bool "Data Center Bridging (DCB) Support"
+	default n
+	depends on DCB
+	help
+	  Enable Priority-Based Flow Control (PFC) support for DPAA2 Ethernet
+	  devices.
+endif
+
 config FSL_DPAA2_PTP_CLOCK
 	tristate "Freescale DPAA2 PTP Clock"
 	depends on FSL_DPAA2_ETH && PTP_1588_CLOCK_QORIQ
diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/ethernet/freescale/dpaa2/Makefile
index 69184ca3b7b9..6e7f33c956bf 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Makefile
+++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_FSL_DPAA2_ETH)		+= fsl-dpaa2-eth.o
 obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)	+= fsl-dpaa2-ptp.o
 
 fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o
+fsl-dpaa2-eth-${CONFIG_FSL_DPAA2_ETH_DCB} += dpaa2-eth-dcb.o
 fsl-dpaa2-eth-${CONFIG_DEBUG_FS} += dpaa2-eth-debugfs.o
 fsl-dpaa2-ptp-objs	:= dpaa2-ptp.o dprtc.o
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c
new file mode 100644
index 000000000000..7ee07872af4d
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2020 NXP */
+
+#include "dpaa2-eth.h"
+
+static int dpaa2_eth_dcbnl_ieee_getpfc(struct net_device *net_dev,
+				       struct ieee_pfc *pfc)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+
+	if (!(priv->link_state.options & DPNI_LINK_OPT_PFC_PAUSE))
+		return 0;
+
+	memcpy(pfc, &priv->pfc, sizeof(priv->pfc));
+	pfc->pfc_cap = dpaa2_eth_tc_count(priv);
+
+	return 0;
+}
+
+static inline bool is_prio_enabled(u8 pfc_en, u8 tc)
+{
+	return !!(pfc_en & (1 << tc));
+}
+
+static int set_pfc_cn(struct dpaa2_eth_priv *priv, u8 pfc_en)
+{
+	struct dpni_congestion_notification_cfg cfg = {0};
+	int i, err;
+
+	cfg.notification_mode = DPNI_CONG_OPT_FLOW_CONTROL;
+	cfg.units = DPNI_CONGESTION_UNIT_FRAMES;
+	cfg.message_iova = 0ULL;
+	cfg.message_ctx = 0ULL;
+
+	for (i = 0; i < dpaa2_eth_tc_count(priv); i++) {
+		if (is_prio_enabled(pfc_en, i)) {
+			cfg.threshold_entry = DPAA2_ETH_CN_THRESH_ENTRY(priv);
+			cfg.threshold_exit = DPAA2_ETH_CN_THRESH_EXIT(priv);
+		} else {
+			/* For priorities not set in the pfc_en mask, we leave
+			 * the congestion thresholds at zero, which effectively
+			 * disables generation of PFC frames for them
+			 */
+			cfg.threshold_entry = 0;
+			cfg.threshold_exit = 0;
+		}
+
+		err = dpni_set_congestion_notification(priv->mc_io, 0,
+						       priv->mc_token,
+						       DPNI_QUEUE_RX, i, &cfg);
+		if (err) {
+			netdev_err(priv->net_dev,
+				   "dpni_set_congestion_notification failed\n");
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+static int dpaa2_eth_dcbnl_ieee_setpfc(struct net_device *net_dev,
+				       struct ieee_pfc *pfc)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	struct dpni_link_cfg link_cfg = {0};
+	int err;
+
+	if (pfc->mbc || pfc->delay)
+		return -EOPNOTSUPP;
+
+	/* If same PFC enabled mask, nothing to do */
+	if (priv->pfc.pfc_en == pfc->pfc_en)
+		return 0;
+
+	/* We allow PFC configuration even if it won't have any effect until
+	 * general pause frames are enabled
+	 */
+	if (!dpaa2_eth_rx_pause_enabled(priv->link_state.options) ||
+	    !dpaa2_eth_tx_pause_enabled(priv->link_state.options))
+		netdev_warn(net_dev, "Pause support must be enabled in order for PFC to work!\n");
+
+	link_cfg.rate = priv->link_state.rate;
+	link_cfg.options = priv->link_state.options;
+	if (pfc->pfc_en)
+		link_cfg.options |= DPNI_LINK_OPT_PFC_PAUSE;
+	else
+		link_cfg.options &= ~DPNI_LINK_OPT_PFC_PAUSE;
+	err = dpni_set_link_cfg(priv->mc_io, 0, priv->mc_token, &link_cfg);
+	if (err) {
+		netdev_err(net_dev, "dpni_set_link_cfg failed\n");
+		return err;
+	}
+
+	/* Configure congestion notifications for the enabled priorities */
+	err = set_pfc_cn(priv, pfc->pfc_en);
+	if (err)
+		return err;
+
+	memcpy(&priv->pfc, pfc, sizeof(priv->pfc));
+
+	return 0;
+}
+
+static u8 dpaa2_eth_dcbnl_getdcbx(struct net_device *net_dev)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+
+	return priv->dcbx_mode;
+}
+
+static u8 dpaa2_eth_dcbnl_setdcbx(struct net_device *net_dev, u8 mode)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+
+	return (mode != (priv->dcbx_mode)) ? 1 : 0;
+}
+
+static u8 dpaa2_eth_dcbnl_getcap(struct net_device *net_dev, int capid, u8 *cap)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+
+	switch (capid) {
+	case DCB_CAP_ATTR_PFC:
+		*cap = true;
+		break;
+	case DCB_CAP_ATTR_PFC_TCS:
+		*cap = 1 << (dpaa2_eth_tc_count(priv) - 1);
+		break;
+	case DCB_CAP_ATTR_DCBX:
+		*cap = priv->dcbx_mode;
+		break;
+	default:
+		*cap = false;
+		break;
+	}
+
+	return 0;
+}
+
+const struct dcbnl_rtnl_ops dpaa2_eth_dcbnl_ops = {
+	.ieee_getpfc	= dpaa2_eth_dcbnl_ieee_getpfc,
+	.ieee_setpfc	= dpaa2_eth_dcbnl_ieee_setpfc,
+	.getdcbx	= dpaa2_eth_dcbnl_getdcbx,
+	.setdcbx	= dpaa2_eth_dcbnl_setdcbx,
+	.getcap		= dpaa2_eth_dcbnl_getcap,
+};
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 04eff6308c72..cde9d0e2dd6d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -3844,6 +3844,15 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	if (err)
 		goto err_alloc_rings;
 
+#ifdef CONFIG_FSL_DPAA2_ETH_DCB
+	if (dpaa2_eth_has_pause_support(priv) && priv->vlan_cls_enabled) {
+		priv->dcbx_mode = DCB_CAP_DCBX_HOST | DCB_CAP_DCBX_VER_IEEE;
+		net_dev->dcbnl_ops = &dpaa2_eth_dcbnl_ops;
+	} else {
+		dev_dbg(dev, "PFC not supported\n");
+	}
+#endif
+
 	err = setup_irqs(dpni_dev);
 	if (err) {
 		netdev_warn(net_dev, "Failed to set link interrupt, fall back to polling\n");
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 02c0eea69a23..31b7b9b52da0 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -6,6 +6,7 @@
 #ifndef __DPAA2_ETH_H
 #define __DPAA2_ETH_H
 
+#include <linux/dcbnl.h>
 #include <linux/netdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/fsl/mc.h>
@@ -65,6 +66,17 @@
 #define DPAA2_ETH_CG_TAILDROP_THRESH(priv)				\
 	(1024 * dpaa2_eth_queue_count(priv) / dpaa2_eth_tc_count(priv))
 
+/* Congestion group notification threshold: when this many frames accumulate
+ * on the Rx queues belonging to the same TC, the MAC is instructed to send
+ * PFC frames for that TC.
+ * When number of pending frames drops below exit threshold transmission of
+ * PFC frames is stopped.
+ */
+#define DPAA2_ETH_CN_THRESH_ENTRY(priv) \
+	(DPAA2_ETH_CG_TAILDROP_THRESH(priv) / 2)
+#define DPAA2_ETH_CN_THRESH_EXIT(priv) \
+	(DPAA2_ETH_CN_THRESH_ENTRY(priv) * 3 / 4)
+
 /* Maximum number of buffers that can be acquired/released through a single
  * QBMan command
  */
@@ -436,6 +448,10 @@ struct dpaa2_eth_priv {
 	struct dpaa2_eth_cls_rule *cls_rules;
 	u8 rx_cls_enabled;
 	u8 vlan_cls_enabled;
+#ifdef CONFIG_FSL_DPAA2_ETH_DCB
+	u8 dcbx_mode;
+	struct ieee_pfc pfc;
+#endif
 	struct bpf_prog *xdp_prog;
 #ifdef CONFIG_DEBUG_FS
 	struct dpaa2_debugfs dbg;
@@ -568,4 +584,6 @@ int dpaa2_eth_cls_key_size(u64 key);
 int dpaa2_eth_cls_fld_off(int prot, int field);
 void dpaa2_eth_cls_trim_rule(void *key_mem, u64 fields);
 
+extern const struct dcbnl_rtnl_ops dpaa2_eth_dcbnl_ops;
+
 #endif	/* __DPAA2_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 0048e856f85e..fd069f67be9b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -601,4 +601,29 @@ struct dpni_cmd_remove_qos_entry {
 	__le64 mask_iova;
 };
 
+#define DPNI_DEST_TYPE_SHIFT		0
+#define DPNI_DEST_TYPE_SIZE		4
+#define DPNI_CONG_UNITS_SHIFT		4
+#define DPNI_CONG_UNITS_SIZE		2
+
+struct dpni_cmd_set_congestion_notification {
+	/* cmd word 0 */
+	u8 qtype;
+	u8 tc;
+	u8 pad[6];
+	/* cmd word 1 */
+	__le32 dest_id;
+	__le16 notification_mode;
+	u8 dest_priority;
+	/* from LSB: dest_type: 4 units:2 */
+	u8 type_units;
+	/* cmd word 2 */
+	__le64 message_iova;
+	/* cmd word 3 */
+	__le64 message_ctx;
+	/* cmd word 4 */
+	__le32 threshold_entry;
+	__le32 threshold_exit;
+};
+
 #endif /* _FSL_DPNI_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 78fa325407ca..6b479ba66465 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -1354,6 +1354,52 @@ int dpni_set_rx_tc_dist(struct fsl_mc_io *mc_io,
 	return mc_send_command(mc_io, &cmd);
 }
 
+/**
+ * dpni_set_congestion_notification() - Set traffic class congestion
+ *					notification configuration
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPNI object
+ * @qtype:	Type of queue - Rx, Tx and Tx confirm types are supported
+ * @tc_id:	Traffic class selection (0-7)
+ * @cfg:	Congestion notification configuration
+ *
+ * Return:	'0' on Success; error code otherwise.
+ */
+int dpni_set_congestion_notification(
+			struct fsl_mc_io *mc_io,
+			u32 cmd_flags,
+			u16 token,
+			enum dpni_queue_type qtype,
+			u8 tc_id,
+			const struct dpni_congestion_notification_cfg *cfg)
+{
+	struct dpni_cmd_set_congestion_notification *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header =
+		mc_encode_cmd_header(DPNI_CMDID_SET_CONGESTION_NOTIFICATION,
+				     cmd_flags,
+				     token);
+	cmd_params = (struct dpni_cmd_set_congestion_notification *)cmd.params;
+	cmd_params->qtype = qtype;
+	cmd_params->tc = tc_id;
+	cmd_params->dest_id = cpu_to_le32(cfg->dest_cfg.dest_id);
+	cmd_params->notification_mode = cpu_to_le16(cfg->notification_mode);
+	cmd_params->dest_priority = cfg->dest_cfg.priority;
+	dpni_set_field(cmd_params->type_units, DEST_TYPE,
+		       cfg->dest_cfg.dest_type);
+	dpni_set_field(cmd_params->type_units, CONG_UNITS, cfg->units);
+	cmd_params->message_iova = cpu_to_le64(cfg->message_iova);
+	cmd_params->message_ctx = cpu_to_le64(cfg->message_ctx);
+	cmd_params->threshold_entry = cpu_to_le32(cfg->threshold_entry);
+	cmd_params->threshold_exit = cpu_to_le32(cfg->threshold_exit);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
 /**
  * dpni_set_queue() - Set queue parameters
  * @mc_io:	Pointer to MC portal's I/O object
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index 8c7ac20bf1a7..e874d8084142 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -513,6 +513,11 @@ int dpni_get_statistics(struct fsl_mc_io	*mc_io,
  */
 #define DPNI_LINK_OPT_ASYM_PAUSE	0x0000000000000008ULL
 
+/**
+ * Enable priority flow control pause frames
+ */
+#define DPNI_LINK_OPT_PFC_PAUSE		0x0000000000000010ULL
+
 /**
  * struct - Structure representing DPNI link configuration
  * @rate: Rate
@@ -877,6 +882,62 @@ enum dpni_congestion_point {
 	DPNI_CP_GROUP,
 };
 
+/**
+ * struct dpni_dest_cfg - Structure representing DPNI destination parameters
+ * @dest_type:	Destination type
+ * @dest_id:	Either DPIO ID or DPCON ID, depending on the destination type
+ * @priority:	Priority selection within the DPIO or DPCON channel; valid
+ *		values are 0-1 or 0-7, depending on the number of priorities
+ *		in that channel; not relevant for 'DPNI_DEST_NONE' option
+ */
+struct dpni_dest_cfg {
+	enum dpni_dest dest_type;
+	int dest_id;
+	u8 priority;
+};
+
+/* DPNI congestion options */
+
+/**
+ * This congestion will trigger flow control or priority flow control.
+ * This will have effect only if flow control is enabled with
+ * dpni_set_link_cfg().
+ */
+#define DPNI_CONG_OPT_FLOW_CONTROL		0x00000040
+
+/**
+ * struct dpni_congestion_notification_cfg - congestion notification
+ *					configuration
+ * @units: Units type
+ * @threshold_entry: Above this threshold we enter a congestion state.
+ *		set it to '0' to disable it
+ * @threshold_exit: Below this threshold we exit the congestion state.
+ * @message_ctx: The context that will be part of the CSCN message
+ * @message_iova: I/O virtual address (must be in DMA-able memory),
+ *		must be 16B aligned; valid only if 'DPNI_CONG_OPT_WRITE_MEM_<X>'
+ *		is contained in 'options'
+ * @dest_cfg: CSCN can be send to either DPIO or DPCON WQ channel
+ * @notification_mode: Mask of available options; use 'DPNI_CONG_OPT_<X>' values
+ */
+
+struct dpni_congestion_notification_cfg {
+	enum dpni_congestion_unit units;
+	u32 threshold_entry;
+	u32 threshold_exit;
+	u64 message_ctx;
+	u64 message_iova;
+	struct dpni_dest_cfg dest_cfg;
+	u16 notification_mode;
+};
+
+int dpni_set_congestion_notification(
+			struct fsl_mc_io *mc_io,
+			u32 cmd_flags,
+			u16 token,
+			enum dpni_queue_type qtype,
+			u8 tc_id,
+			const struct dpni_congestion_notification_cfg *cfg);
+
 /**
  * struct dpni_taildrop - Structure representing the taildrop
  * @enable:	Indicates whether the taildrop is active or not.
-- 
2.17.1

