Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5112A6B38
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732158AbgKDQ6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731694AbgKDQ5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:57:40 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EFDC0613D4;
        Wed,  4 Nov 2020 08:57:40 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id k9so23189190edo.5;
        Wed, 04 Nov 2020 08:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n5sGF1XqNRNaQRaYaE7ck1Zj8iWI/yaXNjIgNVguXWQ=;
        b=FiBJYJhxaPY72lPL+XZRgnCmwsKSqP9B9ju/FpIPCGgiYl0shTuM0MA9FypcHonYSY
         31ONHp6G8MZ9cKkGYisaE2hwOKQ7mDJpMVue7pw+z095Bq/h3jnQuEy8loyW6sLjqJEw
         LWYRF0jDt2pYP15qPGoKzDc9T7PTlXREqB4mUt2PEa9qQ5HiPxXPDsxAEqOp9hpgWgzI
         c37XqTE8DBeT5V6Qa5U8ua/TTdT3bpU9uegK+dP6Im1/xD22+fCD9P1oNlEN8lHzmCJH
         Io1csRscEv1ino4hMe6/bSMgYQ3vcxJtm1m9aF5+HG2KmE4h//uBgd1gn/DF2MMJ24bR
         KCuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n5sGF1XqNRNaQRaYaE7ck1Zj8iWI/yaXNjIgNVguXWQ=;
        b=hlDWKHJJp+RH3Tvlft6bH4dMqX8PoUf6Ni2d6A84L3+pXmT/88ZsXG+NH/bypMxhE1
         XtN6FPdZuSbwuD9+CeEkURrAr7cT2byJtmclgVr4AWgJ+owg05Rkzy3Lyamn9fN/iS+R
         ytHuRJ2H1siHiNqqxA6pOFTRjMQJo1R2lUmM5dgDYdelA9YpWoULT3+QZGfzZRwC5brZ
         5KZ1dBxOwua4BXfMsUJIC/yqSxq44m1zl4wAE4bq4PUJbczF+NLIw1crC8u2Wx7E7lqz
         +uleL4UsW/WQT9CB+zyagHMX5yipGI6ik0EaDtCvzv3y0/pZQ/VzFQjZ7FDtzML1t59z
         DY4g==
X-Gm-Message-State: AOAM530lGcjB0smvzuu3T27InUStPSaIM4xffjVg/p/KITdt664ym9CV
        k/hmi55aWVtRLckgRf5cUKs=
X-Google-Smtp-Source: ABdhPJwsNpEZUVNdYE3wKYvyBCeVI2Fy6rOz8VnKHpwjtGG7NNYdwsF8P3cVl30G99fXqRx5aYc+lA==
X-Received: by 2002:aa7:c90d:: with SMTP id b13mr13963066edt.136.1604509058645;
        Wed, 04 Nov 2020 08:57:38 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id l12sm1354748edt.46.2020.11.04.08.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:57:38 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC 8/9] staging: dpaa2-switch: properly setup switching domains
Date:   Wed,  4 Nov 2020 18:57:19 +0200
Message-Id: <20201104165720.2566399-9-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104165720.2566399-1-ciorneiioana@gmail.com>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Until now, the DPAA2 switch was not capable to properly setup it's
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
  that when a switch interface is not bridged it will use it's own FDB
  table. While in bridged mode all DPAA2 switch interfaces under the
  same upper will use the same FDB table, thus leverage the same FDB
  entries.

* Adding a new MC firmware command - dpsw_set_egress_flood() - through
  which the driver can setup the flooding domains as needed. For
  example, when the switch interface is standalone, thus not in a
  bridge with any other DPAA2 switch port, it will setup it's broadcast
  and unknown unicast flooding domains to only include the control
  interface (the queues that reach the CPU and the driver can dequeue
  from). This flooding domain changes when the interface joins a bridge
  and is configured to include, beside the control interface, all other
  DPAA2 switch interfaces.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |  25 ++-
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     |  96 +++++++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     |  41 ++++
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 220 +++++++++++++++++----
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h    |   6 +-
 5 files changed, 345 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
index c6eb9bffdd3e..9b068b07bbcd 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h
@@ -15,9 +15,11 @@
 #define DPSW_VER_MINOR		4
 
 #define DPSW_CMD_BASE_VERSION	1
+#define DPSW_CMD_2ND_VERSION	2
 #define DPSW_CMD_ID_OFFSET	4
 
 #define DPSW_CMD_ID(id)	(((id) << DPSW_CMD_ID_OFFSET) | DPSW_CMD_BASE_VERSION)
+#define DPSW_CMD_V2(id) (((id) << DPSW_CMD_ID_OFFSET) | DPSW_CMD_2ND_VERSION)
 
 /* Command IDs */
 #define DPSW_CMDID_CLOSE                    DPSW_CMD_ID(0x800)
@@ -58,7 +60,7 @@
 #define DPSW_CMDID_IF_SET_LINK_CFG          DPSW_CMD_ID(0x04C)
 
 #define DPSW_CMDID_VLAN_ADD                 DPSW_CMD_ID(0x060)
-#define DPSW_CMDID_VLAN_ADD_IF              DPSW_CMD_ID(0x061)
+#define DPSW_CMDID_VLAN_ADD_IF              DPSW_CMD_V2(0x061)
 #define DPSW_CMDID_VLAN_ADD_IF_UNTAGGED     DPSW_CMD_ID(0x062)
 
 #define DPSW_CMDID_VLAN_REMOVE_IF           DPSW_CMD_ID(0x064)
@@ -66,6 +68,8 @@
 #define DPSW_CMDID_VLAN_REMOVE_IF_FLOODING  DPSW_CMD_ID(0x066)
 #define DPSW_CMDID_VLAN_REMOVE              DPSW_CMD_ID(0x067)
 
+#define DPSW_CMDID_FDB_ADD                  DPSW_CMD_ID(0x082)
+#define DPSW_CMDID_FDB_REMOVE               DPSW_CMD_ID(0x083)
 #define DPSW_CMDID_FDB_ADD_UNICAST          DPSW_CMD_ID(0x084)
 #define DPSW_CMDID_FDB_REMOVE_UNICAST       DPSW_CMD_ID(0x085)
 #define DPSW_CMDID_FDB_ADD_MULTICAST        DPSW_CMD_ID(0x086)
@@ -83,6 +87,8 @@
 #define DPSW_CMDID_CTRL_IF_DISABLE          DPSW_CMD_ID(0x0A3)
 #define DPSW_CMDID_CTRL_IF_SET_QUEUE        DPSW_CMD_ID(0x0A6)
 
+#define DPSW_CMDID_SET_EGRESS_FLOOD         DPSW_CMD_ID(0x0AC)
+
 /* Macros for accessing command fields smaller than 1byte */
 #define DPSW_MASK(field)        \
 	GENMASK(DPSW_##field##_SHIFT + DPSW_##field##_SIZE - 1, \
@@ -324,6 +330,16 @@ struct dpsw_vlan_add {
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
@@ -445,4 +461,11 @@ struct dpsw_cmd_if_set_mac_addr {
 	u8 mac_addr[6];
 };
 
+struct dpsw_cmd_set_egress_flood {
+	__le16 fdb_id;
+	u8 flood_type;
+	u8 pad[5];
+	__le64 if_id;
+};
+
 #endif /* __FSL_DPSW_CMD_H */
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
index f5cfe61498b8..936984e7af50 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.c
@@ -986,6 +986,76 @@ int dpsw_vlan_remove(struct fsl_mc_io *mc_io,
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
+int dpsw_fdb_add(struct fsl_mc_io *mc_io,
+		 u32 cmd_flags,
+		 u16 token,
+		 u16 *fdb_id,
+		 const struct dpsw_fdb_cfg *cfg)
+{
+	struct dpsw_cmd_fdb_add *cmd_params;
+	struct dpsw_rsp_fdb_add *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_FDB_ADD,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_fdb_add *)cmd.params;
+	cmd_params->fdb_aging_time = cpu_to_le16(cfg->fdb_aging_time);
+	cmd_params->num_fdb_entries = cpu_to_le16(cfg->num_fdb_entries);
+
+	/* send command to mc*/
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	/* retrieve response parameters */
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
+int dpsw_fdb_remove(struct fsl_mc_io *mc_io,
+		    u32 cmd_flags,
+		    u16 token,
+		    u16 fdb_id)
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
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
+
 /**
  * dpsw_fdb_add_unicast() - Function adds an unicast entry into MAC lookup table
  * @mc_io:	Pointer to MC portal's I/O object
@@ -1493,3 +1563,29 @@ int dpsw_ctrl_if_disable(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token)
 
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
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_SET_EGRESS_FLOOD,
+					  cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_set_egress_flood *)cmd.params;
+	cmd_params->fdb_id = cpu_to_le16(cfg->fdb_id);
+	cmd_params->flood_type = cfg->flood_type;
+	build_if_id_bitmap(&cmd_params->if_id, cfg->if_id, cfg->num_ifs);
+
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
index 9e30adad4ffa..8fe76c7227ea 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/dpsw.h
@@ -493,6 +493,8 @@ int dpsw_vlan_add(struct fsl_mc_io *mc_io,
 		  u16 vlan_id,
 		  const struct dpsw_vlan_cfg *cfg);
 
+#define DPSW_VLAN_ADD_IF_OPT_FDB_ID            0x0001
+
 /**
  * struct dpsw_vlan_if_cfg - Set of VLAN Interfaces
  * @num_ifs: The number of interfaces that are assigned to the egress
@@ -502,7 +504,9 @@ int dpsw_vlan_add(struct fsl_mc_io *mc_io,
  */
 struct dpsw_vlan_if_cfg {
 	u16 num_ifs;
+	u16 options;
 	u16 if_id[DPSW_MAX_IF];
+	u16 fdb_id;
 };
 
 int dpsw_vlan_add_if(struct fsl_mc_io *mc_io,
@@ -692,4 +696,41 @@ int dpsw_if_get_primary_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags,
 int dpsw_if_set_primary_mac_addr(struct fsl_mc_io *mc_io, u32 cmd_flags,
 				 u16 token, u16 if_id, u8 mac_addr[6]);
 
+/**
+ * struct dpsw_fdb_cfg  - FDB Configuration
+ * @num_fdb_entries: Number of FDB entries
+ * @fdb_aging_time: Aging time in seconds
+ */
+struct dpsw_fdb_cfg {
+	u16 num_fdb_entries;
+	u16 fdb_aging_time;
+};
+
+int dpsw_fdb_add(struct fsl_mc_io *mc_io,
+		 u32 cmd_flags,
+		 u16 token,
+		 u16 *fdb_id,
+		 const struct dpsw_fdb_cfg *cfg);
+
+int dpsw_fdb_remove(struct fsl_mc_io *mc_io,
+		    u32 cmd_flags,
+		    u16 token,
+		    u16 fdb_id);
+
+enum dpsw_flood_type {
+	DPSW_BROADCAST_FLOOD = 0,
+	DPSW_UNICAST_FLOOD,
+	DPSW_MULTICAST_FLOOD,
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
index 24bdac6d6005..7a0d9a178cdc 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -25,6 +25,36 @@
 
 #define DEFAULT_VLAN_ID			1
 
+static u16 dpaa2_switch_port_get_fdb_id(struct ethsw_port_priv *port_priv)
+{
+	struct ethsw_port_priv *other_port_priv = NULL;
+	struct net_device *other_dev;
+	struct list_head *iter;
+
+	/* If not part of a bridge, just use the private FDB */
+	if (!port_priv->bridge_dev)
+		return port_priv->fdb_id;
+
+	/* If part of a bridge, use the FDB of the first dpaa2 switch interface
+	 * to be present in that bridge
+	 */
+	netdev_for_each_lower_dev(port_priv->bridge_dev, other_dev, iter) {
+		if (!dpaa2_switch_port_dev_check(other_dev, NULL))
+			continue;
+
+		other_port_priv = netdev_priv(other_dev);
+		break;
+	}
+
+	/* We are the first dpaa2 switch interface to join the bridge, just use
+	 * our own FDB
+	 */
+	if (!other_port_priv)
+		other_port_priv = port_priv;
+
+	return other_port_priv->fdb_id;
+}
+
 static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
 				dma_addr_t iova_addr)
 {
@@ -133,7 +163,7 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
 {
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct net_device *netdev = port_priv->netdev;
-	struct dpsw_vlan_if_cfg vcfg;
+	struct dpsw_vlan_if_cfg vcfg = {0};
 	int err;
 
 	if (port_priv->vlans[vid]) {
@@ -141,8 +171,13 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
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
@@ -172,8 +207,10 @@ static int dpaa2_switch_port_add_vlan(struct ethsw_port_priv *port_priv,
 	return 0;
 }
 
-static int dpaa2_switch_set_learning(struct ethsw_core *ethsw, bool enable)
+static int dpaa2_switch_port_set_learning(struct ethsw_port_priv *port_priv, bool enable)
 {
+	u16 fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
+	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	enum dpsw_fdb_learning_mode learn_mode;
 	int err;
 
@@ -182,13 +219,12 @@ static int dpaa2_switch_set_learning(struct ethsw_core *ethsw, bool enable)
 	else
 		learn_mode = DPSW_FDB_LEARNING_MODE_DIS;
 
-	err = dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle, 0,
+	err = dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle, fdb_id,
 					 learn_mode);
 	if (err) {
 		dev_err(ethsw->dev, "dpsw_fdb_set_learning_mode err %d\n", err);
 		return err;
 	}
-	ethsw->learning = enable;
 
 	return 0;
 }
@@ -267,15 +303,17 @@ static int dpaa2_switch_port_fdb_add_uc(struct ethsw_port_priv *port_priv,
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
@@ -306,6 +344,7 @@ static int dpaa2_switch_port_fdb_add_mc(struct ethsw_port_priv *port_priv,
 					const unsigned char *addr)
 {
 	struct dpsw_fdb_multicast_cfg entry = {0};
+	u16 fdb_id;
 	int err;
 
 	ether_addr_copy(entry.mac_addr, addr);
@@ -313,9 +352,10 @@ static int dpaa2_switch_port_fdb_add_mc(struct ethsw_port_priv *port_priv,
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
@@ -723,6 +763,7 @@ static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callba
 	u32 fdb_dump_size;
 	int err = 0, i;
 	u8 *dma_mem;
+	u16 fdb_id;
 
 	fdb_dump_size = ethsw->sw_attr.max_fdb_entries * sizeof(fdb_entry);
 	dma_mem = kzalloc(fdb_dump_size, GFP_KERNEL);
@@ -737,7 +778,8 @@ static int dpaa2_switch_port_fdb_dump(struct sk_buff *skb, struct netlink_callba
 		goto err_map;
 	}
 
-	err = dpsw_fdb_dump(ethsw->mc_io, 0, ethsw->dpsw_handle, 0,
+	fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
+	err = dpsw_fdb_dump(ethsw->mc_io, 0, ethsw->dpsw_handle, fdb_id,
 			    fdb_dump_iova, fdb_dump_size, &num_fdb_entries);
 	if (err) {
 		netdev_err(net_dev, "dpsw_fdb_dump() = %d\n", err);
@@ -960,8 +1002,8 @@ static const struct net_device_ops dpaa2_switch_port_ops = {
 	.ndo_get_phys_port_name = dpaa2_switch_port_get_phys_name,
 };
 
-static bool dpaa2_switch_port_dev_check(const struct net_device *netdev,
-					struct notifier_block *nb)
+bool dpaa2_switch_port_dev_check(const struct net_device *netdev,
+				 struct notifier_block *nb)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 
@@ -1119,9 +1161,11 @@ static int dpaa2_switch_port_attr_br_flags_set(struct net_device *netdev,
 	if (switchdev_trans_ph_prepare(trans))
 		return 0;
 
-	/* Learning is enabled per switch */
-	err = dpaa2_switch_set_learning(port_priv->ethsw_data,
-					!!(flags & BR_LEARNING));
+	/* Learning is enabled per swiching domain, thus all dpaa2 switch
+	 * interfaces under the same bridge will have their flooding state
+	 * changed also
+	 */
+	err = dpaa2_switch_port_set_learning(port_priv, !!(flags & BR_LEARNING));
 	if (err)
 		goto exit;
 
@@ -1403,24 +1447,69 @@ static int dpaa2_switch_port_attr_set_event(struct net_device *netdev,
 	return notifier_from_errno(err);
 }
 
-/* For the moment, only flood setting needs to be updated */
-static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
-					 struct net_device *upper_dev)
+static int dpaa2_switch_port_set_egress_flood(struct ethsw_port_priv *port_priv)
 {
-	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct net_device *netdev = port_priv->netdev;
 	struct ethsw_port_priv *other_port_priv;
+	struct dpsw_egress_flood_cfg flood_cfg;
 	struct net_device *other_dev;
 	struct list_head *iter;
-	int i, err;
+	int i = 0;
+	int err;
 
-	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
-		if (ethsw->ports[i]->bridge_dev &&
-		    (ethsw->ports[i]->bridge_dev != upper_dev)) {
-			netdev_err(netdev,
-				   "Only one bridge supported per DPSW object!\n");
-			return -EINVAL;
+	if (port_priv->bridge_dev) {
+		/* Add all the DPAA2 switch ports found under the same bridge to the
+		 * egress flooding domain
+		 */
+		netdev_for_each_lower_dev(port_priv->bridge_dev, other_dev, iter) {
+			if (!dpaa2_switch_port_dev_check(other_dev, NULL))
+				continue;
+
+			other_port_priv = netdev_priv(other_dev);
+			flood_cfg.if_id[i++] = other_port_priv->idx;
 		}
+	} else {
+		flood_cfg.if_id[i++] = port_priv->idx;
+	}
+
+	/* Add the CTRL interface to the egress flooding domain */
+	flood_cfg.if_id[i++] = ethsw->sw_attr.num_ifs;
+
+	/* Use the FDB of the first dpaa2 switch port added to the bridge */
+	flood_cfg.fdb_id = dpaa2_switch_port_get_fdb_id(port_priv);
+
+	/* Setup broadcast flooding domain */
+	flood_cfg.flood_type = DPSW_BROADCAST_FLOOD;
+	flood_cfg.num_ifs = i;
+	err = dpsw_set_egress_flood(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				    &flood_cfg);
+	if (err) {
+		netdev_err(netdev, "dpsw_set_egress_flood() = %d\n", err);
+		return err;
+	}
+
+	/* Setup unknown unicast flooding domain */
+	flood_cfg.flood_type = DPSW_UNICAST_FLOOD;
+	flood_cfg.num_ifs = i;
+	err = dpsw_set_egress_flood(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				    &flood_cfg);
+	if (err) {
+		netdev_err(netdev, "dpsw_set_egress_flood() = %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
+					 struct net_device *upper_dev)
+{
+	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
+	struct ethsw_port_priv *other_port_priv;
+	struct net_device *other_dev;
+	struct list_head *iter;
+	int err;
 
 	netdev_for_each_lower_dev(upper_dev, other_dev, iter) {
 		if (!dpaa2_switch_port_dev_check(other_dev, NULL))
@@ -1434,11 +1523,23 @@ static int dpaa2_switch_port_bridge_join(struct net_device *netdev,
 		}
 	}
 
-	/* Enable flooding */
-	err = dpaa2_switch_port_set_flood(port_priv, 1);
-	if (!err)
-		port_priv->bridge_dev = upper_dev;
+	/* Delete the previously manually installed VLAN 1 */
+	err = dpaa2_switch_port_del_vlan(port_priv, 1);
+	if (err)
+		return err;
+
+	/* Keep track of the upper bridge device */
+	port_priv->bridge_dev = upper_dev;
+
+	/* Setup the egress flood policy (broadcast, unknown unicast) */
+	err = dpaa2_switch_port_set_egress_flood(port_priv);
+	if (err)
+		goto err_egress_flood;
+
+	return 0;
 
+err_egress_flood:
+	port_priv->bridge_dev = NULL;
 	return err;
 }
 
@@ -1447,10 +1548,24 @@ static int dpaa2_switch_port_bridge_leave(struct net_device *netdev)
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	int err;
 
-	/* Disable flooding */
-	err = dpaa2_switch_port_set_flood(port_priv, 0);
-	if (!err)
-		port_priv->bridge_dev = NULL;
+	/* Port is not part of a bridge anymore */
+	port_priv->bridge_dev = NULL;
+
+	/* Setup the egress flood policy (broadcast, unknown unicast).
+	 * When the port is not under a bridge, only the CTRL interface is part
+	 * of the flooding domain besides the actual port
+	 */
+	err = dpaa2_switch_port_set_egress_flood(port_priv);
+	if (err)
+		return err;
+
+	/* Add the VLAN 1 as PVID when not under a bridge. We need this since
+	 * the dpaa2 switch interfaces are not capable to be VLAN unaware
+	 */
+	err = dpaa2_switch_port_add_vlan(port_priv, 1,
+					 BRIDGE_VLAN_INFO_UNTAGGED | BRIDGE_VLAN_INFO_PVID);
+	if (err)
+		return err;
 
 	return err;
 }
@@ -2291,13 +2406,6 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 		goto err_close;
 	}
 
-	err = dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle, 0,
-					 DPSW_FDB_LEARNING_MODE_HW);
-	if (err) {
-		dev_err(dev, "dpsw_fdb_set_learning_mode err %d\n", err);
-		goto err_close;
-	}
-
 	stp_cfg.vlan_id = DEFAULT_VLAN_ID;
 	stp_cfg.state = DPSW_STP_STATE_FORWARDING;
 
@@ -2352,6 +2460,7 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 {
 	struct net_device *netdev = port_priv->netdev;
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
+	struct dpsw_fdb_cfg fdb_cfg = {0};
 	struct dpsw_if_attr dpsw_if_attr;
 	struct dpsw_vlan_if_cfg vcfg;
 	int err;
@@ -2387,6 +2496,38 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	}
 	port_priv->tx_qdid = dpsw_if_attr.qdid;
 
+	/* Create a FDB table for this particular switch port */
+	fdb_cfg.num_fdb_entries = ethsw->sw_attr.max_fdb_entries / ethsw->sw_attr.num_ifs;
+	err = dpsw_fdb_add(ethsw->mc_io, 0, ethsw->dpsw_handle,
+			   &port_priv->fdb_id, &fdb_cfg);
+	if (err) {
+		netdev_err(netdev, "dpsw_fdb_add err %d\n", err);
+		return err;
+	}
+
+	/* Setup the default learning mode to he HW learning enabled */
+	err = dpsw_fdb_set_learning_mode(ethsw->mc_io, 0, ethsw->dpsw_handle,
+					 port_priv->fdb_id,
+					 DPSW_FDB_LEARNING_MODE_HW);
+	if (err) {
+		netdev_err(netdev, "dpsw_fdb_set_learning_mode err %d\n", err);
+		return err;
+	}
+
+	/* We need to add VLAN 1 as the PVID on this port until it is under a
+	 * bridge since the DPAA2 switch is not able to handle the traffic in a
+	 * VLAN unaware fashion
+	 */
+	err = dpaa2_switch_port_add_vlan(port_priv, 1,
+					 BRIDGE_VLAN_INFO_UNTAGGED | BRIDGE_VLAN_INFO_PVID);
+	if (err)
+		return err;
+
+	/* Setup the egress flooding domains (broadcast, unknown unicast */
+	err = dpaa2_switch_port_set_egress_flood(port_priv);
+	if (err)
+		return err;
+
 	return 0;
 }
 
@@ -2562,9 +2703,6 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 	/* DEFAULT_VLAN_ID is implicitly configured on the switch */
 	ethsw->vlans[DEFAULT_VLAN_ID] = ETHSW_VLAN_MEMBER;
 
-	/* Learning is implicitly enabled */
-	ethsw->learning = true;
-
 	ethsw->ports = kcalloc(ethsw->sw_attr.num_ifs, sizeof(*ethsw->ports),
 			       GFP_KERNEL);
 	if (!(ethsw->ports)) {
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
index b267c04e2008..f905acd18c67 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.h
@@ -106,6 +106,7 @@ struct ethsw_port_priv {
 	u16			pvid;
 	struct net_device	*bridge_dev;
 	u16			tx_qdid;
+	u16			fdb_id;
 };
 
 /* Switch data */
@@ -121,7 +122,6 @@ struct ethsw_core {
 	struct iommu_domain		*iommu_domain;
 
 	u8				vlans[VLAN_VID_MASK + 1];
-	bool				learning;
 
 	struct notifier_block		port_nb;
 	struct notifier_block		port_switchdev_nb;
@@ -139,4 +139,8 @@ static inline bool dpaa2_switch_has_ctrl_if(struct ethsw_core *ethsw)
 {
 	return !(ethsw->sw_attr.options & DPSW_OPT_CTRL_IF_DIS);
 }
+
+bool dpaa2_switch_port_dev_check(const struct net_device *netdev,
+				 struct notifier_block *nb);
+
 #endif	/* __ETHSW_H */
-- 
2.28.0

