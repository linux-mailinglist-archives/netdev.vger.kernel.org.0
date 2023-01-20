Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0133C6756CE
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjATOSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjATOSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:18:18 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2068.outbound.protection.outlook.com [40.107.22.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3503597
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:17:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwUeE1GGokGvJ5nQkhzA6l/jO+Gd9mhZm93mePFx8AzITjL5Ok/AVVfQxKWoZ3wuEIUqBwJcFkbRjaYhxvggArWh3Ip0meqpcZlqCLtRUcOHgRH1OCzGbXr17csgCrbUvyum6PlX1H++RmFn4J5e8NWtOjqtHpXTKBry+PyDgqf3vpqEDvF+9qMmgorYkOxRym7khAtX0itDkIRNXXUhOiB2yai9WNkqs0vO4rrP5LAHkEB6h7eUPyva2z+Bt0WeCJIjpWr2CNxzNkTENEd9rQ2fBTRwr7tPAnIZVoh9S2Qj6T1LTYkGpH/WIlkJ/jo9SBSDG8sqet2fwH37ngldSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xghNXqCBJ+JT09Jo8lv06PIFrar7iSlLrgDlvMmJBHA=;
 b=innfEl+4oa/tOzEDNCYTIuaXOzIpg2SVLDZV7Wd7wsBlDMnx1B/Vlph/oD0TciZ4R5Jtvvq1l0EfCntv4C3YK/DKQ8IcP7Y2UDEW/ASJpzJ4mMaDAxnbT0vyk4Tzr+xXHbQ/IEItN+8mGSr+tggKgFN4JdNhQbVsGCjrsJg4FBXuE32HCviq8BIxYM1/wO8Y73sB4R6yBolyKo1IHbDf2UYPWLAG9LXz3KCGTIHOJNrvTpOM8z/iW9TLTxkyvwmmcfqgS251NPUr5gj8diNEQ49jh+ipvYiLSWkGnJYnI9GtAvxE5KRipW3C8K/rguX+2Azj5yv1Owfhox1gQZVcFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xghNXqCBJ+JT09Jo8lv06PIFrar7iSlLrgDlvMmJBHA=;
 b=h56Bp/II/ms8/LNpmNoOoswv0sqjtmxfgAqRm/9nuvk2suaKotH5by/D3SnGaEJDkqtgGST54Z/FoB3kx4DbyumCmQPwZrhPfr1hkxQQey62E39IJPXUBCgwfoL6XPn4xVStlA+dacRCA4R412ZhRFmxH7f7QhrTaCdRTBEV4Cs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8085.eurprd04.prod.outlook.com (2603:10a6:20b:3f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 14:15:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:15:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 05/11] net/sched: mqprio: add extack messages for queue count validation
Date:   Fri, 20 Jan 2023 16:15:31 +0200
Message-Id: <20230120141537.1350744-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8085:EE_
X-MS-Office365-Filtering-Correlation-Id: e0276c53-c451-4307-abe4-08dafaf0d91e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t5khCkV7kz5PD+8xYUAuJKGEuRhZTlhPWx/FXROaBVp2nfBjeiQrJj/q5Y0kzD3faTE1+BCFG9t3Ifus0MjQvIJIV2xLQWy4uZO1jLnxL+o6kk3vBovHPwmbqRfF5g8HWimN2JbdVT8JJekJEqxw0EVXqkOATE8SIp7ImgqRiZatzmN6Mp8rQF4R9vdMU9qvYPukPfg6ISBkMimIZx4GqdgvQzro1U5Aw7N6MFVlMIXtDHRmMni1MQgJ5gnb6irlTvxw58sr/UR2hXcDBRSNi8HTn2IS9gwd09SdwOLw5+CNJQ4+8MlOxaUlQTlw9KS6uVYUXaqXixqEYOBs3T328gtjB6DBLMjdcqa+qJswmD7i6pUbIPfR3UoTZdWGfUlxeHGS54DQPDSCHnoqTqNoA1MBHwP4dsJvw9njazXPBqGQqTWTblseFtsCispocTflYNOUVgWRPKSAqvJIJzBWhnfjmCEtVCI4W9dvE1LpHac/UGoJAtf1kHWL+U7DGc1X4Ilu6zwDd9plCZ0v1D6C8LQRIM4yxuryUCIkNFq4KsfcBgyFf5hroaCkw0gwsJqx1kjrefqXK4YeD8cZT48Pzm3JZW4TiwzYGdn4eXmLynN99N0WCZnDMaSEHaHYLWD+WxnM/7EF+ONQMXdADF6LY2fj/eszEilCRnv0h28Pcnu7Fl/99n4bAa0PuO0GKszs1lE1m26WkG5rpOKR4Wk3Qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199015)(52116002)(6486002)(26005)(6506007)(478600001)(66946007)(6916009)(8676002)(66476007)(4326008)(66556008)(5660300002)(6666004)(54906003)(41300700001)(38100700002)(6512007)(8936002)(186003)(38350700002)(316002)(7416002)(86362001)(1076003)(2616005)(83380400001)(2906002)(44832011)(36756003)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mzkErU9AoF+ExAvuY9Gh1O5OxBUA4ZlEJMqTOKDarxKrOpWwk6tnml3EwI7Y?=
 =?us-ascii?Q?SzqEQHgRfVeZzfNmibiLiOIZIlCkGE6JXGpTHi+j7IM+hlpnwCGSRuLb53fq?=
 =?us-ascii?Q?tLiQbr2j7moPB876Z3jHDB/5FlE5+AJg/J7ZpJqZ+cdkRjUgrMWnkv46T4kZ?=
 =?us-ascii?Q?b28od0EhleI2Cer2kYYbmvbnpp9BwQO1NGNo6F4kw90a1X/s4aUiG5C3jnLp?=
 =?us-ascii?Q?ZeDaV2zpXm1HAJEWD68KdTKhIgKxr9PjKoO1J0gsOjpMx9QVkWKDeaQFq0u5?=
 =?us-ascii?Q?3by9Hig8YRB52LIoOXUTGLplo/z2wqlPcugM2/d9uFYEptNwd8YjwmgpgnWi?=
 =?us-ascii?Q?nFWcyRKbtG3DgIGCpReGEIVHuLJMBqtIvdLPwmdn5iDt2azWtuk2tucv65QG?=
 =?us-ascii?Q?luDt0fAAivQO9/lt5oRufyVeY66YswMGZ53Gj/3FfZq29qkEDSmTXFLUTWVS?=
 =?us-ascii?Q?gvOndCkmetxZ1/IaiGCzK5Qe1eZKWEKPFtcpNMbHX3rJ5L9JZ6d30fYVIA+v?=
 =?us-ascii?Q?zoDc91sW6Bae5xcY/MI1LriUmfI3j8TWRGhEphNZDUWhZRisBB4fDOq0dTai?=
 =?us-ascii?Q?oc/J2zdl6RY3dJmmMZ79Qsom9z8DsXIya33/MAZr72lW99x54JU3USiie6Zl?=
 =?us-ascii?Q?tg0DnbATp7jUjF8txZciXFrzkfeeigZFnYwDhpNxDldy+PTPy6TUaahlmBh6?=
 =?us-ascii?Q?XQFkVtzGKcTSHhi6F1bpYEu47HM72qDDB9uRJZrUwJdXYa9i2bQMlbo5EcKQ?=
 =?us-ascii?Q?9uGMb/YVCpmpIOrnHMKR1/Nr+seyuzeShrosSwAMiUrxMC9i81VbfOv41WqB?=
 =?us-ascii?Q?EJihzqE2mhcvWt7SHRHXsHiWA4p5uYg9/j0JSrReH+VSRIiYzyfVyVkY8Lvx?=
 =?us-ascii?Q?yH48RIIqyaBkdYdOeHhkEeXSDZZ61/fy8ZdUmnzqojKHWWGwQ8mBsBb0jam5?=
 =?us-ascii?Q?Ux3rbuo44kHKspxwMes9SJ+nkmYEncBh6NFVzig9hHIwzznp20euPdNP8e9c?=
 =?us-ascii?Q?vmqvRrwU9BDMqYIS/nBHWqhKnE9Ke+w3+6Qe1iec0COqO/Yy4PfQE8HIBzGj?=
 =?us-ascii?Q?U38wy1574sXbekQ7+CItETGCTJJBvEoILQxgci1ZsfV+JOmxxJN69/QMXlvX?=
 =?us-ascii?Q?CBNMp4cG9DlJdDkfcAcCa0QP+FySkdUDRZGFONDR/4Y1MyVASDwAg101FOVT?=
 =?us-ascii?Q?Dc/akZHDV+yJSCvulKZRMzkYMWKn4C6D3KmoQXRpIZJUL/x+Mmh48ow4BrkD?=
 =?us-ascii?Q?iCeZraSrb2epwKf2AtggLyMRLwFi9+qDEIM+sgPVrb3lKb3siwtxtfhjWKR+?=
 =?us-ascii?Q?rLP/5F2oXHWl7ihw/fJRPe6LEGwhBcMN+gyihtkJkoEJL5oT6BhXrrDk+cZz?=
 =?us-ascii?Q?s/ONT24T/j+r2GMlpuoFn5Cc6oVouWKTpPdSXccAnDhSXFAUcTjdaICLgFgl?=
 =?us-ascii?Q?LOBFpFsfcctazfh5PSrVHHVENsP4bR3hYowiZMRKXQoWI78LiIy5XQn2Nh7c?=
 =?us-ascii?Q?KvTzPE+/mDkE0z/lDkL2KwgkfiKDBLYs+CPFe2nl6IhgLbhtEKKWFJ00HxzW?=
 =?us-ascii?Q?AddkwmpOcxYdBvTiGui3ybXbfXV/XWQz5r18rcQBGnFbmtflg7VYeKVUfUsn?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0276c53-c451-4307-abe4-08dafaf0d91e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:15:56.9826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZy/aXLpdsY8Dh49Wi2iDyA2DrS2E5wqxDYDW0ixgDzaJjgKJf38so7W/XEi97U/8+QYWkxCjdgoW91BW1dGGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make mqprio more user-friendly, create netlink extended ack messages
which say exactly what is wrong about the queue counts. This uses the
new support for printf-formatted extack messages.

Example:

$ tc qdisc add dev eno0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 3@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 1
Error: sch_mqprio: Queues 1:1 for TC 1 overlap with last TX queue 3 for TC 0.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_mqprio.c | 40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 5fdceab82ea1..4cd6d47cc7a1 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -28,25 +28,42 @@ struct mqprio_sched {
 };
 
 static int mqprio_validate_queue_counts(struct net_device *dev,
-					const struct tc_mqprio_qopt *qopt)
+					const struct tc_mqprio_qopt *qopt,
+					struct netlink_ext_ack *extack)
 {
 	int i, j;
 
 	for (i = 0; i < qopt->num_tc; i++) {
 		unsigned int last = qopt->offset[i] + qopt->count[i];
 
+		if (!qopt->count[i]) {
+			NL_SET_ERR_MSG_FMT_MOD(extack, "No queues for TC %d",
+					       i);
+			return -EINVAL;
+		}
+
 		/* Verify the queue count is in tx range being equal to the
 		 * real_num_tx_queues indicates the last queue is in use.
 		 */
 		if (qopt->offset[i] >= dev->real_num_tx_queues ||
-		    !qopt->count[i] ||
-		    last > dev->real_num_tx_queues)
+		    last > dev->real_num_tx_queues) {
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "Queues %d:%d for TC %d exceed the %d TX queues available",
+					       qopt->count[i], qopt->offset[i],
+					       i, dev->real_num_tx_queues);
 			return -EINVAL;
+		}
 
 		/* Verify that the offset and counts do not overlap */
 		for (j = i + 1; j < qopt->num_tc; j++) {
-			if (last > qopt->offset[j])
+			if (last > qopt->offset[j]) {
+				NL_SET_ERR_MSG_FMT_MOD(extack,
+						       "Queues %d:%d for TC %d overlap with last TX queue %d for TC %d",
+						       qopt->count[j],
+						       qopt->offset[j],
+						       j, last, i);
 				return -EINVAL;
+			}
 		}
 	}
 
@@ -54,7 +71,8 @@ static int mqprio_validate_queue_counts(struct net_device *dev,
 }
 
 static int mqprio_enable_offload(struct Qdisc *sch,
-				 const struct tc_mqprio_qopt *qopt)
+				 const struct tc_mqprio_qopt *qopt,
+				 struct netlink_ext_ack *extack)
 {
 	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
 	struct mqprio_sched *priv = qdisc_priv(sch);
@@ -66,7 +84,7 @@ static int mqprio_enable_offload(struct Qdisc *sch,
 				 &caps, sizeof(caps));
 
 	if (caps.validate_queue_counts) {
-		err = mqprio_validate_queue_counts(dev, qopt);
+		err = mqprio_validate_queue_counts(dev, qopt, extack);
 		if (err)
 			return err;
 	}
@@ -138,7 +156,9 @@ static void mqprio_destroy(struct Qdisc *sch)
 		netdev_set_num_tc(dev, 0);
 }
 
-static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
+static int mqprio_parse_opt(struct net_device *dev,
+			    struct tc_mqprio_qopt *qopt,
+			    struct netlink_ext_ack *extack)
 {
 	int i;
 
@@ -167,7 +187,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 	if (qopt->hw)
 		return dev->netdev_ops->ndo_setup_tc ? 0 : -EINVAL;
 
-	return mqprio_validate_queue_counts(dev, qopt);
+	return mqprio_validate_queue_counts(dev, qopt, extack);
 }
 
 static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
@@ -280,7 +300,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 		return -EINVAL;
 
 	qopt = nla_data(opt);
-	if (mqprio_parse_opt(dev, qopt))
+	if (mqprio_parse_opt(dev, qopt, extack))
 		return -EINVAL;
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
@@ -314,7 +334,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	 * supplied and verified mapping
 	 */
 	if (qopt->hw) {
-		err = mqprio_enable_offload(sch, qopt);
+		err = mqprio_enable_offload(sch, qopt, extack);
 		if (err)
 			return err;
 	} else {
-- 
2.34.1

