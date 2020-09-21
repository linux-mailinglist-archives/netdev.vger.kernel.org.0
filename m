Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB48272C37
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgIUQ2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:28:38 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:34958
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727323AbgIUQ2h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 12:28:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJWk02lUZmb3s3Y7+9lj3vr2VDAxag0kZpcit9zX0mCULNGpSrd2yigXLMR1QeiqNnADNIqZfmcMncTnqmemv3bN5PYSsuzseZBBOO6829dyvZb8hMP0QSuFnN19lqXY0x7WwP3r8X32PIOAQcbu8ara28QNXiRbHgFjZCBuihB9yLWRJ+EMB6XifIJx/5qc0nfrZFbHmroDT4ebYWrqD+Yq0rWUq7DJv1hTlDmzHU4Ryx67pA4T45G8gxduMrZsHwqIBwCkpvxU2Eu2YxQ1Z5en3RBAoovV56218DLnsaVZrhfm0adf6hGfhVkYSDhJXgdXbbocxGYUfc+uknZadQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuI3t0NbsZ6TcJju2KzY7n/GSNH2Nx4dQfkBN/akVQc=;
 b=Sw3p4ZdxJm02YfIgY5LTptgzSP/QZ5WvNg5rF1LUMUq4Rw4HdyekWrMqiliGGWq5MieQjxC0kTP9NS+8Yvd4Hxj+FN2IJKyjfcThe/Ghf8hs/myNyB753IO1K90GhwEJYUGfVQ1ICkd863C3diUC9oCPbPonteRa+hzRogXuv9J4pawCIOhVBlNr5rDodeHWfW/omT9OSLXINGDQGSvDIyO94xQhpF5V+D98+m1qqOcWwUzfG/LvM0fxiZv4AIf2FDE/rv+V6/qIduwb1aauOlJNlxGN1olsDTed/6EicQAm60Z9sf1mf/IBXo9MdPtFcQ103rfeeq/XCZmMqyFJpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuI3t0NbsZ6TcJju2KzY7n/GSNH2Nx4dQfkBN/akVQc=;
 b=rvZZO++Xu47htO/tQShUIpaPFjhaHCQjc9Lh5rMGxlXPQCcmOD2IZon4LLcnkcYG38QkHuE1wd8CBSUgB5LIv4xDvIbUWgcfqtjsicDhk9hzIowH4GOhCmCGZLhfnxaSN97BP1DH5fhwIBJTh8BobgvpgeFdnkXCtKib8AHGtq4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Mon, 21 Sep
 2020 16:28:30 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 16:28:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, cphealy@gmail.com, jiri@nvidia.com
Subject: [PATCH net-next 1/2] net: dsa: sja1105: move devlink param code to sja1105_devlink.c
Date:   Mon, 21 Sep 2020 19:27:40 +0300
Message-Id: <20200921162741.4081710-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921162741.4081710-1-vladimir.oltean@nxp.com>
References: <20200921162741.4081710-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P18901CA0003.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::13) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1P18901CA0003.EURP189.PROD.OUTLOOK.COM (2603:10a6:801::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 16:28:29 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3bfe4d59-27ed-4593-6930-08d85e4b6029
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-Microsoft-Antispam-PRVS: <VE1PR04MB73435FCEB09088DB8CB7C39DE03A0@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gRndmuFwM/OzY6bzEcaE9Zfw6Ky8sBBmAGvaZ2YXJgwmU1HAEi4+VnUoshActlgz+n+Kfr2PXeZgXhkB8m1CeeLQqgAvGSSMlRwW3SXEXw0WKTw82LLLM9HUxDhy8ZrajIjjz2pr+G7afIZHZsczRu+PmQZRIcOoAHUpL0ZOsO4UYjAIU1PDkg+TuaiVRRAucrYAjNQQWlVHW/6FfNDLsyM2PQzfe/JnyAELZ5m75f2ieG3L7w3aZG4d5Mg0OxsCX5tXj+1w+w9WVDwpI/aW+P8fpQ+ISV9KhDAoM+zXjYxLt9qeVSoHlMvC7gNj5ZiqvTz3jkcdZtE62Pn4Kh38hWVlcGnESx3+HbOEgXS1iz95wI2lLUuQsxLG0C0V+/Zi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(8676002)(1076003)(16526019)(186003)(2906002)(26005)(66556008)(66476007)(6512007)(66946007)(5660300002)(8936002)(69590400008)(2616005)(956004)(316002)(86362001)(36756003)(44832011)(6506007)(83380400001)(6666004)(52116002)(6486002)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nHwcBvAQtaN8PcysnbS9Grs7SrWHyTKxPXtfjgxL5CmFnF0TDPIoOSXLPzeaT7WvcO3OHk/mK0y6RfamEkuIrlk8TVFMHDzFpDcxotA2JA11FmqWD+KyY7kUYCaItmmATS0/wkFOcHcZfzymC/JT/sKMS21AAepL4XHS2y469g77b45zqCt/lnCsN7IB2e3Sm8gRKbe+WGlW6BSu+bi7jpt7c6XlfwdQz8sPKqN1xC+9GCnl1n8N1a+M87DmewpQ3QVV2RM4EHw/3tmGOFZ5wp6mClY1JaF8wmbnO989HCBc0Sd8sdKYXGtjIyb7sZARpSRuTm3k0bkbCnLoLAv9AqTt9pO4NVtdSPo3a3bY5uZEPoyQfxBJmasfm5nlWt2Mxou4mj1kCOcW87+Lpw3A3Z7XvcqCc8T+Xk2MRQdwWVApYDqaQpo+MMW27p1PqHXP6REDlSUyvxBzviIn+SkkRlAI5hDc1pMMBa1scxzVke0FZagbOqnelyS3fNyg0hybhgVV73M9vS5XxVkO1OIJ1na9PvGOpmgrUXWe+ZwsVr29BxNuSOGqGtq9sHV1DlMsxaullWGqECNZaNaKm6qVGMysaIr3E6d1hrp3ixKVFKuD7+QXqw6NMyEXWGRmVLC0QYCHuQ2qukWVPsBv6IN29A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bfe4d59-27ed-4593-6930-08d85e4b6029
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 16:28:30.3269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVE2CeUA3lAcABWZao0BMfG5DOyYUzJqz4/nlYB8Y5jnfm7uTgaC+6mw/A/wBsLpYjdHOvb6Br86mtWUnKhZuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll have more devlink code soon. Group it together in a separate
translation object.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/Makefile          |   1 +
 drivers/net/dsa/sja1105/sja1105.h         |  10 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c | 119 ++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_main.c    | 105 +------------------
 4 files changed, 132 insertions(+), 103 deletions(-)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_devlink.c

diff --git a/drivers/net/dsa/sja1105/Makefile b/drivers/net/dsa/sja1105/Makefile
index c88e56a29db8..a860e3a910be 100644
--- a/drivers/net/dsa/sja1105/Makefile
+++ b/drivers/net/dsa/sja1105/Makefile
@@ -6,6 +6,7 @@ sja1105-objs := \
     sja1105_main.o \
     sja1105_flower.o \
     sja1105_ethtool.o \
+    sja1105_devlink.o \
     sja1105_clocking.o \
     sja1105_static_config.o \
     sja1105_dynamic_config.o \
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index a93f580b558a..d043332cbc02 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -244,9 +244,17 @@ enum sja1105_reset_reason {
 
 int sja1105_static_config_reload(struct sja1105_private *priv,
 				 enum sja1105_reset_reason reason);
-
+int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled);
 void sja1105_frame_memory_partitioning(struct sja1105_private *priv);
 
+/* From sja1105_devlink.c */
+int sja1105_devlink_setup(struct dsa_switch *ds);
+void sja1105_devlink_teardown(struct dsa_switch *ds);
+int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
+			      struct devlink_param_gset_ctx *ctx);
+int sja1105_devlink_param_set(struct dsa_switch *ds, u32 id,
+			      struct devlink_param_gset_ctx *ctx);
+
 /* From sja1105_spi.c */
 int sja1105_xfer_buf(const struct sja1105_private *priv,
 		     sja1105_spi_rw_mode_t rw, u64 reg_addr,
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
new file mode 100644
index 000000000000..03454638c5a8
--- /dev/null
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
+ */
+#include "sja1105.h"
+
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
+int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
+			      struct devlink_param_gset_ctx *ctx)
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
+int sja1105_devlink_param_set(struct dsa_switch *ds, u32 id,
+			      struct devlink_param_gset_ctx *ctx)
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
+int sja1105_devlink_setup(struct dsa_switch *ds)
+{
+	int rc;
+
+	rc = sja1105_setup_devlink_params(ds);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+void sja1105_devlink_teardown(struct dsa_switch *ds)
+{
+	sja1105_teardown_devlink_params(ds);
+}
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 4a298729937b..de4773e99549 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2634,7 +2634,7 @@ static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
  * which can only be partially reconfigured at runtime (and not the TPID).
  * So a switch reset is required.
  */
-static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
+int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 {
 	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
 	struct sja1105_general_params_entry *general_params;
@@ -2864,105 +2864,6 @@ static const struct dsa_8021q_ops sja1105_dsa_8021q_ops = {
 	.vlan_del	= sja1105_dsa_8021q_vlan_del,
 };
 
-static int sja1105_best_effort_vlan_filtering_get(struct sja1105_private *priv,
-						  bool *be_vlan)
-{
-	*be_vlan = priv->best_effort_vlan_filtering;
-
-	return 0;
-}
-
-static int sja1105_best_effort_vlan_filtering_set(struct sja1105_private *priv,
-						  bool be_vlan)
-{
-	struct dsa_switch *ds = priv->ds;
-	bool vlan_filtering;
-	int port;
-	int rc;
-
-	priv->best_effort_vlan_filtering = be_vlan;
-
-	rtnl_lock();
-	for (port = 0; port < ds->num_ports; port++) {
-		struct dsa_port *dp;
-
-		if (!dsa_is_user_port(ds, port))
-			continue;
-
-		dp = dsa_to_port(ds, port);
-		vlan_filtering = dsa_port_is_vlan_filtering(dp);
-
-		rc = sja1105_vlan_filtering(ds, port, vlan_filtering);
-		if (rc)
-			break;
-	}
-	rtnl_unlock();
-
-	return rc;
-}
-
-enum sja1105_devlink_param_id {
-	SJA1105_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
-	SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING,
-};
-
-static int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
-				     struct devlink_param_gset_ctx *ctx)
-{
-	struct sja1105_private *priv = ds->priv;
-	int err;
-
-	switch (id) {
-	case SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING:
-		err = sja1105_best_effort_vlan_filtering_get(priv,
-							     &ctx->val.vbool);
-		break;
-	default:
-		err = -EOPNOTSUPP;
-		break;
-	}
-
-	return err;
-}
-
-static int sja1105_devlink_param_set(struct dsa_switch *ds, u32 id,
-				     struct devlink_param_gset_ctx *ctx)
-{
-	struct sja1105_private *priv = ds->priv;
-	int err;
-
-	switch (id) {
-	case SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING:
-		err = sja1105_best_effort_vlan_filtering_set(priv,
-							     ctx->val.vbool);
-		break;
-	default:
-		err = -EOPNOTSUPP;
-		break;
-	}
-
-	return err;
-}
-
-static const struct devlink_param sja1105_devlink_params[] = {
-	DSA_DEVLINK_PARAM_DRIVER(SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING,
-				 "best_effort_vlan_filtering",
-				 DEVLINK_PARAM_TYPE_BOOL,
-				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
-};
-
-static int sja1105_setup_devlink_params(struct dsa_switch *ds)
-{
-	return dsa_devlink_params_register(ds, sja1105_devlink_params,
-					   ARRAY_SIZE(sja1105_devlink_params));
-}
-
-static void sja1105_teardown_devlink_params(struct dsa_switch *ds)
-{
-	dsa_devlink_params_unregister(ds, sja1105_devlink_params,
-				      ARRAY_SIZE(sja1105_devlink_params));
-}
-
 /* The programming model for the SJA1105 switch is "all-at-once" via static
  * configuration tables. Some of these can be dynamically modified at runtime,
  * but not the xMII mode parameters table.
@@ -3030,7 +2931,7 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 	ds->configure_vlan_while_not_filtering = true;
 
-	rc = sja1105_setup_devlink_params(ds);
+	rc = sja1105_devlink_setup(ds);
 	if (rc < 0)
 		return rc;
 
@@ -3061,7 +2962,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 			kthread_destroy_worker(sp->xmit_worker);
 	}
 
-	sja1105_teardown_devlink_params(ds);
+	sja1105_devlink_teardown(ds);
 	sja1105_flower_teardown(ds);
 	sja1105_tas_teardown(ds);
 	sja1105_ptp_clock_unregister(ds);
-- 
2.25.1

