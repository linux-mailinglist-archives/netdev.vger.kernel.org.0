Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324A2F2CC0
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733278AbfKGKoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:44:55 -0500
Received: from inva021.nxp.com ([92.121.34.21]:40478 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727528AbfKGKoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 05:44:55 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A5721200157;
        Thu,  7 Nov 2019 11:44:51 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8D475200A93;
        Thu,  7 Nov 2019 11:44:51 +0100 (CET)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4BA3520634;
        Thu,  7 Nov 2019 11:44:51 +0100 (CET)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2] dpaa2-eth: add ethtool MAC counters
Date:   Thu,  7 Nov 2019 12:44:48 +0200
Message-Id: <1573123488-21530-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a DPNI is connected to a MAC, export its associated counters.
Ethtool related functions are added in dpaa2_mac for returning the
number of counters, their strings and also their values.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - set stats value to U64_MAX on error

 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   | 13 +++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   | 68 ++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h   |  6 ++
 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h   | 11 +++
 drivers/net/ethernet/freescale/dpaa2/dpmac.c       | 34 +++++++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h       | 82 ++++++++++++++++++++++
 6 files changed, 213 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index 0883620631b8..96676abcebd5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -173,6 +173,7 @@ static int dpaa2_eth_set_pauseparam(struct net_device *net_dev,
 static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 				  u8 *data)
 {
+	struct dpaa2_eth_priv *priv = netdev_priv(netdev);
 	u8 *p = data;
 	int i;
 
@@ -186,15 +187,22 @@ static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 			strlcpy(p, dpaa2_ethtool_extras[i], ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
+		if (priv->mac)
+			dpaa2_mac_get_strings(p);
 		break;
 	}
 }
 
 static int dpaa2_eth_get_sset_count(struct net_device *net_dev, int sset)
 {
+	int num_ss_stats = DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS;
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+
 	switch (sset) {
 	case ETH_SS_STATS: /* ethtool_get_stats(), ethtool_get_drvinfo() */
-		return DPAA2_ETH_NUM_STATS + DPAA2_ETH_NUM_EXTRA_STATS;
+		if (priv->mac)
+			num_ss_stats += dpaa2_mac_get_sset_count();
+		return num_ss_stats;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -293,6 +301,9 @@ static void dpaa2_eth_get_ethtool_stats(struct net_device *net_dev,
 		return;
 	}
 	*(data + i++) = buf_cnt;
+
+	if (priv->mac)
+		dpaa2_mac_get_ethtool_stats(priv->mac, data + i);
 }
 
 static int prep_eth_rule(struct ethhdr *eth_value, struct ethhdr *eth_mask,
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index d322123ed373..84233e467ed1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -305,3 +305,71 @@ void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
 	phylink_destroy(mac->phylink);
 	dpmac_close(mac->mc_io, 0, mac->mc_dev->mc_handle);
 }
+
+static char dpaa2_mac_ethtool_stats[][ETH_GSTRING_LEN] = {
+	[DPMAC_CNT_ING_ALL_FRAME]		= "[mac] rx all frames",
+	[DPMAC_CNT_ING_GOOD_FRAME]		= "[mac] rx frames ok",
+	[DPMAC_CNT_ING_ERR_FRAME]		= "[mac] rx frame errors",
+	[DPMAC_CNT_ING_FRAME_DISCARD]		= "[mac] rx frame discards",
+	[DPMAC_CNT_ING_UCAST_FRAME]		= "[mac] rx u-cast",
+	[DPMAC_CNT_ING_BCAST_FRAME]		= "[mac] rx b-cast",
+	[DPMAC_CNT_ING_MCAST_FRAME]		= "[mac] rx m-cast",
+	[DPMAC_CNT_ING_FRAME_64]		= "[mac] rx 64 bytes",
+	[DPMAC_CNT_ING_FRAME_127]		= "[mac] rx 65-127 bytes",
+	[DPMAC_CNT_ING_FRAME_255]		= "[mac] rx 128-255 bytes",
+	[DPMAC_CNT_ING_FRAME_511]		= "[mac] rx 256-511 bytes",
+	[DPMAC_CNT_ING_FRAME_1023]		= "[mac] rx 512-1023 bytes",
+	[DPMAC_CNT_ING_FRAME_1518]		= "[mac] rx 1024-1518 bytes",
+	[DPMAC_CNT_ING_FRAME_1519_MAX]		= "[mac] rx 1519-max bytes",
+	[DPMAC_CNT_ING_FRAG]			= "[mac] rx frags",
+	[DPMAC_CNT_ING_JABBER]			= "[mac] rx jabber",
+	[DPMAC_CNT_ING_ALIGN_ERR]		= "[mac] rx align errors",
+	[DPMAC_CNT_ING_OVERSIZED]		= "[mac] rx oversized",
+	[DPMAC_CNT_ING_VALID_PAUSE_FRAME]	= "[mac] rx pause",
+	[DPMAC_CNT_ING_BYTE]			= "[mac] rx bytes",
+	[DPMAC_CNT_EGR_GOOD_FRAME]		= "[mac] tx frames ok",
+	[DPMAC_CNT_EGR_UCAST_FRAME]		= "[mac] tx u-cast",
+	[DPMAC_CNT_EGR_MCAST_FRAME]		= "[mac] tx m-cast",
+	[DPMAC_CNT_EGR_BCAST_FRAME]		= "[mac] tx b-cast",
+	[DPMAC_CNT_EGR_ERR_FRAME]		= "[mac] tx frame errors",
+	[DPMAC_CNT_EGR_UNDERSIZED]		= "[mac] tx undersized",
+	[DPMAC_CNT_EGR_VALID_PAUSE_FRAME]	= "[mac] tx b-pause",
+	[DPMAC_CNT_EGR_BYTE]			= "[mac] tx bytes",
+};
+
+#define DPAA2_MAC_NUM_STATS	ARRAY_SIZE(dpaa2_mac_ethtool_stats)
+
+int dpaa2_mac_get_sset_count(void)
+{
+	return DPAA2_MAC_NUM_STATS;
+}
+
+void dpaa2_mac_get_strings(u8 *data)
+{
+	u8 *p = data;
+	int i;
+
+	for (i = 0; i < DPAA2_MAC_NUM_STATS; i++) {
+		strlcpy(p, dpaa2_mac_ethtool_stats[i], ETH_GSTRING_LEN);
+		p += ETH_GSTRING_LEN;
+	}
+}
+
+void dpaa2_mac_get_ethtool_stats(struct dpaa2_mac *mac, u64 *data)
+{
+	struct fsl_mc_device *dpmac_dev = mac->mc_dev;
+	int i, err;
+	u64 value;
+
+	for (i = 0; i < DPAA2_MAC_NUM_STATS; i++) {
+		err = dpmac_get_counter(mac->mc_io, 0, dpmac_dev->mc_handle,
+					i, &value);
+		if (err) {
+			netdev_err_once(mac->net_dev,
+					"dpmac_get_counter error %d\n", err);
+			*(data + i) = U64_MAX;
+			continue;
+		}
+		*(data + i) = value;
+	}
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 8634d0de7ef3..4da8079b9155 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -29,4 +29,10 @@ bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
 
 void dpaa2_mac_disconnect(struct dpaa2_mac *mac);
 
+int dpaa2_mac_get_sset_count(void);
+
+void dpaa2_mac_get_strings(u8 *data);
+
+void dpaa2_mac_get_ethtool_stats(struct dpaa2_mac *mac, u64 *data);
+
 #endif /* DPAA2_MAC_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
index 96a9b0d0992e..3ea51dd9374b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
@@ -22,6 +22,8 @@
 #define DPMAC_CMDID_GET_ATTR		DPMAC_CMD(0x004)
 #define DPMAC_CMDID_SET_LINK_STATE	DPMAC_CMD_V2(0x0c3)
 
+#define DPMAC_CMDID_GET_COUNTER		DPMAC_CMD(0x0c4)
+
 /* Macros for accessing command fields smaller than 1byte */
 #define DPMAC_MASK(field)        \
 	GENMASK(DPMAC_##field##_SHIFT + DPMAC_##field##_SIZE - 1, \
@@ -59,4 +61,13 @@ struct dpmac_cmd_set_link_state {
 	__le64 advertising;
 };
 
+struct dpmac_cmd_get_counter {
+	u8 id;
+};
+
+struct dpmac_rsp_get_counter {
+	u64 pad;
+	u64 counter;
+};
+
 #endif /* _FSL_DPMAC_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.c b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
index b75189deffb1..d5997b654562 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
@@ -147,3 +147,37 @@ int dpmac_set_link_state(struct fsl_mc_io *mc_io,
 	/* send command to mc*/
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dpmac_get_counter() - Read a specific DPMAC counter
+ * @mc_io:	Pointer to opaque I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPMAC object
+ * @id:		The requested counter ID
+ * @value:	Returned counter value
+ *
+ * Return:	The requested counter; '0' otherwise.
+ */
+int dpmac_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		      enum dpmac_counter_id id, u64 *value)
+{
+	struct dpmac_cmd_get_counter *dpmac_cmd;
+	struct dpmac_rsp_get_counter *dpmac_rsp;
+	struct fsl_mc_command cmd = { 0 };
+	int err = 0;
+
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_GET_COUNTER,
+					  cmd_flags,
+					  token);
+	dpmac_cmd = (struct dpmac_cmd_get_counter *)cmd.params;
+	dpmac_cmd->id = id;
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	dpmac_rsp = (struct dpmac_rsp_get_counter *)cmd.params;
+	*value = le64_to_cpu(dpmac_rsp->counter);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.h b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
index 4efc410a479e..135f143097a5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
@@ -141,4 +141,86 @@ int dpmac_set_link_state(struct fsl_mc_io *mc_io,
 			 u16 token,
 			 struct dpmac_link_state *link_state);
 
+/**
+ * enum dpmac_counter_id - DPMAC counter types
+ *
+ * @DPMAC_CNT_ING_FRAME_64: counts 64-bytes frames, good or bad.
+ * @DPMAC_CNT_ING_FRAME_127: counts 65- to 127-bytes frames, good or bad.
+ * @DPMAC_CNT_ING_FRAME_255: counts 128- to 255-bytes frames, good or bad.
+ * @DPMAC_CNT_ING_FRAME_511: counts 256- to 511-bytes frames, good or bad.
+ * @DPMAC_CNT_ING_FRAME_1023: counts 512- to 1023-bytes frames, good or bad.
+ * @DPMAC_CNT_ING_FRAME_1518: counts 1024- to 1518-bytes frames, good or bad.
+ * @DPMAC_CNT_ING_FRAME_1519_MAX: counts 1519-bytes frames and larger
+ *				  (up to max frame length specified),
+ *				  good or bad.
+ * @DPMAC_CNT_ING_FRAG: counts frames which are shorter than 64 bytes received
+ *			with a wrong CRC
+ * @DPMAC_CNT_ING_JABBER: counts frames longer than the maximum frame length
+ *			  specified, with a bad frame check sequence.
+ * @DPMAC_CNT_ING_FRAME_DISCARD: counts dropped frames due to internal errors.
+ *				 Occurs when a receive FIFO overflows.
+ *				 Includes also frames truncated as a result of
+ *				 the receive FIFO overflow.
+ * @DPMAC_CNT_ING_ALIGN_ERR: counts frames with an alignment error
+ *			     (optional used for wrong SFD).
+ * @DPMAC_CNT_EGR_UNDERSIZED: counts frames transmitted that was less than 64
+ *			      bytes long with a good CRC.
+ * @DPMAC_CNT_ING_OVERSIZED: counts frames longer than the maximum frame length
+ *			     specified, with a good frame check sequence.
+ * @DPMAC_CNT_ING_VALID_PAUSE_FRAME: counts valid pause frames (regular and PFC)
+ * @DPMAC_CNT_EGR_VALID_PAUSE_FRAME: counts valid pause frames transmitted
+ *				     (regular and PFC).
+ * @DPMAC_CNT_ING_BYTE: counts bytes received except preamble for all valid
+ *			frames and valid pause frames.
+ * @DPMAC_CNT_ING_MCAST_FRAME: counts received multicast frames.
+ * @DPMAC_CNT_ING_BCAST_FRAME: counts received broadcast frames.
+ * @DPMAC_CNT_ING_ALL_FRAME: counts each good or bad frames received.
+ * @DPMAC_CNT_ING_UCAST_FRAME: counts received unicast frames.
+ * @DPMAC_CNT_ING_ERR_FRAME: counts frames received with an error
+ *			     (except for undersized/fragment frame).
+ * @DPMAC_CNT_EGR_BYTE: counts bytes transmitted except preamble for all valid
+ *			frames and valid pause frames transmitted.
+ * @DPMAC_CNT_EGR_MCAST_FRAME: counts transmitted multicast frames.
+ * @DPMAC_CNT_EGR_BCAST_FRAME: counts transmitted broadcast frames.
+ * @DPMAC_CNT_EGR_UCAST_FRAME: counts transmitted unicast frames.
+ * @DPMAC_CNT_EGR_ERR_FRAME: counts frames transmitted with an error.
+ * @DPMAC_CNT_ING_GOOD_FRAME: counts frames received without error, including
+ *			      pause frames.
+ * @DPMAC_CNT_EGR_GOOD_FRAME: counts frames transmitted without error, including
+ *			      pause frames.
+ */
+enum dpmac_counter_id {
+	DPMAC_CNT_ING_FRAME_64,
+	DPMAC_CNT_ING_FRAME_127,
+	DPMAC_CNT_ING_FRAME_255,
+	DPMAC_CNT_ING_FRAME_511,
+	DPMAC_CNT_ING_FRAME_1023,
+	DPMAC_CNT_ING_FRAME_1518,
+	DPMAC_CNT_ING_FRAME_1519_MAX,
+	DPMAC_CNT_ING_FRAG,
+	DPMAC_CNT_ING_JABBER,
+	DPMAC_CNT_ING_FRAME_DISCARD,
+	DPMAC_CNT_ING_ALIGN_ERR,
+	DPMAC_CNT_EGR_UNDERSIZED,
+	DPMAC_CNT_ING_OVERSIZED,
+	DPMAC_CNT_ING_VALID_PAUSE_FRAME,
+	DPMAC_CNT_EGR_VALID_PAUSE_FRAME,
+	DPMAC_CNT_ING_BYTE,
+	DPMAC_CNT_ING_MCAST_FRAME,
+	DPMAC_CNT_ING_BCAST_FRAME,
+	DPMAC_CNT_ING_ALL_FRAME,
+	DPMAC_CNT_ING_UCAST_FRAME,
+	DPMAC_CNT_ING_ERR_FRAME,
+	DPMAC_CNT_EGR_BYTE,
+	DPMAC_CNT_EGR_MCAST_FRAME,
+	DPMAC_CNT_EGR_BCAST_FRAME,
+	DPMAC_CNT_EGR_UCAST_FRAME,
+	DPMAC_CNT_EGR_ERR_FRAME,
+	DPMAC_CNT_ING_GOOD_FRAME,
+	DPMAC_CNT_EGR_GOOD_FRAME
+};
+
+int dpmac_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		      enum dpmac_counter_id id, u64 *value);
+
 #endif /* __FSL_DPMAC_H */
-- 
1.9.1

