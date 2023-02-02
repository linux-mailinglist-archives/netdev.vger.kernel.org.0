Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FE0687263
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 01:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjBBAhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 19:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjBBAhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 19:37:04 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5334973753
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 16:36:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fjtv8IZCZOH6BfC7a5JhoAV+U5BjoOnwhlG+2zmRbyIKIeENtZnepjbMiSKFairWqQ6D8vWqA1MNZUaTifztYN0xyadNa4fkJCoC7WOuGLgSpsmqX7FakSUiiJtmVzEMn7nwpSPIW//I9mAOUdU2doe0XHld7I3EAsEIwszkaaUPBD283jiSHj+IXmwTkfglhODZ/JdxV/dtMlBrLTcLsLnFX4hsJS8phwS4XzqAW403Qvm2DqiPFwmdgsEneg5Rwpe/WA2+T2MckfuHfVS8bo7t6S+IvdyfDgVX3MvAvfgF5fqQeNpC05PswgLhenQ163D9vHu1GNi7uG9huoNrWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTzQbQ/RGwzZ/YqnqdMqI1okfDA1OKEO4RIJiq52XPA=;
 b=cayCb0u9TYgkJru4lijvTZiyOekD26wMHG2tzLKAhhDwjm10Ci1VFNRgvOX4cHnEpPY0Gi6kfxuMU5LIN8X3I/0nSTDhBc/NJERGvJvV97Z0ZVFyb2EUfDKBqqIupKhEw8SlxC5oV7aLrwoFBRcViOlg2rtcM08qWIbV+XyMdDn6OAKAv6i6IawKfct83SAmLpEKjjdmE6fp/yKLlRf6nl/+7AnsNAG3bbuHKCk/oRYIocDdEnMHRejUPP8WkLEP/uYOFbUUKckfSc+oCqXMnjYbjmr34E9ceN/bGWdb/IbknO737PO7G/U7z3rjaR+upYQWxK4fqWtfCycVE0Y5qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTzQbQ/RGwzZ/YqnqdMqI1okfDA1OKEO4RIJiq52XPA=;
 b=hw0WZlkpA4QzxdP6dOXI2ltIkbW8I6KQvXh0wRr2nge/IdlizYBwBpv99H5hVTH8F0XPko1qUOpGDZC08Zms8fIim8Qndb96AIyEftdoKXo9Lo5SnRv6UC3bcQctiWbMHnTYHpIS2fh7PLe9wV62edC179q8B4gWPmJWKQkT1Es=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8789.eurprd04.prod.outlook.com (2603:10a6:10:2e0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 00:36:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%3]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 00:36:55 +0000
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
Subject: [PATCH v5 net-next 08/17] net/sched: mqprio: allow reverse TC:TXQ mappings
Date:   Thu,  2 Feb 2023 02:36:12 +0200
Message-Id: <20230202003621.2679603-9-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: a9099e56-15ca-4179-8b6e-08db04b59582
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wjsm1E0P/beOjFbcVZbu02LABCtCX47xSSiCCVHswywXCBu7Bnd/O3XhQnu6fLfsKzwfSzzZ/Ne3IT6winDFoOCg8CjhwtU+F8zkH49et+TXeVA3PdVLMgZrVmEIx/4xbmoWPI0QiTrSA3BL0Jrm/xE4tclldcoz2o5+UcJza92UhVx/LnMvfRxpcF7JPR1vT4Mp3KCoub23WtrPDRQ8qg0DIciLIrKr8R7tH8rSPXWYGgeqHwHXqhgAg/wgS13yxsOehkgoU1iKo2E2UQZMG9O4/sMMshNH4FxZhFc/eQxMsjbxHCDWNvCzBhPwtqmzj8uvrKbFVxWmhXlmG33Qe7D9xCd3B9Y4m6xwuN9TOSer3ZxuxvBk2yMim2H1PNPJCQe5saVrncU5/ADuGAOFSG4hne1aAoc6UqXcomxknyWvwhyf0XaDAI30GMCsA86QwugeH4xiOuuKlDT7RXSakCevsurIvrrRFQbXGSTtc2d46EdoZ8k6lE2OHbbP976VrewDKzjyJaCzcqD238TAnk5NJNhMQmVcA5QqJ0XeG63VEu3H+pnQGu2T5VNsZN057ZK3l0FtO2gRSTPoDwtkWZ3nnJQd5OOZwAMBlbPf1l8GQ/o+GvLGdFkGG5BN/5/vQsDRC8efkoj6WgbMdyr1L0a9q/chWZ1ig8JFE/ge8zUPlxC7uVyEaKgAkzDeubOi0k3HIJ86ylKNHROy/T9jrUb/on9Yha2tpObOBDBne9MrO7+umRqNnjsJk6+y9/MVFPectewj9n1Gf6L59hg7IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199018)(36756003)(2616005)(7416002)(6666004)(966005)(52116002)(478600001)(2906002)(6486002)(38350700002)(86362001)(38100700002)(8936002)(54906003)(1076003)(6506007)(66556008)(8676002)(5660300002)(316002)(6916009)(41300700001)(44832011)(66476007)(66946007)(4326008)(6512007)(26005)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kxWe4lcC7XqUyTHylteszSeAxfVAxog5riOxwXqcyqWRJGwscss4AEnqZYeO?=
 =?us-ascii?Q?qPIX/Eb498jkr75JZfvuznSOrdWuroWGtPcBnWxvCe3a+DsZbKkQyfy2Yw7W?=
 =?us-ascii?Q?eIS/l7KI7UXYDVCmySeM4ntX/Suhq62i9UR5GFfTgpM4gSdZzhOf5CXBzek1?=
 =?us-ascii?Q?EYGp/hnOB9+Yc2J4AuIVP6kviO0PGTH/FFyUideLK1+ZAMhGjadms/9b2kd/?=
 =?us-ascii?Q?6KXKpbBdaGiof8Zn/eoRefxTuwxmVGg1ImrbmleiSdEYUZWquUvwP4r5MzUb?=
 =?us-ascii?Q?trdPdYE8LUPOF2+F+/q0G7HLeGLwrDCJwlFYuNsOYFTSBbgP/FIcWpg7EH6x?=
 =?us-ascii?Q?fyG0CiDpGF5c99qiuAblbmxwwrGVNPMyG844XFtelQGnwxyIN/vzqqDi4sm5?=
 =?us-ascii?Q?BL6klTo/atRtwc7YvpPaeWdq48xiwtNTGysOjS5mUDn5PuGhI+Ysd1QXHcM9?=
 =?us-ascii?Q?kNKqrB4j0vAzcvUNlQwtbh28l7GYNtetmL8Vvtit8a+NfanWjT3d0yrsIQne?=
 =?us-ascii?Q?jLipwWcZY9VO+gb75z0H4G6VIMIk37s7OyxcKq5KREwY7XIW3uvSzJxgJGY2?=
 =?us-ascii?Q?bvLU7JQ44U+iMwd/SvaucmcLFyhjMwV0tngqIqJipt6J7oOeR1AHpotlpwcd?=
 =?us-ascii?Q?B0yx7lyjqEeWVwsJi/Y1Q0KV9M6703GB+j60QpEQGZY6AVUVd4eqqyPONPIz?=
 =?us-ascii?Q?BdYt7SC4EUKHDhmvUw6HNbWTeIIr/SEMOIYbGLK5L6DmfoC/xe/j4tlgvSFm?=
 =?us-ascii?Q?oHdMZ1/asZdMBgJkyKUjQ1eFXz3XA/l+rxvbsT0ZRLVN/BMKpX5Sm51JcUmF?=
 =?us-ascii?Q?zUCjn9te04Lpoh0Sb/vvhY2X9iX6Hr1thPwY2+1++QaArlKzmgSINjC5DrAu?=
 =?us-ascii?Q?MUHPh4a3oN2itZqVXopH9qRJdTMzlOwHHrZJqEr2Sf9MlN0jGOuD6TD8tJLP?=
 =?us-ascii?Q?97UUAEv8b7LIhfMkX3E3Yafc1hnTuctav5TOnWHS7VVsTwRnhomgvfnyy+f4?=
 =?us-ascii?Q?lzKiIJDMT6KUsXLtzAIUpAGCRIrrNCJ6Y595yiDy0Ol47ULc/uqIWsWns3LE?=
 =?us-ascii?Q?PFtfY7IZFZDT1jd1VTJckrlz3JW/yEVLOCw80UW3ztRC5LmAU5ZlYQ7wNqcr?=
 =?us-ascii?Q?m22FYd14to83EpxmEMD66rxLOArr5IumwPUGJZHBhSg8piCtqCk7IKNmGxI5?=
 =?us-ascii?Q?8XhmyZY6phrauBU4NKIGTK6fXL20bqg1KMsE653/VtjkkUfE346aPH0kHllq?=
 =?us-ascii?Q?gChZEEo3+UKJMIBTusV8Usb8wWs2TzZsVfhC5monlU6Jengyfmywi4uDBU0d?=
 =?us-ascii?Q?NF/QAkfmgUs+J9Kl3/fVw+5xxqLTjcmyM6AGTidquwdi5h03cQazvr8adeTp?=
 =?us-ascii?Q?MGgCbw4Vhyf+5tSCr0/FH8+lHEEf5i2a3LisrQmlIhTy93Rk63yq3iuchgNa?=
 =?us-ascii?Q?t3iTNpIDqJDUXcYgVpJrH1584uW4xGx9D/2FXeyWtSGcDhFe5C3aWw4W2qDJ?=
 =?us-ascii?Q?Mwq7KeJlT/X+ghzAiBhyCRLw6TzUSiUgewB26JDuSFhWN7xAgxLVj61RJM8S?=
 =?us-ascii?Q?Eu5zjbc6yNERqM042yBCrXrMT6eBXqplAqayafsaMeYtYh+ptvasutRMGp8E?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9099e56-15ca-4179-8b6e-08db04b59582
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 00:36:54.9977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fflHExwT7ZPSPXh9aOKqj6dx/RL3jZv1sZtt99Ka2SsH96fmZmW5RxdS926IfGjGhoKjiTyUPiYKFRwR7b/wsQ==
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

By imposing that the last TXQ of TC i is smaller than the first TXQ of
any TC j (j := i+1 .. n), mqprio imposes a strict ordering condition for
the TXQ indices (they must increase as TCs increase).

Claudiu points out that the complexity of the TXQ count validation is
too high for this logic, i.e. instead of iterating over j, it is
sufficient that the TXQ indices of TC i and i + 1 are ordered, and that
will eventually ensure global ordering.

This is true, however it doesn't appear to me that is what the code
really intended to do. Instead, based on the comments, it just wanted to
check for overlaps (and this isn't how one does that).

So the following mqprio configuration, which I had recommended to
Vinicius more than once for igb/igc (to account for the fact that on
this hardware, lower numbered TXQs have higher dequeue priority than
higher ones):

num_tc 4 map 0 1 2 3 queues 1@3 1@2 1@1 1@0

is in fact denied today by mqprio.

The full story is that in fact, it's only denied with "hw 0"; if
hardware offloading is requested, mqprio defers TXQ range overlap
validation to the device driver (a strange decision in itself).

This is most certainly a bug, but it's not one that has any merit for
being fixed on "stable" as far as I can tell. This is because mqprio
always rejected a configuration which was in fact valid, and this has
shaped the way in which mqprio configuration scripts got built for
various hardware (see igb/igc in the link below). Therefore, one could
consider it to be merely an improvement for mqprio to allow reverse
TC:TXQ mappings.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230130173145.475943-9-vladimir.oltean@nxp.com/#25188310
Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230128010719.2182346-6-vladimir.oltean@nxp.com/#25186442
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: patch is new

 net/sched/sch_mqprio.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 3579a64da06e..25ab215641a2 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -27,6 +27,14 @@ struct mqprio_sched {
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
 };
 
+/* Returns true if the intervals [a, b) and [c, d) overlap. */
+static bool intervals_overlap(int a, int b, int c, int d)
+{
+	int left = max(a, c), right = min(b, d);
+
+	return left < right;
+}
+
 static int mqprio_enable_offload(struct Qdisc *sch,
 				 const struct tc_mqprio_qopt *qopt)
 {
@@ -144,7 +152,10 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 
 		/* Verify that the offset and counts do not overlap */
 		for (j = i + 1; j < qopt->num_tc; j++) {
-			if (last > qopt->offset[j])
+			if (intervals_overlap(qopt->offset[i], last,
+					      qopt->offset[j],
+					      qopt->offset[j] +
+					      qopt->count[j]))
 				return -EINVAL;
 		}
 	}
-- 
2.34.1

