Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CED38E33B
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 11:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhEXJ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 05:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhEXJ1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 05:27:04 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676DDC061756
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:36 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id f18so10556705ejq.10
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 02:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gsjOsAbLjC1aLaqOCkLQq0Rt/VoD2lZoL8JXtd1CnAE=;
        b=AKFe5GxU4uUGKfB/O8+7cPTjlHa/9jQbwgP0m+hq4zNkTsRe/TuneNnMBG7FEwv8rF
         q1rdu9hUkD+ig1fvhk2yMnxUMTJa/mOYmr+eYhsl4gEJmr+8VcHMWDLyV0NJ2AS6WRwj
         HufmGE/3P8tGaeJKSpjl6mNcc02D/MjyWz7CrSif7Py2vBUy44HfCT5ZlSNUQgHwyPvc
         Aw3opAKcXafFETWBIgoTr31MXOIYpnUacgi7B2tIieX6EXX8rZxFnB037mV8ZlUEf2KK
         7pQ0S0FNCBdrABT0lGXg2JTJk8Bb24xG4dYdmJte8enyalMZBlNbqc9W3nLTIe2pn9yG
         Fi0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gsjOsAbLjC1aLaqOCkLQq0Rt/VoD2lZoL8JXtd1CnAE=;
        b=MKd08bLj/He/fK49AgT1J6X56JOG2+GY8zuDQE4qGyVwflz5OuxzSAgnQG/sITblPb
         bIqOIBvbjBrvRepdDly6DS6IpsuPL+8JUquV3sV5ZYpou4LqFDDabT49l2dj19qoDMn8
         A2NwYlVpqY9E2bCxVVTMpOJxmu/AhvQ9Ij6ansf/vI7qolujt6T9/zBY5tu7xx4VrOAa
         FRsFSTDCAIi+02l+Yubts7IUA/5LH7qdnZHj8B3Rzq3Ec3KK8JSRtw2FqV1KigTwvjcQ
         7Oy0zWq5PsbTUb8KFKlHCRrcvOiSqBuTzBxZQ8XEnq+hmo82iLuz0Yi8mNN0CKCK0xfl
         65+g==
X-Gm-Message-State: AOAM533ZiIDT7jpk1e7Ay8ctQuarlpRlto3XmnGC8GhDxlr5dqAMpqnX
        zzsilWnKW60ujbIQZgrlNWA=
X-Google-Smtp-Source: ABdhPJyAohoTi/mGveqqmTaweC4jVUWS4TJoEWSbEFYutkoxxNuw2FTI0v7qhcRtrI9kiL6EDnaLgw==
X-Received: by 2002:a17:906:4ece:: with SMTP id i14mr21713601ejv.249.1621848334941;
        Mon, 24 May 2021 02:25:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id yw9sm7553007ejb.91.2021.05.24.02.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 02:25:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 1/6] net: dsa: sja1105: fix VL lookup command packing for P/Q/R/S
Date:   Mon, 24 May 2021 12:25:22 +0300
Message-Id: <20210524092527.874479-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524092527.874479-1-olteanv@gmail.com>
References: <20210524092527.874479-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

At the beginning of the sja1105_dynamic_config.c file there is a diagram
of the dynamic config interface layout:

 packed_buf

 |
 V
 +-----------------------------------------+------------------+
 |              ENTRY BUFFER               |  COMMAND BUFFER  |
 +-----------------------------------------+------------------+

 <----------------------- packed_size ------------------------>

So in order to pack/unpack the command bits into the buffer,
sja1105_vl_lookup_cmd_packing must first advance the buffer pointer by
the length of the entry. This is similar to what the other *cmd_packing
functions do.

This bug exists because the command packing function for P/Q/R/S was
copied from the E/T generation, and on E/T, the command was actually
embedded within the entry buffer itself.

Fixes: 94f94d4acfb2 ("net: dsa: sja1105: add static tables for virtual links")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 23 +++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index b777d3f37573..12cd04b56803 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -167,9 +167,10 @@ enum sja1105_hostcmd {
 	SJA1105_HOSTCMD_INVALIDATE = 4,
 };
 
+/* Command and entry overlap */
 static void
-sja1105_vl_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
-			      enum packing_op op)
+sja1105et_vl_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				enum packing_op op)
 {
 	const int size = SJA1105_SIZE_DYN_CMD;
 
@@ -179,6 +180,20 @@ sja1105_vl_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	sja1105_packing(buf, &cmd->index,    9,  0, size, op);
 }
 
+/* Command and entry are separate */
+static void
+sja1105pqrs_vl_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				  enum packing_op op)
+{
+	u8 *p = buf + SJA1105_SIZE_VL_LOOKUP_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->errors,  30, 30, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 29, 29, size, op);
+	sja1105_packing(p, &cmd->index,    9,  0, size, op);
+}
+
 static size_t sja1105et_vl_lookup_entry_packing(void *buf, void *entry_ptr,
 						enum packing_op op)
 {
@@ -641,7 +656,7 @@ static size_t sja1105pqrs_cbs_entry_packing(void *buf, void *entry_ptr,
 const struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_VL_LOOKUP] = {
 		.entry_packing = sja1105et_vl_lookup_entry_packing,
-		.cmd_packing = sja1105_vl_lookup_cmd_packing,
+		.cmd_packing = sja1105et_vl_lookup_cmd_packing,
 		.access = OP_WRITE,
 		.max_entry_count = SJA1105_MAX_VL_LOOKUP_COUNT,
 		.packed_size = SJA1105ET_SIZE_VL_LOOKUP_DYN_CMD,
@@ -725,7 +740,7 @@ const struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 const struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_VL_LOOKUP] = {
 		.entry_packing = sja1105_vl_lookup_entry_packing,
-		.cmd_packing = sja1105_vl_lookup_cmd_packing,
+		.cmd_packing = sja1105pqrs_vl_lookup_cmd_packing,
 		.access = (OP_READ | OP_WRITE),
 		.max_entry_count = SJA1105_MAX_VL_LOOKUP_COUNT,
 		.packed_size = SJA1105PQRS_SIZE_VL_LOOKUP_DYN_CMD,
-- 
2.25.1

