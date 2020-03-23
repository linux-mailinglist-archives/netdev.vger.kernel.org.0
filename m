Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3424190177
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCWW7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:59:40 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40365 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgCWW7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 18:59:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id a81so1418115wmf.5
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 15:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mhEfMIFD0XoUUFJcCRUf1uC9j5UhFvOy81Sf6VYH49w=;
        b=mnGyF0TIrT6bsgdESXRkmgMrpBvAf1YRSYXBLtZm1MjdWL/Etxr8Hf2wt4FBmkeLtO
         OkxRmPs7j06DdYWfJWygev39/Dm+u7OwUTjcGLAw+O3FFEKIoixrgMQa/iYaBjBEg2wL
         J2NKzCDcs7VsS+Dl7C8DYmJZE7UmKyk9pWVrp6RcABXRFso/83zayDQUugHgtBe+UXrN
         U/6a2rXfmVF2Hi0x1F17akcAAjaHNiMl+2h7KP1yt/TSo7kO0bzqx4XV7fw226WlacDM
         FM2uQcHjdgVNr3HBlE9YbGWCUl1NrGNi4prYz6I+YA7w4Bat9M7X8FGcS0YYU4yuRIiq
         i+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mhEfMIFD0XoUUFJcCRUf1uC9j5UhFvOy81Sf6VYH49w=;
        b=Vmch/Zt3Chbp1CdMCVPGqwv+55BW+AWdf4CS3JzTfy33vsUu8/2H49UKIgmviu+Wbh
         jJ7p3DexYmH7KSM3cHtj5+msgz43Yk1njdUIpO67HMi02pPK9VgIGyrjpNwNHrPdd/PW
         y2LjcbDnjfTLRuK1eMhjSUaRicCwJVwP8+bsxBHa9Sdyr0iCZdGb6LN89NQNUUU1JrDE
         F4b9OOChzmFHtjRUBa3Mfwd/rTrXuZlDkmgEpD9r8IId2yXWxP8UafFQ6cMkR2QDWft/
         5SDKJAyRxYfy9ejWmbakZz1ys4oRKdqxoWXzGDbkHGMEppSroKAOiRmiosodBDLtuhQI
         SOvQ==
X-Gm-Message-State: ANhLgQ0OfIBR1Ct1m0AiR0kNLZbpW6UCPFHrD3evKW4QB2TfliZswC23
        xMfwsrBA6E77ozag7S4ck/M=
X-Google-Smtp-Source: ADFU+vv+zqvo55td5FixoOpx68a0/9H151TWIuijQoCoDqK4Qfd6CEuc30OBpUg1klJ7Qn9cR+BSCw==
X-Received: by 2002:a1c:4d0c:: with SMTP id o12mr540604wmh.119.1585004374703;
        Mon, 23 Mar 2020 15:59:34 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id r3sm26332912wrm.35.2020.03.23.15.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 15:59:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, richardcochran@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        christian.herber@nxp.com, yangbo.lu@nxp.com, netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] net: dsa: sja1105: make the AVB table dynamically reconfigurable
Date:   Tue, 24 Mar 2020 00:59:23 +0200
Message-Id: <20200323225924.14347-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323225924.14347-1-olteanv@gmail.com>
References: <20200323225924.14347-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The AVB table contains the CAS_MASTER field (to be added in the next
patch) which decides the direction of the PTP_CLK pin.

Reconfiguring this field dynamically is highly preferable to having to
reset the switch and upload a new static configuration, so we add
support for exactly that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h             |  2 ++
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 24 ++++++++++++++++++-
 .../net/dsa/sja1105/sja1105_static_config.c   |  4 ++--
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 4c40f2d51a54..5bc40175ee0d 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -214,5 +214,7 @@ size_t sja1105_vlan_lookup_entry_packing(void *buf, void *entry_ptr,
 					 enum packing_op op);
 size_t sja1105pqrs_mac_config_entry_packing(void *buf, void *entry_ptr,
 					    enum packing_op op);
+size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
+					    enum packing_op op);
 
 #endif
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 25381bd65ed7..bf9b36ff35bf 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -124,6 +124,9 @@
 #define SJA1105ET_SIZE_GENERAL_PARAMS_DYN_CMD			\
 	SJA1105_SIZE_DYN_CMD
 
+#define SJA1105PQRS_SIZE_AVB_PARAMS_DYN_CMD			\
+	(SJA1105_SIZE_DYN_CMD + SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY)
+
 #define SJA1105_MAX_DYN_CMD_SIZE				\
 	SJA1105PQRS_SIZE_MAC_CONFIG_DYN_CMD
 
@@ -481,6 +484,18 @@ sja1105et_general_params_entry_packing(void *buf, void *entry_ptr,
 	return 0;
 }
 
+static void
+sja1105pqrs_avb_params_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				   enum packing_op op)
+{
+	u8 *p = buf + SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(p, &cmd->valid,   31, 31, size, op);
+	sja1105_packing(p, &cmd->errors,  30, 30, size, op);
+	sja1105_packing(p, &cmd->rdwrset, 29, 29, size, op);
+}
+
 #define OP_READ		BIT(0)
 #define OP_WRITE	BIT(1)
 #define OP_DEL		BIT(2)
@@ -610,7 +625,14 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.addr = 0x38,
 	},
 	[BLK_IDX_L2_FORWARDING_PARAMS] = {0},
-	[BLK_IDX_AVB_PARAMS] = {0},
+	[BLK_IDX_AVB_PARAMS] = {
+		.entry_packing = sja1105pqrs_avb_params_entry_packing,
+		.cmd_packing = sja1105pqrs_avb_params_cmd_packing,
+		.max_entry_count = SJA1105_MAX_AVB_PARAMS_COUNT,
+		.access = (OP_READ | OP_WRITE),
+		.packed_size = SJA1105PQRS_SIZE_AVB_PARAMS_DYN_CMD,
+		.addr = 0x8003,
+	},
 	[BLK_IDX_GENERAL_PARAMS] = {
 		.entry_packing = sja1105et_general_params_entry_packing,
 		.cmd_packing = sja1105et_general_params_cmd_packing,
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 63d2311817c4..fccc9c4d6b35 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -102,8 +102,8 @@ static size_t sja1105et_avb_params_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
-static size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
-						   enum packing_op op)
+size_t sja1105pqrs_avb_params_entry_packing(void *buf, void *entry_ptr,
+					    enum packing_op op)
 {
 	const size_t size = SJA1105PQRS_SIZE_AVB_PARAMS_ENTRY;
 	struct sja1105_avb_params_entry *entry = entry_ptr;
-- 
2.17.1

