Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4B034EB36
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhC3OzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbhC3Oye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:54:34 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33571C061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:34 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id e14so25224810ejz.11
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0pOSxUIIf00fKgnVj6pbqJ70lF/PXEyUQWbbQfsjK9k=;
        b=StpBl0eaDrD5WnrHsv9qqbXDzgMJ9zHu44DP6t5IB3/2625YNNYRCNPuMBTLZLOiOx
         tAiH4UIJ89OStQ+eU7YYTnq0PSomqD0FcqbMFx+eKUsgvrcVR0D0Ed0k9JXzUbBERXEe
         skiOLXQrZZB/JYH2uzN8OmcheIFih0XkMqcxR8VIra7fQLPkejlOANkyT0AYQlGiT8ls
         kkee7lA6BNcNJBajN9CNeqJE83akFKQEEt4+KDDhRvFJ4JjtqmJBy6f9V8x5bx7ueBrN
         ZSbB2C9dLFzfLCd/Rl0+YuIICccpxTRAkEsznc9bghgHpahyNvfYmeJZUK+QJ1PIS40s
         nkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0pOSxUIIf00fKgnVj6pbqJ70lF/PXEyUQWbbQfsjK9k=;
        b=rXUM8jfx/McvD5zvR48WrNgid0oLuzLawLg0uUksd6Zv5pMMjt85FyZGQfo3EMyZQx
         Tm4ldGfLzg63/dv6Hu59ZNYTvykVtxZFL8LqyIp4ZPVu7xEKCuZGTTXzzat8Mrof2Crx
         sUuzWgAsgbaUHOsMHjw15pyhEIQyyhXaDVGPpqTk2VhwumEP/iMHQyy4T/PbLawvwXd1
         kkNrCzKCNtDsnnOqo61VMP2TFCKRQHL9WSr9PvQRVQl0Nt9gYdObPRpKQ01htczF44Dy
         kqxtjNMK9PfYbkFAMk9Kh5W3sKCAobdx8MYtOl9xuQXwOwbKGyp5LPTDSMJP+YCyASDl
         6GAA==
X-Gm-Message-State: AOAM533T8hT9ARTA4+9nKVLIqq82HRaIxRH0KN1HwrkTYJ+sp7/ShBYL
        OiVUVUgyaYZ8XLaEs1JRV0g=
X-Google-Smtp-Source: ABdhPJz3//evdzK14nshwHrzWxjBBMYGBaqBscmImI7AMpzj/450f5GSf8zxkr6AmcnGOU0Q+lU0mw==
X-Received: by 2002:a17:907:9863:: with SMTP id ko3mr33834842ejc.543.1617116072853;
        Tue, 30 Mar 2021 07:54:32 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id la15sm10284625ejb.46.2021.03.30.07.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 07:54:32 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 4/5] dpaa2-switch: trap STP frames to the CPU
Date:   Tue, 30 Mar 2021 17:54:18 +0300
Message-Id: <20210330145419.381355-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210330145419.381355-1-ciorneiioana@gmail.com>
References: <20210330145419.381355-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Add an ACL entry in each port's ACL table to redirect any frame that
has the destination MAC address equal to the STP dmac to the control
interface.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 68 ++++++++++++++
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  2 +
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h   | 49 ++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpsw.c   | 78 ++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   | 92 +++++++++++++++++++
 5 files changed, 289 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 45090d003b3d..72b7ba003538 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2652,8 +2652,72 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 	return err;
 }
 
+/* Add an ACL to redirect frames with specific destination MAC address to
+ * control interface
+ */
+static int dpaa2_switch_port_trap_mac_addr(struct ethsw_port_priv *port_priv,
+					   const char *mac)
+{
+	struct net_device *netdev = port_priv->netdev;
+	struct dpsw_acl_entry_cfg acl_entry_cfg;
+	struct dpsw_acl_fields *acl_h;
+	struct dpsw_acl_fields *acl_m;
+	struct dpsw_acl_key acl_key;
+	struct device *dev;
+	u8 *cmd_buff;
+	int err;
+
+	dev = port_priv->netdev->dev.parent;
+	acl_h = &acl_key.match;
+	acl_m = &acl_key.mask;
+
+	if (port_priv->acl_num_rules >= DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES) {
+		netdev_err(netdev, "ACL full\n");
+		return -ENOMEM;
+	}
+
+	memset(&acl_entry_cfg, 0, sizeof(acl_entry_cfg));
+	memset(&acl_key, 0, sizeof(acl_key));
+
+	/* Match on the destination MAC address */
+	ether_addr_copy(acl_h->l2_dest_mac, mac);
+	eth_broadcast_addr(acl_m->l2_dest_mac);
+
+	cmd_buff = kzalloc(DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE, GFP_KERNEL);
+	if (!cmd_buff)
+		return -ENOMEM;
+	dpsw_acl_prepare_entry_cfg(&acl_key, cmd_buff);
+
+	memset(&acl_entry_cfg, 0, sizeof(acl_entry_cfg));
+	acl_entry_cfg.precedence = port_priv->acl_num_rules;
+	acl_entry_cfg.result.action = DPSW_ACL_ACTION_REDIRECT_TO_CTRL_IF;
+	acl_entry_cfg.key_iova = dma_map_single(dev, cmd_buff,
+						DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE,
+						DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, acl_entry_cfg.key_iova))) {
+		netdev_err(netdev, "DMA mapping failed\n");
+		return -EFAULT;
+	}
+
+	err = dpsw_acl_add_entry(port_priv->ethsw_data->mc_io, 0,
+				 port_priv->ethsw_data->dpsw_handle,
+				 port_priv->acl_tbl, &acl_entry_cfg);
+
+	dma_unmap_single(dev, acl_entry_cfg.key_iova, sizeof(cmd_buff),
+			 DMA_TO_DEVICE);
+	if (err) {
+		netdev_err(netdev, "dpsw_acl_add_entry() failed %d\n", err);
+		return err;
+	}
+
+	port_priv->acl_num_rules++;
+
+	return 0;
+}
+
 static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 {
+	const char stpa[ETH_ALEN] = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x00};
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
 		.vid = DEFAULT_VLAN_ID,
@@ -2726,6 +2790,10 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 				port_priv->acl_tbl);
 	}
 
+	err = dpaa2_switch_port_trap_mac_addr(port_priv, stpa);
+	if (err)
+		return err;
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 35990761ce8f..0ae1d27c811e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -80,6 +80,7 @@
 	(DPAA2_SWITCH_TX_DATA_OFFSET + DPAA2_SWITCH_TX_BUF_ALIGN)
 
 #define DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES	16
+#define DPAA2_ETHSW_PORT_ACL_CMD_BUF_SIZE	256
 
 extern const struct ethtool_ops dpaa2_switch_port_ethtool_ops;
 
@@ -118,6 +119,7 @@ struct ethsw_port_priv {
 	bool			learn_ena;
 
 	u16			acl_tbl;
+	u8			acl_num_rules;
 };
 
 /* Switch data */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
index 89f757a2de77..1747cee19a72 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
@@ -76,6 +76,7 @@
 
 #define DPSW_CMDID_ACL_ADD                  DPSW_CMD_ID(0x090)
 #define DPSW_CMDID_ACL_REMOVE               DPSW_CMD_ID(0x091)
+#define DPSW_CMDID_ACL_ADD_ENTRY            DPSW_CMD_ID(0x092)
 #define DPSW_CMDID_ACL_ADD_IF               DPSW_CMD_ID(0x094)
 #define DPSW_CMDID_ACL_REMOVE_IF            DPSW_CMD_ID(0x095)
 
@@ -483,5 +484,53 @@ struct dpsw_cmd_acl_if {
 	__le64 if_id;
 };
 
+struct dpsw_prep_acl_entry {
+	u8 match_l2_dest_mac[6];
+	__le16 match_l2_tpid;
+
+	u8 match_l2_source_mac[6];
+	__le16 match_l2_vlan_id;
+
+	__le32 match_l3_dest_ip;
+	__le32 match_l3_source_ip;
+
+	__le16 match_l4_dest_port;
+	__le16 match_l4_source_port;
+	__le16 match_l2_ether_type;
+	u8 match_l2_pcp_dei;
+	u8 match_l3_dscp;
+
+	u8 mask_l2_dest_mac[6];
+	__le16 mask_l2_tpid;
+
+	u8 mask_l2_source_mac[6];
+	__le16 mask_l2_vlan_id;
+
+	__le32 mask_l3_dest_ip;
+	__le32 mask_l3_source_ip;
+
+	__le16 mask_l4_dest_port;
+	__le16 mask_l4_source_port;
+	__le16 mask_l2_ether_type;
+	u8 mask_l2_pcp_dei;
+	u8 mask_l3_dscp;
+
+	u8 match_l3_protocol;
+	u8 mask_l3_protocol;
+};
+
+#define DPSW_RESULT_ACTION_SHIFT	0
+#define DPSW_RESULT_ACTION_SIZE		4
+
+struct dpsw_cmd_acl_entry {
+	__le16 acl_id;
+	__le16 result_if_id;
+	__le32 precedence;
+	/* from LSB only the first 4 bits */
+	u8 result_action;
+	u8 pad[7];
+	__le64 pad2[4];
+	__le64 key_iova;
+};
 #pragma pack(pop)
 #endif /* __FSL_DPSW_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.c b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
index ad4b62b3c669..6704efe89bc1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
@@ -1466,3 +1466,81 @@ int dpsw_acl_remove_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 	/* send command to mc*/
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dpsw_acl_prepare_entry_cfg() - Setup an ACL entry
+ * @key:		Key
+ * @entry_cfg_buf:	Zeroed 256 bytes of memory before mapping it to DMA
+ *
+ * This function has to be called before adding or removing acl_entry
+ *
+ */
+void dpsw_acl_prepare_entry_cfg(const struct dpsw_acl_key *key,
+				u8 *entry_cfg_buf)
+{
+	struct dpsw_prep_acl_entry *ext_params;
+	int i;
+
+	ext_params = (struct dpsw_prep_acl_entry *)entry_cfg_buf;
+
+	for (i = 0; i < 6; i++) {
+		ext_params->match_l2_dest_mac[i] = key->match.l2_dest_mac[5 - i];
+		ext_params->match_l2_source_mac[i] = key->match.l2_source_mac[5 - i];
+		ext_params->mask_l2_dest_mac[i] = key->mask.l2_dest_mac[5 - i];
+		ext_params->mask_l2_source_mac[i] = key->mask.l2_source_mac[5 - i];
+	}
+
+	ext_params->match_l2_tpid = cpu_to_le16(key->match.l2_tpid);
+	ext_params->match_l2_vlan_id = cpu_to_le16(key->match.l2_vlan_id);
+	ext_params->match_l3_dest_ip = cpu_to_le32(key->match.l3_dest_ip);
+	ext_params->match_l3_source_ip = cpu_to_le32(key->match.l3_source_ip);
+	ext_params->match_l4_dest_port = cpu_to_le16(key->match.l4_dest_port);
+	ext_params->match_l4_source_port = cpu_to_le16(key->match.l4_source_port);
+	ext_params->match_l2_ether_type = cpu_to_le16(key->match.l2_ether_type);
+	ext_params->match_l2_pcp_dei = key->match.l2_pcp_dei;
+	ext_params->match_l3_dscp = key->match.l3_dscp;
+
+	ext_params->mask_l2_tpid = cpu_to_le16(key->mask.l2_tpid);
+	ext_params->mask_l2_vlan_id = cpu_to_le16(key->mask.l2_vlan_id);
+	ext_params->mask_l3_dest_ip = cpu_to_le32(key->mask.l3_dest_ip);
+	ext_params->mask_l3_source_ip = cpu_to_le32(key->mask.l3_source_ip);
+	ext_params->mask_l4_dest_port = cpu_to_le16(key->mask.l4_dest_port);
+	ext_params->mask_l4_source_port = cpu_to_le16(key->mask.l4_source_port);
+	ext_params->mask_l2_ether_type = cpu_to_le16(key->mask.l2_ether_type);
+	ext_params->mask_l2_pcp_dei = key->mask.l2_pcp_dei;
+	ext_params->mask_l3_dscp = key->mask.l3_dscp;
+	ext_params->match_l3_protocol = key->match.l3_protocol;
+	ext_params->mask_l3_protocol = key->mask.l3_protocol;
+}
+
+/**
+ * dpsw_acl_add_entry() - Add a rule to the ACL table.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @acl_id:	ACL ID
+ * @cfg:	Entry configuration
+ *
+ * warning: This function has to be called after dpsw_acl_prepare_entry_cfg()
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_acl_add_entry(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		       u16 acl_id, const struct dpsw_acl_entry_cfg *cfg)
+{
+	struct dpsw_cmd_acl_entry *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_ACL_ADD_ENTRY, cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_acl_entry *)cmd.params;
+	cmd_params->acl_id = cpu_to_le16(acl_id);
+	cmd_params->result_if_id = cpu_to_le16(cfg->result.if_id);
+	cmd_params->precedence = cpu_to_le32(cfg->precedence);
+	cmd_params->key_iova = cpu_to_le64(cfg->key_iova);
+	dpsw_set_field(cmd_params->result_action,
+		       RESULT_ACTION,
+		       cfg->result.action);
+
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.h b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
index 35b4749cdcdb..08e37c475ae8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
@@ -657,4 +657,96 @@ int dpsw_acl_add_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 
 int dpsw_acl_remove_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 		       u16 acl_id, const struct dpsw_acl_if_cfg *cfg);
+
+/**
+ * struct dpsw_acl_fields - ACL fields.
+ * @l2_dest_mac: Destination MAC address: BPDU, Multicast, Broadcast, Unicast,
+ *			slow protocols, MVRP, STP
+ * @l2_source_mac: Source MAC address
+ * @l2_tpid: Layer 2 (Ethernet) protocol type, used to identify the following
+ *		protocols: MPLS, PTP, PFC, ARP, Jumbo frames, LLDP, IEEE802.1ae,
+ *		Q-in-Q, IPv4, IPv6, PPPoE
+ * @l2_pcp_dei: indicate which protocol is encapsulated in the payload
+ * @l2_vlan_id: layer 2 VLAN ID
+ * @l2_ether_type: layer 2 Ethernet type
+ * @l3_dscp: Layer 3 differentiated services code point
+ * @l3_protocol: Tells the Network layer at the destination host, to which
+ *		Protocol this packet belongs to. The following protocol are
+ *		supported: ICMP, IGMP, IPv4 (encapsulation), TCP, IPv6
+ *		(encapsulation), GRE, PTP
+ * @l3_source_ip: Source IPv4 IP
+ * @l3_dest_ip: Destination IPv4 IP
+ * @l4_source_port: Source TCP/UDP Port
+ * @l4_dest_port: Destination TCP/UDP Port
+ */
+struct dpsw_acl_fields {
+	u8 l2_dest_mac[6];
+	u8 l2_source_mac[6];
+	u16 l2_tpid;
+	u8 l2_pcp_dei;
+	u16 l2_vlan_id;
+	u16 l2_ether_type;
+	u8 l3_dscp;
+	u8 l3_protocol;
+	u32 l3_source_ip;
+	u32 l3_dest_ip;
+	u16 l4_source_port;
+	u16 l4_dest_port;
+};
+
+/**
+ * struct dpsw_acl_key - ACL key
+ * @match: Match fields
+ * @mask: Mask: b'1 - valid, b'0 don't care
+ */
+struct dpsw_acl_key {
+	struct dpsw_acl_fields match;
+	struct dpsw_acl_fields mask;
+};
+
+/**
+ * enum dpsw_acl_action - action to be run on the ACL rule match
+ * @DPSW_ACL_ACTION_DROP: Drop frame
+ * @DPSW_ACL_ACTION_REDIRECT: Redirect to certain port
+ * @DPSW_ACL_ACTION_ACCEPT: Accept frame
+ * @DPSW_ACL_ACTION_REDIRECT_TO_CTRL_IF: Redirect to control interface
+ */
+enum dpsw_acl_action {
+	DPSW_ACL_ACTION_DROP,
+	DPSW_ACL_ACTION_REDIRECT,
+	DPSW_ACL_ACTION_ACCEPT,
+	DPSW_ACL_ACTION_REDIRECT_TO_CTRL_IF
+};
+
+/**
+ * struct dpsw_acl_result - ACL action
+ * @action: Action should be taken when	ACL entry hit
+ * @if_id:  Interface IDs to redirect frame. Valid only if redirect selected for
+ *		 action
+ */
+struct dpsw_acl_result {
+	enum dpsw_acl_action action;
+	u16 if_id;
+};
+
+/**
+ * struct dpsw_acl_entry_cfg - ACL entry
+ * @key_iova: I/O virtual address of DMA-able memory filled with key after call
+ *				to dpsw_acl_prepare_entry_cfg()
+ * @result: Required action when entry hit occurs
+ * @precedence: Precedence inside ACL 0 is lowest; This priority can not change
+ *		during the lifetime of a Policy. It is user responsibility to
+ *		space the priorities according to consequent rule additions.
+ */
+struct dpsw_acl_entry_cfg {
+	u64 key_iova;
+	struct dpsw_acl_result result;
+	int precedence;
+};
+
+void dpsw_acl_prepare_entry_cfg(const struct dpsw_acl_key *key,
+				u8 *entry_cfg_buf);
+
+int dpsw_acl_add_entry(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		       u16 acl_id, const struct dpsw_acl_entry_cfg *cfg);
 #endif /* __FSL_DPSW_H */
-- 
2.30.0

