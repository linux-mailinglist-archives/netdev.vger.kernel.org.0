Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F441E9091
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 12:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgE3KaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 06:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbgE3KaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 06:30:14 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE12C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 03:30:13 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l27so4599829ejc.1
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 03:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LT4D3xYy5oMKofGfXg8CPR9c5atxjRMzgC5KCuW7gMc=;
        b=RCJYVpo9iCocr7ksNchQtz9XEfC5vsVEmqcTBVh2Sptkj03B2PwdBuMtXfN+/zlyBc
         FqxYps2kIJ9kHvntKX57T69Ep71884RpXymB8KSXQf38CUUN5OF/IhcGoqXuV9gWwVjV
         HqH39Lih95DIRmKjcyFchf47P2i3r8em5BD8gdUtZT0lxf+tklESkmSw+3ub+AqaEmhM
         baTU/Lxn/YabvemS5gautURLVeRXMzZt3juqurELmmX3/l9z8zofiALvks/ivMxtUOcl
         tp0Yl39EBd5To1SYsvGBCTWwUbT0e9lTneEJDUEv8DEIVawpZKn8wHOr+LZoNzRqMyvy
         HgWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LT4D3xYy5oMKofGfXg8CPR9c5atxjRMzgC5KCuW7gMc=;
        b=ZGeshLv57grFkLEg/tZz7x3J80oodBnNLG+DINQRefInPV1gwnMm6wNvHCT/Y68LV5
         CFRpHOLhL+PuTWi/6ipnNqUdjSvUGl6lGOQCklidBQVqXnikZth1CFaKk7QD95vPf1hC
         DDK+PIoIblQ7au5PsHK5OSOoDpmCWqOPv8KK7eBRLhsCXraclmdYWArBIfrxOkA5u7Nb
         HPbzJoTWXVoadFWMnO+snNgSXPUFkdwZtfcNW47w2MIBK5nlvBOinPPvqM3b/Mto8BTc
         IFIDcjdVav7d+A1Hu6MR6f1AGFhl1RmRDg8qqhFMZMND+R2hl0HtX0JxYOs61nRBJBvC
         Ywkg==
X-Gm-Message-State: AOAM533tYOhRym+8/XFrYy6zioJWJ/KnkKAOKkUvq6irHO325iWoJVXT
        mxubL7a/ePr5j5u+n6AVrtE=
X-Google-Smtp-Source: ABdhPJw7N7WfSGgB5Zba2EFMYqRv2z3pMGbh8cRuOT+Ztcr/uA0jsn7eQNnBkSoYDIAipkE0ak5nZA==
X-Received: by 2002:a17:906:851:: with SMTP id f17mr683837ejd.396.1590834612520;
        Sat, 30 May 2020 03:30:12 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id g21sm9511204edw.9.2020.05.30.03.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 03:30:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: dsa: sja1105: fix port mirroring for P/Q/R/S
Date:   Sat, 30 May 2020 13:29:53 +0300
Message-Id: <20200530102953.692780-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200530102953.692780-1-olteanv@gmail.com>
References: <20200530102953.692780-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The dynamic configuration interface for the General Params and the L2
Lookup Params tables was copy-pasted between E/T devices and P/Q/R/S
devices. Nonetheless, these interfaces are bitwise different.

The driver is using dynamic reconfiguration of the General Parameters
table for the port mirroring feature, which was therefore broken on
P/Q/R/S.

Note that this patch can't be backported easily very far to stable trees
(since it conflicts with some other development done since the
introduction of the driver). So the Fixes: tag is purely informational.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 50 +++++++++++++++----
 .../net/dsa/sja1105/sja1105_static_config.c   | 10 ++--
 .../net/dsa/sja1105/sja1105_static_config.h   |  4 ++
 3 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 7516f2ffdd4e..4471eeccc293 100644
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
 
@@ -143,7 +149,7 @@
 	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_CBS_ENTRY)
 
 #define SJA1105_MAX_DYN_CMD_SIZE				\
-	SJA1105PQRS_SIZE_MAC_CONFIG_DYN_CMD
+	SJA1105PQRS_SIZE_GENERAL_PARAMS_DYN_CMD
 
 struct sja1105_dyn_cmd {
 	bool search;
@@ -500,6 +506,18 @@ sja1105et_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
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
@@ -522,6 +540,18 @@ sja1105et_general_params_entry_packing(void *buf, void *entry_ptr,
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
@@ -761,12 +791,12 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
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
@@ -778,12 +808,12 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
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
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 8279f4f31eff..ee0f10062763 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -431,6 +431,10 @@ void sja1105_packing(void *buf, u64 *val, int start, int end,
 		     size_t len, enum packing_op op);
 
 /* Common implementations for the static and dynamic configs */
+size_t sja1105pqrs_general_params_entry_packing(void *buf, void *entry_ptr,
+						enum packing_op op);
+size_t sja1105pqrs_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
+						  enum packing_op op);
 size_t sja1105_l2_forwarding_entry_packing(void *buf, void *entry_ptr,
 					   enum packing_op op);
 size_t sja1105pqrs_l2_lookup_entry_packing(void *buf, void *entry_ptr,
-- 
2.25.1

