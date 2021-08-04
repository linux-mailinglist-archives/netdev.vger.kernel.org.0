Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8973E0280
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238512AbhHDNzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:55:32 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:28896
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238488AbhHDNzY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:55:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHBdujPe0kyt29coDbXNrXEiYzzdfpdomxiQhVWp62hUAdY99wt9HyCS4pDYZdnhEVE23nEQMfZQhtQ4/lZOJeo/kolGDXAZJxl6VC/Us+hP9K9xdWKfvP5FlRSBizw3hilPQYQkO0QeX2VGlk5oN8ccJdKysQ2ge1UcHqBrlMNxmgEttBR9gpUCr3HPJTr0AKIzoYjQnAOYkVLYe88dIftJLaUx6KT6onQKdbSDPYYzcMTLbOM2nxc2RbP1hbMeI8OxXU0dXNYrEZ0fJuZ6SaQ54qwbTaHF6waZGn6OhaXSMkvl6OBUMGF8ruCcy+R+U+C4MJThLJHJBg1mujyLzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amoeNrWJ4532H2p7QkiIVWJGcprWXA9ktT8T2gaXz0o=;
 b=dqKAvB+94rPFKnV7Gy8akUNsZiTdMlHcg5LhsA/6ggVbEAhg1aDdSYGN7EXSNJMoYUgn8vTF49PcosUH+gTBYqeFhxmkQ5+5sGYswbTsaViuRcvQyWDtg3H3nmwBX1FBJLxGV7BFss/1KNC80QV9TdT7C2iXh8Vx0cLV3QwYfeajdUz7hf3YSoFIovbHCZZlp9TmKD/yZuJHDTd/odMwUwpHkgAuNv2oNjr4K5bB8DuJFx/5pRWfaiGObpWWSEiZCO3noOpYbn/CCZj9LU/WTPL9jLHPFJUo/CzouUSSzv2QLJ5g8Xzvwsn03Zd6csfrdmd6YyO6lDx6/DA0BAtFHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amoeNrWJ4532H2p7QkiIVWJGcprWXA9ktT8T2gaXz0o=;
 b=IR+/+520PTEGLbySITJBxEQI0zOEwUX7RVPk7I+37jdHBAn0ZBjJWPZSNs/O7hpQhD3XCQUUIQbcJ8sHhW9QDqHh4D0WEeYiO0b5HlIDuZ2zLh/eJqM6D4fbT6kqXy2NJ2WpQOvxPIm/+QizZxHfq1suCejlUYI0vIcOAhXkbkY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 13:55:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:55:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 3/8] net: dsa: sja1105: configure the cascade ports based on topology
Date:   Wed,  4 Aug 2021 16:54:31 +0300
Message-Id: <20210804135436.1741856-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
References: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR01CA0155.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 13:55:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6097801-f3aa-4817-4ad0-08d9574f796e
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB268796E71569E1AAB416AF51E0F19@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wIh1oOXg3KlwYHe5uTPS5Pi5HsJC2JMBaVm+r8v/Z1iBKx+12Q/TkD5FoHRT5YNec+h3cwXG1SLJ9uI4ryv3w7s2pPesK9Pq8v4I4SvDfbOab9BOcO1E7Npm+Oq8zGYOfpCpXdIYapq1PCQB32cPnfZ3NLda8u1jmMdtXWi82j21rWY0YCaDPM/XYOl+CwVrdPY9ZWa5Hu69g/JthI0M4leukDZ38GRhor14PRrqdL87wXbf6X3J3UDGfz/boPVXkgOVVFrlwwIS0R5flNhEz29QdhV5t2B9rSRu2ReBMamZAyxV3GDywVbSr7k84aqCI88SFzE69pTC7PcXZYLUcsb+O2lQV2E4KoCUhqAVoPCvVzEvicTm6OuRz8B0XgamVGHU8Wvj4SZpw/aAwpHWJHBnwqzN9xmbBGiHD4TKzgmoZjUHURskU3n6mNcwFq2qyH4FZSrY82N529L3UPKKCHZxICFnrY9m6opEaP/TfuIdhqfXQ8dweiLXRIlscgBRlW92ZDxYZ0sfZ4+3O35xeSSdS9p0cdd36gDuOsaTVGKa5IpnUZ0gsGtDCvqQV3zdzRK24WvvtptrUrHBvTyo/CJoNdk13qh4JIOMKTab6jBpGVbjXm8Ax3crXhYSv+ZecV9WCK9dbb/5wu3NXqN3dKnzJvtp08M7uirY1OXC0o0MteSGXZd1aCRltoaaEfSO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(6666004)(6486002)(5660300002)(478600001)(66946007)(1076003)(66476007)(4326008)(66556008)(54906003)(26005)(44832011)(38350700002)(86362001)(2616005)(52116002)(8676002)(6506007)(2906002)(36756003)(110136005)(83380400001)(38100700002)(956004)(6512007)(316002)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PnV73DwaRU4Kg6O0RkAbeGZIm3TSVHDzTRdMI/4/Cv9RKaXAUOeaJc5D/42d?=
 =?us-ascii?Q?VkzV1ShV3ZAnhNev1ZfO3rhWmpQtVBthRYMyqMcvL8/snvvv9PbEhu2DLK6F?=
 =?us-ascii?Q?OkLD5E07uABV6OXcOfmI0dc433eHdVfPyG28BiwvOqCkzaDEPMB3hOA7ev3T?=
 =?us-ascii?Q?165RwOIaNyuXAhhJ4Xr1UWIHt6bYVVdfLmUrsz47ZTF4oHn/huHtAS7sgSZG?=
 =?us-ascii?Q?c/fnMbEdEoGeFA8mKRGIxm4vePrxqGrIlBG+QwnY29J/z9mKH4jGAHb6yxnm?=
 =?us-ascii?Q?KJbRhkPlEFLkR15qJh8zlYl/uog1h0muYXPBxWgVaPeAc1afZxBkaoyvGZWM?=
 =?us-ascii?Q?A7hT48G3uNkQvwwMqqWwZ5JEN1SunkTmN+bS7opz75VwpOw5pBSWR+Ka9Dmp?=
 =?us-ascii?Q?KoGwlRXU3uuBxAW0p8x1mMB7Xcg6pLZF3CRAUK+9ykS9Xwb5j8UAUFjxMN3s?=
 =?us-ascii?Q?V7UYRokBk/OVK339dzOzf8q3701QUBiwNDdjlHs0DYO/Gy48G6EZWAueg89L?=
 =?us-ascii?Q?heXYDJB0zx0InXq417i8pLK0GP3wVG6Jr15ZQp7itnGxN471ht1a46so5QPS?=
 =?us-ascii?Q?aicFnvKFJ8sgaOPgavZQOWDS3ZQon2UCmEyixY9DlZOXMRkdAWP6iVXNdrL4?=
 =?us-ascii?Q?WXIGPUB/0yk8dnoI2bY4xgYWvCBLPmeyCnPXGsc25cuBAlXadOrou93YDgQu?=
 =?us-ascii?Q?vMlcnrm/V+Zt2v8QOUlK+wjZzAQqv6I5N43cYgya5Bsqzwnjm20U0KVZb8Ah?=
 =?us-ascii?Q?xzZpgNcAJqBk38/P5n9QaHO9Lu2VG8jkdOGnJurEozdVnODRIKt/Ueq6Q9c6?=
 =?us-ascii?Q?C41uJjnRyiODYgfxCLozL7LiymehcbhYesxroCV6DXCHI4IOw2mn5qI0XUEh?=
 =?us-ascii?Q?CDg2pTT2TdGN0xIoKijTu6VmgaDatd9Okl6HP2X1+/a1+4YOKV5uuGF2ejKw?=
 =?us-ascii?Q?Div/Cm45vcPljk06flXuv11G93ZzfRr1ejWipOx5Bf5K7UAPqSDJp9WXfOvg?=
 =?us-ascii?Q?icN7xyTNMmcljB6VrWRqkt1GDUyVaWPuEpMB1zaux8H1pF6OImVGbbqWR3Vj?=
 =?us-ascii?Q?ps63ACGkB2jPhRiVlY/WKJACKlz4K/7j69f67Bewc7aEMe00B6qJYhUaQHiE?=
 =?us-ascii?Q?QTe8BpEvTkJ4Vqq6IT2WtVs0r/o+9QpNuUpZ/Yk7gJbfStip1wkCeGhnPijU?=
 =?us-ascii?Q?FFGLbhzHbYa+lxr17liab3Zkf3U9QwrWOe/M5geF0O8w2qbfVHPYbs3l8xAO?=
 =?us-ascii?Q?rlWFtTGwUSZNCQP4mNexPOWMkS7MytzDlDNpTuqX3yEAd6YWFjMmSgA0k3EF?=
 =?us-ascii?Q?/fQwicr04fM+fgnt60HxKZmw?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6097801-f3aa-4817-4ad0-08d9574f796e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:55:10.2499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yxrrOpsU1KpdGvaE1eTu8Y4U0JH2GZ62RIQZjPwbw6SdtlPZgrACb4DfimmRd38qo8RGKFRIr7zQkc5oWE0NKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 switch family has a feature called "cascade ports" which can
be used in topologies where multiple SJA1105/SJA1110 switches are daisy
chained. Upstream switches set this bit for the DSA link towards the
downstream switches. This is used when the upstream switch receives a
control packet (PTP, STP) from a downstream switch, because if the
source port for a control packet is marked as a cascade port, then the
source port, switch ID and RX timestamp will not be taken again on the
upstream switch, it is assumed that this has already been done by the
downstream switch (the leaf port in the tree) and that the CPU has
everything it needs to decode the information from this packet.

We need to distinguish between an upstream-facing DSA link and a
downstream-facing DSA link, because the upstream-facing DSA links are
"host ports" for the SJA1105/SJA1110 switches, and the downstream-facing
DSA links are "cascade ports".

Note that SJA1105 supports a single cascade port, so only daisy chain
topologies work. With SJA1110, there can be more complex topologies such
as:

                    eth0
                     |
                 host port
                     |
 sw0p0    sw0p1    sw0p2    sw0p3    sw0p4
   |        |                 |        |
 cascade  cascade            user     user
  port     port              port     port
   |        |
   |        |
   |        |
   |       host
   |       port
   |        |
   |      sw1p0    sw1p1    sw1p2    sw1p3    sw1p4
   |                 |        |        |        |
   |                user     user     user     user
  host              port     port     port     port
  port
   |
 sw2p0    sw2p1    sw2p2    sw2p3    sw2p4
            |        |        |        |
           user     user     user     user
           port     port     port     port

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 97 +++++++++++++++++++-------
 1 file changed, 70 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5ab1676a7448..74cd5bf7abc6 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -688,6 +688,72 @@ static void sja1110_select_tdmaconfigidx(struct sja1105_private *priv)
 	general_params->tdmaconfigidx = tdmaconfigidx;
 }
 
+static int sja1105_init_topology(struct sja1105_private *priv,
+				 struct sja1105_general_params_entry *general_params)
+{
+	struct dsa_switch *ds = priv->ds;
+	int port;
+
+	/* The host port is the destination for traffic matching mac_fltres1
+	 * and mac_fltres0 on all ports except itself. Default to an invalid
+	 * value.
+	 */
+	general_params->host_port = ds->num_ports;
+
+	/* Link-local traffic received on casc_port will be forwarded
+	 * to host_port without embedding the source port and device ID
+	 * info in the destination MAC address, and no RX timestamps will be
+	 * taken either (presumably because it is a cascaded port and a
+	 * downstream SJA switch already did that).
+	 * To disable the feature, we need to do different things depending on
+	 * switch generation. On SJA1105 we need to set an invalid port, while
+	 * on SJA1110 which support multiple cascaded ports, this field is a
+	 * bitmask so it must be left zero.
+	 */
+	if (!priv->info->multiple_cascade_ports)
+		general_params->casc_port = ds->num_ports;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		bool is_upstream = dsa_is_upstream_port(ds, port);
+		bool is_dsa_link = dsa_is_dsa_port(ds, port);
+
+		/* Upstream ports can be dedicated CPU ports or
+		 * upstream-facing DSA links
+		 */
+		if (is_upstream) {
+			if (general_params->host_port == ds->num_ports) {
+				general_params->host_port = port;
+			} else {
+				dev_err(ds->dev,
+					"Port %llu is already a host port, configuring %d as one too is not supported\n",
+					general_params->host_port, port);
+				return -EINVAL;
+			}
+		}
+
+		/* Cascade ports are downstream-facing DSA links */
+		if (is_dsa_link && !is_upstream) {
+			if (priv->info->multiple_cascade_ports) {
+				general_params->casc_port |= BIT(port);
+			} else if (general_params->casc_port == ds->num_ports) {
+				general_params->casc_port = port;
+			} else {
+				dev_err(ds->dev,
+					"Port %llu is already a cascade port, configuring %d as one too is not supported\n",
+					general_params->casc_port, port);
+				return -EINVAL;
+			}
+		}
+	}
+
+	if (general_params->host_port == ds->num_ports) {
+		dev_err(ds->dev, "No host port configured\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int sja1105_init_general_params(struct sja1105_private *priv)
 {
 	struct sja1105_general_params_entry default_general_params = {
@@ -706,12 +772,6 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.mac_flt0    = SJA1105_LINKLOCAL_FILTER_B_MASK,
 		.incl_srcpt0 = false,
 		.send_meta0  = false,
-		/* The destination for traffic matching mac_fltres1 and
-		 * mac_fltres0 on all ports except host_port. Such traffic
-		 * receieved on host_port itself would be dropped, except
-		 * by installing a temporary 'management route'
-		 */
-		.host_port = priv->ds->num_ports,
 		/* Default to an invalid value */
 		.mirr_port = priv->ds->num_ports,
 		/* No TTEthernet */
@@ -731,16 +791,12 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		.header_type = ETH_P_SJA1110,
 	};
 	struct sja1105_general_params_entry *general_params;
-	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
-	int port;
+	int rc;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_is_cpu_port(ds, port)) {
-			default_general_params.host_port = port;
-			break;
-		}
-	}
+	rc = sja1105_init_topology(priv, &default_general_params);
+	if (rc)
+		return rc;
 
 	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
 
@@ -763,19 +819,6 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 
 	sja1110_select_tdmaconfigidx(priv);
 
-	/* Link-local traffic received on casc_port will be forwarded
-	 * to host_port without embedding the source port and device ID
-	 * info in the destination MAC address, and no RX timestamps will be
-	 * taken either (presumably because it is a cascaded port and a
-	 * downstream SJA switch already did that).
-	 * To disable the feature, we need to do different things depending on
-	 * switch generation. On SJA1105 we need to set an invalid port, while
-	 * on SJA1110 which support multiple cascaded ports, this field is a
-	 * bitmask so it must be left zero.
-	 */
-	if (!priv->info->multiple_cascade_ports)
-		general_params->casc_port = ds->num_ports;
-
 	return 0;
 }
 
-- 
2.25.1

