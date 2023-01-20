Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592576756D7
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbjATOTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjATOTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:19:09 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2076.outbound.protection.outlook.com [40.107.6.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6C276AA
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 06:18:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzFkWOW+OtYMlEhdIlIH4zwF/qpi5u9cs4/Bn02FT9sGq5wdcpYzhj7cACWaBiNV8sV/jGHXVZkWsRse9T6Khw53wsu6vZLa0m+q8bPTE9lNrnIngCwU/NC3BGBifa0g3OY1+7BP+rXdMHBDiCElLJ4ePJ3HJOUP65iHpz0KqIttITsNODDxsdd4pRpt0LzUpmWvuV7M5QYGoAPoNvRh1S02EXK+8QIHMtDlZIinNuNDYplAvgebqXOdHCPgb1iGzS4zrmk8e3XkuLuAsjvodLypMTfdrMxxbk65V+5U6G4VLEFpF4n4h10l+/SDN74r/Bo5PtsoR7fbpQ3soqgzMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lw1bymA9Th0Yxk7/wXNrwTqzrzgujJQOYIXGatyt2io=;
 b=Sh+1Xi+TevbUJBncQB1MCEryMg8Yi87TE2hq4KZ7dK043rV8Yb6O4L9YP8iEQvuDsm0+NFL+9/KI6hzr8Bw68Ybd7uj9VkoSKtdoTMZ7CdEw811IjAzzZqcVqmaZUOpxt9ru3GdieHkMKsfPfKyC6xNh39mizncDPkSeSl51SAX1kTuwkpqCpTr0wj83zcx0N2qTWl0Ng58zNszdF8YKiwHI1f09Ezu09olFOkDj7hd1Xjs6H4au+Iq60qyXnb+I9VTR1dAtImnDpEpbZablBQAjoCctxHc8ap7UbHFAJvKeIVuRTEX0/cNEOU0V4IvAr0Os4COatRApjvijhqDcig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lw1bymA9Th0Yxk7/wXNrwTqzrzgujJQOYIXGatyt2io=;
 b=EGVEkOGfLRyK9y4sGZI0QIkcT/PRncIBwbmik1pcK1kykk69acKMTZoJD5S55n+m9ryepYO3dLuoFTO0/Mndv4ocW/iT/K6pTiafxYJN06En0DL0HT/CdzeQV7lbz/N0Okgueq7fDzn2jZ1mjNapsBVjs5zQo01/W+z6FGGaoxQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8837.eurprd04.prod.outlook.com (2603:10a6:10:2e0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25; Fri, 20 Jan
 2023 14:16:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 14:16:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC PATCH net-next 11/11] net/sched: taprio: only calculate gate mask per TXQ for igc
Date:   Fri, 20 Jan 2023 16:15:37 +0200
Message-Id: <20230120141537.1350744-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8837:EE_
X-MS-Office365-Filtering-Correlation-Id: ed5ae14c-8261-4537-2052-08dafaf0dcd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5MVpiWrzBRDjA0dYVIM8Alz2AV0lelkxoqT5xjgBz+zMJ4e31MDvWCfDeGmaM/ofZA9jGF0bKzpolq0pylvx/M1rSvWy16p9A3PPL3ajIf/ykNBcdJo8Cg8MUF1fP205lLtX0hH+ENo5z/UTND99+n6SaRrjKg+WNU9gNi3FNxnoUco3LYosVPgpdJ63+0szodj+6AQQK5S/whFiF2U4RqsVUfrIr5mNhAcPcCt3/UwS/YtGmxRlq+hr0Tkj54oSX2nXCKiYS6tmyKffB1mdUcXjJDJGE+xfWnDKprOlPFmvwzZLAXjEZyyQOQjpmbtP9PDq4AvLinsOWYW9j4cqQc/emK82i5W430zlqf96SBBvxMHLWc7VJEqopoQsGp4s641eHwMCarNf5KaDLZKse+NPeHaqjK1ioXQTeCwo4/y4XMRFNQY632IyC/BB3QP7nDLnurK128uJ9QMc9qhihVuQ9MwT4LpjVaTABguUvbMcSPR8Vj6NcTTSs/SBMSLDPnQfKNA2afbhF/yMmIuv9TmJLNNRWLGBB3sqdfl3Vep/PU3WzzsJQ2rW3rngC6F2whrQCYfoXp8wYB3HdBlnlnNH3oL/4egz0W3lRhLQABzZFKlNseghwCFrTPyHwpesJ30v1xKUNGr4Of0BT7OzuZVmOK+RUQ1wkoyoacn2+9sa7Qa7TWnOaHnsFl00djoxiMFZ5vKIyaejJZrlOUElveCK847U4ZM2B7VrS8ibkN8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(451199015)(86362001)(44832011)(8936002)(7416002)(5660300002)(41300700001)(38100700002)(54906003)(38350700002)(36756003)(966005)(478600001)(52116002)(6512007)(83380400001)(6666004)(186003)(6506007)(26005)(4326008)(66556008)(316002)(66946007)(66476007)(8676002)(1076003)(6916009)(2616005)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?69DtUasjizx/5g/6YpGH/Xflcrkd/FpKITTMeH+uq8eK8S1pZFzgJaBgnZBx?=
 =?us-ascii?Q?WGaLViHsNFj574HPGsEKRIEV4f7Xzz3gvDqN3340m/zA862+qHmSeDfhOiNo?=
 =?us-ascii?Q?ou1BjW9lPvA0S0jnxITsD9ymhkZ2u6uvViJSB6zLWq8vvmPmtwEAR6kAXc4o?=
 =?us-ascii?Q?v8Mz7GRFenmiTb7ecWzGA43PQSQDVEzz7RCQ4YejoN1I0x55nNXvem0gp+dK?=
 =?us-ascii?Q?KgfDruq+fMpA67lk2zd/TnFCRVQKV4gBPBf6y0S5NxlpezmBAndOpWHcUUBt?=
 =?us-ascii?Q?qrDZP19iJsvNHODJKmrQgycaVSnV3L3HB4g5oCsezJZTb1/G/3AAYLa8MFvR?=
 =?us-ascii?Q?tPU/H9FWFkYjkZJAHOcZz+YIMYMOCb3dx1aeXKKxi/1cJa3H+zcmv4ZB/mhc?=
 =?us-ascii?Q?woikak8FhH1UcP857PA6SF9GOPv/YtIgBJCcodicuvqJqyORVzC08g/mA8Wv?=
 =?us-ascii?Q?XjtIkyYzUgruP/lCYMmhWgGX7cerxh/pR+Pxun6IdY0dhgpnKrwc+snAnbY/?=
 =?us-ascii?Q?o2yrcNSXg/4ElQo9xFALDCHdkInX0tj10JcYfDHjsM9Zhv+vFW2zsfUJ9DjD?=
 =?us-ascii?Q?O59ueGWiV9mbPagBCKdhIgHa0KHXkckQ+rPA0fq+tmmo+MXwPjKs4tRfMtiu?=
 =?us-ascii?Q?Z2ydnFMJrl7TTIXSQv1tKNTX7xh3rKyKzFZ6RNvZ+cN5ILPgM63rkJE4wRkl?=
 =?us-ascii?Q?c1LyNrBvymLQ7uEiiqbsPTpTG0MJwJbbQAOJ2AwsCZEnEPxMX24BeIRJ1zMo?=
 =?us-ascii?Q?gQzF5MLj7h0dUdTirD/1Jn15eO0J3p2H0OskZI2bR8TmxuLWuNnHDor0yQ8W?=
 =?us-ascii?Q?SfO0Fv0APG2jEfZcpfxHdWjuuLl4CX5sfWJQgXh/u+33II/0gSGXn15t6ebC?=
 =?us-ascii?Q?Ci6noQiL70/enFUW1Vox+n60GFBoDzKqolhsdoGxhI4G3cwuSJ7Lrbo1EKbW?=
 =?us-ascii?Q?+VhBMfxBr7q8VMkCzFMtZ+t5wL9Cuk4RVV2SghAiY5JTbWxYG8LCJBEBKvTr?=
 =?us-ascii?Q?/KBW+60WpaYNQfK2q9aU7u4EuCewLSHAPhPMa2QYTn3eSEdVj6sYqutFY3ON?=
 =?us-ascii?Q?3PmjFE+6IJVRxl1BZWNuCsCtDrZYyYMOdJa2mkvuZl5IvhCHKxnVUs4qumHa?=
 =?us-ascii?Q?RrzWirmj47O1BM0a82VDhwriZ+oo8oLvbnzZuXImX7d6yrv1gtUGSsBBd88H?=
 =?us-ascii?Q?dmnx54cnpkIyx8zqLxpB4S5Y/cFgvgkx6SqB1XAXeC35fqCDXCAcf0TkT7uA?=
 =?us-ascii?Q?tahl5hyqPCx+DEEiKQyZ4SYkY66EkmP44B4+yvopIWZAOTo1BL6v3yO06sFb?=
 =?us-ascii?Q?XwBwF7R1pOWqayy238vc/Gji+tiSEY3jL38VZ5Sf8deivqKaL+I/ResVTjg/?=
 =?us-ascii?Q?hG+pGD5oXN2Z/4Kwfyu1Z4NdayXsmpqq3GBRGcyI2ZGVOaRNfGGUA5Tvtm1f?=
 =?us-ascii?Q?BCETFzlNIc8ahB6CxIO+rX6oa9LWIDOKoVcAgT8BV9Wr+T8TeQHKpdmUr8Fq?=
 =?us-ascii?Q?oSBFOVtchaAV/CK66hNPWDoZVou6YBxDC2Fz4Xw6avZtjVo3I6r22Nial5Oy?=
 =?us-ascii?Q?HwyIDdSZiWaY5FmpDbC6deRsuYLeQIk0IEJUfrWomAXOU9fkBushJwNznPGd?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5ae14c-8261-4537-2052-08dafaf0dcd1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 14:16:03.2165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e3ynpgwUz2d8x1MmZ3HiIxoOM9EEmk74Gw/57zOaEdG7diY7kqjY0xWdKFE7QvpP+vJ7rbg9NZKdOsmoqthtZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8837
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vinicius has repeated a couple of times in our discussion that it was a
mistake for the taprio UAPI to take as input the Qbv gate mask per TC
rather than per TXQ. In the Frame Preemption RFC thread:
https://patchwork.kernel.org/project/netdevbpf/patch/20220816222920.1952936-3-vladimir.oltean@nxp.com/#25011225

I had this unanswered question:

| > And even that it works out because taprio "translates" from traffic
| > classes to queues when it sends the offload information to the driver,
| > i.e. the driver knows the schedule of queues, not traffic classes.
|
| Which is incredibly strange to me, since the standard clearly defines
| Qbv gates to be per traffic class, and in ENETC, even if we have 2 TX
| queues for the same traffic class (one per CPU), the hardware schedule
| is still per traffic class and not per independent TX queue (BD ring).
|
| How does this work for i225/i226, if 2 queues are configured for the
| same dequeue priority? Do the taprio gates still take effect per queue?

I haven't gotten an answer, and some things are still unclear, but I
suspect that igc is the outlier, and all the other hardware actually has
the gate mask per TC and not per TXQ, just like the standard says.

For example, in ENETC up until now, we weren't passed the mqprio queue
configuration via struct tc_taprio_qopt_offload, and hence, we needed to
assume that the TC:TXQ mapping was 1:1. So "per TC" or "per TXQ" did not
make a practical difference. I suspect that other drivers are in the
same position.

Benefit from the TC_QUERY_CAPS feature that Jakub suggested we add, and
query the device driver before calling the proper ndo_setup_tc(), and
figure out if it expects the gate mask to be per TC or per TXQ.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 17 +++++++++++++++++
 include/net/pkt_sched.h                   |  1 +
 net/sched/sch_taprio.c                    | 11 ++++++++---
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e86b15efaeb8..9b6f2aaf78c2 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6205,12 +6205,29 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
 	return igc_tsn_offload_apply(adapter);
 }
 
+static int igc_tc_query_caps(struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		caps->gate_mask_per_txq = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			void *type_data)
 {
 	struct igc_adapter *adapter = netdev_priv(dev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return igc_tc_query_caps(type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return igc_tsn_enable_qbv_scheduling(adapter, type_data);
 
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index ace8be520fb0..fd889fc4912b 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -176,6 +176,7 @@ struct tc_mqprio_qopt_offload {
 
 struct tc_taprio_caps {
 	bool supports_queue_max_sdu:1;
+	bool gate_mask_per_txq:1;
 };
 
 struct tc_taprio_sched_entry {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index a3fa5debe513..58efa982db65 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1212,7 +1212,8 @@ static u32 tc_map_to_queue_mask(struct net_device *dev, u32 tc_mask)
 
 static void taprio_sched_to_offload(struct net_device *dev,
 				    struct sched_gate_list *sched,
-				    struct tc_taprio_qopt_offload *offload)
+				    struct tc_taprio_qopt_offload *offload,
+				    bool gate_mask_per_txq)
 {
 	struct sched_entry *entry;
 	int i = 0;
@@ -1226,7 +1227,11 @@ static void taprio_sched_to_offload(struct net_device *dev,
 
 		e->command = entry->command;
 		e->interval = entry->interval;
-		e->gate_mask = tc_map_to_queue_mask(dev, entry->gate_mask);
+		if (gate_mask_per_txq)
+			e->gate_mask = tc_map_to_queue_mask(dev,
+							    entry->gate_mask);
+		else
+			e->gate_mask = entry->gate_mask;
 
 		i++;
 	}
@@ -1273,7 +1278,7 @@ static int taprio_enable_offload(struct net_device *dev,
 	offload->enable = 1;
 	if (mqprio)
 		offload->mqprio.qopt = *mqprio;
-	taprio_sched_to_offload(dev, sched, offload);
+	taprio_sched_to_offload(dev, sched, offload, caps.gate_mask_per_txq);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
 		offload->max_sdu[tc] = q->max_sdu[tc];
-- 
2.34.1

