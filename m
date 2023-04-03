Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541CF6D423C
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbjDCKhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbjDCKhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:37:03 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607EB12875;
        Mon,  3 Apr 2023 03:36:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d16OT57Mm4s3lkBXG2BvM+HvOFyrCJnotImw7XXPi3ik0F471huwjWxql5+hHUiCwF6IueRdMQ7PM5Co+NRW75o/USoz3+Ws6Oi717jveIpD5R7OGtIA2/93XykLsvbS0OxP/iMZSn5i66oknCrrSP2ndiCpHfI9u9yJxamBds54Kzg7BEZf4R5bn/vaUaNxL3S7cT4TBBzZo4CmWV4MJWkdkMOJ4jQ/cJJyDZZ5dUeDCXkIOBJL5WUHFNVDhw3uxCXaZwjOuFCZWUjcJg4+P693/MZ1b49ZAXnc+7I5ysWjTyNg2oCI/ms0js5+swVqePCG2efPvWCVveQWWu2fcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIEbuwGFx0j3/eVF8eQ7Yt7xrWD7sp6ajUPav85rFx8=;
 b=WJfSNKdazQtV7g8JhYM2yvTfrBpbtfE3zAwwx3iZRdSA3TrfDY/Sg7GMu/0cP8l2QmZ0Vehl8FcSYqNbGxLO3JVeMZ7p6SJ5g7t0wCedmBbeMbt1HTqK7tT0nDhwBfOSe52Xl/lxdmsm/2K1rcKOfHvtJFZJxftKoL3GW+IBkUBjUOFdfCMVnBFzAXvDG1lN/PAb0Ob/J4GuKVlfbrphQLZ9RH4T6detKJWrBkh5z9jNydq2x1FqjM3Lyhlxrmjqu1keJQtMMNVmF+hIr/oX6hILSqJLGeyXRM6NSrVaizDO8R8bpoagH5FdUjuwv9iobD0lgs48chvzI9GG+vr9ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIEbuwGFx0j3/eVF8eQ7Yt7xrWD7sp6ajUPav85rFx8=;
 b=ICXZcUWEFvogWF0vnFX/zDAIFejWnSJZGfnzeC/6h9hFI7mR6hNM96hJWsxycTsa7VGw2gVCWaQKFLoBDxUwK7ltMdE3sEsy/kCpC+xAS6/QAe7TUvkMwT9P/d1s//MgCPQNCkPx8YOf9ISfRZysLIQeAAOrDpLCmavOT5c8Le4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS4PR04MB9292.eurprd04.prod.outlook.com (2603:10a6:20b:4e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 10:35:10 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:35:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v4 net-next 8/9] net: enetc: rename "mqprio" to "qopt"
Date:   Mon,  3 Apr 2023 13:34:39 +0300
Message-Id: <20230403103440.2895683-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0221.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ac::17) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS4PR04MB9292:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fef957f-ed1f-423a-ff2d-08db342f198f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FRE8+snUODInuCFt6xS7mQF6Fzs5BVpCvNLr+PxZSlIUb2ubeeOG0cLGTMWbxt4pR0eNKsDXcQHGEisp51EV1a4e9He/cvTBpm6JV7+Bq0n2v2FpsidkHPbUhtqXmssyzQJdndiLq7Ucg4dIe6vvqilqPXJdmpLiq2InDgYh8WymsbamruVZSNzajgQCNqVP+7WhKZP4v24FbWEX7ju81+JsC5VocFxhA4XmCnSNf1O4XzSbawzSTc9HHwQB7jERB8BwwzrZvH3hJBawh6nTXAAL9eAwCla0ScNBGKegCvVW5hc6tvesToviXyr/a6ruEkA6TckVrYTUkpPxJEKwbriikNhP8g2H0b+xk2KwI876tO0IjJDcNVVb5JqypApQgIdK8HUNvAZsY+jpv3R3qa5ZJ5YiNR7yCDtCFnJ+GiS86FfRZSUFWr2j5E+0AnBKa3ueQMRvI5xXOp7F2X5VHYveiIKdN1p4QGaiMKG1dkOEC/zDxNwWQJq/y80/ZWeqYauv2pFWla647PZv7IKvd60N8I3xHMhzP2CZMcJ3b3RfXMn5TKNLkAFNZSItBflClpun1NlAhzjWadpR75NWLeEqlJNkrNe+9o4BitCZ8cXUzMnaJ+UPtiJ43DB8/OL4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(26005)(1076003)(6506007)(186003)(38350700002)(38100700002)(6512007)(86362001)(316002)(54906003)(41300700001)(7416002)(5660300002)(44832011)(66556008)(66476007)(4326008)(66946007)(8676002)(6916009)(478600001)(52116002)(8936002)(6666004)(6486002)(36756003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UafAnyEoGvJpLss5qURFsYXhxrHh+zKbeirAPsyNNHyikof6yGsXTEgbTol6?=
 =?us-ascii?Q?Z8xy/Bv3uvF6e1kRfXPItfrGgM4AjaIHPkNf5b/thdAqL7n6GLQbH8gP7RmJ?=
 =?us-ascii?Q?pNM2eQaJsmfNufg6212K5lf5+PR5PJ/nw9adzdaN7+NXJ5hQNJILYQ+AsQZz?=
 =?us-ascii?Q?CmShJ0YbzmgMNT3oLdAYcyAQ0MdTZ7K8nkaeXPvEZgXRkFuXWoSOJukNswNL?=
 =?us-ascii?Q?vjwGd+Aex7SJBktvuN2IbKQK+oypL81fFVGROFn6ZsoKopsr5S5o6waAFqAU?=
 =?us-ascii?Q?t8IIVcse4vo75GHwuQoUaq3fH9X6BKoXghuC7W4jS4pb0oskPPekkg4WC1be?=
 =?us-ascii?Q?uXtCMGaGSaT9gmQ+C5wjxnTN0HdWm/qtJJRIoo9t13eZB30oej36ZOfyGGsb?=
 =?us-ascii?Q?dUOCWkScLgfy0uqmEqXyBi5Pn/o4fPhEvuZ2wW9mw46Rmi0VVK9MoYwUNJ0T?=
 =?us-ascii?Q?Z4A0A11mOlOPKuNAvNA8JmucrIim5jxQFCxvdds4tV650oWHrpWSRAakB9Sl?=
 =?us-ascii?Q?Pu/tG8mprp9y8WXuBEMxGxf8F2P2hUAFJpwz7Wc8cfduSiB/yvpEYS1SfuCf?=
 =?us-ascii?Q?2nHari9iNRaPfXgvcs/ktSLeJ6wShtkU8WuTpyVfo61ua3Rx4fRg1IDefD5m?=
 =?us-ascii?Q?5CRnCDubIFalbGXnCr+kwsyhThxYwgAnXL6oKtzwQdWAiM+bAHKwTyrTC61e?=
 =?us-ascii?Q?uyGOjRmYLckyih+MqU3pNcZ8ebeohnaOJRVmFV80IkOU0JYMBLUHCRJ55ZfI?=
 =?us-ascii?Q?STL3KGUyJQUUrq8jLQ0fKxqT1E7aJp1ntx6+WnKsCCJ2UrgL5iCyXXltH3DD?=
 =?us-ascii?Q?6sGVb82EBV3mL1w+zfmUSoUB71UTubq8nmvWUB54zh4Ld59mbh/HNXJ8UBaK?=
 =?us-ascii?Q?u07hTQBWmMaJYn3WtQSTh38jVULLs7I07gAyyr4pujZyuC46zXmSapyEYmmo?=
 =?us-ascii?Q?T+RAwBSgG5VslrlKoB7vsPrW88/cZIxxAo5jxC8qu2GzEk/PXCgNev0eqLks?=
 =?us-ascii?Q?KiBLMDuk638AmhSHtnopUCGGC+yjETr6qFUrb/0nMPO4jSOVx5Bczmk3XPCn?=
 =?us-ascii?Q?dKiQtt7pHwNSFTufDsS/Dhc2rWVTpi6LzN65Uj4A091wFPi6GHbrQYziT8Wt?=
 =?us-ascii?Q?38gsL8bdVRERdyoobEEszHVDE1G75bIMxPv8+LwzKic4qlxddPdpOgO79OY8?=
 =?us-ascii?Q?UXql9jgWEstburIbP5Td/mVq99xMCqg+X3N/RLaTvsucoUUCguVou5EldnXt?=
 =?us-ascii?Q?94144wOj0C3WhOBZOxZIG0j/1WT7/gDcsHc/T/l4IN2ph9tLjPp4XcqXvQFI?=
 =?us-ascii?Q?kkGhiNkILYJPjr6AVkPH3NpoQlVD+QaUj74Vcgkb7MHsktMRqG+3xrGaEXYw?=
 =?us-ascii?Q?gA8AMniUQlJaiMA/ekzWVr93meG62sE9HbcJ1n7KoT/oaV30hhUb3qn2CkLf?=
 =?us-ascii?Q?1u1X4clEN3luT+OCmF2Bi8ruEsCnCZhqWcDGuOai1RqlaWPjIqX3P52+25ig?=
 =?us-ascii?Q?TvLbHaZCAY4trqi3beAI4AR2TUASkVeBG50jsTNIwHQ+y4sJgWVuXW1bVdX2?=
 =?us-ascii?Q?0JwJqXk35UR3ZVC8WPGEfFBr/1W76D/SfJDRcVszVhC5g5y8eXNCTE1d0MXG?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fef957f-ed1f-423a-ff2d-08db342f198f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:35:10.2442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Mp3wnOYGP8+PjfohlNh8ZEzhY1/mcN7r8Vo/DCm3rBKx8Mkc5Ywyx5g14LWTsFXR0Dj/hQuBXPRAnrGFfaJ4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9292
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To gain access to the larger encapsulating structure which has the type
tc_mqprio_qopt_offload, rename just the "qopt" field as "qopt".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v1->v4: none

 drivers/net/ethernet/freescale/enetc/enetc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 2fc712b24d12..e0207b01ddd6 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2644,12 +2644,13 @@ static void enetc_reset_tc_mqprio(struct net_device *ndev)
 
 int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
+	struct tc_mqprio_qopt_offload *mqprio = type_data;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	struct tc_mqprio_qopt *mqprio = type_data;
+	struct tc_mqprio_qopt *qopt = &mqprio->qopt;
 	struct enetc_hw *hw = &priv->si->hw;
 	int num_stack_tx_queues = 0;
-	u8 num_tc = mqprio->num_tc;
 	struct enetc_bdr *tx_ring;
+	u8 num_tc = qopt->num_tc;
 	int offset, count;
 	int err, tc, q;
 
@@ -2663,8 +2664,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 		return err;
 
 	for (tc = 0; tc < num_tc; tc++) {
-		offset = mqprio->offset[tc];
-		count = mqprio->count[tc];
+		offset = qopt->offset[tc];
+		count = qopt->count[tc];
 		num_stack_tx_queues += count;
 
 		err = netdev_set_tc_queue(ndev, tc, count, offset);
-- 
2.34.1

