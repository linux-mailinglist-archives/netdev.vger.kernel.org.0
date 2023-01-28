Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1EEE67F376
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbjA1BID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjA1BH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:07:56 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2271ADCE
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:07:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbyWghYKzoahm07iE77nuAEEx3FUgjsfcOw4ImX0fchbXCnuQOQM5mmVWtFsryrl9gC3+Dhn8aKXkUFrVGgOaL8LJlii1ujUD8hoZJ7hrhfwiJ5SGAr0XqQnoHXfYs9ktEU4p50PcmQW3pCczbdb1gVNajd4pRz3Lc0tk3Mt9ZVNvMu+12EJzEtlV3VLUBPl3y4X9qSyUDWl1UAn+SOX9oGIKjFf2Bms5shAHegJYJ0X+YWuE160Xhi9OG8oL/eWQQgypjNSqWp4wNM0Ie+kyMK+iEjEkVr11WMqR5edOHqI56xi6ReiOiBtNiZYOYMMFFzhQDjeKpP7riaNXQLqHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUssSdJtzUQfQiYK0BDmZMG7q2MKAhBmvgYvaTeg8us=;
 b=e7ycrKpjoeTIZA2miVDSokDVOe+J2ol57xcPxSzOxeeA4QRN2sdaOVy7eC8QsNg06zsFVnAL7K56Sm7qOHDqEBz/hyYi3nRLadx3B4HNT0TkeBkaui6exCroxiYC3Nh5k38SmXjdznJzcT1mS8orA3Mf9pKjQyPjaKo7HQ7tX32mbbtkZHY436hLk5zkZBygG1ucPjZ1ERviIfiuXpYvJu1BmZjgVRKoRE+L5i3UPYkGdm1Xi+tST8clqBhRoNQGFSi/cnPw4Kz2atPU612rQ7ahr+Qan9asJwBr8YSz5/RF1bIc5IxXmQ3Is+VLgUbedXZUYOtdqoEx0e1M3yjc0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUssSdJtzUQfQiYK0BDmZMG7q2MKAhBmvgYvaTeg8us=;
 b=AXmu25YiEvR/C4kmcDhMiJF/7nAIu4aE6gyHED3W85s06fVOAlTVKyDOi+fzE0XposjlGy6pjG9KUzSr1P8sUvSvw8mfQANpk3dUkA+5UYbjAu0fnZZbWYnj8qm1vtPnWktEs9dcqawhec+Dl8+O7wZg21Yd44hQFlgoaOohrcI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 01/15] net/sched: taprio: delete peek() implementation
Date:   Sat, 28 Jan 2023 03:07:05 +0200
Message-Id: <20230128010719.2182346-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: d14b9fd2-b4bf-4202-a0c5-08db00cc130d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AfkyZeG6UGVUAKlw7G5Ll/x5x+rzKZrHd4uZN+04VfZ16e+7rbmjaiYFjaHHkKshdZRgIkuJi9IfqpMazPW/ZfYtAIyFkG7msA+Z+ilxysTLzNJ6bRkPQdTeU2VdCYARyB2Z4NXu1LJ5ULZfX0QG2jHIDFN2SrmqGSGIaCjig/AWBvgUstTnUjEz7deYJCs+re4S9GIqHTLWL3i7eRzrrCwwZd7GdWIPy6Wy2E98v9AGvWKUgU2coLAyaus3jSFSa8U4AnQ+3Kl7MOHArqtskgm+ZUd4/5qTg3QrlO0hczTuV4kFdbG6wMFehhUb54E48r5rGUnzmtMrnokpwJYISws1XBXoVgxgmkke1LxKTck5rdi4EJ7r3ckOv/bCF4P0Tfz0RtIX8zc3Mbo7E7z/yjh8R7L4sJDZeYXPsobUKTGFt5pjRotLlkaX7fSmV2W3Iv9iE9UlllzdcOym9u8Yltc92gFVV7HySWY1EXOFOYWW5dHBVja49BpvUUy+8w531eb+KQY56tFAlL98W3nZjsZ/U/2OUSch4bF0D2imqWNgAP40iIn+e/hJwdKWALPBStPmf4nSImBIkQbIFvWre2XQj9VVnwDy3/QX8XdRlgzncBHCrUIM/pICN37cm+NyyscdCnAffw4xxKWZH7t4tj7t+IWuBKhi8DseiRJTfPcQ/oMJ2YWqWgkemt6nmUDCj6GKkC2Q/oZIvGZDvtcz9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vo2CW/IPdYtcqx9+cL0MLuUBo0+qmVmY2kw5YOSEtz2Np/Y4MpWauWl+v/N8?=
 =?us-ascii?Q?+iiEnMRpwuJCBAl496jLfDuaAxVmMGM4ii0ieg2DpJoQwqyTYmdy2ykA7RHu?=
 =?us-ascii?Q?sKm9pjFpxEfLVKZTJguIICCGWJkShr5Lm+HngJvpDHJBP4xiAvGEzGJw1psF?=
 =?us-ascii?Q?jgVkSOEsZ1nQzunEwIVhepRfX4hI1rWONlsp9kPsN8Yg60hrfj4JUaeWJkx1?=
 =?us-ascii?Q?RL+xDoNwK4mHRgaUH2f2Uar3Mskre3u2xobh//yjda3iajhwRs/D9PhKYPIz?=
 =?us-ascii?Q?llzhYHTqEQai+ZcUgKP0sA76eRYtyPFg6/y5VO9byphq/4coS/S6KNZmYbm8?=
 =?us-ascii?Q?9tPGDrItVO8RUpn7UnnYWbUWxw/v+IlD2/R31Mb90e+wDU4zlWAGORIgAilJ?=
 =?us-ascii?Q?huxDS+6z3ryhFag6sKoD7uTpcXogDbIawmqcNlUc+419qVJi1qNJF1uWEKBA?=
 =?us-ascii?Q?s0o/ntgqMpQ747qEzx5Qj5zLYzEu2ceRt9Q4uJrlqidWHERd4sP/Hwzqx25Q?=
 =?us-ascii?Q?pIJhnSWXVE+aSf41Vx/EzBAIVBvfyAFPGa6sqSam/WJ/Wxy/1nK8xa2f8L8f?=
 =?us-ascii?Q?/kuxAc2zDIo+4J0e97O4aLVREHIyiHijDGzuyo4DeNXULs2qMgOOkWS8Pu8J?=
 =?us-ascii?Q?fcYXjAuq1KHeaISArmOANdbBZ4GXBL2A2W5Wmg1HLUSZW+8Pj2hUzBF3eAng?=
 =?us-ascii?Q?WifY5teUSpmJvv3jTPL1aXJr2Qz69dA+4KrUAr8dZiHSuvXMVqVl74aNi1Do?=
 =?us-ascii?Q?EnyH2oV+/tx9lg8H1FAcibX9v3xiGCGpe6shUN8t0d4R178IFRVvpLifzrRy?=
 =?us-ascii?Q?3c0TuEa/3+cs3lIiAFZE4XZQpjaq2LeJfcKA9Ygq/oQduL4VdJLLX218+j6/?=
 =?us-ascii?Q?i4sgTn0uYkpdSA6q17QhYZo/vbYLl68SKmcwRPjwAf+BPPtzUwCI5dHhEwzd?=
 =?us-ascii?Q?Z+7uZ+qMal8sfs80lv2aSiBXRhwG2zEDbnaZEVHc/VA1xOmhimovrThCb1tm?=
 =?us-ascii?Q?DdCpUdP71GyikPW3hI6sqW8u86AjZUFNPYvH2FTdty6TFeBwhF6dIttH8UCy?=
 =?us-ascii?Q?Q3fV1ACw5HCuy1ujVAKIZNoN5a/S7hs9GfzK99FBKMFtiXwHD2TqSxBNNVDq?=
 =?us-ascii?Q?N5GTh0bg+seXM/toqRcOhsiqrnZgwgMG7YSHMkrOu351adIs4DUyGu7Nsdx4?=
 =?us-ascii?Q?InvCxzMuU26YQfn66nGKoWXmp6+W9BjABfIt9MJnF9+Zo2rtQJiW+fj3WPXv?=
 =?us-ascii?Q?yqaFygnpeWVeg2vTbRdR5/FlTh1nMZ819sQTff1oaB6JU52FuHOL6kYnLUAW?=
 =?us-ascii?Q?P5QcXMt0e1HM9t0U7SirzL5PHBDtwhHM690r5Br5thBYT9MsGl7UICtEvrdI?=
 =?us-ascii?Q?MkCK+d0zhzLDPSlcyQxoD3/zzoW1bjRr/bcwZ+1Uk+f7F598G7yq5/yUo+Vh?=
 =?us-ascii?Q?v7CGvK8RhmGdZbsOm9adeFSBv3NklBJ3+kX3ZQZbnSC4yfQmFS68vQH1kXt2?=
 =?us-ascii?Q?+tSSNaOgU2PrxULePhRa3QAEy6DxJMPcpYf1tWaRF4YpmSWzegYWGJfhHjz/?=
 =?us-ascii?Q?qpZaT7+0sJqmnSu0lIM5Agfe/XVD5gqtIyGJArArkcs7vNrls2lqWSnuv+DX?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d14b9fd2-b4bf-4202-a0c5-08db00cc130d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:49.7920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M6ItDhSPM81VoeO6JslE4yOa76+sq2CrHtP5NdQQA1tX/R2Nw2ceVXo/oM4pNBg/nPdNOztwOGuiNn1CAh+oqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There isn't any code in the network stack which calls taprio_peek().
We only see qdisc->ops->peek() being called on child qdiscs of other
classful qdiscs, never from the generic qdisc code. Whereas taprio is
never a child qdisc, it is always root.

This snippet of a comment from qdisc_peek_dequeued() seems to confirm:

	/* we can reuse ->gso_skb because peek isn't called for root qdiscs */

Since I've been known to be wrong many times though, I'm not completely
removing it, but leaving a stub function in place which emits a warning.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 43 +-----------------------------------------
 1 file changed, 1 insertion(+), 42 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index f2c585bb0519..375f445c1cfb 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -497,50 +497,9 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	return taprio_enqueue_one(skb, sch, child, to_free);
 }
 
-/* Will not be called in the full offload case, since the TX queues are
- * attached to the Qdisc created using qdisc_create_dflt()
- */
 static struct sk_buff *taprio_peek(struct Qdisc *sch)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
-	struct net_device *dev = qdisc_dev(sch);
-	struct sched_entry *entry;
-	struct sk_buff *skb;
-	u32 gate_mask;
-	int i;
-
-	rcu_read_lock();
-	entry = rcu_dereference(q->current_entry);
-	gate_mask = entry ? entry->gate_mask : TAPRIO_ALL_GATES_OPEN;
-	rcu_read_unlock();
-
-	if (!gate_mask)
-		return NULL;
-
-	for (i = 0; i < dev->num_tx_queues; i++) {
-		struct Qdisc *child = q->qdiscs[i];
-		int prio;
-		u8 tc;
-
-		if (unlikely(!child))
-			continue;
-
-		skb = child->ops->peek(child);
-		if (!skb)
-			continue;
-
-		if (TXTIME_ASSIST_IS_ENABLED(q->flags))
-			return skb;
-
-		prio = skb->priority;
-		tc = netdev_get_prio_tc_map(dev, prio);
-
-		if (!(gate_mask & BIT(tc)))
-			continue;
-
-		return skb;
-	}
-
+	WARN_ONCE(1, "taprio only supports operating as root qdisc, peek() not implemented");
 	return NULL;
 }
 
-- 
2.34.1

