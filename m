Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944261C2FE5
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbgECWMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729165AbgECWMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:12:42 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D94C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:12:41 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e26so6241200wmk.5
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nUDGlxDfKe6tJ67ddSjASJnEIqT9sY/RHshixmIDAEo=;
        b=CYWHWyCBCKOz1M9drZmQk7dJue7cM52j7IaPjSbUrE9GO7I9BSS5wIt3r0/HTJ4uIA
         yFszoQAx91S4OXHFDMxWfxq9zxZfHxJBPOQt+33UxdtpdSG+0Shp+9qpJpn+nc0o0avR
         EY9KfMICFv6bujvSmWhgeHMrG9Kr7PuJikR1GwnJNhE+rhtcPHOFv8qou76HeFKyW4mE
         E1ymdlT0HE4zrYap81cSPwlV+oSvl6V2d3tkwlucUfSjpuiU0aOkHw8v+HnqOITG6gcg
         DRyovxZTbMQaPC3wlszgTuJCpXuoICVIENpbO/XksqoXubu1SpJbSprxtm+y0PQP7wtJ
         IFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nUDGlxDfKe6tJ67ddSjASJnEIqT9sY/RHshixmIDAEo=;
        b=eU75828qxEE/5+5ITdj0SalxWhsrdHK7k4vHxA+s2zgIAM7+1GjxvqQ6tuRkksY9c/
         mX3AKdQCt9Ig+bth7MawpEU1AMXaJNJ4GB6ixdkKl7P/wim6GnILeLXNg5QfnMzfuZHO
         gpTCWkx5G1RftBURkHo0LuegAOuWqCQ+0RGCZReVaGe4ciyQx3mm17iwtlq+dfQVaa6u
         w9OYHWjgfxHwTfjHKgoUgHe8nDyiwohWz7yyPKja8Fbrj3CLZfSfTdp5h3QwXX8gT2L/
         jTz8xMPRhDkE/jztVYryA8LqEG2j3KMl2yur3boOi0Nz/eWdmC+zRVWNQLoyw//6ouze
         QIRQ==
X-Gm-Message-State: AGi0PubogM13BZieovaI6dKw6DD54tQ/iGy5L9xXMpDg+3ZEejvhffI7
        0vEfnMv8PqElc+fIEKOkHHA=
X-Google-Smtp-Source: APiQypJuUyKM6+OMltZFPOOlkp45TVXWvuyY8SilC8C97TV0y0i+xmpP66U5xpob/OQT+OyuXagf+A==
X-Received: by 2002:a7b:c399:: with SMTP id s25mr10783328wmj.169.1588543960447;
        Sun, 03 May 2020 15:12:40 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id q143sm10692188wme.31.2020.05.03.15.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 15:12:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, mingkai.hu@nxp.com
Subject: [PATCH v3 net-next 4/4] net: dsa: sja1105: implement cross-chip bridging operations
Date:   Mon,  4 May 2020 01:12:28 +0300
Message-Id: <20200503221228.10928-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503221228.10928-1-olteanv@gmail.com>
References: <20200503221228.10928-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

sja1105 uses dsa_8021q for DSA tagging, a format which is VLAN at heart
and which is compatible with cascading. A complete description of this
tagging format is in net/dsa/tag_8021q.c, but a quick summary is that
each external-facing port tags incoming frames with a unique pvid, and
this special VLAN is transmitted as tagged towards the inside of the
system, and as untagged towards the exterior. The tag encodes the switch
id and the source port index.

This means that cross-chip bridging for dsa_8021q only entails adding
the dsa_8021q pvids of one switch to the RX filter of the other
switches. Everything else falls naturally into place, as long as the
bottom-end of ports (the leaves in the tree) is comprised exclusively of
dsa_8021q-compatible (i.e. sja1105 switches). Otherwise, there would be
a chance that a front-panel switch transmits a packet tagged with a
dsa_8021q header, header which it wouldn't be able to remove, and which
would hence "leak" out.

The only use case I tested (due to lack of board availability) was when
the sja1105 switches are part of disjoint trees (however, this doesn't
change the fact that multiple sja1105 switches still need unique switch
identifiers in such a system). But in principle, even "true" single-tree
setups (with DSA links) should work just as fine, except for a small
change which I can't test: dsa_towards_port should be used instead of
dsa_upstream_port (I made the assumption that the routing port that any
sja1105 should use towards its neighbours is the CPU port. That might
not hold true in other setups).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
* Moved the implementation in tag_8021q.c, because 1. it is generic
  enough that is can be reused by anyone employing dsa_8021q tagging,
  and 2. sja1105_main.c could use some de-cluttering.
* Provided reference counting to the crosschip links to avoid
  workarounds such as never deleting VLANs from the CPU port.

Changes in v2:
Now replaying the crosschip operations when toggling the VLAN filtering
state (aka when we need to hide the dsa_8021q VLANs, as the VLAN
filtering table becomes visible to the user so it needs to be cleared -
and perhaps restored afterwards).

 drivers/net/dsa/sja1105/sja1105.h      |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c |  90 +++++++++++++++
 include/linux/dsa/8021q.h              |  45 ++++++++
 net/dsa/tag_8021q.c                    | 151 +++++++++++++++++++++++++
 4 files changed, 288 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 2f62942692ec..a12779c9fa19 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -8,6 +8,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 #include <linux/dsa/sja1105.h>
+#include <linux/dsa/8021q.h>
 #include <net/dsa.h>
 #include <linux/mutex.h>
 #include "sja1105_static_config.h"
@@ -135,6 +136,7 @@ struct sja1105_private {
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
+	struct list_head crosschip_links;
 	struct sja1105_flow_block flow_block;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
 	/* Serializes transmission of management frames so that
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 472f4eb20c49..f75ceabb4bf9 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -25,6 +25,8 @@
 #include "sja1105_sgmii.h"
 #include "sja1105_tas.h"
 
+static const struct dsa_switch_ops sja1105_switch_ops;
+
 static void sja1105_hw_reset(struct gpio_desc *gpio, unsigned int pulse_len,
 			     unsigned int startup_delay)
 {
@@ -1790,6 +1792,84 @@ static int sja1105_vlan_apply(struct sja1105_private *priv, int port, u16 vid,
 	return 0;
 }
 
+static int sja1105_crosschip_bridge_join(struct dsa_switch *ds,
+					 int tree_index, int sw_index,
+					 int other_port, struct net_device *br)
+{
+	struct dsa_switch *other_ds = dsa_switch_find(tree_index, sw_index);
+	struct sja1105_private *other_priv = other_ds->priv;
+	struct sja1105_private *priv = ds->priv;
+	int port, rc;
+
+	if (other_ds->ops != &sja1105_switch_ops)
+		return 0;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!dsa_is_user_port(ds, port))
+			continue;
+		if (dsa_to_port(ds, port)->bridge_dev != br)
+			continue;
+
+		rc = dsa_8021q_crosschip_bridge_join(ds, port, other_ds,
+						     other_port, br,
+						     &priv->crosschip_links);
+		if (rc)
+			return rc;
+
+		rc = dsa_8021q_crosschip_bridge_join(other_ds, other_port, ds,
+						     port, br,
+						     &other_priv->crosschip_links);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static void sja1105_crosschip_bridge_leave(struct dsa_switch *ds,
+					   int tree_index, int sw_index,
+					   int other_port,
+					   struct net_device *br)
+{
+	struct dsa_switch *other_ds = dsa_switch_find(tree_index, sw_index);
+	struct sja1105_private *other_priv = other_ds->priv;
+	struct sja1105_private *priv = ds->priv;
+	int port;
+
+	if (other_ds->ops != &sja1105_switch_ops)
+		return;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!dsa_is_user_port(ds, port))
+			continue;
+		if (dsa_to_port(ds, port)->bridge_dev != br)
+			continue;
+
+		dsa_8021q_crosschip_bridge_leave(ds, port, other_ds, other_port,
+						 br, &priv->crosschip_links);
+
+		dsa_8021q_crosschip_bridge_leave(other_ds, other_port, ds,
+						 port, br,
+						 &other_priv->crosschip_links);
+	}
+}
+
+static int sja1105_replay_crosschip_vlans(struct dsa_switch *ds, bool enabled)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct dsa_8021q_crosschip_link *c;
+	int rc;
+
+	list_for_each_entry(c, &priv->crosschip_links, list) {
+		rc = dsa_8021q_crosschip_link_apply(ds, c->port, c->other_ds,
+						    c->other_port, enabled);
+		if (rc)
+			break;
+	}
+
+	return rc;
+}
+
 static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
 {
 	int rc, i;
@@ -1802,6 +1882,12 @@ static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
 			return rc;
 		}
 	}
+	rc = sja1105_replay_crosschip_vlans(ds, enabled);
+	if (rc) {
+		dev_err(ds->dev, "Failed to replay crosschip VLANs: %d\n", rc);
+		return rc;
+	}
+
 	dev_info(ds->dev, "%s switch tagging\n",
 		 enabled ? "Enabled" : "Disabled");
 	return 0;
@@ -2359,6 +2445,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_policer_del	= sja1105_port_policer_del,
 	.cls_flower_add		= sja1105_cls_flower_add,
 	.cls_flower_del		= sja1105_cls_flower_del,
+	.crosschip_bridge_join	= sja1105_crosschip_bridge_join,
+	.crosschip_bridge_leave	= sja1105_crosschip_bridge_leave,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
@@ -2461,6 +2549,8 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->mgmt_lock);
 
+	INIT_LIST_HEAD(&priv->crosschip_links);
+
 	sja1105_tas_setup(ds);
 	sja1105_flower_setup(ds);
 
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index c620d9139c28..b8daaec0896e 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -12,11 +12,33 @@ struct sk_buff;
 struct net_device;
 struct packet_type;
 
+struct dsa_8021q_crosschip_link {
+	struct list_head list;
+	int port;
+	struct dsa_switch *other_ds;
+	int other_port;
+	refcount_t refcount;
+};
+
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q)
 
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
 				 bool enabled);
 
+int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
+				   struct dsa_switch *other_ds,
+				   int other_port, bool enabled);
+
+int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
+				    struct dsa_switch *other_ds,
+				    int other_port, struct net_device *br,
+				    struct list_head *crosschip_links);
+
+int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
+				     struct dsa_switch *other_ds,
+				     int other_port, struct net_device *br,
+				     struct list_head *crosschip_links);
+
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci);
 
@@ -36,6 +58,29 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
 	return 0;
 }
 
+int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
+				   struct dsa_switch *other_ds,
+				   int other_port, bool enabled)
+{
+	return 0;
+}
+
+int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
+				    struct dsa_switch *other_ds,
+				    int other_port, struct net_device *br,
+				    struct list_head *crosschip_links)
+{
+	return 0;
+}
+
+int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
+				     struct dsa_switch *other_ds,
+				     int other_port, struct net_device *br,
+				     struct list_head *crosschip_links)
+{
+	return 0;
+}
+
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci)
 {
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index b97ad93d1c1a..ff9c5bf64bda 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -8,6 +8,7 @@
  */
 #include <linux/if_bridge.h>
 #include <linux/if_vlan.h>
+#include <linux/dsa/8021q.h>
 
 #include "dsa_priv.h"
 
@@ -288,6 +289,156 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 }
 EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
 
+int dsa_8021q_crosschip_link_apply(struct dsa_switch *ds, int port,
+				   struct dsa_switch *other_ds,
+				   int other_port, bool enabled)
+{
+	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+
+	/* @rx_vid of local @ds port @port goes to @other_port of
+	 * @other_ds
+	 */
+	return dsa_8021q_vid_apply(other_ds, other_port, rx_vid,
+				   BRIDGE_VLAN_INFO_UNTAGGED, enabled);
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_link_apply);
+
+static int dsa_8021q_crosschip_link_add(struct dsa_switch *ds, int port,
+					struct dsa_switch *other_ds,
+					int other_port,
+					struct list_head *crosschip_links)
+{
+	struct dsa_8021q_crosschip_link *c;
+
+	list_for_each_entry(c, crosschip_links, list) {
+		if (c->port == port && c->other_ds == other_ds &&
+		    c->other_port == other_port) {
+			refcount_inc(&c->refcount);
+			return 0;
+		}
+	}
+
+	dev_dbg(ds->dev, "adding crosschip link from port %d to %s port %d\n",
+		port, dev_name(other_ds->dev), other_port);
+
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	if (!c)
+		return -ENOMEM;
+
+	c->port = port;
+	c->other_ds = other_ds;
+	c->other_port = other_port;
+	refcount_set(&c->refcount, 1);
+
+	list_add(&c->list, crosschip_links);
+
+	return 0;
+}
+
+static void dsa_8021q_crosschip_link_del(struct dsa_switch *ds,
+					 struct dsa_8021q_crosschip_link *c,
+					 struct list_head *crosschip_links,
+					 bool *keep)
+{
+	*keep = !refcount_dec_and_test(&c->refcount);
+
+	if (*keep)
+		return;
+
+	dev_dbg(ds->dev,
+		"deleting crosschip link from port %d to %s port %d\n",
+		c->port, dev_name(c->other_ds->dev), c->other_port);
+
+	list_del(&c->list);
+	kfree(c);
+}
+
+/* Make traffic from local port @port be received by remote port @other_port.
+ * This means that our @rx_vid needs to be installed on @other_ds's upstream
+ * and user ports. The user ports should be egress-untagged so that they can
+ * pop the dsa_8021q VLAN. But the @other_upstream can be either egress-tagged
+ * or untagged: it doesn't matter, since it should never egress a frame having
+ * our @rx_vid.
+ */
+int dsa_8021q_crosschip_bridge_join(struct dsa_switch *ds, int port,
+				    struct dsa_switch *other_ds,
+				    int other_port, struct net_device *br,
+				    struct list_head *crosschip_links)
+{
+	/* @other_upstream is how @other_ds reaches us. If we are part
+	 * of disjoint trees, then we are probably connected through
+	 * our CPU ports. If we're part of the same tree though, we should
+	 * probably use dsa_towards_port.
+	 */
+	int other_upstream = dsa_upstream_port(other_ds, other_port);
+	int rc;
+
+	rc = dsa_8021q_crosschip_link_add(ds, port, other_ds,
+					  other_port, crosschip_links);
+	if (rc)
+		return rc;
+
+	if (!br_vlan_enabled(br)) {
+		rc = dsa_8021q_crosschip_link_apply(ds, port, other_ds,
+						    other_port, true);
+		if (rc)
+			return rc;
+	}
+
+	rc = dsa_8021q_crosschip_link_add(ds, port, other_ds,
+					  other_upstream,
+					  crosschip_links);
+	if (rc)
+		return rc;
+
+	if (!br_vlan_enabled(br)) {
+		rc = dsa_8021q_crosschip_link_apply(ds, port, other_ds,
+						    other_upstream, true);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_bridge_join);
+
+int dsa_8021q_crosschip_bridge_leave(struct dsa_switch *ds, int port,
+				     struct dsa_switch *other_ds,
+				     int other_port, struct net_device *br,
+				     struct list_head *crosschip_links)
+{
+	int other_upstream = dsa_upstream_port(other_ds, other_port);
+	struct dsa_8021q_crosschip_link *c, *n;
+
+	list_for_each_entry_safe(c, n, crosschip_links, list) {
+		if (c->port == port && c->other_ds == other_ds &&
+		    (c->other_port == other_port ||
+		     c->other_port == other_upstream)) {
+			struct dsa_switch *other_ds = c->other_ds;
+			int other_port = c->other_port;
+			bool keep;
+			int rc;
+
+			dsa_8021q_crosschip_link_del(ds, c, crosschip_links,
+						     &keep);
+			if (keep)
+				continue;
+
+			if (!br_vlan_enabled(br)) {
+				rc = dsa_8021q_crosschip_link_apply(ds, port,
+								    other_ds,
+								    other_port,
+								    false);
+				if (rc)
+					return rc;
+			}
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_crosschip_bridge_leave);
+
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci)
 {
-- 
2.17.1

