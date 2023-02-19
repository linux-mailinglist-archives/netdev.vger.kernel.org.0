Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABA569C07F
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjBSNzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:55:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjBSNyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:54:46 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2084.outbound.protection.outlook.com [40.107.14.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E391C1205C;
        Sun, 19 Feb 2023 05:54:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnJUJRxjY5Uua4ggQ8HUBe1DNK6TH/2JdVCt8XQAPY2QdRrW7aG3Qttx9kws8g1UOlE0yLxx96ZXaIL1vGZQUbMxDAuoOINbb4ojjXrRsSRyCIbUghnCPf0oT1KkcsulOMUbv+q1jn+zPIMJOp7G/AeG75lfgtF431+PnHlDEZgbo6BS4zeKSBcqpgI9vV8B0nR+58BYS+7nT5Ary2Ql4ozApxff+opEUSu8WRyAGD1irAsxqYLY2vEnVdcT6kA/PJlzXBDFH0aHDVvBLL/ZfuBeec9pf2PfAAPKwuRSmEWCrw8ilGpETtJX2FBUfXw9adFBXfjVRI9Ugi+CZsol1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/tnAuFk/OkIAF62qcqfhm9P34ifrnzrvpBR8KHX5j50=;
 b=GeZhQ4LKiqa6dD4aP4j5VFuJggf8FLzYchYZuQdiGsvpZj2Uc3JHnLppKQADppbbDXV4r6YClPAr9LLwBDLpzrnTt9Qc4I7z33g3dTSIG2sAVuwaTwmMVh2tkI6h8scXZm7TIgIFTw68jsdF5gbGf/uMnR5LebW1EF2CjsotQotCBUADKqNjNAN7RPx6yTi6KVsLmXsZjdJsozO8s4BeaGoiqnwOtfq8oRlDty0XZDg5YJQkY/s/8SrXI7qVgZOtrafgmQ0KFXVyVFY6pbH5srtnEKlM3t2qBaIaqmnchyinpwHl2HZ40Oj7FXh0Pphla641opXzVvWGqAcNkCHrew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/tnAuFk/OkIAF62qcqfhm9P34ifrnzrvpBR8KHX5j50=;
 b=bDgC2jVpcFDFbt4dPqbAi6UDhuL4kjjHJOQG3N/Lgnb2gUDpU2uq3xUGvh+oBZ8s8a8n91XK0diplHThf2PzmTCUkY3Tav2mNQRPPsNvijy9r5C67qjVK+q1Wgu3bYKGDSmeHkLfq2uNR20K6dpF5OWFmIzxkKPRsOmLMXeweSI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8238.eurprd04.prod.outlook.com (2603:10a6:102:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17; Sun, 19 Feb
 2023 13:53:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:53:55 +0000
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
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        linux-kernel@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 net-next 09/12] net/sched: mqprio: allow per-TC user input of FP adminStatus
Date:   Sun, 19 Feb 2023 15:53:05 +0200
Message-Id: <20230219135309.594188-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230219135309.594188-1-vladimir.oltean@nxp.com>
References: <20230219135309.594188-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::6) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b2a0896-8193-4c23-583b-08db1280bd99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IsM7XWm6CIgxS7CBmy9rqwI2fx6gt5HOCWa0N3lyRmWUEfkdDkFHvg32Pofd7zeAHCVYaBIc0fMssXfFlOYHZgIOM/WF9OQrFvLwmYIeDKUJUHo2dH+jpzDkL7N+hKAb2uCFD5bVtEo2z3AwYcHUbySMB27WoXGRYnDIjjitsZRqIymjjy2cj1v8YREAFVNwwJYc+SS7WdfIv4Covd0GWrpDgMTOB6FebNaJAcLZuag/hQn+yZoly/zxA9O8DtnLuY+GKYJy2bgevU1BCLDX9Kw4vVK1eGTqnQAkl1qVkRrDocYw0ImvPKAoGye8XPqqfyRI5TVSSUe6rk2/cJAQTE9E6R3WLk3SkdfQ7GvxylRrrgWXpI8dOqqLSCT3JsDm7FZjtiwJD/f/zbqxZqltXvnsVuwuejC40WnzEgLnMJmMfO7MjcaI770wpusIq7AuDKngV/TxItUqYQUCBT1buCNXIZHZUmTyOaKSmzXRBKmESz6pSNPHEoYKPNagF0BqvUSU1urTNTBxv03HO01EBfBm2U5WMhFDNy8mjIW8dE2fclWDSPMOx7cYAmcAGPcxalvd4aPSLRF5H0Py/NrN8MvYULfH9w3LPLLJYTWEE6Ix5kK6fzrjxCPxfhaQjSE1e6/w/p8MgxWMUjo7Nqnop5JsnZQiWUB2wZVwaItl0tUwKypYfk38gdFoN+gF/LWZzYYdCUrhjv/1Zx1pIeUwbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199018)(8676002)(66556008)(66946007)(66476007)(5660300002)(7416002)(4326008)(8936002)(41300700001)(30864003)(6916009)(44832011)(86362001)(38100700002)(38350700002)(6512007)(6666004)(6506007)(186003)(26005)(2616005)(83380400001)(52116002)(6486002)(478600001)(1076003)(36756003)(316002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EMrPJ/+EXticyiYhcPCnSdMziR5EC5tLiUmdPH6q8n9cbxO8dUV37Y/XmhMI?=
 =?us-ascii?Q?OFd99YxdJ/JwoJbzN3RCS7NETWcd2+h1xOW5gQVaGGn/eHKu8lwZEqi5aJYs?=
 =?us-ascii?Q?VJUWwVIKvZgfe4EE7/Zmk3UTJYFPC9hAaFcJ22wceSNniJDkty9JA81WFqxu?=
 =?us-ascii?Q?2YGja/VSdnU3LeKhLQmyBLj9dXa65IePA/is/saELgRP2Wr1xyHWA3ebxxpX?=
 =?us-ascii?Q?lrwJUnDCU7D3NvRM1gF9OAbG4wenP/zG7wr1PZGL7MTv+kT/4+oZdqD5J7v0?=
 =?us-ascii?Q?yjwlfMYh2fNb4y5iVyDfq9/z4kDT5mwSL7Nynnd1/3sZLMokCVI7gV4+nVSI?=
 =?us-ascii?Q?9vz2LMZnF4LguWjDeINfnnKYgLY/t0bvEC3fiVXxHfAqSSzTWvABeRIe7SI1?=
 =?us-ascii?Q?rsyAHedEhj6YxoZVSRqApncGV1/1QXZn5sOxFQbxhpZ1zycP4/gOutbLDdVu?=
 =?us-ascii?Q?gHGC6Nr0uen8i/d56CO0ucgkv5PTjAWGZ/LXs0pvo7MMAq2lwi3cy1zsamV2?=
 =?us-ascii?Q?mG5XLIoFF0q/r45LqIPdK93EI8+sG9JScgS8S1wQ4UA9pUEAUvpU7MGgpzwI?=
 =?us-ascii?Q?cIwzPzSbUKAzeo9MTAJXPcNZW7mol5GKGwzuHeHF26jpPgPZvQWCx248YU4U?=
 =?us-ascii?Q?5qlqS7sGnCAt5aPWyKs1hVIlBI1ZXrpxkd7/o00E4s9B1t9zs/aJkcbUeYI2?=
 =?us-ascii?Q?nSI0YPEwE55f0nfTjfPWRh2ZgLzq3lmtuLNr/m0GaxHfvuwagL1ifqt5dawQ?=
 =?us-ascii?Q?kirBxDkJnkVZHeRrD/v37+mcMRawERo0TwE/jkxw7u/rzOYx/5kTd56NngcW?=
 =?us-ascii?Q?2uA+PuJyhFGOwbE+fPWulbqsxL9Y1cHy5ftj49h1zruKTJovD6CDYUndPxd2?=
 =?us-ascii?Q?k4Eg2wFSyqc5wv9MdMEwt5bEUVsBOMd6+6hQRuGnTXs0ag4kx/I+ZSCsUH5X?=
 =?us-ascii?Q?RxbToCs6MYCZFmXELSjZzF0DS/kE36KbpRwltaQf9vEy7Hx7Qc1pbb7eJMT6?=
 =?us-ascii?Q?o1QaCekJ4/hxLslKFEZGyatyKilgqWzrvh345D7iDpZtGQ0UPH+AdJPdXRgL?=
 =?us-ascii?Q?nQ4k5ODlLJ32QwNJHMfwbenrVTkIlL0yVZRM2pDhbLh3qrH49nb4Q68JeF3G?=
 =?us-ascii?Q?nTTtptZYwLpL/3Xvr/Qv55MupY9/nWs3GG5mIFFb5/uJA5BGpr3EDoLDegdU?=
 =?us-ascii?Q?is0Bghhgp8ZLs0t8t81FZ+qv82NxkqwVDiewp0rFYqa6A2rgY1rMsvxQJExt?=
 =?us-ascii?Q?elTRyWTodLU65s9h6fQR2zk3o1edv70jUwmrHMQY9r0d+qdF1N7Z65BrH8BM?=
 =?us-ascii?Q?pEB1xeOcVcYxa+vOKJEoGz2+UX8JHBjo4X+/FO7Qy1RNTXZZlervlvIGidKG?=
 =?us-ascii?Q?6pUMT3EtJnobgG2Z1bLMSZRDLfhZStjZoMU2udbyDdu0s5XGNHtopIim7TBK?=
 =?us-ascii?Q?PmME2AtXT7W0/TnTeeXdbAASBg0KwF3GJD69sTQnjIT+/mZfgioFXjleHD2o?=
 =?us-ascii?Q?KshaSIvsHO8YPx99o9OAoGz3GRhrt/1s2S2REMjhYj9jY3RVwJfHqj1/Kc3R?=
 =?us-ascii?Q?QYRxhxd5VKFkOsikkHmC4qgI9rHVcQw9gOxkrjrHOq1YQ7IRvXFn2s1bcb2L?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2a0896-8193-4c23-583b-08db1280bd99
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:53:55.1614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xC2Uxnsc+ZHBKk3IYgqNmgNRvDlF3pnfiQmh84H02VcTEEyy3pL9+GpEbW9d9e2E9D35WUIM4hl8upeGKy7KcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8238
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
---
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
index 9ee5a9a9b9e9..f2ca7d272274 100644
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
@@ -60,6 +62,8 @@ static int mqprio_enable_offload(struct Qdisc *sch,
 		return -EINVAL;
 	}
 
+	mqprio_fp_to_offload(priv->fp, &mqprio);
+
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_MQPRIO,
 					    &mqprio);
 	if (err)
@@ -142,13 +146,94 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
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
@@ -231,6 +316,13 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, struct tc_mqprio_qopt *qopt,
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
 
@@ -244,7 +336,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	int i, err = -EOPNOTSUPP;
 	struct tc_mqprio_qopt *qopt = NULL;
 	struct tc_mqprio_caps caps;
-	int len;
+	int len, tc;
 
 	BUILD_BUG_ON(TC_MAX_QUEUE != TC_QOPT_MAX_QUEUE);
 	BUILD_BUG_ON(TC_BITMASK != TC_QOPT_BITMASK);
@@ -262,6 +354,9 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	if (!opt || nla_len(opt) < sizeof(*qopt))
 		return -EINVAL;
 
+	for (tc = 0; tc < TC_QOPT_MAX_QUEUE; tc++)
+		priv->fp[tc] = TC_FP_EXPRESS;
+
 	qdisc_offload_query_caps(dev, TC_SETUP_QDISC_MQPRIO,
 				 &caps, sizeof(caps));
 
@@ -412,6 +507,33 @@ static int dump_rates(struct mqprio_sched *priv,
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
@@ -462,6 +584,9 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
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

