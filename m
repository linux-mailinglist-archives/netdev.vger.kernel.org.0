Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F47531B10F
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 16:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhBNP6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 10:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhBNP6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 10:58:01 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709E7C0613D6
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:57:19 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y18so5264264edw.13
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uzMcqZmVU8p/WUafrlw6GUYaSwQEpz2AcZTY4aSc314=;
        b=JMgF0nSl32ObuhbVd4SCHOH8GjbUaocnBZ3YbVjmYIuCHy83aMcIe4za9btPFfhZSK
         XB4kSz0POieh+F9N3pixuz+TbpCnYb7aA+UmEt5vDRtO39RD64RFBsIgS8XCf+I399Go
         aysTvRIEZX53SOXxD11yx/X2bMsJCAJm2eJ4kF+wq81Lxw8oZzmcA/L8yxK7Sf84PAhv
         xyPPP6OvMvqxKcBP2KrrkrO/jDm9Ry5ifwmGlTYVfKyBf1dRZ/HsBkLAw9VCJ4wXCCuR
         iYJSu2LRR6viv3R6OwZUKXhE/jfwcIYoJLkkKTXoOh7cEtp4mgsmZCCmuqgfVFmF4ypS
         esIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uzMcqZmVU8p/WUafrlw6GUYaSwQEpz2AcZTY4aSc314=;
        b=pMLMN6o4fjxFps5m9D0yzD6BjVAPH0T/t+7xDMAzDBc6ScD8LBzopSkMP399i4rolU
         9G05aq89fj3bnsarvDGppMKFQ0qmnqvBmw7WT8ceioydHKC3xmXrhE98Iri1EGsCR2F6
         /IL6I4Wmr5FXMEgcZOLXCEpU9I2BFgUionJmBvYUqwtZ8oycO7+IS6HyMiogNLt2qteA
         8z/Igp43+aCAvXhg5wGWpFFmtFZLhlaFO7nDwuv7CGxYao+SKTOCe0HTDGcCpLMKS1pH
         XGfEO+pDJGEwa3PDZxJOIIxGUqWBh+Kcgb8E8FljANYt/5kHA6gXRFzo20EtMVyCq9zc
         z9wg==
X-Gm-Message-State: AOAM532cIv9NfJE3bRinjTrmS2YfOXrU/0nnwyHRbqyksBNGyin3+FI4
        KGUOLGWMI+h4sWdCsWgVBg0=
X-Google-Smtp-Source: ABdhPJyCrQRI97dN1W+6vyz/hSCuWvb4V9NVqF/8M+VQmt0hYq3ophksMhDcyzk07SjYpYwCijhOKQ==
X-Received: by 2002:a05:6402:17e2:: with SMTP id t2mr11804006edy.140.1613318238107;
        Sun, 14 Feb 2021 07:57:18 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id d16sm8671829edq.77.2021.02.14.07.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 07:57:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 2/2] net: dsa: sja1105: fix leakage of flooded frames outside bridging domain
Date:   Sun, 14 Feb 2021 17:57:04 +0200
Message-Id: <20210214155704.1784220-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210214155704.1784220-1-olteanv@gmail.com>
References: <20210214155704.1784220-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Quite embarrasingly, I managed to fool myself into thinking that the
flooding domain of sja1105 source ports is restricted by the forwarding
domain, which it isn't. Frames which match an FDB entry are forwarded
towards that entry's DESTPORTS restricted by REACH_PORT[SRC_PORT], while
frames that don't match any FDB entry are forwarded towards
FL_DOMAIN[SRC_PORT] or BC_DOMAIN[SRC_PORT].

This means we can't get away with doing the simple thing, and we must
manage the flooding domain ourselves such that it is restricted by the
forwarding domain. This new function must be called from the
.port_bridge_join and .port_bridge_leave methods too, not just from
.port_bridge_flags as we did before.

Fixes: 4d9423549501 ("net: dsa: sja1105: offload bridge port flags to device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c | 115 ++++++++++++++++---------
 2 files changed, 76 insertions(+), 41 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 15a0893d0ff1..494d17117b94 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -206,6 +206,8 @@ struct sja1105_private {
 	bool rgmii_tx_delay[SJA1105_NUM_PORTS];
 	bool best_effort_vlan_filtering;
 	unsigned long learn_ena;
+	unsigned long ucast_egress_floods;
+	unsigned long bcast_egress_floods;
 	const struct sja1105_info *info;
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 3d3e2794655d..7eef96fab214 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -50,6 +50,12 @@ sja1105_port_allow_traffic(struct sja1105_l2_forwarding_entry *l2_fwd,
 		l2_fwd[from].reach_port &= ~BIT(to);
 }
 
+static bool sja1105_can_forward(struct sja1105_l2_forwarding_entry *l2_fwd,
+				int from, int to)
+{
+	return !!(l2_fwd[from].reach_port & BIT(to));
+}
+
 /* Structure used to temporarily transport device tree
  * settings into sja1105_setup
  */
@@ -408,6 +414,12 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 		for (j = 0; j < SJA1105_NUM_TC; j++)
 			l2fwd[i].vlan_pmap[j] = j;
 
+		/* All ports start up with egress flooding enabled,
+		 * including the CPU port.
+		 */
+		priv->ucast_egress_floods |= BIT(i);
+		priv->bcast_egress_floods |= BIT(i);
+
 		if (i == upstream)
 			continue;
 
@@ -1571,6 +1583,50 @@ static int sja1105_mdb_del(struct dsa_switch *ds, int port,
 	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid);
 }
 
+/* Common function for unicast and broadcast flood configuration.
+ * Flooding is configured between each {ingress, egress} port pair, and since
+ * the bridge's semantics are those of "egress flooding", it means we must
+ * enable flooding towards this port from all ingress ports that are in the
+ * same forwarding domain.
+ */
+static int sja1105_manage_flood_domains(struct sja1105_private *priv)
+{
+	struct sja1105_l2_forwarding_entry *l2_fwd;
+	struct dsa_switch *ds = priv->ds;
+	int from, to, rc;
+
+	l2_fwd = priv->static_config.tables[BLK_IDX_L2_FORWARDING].entries;
+
+	for (from = 0; from < ds->num_ports; from++) {
+		u64 fl_domain = 0, bc_domain = 0;
+
+		for (to = 0; to < priv->ds->num_ports; to++) {
+			if (!sja1105_can_forward(l2_fwd, from, to))
+				continue;
+
+			if (priv->ucast_egress_floods & BIT(to))
+				fl_domain |= BIT(to);
+			if (priv->bcast_egress_floods & BIT(to))
+				bc_domain |= BIT(to);
+		}
+
+		/* Nothing changed, nothing to do */
+		if (l2_fwd[from].fl_domain == fl_domain &&
+		    l2_fwd[from].bc_domain == bc_domain)
+			continue;
+
+		l2_fwd[from].fl_domain = fl_domain;
+		l2_fwd[from].bc_domain = bc_domain;
+
+		rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_FORWARDING,
+						  from, &l2_fwd[from], true);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
 static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 				 struct net_device *br, bool member)
 {
@@ -1608,8 +1664,12 @@ static int sja1105_bridge_member(struct dsa_switch *ds, int port,
 			return rc;
 	}
 
-	return sja1105_dynamic_config_write(priv, BLK_IDX_L2_FORWARDING,
-					    port, &l2_fwd[port], true);
+	rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_FORWARDING,
+					  port, &l2_fwd[port], true);
+	if (rc)
+		return rc;
+
+	return sja1105_manage_flood_domains(priv);
 }
 
 static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
@@ -3297,51 +3357,24 @@ static int sja1105_port_set_learning(struct sja1105_private *priv, int port,
 	return 0;
 }
 
-/* Common function for unicast and broadcast flood configuration.
- * Flooding is configured between each {ingress, egress} port pair, and since
- * the bridge's semantics are those of "egress flooding", it means we must
- * enable flooding towards this port from all ingress ports that are in the
- * same bridge. In practice, we just enable flooding from all possible ingress
- * ports regardless of whether they're in the same bridge or not, since the
- * reach_port configuration will not allow flooded frames to leak across
- * bridging domains anyway.
- */
 static int sja1105_port_ucast_bcast_flood(struct sja1105_private *priv, int to,
 					  struct switchdev_brport_flags flags)
 {
-	struct sja1105_l2_forwarding_entry *l2_fwd;
-	int from, rc;
-
-	l2_fwd = priv->static_config.tables[BLK_IDX_L2_FORWARDING].entries;
-
-	for (from = 0; from < priv->ds->num_ports; from++) {
-		if (dsa_is_unused_port(priv->ds, from))
-			continue;
-		if (from == to)
-			continue;
-
-		/* Unicast */
-		if (flags.mask & BR_FLOOD) {
-			if (flags.val & BR_FLOOD)
-				l2_fwd[from].fl_domain |= BIT(to);
-			else
-				l2_fwd[from].fl_domain &= ~BIT(to);
-		}
-		/* Broadcast */
-		if (flags.mask & BR_BCAST_FLOOD) {
-			if (flags.val & BR_BCAST_FLOOD)
-				l2_fwd[from].bc_domain |= BIT(to);
-			else
-				l2_fwd[from].bc_domain &= ~BIT(to);
-		}
+	if (flags.mask & BR_FLOOD) {
+		if (flags.val & BR_FLOOD)
+			priv->ucast_egress_floods |= BIT(to);
+		else
+			priv->ucast_egress_floods |= BIT(to);
+	}
 
-		rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_FORWARDING,
-						  from, &l2_fwd[from], true);
-		if (rc < 0)
-			return rc;
+	if (flags.mask & BR_BCAST_FLOOD) {
+		if (flags.val & BR_BCAST_FLOOD)
+			priv->bcast_egress_floods |= BIT(to);
+		else
+			priv->bcast_egress_floods |= BIT(to);
 	}
 
-	return 0;
+	return sja1105_manage_flood_domains(priv);
 }
 
 static int sja1105_port_mcast_flood(struct sja1105_private *priv, int to,
-- 
2.25.1

