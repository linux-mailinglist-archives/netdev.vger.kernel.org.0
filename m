Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB57F34E57
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfFDRIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:08:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34141 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbfFDRIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id e16so8389542wrn.1;
        Tue, 04 Jun 2019 10:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P5Lnnbfs/dBJs54MjcQs1UJsoUQMvWqFohy7RWAevwM=;
        b=vX6HHOxhebZ/tYAtHdT3aej7vtOIIbMYiQTcnuSbMPL8y4A3qDNkL/TmYVjfV/hEr+
         SV3x0v1lYwoMH364wikwr9Fk3m+Jw7mMNhmqwIAdOnZbvjNHeZQ7eeqiNXZGnVEV2i+o
         OmmNq5bELbHr19EZAeqTjA43RS6RvAxnpeqQ/y4daiU+0pJVEN6jXkCWo8tV5mQam/fm
         NzgD17QlB0ZiRQm4nbs3R+OVXJuz/k01A6rvKdype8K1EizFvsCq8J20dQdR52Ae/nRB
         sWUnLz7f1SaGdhwKrpEAh/JyvWEQJ0+3MXv6K+PaNp/CEbVUT1CHh3cd92hL6p0+3QAt
         JteQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P5Lnnbfs/dBJs54MjcQs1UJsoUQMvWqFohy7RWAevwM=;
        b=hsJWQfxQCknq1LHy+7DpSxNQNkt/IZwcrHiP+pvsiI8JVW3kHaf3j5+dkiR8LiSda4
         O11Sx1pORwfbeVaSsx9ZUJo4u6MLCHZnUheqsKaDnCr6GCSeMLtt3mOHnMlkkxQIguf+
         C3PNkh20n/yzrAl1ZDVuRraFsEYnEEH7h4rWOy7FADHqG5xBrcIHOqOL2W0ptP5GnKZL
         j4nVWQtyzlDLdxboP218t+FvWS6WSckzKKsl9wg9KR8bKqmEy8TzU5CuQZOEkOWaHba6
         bpSYoUTgV2qjs7E5zKmMTszwcxymcv/K3N7CUnsOswNYGJ7WcYw3h1k+U78Fss3cDgWJ
         wETQ==
X-Gm-Message-State: APjAAAVszxtmr3DieEE0V2v7dfz/Ev8eVFOrrCulMPO3LrHyOSgyC3V5
        ysETz7lJLhqpkmFY6YK/sEdrWftjQm8=
X-Google-Smtp-Source: APXvYqxgPRy6Pl4Z7lwzkxg+nC5cEcoigTvncIi9N4nthNR4QVDKbrcfapKGaBgTaOVHMoni8QlV0g==
X-Received: by 2002:a5d:6207:: with SMTP id y7mr3456530wru.265.1559668095584;
        Tue, 04 Jun 2019 10:08:15 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 11/17] net: dsa: sja1105: Add support for the AVB Parameters Table
Date:   Tue,  4 Jun 2019 20:07:50 +0300
Message-Id: <20190604170756.14338-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This table is used to program the switch to emit "meta" follow-up
Ethernet frames (which contain partial RX timestamps) after each
link-local frame that was trapped to the CPU port through MAC filtering.
This includes PTP frames.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:

Split from previous 09/10 patch (no functional changes).

Changes in v2:

None.

 .../net/dsa/sja1105/sja1105_dynamic_config.c  |  2 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 36 +++++++++++
 .../net/dsa/sja1105/sja1105_static_config.c   | 59 +++++++++++++++++++
 .../net/dsa/sja1105/sja1105_static_config.h   | 10 ++++
 4 files changed, 107 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 352bb6e89297..56c83b9d52e4 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -378,6 +378,7 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.addr = 0x38,
 	},
 	[BLK_IDX_L2_FORWARDING_PARAMS] = {0},
+	[BLK_IDX_AVB_PARAMS] = {0},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.entry_packing = sja1105et_general_params_entry_packing,
 		.cmd_packing = sja1105et_general_params_cmd_packing,
@@ -441,6 +442,7 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.addr = 0x38,
 	},
 	[BLK_IDX_L2_FORWARDING_PARAMS] = {0},
+	[BLK_IDX_AVB_PARAMS] = {0},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.entry_packing = sja1105et_general_params_entry_packing,
 		.cmd_packing = sja1105et_general_params_cmd_packing,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 45c65e77b61d..f83f924c0833 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -508,6 +508,39 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 	return 0;
 }
 
+static int sja1105_init_avb_params(struct sja1105_private *priv,
+				   bool on)
+{
+	struct sja1105_avb_params_entry *avb;
+	struct sja1105_table *table;
+
+	table = &priv->static_config.tables[BLK_IDX_AVB_PARAMS];
+
+	/* Discard previous AVB Parameters Table */
+	if (table->entry_count) {
+		kfree(table->entries);
+		table->entry_count = 0;
+	}
+
+	/* Configure the reception of meta frames only if requested */
+	if (!on)
+		return 0;
+
+	table->entries = kcalloc(SJA1105_MAX_AVB_PARAMS_COUNT,
+				 table->ops->unpacked_entry_size, GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+
+	table->entry_count = SJA1105_MAX_AVB_PARAMS_COUNT;
+
+	avb = table->entries;
+
+	avb->destmeta = SJA1105_META_DMAC;
+	avb->srcmeta  = SJA1105_META_SMAC;
+
+	return 0;
+}
+
 static int sja1105_static_config_load(struct sja1105_private *priv,
 				      struct sja1105_dt_port *ports)
 {
@@ -546,6 +579,9 @@ static int sja1105_static_config_load(struct sja1105_private *priv,
 	if (rc < 0)
 		return rc;
 	rc = sja1105_init_general_params(priv);
+	if (rc < 0)
+		return rc;
+	rc = sja1105_init_avb_params(priv, false);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 6d65a7b09395..242f001c59fe 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -91,6 +91,28 @@ u32 sja1105_crc32(const void *buf, size_t len)
 	return ~crc;
 }
 
+static size_t sja1105et_avb_params_entry_packing(void *buf, void *entry_ptr,
+						 enum packing_op op)
+{
+	const size_t size = SJA1105ET_SIZE_AVB_PARAMS_ENTRY;
+	struct sja1105_avb_params_entry *entry = entry_ptr;
+
+	sja1105_packing(buf, &entry->destmeta, 95, 48, size, op);
+	sja1105_packing(buf, &entry->srcmeta,  47,  0, size, op);
+	return size;
+}
+
+static size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
+						   enum packing_op op)
+{
+	const size_t size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY;
+	struct sja1105_avb_params_entry *entry = entry_ptr;
+
+	sja1105_packing(buf, &entry->destmeta,   125,  78, size, op);
+	sja1105_packing(buf, &entry->srcmeta,     77,  30, size, op);
+	return size;
+}
+
 static size_t sja1105et_general_params_entry_packing(void *buf, void *entry_ptr,
 						     enum packing_op op)
 {
@@ -423,6 +445,7 @@ static u64 blk_id_map[BLK_IDX_MAX] = {
 	[BLK_IDX_MAC_CONFIG] = BLKID_MAC_CONFIG,
 	[BLK_IDX_L2_LOOKUP_PARAMS] = BLKID_L2_LOOKUP_PARAMS,
 	[BLK_IDX_L2_FORWARDING_PARAMS] = BLKID_L2_FORWARDING_PARAMS,
+	[BLK_IDX_AVB_PARAMS] = BLKID_AVB_PARAMS,
 	[BLK_IDX_GENERAL_PARAMS] = BLKID_GENERAL_PARAMS,
 	[BLK_IDX_XMII_PARAMS] = BLKID_XMII_PARAMS,
 };
@@ -624,6 +647,12 @@ struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105et_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105ET_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105et_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
@@ -682,6 +711,12 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105et_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105ET_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105et_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
@@ -740,6 +775,12 @@ struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105pqrs_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105pqrs_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
@@ -798,6 +839,12 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105pqrs_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105pqrs_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
@@ -856,6 +903,12 @@ struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105pqrs_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105pqrs_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
@@ -914,6 +967,12 @@ struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105_SIZE_L2_FORWARDING_PARAMS_ENTRY,
 		.max_entry_count = SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT,
 	},
+	[BLK_IDX_AVB_PARAMS] = {
+		.packing = sja1105pqrs_avb_params_entry_packing,
+		.unpacked_entry_size = sizeof(struct sja1105_avb_params_entry),
+		.packed_entry_size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.packing = sja1105pqrs_general_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_general_params_entry),
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index d513b1c91b98..a9586d0b4b3b 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -20,10 +20,12 @@
 #define SJA1105ET_SIZE_MAC_CONFIG_ENTRY			28
 #define SJA1105ET_SIZE_L2_LOOKUP_PARAMS_ENTRY		4
 #define SJA1105ET_SIZE_GENERAL_PARAMS_ENTRY		40
+#define SJA1105ET_SIZE_AVB_PARAMS_ENTRY			12
 #define SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY		20
 #define SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY		32
 #define SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_ENTRY		16
 #define SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY		44
+#define SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY		16
 
 /* UM10944.pdf Page 11, Table 2. Configuration Blocks */
 enum {
@@ -34,6 +36,7 @@ enum {
 	BLKID_MAC_CONFIG				= 0x09,
 	BLKID_L2_LOOKUP_PARAMS				= 0x0D,
 	BLKID_L2_FORWARDING_PARAMS			= 0x0E,
+	BLKID_AVB_PARAMS				= 0x10,
 	BLKID_GENERAL_PARAMS				= 0x11,
 	BLKID_XMII_PARAMS				= 0x4E,
 };
@@ -46,6 +49,7 @@ enum sja1105_blk_idx {
 	BLK_IDX_MAC_CONFIG,
 	BLK_IDX_L2_LOOKUP_PARAMS,
 	BLK_IDX_L2_FORWARDING_PARAMS,
+	BLK_IDX_AVB_PARAMS,
 	BLK_IDX_GENERAL_PARAMS,
 	BLK_IDX_XMII_PARAMS,
 	BLK_IDX_MAX,
@@ -64,6 +68,7 @@ enum sja1105_blk_idx {
 #define SJA1105_MAX_L2_FORWARDING_PARAMS_COUNT		1
 #define SJA1105_MAX_GENERAL_PARAMS_COUNT		1
 #define SJA1105_MAX_XMII_PARAMS_COUNT			1
+#define SJA1105_MAX_AVB_PARAMS_COUNT			1
 
 #define SJA1105_MAX_FRAME_MEMORY			929
 
@@ -179,6 +184,11 @@ struct sja1105_l2_policing_entry {
 	u64 partition;
 };
 
+struct sja1105_avb_params_entry {
+	u64 destmeta;
+	u64 srcmeta;
+};
+
 struct sja1105_mac_config_entry {
 	u64 top[8];
 	u64 base[8];
-- 
2.17.1

