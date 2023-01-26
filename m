Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E82667CB59
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbjAZMyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236296AbjAZMyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:03 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2065.outbound.protection.outlook.com [40.107.241.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7836D36B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyGrXvxqvFO114gAns7FnCQwYZ14h+A6txTZztVHyinvQwgfEIuOTWU+eb7zfnMRht5xVF+Q7kYTRg1ASY+sYqB9vElK3qZAkaFjumkIJvRIHuvdZwfZmYxIGvQaWJdkjjYqeel8JpzGxPGsrLLb2ezCIOt9MA8WvavGDA/hSH9KkevCUVXcinU+ZE0CljkDDTsRdA+nbYeS7MBr/h8YCohC2tmF37Os1VBvDrQEqMoFk2XDjhyAlv5/j+bxjMTHHHGo8D2Y9wU9ejRYz7GZSRYkjrRtFQAc9fwjzdBnPHrE46QcP6EJ/V+yQhGgViayy2zX3srPBchg+Ky1hp6BAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WqJFpdauAggbde/esspydLQtxDSOPkAHJiQdzxGaQH8=;
 b=TVfUbNzEQIuq/B80qJUOOEOZbedVRijf+kcHmM0kCvtRX1VYxi8kONG0NPo2CqOsY3N605/UG+rsi2IoDKOsqaHs5ZROq4+xOU+4qaplusJF4zvew3vVDsJS7xk+0eox/WMkGpDP8agicPjgY7jCK9+UoKYgii1XE1K244zfZRLdfQ6bTSMelcxBPVkMJAIIipMSRcgyOU3fJy1jjka0byqojEPvtkTkQQubgRLeiZKcew5YxSOvRaEEjI1ANYYXvkTtc46Ku+1UqIWdnJUSbm3LIwGkhWqGglnrohRBjBRXve/2EZldMawK/bsr44WzhqA5fcLiw4BxBX78kh80xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqJFpdauAggbde/esspydLQtxDSOPkAHJiQdzxGaQH8=;
 b=OHB1h2F9MxaCZ9oRFnedKbJTjU6yz2QmQ/93qzYUoTPDNr/Ghy4bFs2Es3r66AbnbtXIfV/yu7Att9yopM3x8jJRWg94McGBAW0gl0VM0bQV1FeFX3ZSfJB7zpvXYTHXtp6I2WDb86pslLLU5mZeAoBpNZwmq7Dtv73ONH8y020=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7795.eurprd04.prod.outlook.com (2603:10a6:20b:24f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Thu, 26 Jan
 2023 12:53:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Thu, 26 Jan 2023
 12:53:45 +0000
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
Subject: [PATCH v2 net-next 09/15] net/sched: mqprio: add extack messages for queue count validation
Date:   Thu, 26 Jan 2023 14:53:02 +0200
Message-Id: <20230126125308.1199404-10-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 263bef5b-1509-48cd-ea7c-08daff9c5b54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ISmPaoIGGtBUCF0k89+sMCtRbi7Ifs7TdHmbVqhbU+tLZIAR1EfZpzTusFVZXUUAoTUlq4HKAluWzq3zu4ru1slro+YpD38HS5HFyCmOKHJmuKMDOLBX02qq4jLD9GqKaCO8pZXsKiKrRk6GZHMyDGKcXv6SKfIuwws01HS+NY8/WtJyYH/B6t70u3FvSVoEiSk+N1NzPG57Y6XUWc7kdQ20rUuc8fpNRWnYnK0E3ao1rAAtc6Fimyoe4MPDlcHtvDMfLbnlnkb0XjRRUZOzSPJriW7GUOiBet3PoocYyMnQUDRL8R50lW0hINM0qn6w4c+0AVxL3MyKiS/vnmgNpg9ew+ONEs7aPql+v3SAi9KI65jr+sLxbMmBD1FbVd9BMBOomhr6GRJV0wbJtje1dNuPld5SNySBImzfrilyEcAFGlF6q14X3/ZuJp1yUgEOR8NtwnCAxXLp0Th68JOj0Xw099CGIdsq/CdlBb2RnYT9Z52Nn1uEmwNzTiBzv7EY/uXnlWBcLh52IDfTbnYNaNln6eXKHA1FywocDd+UPP1Cdemy5JLR90AHK6fbbIP45VhiLDgx7rNVqawnb+m3TO+orwy4ywZA5tjxmawUjcaY3hmER9MYMSp2ltn8NGlDq3dV1Qoo1I9PUhVBkaQaJ6liiN33n21N3TGDWxeLs6I0cIdzu3UCWcDlZS84IvC4014I1ErY7G81vyunNsAyRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199018)(478600001)(6666004)(1076003)(66556008)(6486002)(26005)(6512007)(316002)(54906003)(66946007)(52116002)(4326008)(66476007)(8676002)(41300700001)(6916009)(2616005)(83380400001)(5660300002)(8936002)(6506007)(44832011)(2906002)(15650500001)(186003)(86362001)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QOpL9RHJiV95cXVY1BGAiHF33XAiIwmgr3YIy2H1TbqBtLCUoJG7I3QD3wc7?=
 =?us-ascii?Q?ieFAdomRZPG13jWUGypIxke2BEvhG3DShkRJU4w+DZB3YAM5ml4Fxt10E3EP?=
 =?us-ascii?Q?7rbgh7KdKbRNat1lr87XGOcWMw5Dqn+CIVcLRtN4DrZRy8s4BYBXN0bBH/SN?=
 =?us-ascii?Q?SDjvl0REAdauf43m/CzkACBKK7mqrCXjKRbqXwUZHAt9EHK5w0z4TGRMs5ir?=
 =?us-ascii?Q?GSMDBdpORQu6SjpJfB+pcHdSOB1Ed/PjtUPtyJhQgfid5gdVFgJy7p5jj/ip?=
 =?us-ascii?Q?u7Cnrrkhc5wwVMOCCAkrUYR1lOUXYqlXRNM2zIaBsM0HvDcpXrjnfNARG/TC?=
 =?us-ascii?Q?ah8/Sat9MGBmPZLFeW+qVHoQQj/i5zjwwANvfGeVYoewyVfHFE9Eexiq//K/?=
 =?us-ascii?Q?G6KaKePBdFIzO4/XIJ/ai+dNYRFhaDZlDJaRUtSYXoPYx5RvZD7WoDHAZgfa?=
 =?us-ascii?Q?lsjMs7e3vil8By427EL4s//yb1ptTWTOisdptiB5IOWoLtWHbJlqe3eUm4vw?=
 =?us-ascii?Q?VlcasOxZv/xvwf5uzIVM2qUP1HVihi0EAI7ISE2eEpNz6e8Q2TN1VbLQqa9s?=
 =?us-ascii?Q?vx8+cJzyI1d5omVwbXg7NHK6SXCPIshfcLMCJNSMg2SDts8Zvvjn1le5JXdT?=
 =?us-ascii?Q?CrFkHaatapZEhYUYNW5HZuQu5huVGhZo77uWzqFVa4BvJhnDnyUpN1A73IPJ?=
 =?us-ascii?Q?yrpiR853SgrYKIKcCdzY8JrrHAFPMjPsFvCn8mvawpws6hAmeIcEvDW3K8KG?=
 =?us-ascii?Q?q5m7qi0Sv5KfQ3Ts0ud0aejwp5VDi/LjQd6PIyHb4mEyU7oD4eilEyPViqfa?=
 =?us-ascii?Q?Px40sDj/6fya6bBw+IXODTicS/7loKaqvH+g/A0T1rn1t1qunSebhT/lmaon?=
 =?us-ascii?Q?eLhR9foC61/OwwEv8rntL0BLTdW8YqhH9yxmHJERmJG46otj4s3QtDznUU/d?=
 =?us-ascii?Q?f9nsZ0rNjIpyTPAkAIZBlAS2NHMqgXk2jxHfRytQSlPFCZorW8f7aF4bPAh0?=
 =?us-ascii?Q?wXmwUp9oiMaqVIOwp1Yv3HZbA4h2H12BO+ZpvOmYMNJAkbfTMXNf0K4zwdX9?=
 =?us-ascii?Q?tnggTTi6SYEZnXoMpX+0qtNeb51PdpNLxxCY9FzA65qvchszLojiD7UsJNPD?=
 =?us-ascii?Q?wam7jo1NcXzX6QA7ut/GHNYWe+KkmXQCEBYcmatkIz0CNgl8lyR7QGEcPP4a?=
 =?us-ascii?Q?PAikUJyWsW3dDQPyaLnmNyk59dIQj4GfDPW62eJSdePf/2dk41kQsqAARcbF?=
 =?us-ascii?Q?8jR5viUEDGZ2UwizgYao2dZogw4IUG7x91StNFsukzFYMkMzfuyfat8Ho/En?=
 =?us-ascii?Q?4XBvEWauCAOyXkZOC84UFRNgY2tD451sbZGFB7gxKZguak9PMsTCIF0JosSf?=
 =?us-ascii?Q?uJsCBgRwa1h6bCykweBhOU7fuHLHdIeJjOWiPcc9wAKDFE/5AD4B5/ujwi7I?=
 =?us-ascii?Q?1zcQT/KawjugF4GnuR1n7MSz0rHmzrnN9lys7/Zeu6A6dCJrZP5uO5Mrj4hR?=
 =?us-ascii?Q?uFWxSNOPMZPuP2z34MKbtN3kQKbYmCxBOxa0dxOxCclQKTXf7NIEBx6N3JBf?=
 =?us-ascii?Q?lLrBPHs5MYSs1Xu0E8NgonHhxpTApSCfD4brmC14D1KZyBWrBtpkoUo7KEAM?=
 =?us-ascii?Q?/Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 263bef5b-1509-48cd-ea7c-08daff9c5b54
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 12:53:44.0962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/zGtlcTbSgS+wMQEC57RjKH1EA84NMe0bCx+7zFDJ8uMWa1v3qadb4dRTzOadrcm8IvklQ1yDc4M8g5xILuKw==
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
v1->v2: none

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

