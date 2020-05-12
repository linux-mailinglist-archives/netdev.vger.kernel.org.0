Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088D51CFBEA
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbgELRVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730703AbgELRU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:20:58 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC97C061A0F;
        Tue, 12 May 2020 10:20:58 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u16so24383350wmc.5;
        Tue, 12 May 2020 10:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tWyi81GBhF+5vlHILrKFoCNS7Q2uZx7X1aWEwxXZH/E=;
        b=gFMvHAOoGXdTMOuuyJ4l1ZJZ7BI7oMl6jH466Qx2sKwCIjTMLrB3Mw7WSXZPvxogOv
         Yut6wU6UclrRymgkloACNxCPDk2Rk99zQOfnW15zbl4HgoiO+BB/0A1c3WNeobsHPzBM
         /fUxs37Ujzw1r/MGR+1p2q6jXURnLiAjvo/B+aL3vxl4kd7CmZeB/Eh7qf6Lbyd9cpbT
         avbQIYLfd0GSWQR6EgZMjsyn9JmQcc93SqaPSU3I9L2TaNvC+wuxhaUk/nHmSHE9hG3G
         nkwZVHH8vnyRMqLcUL82ih8hEVvKqEpZUcBqGq4f9+MkspDLiEdjzvkCQzibeoIyD5PG
         BuYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tWyi81GBhF+5vlHILrKFoCNS7Q2uZx7X1aWEwxXZH/E=;
        b=IwJDSZhPDPkjESNU1CwEIEuH4AkbeYZrspKlKYmTNtoyrVm/5EHi9opH/6UoSQoOF+
         6nPw2/4GSEQcgWrkDGtcZ2oVLMNo5WddHyDX8NbDQg5A3HIJUR57Qo3TKxqd4aiPDmLO
         eRi1iZiyISesPV85guSJF2KrArnVkcPwbPmlQ2XNnSeSo2hXZphSQRm87RsFYsDl+VZp
         FMFtA0dNMHRUZK3cikme/ah93aNdRdm9PGELzZm5HPJF4qNrpKMWxWPSPQv/CMvLY/CN
         p9ubvJ7VoSJ++PzaSvlnjcOBCB2xYYmT5xlm/yNIwsOblG8bmiMTfcC6H5f673B7oug+
         nkrA==
X-Gm-Message-State: AOAM533t5Beox1OsRVurc7h7D8UhDJmMBYmYRmS33ZPK/wS70FneEUyT
        oWexlBKobuoZFAoNhImGoa8=
X-Google-Smtp-Source: ABdhPJxwdsIdmFrwDpUGc8F+y7kdMwBJzbsRoXEx+ehPXrG4G7hfWt8vhh+9iYwp5JygXLUlqU44Qg==
X-Received: by 2002:a7b:cf14:: with SMTP id l20mr4374383wmg.100.1589304057061;
        Tue, 12 May 2020 10:20:57 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id a15sm23999743wrw.56.2020.05.12.10.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:20:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 11/15] net: dsa: sja1105: add a new best_effort_vlan_filtering devlink parameter
Date:   Tue, 12 May 2020 20:20:35 +0300
Message-Id: <20200512172039.14136-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200512172039.14136-1-olteanv@gmail.com>
References: <20200512172039.14136-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
- In sja1105_best_effort_vlan_filtering_set, get the vlan_filtering
  value of each port instead of just one time for port 0. Normally this
  shouldn't matter, but it avoids issues when port 0 is disabled in
  device tree.

 drivers/net/dsa/sja1105/sja1105.h      |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c | 122 ++++++++++++++++++++++++-
 2 files changed, 120 insertions(+), 4 deletions(-)

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
index fd15a18596ea..775a6766288e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2132,6 +2132,7 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	enum sja1105_vlan_state state;
 	struct sja1105_table *table;
 	struct sja1105_rule *rule;
+	bool want_tagging;
 	u16 tpid, tpid2;
 	int rc;
 
@@ -2164,6 +2165,8 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	if (!enabled)
 		state = SJA1105_VLAN_UNAWARE;
+	else if (priv->best_effort_vlan_filtering)
+		state = SJA1105_VLAN_BEST_EFFORT;
 	else
 		state = SJA1105_VLAN_FILTERING_FULL;
 
@@ -2171,6 +2174,8 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 		return 0;
 
 	priv->vlan_state = state;
+	want_tagging = (state == SJA1105_VLAN_UNAWARE ||
+			state == SJA1105_VLAN_BEST_EFFORT);
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 	general_params = table->entries;
@@ -2184,8 +2189,10 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
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
@@ -2204,7 +2211,7 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	 */
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
 	l2_lookup_params = table->entries;
-	l2_lookup_params->shared_learn = !enabled;
+	l2_lookup_params->shared_learn = want_tagging;
 
 	rc = sja1105_static_config_reload(priv, SJA1105_VLAN_FILTERING);
 	if (rc)
@@ -2212,9 +2219,10 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	/* Switch port identification based on 802.1Q is only passable
 	 * if we are not under a vlan_filtering bridge. So make sure
-	 * the two configurations are mutually exclusive.
+	 * the two configurations are mutually exclusive (of course, the
+	 * user may know better, i.e. best_effort_vlan_filtering).
 	 */
-	return sja1105_setup_8021q_tagging(ds, !enabled);
+	return sja1105_setup_8021q_tagging(ds, want_tagging);
 }
 
 static void sja1105_vlan_add(struct dsa_switch *ds, int port,
@@ -2297,6 +2305,105 @@ static int sja1105_vlan_del(struct dsa_switch *ds, int port,
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
+	priv->best_effort_vlan_filtering = be_vlan;
+
+	rtnl_lock();
+	for (port = 0; port < ds->num_ports; port++) {
+		struct dsa_port *dp;
+
+		if (!dsa_is_user_port(ds, port))
+			continue;
+
+		dp = dsa_to_port(ds, port);
+		vlan_filtering = dsa_port_is_vlan_filtering(dp);
+
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
@@ -2364,6 +2471,10 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 	ds->configure_vlan_while_not_filtering = true;
 
+	rc = sja1105_setup_devlink_params(ds);
+	if (rc < 0)
+		return rc;
+
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
 	 * a bridge, so it's safe to set up switch tagging at this time.
@@ -2387,6 +2498,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 			kthread_destroy_worker(sp->xmit_worker);
 	}
 
+	sja1105_teardown_devlink_params(ds);
 	sja1105_flower_teardown(ds);
 	sja1105_tas_teardown(ds);
 	sja1105_ptp_clock_unregister(ds);
@@ -2738,6 +2850,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.cls_flower_stats	= sja1105_cls_flower_stats,
 	.crosschip_bridge_join	= sja1105_crosschip_bridge_join,
 	.crosschip_bridge_leave	= sja1105_crosschip_bridge_leave,
+	.devlink_param_get	= sja1105_devlink_param_get,
+	.devlink_param_set	= sja1105_devlink_param_set,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
-- 
2.17.1

