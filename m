Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31C8478D9F
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 15:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237198AbhLQOWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 09:22:34 -0500
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com ([104.47.70.104]:6434
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234633AbhLQOWa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 09:22:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkxdktAbUBBLslK/2hKhs9OyAeKtWOrveWpn/OZOyXWj0g8BpCAX19ThUZW+XoiPYTdtgHW325A9UnLiTcr8T3gS9E8O5sgV24OzAWrnzJUBLrBe29moQ+YoqDHHuKmRzrUtrgrvIDWnN8cNePjV4VLgrnx/+hYgp1RoorQKZ2jkL5TXbxizWP/VZpgaxxnm4+Q0hjGKPZHydQryZqqrm0ORs1iyBSSsyAYQ5vKrVgs2vw/XlOqV6dq5O3IybvTzZ8m+ZwRn/HLbi32N2P7kASCnfc/YAVAPtj8YcYQbuciPYIMLBtM2gqEtwIHvOsHMUfYQov3pHIunt3vI/ZEVTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1G4tyxFc3zVOAmfbFEQn58jDSjQMx8ROLT5iAs0ugw=;
 b=baLyFy6Y7d/mTV5VLKLqQI0ZvmmI7a8viQXiOrKlnNIUgNwxvdkOGi+b73RegDssmDWVkS+mGgx2c7q7tt2TXRXj1OMGMGhP+yEfqVyG2GOb+TJQmMEDayfY3M7ghs0a4vYxU065qSCaShUN6vFD+PDLDefmUnC25pzONZTX3Qa4iYvSNhgxhKGY0G1RAFUID1zxgpaHjNCSLJht3Fw4c4tc5KKPmMlva3X6w0ekiApImhcdWXX5F88lITiAFwDrSFpkR2RH5zLi5641yqRKG0YGalgekdi5kMBgqOD3j2N4+B7elpHsIQPjIz/LHfgVnRkJRdI8w/0vGAZdY16khg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1G4tyxFc3zVOAmfbFEQn58jDSjQMx8ROLT5iAs0ugw=;
 b=JD2I5QF+1Tqz3GmjQ8cGossqsZL2AOpDRIfJaOUQ+nlXK9GEgy0IbY3Q8b6YtSHFTZswUsB44oF7KUhVz7+CMv22fEdKbmiJpw3iLZ1m7Fmjc57GCgCfBbKwp0vL1UBtZHUzQ3J2tisicJ/phQcumd6U/RGdzdMXzw3dfkvFLTQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5469.namprd13.prod.outlook.com (2603:10b6:510:142::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8; Fri, 17 Dec
 2021 14:22:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 14:22:25 +0000
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
Subject: [PATCH v7 net-next 04/12] flow_offload: rename offload functions with offload instead of flow
Date:   Fri, 17 Dec 2021 15:21:42 +0100
Message-Id: <20211217142150.17838-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211217142150.17838-1-simon.horman@corigine.com>
References: <20211217142150.17838-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0079.eurprd07.prod.outlook.com
 (2603:10a6:207:6::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0e76ff1-2085-43f9-ed95-08d9c168a5e5
X-MS-TrafficTypeDiagnostic: PH0PR13MB5469:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB54698E41C8B34C197A8C02D3E8789@PH0PR13MB5469.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jQ3BNxxjfOHmVPlwNTsAP9vDYF5rVUaEUJdAVJ8kT5hkG+OoXC937HQH2QTMhe1n4Sn8j/3EZ0WZiOkgwXrTnZrHUiykoyqHhyriOg7FVgL+Zn5A4JdgFFa9iuAApAQD/VmHRibek2Dh20Dd5BGfy6e1mJ7qkltUT/Xbiu80pzyH8nv+Ll9ySuHQkOYtsBGuWzHlc7/lnWfjhyKSC0L4YvVqBPI2/d8yilLo9PaymsLKLGrTXSzd21PRyCIEx5Ql6/DQJ4gjhM6TOyQcuw+kZjrIxrPrZMViLIWJW2YEktyB34PUY9pX9J24OQIYaFKtYMnTwUsdMKM0FinJiinuh/5qRis2jPcDIcgn3P/hLyJRdkPZd7KPtlsFue8fme1OcEqk0F4wZXx87aH6vo4l6hZYtC3E+g0QijBJBWcD9U+4Qdndh3TquI8CIDOURbMZRDjP8m+vKp/R8gsQJnAbNQkcv7snciFM8lcacbetKMfN8RoWvQ+yIoHPPEFTS88gE1RefhvfyDTALA0SQGBNGZuSDLMjJPcKNMI/IbZK5nPoUmP02TXX3Vf9ZXn5w2M1jmQ+lKTffCEKmpelOFRpkyxMFFKBWsAE5EMaeA99rrkjjQJtRy7Z9Pc9WuxZfvVzFh0yUlXoFV+aOxiHM0x17/UD35+6Cb25TPap3O+PCHIcWjH9JN0tSn00+pl8bn2a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(39840400004)(376002)(136003)(346002)(396003)(7416002)(5660300002)(83380400001)(36756003)(6666004)(186003)(44832011)(1076003)(107886003)(6506007)(2906002)(6512007)(6486002)(52116002)(66476007)(66556008)(4326008)(38100700002)(66946007)(54906003)(110136005)(508600001)(8936002)(86362001)(316002)(8676002)(2616005)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LTtC866LgxUjnHfGI6PmWPbroHkEqoZvb5//WcpjWTn6SrZ/z1DLzzMEcoG3?=
 =?us-ascii?Q?vsVTDn/81DJIxtwrrapmOl8yrI26ojkgJH0YTBmV71BoLVbM9YVnYeJPrKvL?=
 =?us-ascii?Q?AySpLyg3XtEFUM11dFpof/ewhGbWKeNHNYk5G2Px2FOLRLAKhUqwDvTBrsrZ?=
 =?us-ascii?Q?c/rbIVjRnX9Rwaieeo1M/aCjBYaq02fb3kL/0acD1FbnXz1+a/JWMYr22EJS?=
 =?us-ascii?Q?yOmww4hvui0k3YY1Lf+Tp3KZavgIRZzfKFhIUpkSq1/+5IV+JOf0ENzUC5za?=
 =?us-ascii?Q?AeWbfNLLQSHiC3qVGje1K5oRwjqFcwaMlsxdf5Br4akCvk+b33NXqj0EKmzm?=
 =?us-ascii?Q?16UymD6aETMUyKIHNZT8Ny7H6/dGmWRhsUtPzXTICtoxL0O8f4dPBhwK2F1/?=
 =?us-ascii?Q?ZbN0wwjnZ8ervPj1iHyqCdXtL1dQk1C755Q5xoUzsFOQZyD2TrkGW4AuZbx7?=
 =?us-ascii?Q?QUghkP35yw4N/0YQLcewr8rbjpQ/hybTNuPPZXXubuBh8zVqtPr+CT535nT1?=
 =?us-ascii?Q?sboObZtDUw1ZXyXk6pAsVZcWReL1zvORpjgeqCnzZhx49D8fsmSUvXiw31ER?=
 =?us-ascii?Q?Pozk5ShgYPFxNvXCUNHrt5x+fc1ubVSwNdppT/mrB0P6QMeQYIzBgEapv/BI?=
 =?us-ascii?Q?gpcTsm73vmUhwpVLrarNofQYm6i+lJyZiNd93SBqrF151TvX2hWejNZXyZQJ?=
 =?us-ascii?Q?T2ofRm5VeuzkPU1D9KmByeTYQbHkVhQ0U3F3Z263PN8lUbj9gltKHpyHFdE0?=
 =?us-ascii?Q?ErzI55rFQg8ZJtjzicWhTgb2sqm3Fq7kuKT7qt/VLkPvHGVGcWVZ3u5VIOQT?=
 =?us-ascii?Q?0z0ip75ZxNMpsjKXa6iv1kk3J4IxFlrqx8/ELNVOn/sd+D6eJPtfWt7mrNlq?=
 =?us-ascii?Q?OoOrNOXXHnOpcFINQdA/yVlTsGGkNPOAZQkgQXi9pzDrAUnWsfyZtB3SsQWD?=
 =?us-ascii?Q?8p78yQZp0pwdUIYqmg7eYW8VQDkV7uusbCJtYoQlQd6qzaSLismZ78c1Pooy?=
 =?us-ascii?Q?ZdRJYaML9A++mdh6BBCUWF7fiatxznXJn/iDZKpy3h6x7DspiURBUYZ88YOK?=
 =?us-ascii?Q?QRTLaXG06VmyHQ1ADW2T7zFOXX65cA3h/MMEqWvoysvg8n0aq+Jl3uxq3K+I?=
 =?us-ascii?Q?dHyWjPE/ou7RaVbIeyQHWClWFYT9Z0O8p7JMYNP5Dzrios9BHDgg/VX1z1Fj?=
 =?us-ascii?Q?qC1pDXfhE8Xlskghn1NJ+iSXXQJwReTvefGoX8+oVF9b0zqC+OKePHom7fW+?=
 =?us-ascii?Q?5rAZdQOxqrYviGcip0HEqQmgueB4Q0FXSrTK5N5UalHhY0akRfA78tfNffYk?=
 =?us-ascii?Q?aiSbkJzFvMOE4O3dXRpwZTgqFWrouznuMYytw2kf0BVfVUtGgIOgLCKR4Pw6?=
 =?us-ascii?Q?NYUc5WEMqWSdQnduvawibMbVNPnYJHWhVzNlXQconKbrge+JwIIZZTwjFmG2?=
 =?us-ascii?Q?q85rG6AgV8XRlBcg/8F8uTCtwF9aT17SEgIuKZw8/8u2/yh+Y3z7zv5p2MBP?=
 =?us-ascii?Q?TO5+R4zyMqV7RzJpVGPUGz0DiovNyHoAOWuNM1KpI2SMufQpQMtg+P3yd6qY?=
 =?us-ascii?Q?67Nldy/vBgTOm9qBMgPSJRLbVIa0y9u7/Eh1WuVSVcUz8iO07DUe0leboZDP?=
 =?us-ascii?Q?q/MLJ3/EH88fCcK84MGweRNeyPsnPLV9JcFswJQgUCQdHtwlhDrTHaASJddI?=
 =?us-ascii?Q?xVR6e3tI4OopRfDc4To0oebbDwqsi37rExXFb9dkXr1thibrA4HJV60xbPGI?=
 =?us-ascii?Q?3FXqFfv4Ng=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0e76ff1-2085-43f9-ed95-08d9c168a5e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 14:22:25.5705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /DvrScNJXPWgJG4IqP4cT0/Zw/cNfWdytM7+q2zyhfR+cqzoHcneGNpUSQVGaeHAVK0uxiL5mEe8HlkupPp/WMNmpquOaDFkej3av7uFVjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5469
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

