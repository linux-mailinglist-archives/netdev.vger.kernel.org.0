Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC2585B991A
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 12:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiIOKvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 06:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiIOKvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 06:51:04 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B10B80EA0;
        Thu, 15 Sep 2022 03:51:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDbuMrLiSk5BKqqO3CoTMswFlh4oAZs80jeZ8W5EigQgwhrjhZkG2GszIeBjAMXLkIWJb+LGD7WVKULJ5lyeH8AR2Qoq/J+UrzEYmQX2janLAIqOA6zzp85agmrD0LPVxLA/SuXn81EomjNmAqk9FgLKPFAA5VjkL+ZY3VNmc9M48G53M3yQwhA/m76iP8D/nC+9+9bPHfw1awvCHFh/0BdfBQnRY2IpHWCWnlbHAmkaPl55CqCVygQTBeIM8VzdTT/dxZrzHOeY907IBRWE3tRFcLNgTuIrQjW/OGIh8Oxo2PVMCJ2A3MKlyJCJY4KB+HyQgxl60E8JJ5eixcb7Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVllrFQAyaq6mv4H0bPEc2mXWu0XjDAty9O/abvxXVE=;
 b=OLi9i6D3uMtKLwS5u3HmFC9zujsXfiImJMk9rNNRk5lwsGts37+lIJu9Jd7Gt0aEN9wT6m6fo910Td0m8rL8jF6iN+DEZU5Z14fmhkOOh/wKoU0kWWqAnThgWZmyH2GZgIoDWbttKFo5KaLgHvzN4Z7DuA6570AShW14b1JJIvC4xIqx8T2fe0tPQ4VV9Rt9YXtRP2gbHERBwPDknmaPdAKtN9LS3aoIvJqpirKwGriE04RPt2BVUm0D/5JogwmPhKNtNrYeSqCZ2PhDBG800RR+fW9TaKT5xLSW3qXBC5q+qu+Xj5XMyWmF8Y3XTBHaYjtKPyCbE22/ldmUJoyUKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVllrFQAyaq6mv4H0bPEc2mXWu0XjDAty9O/abvxXVE=;
 b=WVAOSlpAMGp/dPiqXScXiIPuLu7wAABLWpfVq2r60k+ti5sOP4Uj8mbAIIPmni/h+HgcOkQUqi8xj2jJqQ8qUgKxbZ2XTv8hHwXaaugGN5HKbJC1NNXhhOfDNlN2FXpSvy+40C4Ipn0dE/kTWWXQ7eGq2jsB6HS6IAkGN0CNHSA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB7163.eurprd04.prod.outlook.com (2603:10a6:10:fe::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 10:50:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 10:50:59 +0000
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
Subject: [PATCH v2 net-next 3/7] net/sched: taprio: use rtnl_dereference for oper and admin sched in taprio_destroy()
Date:   Thu, 15 Sep 2022 13:50:42 +0300
Message-Id: <20220915105046.2404072-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1e34fa99-9322-4db5-56f2-08da97082c82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YLTxZMV6RpatO9q9paFbipVoGng/iXzUqu2HflWutbzGLpAHEGX5Ur9dHxyGQTxk1CPeFS2rnMB+7FHgWyQlZyz4GdxvW6B4fWgFyjcDvjJs0srDo/8ci98LGPe0gEEo+DriPoRNCQDbZnYuJRVGANFfFZiMY16mij+DqNcVK6sLlKGF40k7ZitpeJr7jlgfBoSQ89sOP4yQeSH85Agj4TC16s2w+GNpWL0TR3s4o2u8y4Xi8pcZv8LcOhklgh4Y81oHR4n+iAj0FOjiqhAB/J/txGpIkM/DKylLPJoAoj+J1owYeMNsDOoRnWv1V9prHHN+R9GJPMRImKzUE0tMiLnxyzY5s7Y8CXl4NTyC/l1CxzJAGE3GrtX3GNRWWdqPc5ZS+SGu3FxPAThNyXvE73pVRQ3Lm435pVS0ndVN3vyFEbEChWAHzbDdCDH+iIhBQtRJ1GiIX1s5j7k+Pq9KnyR0QhVJt8/LgPXX+SIHj3O8TJPgysdegXphTiknXuA/iEt2QS25RH6KMWZmC46e6NiWkuS9Wm9c+JLdy0e023rKg3htOUC02zECpFXC2IrozvPswQaDz80dMZTau2u0f86CzPs2iLaTbLzIluyZDBzgZCBLx9WNKVAfsO7uTQ2aTHrvF//14CNmg+4kujMWpBlcgsmMR8tkV9Iouyx2gLooB84YB6CiZRv4BZ+Wtem928EQGwlom3Qx/pqdJwyg5foWViTxpW/i1L204Dv99fnEhSeYHCqvWOCQijsvHzTKtP8v9K5EBhzZLvRF69srFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199015)(6916009)(5660300002)(6486002)(7416002)(2906002)(478600001)(66476007)(36756003)(54906003)(44832011)(38350700002)(8676002)(38100700002)(6666004)(316002)(2616005)(83380400001)(1076003)(186003)(66946007)(41300700001)(6512007)(86362001)(4326008)(6506007)(8936002)(66556008)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aKklTgPfg8kkBc/Zt0SnmRWD15tinZiEP8l/NO4/4yA3ksHtO9EAHKcgMnvl?=
 =?us-ascii?Q?WN72446osBcDG5EOetloIUiJRKuQEMPVTDo3yPi89GA8VY6BpqaRdjo2LoWJ?=
 =?us-ascii?Q?MztSRqXPdShfRLhABKYXKmuL1ln3frD2k1EBWc9z36vCNTCiZynHRqK6yZQ1?=
 =?us-ascii?Q?cEJ09w0akAxXOfL7qsiD6lKsy/VCyy9AxLlMKr2z9OVRFTciuEZTOpi1f8rx?=
 =?us-ascii?Q?ahfYNL9G60FcUzpC/Zn02veH7zI98iVqYzkIYIUnajDktU6v6Hd8But1Hj5Q?=
 =?us-ascii?Q?Fe//6VS1Ps0dSzOco/QLpzvuvY2RoOx//j7yskOJjd6RI1fcCFEgJUhHt6mm?=
 =?us-ascii?Q?V6CYLzElVwY/sddwcxs8vTVCZgSFm+16F1knszsewCgxuHJSir7hHbf+Knfr?=
 =?us-ascii?Q?URWgr/k7pt2r0YxVfuw+LlK+F5o6o719OKL1gugNiwv7DKdDCoQ2mfYeEjDj?=
 =?us-ascii?Q?ToGkh1DHrrF9Omy2ayDyDEry7fM5ZK1S/M5aosONuPzoPhr3Yaz8GSXaDsP5?=
 =?us-ascii?Q?kqysEw9sxlG9GLbw3sYB4aOdVRpK4BIuZoaKUSkAG7eSdRDGC/P+jpKpm86L?=
 =?us-ascii?Q?SzPLZWMEz0ymWl7ptbFaQ/D0yTqOAYkXiqjbaq2kE20SkZ/Jqd4t6vJcpHrf?=
 =?us-ascii?Q?APfeEIXvAiRD+wHNnCmwZwL7GfkXICllFw8l2jBu2gTnDf7orW5OF7q4xQV/?=
 =?us-ascii?Q?8NaHjt+HnTn77e/OjHFKhSx5MXsrn13L1JkYIf5AxvCiDSAFeUATRqTZLyjz?=
 =?us-ascii?Q?m6m9yG/67NX+yAsYsyD8en7gu1REpRkJlYQUtoRvQOlQi+2IA/0+XnwCb6wN?=
 =?us-ascii?Q?zXM0wwBHyAxcPAd4sxbFBRq8GPpirOhsMqIwu2vf7kQRHISz7uJzJ1mGMmS6?=
 =?us-ascii?Q?YvybkcV0ojICyIOswoGe3+aTuWMDFN/iuCy8h9oE/KL68FmnOxW0LyX/iW1R?=
 =?us-ascii?Q?GgOi1EzGpZ/Wv/NWi4eWuGTCRG+i3rDC2HoBpXHHC/m4QGCMVzR+NvVWygIT?=
 =?us-ascii?Q?NfYn6hHPKzEdtcEjiKV4+PYc7KfMdGR+I10nDsdkvdSDXU+PQJo+8jvz/MWp?=
 =?us-ascii?Q?M5kJKNl6R8Ed3+vOemvcBZEY9GcRT2FSxKasIjdPWKUQWh/pAAGUmNbrntq+?=
 =?us-ascii?Q?iQyPPcrWBwdtXTfYv+5yiuvSEKWWgHoBP49Jyst0ARuTfRqFp0U7cyRPtky8?=
 =?us-ascii?Q?NuSkf8I6E6ckjSL4jJ+YjikoZgI84ys49+9fAsHPhGnM6OSfU35ZbYdGjLiQ?=
 =?us-ascii?Q?bUVnRpG+RKZyZMpBaF0lTla4kS+PCnNALgYykiBAauErPorkdXD5rm0LX5DM?=
 =?us-ascii?Q?sg7e0/ceQUwHDZwRF4SIO7sQxwJ64PIGrYHI6fomeLzV/Mqi3qGmG80OmxZ1?=
 =?us-ascii?Q?vTSVp/rHU5wEi2H8J5gV4kS9qJI5VpB6IwN9m9SQkfKPC3bWCMpC3KR7G3X1?=
 =?us-ascii?Q?I6OBXu8hO56yHimNRLx6HjVgh7gemQVDx5k6CLUAcZrIPLiHRdD85TunyNNb?=
 =?us-ascii?Q?vR0DtCXpb2jBBopQjf7qGsW1OJT6txNooxs1ICXGksYUppjH3l8eOmm+iRG9?=
 =?us-ascii?Q?Lir+Nw35oo+mq9wG/ECjazov/ybepjxbcWMIoWdF0+sFb4W4+CtzT9d+61OK?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e34fa99-9322-4db5-56f2-08da97082c82
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 10:50:59.0649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUct/gTwpaZNAH4Oeh98AHl0oFXziYXbF0cpweKZ/eZeTY0/ou6wLeL6I42FpYQjhau9xmnjTjjXKkZanTYtHA==
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

Sparse complains that taprio_destroy() dereferences q->oper_sched and
q->admin_sched without rcu_dereference(), since they are marked as __rcu
in the taprio private structure.

1671:28: warning: incorrect type in argument 1 (different address spaces)
1671:28:    expected struct callback_head *head
1671:28:    got struct callback_head [noderef] __rcu *
1674:28: warning: incorrect type in argument 1 (different address spaces)
1674:28:    expected struct callback_head *head
1674:28:    got struct callback_head [noderef] __rcu *

To silence that build warning, do actually use rtnl_dereference(), since
we know the rtnl_mutex is held at the time of q->destroy().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: resend to net-next, use rtnl_dereference() instead of opening an
        rcu_read_lock()

 net/sched/sch_taprio.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 63cbf856894a..6113c6646559 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1636,6 +1636,7 @@ static void taprio_destroy(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct sched_gate_list *oper, *admin;
 	unsigned int i;
 
 	spin_lock(&taprio_list_lock);
@@ -1659,11 +1660,14 @@ static void taprio_destroy(struct Qdisc *sch)
 
 	netdev_reset_tc(dev);
 
-	if (q->oper_sched)
-		call_rcu(&q->oper_sched->rcu, taprio_free_sched_cb);
+	oper = rtnl_dereference(q->oper_sched);
+	admin = rtnl_dereference(q->admin_sched);
+
+	if (oper)
+		call_rcu(&oper->rcu, taprio_free_sched_cb);
 
-	if (q->admin_sched)
-		call_rcu(&q->admin_sched->rcu, taprio_free_sched_cb);
+	if (admin)
+		call_rcu(&admin->rcu, taprio_free_sched_cb);
 }
 
 static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
-- 
2.34.1

