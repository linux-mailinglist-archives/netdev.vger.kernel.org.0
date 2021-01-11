Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAEF2F1BD7
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389229AbhAKRIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730949AbhAKRIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:08:15 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2F3C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:07:35 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id b9so730247ejy.0
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sLs9vKrJNRHuUxzwJLJ2KqhpjdtpN+geQJ46NtQn0w8=;
        b=VhUVN2LSavloWtQXUBdjImwzBqOux7OAxd6pPuayIn31ynxbyuCGsWZU9Oz34iB/i4
         WymQNYlyZZTVZqAcRyJH0050NKwGtIl2FvSHndcy8T8VX6mtZYjSRzbcYRue63d9POox
         eKzg7dQajKWWdu13EdCEWd6ltjm1FaqeIJj+jkqHJz+wooDPb7qM2b36SZd8364mebTr
         OxFswTsKdmzR40wwn6sG7JPWUk4vPW638JlJTV3H6MmZYeJgb7uqPm9E4zgqot4EexFb
         Gw657fEGiUYxIj7GH8QgA8Ca/53JRZ2R6zltWEye8mVfIaUPsOfXHexaEXjPiqjsS6wo
         1dSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sLs9vKrJNRHuUxzwJLJ2KqhpjdtpN+geQJ46NtQn0w8=;
        b=SWFXyXPdbrRbV1O09ozVq2Opx39qhWfBOQyJPG9RxgoUjVXu1hMWy3C2tovA7DJsre
         a06gT3N2ru9JFxLb/g7ImuATqsI0Kp+1sY5/tjdv5pSvgy3OlMCmtULhZioUkrC6z05g
         KLQqGjxPs30iXcnYS+BdhTFxuevAZTNXdzNtHnRrRYdvoufdb+mYKjWEjKSrZyy7ZkQX
         gCQQ75wGVQXOWiAvmFBUu4M7ubsGnX7d14iHcHeU1I/tpTgKC5qNVpA2SiUyaejPjyIE
         3GPpUyO75hrCJk5c071FnyOQqP7/wnqwt+7FYs+fREJy7XQEohBajTYXlteFFQz/yssG
         lfOA==
X-Gm-Message-State: AOAM530hmsOIjmCovologJC7XupoLt9lCgs9KEZtRuFk5QPL84jMROzE
        sDlDGvEUJ/1nTPyQwhroUtc=
X-Google-Smtp-Source: ABdhPJy+ovxJfDxsOGS9wvC2RnYaDpK8SYtfgRTcfsJw/W/zw62u5WKnj4uBSUJYH6CeLtTgBABDQA==
X-Received: by 2002:a17:906:b56:: with SMTP id v22mr297042ejg.145.1610384853997;
        Mon, 11 Jan 2021 09:07:33 -0800 (PST)
Received: from yoga-910.localhost (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id j5sm212845edl.42.2021.01.11.09.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 09:07:33 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Ionut-robert Aron <ionut-robert.aron@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next] dpaa2-eth: add support for Rx VLAN filtering
Date:   Mon, 11 Jan 2021 19:07:25 +0200
Message-Id: <20210111170725.1818218-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ionut-robert Aron <ionut-robert.aron@nxp.com>

Declare Rx VLAN filtering as supported and user-changeable only when
there are VLAN filtering entries available on the DPNI object. Even
then, rx-vlan-filtering is by default disabled.
Also, populate the .ndo_vlan_rx_add_vid() and .ndo_vlan_rx_kill_vid()
callbacks for adding and removing a specific VLAN from the VLAN table.

Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 65 +++++++++++++
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   | 17 ++++
 drivers/net/ethernet/freescale/dpaa2/dpni.c   | 93 +++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |  9 ++
 4 files changed, 184 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 15acb1ddd701..8373dbc6fe99 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1262,6 +1262,22 @@ static void dpaa2_eth_tx_conf(struct dpaa2_eth_priv *priv,
 	percpu_stats->tx_errors++;
 }
 
+static int dpaa2_eth_set_rx_vlan_filtering(struct dpaa2_eth_priv *priv,
+					   bool enable)
+{
+	int err;
+
+	err = dpni_enable_vlan_filter(priv->mc_io, 0, priv->mc_token, enable);
+
+	if (err) {
+		netdev_err(priv->net_dev,
+			   "dpni_enable_vlan_filter failed\n");
+		return err;
+	}
+
+	return 0;
+}
+
 static int dpaa2_eth_set_rx_csum(struct dpaa2_eth_priv *priv, bool enable)
 {
 	int err;
@@ -1952,6 +1968,43 @@ static void dpaa2_eth_add_mc_hw_addr(const struct net_device *net_dev,
 	}
 }
 
+static int dpaa2_eth_rx_add_vid(struct net_device *net_dev,
+				__be16 vlan_proto, u16 vid)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int err;
+
+	err = dpni_add_vlan_id(priv->mc_io, 0, priv->mc_token,
+			       vid, 0, 0, 0);
+
+	if (err) {
+		netdev_warn(priv->net_dev,
+			    "Could not add the vlan id %u\n",
+			    vid);
+		return err;
+	}
+
+	return 0;
+}
+
+static int dpaa2_eth_rx_kill_vid(struct net_device *net_dev,
+				 __be16 vlan_proto, u16 vid)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	int err;
+
+	err = dpni_remove_vlan_id(priv->mc_io, 0, priv->mc_token, vid);
+
+	if (err) {
+		netdev_warn(priv->net_dev,
+			    "Could not remove the vlan id %u\n",
+			    vid);
+		return err;
+	}
+
+	return 0;
+}
+
 static void dpaa2_eth_set_rx_mode(struct net_device *net_dev)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
@@ -2058,6 +2111,13 @@ static int dpaa2_eth_set_features(struct net_device *net_dev,
 	bool enable;
 	int err;
 
+	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
+		enable = !!(features & NETIF_F_HW_VLAN_CTAG_FILTER);
+		err = dpaa2_eth_set_rx_vlan_filtering(priv, enable);
+		if (err)
+			return err;
+	}
+
 	if (changed & NETIF_F_RXCSUM) {
 		enable = !!(features & NETIF_F_RXCSUM);
 		err = dpaa2_eth_set_rx_csum(priv, enable);
@@ -2507,6 +2567,8 @@ static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_bpf = dpaa2_eth_xdp,
 	.ndo_xdp_xmit = dpaa2_eth_xdp_xmit,
 	.ndo_setup_tc = dpaa2_eth_setup_tc,
+	.ndo_vlan_rx_add_vid = dpaa2_eth_rx_add_vid,
+	.ndo_vlan_rx_kill_vid = dpaa2_eth_rx_kill_vid
 };
 
 static void dpaa2_eth_cdan_cb(struct dpaa2_io_notification_ctx *ctx)
@@ -4015,6 +4077,9 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 			    NETIF_F_LLTX | NETIF_F_HW_TC;
 	net_dev->hw_features = net_dev->features;
 
+	if (priv->dpni_attrs.vlan_filter_entries)
+		net_dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 90453dc7baef..9f80bdfeedec 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -62,6 +62,10 @@
 
 #define DPNI_CMDID_SET_RX_TC_DIST			DPNI_CMD(0x235)
 
+#define DPNI_CMDID_ENABLE_VLAN_FILTER			DPNI_CMD(0x230)
+#define DPNI_CMDID_ADD_VLAN_ID				DPNI_CMD_V2(0x231)
+#define DPNI_CMDID_REMOVE_VLAN_ID			DPNI_CMD(0x232)
+
 #define DPNI_CMDID_SET_QOS_TBL				DPNI_CMD(0x240)
 #define DPNI_CMDID_ADD_QOS_ENT				DPNI_CMD(0x241)
 #define DPNI_CMDID_REMOVE_QOS_ENT			DPNI_CMD(0x242)
@@ -662,4 +666,17 @@ struct dpni_rsp_single_step_cfg {
 	__le32 peer_delay;
 };
 
+struct dpni_cmd_enable_vlan_filter {
+	/* only the LSB */
+	u8 en;
+};
+
+struct dpni_cmd_vlan_id {
+	u8 flags;
+	u8 tc_id;
+	u8 flow_id;
+	u8 pad;
+	__le16 vlan_id;
+};
+
 #endif /* _FSL_DPNI_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index 6ea7db66a632..aa429c17c343 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -1224,6 +1224,99 @@ int dpni_get_port_mac_addr(struct fsl_mc_io *mc_io,
 	return 0;
 }
 
+/**
+ * dpni_enable_vlan_filter() - Enable/disable VLAN filtering mode
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPNI object
+ * @en:		Set to '1' to enable; '0' to disable
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpni_enable_vlan_filter(struct fsl_mc_io *mc_io,
+			    u32 cmd_flags,
+			    u16 token,
+			    u32 en)
+{
+	struct dpni_cmd_enable_vlan_filter *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPNI_CMDID_ENABLE_VLAN_FILTER,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpni_cmd_enable_vlan_filter *)cmd.params;
+	dpni_set_field(cmd_params->en, ENABLE, en);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpni_add_vlan_id() - Add VLAN ID filter
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPNI object
+ * @vlan_id:	VLAN ID to add
+ * @flags:   0 - tc_id and flow_id will be ignored.
+ * Pkt with this vlan_id will be passed to the next
+ * classification stages
+ * DPNI_VLAN_SET_QUEUE_ACTION
+ * Pkt with this vlan_id will be forward directly to
+ * queue defined by the tc_id and flow_id
+ *
+ * @tc_id: Traffic class selection (0-7)
+ * @flow_id: Selects the specific queue out of the set allocated for the
+ *           same as tc_id. Value must be in range 0 to NUM_QUEUES - 1
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpni_add_vlan_id(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		     u16 vlan_id, u8 flags, u8 tc_id, u8 flow_id)
+{
+	struct dpni_cmd_vlan_id *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPNI_CMDID_ADD_VLAN_ID,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpni_cmd_vlan_id *)cmd.params;
+	cmd_params->flags = flags;
+	cmd_params->tc_id = tc_id;
+	cmd_params->flow_id =  flow_id;
+	cmd_params->vlan_id = cpu_to_le16(vlan_id);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpni_remove_vlan_id() - Remove VLAN ID filter
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPNI object
+ * @vlan_id:	VLAN ID to remove
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpni_remove_vlan_id(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			u16 vlan_id)
+{
+	struct dpni_cmd_vlan_id *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPNI_CMDID_REMOVE_VLAN_ID,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpni_cmd_vlan_id *)cmd.params;
+	cmd_params->vlan_id = cpu_to_le16(vlan_id);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
 /**
  * dpni_add_mac_addr() - Add MAC address filter
  * @mc_io:	Pointer to MC portal's I/O object
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index e7b9e195b534..4e96d9362dd2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -1114,4 +1114,13 @@ int dpni_get_single_step_cfg(struct fsl_mc_io *mc_io,
 			     u16 token,
 			     struct dpni_single_step_cfg *ptp_cfg);
 
+int dpni_enable_vlan_filter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			    u32 en);
+
+int dpni_add_vlan_id(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		     u16 vlan_id, u8 flags, u8 tc_id, u8 flow_id);
+
+int dpni_remove_vlan_id(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			u16 vlan_id);
+
 #endif /* __FSL_DPNI_H */
-- 
2.29.2

