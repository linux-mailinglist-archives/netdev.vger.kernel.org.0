Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8B26DE35E
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjDKSDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjDKSCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:02:43 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E826A7E;
        Tue, 11 Apr 2023 11:02:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkLCNQQPjz+RBWzNPHpjUI/9H7yW1C8Clk1IdHVKdvTnqzM4FsL+fbkKV624imnNrrObtkv0siH8DOBZE13TezxembYRkEZkHX3JW9+WstFHHfxIOICREthB4Tsx9gPwDTEU8+EtG6a5COO8HRaNKiNuQyEAbWQKSU07OxYxsNpd5anRxU+QyrHy6Nv21iNzx/eQQTpXuVvvvvQ8g3rQI2i+FsPaB0xdvDDzWb/kH+m00ZnBq8oAvjUSGW+CVqYy2HJTuMmZedDb6UXMEPg+Gt4rC+wxHSEbk/m1/Pbe45L3rfgZWQg/DZPTROLv2Ho8MyaPH66MbJfiJPvatlrXFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OeLEPyStBO8JT73LZKkycLEh9m3oBOZVC+NT+wuALJ4=;
 b=LgX9T4Y9SDYB1QXvLZtxUMXl6UoXDxC7FZibY8FRmPQgVUYhRVSkRzZ/c5qc6IJcmt1by3ScoRHskY29tX87cIClty5pwqWMTqTx0+/xsStYPVD2mg1P44K+Bd+yg9ktsD9Va6tGQ4MkJEG/sdWvftfTRvbZuqQvswiWcBXu8JB8zaXdWeKbLHXHlbSMRsbGeyMQ41HbrrlegsEIStrEUb+sBbqYRrQfy7lJnh6Z2VeTJtXUs6MaslLKH0lEPr/IbRWhGZZHBHfwDnBY2oK7hKjDWwnGXZMEDiVu9UAOzmdyDdd/OjBXZlsP8bOawUGL/rotwpki6gMvPir4GcIMMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OeLEPyStBO8JT73LZKkycLEh9m3oBOZVC+NT+wuALJ4=;
 b=IqHAYWA8+P0oidyN4vesp5giEvaL9xDQIeNbzSzEC81T5rMZKNPlJOLwDaCCeQHymnrcOyIMdpxBbQML86rRoYk72v4pxs+CnZPJlgEmgyvt3E+HhBtVK/pZ88sLdigaAEUHFJzht3+oJzF8uwpcpo1KG/feByRpV/rrBQq9Ln4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7829.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:02:30 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 11 Apr 2023
 18:02:30 +0000
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
Subject: [PATCH v5 net-next 6/9] net/sched: mqprio: allow per-TC user input of FP adminStatus
Date:   Tue, 11 Apr 2023 21:01:54 +0300
Message-Id: <20230411180157.1850527-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
References: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: d247d78e-1405-4aac-d95a-08db3ab6ead6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n3fSZh0woepsY8It1trOGFKKKjAZ7cdIL8Jsnu6Nzc0ZVOLXlnJMk9GEX/vGcyTxJfYRxAaqu2iTl2OIFD4r0FI12op2mzXTzlO4tLeNncyzIEDWKHWxzxeitIge4XYRG86wrVFhYWweTKpLlOUBCoYOqiZ2dD9jZ68or7DHcM0PZkuafEXagEkoTTsR8S0bFnifS86PvzVIgaDF0EGeuGoXH74HTaw60cTTaiAH6cBYHgZa8qonW81HhBkxNh4ytc/2/8rkK0PuCWk03X6vdFLSUkzUZYlt+2yHDWTOZccj+GMF7r+qpjW/B8YQe0c5S2cs1qlOSNADEoZFfX+cnrwvxLiEiWYPrzeVOXvgLvOQ0yhCl/5porKGZEQRMGvhj+i7n1at4wL9GFi5dITzZxefw04asULN1/O5p6/kDaPBIVEifhok5udWfxrrxKKCfTnBP3DhT2kKDQwc8d56LBWtIHSlnuGnGbHm7zt9dp6ZgTMWJRvf2qT9FzIVHk8UNetC1RmbGarqotG/IDsn1Z3xn5GgzlhAabZFomYq+39l5CR7KC0F+gu/8XSfAh8/kiVe3p5ir8aawNjco3//ZpJpLHnB7gy1EqMbmNuoNJzgb+ZOZPee8/6vEaAZkOob
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(41300700001)(478600001)(86362001)(316002)(54906003)(8676002)(52116002)(6916009)(66946007)(66556008)(4326008)(66476007)(8936002)(6486002)(5660300002)(30864003)(7416002)(44832011)(2616005)(186003)(36756003)(38100700002)(38350700002)(26005)(6506007)(6512007)(1076003)(83380400001)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EwMCe3HNxGC2pH40XFxLfX5BF+D5cLx0oDdCHjodBUTp/w0egA0TztKgYbaE?=
 =?us-ascii?Q?VqijHNBOvgMvj1GwzEqzM7Bo/eVOaJ0gm3MdPxn3+Nn9ZcbB0rlhnYp4SbtJ?=
 =?us-ascii?Q?2Z2jDD0NiaSzr6pjYPdnH937s3VZgJso0ScrdQ2U+wTsqh53FpNuSoZQ09Iz?=
 =?us-ascii?Q?0aYU7X3jwSXbLz1JbvimmiNReWHPIgwQt1UKSBKs2fqonZIiHFw/BMFwdLQZ?=
 =?us-ascii?Q?164t8CXoljeax/p0f8kXlWlVZouEOuJvyof0SdWr7y1Yzp3tRN/0EzTGAlan?=
 =?us-ascii?Q?JkqY7I8NS8EBK9WTpJ/msCmmpBWzF5WANavQpOHN/TbQZpKmkDwh9vMYH08e?=
 =?us-ascii?Q?YJAbn7pHIp3Py0rRCtiHofPMORcC2e5twhVb1KeFnVksCKeLEFX5cRBE3Fr/?=
 =?us-ascii?Q?iT41PNMRrp6epB0packWrL1z+qqiPTXaskfjRcax7XDB61B38q4mjIqKJ2Xp?=
 =?us-ascii?Q?S03RG/JsZ7TuluFTCgr80srtBgrPVwrQyLD9Fi31k/OEDbEftUqZSABKVSlJ?=
 =?us-ascii?Q?zAcsFPE1mjoFdFPGGXQy3U48GX0Gk3rRAfn7lBlU1whlZtarcyKF5T4fBB23?=
 =?us-ascii?Q?xjC4MJUvdJYVTfxi5taSb2YWon8v8YFAFsRtcTTNHbQLhtkVX5YNSd6r6nTk?=
 =?us-ascii?Q?aZprXH2Mrlpa2EDdADu7WiLazW6K/YosjLjaO/F44mUWGYhLu2R7Mk1RN9Tr?=
 =?us-ascii?Q?xWnHUmBglfklcSUyxpkUkqmfFQHjuQ7lbD0WlsUX2m4Ev8PTppPsaIdkSqj4?=
 =?us-ascii?Q?8x2OhBm8Oa1yw2J/e721KQ8fD0/A089SmcpIXeki3swYQyZevR/hE4BXZx0v?=
 =?us-ascii?Q?u1tgpKWFvrFWohsiRarmQudw5+ijFmDYxUM1hqFUAdWCKsGwCRg3zCuk8bus?=
 =?us-ascii?Q?r76mvkbdgw+RCCTI+wNtnvWTmCaTS/fw3dGOFH/8eDu5MKOK3whuonxlCP75?=
 =?us-ascii?Q?phnhmn9B1UmcdBd+CoYO3Tep/qtrE4RmuK7kGMEmvANe3hY272gJyrXmgYzS?=
 =?us-ascii?Q?peQPfiTiKcMuj5LeliYKKDOlVG+aDwJ8qjhQFEbEUXei2nJy3a7dw6LRGBai?=
 =?us-ascii?Q?NJR5y6xUCUhFXDsbrXsfQBY77kXZsMQ9R2944KgM5JAb5HMBhJ4aAh9JInnz?=
 =?us-ascii?Q?lmj7dgTdOzJE5kSx7wSIrWC99q/jyxHCUoq/583Pjgkjr1lH/02k/uebEVAb?=
 =?us-ascii?Q?PreA57/dL4rGZ9ysdF2nDOENBoYiQSVl4LA8yKKbTxVEr3pUq2tbw7u2iHRE?=
 =?us-ascii?Q?FIpWikaeT8WqJz4EAWBrnMSbbaegquCuIipnSDvoTtgQpr4AALFBEEWNDjdl?=
 =?us-ascii?Q?6ZAEicj9qqw9R4f8xrUCbBUTqov0KdbXprKSFgNRCywv4YYVhW2dQYzzRiKt?=
 =?us-ascii?Q?tjuqJTeMDAaFLdgc1yxj517FPzKHUGN/Gn7rEG1+y0fpyT5XL+K3OlLKOASn?=
 =?us-ascii?Q?uOftQUalfsNDvrTmxmt7sIRSCEbJhIfBw2jLR/Sz0XQ71zWmxLmIFoV6Guua?=
 =?us-ascii?Q?xa+ipBuewkgf/LgDX4QbRDLWZpyI91R/Q/jBta8MAl+w2UCWQ04yHZiuvlRm?=
 =?us-ascii?Q?6opinI6wIZo5M5zLSYcMWxyRmonxmUYeHuuPnjmlkiSNYOje6ENNwecLmHwZ?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d247d78e-1405-4aac-d95a-08db3ab6ead6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:02:30.3730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efxkBUnMrfDCUQE8VXQaIoPEc8v2rzISUs1n4hN9Dq07B23KeI5BHRLaP56cbHq85yTPuxQsDsyWbLkgCO1c4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7829
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
v4->v5:
- don't initialize tb twice, nla_parse_nested() does it
- use NL_REQ_ATTR_CHECK() and NL_SET_ERR_MSG_ATTR() for
  TCA_MQPRIO_TC_ENTRY_INDEX
v3->v4: none
v2->v3: none
v1->v2:
- slightly reword commit message
- move #include <linux/ethtool_netlink.h> to this patch
- remove self-evident comment "only for dump and offloading"

 include/net/pkt_sched.h        |   1 +
 include/uapi/linux/pkt_sched.h |  16 +++++
 net/sched/sch_mqprio.c         | 128 ++++++++++++++++++++++++++++++++-
 net/sched/sch_mqprio_lib.c     |  14 ++++
 net/sched/sch_mqprio_lib.h     |   2 +
 5 files changed, 160 insertions(+), 1 deletion(-)

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
index 67d77495c8fd..dc5a0ff50b14 100644
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
@@ -145,13 +149,95 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
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
+	struct nlattr *tb[TCA_MQPRIO_TC_ENTRY_MAX + 1];
+	int err, tc;
+
+	err = nla_parse_nested(tb, TCA_MQPRIO_TC_ENTRY_MAX, opt,
+			       mqprio_tc_entry_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (NL_REQ_ATTR_CHECK(extack, opt, tb, TCA_MQPRIO_TC_ENTRY_INDEX)) {
+		NL_SET_ERR_MSG(extack, "TC entry index missing");
+		return -EINVAL;
+	}
+
+	tc = nla_get_u32(tb[TCA_MQPRIO_TC_ENTRY_INDEX]);
+	if (*seen_tcs & BIT(tc)) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[TCA_MQPRIO_TC_ENTRY_INDEX],
+				    "Duplicate tc entry");
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
@@ -234,6 +320,13 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
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
 
@@ -247,7 +340,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	int i, err = -EOPNOTSUPP;
 	struct tc_mqprio_qopt *qopt = NULL;
 	struct tc_mqprio_caps caps;
-	int len;
+	int len, tc;
 
 	BUILD_BUG_ON(TC_MAX_QUEUE != TC_QOPT_MAX_QUEUE);
 	BUILD_BUG_ON(TC_BITMASK != TC_QOPT_BITMASK);
@@ -265,6 +358,9 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt || nla_len(opt) < sizeof(*qopt))
 		return -EINVAL;
 
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		priv->fp[tc] = TC_FP_EXPRESS;
+
 	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_MQPRIO,
 				 &caps, sizeof(caps));
 
@@ -415,6 +511,33 @@ static int dump_rates(struct mqprio_sched *priv,
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
@@ -465,6 +588,9 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
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

