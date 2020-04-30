Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8DA1C07E1
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgD3UZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbgD3UZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:25:53 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA54BC035495
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:25:52 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u127so3720214wmg.1
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 13:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f4SwCAXCxrU0cnOC51WJEylW3Rjq5yh0DKQxZ3Li9+k=;
        b=G4A6D1/wAh19XGjVWZTNvpsF/Atyib7JT+qk5J2tEG1YMB70rQnz76E0zfx5aPgvq/
         7P8pLAZ9YCbgWLTk3ltsPkyerq3vhExyF3/pPwWHtPVLcB08EH/l9E578oBaTNtRkoK8
         QNPX0s6o4nW0DPC0+u29DwXR1cwLE+/3v3SMqsWlu2BA+0oag7cg3LGWUwJLo/3RkTJf
         FKUQizuGDeLiAb4q2T31azjAqtVDu45RSeQTn/hgDIASkaAoxWT7tVrRPqewXXxzEgoA
         Uek/hHIqeCkhE/uBrubVqb+L9Yhz5T7eyh3rpp/3KEiHz3Kxg5oH6GwFrDvyyevGvYZM
         +5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f4SwCAXCxrU0cnOC51WJEylW3Rjq5yh0DKQxZ3Li9+k=;
        b=DNpWf2wt6TWnZ+Sq1ngys0EfnYijkyZXHIL70WL3GibqPWmZtruCCp/SHWYD+mul+P
         qPy9qvI3ZjIpqRR38pHudPHa1m0g6yhd5wlB09AT6G2s3x4cN5MhR1Ii97yCVpvn5hq5
         kxyOaGmnOQn7Z6Y5MkaDjxr3/rYaUjfUHkN02qc03fWkbUZPvQVupoU/CtdHjJzW85XS
         r6pdO9FQNdy+saM/JvOCLoV6vzs7XQu/Gv2UgJhM/9KAtLeDph9pdyAa/Wndk1MqODmK
         FzncA6iiaUD8fDc6Auq3qoEaAUmI2/5EaqfaCsl5UPL23hOxp2tF5wdRzG0PMJ9IEDiK
         ZiTQ==
X-Gm-Message-State: AGi0PubpiGdr954ar0RU7sJCaTi+pkrn2ivD6dkTVdevtACyPgjxNY4x
        U+3fY3r8GohMXVvrBtJWGac=
X-Google-Smtp-Source: APiQypKOTdhmGRAWB/nTe9Hbv7SAOGHR8pW9ECZJGIFE6ih4e1J80/bhOPHDyoHjc38haIDYfQocBQ==
X-Received: by 2002:a7b:c755:: with SMTP id w21mr370228wmk.120.1588278351220;
        Thu, 30 Apr 2020 13:25:51 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id f8sm1188462wrm.14.2020.04.30.13.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 13:25:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH v2 net-next 4/4] net: dsa: sja1105: implement cross-chip bridging operations
Date:   Thu, 30 Apr 2020 23:25:42 +0300
Message-Id: <20200430202542.11797-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430202542.11797-1-olteanv@gmail.com>
References: <20200430202542.11797-1-olteanv@gmail.com>
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
Changes in v2:
Now replaying the crosschip operations when toggling the VLAN filtering
state (aka when we need to hide the dsa_8021q VLANs, as the VLAN
filtering table becomes visible to the user so it needs to be cleared -
and perhaps restored afterwards).

 drivers/net/dsa/sja1105/sja1105.h      |   9 ++
 drivers/net/dsa/sja1105/sja1105_main.c | 183 +++++++++++++++++++++++++
 2 files changed, 192 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 2f62942692ec..6b4fad1216bb 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -127,6 +127,14 @@ struct sja1105_flow_block {
 	bool l2_policer_used[SJA1105_NUM_L2_POLICERS];
 };
 
+struct sja1105_crosschip_info {
+	struct list_head list;
+	int tree_index;
+	int sw_index;
+	int other_port;
+	struct net_device *br;
+};
+
 struct sja1105_private {
 	struct sja1105_static_config static_config;
 	bool rgmii_rx_delay[SJA1105_NUM_PORTS];
@@ -135,6 +143,7 @@ struct sja1105_private {
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
 	struct dsa_switch *ds;
+	struct list_head crosschip_ports;
 	struct sja1105_flow_block flow_block;
 	struct sja1105_port ports[SJA1105_NUM_PORTS];
 	/* Serializes transmission of management frames so that
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 472f4eb20c49..95e00e03d05b 100644
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
@@ -1790,6 +1792,176 @@ static int sja1105_vlan_apply(struct sja1105_private *priv, int port, u16 vid,
 	return 0;
 }
 
+static int sja1105_crosschip_bridge_member(struct dsa_switch *ds,
+					   int tree_index, int sw_index,
+					   int other_port,
+					   struct net_device *br, bool enabled)
+{
+	struct dsa_switch *other_ds = dsa_switch_find(tree_index, sw_index);
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_private *other_priv;
+	u16 rx_vid, other_rx_vid;
+	int cpu = -1, other_cpu;
+	int port, rc;
+
+	if (other_ds->ops != &sja1105_switch_ops)
+		return 0;
+
+	other_cpu = dsa_upstream_port(other_ds, other_port);
+	other_priv = other_ds->priv;
+
+	/* Make traffic from all local ports enslaved to @br be received
+	 * by @other_ds. This means that our @rx_vid needs to be installed
+	 * on @other_ds's CPU port and user ports. The user ports should be
+	 * egress-untagged so that the can pop the dsa_8021q VLAN. But the
+	 * @other_cpu can be either egress-tagged or untagged: it doesn't
+	 * matter, since it should never egress a frame having our @rx_vid.
+	 */
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		if (!dsa_is_user_port(ds, port))
+			continue;
+		if (dsa_to_port(ds, port)->bridge_dev != br)
+			continue;
+
+		cpu = dsa_upstream_port(ds, port);
+
+		rx_vid = dsa_8021q_rx_vid(ds, port);
+
+		/* The VLANs on @other_cpu port should be refcounted, because
+		 * we don't want to remove our @rx_vid just yet when a single
+		 * remote port leaves. But that's tricky to implement, so just
+		 * keep it simple and leave the VLANs installed on the CPU
+		 * ports when leaving. Forwarding will still be denied, as it
+		 * should be, because the @rx_vid has been removed from the
+		 * remote switch's external port.
+		 */
+		if (enabled) {
+			/* @rx_vid of local @ds port @port goes to @other_cpu
+			 * of @other_ds
+			 */
+			rc = sja1105_vlan_apply(other_priv, other_cpu, rx_vid,
+						enabled, false);
+			if (rc < 0)
+				return rc;
+		}
+
+		/* @rx_vid of local @ds port @port goes to @other_port of
+		 * @other_ds
+		 */
+		rc = sja1105_vlan_apply(other_priv, other_port,
+					rx_vid, enabled, true);
+		if (rc < 0)
+			return rc;
+	}
+
+	/* Shorthand way of saying that we had no ports enslaved to @br. Also a
+	 * convenient way of getting a reference to the CPU port via
+	 * dsa_upstream_port(), which needs a valid user port as argument.
+	 */
+	if (cpu == -1)
+		return 0;
+
+	/* Make traffic from the remote @other_ds switch's @other_port be
+	 * accepted by the local @ds. This means that its @rx_vid needs to be
+	 * installed on our local CPU port as well as local ports that are
+	 * members of @br.
+	 */
+	other_rx_vid = dsa_8021q_rx_vid(other_ds, other_port);
+
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		if (!dsa_is_user_port(ds, port))
+			continue;
+		if (dsa_to_port(ds, port)->bridge_dev != br)
+			continue;
+
+		/* @other_rx_vid of @other_ds port @other_port goes to port
+		 * @port of local @ds.
+		 */
+		rc = sja1105_vlan_apply(priv, port, other_rx_vid, enabled,
+					true);
+		if (rc < 0)
+			return rc;
+	}
+
+	/* The comment above regarding VLAN refcounting applies here too */
+	if (!enabled)
+		return 0;
+
+	/* @other_rx_vid of @other_ds port @other_port goes to port @cpu of
+	 * local @ds
+	 */
+	return sja1105_vlan_apply(priv, cpu, other_rx_vid, enabled, false);
+}
+
+static int sja1105_crosschip_bridge_join(struct dsa_switch *ds,
+					 int tree_index, int sw_index,
+					 int other_port, struct net_device *br)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_crosschip_info *c;
+	int rc;
+
+	if (!br_vlan_enabled(br)) {
+		rc = sja1105_crosschip_bridge_member(ds, tree_index, sw_index,
+						     other_port, br, true);
+		if (rc)
+			return rc;
+	}
+
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	if (!c)
+		return -ENOMEM;
+
+	c->tree_index = tree_index;
+	c->sw_index = sw_index;
+	c->other_port = other_port;
+	c->br = br;
+
+	list_add(&c->list, &priv->crosschip_ports);
+
+	return 0;
+}
+
+static void sja1105_crosschip_bridge_leave(struct dsa_switch *ds,
+					   int tree_index, int sw_index,
+					   int other_port,
+					   struct net_device *br)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_crosschip_info *c, *n;
+
+	if (!br_vlan_enabled(br))
+		sja1105_crosschip_bridge_member(ds, tree_index, sw_index,
+						other_port, br, false);
+
+	list_for_each_entry_safe(c, n, &priv->crosschip_ports, list) {
+		if (c->tree_index == tree_index && c->sw_index == sw_index &&
+		    c->other_port == other_port && c->br == br) {
+			list_del(&c->list);
+			kfree(c);
+			break;
+		}
+	}
+}
+
+static int sja1105_apply_crosschip_vlans(struct dsa_switch *ds, bool enabled)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_crosschip_info *c;
+	int rc;
+
+	list_for_each_entry(c, &priv->crosschip_ports, list) {
+		rc = sja1105_crosschip_bridge_member(ds, c->tree_index,
+						     c->sw_index,
+						     c->other_port, c->br,
+						     enabled);
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
@@ -1802,6 +1974,13 @@ static int sja1105_setup_8021q_tagging(struct dsa_switch *ds, bool enabled)
 			return rc;
 		}
 	}
+	/* Replay the crosschip operations whenever we need to enable or
+	 * disable DSA tagging.
+	 */
+	rc = sja1105_apply_crosschip_vlans(ds, enabled);
+	if (rc)
+		return rc;
+
 	dev_info(ds->dev, "%s switch tagging\n",
 		 enabled ? "Enabled" : "Disabled");
 	return 0;
@@ -2359,6 +2538,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_policer_del	= sja1105_port_policer_del,
 	.cls_flower_add		= sja1105_cls_flower_add,
 	.cls_flower_del		= sja1105_cls_flower_del,
+	.crosschip_bridge_join	= sja1105_crosschip_bridge_join,
+	.crosschip_bridge_leave	= sja1105_crosschip_bridge_leave,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
@@ -2461,6 +2642,8 @@ static int sja1105_probe(struct spi_device *spi)
 	mutex_init(&priv->ptp_data.lock);
 	mutex_init(&priv->mgmt_lock);
 
+	INIT_LIST_HEAD(&priv->crosschip_ports);
+
 	sja1105_tas_setup(ds);
 	sja1105_flower_setup(ds);
 
-- 
2.17.1

