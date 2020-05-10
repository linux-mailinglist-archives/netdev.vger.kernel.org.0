Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B533E1CCC57
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 18:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgEJQns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 12:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729154AbgEJQnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 12:43:41 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883B6C061A0C;
        Sun, 10 May 2020 09:43:41 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id y3so7936796wrt.1;
        Sun, 10 May 2020 09:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=evCDaaGvKeikSrgDPwn+au2FyzoFxP/big4rQtX74Ik=;
        b=sChnG59u1yaACxcAAqbXQKYd/5879TmvYa9HMTnUiJh8wIIuPUuWR8PM45oX/iw9hM
         7roFQpREEBcUZlBai/R4AeuH0fOj3jmgoHvtF2hxAwdn1KQlQ8cXYu89YHRZfQuNfZP6
         J57pLgMXQ3J9s3mRiUk0t0TfnOCtNNnLuEVqDz92Al8pl16JyJuLJeYz3G8jpEOLWe73
         JGbmq7lDtJ2FqtxGk/qQ4OkWlS2L6YMKqZ5e7Zh5UvJGe/4SKOjxYGClN71j96hQzHP8
         8i0IexW91s27C9tisGNVl6Rg0rBruzgtQy47W83hWcjOFzKuvVwD/Y2oaepzzJLaCIUx
         1ebQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=evCDaaGvKeikSrgDPwn+au2FyzoFxP/big4rQtX74Ik=;
        b=JzoKOjcZOQg05Yu9VPAE2uvmJ/vWFCofq6cHZPtlknSB0joQWtqYm0dZJhjmRfKM2Y
         NoobPUdQVfLdrFCDeOnffHbFv4nNdeZT6ys8B58vJJdpfbgyOuwPAXrEAuleiuWshbCx
         kwIAsJ9zV7SND9E+K5n0z6wqL7kGmhEEJvMI9FuGOJc2a/HTB9jbdtoLTw6i53OaG0DP
         3fgJh3U1SEYHxy3XyI/afwLRGVhoKT+Z3L2Rxdjxnlwhqwiuu76AERkDYyvnJOG3rWJI
         35nNSnantC5R+x/iWVg2nXoImJ/fK7XNyNubjQoie8D1Cge+DzacrHJiiLZnGnAvFx50
         2KkQ==
X-Gm-Message-State: AGi0PuZOphe7xVZSd1904SMk1s1dMsjs44Av5jFs4xin+Huw/mtc8SlJ
        nPL8Og20UBa98kweEoUr+Xg=
X-Google-Smtp-Source: APiQypKvZULPbqkiOHxwi8Q3FbAwprrKJPa9dlEfLBsO78Dg1eitKGGp+xNfZI6IHPXwMOXbgz0cyw==
X-Received: by 2002:a5d:4bc6:: with SMTP id l6mr12735096wrt.112.1589129020265;
        Sun, 10 May 2020 09:43:40 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i1sm13390916wrx.22.2020.05.10.09.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 09:43:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/15] net: dsa: sja1105: add a new best_effort_vlan_filtering devlink parameter
Date:   Sun, 10 May 2020 19:42:51 +0300
Message-Id: <20200510164255.19322-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200510164255.19322-1-olteanv@gmail.com>
References: <20200510164255.19322-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This devlink parameter enables the handling of DSA tags when enslaved to
a bridge with vlan_filtering=1. There are very good reasons to want
this, but there are also very good reasons for not enabling it by
default. So a devlink param named best_effort_vlan_filtering, currently
driver-specific and exported only by sja1105, is used to configure this.

In practice, this is perhaps the way that most users are going to use
the switch in. It assumes that no more than 7 VLANs are needed per port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h      |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c | 117 ++++++++++++++++++++++++-
 2 files changed, 115 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index a019ffae38f1..1dcaecab0912 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -194,6 +194,7 @@ struct sja1105_bridge_vlan {
 
 enum sja1105_vlan_state {
 	SJA1105_VLAN_UNAWARE,
+	SJA1105_VLAN_BEST_EFFORT,
 	SJA1105_VLAN_FILTERING_FULL,
 };
 
@@ -201,6 +202,7 @@ struct sja1105_private {
 	struct sja1105_static_config static_config;
 	bool rgmii_rx_delay[SJA1105_NUM_PORTS];
 	bool rgmii_tx_delay[SJA1105_NUM_PORTS];
+	bool best_effort_vlan_filtering;
 	const struct sja1105_info *info;
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d298098232cb..4ea77e829d70 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2115,6 +2115,7 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	enum sja1105_vlan_state state;
 	struct sja1105_table *table;
 	struct sja1105_rule *rule;
+	bool want_tagging;
 	u16 tpid, tpid2;
 	int rc;
 
@@ -2147,6 +2148,8 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	if (!enabled)
 		state = SJA1105_VLAN_UNAWARE;
+	else if (priv->best_effort_vlan_filtering)
+		state = SJA1105_VLAN_BEST_EFFORT;
 	else
 		state = SJA1105_VLAN_FILTERING_FULL;
 
@@ -2154,6 +2157,8 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 		return 0;
 
 	priv->vlan_state = state;
+	want_tagging = (state == SJA1105_VLAN_UNAWARE ||
+			state == SJA1105_VLAN_BEST_EFFORT);
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
@@ -2167,8 +2172,10 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	general_params->incl_srcpt1 = enabled;
 	general_params->incl_srcpt0 = enabled;
 
+	want_tagging = priv->best_effort_vlan_filtering || !enabled;
+
 	/* VLAN filtering => independent VLAN learning.
-	 * No VLAN filtering => shared VLAN learning.
+	 * No VLAN filtering (or best effort) => shared VLAN learning.
 	 *
 	 * In shared VLAN learning mode, untagged traffic still gets
 	 * pvid-tagged, and the FDB table gets populated with entries
@@ -2187,7 +2194,7 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	 */
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
 	l2_lookup_params = table->entries;
-	l2_lookup_params->shared_learn = !enabled;
+	l2_lookup_params->shared_learn = want_tagging;
 
 	rc = sja1105_static_config_reload(priv, SJA1105_VLAN_FILTERING);
 	if (rc)
@@ -2195,9 +2202,10 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	/* Switch port identification based on 802.1Q is only passable
 	 * if we are not under a vlan_filtering bridge. So make sure
-	 * the two configurations are mutually exclusive.
+	 * the two configurations are mutually exclusive (of course, the
+	 * user may know better, i.e. best_effort_vlan_filtering).
 	 */
-	return sja1105_setup_8021q_tagging(ds, !enabled);
+	return sja1105_setup_8021q_tagging(ds, want_tagging);
 }
 
 bool sja1105_can_use_vlan_as_tags(struct dsa_switch *ds)
@@ -2288,6 +2296,100 @@ static int sja1105_vlan_del(struct dsa_switch *ds, int port,
 	return sja1105_build_vlan_table(priv, true);
 }
 
+static int sja1105_best_effort_vlan_filtering_get(struct sja1105_private *priv,
+						  bool *be_vlan)
+{
+	*be_vlan = priv->best_effort_vlan_filtering;
+
+	return 0;
+}
+
+static int sja1105_best_effort_vlan_filtering_set(struct sja1105_private *priv,
+						  bool be_vlan)
+{
+	struct dsa_switch *ds = priv->ds;
+	bool vlan_filtering;
+	int port;
+	int rc;
+
+	vlan_filtering = dsa_port_is_vlan_filtering(dsa_to_port(ds, 0));
+	priv->best_effort_vlan_filtering = be_vlan;
+
+	rtnl_lock();
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!dsa_is_user_port(ds, port))
+			continue;
+		rc = sja1105_vlan_filtering(ds, port, vlan_filtering);
+		if (rc)
+			break;
+	}
+	rtnl_unlock();
+
+	return rc;
+}
+
+enum sja1105_devlink_param_id {
+	SJA1105_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING,
+};
+
+static int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct sja1105_private *priv = ds->priv;
+	int err;
+
+	switch (id) {
+	case SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING:
+		err = sja1105_best_effort_vlan_filtering_get(priv,
+							     &ctx->val.vbool);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int sja1105_devlink_param_set(struct dsa_switch *ds, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct sja1105_private *priv = ds->priv;
+	int err;
+
+	switch (id) {
+	case SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING:
+		err = sja1105_best_effort_vlan_filtering_set(priv,
+							     ctx->val.vbool);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static const struct devlink_param sja1105_devlink_params[] = {
+	DSA_DEVLINK_PARAM_DRIVER(SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING,
+				 "best_effort_vlan_filtering",
+				 DEVLINK_PARAM_TYPE_BOOL,
+				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
+};
+
+static int sja1105_setup_devlink_params(struct dsa_switch *ds)
+{
+	return dsa_devlink_params_register(ds, sja1105_devlink_params,
+					   ARRAY_SIZE(sja1105_devlink_params));
+}
+
+static void sja1105_teardown_devlink_params(struct dsa_switch *ds)
+{
+	dsa_devlink_params_unregister(ds, sja1105_devlink_params,
+				      ARRAY_SIZE(sja1105_devlink_params));
+}
+
 /* The programming model for the SJA1105 switch is "all-at-once" via static
  * configuration tables. Some of these can be dynamically modified at runtime,
  * but not the xMII mode parameters table.
@@ -2354,6 +2456,10 @@ static int sja1105_setup(struct dsa_switch *ds)
 	ds->mtu_enforcement_ingress = true;
 	ds->vlan_bridge_vtu = true;
 
+	rc = sja1105_setup_devlink_params(ds);
+	if (rc < 0)
+		return rc;
+
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
 	 * a bridge, so it's safe to set up switch tagging at this time.
@@ -2376,6 +2482,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 			kthread_destroy_worker(sp->xmit_worker);
 	}
 
+	sja1105_teardown_devlink_params(ds);
 	sja1105_flower_teardown(ds);
 	sja1105_tas_teardown(ds);
 	sja1105_ptp_clock_unregister(ds);
@@ -2717,6 +2824,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.cls_flower_stats	= sja1105_cls_flower_stats,
 	.crosschip_bridge_join	= sja1105_crosschip_bridge_join,
 	.crosschip_bridge_leave	= sja1105_crosschip_bridge_leave,
+	.devlink_param_get	= sja1105_devlink_param_get,
+	.devlink_param_set	= sja1105_devlink_param_set,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
-- 
2.17.1

