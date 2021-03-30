Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B1434EB39
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhC3OzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbhC3Oyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:54:33 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557ADC061764
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:32 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id l4so25264884ejc.10
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 07:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sRluMp1F7mKTU2sterL/STcQc6lqKMYYgnw+JxRK/6Y=;
        b=pZw6JXOVlhK9Ra30MLz2a/fKbAjlg9Y2KfFWuW1jhtpa8Ds5AHx/97k++dO39IR+nj
         c1+sWwYlV8TUCUTnBICZIcv2VtJ6JBN7+yGRKHjeLCaK0fTlnaA2uvDA949YhkgKMHVa
         mP0c0feWYHowk/QJ1+kDaGRFfrWxpAHUMMtIESZyYg/Km39FznlqiZ3nztCaPcedopPu
         M2B6DQZMhT9U1FYizHlM6dO0KHFbfPLXiQyq7zWZsM49FA1yGYaFxBTSQge36nLlK0f2
         Vwi0t/+nBHVQNrS44okYPB/2dKLWkZm/n8+xxRS1NpE3/XmUWuecAzsgq715FqVgzEiz
         i5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sRluMp1F7mKTU2sterL/STcQc6lqKMYYgnw+JxRK/6Y=;
        b=TeEpmwjHbCJF9RRzshqJh/sZYlAnPGScjI6TNLLiYMxbLxO2GaBWj8zWz9bXQgBrlO
         PcylZnLnzWnMdxPI6tHVUx6Q1beIz6TkTQLVelq6Cwcl/bwhYcYFwTnch2XZIKM9ThMb
         lwS25gEXhfC848RjMHcP8466wUicg2m0PDtt7m0hq3hAqt0frcAsMvq7XAYHySZZBpXF
         k7ZkAdmx+NXojZSug05hWMuV75alLJRolLhRe4sWgufk1ircTkqSDnhzb05m8AHzThUQ
         cvmZeDt1FkoKmOq1qtZpCt+oZN/pL9tQlM/UigeAeZa05T5kBjoZdw9mi4MQFHgxoZPk
         j/ig==
X-Gm-Message-State: AOAM530mQsrfKdCHeZ8y4IERQ4g9sPiNQ2OAynnbCBimNArnQ7oDlHmp
        A2lpvzf5M0BB+HSaHaR0NaBtMkm40sAdRw==
X-Google-Smtp-Source: ABdhPJyWF9Q+az0khmszVgjG660XRMRAgxza1Yy1PFH4Z4m1RxI4ygDI3Myxrf/+WK+KzlrkGsAtyA==
X-Received: by 2002:a17:906:c9d8:: with SMTP id hk24mr34231434ejb.480.1617116071014;
        Tue, 30 Mar 2021 07:54:31 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id la15sm10284625ejb.46.2021.03.30.07.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 07:54:30 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/5] dpaa2-switch: create and assign an ACL table per port
Date:   Tue, 30 Mar 2021 17:54:16 +0300
Message-Id: <20210330145419.381355-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210330145419.381355-1-ciorneiioana@gmail.com>
References: <20210330145419.381355-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In order to trap frames to the CPU, the DPAA2 switch uses the ACL table.
At probe time, create an ACL table for each switch port so that in the
next patches we can use this to trap STP frames and redirect them to the
control interface.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  23 +++-
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |   4 +
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h   |  26 ++++
 drivers/net/ethernet/freescale/dpaa2/dpsw.c   | 112 ++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   |  29 +++++
 5 files changed, 193 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 073316d0a77c..0683aa34f49c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2659,8 +2659,10 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	struct net_device *netdev = port_priv->netdev;
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	struct dpsw_fdb_cfg fdb_cfg = {0};
-	struct dpaa2_switch_fdb *fdb;
+	struct dpsw_acl_if_cfg acl_if_cfg;
 	struct dpsw_if_attr dpsw_if_attr;
+	struct dpaa2_switch_fdb *fdb;
+	struct dpsw_acl_cfg acl_cfg;
 	u16 fdb_id;
 	int err;
 
@@ -2702,6 +2704,25 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	if (err)
 		return err;
 
+	/* Create an ACL table to be used by this switch port */
+	acl_cfg.max_entries = DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES;
+	err = dpsw_acl_add(ethsw->mc_io, 0, ethsw->dpsw_handle,
+			   &port_priv->acl_tbl, &acl_cfg);
+	if (err) {
+		netdev_err(netdev, "dpsw_acl_add err %d\n", err);
+		return err;
+	}
+
+	acl_if_cfg.if_id[0] = port_priv->idx;
+	acl_if_cfg.num_ifs = 1;
+	err = dpsw_acl_add_if(ethsw->mc_io, 0, ethsw->dpsw_handle,
+			      port_priv->acl_tbl, &acl_if_cfg);
+	if (err) {
+		netdev_err(netdev, "dpsw_acl_add_if err %d\n", err);
+		dpsw_acl_remove(ethsw->mc_io, 0, ethsw->dpsw_handle,
+				port_priv->acl_tbl);
+	}
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index 549218994243..655937887960 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -79,6 +79,8 @@
 #define DPAA2_SWITCH_NEEDED_HEADROOM \
 	(DPAA2_SWITCH_TX_DATA_OFFSET + DPAA2_SWITCH_TX_BUF_ALIGN)
 
+#define DPAA2_ETHSW_PORT_MAX_ACL_ENTRIES	16
+
 extern const struct ethtool_ops dpaa2_switch_port_ethtool_ops;
 
 struct ethsw_core;
@@ -113,6 +115,8 @@ struct ethsw_port_priv {
 	struct dpaa2_switch_fdb	*fdb;
 	bool			bcast_flood;
 	bool			ucast_flood;
+
+	u16			acl_tbl;
 };
 
 /* Switch data */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
index 24b17d6e09af..89f757a2de77 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
@@ -74,6 +74,11 @@
 #define DPSW_CMDID_FDB_REMOVE_MULTICAST     DPSW_CMD_ID(0x087)
 #define DPSW_CMDID_FDB_DUMP                 DPSW_CMD_ID(0x08A)
 
+#define DPSW_CMDID_ACL_ADD                  DPSW_CMD_ID(0x090)
+#define DPSW_CMDID_ACL_REMOVE               DPSW_CMD_ID(0x091)
+#define DPSW_CMDID_ACL_ADD_IF               DPSW_CMD_ID(0x094)
+#define DPSW_CMDID_ACL_REMOVE_IF            DPSW_CMD_ID(0x095)
+
 #define DPSW_CMDID_IF_GET_PORT_MAC_ADDR     DPSW_CMD_ID(0x0A7)
 
 #define DPSW_CMDID_CTRL_IF_GET_ATTR         DPSW_CMD_ID(0x0A0)
@@ -457,5 +462,26 @@ struct dpsw_cmd_if_set_learning_mode {
 	/* only the first 4 bits from LSB */
 	u8 mode;
 };
+
+struct dpsw_cmd_acl_add {
+	__le16 pad;
+	__le16 max_entries;
+};
+
+struct dpsw_rsp_acl_add {
+	__le16 acl_id;
+};
+
+struct dpsw_cmd_acl_remove {
+	__le16 acl_id;
+};
+
+struct dpsw_cmd_acl_if {
+	__le16 acl_id;
+	__le16 num_ifs;
+	__le32 pad;
+	__le64 if_id;
+};
+
 #pragma pack(pop)
 #endif /* __FSL_DPSW_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.c b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
index 6c787d4b85f9..ad4b62b3c669 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
@@ -1354,3 +1354,115 @@ int dpsw_if_set_learning_mode(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 
 	return mc_send_command(mc_io, &cmd);
 }
+
+/**
+ * dpsw_acl_add() - Create an ACL table
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @acl_id:	Returned ACL ID, for future references
+ * @cfg:	ACL configuration
+ *
+ * Create Access Control List table. Multiple ACLs can be created and
+ * co-exist in L2 switch
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_acl_add(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 *acl_id,
+		 const struct dpsw_acl_cfg *cfg)
+{
+	struct dpsw_cmd_acl_add *cmd_params;
+	struct dpsw_rsp_acl_add *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_ACL_ADD, cmd_flags, token);
+	cmd_params = (struct dpsw_cmd_acl_add *)cmd.params;
+	cmd_params->max_entries = cpu_to_le16(cfg->max_entries);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dpsw_rsp_acl_add *)cmd.params;
+	*acl_id = le16_to_cpu(rsp_params->acl_id);
+
+	return 0;
+}
+
+/**
+ * dpsw_acl_remove() - Remove an ACL table from L2 switch.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @acl_id:	ACL ID
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_acl_remove(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		    u16 acl_id)
+{
+	struct dpsw_cmd_acl_remove *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_ACL_REMOVE, cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_acl_remove *)cmd.params;
+	cmd_params->acl_id = cpu_to_le16(acl_id);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpsw_acl_add_if() - Associate interface/interfaces with an ACL table.
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @acl_id:	ACL ID
+ * @cfg:	Interfaces list
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_acl_add_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		    u16 acl_id, const struct dpsw_acl_if_cfg *cfg)
+{
+	struct dpsw_cmd_acl_if *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_ACL_ADD_IF, cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_acl_if *)cmd.params;
+	cmd_params->acl_id = cpu_to_le16(acl_id);
+	cmd_params->num_ifs = cpu_to_le16(cfg->num_ifs);
+	build_if_id_bitmap(&cmd_params->if_id, cfg->if_id, cfg->num_ifs);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
+/**
+ * dpsw_acl_remove_if() - De-associate interface/interfaces from an ACL table
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:	Token of DPSW object
+ * @acl_id:	ACL ID
+ * @cfg:	Interfaces list
+ *
+ * Return:	'0' on Success; Error code otherwise.
+ */
+int dpsw_acl_remove_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		       u16 acl_id, const struct dpsw_acl_if_cfg *cfg)
+{
+	struct dpsw_cmd_acl_if *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	/* prepare command */
+	cmd.header = mc_encode_cmd_header(DPSW_CMDID_ACL_REMOVE_IF, cmd_flags,
+					  token);
+	cmd_params = (struct dpsw_cmd_acl_if *)cmd.params;
+	cmd_params->acl_id = cpu_to_le16(acl_id);
+	cmd_params->num_ifs = cpu_to_le16(cfg->num_ifs);
+	build_if_id_bitmap(&cmd_params->if_id, cfg->if_id, cfg->num_ifs);
+
+	/* send command to mc*/
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.h b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
index 96837b10cc94..35b4749cdcdb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
@@ -628,4 +628,33 @@ int dpsw_set_egress_flood(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 int dpsw_if_set_learning_mode(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 			      u16 if_id, enum dpsw_learning_mode mode);
 
+/**
+ * struct dpsw_acl_cfg - ACL Configuration
+ * @max_entries: Number of ACL rules
+ */
+struct dpsw_acl_cfg {
+	u16 max_entries;
+};
+
+int dpsw_acl_add(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token, u16 *acl_id,
+		 const struct dpsw_acl_cfg *cfg);
+
+int dpsw_acl_remove(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		    u16 acl_id);
+
+/**
+ * struct dpsw_acl_if_cfg - List of interfaces to associate with an ACL table
+ * @num_ifs: Number of interfaces
+ * @if_id: List of interfaces
+ */
+struct dpsw_acl_if_cfg {
+	u16 num_ifs;
+	u16 if_id[DPSW_MAX_IF];
+};
+
+int dpsw_acl_add_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		    u16 acl_id, const struct dpsw_acl_if_cfg *cfg);
+
+int dpsw_acl_remove_if(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		       u16 acl_id, const struct dpsw_acl_if_cfg *cfg);
 #endif /* __FSL_DPSW_H */
-- 
2.30.0

