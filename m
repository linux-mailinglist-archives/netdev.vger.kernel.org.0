Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7E55B9882
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiIOKI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiIOKIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:08:20 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4721D6745D;
        Thu, 15 Sep 2022 03:08:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eMD+wkSXsIr1sR/ToD3K+awk/aT3a11MPisfyLqtr4aSo0WvAihwy1NDdj/oRCRIa5injIP+LwDGrodLR6oxNf9rKEb7QpJP/mNxLIDckr9Uu90dr6a21EEaI7HnKfZpvAfRSd5ZTy9pUhRby4deHqAcrJITSq1gIfaF2DEgnmMZ6DwwpMj6IzM3dipIqiehEOu6HD2m7yLa715VKdSa7slPUlzOQsH/sqUYVeCiM54bftlTqhIcBZRPJpLXapxS8/lHf7CQKuwqLUmdrhQXQaJwQKKN5EqSvfHQVLCoNCYC6YCXrHnOKNIMWDV0miplj2BO1mVxzbBBMtqy8JF2sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DQRoMfVdEcqqufuyyuGKqnIB2MMh5L3JOlloBt0p3IM=;
 b=DoZNCTz9TqveGufOUJ6DVR6a3HzzU0AvUBGeiU61bGpdl3PAJCDV2VWQGyOuoHNvRf7xpRhYOK2ojo01n+sUV+j9Yg37JgwXuWGGg8mzNDmyzKlR6zwv7UlOzWgLdxt2ZZfxvL+ou8Lb8wR77OORKDSLMc/u+oEfgOIP4ZFTeRRttnCZ03I5Y/zv5GgsExYagzSs5MlPpNnb0480pb0aRjPwmj1ZuXsj0kX65HDdEuXxYXLdWsWRSwUngoUKhJb11ZRMSgqvFkTx2qQPfthGPqgN3ofhwJaxseBev3wXCyQek6QXw8vtofNYFnZPdT8YlokEP8Auyf9s7ynDn+z0Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQRoMfVdEcqqufuyyuGKqnIB2MMh5L3JOlloBt0p3IM=;
 b=TOGS+pcjF0/na8HMt/LBzQWh73XoSSW1fWScl8sffNVuSTA08Mikuz4/Hq/vyjYE0cYkipBmOt2cWHGZuXIVdyq7qQdRw8e0dIx8D1QRRSpUsFS3/vih8kxzvn8JxCsham+Ohzt2G2wyd0SeY1Ez2QJ5meaH+ypEnHmh6VFf5Gk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8457.eurprd04.prod.outlook.com (2603:10a6:102:1d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14; Thu, 15 Sep
 2022 10:08:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:08:15 +0000
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
Subject: [PATCH v2 net 2/2] net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs
Date:   Thu, 15 Sep 2022 13:08:02 +0300
Message-Id: <20220915100802.2308279-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
References: <20220915100802.2308279-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0044.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8457:EE_
X-MS-Office365-Filtering-Correlation-Id: f9f12908-aec8-40c4-4034-08da97023483
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ens0F0QkzI3Ekv+TAvzFPNz7eWAjKeo7O9I2qC3pHySnNqFXrj2+SLxw20FQIrNzvXdwTGT3bLb4FcAnreCkK5qwbOEzRACfT1zDZFBu1aJhuHt1N5WyAZTFi53YC7ghOB6X6Mskm48hvIK/k/I1E7ntHPJgyvMIrKaRfCtFi1J0H33gRKyGRBM7Z3Lrns0pg7i9MTGeTTUExTP0+1E6oGudCb5Qt+ParNh/SOLVstPozrzBKRjD5De49hWc3EtgQPstek3X6OwLwBpuJPFRXZfcdwNgi2TvEGyHOJb1Xre911GVxB9bPJBNcbCVqlzris1azYCnuhBe0kRnXhMXyeknr0ib9DvgOukiTyShMFO5cZBu34B7h63OTmnIZA0/L2+8XNJetJO52rHK8OEspKwMZRJbBnRBRojdcPmwrQSXeCcgArKV1YeYR0cDuzqFrl1SDF7912ozTwD1AbbKT/rXWvp7LNe0C4P6Rq1LT7EE+pNLlfpLJCO/fo8gOix6sO2qb56pN0YrGWtqhVI0VlHNyc4ZeHeDv6P5+dsYjenhea/f0GXvYI/YApOWPde0MWmIZtisPntfXvVKLubowHVoPJftq0xJYTb0OqgddrMS/pBYACnx1WSPJ2F2O9dlQ6VArPIrC41ArWaT7ZYiA5Co8RQxOjDHxtUiTlWULKiCrUoX0qVN4P8o4HFip5ZNqTYO2rq9B1zwRAHNLOcKuyr9IKVz1FPPKjVGma7brsOv9OO/mqM+lwFmVZtmrJWNkFSwz95fYWl11dLIrOJfTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199015)(6486002)(2906002)(478600001)(41300700001)(6666004)(8936002)(54906003)(38350700002)(6916009)(52116002)(66946007)(316002)(4326008)(66476007)(66556008)(8676002)(36756003)(38100700002)(7416002)(86362001)(5660300002)(1076003)(186003)(2616005)(83380400001)(26005)(6512007)(44832011)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6Ahz+LigCB+4hgwPofoj5yVl9EThOWYdv/GilMvhBIVdKSr+edjJOD8RdxFz?=
 =?us-ascii?Q?9u/IjFFfTWCQD+CK/htFIIoHiUjNlzF3FCjPOSGUlJtjSuFiQfeX6vZ/5sqe?=
 =?us-ascii?Q?MErbQbfyOwlk2lQs62kEYIqrVEvyOxojgZi5FWJTl/4E1P7jZNWX9njwYSNv?=
 =?us-ascii?Q?XT/iISvfFWNICp4bt/tzA1krXcTU/Ld1KwjqDVlptFZn+svAfvuIt1gUm11Q?=
 =?us-ascii?Q?0yy/aDeIRkfUb0suAkyxcmY8lUD8QEsHCwkZ9qlxQ0aRvPYgeRTG5eSa4KLO?=
 =?us-ascii?Q?qbuG9NmCpFX+hF3YNtFp/bhiistf5WGar9M6iLD31vDeib7+jX0ecx+OXIij?=
 =?us-ascii?Q?NJDOz1mS+u3by/FXfANOa2kWTFm2GTULPhVEL6wfSXidjkT02thMrFHeiBwZ?=
 =?us-ascii?Q?N8W+UZDzrRzN/2dtObgrFSLxuYOeIbLI9sIALsq+GzHu3c/xZ0oDfcG0axeP?=
 =?us-ascii?Q?mVScAvTIdvL6kkdXQlPfzRszIxWpryepWK/7w2WrUq5xTxW4KZa2+DsQE3Ps?=
 =?us-ascii?Q?lKftEZ2Uj8bRnQ94dmrPNAgJNEN6ktS7vwMYhiq/LEeVJ/ArnSHVxaFBscbL?=
 =?us-ascii?Q?NlhHZgvtdbSJbpJ3R1X6SE8FQB0yHykg48eUooqJG7qYqHM/NO455AXQmogJ?=
 =?us-ascii?Q?c/3/vxpxqOVzqihta1AQQUVj8EUDNXUDFDiOABMqRnTzaSCJRDF+yD4lZX3q?=
 =?us-ascii?Q?JMsbamKUEN7v7Fet4U542SC7b/MfG4xrO+Me4Y0nD8neZ26L7DpmSArjiXNT?=
 =?us-ascii?Q?zNx9ZjfAD9489IskZ5EROjwzB0Bzj3vgUpdF5MQEs71aH1ThhksuSxAtOGG8?=
 =?us-ascii?Q?uCNHa85PktQyMwOT8WpsWSwJr6YF+2pKTfwU9k2JCNRmiuQaTcUnY1nxIOQL?=
 =?us-ascii?Q?4xBS7g7ONyJ/1eNIqOjL8ptGlkxh1hlQPE01OYlVKpfOiZFgM6ihDPNViBVz?=
 =?us-ascii?Q?eb+Hz/pedDpcHWho+y0/sOqLTZy6fMSpFDsX56L7FsgimGRPt35aFc17tEmH?=
 =?us-ascii?Q?kZ0asU+Ti5+eFAaVzKrrOgwFBhJkVuUBZ5xUFxgK8lJtOPNY+VFqjCMxoC0G?=
 =?us-ascii?Q?PwCv2BA2dnD0aXy6gHf3oXItPHuF0wQf3WHPwmZsoP7H2Sf9gv+ugzYvly4U?=
 =?us-ascii?Q?NL9qToNNlbE44L340uYzH2SXOFcxA4IkN+QIKJzvP0E/iWC122g8cFZe6jS0?=
 =?us-ascii?Q?bA+HSEYvpU2gxno0sma1g7FKAdai2HqpQOUEl7qOSOFPsM3nPVBARXhQgEKz?=
 =?us-ascii?Q?Q7P2XcL5kFlN2dodGLuez4wWyZQL0UunADQ6oimGXS3smbO/52+FkJSK92JD?=
 =?us-ascii?Q?N7mcXmpzJn3iOhM+uhhPUewD6dkid6EF4gNco65z7wfQVEwkJ9DsKzcEwaLF?=
 =?us-ascii?Q?CYrcocAXWJ/iZOR6t9SymTY554LXNFLoVXq8hccMwJMeBlqJ3M+dkTt1eHtk?=
 =?us-ascii?Q?4QjCoD1LS5W9Oht4dc7Ck2JR49tvxw5LwALlPE5NP6H9O7TUfVeFgZqxjZWG?=
 =?us-ascii?Q?1721fdUJRA/26Dzp7ztabjfDSRdhXpkTdypj3iT9Ss8t71SXWVGCDhYPmml/?=
 =?us-ascii?Q?JwKzrIKPCn2A/JvXeQkSiKEwZcf9guqY6m1UAcxZShZr8HMjoVbkL6qgjsEO?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f12908-aec8-40c4-4034-08da97023483
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:08:15.5123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ig/qrbmpTHIUxAMgu2FlunjOa/pY5l64C2xNMbBI8FLTKANKb0AFD5F3uCxLs6pE3+Nux8OYfPrePd1TdRmK+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8457
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

taprio can only operate as root qdisc, and to that end, there exists the
following check in taprio_init(), just as in mqprio:

	if (sch->parent != TC_H_ROOT)
		return -EOPNOTSUPP;

And indeed, when we try to attach taprio to an mqprio child, it fails as
expected:

$ tc qdisc add dev swp0 root handle 1: mqprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
$ tc qdisc replace dev swp0 parent 1:2 taprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
	flags 0x0 clockid CLOCK_TAI
Error: sch_taprio: Can only be attached as root qdisc.

(extack message added by me)

But when we try to attach a taprio child to a taprio root qdisc,
surprisingly it doesn't fail:

$ tc qdisc replace dev swp0 root handle 1: taprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
	flags 0x0 clockid CLOCK_TAI
$ tc qdisc replace dev swp0 parent 1:2 taprio num_tc 8 \
	map 0 1 2 3 4 5 6 7 \
	queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
	base-time 0 sched-entry S 0x7f 990000 sched-entry S 0x80 100000 \
	flags 0x0 clockid CLOCK_TAI

This is because tc_modify_qdisc() behaves differently when mqprio is
root, vs when taprio is root.

In the mqprio case, it finds the parent qdisc through
p = qdisc_lookup(dev, TC_H_MAJ(clid)), and then the child qdisc through
q = qdisc_leaf(p, clid). This leaf qdisc q has handle 0, so it is
ignored according to the comment right below ("It may be default qdisc,
ignore it"). As a result, tc_modify_qdisc() goes through the
qdisc_create() code path, and this gives taprio_init() a chance to check
for sch_parent != TC_H_ROOT and error out.

Whereas in the taprio case, the returned q = qdisc_leaf(p, clid) is
different. It is not the default qdisc created for each netdev queue
(both taprio and mqprio call qdisc_create_dflt() and keep them in
a private q->qdiscs[], or priv->qdiscs[], respectively). Instead, taprio
makes qdisc_leaf() return the _root_ qdisc, aka itself.

When taprio does that, tc_modify_qdisc() goes through the qdisc_change()
code path, because the qdisc layer never finds out about the child qdisc
of the root. And through the ->change() ops, taprio has no reason to
check whether its parent is root or not, just through ->init(), which is
not called.

The problem is the taprio_leaf() implementation. Even though code wise,
it does the exact same thing as mqprio_leaf() which it is copied from,
it works with different input data. This is because mqprio does not
attach itself (the root) to each device TX queue, but one of the default
qdiscs from its private array.

In fact, since commit 13511704f8d7 ("net: taprio offload: enforce qdisc
to netdev queue mapping"), taprio does this too, but just for the full
offload case. So if we tried to attach a taprio child to a fully
offloaded taprio root qdisc, it would properly fail too; just not to a
software root taprio.

To fix the problem, stop looking at the Qdisc that's attached to the TX
queue, and instead, always return the default qdiscs that we've
allocated (and to which we privately enqueue and dequeue, in software
scheduling mode).

Since Qdisc_class_ops :: leaf  is only called from tc_modify_qdisc(),
the risk of unforeseen side effects introduced by this change is
minimal.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/sched/sch_taprio.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index a3b4f92a9937..5bffc37022e0 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1949,12 +1949,14 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 
 static struct Qdisc *taprio_leaf(struct Qdisc *sch, unsigned long cl)
 {
-	struct netdev_queue *dev_queue = taprio_queue_get(sch, cl);
+	struct taprio_sched *q = qdisc_priv(sch);
+	struct net_device *dev = qdisc_dev(sch);
+	unsigned int ntx = cl - 1;
 
-	if (!dev_queue)
+	if (ntx >= dev->num_tx_queues)
 		return NULL;
 
-	return dev_queue->qdisc_sleeping;
+	return q->qdiscs[ntx];
 }
 
 static unsigned long taprio_find(struct Qdisc *sch, u32 classid)
-- 
2.34.1

