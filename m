Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D986817AA
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbjA3Rcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237870AbjA3Rcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:32:39 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2078.outbound.protection.outlook.com [40.107.13.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D60436097
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 09:32:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNuITCaDIXu7aRB1fu8RzCSugbsfa6w7g2fVhDZuuqrZA/uG1yleY677rnPsMNmuBHitov3bS1OpxwrA0xD9ZdfqMPn4jEtLvrM3xQYA24tpb5NynCnDNjhoaR1x/a6XpI0eCQikg3Ap/cZSeKbHIVtgPtvsMrR9JqtnFogAwi2yzxKPD49x6+5HmalPXvk+tSreeTMHBWWYo6GGvC4FjrZiP/Qsf2j9iZ5BU1WyW7svJ8vWRxsSeQ5UIu7vHJtu29VE5yE5u0ZG6ZzI5fVnEA4gDNMinMwytdEd5+UJbUKgH2WFXLdyVNZVXaoWb2hQ3q7YrekLqlUjWfg8CRR7wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fSXP153aXCWatm3T/U9oLDAjW5ujBvjqVyz9wCgT8Co=;
 b=jA66RV1rCDogOy+WLN/wJeEk1KalN8S0k2jxu5kPkmpBXystCrAGGV97Ryv4+ya2e+7TVkwZy/TElbhjuFGT8aok7jBI9KjTbw0HTQ2P6o+3QD3BUzjtv3jScL2fVO23j6Er5tDd3cfgNwNpg0585b+jxxNnEKLQdoMhXIrudyIFHF8stUUNgq0kkuwOlXD2X+DFyvEib7vDRDlDewNjIRjtZpfLCYTfJh/ZegQSaO6cdXyS77/mej/E3Xg/wwfZOCR1u16pY/VQ47z6xU2bw2tIXwF5SJzHsDTbgvg6DL8Jbu707I40ZbDxJBJ7ndCQglIxOD8AvquRORuBZPxy3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fSXP153aXCWatm3T/U9oLDAjW5ujBvjqVyz9wCgT8Co=;
 b=LpV8HLDQ0wemuBPtOg70s5CZRRm7PvFp6tDXubPsa/TRFPwUCqpcUp9DLbp2LwNsIipO+KWyvML6X2hAJxxGOE8Fustk2k/KzjKP82StVd8g65SBWdm9/eW55o5DLWoeFjBJB9kRcihnheawKAJsFHtpQNRATKk0OTrBCOdq6Oc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by PA4PR04MB7677.eurprd04.prod.outlook.com (2603:10a6:102:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 17:32:19 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4c1:95d7:30fc:d730%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 17:32:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v4 net-next 09/15] net/sched: mqprio: add extack messages for queue count validation
Date:   Mon, 30 Jan 2023 19:31:39 +0200
Message-Id: <20230130173145.475943-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173145.475943-1-vladimir.oltean@nxp.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::10) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|PA4PR04MB7677:EE_
X-MS-Office365-Filtering-Correlation-Id: ea10ad15-d730-487d-034d-08db02e7efff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0V47nG2HuPGxbrfoKv6FwdzM375WNcaKoW+R6aCTUnpcYOUImMJjbFgisUqW+kejduKRHSrf4K38XOraLyNo9/WXSILT+tQwN9iecsvmhIUIvZAXHbO3Hi0dDUeRKb79ZeA1EU2MHcZ6cm8VbVGQhNx5mLI65OfqSGFNVow4sUXxHlkNPmLcdLZ7spMLZNosMC7reBXDFIQFa7/y/f8WgiPDdbrp8dPZ4ceFbYdLoj5ZQ4dzkfXvX3tgPKheeUhwxrFgsaS7IBVdnTSlHOuLfML+ofYXfQZBl8nnODhT/8jBBBecChXoLZ5y0CXH+CkGuqy+PP12sd+BgUIOTbnLdQre54oH98qkw/1KSLzicEEk7+DK9MrQv9DsRYCU0WKyuXYcePXK7v8/fkDLYE97c2hzw1Ihpu3P/dbeGAaRIxr8SFpXanyScHHqk0QLbtXMCGhxeewD460FXFGupbxOA4oPVS0aMazapVk5gtvGeT3dlikIxZFfiwGipRzJ1eERyLNV8K+x79VjoyZE2LCOLiHmki3eHDenBhdVjjQ+h448iYjf7RwptwpHOTvWB+2jNgQze36d8nBHImJtHz+Pz6FpfTgN7T6aAnNZQEGHE3VIojuc7nslDK6WVa3c1/8wBJV1Cs57E5cE3iCiAbnhyUvUQ3Y5JPS5KqQRPSqxUznIBqYLiEN2dALCDkMmfbsgcUXKHv6w3wO8CowdXiSYHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199018)(2906002)(15650500001)(5660300002)(86362001)(44832011)(7416002)(83380400001)(8936002)(41300700001)(36756003)(478600001)(6486002)(1076003)(26005)(6512007)(6666004)(186003)(52116002)(6506007)(2616005)(54906003)(4326008)(66476007)(38100700002)(66946007)(8676002)(66556008)(6916009)(316002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M8ubAPPGPvp/CcNZHMlc+aloEWGLkfu6ZDJ81aouHL10TQSJuxLIa8tcPmvU?=
 =?us-ascii?Q?a8xFDFPvIGTWQEdYzVa2JOFcpro8IYpWN56U05SQPdF9VVonYCIG4chQIlg9?=
 =?us-ascii?Q?+Tm662yjAsxGwEIWG4uYIRU52VexTiGThXkeLk5WI/YOzftoftk/GLF+dUvg?=
 =?us-ascii?Q?Uds3SnPkH/sX2fEG2J299YmvckWETwvpEe2QaERUf3p29Mhsflg69z+Wyj6C?=
 =?us-ascii?Q?r+v1oD1xXOptuCwr88vrSbcKn5Y2O06gXZG259kP4CpxdRlGUQlf9b9JhYA2?=
 =?us-ascii?Q?VfnqvxwVDemLPdfmaT4D8nOvuNvPxJGf/kLssb7TWswMIxs+6HvzU6nGULaD?=
 =?us-ascii?Q?vjIxYL/FhyTsykYLACt+pi2V1+nTxtlPqtnuqcCu5+3VczLr50Zcl0u51Fnv?=
 =?us-ascii?Q?lmmRfkjM8dhJAt1Hr9vs1pc6KVsq00i/fsmXKi3+PB2jMtENTUhz9MmN0mFf?=
 =?us-ascii?Q?r2G4jj0RR0tdbNgUBE8NM1iDAdEOw9C2zSeE91cczTbobyEiv1f4plJOTk4U?=
 =?us-ascii?Q?Pg4mg9wySPEcT/B42x1Ixxr6EKXfOFCHQ09UU/IalOcEZfw/48it3CLRNaQv?=
 =?us-ascii?Q?xslI//9V6zRh7lu+lpLqz92I8i4Zw7T0k+UgZO1zHtE6Vm69ewkVgb9unonh?=
 =?us-ascii?Q?Jri4WTlJh3EqzJJ2EZy3KSfZHpiPvFdw/yySqaU9xDkjIWWx/RHvRbjfxiFW?=
 =?us-ascii?Q?nvFvHNVnqv9+tXyNYhcLo41q9LaJq3sRpCrPsIUP+QEnyZnpmG0PXGaREYGg?=
 =?us-ascii?Q?wxPrHIIoLYcLYoPZADwY1RX+1mQGGsay3FGlsm7PDJYsvwclfNmaRPCmrMSI?=
 =?us-ascii?Q?dYrMYBfLqeCwu5kPKMvW7GJ7Er38xH5ypwCZ6kiX5O92aDJHcPg1ETsKHF/h?=
 =?us-ascii?Q?5aQ61LeQSENdXiPRSUzeT+0MDvL/7hysA9h/Ps3stCrHUrJAceS71ugO1uXq?=
 =?us-ascii?Q?QomXLAVjSq0kOjVRvpntD6GlptYcZMD0fQ4nEbEG8Xj3jFhhs3TjKJhaX1SB?=
 =?us-ascii?Q?XFt6VHLJSzwnRy9LEILo+59j1A2Nz87OniAZaRoHwjdEZ6QW8cwd4h6xD+iS?=
 =?us-ascii?Q?U/JID6frpSCt5TkRMvf2/++qh0nYo5AUXsqnjYjBOfysgHraqrLBgnSHZbx6?=
 =?us-ascii?Q?nsmMs183dqGL0h86n3RmnK1Dd5GaP6vnCzKKrdhNClySpbGn4bdgUQmjGBlt?=
 =?us-ascii?Q?SlsJS74KHh0JYPCQWBqtD1UD0wMtnBS0WfImWLmc1Yj/RXNIpAu8MblrMULB?=
 =?us-ascii?Q?G7weSGza1b3R+3MmucftbJUIOq+sEycBsp6ZqfofVc0TVeeyo2HLbky4lcpx?=
 =?us-ascii?Q?Rs9M5dpZJZeIQxnuq86LQE/4maUQu6u+M34s8JskCjKrYGLkjhoqI4nq49SF?=
 =?us-ascii?Q?ilMIQnEqexyhj0IKjy8b2toi27+iNl2Re6jJRUewW4U4InFqcioBjXan3sMQ?=
 =?us-ascii?Q?ucb09uT/E5sZCQzPWVWzMfzY/YWJRPSu8r7P1onQMfIW84UEC6Lv1YxMFhyt?=
 =?us-ascii?Q?brcNtnQU2ZFVdjQOT+/Dm/loiPGuFRuyzEuHy4J3JUd855H4jsjRUPqaSTNq?=
 =?us-ascii?Q?TRtd9ODQc7CBGfnWBKKRhT7LozDid+avn/N8LtirUQsRd46JnFAhOX4IOH5j?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea10ad15-d730-487d-034d-08db02e7efff
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 17:32:19.2100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: krod6hAbmXaypFkH4WtEdi8VQX94nlOc14ZZA/r3zCIdl77V0GK5mlBEqOSPGVObb0bFAY9BEXSd3jVTv2V2xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7677
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
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v4: none

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

