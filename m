Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31EB1CCC59
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgEJQnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729201AbgEJQnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:43 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39E3C061A0C;
        Sun, 10 May 2020 09:43:42 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so16339812wma.4;
        Sun, 10 May 2020 09:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1VdKd6xGfS37QzUTdaLfq1NQgQ9fEEFw3sewt9lmK54=;
        b=UrUQoNX4lPJGUBHFd4HobxStJcitHeDESrFfSKeb7HE3p6ohtdaO2Cz6nTrkAzovwW
         KJPa0TlA6WdBC7gE8bA6MPGN0qHE0Fu5w8BSyNZx1YEhLnyxSpul9G2Xg5B49D/joVjx
         0SWj22xiJuIC5nEWYfmNNgm98z5HSo+IeO6pZA4nqv1sBKeToyicCiMVk0s+BCYJP7wB
         CN8zleDtRCxTLAVCLaESkPs8Sm2/4YnB0lffm9jh7YSmiTZMZrxt0P2VTqjEKLc0XpjL
         Yb++VyB3YftQRAGY57xjO/pUzyL/Q7Z8epCYJ/Szr7eO+8UN1JkxhvZdnPeQ9mT6qykm
         EhDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1VdKd6xGfS37QzUTdaLfq1NQgQ9fEEFw3sewt9lmK54=;
        b=dsX8lbOvui9s3YrhoEdYoZjzDorNi2yD9IXlfg7wEibbIYdLfICCsb3PlQ01XGlWVO
         NGP6rtBdghULYe9uGi4fI1q0IoOmE4LOUvrnpa/lPJ2bO8ugDqfrKZmGf6lfGi3UN7KU
         V5nqvvia9bFDD/6VfkHr252/pXXFF5cxnff3HmMGBJXgpU4yPZpZpRPXyVg8XrC96kx+
         vP4hRMSKDYd2TFxqqyOidiZA6+oM6ed3+vZtnuJSy7pN6uxzs4CeBgaQ0VA4szsaFZBR
         l8N40CLU6+VthaorHPBTGkKYFGKtFyWpUpod9PLKqKo3IlqiqV0hY5cCY1hxDeOb9NRx
         jPMg==
X-Gm-Message-State: AGi0PubR5IadTdDdzbVt8dJatNmtIa9v78Ji8hvd/yIO8eBHxjRFLFEb
        FZ7uYz+edBX+7hiuhuRAWt4=
X-Google-Smtp-Source: APiQypK2BfXvtruj/lCsY5fnh0o70oE1swLovd6jqvlZYx40GEpogsh3nrVA2Kjp+Kb559d0hu27dg==
X-Received: by 2002:a05:600c:218e:: with SMTP id e14mr28366696wme.140.1589129021306;
        Sun, 10 May 2020 09:43:41 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:40 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 12/15] net: dsa: sja1105: add packing ops for the Retagging Table
Date:   Sun, 10 May 2020 19:42:52 +0300
Message-Id: <20200510164255.19322-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Retagging Table is an optional feature that allows the switch to
match frames against a {ingress port, egress port, vid} rule and change
their VLAN ID. The retagged frames are by default clones of the original
ones (since the hardware-foreseen use case was to mirror traffic for
debugging purposes and to tag it with a special VLAN for this purpose),
but we can force the original frames to be dropped by removing the
pre-retagging VLAN from the port membership list of the egress port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h             |  2 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 33 ++++++++++
 .../net/dsa/sja1105/sja1105_static_config.c   | 62 ++++++++++++++++++-
 .../net/dsa/sja1105/sja1105_static_config.h   | 15 +++++
 4 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 1dcaecab0912..1ecdfd6be4c2 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -328,6 +328,8 @@ size_t sja1105et_l2_lookup_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op);
 size_t sja1105_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op);
+size_t sja1105_retagging_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op);
 size_t sja1105pqrs_mac_config_entry_packing(void *buf, void *entry_ptr,
 					    enum packing_op op);
 size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index bdee01811960..2a8fbd7fdedc 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -133,6 +133,9 @@
 #define SJA1105PQRS_SIZE_AVB_PARAMS_DYN_CMD			\
 	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY)
 
+#define SJA1105_SIZE_RETAGGING_DYN_CMD				\
+	(SJA1105_SIZE_DYN_CMD + SJA1105_SIZE_RETAGGING_ENTRY)
+
 #define SJA1105_MAX_DYN_CMD_SIZE				\
 	SJA1105PQRS_SIZE_MAC_CONFIG_DYN_CMD
 
@@ -525,6 +528,20 @@ sja1105pqrs_avb_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	sja1105_packing(p, &cmd->rdwrset, 29, 29, size, op);
 }
 
+static void
+sja1105_retagging_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+			      enum packing_op op)
+{
+	u8 *p = buf + SJA1105_SIZE_RETAGGING_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,    31, 31, size, op);
+	sja1105_packing(p, &cmd->errors,   30, 30, size, op);
+	sja1105_packing(p, &cmd->valident, 29, 29, size, op);
+	sja1105_packing(p, &cmd->rdwrset,  28, 28, size, op);
+	sja1105_packing(p, &cmd->index,     5,  0, size, op);
+}
+
 #define OP_READ		BIT(0)
 #define OP_WRITE	BIT(1)
 #define OP_DEL		BIT(2)
@@ -606,6 +623,14 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105ET_SIZE_GENERAL_PARAMS_DYN_CMD,
 		.addr = 0x34,
 	},
+	[BLK_IDX_RETAGGING] = {
+		.entry_packing = sja1105_retagging_entry_packing,
+		.cmd_packing = sja1105_retagging_cmd_packing,
+		.max_entry_count = SJA1105_MAX_RETAGGING_COUNT,
+		.access = (OP_WRITE | OP_DEL),
+		.packed_size = SJA1105_SIZE_RETAGGING_DYN_CMD,
+		.addr = 0x31,
+	},
 	[BLK_IDX_XMII_PARAMS] = {0},
 };
 
@@ -692,6 +717,14 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105ET_SIZE_GENERAL_PARAMS_DYN_CMD,
 		.addr = 0x34,
 	},
+	[BLK_IDX_RETAGGING] = {
+		.entry_packing = sja1105_retagging_entry_packing,
+		.cmd_packing = sja1105_retagging_cmd_packing,
+		.max_entry_count = SJA1105_MAX_RETAGGING_COUNT,
+		.access = (OP_READ | OP_WRITE | OP_DEL),
+		.packed_size = SJA1105_SIZE_RETAGGING_DYN_CMD,
+		.addr = 0x38,
+	},
 	[BLK_IDX_XMII_PARAMS] = {0},
 };
 
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index b68c9c92c248..780aca034cdc 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -541,6 +541,22 @@ static size_t sja1105_xmii_params_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+size_t sja1105_retagging_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op)
+{
+	struct sja1105_retagging_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_RETAGGING_ENTRY;
+
+	sja1105_packing(buf, &entry->egr_port,       63, 59, size, op);
+	sja1105_packing(buf, &entry->ing_port,       58, 54, size, op);
+	sja1105_packing(buf, &entry->vlan_ing,       53, 42, size, op);
+	sja1105_packing(buf, &entry->vlan_egr,       41, 30, size, op);
+	sja1105_packing(buf, &entry->do_not_learn,   29, 29, size, op);
+	sja1105_packing(buf, &entry->use_dest_ports, 28, 28, size, op);
+	sja1105_packing(buf, &entry->destports,      27, 23, size, op);
+	return size;
+}
+
 size_t sja1105_table_header_packing(void *buf, void *entry_ptr,
 				    enum packing_op op)
 {
@@ -603,6 +619,7 @@ static u64 blk_id_map[BLK_IDX_MAX] = {
 	[BLK_IDX_L2_FORWARDING_PARAMS] = BLKID_L2_FORWARDING_PARAMS,
 	[BLK_IDX_AVB_PARAMS] = BLKID_AVB_PARAMS,
 	[BLK_IDX_GENERAL_PARAMS] = BLKID_GENERAL_PARAMS,
+	[BLK_IDX_RETAGGING] = BLKID_RETAGGING,
 	[BLK_IDX_XMII_PARAMS] = BLKID_XMII_PARAMS,
 };
 
@@ -646,7 +663,7 @@ static_config_check_memory_size(const struct sja1105_table *tables)
 {
 	const struct sja1105_l2_forwarding_params_entry *l2_fwd_params;
 	const struct sja1105_vl_forwarding_params_entry *vl_fwd_params;
-	int i, mem = 0;
+	int i, max_mem, mem = 0;
 
 	l2_fwd_params = tables[BLK_IDX_L2_FORWARDING_PARAMS].entries;
 
@@ -659,7 +676,12 @@ static_config_check_memory_size(const struct sja1105_table *tables)
 			mem += vl_fwd_params->partspc[i];
 	}
 
-	if (mem > SJA1105_MAX_FRAME_MEMORY)
+	if (tables[BLK_IDX_RETAGGING].entry_count)
+		max_mem = SJA1105_MAX_FRAME_MEMORY_RETAGGING;
+	else
+		max_mem = SJA1105_MAX_FRAME_MEMORY;
+
+	if (mem > max_mem)
 		return SJA1105_OVERCOMMITTED_FRAME_MEMORY;
 
 	return SJA1105_CONFIG_OK;
@@ -881,6 +903,12 @@ struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105ET_SIZE_GENERAL_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_GENERAL_PARAMS_COUNT,
 	},
+	[BLK_IDX_RETAGGING] = {
+		.packing = sja1105_retagging_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_retagging_entry),
+		.packed_entry_size = SJA1105_SIZE_RETAGGING_ENTRY,
+		.max_entry_count = SJA1105_MAX_RETAGGING_COUNT,
+	},
 	[BLK_IDX_XMII_PARAMS] = {
 		.packing = sja1105_xmii_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_xmii_params_entry),
@@ -993,6 +1021,12 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105ET_SIZE_GENERAL_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_GENERAL_PARAMS_COUNT,
 	},
+	[BLK_IDX_RETAGGING] = {
+		.packing = sja1105_retagging_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_retagging_entry),
+		.packed_entry_size = SJA1105_SIZE_RETAGGING_ENTRY,
+		.max_entry_count = SJA1105_MAX_RETAGGING_COUNT,
+	},
 	[BLK_IDX_XMII_PARAMS] = {
 		.packing = sja1105_xmii_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_xmii_params_entry),
@@ -1065,6 +1099,12 @@ struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_GENERAL_PARAMS_COUNT,
 	},
+	[BLK_IDX_RETAGGING] = {
+		.packing = sja1105_retagging_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_retagging_entry),
+		.packed_entry_size = SJA1105_SIZE_RETAGGING_ENTRY,
+		.max_entry_count = SJA1105_MAX_RETAGGING_COUNT,
+	},
 	[BLK_IDX_XMII_PARAMS] = {
 		.packing = sja1105_xmii_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_xmii_params_entry),
@@ -1177,6 +1217,12 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_GENERAL_PARAMS_COUNT,
 	},
+	[BLK_IDX_RETAGGING] = {
+		.packing = sja1105_retagging_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_retagging_entry),
+		.packed_entry_size = SJA1105_SIZE_RETAGGING_ENTRY,
+		.max_entry_count = SJA1105_MAX_RETAGGING_COUNT,
+	},
 	[BLK_IDX_XMII_PARAMS] = {
 		.packing = sja1105_xmii_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_xmii_params_entry),
@@ -1249,6 +1295,12 @@ struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_GENERAL_PARAMS_COUNT,
 	},
+	[BLK_IDX_RETAGGING] = {
+		.packing = sja1105_retagging_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_retagging_entry),
+		.packed_entry_size = SJA1105_SIZE_RETAGGING_ENTRY,
+		.max_entry_count = SJA1105_MAX_RETAGGING_COUNT,
+	},
 	[BLK_IDX_XMII_PARAMS] = {
 		.packing = sja1105_xmii_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_xmii_params_entry),
@@ -1361,6 +1413,12 @@ struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_GENERAL_PARAMS_COUNT,
 	},
+	[BLK_IDX_RETAGGING] = {
+		.packing = sja1105_retagging_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_retagging_entry),
+		.packed_entry_size = SJA1105_SIZE_RETAGGING_ENTRY,
+		.max_entry_count = SJA1105_MAX_RETAGGING_COUNT,
+	},
 	[BLK_IDX_XMII_PARAMS] = {
 		.packing = sja1105_xmii_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_xmii_params_entry),
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index b569e3de3590..d96044d86b11 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -20,6 +20,7 @@
 #define SJA1105_SIZE_VLAN_LOOKUP_ENTRY			8
 #define SJA1105_SIZE_L2_FORWARDING_ENTRY		8
 #define SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY		12
+#define SJA1105_SIZE_RETAGGING_ENTRY			8
 #define SJA1105_SIZE_XMII_PARAMS_ENTRY			4
 #define SJA1105_SIZE_SCHEDULE_PARAMS_ENTRY		12
 #define SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY	4
@@ -54,6 +55,7 @@ enum {
 	BLKID_L2_FORWARDING_PARAMS			= 0x0E,
 	BLKID_AVB_PARAMS				= 0x10,
 	BLKID_GENERAL_PARAMS				= 0x11,
+	BLKID_RETAGGING					= 0x12,
 	BLKID_XMII_PARAMS				= 0x4E,
 };
 
@@ -75,6 +77,7 @@ enum sja1105_blk_idx {
 	BLK_IDX_L2_FORWARDING_PARAMS,
 	BLK_IDX_AVB_PARAMS,
 	BLK_IDX_GENERAL_PARAMS,
+	BLK_IDX_RETAGGING,
 	BLK_IDX_XMII_PARAMS,
 	BLK_IDX_MAX,
 	/* Fake block indices that are only valid for dynamic access */
@@ -99,10 +102,12 @@ enum sja1105_blk_idx {
 #define SJA1105_MAX_L2_LOOKUP_PARAMS_COUNT		1
 #define SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT		1
 #define SJA1105_MAX_GENERAL_PARAMS_COUNT		1
+#define SJA1105_MAX_RETAGGING_COUNT			32
 #define SJA1105_MAX_XMII_PARAMS_COUNT			1
 #define SJA1105_MAX_AVB_PARAMS_COUNT			1
 
 #define SJA1105_MAX_FRAME_MEMORY			929
+#define SJA1105_MAX_FRAME_MEMORY_RETAGGING		910
 
 #define SJA1105E_DEVICE_ID				0x9C00000Cull
 #define SJA1105T_DEVICE_ID				0x9E00030Eull
@@ -273,6 +278,16 @@ struct sja1105_mac_config_entry {
 	u64 ingress;
 };
 
+struct sja1105_retagging_entry {
+	u64 egr_port;
+	u64 ing_port;
+	u64 vlan_ing;
+	u64 vlan_egr;
+	u64 do_not_learn;
+	u64 use_dest_ports;
+	u64 destports;
+};
+
 struct sja1105_xmii_params_entry {
 	u64 phy_mac[5];
 	u64 xmii_mode[5];
-- 
2.17.1

