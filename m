Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CB71C39BF
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgEDMoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728869AbgEDMoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:44:19 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF53C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 05:44:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e16so15631613wra.7
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 05:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zgtWbKwoFPL+t361Q3v0HiQBH/Kcg/vdhd2CNMYKU30=;
        b=CaHyqs+27R6UXGBTwE5Gw22OESrv/Qc+J/WGXO/HycrIylHJfMOfKSL95tifC/rQ48
         h0vPptbFORb5OcM+SErEKTc2+35X30m9ATw+GgSUL0Zisnwadp3jYXfoEmgwo7PB8NlU
         RqFoAGT9ELADV3M9LI6XczvFVlAPcmO/dGGgzYca0NaA/UGh+zp+WSouZjfigqyTxEaQ
         f5lNi//VGeDeX5qInRXrIbemq16iizUlEUAqB8g2+tE0tn2T9DWw2BW8K7AidlNFrfkf
         VO1L0do0AwMJ0Q27jd+e1CPsOUq7L32J6MaZcyNM9BtXD7GhYfgAxyAEnauJ7cetdJcs
         sekA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zgtWbKwoFPL+t361Q3v0HiQBH/Kcg/vdhd2CNMYKU30=;
        b=PQ+ZYCwjDmY8/151nHnxndXysBtuOfeF1gkIXtw3vIDuKWfWxtL0SccX34HumscsUU
         BqRpxtytJbr5eNM9Ml2SYHs+wmpIZR5rH6tDHZG41iYwVQnyY0sLGDeL7bEzeoiuGY3k
         cfSKWGj309U4j6be7hCVAgRAasECB47Ar9WB7RP1PU6200R+Jcn2fo+xZ8p0B/A8GufO
         8uTZwOB77uR1NpxkARU0hw0lMb6etOnufSBHX9BHa9SJdhLiflApE4FWfgZyYkuCUp+5
         IHZsjxOaLbaTv/LO4pDXE7LBZL0vLMG6PuW5z6edObTZTqwm6hJ+6TaHcsuhRG5v0f/T
         f2TA==
X-Gm-Message-State: AGi0PubNdycOV1FXMRjd84fbFPLf7W7BBJIZLNCgrxrKOLmVFGYbAbn2
        xyopF1L46JK1FGGquDt0BuNCXqwiR/k=
X-Google-Smtp-Source: APiQypLbqyg5VxT2ZHm9axNVEzwOl7DHOBcZl9ZgqjQgTZ1eYFc7nyLxRZJL0Gg7+/2SaxaLQKBxnQ==
X-Received: by 2002:adf:e751:: with SMTP id c17mr1942991wrn.351.1588596256377;
        Mon, 04 May 2020 05:44:16 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 32sm17343670wrg.19.2020.05.04.05.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 05:44:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        georg.waibel@sensor-technik.de, o.rempel@pengutronix.de,
        christian.herber@nxp.com
Subject: [RFC 1/6] net: dsa: sja1105: add packing ops for the Retagging Table
Date:   Mon,  4 May 2020 15:43:20 +0300
Message-Id: <20200504124325.26758-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504124325.26758-1-olteanv@gmail.com>
References: <20200504124325.26758-1-olteanv@gmail.com>
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
index a12779c9fa19..f925f6a231e2 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -252,6 +252,8 @@ size_t sja1105et_l2_lookup_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op);
 size_t sja1105_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op);
+size_t sja1105_retagging_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op);
 size_t sja1105pqrs_mac_config_entry_packing(void *buf, void *entry_ptr,
 					    enum packing_op op);
 size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index bf9b36ff35bf..a1ade782beb1 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -127,6 +127,9 @@
 #define SJA1105PQRS_SIZE_AVB_PARAMS_DYN_CMD			\
 	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY)
 
+#define SJA1105_SIZE_RETAGGING_DYN_CMD				\
+	(SJA1105_SIZE_DYN_CMD + SJA1105_SIZE_RETAGGING_ENTRY)
+
 #define SJA1105_MAX_DYN_CMD_SIZE				\
 	SJA1105PQRS_SIZE_MAC_CONFIG_DYN_CMD
 
@@ -496,6 +499,20 @@ sja1105pqrs_avb_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
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
@@ -566,6 +583,14 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
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
 
@@ -641,6 +666,14 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
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
index bbfe034910a0..09125f1c064d 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -463,6 +463,22 @@ static size_t sja1105_xmii_params_entry_packing(void *buf, void *entry_ptr,
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
@@ -521,6 +537,7 @@ static u64 blk_id_map[BLK_IDX_MAX] = {
 	[BLK_IDX_L2_FORWARDING_PARAMS] = BLKID_L2_FORWARDING_PARAMS,
 	[BLK_IDX_AVB_PARAMS] = BLKID_AVB_PARAMS,
 	[BLK_IDX_GENERAL_PARAMS] = BLKID_GENERAL_PARAMS,
+	[BLK_IDX_RETAGGING] = BLKID_RETAGGING,
 	[BLK_IDX_XMII_PARAMS] = BLKID_XMII_PARAMS,
 };
 
@@ -560,14 +577,19 @@ static sja1105_config_valid_t
 static_config_check_memory_size(const struct sja1105_table *tables)
 {
 	const struct sja1105_l2_forwarding_params_entry *l2_fwd_params;
-	int i, mem = 0;
+	int i, max_mem, mem = 0;
 
 	l2_fwd_params = tables[BLK_IDX_L2_FORWARDING_PARAMS].entries;
 
 	for (i = 0; i < 8; i++)
 		mem += l2_fwd_params->part_spc[i];
 
-	if (mem > SJA1105_MAX_FRAME_MEMORY)
+	if (tables[BLK_IDX_RETAGGING].entry_count)
+		max_mem = SJA1105_MAX_FRAME_MEMORY_RETAGGING;
+	else
+		max_mem = SJA1105_MAX_FRAME_MEMORY;
+
+	if (mem > max_mem)
 		return SJA1105_OVERCOMMITTED_FRAME_MEMORY;
 
 	return SJA1105_CONFIG_OK;
@@ -759,6 +781,12 @@ struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
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
@@ -847,6 +875,12 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
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
@@ -915,6 +949,12 @@ struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
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
@@ -1003,6 +1043,12 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
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
@@ -1071,6 +1117,12 @@ struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
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
@@ -1159,6 +1211,12 @@ struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
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
index 8afafb6aef12..fa7bdd95cfd1 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -17,6 +17,7 @@
 #define SJA1105_SIZE_VLAN_LOOKUP_ENTRY			8
 #define SJA1105_SIZE_L2_FORWARDING_ENTRY		8
 #define SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY		12
+#define SJA1105_SIZE_RETAGGING_ENTRY			8
 #define SJA1105_SIZE_XMII_PARAMS_ENTRY			4
 #define SJA1105_SIZE_SCHEDULE_PARAMS_ENTRY		12
 #define SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY	4
@@ -46,6 +47,7 @@ enum {
 	BLKID_L2_FORWARDING_PARAMS			= 0x0E,
 	BLKID_AVB_PARAMS				= 0x10,
 	BLKID_GENERAL_PARAMS				= 0x11,
+	BLKID_RETAGGING					= 0x12,
 	BLKID_XMII_PARAMS				= 0x4E,
 };
 
@@ -63,6 +65,7 @@ enum sja1105_blk_idx {
 	BLK_IDX_L2_FORWARDING_PARAMS,
 	BLK_IDX_AVB_PARAMS,
 	BLK_IDX_GENERAL_PARAMS,
+	BLK_IDX_RETAGGING,
 	BLK_IDX_XMII_PARAMS,
 	BLK_IDX_MAX,
 	/* Fake block indices that are only valid for dynamic access */
@@ -83,10 +86,12 @@ enum sja1105_blk_idx {
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
@@ -257,6 +262,16 @@ struct sja1105_mac_config_entry {
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

