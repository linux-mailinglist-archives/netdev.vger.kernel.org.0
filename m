Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05BB4B9DCF
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbiBQK5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:57:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiBQK5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:57:32 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2125.outbound.protection.outlook.com [40.107.100.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8376589
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k94qZDx2uHjcmT2kEhkR0caoG+X+VyHPbMJFD1sOHsSjvbsirdLnylRz4OwWV8oVI/3EUN0MPqpq4PfRmgq8KMeOQ3//52BnCfSDhg+XdRBqVNH+iZwX/SBuwswYYl8NnaSLczp21aSX7VDj+XXEAJAmZvvpQYvJLaPT2ml3LTSkiDKsYmY5FWbkWDrBm8qTh4mwe76LNpzNzfiQLjQP5NccS7qtd0h6x4zkBDAo/pPbYkNsoQUL0Xkl7AU3xxyJBqAlro7SyJ637mBy1xUr7NSBS+JlGjB2cwH0PIKF5jQrtnOzqnK4c8xmXQ+vix4Twk90qvmm7RH4NF7Ro/a88w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7SW5RmL+IfhPETXPHEbPaIGnl0N9w87G0kLumAbrnc=;
 b=X0lCj+Kk2I3o1c+SvOYBeXVCah3OD+HdbDp6kNrvwoJ49Laub9mpQ6bNsad1PrQMNPh5RasWjEH3DhsXdxA+UwKtOXl7uUoRsI8HG1+7hUhxx6doi0sIP0z9zj4e7o5IGWBq9v5zLt0XhBWQBqo6OdDZMFE8Q4ZglrCu7os+pBWs0Tv3Z3O/Qh4vLK3qp007LeAxsgCM+fq6BC2ao68pVT5fuBH5qhIrIVnbMdTuwVq0x3nKUapIvXuNI9MAaneWlbQIO7QHf2Bsgmh2oYUFqlc2HRk72KoIK6H1RFLd+E+vczhYMx13NPA50MRx+PDb8BHJdQwUC3r5V4pW54w+5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7SW5RmL+IfhPETXPHEbPaIGnl0N9w87G0kLumAbrnc=;
 b=BzBNasL3rr4wMZYiwLZrBmawz9JAigw+CUN0ccqtN6X66/0h3AKD8KjwSfxSp+5Kh7usk6JMmaESY5N3dNdrhWckDW2sqvpKGRzLyl3qCu34kZc8Hb8VteJqAyFx/Y3GXP3VfmsxjCYq2dSgz5m9gHsUK8ul/PMSYdf2Dg3CUc4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1397.namprd13.prod.outlook.com (2603:10b6:903:136::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Thu, 17 Feb
 2022 10:57:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4995.015; Thu, 17 Feb 2022
 10:57:15 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 2/6] nfp: add support to offload tc action to hardware
Date:   Thu, 17 Feb 2022 11:56:48 +0100
Message-Id: <20220217105652.14451-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220217105652.14451-1-simon.horman@corigine.com>
References: <20220217105652.14451-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0081.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbc62c38-1ce5-415d-89b6-08d9f20441ef
X-MS-TrafficTypeDiagnostic: CY4PR13MB1397:EE_
X-Microsoft-Antispam-PRVS: <CY4PR13MB1397628BC639657B732DE938E8369@CY4PR13MB1397.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j0RYQfSY+IazjHAxv/ska14kigmO3lZLwofihH4vQSuGAP566S9nynlGZMeqASXwdJ4bGLeGg7CCRlzMXOD23ZLTFYlLnDMBFZv4X7FB5X1YaiSo76yNhoJPdDDS9QtYNDWsRfZc+kZWF61XPcFXdbQ/q0bpNV4jZJVetPThI6Qehs+3j0FEioPENdgewI3BDEjoXO2Re+2voGAzauy4Q01cidRwLBXGgYZBGyyEsKUZWcJs1QqycL9ct7aWiQUgj7SLJILNhU/t9hBQICM8JyCbQx0bwaKptN1CyhbaP+/lzj5u/l9N4p3WVLOmXk3l/YNUA54Lxq5wULKnk3Qptj5RsibnNNrIRwyQzhNIMMod75O9tJugwRALqNo+aJZuFW3aJtVlyytviiROiQV2oHReMnLZ/SoaVdwELVSwUVF1A7FrR8GdC770LltGspVxb5vgjFuqHFjeb63PanafUtTYFlBQN40unkX7ka/41+8kTS5lw7+gWNH80jwi5S356hdd5lpYyYnNcaaz0l+/9Gv/VVFUbrnCIHDCImHQS3oeumqNadNJA0S/3jmEu6XxAtOKvd8/b4mBalCthHi8bGsT64Qxwec2U0oVM73qQOf3/5WQ/z5T8Ko/M+dHGfRsOBrmr7hS6aDJN+Wb+MwHdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(39840400004)(136003)(396003)(376002)(366004)(8676002)(66476007)(316002)(1076003)(6666004)(6506007)(2616005)(54906003)(186003)(52116002)(38100700002)(6512007)(66946007)(66556008)(4326008)(86362001)(110136005)(6486002)(83380400001)(508600001)(107886003)(44832011)(36756003)(2906002)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rc/MDKXJPUyFLCVVoagN3A9BKDNm0xQW3JtYbkLlUdba0gI51tAr6TzY5X5k?=
 =?us-ascii?Q?5NRK2H7t717XP3BeP+PyzNanhu9rr1F/o3MWJ6zdeEC/IiKmVfUsulRGyH+W?=
 =?us-ascii?Q?N8uFYTWOB0bZbr60ecrll1kXwg0FRHK2RwPsbXOwxOj9HCCaH3+Ex/ylcW89?=
 =?us-ascii?Q?SnNXGTbCJzgOMrddwevP7X6bN4rejW5EUAIjzy5/ziMOR1WU2RQexeoxLzmX?=
 =?us-ascii?Q?/guH8MjvtzSoC42rGDfyhWUnGtKd+H2oikeG7bbz4enD8K3CPRlsBLcv3+Wo?=
 =?us-ascii?Q?cIBBNcRHt3+LUDFcemMfYrykIjDt5omPUeKuq/jfyC8/1cl/28RTdK6QAwT1?=
 =?us-ascii?Q?Kea+MOdrEehvpEEkBnvzHXojVvMW1uJ7qWwlW+TLK8TEI6LNoSAe3qoemdc6?=
 =?us-ascii?Q?MQINBPxOAd+GpaQdii5xb8S2uIbGDN9i0D45bKhfnRlZuBpl5pNZY7Gkadqn?=
 =?us-ascii?Q?wuxGpVmp11CyHizimCbtEHgQvjM/QSnph8s71iIFvuQFzoAJgQFNnDsdAPfF?=
 =?us-ascii?Q?e7lYMAZhMgKanrgZmv62U75/vZFpG7Om7489TO6FV+7QIcyQjoCgIUiwSvBF?=
 =?us-ascii?Q?29dFP4IXRFgKDysI95r7rnJkTsUTRD1RUR6gF4X8IYDmeF9tTPaB5nXt3hMh?=
 =?us-ascii?Q?9rRTe0ihkvmD2FTcfEJyhaJICnPma0SmLud9bWjJRbQNS5XW/zj85iNIhjzi?=
 =?us-ascii?Q?2yl89NXOlqOgbQY+z3Ao/8tC0fPONMtAmrZcEWin5Ii74eIx8SLZLM6lzzFY?=
 =?us-ascii?Q?V+xW3scOCtugc7NI0AHQWA4lkXEta528QJ5zvngfLLy5YjGU4RtHGj+zXd4C?=
 =?us-ascii?Q?YunJ8Gn78LGOEZj8EG+5RU337h40ZckK/Az8/Zg06ffqzTRhpgVvJRQKZoIz?=
 =?us-ascii?Q?SgPd+8rIqqrXGEWvkfwR38zsVg2dGbA7+m5wXehQP+j/gYqWwO4p6PBrIeJd?=
 =?us-ascii?Q?VBY0CqsE7MKW0E6UpZQtupHBtC/aVEmMNs6Gm2N1TpG/9Nue+tlKwnlh5gZJ?=
 =?us-ascii?Q?UsdPyJLDfKDpe5XY3wP3mK786VBZj/pHWn88PkvOE8+ek/M80HhRDwQd1Ssg?=
 =?us-ascii?Q?+QbvNEOa89vUvr9QGrVA5Nh0hwNyZZUkGRsTOcXPCPfaQ/11cPKMjZmdHuQW?=
 =?us-ascii?Q?PZ3mh8N8BebP0WiekpQQn0fzUUgbz13kBLXTewbUx5JdgMIJYVhTC3vQxekO?=
 =?us-ascii?Q?jTC6zGod/GTYLuuKGCFxZW8fBV37K2hxMvSdl5UjkZAwSvlK3+xYYXtUNcy0?=
 =?us-ascii?Q?zx7fzLB3t6oIBou5YeqUNHm2JDdbEC1VHxYiqhkHvTZpEH3gYu5E/qR62dy6?=
 =?us-ascii?Q?bOA9Ke+VOG3aIT4qxTpg9X5hfqXoYQXQkp1kt5LT39zlOtpyhHwithvepBIV?=
 =?us-ascii?Q?q5vBHjQTdePNvEbYxdYK0m+suAaitI8S+wFIr9b7CxG3H0gc26mcWaw2Bivb?=
 =?us-ascii?Q?LvBMOCO89wh8LOMXH7YAiCeHZN92RtFGKsO0NZDbyzUgKDY3xJY4Jflm5Kyd?=
 =?us-ascii?Q?CIKrpHYle27XMkDD2OYyFDeB3lXrUVk6qfnluT0rV3nQeyKSec64FPcU1Lqb?=
 =?us-ascii?Q?WL7ZeBMnLDXkaudHfz3B59JaNamAl4sOUVMf/WpzATt/UfEYnd7leQJg7TpX?=
 =?us-ascii?Q?KTR/BqK6crPfBCFilqQpKENXVQrxG4JVFjayV7/xObioRwdx3V8wrEjC1teQ?=
 =?us-ascii?Q?YjYgDcstzdascucnzO1Y5K0ixAFawEwLa702X+bvKApO1gRnj7DFohC5VT5/?=
 =?us-ascii?Q?L1vanBVHAV75vt66HbAlaCp3Vv5Wp9s=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc62c38-1ce5-415d-89b6-08d9f20441ef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 10:57:15.0581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ngcqILw157SCDfuus4jE87NkMm/lvLKDKPV8IS8snR8ALUWnTNVLRHhiaDgiqEGB7+UxWGi3jMll1ObF4Cz7YHG3lYWk9VAq5CsTB5CQpBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1397
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add process to offload tc action to hardware.

Currently we only support to offload police action.

Add meter capability to check if firmware supports
meter offload.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |   6 +
 .../ethernet/netronome/nfp/flower/offload.c   |  16 ++-
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 103 ++++++++++++++++++
 3 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 7720403e79fb..a880f7684600 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -12,7 +12,9 @@
 #include <linux/rhashtable.h>
 #include <linux/time64.h>
 #include <linux/types.h>
+#include <net/flow_offload.h>
 #include <net/pkt_cls.h>
+#include <net/pkt_sched.h>
 #include <net/tcp.h>
 #include <linux/workqueue.h>
 #include <linux/idr.h>
@@ -48,6 +50,7 @@ struct nfp_app;
 #define NFP_FL_FEATS_IPV6_TUN		BIT(7)
 #define NFP_FL_FEATS_VLAN_QINQ		BIT(8)
 #define NFP_FL_FEATS_QOS_PPS		BIT(9)
+#define NFP_FL_FEATS_QOS_METER		BIT(10)
 #define NFP_FL_FEATS_HOST_ACK		BIT(31)
 
 #define NFP_FL_ENABLE_FLOW_MERGE	BIT(0)
@@ -569,6 +572,9 @@ nfp_flower_xmit_flow(struct nfp_app *app, struct nfp_fl_payload *nfp_flow,
 void
 nfp_flower_update_merge_stats(struct nfp_app *app,
 			      struct nfp_fl_payload *sub_flow);
+
+int nfp_setup_tc_act_offload(struct nfp_app *app,
+			     struct flow_offload_action *fl_act);
 int nfp_flower_offload_one_police(struct nfp_app *app, bool ingress,
 				  bool pps, u32 id, u32 rate, u32 burst);
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index f97eff5afd12..92e8ade4854e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1861,6 +1861,20 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct Qdisc *sch, str
 	return 0;
 }
 
+static int
+nfp_setup_tc_no_dev(struct nfp_app *app, enum tc_setup_type type, void *data)
+{
+	if (!data)
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_ACT:
+		return nfp_setup_tc_act_offload(app, data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 int
 nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *cb_priv,
 			    enum tc_setup_type type, void *type_data,
@@ -1868,7 +1882,7 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	if (!netdev)
-		return -EOPNOTSUPP;
+		return nfp_setup_tc_no_dev(cb_priv, type, data);
 
 	if (!nfp_fl_is_netdev_to_offload(netdev))
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 68a92a28d7fa..3ec63217fb19 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -475,3 +475,106 @@ int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
 		return -EOPNOTSUPP;
 	}
 }
+
+/* offload tc action, currently only for tc police */
+
+static int
+nfp_act_install_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
+			struct netlink_ext_ack *extack)
+{
+	struct flow_action_entry *paction = &fl_act->action.entries[0];
+	u32 action_num = fl_act->action.num_entries;
+	struct nfp_flower_priv *fl_priv = app->priv;
+	struct flow_action_entry *action = NULL;
+	u32 burst, i, meter_id;
+	bool pps_support, pps;
+	bool add = false;
+	u64 rate;
+
+	pps_support = !!(fl_priv->flower_ext_feats & NFP_FL_FEATS_QOS_PPS);
+
+	for (i = 0 ; i < action_num; i++) {
+		/*set qos associate data for this interface */
+		action = paction + i;
+		if (action->id != FLOW_ACTION_POLICE) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "unsupported offload: qos rate limit offload requires police action");
+			continue;
+		}
+		if (action->police.rate_bytes_ps > 0) {
+			rate = action->police.rate_bytes_ps;
+			burst = action->police.burst;
+		} else if (action->police.rate_pkt_ps > 0 && pps_support) {
+			rate = action->police.rate_pkt_ps;
+			burst = action->police.burst_pkt;
+		} else {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "unsupported offload: unsupported qos rate limit");
+			continue;
+		}
+
+		if (rate != 0) {
+			pps = false;
+			if (action->police.rate_pkt_ps > 0)
+				pps = true;
+			meter_id = action->hw_index;
+			nfp_flower_offload_one_police(app, false, pps, meter_id,
+						      rate, burst);
+			add = true;
+		}
+	}
+
+	if (add)
+		return 0;
+	else
+		return -EOPNOTSUPP;
+}
+
+static int
+nfp_act_remove_actions(struct nfp_app *app, struct flow_offload_action *fl_act,
+		       struct netlink_ext_ack *extack)
+{
+	struct nfp_police_config *config;
+	struct sk_buff *skb;
+	u32 meter_id;
+
+	/*delete qos associate data for this interface */
+	if (fl_act->id != FLOW_ACTION_POLICE) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "unsupported offload: qos rate limit offload requires police action");
+		return -EOPNOTSUPP;
+	}
+
+	meter_id = fl_act->index;
+	skb = nfp_flower_cmsg_alloc(app, sizeof(struct nfp_police_config),
+				    NFP_FLOWER_CMSG_TYPE_QOS_DEL, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	config = nfp_flower_cmsg_get_data(skb);
+	memset(config, 0, sizeof(struct nfp_police_config));
+	config->head.flags_opts = cpu_to_be32(NFP_FL_QOS_METER);
+	config->head.meter_id = cpu_to_be32(meter_id);
+	nfp_ctrl_tx(app->ctrl, skb);
+
+	return 0;
+}
+
+int nfp_setup_tc_act_offload(struct nfp_app *app,
+			     struct flow_offload_action *fl_act)
+{
+	struct netlink_ext_ack *extack = fl_act->extack;
+	struct nfp_flower_priv *fl_priv = app->priv;
+
+	if (!(fl_priv->flower_ext_feats & NFP_FL_FEATS_QOS_METER))
+		return -EOPNOTSUPP;
+
+	switch (fl_act->command) {
+	case FLOW_ACT_REPLACE:
+		return nfp_act_install_actions(app, fl_act, extack);
+	case FLOW_ACT_DESTROY:
+		return nfp_act_remove_actions(app, fl_act, extack);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
-- 
2.20.1

