Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD5739F242
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 11:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhFHJ2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 05:28:49 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:37600 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFHJ2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 05:28:44 -0400
Received: by mail-ej1-f47.google.com with SMTP id ce15so31493029ejb.4
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 02:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ToKAeI2JQi7vdsmaDuy6bvnKQhNqELD4Tw6sXjBW/8M=;
        b=XbJ7L3sL6QVtE4Ycqu5gAR+Li1zJ5t18af7oADsIB9QA+XXfL2SGLygi/fJEzyYt5h
         YuxlEu+EKOyB01N+yRKbZxxPVH3aBaSgCIBMjgvGIJBsBQ6uACo03XW4l+8Tyeau62be
         VgE8GidlOO5JXJvpjEYETI6eH1sMF1K02H/ujS2Ee58WvIKuK53QpXwiXJOElDwp5EbO
         7dHT1uJl6cF3O8vDJTB7Kt8RI0ONy1bAbM6lYk1ucBeIc7pclSDYpeP4/ORVm6xueXLY
         QZI3NBo2HE23fwFVvHhtpeeZiXXT/Ug31kqNqEcQbhtDCelwITHC8603+afL/HEYOQfT
         zrQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ToKAeI2JQi7vdsmaDuy6bvnKQhNqELD4Tw6sXjBW/8M=;
        b=smum43GfUPNKhZzIaezDZlak39232fbvvfyzmEYjJfIiPGGXsrr2eT439aG3kVcoNA
         SFlAlwrRfXbX7kBs7N7hP1gwbSCumVeNvEWLdFgMnO/KRq6MebD2rTZCkFT0RsgQx78Q
         +o3OSuqKqajNPR6kD9PtdZ8nd/yjt9aA1MYuMko2XeID+OkUcp+aDmKPKQ41XdO44N00
         0CVeAgisza99dFmzLmMiPnEoG8suLF7maXJPjf10VBP6bKCyjOXk7QWZLrE5HmXqXooB
         nSs6VlZDmfWUWDi5kpCtFPAW7m0bN6Gz1gxQJitYh/4ZqHl0qGfUnBxbtZlOFeFpR+ML
         aImA==
X-Gm-Message-State: AOAM533g/rFY5kbpF5THMcLNK9aoIQeuCgTe0R9a2ZG+R/R8mRcoS1nO
        PconT07deF0Kp1QYMPvWaFk=
X-Google-Smtp-Source: ABdhPJzfXysua39Ex9LTKEfJjtCzJ0l7qkpof+7Xt5+/7VlxH1dBVOhWK2uAOAbyMrpuaUak2sSiDA==
X-Received: by 2002:a17:906:848:: with SMTP id f8mr21893912ejd.198.1623144351279;
        Tue, 08 Jun 2021 02:25:51 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id x9sm639783ejc.37.2021.06.08.02.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 02:25:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 3/4] net: dsa: sja1105: make sure the retagging port is enabled for SJA1110
Date:   Tue,  8 Jun 2021 12:25:37 +0300
Message-Id: <20210608092538.3920217-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210608092538.3920217-1-olteanv@gmail.com>
References: <20210608092538.3920217-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1110 has an extra configuration in the General Parameters Table
through which the user can select the buffer reservation config.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: Patch is new.

 drivers/net/dsa/sja1105/sja1105_main.c        | 56 +++++++++++++++++++
 .../net/dsa/sja1105/sja1105_static_config.c   |  1 +
 .../net/dsa/sja1105/sja1105_static_config.h   |  1 +
 3 files changed, 58 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2b3b6c402b34..801cf47d9572 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -565,6 +565,60 @@ void sja1105_frame_memory_partitioning(struct sja1105_private *priv)
 	vl_fwd_params->partspc[0] = SJA1105_VL_FRAME_MEMORY;
 }
 
+/* SJA1110 TDMACONFIGIDX values:
+ *
+ *      | 100 Mbps ports |  1Gbps ports  | 2.5Gbps ports | Disabled ports
+ * -----+----------------+---------------+---------------+---------------
+ *   0  |   0, [5:10]    |     [1:2]     |     [3:4]     |     retag
+ *   1  |0, [5:10], retag|     [1:2]     |     [3:4]     |       -
+ *   2  |   0, [5:10]    |  [1:3], retag |       4       |       -
+ *   3  |   0, [5:10]    |[1:2], 4, retag|       3       |       -
+ *   4  |  0, 2, [5:10]  |    1, retag   |     [3:4]     |       -
+ *   5  |  0, 1, [5:10]  |    2, retag   |     [3:4]     |       -
+ *  14  |   0, [5:10]    | [1:4], retag  |       -       |       -
+ *  15  |     [5:10]     | [0:4], retag  |       -       |       -
+ */
+static void sja1110_select_tdmaconfigidx(struct sja1105_private *priv)
+{
+	struct sja1105_general_params_entry *general_params;
+	struct sja1105_table *table;
+	bool port_1_is_base_tx;
+	bool port_3_is_2500;
+	bool port_4_is_2500;
+	u64 tdmaconfigidx;
+
+	if (priv->info->device_id != SJA1110_DEVICE_ID)
+		return;
+
+	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
+	general_params = table->entries;
+
+	/* All the settings below are "as opposed to SGMII", which is the
+	 * other pinmuxing option.
+	 */
+	port_1_is_base_tx = priv->phy_mode[1] == PHY_INTERFACE_MODE_INTERNAL;
+	port_3_is_2500 = priv->phy_mode[3] == PHY_INTERFACE_MODE_2500BASEX;
+	port_4_is_2500 = priv->phy_mode[4] == PHY_INTERFACE_MODE_2500BASEX;
+
+	if (port_1_is_base_tx)
+		/* Retagging port will operate at 1 Gbps */
+		tdmaconfigidx = 5;
+	else if (port_3_is_2500 && port_4_is_2500)
+		/* Retagging port will operate at 100 Mbps */
+		tdmaconfigidx = 1;
+	else if (port_3_is_2500)
+		/* Retagging port will operate at 1 Gbps */
+		tdmaconfigidx = 3;
+	else if (port_4_is_2500)
+		/* Retagging port will operate at 1 Gbps */
+		tdmaconfigidx = 2;
+	else
+		/* Retagging port will operate at 1 Gbps */
+		tdmaconfigidx = 14;
+
+	general_params->tdmaconfigidx = tdmaconfigidx;
+}
+
 static int sja1105_init_general_params(struct sja1105_private *priv)
 {
 	struct sja1105_general_params_entry default_general_params = {
@@ -640,6 +694,8 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 	((struct sja1105_general_params_entry *)table->entries)[0] =
 				default_general_params;
 
+	sja1110_select_tdmaconfigidx(priv);
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index 4eba79bdedbf..eda571819d45 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -211,6 +211,7 @@ size_t sja1110_general_params_entry_packing(void *buf, void *entry_ptr,
 	sja1105_packing(buf, &entry->egrmirrpcp,   113, 111, size, op);
 	sja1105_packing(buf, &entry->egrmirrdei,   110, 110, size, op);
 	sja1105_packing(buf, &entry->replay_port,  109, 106, size, op);
+	sja1105_packing(buf, &entry->tdmaconfigidx, 70,  67, size, op);
 	sja1105_packing(buf, &entry->tte_en,        16,  16, size, op);
 	return size;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index d24227f78a72..9bef51791bff 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -216,6 +216,7 @@ struct sja1105_general_params_entry {
 	u64 replay_port;
 	/* SJA1110 only */
 	u64 tte_en;
+	u64 tdmaconfigidx;
 };
 
 struct sja1105_schedule_entry_points_entry {
-- 
2.25.1

