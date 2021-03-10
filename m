Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472D2333C69
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbhCJMQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbhCJMPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:15:43 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF57C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:42 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ci14so38155022ejc.7
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B6GlubZpY1Z480WXP4bLpT5AOkc5jKeSGUPbCol/7MU=;
        b=MefmRfUXdGpAi3/XPNmRymKX0wpYO+SRBWO2P1RJo3RA7RRjrow5rnqSQgdeDMCEnZ
         9jIQZ3lHGgphcBfm5Ymle2ba8OoNSZjzsOGAidtwXjc2iPKVhfsSfOvp3D+SDnltRlB5
         qRmaGPSS8gxnnfrL1zWceBHqoAlYcMK9bfQMX2le+THNQrnwdHAZ/S0PmGxHptp9IJ1E
         RwQGX7U38+4U6YR8CBiTndHlKyabCxHapQnZwPYU2QQ6sLu0TBZIrc9Gl1tzZkb3b3y/
         qKoIO5cvES+9+83hQcLxijBTDVbqkggf6Ey6/DaDXLe+1luBakug1GcLCF13klE1WaE7
         ZjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B6GlubZpY1Z480WXP4bLpT5AOkc5jKeSGUPbCol/7MU=;
        b=a7d+btwE3UPRANbMety0Tig2pohux5Lay9KceJgaclUsQCKatRC1kMVSVw436fB3LB
         PnOhw8PAb/PoKIdJrzmN575Pvx+xI0BihKcSkPI1kijHAtce4BRGhd1xkde68Mn7GQLA
         rbGgFiZqPdxMzGclODxAW8eaeV5ktqQMUs0EE66OBe3PPBBlpdV28aUN/CRbOTQi8psr
         k9sPo7Jf4Tn6026zJyqRF7gA7yZXrUwF9hy3ngD9YwaWfqnrVj5jAEoDsR5zugKKmiYt
         CLARPu75La1GPk3XjN7IrXr+h2NzVz/Ci3EHDbWWa0NDIb+v4cOCIDyPuEz6PCyw4Bcs
         11oA==
X-Gm-Message-State: AOAM533SBYWc/zinjnskUYEK76DagSTj+jY2yX7HVor5sWarbgrl8D7G
        oePMNMtLfcn5BfFJ/uYaKRs=
X-Google-Smtp-Source: ABdhPJz5fjv9d+kN0PbJnbvWAe32K2/QBdk7xmRmW0NO6Eg4UWIsvtyAu8KnO2mZwTNCwGxLNZFKSA==
X-Received: by 2002:a17:907:2093:: with SMTP id pv19mr3381221ejb.134.1615378541319;
        Wed, 10 Mar 2021 04:15:41 -0800 (PST)
Received: from yoga-910.localhost ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v15sm4865527edw.28.2021.03.10.04.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:15:40 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        jiri@resnulli.us, ruxandra.radulescu@nxp.com,
        netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 10/15] staging: dpaa2-switch: properly setup switching domains
Date:   Wed, 10 Mar 2021 14:14:47 +0200
Message-Id: <20210310121452.552070-11-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210310121452.552070-1-ciorneiioana@gmail.com>
References: <20210310121452.552070-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Until now, the DPAA2 switch was not capable to properly setup its
switching domains depending on the existence, or lack thereof, of a
upper bridge device. This meant that all switch ports of a DPSW object
were switching by default even though they were not under the same
bridge device.

Another issue was the inability to actually add the CPU in the flooding
domains (broadcast, unknown unicast etc) of a particular switch port.
This meant that a simple ping on a switch interface was not possible
since no broadcast ARP frame would actually reach the CPU queues.

This patch tries to fix exactly these problems by:

* Creating and managing a FDB table for each flooding domain. This means
  that when a switch interface is not bridged it will use its own FDB
  table. While in bridged mode all DPAA2 switch interfaces under the
  same upper will use the same FDB table, thus leverage the same FDB
  entries.

* Adding a new MC firmware command - dpsw_set_egress_flood() - through
  which the driver can setup the flooding domains as needed. For
  example, when the switch interface is standalone, thus not in a
  bridge with any other DPAA2 switch port, it will setup its broadcast
  and unknown unicast flooding domains to only include the control
  interface (the queues that reach the CPU and the driver can dequeue
  from). This flooding domain changes when the interface joins a bridge
  and is configured to include, beside the control interface, all other
  DPAA2 switch interfaces.

We impose a minimum limit of FDB tables available equal to the number of
switch interfaces so that we guarantee that, in the maximal
configuration - all interfaces are standalone, each switch port will
have a private FDB table. At the same time, we only probe DPSW objects
that have the flooding and broadcast replicators configured to be per
FDB (DPSW_*_PER_FDB). Without this, the dpaa2-switch driver would not
be able to configure multiple switching domains.

At probe time, a FDB table will be allocated for each port. At a bridge
join event, the switch port will either continue to use the current FDB
table (if it's the first dpaa2-switch port to join that bridge) or will
switch to use the FDB table associated with the port that it's already
under the bridge. If a FDB switch is necessary, the private FDB table
which was previously used will be returned to the pool of unused FDBs.

Upon a bridge leave, the switch port needs a private FDB table thus it
will search and get the first unused FDB table. This way, all the other
ports remaining under the bridge will continue to use the same FDB
table.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |  38 ++-
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     |  90 +++++-
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     |  76 ++++-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 321 +++++++++++++++++++--
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    |  30 +-
 5 files changed, 514 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index 6f1b9d16a09f..eb620e832412 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -29,7 +29,7 @@
 
 #define DPSW_CMDID_ENABLE                   DPSW_CMD_ID(0x002)
 #define DPSW_CMDID_DISABLE                  DPSW_CMD_ID(0x003)
-#define DPSW_CMDID_GET_ATTR                 DPSW_CMD_ID(0x004)
+#define DPSW_CMDID_GET_ATTR                 DPSW_CMD_V2(0x004)
 #define DPSW_CMDID_RESET                    DPSW_CMD_ID(0x005)
 
 #define DPSW_CMDID_SET_IRQ_ENABLE           DPSW_CMD_ID(0x012)
@@ -58,7 +58,7 @@
 #define DPSW_CMDID_IF_SET_LINK_CFG          DPSW_CMD_ID(0x04C)
 
 #define DPSW_CMDID_VLAN_ADD                 DPSW_CMD_ID(0x060)
-#define DPSW_CMDID_VLAN_ADD_IF              DPSW_CMD_ID(0x061)
+#define DPSW_CMDID_VLAN_ADD_IF              DPSW_CMD_V2(0x061)
 #define DPSW_CMDID_VLAN_ADD_IF_UNTAGGED     DPSW_CMD_ID(0x062)
 
 #define DPSW_CMDID_VLAN_REMOVE_IF           DPSW_CMD_ID(0x064)
@@ -66,6 +66,8 @@
 #define DPSW_CMDID_VLAN_REMOVE_IF_FLOODING  DPSW_CMD_ID(0x066)
 #define DPSW_CMDID_VLAN_REMOVE              DPSW_CMD_ID(0x067)
 
+#define DPSW_CMDID_FDB_ADD                  DPSW_CMD_ID(0x082)
+#define DPSW_CMDID_FDB_REMOVE               DPSW_CMD_ID(0x083)
 #define DPSW_CMDID_FDB_ADD_UNICAST          DPSW_CMD_ID(0x084)
 #define DPSW_CMDID_FDB_REMOVE_UNICAST       DPSW_CMD_ID(0x085)
 #define DPSW_CMDID_FDB_ADD_MULTICAST        DPSW_CMD_ID(0x086)
@@ -82,6 +84,8 @@
 #define DPSW_CMDID_CTRL_IF_DISABLE          DPSW_CMD_ID(0x0A3)
 #define DPSW_CMDID_CTRL_IF_SET_QUEUE        DPSW_CMD_ID(0x0A6)
 
+#define DPSW_CMDID_SET_EGRESS_FLOOD         DPSW_CMD_ID(0x0AC)
+
 /* Macros for accessing command fields smaller than 1byte */
 #define DPSW_MASK(field)        \
 	GENMASK(DPSW_##field##_SHIFT + DPSW_##field##_SIZE - 1, \
@@ -176,6 +180,12 @@ struct dpsw_cmd_clear_irq_status {
 #define DPSW_COMPONENT_TYPE_SHIFT	0
 #define DPSW_COMPONENT_TYPE_SIZE	4
 
+#define DPSW_FLOODING_CFG_SHIFT		0
+#define DPSW_FLOODING_CFG_SIZE		4
+
+#define DPSW_BROADCAST_CFG_SHIFT	4
+#define DPSW_BROADCAST_CFG_SIZE		4
+
 struct dpsw_rsp_get_attr {
 	/* cmd word 0 */
 	__le16 num_ifs;
@@ -193,7 +203,11 @@ struct dpsw_rsp_get_attr {
 	u8 max_meters_per_if;
 	/* from LSB only the first 4 bits */
 	u8 component_type;
-	__le16 pad;
+	/* [0:3] - flooding configuration
+	 * [4:7] - broadcast configuration
+	 */
+	u8 repl_cfg;
+	u8 pad;
 	/* cmd word 3 */
 	__le64 options;
 };
@@ -312,6 +326,16 @@ struct dpsw_vlan_add {
 	__le16 vlan_id;
 };
 
+struct dpsw_cmd_vlan_add_if {
+	/* cmd word 0 */
+	__le16 options;
+	__le16 vlan_id;
+	__le16 fdb_id;
+	__le16 pad0;
+	/* cmd word 1-4 */
+	__le64 if_id;
+};
+
 struct dpsw_cmd_vlan_manage_if {
 	/* cmd word 0 */
 	__le16 pad0;
@@ -328,7 +352,7 @@ struct dpsw_cmd_vlan_remove {
 
 struct dpsw_cmd_fdb_add {
 	__le32 pad;
-	__le16 fdb_aging_time;
+	__le16 fdb_ageing_time;
 	__le16 num_fdb_entries;
 };
 
@@ -424,5 +448,11 @@ struct dpsw_cmd_if_set_mac_addr {
 	u8 mac_addr[6];
 };
 
+struct dpsw_cmd_set_egress_flood {
+	__le16 fdb_id;
+	u8 flood_type;
+	u8 pad[5];
+	__le64 if_id;
+};
 #pragma pack(pop)
 #endif /* __FSL_DPSW_CMD_H */
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
index edc7559b7b1e..5189f156100e 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -351,9 +351,9 @@ int dpsw_get_attributes(struct fsl_mc_io *mc_io,
 	attr->max_fdb_mc_groups = le16_to_cpu(rsp_params->max_fdb_mc_groups);
 	attr->max_meters_per_if = rsp_params->max_meters_per_if;
 	attr->options = le64_to_cpu(rsp_params->options);
-	attr->component_type = dpsw_get_field(rsp_params->component_type,
-					      COMPONENT_TYPE);
-
+	attr->component_type = dpsw_get_field(rsp_params->component_type, COMPONENT_TYPE);
+	attr->flooding_cfg = dpsw_get_field(rsp_params->repl_cfg, FLOODING_CFG);
+	attr->broadcast_cfg = dpsw_get_field(rsp_params->repl_cfg, BROADCAST_CFG);
 	return 0;
 }
 
@@ -924,6 +924,66 @@ int dpsw_vlan_remove(struct fsl_mc_io *mc_io,
 	return mc_send_command(mc_io, &cmd);
 }
 
+/**
+ * dpsw_fdb_add() - Add FDB to switch and Returns handle to FDB table for
+ *		the reference
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @fdb_id:	Returned Forwarding Database Identifier
+ * @cfg:	FDB Configuration
+ *
+ * Return:	Completion status. '0' on Success; Error code otherwise.
+ */
+int dpsw_fdb_add(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 *fdb_id,
+		 const struct dpsw_fdb_cfg *cfg)
+{
+	struct dpsw_cmd_fdb_add *cmd_params;
+	struct dpsw_rsp_fdb_add *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_FDB_ADD,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_fdb_add *)cmd.params;
+	cmd_params->fdb_ageing_time = cpu_to_le16(cfg->fdb_ageing_time);
+	cmd_params->num_fdb_entries = cpu_to_le16(cfg->num_fdb_entries);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dpsw_rsp_fdb_add *)cmd.params;
+	*fdb_id = le16_to_cpu(rsp_params->fdb_id);
+
+	return 0;
+}
+
+/**
+ * dpsw_fdb_remove() - Remove FDB from switch
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @fdb_id:	Forwarding Database Identifier
+ *
+ * Return:	Completion status. '0' on Success; Error code otherwise.
+ */
+int dpsw_fdb_remove(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 fdb_id)
+{
+	struct dpsw_cmd_fdb_remove *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_FDB_REMOVE,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_fdb_remove *)cmd.params;
+	cmd_params->fdb_id = cpu_to_le16(fdb_id);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
 /**
  * dpsw_fdb_add_unicast() - Function adds an unicast entry into MAC lookup table
  * @mc_io:	Pointer to MC portal's I/O object
@@ -1400,3 +1460,27 @@ int dpsw_ctrl_if_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
 
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dpsw_set_egress_flood() - Set egress parameters associated with an FDB ID
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @cfg:	Egress flooding configuration
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_set_egress_flood(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			  const struct dpsw_egress_flood_cfg *cfg)
+{
+	struct dpsw_cmd_set_egress_flood *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_SET_EGRESS_FLOOD, cmd_flags, token);
+	cmd_params = (struct dpsw_cmd_set_egress_flood *)cmd.params;
+	cmd_params->fdb_id = cpu_to_le16(cfg->fdb_id);
+	cmd_params->flood_type = cfg->flood_type;
+	build_if_id_bitmap(&cmd_params->if_id, cfg->if_id, cfg->num_ifs);
+
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index 954aa4401cd9..9e04350f3277 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -75,6 +75,35 @@ enum dpsw_component_type {
 	DPSW_COMPONENT_TYPE_S_VLAN
 };
 
+/**
+ *  enum dpsw_flooding_cfg - flooding configuration requested
+ * @DPSW_FLOODING_PER_VLAN: Flooding replicators are allocated per VLAN and
+ * interfaces present in each of them can be configured using
+ * dpsw_vlan_add_if_flooding()/dpsw_vlan_remove_if_flooding().
+ * This is the default configuration.
+ *
+ * @DPSW_FLOODING_PER_FDB: Flooding replicators are allocated per FDB and
+ * interfaces present in each of them can be configured using
+ * dpsw_set_egress_flood().
+ */
+enum dpsw_flooding_cfg {
+	DPSW_FLOODING_PER_VLAN = 0,
+	DPSW_FLOODING_PER_FDB,
+};
+
+/**
+ * enum dpsw_broadcast_cfg - broadcast configuration requested
+ * @DPSW_BROADCAST_PER_OBJECT: There is only one broadcast replicator per DPSW
+ * object. This is the default configuration.
+ * @DPSW_BROADCAST_PER_FDB: Broadcast replicators are allocated per FDB and
+ * interfaces present in each of them can be configured using
+ * dpsw_set_egress_flood().
+ */
+enum dpsw_broadcast_cfg {
+	DPSW_BROADCAST_PER_OBJECT = 0,
+	DPSW_BROADCAST_PER_FDB,
+};
+
 int dpsw_enable(struct fsl_mc_io *mc_io,
 		u32 cmd_flags,
 		u16 token);
@@ -153,6 +182,8 @@ int dpsw_clear_irq_status(struct fsl_mc_io *mc_io,
  * @num_vlans: Current number of VLANs
  * @num_fdbs: Current number of FDBs
  * @component_type: Component type of this bridge
+ * @flooding_cfg: Flooding configuration (PER_VLAN - default, PER_FDB)
+ * @broadcast_cfg: Broadcast configuration (PER_OBJECT - default, PER_FDB)
  */
 struct dpsw_attr {
 	int id;
@@ -168,6 +199,8 @@ struct dpsw_attr {
 	u16 num_vlans;
 	u8 num_fdbs;
 	enum dpsw_component_type component_type;
+	enum dpsw_flooding_cfg flooding_cfg;
+	enum dpsw_broadcast_cfg broadcast_cfg;
 };
 
 int dpsw_get_attributes(struct fsl_mc_io *mc_io,
@@ -483,6 +516,8 @@ int dpsw_vlan_add(struct fsl_mc_io *mc_io,
 		  u16 vlan_id,
 		  const struct dpsw_vlan_cfg *cfg);
 
+#define DPSW_VLAN_ADD_IF_OPT_FDB_ID            0x0001
+
 /**
  * struct dpsw_vlan_if_cfg - Set of VLAN Interfaces
  * @num_ifs: The number of interfaces that are assigned to the egress
@@ -492,7 +527,9 @@ int dpsw_vlan_add(struct fsl_mc_io *mc_io,
  */
 struct dpsw_vlan_if_cfg {
 	u16 num_ifs;
+	u16 options;
 	u16 if_id[DPSW_MAX_IF];
+	u16 fdb_id;
 };
 
 int dpsw_vlan_add_if(struct fsl_mc_io *mc_io,
@@ -649,14 +686,14 @@ enum dpsw_fdb_learning_mode {
 /**
  * struct dpsw_fdb_attr - FDB Attributes
  * @max_fdb_entries: Number of FDB entries
- * @fdb_aging_time: Aging time in seconds
+ * @fdb_ageing_time: Ageing time in seconds
  * @learning_mode: Learning mode
  * @num_fdb_mc_groups: Current number of multicast groups
  * @max_fdb_mc_groups: Maximum number of multicast groups
  */
 struct dpsw_fdb_attr {
 	u16 max_fdb_entries;
-	u16 fdb_aging_time;
+	u16 fdb_ageing_time;
 	enum dpsw_fdb_learning_mode learning_mode;
 	u16 num_fdb_mc_groups;
 	u16 max_fdb_mc_groups;
@@ -676,4 +713,39 @@ int dpsw_if_get_primary_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags,
 int dpsw_if_set_primary_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags,
 				 u16 token, u16 if_id, u8 mac_addr[6]);
 
+/**
+ * struct dpsw_fdb_cfg  - FDB Configuration
+ * @num_fdb_entries: Number of FDB entries
+ * @fdb_ageing_time: Ageing time in seconds
+ */
+struct dpsw_fdb_cfg {
+	u16 num_fdb_entries;
+	u16 fdb_ageing_time;
+};
+
+int dpsw_fdb_add(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 *fdb_id,
+		 const struct dpsw_fdb_cfg *cfg);
+
+int dpsw_fdb_remove(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 fdb_id);
+
+/**
+ * enum dpsw_flood_type - Define the flood type of a DPSW object
+ * @DPSW_BROADCAST: Broadcast flooding
+ * @DPSW_FLOODING: Unknown flooding
+ */
+enum dpsw_flood_type {
+	DPSW_BROADCAST = 0,
+	DPSW_FLOODING,
+};
+
+struct dpsw_egress_flood_cfg {
+	u16 fdb_id;
+	enum dpsw_flood_type flood_type;
+	u16 num_ifs;
+	u16 if_id[DPSW_MAX_IF];
+};
+
+int dpsw_set_egress_flood(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+			  const struct dpsw_egress_flood_cfg *cfg);
+
 #endif /* __FSL_DPSW_H */
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 41860187cba5..5be07181399d 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -25,6 +25,91 @@
 
 #define DEFAULT_VLAN_ID			1
 
+static u16 dpaa2_switch_port_get_fdb_id(struct ethsw_port_priv *port_priv)
+{
+	return port_priv->fdb->fdb_id;
+}
+
+static struct dpaa2_switch_fdb *dpaa2_switch_fdb_get_unused(struct ethsw_core *ethsw)
+{
+	int i;
+
+	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
+		if (!ethsw->fdbs[i].in_use)
+			return &ethsw->fdbs[i];
+	return NULL;
+}
+
+static u16 dpaa2_switch_port_set_fdb(struct ethsw_port_priv *port_priv,
+				     struct net_device *bridge_dev)
+{
+	struct ethsw_port_priv *other_port_priv = NULL;
+	struct dpaa2_switch_fdb *fdb;
+	struct net_device *other_dev;
+	struct list_head *iter;
+
+	/* If we leave a bridge (bridge_dev is NULL), find an unused
+	 * FDB and use that.
+	 */
+	if (!bridge_dev) {
+		fdb = dpaa2_switch_fdb_get_unused(port_priv->ethsw_data);
+
+		/* If there is no unused FDB, we must be the last port that
+		 * leaves the last bridge, all the others are standalone. We
+		 * can just keep the FDB that we already have.
+		 */
+
+		if (!fdb) {
+			port_priv->fdb->bridge_dev = NULL;
+			return 0;
+		}
+
+		port_priv->fdb = fdb;
+		port_priv->fdb->in_use = true;
+		port_priv->fdb->bridge_dev = NULL;
+		return 0;
+	}
+
+	/* The below call to netdev_for_each_lower_dev() demands the RTNL lock
+	 * being held. Assert on it so that it's easier to catch new code
+	 * paths that reach this point without the RTNL lock.
+	 */
+	ASSERT_RTNL();
+
+	/* If part of a bridge, use the FDB of the first dpaa2 switch interface
+	 * to be present in that bridge
+	 */
+	netdev_for_each_lower_dev(bridge_dev, other_dev, iter) {
+		if (!dpaa2_switch_port_dev_check(other_dev, NULL))
+			continue;
+
+		if (other_dev == port_priv->netdev)
+			continue;
+
+		other_port_priv = netdev_priv(other_dev);
+		break;
+	}
+
+	/* The current port is about to change its FDB to the one used by the
+	 * first port that joined the bridge.
+	 */
+	if (other_port_priv) {
+		/* The previous FDB is about to become unused, since the
+		 * interface is no longer standalone.
+		 */
+		port_priv->fdb->in_use = false;
+		port_priv->fdb->bridge_dev = NULL;
+
+		/* Get a reference to the new FDB */
+		port_priv->fdb = other_port_priv->fdb;
+	}
+
+	/* Keep track of the new upper bridge device */
+	port_priv->fdb->bridge_dev = bridge_dev;
+
+	return 0;
+}
+
 static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
 				dma_addr_t iova_addr)
 {
@@ -35,14 +120,13 @@ static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
 	return phys_to_virt(phys_addr);
 }
 
-static int dpaa2_switch_add_vlan(struct ethsw_core *ethsw, u16 vid)
+static int dpaa2_switch_add_vlan(struct ethsw_port_priv *port_priv, u16 vid)
 {
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct dpsw_vlan_cfg vcfg = {0};
 	int err;
 
-	struct dpsw_vlan_cfg	vcfg = {
-		.fdb_id = 0,
-	};
-
+	vcfg.fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
 	err = dpsw_vlan_add(ethsw->mc_io, 0,
 			    ethsw->dpsw_handle, vid, &vcfg);
 	if (err) {
@@ -133,7 +217,7 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
 {
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct net_device *netdev = port_priv->netdev;
-	struct dpsw_vlan_if_cfg vcfg;
+	struct dpsw_vlan_if_cfg vcfg = {0};
 	int err;
 
 	if (port_priv->vlans[vid]) {
@@ -141,8 +225,13 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
 		return -EEXIST;
 	}
 
+	/* If hit, this VLAN rule will lead the packet into the FDB table
+	 * specified in the vlan configuration below
+	 */
 	vcfg.num_ifs = 1;
 	vcfg.if_id[0] = port_priv->idx;
+	vcfg.fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
+	vcfg.options |= DPSW_VLAN_ADD_IF_OPT_FDB_ID;
 	err = dpsw_vlan_add_if(ethsw->mc_io, 0, ethsw->dpsw_handle, vid, &vcfg);
 	if (err) {
 		netdev_err(netdev, "dpsw_vlan_add_if err %d\n", err);
@@ -229,15 +318,17 @@ static int dpaa2_switch_port_fdb_add_uc(struct ethsw_port_priv *port_priv,
 					const unsigned char *addr)
 {
 	struct dpsw_fdb_unicast_cfg entry = {0};
+	u16 fdb_id;
 	int err;
 
 	entry.if_egress = port_priv->idx;
 	entry.type = DPSW_FDB_ENTRY_STATIC;
 	ether_addr_copy(entry.mac_addr, addr);
 
+	fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
 	err = dpsw_fdb_add_unicast(port_priv->ethsw_data->mc_io, 0,
 				   port_priv->ethsw_data->dpsw_handle,
-				   0, &entry);
+				   fdb_id, &entry);
 	if (err)
 		netdev_err(port_priv->netdev,
 			   "dpsw_fdb_add_unicast err %d\n", err);
@@ -248,15 +339,17 @@ static int dpaa2_switch_port_fdb_del_uc(struct ethsw_port_priv *port_priv,
 					const unsigned char *addr)
 {
 	struct dpsw_fdb_unicast_cfg entry = {0};
+	u16 fdb_id;
 	int err;
 
 	entry.if_egress = port_priv->idx;
 	entry.type = DPSW_FDB_ENTRY_STATIC;
 	ether_addr_copy(entry.mac_addr, addr);
 
+	fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
 	err = dpsw_fdb_remove_unicast(port_priv->ethsw_data->mc_io, 0,
 				      port_priv->ethsw_data->dpsw_handle,
-				      0, &entry);
+				      fdb_id, &entry);
 	/* Silently discard error for calling multiple times the del command */
 	if (err && err != -ENXIO)
 		netdev_err(port_priv->netdev,
@@ -268,6 +361,7 @@ static int dpaa2_switch_port_fdb_add_mc(struct ethsw_port_priv *port_priv,
 					const unsigned char *addr)
 {
 	struct dpsw_fdb_multicast_cfg entry = {0};
+	u16 fdb_id;
 	int err;
 
 	ether_addr_copy(entry.mac_addr, addr);
@@ -275,9 +369,10 @@ static int dpaa2_switch_port_fdb_add_mc(struct ethsw_port_priv *port_priv,
 	entry.num_ifs = 1;
 	entry.if_id[0] = port_priv->idx;
 
+	fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
 	err = dpsw_fdb_add_multicast(port_priv->ethsw_data->mc_io, 0,
 				     port_priv->ethsw_data->dpsw_handle,
-				     0, &entry);
+				     fdb_id, &entry);
 	/* Silently discard error for calling multiple times the add command */
 	if (err && err != -ENXIO)
 		netdev_err(port_priv->netdev, "dpsw_fdb_add_multicast err %d\n",
@@ -289,6 +384,7 @@ static int dpaa2_switch_port_fdb_del_mc(struct ethsw_port_priv *port_priv,
 					const unsigned char *addr)
 {
 	struct dpsw_fdb_multicast_cfg entry = {0};
+	u16 fdb_id;
 	int err;
 
 	ether_addr_copy(entry.mac_addr, addr);
@@ -296,9 +392,10 @@ static int dpaa2_switch_port_fdb_del_mc(struct ethsw_port_priv *port_priv,
 	entry.num_ifs = 1;
 	entry.if_id[0] = port_priv->idx;
 
+	fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
 	err = dpsw_fdb_remove_multicast(port_priv->ethsw_data->mc_io, 0,
 					port_priv->ethsw_data->dpsw_handle,
-					0, &entry);
+					fdb_id, &entry);
 	/* Silently discard error for calling multiple times the del command */
 	if (err && err != -ENAVAIL)
 		netdev_err(port_priv->netdev,
@@ -652,6 +749,7 @@ static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callba
 	u32 fdb_dump_size;
 	int err = 0, i;
 	u8 *dma_mem;
+	u16 fdb_id;
 
 	fdb_dump_size = ethsw->sw_attr.max_fdb_entries * sizeof(fdb_entry);
 	dma_mem = kzalloc(fdb_dump_size, GFP_KERNEL);
@@ -666,7 +764,8 @@ static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callba
 		goto err_map;
 	}
 
-	err = dpsw_fdb_dump(ethsw->mc_io, 0, ethsw->dpsw_handle, 0,
+	fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
+	err = dpsw_fdb_dump(ethsw->mc_io, 0, ethsw->dpsw_handle, fdb_id,
 			    fdb_dump_iova, fdb_dump_size, &num_fdb_entries);
 	if (err) {
 		netdev_err(net_dev, "dpsw_fdb_dump() = %d\n", err);
@@ -888,8 +987,8 @@ static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_get_phys_port_name = dpaa2_switch_port_get_phys_name,
 };
 
-static bool dpaa2_switch_port_dev_check(const struct net_device *netdev,
-					struct notifier_block *nb)
+bool dpaa2_switch_port_dev_check(const struct net_device *netdev,
+				 struct notifier_block *nb)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 
@@ -1080,7 +1179,7 @@ static int dpaa2_switch_port_vlans_add(struct net_device *netdev,
 
 	if (!port_priv->ethsw_data->vlans[vlan->vid]) {
 		/* this is a new VLAN */
-		err = dpaa2_switch_add_vlan(port_priv->ethsw_data, vlan->vid);
+		err = dpaa2_switch_add_vlan(port_priv, vlan->vid);
 		if (err)
 			return err;
 
@@ -1163,7 +1262,11 @@ static int dpaa2_switch_port_del_vlan(struct ethsw_port_priv *port_priv, u16 vid
 		return -ENOENT;
 
 	if (port_priv->vlans[vid] & ETHSW_VLAN_PVID) {
-		err = dpaa2_switch_port_set_pvid(port_priv, 0);
+		/* If we are deleting the PVID of a port, use VLAN 4095 instead
+		 * as we are sure that neither the bridge nor the 8021q module
+		 * will use it
+		 */
+		err = dpaa2_switch_port_set_pvid(port_priv, 4095);
 		if (err)
 			return err;
 	}
@@ -1273,7 +1376,48 @@ static int dpaa2_switch_port_attr_set_event(struct net_device *netdev,
 	return notifier_from_errno(err);
 }
 
-/* For the moment, only flood setting needs to be updated */
+static int dpaa2_switch_fdb_set_egress_flood(struct ethsw_core *ethsw, u16 fdb_id)
+{
+	struct dpsw_egress_flood_cfg flood_cfg;
+	int i = 0, j;
+	int err;
+
+	/* Add all the DPAA2 switch ports found in the same bridging domain to
+	 * the egress flooding domain
+	 */
+	for (j = 0; j < ethsw->sw_attr.num_ifs; j++)
+		if (ethsw->ports[j] && ethsw->ports[j]->fdb->fdb_id == fdb_id)
+			flood_cfg.if_id[i++] = ethsw->ports[j]->idx;
+
+	/* Add the CTRL interface to the egress flooding domain */
+	flood_cfg.if_id[i++] = ethsw->sw_attr.num_ifs;
+
+	/* Use the FDB of the first dpaa2 switch port added to the bridge */
+	flood_cfg.fdb_id = fdb_id;
+
+	/* Setup broadcast flooding domain */
+	flood_cfg.flood_type = DPSW_BROADCAST;
+	flood_cfg.num_ifs = i;
+	err = dpsw_set_egress_flood(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				    &flood_cfg);
+	if (err) {
+		dev_err(ethsw->dev, "dpsw_set_egress_flood() = %d\n", err);
+		return err;
+	}
+
+	/* Setup unknown flooding domain */
+	flood_cfg.flood_type = DPSW_FLOODING;
+	flood_cfg.num_ifs = i;
+	err = dpsw_set_egress_flood(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				    &flood_cfg);
+	if (err) {
+		dev_err(ethsw->dev, "dpsw_set_egress_flood() = %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 					 struct net_device *upper_dev)
 {
@@ -1282,15 +1426,7 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 	struct ethsw_port_priv *other_port_priv;
 	struct net_device *other_dev;
 	struct list_head *iter;
-	int i, err;
-
-	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
-		if (ethsw->ports[i]->bridge_dev &&
-		    (ethsw->ports[i]->bridge_dev != upper_dev)) {
-			netdev_err(netdev,
-				   "Only one bridge supported per DPSW object!\n");
-			return -EINVAL;
-		}
+	int err;
 
 	netdev_for_each_lower_dev(upper_dev, other_dev, iter) {
 		if (!dpaa2_switch_port_dev_check(other_dev, NULL))
@@ -1304,9 +1440,87 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 		}
 	}
 
+	/* Delete the previously manually installed VLAN 1 */
+	err = dpaa2_switch_port_del_vlan(port_priv, 1);
+	if (err)
+		return err;
+
+	dpaa2_switch_port_set_fdb(port_priv, upper_dev);
+
+	/* Setup the egress flood policy (broadcast, unknown unicast) */
+	err = dpaa2_switch_fdb_set_egress_flood(ethsw, port_priv->fdb->fdb_id);
+	if (err)
+		goto err_egress_flood;
+
+	return 0;
+
+err_egress_flood:
+	dpaa2_switch_port_set_fdb(port_priv, NULL);
 	return err;
 }
 
+static int dpaa2_switch_port_clear_rxvlan(struct net_device *vdev, int vid, void *arg)
+{
+	__be16 vlan_proto = htons(ETH_P_8021Q);
+
+	if (vdev)
+		vlan_proto = vlan_dev_vlan_proto(vdev);
+
+	return dpaa2_switch_port_vlan_kill(arg, vlan_proto, vid);
+}
+
+static int dpaa2_switch_port_restore_rxvlan(struct net_device *vdev, int vid, void *arg)
+{
+	__be16 vlan_proto = htons(ETH_P_8021Q);
+
+	if (vdev)
+		vlan_proto = vlan_dev_vlan_proto(vdev);
+
+	return dpaa2_switch_port_vlan_add(arg, vlan_proto, vid);
+}
+
+static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
+{
+	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	struct dpaa2_switch_fdb *old_fdb = port_priv->fdb;
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	int err;
+
+	/* Clear all RX VLANs installed through vlan_vid_add() either as VLAN
+	 * upper devices or otherwise from the FDB table that we are about to
+	 * leave
+	 */
+	err = vlan_for_each(netdev, dpaa2_switch_port_clear_rxvlan, netdev);
+	if (err)
+		netdev_err(netdev, "Unable to clear RX VLANs from old FDB table, err (%d)\n", err);
+
+	dpaa2_switch_port_set_fdb(port_priv, NULL);
+
+	/* Restore all RX VLANs into the new FDB table that we just joined */
+	err = vlan_for_each(netdev, dpaa2_switch_port_restore_rxvlan, netdev);
+	if (err)
+		netdev_err(netdev, "Unable to restore RX VLANs to the new FDB, err (%d)\n", err);
+
+	/* Setup the egress flood policy (broadcast, unknown unicast).
+	 * When the port is not under a bridge, only the CTRL interface is part
+	 * of the flooding domain besides the actual port
+	 */
+	err = dpaa2_switch_fdb_set_egress_flood(ethsw, port_priv->fdb->fdb_id);
+	if (err)
+		return err;
+
+	/* Recreate the egress flood domain of the FDB that we just left */
+	err = dpaa2_switch_fdb_set_egress_flood(ethsw, old_fdb->fdb_id);
+	if (err)
+		return err;
+
+	/* Add the VLAN 1 as PVID when not under a bridge. We need this since
+	 * the dpaa2 switch interfaces are not capable to be VLAN unaware
+	 */
+	return dpaa2_switch_port_add_vlan(port_priv, DEFAULT_VLAN_ID,
+					  BRIDGE_VLAN_INFO_UNTAGGED | BRIDGE_VLAN_INFO_PVID);
+}
+
 static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 					     unsigned long event, void *ptr)
 {
@@ -1324,6 +1538,8 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 		if (netif_is_bridge_master(upper_dev)) {
 			if (info->linking)
 				err = dpaa2_switch_port_bridge_join(netdev, upper_dev);
+			else
+				err = dpaa2_switch_port_bridge_leave(netdev);
 		}
 	}
 
@@ -2202,6 +2418,10 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 		goto err_close;
 	}
 
+	err = dpsw_fdb_remove(ethsw->mc_io, 0, ethsw->dpsw_handle, 0);
+	if (err)
+		goto err_destroy_ordered_workqueue;
+
 	err = dpaa2_switch_ctrl_if_setup(ethsw);
 	if (err)
 		goto err_destroy_ordered_workqueue;
@@ -2229,7 +2449,10 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	};
 	struct net_device *netdev = port_priv->netdev;
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct dpsw_fdb_cfg fdb_cfg = {0};
+	struct dpaa2_switch_fdb *fdb;
 	struct dpsw_if_attr dpsw_if_attr;
+	u16 fdb_id;
 	int err;
 
 	/* Get the Tx queue for this specific port */
@@ -2241,6 +2464,22 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	}
 	port_priv->tx_qdid = dpsw_if_attr.qdid;
 
+	/* Create a FDB table for this particular switch port */
+	fdb_cfg.num_fdb_entries = ethsw->sw_attr.max_fdb_entries / ethsw->sw_attr.num_ifs;
+	err = dpsw_fdb_add(ethsw->mc_io, 0, ethsw->dpsw_handle,
+			   &fdb_id, &fdb_cfg);
+	if (err) {
+		netdev_err(netdev, "dpsw_fdb_add err %d\n", err);
+		return err;
+	}
+
+	/* Find an unused dpaa2_switch_fdb structure and use it */
+	fdb = dpaa2_switch_fdb_get_unused(ethsw);
+	fdb->fdb_id = fdb_id;
+	fdb->in_use = true;
+	fdb->bridge_dev = NULL;
+	port_priv->fdb = fdb;
+
 	/* We need to add VLAN 1 as the PVID on this port until it is under a
 	 * bridge since the DPAA2 switch is not able to handle the traffic in a
 	 * VLAN unaware fashion
@@ -2249,6 +2488,11 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	if (err)
 		return err;
 
+	/* Setup the egress flooding domains (broadcast, unknown unicast */
+	err = dpaa2_switch_fdb_set_egress_flood(ethsw, port_priv->fdb->fdb_id);
+	if (err)
+		return err;
+
 	return err;
 }
 
@@ -2319,6 +2563,8 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 		unregister_netdev(port_priv->netdev);
 		free_netdev(port_priv->netdev);
 	}
+
+	kfree(ethsw->fdbs);
 	kfree(ethsw->ports);
 
 	dpaa2_switch_takedown(sw_dev);
@@ -2365,6 +2611,11 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	port_netdev->min_mtu = ETH_MIN_MTU;
 	port_netdev->max_mtu = ETHSW_MAX_FRAME_LENGTH;
 
+	/* Populate the private port structure so that later calls to
+	 * dpaa2_switch_port_init() can use it.
+	 */
+	ethsw->ports[port_idx] = port_priv;
+
 	err = dpaa2_switch_port_init(port_priv, port_idx);
 	if (err)
 		goto err_port_probe;
@@ -2373,12 +2624,11 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 	if (err)
 		goto err_port_probe;
 
-	ethsw->ports[port_idx] = port_priv;
-
 	return 0;
 
 err_port_probe:
 	free_netdev(port_netdev);
+	ethsw->ports[port_idx] = NULL;
 
 	return err;
 }
@@ -2420,10 +2670,17 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 		goto err_takedown;
 	}
 
+	ethsw->fdbs = kcalloc(ethsw->sw_attr.num_ifs, sizeof(*ethsw->fdbs),
+			      GFP_KERNEL);
+	if (!ethsw->fdbs) {
+		err = -ENOMEM;
+		goto err_free_ports;
+	}
+
 	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
 		err = dpaa2_switch_probe_port(ethsw, i);
 		if (err)
-			goto err_free_ports;
+			goto err_free_netdev;
 	}
 
 	/* Add a NAPI instance for each of the Rx queues. The first port's
@@ -2438,7 +2695,7 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 	err = dpsw_enable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 	if (err) {
 		dev_err(ethsw->dev, "dpsw_enable err %d\n", err);
-		goto err_free_ports;
+		goto err_free_netdev;
 	}
 
 	/* Setup IRQs */
@@ -2462,12 +2719,14 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 err_unregister_ports:
 	for (i--; i >= 0; i--)
 		unregister_netdev(ethsw->ports[i]->netdev);
+	dpaa2_switch_teardown_irqs(sw_dev);
 err_stop:
 	dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
-
-err_free_ports:
+err_free_netdev:
 	for (i--; i >= 0; i--)
 		free_netdev(ethsw->ports[i]->netdev);
+	kfree(ethsw->fdbs);
+err_free_ports:
 	kfree(ethsw->ports);
 
 err_takedown:
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index ab3b75a62f01..d83a9f17f672 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -92,6 +92,12 @@ struct dpaa2_switch_fq {
 	u32 fqid;
 };
 
+struct dpaa2_switch_fdb {
+	struct net_device	*bridge_dev;
+	u16			fdb_id;
+	bool			in_use;
+};
+
 /* Per port private data */
 struct ethsw_port_priv {
 	struct net_device	*netdev;
@@ -103,8 +109,9 @@ struct ethsw_port_priv {
 
 	u8			vlans[VLAN_VID_MASK + 1];
 	u16			pvid;
-	struct net_device	*bridge_dev;
 	u16			tx_qdid;
+
+	struct dpaa2_switch_fdb	*fdb;
 };
 
 /* Switch data */
@@ -131,6 +138,8 @@ struct ethsw_core {
 	int				buf_count;
 	u16				bpid;
 	int				napi_users;
+
+	struct dpaa2_switch_fdb		*fdbs;
 };
 
 static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
@@ -140,6 +149,25 @@ static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
 		return false;
 	}
 
+	if (ethsw->sw_attr.flooding_cfg != DPSW_FLOODING_PER_FDB) {
+		dev_err(ethsw->dev, "Flooding domain is not per FDB, cannot probe\n");
+		return false;
+	}
+
+	if (ethsw->sw_attr.broadcast_cfg != DPSW_BROADCAST_PER_FDB) {
+		dev_err(ethsw->dev, "Broadcast domain is not per FDB, cannot probe\n");
+		return false;
+	}
+
+	if (ethsw->sw_attr.max_fdbs < ethsw->sw_attr.num_ifs) {
+		dev_err(ethsw->dev, "The number of FDBs is lower than the number of ports, cannot probe\n");
+		return false;
+	}
+
 	return true;
 }
+
+bool dpaa2_switch_port_dev_check(const struct net_device *netdev,
+				 struct notifier_block *nb);
+
 #endif	/* __ETHSW_H */
-- 
2.30.0

