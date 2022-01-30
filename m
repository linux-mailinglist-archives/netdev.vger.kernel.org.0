Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763ED4A3643
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 13:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347152AbiA3Mb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 07:31:59 -0500
Received: from mail-dm6nam08on2089.outbound.protection.outlook.com ([40.107.102.89]:10336
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240805AbiA3Mb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 07:31:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2jilz7NdLfNufPw5FSP/5vWir2kUDCx/8Dk5jveWpEVvsTqTHOXwfhUeanLrT85DLToiDY0F8kxRnFw59c5fTnyfBdyTPBjKuSCWraoBXSb9k4rCk35yIwsuWVPT4D0KJmrQ49vUO9nSaWzrJKlXk+MIdymF0YX3Nzxxj5ZqIQfYBOYCLN94B7JK0Mp/XVAfMviGZtoH4mDlFQvuabtQWLC0bw1xwOG5L4MiCOEuJUDdnD2GR1+BfRuG7/RPynS5RHftvdP0ZY1ZJM52PGp55mP0nbTxykD+5MCOLVfAdeZmxPvJXMAwRVmq9y9QlAtD4tjDeTdD9R6rIijo44eFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CdbE9UmqXCoSbVURnuSNOAll7SV4li7O5aZTy3pczlA=;
 b=OtfTRpr2adU5+8aRyI7IIlTzePb1X8LsxX/9UvkG/n8YjmZ++s2M8va4wip6h5si0ibpnc15WGCsAQOftEkXEywT8vQHiDtLYfLm+EgrT8C0fCiaGP2zpDk/+oYFpGOoKVQtNJLJCHJON6F5bzZ7Dx9K+IrCEelcdEZSkB+MskI0TaT2+vA/AvKtLsZTMluxNxO4EdvS0DG+0kCpEPwWqhnypO1mPvZVHXgOOeJt4IldhUs8ZyqKctlN/xD7Xyzl2+CcegVEHujQ/BUjqZFchKVTkjRVvy0HrYiSxOGSNCquSUANxyewiFItUZ9tow8fONvlNVdNwGrO+mP4fN2f0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdbE9UmqXCoSbVURnuSNOAll7SV4li7O5aZTy3pczlA=;
 b=r61+D2xTlj4PSBESBoSORvuFg3N8NGDC9U3uXCO3tyLLop1uVHyPt94VetwMJ+FqRdBhQ8z6d16+0ZcKmcOS/K2x4QCF1JJkYwndpD38lZzuR0IoeHy6bWBebpJAOcOPl/mLZxuo8yGfp4M+p4E5cpUMT5L6TFL1iF8Wca0uKpL0n3GzUd5PNqp7nyLeijIAQ+HZh/B8gvPTMVeDQ/0wnr9UBT40Rdg+nJeSIpUQS70j8yicjfQqVDTZJAW+BGjO5uQW5uo8919LUPMwexBnEiDhm9FYCrx6L48cMaEXvQPRoYg2Zu2ftWPpBsrphK00Akh8Bu6rqfZ6xbrdngu4QA==
Received: from DM5PR16CA0045.namprd16.prod.outlook.com (2603:10b6:4:15::31) by
 DM4PR12MB5055.namprd12.prod.outlook.com (2603:10b6:5:38a::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.17; Sun, 30 Jan 2022 12:31:56 +0000
Received: from DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:15:cafe::52) by DM5PR16CA0045.outlook.office365.com
 (2603:10b6:4:15::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21 via Frontend
 Transport; Sun, 30 Jan 2022 12:31:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT045.mail.protection.outlook.com (10.13.173.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 12:31:55 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 12:31:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 04:31:53 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Sun, 30 Jan 2022 04:31:50 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Pravin B Shelar <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        "Vlad Buslov" <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next 1/1] net/sched: Enable tc skb ext allocation on chain miss only when needed
Date:   Sun, 30 Jan 2022 14:31:41 +0200
Message-ID: <20220130123141.10119-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c52b3d9d-c2d5-41ad-de4a-08d9e3ec80a4
X-MS-TrafficTypeDiagnostic: DM4PR12MB5055:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB50554FAC5227057883A6AC74C2249@DM4PR12MB5055.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:475;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tMdnnAdqrCTVCM+dEQ5h1vvyiDBlcNBkroNv5zZxdrBBTl4p45ZcazLsa2LI1z8/8nS8U+Dz154DnbGCkF3I1MZsMr0+jQ6Ki5scb2WAF58qi2jkfw+qpb6G+sN33Z3UkZBBiUOAimjd2jvyXnsTg5Zd51eh7oOcgc4zLV1Md9nRMldKjUxLVbsOBP98zLlvu+/gsRJFK7RZouMi+FhAuV4D3s8q1/UMnVw4do2NEtnruTQxYpVkNBbZ8xYcgTXIgfFvYxkY5dNhVDsVnyaA20nqDE4NzhdlUHRWne5k0vb0HsW0AwX6/NPlYQV4US4iBx473rP2R5KnKHG59gJVrLdqbP+d3MldIubaXt/wm7A5p/QrImJYkyUUtPwR/9sV6HFwtUdyVMqPOhAmsdRpgZrdjLKVwwvsf4mVep6qvqVK0DCydw5MhIuvjrh4y2cRv2pxyxJeH+R88gZkKXLcuAMghDpZ8IxPGIxAf2yp+8gB/M3dIzkqNv2F82GxTel6KIUIVEr/ZmQJyo0hq2U3+Ztgpa8XperftfxqefDjKm+6X1BTxdJ+kyXEeisRgAgNoaeRoxnQyMiGePc2t/UJBfymo0O6LfetQ+gJMps2JF/4XjaHynKBEW5T56RvxzbSdQ38W/umuHW4FmG5GTIQnFj7UXbtXMZxcnLdcUKVCU64+b4jfdWdHLRMh56qWRy9j8o9YggJFH4a/IjK6DxYsB6YDq2FZCR5D4FhR1+0jNo=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(26005)(6666004)(186003)(336012)(2616005)(107886003)(86362001)(508600001)(426003)(1076003)(81166007)(921005)(82310400004)(356005)(83380400001)(4326008)(36860700001)(47076005)(5660300002)(8676002)(70586007)(316002)(70206006)(40460700003)(36756003)(2906002)(110136005)(54906003)(8936002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 12:31:55.8148
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c52b3d9d-c2d5-41ad-de4a-08d9e3ec80a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tc skb extension is used to send miss info from tc to ovs datapath
module, and is currently always allocated even if it will not
be used by ovs datapath (as it depends on a requested feature).

Export the static key which is used by openvswitch module to
guard this code path as well, so it will be skipped if ovs
datapath doesn't need it. Enable this code path once
ovs datapath needs it.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 include/net/pkt_cls.h      | 11 ++++++++++
 net/openvswitch/datapath.c | 18 +++++++++-------
 net/openvswitch/datapath.h |  2 --
 net/openvswitch/flow.c     |  3 ++-
 net/sched/cls_api.c        | 43 ++++++++++++++++++++++++++------------
 5 files changed, 54 insertions(+), 23 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 676cb8ea9e15..b4a34d3325d2 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -1028,4 +1028,15 @@ struct tc_fifo_qopt_offload {
 	};
 };
 
+#ifdef CONFIG_NET_CLS_ACT
+DECLARE_STATIC_KEY_FALSE(tc_skb_ext_tc_ovs);
+void tc_skb_ext_tc_ovs_enable(void);
+void tc_skb_ext_tc_ovs_disable(void);
+#define tc_skb_ext_tc_ovs_enabled() static_branch_unlikely(&tc_skb_ext_tc_ovs)
+#else /* CONFIG_NET_CLS_ACT */
+static inline void tc_skb_ext_tc_ovs_enable(void) { }
+static inline void tc_skb_ext_tc_ovs_disable(void) { }
+#define tc_skb_ext_tc_ovs_enabled() false
+#endif
+
 #endif
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 67ad08320886..4c73a768abc5 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -37,6 +37,7 @@
 #include <net/genetlink.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
+#include <net/pkt_cls.h>
 
 #include "datapath.h"
 #include "flow.h"
@@ -1601,8 +1602,6 @@ static void ovs_dp_reset_user_features(struct sk_buff *skb,
 	dp->user_features = 0;
 }
 
-DEFINE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
-
 static int ovs_dp_set_upcall_portids(struct datapath *dp,
 			      const struct nlattr *ids)
 {
@@ -1657,7 +1656,7 @@ u32 ovs_dp_get_upcall_portid(const struct datapath *dp, uint32_t cpu_id)
 
 static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 {
-	u32 user_features = 0;
+	u32 user_features = 0, old_features = dp->user_features;
 	int err;
 
 	if (a[OVS_DP_ATTR_USER_FEATURES]) {
@@ -1696,10 +1695,12 @@ static int ovs_dp_change(struct datapath *dp, struct nlattr *a[])
 			return err;
 	}
 
-	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
-		static_branch_enable(&tc_recirc_sharing_support);
-	else
-		static_branch_disable(&tc_recirc_sharing_support);
+	if ((dp->user_features & OVS_DP_F_TC_RECIRC_SHARING) &&
+	    !(old_features & OVS_DP_F_TC_RECIRC_SHARING))
+		tc_skb_ext_tc_ovs_enable();
+	else if (!(dp->user_features & OVS_DP_F_TC_RECIRC_SHARING) &&
+		 (old_features & OVS_DP_F_TC_RECIRC_SHARING))
+		tc_skb_ext_tc_ovs_disable();
 
 	return 0;
 }
@@ -1839,6 +1840,9 @@ static void __dp_destroy(struct datapath *dp)
 	struct flow_table *table = &dp->table;
 	int i;
 
+	if (dp->user_features & OVS_DP_F_TC_RECIRC_SHARING)
+		tc_skb_ext_tc_ovs_disable();
+
 	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++) {
 		struct vport *vport;
 		struct hlist_node *n;
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index fcfe6cb46441..0cd29971a907 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -253,8 +253,6 @@ static inline struct datapath *get_dp(struct net *net, int dp_ifindex)
 extern struct notifier_block ovs_dp_device_notifier;
 extern struct genl_family dp_vport_genl_family;
 
-DECLARE_STATIC_KEY_FALSE(tc_recirc_sharing_support);
-
 void ovs_dp_process_packet(struct sk_buff *skb, struct sw_flow_key *key);
 void ovs_dp_detach_port(struct vport *);
 int ovs_dp_upcall(struct datapath *, struct sk_buff *,
diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 02096f2ec678..5839b00c99bc 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -34,6 +34,7 @@
 #include <net/mpls.h>
 #include <net/ndisc.h>
 #include <net/nsh.h>
+#include <net/pkt_cls.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 
 #include "conntrack.h"
@@ -895,7 +896,7 @@ int ovs_flow_key_extract(const struct ip_tunnel_info *tun_info,
 	key->mac_proto = res;
 
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	if (static_branch_unlikely(&tc_recirc_sharing_support)) {
+	if (tc_skb_ext_tc_ovs_enabled()) {
 		tc_ext = skb_ext_find(skb, TC_SKB_EXT);
 		key->recirc_id = tc_ext ? tc_ext->chain : 0;
 		OVS_CB(skb)->mru = tc_ext ? tc_ext->mru : 0;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d4e27c679123..683e870b11fa 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -49,6 +49,21 @@ static LIST_HEAD(tcf_proto_base);
 /* Protects list of registered TC modules. It is pure SMP lock. */
 static DEFINE_RWLOCK(cls_mod_lock);
 
+DEFINE_STATIC_KEY_FALSE(tc_skb_ext_tc_ovs);
+EXPORT_SYMBOL(tc_skb_ext_tc_ovs);
+
+void tc_skb_ext_tc_ovs_enable(void)
+{
+	static_branch_inc(&tc_skb_ext_tc_ovs);
+}
+EXPORT_SYMBOL(tc_skb_ext_tc_ovs_enable);
+
+void tc_skb_ext_tc_ovs_disable(void)
+{
+	static_branch_dec(&tc_skb_ext_tc_ovs);
+}
+EXPORT_SYMBOL(tc_skb_ext_tc_ovs_disable);
+
 static u32 destroy_obj_hashfn(const struct tcf_proto *tp)
 {
 	return jhash_3words(tp->chain->index, tp->prio,
@@ -1615,19 +1630,21 @@ int tcf_classify(struct sk_buff *skb,
 	ret = __tcf_classify(skb, tp, orig_tp, res, compat_mode,
 			     &last_executed_chain);
 
-	/* If we missed on some chain */
-	if (ret == TC_ACT_UNSPEC && last_executed_chain) {
-		struct tc_skb_cb *cb = tc_skb_cb(skb);
-
-		ext = tc_skb_ext_alloc(skb);
-		if (WARN_ON_ONCE(!ext))
-			return TC_ACT_SHOT;
-		ext->chain = last_executed_chain;
-		ext->mru = cb->mru;
-		ext->post_ct = cb->post_ct;
-		ext->post_ct_snat = cb->post_ct_snat;
-		ext->post_ct_dnat = cb->post_ct_dnat;
-		ext->zone = cb->zone;
+	if (tc_skb_ext_tc_ovs_enabled()) {
+		/* If we missed on some chain */
+		if (ret == TC_ACT_UNSPEC && last_executed_chain) {
+			struct tc_skb_cb *cb = tc_skb_cb(skb);
+
+			ext = tc_skb_ext_alloc(skb);
+			if (WARN_ON_ONCE(!ext))
+				return TC_ACT_SHOT;
+			ext->chain = last_executed_chain;
+			ext->mru = cb->mru;
+			ext->post_ct = cb->post_ct;
+			ext->post_ct_snat = cb->post_ct_snat;
+			ext->post_ct_dnat = cb->post_ct_dnat;
+			ext->zone = cb->zone;
+		}
 	}
 
 	return ret;
-- 
2.30.1

