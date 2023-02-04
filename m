Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEFA68AA63
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 14:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjBDNyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 08:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbjBDNxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 08:53:53 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA172B29F
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 05:53:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrsM3tlAlpsH/BvDOKMfsNqeUt2Hs0nm237xgr7yXg3wAad30xNbMHeF6sR1zOk191HkEJHWspXdAbp3cpbTJjxq1LWGIGJMPcd38K/kO9bnJw4L9OLIABh1/T7i3sFbUz+DWYnAaT/S1YrFfN0sFWIwl/us0Xr6P7efYZLmdm+hI2hGGkNg9kaFno8hyGGTm4sSw4r1JxwAArtI8T4K1yVngIKrEFav+lwrze0R+acAz/LHckZNdOBN9RjK2XOxs8CNSEke6ivknIcO2a+TnZ9Uy9+NDqGtvav2VHIiH95UGKTc5Q/YqZF3PcmmDuUnnxtZYMBP1eEwENcihbsXGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nM5373owzpfIS6CkhVu0xYHFFake2BpmMqiTF1R14FE=;
 b=n5MRg2G6it67PavCtGGx9iNzdZ42/gyBBTY0MYIJKemviiIKWEQf4mlTLUrd1Kzv7jqQChjL+7i3RdcB8uGLfepZakHRg50y/qs1/eKkn0P7HOY3diotgVpbv843mc9LykYGYi60Edtcs1/YlC38B03t/CIURlbiGjNDJg2raWAhdAU4e5u34PPNyOvCDhMg46A6onOUiWN9tUP9QlzAKNM73DRi3Qeb5dC5CCjT7u5LlKILPIlmvv9iz6DtNCkVV1XhU6fYrLMtBzAC3cQRPOVvJPxC6ihStvbbIH7kjYyMLQEHNPtSshxRT5H8vrwuH44peImcmZnPvnNx6HymLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nM5373owzpfIS6CkhVu0xYHFFake2BpmMqiTF1R14FE=;
 b=YQfdMzA1S6QHobVXUejLBRZsTupLkCyjs5Tsy+ovWXWrwv9DX6UxVi72vCbNyY/i9ggCo+msLCsB7OtRM49Yw3Ygor2wZZeMaGrtG1UGbcl2r1iL7lZUpXCP26Ye8DNRP+mueb2eSWuOELWA7cmIymR4797PF/w9Ce3DqBtjQyM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB9047.eurprd04.prod.outlook.com (2603:10a6:20b:442::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sat, 4 Feb
 2023 13:53:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6064.032; Sat, 4 Feb 2023
 13:53:36 +0000
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
Subject: [PATCH v6 net-next 09/13] net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
Date:   Sat,  4 Feb 2023 15:53:03 +0200
Message-Id: <20230204135307.1036988-10-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB9047:EE_
X-MS-Office365-Filtering-Correlation-Id: 53ca27a5-602e-48bc-2cb7-08db06b73685
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4MhXUnFZvA5fILCVL3rwKPiy8hwH9Zpa/yXWpxiqQLHsCwAPd8LTi0pDa/tpoBXlEyI0GJ+zTKu3ZVuMUwyK81sc88lYTZ0CIPXV+189bYAaHFKHpH8ES4K9lOZvGEkNnm5XenvV3fMgkq5UDJgmlT9lL6dNEcngwztaj5yFy7NwfdMGqKab4QQA+Tk9g5Q1kz9MWTl3tsTUDsNNNxu0RTZvGOjFTB/sACDmf8Z2ndh2v678gf23U58eWZbl1olGbXmdKYFLjcAY6Dcdga8jbgg0iu7WfpsgvL0Y2bR1h2SB6kcGlUrJfudo3nyGyQ7gAUOMoXd+B8IXPds79xhvAb/9znkmOkXc6HE3s5fDiznX9lvA+ZKml1HYujb8M1qIXHEvZidTtbE9CZjDxp7HI3bu0b3TzG6cgxQuplvYVFlelZ/3fKLmDWZwDvCh0x/e2AhTOFnkG/RxScKKTH+mbvwhOYA415mp53oQx4ZTuTl6Gh5sTWQ3xlhJZqjus+epYn54VqlOoIVfG1bWL4TyKqjmYw+uNP2+RnjNwpliok213RkR3sG1nm2WJIpIN54jsF/pfb5Rabe+eI7wMPO7NCQLfSZld+hRvIP6+Vtq9vjnDQuOviSELxwlzj2KEB7uwdzo/UM9232sbuQV0sIsVprISKK8Mc5PRIxmvINNbX0perrjRamxaJ2k0uyylo5IUyNBn6tX7LaHztieW30Jtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199018)(86362001)(36756003)(38100700002)(38350700002)(7416002)(41300700001)(4326008)(8676002)(5660300002)(8936002)(6916009)(66476007)(54906003)(316002)(66946007)(66556008)(2906002)(44832011)(2616005)(83380400001)(478600001)(6486002)(52116002)(186003)(26005)(6512007)(6666004)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?inZ4mXMVxkBX7tqGW1u0bpY/HvTRmN6O5d6oddoqJNhiGsK8gjhY7UkIWzVs?=
 =?us-ascii?Q?yGNH8fGfAffuLoiEpiRT+0wS78eRVuzblg75InYfrPnGAOLA7e2MoMUW44i8?=
 =?us-ascii?Q?TuDgJsfPFYFC841Ii62KYN46JJGuLlZZbMl+dEO0PnfxI4N8wnpg8uKKG4uy?=
 =?us-ascii?Q?7AyvJ4P17dseJHZJ25+ayYaSrvGgFLvHpXo6TU9q1RSUyqhYFfULR4jukxta?=
 =?us-ascii?Q?aAlC18ao228mLeF6+EmSWUOAwuky52zK2aJEWkR4VOw8jBqzTmfwFKSy7Mx5?=
 =?us-ascii?Q?7iluJFRWMwVGhlfblZRu9BIu7aa7wE2HyNa7UgkWIuXi/ILqvIDoPrcUM/DL?=
 =?us-ascii?Q?wRF6dX0iOReGMgFOElHN+s4PeB2WRFzSrc+t2Hdy/xKpFJc9gNjqOxXrJw02?=
 =?us-ascii?Q?G07Uj9BZMc4zJq984kYXEMsJ1xPz0u3hGdWzN37uwzeI3cLpg8YhF3Sdco9y?=
 =?us-ascii?Q?Kypd9OovelsHqW2IrilmPyw1nPIBzfHcERyxEPkwf8OYb04xSbe/vj6vfiex?=
 =?us-ascii?Q?dbk9K+FteQzIQRa7U7cahcOtldMq8aYwlJBze0t9BLw3FP2wa90xW7iVKqos?=
 =?us-ascii?Q?tdouuttaIDq8dla205H1SbMMOdBM0GT0by/OjznU9XGqBT9Yt2ZShYAmW7Xz?=
 =?us-ascii?Q?8/0Rsqq6yW/7dNVbdKslzoDmHmzMu/uUJBqX21UY/zvmZvwbUquqsyoF8w1S?=
 =?us-ascii?Q?Fi3anEAPrujQBxyAaWrmNQZwmU0S4JV0EIbppRUAs0wjVyaAmjn9plRKr+Kd?=
 =?us-ascii?Q?t83Ma/XeWMYhwq3AmbHYKDdQJK62xBX8HLp/LFJ7ZIxDDpPFFc5iYV6mxqyS?=
 =?us-ascii?Q?1+FBKHMEI4zgakAxIy22zlYvJNM1OeXXMdsTbySYGgtRyCAcgkNVnCLQTf2A?=
 =?us-ascii?Q?nNODul0clVHXxThjUDaGkVeKM109QrqlWQTkKlhvhm8mNNldQ/46FOT6BKS+?=
 =?us-ascii?Q?ZEdS3Ea77Z9JgmtqDQjUYkMCFu9zD1tAT7Glz3NzS+FjCZjmxKxRKghjeBaC?=
 =?us-ascii?Q?aXSemhtti6T5fqgb+AHnisO52QCkzf6OcOesIPv6r/aX7KpHY9O+AOwSXbfd?=
 =?us-ascii?Q?+QNsXYpUFmB15mbZhS+TI5LMtwO6WkD5dJlDnoA5z9H2wrso51ndt11r/ppZ?=
 =?us-ascii?Q?73aUPKfI47sRb10vkE1vksqNX9cQFCMuxUsBzGiHss775yOayHZrOwif24i4?=
 =?us-ascii?Q?s0raOOjmgHHqh8gCF1lYpql4hLfhOq/umVolcNQdcsMZV/diGrnr6SacduHX?=
 =?us-ascii?Q?kWel5O1hUlsdCrOuGaVDojoylutpuLrh5EGj1uaoQH/QrDbLloGT/MBB2ppr?=
 =?us-ascii?Q?9tizmsbSZwP01mobiJ0BJxNk5lroP9gljy4DPPymnH0hvTwR6y+OU/ChIfts?=
 =?us-ascii?Q?E/VrFoZIymP8bA9/asXtcyHWl0ZVmbIFUd21BtQrMX1XsyDDgiJLaG0sqzRc?=
 =?us-ascii?Q?Or/xhEWglwO/BhehBnqEnUYKnS/BSTiTACi2vz6qdVz2HEf7RI9glAUqRv9q?=
 =?us-ascii?Q?tcwp6kCqP2r4wDMj3u7sfSBU8MEp5SrcOAX3uoOa4HixyUBWIS4WWU//XCuZ?=
 =?us-ascii?Q?/qD8JjMH2qv9IfXpFDe0dleQbqR/bsajUtkAUccp3RwPPpjAekkiGljXJzqB?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ca27a5-602e-48bc-2cb7-08db06b73685
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 13:53:36.8723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXqaBlgO3hut9gyoVMQDX738q4qCe7Vw0gqC5avEYcdbiqzKVdIVZ311H0xa6xgJGuFTJClZR3wBYcKUkM7SCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9047
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The taprio qdisc does not currently pass the mqprio queue configuration
down to the offloading device driver. So the driver cannot act upon the
TXQ counts/offsets per TC, or upon the prio->tc map. It was probably
assumed that the driver only wants to offload num_tc (see
TC_MQPRIO_HW_OFFLOAD_TCS), which it can get from netdev_get_num_tc(),
but there's clearly more to the mqprio configuration than that.

I've considered 2 mechanisms to remedy that. First is to pass a struct
tc_mqprio_qopt_offload as part of the tc_taprio_qopt_offload. The second
is to make taprio actually call TC_SETUP_QDISC_MQPRIO, *in addition to*
TC_SETUP_QDISC_TAPRIO.

The difference is that in the first case, existing drivers (offloading
or not) all ignore taprio's mqprio portion currently, whereas in the
second case, we could control whether to call TC_SETUP_QDISC_MQPRIO,
based on a new capability. The question is which approach would be
better.

I'm afraid that calling TC_SETUP_QDISC_MQPRIO unconditionally (not based
on a taprio capability bit) would risk introducing regressions. For
example, taprio doesn't populate (or validate) qopt->hw, as well as
mqprio.flags, mqprio.shaper, mqprio.min_rate, mqprio.max_rate.

In comparison, adding a capability is functionally equivalent to just
passing the mqprio in a way that drivers can ignore it, except it's
slightly more complicated to use it (need to set the capability).

Ultimately, what made me go for the "mqprio in taprio" variant was that
it's easier for offloading drivers to interpret the mqprio qopt slightly
differently when it comes from taprio vs when it comes from mqprio,
should that ever become necessary.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v5->v6: none
v4->v5:
- reword commit message
- mqprio_qopt_reconstruct() has been added in a previous patch, to
  consolidate existing code
v2->v4: none
v1->v2: reconstruct the mqprio queue configuration structure

 include/net/pkt_sched.h | 1 +
 net/sched/sch_taprio.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 02e3ccfbc7d1..ace8be520fb0 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -187,6 +187,7 @@ struct tc_taprio_sched_entry {
 };
 
 struct tc_taprio_qopt_offload {
+	struct tc_mqprio_qopt_offload mqprio;
 	u8 enable;
 	ktime_t base_time;
 	u64 cycle_time;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6b3cecbe9f1f..aba8a16842c1 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1228,6 +1228,7 @@ static int taprio_enable_offload(struct net_device *dev,
 		return -ENOMEM;
 	}
 	offload->enable = 1;
+	mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
 	taprio_sched_to_offload(dev, sched, offload);
 
 	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
-- 
2.34.1

