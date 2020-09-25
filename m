Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B0627947B
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgIYXEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:04:43 -0400
Received: from mail-eopbgr80051.outbound.protection.outlook.com ([40.107.8.51]:28545
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729041AbgIYXEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 19:04:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmQD6gMmRGpLkuzwcJC5NuW4pE3dp0mrh1oOGY3h2zRWHeInNkW7NKOK+hYMIUZCIXqdmWWZoumBR+Dh95Yxo1zUoQSYupTIG+ziez84WzvwIpn+F6KRKd1jkbhsyzCHyhDR6w1GLMenvtlSlz9SGKXDGoYRdt8rtdmV7J1Yfbu0NO4kqQaVSxUvweR5SgMNVML08qmYsybWoFRaXSBw/JQjWm0nE2WcKU3DROMV03WxK3PR3uudfH6OSFLpBPkNh/EBOdP6pwbmZ7drN2e9dMO7WU9ujVsWinyZOKO2gEEcx66YZT2aDmujWNv4qzPUOaB2rb/bC0Xq0hu/ma/FeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJpB5dKI/Wr3seU9Zhm5kK7xYA2mT73bluT6Ttr75YM=;
 b=n4irUb0V989/mo+cZBqr+UPJ16sdeByFQ+jsYUXPlle6eG4APT6sV0hWca+8UftHXs+FhBAOo1hu5W2O9PP+he1PGIfY8+B3m0reuVsoPizxPgFUrRFUQ6Wmju/6GrvjulRZ56fP6OPJWmhcX9wqCXg5q1NhZHmoQZOQ9MEYjt3oDBkU2ZTA5hhtL9JXbjVODTiEDEKnBvN3r6DMwrTOYn5s1CELuaSAVpIBdF9aJAGGbyzYafPoEbhx8jugd0Vrfm3xsdG7cALatiEO+rbNSqGKQ8gwd7My5JlHn1MgkUkuL6T/WuhcaI2LfYu7hk2lPe0jkdNl+hpArfLXLMJykw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJpB5dKI/Wr3seU9Zhm5kK7xYA2mT73bluT6Ttr75YM=;
 b=YctCcHItMmsb4gPVPsTHCIzOorGwzUK9MvI9ugDgu2zk7uw6v69Vfp5ZfYKlZOKe8djv0NdY+LxTIkITnudrXJnISTHeKmzFpE0HE+dX51jPGNNdfIJ2cm3ZYgspMi12cdWzkCzcd1A0idmB44KTSMST4tM55TJHrI58CYxz1MU=
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
Subject: [PATCH v2 net-next 2/3] net: dsa: sja1105: expose static config as devlink region
Date:   Sat, 26 Sep 2020 02:04:20 +0300
Message-Id: <20200925230421.711991-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by VI1PR06CA0169.eurprd06.prod.outlook.com (2603:10a6:803:c8::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Fri, 25 Sep 2020 23:04:35 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 734220e5-9007-42fd-9350-08d861a75f1e
X-MS-TrafficTypeDiagnostic: VI1PR04MB3968:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3968B65C968FCC08170996B2E0360@VI1PR04MB3968.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXuZa2HuyL3891hEsPhtf1k/LJEpGxVhKNbhEm9VzL1dOfOv49qkot9IDZOSsx9im4WEgOaEifGQJom5I96Z1r6mnrGKdXXl2BfdnrvVSzrSxQfNn8iAnQKRzXo8hkC7uq4tQN9q3Kn/y19DfP3A0g/SLr52g2W6FrFyoDDuDD59Ulz57by099F/AXvQLnUOWPWVJR2MItjP6TEz/Nc842/iU4wiN5cN22X5aScLIk/ZavL+FANoIKIt2O7PSKhlzmllKh+mA5oDOQS5o3dwTADhFcYmLYuleKmYqqpTIY6sGqdXzFnkGm+c+uDnS21HE4BbksNzZz48J7bBF9bCKTEzlninIY2VMTGyaKcFw1Zx+si1nVvkF48NeUPFAph+u1bNSxfJQMu7K2a+z6WgMI5cRO5Vx0MENI7nKKo6xm4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(346002)(366004)(136003)(478600001)(5660300002)(83380400001)(86362001)(66946007)(69590400008)(1076003)(316002)(6506007)(52116002)(16526019)(6512007)(36756003)(66476007)(66556008)(2906002)(44832011)(6666004)(8936002)(8676002)(26005)(4326008)(2616005)(956004)(6486002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 06rpRpZ2rAFrzTgOYAVQt3PPPImFM686ljrrD2YrNAAAyfxJ0k4NahA0ie3DrnC0YyPBl7Idmwp8RkuMLrK5V0qgosdyKjg5s7NBmLOi5Qi2I0jmulDFDbDQB4G0WbX9ltQU4ogKofDYm/favBMnyOBwcJMSduIW/7i/MPJI5iduwNKV8oOp/vrUOrN6KqjIQhQm3HYOoRPLvwonmV8Hl2QmX5VEGtnrLEZRlOsiUQABUf+E/rixuJOzTNfSpNn/LSkP/r1k8hFjHDBpeOPau/cIotYU0fxl0feuc6OHKccLuS+U9UIRyhEeXMxfUsbtHZ/Tzln22DyZO/5HCS0t2ANPPPg+O7CiR++VAoC1RpCBZT6M9RmMKxCkDijxEGfnhzm48fucWcj2HKfyaMPJcEGV1gfT8BCjjb6MR5NPW0l3Ooqb/FNNaWyCIGCwHUGOOAW7ZdigpKyBjFRF+xH0WRHRuU5NUbc7rQ9HeGGFIBhgErIj8GE7L151dJeervwzLNAOzFdllSmKONYJT3dyfby+jLcprFVJFuz3HLy6xnbLmapMJk18Xqhp9En4Zhb1iurYZOdeadKB63TPaAtOjBWvd4QrC2NXNtXjjVtK0YMiHM+sJ8KXqEO3gyCl5AkadBnRZmZsYacVN+KcfWNRhw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 734220e5-9007-42fd-9350-08d861a75f1e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 23:04:35.8435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPbUvXG9z7uF04KUyJvQkdnvuDk+JZ1w7X9t7yl2wfL0rpTPUQ/h3aoYhCWXaDe/r/C5Wt8+79Nz25dFi8B5IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As explained in Documentation/networking/dsa/sja1105.rst, this switch
has a static config held in the driver's memory and re-uploaded from
time to time into the device (after any major change).

The format of this static config is in fact described in UM10944.pdf and
it contains all the switch's settings (it also contains device ID, table
CRCs, etc, just like in the manual). So it is a useful and universal
devlink region to expose to user space, for debugging purposes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Tear down devlink params on initialization failure.

 drivers/net/dsa/sja1105/sja1105.h         |   3 +
 drivers/net/dsa/sja1105/sja1105_devlink.c | 119 ++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c     |   5 +-
 3 files changed, 124 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index d043332cbc02..4af70f619d8e 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -218,6 +218,7 @@ struct sja1105_private {
 	struct mutex mgmt_lock;
 	struct dsa_8021q_context *dsa_8021q_ctx;
 	enum sja1105_vlan_state vlan_state;
+	struct devlink_region **regions;
 	struct sja1105_cbs_entry *cbs;
 	struct sja1105_tagger_data tagger_data;
 	struct sja1105_ptp_data ptp_data;
@@ -265,6 +266,8 @@ int sja1105_xfer_u32(const struct sja1105_private *priv,
 int sja1105_xfer_u64(const struct sja1105_private *priv,
 		     sja1105_spi_rw_mode_t rw, u64 reg_addr, u64 *value,
 		     struct ptp_system_timestamp *ptp_sts);
+int static_config_buf_prepare_for_upload(struct sja1105_private *priv,
+					 void *config_buf, int buf_len);
 int sja1105_static_config_upload(struct sja1105_private *priv);
 int sja1105_inhibit_tx(const struct sja1105_private *priv,
 		       unsigned long port_bitmap, bool tx_inhibited);
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 03454638c5a8..07ae6913d188 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -1,8 +1,120 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2018-2019, Vladimir Oltean <olteanv@gmail.com>
+ * Copyright 2020 NXP Semiconductors
  */
 #include "sja1105.h"
 
+/* Since devlink regions have a fixed size and the static config has a variable
+ * size, we need to calculate the maximum possible static config size by
+ * creating a dummy config with all table entries populated to the max, and get
+ * its packed length. This is done dynamically as opposed to simply hardcoding
+ * a number, since currently not all static config tables are implemented, so
+ * we are avoiding a possible code desynchronization.
+ */
+static size_t sja1105_static_config_get_max_size(struct sja1105_private *priv)
+{
+	struct sja1105_static_config config;
+	enum sja1105_blk_idx blk_idx;
+	int rc;
+
+	rc = sja1105_static_config_init(&config,
+					priv->info->static_ops,
+					priv->info->device_id);
+	if (rc)
+		return 0;
+
+	for (blk_idx = 0; blk_idx < BLK_IDX_MAX; blk_idx++) {
+		struct sja1105_table *table = &config.tables[blk_idx];
+
+		table->entry_count = table->ops->max_entry_count;
+	}
+
+	return sja1105_static_config_get_length(&config);
+}
+
+static int
+sja1105_region_static_config_snapshot(struct devlink *dl,
+				      const struct devlink_region_ops *ops,
+				      struct netlink_ext_ack *extack,
+				      u8 **data)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+	struct sja1105_private *priv = ds->priv;
+	size_t max_len, len;
+
+	len = sja1105_static_config_get_length(&priv->static_config);
+	max_len = sja1105_static_config_get_max_size(priv);
+
+	*data = kcalloc(max_len, sizeof(u8), GFP_KERNEL);
+	if (!*data)
+		return -ENOMEM;
+
+	return static_config_buf_prepare_for_upload(priv, *data, len);
+}
+
+static struct devlink_region_ops sja1105_region_static_config_ops = {
+	.name = "static-config",
+	.snapshot = sja1105_region_static_config_snapshot,
+	.destructor = kfree,
+};
+
+enum sja1105_region_id {
+	SJA1105_REGION_STATIC_CONFIG = 0,
+};
+
+struct sja1105_region {
+	const struct devlink_region_ops *ops;
+	size_t (*get_size)(struct sja1105_private *priv);
+};
+
+static struct sja1105_region sja1105_regions[] = {
+	[SJA1105_REGION_STATIC_CONFIG] = {
+		.ops = &sja1105_region_static_config_ops,
+		.get_size = sja1105_static_config_get_max_size,
+	},
+};
+
+static int sja1105_setup_devlink_regions(struct dsa_switch *ds)
+{
+	int i, num_regions = ARRAY_SIZE(sja1105_regions);
+	struct sja1105_private *priv = ds->priv;
+	const struct devlink_region_ops *ops;
+	struct devlink_region *region;
+	u64 size;
+
+	priv->regions = kcalloc(num_regions, sizeof(struct devlink_region *),
+				GFP_KERNEL);
+	if (!priv->regions)
+		return -ENOMEM;
+
+	for (i = 0; i < num_regions; i++) {
+		size = sja1105_regions[i].get_size(priv);
+		ops = sja1105_regions[i].ops;
+
+		region = dsa_devlink_region_create(ds, ops, 1, size);
+		if (IS_ERR(region)) {
+			while (i-- >= 0)
+				dsa_devlink_region_destroy(priv->regions[i]);
+			return PTR_ERR(region);
+		}
+
+		priv->regions[i] = region;
+	}
+
+	return 0;
+}
+
+static void sja1105_teardown_devlink_regions(struct dsa_switch *ds)
+{
+	int i, num_regions = ARRAY_SIZE(sja1105_regions);
+	struct sja1105_private *priv = ds->priv;
+
+	for (i = 0; i < num_regions; i++)
+		dsa_devlink_region_destroy(priv->regions[i]);
+
+	kfree(priv->regions);
+}
+
 static int sja1105_best_effort_vlan_filtering_get(struct sja1105_private *priv,
 						  bool *be_vlan)
 {
@@ -110,10 +222,17 @@ int sja1105_devlink_setup(struct dsa_switch *ds)
 	if (rc)
 		return rc;
 
+	rc = sja1105_setup_devlink_regions(ds);
+	if (rc < 0) {
+		sja1105_teardown_devlink_params(ds);
+		return rc;
+	}
+
 	return 0;
 }
 
 void sja1105_devlink_teardown(struct dsa_switch *ds)
 {
 	sja1105_teardown_devlink_params(ds);
+	sja1105_teardown_devlink_regions(ds);
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 704dcf1d1c01..591c5734747d 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -302,9 +302,8 @@ static int sja1105_status_get(struct sja1105_private *priv,
  * for upload requires the recalculation of table CRCs and updating the
  * structures with these.
  */
-static int
-static_config_buf_prepare_for_upload(struct sja1105_private *priv,
-				     void *config_buf, int buf_len)
+int static_config_buf_prepare_for_upload(struct sja1105_private *priv,
+					 void *config_buf, int buf_len)
 {
 	struct sja1105_static_config *config = &priv->static_config;
 	struct sja1105_table_header final_header;
-- 
2.25.1

