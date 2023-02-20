Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D086269CAD4
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjBTMZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbjBTMZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:25:03 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2071.outbound.protection.outlook.com [40.107.15.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F21C1C7F7;
        Mon, 20 Feb 2023 04:24:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYozqq/w8l7ImlTPrNrfm6dD+yteVceRu42cU0jXVrfH9zTKmBr5CD8bX+wlUVPMm8HEqQ53tUQfUYUehK4tNrV5YZ3m5o7ykcVVcZie7O4nshgXZ3zGb6PhKNkqC50wSrH+csdfOJTQEvTNEgZeF58W3AeCqrs6kI2fldA6qB5NOUngXUQa0SwN/7ikGdpsW0X/hOnyFnGuPHRn8ysttcr/6zPqj8STev4YLI+lgzhVUb2Ho2AhZTjCLFsAp+sc/4IkzT5bEnLrtc69Pds9AEP/qSx3et7mtqhXfGc5N6ZZqVeHBTaCB+j5dEkR/pXpVbZ/fllS8n21CIoId9buwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7ouJPnAh/3p8IFwec6nIeLcyjjo4eZKQQdYBAvXiV4=;
 b=gjNnn7oqB8PAdvQlrHuHJQX3T1WKdkNbB1Qzp0OoB9Ybo2nm3FGFhNn2jApb7lCq0Z/4RZBPFpEJ5H7JYV0UEbfRfOGdrmtua9NZC9b7KGi4HQoqnkw0OVEVYIl1CHF/npkmLtLsEJ0dSYUDH+gW0vDRpXqWuD/ZXBzXkG7dMjA9Ibm5SpfqAI3kmRWtpAiMHGW34pybOkvm/q6M7ZVaKqQXItIQ8vmGiwZP6to/RfMDa+aqNdoP3hIJnAtlMVURSHqiK7WZ267TCm22Dnt8d40za/bcZFkmIui5Nzg96xzwNacFWdsLsJHY7hsp/JZvfisjNuEbt5CF80ZBTmGvPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7ouJPnAh/3p8IFwec6nIeLcyjjo4eZKQQdYBAvXiV4=;
 b=OEu82JX5CGzcrmz88Rz+f5gt+1hFxmHNysJu8Y7EWjh3ZhRhdcUuZyeNCpSuIjll7lVFaa8yflmVj3ya/F1Tvf2QY2L9hTNYzi7X2zUD9Hm+KgU932K59cdZJn4TV5eiQp1yZAHqq4BYlbROl4pegnizjcyE+1TvOt3rxaHRD4A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:24:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:24:12 +0000
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
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v3 net-next 07/13] net/sched: mqprio: allow per-TC user input of FP adminStatus
Date:   Mon, 20 Feb 2023 14:23:37 +0200
Message-Id: <20230220122343.1156614-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 99538b90-9d5c-4396-4375-08db133d5fd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pwRMpTGV8rOZegWpdeuK54ouY0qWN9WxdluYL+ZEr79e6ga/NFct0Q9z7hOOq5zJS3YPkJrCgreeuGiOXCpFbYBPYXgzmSQwEtlXdW44lOcPgIaIs5t3kPVbsQv8iJP5zb4NPDDdIQ3gzM4vpJYjtPpcAXupFd82cdLtF0/YIwz3zDdMI+ycEQY3fryyuf2zF8flXcCWBz3o01fJ0IEerD+JHBR97sXF02mryeHn7g1o1yCxA1mGPu3h///MhC+UVKcE/h/bTLrXBDQcxayNRtxJwVdC7j788WoAbCtZaFjQ4JvLJNhG8uf1A7Wl4/b+lYbrvlJSFP4HCneC4sSQaIM6syBAgE8ZQLsVDlV1UKFGV3DOwx1ruFyvD8nUgcL0WQ/Ga8iwVMkoCS28zcuA0t33qXpj069X2yB6q5EoKzB9NX7ezBRO3jm7kBtODvzkaXZSN1a4sHlVoAxywL8SMS4DMHIIIBef6KzaEBbeBoujw5hEHYENNZfnhgdgD1L0iAQJZIJG6makMqbkF5J+5fWU3o3kr0Kp2F6662/jB5ZSAnpBm12n78BgKi+zXxP23ZlvUss4GBw7LtHmRrHTfcg79GidpCMkAzUEsSJFNIdz58bpRQh3KyAC0VUz7WUTUJPeO5PnJ7a7UvbjMeT1jghNCWpZ8coE4QZp6ItyUUWSof1mJlYo0z1DJSXfaQOxN27l9a9h97zEj8biv7HHtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(52116002)(30864003)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+QXiGY906zfyEZ2Ai1ny2z7Tw/ujW8Ct/pYnrQ2P0wKYVHvBldaUGwqHk2GQ?=
 =?us-ascii?Q?9E2fhFFRkoBaE20Y4ocM69s8zlWHgboDMiUgmY4edqlfFnCq51stn5PO8T2L?=
 =?us-ascii?Q?XJegbOQ/gnb73q3/fAUmRMhjAK1PJ77+E5aSNmSZ3yO6VyMeT0TCu/Qt8SaH?=
 =?us-ascii?Q?NHFNdBB9GUmf8R+z+4SPsXVS84m+PmBznihdhg2HgdbEmjLzHW7ifcmupqZk?=
 =?us-ascii?Q?xf4wsFp7dNWBlNEm3FosfREhchIcUR+k5eVnmkx0CO35lZEQv+5RACLnU2KH?=
 =?us-ascii?Q?PRHJnPTJkDoe+KjXHKDnG/wDWZVl4pR6KqngeKIU1bjW7WbCnq+1BvahmLrR?=
 =?us-ascii?Q?TAt++hXV55a9LF1vM0+kwxs35D7ccJ5wbpQ17qC5GgnmnjQLzmO6ONYXIjwF?=
 =?us-ascii?Q?+FNpM091lmBodicvnKTqmbOmHDy8cBlj+1a3UeMPMgopuqXNALhKDhq9FJvk?=
 =?us-ascii?Q?Qt5SmBV+aAuDhmOg+qOoUplVIJPHmfUbe9lZjAaPDaM/R92gl2wiphdLaGh6?=
 =?us-ascii?Q?D71E7wf9W6FbvrS/E3m9vqMQQpWjh1zVZA74E2kqxcwQbBHbcx3/aot9iokN?=
 =?us-ascii?Q?8yllo3k5ca+oMASCvpCwUB9mC9iTzL9VkqwMJhMDUtmpMgsd6VWt18UciXSw?=
 =?us-ascii?Q?108vSIZ5Scgismy9OlGBp21EYQDyTYXwwdCUb3oGiLt4YIlbBr8FUeYBc5nO?=
 =?us-ascii?Q?i/OLoTB7i/wOpqTEwAD+n5RyBweVO/8673hmC81VulcxlFR/pWEwLKuKIDSJ?=
 =?us-ascii?Q?qX0/2/YbOQ49XG7QpsSG9IZXqD1QpiDPr2zNGx2WzchSUpzGzvcBwHFVHsYd?=
 =?us-ascii?Q?zzg6wsykSOxTmvRjgPfhonJgvFAWeXQC8VQcPWbN59yyxbPaG9kYyGuVLTAh?=
 =?us-ascii?Q?Gbh9qGFxrBzoMUKL5VK7Tg3Q4vWC7TrryBQSHTsLhcZ1h2fvyYbLcf4u5RN1?=
 =?us-ascii?Q?P4EafNtHc+3WES9W8XH+iCJ26RU7XcR7v0NQmABi93be5SDY1RviEtz/ua9S?=
 =?us-ascii?Q?CSqMbGlIqLOFKOtMPLG6ARvPaiBczUUSZZt65DWCMLovcL0IjF38aVV97iQj?=
 =?us-ascii?Q?Va4WwMv6hRjXcdviicEsB6/qgMUV46kTk6J9vaLI0FUrkteOTeYFMZmvF+QQ?=
 =?us-ascii?Q?Jalnfty0i9DXLo2HOs5+Ea1uh9lvgPzAZ1rBZwnX33ZLYPTziuRXOlVO7KKz?=
 =?us-ascii?Q?tYatHuwCuYw++P3O5mIkrjknJtCKxfhaNUdPIICpa2YIBeo5YW8yLU5l4P2S?=
 =?us-ascii?Q?5cyMjO6JzSBQYhysbNT2gT4V4fAypegU0os0kbDij7omlToFX6QbaRyw548u?=
 =?us-ascii?Q?gYiTDlggUrvpBpJLHS9Ibr8UXNN4TtJKoap4DX1gMQc9Vwas7xwFXXkjZ6L0?=
 =?us-ascii?Q?K+/77NDUP8JUChaPQ0O0ywMqgjQNFKmIVJYXXgvY1e+N8mwolkFOuBcsbmdR?=
 =?us-ascii?Q?ViwJGNYZPG8i32nbbRWwQnsQguYfFcNekr0gYTkQfueCLq4tW6Mq8mgCVeuW?=
 =?us-ascii?Q?yni/yKoi+47NWrzuWKq/hjQCBc0WyCm8yBNUN10atZ3NEbSn/qyzWzSte8E4?=
 =?us-ascii?Q?M+TeFdhXQijMi5b40G7lpRcjVKxHg2+Q4gMjRKE8ZcsbVWeWOafqPvRlNAke?=
 =?us-ascii?Q?lQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99538b90-9d5c-4396-4375-08db133d5fd7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:24:12.7432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DsN3ZE92Pn30dRtxN55ruRNmU9Eoe0UMv3u2fAXmFyNkupaXkFgrHj+shGNTv3xE40aTyf8H0wb1ZrSO8iJc+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
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
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
---
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
index fc688c7e9595..f4f758963c84 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -173,6 +173,7 @@ struct tc_mqprio_qopt_offload {
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

