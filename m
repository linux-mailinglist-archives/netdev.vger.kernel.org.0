Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EF767DA9B
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbjA0ASP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbjA0ARy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:17:54 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D57174A66
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:17:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxHj26xe3r2k33w3hZFWnnJYHUK+Xhg+K2ieBbmyUBsFgegt3q2zBCEPSB8fStroKWluMblXskhfEyuAZDsPBh6ghJ2IFa76OqqM8vU1l++S0CnyglKHYJeN2Xhe4x6nSQQOXovz0SF7Ug2lMB5V8Y+V71AYD+P9rvQXOUky7srCm6XTECqAaOXaNu5toOaHy0ZwjNY9e3tf/JOaRwyyfjliC8MZsKyPSRR4Y9wQ8CBAJnU6n3C2P15BtNXS8um3hnF7Tj70uPW+AAXDrEzuww8GlhotFDqD5Dxx8s5xDVXpIVH6rpMYD4uCrgQp8d7elKd03C/KJbCW+DRSX4SQYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVunkUqG8gBb3EsfmL7djLoEs1U2FW4QkFvGTrsiG6Y=;
 b=KSr09/25E3+td55Lxowzq/+ApLUXTOkc/7hUc+pYLZT2R41ZlcgfC0V55NCgNhaDKblYo3QAoaanm2oD7MDAGts3UER3n9QakCN/N6E3BCBNIBx+0ZGxO/aIhVvYi7DjynJ0n+/kmui91X9C7lY8c2+kAe5dmdbFa3iEpq7OUQqrEurPb2h6yp157Qk+P54rG0lxHRPU/p1e9SKwjCdyHilZdnqM0/+BOs7c46PgTXz+mptggTvflASLU/WmJoAbX97JddICMKJKdMcvfP66EKnvQlcR+LTRtAmACsJoLgeG7GdnuBlZRRhtbUSpibfb5t/mMSm+jhkWUvYJbrBTVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVunkUqG8gBb3EsfmL7djLoEs1U2FW4QkFvGTrsiG6Y=;
 b=Ib821WB80XJwvbLhVD9jIoPX6cJd8zYv7FoFWtmGU3QuMOInFb1Qwqy68gnoBKiXvtBhk9vdfuxfWlAqvLPSxAUcmexTDX6UJUHqkwrjChpS0wG1zDmXGNhZr9F4Ht2GS6zvv4dijZErmubpbpglEKAwA/ONzSdo/L5C6ng+Lgk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7347.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Fri, 27 Jan
 2023 00:16:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Fri, 27 Jan 2023
 00:16:05 +0000
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
Subject: [PATCH v3 net-next 08/15] net/sched: mqprio: allow offloading drivers to request queue count validation
Date:   Fri, 27 Jan 2023 02:15:09 +0200
Message-Id: <20230127001516.592984-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127001516.592984-1-vladimir.oltean@nxp.com>
References: <20230127001516.592984-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:23::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 76546961-be6c-46b9-c6e5-08dafffbae72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nUecKR3Lsqkgpq5PeJahdZ5I5HNPIe2q5+hTdFE+f+5W8uvn2+t5uUwHVgIQsVD9IMhIkpyQ3dlvE+j9e9LokkurUG8OQpKSl020GmK9EK8PEvpVYEyRQA6WuWOCDCczKynRM6NH6zDQAi0Xs0fpulBAVG9kTvBXk5vV7XW6WICjiNeXjto0hgmrH6KZVLTb46cHh6iXF/0aQ1vPRZNl8c1O/heUH9HPJSHeceH5IDe5HVHeQi8jWvKJaC3iXirojKlvGe/iwNsjqHAvwZHZkbrIkTL9Zl541sjNHDHhBUUdmBS5hK8H01HIv1aG1xuA33p+EJrZnpgMkj7dugerYIFty8/4vtre9E8a13wnNRti2+ZvNa5cJ5uNp8i4SKmuaQwEAUn8OVLILk0nIW2CYts3Wwq6wKGAZUUEugekOfSmIsnhzFBl2pVcWNC12VMse/Rs+1LAZRT9oXXdpXyPRTrevyfY2gdzXNlgDQ1Q4XbgOaKI9QwVe2wijzcAU1pQhGhZLUdX3fIADIYiKLoqjt0cKBipBgIR62VpHcWvSBFdyUmd2BUHRTdv9Ozi5WB6BnSA6qlFq0TXUdiyWc9lE1T0dWHUsy1vF40fG+82OVstiH321wj+qZyuIzGrQe0Dk0kuelKmAn+3mpLcR5MKVYmWauYWhdSnuASka4JtpwN9u2LwNW5WbYCLetMZDLZuCB9R24e6v82wxBXZyfSE/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(7416002)(44832011)(2906002)(36756003)(83380400001)(52116002)(6506007)(38100700002)(26005)(6512007)(186003)(478600001)(6486002)(2616005)(1076003)(86362001)(66946007)(66476007)(66556008)(8676002)(8936002)(4326008)(6916009)(41300700001)(54906003)(316002)(5660300002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EZyxRKQ3bfDNdhAqtSXl+oby82pv1PhUZPR+AA6LZS/JUC4puYJwvHbyPhEp?=
 =?us-ascii?Q?ervaiQcC1cX6m5VKKWOoRJ55FCdZ060/UPEcH3LzOLESVqP3hatcgKDXqXLS?=
 =?us-ascii?Q?UrveO0iCFOZdAy9v6tiiGAMJmB7AxmTbJnwdBViPMbuxbRQmGA5eomiORw/L?=
 =?us-ascii?Q?+U02ioLP/hUhT3EHNw+VvHsrXv2I0T6qW0Psxtfk6lUL4a0h2JufFntyaY3e?=
 =?us-ascii?Q?zN8fpvs3cgXykqd/h9tjEwKFxs6pwENjq64RMcj+czdOIVYjFMmnwiMyWD6V?=
 =?us-ascii?Q?/sssMoSLfdQSAkUgZH+bU5N3wR6KJb3uU29DykmNh5k6mWjFSPx+aACs10Dx?=
 =?us-ascii?Q?7QNJEzPlTvGGj4fmI2AGO4XFRVwMpFFXHiwzcnWGr6bws2bYJT6z5HxxZn3k?=
 =?us-ascii?Q?41sP3HQiudi2sv/Uyja7UFz9g52n8ZuMewOtc5/uc0fYV81S7inftvtpFTy6?=
 =?us-ascii?Q?DpwQP0nBanmtA8Bl1Fr5GlRmWxNosJKw5bEnyDNv7im3WNTSlnr2qf9vh/xa?=
 =?us-ascii?Q?3bfJHfjKa4EHG8sMuV5m1rgm9O1LWls1X6YqGBTRJd5VKhYtNNFcYXm2HV18?=
 =?us-ascii?Q?o3Vp1xby0nVgPJA8/HLf77ie8KpDxGLQO1XAZdp0QJpJgG0oZbc5jNorrjTz?=
 =?us-ascii?Q?s668bwVBHof1j0MxZvfeBYiiA8wmm9gxFLVpWmEelPLyCIZ/XgrvFDmeIJAs?=
 =?us-ascii?Q?z4Xo5ExQugPz43WHyNIbaqjAZoGQAwR1Y/UNAAy29osDTqRArcUfEoDDbbwV?=
 =?us-ascii?Q?0O2XXjnel7WUA+D4vLQ+A7sbJOIGLObTn8wUdxcLZx00qe3E6xetPsaAjm9d?=
 =?us-ascii?Q?q2RbPsKIllQOCxqzHSFMfyKSI0G4Gqr/hAcd6pImcdi5Foa2S6cppM9EPrnj?=
 =?us-ascii?Q?M7GNgFU3f/akE7Z1QrZBTv4eOQ4XRZbT/CDujYYI2WQCg3e2W3FDYQ0Umdhf?=
 =?us-ascii?Q?6AuY1skfimNJDl/PREL4kc6e3HhBmpbTmuGMa7NK/ixM60S/HWMnQnnhKjDi?=
 =?us-ascii?Q?OK/cZxqlo57KmSpMDCm8uksDvX2QZsPTacHrWMvDcgeVyOErx4x9Y21+jOJu?=
 =?us-ascii?Q?SSPq2pe8Dp66zava2w86PvYrYCJLhkGhX1XidmFMyvnP4k7kiwQVINjhVkXi?=
 =?us-ascii?Q?ONEh+etbbv5R9jtQ6P2SBX/CPPXlIpPho/gZpdhisLVcqyes2B/T2T/Iv43p?=
 =?us-ascii?Q?R5fyrFVZyu25iyb222zV1erJux9Jq1UqchBC9AkeeEFB2m7TrhWXW4ACfHIT?=
 =?us-ascii?Q?3kfJdz2iUH8FHVZbl1Qv3SL5RItaPkHRbYU6wA6xk7C8hsGZdC7yIFjxb0gl?=
 =?us-ascii?Q?3q83J41QBJyEMGdy+YsFAXIiuFFQFJDzSOWXe6Ir6nps+30GzMWjjn2JlyIw?=
 =?us-ascii?Q?+m3eyNiVgxM1qVo80Vz4gP2fUl6FdFFm3jEa3dd7XAYDZv5wVC5Q0mtqTzEv?=
 =?us-ascii?Q?A6XAgPstWLyzZ7zNJ6xv8xasMy2e7yRvSj1JCRqj7US9uIj77VL3Hk5Uq7r9?=
 =?us-ascii?Q?RwHAk0Bx1xPAlH6KeWxXz9UePV5DJ+17TMh17T26ZQaHJiALNHRm+CcGDxHJ?=
 =?us-ascii?Q?E3OkROmdrr4m90JZvsC3mOEuDYZhH5XI3S6atODuXBoJw96bWJSWaMQTw24V?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76546961-be6c-46b9-c6e5-08dafffbae72
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 00:16:05.6696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s4gqGDQWxcn3HrOY+RFyGIucocBDWh+0fDN+xTrcIDXBZiLLaAirkkASlKYp+katDzMoaHY9CNG0R40c2g9fxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7347
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
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
validate the queue counts.

Introduce a tc capability, and make mqprio query it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v1->v3: none

 include/net/pkt_sched.h |  4 +++
 net/sched/sch_mqprio.c  | 58 +++++++++++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 20 deletions(-)

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
index 3579a64da06e..5fdceab82ea1 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -27,14 +27,50 @@ struct mqprio_sched {
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
 };
 
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
+			if (last > qopt->offset[j])
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
 	struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
 	struct mqprio_sched *priv = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct tc_mqprio_caps caps;
 	int err, i;
 
+	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_MQPRIO,
+				 &caps, sizeof(caps));
+
+	if (caps.validate_queue_counts) {
+		err = mqprio_validate_queue_counts(dev, qopt);
+		if (err)
+			return err;
+	}
+
 	switch (priv->mode) {
 	case TC_MQPRIO_MODE_DCB:
 		if (priv->shaper != TC_MQPRIO_SHAPER_DCB)
@@ -104,7 +140,7 @@ static void mqprio_destroy(struct Qdisc *sch)
 
 static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 {
-	int i, j;
+	int i;
 
 	/* Verify num_tc is not out of max range */
 	if (qopt->num_tc > TC_MAX_QUEUE)
@@ -131,25 +167,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 	if (qopt->hw)
 		return dev->netdev_ops->ndo_setup_tc ? 0 : -EINVAL;
 
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
-			if (last > qopt->offset[j])
-				return -EINVAL;
-		}
-	}
-
-	return 0;
+	return mqprio_validate_queue_counts(dev, qopt);
 }
 
 static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
-- 
2.34.1

