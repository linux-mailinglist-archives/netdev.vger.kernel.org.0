Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF6D68D9BB
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbjBGNzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjBGNzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:55:09 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2041.outbound.protection.outlook.com [40.107.8.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FF6F4;
        Tue,  7 Feb 2023 05:55:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuMGCmTlVQULIPWG0O9oerq8GUNmSzS65S0bXhaSdfQss+Ai2dxGbdqX+vMXBhvQid1/noEkCD2V0SmKbnb+eUo/qj2h0GKGE1mtbsVm0G4MnCaoyTlpKt3zqcrmyZy1Ny4/BBOLiClnLd3MmUi4MxKzZ3qfL6X2lFXt5clgcfc29R5Z7PRZ2iFw6T1LkV4SpbtF4hpZTyUFhNXKHW97IfWrY2nl9fedWjKkdFrlB3T3PkMsRcdBE65bn9u0u0cdmhHyFZUncLj5ZJi1pjqTsVa6x1ouDLbcwJiJ2zakGQDtr7ksalUIEZCn1B3aIhOwqnG2YfMo84C5mPNOxov2IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBGNKAdOIbIQ/2WkVic7Z6QJr7zWWMBUUGX1u6+3xjM=;
 b=OG4pScokNqSavJLveUjPsCvsDX9UjdFHcJlT2LpG4/BFM00TTlpHJFGvg1npSH735Z40XyAUs2mwjKCF0L/cd+VHr+PNbFXnoMPFO/Mk6A0qS+KWgOxaeux98GYTtQkNN6HjD8KT8PC1ykecnu9798RUnPV8PvkSFca4iH9yWWBkBKGMCFJ/nWJt5f4qXqwWXUqA/XvUSTp+4wQCxhcxr/kcE3Q+bu23AK0PO63hzo3mBQx/9GMrXXeHgC0GrL9n0cxrdD3ZhKp/M+bh9lsWnkbR5cfMC36YHFw0WMVN37EZqipD0VHrVi3L+kybZnFUsnZB1TvNVyS9q1nx35w78Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBGNKAdOIbIQ/2WkVic7Z6QJr7zWWMBUUGX1u6+3xjM=;
 b=B/O8rySNVHrpknm0NzNNNoB/7VGPL5FY8+wzLgiaSwIaRFOWtVTBk5rnqH9QmN9dCFvs7MVp+YkZXYN45Oi/l8F+Y+dvP5rxOhrfU+wHv3xhEI/fFTinG/J6ODhuVWLh9OqKYE2OaeQ1jzlzspSawbMZvsaWF29sR6znMExLkng=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7299.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Tue, 7 Feb
 2023 13:55:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 13:55:04 +0000
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
Subject: [PATCH v2 net-next 01/15] net/sched: taprio: delete peek() implementation
Date:   Tue,  7 Feb 2023 15:54:26 +0200
Message-Id: <20230207135440.1482856-2-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: f4c3b158-b05a-49d8-9268-08db0912e973
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a9ykhu6Bwrmh2IpDm7J9OHPnuOX+zY5Lx5pMGFW1dvL+v/GZ6J6JJzoLEHWwgK0DmuPVjhMHaMlAgh+zwWP7gHQkeBP9kG9SGsJne/P7VMGBwjWvsiCZQrEiZ9/xyhLXGYisICL78AYj2NkE+qD1G0lh/GuW54ewClCEh6nH58ZmhZbchMCOYHi2UPjrghlbmdxchVzIqEcmj4QX48jNtC+t3DuoGx3ksWFTt1PHIl45Q+7maeSEKOGvSz4URba69Lg84PfnsAFCvrh3EKuyb3poBHx1ERWX8yLb/klorxNoBqC7qgRm/b93iHpaAaXmrZtuBcebcqwOkUzeSIU086rOvX5D0TO5YdWIThnoi5kn1fQqcFBLMJNRdGmg1zTBbPgypZKzKW6HojeUD8G4UOcTQIMYC556Zn+F2Z5bPIBjQBLM3mNdt/0P0jbczptzLI/yrjYZ7hThcJtiEnuiJzWCThjQ92AlNcVMvMJvzouWgyTRH1LMEidL/Wl/ebxUrMBsTxUIeJSSOw3yfG/+C6HPtxlshlFFp7zPxfqeY6vlF35/JN71r1btvZAJP3Ibm8g6+87QXyUQXLxLH+ltfMmtH2mqHHFil76rFB+T6y9nsxtsOwK8l38SnbS0SbYNhwGDps4A+yjwbpbxTbcDIzOoW7oVZuj3p3I6Agm3h/OE0sq2l1gZS7wzLxhioee53Ch5Eph4SZSiuKU/60cPaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199018)(2616005)(316002)(26005)(4326008)(6486002)(8936002)(6512007)(36756003)(8676002)(6666004)(41300700001)(6506007)(1076003)(86362001)(186003)(478600001)(5660300002)(7416002)(2906002)(54906003)(44832011)(83380400001)(66556008)(52116002)(6916009)(38350700002)(38100700002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?92202rSHbf+eOf9ecuP/XoUEKURX/NTjGO4O+RqPk6XgAftA+ngI1x+YeiSy?=
 =?us-ascii?Q?1+8P8AmzJrKddWw8blGHZyntVb9MNb7IqP4rMtj20lKQzOdGnfvu73O+4gx5?=
 =?us-ascii?Q?aQ8xMXFPvfB91iaj/IYN+K3FzPLBmy10cn5IXww1DQl5HvQ9LbrcrfqwQ7MN?=
 =?us-ascii?Q?UDgmi3seE94MQK+sQGNMZ892WdNw5VaUdMfh5GqWxgJGOym9YRxWbMx2jq7K?=
 =?us-ascii?Q?7FEYqpCVH3S3Ob1QjG5LWFTsDS/iWRSwPvn8DFcwuiw+sBlCHbOBgyfSM8XT?=
 =?us-ascii?Q?ZStpysRwdOeP4vuH/IzMvVNDOWJY99OYcgA/y3DL3vHArD5ADih7Qf8fNOoi?=
 =?us-ascii?Q?3Yrn/OtStBqvCyfOtcsygJ2vt8xe/hyZigw65oU6RV7bYquqM1exBuylglbE?=
 =?us-ascii?Q?ug/bgxhHuGUs/ssekNmIj3bkl/YYjLtfycbJ4iaMZL4bTOu8r/idKkE15x7B?=
 =?us-ascii?Q?cH6YGsJzJfZL+7r0EblkpRzcP7aeEttoVadBRFrgTMWWAyyR696Qw23bGyvD?=
 =?us-ascii?Q?6dtHV4Mei5t9IHcdARLVH8nepWqkgd1oPTrwNPFqm7UbZuON738Zjj/z6ZXp?=
 =?us-ascii?Q?4pG6SheGYeTTdy64pf5vPpRSIHkLSnt+VVyEMW1ESQ26l3/aKU+oJVn1l0pS?=
 =?us-ascii?Q?mIi6ZdosalQzr4PRwCaOwm4RQpA+zZGYj27JFgPUw/okZf+zgqtCHDVxzAQK?=
 =?us-ascii?Q?U9y2ImCqFWQBeUkI3qHvk6pChIe7FJZyG+2qVqviTuyTa6qHZAstyzk4UYG9?=
 =?us-ascii?Q?BZI1hEBb14+cBVAGg80G0JhSHBIh/Fb2WeuMndlkc+jGSNbkM3N3SPU9S6Th?=
 =?us-ascii?Q?UjbbB278VsM5OV8SUkmQD4SjYQ3SbEq4JAALLhOUDQzkyWwnpGj1D3xM/TB/?=
 =?us-ascii?Q?RXObzz59RRe/317N7/tKvur257bJalYdrfABKHhG7hwpHvhsrX61jb7piB+I?=
 =?us-ascii?Q?1gvvH8tJ5ZzrizPqvtGuoXNKXbaPa37oYx2nffuvQJurclHiXbI/B2pmUbi8?=
 =?us-ascii?Q?k/5wVqtATgEaDFmSUIIBa0FV/YvQ0lMYdq2x+XI7d1bTEHd+FQ37hvdCdy9Q?=
 =?us-ascii?Q?1CHf0hgV715ciblPWR3Tsh8ZxWlJbyALF0VUQDU3xooNI+W6CQQFx0zbZrq+?=
 =?us-ascii?Q?ZsqgkWS0eweqdWZVqq+cBOqWDjkifppMEnkmHmELXT3vjcuj/HSLzx3tmP55?=
 =?us-ascii?Q?vpOHn3WWt/1vCsBSuCQACv2AVNfzgjj8wg3L1Lp6Yb504xnTzbN+PpWuaUZG?=
 =?us-ascii?Q?/LIs+iMmNyJcZ0KK6/a0vDYv9MYqtEzlh6lbFtbQphE+FvBw4hSTDw0utUUx?=
 =?us-ascii?Q?hIYlwYt+MsmkV/x3Hia5UxBxxnSEBUEsCm0jZNezQW4xeeoMSntHZQaBR0/t?=
 =?us-ascii?Q?HqyOTVhFiQwhTklMAXo3BICrqaacUK7JOrKxSC+InnJ6iEOUrQ+hOaAdOLdi?=
 =?us-ascii?Q?e0T2Tu3Vu9z191KfjGxleu356Qk2mKHfmG3BdIpA/mM0Wg8PsBmn2Bj2Lcq7?=
 =?us-ascii?Q?ZwsvAdLxbPAQV88TowLpeV4xUsAB/5Ka6k3+hYk7eGDqvwuFfiKrOY1ulFTu?=
 =?us-ascii?Q?2/W0zNr/nejcDSMpBDSpNMHGs2tjna/Ecq/U24Seua0+g6S4NtCIzPesH38o?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4c3b158-b05a-49d8-9268-08db0912e973
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 13:55:04.8626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HBP7/2Zvv8G3wGi9XKzDeNrDDFXxAo4DtKRZcPJJEKdYkN4L1WVNFzDqPWdfWspzU9c3kIKGn8kp6MlcpD3HJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7299
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
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
v1->v2: none

 net/sched/sch_taprio.c | 43 +-----------------------------------------
 1 file changed, 1 insertion(+), 42 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 1c95785932b9..d9e26ddaa7f2 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -499,50 +499,9 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
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

