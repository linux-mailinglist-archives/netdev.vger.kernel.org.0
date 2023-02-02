Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2A3687265
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjBBAhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjBBAhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:37:16 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE3574C03
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:37:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mh24nRT0K3sSmJcLnCbebm67fF2/H0C0SDOM+EdfGb+39pQKx4MSkhnVRXiLhyQWFmjhyoetJ5iI3vzTo+m3aWx5J3iBM8fxtiqOPiQKFkF8NE2qztYmRTdLdqoJ9pT7vUq8sGXWwZ391k+IaokfDT3bACaZ/EKOnCU8Aj/sUG9G7v4j5Jf76QI9GS1ih827R25vuBJ40qvL1b8UKlEHAzQmJkuv3NYeuSY8XIAVoQ3tRg0icn1h6Vuuwx9GkCa6hsXRg6lDzhIU70V0SGqbIjZcI93USqiJ52JJOkdTQwH1HmhRYbDOYyIbRI304B0v7YUJhNOGlIUa/IHyapWsKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zPu9L9SMPosHKaSS66Ncqh7IFWxQBxNYCkfBsEfEV1k=;
 b=UsOsNvqP01aJICtZB/gdhGTWNb5EnxrSdpl7evSRRt1rA7eXRz8vgtaYjXrvEq8mplyqy1JJjz3I80frOzffXU+KigTCBox/qGFNjshIXAm8L8zpXAXJG5gd1tQf51cEzcmxbjmjQUTkCzIqqK/fmsZq9c/hEYxRIxMKRPFyjbjqpNj43GHRZceYIVZFb4ccKLuVLL4AycF00xFXn6+TCe5OOxfXowBSRMEH5WYMUHX7jvdXd0YrNdPu1tYRlaRKn4VYidLHgdbGnuFLpzJOiAkQv4S5x3188j9nPvSoMdQldI1OtwQonw40mnF7tp2WSfiUYGtCyhDdHEhZN1skXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPu9L9SMPosHKaSS66Ncqh7IFWxQBxNYCkfBsEfEV1k=;
 b=jy/mXn8/t0NZdxylTnCq84Da6N6MZmkCggtLA7xMYMDjUyYJwTspH21z1UzNJ+ZQckJ1nOEpd2nJ8xN5Sj8+LDV/wO0BY5i9MhRSmUVPhV1X+5aEFghVFy6bV9Jefd6IYOyu7zvSdCJ7O8wGDr9dPGkftH3h7aho6id5rAOGi2s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:57 +0000
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
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 10/17] net/sched: mqprio: add extack messages for queue count validation
Date:   Thu,  2 Feb 2023 02:36:14 +0200
Message-Id: <20230202003621.2679603-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8789:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d26e372-aa07-4ec8-d9ff-08db04b596ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B2Y12aMITHMorWv8JeogZn37tfqEPVJRnN30RbnOCcarpP/9aw06RnVcqiO3eRecEXMqhykzjJqTSBm8JP2/7KpOu+Zr+1LYw0U8xsYUcFtiKmvp05qBlCqiMZAlLna4l368KLMNGoOZy3XNuEMzX3EaRBwz5wSAx7tJJGbAy0MFPhOAnYUK807CDW5JqrqKIyymavLRAdxq+1rR1jQtOfxPcJZohJ7VrVCjNRhG0m2egroJjlkEnCxsso8J3e7YTPuW3Y/edRenUMkIA4dhZUbddrrymcs6U6DKd/QBt4F7QW8uNg8rIkCDKIGSmTJu5zooqxmMlR+OV/S9yLjxwrPLoOOcTIDf4vXx4Yly0AAJWnG5/e0O/4QXfxagbhKoredOMBpQjgMt5rRIUahJ8km23BAX1NO1i6ayDNe2fYue2WSgIW1Uqv1nuxQH2w79eoYm1jsJrZQd6ssSc3LxBGi0DIWxbr+ga2QemF4xdT8+M3w16rVJOR2tdKT0hR5g9VR6Pcnn1cNkdN69fDkHU0gT84Mq703TYN32aBZweU4xwaGv2kMNhjE6ffxf+VsMNkIGWdDgOmSJXDLtPdEbBRq1RilzamheEVjfm8HLQuJfPQ/X+mTrS3OOp8NQTZ5xlGiJ20Pom611u+AxMue6LMNZByVZC6Ftr5LCFeXEZJBFVw9ZN+OpNsfxQNbYfKvfV7vtXHK+K7ZNAKg8HlCRGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(15650500001)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Woe0h5jpnEc9lIYP9ftpULa0/aorjTI3XJfdMrayyallawTB6DcSD2rcM1ZW?=
 =?us-ascii?Q?TIpU2SM5bQWXmIPFBBmlVeQ34mnpL3NfowQgSfEPpSAwRkWsq19YGSt8bIP/?=
 =?us-ascii?Q?RzOgdu8+f37sZFEUli3OvN4uOJGC32hTh4cqpfSJ8lZCJuS3xCuh9K5gCxq4?=
 =?us-ascii?Q?q11GY4eByqWj7MoSnaEUhz9XY1BJEIJ9wiAJ8EYflIsqNTe/mFVeI9FjGurS?=
 =?us-ascii?Q?bQpyFPV1+rqIRUSr3PrUocO5m0J/Rjb9J1MqVXoTyxIMEfTF9vruK5UStcAa?=
 =?us-ascii?Q?RjmrLyZ8Wf4uiTfH6iEiHd6wmeYJ0hAyowvvqDltiqsz6z7dPb2fOSHOg2TA?=
 =?us-ascii?Q?Pzq1BEI4rDrTfUx0Qd8LATnc2Uq5Ym293UX9MDwbuEg7Eq9/QVIGXpJvgQek?=
 =?us-ascii?Q?DtqtK0X/zxxa7XdpnKPZ5Y6LbYYkTkKWcIdIYZxq/Ffya9HehjLMrCo9SDQe?=
 =?us-ascii?Q?bjRt077i3+IKf1aHyD7704IGkX41ghHrSbzwSTC8T3QO+uAJbwibxFV7Aqpi?=
 =?us-ascii?Q?Csh7QjIWMhLXGBBRaR47a3haXPD8u+qkF8/VMg+MJ8fFow3y78KWcWFUrTwv?=
 =?us-ascii?Q?zp3TjaLANwk2R7pzZv/X3jWrfcIVx8ew6gtxHMl2DFE5iAtDJwncEeGfKceP?=
 =?us-ascii?Q?p4+u6p0OhQLKE4tgRbFWmnZWzcMpGyMiUO+uOvyZrVtm0rpNa7lVU1sBpg6n?=
 =?us-ascii?Q?YyfpwzvbjTCOVbp3m8Zbaa1Cd9iGUKuMF/pjYiYXzEGtPnYeimYwQff7U+GN?=
 =?us-ascii?Q?4F6kcnw4qTlfwLDyHnmsNvo3vocMagn6upfX9r6uOnR4am12BnKPdy40qAFo?=
 =?us-ascii?Q?0iPGQnKyqlNxswMOXGUYKS3rST+K/9h3P7AZXaaIIrMsH0VfMVRwNeFXTaBl?=
 =?us-ascii?Q?b6vAgBENn5naZTadFzPU6SD7yN88u1ztZA5ZyORDnjUtGtRBDpBlF8UqTAfn?=
 =?us-ascii?Q?50dta29ycBJ+5X81lWFUf80FEpg42dQdZTGcnfjGfRbCBI/VXyf2Ay95+LSq?=
 =?us-ascii?Q?6CuCMMWHy28nJODn24aTPez3AOpi6VllMPFnw8BmaHu33ChsxWZxuv7TbwPC?=
 =?us-ascii?Q?fnMHJ1XQY489p3oyZbPQ6FjqhNsPKSylX8vxmcESJbjhS1HF54kOLZkQGSir?=
 =?us-ascii?Q?VSL1PWZXolW1E3k7qy2rn1FinvxCLNkxqeC46fS9BAy26v/fM1JJ5lnWpy3j?=
 =?us-ascii?Q?FQ4VZIsPlP7Uw2kzCxKW0zE7YAdbp62D2HWMYJavdREnEonFXCOXUcv9DBR+?=
 =?us-ascii?Q?EKIVdZyAD0fmACtWpD7BhgdM5y54r+uIn3H49tRabNmqvdmgHTN5vD0qkN5p?=
 =?us-ascii?Q?HONAROhJqsm8mO2zDItUcjrg6wPrsiDtLDVlKl12UJZ01taLvekOwcQMtA25?=
 =?us-ascii?Q?fZFKgLSP3X/LNPPrR1MWGdooZnoe66uWUKdOBvfAA2zCGI1gCxS5wSwyqNCS?=
 =?us-ascii?Q?OjVl88aGTC4Hynif+4fD2G3nNpeOr+oZy4O6P5I7ImemL9et66nSiGUdzJo2?=
 =?us-ascii?Q?NE2cyPvXg4zNjNAcQhyWcV+5B3HJovAO+VNqbSBBS9xcDs5dkT3C8y4z4rUu?=
 =?us-ascii?Q?j6/s/H5vMkmTmrIWS9jFufygDrcUGaZnOfTuwgpbvyNsv0DKM4WatKFm9zZe?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d26e372-aa07-4ec8-d9ff-08db04b596ba
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:57.1851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BkSPNCXzvZNKzh+juLTwbhBar3Se7y32t8qSJ9OY82kdNvqN214GpsfqJF8qmZcO1mhzRzyFKqOq87vFA8spQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8789
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
	map 0 1 2 3 4 5 6 7 queues 3@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
Error: sch_mqprio: TC 0 queues 3@0 overlap with TC 1 queues 1@1.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v4->v5: change extack message to say full TXQ range of TC i
v1->v4: none

 net/sched/sch_mqprio.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 466fbcb5de08..3b6832278d83 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -36,28 +36,44 @@ static bool intervals_overlap(int a, int b, int c, int d)
 }
 
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
 			if (intervals_overlap(qopt->offset[i], last,
 					      qopt->offset[j],
 					      qopt->offset[j] +
-					      qopt->count[j]))
+					      qopt->count[j])) {
+				NL_SET_ERR_MSG_FMT_MOD(extack,
+						       "TC %d queues %d@%d overlap with TC %d queues %d@%d",
+						       i, qopt->count[i], qopt->offset[i],
+						       j, qopt->count[j], qopt->offset[j]);
 				return -EINVAL;
+			}
 		}
 	}
 
@@ -65,7 +81,8 @@ static int mqprio_validate_queue_counts(struct net_device *dev,
 }
 
 static int mqprio_enable_offload(struct Qdisc *sch,
-				 const struct tc_mqprio_qopt *qopt)
+				 const struct tc_mqprio_qopt *qopt,
+				 struct netlink_ext_ack *extack)
 {
 	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
 	struct mqprio_sched *priv = qdisc_priv(sch);
@@ -140,7 +157,8 @@ static void mqprio_destroy(struct Qdisc *sch)
 }
 
 static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
-			    const struct tc_mqprio_caps *caps)
+			    const struct tc_mqprio_caps *caps,
+			    struct netlink_ext_ack *extack)
 {
 	int i, err;
 
@@ -166,7 +184,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 	 * provided queue counts (or to request validation on its behalf).
 	 */
 	if (!qopt->hw || caps->validate_queue_counts) {
-		err = mqprio_validate_queue_counts(dev, qopt);
+		err = mqprio_validate_queue_counts(dev, qopt, extack);
 		if (err)
 			return err;
 	}
@@ -294,7 +312,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 				 &caps, sizeof(caps));
 
 	qopt = nla_data(opt);
-	if (mqprio_parse_opt(dev, qopt, &caps))
+	if (mqprio_parse_opt(dev, qopt, &caps, extack))
 		return -EINVAL;
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
@@ -328,7 +346,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
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

