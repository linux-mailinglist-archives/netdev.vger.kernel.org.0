Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62FB5B8AB4
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 16:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiINOfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 10:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiINOfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 10:35:07 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20088.outbound.protection.outlook.com [40.107.2.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A885F27B2E;
        Wed, 14 Sep 2022 07:35:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H521pvMKZ6WY7R3mjQMZ571RQJjLI9pB8yxMZYJJ9hnFKNI1k4NI6ARP/5qE6t7prqRQmfQq5gE7GJ3b1XU/0Cm+RMqFbxXlkRLlt879LjlBVW4mitfPYaXixuuWKDP1amEkpmEKDQqzdkrrBfyeACT91WHixPtOAAQMVBbHlBhuurSNReWpgWePWBmAusHeCA5FnzwTnPeKv0P3nt/PAl/Y/DuHB4KN5Y1uHg/TFhSKwNDE4RFcMVrn5ej2gRR2qiLwTawTMy8dCzV+eR4LTMzvPBW5uMVwRGRCWjhibDIPvZVe1nmDydmiTTav2SiM0lAlml9gesIGoTprCLIhZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nujzADmc83/SwpTE1WwQ7EnyrRX/hSkqL/6Z1vjgfk8=;
 b=dY9osR0mmbI4KT5fapSZf368L0klC3hDWWQeTz1xkD/EFRlNZeMwhW14iI/K5ItgeAmekzxUONFn2HSgn7mcg2U5d8082cvl6pgm9nLYy6GKjS++e2+k53uPTZUhyzgU11w4xvjSCW4Agr/1IWSPV81PDkIMEZfv9DrTCFK9J1K2kvq5zzek+lK/hW3swB9PuO/rvSYtxGbJ5l7f6cTKDQmdgmSibJL6KCf1Zf6BYS5gYmLFW/wSDSE7IH5Ock8XoDcQYFxlkrEneC8l0fBg+GfvhDFvL/jKu4jjmtFvHxIh8XTt92e+ht7IiTseTry8EVIpXnsxz7XxP/cYG5BGEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nujzADmc83/SwpTE1WwQ7EnyrRX/hSkqL/6Z1vjgfk8=;
 b=ZgDL/665YvRfOJx+DLs19V/vdwMP7ZUbk8pTsDxaY8ey6S8RT/umJHO80YK5EBSLsKEi7BnuB28tVqnv/LdH+raA8u4xYXdyeiASe6i7Kgq06xqBsU5goNYD6t9mmA/gLp0Zn8f7snV9LOXVh3TDAhMd48iAtvlsyh+2jxP2eU8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6777.eurprd04.prod.outlook.com (2603:10a6:10:11f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 14:35:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 14:35:02 +0000
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
Subject: [PATCH net 3/3] net/sched: taprio: dereference oper and admin sched under RCU in taprio_destroy
Date:   Wed, 14 Sep 2022 17:34:39 +0300
Message-Id: <20220914143439.1544363-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914143439.1544363-1-vladimir.oltean@nxp.com>
References: <20220914143439.1544363-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0029.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB6777:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f042252-f1e1-4755-e36e-08da965e4ebb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MbigvFrkHxaMRfZO+SmGPOaNVk1Ldw4kGtelSGpzf2yinfJY4dcbU6Z6+Tgz0KWZe2SkacwUKSbfH4oAt56QPSTGyf1rvm+xVhd710OLlKXQUv2MI4rHUcxzKgXAhHumYWaffcSfw3SWCbBciTloF1nawUY5+tIxAOeD8qOPBPyrZfGiYL8jksik/LSBl6gxU9joicsR31mgOitmDDnvyXQ9joG/RyAvcjqZdxEMJFyHNQbZu3YbNYzL8ZtHHHZtCfi0DGft5FSJ3q42Wb+8Xxoo8WiAy3ysGmo/M8Utm+OctEVJB5cX8sTP5l6p/+Z/g3uIJySwISEd6N1RVwjZgUx+4KkvnLhCZ28fZ/iu27Jn1gdUdg0vBZEaz/AGURgv/Cw8CMYzLf52JX46ITrz8pKCV8bwwtuC/fBEHHw5u2HjWs4aXbO+AwPocc8kaeEq6c1hzwndkrF/cchDP3VasmsOehAC0YbOBt6H/dNXgZGqg5Y+yMENcdbD8LsWVvcQOOQDIFwOO5/+OOoPO20SDEqjKztklPWIXBeLI7WM1brV08zOnocwe39QxVMaBwYPlYocTCnGiqXGmZalKtMpa9mLaAZiH6RM5bYsuKeDk95Soe4hQYa2j/vcw46vxLcUt52I6ewGLxWtSBOkQJ3UZS4zR3cIE+kLIzEoTMrwt+KEUr7/J7juC7F6iVQ1Rie7B+50HLmU3bz/8Oosg719RHKqZgv6jOQ2DSk6HS3/eiBVMC1adN/ERajBAXx8BfmuenzHncwah82bCOv5X1jkGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199015)(6486002)(4326008)(38350700002)(66946007)(5660300002)(6916009)(6512007)(7416002)(6506007)(2616005)(1076003)(66556008)(52116002)(36756003)(41300700001)(26005)(83380400001)(86362001)(66476007)(186003)(8936002)(44832011)(8676002)(38100700002)(2906002)(316002)(6666004)(478600001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XMH16pDMXJn/+uKx4u7q3IqKXMfp4ndIMYMZ9l88VhrkkidEhSlV789A4DfP?=
 =?us-ascii?Q?mB57JIVUge5fLWkNYXDoNu7OKsBs4+M1u4rWoBlsikCN8lWprgPQNMKyrENz?=
 =?us-ascii?Q?xfBrW96BQP9mV84fePcHHGZUiUdANrMFRHDBQfG0hjxa3/FD+1xBIAIjaj4X?=
 =?us-ascii?Q?31az2sEtXg+hi1i60Lp0bbVU6WCyqBcHJtTXzKpkx1KHLo1t9v2Cq2/EBcoS?=
 =?us-ascii?Q?JRP5Bzdnu0G7UKR5ANk47VV/k1FW0F+UMQkqbAOkbli66/DXPt6GxVqu+RRT?=
 =?us-ascii?Q?nyKIbA0TQU4av4lPM9Maq1CzZUWXkmPfYfdeos076RrRHMM9xH095o5S8tHe?=
 =?us-ascii?Q?U+NsmcQ8p+k7rx/QFrOrsnoz1aEMR6tLu+FuXHZwmQkDkek2g7zlfdVkaqFp?=
 =?us-ascii?Q?PpnHJS+wr8K/r+nqu2YJYVJrnAC9FSeGeUWKZvlAYne6VQOPPQBO2aJdDyNK?=
 =?us-ascii?Q?C9T8DVuMKLOeENZgI84R8jvfsMbF7Di4q4BwZw+o3Lausfr93b7UxJpAOuoh?=
 =?us-ascii?Q?Fz/olYNjxO0tSQwzripuzkhtdORWJk38pUlX2rr8ROFfwLJvlg5jB42B+7k4?=
 =?us-ascii?Q?gwiXsQVYRRe407E5+j311AIX9H8hkR/81dyjCQbak6xYQlkKb86AaqkcF4xt?=
 =?us-ascii?Q?6OsidqLzIrD6fj1ZWkK/P1sPqpa56c9a1NEmSovE2oSqsCHsjLQUc0XLKHtC?=
 =?us-ascii?Q?AY9yJPsN6fYQQhEVNu/XmFsDe8HcrnjgxV1hQhkU+88onNNeSFtmzeN1vvPG?=
 =?us-ascii?Q?JQbK8TREnTUuCdQ2i3CaIDI7n/tE7GxeLOjOUVhm+iwZX2IbI6qS5gsEPcDZ?=
 =?us-ascii?Q?Dsi+WdEq74ZVyC+C+gy6tzuhX25v1v87YJOvfOwNQ+HCmz8OVKx6YW7h9LWv?=
 =?us-ascii?Q?qhvQxJ7oYqeGvn8QzdIJUJJpfCkE0lsAC4IJp8ooDqFBys3o7mmPvW+f9CYA?=
 =?us-ascii?Q?HzSDTCGPlPIBK7YAKaFgiSmI44g6ANfQPFIgvYiZC9TLB4NxiQtSBu3qs5tC?=
 =?us-ascii?Q?zNA85RubbnzJ7zUCXu07za+yDGICYN34xL+zyg2HlfBY/JfwMuxA3t8KVbhP?=
 =?us-ascii?Q?yWxYfdWKmnlIakXg+U0TGA5cxsV2qAXt/+oCB7TQ/NIDvKIzcukuzQdpvTC0?=
 =?us-ascii?Q?HW2eQ/iqmGYIhAF1vYlpRMKc1NDJPJM7X5VuuOpINCzrNpik45WDZzLlMV9I?=
 =?us-ascii?Q?o61XF1/wGOnNuMUYB92hFWJS6jbG2YVIo/N7SpetSs0Sm8cyh3gZxwnuk+Sq?=
 =?us-ascii?Q?ADBuO3y4WjF3kqarxwrNMKMV/LqskF/4bElli883b6B4aW55GE78koRAHygo?=
 =?us-ascii?Q?eKNpeSwjhboBZ+WJbv+33UugJNzr/JQQjqFCjg8alH/YflGrkIFRSUxXPRUR?=
 =?us-ascii?Q?2PebDL+0OxTdPp2IbIIzgOcRnEERT4Q9TSr/CML95b8v9F1uE+ba+WbWyg+F?=
 =?us-ascii?Q?4itRsDPOIiaw+dTuEftgb1WBeExD2pfo+5rdNqGjByUMv2oJpETmz3pjisUI?=
 =?us-ascii?Q?vuCeL3ecmqGAIqMXkSxA/Goh6YqpVQAF11nKc3WY6FOJxYyJO1oM438/+8TB?=
 =?us-ascii?Q?13j+KqE0e55jdfaNwAXLBSr6MONJVLWFrYaKsqbd1skIbSujVjdqrDXWL2uO?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f042252-f1e1-4755-e36e-08da965e4ebb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 14:35:02.0093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tgv9Pz+kl2EOo1iwcSCmbwGEau2tCdKRm2sF/Ovb4aqCyG4xbx5fVIgufCZFY95CsLTdAPc8V5Uuj/apvBZXPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6777
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

To silence that build warning, do actually use rcu_dereference().
It would have been good if we had a writer-side lock to be able to use
rcu_dereference_protected(), but even the writer side taprio_change()
uses rcu_dereference() on these, only to close the critical section
immediately afterwards (and still keep using the variables).

Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 5bffc37022e0..fbf84404408f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1644,6 +1644,7 @@ static void taprio_destroy(struct Qdisc *sch)
 {
 	struct taprio_sched *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct sched_gate_list *oper, *admin;
 	unsigned int i;
 
 	spin_lock(&taprio_list_lock);
@@ -1667,11 +1668,18 @@ static void taprio_destroy(struct Qdisc *sch)
 
 	netdev_reset_tc(dev);
 
-	if (q->oper_sched)
-		call_rcu(&q->oper_sched->rcu, taprio_free_sched_cb);
+	rcu_read_lock();
+
+	oper = rcu_dereference(q->oper_sched);
+	admin = rcu_dereference(q->admin_sched);
+
+	if (oper)
+		call_rcu(&oper->rcu, taprio_free_sched_cb);
 
-	if (q->admin_sched)
-		call_rcu(&q->admin_sched->rcu, taprio_free_sched_cb);
+	if (admin)
+		call_rcu(&admin->rcu, taprio_free_sched_cb);
+
+	rcu_read_unlock();
 }
 
 static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
-- 
2.34.1

