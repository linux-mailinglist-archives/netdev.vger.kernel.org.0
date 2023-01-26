Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B075C67CB52
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbjAZMyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbjAZMyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:00 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2059.outbound.protection.outlook.com [40.107.241.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0464E4A222
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFxklnK1vmvDOaPxtZZHf8W/RUDNr5iLDQ9DNFv0103zl6fVlHBDQSbEfYX7X3mSSNnYvS+iCPGkeXkD+Z6w7/90qFrZZFVbtnhYamLmrbCc3IgX+zeN2cITNGEGEFM2VMAUdu70vSUQ1bHvHPxUnUW4fcOj+QWCcX5GIa4zFufokVI5CRQ7qD/ELJ9dUVSTYNyWLz6kQjTgRC86Q0qVZn0xHzGl3G+br9kJBurqzn0bTef0SSi1Meh53nt1mRpALJ3bduBE7FVuavwxAprAK8xBxCH251tcwvk7nBQe4NRsHBiTc82/n0JdVqUU+xW4Hz6QsgnMRD0TktUlnazJKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BclH9+EaKn/0X3VGJG2O4JCtG0iErChj6sw9nYwZdIc=;
 b=gNAHdfRa9jD7No8DSO7NZIgWbPnCfk5ZrzqKbPdciJBkRIB2py3IrenFp5YyEfX7OaXnSDWXHrbwF3/w5V6Xs21aqIENqZEczaPMiekKwJESrcsB+dCZ0QhHtupaMG59r3u4RZaumQMbsHvZmnd7XPmBSIlE6XZW7eYCrujfAT49u+b11nsZ+IQl8HMCO/qMAUANWUTOhqPyN9TFm1gfeslkWJKu6gQF5VceBLt1ohmQ224jWNRH7FtzJJEXlw8AfsEEidHGu8h7x2vPViiPR2Sg3D5U7qfD8ORNdi1y0V6pDB0ot4sOibySjy7jfSGGw/5GsZ9KDpmjPDRxIRqgnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BclH9+EaKn/0X3VGJG2O4JCtG0iErChj6sw9nYwZdIc=;
 b=THaUWk0S9O0S2En1xjoAbg7kjFAXGzIN9LbghQP1jRYhChiJ93hQyIC/Nhs9QHPpSKpZP92xuQijZTZ3HspZdUZPmsKGT1MuMI1NZfj3w5QrwdGDd1jA0zcY1XcB5OVNyV75JQ2mXRxT34MLxkA7NgmExu9HAuOvkx8ubyoKIH0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7795.eurprd04.prod.outlook.com (2603:10a6:20b:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 12:53:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 04/15] net: enetc: ensure we always have a minimum number of TXQs for stack
Date:   Thu, 26 Jan 2023 14:52:57 +0200
Message-Id: <20230126125308.1199404-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
References: <20230126125308.1199404-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0123.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 9429176f-de02-4bd3-f73a-08daff9c5827
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yQmytZDaLRPzcPN/v6LQMHQ1z1jcTkL8vhhNWp/dgWC7MqOwe8w6wWwgkbi8WIOFKU6B2+sOVBNsjs0qCzbLNPcTBKJgTJXPkDsUNN7/WJW+TFZRYD/cBy8Pim/lxe9LFQoBDMK4AUOVUk/p6M0TNBHG+R1W0FDplEMatfldM/sCEY+s6jK4GvoUzHox49qjS5Ndzcz5K3n19Jvff9fZE6Ped0AB11g4MzqTYj16F7/hEKgzbKCA+DG+CYHS7W8m6Bv9BUnuRJ6JUP3wGEimBZlUy2Y2viaevtrFkz9hNScMInh496F3fzhK2gmJ5vhz5jh+hDc/K9P+FIx+x6YZvsdPlUYUplFPglZ+c0/v3+7VydxRJ2bqQbR8AovRXT6wBBtPVxRQbe9r5hK47uQhkmxC7GCG+p76qigR1UnnFusvD1AD24RAVsNiuBlr5JqicGRlv8amIIaMyJx3DBb+MGhKWBSkGi0CxgUrawG333Hr6+KQSskdgh5raBXyi3dM+C2RkyifpxNON8FF/Ejx3joL2sN0iaVdv4JpdHXluBel/EpOYLwixe2JAeauuWond5YF0/jLZhy/PZc0S+UQcpN8WFIJtwbbig2qYsf2rC8BwHgW/LXzxgJ/SgYnPB4QvJ3Fe/OnbvperCc7kX4SbjVbJZK1x5ED70VkshG0xEEv27lX0Ur2wt9Nmz33Oy6loV45fWNdO9gIODdmg7+5Mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(478600001)(6666004)(1076003)(66556008)(6486002)(26005)(6512007)(316002)(54906003)(66946007)(52116002)(4326008)(66476007)(8676002)(41300700001)(6916009)(2616005)(83380400001)(5660300002)(8936002)(6506007)(44832011)(2906002)(186003)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BAubQm4TyH9+BtQ8ss+rMDaeA5APXntSVG+DAdC+4GyBn6Op0LudToQNbYgl?=
 =?us-ascii?Q?+zmZVPM5YvmxljQgDPUbZrHqe5MpWgjGluytG09XqawpZfuxd4Q+tBeq4OP/?=
 =?us-ascii?Q?UAe99hWF/Xzxn/WYtTc3eZT4rUlOTHVB88ChuJLAZGOcfolwH7Y29zom9QvX?=
 =?us-ascii?Q?T2/THLaal2CZsqEyes3rLOIXlccxjdO5cumOpFveWw3HNaCR8I0GvXsopLCE?=
 =?us-ascii?Q?L3Ksteeds9fYTnQlDXgAezdyp5t2xhaVkXi+layc7BVSC6U5DWHwfqikVUrx?=
 =?us-ascii?Q?lrjBNU4J/MV/GjSmzFDWPzChEqv9fS6mID+RDj0skZ/tvVxHM+B0vh/NcsAi?=
 =?us-ascii?Q?EdkMGt8H0+FBQgZMdDJZGNvSsChPzdChPsynABfRSn0EseUmjtzwz3W2BnJn?=
 =?us-ascii?Q?Y8ioOT8BFv5vP1FaU1Y3GrjbMyxLCO+hM7oKeWiL+m+WMkd6IqYvMDmIxbpz?=
 =?us-ascii?Q?NwZOx/xKZN4BeYJUXt/TsfSlF7kcxqFA++3XwmmK27nlrz/G0auAKMi3YBnQ?=
 =?us-ascii?Q?GHjqFZj84P1uUIqpS9XCPPHnC2ftURDgevFG/mA+Xr10zQzrpugY/LrR3HV9?=
 =?us-ascii?Q?dp0PCkqimdEwM6G0SubDhg2QbvWgxJQat98zxgVGw0apwQW7VVGSNy68K6VK?=
 =?us-ascii?Q?t98LgBeoVH/tk+LzijL+OoP0wgQeCPoob2kcm8XiAdIf00qFBvi+iMjmdpYk?=
 =?us-ascii?Q?4W2YxCJrS8pAn2e5HQ6eSCTNBc3kIhQmrqVp0AJx/73Cyt7BK+QKvPr3eJj1?=
 =?us-ascii?Q?UEBpHE/KSD8IB8euEWIyhekz1YwhE0asMctOcAXyvGNrmPEyE8UayVHcBpcI?=
 =?us-ascii?Q?Dynhr/MTOaas2rrz1Xq7Npp/W4XYRNQT6ayC07u93/ChRMgbht5ummwbJlqp?=
 =?us-ascii?Q?8fultMskQVMt6DSc8rUr1HgJtjWmtolc8BRjPYxQgKqrcqKCppp4m3VnBEqh?=
 =?us-ascii?Q?dDksdDRghRIFsOmNSKNlSos79xEFVk8UJ9sKNmNrzr4MnmdEYUxG7DhCAPrv?=
 =?us-ascii?Q?W3Ovkxw1ThVNOE2dACA533XoKhWlNR2ek19Ny12nfOVGYGzPfLl1VpXuC1f9?=
 =?us-ascii?Q?/f8XvotglRUlR8tqtsFakCpsiOPgy/2DK4S/ZVlrjc8o0DPj4cawPreaaVvu?=
 =?us-ascii?Q?yF2cRdOk6bwfU3kqLOShDvN+vHHXEMmhhErM5veYWvqqeKlNGabHf1JOhJpo?=
 =?us-ascii?Q?hosDWRBv1XtstQ7XPgTay2KEE0nKWiOyAzu1NhFrCbHQyWmgulAC5daDSOUi?=
 =?us-ascii?Q?LKHrZJeRlsxFGxPa2z+REAhmASGkw859QL33vzr4wIlSROA3TDUqNzcU/yzp?=
 =?us-ascii?Q?/8xUOX++ih7ce6Knztrp3HCyoyY5rNdJOrnhOUufC9ok3p+0Q+xTzxdJiytu?=
 =?us-ascii?Q?x8ijC4QXRGhgyDrcT86IQCV20F7yKNF1BQDm3CVZINEJYU6U4oFePKC/s0qE?=
 =?us-ascii?Q?byfl1dM4TOe95lWkrZMQvIfUG9f2Driu4110/gmN/rHC+T2ny8y+kosYOwOD?=
 =?us-ascii?Q?9cegEULDEqV+pQQIRQMGTLQy8nEndjIU2SmWDK2EsxzHidtsSMdFoN6PQ0Ud?=
 =?us-ascii?Q?VL2Ja9Y85sd//2LEZnQDty4jZuRLilKe5Q+3UevPwXxU9b0rqh1kZ9GfCQSM?=
 =?us-ascii?Q?MA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9429176f-de02-4bd3-f73a-08daff9c5827
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:38.7685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /eC4w8sT/18jknOCnXxs6sjlp8Zf0K/BxgZDi7vvx7wqHyocrM3FOiO9xMPJZhlkYNeShXpVK7eD2hgb2DS9Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7795
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently it can happen that an mqprio qdisc is installed with num_tc 8,
and this will reserve 8 (out of 8) TXQs for the network stack. Then we
can attach an XDP program, and this will crop 2 TXQs, leaving just 6 for
mqprio. That's not what the user requested, and we should fail it.

On the other hand, if mqprio isn't requested, we still give the 8 TXQs
to the network stack (with hashing among a single traffic class), but
then, cropping 2 TXQs for XDP is fine, because the user didn't
explicitly ask for any number of TXQs, so no expectations are violated.

Simply put, the logic that mqprio should impose a minimum number of TXQs
for the network never existed. Let's say (more or less arbitrarily) that
without mqprio, the driver expects a minimum number of TXQs equal to the
number of CPUs (on NXP LS1028A, that is either 1, or 2). And with mqprio,
mqprio gives the minimum required number of TXQs.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/ethernet/freescale/enetc/enetc.c | 14 ++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e18a6c834eb4..1c0aeaa13cde 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2626,6 +2626,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 	if (!num_tc) {
 		netdev_reset_tc(ndev);
 		netif_set_real_num_tx_queues(ndev, num_stack_tx_queues);
+		priv->min_num_stack_tx_queues = num_possible_cpus();
 
 		/* Reset all ring priorities to 0 */
 		for (i = 0; i < priv->num_tx_rings; i++) {
@@ -2656,6 +2657,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 
 	/* Reset the number of netdev queues based on the TC count */
 	netif_set_real_num_tx_queues(ndev, num_tc);
+	priv->min_num_stack_tx_queues = num_tc;
 
 	netdev_set_num_tc(ndev, num_tc);
 
@@ -2702,9 +2704,20 @@ static int enetc_reconfigure_xdp_cb(struct enetc_ndev_priv *priv, void *ctx)
 static int enetc_setup_xdp_prog(struct net_device *ndev, struct bpf_prog *prog,
 				struct netlink_ext_ack *extack)
 {
+	int num_xdp_tx_queues = prog ? num_possible_cpus() : 0;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	bool extended;
 
+	if (priv->min_num_stack_tx_queues + num_xdp_tx_queues >
+	    priv->num_tx_rings) {
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "Reserving %d XDP TXQs does not leave a minimum of %d TXQs for network stack (total %d available)",
+				       num_xdp_tx_queues,
+				       priv->min_num_stack_tx_queues,
+				       priv->num_tx_rings);
+		return -EBUSY;
+	}
+
 	extended = !!(priv->active_offloads & ENETC_F_RX_TSTAMP);
 
 	/* The buffer layout is changing, so we need to drain the old
@@ -2989,6 +3002,7 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 	if (err)
 		goto fail;
 
+	priv->min_num_stack_tx_queues = num_possible_cpus();
 	first_xdp_tx_ring = priv->num_tx_rings - num_possible_cpus();
 	priv->xdp_tx_ring = &priv->tx_ring[first_xdp_tx_ring];
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index f249f44c7ab5..fdcf0a2ffc11 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -381,6 +381,9 @@ struct enetc_ndev_priv {
 	struct sk_buff_head	tx_skbs;
 
 	struct mutex		mm_lock;
+
+	/* Minimum number of TX queues required by the network stack */
+	unsigned int		min_num_stack_tx_queues;
 };
 
 /* Messaging */
-- 
2.34.1

