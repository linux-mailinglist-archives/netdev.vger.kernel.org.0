Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8BA3D1F83
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhGVHSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:18:05 -0400
Received: from mail-bn8nam11on2102.outbound.protection.outlook.com ([40.107.236.102]:43163
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231219AbhGVHSA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:18:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuSdVeD17VzjPjq6euDAx4+vRkOOqUg9Cxl/KwRg/ujylapbfBkqVEP/5YQC5du1+aTF94mDuLTWjJZwkwxPDqs26bxGcY3nooOYR5qFJW7hcBBvf3hjEkmxL9nEoNYYuyGCzkB3ZHG4PcotJ+tg/efTWpnFF/6ZBPfEuf6k4qQJfVyL8gYMD7hWFrW/0M09xkbwUvahdNs4TxlkrAb8W4IU77jRJ3hbxF/r8kMAcbuGBhhl6kbt35uVI20UF2RKzCJo5PRFkNw0rH4AzdStMJDtVZQXQ/qmKewp55cjOSVYOFB41TqL2gSQCa9Q19DNFe+6Kl6Wgx7bo4oAaYbEWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exMRxsHVpg1lAcVliXsuus0Uv8cROtl/IERjGNBR/H4=;
 b=R7WLIBK1JET1BL3DoMLHnvaknb/1Yb7nJn8SGy/u8WLlH3uuSE36axTqa8r/mVesbrrtDH3SF1Xm++gBRnld5X+fBJ1Bk7U6z+hpkPjfVRjgk67pS9SMBU+HOCnYGhKQBPWPnxvwAitGT6qBtoSCI1VM3qcgtTlbRoOeGVxvPzKH1a7ZqJdRWVyOxZF6bXzhgKwuZVTg4fQIWxC6Z7f0wsndiY+WSXVGT/CwX3vvtdVMtq2m1wxN/f5johWezv9cWTweNkfReDZukfxyArYu/oUQYfVlwSttKEoak+p18i/KjpSuz/1zOSzqMOhd91jXmDPjEWsj4E+B3iDvNLaPsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=exMRxsHVpg1lAcVliXsuus0Uv8cROtl/IERjGNBR/H4=;
 b=AL1AlSRZPHIsqqtQxp+N0J3xJPmz2yF5hJCl8xO26bRUPjNDnEzpL21frB8Lenxswja91sDyffmi4A+6wdOyIDlTTcaS70WR7fZ6uDHomiybO25NmpJZHEEYXnGkn/UAmlyTkL8KN8I89HanJWrpaksUKrpTbZcbhRqqIFsCEe0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4892.namprd13.prod.outlook.com (2603:10b6:510:74::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.11; Thu, 22 Jul
 2021 07:58:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 07:58:33 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 3/9] nfp: flower: refactor action offload code slightly
Date:   Thu, 22 Jul 2021 09:58:02 +0200
Message-Id: <20210722075808.10095-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210722075808.10095-1-simon.horman@corigine.com>
References: <20210722075808.10095-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0136.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR06CA0136.eurprd06.prod.outlook.com (2603:10a6:208:ab::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 07:58:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72d3c2d0-a680-408d-4c76-08d94ce68076
X-MS-TrafficTypeDiagnostic: PH0PR13MB4892:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4892AB48C5492B561742C2E2E8E49@PH0PR13MB4892.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:316;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtAcJVx1uETY71SfSsPpZx7Hz1diEdAeuREUHrsaJ7BqvCKuObRvgIgui5Xx+pxNlef6JkvX05c66JcpiFm5YVS81zJMigc83rM9A9p7hc4o7QjN+QYDRzFslDVLWCwsy2SfrlOEO88QRqnQ4nSEg0BUbL2L6VRvYZx54e/NpUZ1UlLlPejLOaG7VC+eyJEaDX4pQXa9cj4wmMqiFZiki1ZBmAXyK4E2+ULpq2y9EQfCH8QUMANGuCH4UVs6Vj/41xs0whvBZG3xkTdRXPl3+JeI4RqUh/H6KVX1ougiWLfVeZbdo4POv75wZuGvo9kKVVegGITt8Z/XvkcQAi81nHGa0BikDZunVDzFhxASCJVNidynHw2LGmSUfQC7DH2cGs66rLzuptip3GFy/O2k8VTEGbN6te7I4x5lv4IzxJ+QG88w92bt+z3RmJX83HlJOMA0lerGhWTXqFEJuCvS6MDTNtRiwzQvnxB/hhzXzZiyrF+CE9J0J6LY8vPwNznbIF4h4Spmx+dzATXSJNIX9PN5XFiasaPesvWaitKVPUVgVbkJcng/yhQxVmK2NM3I9WqaLXOUK5uqy2vOrUQLgcHrwy8+fy4N8UVdhjzk8nkVJIwTqhS8DvdJsRJiRtiuSud/V0t6EL5for6CMzvgUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39830400003)(396003)(136003)(346002)(52116002)(4326008)(6666004)(316002)(6506007)(1076003)(8936002)(5660300002)(8676002)(6486002)(186003)(107886003)(6512007)(110136005)(478600001)(2906002)(54906003)(36756003)(86362001)(44832011)(83380400001)(38100700002)(2616005)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z/fGE94drQp9ZIfpJaVW6XYtGHcB3TPW0kKQbPZmjJU8ySmdYHbCn9ugC+iM?=
 =?us-ascii?Q?2FwanTC4e4Bm7MKdjv/K9wkXl3QimdqZvMJ/HdhyRoYd8xJtQ7FUFerrzkRU?=
 =?us-ascii?Q?ib9JKkE2DTdzGJurRJRfkitV/FMm7srSnfrmYE97Ug0B1icOTQphBpPbzPCe?=
 =?us-ascii?Q?qRhS6XkMbu0stN8m7NRrQuQZBhKGjhfZXaQE2WYcRiDfDcEi7oyFPEmMzJWq?=
 =?us-ascii?Q?iUiCptQ2YUuUOVukgCo44lSjL4NJUNeDsedLl6505jk9ewUCzLkaPtYDtYZK?=
 =?us-ascii?Q?TpFWvJkY5R0jyowf1PepIpeoLqPtklSm6Q++NtrbtcbOiTVtDjNDiHI0pIpj?=
 =?us-ascii?Q?KIr3E6xbBPHpmCvNGPf5FbGIU106DPCFu+YU1K6oi55UAW2TFVcqFK+m6hyM?=
 =?us-ascii?Q?nwv2VgAXDrgwBHsEdQEE7enN6l+ZoQpRs2/7mFCRFjaBPJ39vFoZWGaFExgT?=
 =?us-ascii?Q?jqmG35pwv3X0fvV8W+YOF2HFuZEDKfL+1tkOSBOufCIpcXQ+xyF/v4j1Vq+0?=
 =?us-ascii?Q?L8+no0Jq73q9NPLB2VPGFZIfxrinuyvJxNMVTMdMLz0wmcQiO6asvXRTL0SI?=
 =?us-ascii?Q?3AdVHWunQdXGSpUrDpMvki4/ZdTNFGn2BWt8sNKI2VNbB6dqE7mk8Kb4FKIi?=
 =?us-ascii?Q?kf/X0yAZqdLbNFiIPmfWlg9X3THhnpKf9IDTJFqB9OAX5dMfPlIdohW8Q45A?=
 =?us-ascii?Q?79CjL/+X/LB2Mk8gQR6p5Th6jzCUuxab5CkQXXuajz9Gv//r+KAC4LFrApR8?=
 =?us-ascii?Q?kyct2w61qq7oSXWCjRjGQa1txe+x2P5MhWlhi5qh85+PKgUgdt1esqBsHXIr?=
 =?us-ascii?Q?aRyRUT2ydM484O1i33IjF15WY0gHL4Piiufutnc3IgJiYqUM8TQdZFaClvTG?=
 =?us-ascii?Q?tYOex4qMkqNYCbEsM2ClTD3Dx0cS8zE3BhMeZJLeHAbQ/NMVZToZuvikKQyL?=
 =?us-ascii?Q?vsX40Bi16b32GHiGYjsCTjxLXty2WcJg+0wfhbdYEeJBY248vzU65JWCSRLk?=
 =?us-ascii?Q?2pSxth8UFuozwI/YTmIf4cABSG274v593WGl2QogL7GbeIqlT/kX32L6ngLm?=
 =?us-ascii?Q?zt2f0/3jv2uZMFQHDNRnEtHen9sKlwA1rcj+YLPu66mogHyjEnpyakQnDlmM?=
 =?us-ascii?Q?/f61rSvxeqVRlI8rRfFyvpIYK5O65ohYoqlysXMb1Tnubi7Ram276iltYzOv?=
 =?us-ascii?Q?A+Z+4Os86NCWGYZA577+kgdqve9LhHBlvjr9TEA2BGZncFu0QJnhg0S/k33G?=
 =?us-ascii?Q?C6D376zS1q1ZFbGC8OpxiGRKAsgDCtH6Q8RHzbmktndVY385xLF5oLWtgMZc?=
 =?us-ascii?Q?cz863DXLrR/frKDwDwYWobVNr/+A3w5l01MI4FLARQek/ehE84KkfvNGWn9g?=
 =?us-ascii?Q?/GQaKaHKaA5cbFmiXaEkefxNoXga?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d3c2d0-a680-408d-4c76-08d94ce68076
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 07:58:33.1967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUlRqWhuZ4kbY8hVoXbUw/nFnN2Ct9rftErQr/s4BZAPVuUKezv5fuJ953tknRErAPdwlxQ3DRHLSbL35Dzz2EWKnPSmJ+i6B3/lxQobpyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4892
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Change the action related offload functions to take in flow_rule *
as input instead of flow_cls_offload * as input. The flow_rule
parts of flow_cls_offload is the only part that is used in any
case, and this is required for more conntrack offload patches
which will follow later.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/flower/action.c    | 35 +++++++++----------
 .../net/ethernet/netronome/nfp/flower/main.h  |  2 +-
 .../ethernet/netronome/nfp/flower/offload.c   |  2 +-
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 1cbe2c9f3959..2a432de11858 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -262,10 +262,10 @@ nfp_fl_output(struct nfp_app *app, struct nfp_fl_output *output,
 }
 
 static bool
-nfp_flower_tun_is_gre(struct flow_cls_offload *flow, int start_idx)
+nfp_flower_tun_is_gre(struct flow_rule *rule, int start_idx)
 {
-	struct flow_action_entry *act = flow->rule->action.entries;
-	int num_act = flow->rule->action.num_entries;
+	struct flow_action_entry *act = rule->action.entries;
+	int num_act = rule->action.num_entries;
 	int act_idx;
 
 	/* Preparse action list for next mirred or redirect action */
@@ -279,7 +279,7 @@ nfp_flower_tun_is_gre(struct flow_cls_offload *flow, int start_idx)
 
 static enum nfp_flower_tun_type
 nfp_fl_get_tun_from_act(struct nfp_app *app,
-			struct flow_cls_offload *flow,
+			struct flow_rule *rule,
 			const struct flow_action_entry *act, int act_idx)
 {
 	const struct ip_tunnel_info *tun = act->tunnel;
@@ -288,7 +288,7 @@ nfp_fl_get_tun_from_act(struct nfp_app *app,
 	/* Determine the tunnel type based on the egress netdev
 	 * in the mirred action for tunnels without l4.
 	 */
-	if (nfp_flower_tun_is_gre(flow, act_idx))
+	if (nfp_flower_tun_is_gre(rule, act_idx))
 		return NFP_FL_TUNNEL_GRE;
 
 	switch (tun->key.tp_dst) {
@@ -788,11 +788,10 @@ struct nfp_flower_pedit_acts {
 };
 
 static int
-nfp_fl_commit_mangle(struct flow_cls_offload *flow, char *nfp_action,
+nfp_fl_commit_mangle(struct flow_rule *rule, char *nfp_action,
 		     int *a_len, struct nfp_flower_pedit_acts *set_act,
 		     u32 *csum_updated)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	size_t act_size = 0;
 	u8 ip_proto = 0;
 
@@ -890,7 +889,7 @@ nfp_fl_commit_mangle(struct flow_cls_offload *flow, char *nfp_action,
 
 static int
 nfp_fl_pedit(const struct flow_action_entry *act,
-	     struct flow_cls_offload *flow, char *nfp_action, int *a_len,
+	     char *nfp_action, int *a_len,
 	     u32 *csum_updated, struct nfp_flower_pedit_acts *set_act,
 	     struct netlink_ext_ack *extack)
 {
@@ -977,7 +976,7 @@ nfp_flower_output_action(struct nfp_app *app,
 
 static int
 nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
-		       struct flow_cls_offload *flow,
+		       struct flow_rule *rule,
 		       struct nfp_fl_payload *nfp_fl, int *a_len,
 		       struct net_device *netdev,
 		       enum nfp_flower_tun_type *tun_type, int *tun_out_cnt,
@@ -1045,7 +1044,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 	case FLOW_ACTION_TUNNEL_ENCAP: {
 		const struct ip_tunnel_info *ip_tun = act->tunnel;
 
-		*tun_type = nfp_fl_get_tun_from_act(app, flow, act, act_idx);
+		*tun_type = nfp_fl_get_tun_from_act(app, rule, act, act_idx);
 		if (*tun_type == NFP_FL_TUNNEL_NONE) {
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unsupported tunnel type in action list");
 			return -EOPNOTSUPP;
@@ -1086,7 +1085,7 @@ nfp_flower_loop_action(struct nfp_app *app, const struct flow_action_entry *act,
 		/* Tunnel decap is handled by default so accept action. */
 		return 0;
 	case FLOW_ACTION_MANGLE:
-		if (nfp_fl_pedit(act, flow, &nfp_fl->action_data[*a_len],
+		if (nfp_fl_pedit(act, &nfp_fl->action_data[*a_len],
 				 a_len, csum_updated, set_act, extack))
 			return -EOPNOTSUPP;
 		break;
@@ -1195,7 +1194,7 @@ static bool nfp_fl_check_mangle_end(struct flow_action *flow_act,
 }
 
 int nfp_flower_compile_action(struct nfp_app *app,
-			      struct flow_cls_offload *flow,
+			      struct flow_rule *rule,
 			      struct net_device *netdev,
 			      struct nfp_fl_payload *nfp_flow,
 			      struct netlink_ext_ack *extack)
@@ -1207,7 +1206,7 @@ int nfp_flower_compile_action(struct nfp_app *app,
 	bool pkt_host = false;
 	u32 csum_updated = 0;
 
-	if (!flow_action_hw_stats_check(&flow->rule->action, extack,
+	if (!flow_action_hw_stats_check(&rule->action, extack,
 					FLOW_ACTION_HW_STATS_DELAYED_BIT))
 		return -EOPNOTSUPP;
 
@@ -1219,18 +1218,18 @@ int nfp_flower_compile_action(struct nfp_app *app,
 	tun_out_cnt = 0;
 	out_cnt = 0;
 
-	flow_action_for_each(i, act, &flow->rule->action) {
-		if (nfp_fl_check_mangle_start(&flow->rule->action, i))
+	flow_action_for_each(i, act, &rule->action) {
+		if (nfp_fl_check_mangle_start(&rule->action, i))
 			memset(&set_act, 0, sizeof(set_act));
-		err = nfp_flower_loop_action(app, act, flow, nfp_flow, &act_len,
+		err = nfp_flower_loop_action(app, act, rule, nfp_flow, &act_len,
 					     netdev, &tun_type, &tun_out_cnt,
 					     &out_cnt, &csum_updated,
 					     &set_act, &pkt_host, extack, i);
 		if (err)
 			return err;
 		act_cnt++;
-		if (nfp_fl_check_mangle_end(&flow->rule->action, i))
-			nfp_fl_commit_mangle(flow,
+		if (nfp_fl_check_mangle_end(&rule->action, i))
+			nfp_fl_commit_mangle(rule,
 					     &nfp_flow->action_data[act_len],
 					     &act_len, &set_act, &csum_updated);
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 004665567b5a..b5bb13de73df 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -475,7 +475,7 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 				  enum nfp_flower_tun_type tun_type,
 				  struct netlink_ext_ack *extack);
 int nfp_flower_compile_action(struct nfp_app *app,
-			      struct flow_cls_offload *flow,
+			      struct flow_rule *rule,
 			      struct net_device *netdev,
 			      struct nfp_fl_payload *nfp_flow,
 			      struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 46bd5da89bfd..ad97770fa39c 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1338,7 +1338,7 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 	if (err)
 		goto err_destroy_flow;
 
-	err = nfp_flower_compile_action(app, flow, netdev, flow_pay, extack);
+	err = nfp_flower_compile_action(app, rule, netdev, flow_pay, extack);
 	if (err)
 		goto err_destroy_flow;
 
-- 
2.20.1

