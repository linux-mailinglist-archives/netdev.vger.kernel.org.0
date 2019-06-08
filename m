Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF8F39F85
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbfFHMGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:06:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36672 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfFHMFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id u8so4209433wmm.1;
        Sat, 08 Jun 2019 05:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0+l+Wr1sIHp9MJA2YAWp1xAg1OgIafMRyHKoAvbZSB0=;
        b=Gw7B8FoNmk/DSuf4VNOaSmC1lPHreOgkWEcamLCEzKbXclEK3TitoG+gmGMGSDQYDL
         OLf8NL4B2ft+fFtf1aBG6fC6uRj7IsW9rDMNMsiRnOh7Q0eA54qHXF37iV2csk/jgtON
         FH4znRl9ijqYGRoAQLRmOuNNT4tZPighuuVKTgGCr+Q8KoDjVH+GjjlKW1B2r2tdCebB
         vc1eyyuXF33fWYBBZymum80ETisr/ovCX3cr9gWH5TiEr9X7EIdGKvgXLPQOPgMf9yTY
         pM5kRKyCVihgBliKLWjj16PVQ2/wF89m608r8HfYaW0Frq2Ug3ZCsNtg+Tc1ZXRFzdnn
         CAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0+l+Wr1sIHp9MJA2YAWp1xAg1OgIafMRyHKoAvbZSB0=;
        b=ST1IzhSWDcDM/oV/7ggbKc0aw3/eurpisrrBflDIo6ROBwqCX3a44S7ws2lG3M9Ixb
         Oxn4kNjOFef6xi4Oo/e9QjIQlc1VmS6uZZ6IGYzQaI11nDIy0ZJj4Y/26kWNp97e/dK7
         CEeNnzEI0q+EYdnbetZTwp34zLMdWzXTcGH7t5i1C8uNVCHZuOSe0r4c9PObQp9rypGw
         Sz7vEfpGUB3H/QIxynIelgkLxYSK2wUo3jTzGAEF9NjrkcGLkIoKZp/k+NslUHSnDy9H
         eOpKoQ33yYN16zqpU9VlGlPrrLsyYWpnj4Y2qD0xlpJAP8ajWaFzUFtggiyJ23K0QJEq
         3Bgg==
X-Gm-Message-State: APjAAAW1QP7OXKehkK9jqqSqvYgnSwWbG2itTBY3ci4Hq+jaz6vUumd/
        99NGFib/fgcTJWODidEXCfI=
X-Google-Smtp-Source: APXvYqwSbUJtijyn6QJPbjfH9qQP70q8kFzxPk/myR27gUKcNzHAZHg4h+QzFQaxMViBvEbZAvfNDQ==
X-Received: by 2002:a1c:3dc1:: with SMTP id k184mr7232197wma.88.1559995547402;
        Sat, 08 Jun 2019 05:05:47 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 11/17] net: dsa: sja1105: Add support for the AVB Parameters Table
Date:   Sat,  8 Jun 2019 15:04:37 +0300
Message-Id: <20190608120443.21889-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
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
Changes in v4:

None.

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
index 121ceccd8107..d129997174bb 100644
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
index e2f86b332b09..58f273eaf1ea 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -94,6 +94,28 @@ u32 sja1105_crc32(const void *buf, size_t len)
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
@@ -426,6 +448,7 @@ static u64 blk_id_map[BLK_IDX_MAX] = {
 	[BLK_IDX_MAC_CONFIG] = BLKID_MAC_CONFIG,
 	[BLK_IDX_L2_LOOKUP_PARAMS] = BLKID_L2_LOOKUP_PARAMS,
 	[BLK_IDX_L2_FORWARDING_PARAMS] = BLKID_L2_FORWARDING_PARAMS,
+	[BLK_IDX_AVB_PARAMS] = BLKID_AVB_PARAMS,
 	[BLK_IDX_GENERAL_PARAMS] = BLKID_GENERAL_PARAMS,
 	[BLK_IDX_XMII_PARAMS] = BLKID_XMII_PARAMS,
 };
@@ -627,6 +650,12 @@ struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
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
@@ -685,6 +714,12 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
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
@@ -743,6 +778,12 @@ struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
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
@@ -801,6 +842,12 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
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
@@ -859,6 +906,12 @@ struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
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
@@ -917,6 +970,12 @@ struct sja1105_table_ops sja1105s_table_ops[BLK_IDX_MAX] = {
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

