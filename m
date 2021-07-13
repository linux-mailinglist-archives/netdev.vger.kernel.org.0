Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421883C6D8E
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 11:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbhGMJhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 05:37:01 -0400
Received: from mail-db8eur05on2068.outbound.protection.outlook.com ([40.107.20.68]:56289
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234819AbhGMJhA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 05:37:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DNUpHt4mvHTH6rYUA4P6KWJXtis4dfXudobhs9ZSfJsh6w7KT+rEiMha7HIDg0ZfKR+PYrnV4vkwb4Bn/vy2oCRXEqleOEWe+agp6712DfXemTXgiodNvmP7z/u9miK2WkTI1RVOGvtN0FIGLbBqxz4FtHUZTGBDumeS7KV3VbaehGL49oVdV/pCxhm4Qx3pPFFIkKhk5dP+bL+ISt/e3OYT96wv6iRhLoP5yLUdwJSUsu+k1KwFDw6m+e4gxVnr0q1cTnTx8Xfak40NVPlCirfGIBetGL8kjeT8Z1HCItEpX5B6pS8iKfC96quhE28Bc1OpWt9rAhusyvfVjZv7zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQGZqA4YLYAdJOm/W3LrzcL1Llu3tBJ7wawN8JJFNl0=;
 b=ko8gNk1X3bY2eNFwG77REMdHpqfgsfmghF3/B0lTOEJzoZKqQDi/P5k+JhoqSSU7bSta/4oGhdpt3AI73xPsWpThl//FpI/lQXxUShMnbP88m5r7lO5IhhtMz9Qn7l/q7mjSrrDMAQQu0RSdlHSHA09txImVQKt2cKG6BI1dQJ7ZNS2/hoa6V2GZtQt/+dCczulYPXQYWPNT4DzDGz3mDGZkMf2JZTSeqieFUCuqCMGHl9X0QHpZ0jO/xFyAEIuEkuMTgefPCspwsHqNp8SlgRqV9BY/+HmGSen8pysKvaNBNuW4muH165I0MKoM2QcdjzVWvIQn0dq5vJPZzd9+Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQGZqA4YLYAdJOm/W3LrzcL1Llu3tBJ7wawN8JJFNl0=;
 b=TEPHWsZ4vc9NK8q5WJoaqQRh8lLjRc6iiRDRqd6oGooCJDD51UPuzu2w95NWVYDkcnIjxqKlDM7PAQNXusKjKpEM4hURDWRVj5QPSjqpS51IWWk4nQe/kNba3ytuc6wimhWAWAXo+nmDHr/c45+PtTBb+eCRB208H8l+0dwE1wY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2688.eurprd04.prod.outlook.com (2603:10a6:800:59::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Tue, 13 Jul
 2021 09:34:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 09:34:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net] net: ocelot: fix switchdev objects synced for wrong netdev with LAG offload
Date:   Tue, 13 Jul 2021 12:33:50 +0300
Message-Id: <20210713093350.939559-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0082.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR3P189CA0082.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 09:34:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d52dc2dc-5ff8-47d1-4b2d-08d945e15d98
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2688CEE3A3E6FC1C1F154A14E0149@VI1PR0401MB2688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Y5xaJrBRT+Sa1U5VOhgjDNtVOkMghjmG06aFsFZ3oCRp6aiFJB1pAiCrcZzJxgDu7Euv7pp00BvbFp1o/6dWIMklVNRtmAuY7e5K86Z7T0RBrNMexpICz3kmuLbNlTz/1Np2qsHbqEk+/jRKnAqgRyBKHGbELnqxFGRMxlcvBQG2VEaImcvM4IINF8SZzyHoGsJgTda3cSqLydaBWTNNtf7xiHHQtAWvVxTbPqCuSj9vXmUZyf1LnOho/fw93eHF7RI1w8hU8o9v24u8/YFf2IHaBwyR9SFpENCKrRcWJVRMUwdCBtVBeKWVUSHown5Adf20dy11GKcQOfel7BydtB12ClHsSrCsodrPV2RvQ81a3u1cEjO2DtzDbTh0TMlDGT3T4jM2/05LqGShuM2ecRIYnZsT6mh8KeEbMJZYtYrddWAa4nv1es4viKAMCYn0aP8CbGcFG1sWVlcuXx2SF+fGZx1jtbhz2jY8jqOn7q58n5Yje01kJKcuzsK4X88mEMC57FvW37G0mDIH56jd29Galx7/m2m6h8hkbvu/tb2zAWMbOc500pttEalipPC/xX7DafEzAf/p+kE+yWdQr+dc1xQVJgG0kQ6TgKA1b4hQS7GXAd6d3to2gfnJXdpjQbJK9b0mHpU+II9igzerMQ20wIB8Gl2vB5NVsRwALs45aoQkDOoHnwNnP4/ItAoN8sjVihGAwVwaZ6CnO0d8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(39860400002)(346002)(136003)(26005)(316002)(54906003)(2616005)(44832011)(86362001)(5660300002)(956004)(52116002)(6486002)(8936002)(110136005)(6506007)(4326008)(36756003)(83380400001)(478600001)(6512007)(66556008)(66476007)(38350700002)(66946007)(2906002)(186003)(1076003)(38100700002)(8676002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ak9nsRCPidP1ZgA5gi9/kd03tSvrGVabCxANfH/PgARMJGLgDguW0wS3LghK?=
 =?us-ascii?Q?R3wc6uzEw24vk5qheVQj7cC9x4Seq1i+mg+piEJhhXkHcTJfVosLW7ODS3c2?=
 =?us-ascii?Q?OXT6J+7YnLBtEEQYwGbN+33jlZ3k5O1zmE8/sM6ZggKwgekOohEBmLWmh21G?=
 =?us-ascii?Q?leZ8k30SOVWjVHdC16PQZYqfcbdqyeMO4MY73Ur8IY2EIEpFpalgkBmBwnQe?=
 =?us-ascii?Q?dqrPmqtLYl3ElNXWsWL6aEgmP7Y/XzfwNChJkZgl1RStK+vGhuRPl5B+7E7l?=
 =?us-ascii?Q?CmZm0bIpZQ9C4Mt+cBLL1S9v/YxWMhA4T3Yi/x/HrGAl5QzBSFTowuGJ3xp1?=
 =?us-ascii?Q?PtTDKLBHuhT12GATA5syM2FL2k2PDfkNTPIQp6hG3gCTi3yC1DIZesSdN+wh?=
 =?us-ascii?Q?SoQC6VHZJSO1oLR4H50R+O7Anvj+alS+giFDH7ItN/37M7rN3Fa4g2ONMpAy?=
 =?us-ascii?Q?bQxnP+L5KmH97D7izy8X+OVHhIzuF4mA6zmjP3xfGRlRJ6P2eKrkYO6lCrlw?=
 =?us-ascii?Q?BxrCcBWUNM5vnfwd/Q/9au81hjzlV4v/0gGlQ8Ew9bJtgG257Deg3NP7ZG6E?=
 =?us-ascii?Q?6KPBI3Shnv3WiIHQokXzy7NOySioEI39DsEHg6yXvlwPTpSxZqldHRq//Bbx?=
 =?us-ascii?Q?/kFhFjc+utdvD0QNTpr8XtCRtQn1tkMt3mO9MNCl4zMryHyQMjNiNqXK2GQZ?=
 =?us-ascii?Q?ohWswWqSSQQetSThUbSamkIP+2QKIixLhy7Z7zLQ9va55Osux5rmyU3ymTdI?=
 =?us-ascii?Q?I1eYLowukpoA4KKwzL2c/W2Jj3gkvIwiZdLmXyEr7iUoNzlTCl2ZsaIgdd5t?=
 =?us-ascii?Q?vBQl2oyHVKRSpQzAA67ZkWuKlOqfAuaMbSt/t7NlfkHuLREqbpbbdRsxLlxT?=
 =?us-ascii?Q?Vy+gPEHNX9T5xAYODcUbbx6oYuaRXvaWTVCClQXw5HR9M7TgpWKw44Mbt+OX?=
 =?us-ascii?Q?Hc03j5I8m18xKOQY2Nqbw/bX5KGpeKsVU32tWpUEGQm5UqQGMl/XNEJMBU38?=
 =?us-ascii?Q?ZK1uA0Yu0D/DkEKkWezhr+eWadY5d/anJNEmczbNZXPk7QFYhQec888feX0Y?=
 =?us-ascii?Q?jCX5oK1sCX3L23gIINkc/zcZ6rPFdrx8YgiFKYSUt6Z2PeXYF+zv1zs2rCT7?=
 =?us-ascii?Q?XZnTSMAllju2taeZpYAjIQy43XYe1czA1bhMKDGR6q2/+VGKhW1eAg1ZGy/8?=
 =?us-ascii?Q?uGMA4AA+ZldzTdoO35n+GAdG6AYyPuaNxmfvB7yUQjFSnRf2rFkHCwVj80PA?=
 =?us-ascii?Q?d10pDfTHTLbPzOBspxYOoI5d8oALPByfuJx9F3/yDP4ZHDn80gGAeb7bczp9?=
 =?us-ascii?Q?QGle4wx8nDI+LdHh9DByAlar?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52dc2dc-5ff8-47d1-4b2d-08d945e15d98
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 09:34:09.1135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgdaTANi7rLUmexKMhxya9KZJy+lQXyDDluMOfzbeplnh1Pbvc2fYJuLOiGhngo0zhVDxDcFwhCqapPZJIgqag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The point with a *dev and a *brport_dev is that when we have a LAG net
device that is a bridge port, *dev is an ocelot net device and
*brport_dev is the bonding/team net device. The ocelot net device
beneath the LAG does not exist from the bridge's perspective, so we need
to sync the switchdev objects belonging to the brport_dev and not to the
dev.

Fixes: e4bd44e89dcf ("net: ocelot: replay switchdev events when joining bridge")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 3e89e34f86d5..e9d260d84bf3 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1298,6 +1298,7 @@ static int ocelot_netdevice_lag_leave(struct net_device *dev,
 }
 
 static int ocelot_netdevice_changeupper(struct net_device *dev,
+					struct net_device *brport_dev,
 					struct netdev_notifier_changeupper_info *info)
 {
 	struct netlink_ext_ack *extack;
@@ -1307,11 +1308,11 @@ static int ocelot_netdevice_changeupper(struct net_device *dev,
 
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking)
-			err = ocelot_netdevice_bridge_join(dev, dev,
+			err = ocelot_netdevice_bridge_join(dev, brport_dev,
 							   info->upper_dev,
 							   extack);
 		else
-			err = ocelot_netdevice_bridge_leave(dev, dev,
+			err = ocelot_netdevice_bridge_leave(dev, brport_dev,
 							    info->upper_dev);
 	}
 	if (netif_is_lag_master(info->upper_dev)) {
@@ -1346,7 +1347,7 @@ ocelot_netdevice_lag_changeupper(struct net_device *dev,
 		if (ocelot_port->bond != dev)
 			return NOTIFY_OK;
 
-		err = ocelot_netdevice_changeupper(lower, info);
+		err = ocelot_netdevice_changeupper(lower, dev, info);
 		if (err)
 			return notifier_from_errno(err);
 	}
@@ -1385,7 +1386,7 @@ static int ocelot_netdevice_event(struct notifier_block *unused,
 		struct netdev_notifier_changeupper_info *info = ptr;
 
 		if (ocelot_netdevice_dev_check(dev))
-			return ocelot_netdevice_changeupper(dev, info);
+			return ocelot_netdevice_changeupper(dev, dev, info);
 
 		if (netif_is_lag_master(dev))
 			return ocelot_netdevice_lag_changeupper(dev, info);
-- 
2.25.1

