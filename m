Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422A159657E
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbiHPW3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238012AbiHPW3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:29:41 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60064.outbound.protection.outlook.com [40.107.6.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26617B2BC
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:29:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwhIBZziYp6utMRH3bfjTz85LrzaQvRFvewJzw+u1WfHxRYq+EdvuZomuvZgc5VcA4GBKbxUEZmyfTZaqabiB0Nhq7n1JuN1eSPcgvoJ9lhFI5tQ5hftD2DIIx3ftkeIJsCkO2lZFaotWvUtxSnsnDGu436V656Q5Kxa7cx/qAP3jQnBMuxTkImaeg4pPeZ5+Srmk2cC1YqayR4b4GljxuhDLHj1wlQGsiS1vHBCDaTI+vaXEnLLCUOH4LUPurhwDMhxjuU+qnM4UA3uMgiUDTcLY8smGigkMbaQJ2RC+uIPfQTM7heVLavoqNZeff6yca8se2sjQF3R9MdrDH52Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ci3BGnksxk1cuXJM6Ng9LUvnTbQwyddUiYsntfB15j8=;
 b=Nj1gxt/mGbDN/2l9Kis9DQO14MBZlGmb1CZRNUwuu6uqCn7nESHAbvgBuelK8bSGaxB+ikjNzy/BMHUsmOHQUbV6OQDpn06CR48npyKE0+f6UknAC/5e5XEe/3fgiYX8ezARziTmbYb+UHUOjADPuADw9NaxFgNUvvMG/Me1GblmGir0g0DgnUTlw4lK/5dQRoGeGg/TLlE7+ob4HxZQ4neESRoDzGf1kT6WdL4IL3CiJ1IwZj3N2kJgRR+UMdgOaMn4dR8laB6qvuqwmLaOhD+e0ULKKwT4WWhufDw1FLCMqafOQbuwWb3xMOMgsfEhR2TUbO9J7l16KOngW8cJ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ci3BGnksxk1cuXJM6Ng9LUvnTbQwyddUiYsntfB15j8=;
 b=bFo2J9XgJD1KBTaE7IkAd5gtgY9o308iJ7dsw3ne2N1jgCjDduQU9BUB1nbAGsQLaPiXs7CFJ/pzuX1CTedter2HlMiIV77KfW/RS1Ur5FgGhBVt1PMfHpoE/t5eTA9KtprWVL9UZNf0xIgnzTeEluGr5/+149quQtPcK/O7tiM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8618.eurprd04.prod.outlook.com (2603:10a6:20b:439::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 22:29:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 22:29:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: [RFC PATCH net-next 3/7] net: ethtool: stats: make stats_put_stats() take input from multiple sources
Date:   Wed, 17 Aug 2022 01:29:16 +0300
Message-Id: <20220816222920.1952936-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0021.eurprd05.prod.outlook.com
 (2603:10a6:800:92::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 651d908d-e58d-4626-6342-08da7fd6ca9d
X-MS-TrafficTypeDiagnostic: AM9PR04MB8618:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AVirBR+B/p8w249Jqff5u7xJJKJSisWRA4p4OXWD2tRTxq9hoKShkswI/sdMk0G66h9Cjvnxget4RjznoDUVZxTEXAaxLpnqniv2ajylb6euBPgBMWthON24YeWrh/ku0NSoS0Pi+FQ/pOXfbusu06Qs921Cb4TZqWuDiikjKa4vFqkHJNo/e+rU8XQAB55kqZFO/Ldcgt0k38n1jEiXOrSkkSFfOudN5nncSa/3LvIP/cxhQ+8OYeo9gO4Ib0UJP957q0KLnSuvBFouafNAKneuoLOKg+BsiFsPK1CH0/gQ/rj6m4u/sFa6Gl1rVdKfmafZkp2FL0r9lq+IaosQbyWlfJxgEb+QLhJfVMZ99c4d8PvC9AG/s3sxUWsLJSTj5KW2nP+prahMTQhmz+erm7oTLaEaTvG7WTGuKfGoLYBL19heIdsLMxn0J5cdODFwrz3r1ZOjVleAXg9dCU9yP1gdR3j2kolIHAwXirbXpZdYRkX9WFs0EICsFWnAkPcvtI3saGapsSKqO7JiMOp5RC3+CxudOB8jw2NIxbu/LOQ8OLgiiKPpgn9kERUixdeJ8evrxhXPC1/7JeFtTo0ZfNCzSa4luj0JvpFJKbr2Oqh6rMJ66pcdkrp8wn9s9UG4btHTre1IJEsiJRzzGGW6+bsVzrw5/cQ6mkwoCGa3uiQrbe2B/ZkdArZp7UUXz3l67A1BTCXkjy35qXyfCx3U8+Tv5VYy92hk8EQolphr1P4Lt1FXI2fe6IxO82W6lplTSbhZiXxT2M2mLU9DKSr80ZkjrTYQnISv4+TxxuRskFtM1SAwt5oFcdVGXQD4Q2RWlh8k9et7ovds50rGJstEjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(66946007)(44832011)(316002)(1076003)(66556008)(8676002)(83380400001)(41300700001)(6666004)(6916009)(4326008)(2906002)(36756003)(54906003)(186003)(2616005)(38100700002)(26005)(38350700002)(30864003)(6506007)(6512007)(66476007)(6486002)(8936002)(86362001)(478600001)(52116002)(5660300002)(44824005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gmPGCsKd7k1pZPMJCtd4tuWLUbyBMMFE7WENMlLJIoKb9vui2iQ2mfij+G7G?=
 =?us-ascii?Q?ohpRxAZA6pfX/nCnK9swoR1S2iOgaCXgMgwVCN/Yn+XWVGZXDHlOY5NSmzht?=
 =?us-ascii?Q?OCYc+Ltj7M1lq3LGmanb+7tBrGZIleaTGHQaYkf+84NJ/jnSuAD7aj0MI8Fd?=
 =?us-ascii?Q?5FeZ6wz4OCAu5fQ0tgEKQe9Q2BeJ+q/6kL1LLSRxNk+r5IVsBVoI54VLCx4I?=
 =?us-ascii?Q?7lmym1/lSrDGTxfYjiM0tsEPPmnN6km0oFLNQ6pF2oRWikqZgJMeLxWjakbs?=
 =?us-ascii?Q?aGun3DTLtyS2mRlvfT+42Pt7WE/jiomrNuhabbNRbKU/ib58rt4Ff27oEjya?=
 =?us-ascii?Q?etwnMtI/D4k8Yo5+1ik9pbJl1sEFhkSevFoUKjJifBMsCWIqQgcP+P1E/t/q?=
 =?us-ascii?Q?E63x7hmTUCu9S852QrpVEzE5B2EVduS4Ut8ISqoogJzQLx0fMaRIpGRfM4zN?=
 =?us-ascii?Q?X6gESs1wMjeVlKXBH6s/uNDx/c1YHAQR1l1sSkyZXJcD3U/VRXrRV+qI+3Ub?=
 =?us-ascii?Q?r0nbUPwhk6+uk9F4eDfR9qQGF0k81l+WBjz4wUAAZEmkZ1k4H6mqaEdRqIcb?=
 =?us-ascii?Q?wxqZKqmL+4eubGuOfamGCTaiPY0GPepg0nsyK9VMGGLF33hNAHI2QYxDNvuW?=
 =?us-ascii?Q?PoGx2nyzlUvbpU8MXUpSN45GwJNSj8v0AFfRSmNmjkRk1EZv+1w3z5HvQDhB?=
 =?us-ascii?Q?43UghBfaxTObUCdHyBECRj8w4hpG83ckO0RfX/5uYSMPTdUSAyVTSoavzhzj?=
 =?us-ascii?Q?Wz0XaYN4Xq+Vds+FYxyKcFI5grP1CtixMtOUqLiCH8yoioUfk+1gqgN9js0+?=
 =?us-ascii?Q?Vg8inA/7zCPY9cGUhkQNDusUocESqrtyS8wFJclNyTKRoDt9lgNUS2LOoSLU?=
 =?us-ascii?Q?NkJ5EK/VTSxoBAPPxAbVqJzD3QyifJfVmVhSH3AGxlXN1DK+A59C7NzwKRJy?=
 =?us-ascii?Q?G/z0ykjICjXdUmwkd6C8JdYWL3sU2aTITJJQxozLA879MVSvsGiIBmkU06Qn?=
 =?us-ascii?Q?S07AARxjdsZuW7hNmLcwKXnCv1LZS5oo8Zm272Ojxcsa5vKUqtfolbGTLJzX?=
 =?us-ascii?Q?5XupkO0zNLK2utRlptwQMHYHENXRG1ZQPjdj6buKklytajjRwPJHg5bNV3nb?=
 =?us-ascii?Q?YxwO+LxpMmDgWQiuP77NqlNNyyTFYQY8ybKiYSFrPS/F/HCSWBrXi7/wFA6h?=
 =?us-ascii?Q?HBl8o6bsT0/V4719Ph809Yvat40KdRMqs69lgF93FXmDPhTmW0ooBppBsxe7?=
 =?us-ascii?Q?lk3D1hRI6fSWHMJ1zfX3Ma3/u0HhSQFeMMERzwd1oMIXoKXNRyBaPK2tXk9h?=
 =?us-ascii?Q?d3Qz5pMIkWpKpsx1n4XFSoTEdHhueMeMKYezTYN043qKvfx62EjzURSakBCr?=
 =?us-ascii?Q?6mPEaJgV5Ov/HFkErXnZ08knPbJQTyhtd3Kk1zb9mHMeqL1QoO6kLSkA/zFM?=
 =?us-ascii?Q?ImHt8rJ5MtGD26r2T/DWRaxu/+tEVLCMYab/gVx7YG3VeUIrAZmbg5FgwwvS?=
 =?us-ascii?Q?90bPXU1XnVO0GCAzumWWQA7vztc69b1nPCRUprIS0NUcWwtHtzm/5oaDtHaZ?=
 =?us-ascii?Q?KXIPsw7oQDP0uvrhtC7MK4Le+vp3yNtuQKZOwPsnOenlznIOmtfXHVQFFqUz?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 651d908d-e58d-4626-6342-08da7fd6ca9d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 22:29:32.7418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hU2if1zuvAn7vIf6V8/R0K1tmDdH3QTSJJVWT5WedbhkGg6XS0ckDonSYp4+BbN9D+f9scM9+VBi1O8DKlF/TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8618
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.3 defines a MAC merge layer, for supporting the 802.1Q Frame
Preemption capability. Beyond the MAC merge layer there are 2 distinct
MACs, one is for express traffic (eMAC, aka the good old MAC that the
Linux network stack knows about) and the other is for preemptable
traffic (pMAC).

The pMAC is a MAC in its own right, and has a full set of statistics
that can be exposed through the standardized ethtool counters (RMON,
802.3 etc).

In preparation for extending struct stats_reply_data to store both the
eMAC and the pMAC stats structures, modify stats_put_stats() to not
assume that we only care about the eMAC stats. Instead, we will
introduce separate ops for pMAC stats, and put those stats into separate
netlink attributes, and take them from different instances of the same
structure types as in the case of the eMAC.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/ethtool/stats.c | 148 +++++++++++++++++++++++++-------------------
 1 file changed, 86 insertions(+), 62 deletions(-)

diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index a20e0a24ff61..8d4d3c70c0a4 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -9,6 +9,11 @@ struct stats_req_info {
 	DECLARE_BITMAP(stat_mask, __ETHTOOL_STATS_CNT);
 };
 
+struct rmon_stats_put_ctx {
+	const struct ethtool_rmon_stats *rmon_stats;
+	const struct ethtool_rmon_hist_range *rmon_ranges;
+};
+
 #define STATS_REQINFO(__req_base) \
 	container_of(__req_base, struct stats_req_info, base)
 
@@ -110,8 +115,11 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	const struct stats_req_info *req_info = STATS_REQINFO(req_base);
 	struct stats_reply_data *data = STATS_REPDATA(reply_base);
 	struct net_device *dev = reply_base->dev;
+	const struct ethtool_ops *ops;
 	int ret;
 
+	ops = dev->ethtool_ops;
+
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
@@ -122,18 +130,18 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	memset(&data->stats, 0xff, sizeof(data->stats));
 
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
-	    dev->ethtool_ops->get_eth_phy_stats)
-		dev->ethtool_ops->get_eth_phy_stats(dev, &data->phy_stats);
+	    ops->get_eth_phy_stats)
+		ops->get_eth_phy_stats(dev, &data->phy_stats);
 	if (test_bit(ETHTOOL_STATS_ETH_MAC, req_info->stat_mask) &&
-	    dev->ethtool_ops->get_eth_mac_stats)
-		dev->ethtool_ops->get_eth_mac_stats(dev, &data->mac_stats);
+	    ops->get_eth_mac_stats)
+		ops->get_eth_mac_stats(dev, &data->mac_stats);
 	if (test_bit(ETHTOOL_STATS_ETH_CTRL, req_info->stat_mask) &&
-	    dev->ethtool_ops->get_eth_ctrl_stats)
-		dev->ethtool_ops->get_eth_ctrl_stats(dev, &data->ctrl_stats);
+	    ops->get_eth_ctrl_stats)
+		ops->get_eth_ctrl_stats(dev, &data->ctrl_stats);
 	if (test_bit(ETHTOOL_STATS_RMON, req_info->stat_mask) &&
-	    dev->ethtool_ops->get_rmon_stats)
-		dev->ethtool_ops->get_rmon_stats(dev, &data->rmon_stats,
-						 &data->rmon_ranges);
+	    ops->get_rmon_stats)
+		ops->get_rmon_stats(dev, &data->rmon_stats,
+				    &data->rmon_ranges);
 
 	ethnl_ops_complete(dev);
 	return 0;
@@ -212,76 +220,82 @@ static int stat_put(struct sk_buff *skb, u16 attrtype, u64 val)
 	return 0;
 }
 
-static int stats_put_phy_stats(struct sk_buff *skb,
-			       const struct stats_reply_data *data)
+static int stats_put_phy_stats(struct sk_buff *skb, const void *src)
 {
+	const struct ethtool_eth_phy_stats *phy_stats = src;
+
 	if (stat_put(skb, ETHTOOL_A_STATS_ETH_PHY_5_SYM_ERR,
-		     data->phy_stats.SymbolErrorDuringCarrier))
+		     phy_stats->SymbolErrorDuringCarrier))
 		return -EMSGSIZE;
+
 	return 0;
 }
 
-static int stats_put_mac_stats(struct sk_buff *skb,
-			       const struct stats_reply_data *data)
+static int stats_put_mac_stats(struct sk_buff *skb, const void *src)
 {
+	const struct ethtool_eth_mac_stats *mac_stats = src;
+
 	if (stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_2_TX_PKT,
-		     data->mac_stats.FramesTransmittedOK) ||
+		     mac_stats->FramesTransmittedOK) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_3_SINGLE_COL,
-		     data->mac_stats.SingleCollisionFrames) ||
+		     mac_stats->SingleCollisionFrames) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_4_MULTI_COL,
-		     data->mac_stats.MultipleCollisionFrames) ||
+		     mac_stats->MultipleCollisionFrames) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_5_RX_PKT,
-		     data->mac_stats.FramesReceivedOK) ||
+		     mac_stats->FramesReceivedOK) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_6_FCS_ERR,
-		     data->mac_stats.FrameCheckSequenceErrors) ||
+		     mac_stats->FrameCheckSequenceErrors) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_7_ALIGN_ERR,
-		     data->mac_stats.AlignmentErrors) ||
+		     mac_stats->AlignmentErrors) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_8_TX_BYTES,
-		     data->mac_stats.OctetsTransmittedOK) ||
+		     mac_stats->OctetsTransmittedOK) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_9_TX_DEFER,
-		     data->mac_stats.FramesWithDeferredXmissions) ||
+		     mac_stats->FramesWithDeferredXmissions) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_10_LATE_COL,
-		     data->mac_stats.LateCollisions) ||
+		     mac_stats->LateCollisions) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_11_XS_COL,
-		     data->mac_stats.FramesAbortedDueToXSColls) ||
+		     mac_stats->FramesAbortedDueToXSColls) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_12_TX_INT_ERR,
-		     data->mac_stats.FramesLostDueToIntMACXmitError) ||
+		     mac_stats->FramesLostDueToIntMACXmitError) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_13_CS_ERR,
-		     data->mac_stats.CarrierSenseErrors) ||
+		     mac_stats->CarrierSenseErrors) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_14_RX_BYTES,
-		     data->mac_stats.OctetsReceivedOK) ||
+		     mac_stats->OctetsReceivedOK) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_15_RX_INT_ERR,
-		     data->mac_stats.FramesLostDueToIntMACRcvError) ||
+		     mac_stats->FramesLostDueToIntMACRcvError) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_18_TX_MCAST,
-		     data->mac_stats.MulticastFramesXmittedOK) ||
+		     mac_stats->MulticastFramesXmittedOK) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_19_TX_BCAST,
-		     data->mac_stats.BroadcastFramesXmittedOK) ||
+		     mac_stats->BroadcastFramesXmittedOK) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_20_XS_DEFER,
-		     data->mac_stats.FramesWithExcessiveDeferral) ||
+		     mac_stats->FramesWithExcessiveDeferral) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_21_RX_MCAST,
-		     data->mac_stats.MulticastFramesReceivedOK) ||
+		     mac_stats->MulticastFramesReceivedOK) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_22_RX_BCAST,
-		     data->mac_stats.BroadcastFramesReceivedOK) ||
+		     mac_stats->BroadcastFramesReceivedOK) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_23_IR_LEN_ERR,
-		     data->mac_stats.InRangeLengthErrors) ||
+		     mac_stats->InRangeLengthErrors) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_24_OOR_LEN,
-		     data->mac_stats.OutOfRangeLengthField) ||
+		     mac_stats->OutOfRangeLengthField) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_MAC_25_TOO_LONG_ERR,
-		     data->mac_stats.FrameTooLongErrors))
+		     mac_stats->FrameTooLongErrors))
 		return -EMSGSIZE;
+
 	return 0;
 }
 
-static int stats_put_ctrl_stats(struct sk_buff *skb,
-				const struct stats_reply_data *data)
+static int stats_put_ctrl_stats(struct sk_buff *skb, const void *src)
 {
+	const struct ethtool_eth_ctrl_stats *ctrl_stats = src;
+
 	if (stat_put(skb, ETHTOOL_A_STATS_ETH_CTRL_3_TX,
-		     data->ctrl_stats.MACControlFramesTransmitted) ||
+		     ctrl_stats->MACControlFramesTransmitted) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_CTRL_4_RX,
-		     data->ctrl_stats.MACControlFramesReceived) ||
+		     ctrl_stats->MACControlFramesReceived) ||
 	    stat_put(skb, ETHTOOL_A_STATS_ETH_CTRL_5_RX_UNSUP,
-		     data->ctrl_stats.UnsupportedOpcodesReceived))
+		     ctrl_stats->UnsupportedOpcodesReceived))
 		return -EMSGSIZE;
+
 	return 0;
 }
 
@@ -322,33 +336,34 @@ static int stats_put_rmon_hist(struct sk_buff *skb, u32 attr, const u64 *hist,
 	return -EMSGSIZE;
 }
 
-static int stats_put_rmon_stats(struct sk_buff *skb,
-				const struct stats_reply_data *data)
+static int stats_put_rmon_stats(struct sk_buff *skb, const void *src)
 {
+	const struct ethtool_rmon_hist_range *rmon_ranges;
+	const struct ethtool_rmon_stats *rmon_stats;
+	const struct rmon_stats_put_ctx *ctx = src;
+
+	rmon_stats = ctx->rmon_stats;
+	rmon_ranges = ctx->rmon_ranges;
+
 	if (stats_put_rmon_hist(skb, ETHTOOL_A_STATS_GRP_HIST_RX,
-				data->rmon_stats.hist, data->rmon_ranges) ||
+				rmon_stats->hist, rmon_ranges) ||
 	    stats_put_rmon_hist(skb, ETHTOOL_A_STATS_GRP_HIST_TX,
-				data->rmon_stats.hist_tx, data->rmon_ranges))
+				rmon_stats->hist_tx, rmon_ranges))
 		return -EMSGSIZE;
 
 	if (stat_put(skb, ETHTOOL_A_STATS_RMON_UNDERSIZE,
-		     data->rmon_stats.undersize_pkts) ||
+		     rmon_stats->undersize_pkts) ||
 	    stat_put(skb, ETHTOOL_A_STATS_RMON_OVERSIZE,
-		     data->rmon_stats.oversize_pkts) ||
-	    stat_put(skb, ETHTOOL_A_STATS_RMON_FRAG,
-		     data->rmon_stats.fragments) ||
-	    stat_put(skb, ETHTOOL_A_STATS_RMON_JABBER,
-		     data->rmon_stats.jabbers))
+		     rmon_stats->oversize_pkts) ||
+	    stat_put(skb, ETHTOOL_A_STATS_RMON_FRAG, rmon_stats->fragments) ||
+	    stat_put(skb, ETHTOOL_A_STATS_RMON_JABBER, rmon_stats->jabbers))
 		return -EMSGSIZE;
 
 	return 0;
 }
 
-static int stats_put_stats(struct sk_buff *skb,
-			   const struct stats_reply_data *data,
-			   u32 id, u32 ss_id,
-			   int (*cb)(struct sk_buff *skb,
-				     const struct stats_reply_data *data))
+static int stats_put_stats(struct sk_buff *skb, const void *src, u32 id, u32 ss_id,
+			   int (*cb)(struct sk_buff *skb, const void *src))
 {
 	struct nlattr *nest;
 
@@ -360,7 +375,7 @@ static int stats_put_stats(struct sk_buff *skb,
 	    nla_put_u32(skb, ETHTOOL_A_STATS_GRP_SS_ID, ss_id))
 		goto err_cancel;
 
-	if (cb(skb, data))
+	if (cb(skb, src))
 		goto err_cancel;
 
 	nla_nest_end(skb, nest);
@@ -380,20 +395,29 @@ static int stats_fill_reply(struct sk_buff *skb,
 	int ret = 0;
 
 	if (!ret && test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask))
-		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_PHY,
+		ret = stats_put_stats(skb, &data->phy_stats,
+				      ETHTOOL_STATS_ETH_PHY,
 				      ETH_SS_STATS_ETH_PHY,
 				      stats_put_phy_stats);
 	if (!ret && test_bit(ETHTOOL_STATS_ETH_MAC, req_info->stat_mask))
-		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_MAC,
+		ret = stats_put_stats(skb, &data->mac_stats,
+				      ETHTOOL_STATS_ETH_MAC,
 				      ETH_SS_STATS_ETH_MAC,
 				      stats_put_mac_stats);
 	if (!ret && test_bit(ETHTOOL_STATS_ETH_CTRL, req_info->stat_mask))
-		ret = stats_put_stats(skb, data, ETHTOOL_STATS_ETH_CTRL,
+		ret = stats_put_stats(skb, &data->ctrl_stats,
+				      ETHTOOL_STATS_ETH_CTRL,
 				      ETH_SS_STATS_ETH_CTRL,
 				      stats_put_ctrl_stats);
-	if (!ret && test_bit(ETHTOOL_STATS_RMON, req_info->stat_mask))
-		ret = stats_put_stats(skb, data, ETHTOOL_STATS_RMON,
+	if (!ret && test_bit(ETHTOOL_STATS_RMON, req_info->stat_mask)) {
+		struct rmon_stats_put_ctx ctx = {
+			.rmon_stats = &data->rmon_stats,
+			.rmon_ranges = data->rmon_ranges,
+		};
+
+		ret = stats_put_stats(skb, &ctx, ETHTOOL_STATS_RMON,
 				      ETH_SS_STATS_RMON, stats_put_rmon_stats);
+	}
 
 	return ret;
 }
-- 
2.34.1

