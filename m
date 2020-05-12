Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5FA1CFC0E
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730975AbgELRV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730366AbgELRUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:20:50 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D217DC061A0C;
        Tue, 12 May 2020 10:20:48 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y24so24432602wma.4;
        Tue, 12 May 2020 10:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YTQRQXPmLJpZRnFTd2BFC4XaesOJF0QpFiy/VbePCOQ=;
        b=N8yrxXEX+fKMW2bsHqepE1RpjVkQNZQbjvXduTDvZrq2KRuQvSdbebB0AQ4Xi9m4g8
         9bu7ch+jYOTeZ+pGtuFwYXtsOVPYjmII1eXVsa3rXp5eYCWQprp3v4PskPGuEMQo8kMJ
         RcriabGw2Ctid+EbE8I2gLoO0hf2TgpN8s5I+8+3NfIvntZLTgjl30LhtFfVRNFguGUL
         BHZ4bnFIL0PKfisVPzbi+/TiXIyID65mqrJet8K2ECL8s+s6Ze877l3EL5CndQVbRWw6
         aEcxFW6IgGJmn28MRuFaojVmbcn9mU8V2EFQgpLIaWSs8UY3wZ4VCZACw+bgZRC71jF9
         346A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YTQRQXPmLJpZRnFTd2BFC4XaesOJF0QpFiy/VbePCOQ=;
        b=Evpl3cS/1pwhwFoUn7eqljgR4p+W/gtPwbea9fxqu0rcHG43j0GN88ymdot+/3USal
         664SI0y6UP2WPtKbUQ0AfKBxrj8efc9zKmHRUA2jaLpLDkg0g2UQihrtNNmiI5QMglXS
         r7cjdLGnEp23DgFFCFWnPI4YMvpeHaJtZu+00kmdOsaCjiUWs0kresmFLG/Px+6/vidh
         jmil9IU3zWZlCCXGlj9owb3757m05YmlTMDx7CruaR4McA9rik3+BFAc4oqmARxVqXpb
         eRkGqCea/raBaSuZKUtSOnnNXNk7FS8sXUwtfWcnNVob9JQHfuUfVPDE9pxqhYJebQhb
         ce3A==
X-Gm-Message-State: AGi0PuYIj1hObIxmE1/YfJq0hPCTbp01VZWZSm5pad4tDQla9Ij8RuCN
        5svLtQfymUx2XilOaJiohqs=
X-Google-Smtp-Source: APiQypKASE1iZYqexikV0AgtsS/7QAmtfB/d0Brn+1rRruYZIZfA4awLZ/OMgfYf1OrYzCr//tlUKA==
X-Received: by 2002:a1c:ed0b:: with SMTP id l11mr40539443wmh.31.1589304047522;
        Tue, 12 May 2020 10:20:47 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id a15sm23999743wrw.56.2020.05.12.10.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:20:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 03/15] net: dsa: sja1105: keep the VLAN awareness state in a driver variable
Date:   Tue, 12 May 2020 20:20:27 +0300
Message-Id: <20200512172039.14136-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512172039.14136-1-olteanv@gmail.com>
References: <20200512172039.14136-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Soon we'll add a third operating mode to the driver. Introduce a
vlan_state to make things more easy to manage, and use it where
applicable.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
Remove sja1105_can_use_vlan_as_tags.

Changes in v2:
Be much more thorough, and make sure that things like virtual links and
FDB operations still work properly.

 drivers/net/dsa/sja1105/sja1105.h      |  6 ++++++
 drivers/net/dsa/sja1105/sja1105_main.c | 18 +++++++++++++-----
 drivers/net/dsa/sja1105/sja1105_vl.c   | 24 ++++++++++++++----------
 3 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index a64ace07b89f..5b2b275d01a7 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -178,6 +178,11 @@ struct sja1105_flow_block {
 	int num_virtual_links;
 };
 
+enum sja1105_vlan_state {
+	SJA1105_VLAN_UNAWARE,
+	SJA1105_VLAN_FILTERING_FULL,
+};
+
 struct sja1105_private {
 	struct sja1105_static_config static_config;
 	bool rgmii_rx_delay[SJA1105_NUM_PORTS];
@@ -193,6 +198,7 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
+	enum sja1105_vlan_state vlan_state;
 	struct sja1105_tagger_data tagger_data;
 	struct sja1105_ptp_data ptp_data;
 	struct sja1105_tas_data tas_data;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d5de9305df25..e7b675909288 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1303,7 +1303,7 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	if (dsa_port_is_vlan_filtering(dsa_to_port(ds, port))) {
+	if (priv->vlan_state != SJA1105_VLAN_UNAWARE) {
 		l2_lookup.mask_vlanid = VLAN_VID_MASK;
 		l2_lookup.mask_iotag = BIT(0);
 	} else {
@@ -1366,7 +1366,7 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 	l2_lookup.vlanid = vid;
 	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
-	if (dsa_port_is_vlan_filtering(dsa_to_port(ds, port))) {
+	if (priv->vlan_state != SJA1105_VLAN_UNAWARE) {
 		l2_lookup.mask_vlanid = VLAN_VID_MASK;
 		l2_lookup.mask_iotag = BIT(0);
 	} else {
@@ -1412,7 +1412,7 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 	 * for what gets printed in 'bridge fdb show'.  In the case of zero,
 	 * no VID gets printed at all.
 	 */
-	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
+	if (priv->vlan_state != SJA1105_VLAN_FILTERING_FULL)
 		vid = 0;
 
 	return priv->info->fdb_add_cmd(ds, port, addr, vid);
@@ -1423,7 +1423,7 @@ static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 
-	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
+	if (priv->vlan_state != SJA1105_VLAN_FILTERING_FULL)
 		vid = 0;
 
 	return priv->info->fdb_del_cmd(ds, port, addr, vid);
@@ -1462,7 +1462,7 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
 		/* We need to hide the dsa_8021q VLANs from the user. */
-		if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
+		if (priv->vlan_state == SJA1105_VLAN_UNAWARE)
 			l2_lookup.vlanid = 0;
 		cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
 	}
@@ -1917,6 +1917,7 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_private *priv = ds->priv;
+	enum sja1105_vlan_state state;
 	struct sja1105_table *table;
 	struct sja1105_rule *rule;
 	u16 tpid, tpid2;
@@ -1940,6 +1941,13 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 		tpid2 = ETH_P_SJA1105;
 	}
 
+	if (!enabled)
+		state = SJA1105_VLAN_UNAWARE;
+	else
+		state = SJA1105_VLAN_FILTERING_FULL;
+
+	priv->vlan_state = state;
+
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
 	/* EtherType used to identify inner tagged (C-tag) VLAN traffic */
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index aa9b0b92f437..312401995b54 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -353,14 +353,14 @@ int sja1105_vl_redirect(struct sja1105_private *priv, int port,
 	struct sja1105_rule *rule = sja1105_rule_find(priv, cookie);
 	int rc;
 
-	if (dsa_port_is_vlan_filtering(dsa_to_port(priv->ds, port)) &&
-	    key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+	if (priv->vlan_state == SJA1105_VLAN_UNAWARE &&
+	    key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Can only redirect based on {DMAC, VID, PCP}");
+				   "Can only redirect based on DMAC");
 		return -EOPNOTSUPP;
-	} else if (key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
+	} else if (key->type != SJA1105_KEY_VLAN_AWARE_VL) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Can only redirect based on DMAC");
+				   "Can only redirect based on {DMAC, VID, PCP}");
 		return -EOPNOTSUPP;
 	}
 
@@ -602,14 +602,18 @@ int sja1105_vl_gate(struct sja1105_private *priv, int port,
 		return -ERANGE;
 	}
 
-	if (dsa_port_is_vlan_filtering(dsa_to_port(priv->ds, port)) &&
-	    key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+	if (priv->vlan_state == SJA1105_VLAN_UNAWARE &&
+	    key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
+		dev_err(priv->ds->dev, "1: vlan state %d key type %d\n",
+			priv->vlan_state, key->type);
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Can only gate based on {DMAC, VID, PCP}");
+				   "Can only gate based on DMAC");
 		return -EOPNOTSUPP;
-	} else if (key->type != SJA1105_KEY_VLAN_UNAWARE_VL) {
+	} else if (key->type != SJA1105_KEY_VLAN_AWARE_VL) {
+		dev_err(priv->ds->dev, "2: vlan state %d key type %d\n",
+			priv->vlan_state, key->type);
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Can only gate based on DMAC");
+				   "Can only gate based on {DMAC, VID, PCP}");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.17.1

