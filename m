Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5480780CF1
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfHDWj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:39:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39903 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfHDWj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:39:26 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so29309785wrt.6
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 15:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2V/4fJ7kErBLz7uKgoT4938N5LjTn8+30Jx32/BdhZo=;
        b=K9UUIFpNSW6ehIhasfl9vDiGIeILAcBhVrVsG5P3NoESiQjuWY68HT92OizC8Q08In
         cmWAXc3+DJn5dqneJYxWocfyCcFAp4XELgRGwJ9DZ/cb2UfYPyXepXdc+RWXwbTPhdI3
         zEjs0uKaIQC9t+voYzqGnsaZC6EAFmP4ANBTfg6zIO3PpnyqfC/h+b9R0gAcNIe43jSE
         Y0hH2qlErorEMy/XAT+vldHlsnYDPPT+nBM6s51HPB/dKldEAegGLV/TlS7oz8kDR2uW
         uF108F5B2wnoutHjLmJeJp0i+aC67gHThd7XMEkVFWlYIozQ2XJqr0cOvjK1ByCa/V1/
         jy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2V/4fJ7kErBLz7uKgoT4938N5LjTn8+30Jx32/BdhZo=;
        b=rpZp1OOJOPEZuGplzLgjFKc0vNpqA6oN5+tznrkVcJSIEqNAMGmY5d/+xj6OfDbYXs
         AhQNdpu03SXHhKZm3t6wYlz+7Kg+v6p2KtlRHTrNjr4hPF4izQd59xMJSMioxUjLj8pP
         xYvtcnkR70ORJrnoPJWyJU+D7uLfiu/J8OPcUB+ahNC3D+/7qN8l00F4KoIEPXHAQ+p8
         FY5FGqruf05af77ON4wYRacLhO9EhGIePIzYSrc8jCTttV/n/oLXmijq2jfZGrNzUJYU
         qc3j+vSVE3xTjzhwEqzLr2fDrYLbabUaClK55m28MgRcHT8py8c5ieCortuJdzkqNF7B
         EGOw==
X-Gm-Message-State: APjAAAX/ty0XJsIb4ilc1LBWJTnvHaEsR9fiPlEBfxMN2PnneCp5wtKx
        reE9SQIU5VYJSgHhSVL8b0U=
X-Google-Smtp-Source: APXvYqwkOrDwM38dCU7T8x2UaOl6NG4s0MLOXIvBdkoP2fETx4bpKYxmQZ6VD2ReMsSRrdJJ92GMLA==
X-Received: by 2002:adf:f246:: with SMTP id b6mr37502722wrp.92.1564958363991;
        Sun, 04 Aug 2019 15:39:23 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id j33sm187795615wre.42.2019.08.04.15.39.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:39:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 2/5] net: dsa: sja1105: Use the LOCKEDS bit for SJA1105 E/T as well
Date:   Mon,  5 Aug 2019 01:38:45 +0300
Message-Id: <20190804223848.31676-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190804223848.31676-1-olteanv@gmail.com>
References: <20190804223848.31676-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks like the FDB dump taken from first-generation switches also
contains information on whether entries are static or not. So use that
instead of searching through the driver's tables.

Fixes: d763778224ea ("net: dsa: sja1105: Implement is_static for FDB entries on E/T")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c | 14 +++++++++++++-
 drivers/net/dsa/sja1105/sja1105_main.c           | 15 ---------------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 6bfb1696a6f2..9988c9d18567 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -277,6 +277,18 @@ sja1105et_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 			SJA1105ET_SIZE_L2_LOOKUP_ENTRY, op);
 }
 
+static size_t sja1105et_dyn_l2_lookup_entry_packing(void *buf, void *entry_ptr,
+						    enum packing_op op)
+{
+	struct sja1105_l2_lookup_entry *entry = entry_ptr;
+	u8 *cmd = buf + SJA1105ET_SIZE_L2_LOOKUP_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(cmd, &entry->lockeds, 28, 28, size, op);
+
+	return sja1105et_l2_lookup_entry_packing(buf, entry_ptr, op);
+}
+
 static void
 sja1105et_mgmt_route_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				 enum packing_op op)
@@ -477,7 +489,7 @@ sja1105et_general_params_entry_packing(void *buf, void *entry_ptr,
 /* SJA1105E/T: First generation */
 struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_L2_LOOKUP] = {
-		.entry_packing = sja1105et_l2_lookup_entry_packing,
+		.entry_packing = sja1105et_dyn_l2_lookup_entry_packing,
 		.cmd_packing = sja1105et_l2_lookup_cmd_packing,
 		.access = (OP_READ | OP_WRITE | OP_DEL),
 		.max_entry_count = SJA1105_MAX_L2_LOOKUP_COUNT,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index dc6ab834f0cc..fd036bf0a819 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1251,21 +1251,6 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 			continue;
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
-		/* On SJA1105 E/T, the switch doesn't implement the LOCKEDS
-		 * bit, so it doesn't tell us whether a FDB entry is static
-		 * or not.
-		 * But, of course, we can find out - we're the ones who added
-		 * it in the first place.
-		 */
-		if (priv->info->device_id == SJA1105E_DEVICE_ID ||
-		    priv->info->device_id == SJA1105T_DEVICE_ID) {
-			int match;
-
-			match = sja1105_find_static_fdb_entry(priv, port,
-							      &l2_lookup);
-			l2_lookup.lockeds = (match >= 0);
-		}
-
 		/* We need to hide the dsa_8021q VLANs from the user. */
 		if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
 			l2_lookup.vlanid = 0;
-- 
2.17.1

