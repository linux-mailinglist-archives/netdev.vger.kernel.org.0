Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1C01BE39D
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 18:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgD2QUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 12:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726539AbgD2QUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 12:20:04 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E24C03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:20:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k1so3275794wrx.4
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 09:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VQJTGM6oDsDIGZQkRdaVeFHVl+u9VslqlGtVawflCTU=;
        b=bXPGBL4XhxN22Hdi3Nj2+VNEDwsg7ShF3vE0qQFjrbOQQvGFj6vYU61BM7QiYAIBaB
         rfN6cxfR1sPYEG6fCoZbg1hbC48SLK1BapKshrG4Cxj225JD3V5YXVWCGwGTCfPBBdl0
         usoaPTE7HcpVknMFOxSxPZhBy28dUct78E1LxfJEZdWjUqf8jxSJYZxGt+TbJT08Dy5c
         RF947Y0IIiGpf0OOEJopTTYy9fscHJRzKUm+aBooovRNKOjkFf0TRr92gXbaVjETIgEJ
         CtXwnDzOxGseGb15eT0Y8p89z5AYz+5i5uCkTWqdXd9xMcD2Q2kWL4zAkI5XUmdAYdR3
         K0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VQJTGM6oDsDIGZQkRdaVeFHVl+u9VslqlGtVawflCTU=;
        b=F/kyebHrmqmISsSxcUwFet0cyvTwSrbwTHwJNNSAYuWRN/RAk0g54BAYu+m/CZmhE6
         kmMP8LBNdHGdyoWUz1t/QBUjE0mHT0MJDVyTfvS5uQgJDUWZd4V1/JCnlIB9yL+lSo2C
         DTboHLJuu8NkE0YkAQAUl4nfnSv+s2qYG153U3Jm7z2BiHZDWtvc2KhYHR/Gtbt1q4MN
         Bu5MDknP/2AfUvAlJvJ62oOkbpjpXDjYaVm+LBWhIsk05PsDiB7SJVQkEtiuK0AMUgoK
         XxPYhwl4AUylxW9v1DuEQGcTAW4aoxeW7jS7LgWcjPvdyRQ03ScC3FrJJdaLMZyOcVHB
         luag==
X-Gm-Message-State: AGi0PuY6TUItaa09QHp+9uHOgOrL8tmNaiz+OaW981ZkJpxPdXjf3zLO
        lN/+9pDXsKr+GGLXtHuAJtg=
X-Google-Smtp-Source: APiQypLPyUDvbdOuUapmmgSoAfwWV/Tauz10VJLSdDJbFd1Oz8+JhdWSKxqZwZX/CjqKwtslR6epHQ==
X-Received: by 2002:adf:cc81:: with SMTP id p1mr42743680wrj.372.1588177201861;
        Wed, 29 Apr 2020 09:20:01 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id r18sm28132609wrj.70.2020.04.29.09.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 09:20:01 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com
Subject: [PATCH net-next 4/4] net: dsa: sja1105: implement cross-chip bridging operations
Date:   Wed, 29 Apr 2020 19:19:52 +0300
Message-Id: <20200429161952.17769-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200429161952.17769-1-olteanv@gmail.com>
References: <20200429161952.17769-1-olteanv@gmail.com>
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
 drivers/net/dsa/sja1105/sja1105_main.c | 122 +++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 472f4eb20c49..32a05a2424a3 100644
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
@@ -1934,6 +1936,124 @@ static int sja1105_vlan_del(struct dsa_switch *ds, int port,
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
+	return sja1105_crosschip_bridge_member(ds, tree_index, sw_index,
+					       other_port, br, true);
+}
+
+static void sja1105_crosschip_bridge_leave(struct dsa_switch *ds,
+					   int tree_index, int sw_index,
+					   int other_port,
+					   struct net_device *br)
+{
+	sja1105_crosschip_bridge_member(ds, tree_index, sw_index, other_port,
+					br, false);
+}
+
 /* The programming model for the SJA1105 switch is "all-at-once" via static
  * configuration tables. Some of these can be dynamically modified at runtime,
  * but not the xMII mode parameters table.
@@ -2359,6 +2479,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_policer_del	= sja1105_port_policer_del,
 	.cls_flower_add		= sja1105_cls_flower_add,
 	.cls_flower_del		= sja1105_cls_flower_del,
+	.crosschip_bridge_join	= sja1105_crosschip_bridge_join,
+	.crosschip_bridge_leave	= sja1105_crosschip_bridge_leave,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
-- 
2.17.1

