Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFDB21CDC28
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbgEKNxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730296AbgEKNxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:53:50 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A816BC061A0E;
        Mon, 11 May 2020 06:53:49 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d207so3995061wmd.0;
        Mon, 11 May 2020 06:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jWeisnAchFAnOeKYySeKMncuDFWvmiEMcR60xQYmWBs=;
        b=hjWnncy0wgRMF6+NKeeqdYBTtuAWJcNKgtjF7ndwYK2fqDypTsYg8LH14L9fg78Gu9
         K+8bZOk/mXWbvSCmAGfDMGGvd1+zdFgus+L8FxcXgq1WqwE6D3LaOqFuoxplnl9S5Rul
         W5GSgb8EZSmam+a0+uKSSlzMDdwGPQ41XyukhHoSUu4BLRk9EVa8wTLLsrgiq3gaMOiB
         EQ8HglDPrtaIw3wEm9uHEkpjZDlFjBUn33OpesuCcZNGgzmhvGpzjUUSR1P8Ghaf9Cs5
         9Lf4wCDD8h2uLlt2LJH4t22MYoCWoBqf5N1ecAygRdhyP7x3DPMCZml2gwMnk3JeHnKH
         xLSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jWeisnAchFAnOeKYySeKMncuDFWvmiEMcR60xQYmWBs=;
        b=gsqp/CquEoY9rplVdKJp6vucAFBEsoxotH2bYvh7h3F8sNUsViVg3wNbzDEtJu5KZC
         GYd5rj62WwXb/VBRUfNkxUdpJsZXhJfKNiTJTGvZZTNgFuRkRmRBCHueth4vaxYpK+qM
         YGpeSsIxe8daeH1/6gC7aw7kagcFRppR22Auwibd1iylPp+RopWfD7PA6fn4k5MSM7Vj
         NF5TL/ASquwDtEjvfaRhoFC/iK3tAsmhEziKPbJ/uzTjBTt3XTOTqdrQNNMdDAGq2E+8
         wPJ4GIvtpolrWi2vhc7d1A5/ufa3abR/Sc1pIClJmmz7YwrIdCQwkl6Ca69q58i+R6L1
         ttSw==
X-Gm-Message-State: AGi0PuYxEYQ1vfsms9IL5PHDEe4PMHblY/OeUFXK4fGXgbXfqWUaRora
        /3pVo4QgITT+iOqmRfIQUwU=
X-Google-Smtp-Source: APiQypJl7pkOiCG4zHwhIebkO+eSiTPvk72jGvd5s+dSPCk52a53eJd78xpxhdi9+98qYpD8cm8aKA==
X-Received: by 2002:a1c:1b44:: with SMTP id b65mr681883wmb.181.1589205228377;
        Mon, 11 May 2020 06:53:48 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 2sm17596413wre.25.2020.05.11.06.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 06:53:47 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 03/15] net: dsa: sja1105: keep the VLAN awareness state in a driver variable
Date:   Mon, 11 May 2020 16:53:26 +0300
Message-Id: <20200511135338.20263-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511135338.20263-1-olteanv@gmail.com>
References: <20200511135338.20263-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Soon we'll add a third operating mode to the driver. Introduce a
vlan_state to make things more easy to manage, and use it where
applicable.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Be much more thorough, and make sure that things like virtual links and
FDB operations still work properly.

 drivers/net/dsa/sja1105/sja1105.h      |  6 ++++++
 drivers/net/dsa/sja1105/sja1105_main.c | 26 +++++++++++++++++++++-----
 drivers/net/dsa/sja1105/sja1105_vl.c   | 24 ++++++++++++++----------
 include/linux/dsa/sja1105.h            |  2 ++
 net/dsa/tag_sja1105.c                  |  2 +-
 5 files changed, 44 insertions(+), 16 deletions(-)

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
index d5de9305df25..72e12c02594d 100644
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
@@ -1985,6 +1993,14 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	return sja1105_setup_8021q_tagging(ds, !enabled);
 }
 
+bool sja1105_can_use_vlan_as_tags(struct dsa_switch *ds)
+{
+	struct sja1105_private *priv = ds->priv;
+
+	return priv->vlan_state != SJA1105_VLAN_FILTERING_FULL;
+}
+EXPORT_SYMBOL_GPL(sja1105_can_use_vlan_as_tags);
+
 static void sja1105_vlan_add(struct dsa_switch *ds, int port,
 			     const struct switchdev_obj_port_vlan *vlan)
 {
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
 
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index fa5735c353cd..136481ce3c6f 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -61,4 +61,6 @@ struct sja1105_port {
 	bool hwts_tx_en;
 };
 
+bool sja1105_can_use_vlan_as_tags(struct dsa_switch *ds);
+
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index d553bf36bd41..5368cd34bcf4 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -74,7 +74,7 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
  */
 static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
 {
-	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr))
+	if (sja1105_can_use_vlan_as_tags(dev->dsa_ptr->ds))
 		return true;
 	if (sja1105_is_link_local(skb))
 		return true;
-- 
2.17.1

