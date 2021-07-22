Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88ED3D1F82
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhGVHSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:18:01 -0400
Received: from mail-bn8nam11on2102.outbound.protection.outlook.com ([40.107.236.102]:43163
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230200AbhGVHR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:17:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wwdd+cOlrk3idiieOqTam5+Ozig7Gyu5H2In+vP3zHc0NYapEbVrpwUL989UXaBMo8wsfrnuImhufCmGBZgo7I9d687oBzFa57tHhAIIFBlato4cMqReZq2RGaKOgfEW+xsrMCa0tpTwsd7jy1Yd2cRySLVEt6zPS9nHzQtxL0Krif6OeEIKS4N44BQyTHm4FeIsas1nlRV0kqqsS0OVSvc/R5VlBJH0c0QyA78rg32SFxnmnZOaGhhgMAkD05ICpKwjbiKQR6RHqQ8+UUiV665f85q6Dl1jDLJ6Tu6BfzPftx56UmEOukKbOCg8iuNwmsLBncvpoLUjVxBdnm7Clw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjjzREvIELlxvZych8gAfGrSz1hDGePZRnh8mLuUf+0=;
 b=kWKx8xOf6tCdf6+FXLKNxpCeC3hAS+2oeyoCngMGGYCvqKmo/gx8UiVUMIsddiCjSTxQnEdfc5SlIFiyAEP8SUbgWS5F65gZqVMxz+n4qOeD9S9AZKr4c7DER91D6Txqgw5jDERC/YeECx+qHXd2YeNPYqPUmsDU1TsWvOCyMM9lDk2w5MAFgmwkSy6nQ3UrHAuzDPjcLC9XA7zn1fDDrlI+nccLPC6qB1RmRxhr5FmA4Nfvxgl/HTs0MWZQMPWygVXyUCHxe2yjqgv/EcljWaoc3aE3UxROsuhiL29a3Zad2h0lzaRx0gYgNjF8DfHoqI4j63XWWN0qHRaOwLJ94A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bjjzREvIELlxvZych8gAfGrSz1hDGePZRnh8mLuUf+0=;
 b=DWLOZUdb5N0JoaOyY6kuUlnZNNvjE7+ilMSKwttinaPyIQCP3Rq12NvW32gr4PhtMaFGIMsHVE3clUpeG3rnXI34zauxEjGo9jbT1sRxf16NRXQYkEOsHY/8SJwtCQvxWuBm0XMSmEBrcBAFuXiIf92d1hfH4m5QycUq8r2lAa0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4892.namprd13.prod.outlook.com (2603:10b6:510:74::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.11; Thu, 22 Jul
 2021 07:58:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%7]) with mapi id 15.20.4352.024; Thu, 22 Jul 2021
 07:58:31 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 2/9] nfp: flower: refactor match functions to take flow_rule as input
Date:   Thu, 22 Jul 2021 09:58:01 +0200
Message-Id: <20210722075808.10095-3-simon.horman@corigine.com>
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
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR06CA0136.eurprd06.prod.outlook.com (2603:10a6:208:ab::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 07:58:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ed64f5b-daee-4c62-c7ec-08d94ce67f7b
X-MS-TrafficTypeDiagnostic: PH0PR13MB4892:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48922AD2D63F47780C496D6EE8E49@PH0PR13MB4892.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SfKIuyMJc3wfYWs6y9Qatdq8K7pWnb+4APy3YluLdwIr78kZfFjxU0UasMJa+P96eiKgrKGhKlXwxQyxS/xb/rr0t2ftHVs40KmSdGzeDHjYEe1m/CA3juUMET+iCsoNrK5o97RleeEZYgc77sYZ/LDWbX8L8jpyo4H8vpgls4nXPAQTvMVEpVDNsiFq38m/n0Hc90umqSs6E/G/twrmAp1YA7qZx3IEmsUpmzQRkm3S1UPAL+DSz8TJ0285ZPopmy1XrfaAhlmHkspPjM4QkXccXtt1BZY4HTXJOvJEqPIzEYNE6xckv6+C3IW+ckS7/1uxinfxxTkpytCWBr2LNgWvXSAZjNXNi9GirbonDizZZ4uQLZVu5I/3ywdZ2os7vxNZetyIPgPSSlQ4KL6SlsYx82Mz33ZQhwrkhYPJXMmSUNZyBVTtQSaJrUl7QJ1gFUsl87EtnCbvXE/Rv9fPGStI+YWTfRaLewZxyaito4SAREuIKyDBiVPh8J6Uj9fkVyKOeEdROc7ugRksY9b+ciB5ETOtfhZsqqwY53oAtWcb1+L6jj3HghKBSI4x3JBxqkS9be2aLlT4h7Dgcl8y+swWugKB/ISeDrSGqxeEvxdrRCqzwxuP4F6ND0crRtFYair+YGIZ/R3dNW2h58FCJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39830400003)(396003)(136003)(346002)(52116002)(4326008)(6666004)(316002)(6506007)(1076003)(8936002)(5660300002)(8676002)(6486002)(186003)(107886003)(6512007)(110136005)(478600001)(2906002)(54906003)(36756003)(86362001)(44832011)(83380400001)(38100700002)(2616005)(66946007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p7FsweKF3ma9iV7dF8AlHOaqQwtPMf+nJZvYiHLbOkmxZIJTM+Ux4pF0JZVV?=
 =?us-ascii?Q?etw+PLNckJOqD9/Mt0ZjQ6mKFnlFkaABeYMeMo8UuZkaYyVAJRpaElffKbq0?=
 =?us-ascii?Q?IDLtztns89foO8/24X3t1FJE3vuA7CblB/i9HJN5hCXKeI86fw/jVKaqd9O5?=
 =?us-ascii?Q?XCg7x3huQ0S5Gfb2H9axlhB19tvxuGZeoavSG9efC8JDRTCe/MSFjmW6fhqg?=
 =?us-ascii?Q?rij53l5eNSDX6TNlfiB8WoVjO7v4aOyf6RiDYroAHl7SNmw6U/G1sg7NtxHU?=
 =?us-ascii?Q?mQXzCL1CAiZZf3MLQA9jYT2BSqlFyTxtnZrVxRklU/xXiwIBR8NRLdW75Wi3?=
 =?us-ascii?Q?j/+3QaXCCFsS8+lcvkI7m74mca/esaRFJLFxdpfsvC7Po8sf0RO76Ff8+ePB?=
 =?us-ascii?Q?dMByRgWFffxX//Za3KhmnYL+JKHZwklF5uLUNr9q190eydWZKjccmyK3zfD7?=
 =?us-ascii?Q?f2f/jYbQDIwDzFB9/xfm2JfwI/5EzB5FcZcqdi8+QNjmNVHWbPU7Co7L06tc?=
 =?us-ascii?Q?pp9r0BUwwpmyOfpvynGXJy9SplLRsRCU/jKEptAinkyNLJomJ4aS4qbQ98Xc?=
 =?us-ascii?Q?4qt9Iux4BWWT0LLv7oAa0Xq+c4OrSxsoyYWwWq1Hy6x0VXM7CVk+2H1HhT6Q?=
 =?us-ascii?Q?m0HPuBL9XonpLxffoyEakpMd7yji1oJouOxL6QnSZGHWzbvCJp9t2gAg+jEQ?=
 =?us-ascii?Q?Jw6MvqjGk1MBvUmB/7aNcZrVrS4hy5OeZ/hWkMc14VkoEklP3zRloYymLHta?=
 =?us-ascii?Q?D61sDQ4zk2tymVAaAnj3qmpU1mt6z2btd/CvgVnyIZJJNTZaeSU5/243jFuT?=
 =?us-ascii?Q?vFEmxKQQWf3zjyr3LX9AD3GcVJEx4XnYpF6czStHh972WB6RcCM+hv25XEkG?=
 =?us-ascii?Q?shEVLjq+QCrUzeZk34avLrd7WnWr1hNyUaVmZyBswRCNGNPmBJ6ZlC3Kl7kC?=
 =?us-ascii?Q?mk/faCEpaY2e+UENQrdK6o9HCBcgoJCfiDv1YLlumIil7LunAl3N1K7ETd6a?=
 =?us-ascii?Q?OztkU49oFK6SL2qSQtUiUXBM9yGQ1uRgeO4ABE/vBxi1m423S31cTH6ka19J?=
 =?us-ascii?Q?M8tOw/qjur2LcMcdqbxXFNg/DU8JgTrWDEPvyFYM2VdoKcgZHFyhyytHaZ9+?=
 =?us-ascii?Q?qzEjU2qmTODpdjH3Oq7wcHlI1PHHyx4hPSt5GOELCIfYzC2YtsYRDw6Wp+5+?=
 =?us-ascii?Q?7gwr1gub34wd+CS+LuqGk/3sHWSrIvXVbXREFwp99xgvzTQhfgbKluq9wX+v?=
 =?us-ascii?Q?ihDZaOXYgZy9rFSqMP+SZdsDG0ZcGNsNdhFbrxmxR7WBrX8jgwbeuIBKFKt9?=
 =?us-ascii?Q?JN+9BjW3ebKeZidd6IR6VG9kWrJHrg88/CVBHcc2vVYkhfUOijiLhbKOZInS?=
 =?us-ascii?Q?KgiUI0pqeqycJNmBVzIYYBZBfC6l?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ed64f5b-daee-4c62-c7ec-08d94ce67f7b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 07:58:31.5828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gamsJGqim8VJr7kDt/JR23fuXw7hXxnjCtWROqb7y45VgzV74tAFaofr7CAzPw+tfWRQxBIzUrq02vc7YbNRbiXQaE6wZKyaDa8e2DAcYZY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4892
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

This is a small cleanup to pass in flow->rule to some of the compile
functions instead of extracting it every time. This is will also be
useful for conntrack patches later.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |  5 ++--
 .../net/ethernet/netronome/nfp/flower/match.c |  3 +-
 .../ethernet/netronome/nfp/flower/metadata.c  |  7 ++---
 .../ethernet/netronome/nfp/flower/offload.c   | 30 +++++++------------
 4 files changed, 17 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index beb19deaeb56..004665567b5a 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -468,7 +468,7 @@ nfp_flower_compile_ipv6_gre_tun(struct nfp_flower_ipv6_gre_tun *ext,
 				struct nfp_flower_ipv6_gre_tun *msk,
 				struct flow_rule *rule);
 int nfp_flower_compile_flow_match(struct nfp_app *app,
-				  struct flow_cls_offload *flow,
+				  struct flow_rule *rule,
 				  struct nfp_fl_key_ls *key_ls,
 				  struct net_device *netdev,
 				  struct nfp_fl_payload *nfp_flow,
@@ -479,8 +479,7 @@ int nfp_flower_compile_action(struct nfp_app *app,
 			      struct net_device *netdev,
 			      struct nfp_fl_payload *nfp_flow,
 			      struct netlink_ext_ack *extack);
-int nfp_compile_flow_metadata(struct nfp_app *app,
-			      struct flow_cls_offload *flow,
+int nfp_compile_flow_metadata(struct nfp_app *app, u32 cookie,
 			      struct nfp_fl_payload *nfp_flow,
 			      struct net_device *netdev,
 			      struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 9af1bd90d6c4..9d86eea4dc16 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -511,14 +511,13 @@ nfp_flower_compile_ipv6_gre_tun(struct nfp_flower_ipv6_gre_tun *ext,
 }
 
 int nfp_flower_compile_flow_match(struct nfp_app *app,
-				  struct flow_cls_offload *flow,
+				  struct flow_rule *rule,
 				  struct nfp_fl_key_ls *key_ls,
 				  struct net_device *netdev,
 				  struct nfp_fl_payload *nfp_flow,
 				  enum nfp_flower_tun_type tun_type,
 				  struct netlink_ext_ack *extack)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	struct nfp_flower_priv *priv = app->priv;
 	bool qinq_sup;
 	u32 port_id;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/metadata.c b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
index 621113650a9b..2af9faee96c5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/metadata.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/metadata.c
@@ -290,8 +290,7 @@ nfp_check_mask_remove(struct nfp_app *app, char *mask_data, u32 mask_len,
 	return true;
 }
 
-int nfp_compile_flow_metadata(struct nfp_app *app,
-			      struct flow_cls_offload *flow,
+int nfp_compile_flow_metadata(struct nfp_app *app, u32 cookie,
 			      struct nfp_fl_payload *nfp_flow,
 			      struct net_device *netdev,
 			      struct netlink_ext_ack *extack)
@@ -310,7 +309,7 @@ int nfp_compile_flow_metadata(struct nfp_app *app,
 	}
 
 	nfp_flow->meta.host_ctx_id = cpu_to_be32(stats_cxt);
-	nfp_flow->meta.host_cookie = cpu_to_be64(flow->cookie);
+	nfp_flow->meta.host_cookie = cpu_to_be64(cookie);
 	nfp_flow->ingress_dev = netdev;
 
 	ctx_entry = kzalloc(sizeof(*ctx_entry), GFP_KERNEL);
@@ -357,7 +356,7 @@ int nfp_compile_flow_metadata(struct nfp_app *app,
 	priv->stats[stats_cxt].bytes = 0;
 	priv->stats[stats_cxt].used = jiffies;
 
-	check_entry = nfp_flower_search_fl_table(app, flow->cookie, netdev);
+	check_entry = nfp_flower_search_fl_table(app, cookie, netdev);
 	if (check_entry) {
 		NL_SET_ERR_MSG_MOD(extack, "invalid entry: cannot offload duplicate flow entry");
 		if (nfp_release_stats_entry(app, stats_cxt)) {
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 2406d33356ad..46bd5da89bfd 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -134,20 +134,16 @@ nfp_flower_xmit_flow(struct nfp_app *app, struct nfp_fl_payload *nfp_flow,
 	return 0;
 }
 
-static bool nfp_flower_check_higher_than_mac(struct flow_cls_offload *f)
+static bool nfp_flower_check_higher_than_mac(struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
-
 	return flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS) ||
 	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS) ||
 	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS) ||
 	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP);
 }
 
-static bool nfp_flower_check_higher_than_l3(struct flow_cls_offload *f)
+static bool nfp_flower_check_higher_than_l3(struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
-
 	return flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS) ||
 	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP);
 }
@@ -240,11 +236,10 @@ static int
 nfp_flower_calculate_key_layers(struct nfp_app *app,
 				struct net_device *netdev,
 				struct nfp_fl_key_ls *ret_key_ls,
-				struct flow_cls_offload *flow,
+				struct flow_rule *rule,
 				enum nfp_flower_tun_type *tun_type,
 				struct netlink_ext_ack *extack)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	struct flow_dissector *dissector = rule->match.dissector;
 	struct flow_match_basic basic = { NULL, NULL};
 	struct nfp_flower_priv *priv = app->priv;
@@ -452,7 +447,7 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: match on given EtherType is not supported");
 			return -EOPNOTSUPP;
 		}
-	} else if (nfp_flower_check_higher_than_mac(flow)) {
+	} else if (nfp_flower_check_higher_than_mac(rule)) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: cannot match above L2 without specified EtherType");
 		return -EOPNOTSUPP;
 	}
@@ -471,7 +466,7 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 	}
 
 	if (!(key_layer & NFP_FLOWER_LAYER_TP) &&
-	    nfp_flower_check_higher_than_l3(flow)) {
+	    nfp_flower_check_higher_than_l3(rule)) {
 		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: cannot match on L4 information without specified IP protocol type");
 		return -EOPNOTSUPP;
 	}
@@ -1005,9 +1000,7 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 				     struct nfp_fl_payload *sub_flow1,
 				     struct nfp_fl_payload *sub_flow2)
 {
-	struct flow_cls_offload merge_tc_off;
 	struct nfp_flower_priv *priv = app->priv;
-	struct netlink_ext_ack *extack = NULL;
 	struct nfp_fl_payload *merge_flow;
 	struct nfp_fl_key_ls merge_key_ls;
 	struct nfp_merge_info *merge_info;
@@ -1016,7 +1009,6 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 
 	ASSERT_RTNL();
 
-	extack = merge_tc_off.common.extack;
 	if (sub_flow1 == sub_flow2 ||
 	    nfp_flower_is_merge_flow(sub_flow1) ||
 	    nfp_flower_is_merge_flow(sub_flow2))
@@ -1061,9 +1053,8 @@ int nfp_flower_merge_offloaded_flows(struct nfp_app *app,
 	if (err)
 		goto err_unlink_sub_flow1;
 
-	merge_tc_off.cookie = merge_flow->tc_flower_cookie;
-	err = nfp_compile_flow_metadata(app, &merge_tc_off, merge_flow,
-					merge_flow->ingress_dev, extack);
+	err = nfp_compile_flow_metadata(app, merge_flow->tc_flower_cookie, merge_flow,
+					merge_flow->ingress_dev, NULL);
 	if (err)
 		goto err_unlink_sub_flow2;
 
@@ -1305,6 +1296,7 @@ static int
 nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 		       struct flow_cls_offload *flow)
 {
+	struct flow_rule *rule = flow_cls_offload_flow_rule(flow);
 	enum nfp_flower_tun_type tun_type = NFP_FL_TUNNEL_NONE;
 	struct nfp_flower_priv *priv = app->priv;
 	struct netlink_ext_ack *extack = NULL;
@@ -1330,7 +1322,7 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 	if (!key_layer)
 		return -ENOMEM;
 
-	err = nfp_flower_calculate_key_layers(app, netdev, key_layer, flow,
+	err = nfp_flower_calculate_key_layers(app, netdev, key_layer, rule,
 					      &tun_type, extack);
 	if (err)
 		goto err_free_key_ls;
@@ -1341,7 +1333,7 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 		goto err_free_key_ls;
 	}
 
-	err = nfp_flower_compile_flow_match(app, flow, key_layer, netdev,
+	err = nfp_flower_compile_flow_match(app, rule, key_layer, netdev,
 					    flow_pay, tun_type, extack);
 	if (err)
 		goto err_destroy_flow;
@@ -1356,7 +1348,7 @@ nfp_flower_add_offload(struct nfp_app *app, struct net_device *netdev,
 			goto err_destroy_flow;
 	}
 
-	err = nfp_compile_flow_metadata(app, flow, flow_pay, netdev, extack);
+	err = nfp_compile_flow_metadata(app, flow->cookie, flow_pay, netdev, extack);
 	if (err)
 		goto err_destroy_flow;
 
-- 
2.20.1

