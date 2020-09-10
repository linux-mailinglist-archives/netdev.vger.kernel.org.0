Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2522A264A85
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgIJRB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgIJQ5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:57:48 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD43C0617BF
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:49:07 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e23so9736742eja.3
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 09:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GXc3+6+WHMc5xyTsGtGt4IDVTsn8afXPGAf2Mf9SC0U=;
        b=JlkT5HBYYpuTHq1G7yT8ui1yTIhw+snpq2Fyzr58ANXL+zWY6F/GRZN9i5m+pLTaYr
         2G484exEpgK09uYU/RDKEc4pJuQuaMkslMSDbaeMCB+B0MznD5etb8zu+2kEmRs/XLHQ
         wA8zPczgK07jiJFFJJ9d1DCehm8a37dZ8x6O/9JhBATuUJwBqSWhqM0Jee79s1sxZzDB
         k7/gM6ij2NouTRXnbKPb9Gca8+YgwlHK47Mcoj0ZEWBOgoDR8CH+2E20uu0rG9/Pht7R
         nx4S7v6aqLVpurZCvhJWEVOTLD892cqxAdtb6G9Xn/JRyxH5CTDlQZGn6VPY/vxHTbpX
         Bp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GXc3+6+WHMc5xyTsGtGt4IDVTsn8afXPGAf2Mf9SC0U=;
        b=roINjW8lBLiBSN9N7cWv5YPEIeXHHf6Xc6WIkx7QSbOKu+/NNYGYJZJY0MjSSlPtKT
         FpX4B9zW8kv19nIthm49M93rlk/VXbx3k5KHjKp3n5M0nUNBayD5y6mSPFgBU7TNnTaJ
         boIMJph3BGkrF3Ym3yBQ9P40xfuJB+ipCiSAPPDuld8/hKt9Q7Y9cNHSW5B3ksP2UHq6
         SY8AFtab0LyAnARKFgHjZkf49dbb3Yrfkl0ujO8fCBdVIAr8+brl/dTQyIdoTgrKj21l
         1N9OUHMi/PgW3q8NvXKxh/LtZFEHHu7dLgl+ia6m8Gntc5sX+VUY4z5TXXZD9RJ25P2m
         pesg==
X-Gm-Message-State: AOAM531XD0JmMjwS4FLHWkB/cxOorbCW0TzISdGM2GDhNBtF85Bc/wVt
        ql55HDSkBPDZwtUjfiJzbQg=
X-Google-Smtp-Source: ABdhPJwA/34VbEx6OBju37mRSrtly8U62u7GUkKPY6KtHcQkS0yxYuVVzTQdX5PTuc8QUGfz2NNopg==
X-Received: by 2002:a17:906:ae45:: with SMTP id lf5mr9465896ejb.339.1599756545507;
        Thu, 10 Sep 2020 09:49:05 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id o93sm8108024edd.75.2020.09.10.09.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:49:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 3/4] net: dsa: tag_8021q: add a context structure
Date:   Thu, 10 Sep 2020 19:48:56 +0300
Message-Id: <20200910164857.1221202-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910164857.1221202-1-olteanv@gmail.com>
References: <20200910164857.1221202-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

While working on another tag_8021q driver implementation, some things
became apparent:

- It is not mandatory for a DSA driver to offload the tag_8021q VLANs by
  using the VLAN table per se. For example, it can add custom TCAM rules
  that simply encapsulate RX traffic, and redirect & decapsulate rules
  for TX traffic. For such a driver, it makes no sense to receive the
  tag_8021q configuration through the same callback as it receives the
  VLAN configuration from the bridge and the 8021q modules.

- Currently, sja1105 (the only tag_8021q user) sets a
  priv->expect_dsa_8021q variable to distinguish between the bridge
  calling, and tag_8021q calling. That can be improved, to say the
  least.

- The crosschip bridging operations are, in fact, stateful already. The
  list of crosschip_links must be kept by the caller and passed to the
  relevant tag_8021q functions.

So it would be nice if the tag_8021q configuration was more
self-contained. This patch attempts to do that.

Create a struct dsa_8021q_context which encapsulates a struct
dsa_switch, and has 2 function pointers for adding and deleting a VLAN.
These will replace the previous channel to the driver, which was through
the .port_vlan_add and .port_vlan_del callbacks of dsa_switch_ops.

Also put the list of crosschip_links into this dsa_8021q_context.
Drivers that don't support cross-chip bridging can simply omit to
initialize this list, as long as they dont call any cross-chip function.

The sja1105_vlan_add and sja1105_vlan_del functions are refactored into
a smaller sja1105_vlan_add_one, which now has 2 entry points:
- sja1105_vlan_add, from struct dsa_switch_ops
- sja1105_dsa_8021q_vlan_add, from the tag_8021q ops
But even this change is fairly trivial. It just reflects the fact that
for sja1105, the VLANs from these 2 channels end up in the same hardware
table. However that is not necessarily true in the general sense (and
that's the reason for making this change).

The rest of the patch is mostly plain refactoring of "ds" -> "ctx". The
dsa_8021q_context structure needs to be propagated because adding a VLAN
is now done through the ops function pointers inside of it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Improved commit message.
Avoided some useless and incorrect refactoring. This should be a more
trivial change now.

 drivers/net/dsa/sja1105/sja1105.h      |   3 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 213 +++++++++++++++----------
 include/linux/dsa/8021q.h              |  46 +++---
 net/dsa/tag_8021q.c                    | 127 ++++++++-------
 4 files changed, 216 insertions(+), 173 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index ba70b40a9a95..a93f580b558a 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -210,14 +210,13 @@ struct sja1105_private {
 	struct dsa_switch *ds;
 	struct list_head dsa_8021q_vlans;
 	struct list_head bridge_vlans;
-	struct list_head crosschip_links;
 	struct sja1105_flow_block flow_block;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
 	/* Serializes transmission of management frames so that
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
-	bool expect_dsa_8021q;
+	struct dsa_8021q_context *dsa_8021q_ctx;
 	enum sja1105_vlan_state vlan_state;
 	struct sja1105_cbs_entry *cbs;
 	struct sja1105_tagger_data tagger_data;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 508494390e81..967430e8ceb8 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1880,19 +1880,17 @@ static int sja1105_crosschip_bridge_join(struct dsa_switch *ds,
 		if (dsa_to_port(ds, port)->bridge_dev != br)
 			continue;
 
-		other_priv->expect_dsa_8021q = true;
-		rc = dsa_8021q_crosschip_bridge_join(ds, port, other_ds,
-						     other_port,
-						     &priv->crosschip_links);
-		other_priv->expect_dsa_8021q = false;
+		rc = dsa_8021q_crosschip_bridge_join(priv->dsa_8021q_ctx,
+						     port,
+						     other_priv->dsa_8021q_ctx,
+						     other_port);
 		if (rc)
 			return rc;
 
-		priv->expect_dsa_8021q = true;
-		rc = dsa_8021q_crosschip_bridge_join(other_ds, other_port, ds,
-						     port,
-						     &other_priv->crosschip_links);
-		priv->expect_dsa_8021q = false;
+		rc = dsa_8021q_crosschip_bridge_join(other_priv->dsa_8021q_ctx,
+						     other_port,
+						     priv->dsa_8021q_ctx,
+						     port);
 		if (rc)
 			return rc;
 	}
@@ -1919,15 +1917,13 @@ static void sja1105_crosschip_bridge_leave(struct dsa_switch *ds,
 		if (dsa_to_port(ds, port)->bridge_dev != br)
 			continue;
 
-		other_priv->expect_dsa_8021q = true;
-		dsa_8021q_crosschip_bridge_leave(ds, port, other_ds, other_port,
-						 &priv->crosschip_links);
-		other_priv->expect_dsa_8021q = false;
+		dsa_8021q_crosschip_bridge_leave(priv->dsa_8021q_ctx, port,
+						 other_priv->dsa_8021q_ctx,
+						 other_port);
 
-		priv->expect_dsa_8021q = true;
-		dsa_8021q_crosschip_bridge_leave(other_ds, other_port, ds, port,
-						 &other_priv->crosschip_links);
-		priv->expect_dsa_8021q = false;
+		dsa_8021q_crosschip_bridge_leave(other_priv->dsa_8021q_ctx,
+						 other_port,
+						 priv->dsa_8021q_ctx, port);
 	}
 }
 
@@ -1936,7 +1932,7 @@ static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
 	struct sja1105_private *priv = ds->priv;
 	int rc;
 
-	rc = dsa_8021q_setup(priv->ds, enabled);
+	rc = dsa_8021q_setup(priv->dsa_8021q_ctx, enabled);
 	if (rc)
 		return rc;
 
@@ -2142,12 +2138,12 @@ struct sja1105_crosschip_vlan {
 	bool untagged;
 	int port;
 	int other_port;
-	struct dsa_switch *other_ds;
+	struct dsa_8021q_context *other_ctx;
 };
 
 struct sja1105_crosschip_switch {
 	struct list_head list;
-	struct dsa_switch *other_ds;
+	struct dsa_8021q_context *other_ctx;
 };
 
 static int sja1105_commit_pvid(struct sja1105_private *priv)
@@ -2323,8 +2319,8 @@ sja1105_build_crosschip_subvlans(struct sja1105_private *priv,
 
 	INIT_LIST_HEAD(&crosschip_vlans);
 
-	list_for_each_entry(c, &priv->crosschip_links, list) {
-		struct sja1105_private *other_priv = c->other_ds->priv;
+	list_for_each_entry(c, &priv->dsa_8021q_ctx->crosschip_links, list) {
+		struct sja1105_private *other_priv = c->other_ctx->ds->priv;
 
 		if (other_priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
 			continue;
@@ -2334,7 +2330,7 @@ sja1105_build_crosschip_subvlans(struct sja1105_private *priv,
 		 */
 		if (!dsa_is_user_port(priv->ds, c->port))
 			continue;
-		if (!dsa_is_user_port(c->other_ds, c->other_port))
+		if (!dsa_is_user_port(c->other_ctx->ds, c->other_port))
 			continue;
 
 		/* Search for VLANs on the remote port */
@@ -2369,7 +2365,7 @@ sja1105_build_crosschip_subvlans(struct sja1105_private *priv,
 				    tmp->untagged == v->untagged &&
 				    tmp->port == c->port &&
 				    tmp->other_port == v->port &&
-				    tmp->other_ds == c->other_ds) {
+				    tmp->other_ctx == c->other_ctx) {
 					already_added = true;
 					break;
 				}
@@ -2387,14 +2383,14 @@ sja1105_build_crosschip_subvlans(struct sja1105_private *priv,
 			tmp->vid = v->vid;
 			tmp->port = c->port;
 			tmp->other_port = v->port;
-			tmp->other_ds = c->other_ds;
+			tmp->other_ctx = c->other_ctx;
 			tmp->untagged = v->untagged;
 			list_add(&tmp->list, &crosschip_vlans);
 		}
 	}
 
 	list_for_each_entry(tmp, &crosschip_vlans, list) {
-		struct sja1105_private *other_priv = tmp->other_ds->priv;
+		struct sja1105_private *other_priv = tmp->other_ctx->ds->priv;
 		int upstream = dsa_upstream_port(priv->ds, tmp->port);
 		int match, subvlan;
 		u16 rx_vid;
@@ -2411,7 +2407,7 @@ sja1105_build_crosschip_subvlans(struct sja1105_private *priv,
 			goto out;
 		}
 
-		rx_vid = dsa_8021q_rx_vid_subvlan(tmp->other_ds,
+		rx_vid = dsa_8021q_rx_vid_subvlan(tmp->other_ctx->ds,
 						  tmp->other_port,
 						  subvlan);
 
@@ -2486,11 +2482,11 @@ static int sja1105_notify_crosschip_switches(struct sja1105_private *priv)
 
 	INIT_LIST_HEAD(&crosschip_switches);
 
-	list_for_each_entry(c, &priv->crosschip_links, list) {
+	list_for_each_entry(c, &priv->dsa_8021q_ctx->crosschip_links, list) {
 		bool already_added = false;
 
 		list_for_each_entry(s, &crosschip_switches, list) {
-			if (s->other_ds == c->other_ds) {
+			if (s->other_ctx == c->other_ctx) {
 				already_added = true;
 				break;
 			}
@@ -2505,12 +2501,12 @@ static int sja1105_notify_crosschip_switches(struct sja1105_private *priv)
 			rc = -ENOMEM;
 			goto out;
 		}
-		s->other_ds = c->other_ds;
+		s->other_ctx = c->other_ctx;
 		list_add(&s->list, &crosschip_switches);
 	}
 
 	list_for_each_entry(s, &crosschip_switches, list) {
-		struct sja1105_private *other_priv = s->other_ds->priv;
+		struct sja1105_private *other_priv = s->other_ctx->ds->priv;
 
 		rc = sja1105_build_vlan_table(other_priv, false);
 		if (rc)
@@ -2611,16 +2607,6 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
 	return rc;
 }
 
-/* Select the list to which we should add this VLAN. */
-static struct list_head *sja1105_classify_vlan(struct sja1105_private *priv,
-					       u16 vid)
-{
-	if (priv->expect_dsa_8021q)
-		return &priv->dsa_8021q_vlans;
-
-	return &priv->bridge_vlans;
-}
-
 static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
 				const struct switchdev_obj_port_vlan *vlan)
 {
@@ -2635,7 +2621,7 @@ static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
 	 * configuration done by dsa_8021q.
 	 */
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		if (!priv->expect_dsa_8021q && vid_is_dsa_8021q(vid)) {
+		if (vid_is_dsa_8021q(vid)) {
 			dev_err(ds->dev, "Range 1024-3071 reserved for dsa_8021q operation\n");
 			return -EBUSY;
 		}
@@ -2755,6 +2741,54 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	return sja1105_setup_8021q_tagging(ds, want_tagging);
 }
 
+/* Returns number of VLANs added (0 or 1) on success,
+ * or a negative error code.
+ */
+static int sja1105_vlan_add_one(struct dsa_switch *ds, int port, u16 vid,
+				u16 flags, struct list_head *vlan_list)
+{
+	bool untagged = flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = flags & BRIDGE_VLAN_INFO_PVID;
+	struct sja1105_bridge_vlan *v;
+
+	list_for_each_entry(v, vlan_list, list)
+		if (v->port == port && v->vid == vid &&
+		    v->untagged == untagged && v->pvid == pvid)
+			/* Already added */
+			return 0;
+
+	v = kzalloc(sizeof(*v), GFP_KERNEL);
+	if (!v) {
+		dev_err(ds->dev, "Out of memory while storing VLAN\n");
+		return -ENOMEM;
+	}
+
+	v->port = port;
+	v->vid = vid;
+	v->untagged = untagged;
+	v->pvid = pvid;
+	list_add(&v->list, vlan_list);
+
+	return 1;
+}
+
+/* Returns number of VLANs deleted (0 or 1) */
+static int sja1105_vlan_del_one(struct dsa_switch *ds, int port, u16 vid,
+				struct list_head *vlan_list)
+{
+	struct sja1105_bridge_vlan *v, *n;
+
+	list_for_each_entry_safe(v, n, vlan_list, list) {
+		if (v->port == port && v->vid == vid) {
+			list_del(&v->list);
+			kfree(v);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 static void sja1105_vlan_add(struct dsa_switch *ds, int port,
 			     const struct switchdev_obj_port_vlan *vlan)
 {
@@ -2764,38 +2798,12 @@ static void sja1105_vlan_add(struct dsa_switch *ds, int port,
 	int rc;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
-		bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
-		struct sja1105_bridge_vlan *v;
-		struct list_head *vlan_list;
-		bool already_added = false;
-
-		vlan_list = sja1105_classify_vlan(priv, vid);
-
-		list_for_each_entry(v, vlan_list, list) {
-			if (v->port == port && v->vid == vid &&
-			    v->untagged == untagged && v->pvid == pvid) {
-				already_added = true;
-				break;
-			}
-		}
-
-		if (already_added)
-			continue;
-
-		v = kzalloc(sizeof(*v), GFP_KERNEL);
-		if (!v) {
-			dev_err(ds->dev, "Out of memory while storing VLAN\n");
+		rc = sja1105_vlan_add_one(ds, port, vid, vlan->flags,
+					  &priv->bridge_vlans);
+		if (rc < 0)
 			return;
-		}
-
-		v->port = port;
-		v->vid = vid;
-		v->untagged = untagged;
-		v->pvid = pvid;
-		list_add(&v->list, vlan_list);
-
-		vlan_table_changed = true;
+		if (rc > 0)
+			vlan_table_changed = true;
 	}
 
 	if (!vlan_table_changed)
@@ -2812,21 +2820,12 @@ static int sja1105_vlan_del(struct dsa_switch *ds, int port,
 	struct sja1105_private *priv = ds->priv;
 	bool vlan_table_changed = false;
 	u16 vid;
+	int rc;
 
 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		struct sja1105_bridge_vlan *v, *n;
-		struct list_head *vlan_list;
-
-		vlan_list = sja1105_classify_vlan(priv, vid);
-
-		list_for_each_entry_safe(v, n, vlan_list, list) {
-			if (v->port == port && v->vid == vid) {
-				list_del(&v->list);
-				kfree(v);
-				vlan_table_changed = true;
-				break;
-			}
-		}
+		rc = sja1105_vlan_del_one(ds, port, vid, &priv->bridge_vlans);
+		if (rc > 0)
+			vlan_table_changed = true;
 	}
 
 	if (!vlan_table_changed)
@@ -2835,6 +2834,36 @@ static int sja1105_vlan_del(struct dsa_switch *ds, int port,
 	return sja1105_build_vlan_table(priv, true);
 }
 
+static int sja1105_dsa_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
+				      u16 flags)
+{
+	struct sja1105_private *priv = ds->priv;
+	int rc;
+
+	rc = sja1105_vlan_add_one(ds, port, vid, flags, &priv->dsa_8021q_vlans);
+	if (rc <= 0)
+		return rc;
+
+	return sja1105_build_vlan_table(priv, true);
+}
+
+static int sja1105_dsa_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
+{
+	struct sja1105_private *priv = ds->priv;
+	int rc;
+
+	rc = sja1105_vlan_del_one(ds, port, vid, &priv->dsa_8021q_vlans);
+	if (!rc)
+		return 0;
+
+	return sja1105_build_vlan_table(priv, true);
+}
+
+static const struct dsa_8021q_ops sja1105_dsa_8021q_ops = {
+	.vlan_add	= sja1105_dsa_8021q_vlan_add,
+	.vlan_del	= sja1105_dsa_8021q_vlan_del,
+};
+
 static int sja1105_best_effort_vlan_filtering_get(struct sja1105_private *priv,
 						  bool *be_vlan)
 {
@@ -3497,7 +3526,15 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->mgmt_lock);
 
-	INIT_LIST_HEAD(&priv->crosschip_links);
+	priv->dsa_8021q_ctx = devm_kzalloc(dev, sizeof(*priv->dsa_8021q_ctx),
+					   GFP_KERNEL);
+	if (!priv->dsa_8021q_ctx)
+		return -ENOMEM;
+
+	priv->dsa_8021q_ctx->ops = &sja1105_dsa_8021q_ops;
+	priv->dsa_8021q_ctx->ds = ds;
+
+	INIT_LIST_HEAD(&priv->dsa_8021q_ctx->crosschip_links);
 	INIT_LIST_HEAD(&priv->bridge_vlans);
 	INIT_LIST_HEAD(&priv->dsa_8021q_vlans);
 
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 8586d8cdf956..2b003ae9fb38 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -12,30 +12,40 @@ struct dsa_switch;
 struct sk_buff;
 struct net_device;
 struct packet_type;
+struct dsa_8021q_context;
 
 struct dsa_8021q_crosschip_link {
 	struct list_head list;
 	int port;
-	struct dsa_switch *other_ds;
+	struct dsa_8021q_context *other_ctx;
 	int other_port;
 	refcount_t refcount;
 };
 
+struct dsa_8021q_ops {
+	int (*vlan_add)(struct dsa_switch *ds, int port, u16 vid, u16 flags);
+	int (*vlan_del)(struct dsa_switch *ds, int port, u16 vid);
+};
+
+struct dsa_8021q_context {
+	const struct dsa_8021q_ops *ops;
+	struct dsa_switch *ds;
+	struct list_head crosschip_links;
+};
+
 #define DSA_8021Q_N_SUBVLAN			8
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q)
 
-int dsa_8021q_setup(struct dsa_switch *ds, bool enabled);
+int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled);
 
-int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
-				    struct dsa_switch *other_ds,
-				    int other_port,
-				    struct list_head *crosschip_links);
+int dsa_8021q_crosschip_bridge_join(struct dsa_8021q_context *ctx, int port,
+				    struct dsa_8021q_context *other_ctx,
+				    int other_port);
 
-int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
-				     struct dsa_switch *other_ds,
-				     int other_port,
-				     struct list_head *crosschip_links);
+int dsa_8021q_crosschip_bridge_leave(struct dsa_8021q_context *ctx, int port,
+				     struct dsa_8021q_context *other_ctx,
+				     int other_port);
 
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci);
@@ -56,23 +66,21 @@ bool vid_is_dsa_8021q(u16 vid);
 
 #else
 
-int dsa_8021q_setup(struct dsa_switch *ds, bool enabled)
+int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled)
 {
 	return 0;
 }
 
-int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
-				    struct dsa_switch *other_ds,
-				    int other_port,
-				    struct list_head *crosschip_links)
+int dsa_8021q_crosschip_bridge_join(struct dsa_8021q_context *ctx, int port,
+				    struct dsa_8021q_context *other_ctx,
+				    int other_port)
 {
 	return 0;
 }
 
-int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
-				     struct dsa_switch *other_ds,
-				     int other_port,
-				     struct list_head *crosschip_links)
+int dsa_8021q_crosschip_bridge_leave(struct dsa_8021q_context *ctx, int port,
+				     struct dsa_8021q_context *other_ctx,
+				     int other_port)
 {
 	return 0;
 }
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index e38fdf5d4d03..5baeb0893950 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -146,15 +146,15 @@ EXPORT_SYMBOL_GPL(vid_is_dsa_8021q);
  * user explicitly configured this @vid through the bridge core, then the @vid
  * is installed again, but this time with the flags from the bridge layer.
  */
-static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
+static int dsa_8021q_vid_apply(struct dsa_8021q_context *ctx, int port, u16 vid,
 			       u16 flags, bool enabled)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_port *dp = dsa_to_port(ctx->ds, port);
 
 	if (enabled)
-		return dsa_port_vid_add(dp, vid, flags);
+		return ctx->ops->vlan_add(ctx->ds, dp->index, vid, flags);
 
-	return dsa_port_vid_del(dp, vid);
+	return ctx->ops->vlan_del(ctx->ds, dp->index, vid);
 }
 
 /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
@@ -209,17 +209,18 @@ static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
  * +-+-----+-+-----+-+-----+-+-----+-+    +-+-----+-+-----+-+-----+-+-----+-+
  *   swp0    swp1    swp2    swp3           swp0    swp1    swp2    swp3
  */
-static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
+static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
+				bool enabled)
 {
-	int upstream = dsa_upstream_port(ds, port);
-	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
-	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+	int upstream = dsa_upstream_port(ctx->ds, port);
+	u16 rx_vid = dsa_8021q_rx_vid(ctx->ds, port);
+	u16 tx_vid = dsa_8021q_tx_vid(ctx->ds, port);
 	int i, err;
 
 	/* The CPU port is implicitly configured by
 	 * configuring the front-panel ports
 	 */
-	if (!dsa_is_user_port(ds, port))
+	if (!dsa_is_user_port(ctx->ds, port))
 		return 0;
 
 	/* Add this user port's RX VID to the membership list of all others
@@ -227,7 +228,7 @@ static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 	 * L2 forwarding rules still take precedence when there are no VLAN
 	 * restrictions, so there are no concerns about leaking traffic.
 	 */
-	for (i = 0; i < ds->num_ports; i++) {
+	for (i = 0; i < ctx->ds->num_ports; i++) {
 		u16 flags;
 
 		if (i == upstream)
@@ -240,9 +241,10 @@ static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 			/* The RX VID is a regular VLAN on all others */
 			flags = BRIDGE_VLAN_INFO_UNTAGGED;
 
-		err = dsa_8021q_vid_apply(ds, i, rx_vid, flags, enabled);
+		err = dsa_8021q_vid_apply(ctx, i, rx_vid, flags, enabled);
 		if (err) {
-			dev_err(ds->dev, "Failed to apply RX VID %d to port %d: %d\n",
+			dev_err(ctx->ds->dev,
+				"Failed to apply RX VID %d to port %d: %d\n",
 				rx_vid, port, err);
 			return err;
 		}
@@ -251,24 +253,27 @@ static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 	/* CPU port needs to see this port's RX VID
 	 * as tagged egress.
 	 */
-	err = dsa_8021q_vid_apply(ds, upstream, rx_vid, 0, enabled);
+	err = dsa_8021q_vid_apply(ctx, upstream, rx_vid, 0, enabled);
 	if (err) {
-		dev_err(ds->dev, "Failed to apply RX VID %d to port %d: %d\n",
+		dev_err(ctx->ds->dev,
+			"Failed to apply RX VID %d to port %d: %d\n",
 			rx_vid, port, err);
 		return err;
 	}
 
 	/* Finally apply the TX VID on this port and on the CPU port */
-	err = dsa_8021q_vid_apply(ds, port, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED,
+	err = dsa_8021q_vid_apply(ctx, port, tx_vid, BRIDGE_VLAN_INFO_UNTAGGED,
 				  enabled);
 	if (err) {
-		dev_err(ds->dev, "Failed to apply TX VID %d on port %d: %d\n",
+		dev_err(ctx->ds->dev,
+			"Failed to apply TX VID %d on port %d: %d\n",
 			tx_vid, port, err);
 		return err;
 	}
-	err = dsa_8021q_vid_apply(ds, upstream, tx_vid, 0, enabled);
+	err = dsa_8021q_vid_apply(ctx, upstream, tx_vid, 0, enabled);
 	if (err) {
-		dev_err(ds->dev, "Failed to apply TX VID %d on port %d: %d\n",
+		dev_err(ctx->ds->dev,
+			"Failed to apply TX VID %d on port %d: %d\n",
 			tx_vid, upstream, err);
 		return err;
 	}
@@ -276,14 +281,14 @@ static int dsa_8021q_setup_port(struct dsa_switch *ds, int port, bool enabled)
 	return err;
 }
 
-int dsa_8021q_setup(struct dsa_switch *ds, bool enabled)
+int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled)
 {
 	int rc, port;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		rc = dsa_8021q_setup_port(ds, port, enabled);
+	for (port = 0; port < ctx->ds->num_ports; port++) {
+		rc = dsa_8021q_setup_port(ctx, port, enabled);
 		if (rc < 0) {
-			dev_err(ds->dev,
+			dev_err(ctx->ds->dev,
 				"Failed to setup VLAN tagging for port %d: %d\n",
 				port, rc);
 			return rc;
@@ -294,54 +299,54 @@ int dsa_8021q_setup(struct dsa_switch *ds, bool enabled)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_setup);
 
-static int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
-					  struct dsa_switch *other_ds,
+static int dsa_8021q_crosschip_link_apply(struct dsa_8021q_context *ctx,
+					  int port,
+					  struct dsa_8021q_context *other_ctx,
 					  int other_port, bool enabled)
 {
-	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	u16 rx_vid = dsa_8021q_rx_vid(ctx->ds, port);
 
 	/* @rx_vid of local @ds port @port goes to @other_port of
 	 * @other_ds
 	 */
-	return dsa_8021q_vid_apply(other_ds, other_port, rx_vid,
+	return dsa_8021q_vid_apply(other_ctx, other_port, rx_vid,
 				   BRIDGE_VLAN_INFO_UNTAGGED, enabled);
 }
 
-static int dsa_8021q_crosschip_link_add(struct dsa_switch *ds, int port,
-					struct dsa_switch *other_ds,
-					int other_port,
-					struct list_head *crosschip_links)
+static int dsa_8021q_crosschip_link_add(struct dsa_8021q_context *ctx, int port,
+					struct dsa_8021q_context *other_ctx,
+					int other_port)
 {
 	struct dsa_8021q_crosschip_link *c;
 
-	list_for_each_entry(c, crosschip_links, list) {
-		if (c->port == port && c->other_ds == other_ds &&
+	list_for_each_entry(c, &ctx->crosschip_links, list) {
+		if (c->port == port && c->other_ctx == other_ctx &&
 		    c->other_port == other_port) {
 			refcount_inc(&c->refcount);
 			return 0;
 		}
 	}
 
-	dev_dbg(ds->dev, "adding crosschip link from port %d to %s port %d\n",
-		port, dev_name(other_ds->dev), other_port);
+	dev_dbg(ctx->ds->dev,
+		"adding crosschip link from port %d to %s port %d\n",
+		port, dev_name(other_ctx->ds->dev), other_port);
 
 	c = kzalloc(sizeof(*c), GFP_KERNEL);
 	if (!c)
 		return -ENOMEM;
 
 	c->port = port;
-	c->other_ds = other_ds;
+	c->other_ctx = other_ctx;
 	c->other_port = other_port;
 	refcount_set(&c->refcount, 1);
 
-	list_add(&c->list, crosschip_links);
+	list_add(&c->list, &ctx->crosschip_links);
 
 	return 0;
 }
 
-static void dsa_8021q_crosschip_link_del(struct dsa_switch *ds,
+static void dsa_8021q_crosschip_link_del(struct dsa_8021q_context *ctx,
 					 struct dsa_8021q_crosschip_link *c,
-					 struct list_head *crosschip_links,
 					 bool *keep)
 {
 	*keep = !refcount_dec_and_test(&c->refcount);
@@ -349,9 +354,9 @@ static void dsa_8021q_crosschip_link_del(struct dsa_switch *ds,
 	if (*keep)
 		return;
 
-	dev_dbg(ds->dev,
+	dev_dbg(ctx->ds->dev,
 		"deleting crosschip link from port %d to %s port %d\n",
-		c->port, dev_name(c->other_ds->dev), c->other_port);
+		c->port, dev_name(c->other_ctx->ds->dev), c->other_port);
 
 	list_del(&c->list);
 	kfree(c);
@@ -364,64 +369,58 @@ static void dsa_8021q_crosschip_link_del(struct dsa_switch *ds,
  * or untagged: it doesn't matter, since it should never egress a frame having
  * our @rx_vid.
  */
-int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
-				    struct dsa_switch *other_ds,
-				    int other_port,
-				    struct list_head *crosschip_links)
+int dsa_8021q_crosschip_bridge_join(struct dsa_8021q_context *ctx, int port,
+				    struct dsa_8021q_context *other_ctx,
+				    int other_port)
 {
 	/* @other_upstream is how @other_ds reaches us. If we are part
 	 * of disjoint trees, then we are probably connected through
 	 * our CPU ports. If we're part of the same tree though, we should
 	 * probably use dsa_towards_port.
 	 */
-	int other_upstream = dsa_upstream_port(other_ds, other_port);
+	int other_upstream = dsa_upstream_port(other_ctx->ds, other_port);
 	int rc;
 
-	rc = dsa_8021q_crosschip_link_add(ds, port, other_ds,
-					  other_port, crosschip_links);
+	rc = dsa_8021q_crosschip_link_add(ctx, port, other_ctx, other_port);
 	if (rc)
 		return rc;
 
-	rc = dsa_8021q_crosschip_link_apply(ds, port, other_ds,
+	rc = dsa_8021q_crosschip_link_apply(ctx, port, other_ctx,
 					    other_port, true);
 	if (rc)
 		return rc;
 
-	rc = dsa_8021q_crosschip_link_add(ds, port, other_ds,
-					  other_upstream,
-					  crosschip_links);
+	rc = dsa_8021q_crosschip_link_add(ctx, port, other_ctx, other_upstream);
 	if (rc)
 		return rc;
 
-	return dsa_8021q_crosschip_link_apply(ds, port, other_ds,
+	return dsa_8021q_crosschip_link_apply(ctx, port, other_ctx,
 					      other_upstream, true);
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_bridge_join);
 
-int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
-				     struct dsa_switch *other_ds,
-				     int other_port,
-				     struct list_head *crosschip_links)
+int dsa_8021q_crosschip_bridge_leave(struct dsa_8021q_context *ctx, int port,
+				     struct dsa_8021q_context *other_ctx,
+				     int other_port)
 {
-	int other_upstream = dsa_upstream_port(other_ds, other_port);
+	int other_upstream = dsa_upstream_port(other_ctx->ds, other_port);
 	struct dsa_8021q_crosschip_link *c, *n;
 
-	list_for_each_entry_safe(c, n, crosschip_links, list) {
-		if (c->port == port && c->other_ds == other_ds &&
+	list_for_each_entry_safe(c, n, &ctx->crosschip_links, list) {
+		if (c->port == port && c->other_ctx == other_ctx &&
 		    (c->other_port == other_port ||
 		     c->other_port == other_upstream)) {
-			struct dsa_switch *other_ds = c->other_ds;
+			struct dsa_8021q_context *other_ctx = c->other_ctx;
 			int other_port = c->other_port;
 			bool keep;
 			int rc;
 
-			dsa_8021q_crosschip_link_del(ds, c, crosschip_links,
-						     &keep);
+			dsa_8021q_crosschip_link_del(ctx, c, &keep);
 			if (keep)
 				continue;
 
-			rc = dsa_8021q_crosschip_link_apply(ds, port,
-							    other_ds,
+			rc = dsa_8021q_crosschip_link_apply(ctx, port,
+							    other_ctx,
 							    other_port,
 							    false);
 			if (rc)
-- 
2.25.1

