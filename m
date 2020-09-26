Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61201279B76
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgIZRfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:35:03 -0400
Received: from mail-eopbgr40088.outbound.protection.outlook.com ([40.107.4.88]:62990
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726210AbgIZRfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:35:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiRcvXazi+EYdNbpBHTPmsuwxhz5Fe0E03gxCCl3pUTS1uvMxwSttgegzJ5+nszp3hKvBRfnvCZ/ZZXhynSNfk1rWsd43t50iJuUzojhY40i9oCzYbdfuZqtvmpvtaR8TtL1dVo2+XVd0q6Z5V/sliNKbSGKxORKSZ7Iv6sIU18oqlY4voZ3J8d+9YX1w63OVuPRaNHRDdZXafUmlX2orRv8UVw+gX08XOAaDi5La/f+GJm3UGE14k9rbN9dp48HeiNj8XT/bxM7o568OdQYEG2M1zVK5j3GsQBsMbhf2+O+lKkWlDDwSLaGkiiHHCUKvSJs/z7rFdtH+9peQfOnJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKJkf3TcuqThjlhZ7iJlGq3FqDw7wvQkypsVI+y8a2g=;
 b=gIa0boQXEN8ZZ2TS5dH6qElRCeAf5xlCFHa6UHSEvYiDGqFybmIYXWRQpTcJWcuGH7sUzu8GA6MQuQ8J50hBPdBmIOrdIK5sX4OQuhvkkO6cxptHh1C4c2egw5JC0J8Zd+f/G7tRvpwvdo+BCY1UbFm7WHH2hUwD5+82z4tup/ntBCcva3CsUAN6q1SSsItgs4S1aaElPZuR0iIZfjnzOzZ3s61O4K64yEp8VCCdl62Qn/WswfN6DwxItr5D03DUsoWoIgMQ1gtu3w4bl9jjgNKJ/6xNovJJS5tLkzfW6v58mvztFY37Q4IDcxVf7zLm3t/xDh40bgV2RHrPmqrwKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKJkf3TcuqThjlhZ7iJlGq3FqDw7wvQkypsVI+y8a2g=;
 b=nWGODVYtxJbU7adttEIGbvdp4ncqUHiwaxX8+lZGp39ifWBAgBf16Lb7fmyIYyo1OCRZ6rOkYOxBKZGpt1xIUby0rSQOSdM4+rCbapsofwK5PpLhB6fztFEX+UC7GsPfJV6CLaFZomEQjUdnIYj52EBrneUBpHQXIIOm5gYzVcQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:21 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 01/16] net: mscc: ocelot: move NPI port configuration to DSA
Date:   Sat, 26 Sep 2020 20:30:53 +0300
Message-Id: <20200926173108.1230014-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:20 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a87fea05-3923-4092-9044-08d86241fbd6
X-MS-TrafficTypeDiagnostic: VE1PR04MB6640:
X-Microsoft-Antispam-PRVS: <VE1PR04MB66403D63B465B7EDFA409832E0370@VE1PR04MB6640.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zxm7Ed90ggn5K2PHGmN/kiqwEYPnauJRWcZwnNpYh8LzeWnCKYFWlNImmKPEKiwu0QTvbyH7i+k4csVa8j9m10aYAnnbZg7l/ueRVwD+wwN4dMrfkBzm9WGEHiFVDc8Hcl6zM53UCb9Gklo0WcVovs7G9UE4mfDzsyHLT4MO6lyBlDaMkNel/iDLBCKQgD7mH8XUTjPv388mque477BnmJ8QtymT+96oCBFYhxZSzkWDVYB9d2tskxVx81mVbmTFlqdq2Rht/GvZ70Fq4lFaWC6MTws0rXpeQXmKJuBpd/xpj07eNkqbSKtZW6KqdDdOeIyw4e5eLDJ8Qax5b/DZIZbDB6Ud5ngWPPhI91guD+LwIHi5TtzhJ3L5tP9dXCpiqi5S1oMq+SnzP7CsiLB4QUJglClSEJIscvTFP7oFq/ifGjk3hZWNWl6lBDE9LA9y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(956004)(8936002)(1076003)(6486002)(4326008)(5660300002)(52116002)(26005)(6506007)(66556008)(66476007)(2906002)(8676002)(36756003)(6666004)(44832011)(66946007)(316002)(16526019)(186003)(2616005)(478600001)(83380400001)(86362001)(6512007)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: E7AFiwG2A4zE/GOJwaTPbkt0uWNIkzxJecyaFGk/vtESn+IU0TCnzVZjKpH/1TGgXM7czpkeDmjXamYi0QsBTV/ZeL5P08zE9libKsUv8EXe1FM37MBFk5FbK4cxGsOWxNtnkzTE/hf/fHMiIs5tdfxN4V03Zbyb11WE8DW5i0UVr/vKdiJYqP0xTlYDgmqIFQxtQlarOlQyiP06H48fJ7eClrtN8JLBd/FdaDEr5hdq+GPzmei2m7MqMjybF5ui/M4IBhyIQq9pZU+Z/Ec8/G/QKDuPCIfo91ZX30c0CjaEkq76Fhe+aVPENwWWbn7GMUQez8b0P3U7CnBiWFK81nqV0hgT74hNNxyKkLpaWEkIJdG80NOebAdIwBnEXad+zVz2OYrrGV5P4g1vt0GcsDpLAGdZ/NBMf6D2CBzq/yCW1WIIebKine/wYv0jZAv8grZq6EBFz1dBd7/3N4lMJT4KAxtK6Wwo9d7BnHETN4csfx7hRnyT8s1/i59GMWdAKPrHHvuEOme9PRcyGallo3jjNcgOX51JkigYl6SXljCK7qudgknGDgq+qRwFw9Jvg8Z+tAjym+xjkteKzSI95sNcgigqsXNek01Lq3d0UBBXuqzzxxyrThz7yaPFdfBYALgG1LuTi77uI7DeaJUGjA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a87fea05-3923-4092-9044-08d86241fbd6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:21.2513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0arlGENbkQzqjbRnrSOOuUV3dDjs59TnVW4Tor/71tf0gMd7b3bDsUl8EVT7zg+FNRF319DKNjG6uBxCWB7P1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
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

