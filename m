Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC1C38E73A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhEXNQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbhEXNQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:16:20 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE576C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:50 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r11so31836511edt.13
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4igFFOPgZPtWQWXNKT4MZG6UFgI75s+36WABaYbxDE=;
        b=GdfIIdUxnzO7yee1tfQJ+DddFTPFC7+JTlvYijINuXoCUcKjwd9JClp1wKxn5AoeVE
         rv6G6G4U/tgHQc6FM4JMBLy6Oy4eV+nFgrkHNegN3jpt1SFS9ABVRgT55AxbXsMxdud0
         JFKPGV0Q2q8pmYBS6btPAeQpvgV6ru7Lt2/HE/Iu7mLgX+GMenlQ5pUL/fbsOt4UrleI
         jYfTSwJWnN6e4CFceBJD+WCS8qx+CMhKw0Mh2ZE3EuIav/yS/ziDrQTKMYSgAEB8h7Lh
         NedgOgMx6Z3hCH3kFX1rcT5Rrw6GaXovXy/OuCdI2E0b1O+TIW/yim93V2dyEV8y3gwO
         /z4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4igFFOPgZPtWQWXNKT4MZG6UFgI75s+36WABaYbxDE=;
        b=S7BkmLAKoUfumwHUajfY+B2MBk12QlW5E6CLdV7u2+Etnebud5Ajtc+YhlBEsODnwQ
         QdueAJy1Du9HJ9Md9wZ4ycn2TOY7lwKb1QvtUWrfpTNdU5z7FSKlJK5Xa5rByn7iKkOq
         sKcjKE7A9DkhST3jm65BmImmsOqGATrTjL9q29k/993q59iAtau2/sViw6W1CBUeGr8h
         kkxE8jel5/ZWaOVfg8ZybxO3f/gQk22mnVuu1B4xk/1k/XBcKLdmgzgCjH95s8PjYewG
         EXTd5yTqGY4UQv62H21bx7KCxnjG40mYZMSecieHi/DASBAsQvjYnHcFVIsbymYKaQp1
         Jnpg==
X-Gm-Message-State: AOAM5337oLgRpRG0m1rhFIzNE+rViW9ZMKHq5iQLj1XODtBl94uIamM8
        NIjJyv/LMyJ3nueJWm2UbqE=
X-Google-Smtp-Source: ABdhPJz1nipS1j80c6kMEPUh/OyIo9pSTCWdpTQRUrUPladkTMb5HTqYwbcb7U270+t5WhNi7myaDQ==
X-Received: by 2002:a05:6402:95d:: with SMTP id h29mr23684063edz.233.1621862089539;
        Mon, 24 May 2021 06:14:49 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm8009139ejz.24.2021.05.24.06.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:14:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 9/9] net: dsa: sja1105: allow the frame buffer size to be customized
Date:   Mon, 24 May 2021 16:14:21 +0300
Message-Id: <20210524131421.1030789-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524131421.1030789-1-olteanv@gmail.com>
References: <20210524131421.1030789-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The shared frame buffer of the SJA1110 is larger than that of SJA1105,
which is natural due to the fact that there are more ports.

Introduce yet another property in struct sja1105_info which encodes the
maximum number of 128 byte blocks that can be used for frame buffers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h             |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 21 ++++++++-----------
 drivers/net/dsa/sja1105/sja1105_spi.c         |  9 +++++++-
 .../net/dsa/sja1105/sja1105_static_config.c   | 13 ++++++------
 .../net/dsa/sja1105/sja1105_static_config.h   |  5 +++--
 5 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 47cad24e6af0..2ec03917feb3 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -90,6 +90,7 @@ struct sja1105_info {
 	 */
 	int ptpegr_ts_bytes;
 	int num_cbs_shapers;
+	int max_frame_mem;
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 6850f03be1f3..0385ef9e0026 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -469,12 +469,7 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 
 static int sja1105_init_l2_forwarding_params(struct sja1105_private *priv)
 {
-	struct sja1105_l2_forwarding_params_entry default_l2fwd_params = {
-		/* Disallow dynamic reconfiguration of vlan_pmap */
-		.max_dynp = 0,
-		/* Use a single memory partition for all ingress queues */
-		.part_spc = { SJA1105_MAX_FRAME_MEMORY, 0, 0, 0, 0, 0, 0, 0 },
-	};
+	struct sja1105_l2_forwarding_params_entry *l2fwd_params;
 	struct sja1105_table *table;
 
 	table = &priv->static_config.tables[BLK_IDX_L2_FORWARDING_PARAMS];
@@ -492,8 +487,12 @@ static int sja1105_init_l2_forwarding_params(struct sja1105_private *priv)
 	table->entry_count = table->ops->max_entry_count;
 
 	/* This table only has a single entry */
-	((struct sja1105_l2_forwarding_params_entry *)table->entries)[0] =
-				default_l2fwd_params;
+	l2fwd_params = table->entries;
+
+	/* Disallow dynamic reconfiguration of vlan_pmap */
+	l2fwd_params->max_dynp = 0;
+	/* Use a single memory partition for all ingress queues */
+	l2fwd_params->part_spc[0] = priv->info->max_frame_mem;
 
 	return 0;
 }
@@ -502,16 +501,14 @@ void sja1105_frame_memory_partitioning(struct sja1105_private *priv)
 {
 	struct sja1105_l2_forwarding_params_entry *l2_fwd_params;
 	struct sja1105_vl_forwarding_params_entry *vl_fwd_params;
+	int max_mem = priv->info->max_frame_mem;
 	struct sja1105_table *table;
-	int max_mem;
 
 	/* VLAN retagging is implemented using a loopback port that consumes
 	 * frame buffers. That leaves less for us.
 	 */
 	if (priv->vlan_state == SJA1105_VLAN_BEST_EFFORT)
-		max_mem = SJA1105_MAX_FRAME_MEMORY_RETAGGING;
-	else
-		max_mem = SJA1105_MAX_FRAME_MEMORY;
+		max_mem -= SJA1105_FRAME_MEMORY_RETAGGING_OVERHEAD;
 
 	table = &priv->static_config.tables[BLK_IDX_L2_FORWARDING_PARAMS];
 	l2_fwd_params = table->entries;
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 79ba86096a4b..d0bc6cf90bfd 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -271,7 +271,8 @@ int static_config_buf_prepare_for_upload(struct sja1105_private *priv,
 	char *final_header_ptr;
 	int crc_len;
 
-	valid = sja1105_static_config_check_valid(config);
+	valid = sja1105_static_config_check_valid(config,
+						  priv->info->max_frame_mem);
 	if (valid != SJA1105_CONFIG_OK) {
 		dev_err(&priv->spidev->dev,
 			sja1105_static_config_error_msg[valid]);
@@ -474,6 +475,7 @@ const struct sja1105_info sja1105e_info = {
 	.can_limit_mcast_flood	= false,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
+	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
 	.num_cbs_shapers	= SJA1105ET_MAX_CBS_COUNT,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
@@ -493,6 +495,7 @@ const struct sja1105_info sja1105t_info = {
 	.can_limit_mcast_flood	= false,
 	.ptp_ts_bits		= 24,
 	.ptpegr_ts_bytes	= 4,
+	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
 	.num_cbs_shapers	= SJA1105ET_MAX_CBS_COUNT,
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
@@ -512,6 +515,7 @@ const struct sja1105_info sja1105p_info = {
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
@@ -532,6 +536,7 @@ const struct sja1105_info sja1105q_info = {
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
@@ -552,6 +557,7 @@ const struct sja1105_info sja1105r_info = {
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
@@ -573,6 +579,7 @@ const struct sja1105_info sja1105s_info = {
 	.can_limit_mcast_flood	= true,
 	.ptp_ts_bits		= 32,
 	.ptpegr_ts_bytes	= 8,
+	.max_frame_mem		= SJA1105_MAX_FRAME_MEMORY,
 	.num_cbs_shapers	= SJA1105PQRS_MAX_CBS_COUNT,
 	.setup_rgmii_delay	= sja1105pqrs_setup_rgmii_delay,
 	.reset_cmd		= sja1105pqrs_reset_cmd,
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index a8efb7fac395..33f91ecbe07b 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -657,11 +657,11 @@ const char *sja1105_static_config_error_msg[] = {
 };
 
 static sja1105_config_valid_t
-static_config_check_memory_size(const struct sja1105_table *tables)
+static_config_check_memory_size(const struct sja1105_table *tables, int max_mem)
 {
 	const struct sja1105_l2_forwarding_params_entry *l2_fwd_params;
 	const struct sja1105_vl_forwarding_params_entry *vl_fwd_params;
-	int i, max_mem, mem = 0;
+	int i, mem = 0;
 
 	l2_fwd_params = tables[BLK_IDX_L2_FORWARDING_PARAMS].entries;
 
@@ -675,9 +675,7 @@ static_config_check_memory_size(const struct sja1105_table *tables)
 	}
 
 	if (tables[BLK_IDX_RETAGGING].entry_count)
-		max_mem = SJA1105_MAX_FRAME_MEMORY_RETAGGING;
-	else
-		max_mem = SJA1105_MAX_FRAME_MEMORY;
+		max_mem -= SJA1105_FRAME_MEMORY_RETAGGING_OVERHEAD;
 
 	if (mem > max_mem)
 		return SJA1105_OVERCOMMITTED_FRAME_MEMORY;
@@ -686,7 +684,8 @@ static_config_check_memory_size(const struct sja1105_table *tables)
 }
 
 sja1105_config_valid_t
-sja1105_static_config_check_valid(const struct sja1105_static_config *config)
+sja1105_static_config_check_valid(const struct sja1105_static_config *config,
+				  int max_mem)
 {
 	const struct sja1105_table *tables = config->tables;
 #define IS_FULL(blk_idx) \
@@ -754,7 +753,7 @@ sja1105_static_config_check_valid(const struct sja1105_static_config *config)
 	if (!IS_FULL(BLK_IDX_XMII_PARAMS))
 		return SJA1105_MISSING_XMII_TABLE;
 
-	return static_config_check_memory_size(tables);
+	return static_config_check_memory_size(tables, max_mem);
 #undef IS_FULL
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 9bc783a2bbea..4ddb06bd8e92 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -115,7 +115,7 @@ enum sja1105_blk_idx {
 #define SJA1105PQRS_MAX_CBS_COUNT			16
 
 #define SJA1105_MAX_FRAME_MEMORY			929
-#define SJA1105_MAX_FRAME_MEMORY_RETAGGING		910
+#define SJA1105_FRAME_MEMORY_RETAGGING_OVERHEAD		19
 #define SJA1105_VL_FRAME_MEMORY				100
 
 #define SJA1105E_DEVICE_ID				0x9C00000Cull
@@ -416,7 +416,8 @@ typedef enum {
 extern const char *sja1105_static_config_error_msg[];
 
 sja1105_config_valid_t
-sja1105_static_config_check_valid(const struct sja1105_static_config *config);
+sja1105_static_config_check_valid(const struct sja1105_static_config *config,
+				  int max_mem);
 void
 sja1105_static_config_pack(void *buf, struct sja1105_static_config *config);
 int sja1105_static_config_init(struct sja1105_static_config *config,
-- 
2.25.1

