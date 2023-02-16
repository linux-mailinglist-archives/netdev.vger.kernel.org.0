Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583D769A246
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 00:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjBPXXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 18:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjBPXWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 18:22:31 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2075.outbound.protection.outlook.com [40.107.104.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB8D56EC1;
        Thu, 16 Feb 2023 15:22:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQoHb9iy79+ZVpz5cVIEOYG2xePi52bu6eLB1/cFdLnUMYPs/2T1W71N6x550V/oLKBWm+6g1qqzblTWvMvLNQuDO87bGCBBcT+UuCx+7RSR3TWygsAVSGy2eLOzoU9L7GL6g3/u6e2Oc55H6pPzXQIDfpywhWKXZ0cihs6xntABhaV/U8BK0OkYMy4ArA3uBIBz4620LuBEpyUeb7B3To3uXzIlGvdI1uBYkCzg7t8cJOo1iSJVUdeFthq974VTz5MgRTWUcwpaVsykYxmtNwN8q4aZpN9dO/U0wx3dZ4xubF1yIz847KVvXwi9VbZMtPKae6m/Aroe9Ijqjqb9Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8D6L4E/yOxXNnApcjCDxJDmkPqDQglSjJq9Re+q5zt4=;
 b=Iae58i9aqMvhzTYiVMcw7dKDKM23CPWXI4HPTkaYmv5m3i4goTGxmiAUbaGyPpBu15MbmuEoczTRsd2nAQQ45TKr93p8W3savYddrusQc6zFkHzZcaaiNcVaNVNJeEKdIfczuapZthleSAFJRxpAFuQOkWoauD5DCgij6dPqkWDz2xa/x5sLMo0OMZelskjPN938lC55H0N+z5nXS68Xp55M9JgpmWqr8fCTSO6r4RSmDUDyshV8rYPep4kYno1P4NICjK9MkP8Jy0xHiynehC31uRMAQyALNnvAGsLXggX2ZVA9HA9/ryuqmRbmnDOQYLhYVVX0NQV/qK0SxYSl+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8D6L4E/yOxXNnApcjCDxJDmkPqDQglSjJq9Re+q5zt4=;
 b=jFHjeEhQVgQQO01ST/lKCRyLog5XqIDqAVPIslTaj+fEBy3+GIUleVPlUEdtgi207akv3WaRt/SGpU4djYOmbSg+7Lpc7LzvrJvc4i8y1cK7l7xlZNnghVbAv7MF/jcqkBdS9UkoXGog11+gunS2RYuviEmpvd/lzuBcnyWkaOA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7436.eurprd04.prod.outlook.com (2603:10a6:102:87::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 23:21:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 23:21:50 +0000
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
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/12] net/sched: mqprio: allow per-TC user input of FP adminStatus
Date:   Fri, 17 Feb 2023 01:21:23 +0200
Message-Id: <20230216232126.3402975-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PR3PR04MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: 975b2c76-86ca-4bc7-4303-08db107494f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0xIF8bXTVzrjbkmJpVU8oldyGXfm3osI/Vt4Vo8gbXyTgh9eJ8PRBE2U7IWXKdTFDEkfY23+p0rWxNQkwzXwYIhf9IyoTcD9i+hRiOzah1kG0v1wm81MDTS05WrnPKFhBNVAIGgayZxL2B3D0rclI66gPP5KMAoLpw/EuYeH7vljgZ3YwhtueuCw6vcVwUFKp7IOw0u02deTc1LRnNTHXRPrNETqN4V886jy+q9GtJ/ooNRq13EVVDFC2Q1Fbf2HkMLFJNPx8JTXjTJ4+P44AzD+S4ivZHXWo+MJ38l/bInf0ZgsCZYpjES6U5FBZvSyEMAUai8Vj4hGpSzqVo3t0q2haebi9/eGthNmkexMwiB5y9wxiGV4NuJPyyov93JZV8+138dkLfwTc+C4raIuv3o1ZDVy6DCI8+FEVV24tOokkv828TYQ8WOwJV2AP9tOfauT81nKMhw82K3WZsm9tVNA7+HnMobIxmYiMd1TzF7CDC09L2sTunowYsYemouREQnZCKcYwSrYtOG270yzNsDlSXEDEngsAQBFR8XC7vzOBVztWo8HBMRkkJ7c2iQLqYidHX5SMq6WBvqjhrlX1jPlstKCjoaBzqBHOiW2qEX0uJH8trz1c3RT9hiCj7fESZBvvOIt4egyefU211Efr7t34jWz4xnpWPAS7mc1d5gyh9Qukk/WC5SOfiFP6hX5fK2PJ2UuAz+9oSTqG/QVMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199018)(38100700002)(2906002)(38350700002)(44832011)(7416002)(83380400001)(66476007)(2616005)(86362001)(478600001)(6916009)(66556008)(36756003)(5660300002)(41300700001)(6506007)(52116002)(6666004)(4326008)(66946007)(6486002)(54906003)(186003)(316002)(8936002)(26005)(6512007)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RNeIBKzGv+jK1PS9y/NC5zzoDiMG3RnJAnclDpYGo+PirP9yKAD9MXusmDxA?=
 =?us-ascii?Q?7YsMxH1rDcmvx4caMK3fDhLYh7l8RMipKrpxyU/q8uP/UvP/xZYCchz5RTjS?=
 =?us-ascii?Q?SAfiQ3pHTDj8HDS0q6mbNu5pBDUZNIovScz9iMVI1Fb8pjzmdDLD3P4aMtos?=
 =?us-ascii?Q?24eXRVvu4rFyTpa1CR7IpYjobOms75K70BrIHmhdA9OaFLMOtK/zWt13A3Jw?=
 =?us-ascii?Q?gaJm2ihyFJLR6yWc6GmjG7uIpAaHRWDfxwjLdMnBXwMibv/lbEnaUAbIQaSE?=
 =?us-ascii?Q?L+UWU9QNgiSQmRf+7ZBpuxgQUng/Xn1Lc/bIngH4z0X6EhjRLe1SXvXQjUQR?=
 =?us-ascii?Q?Xr/i7tsC/+d5V2N5AV28j/VR46AVIak4zcscMmRxUUGQH0sAflP5W0weeWfx?=
 =?us-ascii?Q?snE4kC9ec7OO4dlZSUaRcbstwAWd+3fsXWlyMal5Z6gieLP8cHDE3mgT2ow3?=
 =?us-ascii?Q?R1lBw1VI1veC6kNt6HkxCuaIaQFulbdxwaHGfae0ZWoSy5qgRPelUxEpkG6J?=
 =?us-ascii?Q?WUUN/PdH5qij5JmwfIay2o9PmVi1nK+uBmdL0sX7ef6RgFkrFaUuOMRztGnH?=
 =?us-ascii?Q?yZYJpPuxzL6xplk9IPIPdY++XbUUNMQY7wdTu8i08NqnfVW8D2IVJKvxNr9z?=
 =?us-ascii?Q?WfRix8VwuKLTvIAb8bJtcoQqJ7bUvU+KzgqLVEGKQAUE7wvYcKVzn1y06XeV?=
 =?us-ascii?Q?e1psh99RxUlLcTGzfL1qpbwRqd4/OfnOQa02vM94TMPWWfrAw3WDDibo0SUm?=
 =?us-ascii?Q?yRuZR1uRFvr9LqxDZWZMmyZG5ecueRMsL80F5iFg8baxbbvk24hOL7kxciXp?=
 =?us-ascii?Q?kZE8dV61o9RdkfMI3kb3RlA1dwfd0HhJE8pahk3fhu6i8pTRzGFdSJFXW1SC?=
 =?us-ascii?Q?Tcc3U3mdIpGkFDQ8900aXmQvf9S6lLCZIzOOc2tTI/oKbKLWNfqC+Mjr5e9z?=
 =?us-ascii?Q?s7QmGENwNu2ykqkaj3+8PnPfGOUA4bq2lPIul2v9WNKcB6gEVPyIHtSK8hA1?=
 =?us-ascii?Q?zz+alkb3+bSIerBGTq0znlSazXJ2jNjTVY7V49iDauuycPZfAsdZYfwLugqY?=
 =?us-ascii?Q?pyBEWMy+Lcv2G5qXB2lBzoqXoCjlGDhA3HI43caoQzHSQRsfy4KRkjpCO4mP?=
 =?us-ascii?Q?kF0eXo6FlABmTVVA+MV2vu0+Sugbki5Z+NDoDnexNjNnUcz1AcoX1SNtNGVp?=
 =?us-ascii?Q?QeSsmbEZkB6HxDgbDUdLLaKac6r/jI4GzPET8O1kvrfu+5Ci5hgY4hAFg6Xz?=
 =?us-ascii?Q?lJ/V3rKlmcYWL0E9ls+OiVngv4F6h1ERlcOlDnCCqMyng/SwojBYF5EejkZD?=
 =?us-ascii?Q?gAUObq3nLKWS7dGUxXStGeo2evdIaFsCpl0ZeU+BG72nrhIkTa7sckkbycc9?=
 =?us-ascii?Q?w3aJ5WS+eUJem2jPXwQ1aJoDP1uAZGppjagoeDsdwp12GN+Jjum9kW3p2+Bu?=
 =?us-ascii?Q?DjJW7xJf3PEsFKpkJMFIzn2xpeK1hw7EOojet4JzlHg0KGB9WAfGQAC39rlN?=
 =?us-ascii?Q?UKP2cmH4j0ZaC1sTecOMkPnsnT+d+9VyUF3d7nqjNq3QsoIh4/TmLqzwT+81?=
 =?us-ascii?Q?+2ZZdWQWAvhFhbR36QutSgQFFSfQgVirgCRw2CAHzdCa/Uc8APsDJXlTosWy?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 975b2c76-86ca-4bc7-4303-08db107494f1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 23:21:50.6178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ov9T3255tn4VpilmsEoSJMPbtsm0OoViBieEvLxAPX58iRz8L/nE3hw7waIOeR9PdGY76IK1cBT3OOEgu+przQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7436
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE 802.1Q-2018 clause 6.7.2 Frame preemption specifies that each
packet priority can be assigned to a "frame preemption status" value of
either "express" or "preemptible". Express priorities are transmitted by
the local device through the eMAC, and preemptible priorities through
the pMAC (the concepts of eMAC and pMAC come from the 802.3 MAC Merge
layer).

The FP adminStatus is defined per packet priority, but 802.1Q clause
12.30.1.1.1 framePreemptionAdminStatus also says that:

| Priorities that all map to the same traffic class should be
| constrained to use the same value of preemption status.

It is impossible to ignore the cognitive dissonance in the standard
here, because it practically means that the FP adminStatus only takes
distinct values per traffic class, even though it is defined per
priority.

I can see no valid use case which is prevented by having the kernel take
the FP adminStatus as input per traffic class (what we do here).
In addition, this also enforces the above constraint by construction.
User space network managers which wish to expose FP adminStatus per
priority are free to do so; they must only observe the prio_tc_map of
the netdev.

The reason for configuring frame preemption as a property of the Qdisc
layer is that the information about "preemptible TCs" is closest to the
place which handles the num_tc and prio_tc_map of the netdev. If the
UAPI would have been any other layer, it would be unclear what to do
with the FP information when num_tc collapses to 0. A key assumption is
that only mqprio/taprio change the num_tc and prio_tc_map of the netdev.
Not sure if that's a great assumption to make.

Having FP in tc-mqprio can be seen as an implementation of the use case
defined in 802.1Q Annex S.2 Preemption used in isolation. There will be
a separate implementation of FP in tc-taprio.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/pkt_sched.h        |   1 +
 include/uapi/linux/pkt_sched.h |  16 +++++
 net/sched/sch_mqprio.c         | 126 ++++++++++++++++++++++++++++++++-
 net/sched/sch_mqprio_lib.c     |  14 ++++
 net/sched/sch_mqprio_lib.h     |   2 +
 5 files changed, 158 insertions(+), 1 deletion(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 2016839991a4..23be97f542fc 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -172,6 +172,7 @@ struct tc_mqprio_qopt_offload {
 	u32 flags;
 	u64 min_rate[TC_QOPT_MAX_QUEUE];
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
+	unsigned long preemptible_tcs;
 };
 
 struct tc_taprio_caps {
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 000eec106856..b8d29be91b62 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -719,6 +719,11 @@ enum {
 
 #define __TC_MQPRIO_SHAPER_MAX (__TC_MQPRIO_SHAPER_MAX - 1)
 
+enum {
+	TC_FP_EXPRESS = 1,
+	TC_FP_PREEMPTIBLE = 2,
+};
+
 struct tc_mqprio_qopt {
 	__u8	num_tc;
 	__u8	prio_tc_map[TC_QOPT_BITMASK + 1];
@@ -732,12 +737,23 @@ struct tc_mqprio_qopt {
 #define TC_MQPRIO_F_MIN_RATE		0x4
 #define TC_MQPRIO_F_MAX_RATE		0x8
 
+enum {
+	TCA_MQPRIO_TC_ENTRY_UNSPEC,
+	TCA_MQPRIO_TC_ENTRY_INDEX,		/* u32 */
+	TCA_MQPRIO_TC_ENTRY_FP,			/* u32 */
+
+	/* add new constants above here */
+	__TCA_MQPRIO_TC_ENTRY_CNT,
+	TCA_MQPRIO_TC_ENTRY_MAX = (__TCA_MQPRIO_TC_ENTRY_CNT - 1)
+};
+
 enum {
 	TCA_MQPRIO_UNSPEC,
 	TCA_MQPRIO_MODE,
 	TCA_MQPRIO_SHAPER,
 	TCA_MQPRIO_MIN_RATE64,
 	TCA_MQPRIO_MAX_RATE64,
+	TCA_MQPRIO_TC_ENTRY,
 	__TCA_MQPRIO_MAX,
 };
 
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 52cfc0ec2e23..2db0802c2ce8 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -28,6 +28,7 @@ struct mqprio_sched {
 	u32 flags;
 	u64 min_rate[TC_QOPT_MAX_QUEUE];
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
+	u32 fp[TC_QOPT_MAX_QUEUE]; /* only for dump and offloading */
 };
 
 static int mqprio_enable_offload(struct Qdisc *sch,
@@ -61,6 +62,8 @@ static int mqprio_enable_offload(struct Qdisc *sch,
 		return -EINVAL;
 	}
 
+	mqprio_fp_to_offload(priv->fp, &mqprio);
+
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_MQPRIO,
 					    &mqprio);
 	if (err)
@@ -143,13 +146,94 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 	return 0;
 }
 
+static const struct
+nla_policy mqprio_tc_entry_policy[TCA_MQPRIO_TC_ENTRY_MAX + 1] = {
+	[TCA_MQPRIO_TC_ENTRY_INDEX]	= NLA_POLICY_MAX(NLA_U32,
+							 TC_QOPT_MAX_QUEUE),
+	[TCA_MQPRIO_TC_ENTRY_FP]	= NLA_POLICY_RANGE(NLA_U32,
+							   TC_FP_EXPRESS,
+							   TC_FP_PREEMPTIBLE),
+};
+
 static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
 	[TCA_MQPRIO_MODE]	= { .len = sizeof(u16) },
 	[TCA_MQPRIO_SHAPER]	= { .len = sizeof(u16) },
 	[TCA_MQPRIO_MIN_RATE64]	= { .type = NLA_NESTED },
 	[TCA_MQPRIO_MAX_RATE64]	= { .type = NLA_NESTED },
+	[TCA_MQPRIO_TC_ENTRY]	= { .type = NLA_NESTED },
 };
 
+static int mqprio_parse_tc_entry(u32 fp[TC_QOPT_MAX_QUEUE],
+				 struct nlattr *opt,
+				 unsigned long *seen_tcs,
+				 struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[TCA_MQPRIO_TC_ENTRY_MAX + 1] = { };
+	int err, tc;
+
+	err = nla_parse_nested(tb, TCA_MQPRIO_TC_ENTRY_MAX, opt,
+			       mqprio_tc_entry_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[TCA_MQPRIO_TC_ENTRY_INDEX]) {
+		NL_SET_ERR_MSG(extack, "TC entry index missing");
+		return -EINVAL;
+	}
+
+	tc = nla_get_u32(tb[TCA_MQPRIO_TC_ENTRY_INDEX]);
+	if (*seen_tcs & BIT(tc)) {
+		NL_SET_ERR_MSG(extack, "Duplicate tc entry");
+		return -EINVAL;
+	}
+
+	*seen_tcs |= BIT(tc);
+
+	if (tb[TCA_MQPRIO_TC_ENTRY_FP])
+		fp[tc] = nla_get_u32(tb[TCA_MQPRIO_TC_ENTRY_FP]);
+
+	return 0;
+}
+
+static int mqprio_parse_tc_entries(struct Qdisc *sch, struct nlattr *nlattr_opt,
+				   int nlattr_opt_len,
+				   struct netlink_ext_ack *extack)
+{
+	struct mqprio_sched *priv = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	bool have_preemption = false;
+	unsigned long seen_tcs = 0;
+	u32 fp[TC_QOPT_MAX_QUEUE];
+	struct nlattr *n;
+	int tc, rem;
+	int err = 0;
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		fp[tc] = priv->fp[tc];
+
+	nla_for_each_attr(n, nlattr_opt, nlattr_opt_len, rem) {
+		if (nla_type(n) != TCA_MQPRIO_TC_ENTRY)
+			continue;
+
+		err = mqprio_parse_tc_entry(fp, n, &seen_tcs, extack);
+		if (err)
+			goto out;
+	}
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
+		priv->fp[tc] = fp[tc];
+		if (fp[tc] == TC_FP_PREEMPTIBLE)
+			have_preemption = true;
+	}
+
+	if (have_preemption && !ethtool_dev_mm_supported(dev)) {
+		NL_SET_ERR_MSG(extack, "Device does not support preemption");
+		return -EOPNOTSUPP;
+	}
+out:
+	return err;
+}
+
 /* Parse the other netlink attributes that represent the payload of
  * TCA_OPTIONS, which are appended right after struct tc_mqprio_qopt.
  */
@@ -232,6 +316,13 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
 		priv->flags |= TC_MQPRIO_F_MAX_RATE;
 	}
 
+	if (tb[TCA_MQPRIO_TC_ENTRY]) {
+		err = mqprio_parse_tc_entries(sch, nlattr_opt, nlattr_opt_len,
+					      extack);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
@@ -245,7 +336,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	int i, err = -EOPNOTSUPP;
 	struct tc_mqprio_qopt *qopt = NULL;
 	struct tc_mqprio_caps caps;
-	int len;
+	int len, tc;
 
 	BUILD_BUG_ON(TC_MAX_QUEUE != TC_QOPT_MAX_QUEUE);
 	BUILD_BUG_ON(TC_BITMASK != TC_QOPT_BITMASK);
@@ -263,6 +354,9 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt || nla_len(opt) < sizeof(*qopt))
 		return -EINVAL;
 
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		priv->fp[tc] = TC_FP_EXPRESS;
+
 	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_MQPRIO,
 				 &caps, sizeof(caps));
 
@@ -413,6 +507,33 @@ static int dump_rates(struct mqprio_sched *priv,
 	return -1;
 }
 
+static int mqprio_dump_tc_entries(struct mqprio_sched *priv,
+				  struct sk_buff *skb)
+{
+	struct nlattr *n;
+	int tc;
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
+		n = nla_nest_start(skb, TCA_MQPRIO_TC_ENTRY);
+		if (!n)
+			return -EMSGSIZE;
+
+		if (nla_put_u32(skb, TCA_MQPRIO_TC_ENTRY_INDEX, tc))
+			goto nla_put_failure;
+
+		if (nla_put_u32(skb, TCA_MQPRIO_TC_ENTRY_FP, priv->fp[tc]))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, n);
+	}
+
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(skb, n);
+	return -EMSGSIZE;
+}
+
 static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct net_device *dev = qdisc_dev(sch);
@@ -463,6 +584,9 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    (dump_rates(priv, &opt, skb) != 0))
 		goto nla_put_failure;
 
+	if (mqprio_dump_tc_entries(priv, skb))
+		goto nla_put_failure;
+
 	return nla_nest_end(skb, nla);
 nla_put_failure:
 	nlmsg_trim(skb, nla);
diff --git a/net/sched/sch_mqprio_lib.c b/net/sched/sch_mqprio_lib.c
index c58a533b8ec5..83b3793c4012 100644
--- a/net/sched/sch_mqprio_lib.c
+++ b/net/sched/sch_mqprio_lib.c
@@ -114,4 +114,18 @@ void mqprio_qopt_reconstruct(struct net_device *dev, struct tc_mqprio_qopt *qopt
 }
 EXPORT_SYMBOL_GPL(mqprio_qopt_reconstruct);
 
+void mqprio_fp_to_offload(u32 fp[TC_QOPT_MAX_QUEUE],
+			  struct tc_mqprio_qopt_offload *mqprio)
+{
+	unsigned long preemptible_tcs = 0;
+	int tc;
+
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		if (fp[tc] == TC_FP_PREEMPTIBLE)
+			preemptible_tcs |= BIT(tc);
+
+	mqprio->preemptible_tcs = preemptible_tcs;
+}
+EXPORT_SYMBOL_GPL(mqprio_fp_to_offload);
+
 MODULE_LICENSE("GPL");
diff --git a/net/sched/sch_mqprio_lib.h b/net/sched/sch_mqprio_lib.h
index 63f725ab8761..079f597072e3 100644
--- a/net/sched/sch_mqprio_lib.h
+++ b/net/sched/sch_mqprio_lib.h
@@ -14,5 +14,7 @@ int mqprio_validate_qopt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 			 struct netlink_ext_ack *extack);
 void mqprio_qopt_reconstruct(struct net_device *dev,
 			     struct tc_mqprio_qopt *qopt);
+void mqprio_fp_to_offload(u32 fp[TC_QOPT_MAX_QUEUE],
+			  struct tc_mqprio_qopt_offload *mqprio);
 
 #endif
-- 
2.34.1

