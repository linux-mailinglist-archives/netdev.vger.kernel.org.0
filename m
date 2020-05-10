Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B741CCC64
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgEJQoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729135AbgEJQnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65010C061A0C;
        Sun, 10 May 2020 09:43:35 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g14so5031030wme.1;
        Sun, 10 May 2020 09:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lXWEF0lFPnL1sJpICuLXl9aEJQHRS6Q0fzltLMvwdoY=;
        b=B7/XkouHbjfzgAvLK9KSWHtt7VRkZX+xn8ksA2GsVNtHRFOxER/hKji4FRALeNtmUk
         S+ANfiuFu39D5VlV9M/LYGYZonu6oSzTfquObLUak/uAzYTbbwFh5AxCA0/02KEZBGBX
         eK3tEfexmivKKu2RZ56qfNNqh0uJZ7Opnvd0FaSWBeR43uDv6C704haBMd2wp0YfckUW
         hohfDMm79oZ3SpAlRZ8tr7BtEKd/+kz5/bcg+dLzHDS40BaFARcqr2rB3XdWAZ4XAiMF
         O+jDLCuzBtaPpB48nQiEQsJMpUNsBNFjPq8VGtGZyKduaWx7s2gfh1duoxktXgJA7zDB
         veoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lXWEF0lFPnL1sJpICuLXl9aEJQHRS6Q0fzltLMvwdoY=;
        b=qWhulhW+T/fIWFET3C+W+jITK6CHN37T6EwOIuDIV6lRDdeajYYu8aSba7BHS/N73o
         hn+ldzFoMnxGVQ1QuXur1MSBn5lY3tSMPWN05W7slpm3ZnfxYA2iTqJKJb+R9o2gXCDo
         1JqqXIeVAS+2d8VKf1DjLeU0a/VnI1x1UOMCCy0ROqJQeSh+JDW7Xl/iMk+lvLUS75wk
         Y07ukg3OzszQ6L8o4MjTbV/xw3u/kbbjGJwoueIHqYtW+NiIoSMrALNwWRCqyBQ1JSH0
         vn8CAjz2N6QrgbYUvtRDMQuIgPQscOj3EeqINwWsfWug+4e6IuKkqmW3h8bG8vbGMzQp
         VtYg==
X-Gm-Message-State: AGi0Pub3fYvqE7F8/e20N+NrEx0AlQSpB1THwPcCsAcbvw7mPIOGE4cE
        fjUMe2t1jk8P+h+OsDG0AgIbwrim
X-Google-Smtp-Source: APiQypL5koCU406/XPdaoQ1BgnuNSFMVAxEmuw1g3nKcs07AFys4cN3ppCIlO1Xh08f10wptXwSwcA==
X-Received: by 2002:a7b:ca54:: with SMTP id m20mr27694560wml.45.1589129013946;
        Sun, 10 May 2020 09:43:33 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/15] net: dsa: sja1105: save/restore VLANs using a delta commit method
Date:   Sun, 10 May 2020 19:42:45 +0300
Message-Id: <20200510164255.19322-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Managing the VLAN table that is present in hardware will become very
difficult once we add a third operating state
(best_effort_vlan_filtering). That is because correct cleanup (not too
little, not too much) becomes virtually impossible, when VLANs can be
added from the bridge layer, from dsa_8021q for basic tagging, for
cross-chip bridging, as well as retagging rules for sub-VLANs and
cross-chip sub-VLANs. So we need to rethink VLAN interaction with the
switch in a more scalable way.

In preparation for that, use the priv->expect_dsa_8021q boolean to
classify any VLAN request received through .port_vlan_add or
.port_vlan_del towards either one of 2 internal lists: bridge VLANs and
dsa_8021q VLANs.

Then, implement a central sja1105_build_vlan_table method that creates a
VLAN configuration from scratch based on the 2 lists of VLANs kept by
the driver, and based on the VLAN awareness state. Currently, if we are
VLAN-unaware, install the dsa_8021q VLANs, otherwise the bridge VLANs.

Then, implement a delta commit procedure that identifies which VLANs
from this new configuration are actually different from the config
previously committed to hardware. We apply the delta through the dynamic
configuration interface (we don't reset the switch). The result is that
the hardware should see the exact sequence of operations as before this
patch.

This also helps remove the "br" argument passed to
dsa_8021q_crosschip_bridge_join, which it was only using to figure out
whether it should commit the configuration back to us or not, based on
the VLAN awareness state of the bridge. We can simplify that, by always
allowing those VLANs inside of our dsa_8021q_vlans list, and committing
those to hardware when necessary.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |  10 +
 drivers/net/dsa/sja1105/sja1105_main.c | 453 ++++++++++++++++++-------
 include/linux/dsa/8021q.h              |  19 +-
 net/dsa/tag_8021q.c                    |  45 +--
 4 files changed, 359 insertions(+), 168 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 667056d0c819..c80f1999c694 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -178,6 +178,14 @@ struct sja1105_flow_block {
 	int num_virtual_links;
 };
 
+struct sja1105_bridge_vlan {
+	struct list_head list;
+	int port;
+	u16 vid;
+	bool pvid;
+	bool untagged;
+};
+
 enum sja1105_vlan_state {
 	SJA1105_VLAN_UNAWARE,
 	SJA1105_VLAN_FILTERING_FULL,
@@ -191,6 +199,8 @@ struct sja1105_private {
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
+	struct list_head dsa_8021q_vlans;
+	struct list_head bridge_vlans;
 	struct list_head crosschip_links;
 	struct sja1105_flow_block flow_block;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 78ec97850f96..8aa8bbcce6e3 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1717,82 +1717,6 @@ static int sja1105_pvid_apply(struct sja1105_private *priv, int port, u16 pvid)
 					   &mac[port], true);
 }
 
-static int sja1105_is_vlan_configured(struct sja1105_private *priv, u16 vid)
-{
-	struct sja1105_vlan_lookup_entry *vlan;
-	int count, i;
-
-	vlan = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entries;
-	count = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entry_count;
-
-	for (i = 0; i < count; i++)
-		if (vlan[i].vlanid == vid)
-			return i;
-
-	/* Return an invalid entry index if not found */
-	return -1;
-}
-
-static int sja1105_vlan_apply(struct sja1105_private *priv, int port, u16 vid,
-			      bool enabled, bool untagged)
-{
-	struct sja1105_vlan_lookup_entry *vlan;
-	struct sja1105_table *table;
-	bool keep = true;
-	int match, rc;
-
-	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
-
-	match = sja1105_is_vlan_configured(priv, vid);
-	if (match < 0) {
-		/* Can't delete a missing entry. */
-		if (!enabled)
-			return 0;
-		rc = sja1105_table_resize(table, table->entry_count + 1);
-		if (rc)
-			return rc;
-		match = table->entry_count - 1;
-	}
-	/* Assign pointer after the resize (it's new memory) */
-	vlan = table->entries;
-	vlan[match].vlanid = vid;
-	if (enabled) {
-		vlan[match].vlan_bc |= BIT(port);
-		vlan[match].vmemb_port |= BIT(port);
-	} else {
-		vlan[match].vlan_bc &= ~BIT(port);
-		vlan[match].vmemb_port &= ~BIT(port);
-	}
-	/* Also unset tag_port if removing this VLAN was requested,
-	 * just so we don't have a confusing bitmap (no practical purpose).
-	 */
-	if (untagged || !enabled)
-		vlan[match].tag_port &= ~BIT(port);
-	else
-		vlan[match].tag_port |= BIT(port);
-	/* If there's no port left as member of this VLAN,
-	 * it's time for it to go.
-	 */
-	if (!vlan[match].vmemb_port)
-		keep = false;
-
-	dev_dbg(priv->ds->dev,
-		"%s: port %d, vid %llu, broadcast domain 0x%llx, "
-		"port members 0x%llx, tagged ports 0x%llx, keep %d\n",
-		__func__, port, vlan[match].vlanid, vlan[match].vlan_bc,
-		vlan[match].vmemb_port, vlan[match].tag_port, keep);
-
-	rc = sja1105_dynamic_config_write(priv, BLK_IDX_VLAN_LOOKUP, vid,
-					  &vlan[match], keep);
-	if (rc < 0)
-		return rc;
-
-	if (!keep)
-		return sja1105_table_delete_entry(table, match);
-
-	return 0;
-}
-
 static int sja1105_crosschip_bridge_join(struct dsa_switch *ds,
 					 int tree_index, int sw_index,
 					 int other_port, struct net_device *br)
@@ -1813,7 +1737,7 @@ static int sja1105_crosschip_bridge_join(struct dsa_switch *ds,
 
 		other_priv->expect_dsa_8021q = true;
 		rc = dsa_8021q_crosschip_bridge_join(ds, port, other_ds,
-						     other_port, br,
+						     other_port,
 						     &priv->crosschip_links);
 		other_priv->expect_dsa_8021q = false;
 		if (rc)
@@ -1821,7 +1745,7 @@ static int sja1105_crosschip_bridge_join(struct dsa_switch *ds,
 
 		priv->expect_dsa_8021q = true;
 		rc = dsa_8021q_crosschip_bridge_join(other_ds, other_port, ds,
-						     port, br,
+						     port,
 						     &other_priv->crosschip_links);
 		priv->expect_dsa_8021q = false;
 		if (rc)
@@ -1852,35 +1776,16 @@ static void sja1105_crosschip_bridge_leave(struct dsa_switch *ds,
 
 		other_priv->expect_dsa_8021q = true;
 		dsa_8021q_crosschip_bridge_leave(ds, port, other_ds, other_port,
-						 br, &priv->crosschip_links);
+						 &priv->crosschip_links);
 		other_priv->expect_dsa_8021q = false;
 
 		priv->expect_dsa_8021q = true;
-		dsa_8021q_crosschip_bridge_leave(other_ds, other_port, ds,
-						 port, br,
+		dsa_8021q_crosschip_bridge_leave(other_ds, other_port, ds, port,
 						 &other_priv->crosschip_links);
 		priv->expect_dsa_8021q = false;
 	}
 }
 
-static int sja1105_replay_crosschip_vlans(struct dsa_switch *ds, bool enabled)
-{
-	struct sja1105_private *priv = ds->priv;
-	struct dsa_8021q_crosschip_link *c;
-	int rc;
-
-	list_for_each_entry(c, &priv->crosschip_links, list) {
-		priv->expect_dsa_8021q = true;
-		rc = dsa_8021q_crosschip_link_apply(ds, c->port, c->other_ds,
-						    c->other_port, enabled);
-		priv->expect_dsa_8021q = false;
-		if (rc)
-			break;
-	}
-
-	return rc;
-}
-
 static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
 {
 	struct sja1105_private *priv = ds->priv;
@@ -1896,11 +1801,6 @@ static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
 			return rc;
 		}
 	}
-	rc = sja1105_replay_crosschip_vlans(ds, enabled);
-	if (rc) {
-		dev_err(ds->dev, "Failed to replay crosschip VLANs: %d\n", rc);
-		return rc;
-	}
 
 	dev_info(ds->dev, "%s switch tagging\n",
 		 enabled ? "Enabled" : "Disabled");
@@ -1914,6 +1814,272 @@ sja1105_get_tag_protocol(struct dsa_switch *ds, int port,
 	return DSA_TAG_PROTO_SJA1105;
 }
 
+static int sja1105_is_vlan_configured(struct sja1105_private *priv, u16 vid)
+{
+	struct sja1105_vlan_lookup_entry *vlan;
+	int count, i;
+
+	vlan = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entries;
+	count = priv->static_config.tables[BLK_IDX_VLAN_LOOKUP].entry_count;
+
+	for (i = 0; i < count; i++)
+		if (vlan[i].vlanid == vid)
+			return i;
+
+	/* Return an invalid entry index if not found */
+	return -1;
+}
+
+static int sja1105_commit_vlans(struct sja1105_private *priv,
+				struct sja1105_vlan_lookup_entry *new_vlan)
+{
+	struct sja1105_vlan_lookup_entry *vlan;
+	struct sja1105_table *table;
+	int num_vlans = 0;
+	int rc, i, k = 0;
+
+	/* VLAN table */
+	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
+	vlan = table->entries;
+
+	for (i = 0; i < VLAN_N_VID; i++) {
+		int match = sja1105_is_vlan_configured(priv, i);
+
+		if (new_vlan[i].vlanid != VLAN_N_VID)
+			num_vlans++;
+
+		if (new_vlan[i].vlanid == VLAN_N_VID && match >= 0) {
+			/* Was there before, no longer is. Delete */
+			dev_dbg(priv->ds->dev, "Deleting VLAN %d\n", i);
+			rc = sja1105_dynamic_config_write(priv,
+							  BLK_IDX_VLAN_LOOKUP,
+							  i, &vlan[match], false);
+			if (rc < 0)
+				return rc;
+		} else if (new_vlan[i].vlanid != VLAN_N_VID) {
+			/* Nothing changed, don't do anything */
+			if (match >= 0 &&
+			    vlan[match].vlanid == new_vlan[i].vlanid &&
+			    vlan[match].tag_port == new_vlan[i].tag_port &&
+			    vlan[match].vlan_bc == new_vlan[i].vlan_bc &&
+			    vlan[match].vmemb_port == new_vlan[i].vmemb_port)
+				continue;
+			/* Update entry */
+			dev_dbg(priv->ds->dev, "Updating VLAN %d\n", i);
+			rc = sja1105_dynamic_config_write(priv,
+							  BLK_IDX_VLAN_LOOKUP,
+							  i, &new_vlan[i],
+							  true);
+			if (rc < 0)
+				return rc;
+		}
+	}
+
+	if (table->entry_count)
+		kfree(table->entries);
+
+	table->entries = kcalloc(num_vlans, table->ops->unpacked_entry_size,
+				 GFP_KERNEL);
+	if (!table->entries)
+		return -ENOMEM;
+
+	table->entry_count = num_vlans;
+	vlan = table->entries;
+
+	for (i = 0; i < VLAN_N_VID; i++) {
+		if (new_vlan[i].vlanid == VLAN_N_VID)
+			continue;
+		vlan[k++] = new_vlan[i];
+	}
+
+	return 0;
+}
+
+struct sja1105_crosschip_switch {
+	struct list_head list;
+	struct dsa_switch *other_ds;
+};
+
+static int sja1105_commit_pvid(struct sja1105_private *priv)
+{
+	struct sja1105_bridge_vlan *v;
+	struct list_head *vlan_list;
+	int rc = 0;
+
+	if (priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
+		vlan_list = &priv->bridge_vlans;
+	else
+		vlan_list = &priv->dsa_8021q_vlans;
+
+	list_for_each_entry(v, vlan_list, list) {
+		if (v->pvid) {
+			rc = sja1105_pvid_apply(priv, v->port, v->vid);
+			if (rc)
+				break;
+		}
+	}
+
+	return rc;
+}
+
+static int
+sja1105_build_bridge_vlans(struct sja1105_private *priv,
+			   struct sja1105_vlan_lookup_entry *new_vlan)
+{
+	struct sja1105_bridge_vlan *v;
+
+	if (priv->vlan_state == SJA1105_VLAN_UNAWARE)
+		return 0;
+
+	list_for_each_entry(v, &priv->bridge_vlans, list) {
+		int match = v->vid;
+
+		new_vlan[match].vlanid = v->vid;
+		new_vlan[match].vmemb_port |= BIT(v->port);
+		new_vlan[match].vlan_bc |= BIT(v->port);
+		if (!v->untagged)
+			new_vlan[match].tag_port |= BIT(v->port);
+	}
+
+	return 0;
+}
+
+static int
+sja1105_build_dsa_8021q_vlans(struct sja1105_private *priv,
+			      struct sja1105_vlan_lookup_entry *new_vlan)
+{
+	struct sja1105_bridge_vlan *v;
+
+	if (priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
+		return 0;
+
+	list_for_each_entry(v, &priv->dsa_8021q_vlans, list) {
+		int match = v->vid;
+
+		new_vlan[match].vlanid = v->vid;
+		new_vlan[match].vmemb_port |= BIT(v->port);
+		new_vlan[match].vlan_bc |= BIT(v->port);
+		if (!v->untagged)
+			new_vlan[match].tag_port |= BIT(v->port);
+	}
+
+	return 0;
+}
+
+static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify);
+
+static int sja1105_notify_crosschip_switches(struct sja1105_private *priv)
+{
+	struct sja1105_crosschip_switch *s, *pos;
+	struct list_head crosschip_switches;
+	struct dsa_8021q_crosschip_link *c;
+	int rc = 0;
+
+	INIT_LIST_HEAD(&crosschip_switches);
+
+	list_for_each_entry(c, &priv->crosschip_links, list) {
+		bool already_added = false;
+
+		list_for_each_entry(s, &crosschip_switches, list) {
+			if (s->other_ds == c->other_ds) {
+				already_added = true;
+				break;
+			}
+		}
+
+		if (already_added)
+			continue;
+
+		s = kzalloc(sizeof(*s), GFP_KERNEL);
+		if (!s) {
+			dev_err(priv->ds->dev, "Failed to allocate memory\n");
+			rc = -ENOMEM;
+			goto out;
+		}
+		s->other_ds = c->other_ds;
+		list_add(&s->list, &crosschip_switches);
+	}
+
+	list_for_each_entry(s, &crosschip_switches, list) {
+		struct sja1105_private *other_priv = s->other_ds->priv;
+
+		rc = sja1105_build_vlan_table(other_priv, false);
+		if (rc)
+			goto out;
+	}
+
+out:
+	list_for_each_entry_safe(s, pos, &crosschip_switches, list) {
+		list_del(&s->list);
+		kfree(s);
+	}
+
+	return rc;
+}
+
+static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
+{
+	struct sja1105_vlan_lookup_entry *new_vlan;
+	struct sja1105_table *table;
+	int rc;
+	int i;
+
+	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
+	new_vlan = kcalloc(VLAN_N_VID,
+			   table->ops->unpacked_entry_size, GFP_KERNEL);
+	if (!new_vlan)
+		return -ENOMEM;
+
+	for (i = 0; i < VLAN_N_VID; i++)
+		new_vlan[i].vlanid = VLAN_N_VID;
+
+	/* Bridge VLANs */
+	rc = sja1105_build_bridge_vlans(priv, new_vlan);
+	if (rc)
+		goto out;
+
+	/* VLANs necessary for dsa_8021q operation, given to us by tag_8021q.c:
+	 * - RX VLANs
+	 * - TX VLANs
+	 * - Crosschip links
+	 */
+	rc = sja1105_build_dsa_8021q_vlans(priv, new_vlan);
+	if (rc)
+		goto out;
+
+	rc = sja1105_commit_vlans(priv, new_vlan);
+	if (rc)
+		goto out;
+
+	rc = sja1105_commit_pvid(priv);
+	if (rc)
+		goto out;
+
+	if (notify) {
+		rc = sja1105_notify_crosschip_switches(priv);
+		if (rc)
+			goto out;
+	}
+
+out:
+	kfree(new_vlan);
+
+	return rc;
+}
+
+/* Select the list to which we should add this VLAN. */
+static struct list_head *sja1105_classify_vlan(struct sja1105_private *priv,
+					       u16 vid)
+{
+	if (priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
+		return &priv->bridge_vlans;
+
+	if (priv->expect_dsa_8021q)
+		return &priv->dsa_8021q_vlans;
+
+	return &priv->bridge_vlans;
+}
+
 static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
 				const struct switchdev_obj_port_vlan *vlan)
 {
@@ -2034,45 +2200,80 @@ static void sja1105_vlan_add(struct dsa_switch *ds, int port,
 			     const struct switchdev_obj_port_vlan *vlan)
 {
 	struct sja1105_private *priv = ds->priv;
+	bool vlan_table_changed = false;
 	u16 vid;
 	int rc;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		rc = sja1105_vlan_apply(priv, port, vid, true, vlan->flags &
-					BRIDGE_VLAN_INFO_UNTAGGED);
-		if (rc < 0) {
-			dev_err(ds->dev, "Failed to add VLAN %d to port %d: %d\n",
-				vid, port, rc);
-			return;
-		}
-		if (vlan->flags & BRIDGE_VLAN_INFO_PVID) {
-			rc = sja1105_pvid_apply(ds->priv, port, vid);
-			if (rc < 0) {
-				dev_err(ds->dev, "Failed to set pvid %d on port %d: %d\n",
-					vid, port, rc);
-				return;
+		bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+		bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+		struct sja1105_bridge_vlan *v;
+		struct list_head *vlan_list;
+		bool already_added = false;
+
+		vlan_list = sja1105_classify_vlan(priv, vid);
+
+		list_for_each_entry(v, vlan_list, list) {
+			if (v->port == port && v->vid == vid &&
+			    v->untagged == untagged && v->pvid == pvid) {
+				already_added = true;
+				break;
 			}
 		}
+
+		if (already_added)
+			continue;
+
+		v = kzalloc(sizeof(*v), GFP_KERNEL);
+		if (!v) {
+			dev_err(ds->dev, "Out of memory while storing VLAN\n");
+			return;
+		}
+
+		v->port = port;
+		v->vid = vid;
+		v->untagged = untagged;
+		v->pvid = pvid;
+		list_add(&v->list, vlan_list);
+
+		vlan_table_changed = true;
 	}
+
+	if (!vlan_table_changed)
+		return;
+
+	rc = sja1105_build_vlan_table(priv, true);
+	if (rc)
+		dev_err(ds->dev, "Failed to build VLAN table: %d\n", rc);
 }
 
 static int sja1105_vlan_del(struct dsa_switch *ds, int port,
 			    const struct switchdev_obj_port_vlan *vlan)
 {
 	struct sja1105_private *priv = ds->priv;
+	bool vlan_table_changed = false;
 	u16 vid;
-	int rc;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		rc = sja1105_vlan_apply(priv, port, vid, false, vlan->flags &
-					BRIDGE_VLAN_INFO_UNTAGGED);
-		if (rc < 0) {
-			dev_err(ds->dev, "Failed to remove VLAN %d from port %d: %d\n",
-				vid, port, rc);
-			return rc;
+		struct sja1105_bridge_vlan *v, *n;
+		struct list_head *vlan_list;
+
+		vlan_list = sja1105_classify_vlan(priv, vid);
+
+		list_for_each_entry_safe(v, n, vlan_list, list) {
+			if (v->port == port && v->vid == vid) {
+				list_del(&v->list);
+				kfree(v);
+				vlan_table_changed = true;
+				break;
+			}
 		}
 	}
-	return 0;
+
+	if (!vlan_table_changed)
+		return 0;
+
+	return sja1105_build_vlan_table(priv, true);
 }
 
 /* The programming model for the SJA1105 switch is "all-at-once" via static
@@ -2606,6 +2807,8 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->mgmt_lock);
 
 	INIT_LIST_HEAD(&priv->crosschip_links);
+	INIT_LIST_HEAD(&priv->bridge_vlans);
+	INIT_LIST_HEAD(&priv->dsa_8021q_vlans);
 
 	sja1105_tas_setup(ds);
 	sja1105_flower_setup(ds);
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index ebc245ff838a..404bd2cce642 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -25,18 +25,14 @@ struct dsa_8021q_crosschip_link {
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
 				 bool enabled);
 
-int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
-				   struct dsa_switch *other_ds,
-				   int other_port, bool enabled);
-
 int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
 				    struct dsa_switch *other_ds,
-				    int other_port, struct net_device *br,
+				    int other_port,
 				    struct list_head *crosschip_links);
 
 int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
 				     struct dsa_switch *other_ds,
-				     int other_port, struct net_device *br,
+				     int other_port,
 				     struct list_head *crosschip_links);
 
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
@@ -60,16 +56,9 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
 	return 0;
 }
 
-int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
-				   struct dsa_switch *other_ds,
-				   int other_port, bool enabled)
-{
-	return 0;
-}
-
 int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
 				    struct dsa_switch *other_ds,
-				    int other_port, struct net_device *br,
+				    int other_port,
 				    struct list_head *crosschip_links)
 {
 	return 0;
@@ -77,7 +66,7 @@ int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
 
 int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
 				     struct dsa_switch *other_ds,
-				     int other_port, struct net_device *br,
+				     int other_port,
 				     struct list_head *crosschip_links)
 {
 	return 0;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 4774ecd1f8fc..3236fbbf85b9 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -296,9 +296,9 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 }
 EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
 
-int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
-				   struct dsa_switch *other_ds,
-				   int other_port, bool enabled)
+static int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
+					  struct dsa_switch *other_ds,
+					  int other_port, bool enabled)
 {
 	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
 
@@ -308,7 +308,6 @@ int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
 	return dsa_8021q_vid_apply(other_ds, other_port, rx_vid,
 				   BRIDGE_VLAN_INFO_UNTAGGED, enabled);
 }
-EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_link_apply);
 
 static int dsa_8021q_crosschip_link_add(struct dsa_switch *ds, int port,
 					struct dsa_switch *other_ds,
@@ -369,7 +368,7 @@ static void dsa_8021q_crosschip_link_del(struct dsa_switch *ds,
  */
 int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
 				    struct dsa_switch *other_ds,
-				    int other_port, struct net_device *br,
+				    int other_port,
 				    struct list_head *crosschip_links)
 {
 	/* @other_upstream is how @other_ds reaches us. If we are part
@@ -385,12 +384,10 @@ int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
 	if (rc)
 		return rc;
 
-	if (!br_vlan_enabled(br)) {
-		rc = dsa_8021q_crosschip_link_apply(ds, port, other_ds,
-						    other_port, true);
-		if (rc)
-			return rc;
-	}
+	rc = dsa_8021q_crosschip_link_apply(ds, port, other_ds,
+					    other_port, true);
+	if (rc)
+		return rc;
 
 	rc = dsa_8021q_crosschip_link_add(ds, port, other_ds,
 					  other_upstream,
@@ -398,20 +395,14 @@ int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
 	if (rc)
 		return rc;
 
-	if (!br_vlan_enabled(br)) {
-		rc = dsa_8021q_crosschip_link_apply(ds, port, other_ds,
-						    other_upstream, true);
-		if (rc)
-			return rc;
-	}
-
-	return 0;
+	return dsa_8021q_crosschip_link_apply(ds, port, other_ds,
+					      other_upstream, true);
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_bridge_join);
 
 int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
 				     struct dsa_switch *other_ds,
-				     int other_port, struct net_device *br,
+				     int other_port,
 				     struct list_head *crosschip_links)
 {
 	int other_upstream = dsa_upstream_port(other_ds, other_port);
@@ -431,14 +422,12 @@ int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
 			if (keep)
 				continue;
 
-			if (!br_vlan_enabled(br)) {
-				rc = dsa_8021q_crosschip_link_apply(ds, port,
-								    other_ds,
-								    other_port,
-								    false);
-				if (rc)
-					return rc;
-			}
+			rc = dsa_8021q_crosschip_link_apply(ds, port,
+							    other_ds,
+							    other_port,
+							    false);
+			if (rc)
+				return rc;
 		}
 	}
 
-- 
2.17.1

