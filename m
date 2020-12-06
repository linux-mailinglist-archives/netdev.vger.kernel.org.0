Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F3D2D0876
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgLGAB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:01:56 -0500
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:2436
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728683AbgLGABz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:01:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOvIjDhdwhos+KrW6RN5/H7q5RIcrfnc6HbqzF9WPKur+TFvlmqzureFjc8rm29PcfRv+DhhtGkTH6BFtGw/vHixNwhkKPwTTDFFjKsiaa2n9k1RwB+Yvhu+hRmewOdTYzbRabnD7mtDxcZ7xucFL2/LRflVTMdXyfo4b/wIg0BdmDlLkf7yb3vyUZuD1GXTAt28ShV0Rh1eDKIcvAOfw9s4vTDmIMYlHRvwTogVOdym/rvNjDbgAt9O0PF70T7MwaGfv71CFJenebyXFXaDTycuKRYHq6QjXf51jIJ1ReWIY0BkIqOuK1rBSp6jo4uYPaGs7NvWiYyyzZhm9geFng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fe24wXWPqHk0gw/XLrY/J/yPJk51KrqORMkqeYQ007o=;
 b=RV5qf4Hu9c//I3bOXZIIIf8LFeKzJzBy6Y15sTco+kQR3C9pn4CP92jTp96WWmyO/xCOcfftnqlpQ92Ta7WROulhwy/vvN7CLVxVs6rLB7zS8KN+FGpe6uTTwUlTVXprSpRwS+Uk2SsOSiz4nZOQ3p3PuR5K4IISuA7uFcP89bU1yLmL6cLB2j971x9jE1u3DH1YDw8H14jDDukkcKwI4I+rZEn+UHzDRLCrbmBRh8cQqB5C8so56blINNjab0d64kT0xnYrmO7lru+xt44KPetAOAqQ2V3d/IRidOsYkMLB/DdZIW0K7NFZiQbq4VDQS2kKb80HWxhdON4XiZe/uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fe24wXWPqHk0gw/XLrY/J/yPJk51KrqORMkqeYQ007o=;
 b=Ir/iHm7FnOZw84CghTRSeTXbUfaaSQhpZEnNhG9rJ1xzMkNxA8AQpyeNemdG/9N+ErdmxzYQlQzbrLwlFMZpJIRHlupctQ8mKCugOSIsSareTyUm5X1tNT8Q/WmA6DvEXayluqcEf4x2pGTq2r0vprhlvFl/WOeAob4LTk6OwQc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:07 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Subject: [RFC PATCH net-next 09/13] parisc/led: hold the netdev lists lock when retrieving device statistics
Date:   Mon,  7 Dec 2020 01:59:15 +0200
Message-Id: <20201206235919.393158-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201206235919.393158-1-vladimir.oltean@nxp.com>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 00:00:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 53d4cb5a-ce4c-46de-a2a3-08d89a430e4f
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB66375AC9942B8F5B66053299E0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rtt/qMdGZCFILcwJsmIiKLqtvBzTWNpg+Nz0zjiFQ7rokKF4MB0AUVFQl5jXEgYGk9C1qXGnlM5X0y6VlEQC+mAsVR6IUm4We1Q9REIjbd3WIYMmEXXdA2AsVPCYliVt07j1UMv015xWXdxuypvnRX3hxb1wH5by4xwLku9QolAsd2EVRj4vGLZTo5iz6iI0XiCfQQRFTz1eJpVsD6lIDdCBkUPGECuPXNcEMSTFG6e9EC2K5o7v8Z6XgEcTJMX9dy/iqjbys272aWEdVs7akA9TdkDxSBDCDW92O8IE/1/KKSktt2fn8Zw+h1J/WPaBxIuebBKrE0R+VdrOqPkgkuSXXsF1/HM6El2WgRG+zqB8X0X/svbK2+7P2hDnV7PI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?FLYYK/RLLRUG5KYpD+BGnSSlwJ2/JpoTPBdkIfStuc2Jx7mfvyAW1dUG4H8W?=
 =?us-ascii?Q?JT/+fEI6SQ5mM/IQnEdaDCEWoQPkGt3kqYdhSdZ1jqtKyXAjgkC+HrEt5tWa?=
 =?us-ascii?Q?1xMGra+OZDonKWakZCprF2eOPNRCP96HT6eGEMMTG7vnX+8SPhkmUTLjgIjd?=
 =?us-ascii?Q?b/PqJjcUBLdvPNaQRs+8L57Y2nMg891rOjUOfaCp3oV9P5mvs2X1FkTORepn?=
 =?us-ascii?Q?CQqf31QmWr7XXPbYMl2xmL6EHsTRb87YTtz4snDiJFHpM3sgslwOmZMHX9U7?=
 =?us-ascii?Q?MBj79cvLKASBr6Cs6GwOKErnoPnJxbEwOz+yLeXUuDo+l3F6NFNThGnMY/MF?=
 =?us-ascii?Q?XvP4RxLdKXe45/mfAx3gZu6061HsqzDy8J+udyNqf/AK4DP4AaFl/9Z1uSfG?=
 =?us-ascii?Q?vYlwt3Y68bRyPCd0QfnfYnI13QRW/n/zFs5ZrAggax6BysZyYG5ng/TaYJmM?=
 =?us-ascii?Q?KU5mTyesRPiqeuB+BJ9hI2OfphpiDfX/cCHyNS8ZwJk713IZAE5HH6jpnDHQ?=
 =?us-ascii?Q?AiIlgFlgUolp722h0mNTqC9k6pbkg4PxvkZSG/W/EgK5lCGmOPzh7OCA2V5X?=
 =?us-ascii?Q?Rtmg+nbGkRzcmm9auacPZ0kC/6vewiJJri+rwNNzJIA1MECUKT4Qn0hnGUYA?=
 =?us-ascii?Q?qFpgZTlr5FLYae8vycN95m7qKQSDkYQJsl7DpSjB8l2CNqXKoXu1aYCW5BF8?=
 =?us-ascii?Q?q2+JOpgrkoyGTOy0j3ASZWu5pU6aZgJbUmDJccLtBMrav1Sam8a/6dSsTwpL?=
 =?us-ascii?Q?4XHPkhR0ZEqhuXm97G/79MLuxTJ9mNrFZQUDKt2qlzpdW2G+IEIcQzRgYc/k?=
 =?us-ascii?Q?uzu7jyoqubumk0TT0smLM7YbLpBfEFZYX4b4bw7K3wOjjbDeUwUhry4LELYW?=
 =?us-ascii?Q?O8axAOpEAWYLb8sP4WrQXC95XiMomp1Oy0BTeoIKM+ZWe0IGMk8w+g7pjPRN?=
 =?us-ascii?Q?+ZY2Nirzq77SxZhqAfZpQJ3nt9OtwJQati6NHjr8hd+NGWUOyxlh14ENadbo?=
 =?us-ascii?Q?kCHb?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53d4cb5a-ce4c-46de-a2a3-08d89a430e4f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:07.0249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCstBQQSP/uznnkkNen5Mavy8Zio/1Wg+Cup/c66jkHpz5AmDS3fhgiMRlrB8ORMyDaRv1bVumsxq+oGC7huww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

The LED driver for HP-PARISC workstations uses a workqueue to
periodically check for updates in network interface statistics, and
flicker when those have changed (i.e. there has been activity on the
line). Ignoring the fact that this driver is completely duplicating
drivers/leds/trigger/ledtrig-netdev.c, there is an even bigger problem.
Now, the dev_get_stats call can sleep, and iterating through the list of
network interfaces still needs to ensure the integrity of list of
network interfaces. So that leaves us only one locking option given the
current design of the network stack, and that is the netns mutex.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/parisc/led.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index b7005aaa782b..1289dd3ea6e4 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -38,7 +38,6 @@
 #include <linux/ctype.h>
 #include <linux/blkdev.h>
 #include <linux/workqueue.h>
-#include <linux/rcupdate.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/hardware.h>
@@ -356,24 +355,28 @@ static __inline__ int led_get_net_activity(void)
 
 	rx_total = tx_total = 0;
 
-	/* we are running as a workqueue task, so we can use an RCU lookup */
-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, dev) {
+	/* we are running as a workqueue task, so we can sleep */
+	mutex_lock(&init_net->netdev_lists_lock);
+
+	for_each_netdev(&init_net, dev) {
+		struct in_device *in_dev = in_dev_get(dev);
 		const struct rtnl_link_stats64 *stats;
 		struct rtnl_link_stats64 temp;
-		struct in_device *in_dev = __in_dev_get_rcu(dev);
 
-		if (!in_dev || !in_dev->ifa_list)
+		if (!in_dev || !in_dev->ifa_list ||
+		    ipv4_is_loopback(in_dev->ifa_list->ifa_local)) {
+			in_dev_put(in_dev);
 			continue;
+		}
 
-		if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
-			continue;
+		in_dev_put(in_dev);
 
 		stats = dev_get_stats(dev, &temp);
 		rx_total += stats->rx_packets;
 		tx_total += stats->tx_packets;
 	}
-	rcu_read_unlock();
+
+	mutex_unlock(&init_net->netdev_lists_lock);
 
 	retval = 0;
 
-- 
2.25.1

