Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6473E01C6
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238399AbhHDNRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:17:10 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:63904
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238339AbhHDNQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:16:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ETo/R/qZykIgtUzwH38Cy3cfJ+pyXPX3FX7ZB9FXLb7kusF4qgHFVqG8xsJouBK98HIkpHaEMu5+RmJjTyY0Vhz9WQn5Qs+bWAd5A4xd2xOgfGMswc/YwW6XGQB/kYSIIOUJ7eJSE8k27GGJBrZYNKbFeCkKumLlGxjM+xnKmhLGzSKTcY1vjfpEzfS9AwYl9fH8GoG2i0cOR35P7TS5zLW6FGyS61iPO5R4k9PB0xjBTCHWfrs0ygVikBQ21wLXTPe2I1/ng6UPE4iPUkNGSOBMBPzzPaeyw2gvkRLKmXAqvXuGx69HhVpB8OSm0touot0wjxvZQDlc9hCZiylyBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amoeNrWJ4532H2p7QkiIVWJGcprWXA9ktT8T2gaXz0o=;
 b=NZcRMWaZ0lXDgJZcBdtzy4idKQfys1NWKlD5y8Wr/s7zA4w7sftAMRJh613B1BtObSDvVpZX8WvU2xHp1Ptf8wke4qYcHgmmL9squ0LxpTWgoxjsyUEvs54soqyzCfF99N3IyZBQHOLU6jbBqrIr9QdFQoZkUdsFO4Bk0hnHEU1t1aj2q7iHm0cxbj0emqWNisau6HgF6ZNqBSaV8i5WneSwxltDltI0IlUx0cvm8LcCv7Wk750gIbZKWSCYqGPYUxdkK7VL1v0H3ll/rwi0HFIrp2azh/6/jXU8pyTTaD/El+RBxs23rM7f8PGxzAN4xLtEn/F7z6QigFBSOSiLWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amoeNrWJ4532H2p7QkiIVWJGcprWXA9ktT8T2gaXz0o=;
 b=VAG6o5tR3od3qsfMwvntjyZuSX03l1TetViwbgFZtPQUY1D21bFSvaLnaRrAFCqP5dh3rp/p0MaKRpnDwqpBYhvUKRNw8EfGRNwH/drDHJWRAlN3hKrwRApt3PN5GtmUtSSOOt35Wvb8EM2FTKDb9uCU9lnS/GuwSFea7BO8Hak=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 13:16:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:16:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 3/8] net: dsa: sja1105: configure the cascade ports based on topology
Date:   Wed,  4 Aug 2021 16:16:17 +0300
Message-Id: <20210804131622.1695024-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
References: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0083.eurprd03.prod.outlook.com
 (2603:10a6:208:69::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR03CA0083.eurprd03.prod.outlook.com (2603:10a6:208:69::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 13:16:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73d1af8a-eff3-4be6-7a61-08d9574a1afd
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39672599434F4B8BF9E10356E0F19@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v+zLDmuqbf9yG/33P92lsy6ou4LCqa/fSdvxJHFafbn5z0j1p8DmFIwyw4R7/vgNokc3/hL6DCTrY6imxzkq3p/Sgdc4255TskwBnILJW2oOcf6y1FSrUjsGMsk9bNyVhyVjOMSzBYCENBCfHMAiqtIEINHP7TKAnQVOynyOhenK1ZiV8IEWQEOQAHYgdhTBU1r1HQIwpHE7yp08cMT3BZ0/2HWR0P1tRSWmKMYMkm26feYgR5sJc9UjNqg3K9LvK08B/d9uuV7pr6P2vHkpJTvJZqi22GYFP8Z1EPfAqdYjhKt+mJXIFcyp8vuyfX0G8WAGMUrhdLqxriCuv2EF/QBtuUUzGw3wd1q5DopX1CyluKAWW97d96j+oOa5ZoJLeT9Hfwl9YbZv1uXs4GMDnyuIX3nhnWJgtZJnjRPZvdBvGGt/NaDX4JYxptazYdznaXYN6GLEiZeSivzGb5+thCXOiMnT92LE9f2ivu/MmhjDfcwvP8DLoB0FDHP8wCce2z/D+32ACARIXj2iejauF/amfGyYAZVvIkWM6izQ9fI8ICjbZMGT/UswbY5mHmikEf3wsZXA10wCNrIyUqgsxvTtZn2TpeVrs30kWF48hoKxbCBat7RtIkjFyZiIXaUgTofjHGy3nxTp13ydjMw9R24kJY7s0ov7lKaMb3JmIN2N/sBnTub3KjIzroEnUq67
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(478600001)(36756003)(1076003)(66476007)(2906002)(6512007)(66946007)(83380400001)(66556008)(54906003)(8936002)(86362001)(5660300002)(8676002)(6666004)(316002)(26005)(6486002)(110136005)(6506007)(38350700002)(52116002)(956004)(2616005)(4326008)(38100700002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s6c/UHRcCcr0uVrtGuMOzseM02PW67eTKnGfRLutNl3YQjixgpTqTAPlhyep?=
 =?us-ascii?Q?AhRK0aHtPc+mNURBlKDyrtTQABUXrwmJ5ktkm28OCbjrtK1HLuw30oeg2K+L?=
 =?us-ascii?Q?Gtg/xx66GynWZbzFq6K45+CskLQItyd4kIEkvJvgJOuQ4kqAuOPg8uHseF+q?=
 =?us-ascii?Q?SBP2W3KtJB4jzqxoqdUOHmqqysCwIM6zpcE48WFcztLinpJwaf3/YBMBkDNv?=
 =?us-ascii?Q?lWaQWpjJXnqrdcs4D8/Kudw2/UNLwAJvru9WzXicQrjAVi3ZEe+pyPBxhKCa?=
 =?us-ascii?Q?fFJ7bd+NZHLVIhVvkWDyqO/BzccD6Zik2Udl0qu+kUtHfgGGJ4qMfIcAw/x1?=
 =?us-ascii?Q?b10+ZKBYYoeOf3g1CMNxYg4BWEj5O6ZIW6Qx0r0nEBoVSYxtV3vPIyZEfvJP?=
 =?us-ascii?Q?uVm3OMQC3jG/YlietuiNJKJSGYVGcttMLvXT6f0wtuE9xJsBIkyLLkNl+3Ii?=
 =?us-ascii?Q?38m1f4bHRIuQnKh8lCiFuP7xxX3ISllabQpQkhHODF9M1DT7DiMJZmOMyZw4?=
 =?us-ascii?Q?DusIVFDaKZPt4HGSxhtc0/rFjjrx5GYHb6HiwVBFJEijQ+kREbI5xoQzSOUX?=
 =?us-ascii?Q?PPCvfgtV3T87Lxv1/h2R2mmXYUZjR5DF0rbNhCwGR8+mC9dWSiUiJp3oRD+Y?=
 =?us-ascii?Q?G2w3Qb4vQ6Mcnu3WjhVgtuVrRAIJImz/lrznlXsMszFF8DI/aLvMFFkwauKd?=
 =?us-ascii?Q?zuEIsxSDgx958d/ryTJ8uQUL+jOj31E3pmTyDbpr9Hlw7sKmpV0SpGRS14TA?=
 =?us-ascii?Q?m0cMgatnVkfLCIr+3m8gTePWsvzQ8nMbwIMfbuAkRTFL7kGkMHdHhYVS0WRH?=
 =?us-ascii?Q?B/CzdqIrbqP3cwm4yoQqP1MO9B8aP8qLDyWoRLyBXlmekn3t+ZQl1C2ww35s?=
 =?us-ascii?Q?PC9ASnuzPL/NgbCr389HYnJFZ3Imzw7DUlEr+LVnsLGTegf8EbE30jETyMx3?=
 =?us-ascii?Q?um1AcDIoSM7i6FNcvyNdDCqF4yMkZRAR5v2yxxiNG3/HKdxkBPYmLb4RYh4Q?=
 =?us-ascii?Q?oG+JXB0s17IjIxmO2rN1U2/uCkwFxkWAwyCpZdBno6bdQ0NUvz2k8j7cQ9pm?=
 =?us-ascii?Q?03GUh4mwX7KkalG1kaT1jXXp3+ESfF4nk/2S9lPl+8X89q/0LzTd5+w28UTx?=
 =?us-ascii?Q?ZnrE5PTFaDi01U4gVKpxFrDDJvhaUFIhczAfThICtdcd8sDuNv2hBGpsGmb1?=
 =?us-ascii?Q?Jba/H96rH6LEM2qi/TUWP8xLjkIjtAW2oRgm0n9reiAtdcq88I4k5NZTSrIR?=
 =?us-ascii?Q?Vu20HufoeFUn2CE9VKFTT+yQfeuO9YGKOXRZ28cssLYvHESeoCY/3oJ/qW1I?=
 =?us-ascii?Q?CgvPV5kzlnEXf3e16L8FrSxT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d1af8a-eff3-4be6-7a61-08d9574a1afd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:16:44.3490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jq/tl9O8sDrcrsobyXsW4mK37ymxqD20DamORdw1wLcpnDeC7vV0tB0Nj6lOAsQyncj7O+AIKLcHPFKbw7IGlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
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

