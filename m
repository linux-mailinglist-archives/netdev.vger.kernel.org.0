Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C54146F783
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhLIXiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:38:54 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229760AbhLIXix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:38:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UclnER/579Degea26H/B4+R+BRe+THExSHjunUzr2Px26+HWA5TYmkpz7y1X30F+udGpuATBApUi3Q4WzTZjui/3Jfy4gMOYBTRMRcjFR+eDj/w9hZavBB1EFpQjDyat9dc4PuDrw0YCAF2COKCYZlFhOtFl4mvbQ+65KGOb3nEN2tU6b8dTz9g8Doh4ONTfcHJlkK+6IlqJDyjNgvNtddRAks848AdBjb4AQIr1WeBgyeYyVMLxlL2saGIb3ABaDda2LIynEneniXtef0xXTJ2s4X0yR0+Rn6YyOqxwWT1ZxsszgpA5HJTHiu/9YcG6zarsrfQ7oNORtxi48CkmAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fK9k79KfWI4KB+WQn2zUxElbR9wxookySNYXUZOQNkk=;
 b=iQXXtJTAFv17hdNSGQDCrXY888/ZsfpQENE+pTPDGbtbqR2eienE0rUNOGsPjc5fIfpdLeEGbuC7qSbnomKP2kR4S2S6u2iRxJksOHSD59yG2n3/vOpJ2jp6hkZyvZmvIqpBEsvkLq0kEfLMdLublDcHpHPzOIX1VzcmJ3mhA5L6LXv8h32r843yNKCmDc7ph69RrlZbta3Qv79C5MsaTES9PtpeF0WEqv+sCC8XGOenZT3rtBxxQI7kBpDYJZgCCZNNZxyxcp58HY0nkBsje+R8DZTlxcyevWy1nhImu5Ux1SD7buWwnu92mMmBvYOlvsTJhuM+H0AlbNVhuhGRqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fK9k79KfWI4KB+WQn2zUxElbR9wxookySNYXUZOQNkk=;
 b=RuryAH++sZozYHNLrtegmzzQBhmmUy6BOCLyPOyiCDStsBig09+FAc8bboMqqplCnv8KE0Y8tIgZV0Pl2Bty/2ApQMJsv6xh/LWn5FcaNJMUlSjFCSRkqg4HOM9IQJNA3PsU6SaWnyvmCs9vYwPhyTdnaGrpZJNLWWs745Z1fes=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next 05/11] net: dsa: sja1105: remove hwts_tx_en from tagger data
Date:   Fri, 10 Dec 2021 01:34:41 +0200
Message-Id: <20211209233447.336331-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ae19fd7-e691-44a2-53d8-08d9bb6c8c90
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408360AB4B052A174FDFBC8E0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xLE5E2Xh9BGD/GukMrENRtomldySa5IqU9rimUTqdKPSXxJPDmjdXb4eZbPPPFgY8DQt3kW+7pTmYypQmp/Jv0V/mgwlulJwu8+rutzN8fO5iqaoGHMrlMhqSxtGf9r3hfObsof5fnb+5VHLsZVXJUYykHWSXpSzf78sn14oYNGFRG5Kw0wtFZ+ENw5cVF9KSEx1Hgbi0xAfcAey3lP4gNiwu8FW1KTY+hq0L/04ABZDyuJjrZyqOSjlopPzaxXg8ImXmOYTLNorfVSPkQJF4K5mHlzefAGdrfQr6/h4Jge8bp+dnIQS2xTVmZHi7W5+mtKOaXZF05TLrAs9y0CAVkRK1Z42TmA4H31xEptU8PkgUmFttO+CUP6cYGvrEp+tRr16Zx3KbYtj6uruCrbZjU1ofwGXDMRQMbJ6GM4AAz9heB+VPwnyGsoR84sNbMTkLOE8MpMrZhCtiGLx7F2lEqQDTyOKt5PqNPRODCIN+VRMpFANcfakdnDyy/P4WMzrmMi2EPUK717+DiujDaSa9JDgspMTQuKyTK6aXBqU4tPUK/kuOS0q1gG4ic6tb/N9jRrbnB6ehhvzn2vCL1hPWw1MJjA9I1MyVMHeYFwvzJ3S5Uu+TAmGe+5Y4vKyNGptBeY8C43vmn2ianTTlu/LMYkX6eBbBijKHMfwYqZBEzof6z1rGLZeafgvntR7kXIijZc89egEpmDC9fzqyZi/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(6506007)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8JwRBAgOM/nTkoly+dv5gQm6wq0bJXu/Q8yO0oFO+6n9439++Ot3QMxqI9iO?=
 =?us-ascii?Q?/MoY9cObOqmHrkyF5p9175gxTsukuiPGtwfm/kWLzuNFGfWLpOaSPgVMreX3?=
 =?us-ascii?Q?HV+jm4BVq1NoSMv1vi36Omk891FEFvk5iaV0sdqT1eDNIQr3JVV0gNuILVey?=
 =?us-ascii?Q?RB47/jeaucmYg6jQvFC3IGMsii6HhItCW8yZTzSFjjelz1GYwpFBMXPWdSvY?=
 =?us-ascii?Q?I7glZXqMl4r9cPDnaT1317c/TRbPv39Y2kVBCl28t3zxxdxMvnzufoW09Llk?=
 =?us-ascii?Q?LUHwhgiVG9ot2n4rewjDhySXRc/C0fmhIU/M6G7Y/zq9FqJaj7Sm7eHQ1l2T?=
 =?us-ascii?Q?1R9KQy9nTo3VzWtv55vB+QHAdlKiXj2uZQz2qXhnb7wp/YC3unJdEqGEBT0G?=
 =?us-ascii?Q?NRyN4RTaav7JRoKjyz1+YLQl4l0wPN9lSL6qfyyiIvmGc7Y7E8yG/rSvolXF?=
 =?us-ascii?Q?ozjlsZLHk8LMX4F38RA78FJ9PfIat7q+fJ2/PBNe9cNorvgCgzeccB5GSv7f?=
 =?us-ascii?Q?wBqHp+J8TvMayNtQ6iev6q9eWAzNxheNcbrdy84pvzgzgYYCFW4VnGMeE9nv?=
 =?us-ascii?Q?PPmUGHLvaeAtE+mW/ZQPWN/uZH6qL7gsVa26mUk0NI75UEbR2CZIi+G7riKR?=
 =?us-ascii?Q?YnsbcumEthd50Sw5Kuhplo3EJiHXubwGwCMgNVdQULoLEZvuYpsLdtg2sXBH?=
 =?us-ascii?Q?DL8iKAejzMp445xb9eKdZAm3IgPj1GUuKQ0INxias7H4UNfGHdmhDprMZnGA?=
 =?us-ascii?Q?XxBUYIqwex6a8YVGqtkmq3lf4F5WMxPylwY8RDpMIYsfOGbF1NfvLE6ZsoGm?=
 =?us-ascii?Q?IAuaApH9ycoWcv6MsakdkBG+k4lzJm4Sdi330Jk9V1X8WxVkyS6qHiMLJKrx?=
 =?us-ascii?Q?V5ckto+hh2EyGnr6w5bLqJ4UFrlwD6AsLMAYkZNo6Gj4hvcm26/6M1wZOk+Q?=
 =?us-ascii?Q?5bG0YX8dgg7h5wQ2SWrk7wpCZrn6nhqcqLvWOa+wZd2oXy0YfT/RN+IxUtIG?=
 =?us-ascii?Q?sPz+7gKQlLES7N+2AFduNVTtogSATenxDxsMg/eR5Vqzj7y909bGLJJ2O5Uf?=
 =?us-ascii?Q?3qMZLL4U4EA33CZ0EQTO+SrF6ZkEFmV7SfUEYYhPN+xPWfA0TnLo+XmmsVDL?=
 =?us-ascii?Q?razpE6nYT6GzoBi1VUjCKLxAw/G64HqAsuPL7Sj+hOL++tn2EHC6pQbKMr3K?=
 =?us-ascii?Q?qB8AdltTcpNCBKo/4iIQmDFS6ptfUaq2SBFHQNZ84yMAmovUukR6ThL2rd17?=
 =?us-ascii?Q?szvrjin9I/mGMpyBlc2xLTsSQIAxLFED6C6IIle3C92lQ3Q+oyUw4D8H0f1d?=
 =?us-ascii?Q?S8xFHEOOZJW1dh36Y86EZw9PfbnGggir6HtUlcmYH86ar8qcxuLnbYWMjatt?=
 =?us-ascii?Q?Nu8BBmzuc6HFcxw0qriYUoIdOvQm8ME4ightOJjs90kOtfcTW8v0iZ02ndKL?=
 =?us-ascii?Q?ftVc4xrGUUH1EjrWUM8NVPsxHsj8AHy7V0Nfj3DHy51I0+LTwDhOw4qTew25?=
 =?us-ascii?Q?nbJiPTGyqGgQESe4A+mo3a+CyhqzFS0M3PjzqL6WnXsT9K1J7nx5aFvbv/nD?=
 =?us-ascii?Q?Ri2OjgOkXcksCMxJoCFgM4NvQwdpdwH2HLDQ/YzFUxXBxTaBYkn7nZuoiAqD?=
 =?us-ascii?Q?izSS7Ml4s2xn4Noom11wWvQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ae19fd7-e691-44a2-53d8-08d9bb6c8c90
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:14.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5NOw0znwDjoTTXkRT3LJsqxAb9wx4gVik+8j1yjTXfveRY9ucR7Y3K22tKf6OeywXoBowFOFMvki+hVLGuL78A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tagger property is in fact not used at all by the tagger, only by
the switch driver. Therefore it makes sense to be moved to
sja1105_private.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105.h     | 1 +
 drivers/net/dsa/sja1105/sja1105_ptp.c | 9 ++++-----
 include/linux/dsa/sja1105.h           | 1 -
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 21dba16af097..b0612c763ec0 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -249,6 +249,7 @@ struct sja1105_private {
 	bool fixed_link[SJA1105_MAX_NUM_PORTS];
 	unsigned long ucast_egress_floods;
 	unsigned long bcast_egress_floods;
+	unsigned long hwts_tx_en;
 	const struct sja1105_info *info;
 	size_t max_xfer_len;
 	struct spi_device *spidev;
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 54396992a919..b97bd4d948f5 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -98,10 +98,10 @@ int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
 
 	switch (config.tx_type) {
 	case HWTSTAMP_TX_OFF:
-		priv->ports[port].hwts_tx_en = false;
+		priv->hwts_tx_en &= ~BIT(port);
 		break;
 	case HWTSTAMP_TX_ON:
-		priv->ports[port].hwts_tx_en = true;
+		priv->hwts_tx_en |= BIT(port);
 		break;
 	default:
 		return -ERANGE;
@@ -140,7 +140,7 @@ int sja1105_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr)
 	struct hwtstamp_config config;
 
 	config.flags = 0;
-	if (priv->ports[port].hwts_tx_en)
+	if (priv->hwts_tx_en & BIT(port))
 		config.tx_type = HWTSTAMP_TX_ON;
 	else
 		config.tx_type = HWTSTAMP_TX_OFF;
@@ -486,10 +486,9 @@ void sja1110_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 void sja1105_port_txtstamp(struct dsa_switch *ds, int port, struct sk_buff *skb)
 {
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_port *sp = &priv->ports[port];
 	struct sk_buff *clone;
 
-	if (!sp->hwts_tx_en)
+	if (!(priv->hwts_tx_en & BIT(port)))
 		return;
 
 	clone = skb_clone_sk(skb);
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index acd9d2afccab..32a8a1344cf6 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -74,7 +74,6 @@ struct sja1105_skb_cb {
 
 struct sja1105_port {
 	struct sja1105_tagger_data *data;
-	bool hwts_tx_en;
 };
 
 /* Timestamps are in units of 8 ns clock ticks (equivalent to
-- 
2.25.1

