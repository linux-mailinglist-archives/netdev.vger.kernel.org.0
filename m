Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474F5687264
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjBBAhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBBAhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:37:04 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECABC74A69
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:37:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O708ntO0JUk3MX9sA0U1FpiKe/blkzXVEmkGz+nphS16yoOi5rO1L+BH/rpARo5ryXfICahfzRoZKC6yNRzOxazhbTANRsbluf/9wNaL+aB24D/xf86aK4ACfqo5yDPaudi6Qsqw+Ev6WTWEV24g6zonfhbKCpHewy4ZZO89TaRF46mAx0n2kimnAUs7rWiZUhi+cib674DRsEhm9C5cqiF5D2yU6ObLxhYAaXFcpv3sXJ+3en+VHjfhuFFPTD9qZKTE8+dDNVkinqApW+NaVMT7pq8WxaHhumAAbOlEi9Z+2Vx2lNFMEzCBw4VPZpeo9vm4cSB18buphN6DGyfiUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkKNoEy6Qpj9GK8h/uFSmsqpDjd3rkOGTueOcHo6oY8=;
 b=TlZIqsryenwnrLshgiA7Wb+7PjaTevrDrQPQFBfTteSxkMI0lv7TDRPQ9BpMW1/tRgP13Vz9Xo3LiCaoVJpEyaqf0G8lNKMDJCDk+zhefbcO6gxWFPFdSVlFmBUWrb1QkUhM6kiQBVsoa4wQYU739Tyl6c/b7JWqJcPnlPu832dXXd5TSkHtMqWFyY5wY7Cau0FqkYfbaV4TfjB0iRCBuxHZk1GC+9jdtnAdrk5Qa3v5eA9Rm7OBiQNUPMiQr6Wbv3agMwtRogPEKUC31cRx16a7xXwSQMAnaKDbIwVuMuZnx2i8QIsfyjAQCFz+wNe5ZlMiRxI4vvqWaGJB8nwANA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkKNoEy6Qpj9GK8h/uFSmsqpDjd3rkOGTueOcHo6oY8=;
 b=OC/uWdmrYIJbleJYQ1BHo2Gi8DUcOiQn6z9Qxy0srfdD+jBX0o+7S6Et8EwjDOPFqmvARLGBmIug4Yi9Suf3c65k6mcCXHWjI7lefkcFtH5+082hrfvbz9C+vbyWGz45ox9M17xTLfB3qmt9IR2GqAhuhAST1fcOQ8M3AVBExxg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:56 +0000
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
Subject: [PATCH v5 net-next 09/17] net/sched: mqprio: allow offloading drivers to request queue count validation
Date:   Thu,  2 Feb 2023 02:36:13 +0200
Message-Id: <20230202003621.2679603-10-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1e4c007a-ecbb-402a-4634-08db04b59622
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pUMdhKhD7fTgysnCRo899Rl2mWZkoredosvxnnHGoHW61dljZOAxkLDTCpeilWfsqDBgeI37li8XSqFULRytZFa3xVC7n5GJfarR2c58E3BHhYNY6/rN9dcxTD1ednnPjL+5kCtl59sF7JntlpV2ET0WrCbOblVPVxTuhymqFGoL61rvfg+4qf0FFLH7i7ZRwVxehZGUt2bEiSG0LDg4g7COBUYdg9S/0D7pvyPuVLzLGx7D+p4RQPHVUlcEbaEaVDEm0KKmnyz/sckPKdrM4ktB+NzPQl488jSam6V7iguUEPWBHkM9TOKttA77dnMlWU91SBEo/B7mrcRBZSWbNwx6LGOrJF+4hyJam+qT8iQCZBbiBNW4FaLcfg6eKdUbddA6kxZ/9Rxa/GCyUM6w0IYWRUCg+2kX/rE/YmjUeKmXmJSTEiKm9YR7OBzmO8Riyo4gn/QhEvV98QWx/C4GcmFYQT41W/LiWYeWmxiDctBHCsNUtNSVK/rqwBFCgcxuLZTzD7+yCPjDcgWoSmkwc+GrBznykJWtnY4M96wdRvqgBajatarKa0snb15slwczprApepc6LewAaxT6qSYYVa2ihyIpfCuudGkFqz7G2blhP58XUD37Vj8FRTdniLRiegMXXymukUqqVHqVtS4fbUZDPfmfS1OzphnQ/n+40hrbN2EYgDrZpQw0Zuoh2fTmnb+oZcz1P9tZj1HLnXd3Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Abbv7rSJBLT7ces/mp/iJqZULI1J1khdowrCKYgMRfbSr41zM8jvoMUkBVHD?=
 =?us-ascii?Q?gGKA2pNU1km7Ib6F1b6x61QP0ZrUnP79GzYaAmFNg7SV9E2TafwTiTCWgA89?=
 =?us-ascii?Q?c/zm6JHbipFLi8z62nIY7QVAkFfYjSGPbUne06sNA7A8U5g62XH6NWFD1Rwr?=
 =?us-ascii?Q?qxa8TyA+d81inELvWX11OxHMrLH32OI6DGUGK/FL53VTJcWuGaqWiRKfh/Kr?=
 =?us-ascii?Q?H3rvIt1D9aAa6FnVlc1/ehSuL/2JqxMkzio7huWGGA4sV2hWXJSyH3wCBzcw?=
 =?us-ascii?Q?UsQbvh4MCnPdVQrPuq/nVeMruD9OpUdLVBFKfi8EYIfWskUz4Zn0Tz2Xz7vr?=
 =?us-ascii?Q?4WoNyqe2qScXA0sV7HwkX/0509GUc4UdvF36QbmZJnhvetNEPpygp9prVGYO?=
 =?us-ascii?Q?30otxT4747VdGhXlpiZN9meox2DHFM5EwBPlBgbPzYMVOOpI1Ot0/CbFxAA4?=
 =?us-ascii?Q?3IgMdbbcnvkC3SXiOwyi+hIFm2xBJ232seW0Z3fGPDQFDwF4wxooPRJthCoq?=
 =?us-ascii?Q?W4+57kdu1b2D26feH9CkNcXW/zcxiIrZyAsWXf1BDJQ+5v24eAL52W6Jv4K2?=
 =?us-ascii?Q?3ouIkdMiK0vWGPcT4VsiKSvYwYnYXrugSsrfj1rlEyoPjjBgRHSMtWF+fNhb?=
 =?us-ascii?Q?dZApEdwMGwlD/xmKCv7wfFaW1umtFB3n3CQnx9586DJqhouSyGfKrw8/al7R?=
 =?us-ascii?Q?ALguFpwjYGlmtachYxI+49ngHsoR8sduogDh073jYvb2b4XqwOpDPFPjv0fQ?=
 =?us-ascii?Q?pERKtkH0lud0g8K3JAAcqwP4BNEYRFHvESaiPKOpVVVKqzAOHME//n5enYk9?=
 =?us-ascii?Q?SXYQNFUTsNF18qt5j7940NIC+kS/QuXtwMO/8a+AMYdRii4QTVM3nk8dStxn?=
 =?us-ascii?Q?kDf6IcYTUZhjrsUyk19eyu5NKqwAIed6NYKtDKrwFDkuOcmSPz0fnxwYAYUi?=
 =?us-ascii?Q?GSlBwbD99ecBCSkke1pW1KQKMtN33OU/x2AZQiSE8XmY1PXFnXT2GkgBeixo?=
 =?us-ascii?Q?dIV3wgylqt3H1TKMSNYRXHk+Uo7p63EjHFXDETtFikhani4MRqqam4ejQooV?=
 =?us-ascii?Q?r1z/iuLqPi8zokrLW+Ta3fNTOUT/w/9hY5cEokAixqS4R0tvxC0df5H/x/Yh?=
 =?us-ascii?Q?3AcTiVi0xaWwH4W0VHnxwzmUurONCzV/UpDWy6V/hRUjlNcztHC/NI0zS1pG?=
 =?us-ascii?Q?GUcN6T5htsye4x/gbizUbZySRXIi9erBJTjaWTbct2Cknvu7gH4G+CF58/Lm?=
 =?us-ascii?Q?zPuMVwrkB/gY2S9ugHva9nXzoYg39k0g3Gc6QXA+COlc5hh75LkQznFwO13+?=
 =?us-ascii?Q?GBa8ARKFpnxmoJz92dQHtimIK9PO35vE7MAPSXkT3VMxxIY4WtJ7yKmLnsG/?=
 =?us-ascii?Q?lbZJv+63l/NAd8SDxC8fluksRxkmR8h+72SuqYEzI1Zeo2oOppGkGu33P2M2?=
 =?us-ascii?Q?Q76+5IZ6XZbA7QXBGPaQtJ1ADYRaT2cvZz/73N60+PNkQzOcqwpsqnQF5/7q?=
 =?us-ascii?Q?ciuSNQIZLBzhUA5i8YZ4Ha1BuAXT3AxdFPuGEx187IY74c6CM19ybTdRuBW7?=
 =?us-ascii?Q?3wGvDJC4ifpdAsgJ/aVNWWEV0u61965/Si6M1iVEhpWNCqiWEGxS7ObZRFoC?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4c007a-ecbb-402a-4634-08db04b59622
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:55.9196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/xrsqxYZXrfpbHF1mbOkYCXWfXJtLIpcVXHQCpuJz3bqg3cbJAm20fXLd+IplS00P4WgNJtSUyrStvswl74Aw==
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

mqprio_parse_opt() proudly has a comment:

	/* If hardware offload is requested we will leave it to the device
	 * to either populate the queue counts itself or to validate the
	 * provided queue counts.
	 */

Unfortunately some device drivers did not get this memo, and don't
validate the queue counts, or populate them.

In case drivers don't want to populate the queue counts themselves, just
act upon the requested configuration, it makes sense to introduce a tc
capability, and make mqprio query it, so they don't have to do the
validation themselves.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v4->v5:
- call qdisc_offload_query_caps() from mqprio_init()
- call mqprio_validate_queue_counts() only once, from mqprio_parse_opt()
v1->v4: none

 include/net/pkt_sched.h |  4 +++
 net/sched/sch_mqprio.c  | 75 ++++++++++++++++++++++++++---------------
 2 files changed, 52 insertions(+), 27 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 6c5e64e0a0bb..02e3ccfbc7d1 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -160,6 +160,10 @@ struct tc_etf_qopt_offload {
 	s32 queue;
 };
 
+struct tc_mqprio_caps {
+	bool validate_queue_counts:1;
+};
+
 struct tc_mqprio_qopt_offload {
 	/* struct tc_mqprio_qopt must always be the first element */
 	struct tc_mqprio_qopt qopt;
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 25ab215641a2..466fbcb5de08 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -35,6 +35,35 @@ static bool intervals_overlap(int a, int b, int c, int d)
 	return left < right;
 }
 
+static int mqprio_validate_queue_counts(struct net_device *dev,
+					const struct tc_mqprio_qopt *qopt)
+{
+	int i, j;
+
+	for (i = 0; i < qopt->num_tc; i++) {
+		unsigned int last = qopt->offset[i] + qopt->count[i];
+
+		/* Verify the queue count is in tx range being equal to the
+		 * real_num_tx_queues indicates the last queue is in use.
+		 */
+		if (qopt->offset[i] >= dev->real_num_tx_queues ||
+		    !qopt->count[i] ||
+		    last > dev->real_num_tx_queues)
+			return -EINVAL;
+
+		/* Verify that the offset and counts do not overlap */
+		for (j = i + 1; j < qopt->num_tc; j++) {
+			if (intervals_overlap(qopt->offset[i], last,
+					      qopt->offset[j],
+					      qopt->offset[j] +
+					      qopt->count[j]))
+				return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int mqprio_enable_offload(struct Qdisc *sch,
 				 const struct tc_mqprio_qopt *qopt)
 {
@@ -110,9 +139,10 @@ static void mqprio_destroy(struct Qdisc *sch)
 		netdev_set_num_tc(dev, 0);
 }
 
-static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
+static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
+			    const struct tc_mqprio_caps *caps)
 {
-	int i, j;
+	int i, err;
 
 	/* Verify num_tc is not out of max range */
 	if (qopt->num_tc > TC_MAX_QUEUE)
@@ -133,33 +163,20 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 
 	/* If hardware offload is requested we will leave it to the device
 	 * to either populate the queue counts itself or to validate the
-	 * provided queue counts.  If ndo_setup_tc is not present then
-	 * hardware doesn't support offload and we should return an error.
+	 * provided queue counts (or to request validation on its behalf).
 	 */
-	if (qopt->hw)
-		return dev->netdev_ops->ndo_setup_tc ? 0 : -EINVAL;
-
-	for (i = 0; i < qopt->num_tc; i++) {
-		unsigned int last = qopt->offset[i] + qopt->count[i];
-
-		/* Verify the queue count is in tx range being equal to the
-		 * real_num_tx_queues indicates the last queue is in use.
-		 */
-		if (qopt->offset[i] >= dev->real_num_tx_queues ||
-		    !qopt->count[i] ||
-		    last > dev->real_num_tx_queues)
-			return -EINVAL;
-
-		/* Verify that the offset and counts do not overlap */
-		for (j = i + 1; j < qopt->num_tc; j++) {
-			if (intervals_overlap(qopt->offset[i], last,
-					      qopt->offset[j],
-					      qopt->offset[j] +
-					      qopt->count[j]))
-				return -EINVAL;
-		}
+	if (!qopt->hw || caps->validate_queue_counts) {
+		err = mqprio_validate_queue_counts(dev, qopt);
+		if (err)
+			return err;
 	}
 
+	/* If ndo_setup_tc is not present then hardware doesn't support offload
+	 * and we should return an error.
+	 */
+	if (qopt->hw && !dev->netdev_ops->ndo_setup_tc)
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -254,6 +271,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	struct Qdisc *qdisc;
 	int i, err = -EOPNOTSUPP;
 	struct tc_mqprio_qopt *qopt = NULL;
+	struct tc_mqprio_caps caps;
 	int len;
 
 	BUILD_BUG_ON(TC_MAX_QUEUE != TC_QOPT_MAX_QUEUE);
@@ -272,8 +290,11 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt || nla_len(opt) < sizeof(*qopt))
 		return -EINVAL;
 
+	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_MQPRIO,
+				 &caps, sizeof(caps));
+
 	qopt = nla_data(opt);
-	if (mqprio_parse_opt(dev, qopt))
+	if (mqprio_parse_opt(dev, qopt, &caps))
 		return -EINVAL;
 
 	len = nla_len(opt) - NLA_ALIGN(sizeof(*qopt));
-- 
2.34.1

