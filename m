Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE4F6D4231
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjDCKgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbjDCKfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:35:53 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0331285D;
        Mon,  3 Apr 2023 03:35:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzYLbD2Bvk6BuxWHIRL731C80n3IFSFWSD9K1pCRECV1gemLnjhfB+7YTdJ7B/BWsgS/1HJzqKM3ZR48tw1bg6ck+1UbGmw7tgsmjOct9pSpHV18/ftBBoexvFsR/kfTh1ZtGM5t2vOKxCKf1oGkfsSgF7zJvSZZEaVjmlbh007D/95rnstsgmiuwWtbHi1xv6vmNJ+9PjNLHqI/Ofr2nGd56g1D8vCSBJimYklrX9pXNz/u7ParT4HBsnZUokvr6DgeY3VDEqgDPw5juIXyoTpDWsXMThnCojF9yisjjmgm/OCSuAzd9ibwXJnrHWnkF5G7wVWHQlxRjO7GDRVxRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alCPmv8FaTs0aFVBKiC7WnHF2DdMCJiTJQx9TQbQLJU=;
 b=E2vygINyK0CoU/89JL3ZnIpcn9BWDDo3V16LMjO3DX8ePtgbNp9VuG9l/2xHEjTF3p2EPZWr6ciJOxMogQzgHRG/5uFwioZiPf5N6hs36x3TMIpmJP1AyHtSHqNsqUwkLbBVwg2NWfRYl5z7jEdSmihxpicm8U0Jtlev6vg1RvgEdbZduRuoQPPBw4eBO883TNOnGAi1alKbI7OEDVq0SpApvKWPkD2w0qYSBvh/StgqtKZD1RNDxiz6NVJ8kckJWQNs053EJxVjX6mbpmPALtSZi6FLlaOwH0ekHUHEGNgWHu3ulULZhRRf5pYsjppjl35YrOJjX1wtRd1G/62vcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alCPmv8FaTs0aFVBKiC7WnHF2DdMCJiTJQx9TQbQLJU=;
 b=YunkMOAOeHvCdPm5Z+gow0OL9FIw71xGm/UlQIaA5Df1nl97Oqdwt0H6FhPC+M4DThglnDpeuJp726oeZBRjvovopTMarXSmy0oVDAdKl5mz0dxQTzwVMjCaDCj3zx/e64aC5UZs5eDucOd8oYqoSH/TfmaQRAsMphG2uTizpjs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS4PR04MB9292.eurprd04.prod.outlook.com (2603:10a6:20b:4e7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Mon, 3 Apr
 2023 10:35:08 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Mon, 3 Apr 2023
 10:35:07 +0000
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
Subject: [PATCH v4 net-next 6/9] net/sched: mqprio: allow per-TC user input of FP adminStatus
Date:   Mon,  3 Apr 2023 13:34:37 +0300
Message-Id: <20230403103440.2895683-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 26b5d49b-7988-4fca-3090-08db342f1794
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Tg+eH+aSmoXxNgKIdW7GjQD4NEAJYlTmaYn2JuNLyEc4oE5VKCD90pQ+pOAzZv5vP1KhzrOOMkreMs5s6Gey5EkN05ZoOJP6Avv1NmJON0iwpQxE9oS1UpxklUYF/1eap/ZzGjFu94t7ZEV5Tk97KYDOEHuw0Ozchx60UZCHp8hZi2vYw/mezWy5Z2U4/DO31XoM1P0rq2FSfdYTcMX4xUYEfzGySROJrUMyvxd37+X287+XszaIM4MKPiWk/poifYwxnK5E4KnXT6j7Q0xNGQe7ZhbaQwaKDjXytZj8HCkogDzCaLFAUDWbR00C/Xa37k25Si2Xw8Vqd9POgub6Ht8j9esE9d6aZbk2tax64GOWzvooPfFcf2RvaL85SGc7i+KXEjAF+Tibfrqi4aqFPgVzH+8m+oMdOk+vywfJgMdlX5Ka5OnRSqvcWaHakB3nqfJ+q0u4EZ7+KDz58WZaOCG9nw3M32hz/x0PUvRhRKAS/nLmr+oajjBhh7RMkZqWj91EHqqhYjwGoE3UsPV816DONRBdC/gAGkr0TSJnXKMihsPFhK57dvIVqLCu4cFT9w9SyUxuZvjQuJjrDHWjoM335XVBSK8dDEPLCvfGxjTWSIlLzQwC+BOEwotXN8t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(451199021)(26005)(1076003)(6506007)(186003)(38350700002)(38100700002)(6512007)(86362001)(316002)(54906003)(41300700001)(7416002)(5660300002)(30864003)(44832011)(66556008)(66476007)(4326008)(66946007)(8676002)(6916009)(478600001)(52116002)(8936002)(6666004)(6486002)(36756003)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CiZfLRcJA68U+UVuYKIvpWbh5dwM9TbE07SuNAKe6hXka0hoKmP/+kDesYmQ?=
 =?us-ascii?Q?RU6UiB1zf8cJlQ7RzpIOy2X9subyUNBsDhiJbfuYVaah19fUqloFUBDL16Ns?=
 =?us-ascii?Q?b4bPl5KxtUxlswnP2cmEo9Xg19UBAUor1gqDC8iTDzDVOX/lUpDZxGMoWD81?=
 =?us-ascii?Q?KLpzFS9DqZPy9vhIuOOPb+xPVaNs96s2UP/vKgyWDLMdf46E81Sg/i8VhZZc?=
 =?us-ascii?Q?bT2J7pDK8+R/kT3uGTJez07ViHpxhyUXD2PXq81jRQa3Nb64sHA37yM95LvV?=
 =?us-ascii?Q?lQBZk5hH7oiFRjaLsCEyktuYNRI4CEIXLrRrPCPqtguYn+zy8TZiYeqONQzH?=
 =?us-ascii?Q?Ndu8utCSg1oyqDEMopYQChCMHh0A2qSSG8otF6P7sbszvqZ5BFfLR3X6DlFU?=
 =?us-ascii?Q?8BmBdDuRx0ME/UFtQ+iUDybxJ297zLU6SnWdn0RqMb5HsEHdNudchMFqY2Y2?=
 =?us-ascii?Q?G7/pwXiUIf0boqBKYM+Qz0GC6vozlrH9lX6M64iiCLmxOh3RQmccDrfZHDIV?=
 =?us-ascii?Q?F+HKQgxhw9gzyEwo6mXmTOVGVZzW1MAt4Nfz2xpB1QxPfcNLrmb3JDvHfBvY?=
 =?us-ascii?Q?MEuwBB8AUc7oHuwhfEs1g5uQQVr1ldrGlGUwXrKFcD9LRnhixxyWUeSGlPWC?=
 =?us-ascii?Q?jHRScvusqI8ndvTt5erBkTZAm5Qjm1zeK8FkM1/ORdjOf39Kb3eJMobumLRr?=
 =?us-ascii?Q?pnIv9IX/dHFWFb27K0cYrDQbd2j4Ua3Vki5TKJXTwpR156LlvHwv/UrJJgkz?=
 =?us-ascii?Q?yFgQ77gvo084gpt45njvY6+AnRyb2nKX8lT2YviEJsbPCApEj5tzI0LU27RZ?=
 =?us-ascii?Q?v0cMTGpSnMtfrcJ6msNCXLeyobHIF3nz89vhnIfncUw5jypYtR57gDf+EsuQ?=
 =?us-ascii?Q?rrYtnxUClyvYUZKMeqFVyFfqwgQjnusGR0NwX4LDtMjgONEOEDmoUW7YeOQr?=
 =?us-ascii?Q?faKCw5J33h9PIBJK7L3Ag9sP3huoREG0MdtHaXXKi/cgV8LqTdaTgmeKw1xY?=
 =?us-ascii?Q?Nq2vFRTTb9qFKI5Yv4OZx+2tXmgnO5bb88mWUSjJNwBPsZPh8y2QfBrNqaD3?=
 =?us-ascii?Q?haITc8nhy6bLi4lvk8P7wGCBelsL/2EsMwKpqZOazqXo5BdUv0duJIqMxZwB?=
 =?us-ascii?Q?lpWIBSWk52+gZbqPo7If8CbY/vBrtA5JVeYu1SKH0B7O8JkUE0EZ7naMUVrq?=
 =?us-ascii?Q?lzsUVbbySxvWLOIGjwS4JC5Gjg2xkGNeSdTnC9RqvFK7bcwsT+3osPUhuN+K?=
 =?us-ascii?Q?0kV5+ULlC66p5kpn/OJ0zC0FQPK4v0VQh2y4SG+ODcowZDT4BLYIgxrc8py4?=
 =?us-ascii?Q?cHdeLMpGUHFSk9QDZD8KYKAfJEJo+Ryo+OThONvwVjLezTN2Kg7Nd655UGa8?=
 =?us-ascii?Q?WpFphPAdYdt8pVin9WidfUTqQsjG/00jD+RrOj/NbOPG4TSDGSOn743X0kP1?=
 =?us-ascii?Q?17vq42/u8spzicWyWa6Pl5qvNjJ79nr2v0AOKqd8bgG+RHVPeKrxRWC2WiTH?=
 =?us-ascii?Q?wF7B13AcIMjkyjneQqf3fUb21LvSV2teRV81aF+xpJKJGOyvHc4QROSIz90K?=
 =?us-ascii?Q?wZqfoCYZ3ORR/ANYG0wUxCyfKWMOcjADfaxgrBxkBO1UNfHrdR1x6WWNBOmn?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b5d49b-7988-4fca-3090-08db342f1794
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 10:35:06.8567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f91ZvzR3TUIA9j6+RC23BS/TwmbGeEZDg9bN2/bHNWMYWx0JeSioJjdzjchaDtrnqjcv4EfS15GO28R3yZL7Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9292
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
the netdev (which presumably is also under their control, when
constructing the mqprio netlink attributes).

The reason for configuring frame preemption as a property of the Qdisc
layer is that the information about "preemptible TCs" is closest to the
place which handles the num_tc and prio_tc_map of the netdev. If the
UAPI would have been any other layer, it would be unclear what to do
with the FP information when num_tc collapses to 0. A key assumption is
that only mqprio/taprio change the num_tc and prio_tc_map of the netdev.
Not sure if that's a great assumption to make.

Having FP in tc-mqprio can be seen as an implementation of the use case
defined in 802.1Q Annex S.2 "Preemption used in isolation". There will
be a separate implementation of FP in tc-taprio, for the other use
cases.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v3->v4: none
v2->v3: none
v1->v2:
- slightly reword commit message
- move #include <linux/ethtool_netlink.h> to this patch
- remove self-evident comment "only for dump and offloading"

 include/net/pkt_sched.h        |   1 +
 include/uapi/linux/pkt_sched.h |  16 +++++
 net/sched/sch_mqprio.c         | 127 ++++++++++++++++++++++++++++++++-
 net/sched/sch_mqprio_lib.c     |  14 ++++
 net/sched/sch_mqprio_lib.h     |   2 +
 5 files changed, 159 insertions(+), 1 deletion(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index b43ed4733455..f436688b6efc 100644
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
index 5287ff60b3f9..bc158a7fd6ba 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2010 John Fastabend <john.r.fastabend@intel.com>
  */
 
+#include <linux/ethtool_netlink.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
@@ -27,6 +28,7 @@ struct mqprio_sched {
 	u32 flags;
 	u64 min_rate[TC_QOPT_MAX_QUEUE];
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
+	u32 fp[TC_QOPT_MAX_QUEUE];
 };
 
 static int mqprio_enable_offload(struct Qdisc *sch,
@@ -63,6 +65,8 @@ static int mqprio_enable_offload(struct Qdisc *sch,
 		return -EINVAL;
 	}
 
+	mqprio_fp_to_offload(priv->fp, &mqprio);
+
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_MQPRIO,
 					    &mqprio);
 	if (err)
@@ -145,13 +149,94 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
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
@@ -234,6 +319,13 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
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
 
@@ -247,7 +339,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	int i, err = -EOPNOTSUPP;
 	struct tc_mqprio_qopt *qopt = NULL;
 	struct tc_mqprio_caps caps;
-	int len;
+	int len, tc;
 
 	BUILD_BUG_ON(TC_MAX_QUEUE != TC_QOPT_MAX_QUEUE);
 	BUILD_BUG_ON(TC_BITMASK != TC_QOPT_BITMASK);
@@ -265,6 +357,9 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt || nla_len(opt) < sizeof(*qopt))
 		return -EINVAL;
 
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		priv->fp[tc] = TC_FP_EXPRESS;
+
 	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_MQPRIO,
 				 &caps, sizeof(caps));
 
@@ -415,6 +510,33 @@ static int dump_rates(struct mqprio_sched *priv,
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
@@ -465,6 +587,9 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
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

