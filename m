Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CA748CD09
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 21:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357580AbiALUVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 15:21:51 -0500
Received: from mail-eopbgr140085.outbound.protection.outlook.com ([40.107.14.85]:61495
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1357584AbiALUVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 15:21:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faKz12wt4KGdtMDwf0Dp7qvhFk6p/ToEJo615dZPgO3qyheAIP+L8Mabz/LIOPJz/MT8/o2YGqf595Hqby8rzp37djfpxIQ/aTsS3ME4Qr906rvm0YXm5TBl5fN9/wYb2LvYj2EYCyYxxyOPAi+KDkSzCAXJDhz1J3X9XteQTJABAcDgaEjlBO+OUcBjR1+F9kIFGG2Gpx4+XZj6216Rtt8ypi5Fu+apYcbyEuLGoL742kmqrOaq4GYKfR716QXJBn1HimXzL9zahMZ6X5kYs4zG+GRwj5uP7hlyVg0LaMvF95QmOzJMoQrUzJF4Hs4YNCFz2YYlI7+lq30b1yLoEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATqU1ylKiHQ9JNQybIc4hbP8qR3RUxPoiOZQcey1iMM=;
 b=HMPmNkXoqSR5XpdsMBDlEL/JbztkAIz9OBsnihY9mQmS0p5WG0vIMyvA3/YYm/gkmuziXhgPUbVNrTjlh7Sj2KtWWwt9JAkThvmYEd4BlXxKXzsdCU28MNj9Me5Usjv3f37YPEgRf2O5xx5ZeAxOwSw2RxJ49TW/ZYcV3EZCaXeT/Oui/TmL0DHikNrjIftwlANjB1i4NpgdScn10AN1e0We5KGUsew0S9mpM3VsQ90Nb/K6sf/y9Iu8z/udVAoAYngu00x2rYOpV5MWrAYzC3pT0odb33clwTBFpfNInxmI1jaMDRWU6cpM3b/Uvlx1oBtzYGHkNOPENxyPj10i/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATqU1ylKiHQ9JNQybIc4hbP8qR3RUxPoiOZQcey1iMM=;
 b=O1ykhidptOdy8jXPiqxIY8+wMLwymFnncwq3npcLrf+q341YRoRPxHgVn+h9VHlANqH3oXIVrHhuBKABbka34uANAnv3YsOYyI9GFrBanxXN2mh7I5omFTjWdPk9TsyCOGQNqnG1HaIbvEl4xyXrXKgdX9HfCmStTlKLdBwiPRI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 20:21:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4867.012; Wed, 12 Jan 2022
 20:21:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: [PATCH net] net: mscc: ocelot: don't let phylink re-enable TX PAUSE on the NPI port
Date:   Wed, 12 Jan 2022 22:21:27 +0200
Message-Id: <20220112202127.2788856-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P192CA0026.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 510b4756-9878-42ba-25bf-08d9d6092342
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB48137A0BBB107A10B412BA18E0529@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZvZumX7cUkEsSnVhdJwei0OPpVeef93ktrjxnvaLrFuluzUdGOE09S0nyL8MEq4srT+mvhkZPhMcr+pJEmGBLurptP9/nGgONZKdm7i7RJxpoloiC5R8pvG7gXNVQDK4fq8k+FN9BSbg4QSPcjY3nD0S9/PfTyA4rtjmTJufBW5XBBbnC59oLw1TaPMrmI2q7jB7IWU2EL7PdlTrfQMqh2qYNlqTAfKXbo3fr38raBQHIpGt77E5q8M4SZJ2d096DeIeiDsue+DhewgtzvrE8opEwt5m+fA/nJEObo6kxNdF39UEnOLHNDzDnM6n2CrloXXgphbuPDd+D1j8eKNKj6+aySdTcfsKoqnlLeOCFYiAGjhp8Ro7Fsyn7ikXDDp4VjYBBSuXxrLQTxY4Ooo6S3E6FvAzQ5no/GQFtgp8+bDvVlsK2v0T1KqLeOmlHQ/2PWHzYnbcb5hWQGoFv3hshGKOvb6X9mRR8Z0alSAKo9OGomqTowMLsvy4Zdk6U82DegCUo5QOgxWLJEK6WTorMA7W5gkv26MrqPGIGrscktYXxI6zBwipY0yY8Bpx3QfqTp7YLDcvurnnAoRKocU1I9jG6nD6MNkBx+EUxwO8dZGYHZUFVKvF/r8OxlHqV7e8M+DfOt95uPJi0hnQoqv8f/bch77fklPb93zBvoR5cS32zIRXgK5uQ/K/WcyOPmPHf1i6AWvwm2R9J+LZy+j+pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(6666004)(8936002)(83380400001)(66476007)(8676002)(66556008)(36756003)(508600001)(86362001)(6506007)(4326008)(2906002)(316002)(2616005)(52116002)(6486002)(26005)(66946007)(44832011)(1076003)(6916009)(54906003)(186003)(38350700002)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KCDgnfuumTfEbXvjhPkIZ4jhrPpxVmoYGOAuEH8DHyqbnP3pcEONNtzp7+s+?=
 =?us-ascii?Q?x7a+QAob6V8vc5auA33HVrQvdClrgz3drbOP30bNpgJvLTmF0ehFmd9Ssx85?=
 =?us-ascii?Q?lH5r7fLi9663dAMwBxf3LkVlvZcdhBP6aZqskwwDGhmvm9/6HheQy6fAj3mh?=
 =?us-ascii?Q?2B+Lm/X8WtKbHHJ4CmqJfFmO6rvCH1n1fTuh9b7AFaC+ztphwiGouPvjmdc7?=
 =?us-ascii?Q?KcHM6FqdC7E57om0oezTB82MUuCeFpCObD415twlhNQy01cni0ao4t2BbUEH?=
 =?us-ascii?Q?5AYuZ68tCC2lykPHRfvLhaeqswVKacdFFbJFjjnHAoLUyu9jHkrorF1iIgN5?=
 =?us-ascii?Q?jrNffmm6ZCJSLRZV5gCez/87quDWKF1A2eZpO3Xt9/Alw/BA2vzpaGI9AWnJ?=
 =?us-ascii?Q?c+Vc+2+Imjt2hOj3hjwM8WJoPb0ucuTlkhXhmCPaM1MtIr1t28nQeAXdu1VO?=
 =?us-ascii?Q?gzD11ZSjF4I7S/FJYgoL9FYQS9S82koJCcxrTr9MV2TQf+QUSTxgLDZiBRqu?=
 =?us-ascii?Q?wNss13u0qY2BuSsr/StMsH5HmeE02Pw++RJz8bBLZVhNDOocCUgcQjPnOdDf?=
 =?us-ascii?Q?QmaNHUwMigZhHZsbWqR/BBzrOsdLiqZNvJMQ9FotIz+34NoyrEB7hWBOHkuE?=
 =?us-ascii?Q?+WyXilpNLNaO38YaGLI6HZXQvawFAF53kIWFDAvfI52KPL/JsnrcKGSJDeQX?=
 =?us-ascii?Q?RoOz3Ja8bAchzBbZBgn1ofUdsx3rfv9RxLdZbJxFmowEE6+NMxS3cj4ulaFo?=
 =?us-ascii?Q?SYixwlwessk8GwNhE8mGyWvmgAJ12F28YYQJocOigF+d6tzdjXlpUVj5jpN4?=
 =?us-ascii?Q?S9dv0Utm5v0jeO7gaLr4jU6WfL8RHlgSO2nmnlguVUUhhibNMW65eqL0XiYB?=
 =?us-ascii?Q?tvGo+2AvLdRqmIIL2JGupfwUHj1RnPhL8zutnU5/tsmciSJNCvY003bmwC9v?=
 =?us-ascii?Q?dZkz5wD6YLhEzaoeSUP9gvByxm9kzu7lYwEVNNjE1zPlqisL5fm8nNP0beze?=
 =?us-ascii?Q?lHKhjUzT+kL0ska8oZ3fy77/N+DjKSlOYZCrHnMNkDVsovjEM2tbetR22Qsd?=
 =?us-ascii?Q?NwgCSuTdRPF3tjWI6IfPdfomn81hAFVKbdczisRiXeIRfv6bfTfagDebkW1T?=
 =?us-ascii?Q?o2xVBPKO0+HPYH1yQ4R/RI+K2Fw8sfDWez7Vi5vr3/QOvxyoCMokWcqISFi4?=
 =?us-ascii?Q?dKsG58C0fyWhgrDyY2xsSjDis6fIWcpTo1R2jO1uVRYjsYM0jfnIqWjsfiCw?=
 =?us-ascii?Q?LJj3FQAmT94HrFcIan0IB2GSGe+IGVLBavAH/Kpg+Kun3XXl0d9MgJyImK2q?=
 =?us-ascii?Q?dwBkanaqqWLks23c1WAWkgK0KHXb0TyKQz9CvQVIu2a8Lr+38AvdM7JY03VK?=
 =?us-ascii?Q?bn/eex8pCdLQIFql+CJs4q7Dkl6WMUV8a3XNHRyKH7QUnADWd0f5yOtDPG69?=
 =?us-ascii?Q?+u77jmq9fiFMYF5SOdsbnY3ZKu8l2ujgl/B7gy8Wc/jqepjE5/1uEweA7eKc?=
 =?us-ascii?Q?JKXHaHrtTc7wTvEdeAcfaCTfWRHRtNNEMbH3rw9y/4SMinAfIQFB1pKy7L5a?=
 =?us-ascii?Q?x2+nAa8TYt2vhxSBMjbOg4acYh2xsarjPnClbJwyQVmjuDx3B04MjckL9HYF?=
 =?us-ascii?Q?ASPfDog3pK9gH+gd1uLIeWE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 510b4756-9878-42ba-25bf-08d9d6092342
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 20:21:38.6098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldYL1wKAfNVeiMnOaKiSNIzA32iKrgK02a8OLc6GosTJR9S97OUmJ+wkYQYd1bJd+2dKeLN+L7ONajNnFDkpiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit b39648079db4 ("net: mscc: ocelot: disable flow control on
NPI interface"), flow control should be disabled on the DSA CPU port
when used in NPI mode.

However, the commit blamed in the Fixes: tag below broke this, because
it allowed felix_phylink_mac_link_up() to overwrite SYS_PAUSE_CFG_PAUSE_ENA
for the DSA CPU port.

This issue became noticeable since the device tree update from commit
8fcea7be5736 ("arm64: dts: ls1028a: mark internal links between Felix
and ENETC as capable of flow control").

The solution is to check whether this is the currently configured NPI
port from ocelot_phylink_mac_link_up(), and to not modify the statically
disabled PAUSE frame transmission if it is.

When the port is configured for lossless mode as opposed to tail drop
mode, but the link partner (DSA master) doesn't observe the transmitted
PAUSE frames, the switch termination throughput is much worse, as can be
seen below.

Before:

root@debian:~# iperf3 -c 192.168.100.2
Connecting to host 192.168.100.2, port 5201
[  5] local 192.168.100.1 port 37504 connected to 192.168.100.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  28.4 MBytes   238 Mbits/sec  357   22.6 KBytes
[  5]   1.00-2.00   sec  33.6 MBytes   282 Mbits/sec  426   19.8 KBytes
[  5]   2.00-3.00   sec  34.0 MBytes   285 Mbits/sec  343   21.2 KBytes
[  5]   3.00-4.00   sec  32.9 MBytes   276 Mbits/sec  354   22.6 KBytes
[  5]   4.00-5.00   sec  32.3 MBytes   271 Mbits/sec  297   18.4 KBytes
^C[  5]   5.00-5.06   sec  2.05 MBytes   270 Mbits/sec   45   19.8 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-5.06   sec   163 MBytes   271 Mbits/sec  1822             sender
[  5]   0.00-5.06   sec  0.00 Bytes  0.00 bits/sec                  receiver

After:

root@debian:~# iperf3 -c 192.168.100.2
Connecting to host 192.168.100.2, port 5201
[  5] local 192.168.100.1 port 49470 connected to 192.168.100.2 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   112 MBytes   941 Mbits/sec  259    143 KBytes
[  5]   1.00-2.00   sec   110 MBytes   920 Mbits/sec  329    144 KBytes
[  5]   2.00-3.00   sec   112 MBytes   936 Mbits/sec  255    144 KBytes
[  5]   3.00-4.00   sec   110 MBytes   927 Mbits/sec  355    105 KBytes
[  5]   4.00-5.00   sec   110 MBytes   926 Mbits/sec  350    156 KBytes
[  5]   5.00-6.00   sec   110 MBytes   925 Mbits/sec  305    148 KBytes
[  5]   6.00-7.00   sec   110 MBytes   924 Mbits/sec  320    143 KBytes
[  5]   7.00-8.00   sec   110 MBytes   925 Mbits/sec  273   97.6 KBytes
[  5]   8.00-9.00   sec   109 MBytes   913 Mbits/sec  299    141 KBytes
[  5]   9.00-10.00  sec   110 MBytes   922 Mbits/sec  287    146 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.08 GBytes   926 Mbits/sec  3032             sender
[  5]   0.00-10.00  sec  1.08 GBytes   925 Mbits/sec                  receiver

Fixes: de274be32cb2 ("net: dsa: felix: set TX flow control according to the phylink_mac_link_up resolution")
Reported-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b1311b656e17..455293aa6343 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -771,7 +771,10 @@ void ocelot_phylink_mac_link_up(struct ocelot *ocelot, int port,
 
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
 
-	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, tx_pause);
+	/* Don't attempt to send PAUSE frames on the NPI port, it's broken */
+	if (port != ocelot->npi)
+		ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA,
+				    tx_pause);
 
 	/* Undo the effects of ocelot_phylink_mac_link_down:
 	 * enable MAC module
-- 
2.25.1

