Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C8D33D63E
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237643AbhCPO42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237622AbhCPOzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:55:35 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41C2C061764
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:34 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id bx7so21871154edb.12
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 07:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YceSsyGj6Df8mB1FsukmhP7Yi1mnM+5eBcLsmQTFyrA=;
        b=t5OtSJmN9NpAHa8KnRboyjWt53gpTY/vhfjRP2SbO9s0S5ekmPvMShyhM8mGs65MM5
         BuLrR5wVdvYPadUB3VeGiikI64OJoyRZJ3z0IIbakzmS6uWxE52NGfY7TKXrwBvvkdVB
         Dm5xPf9b53QRfnWj7G9sWsuLubbPy8empB5VWDUFPn5f4mE+GKxQNWCI3F4C9+FYNOsp
         D2fUdlRZTwHbmRJq5cSfGwct4ndZ+azKjR4foTad2/PTezgz9Ih+ZCyuoIDBbaYDvCEH
         xu0O/vNd3xSVffE684pKB+5+PDaJLevKj8YNeNaeGHX2mWVHlQVZurEFYGTxmxoRcWkC
         2Gcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YceSsyGj6Df8mB1FsukmhP7Yi1mnM+5eBcLsmQTFyrA=;
        b=uG7GyDqbuSUTuHw8bre7jDK49T1UxZnqQNnz2XNDi90Z0pgcQt3QbaZPXuwEgTtuqP
         0HaYID6vC2g6rsFb8FQH/I8/jrewFCVRhE1RLUAgm8nhKiZpLXmLHeqgnS3jVkupoOVD
         HytRJGVkOQpUhPn4cfT9rrF7rFQkX0jcZqFVrKyN1yfJDK+9Usx7mO56xVGmEWhRWi98
         FeNItO9EtSg9U1cp2MWPl0IN9R4+m6JaS0cgCWV4NnTH0SyYgcZ/wtMndkBTXBP83qZd
         eMREwlKo+z4WTyq/rj5byTeCPgVrootdhwzk6kjIK4mBex3TeV9MfLw3n7pFJZ249PgL
         I0Ug==
X-Gm-Message-State: AOAM530Q+V0eskc12D13rWxi/tfdt56gDgAJYzLh7U2NEbsETEjSUs0Z
        GdlS+309p34oy9O5X6bGtRs=
X-Google-Smtp-Source: ABdhPJz8/O5O3b2cDEnIKN35ZSu0wd/vT4LPHu85jYIzYz7eO3DfDJXRtKFeyiOncOItO07d1Ha88w==
X-Received: by 2002:a05:6402:d4:: with SMTP id i20mr36864653edu.147.1615906533374;
        Tue, 16 Mar 2021 07:55:33 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w18sm9681402ejn.23.2021.03.16.07.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 07:55:33 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, yangbo.lu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 3/5] dpaa2-switch: reduce the size of the if_id bitmap to 64 bits
Date:   Tue, 16 Mar 2021 16:55:10 +0200
Message-Id: <20210316145512.2152374-4-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210316145512.2152374-1-ciorneiioana@gmail.com>
References: <20210316145512.2152374-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

The maximum number of DPAA2 switch interfaces, including the control
interface, is 64. Even though this restriction existed from the first
place, the command structures which use an interface id bitmap were
poorly described and even though a single uint64_t is enough, all of
them used an array of 4 uint64_t's.
Fix this by reducing the size of the interface id field to a single
uint64_t.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpsw-cmd.h    |  4 ++--
 drivers/net/ethernet/freescale/dpaa2/dpsw.c    | 18 ++++++++++--------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
index 2371fd5c40e3..996a59dcd01d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw-cmd.h
@@ -340,7 +340,7 @@ struct dpsw_cmd_vlan_manage_if {
 	__le16 vlan_id;
 	__le32 pad1;
 	/* cmd word 1-4 */
-	__le64 if_id[4];
+	__le64 if_id;
 };
 
 struct dpsw_cmd_vlan_remove {
@@ -386,7 +386,7 @@ struct dpsw_cmd_fdb_multicast_op {
 	u8 mac_addr[6];
 	__le16 pad2;
 	/* cmd word 2-5 */
-	__le64 if_id[4];
+	__le64 if_id;
 };
 
 struct dpsw_cmd_fdb_dump {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.c b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
index ad7a4c03b130..ef0f90ae683f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.c
@@ -773,16 +773,18 @@ int dpsw_vlan_add_if(struct fsl_mc_io *mc_io,
 		     u16 vlan_id,
 		     const struct dpsw_vlan_if_cfg *cfg)
 {
+	struct dpsw_cmd_vlan_add_if *cmd_params;
 	struct fsl_mc_command cmd = { 0 };
-	struct dpsw_cmd_vlan_manage_if *cmd_params;
 
 	/* prepare command */
 	cmd.header = mc_encode_cmd_header(DPSW_CMDID_VLAN_ADD_IF,
 					  cmd_flags,
 					  token);
-	cmd_params = (struct dpsw_cmd_vlan_manage_if *)cmd.params;
+	cmd_params = (struct dpsw_cmd_vlan_add_if *)cmd.params;
 	cmd_params->vlan_id = cpu_to_le16(vlan_id);
-	build_if_id_bitmap(cmd_params->if_id, cfg->if_id, cfg->num_ifs);
+	cmd_params->options = cpu_to_le16(cfg->options);
+	cmd_params->fdb_id = cpu_to_le16(cfg->fdb_id);
+	build_if_id_bitmap(&cmd_params->if_id, cfg->if_id, cfg->num_ifs);
 
 	/* send command to mc*/
 	return mc_send_command(mc_io, &cmd);
@@ -820,7 +822,7 @@ int dpsw_vlan_add_if_untagged(struct fsl_mc_io *mc_io,
 					  token);
 	cmd_params = (struct dpsw_cmd_vlan_manage_if *)cmd.params;
 	cmd_params->vlan_id = cpu_to_le16(vlan_id);
-	build_if_id_bitmap(cmd_params->if_id, cfg->if_id, cfg->num_ifs);
+	build_if_id_bitmap(&cmd_params->if_id, cfg->if_id, cfg->num_ifs);
 
 	/* send command to mc*/
 	return mc_send_command(mc_io, &cmd);
@@ -854,7 +856,7 @@ int dpsw_vlan_remove_if(struct fsl_mc_io *mc_io,
 					  token);
 	cmd_params = (struct dpsw_cmd_vlan_manage_if *)cmd.params;
 	cmd_params->vlan_id = cpu_to_le16(vlan_id);
-	build_if_id_bitmap(cmd_params->if_id, cfg->if_id, cfg->num_ifs);
+	build_if_id_bitmap(&cmd_params->if_id, cfg->if_id, cfg->num_ifs);
 
 	/* send command to mc*/
 	return mc_send_command(mc_io, &cmd);
@@ -890,7 +892,7 @@ int dpsw_vlan_remove_if_untagged(struct fsl_mc_io *mc_io,
 					  token);
 	cmd_params = (struct dpsw_cmd_vlan_manage_if *)cmd.params;
 	cmd_params->vlan_id = cpu_to_le16(vlan_id);
-	build_if_id_bitmap(cmd_params->if_id, cfg->if_id, cfg->num_ifs);
+	build_if_id_bitmap(&cmd_params->if_id, cfg->if_id, cfg->num_ifs);
 
 	/* send command to mc*/
 	return mc_send_command(mc_io, &cmd);
@@ -1140,7 +1142,7 @@ int dpsw_fdb_add_multicast(struct fsl_mc_io *mc_io,
 	cmd_params->fdb_id = cpu_to_le16(fdb_id);
 	cmd_params->num_ifs = cpu_to_le16(cfg->num_ifs);
 	dpsw_set_field(cmd_params->type, ENTRY_TYPE, cfg->type);
-	build_if_id_bitmap(cmd_params->if_id, cfg->if_id, cfg->num_ifs);
+	build_if_id_bitmap(&cmd_params->if_id, cfg->if_id, cfg->num_ifs);
 	for (i = 0; i < 6; i++)
 		cmd_params->mac_addr[i] = cfg->mac_addr[5 - i];
 
@@ -1182,7 +1184,7 @@ int dpsw_fdb_remove_multicast(struct fsl_mc_io *mc_io,
 	cmd_params->fdb_id = cpu_to_le16(fdb_id);
 	cmd_params->num_ifs = cpu_to_le16(cfg->num_ifs);
 	dpsw_set_field(cmd_params->type, ENTRY_TYPE, cfg->type);
-	build_if_id_bitmap(cmd_params->if_id, cfg->if_id, cfg->num_ifs);
+	build_if_id_bitmap(&cmd_params->if_id, cfg->if_id, cfg->num_ifs);
 	for (i = 0; i < 6; i++)
 		cmd_params->mac_addr[i] = cfg->mac_addr[5 - i];
 
-- 
2.30.0

