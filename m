Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E0A5984E7
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245113AbiHRNyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245363AbiHRNyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:54:16 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2082.outbound.protection.outlook.com [40.107.105.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E9027172
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:53:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEo2Xykase8bs6Df1EtygbAANo6GRfI1prqjaJSEKwRVLGKbDxzma72CJO8lbElURxAV0HDVe9dnMLl2NaFDE81c85+/LTDH7JnWai1KkUVplz3SkHAiPmJKJd0MRsRZ6EyaqgRd+1kYFFpaT86EGgQ6v+4YOuoWG6s8m5DmWv97C8mS8QWre4UxMka//BH4phnvRQkaaGP/0lde2OLxxUNISzAtmgAvMAjPuwHMpACUeVGYda4iSwVhtw9EResEUgKZanu95gnbDlib7U2bsUFNHqKlvwA8c7MLuP5aQsRIBMnp59N52ExqQ9DsxjQFJnWr5E4q0o4A1DTNgcd7SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7abzOBoeW5P9YEeIvHgyTLIvb0I4o89SkODdwfDXb8c=;
 b=dsF9kWd0AbHJ5QjQZPl1KqwpuYETdxFOKnjtt9bXo9o+FU/sCvY9XK1/kLxyyYMM1by6j2ojqt1fySn/8w9S/vn4t9gX1Tqmv7jy8ahJQc+vY5Hf5vI56iXcR0DU0qPC/WGCejjapw1Wt6uCPn8P1F7tb4Q+RHp2tDVJsxWQn4STZlpug/Cex1toctRwNZ55wVzrmeUUDq/k7IkraHRkvKXmnwIMvKFZkq3VMu1BZS8yrn63ltznp12hc1ItB+v8fKSiH2NO6Yr+6e8kh6Ksc42ZOK+ZSGkHyk8CghPOMerk2zOqETCn6pPMM8lUrInbyFcFfvY1OdhBWVoKhj5MSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7abzOBoeW5P9YEeIvHgyTLIvb0I4o89SkODdwfDXb8c=;
 b=nMFxIGDWIQhEUVb6OrF1PFrRR58+N/VUw/jU3P0vr1XaqGDsqQo9AmHodsWi2dZJSfDs5B7jQ1Rz1iNXgnZYv0AfC0aOUZW8MUf8sBJ6htp0N/pIuU+9RSb18WVblJ0Ste3De7A1s65qvFgoAG04UoCTL94J0SbwdGgLB9WOMJc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 13:53:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 13:53:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v2 net-next 3/9] net: bridge: move DSA master bridging restriction to DSA
Date:   Thu, 18 Aug 2022 16:52:50 +0300
Message-Id: <20220818135256.2763602-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5900f163-9d50-4ab5-b458-08da8120fe71
X-MS-TrafficTypeDiagnostic: AM6PR04MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+hB5g0NCFTcb83IZ4C0ngrvvyEMQDCPWIC5Pq22/BnLSPAxo0dZVnjSLPQBclR184HYpw2dFAWa3U4hT62Es52hpPqFu0BMjjSQI8+EQlD2H25eAcVNGsiMCFyHjqYwbEZ8OTY1OslwlFbWE2kZbp5i4U+GFbOtgzjw2aiSG/eBAUGPG3yAms39Fh9WtMBkiwrPimGWjSdWqDTUoGm7emtHND8+2YvSKWC6F35RW7fQVuJxhfKJ2aneOoiKVJwhmt71bbxjSdPA3iDqYsVDsKnkbb2eqmtKElKGUmVRM04+lMWp57ntlZg5YQlzhhCE/QiPI4zRz3frrL1LBeIEb9hBeCQEOThueBOdrOamNy92d30AmRPTWISBpZMkzRH84fqFZiAgC9OxdhQm77axCFN/h05LDGrrqS7l77zrSK8VgzfeU/bKuaV5jgFs/ANRKKdw4/y5TI5HtlVH7Dt7vw4obs2WnrRKz4H1qxk/3uqixlrYZAHtxohX9jJpdxbaIxdj47oA+phEADJ3b589Pie6RuDB0xOi6xCKKBkjL32nHyyiyeh+NjBpK0UQpmyt6yBOdsDgoVuXj6bDGx04OuobpS3Gy/P4IfQLfkEH3hPWsfkXTMXrJ6zuy2N4IDFTALYhbPzT6h6qCi3s3b6VHDqjogD6S4Fit2Gbj6ll55WfF74Gt/zzBR562J39MITa5KsB/mj587ETqW4aHwP/OUo6AmikHdmmIc36HbWmIqDQkDeE4FlozrnrxDWLdUgMHP7AGUeRwcM0oqpkRQdSQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(66476007)(5660300002)(6916009)(4326008)(54906003)(66556008)(316002)(2906002)(44832011)(8936002)(38100700002)(66946007)(8676002)(38350700002)(7416002)(36756003)(478600001)(6506007)(52116002)(6666004)(83380400001)(6486002)(26005)(186003)(2616005)(6512007)(41300700001)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zIUy2Jc0l+tnmRDz2HfMGe5oT66INETxIg9dK6IVnB/SDz/LkBKTczYUlP+a?=
 =?us-ascii?Q?vUbaqukUJJpYm16HXVtnP7iVXFJX4X0ZYXrQC3Pioqi1c0EOI0EVDF+KKJW1?=
 =?us-ascii?Q?RL6LtjCKqwzag6iDo4zByQlZvuKxivXQmbPtmLagjb4c6YDgt/ZuJZkeKqGn?=
 =?us-ascii?Q?CKUsBlBqA9M7xF2cBtGZ7RGuesj9gx7uuJOhwUP/UGiZdTXJ7B036o4MUgGf?=
 =?us-ascii?Q?2my9fupN7f5NnDDclxjGN7dUvcFBnLg52Fdn2m+LxdeXU/1j+2tHtmk6p9nY?=
 =?us-ascii?Q?v/lVFzqawnDLUZWQB/mGim/D8+xXgbJHIwO0e+rcjYQXDmWNNuU2n94k6XCk?=
 =?us-ascii?Q?lU7kIddR6yKxObqHI+UcM1Q9cYsiOPSaEcSpy9dsU+vI5rSr7mxkqtKn4ZJo?=
 =?us-ascii?Q?wOaQsa3SnTbTvXyP36uthpdt7FcoUgW3kdcilr2h+7wdPR8Gzz+ViVm25yhJ?=
 =?us-ascii?Q?07NKMPY+vIrNFh9zavwNHpRxcexNEBVmPlpxQ7+NMfllyBV+wtHar04zPA92?=
 =?us-ascii?Q?SOCYxZwwSEX1Ink1sw41Rj2y3R58RQZ/956dCcVJZeZ1XC5XXhQRYo5JVRTZ?=
 =?us-ascii?Q?9Tiz9qjZtC6uATQN9C8Dn0soCNcN3FN8er+mk5vlVjaj43SlqFUEYlMMdc7t?=
 =?us-ascii?Q?pMwLT7Ex6heJ8NbK2ibZLNg3DZ/t2IKIj+oCAkefrX6hv0eXWQoKQ7hHntsV?=
 =?us-ascii?Q?6SQPGkXdB+c+Bn5K3nN8Fii3CK6D2TsApcXNKq5Uy2RaCH5dxFmY3YK2j1Ya?=
 =?us-ascii?Q?uIUMQzRsVz9rpSSslgeXIcsQK1RhvyPsufL31LPh5FWsjQRxnbYjLiEJdCHf?=
 =?us-ascii?Q?LDCS9DzI12Ey/xJkOCC3OPdBrPercm09Vma1DPX9gLnAaFUagJFelKTnQj/1?=
 =?us-ascii?Q?1+becR9iJNZVote51mKnh20IiQUh/ElDVgKlTAEzzyiZmFBH6/Df1LWtRkMu?=
 =?us-ascii?Q?knsfLfPl75anID9MyBT3vlOhXYR5/8Rz8gsQGqaTao622nTYNLJRxJSYlfr+?=
 =?us-ascii?Q?lhrMG/sLlF+YXz4206zlz5CQC/rhXPBKcqdDGs1flhRNVKtVcCpH1c1uJ2xA?=
 =?us-ascii?Q?G14a3fX8B/PD/zHTv5p9g7iH8+lVA8lOBHPpsxQbQBSZ/O0nZupaBODQR65x?=
 =?us-ascii?Q?yQIDVdy0A+YBgT7PPuq0avcWMLReOD3LnSnQWUAXbZIsZ20+7whCqQjaNWF0?=
 =?us-ascii?Q?kZTMyv1gZM1dgyUg3YzqaGx+69navkOd2Ve6sHZ9v6Y75aftYPtNXq+kLBjC?=
 =?us-ascii?Q?uNZigFp+zgJdJL41U90HTc2L4aXEvcw6yi5A9Tfp/R7KeYD0QWUUbHbByTmB?=
 =?us-ascii?Q?wSR+BnLS9RZS00/tksqNCYWlYCsNgGgwjcX8ZiimWSNWO7ifZqTi3ZvlI+Gm?=
 =?us-ascii?Q?+LaZy+6OFgCYxGaKsSkuXPUfEHHuEBtOsr/Tl7gmJp+N+38UrZ44CPM1vZdd?=
 =?us-ascii?Q?K326ked/M3XpN6Np2eoArz6YhQCuy8y9zlCQ1fpXWG7waakPpJfviII2Yr/G?=
 =?us-ascii?Q?b+SdOwJ01x+oxNkc45z9YMlX59OD42v4jCagqqlowlZehu3UJ3anlo8VBbGj?=
 =?us-ascii?Q?DIw5q/M1htYsUo4FmBnNE7HQcu7vS4sj8WlSBust4ApsYf9gjmvhMkYTO7Iq?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5900f163-9d50-4ab5-b458-08da8120fe71
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:53:13.5553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmoN5D3/pdUv2hY8pR2a3FHucBqmHyT38V6v5awz2772iVZdr9xuSwQuQlaSVPHPEJ04XhzdkqDWhuy11Pi7aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When DSA gains support for multiple CPU ports in a LAG, it will become
mandatory to monitor the changeupper events for the DSA master.

In fact, there are already some restrictions to be imposed in that area,
namely that a DSA master cannot be a bridge port except in some special
circumstances.

Centralize the restrictions at the level of the DSA layer as a
preliminary step.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
v1->v2: none

 net/bridge/br_if.c | 20 --------------------
 net/dsa/slave.c    | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a84a7cfb9d6d..efbd93e92ce2 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -568,26 +568,6 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	    !is_valid_ether_addr(dev->dev_addr))
 		return -EINVAL;
 
-	/* Also don't allow bridging of net devices that are DSA masters, since
-	 * the bridge layer rx_handler prevents the DSA fake ethertype handler
-	 * to be invoked, so we don't get the chance to strip off and parse the
-	 * DSA switch tag protocol header (the bridge layer just returns
-	 * RX_HANDLER_CONSUMED, stopping RX processing for these frames).
-	 * The only case where that would not be an issue is when bridging can
-	 * already be offloaded, such as when the DSA master is itself a DSA
-	 * or plain switchdev port, and is bridged only with other ports from
-	 * the same hardware device.
-	 */
-	if (netdev_uses_dsa(dev)) {
-		list_for_each_entry(p, &br->port_list, list) {
-			if (!netdev_port_same_parent_id(dev, p->dev)) {
-				NL_SET_ERR_MSG(extack,
-					       "Cannot do software bridging with a DSA master");
-				return -EINVAL;
-			}
-		}
-	}
-
 	/* No bridging of bridges */
 	if (dev->netdev_ops->ndo_start_xmit == br_dev_xmit) {
 		NL_SET_ERR_MSG(extack,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 008bbe1c0285..09767f4b3b37 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2699,6 +2699,46 @@ dsa_slave_prechangeupper_sanity_check(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+/* Don't allow bridging of DSA masters, since the bridge layer rx_handler
+ * prevents the DSA fake ethertype handler to be invoked, so we don't get the
+ * chance to strip off and parse the DSA switch tag protocol header (the bridge
+ * layer just returns RX_HANDLER_CONSUMED, stopping RX processing for these
+ * frames).
+ * The only case where that would not be an issue is when bridging can already
+ * be offloaded, such as when the DSA master is itself a DSA or plain switchdev
+ * port, and is bridged only with other ports from the same hardware device.
+ */
+static int
+dsa_bridge_prechangelower_sanity_check(struct net_device *new_lower,
+				       struct netdev_notifier_changeupper_info *info)
+{
+	struct net_device *br = info->upper_dev;
+	struct netlink_ext_ack *extack;
+	struct net_device *lower;
+	struct list_head *iter;
+
+	if (!netif_is_bridge_master(br))
+		return NOTIFY_DONE;
+
+	if (!info->linking)
+		return NOTIFY_DONE;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	netdev_for_each_lower_dev(br, lower, iter) {
+		if (!netdev_uses_dsa(new_lower) && !netdev_uses_dsa(lower))
+			continue;
+
+		if (!netdev_port_same_parent_id(lower, new_lower)) {
+			NL_SET_ERR_MSG(extack,
+				       "Cannot do software bridging with a DSA master");
+			return notifier_from_errno(-EINVAL);
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int dsa_slave_netdevice_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
@@ -2713,6 +2753,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_bridge_prechangelower_sanity_check(dev, info);
+		if (notifier_to_errno(err))
+			return err;
+
 		err = dsa_slave_prechangeupper(dev, ptr);
 		if (notifier_to_errno(err))
 			return err;
-- 
2.34.1

