Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B053DC1D4
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbhGaAOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:14:34 -0400
Received: from mail-eopbgr40043.outbound.protection.outlook.com ([40.107.4.43]:13735
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234366AbhGaAOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:14:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIaeeUr3WvyRR6OgtWvcX0PHFzkv1TeML3XGF242O6Alp2rAScwoWWhvV8KPQQSxcou+z2W1cvUeVW5ntF3eJf4abBKn2NnDvMcUgRaRKMlVGgd48FBD0ogiaFDj+S2IZV75baUlJ7Rf+AlVF6wdp1Rs97ErBBpRyVxQf6HaovlZbAYoRuksOAJCWmIbtTmai21ccWgobAAuEm/3QpMGVK+rNCX/QDqDtJVceRTwgnGBpdUb19uur4DQksqnW6h0mkKmDhvmRzwABRUTAByBVNSU9vDO6jRqHBy6RpTa+BWdfCnkF9OMNII6g1ULi9ru5ZrZldk2Cc1pvILw97cxww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amoeNrWJ4532H2p7QkiIVWJGcprWXA9ktT8T2gaXz0o=;
 b=EIV7CUg1VRWxgWwffS3qNGtXgbQctWEf4u3dJXJ1TqijpPDNgM+bcCNsa6rcnifLYg9TmhR2GJaxC3l5goyrXGr5XsaPSu5S21n5rrtIDBU95ci77rfaQfHeoyPB3gAEjCiPDBxpoItvGCQtH4efa6yeLlTPZ4wmF+uEJeoNIqLkFuWJIACgFLAIxbGp5Lr5cApcKVo6OwSZvherC30MX7dwa8b1YTe3kersli4VPAxbhIl15JUTXlj6ZejZ8T98/g7KdEW2lyoHmrAob7rkO/QJbF4/dwODcPcJchm/yhndYTO7yp8ojL6cep2W1TlO+BRyXfHt6sD/erg5mwvd5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amoeNrWJ4532H2p7QkiIVWJGcprWXA9ktT8T2gaXz0o=;
 b=ntYEoAnG7Q19HwDuSYQqujWAU4RWmjEcuyA0VgBexomhI2anM2n2fRynIPfcjnZbhqRiuPN9LtR9nQO7X6Pl5OnRKzAZylPewnbXGOz1mMksPzVgEYYzz9JYsmBo5Ch70TgHQGmB3Gir9mNbjcOMI3WQ9U59t/QCfTkF1+OtRMM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sat, 31 Jul
 2021 00:14:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 00:14:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH net-next 03/10] net: dsa: sja1105: configure the cascade ports based on topology
Date:   Sat, 31 Jul 2021 03:14:01 +0300
Message-Id: <20210731001408.1882772-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
References: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0161.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Sat, 31 Jul 2021 00:14:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21b35c65-daa7-4204-3c71-08d953b82642
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6511825CFA284769E246423DE0ED9@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CUrZH70vti25+GYd3HkzEZtn4aHgtr9vH0TcUPQsSe2d1pvN/PsbgH5C/I+dMRbPIlhfLOD4sp6WdCvG4PO80IjchYOOmuN5D7BiBqt/2BXpMX0JGHNIiGQKNdh6qJTi8WF2uMplANTNY25j/8X35rxpjkiSTSRT6/smPdzEAify55kLT9dbT6GEpYi9s1rQo6GoL5OpTtJdmH7bRHDaJlYI5whYtNbFXEyCCG3aF23T1jWD8sV58E1BwNrobArrJHOksrMREiBJJXT91IZv7qnw/rEIY7YGmgShLAXK/95SiQL5YwgZ0EFyuwaE4ks+w/HPFJfqOF+GlM4eDZvkB/c4CRb5a81bi7ikhhSW0WHBZPxBOCXzzm72UiwCkN3o5XgyaU8ebU+p7e8R5yJRBuVxpmtqmI8I3xuQUVUdhQ2lrFo/niDBaFsn6wtJL5fhtJU3N6whQIDd1xkGYXgT+tJDpUQr5NRPWSUSmJL3gOlGTGMM4P70tIh2BxSY9chj+RmYxk9L9oxLX40kjX0EsaCE4ZIVDAWAfjQarEgS71GhqLYts2KkAxn0WBBZpioic6wXln6baTt5ksOtFRgFYRb8HFVIzqjUbozsJco9G73tMHpXSiDsqG6xluvOnLXZplGi4mvCe3+IZm/7KmgwEwvp2i/o5kQ08wYWGsxmJ1Imaoe9YjduYD/wUxicMTHM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(8936002)(6486002)(6506007)(52116002)(6512007)(508600001)(66946007)(66476007)(4326008)(66556008)(956004)(5660300002)(36756003)(44832011)(38100700002)(38350700002)(83380400001)(54906003)(2906002)(8676002)(6666004)(1076003)(110136005)(2616005)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HBU19mBGet2t57qNI9kRpn1Wwdqdls29QC4adAu6/FHKEcbq3fGds+Z1C+/0?=
 =?us-ascii?Q?EEqlo+NTRQZLvo5iQMA22H6YwxT7K247Yv0VeI0ZmdVWj5ISHMnGUyNcIMdX?=
 =?us-ascii?Q?c79jz0Vy7WTj4WRviDd9tvNV6Xy/gxLMe+Q+ktzAsnmGH0AYN7dX6MA2dANi?=
 =?us-ascii?Q?gTR/chzxdBkRKcqmRFNf7L4yAQ+V58h1GLI7PWjH1YfUgp+KNny1A5Nb62oL?=
 =?us-ascii?Q?YDeziFMoFzC4H5ztPjf41jk1JZtQN7hgyW4LQCrAyViSqG2+/7WptbU6/wDU?=
 =?us-ascii?Q?eJnrxh749Twyr0vmfzLfekc4mdl9+FqflZEhmkBgj3O+HLSnLkIgavVmjGlQ?=
 =?us-ascii?Q?QBpGaTBvUhTwUyGdOEA9Nh0A+/7rXuV5N+WwPjmxMVrtu2lf2H8ZtAQ6q9OK?=
 =?us-ascii?Q?fSUTPUVV1FBBm0xC9tfc9YCmDaEACIyI/z7P5gGmbLeOVC4gCDpiZhWu31jy?=
 =?us-ascii?Q?1v55ALfuNQogIAtRT+I7ffiWpSuOnRiKwF1jUyCFr7y9+ScUw2qiIxTemrK1?=
 =?us-ascii?Q?NJTt9IXxCLWo+4IXyaiDahpo+1khCz1HThtPSAIFB+eKMzElJJXtIwDR9jnd?=
 =?us-ascii?Q?9BZSrvRJItd+FhGWRPykj38tu0iutvP2bYcLz8Y39q85j38eZaL+Wkert6xY?=
 =?us-ascii?Q?7gW30Y9e84QM/4WHI4Z0EO3ozu+5rMsmrJHp4sFqYczPySK/ly7iPzA1W4O9?=
 =?us-ascii?Q?0aDnNWfURgRFKI1HZkOkp5htMPKqqL5PRzQQBpb8k7O42RAWY1B2Gj+I5mNT?=
 =?us-ascii?Q?IZK7ryevyT6vFG6qhs5+xM9DhDX9Zu25VycsWiozPsPGgqCKGHHC1QY8z9aa?=
 =?us-ascii?Q?AEmbHbgv9r4qytNF4KxZxpcA+hxidBoX0WUn+IQiuOB2zrhiO8bwc1gTrSJq?=
 =?us-ascii?Q?ACSJK2WRkmfwJI42pJceQPyobC+LPkh+1IrrN+wUolrEhY0P93PGN+baeZI1?=
 =?us-ascii?Q?qm6uzDQqUfq9xJ3T4E1yvlLBWAWjVNjF/NVFgVTO2YiSJNJl2EsGGqmeyLUe?=
 =?us-ascii?Q?z2NdQiFJljKqfM5XDOJRI9Gjue7LLAx5kUezKjZnJSghym5CPHzh+FAG9z0w?=
 =?us-ascii?Q?SZVrpNXfYlYtzOCNhpWgLomQLjXwTQISPVh7REIf/iK9ni0r79iMiBlA/AEL?=
 =?us-ascii?Q?bCF5fAdO7QViuS4JA0+R3dsinriaTXI2GqOCSIDRaSh5BEyRhlxrZaVlfur5?=
 =?us-ascii?Q?7gfPoQCSsZkG91UHPIzZe4Bh76443AG3ghpa/KF+IUsy4OgLA6gzOLz052d/?=
 =?us-ascii?Q?yNGy48WvBzWmaVyLYV/DzUa2dexgAfOrtzPYM13cqOkGiCAj9V2RjzP9AEQP?=
 =?us-ascii?Q?z+gz8qArXgQV5xKphVL5W7nF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b35c65-daa7-4204-3c71-08d953b82642
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 00:14:23.2237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VcvhjbCPekcq/gNTFM7tZRCPJl1F3lzoThalT5nArsOjZXf8gl4cI936fdVc5hHOssdUP/xSYTff2jOkCEpLqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
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

