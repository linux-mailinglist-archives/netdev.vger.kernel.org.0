Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06121202597
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 19:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgFTRTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 13:19:49 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:47049 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbgFTRTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 13:19:46 -0400
Received: by mail-ed1-f68.google.com with SMTP id m21so10215677eds.13
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 10:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z3Lx3vkk/+ZzYXhKRZMlgxBvqTeX459gjPVSu7Lwzzs=;
        b=TsMcSaMDfdi/4MYV6Ox4OM/uuiYE+dyVDtpOSnGSoyIZzkx/krUGJ3FPrmyZqm2CDQ
         cpglHQrpR7m3fgU/l6nYtA/u/K9h48WGcfPkc7oowJXQ9FUm17CzoO8ZlfW6AERIDd7m
         hGj2+Pfh2xKxle5ovzR2j+lu1ryigxVXfS8VxbIu3KRylW4KJyr3OFXEaDoyyxFoJj31
         TZpPqzwbq8cxWXRFbPnVs8dD5PD3aleTEdPa1UlZjA1xxLky4CV10lu54YduBjc8AmZX
         NUMuxyKcZFnwQQCYswBt116V/az9dcbu4HFtiIt3ky37Tu4AkGM/S5KYavLUiL7EdzLa
         VXRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z3Lx3vkk/+ZzYXhKRZMlgxBvqTeX459gjPVSu7Lwzzs=;
        b=LQOEPRS1SOXP2sMhjgNV90On9DfbmvFrDVSWcU56MJgU8slwc+2leyvlsU13WWsT3n
         f2yNWjt4TDW4C5xpHIr0fJUtJXAJdXh2bGmfZapm3HuA0lMgqK0ATBTM5Qx2AXfbjbId
         n4b6+9tgFHJNgx8CweMWBYVesFx1QYJuy13G6CthPWtlrLanS/SU24G8VBDJDmt2PvoI
         SmooO+7driGPUgXbWeyWZOHtoYwz0PPUEYye7zPbrUZs3y+hoZ2ORwfvqu94zzs3fBUw
         kntbdPVlmAA1VBs5alLWocLPMpYIQzdOGB/9E3w1Ls2N5FKlVWvqrGqEXHxkFzj3w495
         BCCA==
X-Gm-Message-State: AOAM533I3XpXRCE8StXwbrw9fbWNejAX5W+9RWaSuqnSCkqoZkHiS9gm
        8W5Y1kxtd7IQ4LRfs0OWS/E=
X-Google-Smtp-Source: ABdhPJwLgtGBI0MIXCPFIm46NKhbdrFp/OFYT0Q1kNTQ+dlKcS/Ig250i+4dDqYitfgjo6hO5A4LSg==
X-Received: by 2002:a05:6402:1814:: with SMTP id g20mr9283699edy.197.1592673522705;
        Sat, 20 Jun 2020 10:18:42 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id a9sm7863476edr.23.2020.06.20.10.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 10:18:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: [PATCH net-next 1/3] net: dsa: sja1105: remove empty structures from config table ops
Date:   Sat, 20 Jun 2020 20:18:30 +0300
Message-Id: <20200620171832.3679837-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620171832.3679837-1-olteanv@gmail.com>
References: <20200620171832.3679837-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Sparse is complaining and giving the following warning message:
'Using plain integer as NULL pointer'.

This is not what's going on, instead {0} is used as a zero initializer
for the structure members, to indicate that the particular chip revision
does not support those particular config tables.

But since the config tables are declared globally, the unpopulated
elements are zero-initialized anyway. So, to make sparse shut up, let's
remove the zero initializers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 21 ----------------
 .../net/dsa/sja1105/sja1105_static_config.c   | 24 -------------------
 2 files changed, 45 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 4471eeccc293..331593ace215 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -639,8 +639,6 @@ static size_t sja1105pqrs_cbs_entry_packing(void *buf, void *entry_ptr,
 
 /* SJA1105E/T: First generation */
 struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
-	[BLK_IDX_SCHEDULE] = {0},
-	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
 	[BLK_IDX_VL_LOOKUP] = {
 		.entry_packing = sja1105et_vl_lookup_entry_packing,
 		.cmd_packing = sja1105_vl_lookup_cmd_packing,
@@ -649,8 +647,6 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105ET_SJA1105_SIZE_VL_LOOKUP_DYN_CMD,
 		.addr = 0x35,
 	},
-	[BLK_IDX_VL_POLICING] = {0},
-	[BLK_IDX_VL_FORWARDING] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.entry_packing = sja1105et_dyn_l2_lookup_entry_packing,
 		.cmd_packing = sja1105et_l2_lookup_cmd_packing,
@@ -667,7 +663,6 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105ET_SIZE_L2_LOOKUP_DYN_CMD,
 		.addr = 0x20,
 	},
-	[BLK_IDX_L2_POLICING] = {0},
 	[BLK_IDX_VLAN_LOOKUP] = {
 		.entry_packing = sja1105_vlan_lookup_entry_packing,
 		.cmd_packing = sja1105_vlan_lookup_cmd_packing,
@@ -692,9 +687,6 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105ET_SIZE_MAC_CONFIG_DYN_CMD,
 		.addr = 0x36,
 	},
-	[BLK_IDX_SCHEDULE_PARAMS] = {0},
-	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
-	[BLK_IDX_VL_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.entry_packing = sja1105et_l2_lookup_params_entry_packing,
 		.cmd_packing = sja1105et_l2_lookup_params_cmd_packing,
@@ -703,8 +695,6 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105ET_SIZE_L2_LOOKUP_PARAMS_DYN_CMD,
 		.addr = 0x38,
 	},
-	[BLK_IDX_L2_FORWARDING_PARAMS] = {0},
-	[BLK_IDX_AVB_PARAMS] = {0},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.entry_packing = sja1105et_general_params_entry_packing,
 		.cmd_packing = sja1105et_general_params_cmd_packing,
@@ -729,13 +719,10 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105ET_SIZE_CBS_DYN_CMD,
 		.addr = 0x2c,
 	},
-	[BLK_IDX_XMII_PARAMS] = {0},
 };
 
 /* SJA1105P/Q/R/S: Second generation */
 struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
-	[BLK_IDX_SCHEDULE] = {0},
-	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
 	[BLK_IDX_VL_LOOKUP] = {
 		.entry_packing = sja1105_vl_lookup_entry_packing,
 		.cmd_packing = sja1105_vl_lookup_cmd_packing,
@@ -744,8 +731,6 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105PQRS_SJA1105_SIZE_VL_LOOKUP_DYN_CMD,
 		.addr = 0x47,
 	},
-	[BLK_IDX_VL_POLICING] = {0},
-	[BLK_IDX_VL_FORWARDING] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.entry_packing = sja1105pqrs_dyn_l2_lookup_entry_packing,
 		.cmd_packing = sja1105pqrs_l2_lookup_cmd_packing,
@@ -762,7 +747,6 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105PQRS_SIZE_L2_LOOKUP_DYN_CMD,
 		.addr = 0x24,
 	},
-	[BLK_IDX_L2_POLICING] = {0},
 	[BLK_IDX_VLAN_LOOKUP] = {
 		.entry_packing = sja1105_vlan_lookup_entry_packing,
 		.cmd_packing = sja1105_vlan_lookup_cmd_packing,
@@ -787,9 +771,6 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105PQRS_SIZE_MAC_CONFIG_DYN_CMD,
 		.addr = 0x4B,
 	},
-	[BLK_IDX_SCHEDULE_PARAMS] = {0},
-	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
-	[BLK_IDX_VL_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.entry_packing = sja1105pqrs_l2_lookup_params_entry_packing,
 		.cmd_packing = sja1105pqrs_l2_lookup_params_cmd_packing,
@@ -798,7 +779,6 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_DYN_CMD,
 		.addr = 0x54,
 	},
-	[BLK_IDX_L2_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_AVB_PARAMS] = {
 		.entry_packing = sja1105pqrs_avb_params_entry_packing,
 		.cmd_packing = sja1105pqrs_avb_params_cmd_packing,
@@ -831,7 +811,6 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105PQRS_SIZE_CBS_DYN_CMD,
 		.addr = 0x32,
 	},
-	[BLK_IDX_XMII_PARAMS] = {0},
 };
 
 /* Provides read access to the settings through the dynamic interface
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index ff3fe471efc2..fb44c0a72285 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -839,11 +839,6 @@ sja1105_static_config_get_length(const struct sja1105_static_config *config)
 
 /* SJA1105E: First generation, no TTEthernet */
 struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
-	[BLK_IDX_SCHEDULE] = {0},
-	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
-	[BLK_IDX_VL_LOOKUP] = {0},
-	[BLK_IDX_VL_POLICING] = {0},
-	[BLK_IDX_VL_FORWARDING] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105et_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -874,9 +869,6 @@ struct sja1105_table_ops sja1105e_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105ET_SIZE_MAC_CONFIG_ENTRY,
 		.max_entry_count = SJA1105_MAX_MAC_CONFIG_COUNT,
 	},
-	[BLK_IDX_SCHEDULE_PARAMS] = {0},
-	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
-	[BLK_IDX_VL_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105et_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -1035,11 +1027,6 @@ struct sja1105_table_ops sja1105t_table_ops[BLK_IDX_MAX] = {
 
 /* SJA1105P: Second generation, no TTEthernet, no SGMII */
 struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
-	[BLK_IDX_SCHEDULE] = {0},
-	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
-	[BLK_IDX_VL_LOOKUP] = {0},
-	[BLK_IDX_VL_POLICING] = {0},
-	[BLK_IDX_VL_FORWARDING] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -1070,9 +1057,6 @@ struct sja1105_table_ops sja1105p_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY,
 		.max_entry_count = SJA1105_MAX_MAC_CONFIG_COUNT,
 	},
-	[BLK_IDX_SCHEDULE_PARAMS] = {0},
-	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
-	[BLK_IDX_VL_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105pqrs_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
@@ -1231,11 +1215,6 @@ struct sja1105_table_ops sja1105q_table_ops[BLK_IDX_MAX] = {
 
 /* SJA1105R: Second generation, no TTEthernet, SGMII */
 struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
-	[BLK_IDX_SCHEDULE] = {0},
-	[BLK_IDX_SCHEDULE_ENTRY_POINTS] = {0},
-	[BLK_IDX_VL_LOOKUP] = {0},
-	[BLK_IDX_VL_POLICING] = {0},
-	[BLK_IDX_VL_FORWARDING] = {0},
 	[BLK_IDX_L2_LOOKUP] = {
 		.packing = sja1105pqrs_l2_lookup_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_entry),
@@ -1266,9 +1245,6 @@ struct sja1105_table_ops sja1105r_table_ops[BLK_IDX_MAX] = {
 		.packed_entry_size = SJA1105PQRS_SIZE_MAC_CONFIG_ENTRY,
 		.max_entry_count = SJA1105_MAX_MAC_CONFIG_COUNT,
 	},
-	[BLK_IDX_SCHEDULE_PARAMS] = {0},
-	[BLK_IDX_SCHEDULE_ENTRY_POINTS_PARAMS] = {0},
-	[BLK_IDX_VL_FORWARDING_PARAMS] = {0},
 	[BLK_IDX_L2_LOOKUP_PARAMS] = {
 		.packing = sja1105pqrs_l2_lookup_params_entry_packing,
 		.unpacked_entry_size = sizeof(struct sja1105_l2_lookup_params_entry),
-- 
2.25.1

