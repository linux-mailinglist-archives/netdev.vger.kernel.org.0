Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A228272C38
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 18:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgIUQ2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 12:28:41 -0400
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:34958
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728026AbgIUQ2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 12:28:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UByitFULri5FK+BfA51wBdOZh3/soNCOROOZuINLgKQc/sQ4YyWIlDcn4AeiSgnLS7AC0BKkO3cdWMa6eb4TS1jEaXiIbr4EBHwTUx9U0GhBfetoNKYgBXZl0Krdk/MR+AKRdZp2MJoKd2lDs4RbK/R8+Dbx3hdGnApQWdA67GeiTcZhk0AIRO2ebPDcS6FIULHjeNrrcY8Op5vniP10rwV73wyf949s6wWDl9GPdenka+mdBwUJD6Uclh02qcacVcapBIVUH2i7xphr7IcEOvFM8Yb56OMTQaQDGvU8rtGVtxc5YfLoskftO/Q5hLHo7yqJQNJUkkZnTo1cP2LRAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZ9TDLnvGWIe4edWrDWXzRjMgegPkmS0Ci/t7QH2j00=;
 b=aAaOSllkWBJKOFgTws+uvAr0dU5ATizFMVLN5dSN5mI8CCCHoV8S6bWj2Ylo/tc5J2W6B94NgKRmEawF6lDl+IACRKJ+N+WQVAIiRvF4imwlRosvxGlgaoVo+alIpGlS6AkNMW6esCDDe7vyysLWw2NSR2Me65sSQNUAx0OLk/4xx71TNU1cvE+/fvxbRFoMr0hHKW2kuSNRnpbhX3+q6Anmnwgz2tfS9VhKSRoxpQLqmhjv5E/pwIZtUairt40EL5XAchHgOhymUn21+K2vFKI5SrsHhaXLXuTeRJ0goM9/paMSk4qI/ZANmf4gzxqYZ1IungrD0nF4ig3BuZpKOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tZ9TDLnvGWIe4edWrDWXzRjMgegPkmS0Ci/t7QH2j00=;
 b=PauaNhKkrjuOeOE9b68XfJC6PdLyjTxH0VC7Z06gjYC3gCX1xCs/YXbBLhUYZWfiO4zfHdOX82Tk2fgeAM9ZIq5iSIq3ff7m5zoZqTHR/1karmKOuRilvoU6wzdhsN1xzCTJEBem/b2z/oqtbnZj6IqLJkc9BQS2qNGVtjzqJ+k=
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
Subject: [PATCH net-next 2/2] net: dsa: sja1105: expose static config as devlink region
Date:   Mon, 21 Sep 2020 19:27:41 +0300
Message-Id: <20200921162741.4081710-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.217.212) by VI1P18901CA0003.EURP189.PROD.OUTLOOK.COM (2603:10a6:801::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 16:28:30 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d532da9d-bf2d-48ac-56cf-08d85e4b6077
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7343E9EEBB4E3E25C2B701EAE03A0@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ZQVPWpxlMCSXQfE2Q71+BAfYasCElF18sdB00DEqS599e3j93GFE1KcXM9ygUKVVZEBXlHBfiFWc6xtGXM1aZoXIeY1dNVSJRPHfH8JrwLChMWEDeGMjuqKj1fzYo5CCs+ao4Ix0rDtI3lnzp2lJiGN8Rf45vtFo+K/H6Yxv8ZjZy9Zq8bgGQpt+A/kyWV8CNgtfQVAFf/9oKXTYWmPFs/YdFwvwUgo3KB4pVDau9upFTjJC3BU/bZC807cO+ZLFoD2oiaCTFRk61wJsZFpdxUC3ZEZ9Adm4Rw2xwqpZRJuXoE75/MkA6MZ0BwiHPkH/Gc1GQl1AaOsvi93eK8LtmhjJq1X1/RbrK5qYd0KEgZrzlvk61JGoelW419hfvIR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(8676002)(1076003)(16526019)(186003)(2906002)(26005)(66556008)(66476007)(6512007)(66946007)(5660300002)(8936002)(69590400008)(2616005)(956004)(316002)(86362001)(36756003)(44832011)(6506007)(83380400001)(6666004)(52116002)(6486002)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: R3QRMxDYwmR3/Ftb1k44rBwzIwTmWU4vc08zJ2+W554FLg28QqTXGJanpG+cyQBKiuE4K/DwwcVcBgo/5r3sl3LFepbqCTOC5Gu4yvvh6IJU2MHaiHkYzaUsJz0jo7lb53AeerDDoUummbCXfe+0gVgKOu4KQ73gGimXZY45LT+/YTQ9L9JwHXMfEddGdFzPVpipKTAg8mib2FeofCZEksneXdmEJxlO910pspIJ+9/L/p3C5SjpsJ6OsvuNX2sGvGz621w3XGsppzD8AYHhoCc7Mxvp1EiFr21dr64F/P4X3tg1Vfzrbt5DwuktHgDay/iSZ+73fCHobnu67S8OjDangOUD+Vq3J6C4fu0YJLhJdf8pTrq2miCn8UgIoKotDBiIVmbPAGl325c1H3O2fDpJHcMzTwWCjaz1b+k2jAn7+yuyie59RyoFQo5fGslKhDYxdjYbnG+hgMifJ+Y8bv0YCvTdKN/nK2hTgQAICkNTdSGY+sW5ugAEENr10JLlw3cZVMVWyoWpiFqLdTVhL4mGqQOZWPKNXAngmYc5hT5jjHO97SKDpAVnzhKESmgG0RPV+GgqLdQuoMJbHNsxWxNf9ZBQVRTTbOFYSzIwHOiEGWsUBXrHHZDJfhUpPVk2O+BP60cDqGKE6dJQvpmRgw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d532da9d-bf2d-48ac-56cf-08d85e4b6077
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 16:28:30.8246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrakLI0u+GA3zVJe9BQISokdLh3kDS6NWwKkeQzGhPkkdfn2HW1uuKdFnqGhFaUsmKNBuacK1kj6eO/70Mg+FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
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
 drivers/net/dsa/sja1105/sja1105.h         |   3 +
 drivers/net/dsa/sja1105/sja1105_devlink.c | 117 ++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c     |   5 +-
 3 files changed, 122 insertions(+), 3 deletions(-)

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
index 03454638c5a8..ade88c82e11f 100644
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
@@ -110,10 +222,15 @@ int sja1105_devlink_setup(struct dsa_switch *ds)
 	if (rc)
 		return rc;
 
+	rc = sja1105_setup_devlink_regions(ds);
+	if (rc < 0)
+		return rc;
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

