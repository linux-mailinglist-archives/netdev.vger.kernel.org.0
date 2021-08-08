Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DBE3E3AD5
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 16:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhHHOgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 10:36:18 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:24033
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231823AbhHHOgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 10:36:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQc3/ZTLg+qp+6L56I2w0BXXJYfJ6T6pcsfj7iCz9iT4SYnTjF+LdCXH8O1Q6a2DFYKHM/yUL5/BTM37uTqwWLDt05dltZOm1KcSje7IQf1eldAFUcZh0Li+8ttb57gds2av3U9AosWY5gaOrSarqdt8h6AeLFu/3r9kcEILtEuaaHg7JEDzZ7FnB7lEJY4MBpwiwE3Oh4KuSCYyXYF18Yw5KhoqgRQwha6V4c9yY4BOfA7X8J7OJ5aXgsotMjKPXKwZC76E8MzGSwJmYBwwPHjFwJhJ35T9XJgGMKOWpk/mNHm5ErUcE07/DefAsxW5RsUxp31Vc2i4qjhUQjAR8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNbGn9hyQKLDb6evHU1bU/UYF8ldHeNJA/5iCxtBvFk=;
 b=TY96XaAzla+yG3Nm1o5zXxtKd5hNgTYeXlHhiw7EOcjWYnhmdY9Mp1HE3Q9R8NjCsS3ulYK/esDfgu6ks/cbhhn2OOdoCRTJXFrIIAvLlsqz3VYQTFzEI0bDZvO8nkeQ6jO/MavF83DmSJjwjiUr/AGNCtSypyRmQw/qcr6+cmdQBAHnXIx65pF+DoAAS7qv63JlN6Cw1gH1pO+KBH/q19j5n9y1CrnVX6GRLnyKCQL69QQQ3cV2NQbufItPtLl+7SvFIwn4x0ybW/efXDhQ1X/e04b2DU4Tljgxj8zcIo7DAwcAA1zq9XAWjQu9uAc+EcLcZwETLRbOjBE39b1AVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNbGn9hyQKLDb6evHU1bU/UYF8ldHeNJA/5iCxtBvFk=;
 b=AeyHdoUR9ywTmaLIjMfM9IkpOZHwtBTzDIbq6XpS8/ykCRjdYDb4oc3iFHjuQuTft/wUwU2Zu3v4xKm+6HfA/AYSbGK8lHTFckwFtTvpMxvk7r+VBAufPTILbAySFR44ZbGsXG5lFvKNr/8Si3TC6mtpnAPRgIC69R3QS/4RcpQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2301.eurprd04.prod.outlook.com (2603:10a6:800:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 14:35:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 14:35:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 5/5] net: dsa: sja1105: add FDB fast ageing support
Date:   Sun,  8 Aug 2021 17:35:27 +0300
Message-Id: <20210808143527.4041242-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
References: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0003.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0601CA0003.eurprd06.prod.outlook.com (2603:10a6:800:1e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Sun, 8 Aug 2021 14:35:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6660bab1-9436-4e91-0902-08d95a79d1f9
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2301:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2301A0A8FFE1D86ABF5407EBE0F59@VI1PR0401MB2301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8QIgVHQqlKDfPgmZWKglxmCowgzLR5g/jdO8hFivXUNkZu7xyz9iCgJ4DpXTrQKzwEkc0RgfwieiE47JY1B+4YxePyrcE8m3qW/Z+ksuojWf+M3UZYbFG/9cmgIpbMEL0jFeujUjyVrKZYiUIHeKeDNl2zp0JRd/jt1rEb8tCI36fqJiMZMWJpvdEQqBDF1XwEiMzpWKT48iY0CsUj2RTwdikkIksO/j9+R5eHlawJg+JmKbnAWxtwZW0DvJFmxOca93IeIinAGHrs+dJWok87oNVTxCw8jZYho/tbxIGaM6jhQ5BQTaujeW+EXpuiREIivqU1nWRWxyydpBrjsRrcPNPPfGZ967v1otiU7nIodHwWdoH6BhMgV7jB8lm4f96FdXxO3BhQ3fe6JKrJ+JhYzgUChncb2SyeGZhYj/q/jYT05Z0fZ9RSCEmFx18sSJ13A7/heFogiBLLlJk8eeb9HvOvUmIaBTeakW0UKGzqiNF56V6pn7mB/AqqmBiXdOYzJcXkgvqE99ohpgbdH1niJCmzEujn82jBag3qZ1cbTdlAlxc5/oaTRdHKlWPFF8070zAOV9LPGphCaKJig72Dn0zI3KacjbrnYm5Fn5G+CoHu20q13AhDUY4q0IvbkqP6zdnV41dU/9uQurHOMdocsazOOxH4+EVQ9JrDU7UcuEOB7stURiLHh01IcG23zK7+se8+SvAk8yTNRzQq3KZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(8676002)(6486002)(6512007)(956004)(2616005)(44832011)(4326008)(6506007)(186003)(2906002)(1076003)(38350700002)(38100700002)(26005)(52116002)(66556008)(66946007)(66476007)(8936002)(83380400001)(6666004)(110136005)(54906003)(5660300002)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?28VqqO2fRjxdbNDYyJixkEWUSEf1jZoaYQtuSIMmpMqzG7Lj7EEyXXrBcJfs?=
 =?us-ascii?Q?MZPhUz2WY1wdP8tu7DyHNgBwXqJWSZSnoxZpwqzaWUAfwSE8Ter4b3hXcv4g?=
 =?us-ascii?Q?oDd/8daSui7jtGZAalbc9oE/v8bD0Dsmk76Ss/lPQNz8R8FPO+VhN0w5XejP?=
 =?us-ascii?Q?ci9mpitcAKsQ58eIAWcbmDuTAn7jwFwDWQ/wVF9iypp7KLudPnCVfav8ualu?=
 =?us-ascii?Q?u6uWipQu1ZPbt+G3y8NsYWJxH7BHMur3eBlqBs3xOMLC4NgoYaRchxpbof+Y?=
 =?us-ascii?Q?QXaR/bVyov3zndjOc/xvXc4kgRbJ5b/1SjjKRKaKhYLJNByr+wTB9OjtrQrX?=
 =?us-ascii?Q?vBOqcBw/Lzf5H3yJRpe1X7z1Ckv9oBNafHYXkMcQB7jD5Q1dA76gUcNbEnhR?=
 =?us-ascii?Q?BEBmieooFVPxa7bZIYmr/36sepAmI3tb+QWcGEyIATolwePEEwaVuqE4FlFX?=
 =?us-ascii?Q?1PPZhA38ifeJNSqz800YSQNWBmPQKyf2C9508T5lR5UCL9xJcAZ4ro2i96Zt?=
 =?us-ascii?Q?kVG8x3xIS3q+joXo5e+ggVEh5muessP2cwnaYXdZPk/qvGSuZRbfkWkAmqZM?=
 =?us-ascii?Q?pp+tnbqv+NM7jf1VQhgvR/GR+hsYS7/bE/at+6BROAZFDZipLaryYA9xoIq1?=
 =?us-ascii?Q?dZv23tqEK9PL7jsX5d8ELO8IlF98RS6x2gMELMAYo561sPYjTe2SC1X7pm6A?=
 =?us-ascii?Q?8Ip05Mv55Ig9rgO57OXb/NhaU5PRRMYTVGPb8VZACB1SSFwJGkRMli6RDKEs?=
 =?us-ascii?Q?DGHWl+a7OBES39gDOgotAWEz3JL1B0+O24t89cMQK46bAW92u9OQvnRe5OV2?=
 =?us-ascii?Q?9xJnMpSdkpAlbgnGky4h/Fr24wMZmPA91IUqkUhgNpPCyTgZ9/TDDwtNMzOu?=
 =?us-ascii?Q?ApgceadKgbIW2MJZHyJuTGQziaP7AMWZEfXygSqTCPU6aELdyg31cWAdt1O+?=
 =?us-ascii?Q?64SxpVRGV83D8sJ+vFqjLaEkBszNa3SgOubqT4nvqXSEygAzHjgcvzueGb1K?=
 =?us-ascii?Q?giZIuzMH5d2OeLvMmAOgV7Q+xJJhe9WVwYL0iP7I8uFs3bM6iWo1fC2z9uwT?=
 =?us-ascii?Q?c7PbyJZ3IQ8us4SD7T4QRsUH22nMohFwW0zInK4rQn2m0In0/4T04un2MeYM?=
 =?us-ascii?Q?BshnUwQHp7APasYh5toHuL68Ztn7/nEUUHe1cJ4efveWYkMxlFlomVuqOsqN?=
 =?us-ascii?Q?Jv4eQd1kqFgJ4Al444idR17usbdo4YSdZ41DTAumXk2MtW0u0n6DZx6VNbyW?=
 =?us-ascii?Q?c3gqjTxrQz9aFWE4EnhIo1or/BLNk9aqeYGZy49UKrq6Plgl3Es1V4tJzj8M?=
 =?us-ascii?Q?iGwB7cnAEvc1nm3YSNewkTYc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6660bab1-9436-4e91-0902-08d95a79d1f9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 14:35:51.1146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DJvCp3amSRXzy2y+MAsT9cqdrNmDT4Cx+/71UmT/1/oiuwQCFrsmKeD1WI5J7BsWdF8IjhypXia5f6zuElwc4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the dynamically learned FDB entries when the STP state changes
and when address learning is disabled.

On sja1105 there is no shorthand SPI command for this, so we need to
walk through the entire FDB to delete.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 41 ++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 87e279be89c9..6a52db1ef24c 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1794,6 +1794,46 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static void sja1105_fast_age(struct dsa_switch *ds, int port)
+{
+	struct sja1105_private *priv = ds->priv;
+	int i;
+
+	for (i = 0; i < SJA1105_MAX_L2_LOOKUP_COUNT; i++) {
+		struct sja1105_l2_lookup_entry l2_lookup = {0};
+		u8 macaddr[ETH_ALEN];
+		int rc;
+
+		rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
+						 i, &l2_lookup);
+		/* No fdb entry at i, not an issue */
+		if (rc == -ENOENT)
+			continue;
+		if (rc) {
+			dev_err(ds->dev, "Failed to read FDB: %pe\n",
+				ERR_PTR(rc));
+			return;
+		}
+
+		if (!(l2_lookup.destports & BIT(port)))
+			continue;
+
+		/* Don't delete static FDB entries */
+		if (l2_lookup.lockeds)
+			continue;
+
+		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
+
+		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid);
+		if (rc) {
+			dev_err(ds->dev,
+				"Failed to delete FDB entry %pM vid %lld: %pe\n",
+				macaddr, l2_lookup.vlanid, ERR_PTR(rc));
+			return;
+		}
+	}
+}
+
 static int sja1105_mdb_add(struct dsa_switch *ds, int port,
 			   const struct switchdev_obj_port_mdb *mdb)
 {
@@ -3036,6 +3076,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_fdb_dump		= sja1105_fdb_dump,
 	.port_fdb_add		= sja1105_fdb_add,
 	.port_fdb_del		= sja1105_fdb_del,
+	.port_fast_age		= sja1105_fast_age,
 	.port_bridge_join	= sja1105_bridge_join,
 	.port_bridge_leave	= sja1105_bridge_leave,
 	.port_pre_bridge_flags	= sja1105_port_pre_bridge_flags,
-- 
2.25.1

