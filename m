Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64BAC345149
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhCVVAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhCVU71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:59:27 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14504C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:27 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id kt15so14073794ejb.12
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 13:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=545Q87iQ2gBZTtR8ldP7hxSlGyj5mrVoEHjdmE0uY+I=;
        b=Fk6eqeVmOU6j5dWyOFc5N83z3Q0rYPre/6BL1M6HbNHNLmCo4a3arTsB9ySRiRZHaO
         YDPU2gZkuSUJieJYdZRO46Z01w0iB44xV2CFXHOoWzSm528kp4tsaFHbSl5UDa3FlhcF
         CPoDH30+H2GgKZ2hhlpSLXn0+beVuKywQCAWnolA5V2fTzv53w6D59hUKF5kC6Xs4lAZ
         sEJs/hVMYgHKoCBKZkjsAAjDqGwM2pf0aIrW5aTG5AycwYRkEeL+NwX6hxPXRc4aKGCv
         vKKdv26qx3qkBX2dM6gtOW6NJf7Uv4dYJcOgLylnkddwz7yMgp1U1QXAy3nxLnLNBKpy
         BBqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=545Q87iQ2gBZTtR8ldP7hxSlGyj5mrVoEHjdmE0uY+I=;
        b=bNtKWxq64x8s/1noUjLoLCvZysyT1A13z9erUFGHp7bONjoY+12Z60YGF23ZT/Rvwy
         CYMK18nzE7tfpLhUkOla3wAs30VUXZJMN8/onb/3tOw/vgqdkMYeXn8VqVxg4ng6CyM1
         LHkutOz4TMXfnUzGyRFJqYsEUBJ64muEqOxT+5oiAEhL/gl/hLTJyDNQcSIXcU3enU9r
         7m4gRw/Th3CFnV51XTspGMxYgAPG9aEiyQFwG5qGQVq5EZ8ZRqbVRlAY4rzR+S5pQfsx
         MXYUnsSNIs4ypX6wO3QtGX3/ks5xfQSooiaGyCztrG9/wuqDjy+wTniM+0yJZkwq6CX/
         UXEQ==
X-Gm-Message-State: AOAM532jIGWclCDuhgmks05jn3KrARjUw1XHoAyw4kEHOIN0cCpNFA2y
        9sFlBmuA56XcE273C0pNsxY=
X-Google-Smtp-Source: ABdhPJyubgwyN1qDgODHrL0MzLGy4pOnoE8L8q+6mIsiK91rTsg99Muzpd2Qql4hcjkeETMNmqLs7g==
X-Received: by 2002:a17:907:ea3:: with SMTP id ho35mr1605399ejc.219.1616446765761;
        Mon, 22 Mar 2021 13:59:25 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id v25sm11621074edr.18.2021.03.22.13.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:59:25 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/6] dpaa2-switch: add support for configuring learning state per port
Date:   Mon, 22 Mar 2021 22:58:56 +0200
Message-Id: <20210322205859.606704-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210322205859.606704-1-ciorneiioana@gmail.com>
References: <20210322205859.606704-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Add support for configuring the learning state of a switch port.
When the user requests the HW learning to be disabled, a fast-age
procedure on that specific port is run so that previously learnt
addresses do not linger.

At device probe as well as on a bridge leave action, the ports are
configured with HW learning disabled since they are basically a
standalone port.

At the same time, at bridge join we inherit the bridge port BR_LEARNING
flag state and configure it on the switch port.

There were already some MC firmware ABI functions for changing the
learning state, but those were per FDB (bridging domain) and not per
port so we need to adjust those to use the new MC fw command which is
per port.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 70 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h   | 10 +++
 drivers/net/ethernet/freescale/dpaa2/dpsw.c   | 27 +++++++
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   | 25 ++++---
 4 files changed, 121 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 2db9cd78201d..2ea3a4dac49d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1238,6 +1238,56 @@ static int dpaa2_switch_port_attr_stp_state_set(struct net_device *netdev,
 	return dpaa2_switch_port_set_stp_state(port_priv, state);
 }
 
+static int dpaa2_switch_port_set_learning(struct ethsw_port_priv *port_priv, bool enable)
+{
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	enum dpsw_learning_mode learn_mode;
+	int err;
+
+	if (enable)
+		learn_mode = DPSW_LEARNING_MODE_HW;
+	else
+		learn_mode = DPSW_LEARNING_MODE_DIS;
+
+	err = dpsw_if_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle,
+					port_priv->idx, learn_mode);
+	if (err)
+		netdev_err(port_priv->netdev, "dpsw_if_set_learning_mode err %d\n", err);
+
+	if (!enable)
+		dpaa2_switch_port_fast_age(port_priv);
+
+	return err;
+}
+
+static int dpaa2_switch_port_pre_bridge_flags(struct net_device *netdev,
+					      struct switchdev_brport_flags flags,
+					      struct netlink_ext_ack *extack)
+{
+	if (flags.mask & ~(BR_LEARNING))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int dpaa2_switch_port_bridge_flags(struct net_device *netdev,
+					  struct switchdev_brport_flags flags,
+					  struct netlink_ext_ack *extack)
+{
+	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	int err;
+
+	if (flags.mask & BR_LEARNING) {
+		bool learn_ena = !!(flags.val & BR_LEARNING);
+
+		err = dpaa2_switch_port_set_learning(port_priv, learn_ena);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int dpaa2_switch_port_attr_set(struct net_device *netdev,
 				      const struct switchdev_attr *attr,
 				      struct netlink_ext_ack *extack)
@@ -1256,6 +1306,12 @@ static int dpaa2_switch_port_attr_set(struct net_device *netdev,
 			return -EOPNOTSUPP;
 		}
 		break;
+	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
+		err = dpaa2_switch_port_pre_bridge_flags(netdev, attr->u.brport_flags, extack);
+		break;
+	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
+		err = dpaa2_switch_port_bridge_flags(netdev, attr->u.brport_flags, extack);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -1504,6 +1560,7 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 	struct ethsw_port_priv *other_port_priv;
 	struct net_device *other_dev;
 	struct list_head *iter;
+	bool learn_ena;
 	int err;
 
 	netdev_for_each_lower_dev(upper_dev, other_dev, iter) {
@@ -1525,6 +1582,10 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 
 	dpaa2_switch_port_set_fdb(port_priv, upper_dev);
 
+	/* Inherit the initial bridge port learning state */
+	learn_ena = br_port_flag_is_set(netdev, BR_LEARNING);
+	err = dpaa2_switch_port_set_learning(port_priv, learn_ena);
+
 	/* Setup the egress flood policy (broadcast, unknown unicast) */
 	err = dpaa2_switch_fdb_set_egress_flood(ethsw, port_priv->fdb->fdb_id);
 	if (err)
@@ -1595,6 +1656,11 @@ static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
 	if (err)
 		return err;
 
+	/* No HW learning when not under a bridge */
+	err = dpaa2_switch_port_set_learning(port_priv, false);
+	if (err)
+		return err;
+
 	/* Add the VLAN 1 as PVID when not under a bridge. We need this since
 	 * the dpaa2 switch interfaces are not capable to be VLAN unaware
 	 */
@@ -2684,6 +2750,10 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	if (err)
 		goto err_port_probe;
 
+	err = dpaa2_switch_port_set_learning(port_priv, false);
+	if (err)
+		goto err_port_probe;
+
 	return 0;
 
 err_port_probe:
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
index 996a59dcd01d..24b17d6e09af 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
@@ -83,6 +83,7 @@
 #define DPSW_CMDID_CTRL_IF_SET_QUEUE        DPSW_CMD_ID(0x0A6)
 
 #define DPSW_CMDID_SET_EGRESS_FLOOD         DPSW_CMD_ID(0x0AC)
+#define DPSW_CMDID_IF_SET_LEARNING_MODE     DPSW_CMD_ID(0x0AD)
 
 /* Macros for accessing command fields smaller than 1byte */
 #define DPSW_MASK(field)        \
@@ -447,5 +448,14 @@ struct dpsw_cmd_set_egress_flood {
 	u8 pad[5];
 	__le64 if_id;
 };
+
+#define DPSW_LEARNING_MODE_SHIFT	0
+#define DPSW_LEARNING_MODE_SIZE		4
+
+struct dpsw_cmd_if_set_learning_mode {
+	__le16 if_id;
+	/* only the first 4 bits from LSB */
+	u8 mode;
+};
 #pragma pack(pop)
 #endif /* __FSL_DPSW_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.c b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
index 56f3c23fce07..6c787d4b85f9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
@@ -1327,3 +1327,30 @@ int dpsw_set_egress_flood(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dpsw_if_set_learning_mode() - Configure the learning mode on an interface.
+ * If this API is used, it will take precedence over the FDB configuration.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @if_id:	InterfaceID
+ * @mode:	Learning mode
+ *
+ * Return:	Completion status. '0' on Success; Error code otherwise.
+ */
+int dpsw_if_set_learning_mode(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			      u16 if_id, enum dpsw_learning_mode mode)
+{
+	struct dpsw_cmd_if_set_learning_mode *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_IF_SET_LEARNING_MODE,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_if_set_learning_mode *)cmd.params;
+	cmd_params->if_id = cpu_to_le16(if_id);
+	dpsw_set_field(cmd_params->mode, LEARNING_MODE, mode);
+
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.h b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
index f108cc61bb27..96837b10cc94 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
@@ -532,11 +532,11 @@ int dpsw_fdb_remove_multicast(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			      u16 fdb_id, const struct dpsw_fdb_multicast_cfg *cfg);
 
 /**
- * enum dpsw_fdb_learning_mode - Auto-learning modes
- * @DPSW_FDB_LEARNING_MODE_DIS: Disable Auto-learning
- * @DPSW_FDB_LEARNING_MODE_HW: Enable HW auto-Learning
- * @DPSW_FDB_LEARNING_MODE_NON_SECURE: Enable None secure learning by CPU
- * @DPSW_FDB_LEARNING_MODE_SECURE: Enable secure learning by CPU
+ * enum dpsw_learning_mode - Auto-learning modes
+ * @DPSW_LEARNING_MODE_DIS: Disable Auto-learning
+ * @DPSW_LEARNING_MODE_HW: Enable HW auto-Learning
+ * @DPSW_LEARNING_MODE_NON_SECURE: Enable None secure learning by CPU
+ * @DPSW_LEARNING_MODE_SECURE: Enable secure learning by CPU
  *
  *	NONE - SECURE LEARNING
  *	SMAC found	DMAC found	CTLU Action
@@ -561,11 +561,11 @@ int dpsw_fdb_remove_multicast(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
  *	-		-		Forward frame to
  *						1.  Control interface
  */
-enum dpsw_fdb_learning_mode {
-	DPSW_FDB_LEARNING_MODE_DIS = 0,
-	DPSW_FDB_LEARNING_MODE_HW = 1,
-	DPSW_FDB_LEARNING_MODE_NON_SECURE = 2,
-	DPSW_FDB_LEARNING_MODE_SECURE = 3
+enum dpsw_learning_mode {
+	DPSW_LEARNING_MODE_DIS = 0,
+	DPSW_LEARNING_MODE_HW = 1,
+	DPSW_LEARNING_MODE_NON_SECURE = 2,
+	DPSW_LEARNING_MODE_SECURE = 3
 };
 
 /**
@@ -579,7 +579,7 @@ enum dpsw_fdb_learning_mode {
 struct dpsw_fdb_attr {
 	u16 max_fdb_entries;
 	u16 fdb_ageing_time;
-	enum dpsw_fdb_learning_mode learning_mode;
+	enum dpsw_learning_mode learning_mode;
 	u16 num_fdb_mc_groups;
 	u16 max_fdb_mc_groups;
 };
@@ -625,4 +625,7 @@ struct dpsw_egress_flood_cfg {
 int dpsw_set_egress_flood(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			  const struct dpsw_egress_flood_cfg *cfg);
 
+int dpsw_if_set_learning_mode(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			      u16 if_id, enum dpsw_learning_mode mode);
+
 #endif /* __FSL_DPSW_H */
-- 
2.30.0

