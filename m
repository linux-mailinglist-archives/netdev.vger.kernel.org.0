Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4225B9926
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiIOKwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiIOKvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:51:22 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E18589CDC;
        Thu, 15 Sep 2022 03:51:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3Ns1mOIePaU4l/UKzoSL9kcw/z6NSeWVeLFA0iGW68q0QEilsXDtWO3jL+BK3NheVnQCNHQloqTQAwWDgfQHn36TcSpNL94evbX+NPL/LMKjHkqse+mUfrcdz5nzFkEhnFaP9F+wmIXLXfPgIVZS+4t8sa2z/H6pCt7rRITKBeW+t2toeXjqVYLjHciSV3HnzUQxP+mSHlIAwk5aZsez7VeUtModKTRN3NlAmIX9HjFmrJNTjU28SxMBgAuuh0osCHctisqSidd+4R7exaNlyFVjLJNwQuraLafhE0QHO/lBWRybwfWfbG7hGG+dXSk99H6gpYQb9q2Q7Dz4rbkaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ofug0xbIJchZHDQdZ3fIaHdqFMSpcbUXoQal4Hujn2o=;
 b=ORUL3y1BKEM9Q6hRCMnXV302zQ1Ec+boMKRNm5788QoZjXe7opE+1/nhaLk6xWClHX0EeJCrCG2Rw403Dq0neJ7IkUNt+bHauSFWqKXmw8Cz682oumk3rx5eglUrrIZ5oYxgWiQosdG5wmsSqvfncwf2Nd7Kd9iSn4N+AuLfxTuzeE1TBgrFaWzQajswXlgPL30SBRIZWptFSnpyL47/GKzbGvDvtIqqwdMtBMDxlaEhULU6YeTmfT5ugMsNKeYL0DE/E64QGEFCwYS2btSOa3ExMnGF6SGSHA1I4LjkGNe0tZaNqWQ2EELE96P+Y01WBlVJQjYJSbNj1PdPQm5LYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofug0xbIJchZHDQdZ3fIaHdqFMSpcbUXoQal4Hujn2o=;
 b=ImJf7YGeuP1VM1PppZtK6XaBvfE4ytqvtaNruVRexEPEdBGFY4MORpBhXYJvLeDrpWqRWJFX3QTX/+TFO/RnH457omp5tnPOeezBd/ThtahwwtBXSqHhKbqEn2a14tcQROZJsfvwx4bb/TmzmnHIYy0gDRuoS3pH2FR9wAJqAwg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7163.eurprd04.prod.outlook.com (2603:10a6:10:fe::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 10:51:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:51:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 6/7] net/sched: taprio: add extack messages in taprio_init
Date:   Thu, 15 Sep 2022 13:50:45 +0300
Message-Id: <20220915105046.2404072-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
References: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0052.eurprd09.prod.outlook.com
 (2603:10a6:802:28::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: e4da418a-a40d-47a2-4f8a-08da97082e28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ORlkeiOGGQpGCiwyMw+YjzKOKfcvD2pdmxZPbNeQ0IXVXZgh0K57uYr1DMULs10nj5rUtstzW6MjOrApkcIRu30CF2Yr6De5SxW75rniFF94PGvhP+zLag7FR8qUqq+BcfFhz+0wHJsXZE3RRLOMNdcqNpbzD8l4BcC3jEXwsr+wQrO8upkL3yzXf9TQ7G0EAOQkV6nXnfa808cMnpaJxEm/6tP6haKJqMP5WDYjRSBTC/fRozcoY5vlsA7MYCU2oiZXwqpMFjUzlJTjrTPnDRmLTWNl/yJJt1wwcbT5xN/ohjjvBNTHxva9dUtEoGeI3Y0n6gTvWPc5xjuVNRblRdaAL/od/3zy5yRdBgnX/ydnKgvL+Q6jxFRSZu3FcOkD9Z8Rb92sn47GgyG4q1xDjI97lv3C3UewI3HBuRCe92Z8v2zk0umcCYdNk6xRAH3Yol20QQraSm3iN6nKDcUZoxOnN/XgSIe577YqrOc7uDVKLVyrbBXABxKZn2Ih6x713PRlb1pcPIYLTspemEVVtQ3BmmLJZ4nPY2+E9K8eOAktT4TTtkrbyaad9mvN+wpwUchsffNY7PBYfm/kkoyOte2EPL4sSDaiPui6Asy5w227hDlHZAi+59Y0TarA9RZSVYmXzym1cZkiZnaABVP3dNFznptm5sQ8lw9x/9XB2oO0Oq/yPuLIqnnrMM7pO/wRLCAFrxd04sID3ozf1EA4ES/KwVysDEsufP4atXOctbagxfTZT0kql3g2MafpGYPCS37j9CrJdRN4cVQExO+2+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(6916009)(4744005)(5660300002)(6486002)(7416002)(2906002)(478600001)(66476007)(36756003)(54906003)(44832011)(38350700002)(8676002)(38100700002)(6666004)(316002)(2616005)(83380400001)(1076003)(186003)(66946007)(41300700001)(6512007)(86362001)(4326008)(6506007)(8936002)(66556008)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EfcBw/7GzLlPActJcLR5dIcFarl6sWM85rJOyA7IijwjZFCGSC9xir3tSccp?=
 =?us-ascii?Q?3URTym0GPtyD5JUZYuTTq7WTObO6RePjLtN30ZxCoXR2luWH3XL3xIKM3pKH?=
 =?us-ascii?Q?3di8jaNaGUQez+46VIyTgi0gN5XRx5MocdgZaQ9lnm93gs6Dh7pbrP7g9KCx?=
 =?us-ascii?Q?3jjFO0M0xCgGMlik8b/mTCEV9TBPaHFgQjLo4cJCEVuUkQoQq2DbmXPwDSBR?=
 =?us-ascii?Q?ztNF2bTaQ8ttc+qhKfjMMzfHNcHTI+U/ejUOQQDW3L7nv2gCJZ2PxVunUEHS?=
 =?us-ascii?Q?wRTWQhuWvVMktVB2hMXwxksWmKeNgWpjUJsA8YHZUtc1ybJuBOuBKO2Z6Zud?=
 =?us-ascii?Q?sb1HA2osgZiDqHclioIgZGBzsDrcn4o16Y19DEKVns0K8l/QmBlz03CGq93j?=
 =?us-ascii?Q?39psbqHuvmvw0y9h44EnahZpEviOXPAIk4l9nLebLDYC5KN3alUIilhWWbtv?=
 =?us-ascii?Q?tdnAIhpoQREUYQbLyxZum+WjSeQpjl8nxlY226nEH0g/VWCH5PKd/JBz95y1?=
 =?us-ascii?Q?2dz2d5ugbyF5yhHeph0abNOYwfj/ihD9yw/M+yesEttzY+6HLrg/XQ6eI7Q0?=
 =?us-ascii?Q?lkHO1slBVqSt9Dnwz80kLYqLIRpYy/ukYOoLRFGCkZtgSdSSBzn36GlcnleT?=
 =?us-ascii?Q?AXWxI0o0/3muyj7D/RvE0Cy5GmHNr3W2KRyJsEZ2fY4Uva+oR1rDw0qE5V+4?=
 =?us-ascii?Q?FXlK1cJp4txzBKBnXig8FivC+yFhJIH9Q6WxaHPKhBLxe0YMzX6oK3cQ4IZM?=
 =?us-ascii?Q?1c3XgZ/j9cnahaqdv9Uiy2dRxjYXjVnpb2KXjafxEGUOKps5SAUAjh9uTSuF?=
 =?us-ascii?Q?FEsC7IT/FPQlrc6EXELbya47sprrhUnmXvqT6zibjAdf08i+dEjzzEKl9FN2?=
 =?us-ascii?Q?9cyXQGoQCTLQ+/9ZL96CkHS3W8gIYhYOeJSaGfCvPDbC9XSQhARF0N7M/l+0?=
 =?us-ascii?Q?0Ss2Z+Rb2Y730Eyig22TXXymmyCEdWnhKJyIWuKf7I80JDqEtmOoz+ek8/SO?=
 =?us-ascii?Q?u7W+4SsS56T7Q++ogesK51665sk/GetnbykPZDu0da8+c2ct9aiyb2Vgf/NP?=
 =?us-ascii?Q?fAI/RpGPLeRy0TeDSg868klV5Z0HKVGm5+xEQPFQ+oPLiCCvCDkZn5pC5ilM?=
 =?us-ascii?Q?MYdZowfL9XfYfuy5gv2SJXqXxDyehFFGKRhBHE6tgweYAvLqOiwcBlZFaTet?=
 =?us-ascii?Q?gJyB1LIM2NgqI8NtUY46OXZT5//CxFj1g6wpRLYg4QajrK6BzN/O1e6q5dQv?=
 =?us-ascii?Q?61lHXAwmnlbj4okCTfsHsSzGwNATRvFGQDiNe16a2LsUtZVDDvi9vhM+11tq?=
 =?us-ascii?Q?gqmC2ScM+ZQtZnuxfT2fKmh9I6nZcyDHUV4jPllolSQlCZLBO+Qul6/p+HIa?=
 =?us-ascii?Q?sch7Gp1UKwmFR5gUowDmEdA/FFLJEwhGRPBUpnBcBgy7WVAI1N7daAXu6yCh?=
 =?us-ascii?Q?gG46OPGd5WUeWvo3f2WSz1tohegbAymda+PUmpZUV1dl4qw3oRTNvuc0s94a?=
 =?us-ascii?Q?e7tQg28+iF0RH62kUwtifO1QN1lpdNUKKJKgEOfex+wZpFOxwylTXDEgeWKg?=
 =?us-ascii?Q?Ai3lY8aMyCckB85m9NG9WjSY6Z0AnK1GnB0qpmIdhc2iRRY1vlr2LSDymvB9?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4da418a-a40d-47a2-4f8a-08da97082e28
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:51:01.7835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fQF5Ogg67B1VQUlycfimiw56+IwFuoK5/svh1vwJLUNomYVsx0DHvTY/2XFj6605yaKNlhrsD8r5OI3yLU67A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7163
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop contributing to the proverbial user unfriendliness of tc, and tell
the user what is wrong wherever possible.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/sched/sch_taprio.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index f3eadea101e1..bc93f709d354 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1663,11 +1663,15 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	list_add(&q->taprio_list, &taprio_list);
 	spin_unlock(&taprio_list_lock);
 
-	if (sch->parent != TC_H_ROOT)
+	if (sch->parent != TC_H_ROOT) {
+		NL_SET_ERR_MSG_MOD(extack, "Can only be attached as root qdisc");
 		return -EOPNOTSUPP;
+	}
 
-	if (!netif_is_multiqueue(dev))
+	if (!netif_is_multiqueue(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Multi-queue device is required");
 		return -EOPNOTSUPP;
+	}
 
 	/* pre-allocate qdisc, attachment can't fail */
 	q->qdiscs = kcalloc(dev->num_tx_queues,
-- 
2.34.1

