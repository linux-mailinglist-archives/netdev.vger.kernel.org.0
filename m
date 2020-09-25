Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE9927947A
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgIYXEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:04:39 -0400
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:28545
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbgIYXEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 19:04:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3moGTDrtGlrqM9+7n/xmY2ynamkmAoNTwz8bxUWbtYsTWt2PKyoBJ5Dg2bm23nE5JwcRnZs8KlCS0tSvUBvoAzRPnHM1L03LRy03ywKFWZW7m63yY+kc54z7Qve6cyYojDvnh1kbn9SzY7qKZqBjnNoY7+HWMkY3GKHpOlIgxlo3gdmeA50NDWHlx6mSa0cCWbpG5sh5MjTEtY4dVEiQB8F3RbZgboGw1xXbD9VWnM+KEF+PoVEOat4yLNq6WgRF3qEuoW5Wv9LCyPyFh7GRgn9iY0LQMOQNUEO7I11JdU+pBrhQDmvcKn6KbpamY59WHQDu39WkHOIgzhwsAR4eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7e+qcOdPYbP1hHz2Qlnf7SSHkQMBABCIsTnkdfJgG4=;
 b=B/9cOnTBCH5dx2KwPZLSQYFEKLnOj4IkzWzpKtSwMUT76qScO24/A73bNNVVRcox47LejA7rkeisimvMBQFDbeW+OVBcXYbfGGv3KqlA7RhErSZi7teZ24675pXJ1bsSqtv16YHm8ctbjtkpazr4TdwlKNzYRlTIMZNkyTTKez++Zksmb+nmOtnQrRJ9hdtLVypUrNJ9qk8NbLpe9Qf7jkoKNaHNMAR4FxkbyeIb2J62P4wmlfyhti+j7zeEwx3U6Dp0aindM602uIPM3GxttsNUqrvBsiSMCXK28dyKz6WcGPz6SMS93YUDgELNATfQBH2zXInGHTomv77RDe4fbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7e+qcOdPYbP1hHz2Qlnf7SSHkQMBABCIsTnkdfJgG4=;
 b=KFMo+SfOGq2F8woG17m2+YH32X4FNfTmq9GCoHsSMt3UnT5NEcQ97yzNL7N2m4FiIP68E97zGoBhvWcVFwS+/tr+8R6B6X9N1H+uMY8MXwA260FRYvKnn2Zq4kltRXwWhYRrvT3K2HQf3PPTZqcyx4ChQUoRbx4qF3hvgyrFUKc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3968.eurprd04.prod.outlook.com (2603:10a6:803:3d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Fri, 25 Sep
 2020 23:04:35 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 23:04:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, cphealy@gmail.com, jiri@nvidia.com
Subject: [PATCH v2 net-next 1/3] net: dsa: sja1105: move devlink param code to sja1105_devlink.c
Date:   Sat, 26 Sep 2020 02:04:19 +0300
Message-Id: <20200925230421.711991-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925230421.711991-1-vladimir.oltean@nxp.com>
References: <20200925230421.711991-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0169.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::26) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1PR06CA0169.eurprd06.prod.outlook.com (2603:10a6:803:c8::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Fri, 25 Sep 2020 23:04:34 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3510b7f2-98b7-456e-5f4e-08d861a75e5b
X-MS-TrafficTypeDiagnostic: VI1PR04MB3968:
X-Microsoft-Antispam-PRVS: <VI1PR04MB396888AE948D88D37C9A8A9DE0360@VI1PR04MB3968.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: viPxXmo9j/ZIXQy92d1ZqoHTaooEOXauEjQA1Utn4CRV4+irdNskYt452+SzyTTJQW1aO/v1pTsaci2DomObQgXH+Uml3hbezGXfBD6kZ33SrxYDjC8//QjJZHikjAv9kYPdyfjYiFTNbliQhFeMAzLgdRttbnybMNvlPa6/fx+HWNGCyGYuDFq3MW/31M1lRX27J+nTrxMiRm5rH79Xbqg3ync/xwibrbQRbP6fkKWtCNK8eLK3X3ByQet7J86s9A9j6zU4icqQE0tYIMb68a7qQn0yrlM+2DDSQPsotYCrqiAL035GZYVU6tyGYpE1e1UOLIpFDuFS/pcJoTvtSoYmcsQrlIBk16hAc2nDVuJxpQEu7TYY6Zd6eKq7qCPOtEDI7RdpWnIhPjB++2GvvvGimmpeWKO0XPpZIAVCgIr4LTCoBJZN5opT3jj+i6Wv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(346002)(366004)(136003)(478600001)(5660300002)(83380400001)(86362001)(66946007)(69590400008)(1076003)(316002)(6506007)(52116002)(16526019)(6512007)(36756003)(66476007)(66556008)(2906002)(44832011)(6666004)(8936002)(8676002)(26005)(4326008)(2616005)(956004)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jhYtkdoHknMUVNaA2oG/mckkG/XJcTlZirR1DRm+Z+H7bMf0tEFRdRa/RSVCFN1xJH6eLGKp+zyGN1USV8Y5aR4iMIa/B+Y+M8sStxaDAoUGT9EhgPFLReOh82FosVtomLtAOk9jF9aGlF0rajXgBZQ4aMRH+gq9Qcikqk/oAq4PwfFaCJZlb/6Gc/N2I5S89/VFo1T7b+Nkosu2IxGNSL/AirPpEpf61DpxiU3pHCqtJRonn+7UI5LIfusqL9sNQAHUZrZtfWoCk26yPVMbHAXRooYD/h3vgrS3vH28M5d3EfMf8XPHp0Ua6hTZBfepdejcN0jd+9hMoyPPZ92CEJ7MvXV1spTatauyTRNd1YnOZUvPemM66aNMxVau0i1fuoB4qf4pzVUYL76mTP/VAVDWDbZx55btp1kcWbIqkgEsgXivFRu5wXwWWeUdrH5VFxtNFrmM0uVhR7SADpv41/3+eH4Pqu1LKqtMPIgeUxS/S4ovdR3GVUhHUuCiE5rLTJYCVuFmQb04D+aoun5pFoejNzS06uwsq+KBh6xUFsxM3ldFX9eYHjclwD12jyVmTmXz2nyZSqaFQDF/RU1apzHHVmSyg6ZgIg9++ktw6edzpZ6r5kDKnt+Mzw+w/1molEYyLRMW0YrLhbgd+ZzGew==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3510b7f2-98b7-456e-5f4e-08d861a75e5b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 23:04:35.2349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q64mp8kiCpAHSNWZPZPGmo3SDtqKi/V+j16jt6GXcV3knMVwIwchhHHaLdvdxDTELZJS4tj/KwpRcUeA8pcRgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll have more devlink code soon. Group it together in a separate
translation object.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

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

