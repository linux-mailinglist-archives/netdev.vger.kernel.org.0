Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65173B53C4
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhF0O3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhF0O3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:29:40 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB0DC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:27:16 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id yy20so16718514ejb.6
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UfoiygWHNUpm4I6CQGjQwLqViDT2vNralulzzr0DlQE=;
        b=lCwFWpSNEePQsxmYTxe09VV3bo3AS/c520D2JzzPOC2FsEUKK0sXzxscxJkeOEZH1n
         Gktxh7P4ZCS5VRxZpKErqs+T+5N2ggPVH7CtZofE0m6wEDk/NqinA4A+MgIlFpTeFype
         VSrsyu+Gm5GAqq3Cv90YrPOWJfh8xhy5IrKk2wQCfliEEDzSL+Ksm8oM9jeck1l35D3e
         eyslCSCYLAS05Em51lXxvcCfsNHNOyK+mK2s7L11SJ5sCpysOw7B2z3AmQWO8EwzG7Ed
         OSi1rzCaS01HVLlIU9LBvuNBIwVbgJHdn+DukKC9b5ED+/JE9NEcErHAhrHNWf44VC1g
         aLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UfoiygWHNUpm4I6CQGjQwLqViDT2vNralulzzr0DlQE=;
        b=VQT8vGmb2IFSZw9m6RzfERVzw8yYPxVw4gnJ9c2bADVH9Y4fRhoPDue1apX4JxqB5G
         +H+LmRl7mc/sPhmis7adntW0AVnGi0xgTTFtUHr3mMIz1mt8IU+muClMmvrs0xOZCyoQ
         ncL5y8pX/Sg3Jy61Dr4eqqqyQPQ3zrsk685MBM5rtkpU20AHaxL7NQ5MmOVJmMdwAaaX
         H6KiuQhWMzzRHtGPd8vpRUsGq49BqKSRU73iOZzr+orSBLMkIU2f9EvwaKVoB/tWMUzz
         asNMH1+LV359rNdDnKUcbZdE3hDCSLr1hgCGpcg1iFycPtTNBXcIoa4PdsfxYZ0/jnF9
         sABA==
X-Gm-Message-State: AOAM533uf929m4iFFI9BAeCtuPFmZ7wcWXrMDEhnL5mLX+0e6ddkxJqu
        /arlwHfdbkTc+WJnU84Didw=
X-Google-Smtp-Source: ABdhPJy76yeOXE2W6z2yNrQTEj+8qFse5Iz0G9B5jfekkSWUESG81aRxiOVkKhooWkJrazfa9F+SzQ==
X-Received: by 2002:a17:906:2892:: with SMTP id o18mr19912994ejd.370.1624804034739;
        Sun, 27 Jun 2021 07:27:14 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id hg25sm5585855ejc.51.2021.06.27.07.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:27:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: sja1105: fix dynamic access to L2 Address Lookup table for SJA1110
Date:   Sun, 27 Jun 2021 17:27:08 +0300
Message-Id: <20210627142708.1277273-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1105P/Q/R/S and SJA1110 may have the same layout for the command
to read/write/search for L2 Address Lookup entries, but as explained in
the comments at the beginning of the sja1105_dynamic_config.c file, the
command portion of the buffer is at the end, and we need to obtain a
pointer to it by adding the length of the entry to the buffer.

Alas, the length of an L2 Address Lookup entry is larger in SJA1110 than
it is for SJA1105P/Q/R/S, so we need to create a common helper to access
the command buffer, and this receives as argument the length of the
entry buffer.

Fixes: 3e77e59bf8cf ("net: dsa: sja1105: add support for the SJA1110 switch family")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 26 ++++++++++++++++---
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 4c4c04f04269..56fead68ea9f 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -258,11 +258,11 @@ sja1110_vl_policing_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 }
 
 static void
-sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
-				  enum packing_op op)
+sja1105pqrs_common_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+					 enum packing_op op, int entry_size)
 {
-	u8 *p = buf + SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY;
 	const int size = SJA1105_SIZE_DYN_CMD;
+	u8 *p = buf + entry_size;
 	u64 hostcmd;
 
 	sja1105_packing(p, &cmd->valid,    31, 31, size, op);
@@ -317,6 +317,24 @@ sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 			SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY, op);
 }
 
+static void
+sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				  enum packing_op op)
+{
+	int size = SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY;
+
+	return sja1105pqrs_common_l2_lookup_cmd_packing(buf, cmd, op, size);
+}
+
+static void
+sja1110_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+			      enum packing_op op)
+{
+	int size = SJA1110_SIZE_L2_LOOKUP_ENTRY;
+
+	return sja1105pqrs_common_l2_lookup_cmd_packing(buf, cmd, op, size);
+}
+
 /* The switch is so retarded that it makes our command/entry abstraction
  * crumble apart.
  *
@@ -1055,7 +1073,7 @@ const struct sja1105_dynamic_table_ops sja1110_dyn_ops[BLK_IDX_MAX_DYN] = {
 	},
 	[BLK_IDX_L2_LOOKUP] = {
 		.entry_packing = sja1110_dyn_l2_lookup_entry_packing,
-		.cmd_packing = sja1105pqrs_l2_lookup_cmd_packing,
+		.cmd_packing = sja1110_l2_lookup_cmd_packing,
 		.access = (OP_READ | OP_WRITE | OP_DEL | OP_SEARCH),
 		.max_entry_count = SJA1105_MAX_L2_LOOKUP_COUNT,
 		.packed_size = SJA1110_SIZE_L2_LOOKUP_DYN_CMD,
-- 
2.25.1

