Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFB3C68D9F5
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjBGN5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjBGN50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:57:26 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7292638B58;
        Tue,  7 Feb 2023 05:56:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKDzYRhs138UqZmNCLASGdPWI8miSkb5UBae6xJeuOD/8MLVlg/9yKRp6f044SIp/qhuJWGv+1kZYPtiMQdxr9eH7gYDHOPY3p4pdqxUyZVdePH+9acNWRGHcNsfz83frVRfBVzJ0YsgMHsb5qJCBtEL4NNw0N1uk+Q4cGUNW9R2EQLYKFKcPoELWxqqdnlR+LmE4zO9G42++orgb6yX96LL6VWROyYXtjwkvyLdlQZustzRJL7Gt/ZacvZPOGl8Ax+Dm4NX1jAUf9tksd/11dLLLRUQdPPReldTXPhbpHzPk9GSucNwRYCZjsQ2ypBqZzS4Nqre9nqgk+r6DH6gfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yS3NFUx8nuK7XC2Esse+57Ko9xwMEbc4qNSXxpQsgDM=;
 b=gIicsbrE2UGj1O6YdaHxu2anyvzLxYjHB626rW7tsogKpEhNlXKMp+Cg/fclkcju5EZKaz2rSIKsloj/ha6wlBjst0nzIVfFUtLiRUvdt0c4J3AVeOpyRwkD9S2llDZGlsCugnHSnXsEPZVpMNIIWEUfZjOa/9dXytQJjjgeBzJ3at+ECCiRr1crDtdI/+cS628xPSR60r861GunEVdDyjlRMJnj6GYOXpRDNgrzHPaso6RkIcYIDHSBKNmhSWFwRjHi/P8bDnB8iKkkTWQQ1mW1/juf7pI954ysSh2M8vopTzRVoLhXjDJzFwv6GhAyMYlU6MLUIYFEQH4dbRmCJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yS3NFUx8nuK7XC2Esse+57Ko9xwMEbc4qNSXxpQsgDM=;
 b=B9u4CiZJwOisqRkT9iq6GpSdM0LrTzLL1y68cRxjJ/82BgGj94W+lgMSitGvUhqDJTIurqRTnsmtF9z4oJDvoTUKcbXFqOS2c136XkhzmOk8+IUQX91LVXr6mRShb9Wwd4yAYsHs7ReJoI2yKNp9wBIyw1Zwe7rrPdMpwSDUpWQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8115.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 13:55:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:26 +0000
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
        Jacob Keller <jacob.e.keller@intel.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 11/15] net/sched: taprio: warn about missing size table
Date:   Tue,  7 Feb 2023 15:54:36 +0200
Message-Id: <20230207135440.1482856-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
References: <20230207135440.1482856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0023.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8115:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c9799bc-f1a5-4394-a507-08db0912f6b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YhnU4zjHr0M9YJCFN86hgEWdIQ5AeK0ftZlkKq/qzbh6dedpoJO8s+OrXTbHaEzklqMji0dYgmbaG7UhtH3p1gSNO9BEDJu/c6oLIkoQ6EkKMn6XpHvG4pwGU46s/29f5u5ID9zol2s5QK52ubCN7D+DRgzpRTw0rsrLOV2oTnKHHxN+4iaMx8s/P6uRRj+r4TpqI/rGF9zULXSRHkiWbxA2NUKNg2W3BdvAZx/ZVxuuEoQsmT7TOl04H3l8eLAJSFLs/glpO1iHP8XWcs/HS31B5HLN0fRkd+UysumFY2594jOgIfUgZBS5R7/6iiPPDf/yOt92biy0bO59JV01dEE7Y1Zp90ASPrervIDdyaOJAuaO/RZtXuV4wxqnh1KGgoIV0SsQlLf6oUR97MP3Q4wxr5y+zk40R3jpK9f6Vxvx2/lA4vgC//UwxB8SzTBTuYQDcJ5D6OzpaHZlJHHbS5uobXKdOAPV+PHbLgXKak8Aqz1/vWM8R0DfSW2Vqhpm01VEeMKHKPTWWOiAmB/bMnSLMe/Awbcrc6xW5Tx7/T46wabHq036UK145R8VfbOPRaPs38WbcqYBMKB6fGLIrGSzG2PRqlmk1bSz5vqq0kyZqZ9Weh6bLeaJ3OE5z6QcTF4whDRs6ddOQXH9s40fubg7ta9Lfo3MZcuzk3kBjlhf+Ui30JtnsZipgOCNB0YABZ9l+bgAb/y2ll6YBtx1LXJyH7lhXAzfVmih6/E04mE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199018)(2906002)(8676002)(38350700002)(38100700002)(316002)(83380400001)(6916009)(66556008)(66476007)(8936002)(4326008)(41300700001)(44832011)(5660300002)(7416002)(66946007)(966005)(2616005)(6666004)(1076003)(6506007)(478600001)(6486002)(186003)(26005)(6512007)(86362001)(54906003)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VJpVjM60XDJhUiuw72BZsmk7KZ/LJeMt0kklj/8TehzFRbyq1XPdQ90V22FT?=
 =?us-ascii?Q?+NHvM6XEI4120r86EmoT3OzeT/3Iq036etGHtX8hJneNQSNtzUfzMJ24wv+n?=
 =?us-ascii?Q?62OIk6uYnSDarJDTY/vZjImRORqe+BYVDtNLKubFXYapX+SNn9LH3MoWyNQX?=
 =?us-ascii?Q?fY9RYYDXni1SuwCtOVT8w7oJro70D1WpinMAqvxTtFZU/My/ivRNnkzfyV94?=
 =?us-ascii?Q?0eyJiLCIRCQooefM8BTKKtgVAJIJ6VqsrhTF9esT4y36YyWpcZU64ZxjyQoS?=
 =?us-ascii?Q?FqNZ208Oh9bHYXGZet7AwJLp2nzIuIoVb1R7HYB9/sdxhUb64WJMUanMQnrS?=
 =?us-ascii?Q?ZdgBL477VJJZjxK2sDjeFlQFPGzn0cYoaWh2nTBHJkQxRmw5MkUZxqrvqTYe?=
 =?us-ascii?Q?sYTUFRwyOAe/bl3VDJ8B6KPic25doLPLLvW7cRMfuyOTkdwZozyop5zQsGVP?=
 =?us-ascii?Q?oPNq5/RbFpyecS3e980uojS/+NJNVXj5NYKGIFZ3OpNWRRBEOuQk7CUGEJEn?=
 =?us-ascii?Q?F9wfOD2I7VrNFDhZm3x6BK6OABDlb0DUFwbhnyszZCB+LL4f5mtz6Eif556U?=
 =?us-ascii?Q?Emx9a5gFJ09TVNfE7tQNn1yobx2yufW0oB/myqjUb2icJxzipWYlohqK/pf6?=
 =?us-ascii?Q?rUxrGuKivzo+RZv65bmkrJTuy3iuNTx0yIS2LR76hkSThmQ5D1Pe4G5/ujH3?=
 =?us-ascii?Q?eVZCL7ec1F5Xs3mQoYA2hgYr5P6pspKrufOzlGjcVXhoVYnZaYswP4p/MEFb?=
 =?us-ascii?Q?FQwsC6EVI9QXhs+mD21CzUG770ivnEd5TjHUSWQtYXUh/zUu/MqHSgZ9OIDM?=
 =?us-ascii?Q?wKIFkexHsE4F0/UoxFegbSF2JK+uNItFiE7dqReHkhiPYm6EgSAEd53QgGHs?=
 =?us-ascii?Q?TQ4uw+J1GFMId05qQWNogHVogwtPySDnCPZbPbtOz1veoHRQo9o97U1Olryw?=
 =?us-ascii?Q?P10YbAJ8/5ae2aCqCFwNHk65LbXEjEbO15bFUk7WQpMxscaDUM1Y3fKJiKib?=
 =?us-ascii?Q?xkuMH9vunBcAlp/3FfWUp1TMw7XJoS1CEhSsT8Wdm0Ro3wZGvtxz+Vujd2Sn?=
 =?us-ascii?Q?9JA5aomtBDPhs79k65id/LcIN5z4LFJBWP1EoLi3ZvZyUv98JR6IwrGn9eBU?=
 =?us-ascii?Q?k8P8wdx62rlH5q84ctCaLWxnok86eFF74ko/dZTl712wOC5ARO/sj4o6Veor?=
 =?us-ascii?Q?yf43b1R5qSbXrwfDSKCKIuAW2bMTfO5L2N5NBupD+u6dl66S0Nj0ubkxKbR0?=
 =?us-ascii?Q?mgnIXmV+mNE4q7dGYPOBJHB8iHQxfqgpq2tTQAXneZkXZeEntvl6BYTWSV1Q?=
 =?us-ascii?Q?PQ3bcjM3SVjT96Cwds6WR0VZ5owutcEvcg6uYq1dqMDprF3GfLDla1NHjk8C?=
 =?us-ascii?Q?Iexb4crhIobpSONU4SUfqTOaKgWy5fdGRVpmZERTFdx61kUnVJ+L+ZIxvvvh?=
 =?us-ascii?Q?/ufVspx2DmmFh8eaYnXxkR/9wi1urO97T8GKd4K04yF2L4Ahgay2bxJPKv7Y?=
 =?us-ascii?Q?AHSgJNkJCS2J+XmdOer4o48aGKbUG3mvzRKFcEMfvnSPWcdu/a5JHdORAppt?=
 =?us-ascii?Q?7+M9LaChrrQw3WShtcjK3FiWAFD5oMaWbCZMG60G5o0edNoZK+YuAci7lobL?=
 =?us-ascii?Q?TQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c9799bc-f1a5-4394-a507-08db0912f6b1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:55:26.1736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TbebOIv0mmTesOxDlM3rMW2NwwlCmiFRkkEmXUDxGQIUV45RPquIqAiolsEFq0KkKqKRZdUutpTq5qLADlY0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vinicius intended taprio to take the L1 overhead into account when
estimating packet transmission time through user input, specifically
through the qdisc size table (man tc-stab).

Something like this:

tc qdisc replace dev $eth root stab overhead 24 taprio \
	num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 \
	sched-entry S 0x7e 9000000 \
	sched-entry S 0x82 1000000 \
	max-sdu 0 0 0 0 0 0 0 200 \
	flags 0x0 clockid CLOCK_TAI

Without the overhead being specified, transmission times will be
underestimated and will cause late transmissions. For an offloading
driver, it might even cause TX hangs if there is no open gate large
enough to send the maximum sized packets for that TC (including L1
overhead). Properly knowing the L1 overhead will ensure that we are able
to auto-calculate the queueMaxSDU per traffic class just right, and
avoid these hangs due to head-of-line blocking.

We can't make the stab mandatory due to existing setups, but we can warn
the user that it's important with a warning netlink extack.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220505160357.298794-1-vladimir.oltean@nxp.com/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
v1->v2: none

 net/sched/sch_taprio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index e625f8f8704f..7553bc82cf6f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1690,6 +1690,7 @@ static int taprio_new_flags(const struct nlattr *attr, u32 old,
 static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
+	struct qdisc_size_table *stab = rtnl_dereference(sch->stab);
 	struct nlattr *tb[TCA_TAPRIO_ATTR_MAX + 1] = { };
 	struct sched_gate_list *oper, *admin, *new_admin;
 	struct taprio_sched *q = qdisc_priv(sch);
@@ -1842,6 +1843,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	new_admin = NULL;
 	err = 0;
 
+	if (!stab)
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Size table not specified, frame length estimations may be inaccurate");
+
 unlock:
 	spin_unlock_bh(qdisc_lock(sch));
 
-- 
2.34.1

