Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC889279C25
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbgIZTdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:33:07 -0400
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:17545
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730191AbgIZTdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 15:33:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UbI3y4QIVZTbs5rWCy+YzxJRY0CetLHDJfaKdLP+Gk6nmrpwF9AFfdQghQv7WqW0hCJW1Y1uppLmylLcPrwxwiMvi9DoPT4SsuLRr4CVlREecGt4x5P7IbYENDribFBbnHgkbSKeNf5aeMTDUj7JRuOyxoK9+A68NNcF35cUub7gEbmPSbF1C0ko/Gex9UEMd0hpipN1sxU6NHC4qvKqbiYlSF4dW8AdtrsPPQ/lYip/STufklvxw6MoEFBEb1lCqSljTuUAjzMY0RzAhUizohd+3lqdlcj6/Io9nDYmJAWQvHUnqK7ma9xpUx0/Yqwm9Jc0SNgzIcr5rENgjqZHzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvFmdyeWZwcpBJZWaUnVkddJr3JiUvbc3DYc0Ilu81E=;
 b=dLnq6VLUq+/ayvQcn0jcAlK4KmgEcPbslBREjQHiTahyy9xKkGyQ71Kbrlkyw//U5d4QZqv9A4v+sWtQQ2aB9Lq5tdm3f6vIQu9RFf+aPLdHvBFZc1wzx+87kdFIhbfno4IjPn+SrcgAcWlvOQDazybIrzafH5K81ARd5N8Dkhoezt9qwiWVgKEz2bzgIAEbHSyhjKYOFdsZnD8Ati1BrYx3HuyOBXbAthUw/E+tqYPg7iZsPm7cqJV+1aOy31j9LM5ypELeFMXiu3383RtUDT/UXy9n546muMmZhRCg1MGEetF+chBbBIgXQUsGZ/p8OKDcZNvX+ZLMCsQk3VaIYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KvFmdyeWZwcpBJZWaUnVkddJr3JiUvbc3DYc0Ilu81E=;
 b=io+rlo3PR4HJ0/UVUp8OpgnEAGP58w2qctTvqv3ONrQfYBw1zojbXBAfGmj11cyQ489LuEFh6VY7wBagg7sUyaIA3bO6JdQH3RBvZQG6EokUbEuDM95jFDItYjHwYO7vYY1QmW7gitEXqkLBS5aCZtyBurLebHdvE6bcWAntk9U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 19:32:59 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 19:32:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH v3 net-next 01/15] net: mscc: ocelot: move NPI port configuration to DSA
Date:   Sat, 26 Sep 2020 22:32:01 +0300
Message-Id: <20200926193215.1405730-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::27) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.21 via Frontend Transport; Sat, 26 Sep 2020 19:32:58 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 47d5abc4-b921-4010-8a08-08d86252f9cd
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52958DC934C755FD8B799B0CE0370@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +EIB9XZdyNcEPd/ZZ9dsp7yBUFdcQFU/VZ3N1RAmjGbu/GrAM8lfYUjI5eD6WQD33SQWWqloICZoWYEhXPWlBs2CoJhEMCalqUBat9O/veVKzYVVopi7FbHqpDGP/aAqjHrbFt/z5FGfgg3vMNlECdHdOviDT8JHsgKrH0Uj4pkjjTo4y7mqm30+GKlwRJr2fkYhwv9l3VLW+vOTmRX3IWjyz08e+P7ZUilGNN0JgdwqN2F8vOq3lSjlGy4OxLCTfBf8p7/Lx0NXiHR1GymaIDBhUwkXVx5WjupBtNLRxLrPp0K5Qgd83vfi/9h+vGfszM0P/24bh1XyUL4FY03Y3K/h9dMdsYBbm0MFYGcH1ZBEl4gumZVd1SqdHxNJfhLqqpVaJCMNCLz5UoKseYhcFqhu8nSXLF3eAIOJsb0jpx1NG7qUKF0ij9/iPHnDaTGE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(6486002)(52116002)(66556008)(2616005)(956004)(8676002)(44832011)(6512007)(26005)(2906002)(478600001)(16526019)(186003)(6506007)(36756003)(86362001)(8936002)(1076003)(83380400001)(54906003)(4326008)(69590400008)(66946007)(6666004)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2R6FfGbmf2XNybt4MXuaGX8bVPzqjYsiIkkLMYrwdtiHBI/w6ZTzzJf2pDcMSvxhyUmAZjZi9SPRFs2JUl8Z9ZS8dq4n4UIV1tofZqnk8M8b2aSgGfwDOfUfU9CH/ERBTL/fddOLSetXmd3FSJwbpA6M3/tAkaH6BFufo8n0QnuQ/2jsiefX+Ta37dyV2xgdxoOYCN4oHAhYIKKd2yQudtWgSAICw9BbZ7DD4433oGMol6zXLrGDl6hqEuzxzmSq37J60ReqB7J1jm9cJ9dIHW69F8yCHLy33extsQIh/X3DhQnOq3poB51u/Fqtne3nlnEI68/TPdv/y09l/elUqvaXzenPzBxNyypNbHvdqm2MxOc+pyNoG/F5TY61ouiESO4UsScIX2iJ2S2AnMmic5boEsWg2/hbk617b9EZkLgyqmNyoyLr1OMSIV4xkfCgEJyJzCnIuE3adimLg/NESma4dBaw6dlYwfkqLgaBOrL+Qo4j1vt1s2vWK4JAunVPQqMa38eZwcJr9T1xf+lp1kDcdONNMDPwpfu4XRdLep+MvQy2SGf2SRVjGBBUNcdcSExA4csLvkRX6yOZLSoMCfNYmoU8UWEBQNOYTOS+nnkXokJeeOxg5YBsm98HmuTBPF42JQ3NnajSMReSOz7Raw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d5abc4-b921-4010-8a08-08d86252f9cd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 19:32:59.2801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: svXAGO8GuCjIap1WkDgD1UNmmdg9lQYngdSAtvENxFZo35ITfzBPMuk4FdDMdGPqEPGWCKd2j+saZ6HoJVw15A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the ocelot_configure_cpu() function, which was in fact bringing
up 2 ports: the CPU port module, which both switchdev and DSA have, and
the NPI port, which only DSA has.

The (non-Ethernet) CPU port module is at a fixed index in the analyzer,
whereas the NPI port is selected through the "ethernet" property in the
device tree.

Therefore, the function to set up an NPI port is DSA-specific, so we
move it there, simplifying the ocelot switch library a little bit.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Actually copied the people from cc to the patch.

 drivers/net/dsa/ocelot/felix.c             | 29 +++++++++++++---
 drivers/net/ethernet/mscc/ocelot.c         | 40 ++++------------------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  7 ++--
 include/soc/mscc/ocelot.h                  |  3 --
 4 files changed, 35 insertions(+), 44 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a56fc50f5be4..b8e192374a32 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -439,6 +439,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->vcap_is2_actions= felix->info->vcap_is2_actions;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
+	ocelot->inj_prefix	= OCELOT_TAG_PREFIX_NONE;
+	ocelot->xtr_prefix	= OCELOT_TAG_PREFIX_LONG;
 
 	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
 				 GFP_KERNEL);
@@ -538,6 +540,28 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	return 0;
 }
 
+/* The CPU port module is connected to the Node Processor Interface (NPI). This
+ * is the mode through which frames can be injected from and extracted to an
+ * external CPU, over Ethernet.
+ */
+static void felix_npi_port_init(struct ocelot *ocelot, int port)
+{
+	ocelot->npi = port;
+
+	ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
+		     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(port),
+		     QSYS_EXT_CPU_CFG);
+
+	/* NPI port Injection/Extraction configuration */
+	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_XTR_HDR,
+			    ocelot->xtr_prefix);
+	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_INJ_HDR,
+			    ocelot->inj_prefix);
+
+	/* Disable transmission of pause frames */
+	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
+}
+
 /* Hardware initialization done here so that we can allocate structures with
  * devm without fear of dsa_register_switch returning -EPROBE_DEFER and causing
  * us to allocate structures twice (leak memory) and map PCI memory twice
@@ -570,11 +594,8 @@ static int felix_setup(struct dsa_switch *ds)
 	for (port = 0; port < ds->num_ports; port++) {
 		ocelot_init_port(ocelot, port);
 
-		/* Bring up the CPU port module and configure the NPI port */
 		if (dsa_is_cpu_port(ds, port))
-			ocelot_configure_cpu(ocelot, port,
-					     OCELOT_TAG_PREFIX_NONE,
-					     OCELOT_TAG_PREFIX_LONG);
+			felix_npi_port_init(ocelot, port);
 
 		/* Set the default QoS Classification based on PCP and DEI
 		 * bits of vlan tag.
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0445c5ee5551..b9375d96cdbc 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1346,22 +1346,14 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 }
 EXPORT_SYMBOL(ocelot_init_port);
 
-/* Configure and enable the CPU port module, which is a set of queues.
- * If @npi contains a valid port index, the CPU port module is connected
- * to the Node Processor Interface (NPI). This is the mode through which
- * frames can be injected from and extracted to an external CPU,
- * over Ethernet.
+/* Configure and enable the CPU port module, which is a set of queues
+ * accessible through register MMIO, frame DMA or Ethernet (in case
+ * NPI mode is used).
  */
-void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
-			  enum ocelot_tag_prefix injection,
-			  enum ocelot_tag_prefix extraction)
+static void ocelot_cpu_port_init(struct ocelot *ocelot)
 {
 	int cpu = ocelot->num_phys_ports;
 
-	ocelot->npi = npi;
-	ocelot->inj_prefix = injection;
-	ocelot->xtr_prefix = extraction;
-
 	/* The unicast destination PGID for the CPU port module is unused */
 	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, cpu);
 	/* Instead set up a multicast destination PGID for traffic copied to
@@ -1373,31 +1365,13 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 			 ANA_PORT_PORT_CFG_PORTID_VAL(cpu),
 			 ANA_PORT_PORT_CFG, cpu);
 
-	if (npi >= 0 && npi < ocelot->num_phys_ports) {
-		ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
-			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(npi),
-			     QSYS_EXT_CPU_CFG);
-
-		/* Enable NPI port */
-		ocelot_fields_write(ocelot, npi,
-				    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
-		/* NPI port Injection/Extraction configuration */
-		ocelot_fields_write(ocelot, npi, SYS_PORT_MODE_INCL_XTR_HDR,
-				    extraction);
-		ocelot_fields_write(ocelot, npi, SYS_PORT_MODE_INCL_INJ_HDR,
-				    injection);
-
-		/* Disable transmission of pause frames */
-		ocelot_fields_write(ocelot, npi, SYS_PAUSE_CFG_PAUSE_ENA, 0);
-	}
-
 	/* Enable CPU port module */
 	ocelot_fields_write(ocelot, cpu, QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
 	/* CPU port Injection/Extraction configuration */
 	ocelot_fields_write(ocelot, cpu, SYS_PORT_MODE_INCL_XTR_HDR,
-			    extraction);
+			    ocelot->xtr_prefix);
 	ocelot_fields_write(ocelot, cpu, SYS_PORT_MODE_INCL_INJ_HDR,
-			    injection);
+			    ocelot->inj_prefix);
 
 	/* Configure the CPU port to be VLAN aware */
 	ocelot_write_gix(ocelot, ANA_PORT_VLAN_CFG_VLAN_VID(0) |
@@ -1405,7 +1379,6 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 				 ANA_PORT_VLAN_CFG_VLAN_POP_CNT(1),
 			 ANA_PORT_VLAN_CFG, cpu);
 }
-EXPORT_SYMBOL(ocelot_configure_cpu);
 
 int ocelot_init(struct ocelot *ocelot)
 {
@@ -1445,6 +1418,7 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
 	ocelot_vcap_init(ocelot);
+	ocelot_cpu_port_init(ocelot);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		/* Clear all counters (5 groups) */
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index dfb1535f26f2..d7aef2fb9848 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -930,10 +930,6 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 	if (!ocelot->ports)
 		return -ENOMEM;
 
-	/* No NPI port */
-	ocelot_configure_cpu(ocelot, -1, OCELOT_TAG_PREFIX_NONE,
-			     OCELOT_TAG_PREFIX_NONE);
-
 	for_each_available_child_of_node(ports, portnp) {
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
@@ -1120,6 +1116,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
 	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
 	ocelot->vcap = vsc7514_vcap_props;
+	ocelot->inj_prefix = OCELOT_TAG_PREFIX_NONE;
+	ocelot->xtr_prefix = OCELOT_TAG_PREFIX_NONE;
+	ocelot->npi = -1;
 
 	err = ocelot_init(ocelot);
 	if (err)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 3105bbb6cdcf..349e839c4c18 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -672,9 +672,6 @@ void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
 struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
-void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
-			  enum ocelot_tag_prefix injection,
-			  enum ocelot_tag_prefix extraction);
 int ocelot_init(struct ocelot *ocelot);
 void ocelot_deinit(struct ocelot *ocelot);
 void ocelot_init_port(struct ocelot *ocelot, int port);
-- 
2.25.1

