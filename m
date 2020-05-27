Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39951E4A77
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389733AbgE0QkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgE0QkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:40:16 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D46C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:40:15 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id e10so20803558edq.0
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZlD6G96C59XcwrXI1TGeJCOEYLySzbqe5I3feupaN9s=;
        b=WxbMvW3woYTHlxwf423367G/Enr7g0nDP6GkgvKDfc0OJKiFu9jRii95e4QiT3YCeB
         YWhat+vBG4Px1Qeff81/BnxeGspO7Djrfu2GUtCWgLd++QpgAF7762NsBr/JbUiifeBv
         oW7Ky494RUeN10Z8b4//OVddXxQTkYsBH7C/QF9ZGBOD0NE6L2NproplzwTwyugu1oX1
         52Kz/CieePPtcaBWQwIpQOpUYS2U6O+Z4WQSjZhUXjUKgTj2I5cBo2MTXX93WY6/dCMH
         +NV0ty3HJIFuzdLvKkyL1wAz0vD/5gsTFjHOBSv0hwm52JTwkWt9iYsbVbvSFlmD1WPI
         SuLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZlD6G96C59XcwrXI1TGeJCOEYLySzbqe5I3feupaN9s=;
        b=i+9f7/rJpukqrOd3BkfXTFo6ilewWxm0/PaC1GYFB2psy99qXLGZE7WvMy1+kcsdJW
         74gxB+TuOmcJXNnhAUUrbSIOK+u08HivJlCrcsdF9CBARP5JgnQTuQ1MA9ew1iEAE8Sk
         6FzJE7lkhYX5KQhOrD3GBFDF1kyn7nm/k28OHuyX54xPpgvE51EQdkAsjetDbpzeSVI/
         StdGQ4rYg6eLcd5AU1Biq4xElBVqVOsss8/9x5EZf9EPukwtIES8toUWId1ZmCa5smeZ
         I7oyFP6eh3fMoKtAc4ThTcNQrwLf7/bp5kqK0Vku10eR06Tf/94s4RYHYNXyTF1nqObC
         voew==
X-Gm-Message-State: AOAM530ebbME6zYMZbIm2nGhAGZTveX9Z+3Qz8lciCUI9U2BfPxgXeW/
        TIFeQuRtTdWXoU6MD/QED0g=
X-Google-Smtp-Source: ABdhPJxYxmanPrhr5Os1xaV8WHVIdVk/23TbiYuAvwiHn+oXHlOQWUb6sZW9m8SJheP4BsFYsnkTKQ==
X-Received: by 2002:a50:e14e:: with SMTP id i14mr3095254edl.279.1590597614267;
        Wed, 27 May 2020 09:40:14 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id g22sm1526311edj.63.2020.05.27.09.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 09:40:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net] net: dsa: sja1105: fix port mirroring for P/Q/R/S
Date:   Wed, 27 May 2020 19:40:06 +0300
Message-Id: <20200527164006.1080903-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The dynamic configuration interface for the General Params and the L2
Lookup Params tables was copy-pasted between E/T devices and P/Q/R/S
devices. Nonetheless, these interfaces are bitwise different (and not to
mention, located at different SPI addresses).

The driver is using dynamic reconfiguration of the General Parameters
table for the port mirroring feature, which was therefore broken on
P/Q/R/S.

Note that I don't think this patch can be backported very far to stable
trees (since it conflicts with some other development done since the
introduction of the driver).

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h             |  4 ++
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 50 +++++++++++++++----
 .../net/dsa/sja1105/sja1105_static_config.c   | 10 ++--
 3 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 198d2a7d7f95..303b21470d77 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -322,6 +322,10 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 			const unsigned char *addr, u16 vid);
 
 /* Common implementations for the static and dynamic configs */
+size_t sja1105pqrs_general_params_entry_packing(void *buf, void *entry_ptr,
+						enum packing_op op);
+size_t sja1105pqrs_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
+						  enum packing_op op);
 size_t sja1105_l2_forwarding_entry_packing(void *buf, void *entry_ptr,
 					   enum packing_op op);
 size_t sja1105pqrs_l2_lookup_entry_packing(void *buf, void *entry_ptr,
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 2a8fbd7fdedc..f98c98a063e7 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -127,9 +127,15 @@
 #define SJA1105ET_SIZE_L2_LOOKUP_PARAMS_DYN_CMD			\
 	SJA1105_SIZE_DYN_CMD
 
+#define SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_DYN_CMD		\
+	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_ENTRY)
+
 #define SJA1105ET_SIZE_GENERAL_PARAMS_DYN_CMD			\
 	SJA1105_SIZE_DYN_CMD
 
+#define SJA1105PQRS_SIZE_GENERAL_PARAMS_DYN_CMD			\
+	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY)
+
 #define SJA1105PQRS_SIZE_AVB_PARAMS_DYN_CMD			\
 	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY)
 
@@ -137,7 +143,7 @@
 	(SJA1105_SIZE_DYN_CMD + SJA1105_SIZE_RETAGGING_ENTRY)
 
 #define SJA1105_MAX_DYN_CMD_SIZE				\
-	SJA1105PQRS_SIZE_MAC_CONFIG_DYN_CMD
+	SJA1105PQRS_SIZE_GENERAL_PARAMS_DYN_CMD
 
 struct sja1105_dyn_cmd {
 	bool search;
@@ -494,6 +500,18 @@ sja1105et_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
 	return 0;
 }
 
+static void
+sja1105pqrs_l2_lookup_params_cmd_packing(void *buf,
+					 struct sja1105_dyn_cmd *cmd,
+					 enum packing_op op)
+{
+	u8 *p = buf + SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 30, 30, size, op);
+}
+
 static void
 sja1105et_general_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				     enum packing_op op)
@@ -516,6 +534,18 @@ sja1105et_general_params_entry_packing(void *buf, void *entry_ptr,
 	return 0;
 }
 
+static void
+sja1105pqrs_general_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				       enum packing_op op)
+{
+	u8 *p = buf + SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->errors,  30, 30, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 28, 28, size, op);
+}
+
 static void
 sja1105pqrs_avb_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				   enum packing_op op)
@@ -693,12 +723,12 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
 	[BLK_IDX_VL_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
-		.entry_packing = sja1105et_l2_lookup_params_entry_packing,
-		.cmd_packing = sja1105et_l2_lookup_params_cmd_packing,
+		.entry_packing = sja1105pqrs_l2_lookup_params_entry_packing,
+		.cmd_packing = sja1105pqrs_l2_lookup_params_cmd_packing,
 		.max_entry_count = SJA1105_MAX_L2_LOOKUP_PARAMS_COUNT,
 		.access = (OP_READ | OP_WRITE),
-		.packed_size = SJA1105ET_SIZE_L2_LOOKUP_PARAMS_DYN_CMD,
-		.addr = 0x38,
+		.packed_size = SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_DYN_CMD,
+		.addr = 0x54,
 	},
 	[BLK_IDX_L2_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_AVB_PARAMS] = {
@@ -710,12 +740,12 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.addr = 0x8003,
 	},
 	[BLK_IDX_GENERAL_PARAMS] = {
-		.entry_packing = sja1105et_general_params_entry_packing,
-		.cmd_packing = sja1105et_general_params_cmd_packing,
+		.entry_packing = sja1105pqrs_general_params_entry_packing,
+		.cmd_packing = sja1105pqrs_general_params_cmd_packing,
 		.max_entry_count = SJA1105_MAX_GENERAL_PARAMS_COUNT,
-		.access = OP_WRITE,
-		.packed_size = SJA1105ET_SIZE_GENERAL_PARAMS_DYN_CMD,
-		.addr = 0x34,
+		.access = (OP_READ | OP_WRITE),
+		.packed_size = SJA1105PQRS_SIZE_GENERAL_PARAMS_DYN_CMD,
+		.addr = 0x3B,
 	},
 	[BLK_IDX_RETAGGING] = {
 		.entry_packing = sja1105_retagging_entry_packing,
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 780aca034cdc..ff3fe471efc2 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -146,9 +146,8 @@ static size_t sja1105et_general_params_entry_packing(void *buf, void *entry_ptr,
 /* TPID and TPID2 are intentionally reversed so that semantic
  * compatibility with E/T is kept.
  */
-static size_t
-sja1105pqrs_general_params_entry_packing(void *buf, void *entry_ptr,
-					 enum packing_op op)
+size_t sja1105pqrs_general_params_entry_packing(void *buf, void *entry_ptr,
+						enum packing_op op)
 {
 	const size_t size = SJA1105PQRS_SIZE_GENERAL_PARAMS_ENTRY;
 	struct sja1105_general_params_entry *entry = entry_ptr;
@@ -228,9 +227,8 @@ sja1105et_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
-static size_t
-sja1105pqrs_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
-					   enum packing_op op)
+size_t sja1105pqrs_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
+						  enum packing_op op)
 {
 	const size_t size = SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_ENTRY;
 	struct sja1105_l2_lookup_params_entry *entry = entry_ptr;
-- 
2.25.1

