Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C731C49F3
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgEDXAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728145AbgEDXAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:00:49 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE6FC061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:00:49 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f13so409454wrm.13
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XwvOWyXaT83qXaDsGbvwOVQWgn+6fePRY/epKrGu7Vs=;
        b=VAfl4agyJWdN6xo+oObCi7ZPW8xScT/0pb2qrROWr+/IGEaXTUjUnLEqZbKwAw+BaE
         9eSGWjlKi+AxAZEZ3trjbUA8W4eNnpoLfe8kbWSHe3Oi4gl8daoS0ripz7bj1gJJBtSJ
         NfAVh0RwLJ2BG6ZRSqjxgQDbhrtIZR1XE6fo0WkxJzSPJjUmJcjesM0+qXB6QbCXqWE7
         6ro7DuF2Sg1AyblUtjpbhIN693Pl/jUOjPZofLMpO7hr8MGpNiSdtfZ8Wg5MzbM+DIAz
         SqMF68V0M2j6IM29ZheeEZlD1pcrZrR5498tsPNcU9wei/t+CCmGZTiO7BMfbfxLhrRC
         woyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XwvOWyXaT83qXaDsGbvwOVQWgn+6fePRY/epKrGu7Vs=;
        b=CjcOmtuKYO3jHORF2b9UhmU4rb84LtJj8nol1UvNEGg7w79IGmkJsoBybICOZeYXyd
         nFwL/BwiY/GzhhIZeThrQGJYJ3QwSJbbc7vIY/tPgPI56P3X+vJYTr6RHC+q5pC2qfdv
         himVHZMtH+KEx2bBdUkWTiRH0cPVAw25pqKIMvLM5bY4PR3dF3pG2ewdmpZueRlVdnXX
         ++NU7xsZ1DibHjEu/8Dv7ENdUwWEIjMDb2ehJQfGmmEq/kjvAo7cqmGXGbYAOHQF54Mm
         Fq6c8pj6bNEcdUE/ceGFPBQUI9uuwPMcP9IwJRVwwYmN388E66a/x47RmphYLDX8UFHR
         FPhA==
X-Gm-Message-State: AGi0Puahn+cWL6OXELSRjie/N4BWzR5Oyp5eOMsadT55aw70wJgcMxrx
        cJeqBvYmtymiW3vBVFEGhZTSW2wHnX0=
X-Google-Smtp-Source: APiQypJBSfC157fmCh+gdwJ3hiDK9MbkNAVJ1Vj/yPpHsUXASV77RRcNg+kv4UgjTsBP8rLuOxXeDQ==
X-Received: by 2002:adf:82ac:: with SMTP id 41mr192086wrc.110.1588633246609;
        Mon, 04 May 2020 16:00:46 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id r23sm15322570wra.74.2020.05.04.16.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:00:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang_1@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vlad@buslov.dev, jiri@mellanox.com, idosch@mellanox.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 2/6] net: dsa: sja1105: add static tables for virtual links
Date:   Tue,  5 May 2020 02:00:30 +0300
Message-Id: <20200504230034.23958-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504230034.23958-1-olteanv@gmail.com>
References: <20200504230034.23958-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch adds the register definitions for the:
- VL Lookup Table
- VL Policing Table
- VL Forwarding Table
- VL Forwarding Parameters Table

These are needed in order to perform TTEthernet operations: QoS
classification, flow-based policing and/or frame redirecting with the
switch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes from v1:
None.

Changes from RFC:
None.

 drivers/net/dsa/sja1105/sja1105.h             |   2 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  51 +++++
 .../net/dsa/sja1105/sja1105_static_config.c   | 202 ++++++++++++++++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  63 ++++++
 4 files changed, 318 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 2f62942692ec..602aa30c832f 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -254,6 +254,8 @@ size_t sja1105pqrs_mac_config_entry_packing(void *buf, void *entry_ptr,
 					    enum packing_op op);
 size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
 					    enum packing_op op);
+size_t sja1105_vl_lookup_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op);
 
 /* From sja1105_flower.c */
 int sja1105_cls_flower_del(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index bf9b36ff35bf..bdee01811960 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -97,6 +97,12 @@
 
 #define SJA1105_SIZE_DYN_CMD					4
 
+#define SJA1105ET_SJA1105_SIZE_VL_LOOKUP_DYN_CMD		\
+	SJA1105_SIZE_DYN_CMD
+
+#define SJA1105PQRS_SJA1105_SIZE_VL_LOOKUP_DYN_CMD		\
+	(SJA1105_SIZE_DYN_CMD + SJA1105_SIZE_VL_LOOKUP_ENTRY)
+
 #define SJA1105ET_SIZE_MAC_CONFIG_DYN_ENTRY			\
 	SJA1105_SIZE_DYN_CMD
 
@@ -146,6 +152,29 @@ enum sja1105_hostcmd {
 	SJA1105_HOSTCMD_INVALIDATE = 4,
 };
 
+static void
+sja1105_vl_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+			      enum packing_op op)
+{
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(buf, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(buf, &cmd->errors,  30, 30, size, op);
+	sja1105_packing(buf, &cmd->rdwrset, 29, 29, size, op);
+	sja1105_packing(buf, &cmd->index,    9,  0, size, op);
+}
+
+static size_t sja1105et_vl_lookup_entry_packing(void *buf, void *entry_ptr,
+						enum packing_op op)
+{
+	struct sja1105_vl_lookup_entry *entry = entry_ptr;
+	const int size = SJA1105ET_SJA1105_SIZE_VL_LOOKUP_DYN_CMD;
+
+	sja1105_packing(buf, &entry->egrmirr,  21, 17, size, op);
+	sja1105_packing(buf, &entry->ingrmirr, 16, 16, size, op);
+	return size;
+}
+
 static void
 sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				  enum packing_op op)
@@ -505,6 +534,16 @@ sja1105pqrs_avb_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_SCHEDULE] = {0},
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
+	[BLK_IDX_VL_LOOKUP] = {
+		.entry_packing = sja1105et_vl_lookup_entry_packing,
+		.cmd_packing = sja1105_vl_lookup_cmd_packing,
+		.access = OP_WRITE,
+		.max_entry_count = SJA1105_MAX_VL_LOOKUP_COUNT,
+		.packed_size = SJA1105ET_SJA1105_SIZE_VL_LOOKUP_DYN_CMD,
+		.addr = 0x35,
+	},
+	[BLK_IDX_VL_POLICING] = {0},
+	[BLK_IDX_VL_FORWARDING] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.entry_packing = sja1105et_dyn_l2_lookup_entry_packing,
 		.cmd_packing = sja1105et_l2_lookup_cmd_packing,
@@ -548,6 +587,7 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 	},
 	[BLK_IDX_SCHEDULE_PARAMS] = {0},
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
+	[BLK_IDX_VL_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.entry_packing = sja1105et_l2_lookup_params_entry_packing,
 		.cmd_packing = sja1105et_l2_lookup_params_cmd_packing,
@@ -573,6 +613,16 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_SCHEDULE] = {0},
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
+	[BLK_IDX_VL_LOOKUP] = {
+		.entry_packing = sja1105_vl_lookup_entry_packing,
+		.cmd_packing = sja1105_vl_lookup_cmd_packing,
+		.access = (OP_READ | OP_WRITE),
+		.max_entry_count = SJA1105_MAX_VL_LOOKUP_COUNT,
+		.packed_size = SJA1105PQRS_SJA1105_SIZE_VL_LOOKUP_DYN_CMD,
+		.addr = 0x47,
+	},
+	[BLK_IDX_VL_POLICING] = {0},
+	[BLK_IDX_VL_FORWARDING] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.entry_packing = sja1105pqrs_dyn_l2_lookup_entry_packing,
 		.cmd_packing = sja1105pqrs_l2_lookup_cmd_packing,
@@ -616,6 +666,7 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	},
 	[BLK_IDX_SCHEDULE_PARAMS] = {0},
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
+	[BLK_IDX_VL_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.entry_packing = sja1105et_l2_lookup_params_entry_packing,
 		.cmd_packing = sja1105et_l2_lookup_params_cmd_packing,
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index bbfe034910a0..b68c9c92c248 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -432,6 +432,84 @@ static size_t sja1105_schedule_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+static size_t
+sja1105_vl_forwarding_params_entry_packing(void *buf, void *entry_ptr,
+					   enum packing_op op)
+{
+	struct sja1105_vl_forwarding_params_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_VL_FORWARDING_PARAMS_ENTRY;
+	int offset, i;
+
+	for (i = 0, offset = 16; i < 8; i++, offset += 10)
+		sja1105_packing(buf, &entry->partspc[i],
+				offset + 9, offset + 0, size, op);
+	sja1105_packing(buf, &entry->debugen, 15, 15, size, op);
+	return size;
+}
+
+static size_t sja1105_vl_forwarding_entry_packing(void *buf, void *entry_ptr,
+						  enum packing_op op)
+{
+	struct sja1105_vl_forwarding_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_VL_FORWARDING_ENTRY;
+
+	sja1105_packing(buf, &entry->type,      31, 31, size, op);
+	sja1105_packing(buf, &entry->priority,  30, 28, size, op);
+	sja1105_packing(buf, &entry->partition, 27, 25, size, op);
+	sja1105_packing(buf, &entry->destports, 24, 20, size, op);
+	return size;
+}
+
+size_t sja1105_vl_lookup_entry_packing(void *buf, void *entry_ptr,
+				       enum packing_op op)
+{
+	struct sja1105_vl_lookup_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_VL_LOOKUP_ENTRY;
+
+	if (entry->format == SJA1105_VL_FORMAT_PSFP) {
+		/* Interpreting vllupformat as 0 */
+		sja1105_packing(buf, &entry->destports,
+				95, 91, size, op);
+		sja1105_packing(buf, &entry->iscritical,
+				90, 90, size, op);
+		sja1105_packing(buf, &entry->macaddr,
+				89, 42, size, op);
+		sja1105_packing(buf, &entry->vlanid,
+				41, 30, size, op);
+		sja1105_packing(buf, &entry->port,
+				29, 27, size, op);
+		sja1105_packing(buf, &entry->vlanprior,
+				26, 24, size, op);
+	} else {
+		/* Interpreting vllupformat as 1 */
+		sja1105_packing(buf, &entry->egrmirr,
+				95, 91, size, op);
+		sja1105_packing(buf, &entry->ingrmirr,
+				90, 90, size, op);
+		sja1105_packing(buf, &entry->vlid,
+				57, 42, size, op);
+		sja1105_packing(buf, &entry->port,
+				29, 27, size, op);
+	}
+	return size;
+}
+
+static size_t sja1105_vl_policing_entry_packing(void *buf, void *entry_ptr,
+						enum packing_op op)
+{
+	struct sja1105_vl_policing_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_VL_POLICING_ENTRY;
+
+	sja1105_packing(buf, &entry->type,      63, 63, size, op);
+	sja1105_packing(buf, &entry->maxlen,    62, 52, size, op);
+	sja1105_packing(buf, &entry->sharindx,  51, 42, size, op);
+	if (entry->type == 0) {
+		sja1105_packing(buf, &entry->bag,    41, 28, size, op);
+		sja1105_packing(buf, &entry->jitter, 27, 18, size, op);
+	}
+	return size;
+}
+
 size_t sja1105_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op)
 {
@@ -510,6 +588,9 @@ static void sja1105_table_write_crc(u8 *table_start, u8 *crc_ptr)
 static u64 blk_id_map[BLK_IDX_MAX] = {
 	[BLK_IDX_SCHEDULE] = BLKID_SCHEDULE,
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = BLKID_SCHEDULE_ENTRY_POINTS,
+	[BLK_IDX_VL_LOOKUP] = BLKID_VL_LOOKUP,
+	[BLK_IDX_VL_POLICING] = BLKID_VL_POLICING,
+	[BLK_IDX_VL_FORWARDING] = BLKID_VL_FORWARDING,
 	[BLK_IDX_L2_LOOKUP] = BLKID_L2_LOOKUP,
 	[BLK_IDX_L2_POLICING] = BLKID_L2_POLICING,
 	[BLK_IDX_VLAN_LOOKUP] = BLKID_VLAN_LOOKUP,
@@ -517,6 +598,7 @@ static u64 blk_id_map[BLK_IDX_MAX] = {
 	[BLK_IDX_MAC_CONFIG] = BLKID_MAC_CONFIG,
 	[BLK_IDX_SCHEDULE_PARAMS] = BLKID_SCHEDULE_PARAMS,
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = BLKID_SCHEDULE_ENTRY_POINTS_PARAMS,
+	[BLK_IDX_VL_FORWARDING_PARAMS] = BLKID_VL_FORWARDING_PARAMS,
 	[BLK_IDX_L2_LOOKUP_PARAMS] = BLKID_L2_LOOKUP_PARAMS,
 	[BLK_IDX_L2_FORWARDING_PARAMS] = BLKID_L2_FORWARDING_PARAMS,
 	[BLK_IDX_AVB_PARAMS] = BLKID_AVB_PARAMS,
@@ -533,6 +615,9 @@ const char *sja1105_static_config_error_msg[] = {
 		"schedule-table present, but one of "
 		"schedule-entry-points-table, schedule-parameters-table or "
 		"schedule-entry-points-parameters table is empty",
+	[SJA1105_INCORRECT_VIRTUAL_LINK_CONFIGURATION] =
+		"vl-lookup-table present, but one of vl-policing-table, "
+		"vl-forwarding-table or vl-forwarding-parameters-table is empty",
 	[SJA1105_MISSING_L2_POLICING_TABLE] =
 		"l2-policing-table needs to have at least one entry",
 	[SJA1105_MISSING_L2_FORWARDING_TABLE] =
@@ -560,6 +645,7 @@ static sja1105_config_valid_t
 static_config_check_memory_size(const struct sja1105_table *tables)
 {
 	const struct sja1105_l2_forwarding_params_entry *l2_fwd_params;
+	const struct sja1105_vl_forwarding_params_entry *vl_fwd_params;
 	int i, mem = 0;
 
 	l2_fwd_params = tables[BLK_IDX_L2_FORWARDING_PARAMS].entries;
@@ -567,6 +653,12 @@ static_config_check_memory_size(const struct sja1105_table *tables)
 	for (i = 0; i < 8; i++)
 		mem += l2_fwd_params->part_spc[i];
 
+	if (tables[BLK_IDX_VL_FORWARDING_PARAMS].entry_count) {
+		vl_fwd_params = tables[BLK_IDX_VL_FORWARDING_PARAMS].entries;
+		for (i = 0; i < 8; i++)
+			mem += vl_fwd_params->partspc[i];
+	}
+
 	if (mem > SJA1105_MAX_FRAME_MEMORY)
 		return SJA1105_OVERCOMMITTED_FRAME_MEMORY;
 
@@ -594,6 +686,32 @@ sja1105_static_config_check_valid(const struct sja1105_static_config *config)
 		if (!IS_FULL(BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS))
 			return SJA1105_INCORRECT_TTETHERNET_CONFIGURATION;
 	}
+	if (tables[BLK_IDX_VL_LOOKUP].entry_count) {
+		struct sja1105_vl_lookup_entry *vl_lookup;
+		bool has_critical_links = false;
+		int i;
+
+		vl_lookup = tables[BLK_IDX_VL_LOOKUP].entries;
+
+		for (i = 0; i < tables[BLK_IDX_VL_LOOKUP].entry_count; i++) {
+			if (vl_lookup[i].iscritical) {
+				has_critical_links = true;
+				break;
+			}
+		}
+
+		if (tables[BLK_IDX_VL_POLICING].entry_count == 0 &&
+		    has_critical_links)
+			return SJA1105_INCORRECT_VIRTUAL_LINK_CONFIGURATION;
+
+		if (tables[BLK_IDX_VL_FORWARDING].entry_count == 0 &&
+		    has_critical_links)
+			return SJA1105_INCORRECT_VIRTUAL_LINK_CONFIGURATION;
+
+		if (tables[BLK_IDX_VL_FORWARDING_PARAMS].entry_count == 0 &&
+		    has_critical_links)
+			return SJA1105_INCORRECT_VIRTUAL_LINK_CONFIGURATION;
+	}
 
 	if (tables[BLK_IDX_L2_POLICING].entry_count == 0)
 		return SJA1105_MISSING_L2_POLICING_TABLE;
@@ -703,6 +821,9 @@ sja1105_static_config_get_length(const struct sja1105_static_config *config)
 struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
 	[BLK_IDX_SCHEDULE] = {0},
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
+	[BLK_IDX_VL_LOOKUP] = {0},
+	[BLK_IDX_VL_POLICING] = {0},
+	[BLK_IDX_VL_FORWARDING] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105et_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -735,6 +856,7 @@ struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
 	},
 	[BLK_IDX_SCHEDULE_PARAMS] = {0},
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
+	[BLK_IDX_VL_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105et_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -781,6 +903,24 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY,
 		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_COUNT,
 	},
+	[BLK_IDX_VL_LOOKUP] = {
+		.packing = sja1105_vl_lookup_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_lookup_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_LOOKUP_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_LOOKUP_COUNT,
+	},
+	[BLK_IDX_VL_POLICING] = {
+		.packing = sja1105_vl_policing_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_policing_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_POLICING_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_POLICING_COUNT,
+	},
+	[BLK_IDX_VL_FORWARDING] = {
+		.packing = sja1105_vl_forwarding_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_forwarding_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_FORWARDING_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_FORWARDING_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105et_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -823,6 +963,12 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT,
 	},
+	[BLK_IDX_VL_FORWARDING_PARAMS] = {
+		.packing = sja1105_vl_forwarding_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_forwarding_params_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_FORWARDING_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_FORWARDING_PARAMS_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105et_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -859,6 +1005,9 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
 struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
 	[BLK_IDX_SCHEDULE] = {0},
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
+	[BLK_IDX_VL_LOOKUP] = {0},
+	[BLK_IDX_VL_POLICING] = {0},
+	[BLK_IDX_VL_FORWARDING] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -891,6 +1040,7 @@ struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
 	},
 	[BLK_IDX_SCHEDULE_PARAMS] = {0},
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
+	[BLK_IDX_VL_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105pqrs_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -937,6 +1087,24 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY,
 		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_COUNT,
 	},
+	[BLK_IDX_VL_LOOKUP] = {
+		.packing = sja1105_vl_lookup_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_lookup_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_LOOKUP_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_LOOKUP_COUNT,
+	},
+	[BLK_IDX_VL_POLICING] = {
+		.packing = sja1105_vl_policing_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_policing_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_POLICING_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_POLICING_COUNT,
+	},
+	[BLK_IDX_VL_FORWARDING] = {
+		.packing = sja1105_vl_forwarding_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_forwarding_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_FORWARDING_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_FORWARDING_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -979,6 +1147,12 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT,
 	},
+	[BLK_IDX_VL_FORWARDING_PARAMS] = {
+		.packing = sja1105_vl_forwarding_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_forwarding_params_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_FORWARDING_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_FORWARDING_PARAMS_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105pqrs_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -1015,6 +1189,9 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
 struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
 	[BLK_IDX_SCHEDULE] = {0},
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
+	[BLK_IDX_VL_LOOKUP] = {0},
+	[BLK_IDX_VL_POLICING] = {0},
+	[BLK_IDX_VL_FORWARDING] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -1047,6 +1224,7 @@ struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
 	},
 	[BLK_IDX_SCHEDULE_PARAMS] = {0},
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
+	[BLK_IDX_VL_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105pqrs_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -1093,6 +1271,24 @@ struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY,
 		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_COUNT,
 	},
+	[BLK_IDX_VL_LOOKUP] = {
+		.packing = sja1105_vl_lookup_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_lookup_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_LOOKUP_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_LOOKUP_COUNT,
+	},
+	[BLK_IDX_VL_POLICING] = {
+		.packing = sja1105_vl_policing_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_policing_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_POLICING_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_POLICING_COUNT,
+	},
+	[BLK_IDX_VL_FORWARDING] = {
+		.packing = sja1105_vl_forwarding_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_forwarding_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_FORWARDING_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_FORWARDING_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -1135,6 +1331,12 @@ struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT,
 	},
+	[BLK_IDX_VL_FORWARDING_PARAMS] = {
+		.packing = sja1105_vl_forwarding_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_vl_forwarding_params_entry),
+		.packed_entry_size = SJA1105_SIZE_VL_FORWARDING_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_VL_FORWARDING_PARAMS_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105pqrs_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 8afafb6aef12..1a8fcbbb57b6 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -13,6 +13,9 @@
 #define SJA1105_SIZE_TABLE_HEADER			12
 #define SJA1105_SIZE_SCHEDULE_ENTRY			8
 #define SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY	4
+#define SJA1105_SIZE_VL_LOOKUP_ENTRY			12
+#define SJA1105_SIZE_VL_POLICING_ENTRY			8
+#define SJA1105_SIZE_VL_FORWARDING_ENTRY		4
 #define SJA1105_SIZE_L2_POLICING_ENTRY			8
 #define SJA1105_SIZE_VLAN_LOOKUP_ENTRY			8
 #define SJA1105_SIZE_L2_FORWARDING_ENTRY		8
@@ -20,6 +23,7 @@
 #define SJA1105_SIZE_XMII_PARAMS_ENTRY			4
 #define SJA1105_SIZE_SCHEDULE_PARAMS_ENTRY		12
 #define SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY	4
+#define SJA1105_SIZE_VL_FORWARDING_PARAMS_ENTRY         12
 #define SJA1105ET_SIZE_L2_LOOKUP_ENTRY			12
 #define SJA1105ET_SIZE_MAC_CONFIG_ENTRY			28
 #define SJA1105ET_SIZE_L2_LOOKUP_PARAMS_ENTRY		4
@@ -35,6 +39,9 @@
 enum {
 	BLKID_SCHEDULE					= 0x00,
 	BLKID_SCHEDULE_ENTRY_POINTS			= 0x01,
+	BLKID_VL_LOOKUP					= 0x02,
+	BLKID_VL_POLICING				= 0x03,
+	BLKID_VL_FORWARDING				= 0x04,
 	BLKID_L2_LOOKUP					= 0x05,
 	BLKID_L2_POLICING				= 0x06,
 	BLKID_VLAN_LOOKUP				= 0x07,
@@ -42,6 +49,7 @@ enum {
 	BLKID_MAC_CONFIG				= 0x09,
 	BLKID_SCHEDULE_PARAMS				= 0x0A,
 	BLKID_SCHEDULE_ENTRY_POINTS_PARAMS		= 0x0B,
+	BLKID_VL_FORWARDING_PARAMS			= 0x0C,
 	BLKID_L2_LOOKUP_PARAMS				= 0x0D,
 	BLKID_L2_FORWARDING_PARAMS			= 0x0E,
 	BLKID_AVB_PARAMS				= 0x10,
@@ -52,6 +60,9 @@ enum {
 enum sja1105_blk_idx {
 	BLK_IDX_SCHEDULE = 0,
 	BLK_IDX_SCHEDULE_ENTRY_POINTS,
+	BLK_IDX_VL_LOOKUP,
+	BLK_IDX_VL_POLICING,
+	BLK_IDX_VL_FORWARDING,
 	BLK_IDX_L2_LOOKUP,
 	BLK_IDX_L2_POLICING,
 	BLK_IDX_VLAN_LOOKUP,
@@ -59,6 +70,7 @@ enum sja1105_blk_idx {
 	BLK_IDX_MAC_CONFIG,
 	BLK_IDX_SCHEDULE_PARAMS,
 	BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS,
+	BLK_IDX_VL_FORWARDING_PARAMS,
 	BLK_IDX_L2_LOOKUP_PARAMS,
 	BLK_IDX_L2_FORWARDING_PARAMS,
 	BLK_IDX_AVB_PARAMS,
@@ -73,6 +85,9 @@ enum sja1105_blk_idx {
 
 #define SJA1105_MAX_SCHEDULE_COUNT			1024
 #define SJA1105_MAX_SCHEDULE_ENTRY_POINTS_COUNT		2048
+#define SJA1105_MAX_VL_LOOKUP_COUNT			1024
+#define SJA1105_MAX_VL_POLICING_COUNT			1024
+#define SJA1105_MAX_VL_FORWARDING_COUNT			1024
 #define SJA1105_MAX_L2_LOOKUP_COUNT			1024
 #define SJA1105_MAX_L2_POLICING_COUNT			45
 #define SJA1105_MAX_VLAN_LOOKUP_COUNT			4096
@@ -80,6 +95,7 @@ enum sja1105_blk_idx {
 #define SJA1105_MAX_MAC_CONFIG_COUNT			5
 #define SJA1105_MAX_SCHEDULE_PARAMS_COUNT		1
 #define SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT	1
+#define SJA1105_MAX_VL_FORWARDING_PARAMS_COUNT		1
 #define SJA1105_MAX_L2_LOOKUP_PARAMS_COUNT		1
 #define SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT		1
 #define SJA1105_MAX_GENERAL_PARAMS_COUNT		1
@@ -262,6 +278,52 @@ struct sja1105_xmii_params_entry {
 	u64 xmii_mode[5];
 };
 
+enum {
+	SJA1105_VL_FORMAT_PSFP		= 0,
+	SJA1105_VL_FORMAT_ARINC664	= 1,
+};
+
+struct sja1105_vl_lookup_entry {
+	u64 format;
+	u64 port;
+	union {
+		/* SJA1105_VL_FORMAT_PSFP */
+		struct {
+			u64 destports;
+			u64 iscritical;
+			u64 macaddr;
+			u64 vlanid;
+			u64 vlanprior;
+		};
+		/* SJA1105_VL_FORMAT_ARINC664 */
+		struct {
+			u64 egrmirr;
+			u64 ingrmirr;
+			u64 vlid;
+		};
+	};
+};
+
+struct sja1105_vl_policing_entry {
+	u64 type;
+	u64 maxlen;
+	u64 sharindx;
+	u64 bag;
+	u64 jitter;
+};
+
+struct sja1105_vl_forwarding_entry {
+	u64 type;
+	u64 priority;
+	u64 partition;
+	u64 destports;
+};
+
+struct sja1105_vl_forwarding_params_entry {
+	u64 partspc[8];
+	u64 debugen;
+};
+
 struct sja1105_table_header {
 	u64 block_id;
 	u64 len;
@@ -303,6 +365,7 @@ typedef enum {
 	SJA1105_CONFIG_OK = 0,
 	SJA1105_TTETHERNET_NOT_SUPPORTED,
 	SJA1105_INCORRECT_TTETHERNET_CONFIGURATION,
+	SJA1105_INCORRECT_VIRTUAL_LINK_CONFIGURATION,
 	SJA1105_MISSING_L2_POLICING_TABLE,
 	SJA1105_MISSING_L2_FORWARDING_TABLE,
 	SJA1105_MISSING_L2_FORWARDING_PARAMS_TABLE,
-- 
2.17.1

