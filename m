Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05B068AA62
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbjBDNxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjBDNxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:52 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2077.outbound.protection.outlook.com [40.107.20.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F471E1F5
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UuV84bHMbigvRd8ecCBPdr5d7oKQuzA3egoyb0i80X+/ft+Vzbm9Qwsih8KRdQV3pG50MsXejAjJqPotedBa9a3aq8MyobVadyyn94XhYgdbINolf61CPIMt4EE15EfrErcaZeOMqb1Ll6lOwG5otsFzvU9F19ju18Qj7YWDsS5PoxnYMWk798qT2zcaccD1vDyFPeFuki00JLs5VykApON5N4i0P+ZoB3aeSfRDPm6MdxKatlevJtEW8mUR/RIwVAAeNXaYeiKZZxNfrl/DywLV/dG0z0Y85N+XVTT92E625oNftca+ttf9fidQ0FqwmE7KQ1aTBbBNSaeXiQNOJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rMm7sYJETPfWxdLE+G4Xt/rlOvNc7yxfyGcTKQRjSc=;
 b=fxx/CZC9YfOUSGbm1yAEoR0rSIWqNVWjRNFrUq26DOYW2xk7+iDegFdT1lmOb4ACJg1Z+KvMotC+X0q4xWSWEIPaNjNQveTo4Zr/FsaTFh7vCd7UytCDodlBY3e4SxyZSe8KOsCyfppwRQci0NdEgKmhRQx7mqTnsANilBYNAlF2QZRW7eXSsuF0mCBwDAFWB1rNqnBUQIM64awbaBGAd2JnEjWjGOHtKpop4Ta0BtRZAKserHDa3wKdWVa3Hbh7R3DY2//ql2hogNbKCRX9GCHvpiUyYzFhH5AcaSv4S8z2laGpP+nvqyCJ6n8/VydjIDLMHdeCN9Q3N7VH4vdAww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rMm7sYJETPfWxdLE+G4Xt/rlOvNc7yxfyGcTKQRjSc=;
 b=BlUEPgpyfZLO+c/OCTqxo3n5DedLKC4VVlnP4FFWFh620DlKG6yiGyrTFlWzyksYFx2YYmpju7pYrbYf+FFWir8A5QJ/IY0rJlZht1eAmxbOvbDI83CU5MDUh+JdxOg2mYibPIb9jhS8qEb/WpR9feSPfhC+v8WIOuwEc28OnWM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8783.eurprd04.prod.outlook.com (2603:10a6:102:20e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:33 +0000
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
Subject: [PATCH v6 net-next 06/13] net/sched: mqprio: add extack messages for queue count validation
Date:   Sat,  4 Feb 2023 15:53:00 +0200
Message-Id: <20230204135307.1036988-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0141.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8783:EE_
X-MS-Office365-Filtering-Correlation-Id: 6662dbf0-e4e8-4da2-ee06-08db06b73454
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MP0LAnTaJB8sRVTpxy5+bkkLWz3b9WzDvDoP2k14KPPk+VKD35oEPctMy8QuhStZ/Gc4NEllNJiaL2kUdlwV1F0QcvFUmBRihtxyHTmNr3W4xmBiyb5NgxBIsh8WQakKuKn6cavZ3XEl6GDAKSYjxfloyLKeS6L0MvS2P3k8n90mQw6VUSJnjlWt0/3hc43mZajq2F47IOw8TcYSGvdcrDQ1Ux2DaNJgHXSElvd74KBhQDoaiBogbq50B8jsdDwue2j6ccVYoYPtKtf3NBoDKkLYVR9uj6uE21K85Nj7E6TgYevKRQzCQmXP2ZYsd7ht7RKMVpFfYsTAFuG2YO5ZnfYu+QAZgQQSAdddKKlF2wJ4lAtt8Wf54d5eXcycvabo+pgii2zZEP+gzUJezl7s7OYl27CuZw3nA6p1jO8UeJivqzI/y9HeSoAFxMxxh3L90KlkSnEUb00YcBes8Mp98QP3Everayjum7WNRYipAmbxPtJUCY1s8uTktoJFpRbJoWBIu54j+TmAxZhAqzI69KemNYeknErfwapSQndYDBnJ9aOjC6hv8vO9wqyJ5ZD9gF7CkM/ygZZVPh6+H9lwcWEVnTZuJs17rvevIZI+wG/agR2C2P7TeH6l4Y39L9+vVbf/IxozYpH+fkMLWKeDhUCNQQVg7Hy5T9L4iRaoscS94JWtciGd45H+WTd4CTGGLo1R8ySCCKORRy82Og0QZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(366004)(451199018)(478600001)(6486002)(2906002)(52116002)(26005)(6512007)(186003)(66476007)(66946007)(6666004)(6506007)(1076003)(41300700001)(8676002)(8936002)(6916009)(66556008)(4326008)(44832011)(15650500001)(7416002)(316002)(5660300002)(54906003)(38100700002)(38350700002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?klpPZmu9XDc6EBD5qMbW+7/4eTJBtgBYsdvvNpGt6l/OlyvS7i+pPxRV6BzK?=
 =?us-ascii?Q?6JR6Oxlza0pjB+3u5RSuyvPO7RgrSsicl5zY9mdGV4ktVDk+valiyZNvTilZ?=
 =?us-ascii?Q?Bm2yqaYiWIoSS5EeYk81otosp+F8gJ9pOvKH+QfmPdADTiviu9uTRKxwoBCN?=
 =?us-ascii?Q?a5fAdK8RqlsCDBLH20U8VjOMW0Uam41EAsPWrJhvxOD55FcpUhDNt7v/18LU?=
 =?us-ascii?Q?6tIBtz1fxNJGR88o4cL7gQnEiy+eWT/WnDCFKoO0WHLLWr/8rA+mLjLEL6YJ?=
 =?us-ascii?Q?Pw+FPcnkIdQ3FwultLaqgBQTY4RyGcM/9wrNkvukQn+SM7VReTC2RQSZsw6R?=
 =?us-ascii?Q?fNebTFOx9IRLPquo67g0UF+2lOs9rqrXDdqUMPnWWmz3WGp6Nu4QDVFRMfez?=
 =?us-ascii?Q?yXNyuK5sPt0NSv2notPdA3EWNRMIuJGh62A1A4/v4uqZx2bxPW+z6QqdVGrt?=
 =?us-ascii?Q?XPQ4AdMKdr8OZE0vXgegdbvPzP2mPr8d+5yup06ZcDOR9apapjZceq4wx/lh?=
 =?us-ascii?Q?a+ZD7OPDTvl8s8xEJcxQkeZH/aOW+/U+CivJ2y/13+pgTJU0ZLR493CE9yjD?=
 =?us-ascii?Q?WMt+/qYJTqtqtKsY3Jt2woHNnzvwXUglxTDx4aWnjf7xH5ZgJFX1GedQ/mAF?=
 =?us-ascii?Q?w9nsupo5lAPUVTRG0i49Ge8unxDOXGxj3WmPnTWHp4UIF/Baz3ZWxcq5fIEN?=
 =?us-ascii?Q?xiVNsnCwmyZpyvKm0cHMLnqkMhr0cOBvyLkj+suams0t9pBdZympwTVye4oJ?=
 =?us-ascii?Q?okCVGeGMmqHcH+P1d1275Yu6HbT8TAHydnpnokcABODV7gP3eRPjrsUG9/sc?=
 =?us-ascii?Q?7Y0nXgLS1CIw7hLXK7ExtW+YG5ISGn7SWK0x8IywQl5pPjZCT0XcLcbcdm7b?=
 =?us-ascii?Q?7bzoPkngIq1JziTYExCI14qgKn/HB3855dYisrOWOS6OWW5V7THNDegZRkUr?=
 =?us-ascii?Q?225rcXpPLa2XAtqfwFUoeS7w3sQ2fWpcFE2QsJm8KgT57Wl6+DvgFHsOd5at?=
 =?us-ascii?Q?ld8xdnu8qLP+1EakzJ/mnscr5YxT8Bchr2RZFYk++P1mVmDDzMzkp0/nBMyf?=
 =?us-ascii?Q?zpZ/CgKPqQjPJ8MaLaSlReiMckYNQwPkA6pyDfQtt2/aRUjOR79iAksnmXdR?=
 =?us-ascii?Q?kPbsCpNuVxBXb9hz5etFmiyLATynPQbLfcgSi8DuhjXPuuR/mczcxQFhTJ4q?=
 =?us-ascii?Q?j+ZqZlnwD4KkH/Ha7qJrbAFwBvnS334N2Rs2D6b3uRkyCcuEgfpXgOXLVyx5?=
 =?us-ascii?Q?AEnq6pAHCX3rrTXOsCnibA3edYT+oXz4qqPNWwBpevsguflyQw8NRtfld8TI?=
 =?us-ascii?Q?p0GEEhYhrhS02JfY1H6Oh+41Le+2sJaIX5twt3p30GWKamWts+vQrK/sNTRL?=
 =?us-ascii?Q?32V+CwRpjfQRxCjNMjKlllfRHldELavbJ+oIHNutm9IdoimUHL9p62JTwkPE?=
 =?us-ascii?Q?DhPmmEL+OJ6/it2fUnGb9e0dDUoAaNaO6nGO1QaNmNVbhk4xvV1wHrjZf5yW?=
 =?us-ascii?Q?g4WYaSTwput85YHBXY92jBH2laQEJLvZwxybweEpjlKefezpV4Hsx9h5BgIJ?=
 =?us-ascii?Q?C1CroYGcTFKg/At2vS8L3C7E99WVjB7lGEUkRpezjDaF1BjaG1o16Dql6KZU?=
 =?us-ascii?Q?Zw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6662dbf0-e4e8-4da2-ee06-08db06b73454
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:33.3413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sIVuYmp2Iorj0/vI3b5VJZJmcROvyAy9WhkNsCUBoAMc/7sKvocnFseYfsIMJKM4XgiVPyTHAEwwQPJgt5etvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8783
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
v5->v6: none
v4->v5: change extack message to say full TXQ range of TC i
v1->v4: none

 net/sched/sch_mqprio.c | 36 +++++++++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 0f04b17588ca..d2a2dc068408 100644
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
 
@@ -168,7 +186,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 	 * - request queue count validation here (and apply them)
 	 */
 	if (!qopt->hw || caps->validate_queue_counts) {
-		err = mqprio_validate_queue_counts(dev, qopt);
+		err = mqprio_validate_queue_counts(dev, qopt, extack);
 		if (err)
 			return err;
 	}
@@ -296,7 +314,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 				 &caps, sizeof(caps));
 
 	qopt = nla_data(opt);
-	if (mqprio_parse_opt(dev, qopt, &caps))
+	if (mqprio_parse_opt(dev, qopt, &caps, extack))
 		return -EINVAL;
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
@@ -330,7 +348,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
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

