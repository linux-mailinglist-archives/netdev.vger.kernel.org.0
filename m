Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01786B2949
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 03:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404175AbfINBU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 21:20:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39254 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404101AbfINBU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 21:20:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so3539448wrj.6
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 18:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W+yGUGn6GBwHwpqdc0maiOzCX2IrfjHZHfnLO/TB1dU=;
        b=EP1b2KjWdQmp6KyvGvfJ95PywE9c05Cj3iP878NoyyX3iUkbADWfkLxW7+cC1M2Dd+
         jfh82HmHbMSfUaiLMOVzWoBI+ZxyHtSYfW0QYXRUjLvAf5ZtebWdr5vkbK8PqQcnFIxY
         ciVfSpEfHkoqWVyTKtm+Azhrhu+1uc3y+AEUJPwrzpxJe2LQFDBZ9CPZPYeS1TKJLTC7
         +5Rqm4Un/sjeZmgoFJrkijiiog6sfLiBqb3ZSzPVeQ43BT+9BOmn5ze65jOBpDoRgbtb
         Mcltn/wuV+Yz+9MzX08tFBgdZM1ZbpDMyNjCFT75nyB3C2025MDdBMqlQMb8cmhXU9Pd
         k1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W+yGUGn6GBwHwpqdc0maiOzCX2IrfjHZHfnLO/TB1dU=;
        b=RUocQRyEuXkE1i2A9VSq7R/0h/UIOikmYbB2iRwoQEqIIjM2KWH8Qd4bncqazQtYIH
         EmGgFSp7J9V6VRxnvV7P/1w6/un4eFhpOe5A5hoqzSDeZCK8YhYNtH6VSkHbVs9xvyd6
         N/ev5iobRg0f08OZkdDb3ltnqcLYB+E38kLY1JYKKvhBGnNk4oBgvqFC9EhsIpGliEsA
         1uKyeEXYy1uNl0IGMMnY/SIdnl9fGgHXEnK4iAeMRCsCOZxoJTr0lJPZXEpzLIGPvaZO
         kTAetgBPIJG3o4crY2li7FrbB/9S1lY53lL6fUyvuA0QPJaXxrYpMejhFg9CM+jFfhl2
         CzNA==
X-Gm-Message-State: APjAAAUOa0Md2jC+iLHltI1F3OaI3DtH7t8jVN7Y2hMJvI2789V+tqoE
        hQg328wu3+3ZMCzk9FicvuQ=
X-Google-Smtp-Source: APXvYqyk+HycCbtdiEEjpSetRsdOmIsX9j0o/a6d8CYQ/hbtXCDfFqOgq77U+I3qbbbVo62R22gIEw==
X-Received: by 2002:adf:f110:: with SMTP id r16mr15180840wro.152.1568424052058;
        Fri, 13 Sep 2019 18:20:52 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id o14sm21857979wrw.11.2019.09.13.18.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 18:20:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 3/7] net: dsa: sja1105: Add static config tables for scheduling
Date:   Sat, 14 Sep 2019 04:17:58 +0300
Message-Id: <20190914011802.1602-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190914011802.1602-1-olteanv@gmail.com>
References: <20190914011802.1602-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to support tc-taprio offload, the TTEthernet egress scheduling
core registers must be made visible through the static interface.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes since v1:
- None.

Changes since RFC:
- None.

 .../net/dsa/sja1105/sja1105_dynamic_config.c  |   8 +
 .../net/dsa/sja1105/sja1105_static_config.c   | 167 ++++++++++++++++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  48 ++++-
 3 files changed, 222 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 9988c9d18567..91da430045ff 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -488,6 +488,8 @@ sja1105et_general_params_entry_packing(void *buf, void *entry_ptr,
 
 /* SJA1105E/T: First generation */
 struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
+	[BLK_IDX_SCHEDULE] = {0},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.entry_packing = sja1105et_dyn_l2_lookup_entry_packing,
 		.cmd_packing = sja1105et_l2_lookup_cmd_packing,
@@ -529,6 +531,8 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105ET_SIZE_MAC_CONFIG_DYN_CMD,
 		.addr = 0x36,
 	},
+	[BLK_IDX_SCHEDULE_PARAMS] = {0},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.entry_packing = sja1105et_l2_lookup_params_entry_packing,
 		.cmd_packing = sja1105et_l2_lookup_params_cmd_packing,
@@ -552,6 +556,8 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 
 /* SJA1105P/Q/R/S: Second generation */
 struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
+	[BLK_IDX_SCHEDULE] = {0},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.entry_packing = sja1105pqrs_dyn_l2_lookup_entry_packing,
 		.cmd_packing = sja1105pqrs_l2_lookup_cmd_packing,
@@ -593,6 +599,8 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105PQRS_SIZE_MAC_CONFIG_DYN_CMD,
 		.addr = 0x4B,
 	},
+	[BLK_IDX_SCHEDULE_PARAMS] = {0},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.entry_packing = sja1105et_l2_lookup_params_entry_packing,
 		.cmd_packing = sja1105et_l2_lookup_params_cmd_packing,
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index b31c737dc560..0d03e13e9909 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -371,6 +371,63 @@ size_t sja1105pqrs_mac_config_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+static size_t
+sja1105_schedule_entry_points_params_entry_packing(void *buf, void *entry_ptr,
+						   enum packing_op op)
+{
+	struct sja1105_schedule_entry_points_params_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY;
+
+	sja1105_packing(buf, &entry->clksrc,    31, 30, size, op);
+	sja1105_packing(buf, &entry->actsubsch, 29, 27, size, op);
+	return size;
+}
+
+static size_t
+sja1105_schedule_entry_points_entry_packing(void *buf, void *entry_ptr,
+					    enum packing_op op)
+{
+	struct sja1105_schedule_entry_points_entry *entry = entry_ptr;
+	const size_t size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY;
+
+	sja1105_packing(buf, &entry->subschindx, 31, 29, size, op);
+	sja1105_packing(buf, &entry->delta,      28, 11, size, op);
+	sja1105_packing(buf, &entry->address,    10, 1,  size, op);
+	return size;
+}
+
+static size_t sja1105_schedule_params_entry_packing(void *buf, void *entry_ptr,
+						    enum packing_op op)
+{
+	const size_t size = SJA1105_SIZE_SCHEDULE_PARAMS_ENTRY;
+	struct sja1105_schedule_params_entry *entry = entry_ptr;
+	int offset, i;
+
+	for (i = 0, offset = 16; i < 8; i++, offset += 10)
+		sja1105_packing(buf, &entry->subscheind[i],
+				offset + 9, offset + 0, size, op);
+	return size;
+}
+
+static size_t sja1105_schedule_entry_packing(void *buf, void *entry_ptr,
+					     enum packing_op op)
+{
+	const size_t size = SJA1105_SIZE_SCHEDULE_ENTRY;
+	struct sja1105_schedule_entry *entry = entry_ptr;
+
+	sja1105_packing(buf, &entry->winstindex,  63, 54, size, op);
+	sja1105_packing(buf, &entry->winend,      53, 53, size, op);
+	sja1105_packing(buf, &entry->winst,       52, 52, size, op);
+	sja1105_packing(buf, &entry->destports,   51, 47, size, op);
+	sja1105_packing(buf, &entry->setvalid,    46, 46, size, op);
+	sja1105_packing(buf, &entry->txen,        45, 45, size, op);
+	sja1105_packing(buf, &entry->resmedia_en, 44, 44, size, op);
+	sja1105_packing(buf, &entry->resmedia,    43, 36, size, op);
+	sja1105_packing(buf, &entry->vlindex,     35, 26, size, op);
+	sja1105_packing(buf, &entry->delta,       25, 8,  size, op);
+	return size;
+}
+
 size_t sja1105_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op)
 {
@@ -447,11 +504,15 @@ static void sja1105_table_write_crc(u8 *table_start, u8 *crc_ptr)
  * before blindly indexing kernel memory with the blk_idx.
  */
 static u64 blk_id_map[BLK_IDX_MAX] = {
+	[BLK_IDX_SCHEDULE] = BLKID_SCHEDULE,
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = BLKID_SCHEDULE_ENTRY_POINTS,
 	[BLK_IDX_L2_LOOKUP] = BLKID_L2_LOOKUP,
 	[BLK_IDX_L2_POLICING] = BLKID_L2_POLICING,
 	[BLK_IDX_VLAN_LOOKUP] = BLKID_VLAN_LOOKUP,
 	[BLK_IDX_L2_FORWARDING] = BLKID_L2_FORWARDING,
 	[BLK_IDX_MAC_CONFIG] = BLKID_MAC_CONFIG,
+	[BLK_IDX_SCHEDULE_PARAMS] = BLKID_SCHEDULE_PARAMS,
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = BLKID_SCHEDULE_ENTRY_POINTS_PARAMS,
 	[BLK_IDX_L2_LOOKUP_PARAMS] = BLKID_L2_LOOKUP_PARAMS,
 	[BLK_IDX_L2_FORWARDING_PARAMS] = BLKID_L2_FORWARDING_PARAMS,
 	[BLK_IDX_AVB_PARAMS] = BLKID_AVB_PARAMS,
@@ -461,6 +522,13 @@ static u64 blk_id_map[BLK_IDX_MAX] = {
 
 const char *sja1105_static_config_error_msg[] = {
 	[SJA1105_CONFIG_OK] = "",
+	[SJA1105_TTETHERNET_NOT_SUPPORTED] =
+		"schedule-table present, but TTEthernet is "
+		"only supported on T and Q/S",
+	[SJA1105_INCORRECT_TTETHERNET_CONFIGURATION] =
+		"schedule-table present, but one of "
+		"schedule-entry-points-table, schedule-parameters-table or "
+		"schedule-entry-points-parameters table is empty",
 	[SJA1105_MISSING_L2_POLICING_TABLE] =
 		"l2-policing-table needs to have at least one entry",
 	[SJA1105_MISSING_L2_FORWARDING_TABLE] =
@@ -508,6 +576,21 @@ sja1105_static_config_check_valid(const struct sja1105_static_config *config)
 #define IS_FULL(blk_idx) \
 	(tables[blk_idx].entry_count == tables[blk_idx].ops->max_entry_count)
 
+	if (tables[BLK_IDX_SCHEDULE].entry_count) {
+		if (config->device_id != SJA1105T_DEVICE_ID &&
+		    config->device_id != SJA1105QS_DEVICE_ID)
+			return SJA1105_TTETHERNET_NOT_SUPPORTED;
+
+		if (tables[BLK_IDX_SCHEDULE_ENTRY_POINTS].entry_count == 0)
+			return SJA1105_INCORRECT_TTETHERNET_CONFIGURATION;
+
+		if (!IS_FULL(BLK_IDX_SCHEDULE_PARAMS))
+			return SJA1105_INCORRECT_TTETHERNET_CONFIGURATION;
+
+		if (!IS_FULL(BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS))
+			return SJA1105_INCORRECT_TTETHERNET_CONFIGURATION;
+	}
+
 	if (tables[BLK_IDX_L2_POLICING].entry_count == 0)
 		return SJA1105_MISSING_L2_POLICING_TABLE;
 
@@ -614,6 +697,8 @@ sja1105_static_config_get_length(const struct sja1105_static_config *config)
 
 /* SJA1105E: First generation, no TTEthernet */
 struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
+	[BLK_IDX_SCHEDULE] = {0},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105et_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -644,6 +729,8 @@ struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105ET_SIZE_MAC_CONFIG_ENTRY,
 		.max_entry_count = SJA1105_MAX_MAC_CONFIG_COUNT,
 	},
+	[BLK_IDX_SCHEDULE_PARAMS] = {0},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105et_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -678,6 +765,18 @@ struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
 
 /* SJA1105T: First generation, TTEthernet */
 struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
+	[BLK_IDX_SCHEDULE] = {
+		.packing = sja1105_schedule_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_COUNT,
+	},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {
+		.packing = sja1105_schedule_entry_points_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry_points_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105et_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -708,6 +807,18 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105ET_SIZE_MAC_CONFIG_ENTRY,
 		.max_entry_count = SJA1105_MAX_MAC_CONFIG_COUNT,
 	},
+	[BLK_IDX_SCHEDULE_PARAMS] = {
+		.packing = sja1105_schedule_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_params_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_PARAMS_COUNT,
+	},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {
+		.packing = sja1105_schedule_entry_points_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry_points_params_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105et_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -742,6 +853,8 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
 
 /* SJA1105P: Second generation, no TTEthernet, no SGMII */
 struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
+	[BLK_IDX_SCHEDULE] = {0},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -772,6 +885,8 @@ struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY,
 		.max_entry_count = SJA1105_MAX_MAC_CONFIG_COUNT,
 	},
+	[BLK_IDX_SCHEDULE_PARAMS] = {0},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105pqrs_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -806,6 +921,18 @@ struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
 
 /* SJA1105Q: Second generation, TTEthernet, no SGMII */
 struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
+	[BLK_IDX_SCHEDULE] = {
+		.packing = sja1105_schedule_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_COUNT,
+	},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {
+		.packing = sja1105_schedule_entry_points_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry_points_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -836,6 +963,18 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY,
 		.max_entry_count = SJA1105_MAX_MAC_CONFIG_COUNT,
 	},
+	[BLK_IDX_SCHEDULE_PARAMS] = {
+		.packing = sja1105_schedule_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_params_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_PARAMS_COUNT,
+	},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {
+		.packing = sja1105_schedule_entry_points_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry_points_params_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105pqrs_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -870,6 +1009,8 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
 
 /* SJA1105R: Second generation, no TTEthernet, SGMII */
 struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
+	[BLK_IDX_SCHEDULE] = {0},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -900,6 +1041,8 @@ struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY,
 		.max_entry_count = SJA1105_MAX_MAC_CONFIG_COUNT,
 	},
+	[BLK_IDX_SCHEDULE_PARAMS] = {0},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105pqrs_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -934,6 +1077,18 @@ struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
 
 /* SJA1105S: Second generation, TTEthernet, SGMII */
 struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
+	[BLK_IDX_SCHEDULE] = {
+		.packing = sja1105_schedule_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_COUNT,
+	},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {
+		.packing = sja1105_schedule_entry_points_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry_points_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -964,6 +1119,18 @@ struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY,
 		.max_entry_count = SJA1105_MAX_MAC_CONFIG_COUNT,
 	},
+	[BLK_IDX_SCHEDULE_PARAMS] = {
+		.packing = sja1105_schedule_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_params_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_PARAMS_COUNT,
+	},
+	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {
+		.packing = sja1105_schedule_entry_points_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_schedule_entry_points_params_entry),
+		.packed_entry_size = SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT,
+	},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105pqrs_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 684465fc0882..7f87022a2d61 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -11,11 +11,15 @@
 
 #define SJA1105_SIZE_DEVICE_ID				4
 #define SJA1105_SIZE_TABLE_HEADER			12
+#define SJA1105_SIZE_SCHEDULE_ENTRY			8
+#define SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_ENTRY	4
 #define SJA1105_SIZE_L2_POLICING_ENTRY			8
 #define SJA1105_SIZE_VLAN_LOOKUP_ENTRY			8
 #define SJA1105_SIZE_L2_FORWARDING_ENTRY		8
 #define SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY		12
 #define SJA1105_SIZE_XMII_PARAMS_ENTRY			4
+#define SJA1105_SIZE_SCHEDULE_PARAMS_ENTRY		12
+#define SJA1105_SIZE_SCHEDULE_ENTRY_POINTS_PARAMS_ENTRY	4
 #define SJA1105ET_SIZE_L2_LOOKUP_ENTRY			12
 #define SJA1105ET_SIZE_MAC_CONFIG_ENTRY			28
 #define SJA1105ET_SIZE_L2_LOOKUP_PARAMS_ENTRY		4
@@ -29,11 +33,15 @@
 
 /* UM10944.pdf Page 11, Table 2. Configuration Blocks */
 enum {
+	BLKID_SCHEDULE					= 0x00,
+	BLKID_SCHEDULE_ENTRY_POINTS			= 0x01,
 	BLKID_L2_LOOKUP					= 0x05,
 	BLKID_L2_POLICING				= 0x06,
 	BLKID_VLAN_LOOKUP				= 0x07,
 	BLKID_L2_FORWARDING				= 0x08,
 	BLKID_MAC_CONFIG				= 0x09,
+	BLKID_SCHEDULE_PARAMS				= 0x0A,
+	BLKID_SCHEDULE_ENTRY_POINTS_PARAMS		= 0x0B,
 	BLKID_L2_LOOKUP_PARAMS				= 0x0D,
 	BLKID_L2_FORWARDING_PARAMS			= 0x0E,
 	BLKID_AVB_PARAMS				= 0x10,
@@ -42,11 +50,15 @@ enum {
 };
 
 enum sja1105_blk_idx {
-	BLK_IDX_L2_LOOKUP = 0,
+	BLK_IDX_SCHEDULE = 0,
+	BLK_IDX_SCHEDULE_ENTRY_POINTS,
+	BLK_IDX_L2_LOOKUP,
 	BLK_IDX_L2_POLICING,
 	BLK_IDX_VLAN_LOOKUP,
 	BLK_IDX_L2_FORWARDING,
 	BLK_IDX_MAC_CONFIG,
+	BLK_IDX_SCHEDULE_PARAMS,
+	BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS,
 	BLK_IDX_L2_LOOKUP_PARAMS,
 	BLK_IDX_L2_FORWARDING_PARAMS,
 	BLK_IDX_AVB_PARAMS,
@@ -59,11 +71,15 @@ enum sja1105_blk_idx {
 	BLK_IDX_INVAL = -1,
 };
 
+#define SJA1105_MAX_SCHEDULE_COUNT			1024
+#define SJA1105_MAX_SCHEDULE_ENTRY_POINTS_COUNT		2048
 #define SJA1105_MAX_L2_LOOKUP_COUNT			1024
 #define SJA1105_MAX_L2_POLICING_COUNT			45
 #define SJA1105_MAX_VLAN_LOOKUP_COUNT			4096
 #define SJA1105_MAX_L2_FORWARDING_COUNT			13
 #define SJA1105_MAX_MAC_CONFIG_COUNT			5
+#define SJA1105_MAX_SCHEDULE_PARAMS_COUNT		1
+#define SJA1105_MAX_SCHEDULE_ENTRY_POINTS_PARAMS_COUNT	1
 #define SJA1105_MAX_L2_LOOKUP_PARAMS_COUNT		1
 #define SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT		1
 #define SJA1105_MAX_GENERAL_PARAMS_COUNT		1
@@ -83,6 +99,23 @@ enum sja1105_blk_idx {
 #define SJA1105R_PART_NO				0x9A86
 #define SJA1105S_PART_NO				0x9A87
 
+struct sja1105_schedule_entry {
+	u64 winstindex;
+	u64 winend;
+	u64 winst;
+	u64 destports;
+	u64 setvalid;
+	u64 txen;
+	u64 resmedia_en;
+	u64 resmedia;
+	u64 vlindex;
+	u64 delta;
+};
+
+struct sja1105_schedule_params_entry {
+	u64 subscheind[8];
+};
+
 struct sja1105_general_params_entry {
 	u64 vllupformat;
 	u64 mirr_ptacu;
@@ -112,6 +145,17 @@ struct sja1105_general_params_entry {
 	u64 replay_port;
 };
 
+struct sja1105_schedule_entry_points_entry {
+	u64 subschindx;
+	u64 delta;
+	u64 address;
+};
+
+struct sja1105_schedule_entry_points_params_entry {
+	u64 clksrc;
+	u64 actsubsch;
+};
+
 struct sja1105_vlan_lookup_entry {
 	u64 ving_mirr;
 	u64 vegr_mirr;
@@ -256,6 +300,8 @@ sja1105_static_config_get_length(const struct sja1105_static_config *config);
 
 typedef enum {
 	SJA1105_CONFIG_OK = 0,
+	SJA1105_TTETHERNET_NOT_SUPPORTED,
+	SJA1105_INCORRECT_TTETHERNET_CONFIGURATION,
 	SJA1105_MISSING_L2_POLICING_TABLE,
 	SJA1105_MISSING_L2_FORWARDING_TABLE,
 	SJA1105_MISSING_L2_FORWARDING_PARAMS_TABLE,
-- 
2.17.1

