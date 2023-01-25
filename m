Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9BC367B53A
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbjAYO5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbjAYO5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:57:35 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A2F3EFFD
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:57:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNWgk9u631GTJJ7e0Qeej24QoZyU/ILzvbS/EHf3a0A8IVRk0Iq4XbPvWRzZMi1N4TFNmIwmpArMCVzfgp4yBGKTvDS3huTZhPacPtrGQX4x0x71ai+mjWAuIPVi5w3lAnSCmT/zvNC/upl+0J5M/3eJqUM7Q4BwopvUeFv5uW/mho6GsUIPyW9o3cYntFwkMm1tMtqaSLKSowOdORdwBnx4VUEXtiX0SzGplOSQ0qTfv4VhlVdrE1YXnoLafpUGC4qNwKnjS1JYOlWrufrBP0WdMMmJPOXFKlEhUZeuIjuPl2hbxL7GkrWi1d+rBfyCbQp48KLpUeNdGTTbCyAXSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXn/MAh5ML+MuZhjfRpMo/b4Pbyos8jHIyBc6XAi+0g=;
 b=mGMvndzWizP28LQYP3UJPjiqa9Y1ueC94VryojJ7ZXhGfD58+mMypiMlvY0BFILDVlIpKmwMbFjOXWKsqTbmnS1xOsk5POisoD2YVuAnhXRJ2Bgoy9q6v/nTSiLbeM5ocYX6Mz5EYfrw66Q1AvIWvK/JBfA8DX95FU1h9P3lk1QSvMJ32N3prBScStwzOohQzoc3jDjGtrnxAp0WxgJe76Djqq2ccR8CJjkEZRL4k5TS83sy74BgPaghdSgLSCe7oSc8I9v0vhvw4oUJqeG10BU9wH8tEUZxACbjtYXZIUQFyVX9eOTr/7Nmzm44Ovjvvrpf8okXp7+ZJ315Of3osg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXn/MAh5ML+MuZhjfRpMo/b4Pbyos8jHIyBc6XAi+0g=;
 b=HNTidgtAkd1RojbpNyEW8GDoEN+sg2muk03rZ0lXFaVYqLxE0fygtuiMqBENO7DxInEodcESZiS+wi9pagHvuzPERTh7BwMe5NB9z4mynKD76NbN9i0NZzxBcy4+m88YxylYS0yzYv6OsEfIFQd3j5WCASgnTbWPZXv0SsKfqQA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8691.eurprd04.prod.outlook.com (2603:10a6:20b:42a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 14:57:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 14:57:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next] net: dsa: ocelot: build felix.c into a dedicated kernel module
Date:   Wed, 25 Jan 2023 16:57:16 +0200
Message-Id: <20230125145716.271355-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0189.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8691:EE_
X-MS-Office365-Filtering-Correlation-Id: b59064ba-bf42-441e-c8dd-08dafee47973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QOFVYTLP2pl3PZ2dHlHWnhtyJIAWY4TprT5k0qqkGGhWx90sE995xMd0JztoamY2ZLW99IYO82Qw2VY3bcHnnbmfKDdT6poZ+b+/lE99lQIwvx146gSqf067J/0S4VSt8K8GK7ToX7BXrp5LyifFRpSMr6O4EjO9rq6uy+JpGqMamgh2pvPEj8VQLVc+KU1fuCCPsjOdwFKQ38N8HekwY81N4KiAa5BMPJBjsPMwVAOryzT4HHBo/1rdsytR1Drku1D3OUXtVCSeLrg/h538o3mM8ZyopIQGuX/nvI/2BFvoUwCr7I+uomj5EZg26hFW1G8dU6BPks2V4n4HiZYx+WXOo997gt3AC7AKKwimpPpJ11ex665sHSM25YTvmwRvRi21P90KRJ37qBCE45cjExUl7iMPqGxG9P01dVL/MuozPixjhcVHZtiZj86j3odhSxHCft/GWefcXtSOPv1Fyu57ATvlBLundDH68CQ9xXNTh32fqjr0eGRqhgIvH51dpdLJcN0Jw0I/OcEoOmkt42ak53anbJlc9y6C/8bZLtMwfXjsb1Ce6qnUZ+JOMGlHzfdt+AFiH4BYxevpgraCOHoisdFvO7E2ZhH1FQevQmwf3YpbnzAJDZpBQ2Wz3yMMlPMDlq3s2opwVx2mZZopTtASbnDQ0hEDTWh036hUqqIlNavgCbgJ83Z09OjW0CmFTI73wgaiJfK1BivOSFMEIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199018)(26005)(186003)(6506007)(36756003)(2906002)(44832011)(38100700002)(38350700002)(6486002)(52116002)(7416002)(8936002)(86362001)(41300700001)(6512007)(316002)(54906003)(5660300002)(1076003)(2616005)(6666004)(478600001)(66556008)(6916009)(8676002)(66946007)(66476007)(83380400001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VK7bYAkJH/ETPAY2jd861pMBXFcwWLyGM/CgmongcjJ95t7apUDqn2gTPdHN?=
 =?us-ascii?Q?AhibXWJZAvILWcLxmM/3BasYIUQCacZ1dHZZEaoPUqpxcBO1SuKTH0ZVpUD+?=
 =?us-ascii?Q?LeBaIEvdJRuQ6ptGZNdIm/wuGguhgjXooKcWoZd5aDuxfcvI39HjOMS8xFYi?=
 =?us-ascii?Q?nURnw2XKM7XrUShtnAh+JBgRGZA+Fz/yoObapQgkIfFLPeqzEhtUqNOllkX/?=
 =?us-ascii?Q?RhgH1ocVl34aWEPSSlr7mJgzxig86jYiOpuBmeml1FvC0LFIp9z5ReiCAHAL?=
 =?us-ascii?Q?NgaFMlVeXyzMIRt4wxFQtIpAmKpL5um5y3rQJSkVEv8wy7Wyr6s9X7mw8qF8?=
 =?us-ascii?Q?DC++G81xe7w11YhhF2a/AiQGLuhMI84ALIvJuqmbmlE4JFeM2qu2gDfma1xn?=
 =?us-ascii?Q?XTA0ew/95m/gdZjdCWoIAr+s6/xm4RU6+7pcfE8TMTl+zpe3XYe3I2INLQkX?=
 =?us-ascii?Q?f1x5Lkt+mfezxpMFOzVK+7mhiy8PMgJNsUyattCtQhUN/oGJ14TvTxU/2z/F?=
 =?us-ascii?Q?tPD4KTekZVlv1x2f07t5CC1//VMvkRr86w50jgD+CbPd+qTtAlsTN33l5YMN?=
 =?us-ascii?Q?vUjYDESCQuHEQBPQ7KB5FRICD6ZcGjBGmx+8nCdv36Ublh2lUwRlg7Mf8uPp?=
 =?us-ascii?Q?OFoQXaoyVxNn7UoLhZaeIpwQTNjLLYS1sbcicSoQjWHKvYBQsnb6eYk/larB?=
 =?us-ascii?Q?ndiHaK6baqLPAOE+I3t6gF8Bb+6sVuqRU4xImlhEqXuZA+x+mx0OzLN2Mswk?=
 =?us-ascii?Q?I4GCvAo3AXaMi+ekUPScyZtc7ksAsVvsKhXOikt5IutW/LN5O24CWDaVX+Mb?=
 =?us-ascii?Q?fbhzphI+Jn1CK+ILl/33zfjDtBW3d9XR9bgFbuL9i0Hh5rpiokHytpCPRfqm?=
 =?us-ascii?Q?qWXAnOtMDTbBOFGmt9Nk7R0q0+Dg3kErHnDmgaDbwH/hGOPlkpVM3ENL4YMn?=
 =?us-ascii?Q?tHgSX/wsFlIodTZ8RkCQm6SVn8vHHa4RHxCwjROgt4jEJhHxwnIryZXN8UGt?=
 =?us-ascii?Q?5mdAShIxU30Lcvx4HLwu9q/N/4feZbU24PsBhT9MnjzDqaOEzxFJw4mmB+jb?=
 =?us-ascii?Q?XlyvEOO6fhh0123YxzbD177YgDfj5LD3zDZONoVf3Bou9Acg9xMnKSGWHZ7z?=
 =?us-ascii?Q?kqYrRAJ9PWtQlfJ4NuWJ4VepYW0YHsAipTXP6Cx6VFVx+iaO2niJb4dB/QOU?=
 =?us-ascii?Q?sOK5E/fyVW5v9IpGG2XCsWmhiNTRUA1bgHobd1rrZmxvVztUbO3Q1CbeivG2?=
 =?us-ascii?Q?YIsl1LpwEk1IbmUF4tRZp3Fn9Upl7lAthd6SeCw7RsWNli3optP0dUjdiqo7?=
 =?us-ascii?Q?IAxaHtXdrzk3wdzGtXa4y2Ou3Kcr0DZFlUoovS5dFKHwrU18tL3l0EgYscwH?=
 =?us-ascii?Q?WvX61/707pumzISGVv/5qZZ7oP7rBtCImNgKwlQDyVrKnDrI6d3URha/s/wZ?=
 =?us-ascii?Q?Q2vKw5OJtj2jtWUn7yvbzP3BIgNFYQ2XfEzO6jji//eP9Gtm09+n1zJ9SZlX?=
 =?us-ascii?Q?cv10K5J6SkHeoe38kv2dT71fQAPLHHv08PuaxHhhkdkvd8ePb33a/G7FwUur?=
 =?us-ascii?Q?G/dTLKN7+zopZhah26Obf6HKLhvjwx3EsX1E0tsBySq+GemhTcx+0DB/QbWc?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b59064ba-bf42-441e-c8dd-08dafee47973
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 14:57:27.2163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cUt9r2B9Zf12kqVWhrY1clhmm6ODZ5iVsg87m1pcm4St+eeUaJUliR2fkXWBxwTwrsJw+6aAq7yLCk3q34Ow6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8691
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The build system currently complains:

scripts/Makefile.build:252: drivers/net/dsa/ocelot/Makefile:
felix.o is added to multiple modules: mscc_felix mscc_seville

Since felix.c holds the DSA glue layer, create a mscc_felix_dsa_lib.ko.
This is similar to how mscc_ocelot_switch_lib.ko holds a library for
configuring the hardware.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/Kconfig  | 11 +++++++++++
 drivers/net/dsa/ocelot/Makefile | 11 ++++-------
 drivers/net/dsa/ocelot/felix.c  |  6 ++++++
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 08db9cf76818..60f1f7ada465 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -1,4 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0-only
+config NET_DSA_MSCC_FELIX_DSA_LIB
+	tristate
+	help
+	  This is an umbrella module for all network switches that are
+	  register-compatible with Ocelot and that perform I/O to their host
+	  CPU through an NPI (Node Processor Interface) Ethernet port.
+	  Its name comes from the first hardware chip to make use of it
+	  (VSC9959), code named Felix.
+
 config NET_DSA_MSCC_FELIX
 	tristate "Ocelot / Felix Ethernet switch support"
 	depends on NET_DSA && PCI
@@ -8,6 +17,7 @@ config NET_DSA_MSCC_FELIX
 	depends on PTP_1588_CLOCK_OPTIONAL
 	depends on NET_SCH_TAPRIO || NET_SCH_TAPRIO=n
 	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_MSCC_FELIX_DSA_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
@@ -24,6 +34,7 @@ config NET_DSA_MSCC_SEVILLE
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select MDIO_MSCC_MIIM
 	select MSCC_OCELOT_SWITCH_LIB
+	select NET_DSA_MSCC_FELIX_DSA_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
 	select PCS_LYNX
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makefile
index f6dd131e7491..fd7dde570d4e 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -1,11 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_NET_DSA_MSCC_FELIX_DSA_LIB) += mscc_felix_dsa_lib.o
 obj-$(CONFIG_NET_DSA_MSCC_FELIX) += mscc_felix.o
 obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) += mscc_seville.o
 
-mscc_felix-objs := \
-	felix.o \
-	felix_vsc9959.o
-
-mscc_seville-objs := \
-	felix.o \
-	seville_vsc9953.o
+mscc_felix_dsa_lib-objs := felix.o
+mscc_felix-objs := felix_vsc9959.o
+mscc_seville-objs := seville_vsc9953.o
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d21e7be2f8c7..f57b4095b793 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -2131,6 +2131,7 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_set_host_flood		= felix_port_set_host_flood,
 	.port_change_master		= felix_port_change_master,
 };
+EXPORT_SYMBOL_GPL(felix_switch_ops);
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
 {
@@ -2142,6 +2143,7 @@ struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
 
 	return dsa_to_port(ds, port)->slave;
 }
+EXPORT_SYMBOL_GPL(felix_port_to_netdev);
 
 int felix_netdev_to_port(struct net_device *dev)
 {
@@ -2153,3 +2155,7 @@ int felix_netdev_to_port(struct net_device *dev)
 
 	return dp->index;
 }
+EXPORT_SYMBOL_GPL(felix_netdev_to_port);
+
+MODULE_DESCRIPTION("Felix DSA library");
+MODULE_LICENSE("GPL");
-- 
2.34.1

