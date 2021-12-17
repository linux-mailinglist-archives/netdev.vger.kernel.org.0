Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECCA04793BC
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240224AbhLQSRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:17:30 -0500
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com ([104.47.55.102]:6598
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240214AbhLQSR3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 13:17:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAigDkcgBiRY/CK6JNFa3QBppkYSG7i2jbeeiRKaENNhra29/VlYLoW42+pDCwR/A5RW5hYiWxdulUaN5P3KgeRuKyMz1k03t92GkHe3Hi2J3wjn4QMZrc8TYLcFZzlyWOS4r4MjwbNPFLMakIcULW7xB72asBVUbkpqtjzckrzPx8efKPn7u2kSdlaLA2/vw3A2HmvlXx78NnOm3XZvAQU//hCNW+Gs/I1g5JHyYo59Gip3yhYxp9OhuVKvi/Mt02PxBZCjGL14fQDMomKIAp46gbP9Wm5Zr2CCBaylmoyxUNe9cAojtN1H+KpE7RscDVFOSk547LABCyQrgmLjDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1G4tyxFc3zVOAmfbFEQn58jDSjQMx8ROLT5iAs0ugw=;
 b=UUzsfNtzHlfoZPe/mpMg3n43kCGq1FlTjmJb7/mg1mBUstKRcC5rxcVswMHidLlqQmnCLGu6AW7MPHJvNN76OVJx26y7Me2bDhL0e0NBE7EvJ8Nq+HIylGBU45COEnQh13sZetcs97agOdyk9k39fXIwleYJH0J5xsNKD8n2Na0STooTdadYvMBkYhyCX5MedbB8fzoHRTM1PCgOKPVBfahJ64gk9dZMNl6TQeFEfFZoh/P8MrtilrLNBCOsgCwPyGupOK1Z5gRe70qRkcNM5L2PBawyXNj6OefTDXHtyH5VQyQOIilM580GtQAqnm/FFQEWpmqrm0VKaoLKc7O64A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1G4tyxFc3zVOAmfbFEQn58jDSjQMx8ROLT5iAs0ugw=;
 b=W0e9hL5bYnoVVYJCMNA9NGauVglDTH/Bo4oFaxtT5Mix77rnLA+KOLzc12FO+N8bMBJk/vMUTq0HN3Pj2y7QKNoAEwuUMJv57PwztwjwzA+SWTEk2ntBZXx08oY7EyeqX2USeKPxQtmVCp0Rk8W2vj3HtDZmsQ7c5fOMBihn8TM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5589.namprd13.prod.outlook.com (2603:10b6:510:142::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.9; Fri, 17 Dec
 2021 18:17:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 18:17:25 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Oz Shlomo <ozsh@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v8 net-next 04/13] flow_offload: rename offload functions with offload instead of flow
Date:   Fri, 17 Dec 2021 19:16:20 +0100
Message-Id: <20211217181629.28081-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217181629.28081-1-simon.horman@corigine.com>
References: <20211217181629.28081-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0097.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::38) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47af73db-31c9-45cf-0cc8-08d9c1897a30
X-MS-TrafficTypeDiagnostic: PH0PR13MB5589:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB558991FDE385FCD5B16724E2E8789@PH0PR13MB5589.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +hOSClMVoZ8kyM71+GU48tgVKAARgrpIsK5wkW5tsqAPtqmiIoGUm4Ktmq5vlHjMfV8DhxDHGTt+I1veHq9ixsFh21JZXp37FV/aDf0RD4aLM2IMXM5/dFt1lNohSlAaqBPbhbTyVkd5ORwK9u5Xrluo2smpV8BokO96om02lEB13Jk4hK0aX03owyWviuzZ9G3aRcIEq32of20r4EcHXQk2yq/abdUk5c6680mVJBFU4NrHBPMFHMxFbGZlPHpm3LzJjqJyVu1+Su+wiaYARCoFPn56aVCmWIcMMO2ym77G+eqinMO2GvLFBCa/zvhhUVb6SsZV+0PEY3H2r+CXFHCT++QMdMo+XVQWy92D74WrZmH2MW/nXXpcqtz7udogYhB2N+pdI1gSdVQV4rE5gnVZ+YpbkGDKrtGdH6Vs24CVaJ703nb7KZXsxeGmJnFVZQexl8MIwQR1XxTLAQx0i2RLV8+Eopoe4aFth8FU/UkjVzJumC7u7QJoCvSc5LKmwmus2O7OdRDMY0jJC4MstUz3kkyMAeSVb1wsrpqoegg20SQAM1BYICV7Zp2vqzcy1DPYTM7p4bx2S71dK+9btJP+YQ3WUG5YOG2LyF0vp3FANliRJwzLpdTBrjUc7PD28t2P5s5g6NfZH75vchif5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(366004)(39840400004)(396003)(136003)(508600001)(107886003)(52116002)(6666004)(6512007)(86362001)(2616005)(6486002)(186003)(83380400001)(1076003)(8676002)(316002)(6506007)(2906002)(54906003)(66946007)(44832011)(110136005)(7416002)(4326008)(8936002)(66476007)(66556008)(5660300002)(36756003)(38100700002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eM3cBmTuRfLy5tmh3koByvG1JLtz/G56RRYevZnuHDnySEqe/VqzqmQ/Z8nY?=
 =?us-ascii?Q?6l+WwKGKJduyYJvOIx+1NHAf6VKzOnjZBlpXF3a1/6FdeXq8Bleh80wjdM2L?=
 =?us-ascii?Q?sHGXKgjuHgldWjpn+/pw7m4XlkMslziOTL5RRAauRXIzHU4w363hYt8sxnn8?=
 =?us-ascii?Q?ELqz1ppoPkYM32KVUUv7Q//xvyrKfL974lQ0+0bMnYCGt0VA1bRzLI9H8S8O?=
 =?us-ascii?Q?8YT6QEUl2B3Z/ZuzuZ5oRP6yBU4CPrLZD1NwJsrD/pXsI9PZavixpuZ4AZOT?=
 =?us-ascii?Q?YAfQowUA+8gG2L4030NkH7zk4RDEpN4NsmJVS25hiXkB0ysOijrAFv+wRukh?=
 =?us-ascii?Q?0wo3bWU2Rx0VMhEcp2Ox9gJ0r+33uTIjJSJ9LGYaA8im19f2f7OtefLonEOZ?=
 =?us-ascii?Q?hrPugjBchdSkAjvJ+uUE+nTWf5I/SMDI+8QCk4m6D8u0Vhntb3iHkci4xdms?=
 =?us-ascii?Q?uE3pDJdTWwUpCRnNswSyFyGX2yGdtru+xeNho/u6/fgRimQkbeyOIpXYDkzB?=
 =?us-ascii?Q?EdBEiguKvHhd6RyHPlbC7zcJb3h20UWUJLCuNfiBP8NbpotCya8qS09WumgQ?=
 =?us-ascii?Q?xBCTJvzC1LqUjLu+Kl1psiAB+/q8zAcU1kKFDADyB+nvQ4a9RiuJSQbLWLN+?=
 =?us-ascii?Q?y4kKMgS2k1MSxq+CR+pRO0ixxRwl1bEzMgiX+P4pZDof4wC0PIIL1I1EgttW?=
 =?us-ascii?Q?DSeC5lHmjCuNAYDdCyw6T3Ax3csmSUzZYJQYfwu03LxasPbx/mQOIiONASzq?=
 =?us-ascii?Q?yUDVmAYXuVDzD6yEbUSt8vr2ZYlDeNZXIQ/qQ4iIM2tYEk/dIO5OGXeoEtWQ?=
 =?us-ascii?Q?2N+e92ZwoJ4n2sKgvUCbA6rKiZqwsmhQzqV6TpmVjCKjnR+EVCtIKrBjSUwc?=
 =?us-ascii?Q?+9ZxW2JYs9uPoi8Bc/MW023IuNIn2w1kRlh6HJ3R64fye4Q8SbCoEyU/OfbJ?=
 =?us-ascii?Q?J14H/X2toFXLSvcvY9ulZsIaZOoWzIiLwGx1mmr1zXHBoGE4v2gpdk+ICBUN?=
 =?us-ascii?Q?iWgVxbJ7lH28uSjVMkALntlvqJyrIcxU8b1fhlPmS4iIQCKyilTbcYWqf7zV?=
 =?us-ascii?Q?EIPB/Aa3yuapNk5ZlNnBGvW+cx0OlVKDMzoGuKVU8WPBYjVFNH1cx49LyWaK?=
 =?us-ascii?Q?kEgpPDEiN+SkHcgVF8nuHmr+PyFqwEhmRqdoV4stXFLGAyRowCKThD4Jrbhv?=
 =?us-ascii?Q?g5h/rGlnClubE+D8L/wO2NjALbwTX1VxKWOqLSlCFxeWs8ro8Qh48rfbbub4?=
 =?us-ascii?Q?4NjChx6iOpl4I5yZeqyDrdto2H88oMBRgiz2Xenc9bZ5KCP09SZgj9WMjp+/?=
 =?us-ascii?Q?b7q1rqsgdDcqA/63ApGks5F9s4qkQOZEFsL2yZzODVqcJbwZGpSsOf+MnPW/?=
 =?us-ascii?Q?mqmnzJ7ar4IVTWu3VVrBZ28q7v4BrgpPkm1Ljkm+Bu8QBWlXO2BkxrVpoRdm?=
 =?us-ascii?Q?jVjetiPn6QpaIIjx5H0uMi/iqQ4NP7rMp318OXjT6RtCQcya2Rg4UsWHK3lR?=
 =?us-ascii?Q?LAUTvubX99RRZxVUPozB++dg2kHYIGTOGCYvoD6dGPOMWOM4E6rhE5LcjPqc?=
 =?us-ascii?Q?fFc7LB9dkM/vIwYVaGZPxpfbuQfj6fGQBR72rhrXnfyND63u9aNd7qol7JhI?=
 =?us-ascii?Q?ezg5iaQDHVMMGPmvFjLFhBvr7Ma/RP+Qor/gTc1p9d89CywOO1P0+U1azThw?=
 =?us-ascii?Q?2D36UylPnhN11+q33+bHxX6dU18uGDqDD+JFk5s6U4USeRbxc5h5rn7tc6Fx?=
 =?us-ascii?Q?pBYstDAdjA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47af73db-31c9-45cf-0cc8-08d9c1897a30
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 18:17:25.7411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nto/sEsGTXrAqgErNf/PfrpxiFZjYOwIzNt0Q7cTEw5qkd72v6piMnlffPvl4S92bLQ94bKD+WhvWZzjf/fyPet+T0leCFD9Jcsh6EipjuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5589
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

To improves readability, we rename offload functions with offload instead
of flow.

The term flow is related to exact matches, so we rename these functions
with offload.

We make this change to facilitate single action offload functions naming.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/pkt_cls.h    |  6 +++---
 net/sched/cls_api.c      | 12 ++++++------
 net/sched/cls_flower.c   |  8 ++++----
 net/sched/cls_matchall.c |  8 ++++----
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index cebc1bd713b6..5d4ff76d37e2 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -536,9 +536,9 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 	return ifindex == skb->skb_iif;
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts);
-void tc_cleanup_flow_action(struct flow_action *flow_action);
+int tc_setup_offload_action(struct flow_action *flow_action,
+			    const struct tcf_exts *exts);
+void tc_cleanup_offload_action(struct flow_action *flow_action);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop, bool rtnl_held);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index dea1dca6a0fd..61b5012c65dc 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3461,7 +3461,7 @@ static void tcf_act_put_cookie(struct flow_action_entry *entry)
 	flow_action_cookie_destroy(entry->cookie);
 }
 
-void tc_cleanup_flow_action(struct flow_action *flow_action)
+void tc_cleanup_offload_action(struct flow_action *flow_action)
 {
 	struct flow_action_entry *entry;
 	int i;
@@ -3472,7 +3472,7 @@ void tc_cleanup_flow_action(struct flow_action *flow_action)
 			entry->destructor(entry->destructor_priv);
 	}
 }
-EXPORT_SYMBOL(tc_cleanup_flow_action);
+EXPORT_SYMBOL(tc_cleanup_offload_action);
 
 static void tcf_mirred_get_dev(struct flow_action_entry *entry,
 			       const struct tc_action *act)
@@ -3544,8 +3544,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts)
+int tc_setup_offload_action(struct flow_action *flow_action,
+			    const struct tcf_exts *exts)
 {
 	struct tc_action *act;
 	int i, j, k, err = 0;
@@ -3718,14 +3718,14 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 
 err_out:
 	if (err)
-		tc_cleanup_flow_action(flow_action);
+		tc_cleanup_offload_action(flow_action);
 
 	return err;
 err_out_locked:
 	spin_unlock_bh(&act->tcfa_lock);
 	goto err_out;
 }
-EXPORT_SYMBOL(tc_setup_flow_action);
+EXPORT_SYMBOL(tc_setup_offload_action);
 
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 {
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index aab13ba11767..f4dad3be31c9 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -461,7 +461,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	cls_flower.rule->match.key = &f->mkey;
 	cls_flower.classid = f->res.classid;
 
-	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+	err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
 	if (err) {
 		kfree(cls_flower.rule);
 		if (skip_sw) {
@@ -473,7 +473,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 
 	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSFLOWER, &cls_flower,
 			      skip_sw, &f->flags, &f->in_hw_count, rtnl_held);
-	tc_cleanup_flow_action(&cls_flower.rule->action);
+	tc_cleanup_offload_action(&cls_flower.rule->action);
 	kfree(cls_flower.rule);
 
 	if (err) {
@@ -2266,7 +2266,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		cls_flower.rule->match.mask = &f->mask->key;
 		cls_flower.rule->match.key = &f->mkey;
 
-		err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+		err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
 		if (err) {
 			kfree(cls_flower.rule);
 			if (tc_skip_sw(f->flags)) {
@@ -2283,7 +2283,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 					    TC_SETUP_CLSFLOWER, &cls_flower,
 					    cb_priv, &f->flags,
 					    &f->in_hw_count);
-		tc_cleanup_flow_action(&cls_flower.rule->action);
+		tc_cleanup_offload_action(&cls_flower.rule->action);
 		kfree(cls_flower.rule);
 
 		if (err) {
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 24f0046ce0b3..2d2702915cfa 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -97,7 +97,7 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 	cls_mall.command = TC_CLSMATCHALL_REPLACE;
 	cls_mall.cookie = cookie;
 
-	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
+	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts);
 	if (err) {
 		kfree(cls_mall.rule);
 		mall_destroy_hw_filter(tp, head, cookie, NULL);
@@ -111,7 +111,7 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 
 	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSMATCHALL, &cls_mall,
 			      skip_sw, &head->flags, &head->in_hw_count, true);
-	tc_cleanup_flow_action(&cls_mall.rule->action);
+	tc_cleanup_offload_action(&cls_mall.rule->action);
 	kfree(cls_mall.rule);
 
 	if (err) {
@@ -301,7 +301,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		TC_CLSMATCHALL_REPLACE : TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = (unsigned long)head;
 
-	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
+	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts);
 	if (err) {
 		kfree(cls_mall.rule);
 		if (add && tc_skip_sw(head->flags)) {
@@ -314,7 +314,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 	err = tc_setup_cb_reoffload(block, tp, add, cb, TC_SETUP_CLSMATCHALL,
 				    &cls_mall, cb_priv, &head->flags,
 				    &head->in_hw_count);
-	tc_cleanup_flow_action(&cls_mall.rule->action);
+	tc_cleanup_offload_action(&cls_mall.rule->action);
 	kfree(cls_mall.rule);
 
 	if (err)
-- 
2.20.1

