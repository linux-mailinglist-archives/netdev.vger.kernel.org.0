Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE1D679B03
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbjAXODt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbjAXODr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:03:47 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E6229E01;
        Tue, 24 Jan 2023 06:03:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ew8+q1CS0Q2u8JUndXT4fzmexVcvnruj/xrnxU/SkxPxECU9+Do17efnYV/2XAqw9pS3IV2v2RGFAQfvJT55Lkgrsv68pDrGslQ/3GLd7V44YPf0StH5yyepNrDG81ucPNgThuSVqpbiAZip0hBojie9EEyY6qVwsMmTFuIGotAHGxUYo4idCXDyCfPzlO5flrQN/Qk7L8O00EC/FHBDg4dXMDHbAaeJ5mwvNl3KyJYi+dgcO+kjDksgq8lZ0/OMvRwWFNaX0Fk6o/bxDY/DgxSnsyJRiswr/8AdxP/+Vd1fikZaKbNFZ9Fw0eVagZ9QvHzRtDYxPPsgOziE401W4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hRCCIrcOIvrOs9yZYI2nP2cP9hmUlhGTKjvzGb2BZs=;
 b=SL9zSMFdmPAbqGF+6M+/1fDo2p3CYWGT96URPS0P0fqdaJodQL7TCoQim6P4r9/vVmDVIf9VM+btyvncU8VlbqurGve1ObXUpMsYDvkZssVkN2R3EcJoqUXpRvhRfXHyJPIHVTcQe80XJRt+tnbi1fzTeyUmOY1Dfp9HP8Zvw+3P5Fzb/3pE0PeKj+iOYZYRTh4rv4xIPyQVNHhv7EK5A4cdnHtT9gxg1K1bs7P7xRogjWxpkqopQ6yEcCNu3Sk8fL3JJJyj+qtDN0dKIXTngIHjJMM4RbJonhS9ezshalzf5Ny6t6EvOp3f0czxCuViWysBNWAarxqXMhgJhTBlaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hRCCIrcOIvrOs9yZYI2nP2cP9hmUlhGTKjvzGb2BZs=;
 b=KS355yK4YJqi8aH3mTVWbJPMsZ01u7UZyyBp20fFKgU9YOJ2bkJgQxv6jiZtl3CKMzFOP91yc6Hk7G153ZHppLwKQOP/wIi8Nv71AYTJx8bcQSJMBIUUlZoTasQw5WfJFLtMSdyea8v/DU3kGae0oWGI1fJ2TyKV+BYXPGbDbNx/72GIEqb5L9LwIoO82I3H1zRL1wFAQYA70KKj+bOKCf3cokjil7RwhffUmH8MZ8vwo0/PT07vD74Xf9EXWc5huRdp50eArkse/3amYBPiXpS1fBoUab7ojJAUOmNXCSMiIp9RRmstcwtOBelfIYhfPMhWVh5BxJRgSIlJ2q9fxA==
Received: from BN9PR03CA0250.namprd03.prod.outlook.com (2603:10b6:408:ff::15)
 by PH7PR12MB6610.namprd12.prod.outlook.com (2603:10b6:510:212::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:03:20 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::28) by BN9PR03CA0250.outlook.office365.com
 (2603:10b6:408:ff::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:03:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 14:03:19 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:02:57 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:02:56 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:02:52 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 2/7] netfilter: flowtable: fixup UDP timeout depending on ct state
Date:   Tue, 24 Jan 2023 15:02:02 +0100
Message-ID: <20230124140207.3975283-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230124140207.3975283-1-vladbu@nvidia.com>
References: <20230124140207.3975283-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT065:EE_|PH7PR12MB6610:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b226c6e-d570-4101-a038-08dafe13bf53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WsvNsVU9MusEpVT5sYToTADQfsm4PpE40lYPpJZnxH66PIeBZ1G+srCxszVlnf3D1KirCg7ZoZtVS/IHFCwFXFk5Sfrzl1kLRgYkMOG7Me8jU+KsCDLxLnOPIrsf5k1MycIb8IhuITqMT/BQF8hW98M/si8fqlwRjJVSNkZdCQw4IIdKyQGsy8YYEJKRctxns2spXoHiX2Gn9meBgjZI0APBDyYSzInCuBc1CcjsHQoSmORxv/UXz8LjBEYPCoPGX/nWa1W4ZWyaAS9z4AusQB6487/IEdUieoZOlgaEeEAY52cKT1JjUXnbyjxTrmd2CnaG4DftFqzWODiP+Q+Are2XcrLXzymNvHPlyR0UcoZ+sT3UE0f5p+ub6j0Gw1aUNvpgzR5WSIq3sdktl+goRg/xVBpX9axiX8WmTSrmNfKWXveMu9gRHHbwRDRbu2CgN9VLM6MrpiPB3mGvlxKL867irCiCfoVw4wcr8IMNadSefYLJ1KvGoX0zhUCTr3wioLjNL1sCzDKqCjmTJ2EcM6ZLL3FOD1I8xgetmNHhphQPui2pZJW0S9w3QQi8ppsccpxSmHqtTMGBX3X169LLUTHQx9aGKTjj/UDNKaeZ8CHUolbRrYOZEaKhbjlOlrLWU3KtaTNkHmCmzOS/GzkhS6QdGtutoj7AmA5tdtEakmw0PyNbeOOdEUiCx2rQbHomCTn91I3s2zhZl1gZEqTtS8qKxPPjVXZDcXXWpBY4148=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199015)(46966006)(40470700004)(36840700001)(36860700001)(83380400001)(82740400003)(7416002)(41300700001)(86362001)(356005)(7636003)(2906002)(82310400005)(8936002)(5660300002)(4326008)(40460700003)(316002)(40480700001)(26005)(186003)(8676002)(6666004)(107886003)(47076005)(426003)(336012)(70586007)(70206006)(54906003)(2616005)(1076003)(110136005)(478600001)(7696005)(36756003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:03:19.2077
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b226c6e-d570-4101-a038-08dafe13bf53
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6610
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently flow_offload_fixup_ct() function assumes that only replied UDP
connections can be offloaded and hardcodes UDP_CT_REPLIED timeout value.
Allow users to modify timeout calculation by implementing new flowtable
type callback 'timeout' and use the existing algorithm otherwise.

To enable UDP NEW connection offload in following patches implement
'timeout' callback in flowtable_ct of act_ct which extracts the actual
connections state from ct->status and set the timeout according to it.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V3 -> V4:
    
    - Rework the patch to decouple netfilter and act_ct timeout fixup
    algorithms.

 include/net/netfilter/nf_flow_table.h |  6 +++-
 net/netfilter/nf_flow_table_core.c    | 40 +++++++++++++++++++--------
 net/netfilter/nf_flow_table_ip.c      | 17 ++++++------
 net/sched/act_ct.c                    | 35 ++++++++++++++++++++++-
 4 files changed, 76 insertions(+), 22 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index cd982f4a0f50..a3e4b5127ad0 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -61,6 +61,9 @@ struct nf_flowtable_type {
 						  enum flow_offload_tuple_dir dir,
 						  struct nf_flow_rule *flow_rule);
 	void				(*free)(struct nf_flowtable *ft);
+	bool				(*timeout)(struct nf_flowtable *ft,
+						   struct flow_offload *flow,
+						   s32 *val);
 	nf_hookfn			*hook;
 	struct module			*owner;
 };
@@ -278,7 +281,8 @@ void nf_flow_table_cleanup(struct net_device *dev);
 int nf_flow_table_init(struct nf_flowtable *flow_table);
 void nf_flow_table_free(struct nf_flowtable *flow_table);
 
-void flow_offload_teardown(struct flow_offload *flow);
+void flow_offload_teardown(struct nf_flowtable *flow_table,
+			   struct flow_offload *flow);
 
 void nf_flow_snat_port(const struct flow_offload *flow,
 		       struct sk_buff *skb, unsigned int thoff,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 81c26a96c30b..e3eeea349c8d 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -178,28 +178,43 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 	tcp->seen[1].td_maxwin = 0;
 }
 
-static void flow_offload_fixup_ct(struct nf_conn *ct)
+static bool flow_offload_timeout_default(struct nf_conn *ct, s32 *timeout)
 {
 	struct net *net = nf_ct_net(ct);
 	int l4num = nf_ct_protonum(ct);
-	s32 timeout;
 
 	if (l4num == IPPROTO_TCP) {
 		struct nf_tcp_net *tn = nf_tcp_pernet(net);
 
 		flow_offload_fixup_tcp(&ct->proto.tcp);
 
-		timeout = tn->timeouts[ct->proto.tcp.state];
-		timeout -= tn->offload_timeout;
+		*timeout = tn->timeouts[ct->proto.tcp.state];
+		*timeout -= tn->offload_timeout;
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
 
-		timeout = tn->timeouts[UDP_CT_REPLIED];
-		timeout -= tn->offload_timeout;
+		*timeout = tn->timeouts[UDP_CT_REPLIED];
+		*timeout -= tn->offload_timeout;
 	} else {
-		return;
+		return false;
 	}
 
+	return true;
+}
+
+static void flow_offload_fixup_ct(struct nf_flowtable *flow_table,
+				  struct flow_offload *flow)
+{
+	struct nf_conn *ct = flow->ct;
+	bool needs_fixup;
+	s32 timeout;
+
+	needs_fixup = flow_table->type->timeout ?
+		flow_table->type->timeout(flow_table, flow, &timeout) :
+		flow_offload_timeout_default(ct, &timeout);
+	if (!needs_fixup)
+		return;
+
 	if (timeout < 0)
 		timeout = 0;
 
@@ -348,11 +363,12 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 	flow_offload_free(flow);
 }
 
-void flow_offload_teardown(struct flow_offload *flow)
+void flow_offload_teardown(struct nf_flowtable *flow_table,
+			   struct flow_offload *flow)
 {
 	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
-	flow_offload_fixup_ct(flow->ct);
+	flow_offload_fixup_ct(flow_table, flow);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -421,7 +437,7 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
 {
 	if (nf_flow_has_expired(flow) ||
 	    nf_ct_is_dying(flow->ct))
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 
 	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
@@ -569,14 +585,14 @@ static void nf_flow_table_do_cleanup(struct nf_flowtable *flow_table,
 	struct net_device *dev = data;
 
 	if (!dev) {
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 		return;
 	}
 
 	if (net_eq(nf_ct_net(flow->ct), dev_net(dev)) &&
 	    (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
 	     flow->tuplehash[1].tuple.iifidx == dev->ifindex))
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 }
 
 void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 19efba1e51ef..9c97b9994a96 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -18,7 +18,8 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 
-static int nf_flow_state_check(struct flow_offload *flow, int proto,
+static int nf_flow_state_check(struct nf_flowtable *flow_table,
+			       struct flow_offload *flow, int proto,
 			       struct sk_buff *skb, unsigned int thoff)
 {
 	struct tcphdr *tcph;
@@ -28,7 +29,7 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
 	if (unlikely(tcph->fin || tcph->rst)) {
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 		return -1;
 	}
 
@@ -373,11 +374,11 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	iph = (struct iphdr *)(skb_network_header(skb) + offset);
 	thoff = (iph->ihl * 4) + offset;
-	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
+	if (nf_flow_state_check(flow_table, flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 		return NF_ACCEPT;
 	}
 
@@ -419,7 +420,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
 		if (ret == NF_DROP)
-			flow_offload_teardown(flow);
+			flow_offload_teardown(flow_table, flow);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -639,11 +640,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + offset);
 	thoff = sizeof(*ip6h) + offset;
-	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
+	if (nf_flow_state_check(flow_table, flow, ip6h->nexthdr, skb, thoff))
 		return NF_ACCEPT;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {
-		flow_offload_teardown(flow);
+		flow_offload_teardown(flow_table, flow);
 		return NF_ACCEPT;
 	}
 
@@ -684,7 +685,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	case FLOW_OFFLOAD_XMIT_DIRECT:
 		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
 		if (ret == NF_DROP)
-			flow_offload_teardown(flow);
+			flow_offload_teardown(flow_table, flow);
 		break;
 	default:
 		WARN_ON_ONCE(1);
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 0ca2bb8ed026..861305c9c079 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -274,8 +274,41 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
 	return err;
 }
 
+static bool tcf_ct_flow_table_get_timeout(struct nf_flowtable *ft,
+					  struct flow_offload *flow,
+					  s32 *val)
+{
+	struct nf_conn *ct = flow->ct;
+	int l4num =
+		nf_ct_protonum(ct);
+	struct net *net =
+		nf_ct_net(ct);
+
+	if (l4num == IPPROTO_TCP) {
+		struct nf_tcp_net *tn = nf_tcp_pernet(net);
+
+		ct->proto.tcp.seen[0].td_maxwin = 0;
+		ct->proto.tcp.seen[1].td_maxwin = 0;
+		*val = tn->timeouts[ct->proto.tcp.state];
+		*val -= tn->offload_timeout;
+	} else if (l4num == IPPROTO_UDP) {
+		struct nf_udp_net *tn = nf_udp_pernet(net);
+		enum udp_conntrack state =
+			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			UDP_CT_REPLIED : UDP_CT_UNREPLIED;
+
+		*val = tn->timeouts[state];
+		*val -= tn->offload_timeout;
+	} else {
+		return false;
+	}
+
+	return true;
+}
+
 static struct nf_flowtable_type flowtable_ct = {
 	.action		= tcf_ct_flow_table_fill_actions,
+	.timeout	= tcf_ct_flow_table_get_timeout,
 	.owner		= THIS_MODULE,
 };
 
@@ -622,7 +655,7 @@ static bool tcf_ct_flow_table_lookup(struct tcf_ct_params *p,
 	ct = flow->ct;
 
 	if (tcph && (unlikely(tcph->fin || tcph->rst))) {
-		flow_offload_teardown(flow);
+		flow_offload_teardown(nf_ft, flow);
 		return false;
 	}
 
-- 
2.38.1

