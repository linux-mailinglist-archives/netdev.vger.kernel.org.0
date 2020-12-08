Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5694F2D2A57
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgLHMJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:09:41 -0500
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:17934
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729343AbgLHMJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:09:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kok5QayCfDNF8Gtiy6SF8m+Hx6TINySVyhBUmrxfZ3XJr5dbyMdkWthqCzhNz7qxNpnTEbWqbhSCcysQ+3LTZSoyp3BVv86VDOA34xuZuQg6AbMj/N4QFmM37N+OA9xkUPkH5VKSQdiU+tSGCpkO8bGWMTNWX2ZvidQkM8QCHwi4/XCVgGa9YKsSPD3VoqjnCgNzXVU8fKCwrRmRIHSqlX0IoYDAVap7J2k71iweiawl1XmblNpXvcOerDGbYmyyiHUZvzOcUVPQ0vvhAg4hqzyaAjpNGC4NAtG8irg6tufF1IDTubQUNJ6aYRJ2kLvByLVo3TutxpRp6C5JCsCOBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n36USH50cpLgULEquqv35fT1Rapnt6FXLE48rPBxn1w=;
 b=jheZ3LwyPCjpUUDImTiFO5JQBEcrV2m0EjD4wnPT/j6usZmQJabaRhZI+VQ3m9cnZSIrI1OG3OgJ4MEFr/X7mWn9U+qrFbnDJ4NJRLFBMT6AiP5t6UWdtstpRFmsxHXczIhVFMQxcPrFYRgsAvCSFS4oNRSin4fOADVGEu7V807DEoTTK3pjcEcwfLeMX9bHe9NUdUahT30KwJINEemwZTwf0df6CpWGeeW5EihnXC15dwBgTUlSA03SO1UzS64Iem2movCxgrCvHDL3TL9aQXPE/l+wMqob/bBvKacMXFg94bvGR1guspEnI8Dln6I0ErPfVNTdPP7Hkhw+yy/ULA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n36USH50cpLgULEquqv35fT1Rapnt6FXLE48rPBxn1w=;
 b=jVSimT0u5T/B4EX0pfAoLEiM3m7orcsAmDSpIS/zCUfdFV0smpJdETCTLpLWAI5PlhKS0cRmfVUmrltnM6Yfde2BjBM4H7EWkXQegyNaL+w3pOy6CBmZOdr+g6e1nhD00zZ10mlesgG7w0HHCmVophSIQONKwtPpSc733R/y2EU=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:26 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [RFC PATCH net-next 05/16] net: mscc: ocelot: don't refuse bonding interfaces we can't offload
Date:   Tue,  8 Dec 2020 14:07:51 +0200
Message-Id: <20201208120802.1268708-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 61705ad2-381c-4f00-257d-08d89b71f7d7
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5693E9905FD7AD1BB4491BD1E0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uccEhK1BfvifwjF1ii12/HX1XUiN9t+LwQQA5PRRCLKVzdbYfRhSddtCcBpegkRF4YRX1SbhrLm9aaNAgDYq31qA6Q2hPN/aZ7jYnH2xamyDwBbqe2SQ1I44aKSWWggORHFnmCds8kcL22UiPFdGmkLK9TqKlfsoiaEOH0MEbMk+A95CD1G4iH1kzu/qLN7QceMc9HaBksHmQm2yavU74PRs8tBILsKU1E5vQH6yB+K5rLUgnPBUzmIq+bdHbMNxikku6P0OE/lAMIymb0DdFyLc19Hi+2f4hhVSXVoq5OeQWiYmRmqN/1V4KEMv25kHSB3uYFrHyJtSB1fFizD0RBPZrnbEjmVoEpE2aG/0W4Dd/pSndgqhxkmbuhXW6dIT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pMGffQ179wwaIlk37K9OrR6RipaP9wI9XtHRhs6oVHm4yWbi6W5j3oROZ+g5?=
 =?us-ascii?Q?MSUxsE2vrUzpf+y90aadVYJ+RbzHBx7U001Bthb4EJedEGolE2/BHSTSA0oa?=
 =?us-ascii?Q?lNDMi+lZyzaNikEqDZbnG5KylUxT+2pF9q8BDCrJOi4XfiV9F9lStt6yUQAb?=
 =?us-ascii?Q?Y+CfJus5g1N/uykMwWZLYz1vMjEEabvsMsWtfptPdEFbWuC1ykpDBq94s0ug?=
 =?us-ascii?Q?F8CF5dxBqeK/HhKL/KoRt8N12MLyBDKtnzLIWIJFl1RYOwgQss5JYAhn19Mk?=
 =?us-ascii?Q?Q1g7OoFSB0ELDn7UAbUnEaCoS1qd64RqnDohAaeUHIqKak9jGUAIrdeQ17aw?=
 =?us-ascii?Q?XVW3K97U/nAVBq9QlEYupRMYoHjDe5R8WOX1HOAgt36g+K/y+GeznTKylPHE?=
 =?us-ascii?Q?0CWulSJYefrTA7xhAkTzY1zVYJrrZBE0zzwu4Fzz0MaHB1g0fp5kHNnaNHU9?=
 =?us-ascii?Q?l0elXKvBW+x+P/FJrcAxAP1s27Ccw4R1/rn6kRGaxCysHVJDjzfLrlcJgKwS?=
 =?us-ascii?Q?iI3+fai032fbKmzNqLgOP+D9h0nlpAxxZmN64ydsVSSYQaeGRhk+hvQBqJ12?=
 =?us-ascii?Q?vwfAjebWT/+GrxUMHL2s8KbI8iIkxriiHc3R8lni+oV9FTw42Ylz+BaM7Ipb?=
 =?us-ascii?Q?7CoVzHIk7cfTA/HCBtFDDcz3blARqD+S+gCc2pApJWzUh8Omxb07na2RlisY?=
 =?us-ascii?Q?OLkzov5eYCUgmpXvTO1plMYd98I0X3BJx+T6TuBu9IgHzm7V0QbwXTPrLs4C?=
 =?us-ascii?Q?OE+X/xjKO7Oy4nDdVBZTK94jo5rf2NN0GSKLiGZwDW/5Oe8U5HjF2wLGnUu4?=
 =?us-ascii?Q?bcuiy2tGyjDiTq2tHDvCXX+RXL1Qz5xhN2YB0WOQWxyeGyhW8UEGPYkIn94y?=
 =?us-ascii?Q?lF0CEmLevSVlbaMqta2pdixKGBpU2sXouRb5kDkcw6MpYCBghtCHIHbz5wtd?=
 =?us-ascii?Q?oOGJmk4CduA4TTf/aWfiTlYf1AN6dX06gPAbKGi+OL+I382LHqHGUy+BT4Ym?=
 =?us-ascii?Q?95o0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61705ad2-381c-4f00-257d-08d89b71f7d7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:26.6935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XwTr3qfFcbSbi/2G69Bg+18wRDmsqwgxZI2T/uLRrkHE3E1BMbYWO3sEwWCUz31qCBQ4Sgoioz4mekbUJXJPOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since switchdev/DSA exposes network interfaces that fulfill many of the
same user space expectations that dedicated NICs do, it makes sense to
not deny bonding interfaces with a bonding policy that we cannot offload,
but instead allow the bonding driver to select the egress interface in
software.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 38 ++++++++++----------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 47b620967156..77957328722a 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1022,6 +1022,15 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 		}
 	}
 	if (netif_is_lag_master(info->upper_dev)) {
+		struct netdev_lag_upper_info *lag_upper_info;
+
+		lag_upper_info = info->upper_info;
+
+		/* Only offload what we can */
+		if (lag_upper_info &&
+		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+			return NOTIFY_DONE;
+
 		if (info->linking)
 			err = ocelot_port_lag_join(ocelot, port,
 						   info->upper_dev);
@@ -1037,10 +1046,16 @@ static int
 ocelot_netdevice_lag_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
 {
+	struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
 	struct net_device *lower;
 	struct list_head *iter;
 	int err = NOTIFY_DONE;
 
+	/* Can't offload LAG => also do bridging in software */
+	if (lag_upper_info &&
+	    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
+		return NOTIFY_DONE;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		err = ocelot_netdevice_changeupper(lower, info);
 		if (err)
@@ -1056,29 +1071,6 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
 	switch (event) {
-	case NETDEV_PRECHANGEUPPER: {
-		struct netdev_notifier_changeupper_info *info = ptr;
-		struct netdev_lag_upper_info *lag_upper_info;
-		struct netlink_ext_ack *extack;
-
-		if (!ocelot_netdevice_dev_check(dev))
-			break;
-
-		if (!netif_is_lag_master(info->upper_dev))
-			break;
-
-		lag_upper_info = info->upper_info;
-
-		if (lag_upper_info &&
-		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
-			extack = netdev_notifier_info_to_extack(&info->info);
-			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
-
-			return NOTIFY_BAD;
-		}
-
-		break;
-	}
 	case NETDEV_CHANGEUPPER: {
 		struct netdev_notifier_changeupper_info *info = ptr;
 
-- 
2.25.1

