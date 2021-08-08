Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859103E3D15
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 00:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhHHW5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 18:57:23 -0400
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:33075
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231158AbhHHW5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 18:57:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HILeJxB4m9N0jdiYe7vCT+GfCqOTzuAf+Nvpfll/lSog6DDEQpv05DO3CT/lt42V9+tO+29ann7bmfAQSU9FXJqaxnl+WlVzuoiUKwnAwdam3aVC+CmP6jZ2QIAFGvr6lxCeR3nv9jKS6d/fKb/96Kt4DG5eG6NbuQrmw+K6rpsXss3/gAX36kuI/vfRL9TjOUn7qqRo/SrIl/WklVlxjCwBtFjlBoJ+EWcUJjEwVmrHiOrwf1FkcD66NYtPOK6Jdou50OyWXH3zRbXfELTnsTr8zYD77BkD8D2lFSx4jcvbXFOTmUXwbaUqi9+GRXgzeKou1fb7QzZAi0mJhcrPVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEPHtwAKFWT0ZwCpDq+A5bCisL7PkK7p4pyFo6JP9Ck=;
 b=iJiGmx/fZCHe0Y7qK64PQsuYLcm+a+M12/0SoLNiHzPl3uB/3on5HpiAlZJeaFPJbwmhXetCXhSl5kdvwOubLXbh1cIqEDr6ofthr9d/jZoZ95W69JLLBC4BtZNMWDifTm84l13uRX/NMBh3OIftsHCLzYBi1OwzacjI41WMbDMXMbs4thvkBHRP1hu5bpL6IYdc+s/WZfLfM0kzzEP2hUm8GfXMco5kS4taEfw2j57YZ+5wPWYB++1vKWEQw/RBs8xDyp93CSaTtuQJs0gRCWNn4InESSI1odf240PxEClwLxZbeDfNj2rDZLmdaAY3VjwRYtuI970GeJjt3YeltA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KEPHtwAKFWT0ZwCpDq+A5bCisL7PkK7p4pyFo6JP9Ck=;
 b=IBEAxAX4r3X1o1X6/i5mBQdFDskebREGu1SqbHWpmgpL0AOMjRAgHlChMesKmRrR4ktgxzSFIQ6WYRiAkK6R5b9LlIpKNNX8VyTa0OqXtp5qfAnYhNvHIVvhXHepI1OdHABLiuxnKfbp6wAK8VkMNnz8Iv+lhh37beGZTFv8Xt8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.19; Sun, 8 Aug
 2021 22:56:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 22:56:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: still fast-age ports joining a bridge if they can't configure learning
Date:   Mon,  9 Aug 2021 01:56:48 +0300
Message-Id: <20210808225649.62195-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210808225649.62195-1-vladimir.oltean@nxp.com>
References: <20210808225649.62195-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P18901CA0015.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1P18901CA0015.EURP189.PROD.OUTLOOK.COM (2603:10a6:801::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Sun, 8 Aug 2021 22:56:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f5532f4-d796-4e03-9c50-08d95abfd410
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB73282FD522855AF123DC2AD9E0F59@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JSSlMIonzHv1kk9HdoJFMR1WXMb8OgfBuBrG/NsXC3x253gLjEQAql3xhV0STinLN7PqUujRJY6gJ8kOC/KhQhDTmA1dKYP62hYzXAfpJngADoXO1/o9U0FPtyAG/rOeaKxhaGLq3l8cP35veny8j13BIgOmiDz+V+HgJBMrER10KxS74L+2C34udiQHxO9yUD4AvaZha8PP5k+cbsnybr3yLcvadKEg4Ootb3PwbaaFdWXAzAUPoVGnwBwEnJaiorFtHbsrrK/FKTVfofGcayWdrrHdh6PY0NY1WqiXicekWpGl9tmGs4TvvDpxlv+wBc5Vnf0oxYayhtnPydbUPwk6rsxCVsUvanFi49tSPVWEtf2+kg4Ra2Rlox4iBHjayXBZlW/RmNQ2mIIuthur2Ba2m9OsmJvBVmrPhug1CByxT1nd6AwZ139w5jGdw9/UYz1oz8v8kNWLf4MMGDr4DJfzVcEH7zEGB4QHEjDA2HKMF7M90IjsFKinslFT3DDNg9AmvNU+jg8nB9gCzGhj43O8RfKkPFhjutnTj+TAeaedkGmIH+8Yt8dp7qRYPywPQSEVYIrBGaJLNdWBUxYaMWY6V6c4SW1/JJ9IntQ/TJZFloSJNT9Sw7girzNJAiwn4sCsJ0hmlosdpawNYsJQzPIUIsEV2EAKmtLexY9CBxzimmqI0cmjwWl23YS08ttbovkfZ5q7nOVOrvU79KZsQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(36756003)(186003)(5660300002)(110136005)(26005)(54906003)(316002)(38350700002)(38100700002)(4326008)(6666004)(52116002)(86362001)(478600001)(66476007)(1076003)(6486002)(6512007)(83380400001)(2906002)(66556008)(6506007)(8936002)(956004)(66946007)(44832011)(8676002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZJ1acU3uf/fDodHKSaxQnRjE3QRJw2WNoA3OiMEdsKUUk2fkYlh9/osR9gf4?=
 =?us-ascii?Q?Zz7cN0UN3FQ/n4R6Sg9NTtBDB67IRg5oI8wyToQAcZiPnzObUQ48m+6amMZ4?=
 =?us-ascii?Q?9Lt87/tU2uWqXvD9mQkaWQ8tVUiJ8fEqIKmhNQ86XNyF/A2q0R6vFWhLI8wz?=
 =?us-ascii?Q?EhvKWR2jSMAMFX5JdqcXjCrM7WbX41YNCDl+Krg/FeVg7iOdXaWbVgeXAL7A?=
 =?us-ascii?Q?MBfvY74vfHdWEWdZcA2hOBt9P4b6DY04zaJlIaEPL2gD6Yk+35bgbNvHDoa/?=
 =?us-ascii?Q?cXveBIJP8cQ10RFQfhajWFhWMmLfSoYmyhks/etb/wpwJx1xf71rRwKfFgDM?=
 =?us-ascii?Q?FvClPwBasica6lRJkJHDHOumdjGIegJ6+0iXySLj2dymssrQre1t0K6UZEnL?=
 =?us-ascii?Q?CLWHp6FCUkpw+qY5nO+VjGhOva+gqwyyW2VLSVyVnIZP0xOgRQ7OdGVZ+R2u?=
 =?us-ascii?Q?OVEhTVM7xeAZs4cnbrO0zS93VvBnXikEM7gI9M0WfDYXZNdtGBGHISGG7nPD?=
 =?us-ascii?Q?VCZtYlOwuVEGLoOpW3riHjZRSPnoqXv0ycdkIeDTHIwwreJGhPRNhCmWm0Bw?=
 =?us-ascii?Q?i7stNgaewTYNzsSj4a6n5Zyugn/kVbhxVI9vhd9XfFfTVJE1NnooU2qNqnnt?=
 =?us-ascii?Q?V9wukiscVmiRha5AxuoXLVcFi3U/sZWVj5IzBhDynfD1BAe9nawFxXl1AXMs?=
 =?us-ascii?Q?pOwf4i+9OY8L0VyXSSiCy4PcM1Vu7ZTxO4Rp0mLmDq1mLrrVlnDb9Tv/Z6hQ?=
 =?us-ascii?Q?R/steDrQW5pVrU9Cmq6REBKkBtDfimirRbxZE74wRapk0pDYGG0G6i1nS0mf?=
 =?us-ascii?Q?vaWUrHNr7bWsUAZXlDqlETWT1pO0QcS7WBtjy7BxkKniaKpmba368Y2vtLpN?=
 =?us-ascii?Q?tAIP6Emz7xK9gcRhF9LAnagcqkjnc5pnrLN7OPZbytnoLQYkkrr2QpdlvXdj?=
 =?us-ascii?Q?gSI7jnCkA2ocIjDc4ltHlwc2E0Ix5Rez2YUHragTfnkopQItWJWsyPNOl8UP?=
 =?us-ascii?Q?7mgrofXDHBte/JPsSmXhX82f00Zaf5iMn7+lew6EatgGTaboTozc0j5Sj1B3?=
 =?us-ascii?Q?7NThfzXFjcMha6ph1MDICIBhPRq4ZuLBneDLrdhfszjXUnY3UaXnBfCNAp8l?=
 =?us-ascii?Q?M8K6G28LMFzAe3tPb8uYlrkUGvhIC6C4gofp0eC/uQYScImKywYT1b0Fh6pY?=
 =?us-ascii?Q?uUSrNh4/TKC5OOzXt5ktzhLXl56CEhkxaBtBx2qZCA9gwy0uHDMunt/KlsyK?=
 =?us-ascii?Q?A6h4Sg1sr5qsaKwXLyjqglAmFY5Gc/f549iQ4+90mEorbXCOK+fnoxOg881j?=
 =?us-ascii?Q?wp1E+z+L1qTT2Wad4Kwn0sb6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5532f4-d796-4e03-9c50-08d95abfd410
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 22:56:59.5096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U2tp2hMFvwca160CAik0YBRkdKldzQV3+GcyegFAJaSvF9/MSkH+cmX/mbSxfrx3bgxHIvR1uIpYLxlcW+xvvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 39f32101543b ("net: dsa: don't fast age standalone ports")
assumed that all standalone ports disable address learning, but if the
switch driver implements .port_fast_age but not .port_bridge_flags (like
ksz9477, ksz8795, lantiq_gswip, lan9303), then that might not actually
be true.

So whereas before, the bridge temporarily walking us through the
BLOCKING STP state meant that the standalone ports had a checkpoint to
flush their baggage and start fresh when they join a bridge, after that
commit they no longer do.

Restore the old behavior for these drivers by checking if the switch can
toggle address learning. If it can't, disregard the "do_fast_age"
argument and unconditionally perform fast ageing on STP state changes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 96a4de67eccb..aac87ac989ed 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -60,6 +60,21 @@ static void dsa_port_fast_age(const struct dsa_port *dp)
 	dsa_port_notify_bridge_fdb_flush(dp);
 }
 
+static bool dsa_port_can_configure_learning(struct dsa_port *dp)
+{
+	struct switchdev_brport_flags flags = {
+		.mask = BR_LEARNING,
+	};
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	if (!ds->ops->port_bridge_flags || !ds->ops->port_pre_bridge_flags)
+		return false;
+
+	err = ds->ops->port_pre_bridge_flags(ds, dp->index, flags, NULL);
+	return !err;
+}
+
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 {
 	struct dsa_switch *ds = dp->ds;
@@ -70,7 +85,8 @@ int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 
 	ds->ops->port_stp_state_set(ds, port, state);
 
-	if (do_fast_age && dp->learning) {
+	if (!dsa_port_can_configure_learning(dp) ||
+	    (do_fast_age && dp->learning)) {
 		/* Fast age FDB entries or flush appropriate forwarding database
 		 * for the given port, if we are moving it from Learning or
 		 * Forwarding state, to Disabled or Blocking or Listening state.
-- 
2.25.1

