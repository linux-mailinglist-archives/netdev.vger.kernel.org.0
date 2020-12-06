Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB2E2D086C
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgLGABL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:01:11 -0500
Received: from mail-eopbgr80058.outbound.protection.outlook.com ([40.107.8.58]:53705
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728660AbgLGABL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:01:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MkFqdNIz2Lhr0AtqSwT9fnWP9tHax9eALqvWjmhsI+aTCP2OPSTcdwVH0VaVHW2aMI61DOtihy2GptdC6KVBs/51OUmRF1U+h+2BkZHEqZu1xm7LrOLku8BNuaDEAB1ydfseGdaxHwnlG8zPJVugC9emOVaQACsxjvBo159mkKmkDDDlT+U8AeAceR3Fk52XlbdXacD8z7UhXnGR8KshLfrV3M4jzziBzlSKDC3g77p67NYZZXjszZIhm5SMCQQgyzCnsNMRL7Yyjvn9c1xsAwu4J0qvsBwjzW5FSYc6RfkZmu9wwmPWmMprIWh7DJ9EFTiKHei+IWXEvnKH45giIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MB8c3ihaLKCJsxu85I20L7CMGK06x44FkBrlVzAx2QU=;
 b=GdKoMtVk6lJPkYB/5TRtkmMfq0anPjm6FUJb6jUW6v9ChvWBZjEMNLCl32ZsgsjhPGJjDeqqJRW92rXWoY329wiaVy9JpEE3bVsTFRRCPjBIn3C4VCmaVpglQZH7A/IBsMcJroPmeeCT5KmzomkiS4Xp60Sb/AmjNfkjWWCXsOVgYdb3izmqV70qKIQL7YNq0muHZC7TVvnRC9nY4gpg1Q5PqM01PevTpnBqwSkzasAxFKN6ec120OZpakCfAyxdQCeMeGWA22tMzxBYO9K10t1UvoZJpax4+V6F2W+UW3aOGq7u2RTdzd43NcX2ot8mF3QeJnBnTJP07nmJlNs/Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MB8c3ihaLKCJsxu85I20L7CMGK06x44FkBrlVzAx2QU=;
 b=RsHJ50fSCgYeIIPyJOQAyBqg8PxAc6b5H7t9weIWl5UWWg3GwD1FRkbiQL3+2xcFRMy6b2roFouUqQdZQqKMqUcwDsnEhepe7prZPWESQRLeeWvge6ta0WFT/x8I8u78y1+Z5RYXkMcJFyyCcjKELMGBwY4EtmrqCg3sUTyde58=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:03 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:03 +0000
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
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [RFC PATCH net-next 04/13] s390/appldata_net_sum: hold the netdev lists lock when retrieving device statistics
Date:   Mon,  7 Dec 2020 01:59:10 +0200
Message-Id: <20201206235919.393158-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 00:00:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1db6adcf-3a28-40cf-e584-08d89a430b89
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637962482A625569181C4CDE0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dAtQfKIaI1lXzKVOEtzSoPNRHIx7MKqDUjdNSbiDlbvzz0UAarjRpF9Xz3PmP+aa1UpA4XDfScXvukHtPBn6cZa9iFuBp87ctGNagHcn/25eQhiOuA4pVk2YFC0tNoy+eGGkSIAQOWXcHM2tIX+u3YQ7lLOmrSGDilb4Dr63QOKDI4+Jh/zihQ5vH6rrxI3/jiAQ4DhU5tX7LpwlBSBJD2gZ5qnO1tED65aQ9V2Y9ep9ie6PAvPF/r1qzSIVh5lBqQhMHkPq5Aq9Uy2LD9+DBOCiWwaDnEzdQ26jJjw+RUeN9BuZmVShBkgOoS4E+UbmAxi6LBxN514PosIVsSiyrxI1XswSc1f5p/ST27rMkDsbHl8DzY8qh/8ibEXpnL9W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?U309BM3ZyyKDHUU0xL+4hyAMPDeahncJowOtzZcQJmvl09rfQy+c+1lnNFpT?=
 =?us-ascii?Q?nGLKI/DWSBWq/t4SDgMszR9HVcWRqSBIEhDmc5NLxnJr3LukniU8JgQZHVW7?=
 =?us-ascii?Q?8fpXsqZXxEzM/yfJuwJ5H8BtMS5MHzCQAV5dFYC8glt7EAlaADuWIEvHNVcZ?=
 =?us-ascii?Q?ratB6eIRtBvEfRKUSCC0c52NXJacRnTbWdFSianZbH+lR15ri+lKWCINvnSN?=
 =?us-ascii?Q?ZIB2N8Xlz9JCkFe9I07haJ88ANNkcrTkeS1+UaPdgIFhztuxhIW5/I4F6Hbi?=
 =?us-ascii?Q?U1OOfuK3ZNCDegjfB42nyUkVmGWY2gcpHux4YB1qntbzdi0inRV+Jwv7/cnT?=
 =?us-ascii?Q?knf8VEKsJPe10GM59iQtWMKUG4Md7qfaO/g9ELMkHJGTKxslJBjj9j6i4W/z?=
 =?us-ascii?Q?4RaS5IjgN7hmro3t9uqyi+XpP6GjAkcGgL2ssiyrBVUwm42MZt+cwbvzPnPi?=
 =?us-ascii?Q?IupjPcoEO3bYFTqbVtkfwk7aGhEnJRHUL7a+rcTys5f5EaN/YpBYK/UUh6Ds?=
 =?us-ascii?Q?OUIQyQbYFjFyPyL5gLdBnejnjyoXJoQGFoqQbFShGut7O76wPNr7NwYJpJMl?=
 =?us-ascii?Q?o27RnfKW7VRHnlEq9BbzG0OEoldsrcjRN5F9/ryf+yB7p9xDEatIhKn1hQ+0?=
 =?us-ascii?Q?kjjxHDh5M+PuzDOzxjw8xDcoR8UVwa3wlAL2Vs1CgsLGY3xO84yhIn5qddMI?=
 =?us-ascii?Q?mVMt8XXePjPrJZsnut3/R/aeDiI8sn2mdOEJmGCC0XdYs6y3G3s7jfj1kCaL?=
 =?us-ascii?Q?zSIqlxHZhinKIAQeo56SPzXY3ds4LMwNnweLbIALpAtVJeXdlfyBy+GKh+tW?=
 =?us-ascii?Q?I+4TK9Bpa167vnDRTMfvCAdbJ4w5xCGQ/Rc96PCEe2Mg8CkfMQvDxQbbCkVj?=
 =?us-ascii?Q?cLeDRi9/lA0aaL+AzxD6BsMOFPQq90UMgOp3b5Ylg73fv9bI+6No7xHS5JPq?=
 =?us-ascii?Q?C6d4E4sl8fBuKMbP1Aas63tuNeO8nEdKGP2+hXWhWlI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1db6adcf-3a28-40cf-e584-08d89a430b89
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:02.2606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PntJ+bYUie54wiQa/vTNI2J4DjCn4mQOtp6Z1Du4k9eOiABAobET4bLb37nJeJcuUTXaj1Er69tx8CCRfJosQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

In the case of the appldata driver, an RCU read-side critical section is
used to ensure the integrity of the list of network interfaces, because
the driver iterates through all net devices in the netns to aggregate
statistics. We still need some protection against an interface
registering or deregistering, and the writer-side lock, the netns's
mutex, is fine for that, because it offers sleepable context.

The ops->callback function is called from under appldata_ops_mutex
protection, so this is proof that the context is sleepable and holding
a mutex is therefore fine.

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/s390/appldata/appldata_net_sum.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/s390/appldata/appldata_net_sum.c b/arch/s390/appldata/appldata_net_sum.c
index 59c282ca002f..27e9cc998d4d 100644
--- a/arch/s390/appldata/appldata_net_sum.c
+++ b/arch/s390/appldata/appldata_net_sum.c
@@ -78,8 +78,9 @@ static void appldata_get_net_sum_data(void *data)
 	tx_dropped = 0;
 	collisions = 0;
 
-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, dev) {
+	mutex_lock(&init_net.netdev_lists_lock);
+
+	for_each_netdev(&init_net, dev) {
 		const struct rtnl_link_stats64 *stats;
 		struct rtnl_link_stats64 temp;
 
@@ -95,7 +96,8 @@ static void appldata_get_net_sum_data(void *data)
 		collisions += stats->collisions;
 		i++;
 	}
-	rcu_read_unlock();
+
+	mutex_unlock(&init_net.netdev_lists_unlock);
 
 	net_data->nr_interfaces = i;
 	net_data->rx_packets = rx_packets;
-- 
2.25.1

