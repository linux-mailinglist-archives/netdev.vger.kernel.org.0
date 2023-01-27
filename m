Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3539B67EDB7
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbjA0Sjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235088AbjA0Sj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:39:29 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAFFA5F3;
        Fri, 27 Jan 2023 10:39:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kenb16ExhHOMjWfrk/h8SjDwBd8bwFsZMz4U0+O/Bs4Vwu0BEt26NCSGIgHU6vgOhZsJwmKpDOVyu09a2i4tPgLt/2SB9FAydFOq3NSkXPNWqGiuHywq4LTqgxSv5bViVkn61Y9V3Os6sjJsGAjV41EFEeAe1uqYnXewcXcCApCPtkdJu526bBL6PSHaJDnqTwAmv9y7oT2JKwzWDBklsB9NyelgIPTHCyU+km71+xR3cutfyyOVMd1EFSVsu7lebfEsJs+nfhTBqaPMb3ibf4bjQouVisL8uoBblfy1lJN20ddkX3DPIi0y/zKLRBKp5+hr4AV3Q23WA5r/MlkB3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4MqW2wuBqP+NUSb1oqVUHY/8syLIRcYnfLrWqhyD3oQ=;
 b=V01hca/Wg2OXeqfl+0GLuK7XRdihfAsw2/LP1LMvdPoxWKO57rfS5HhAUPwiGTQt4K3h9WvIJ+VSWybowrYkgGVTnhr6J6PtAN4ZwXHKBChgURu1P1ST4kCbqOtqdBi6sYoeWH8ZpRlx8w+oT9cy+pth+1miHlFefgwrnAT6yhKsPZHQMCa3PsAXjZ74p4IUOAzsQdCXfXObsHWOjKOoBBOkj1Z3fA1JJy8ldsPeZeOx7NaBlJIKN5dh6YrPocTRvBUlGQ/kdaWyc4X5Z9nB8j1qNODw7p0t/h/kla6qLJAD+O5MMnOwLb62zddhbBDOPIDibRo9T5uem6ql6zQ1Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MqW2wuBqP+NUSb1oqVUHY/8syLIRcYnfLrWqhyD3oQ=;
 b=l5TiRlJ+FWjtMZ9oamE4sau6NGgiRajvQjjx/vYaCpRVlG3fsOmXvTQePtWVmBJI52ZQKUS8gRk/XgwZ4nyHIEMzBVZjGdi80QcqmCtOmGJJAnXLPJlbaU6sjsYRqXa+dELtARaY0KsgplnFcGP+StgJFJ3POEM3RE17Zd4SHZ7Evmf9IinhF+QsUUSadmAQbZ9P+togewOw/kVqMdQaje4bDd4BSH0I3ijaP81FP+L5zVnUbvSquCyI0ap3zz1HlJv6MtRXALCCVgQrhyGalYlLGMqDrjBAaeiv84/wvVQn9C6VRHZWfp01nmVZRyf9kyzfKinJfuqqsBkd0iNtHQ==
Received: from CY5PR10CA0026.namprd10.prod.outlook.com (2603:10b6:930:1c::9)
 by DS0PR12MB6631.namprd12.prod.outlook.com (2603:10b6:8:d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 18:39:21 +0000
Received: from CY4PEPF0000B8EC.namprd05.prod.outlook.com
 (2603:10b6:930:1c:cafe::c8) by CY5PR10CA0026.outlook.office365.com
 (2603:10b6:930:1c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23 via Frontend
 Transport; Fri, 27 Jan 2023 18:39:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000B8EC.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.3 via Frontend Transport; Fri, 27 Jan 2023 18:39:20 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:14 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:39:13 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 27 Jan
 2023 10:39:10 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v5 4/7] netfilter: flowtable: save ctinfo in flow_offload
Date:   Fri, 27 Jan 2023 19:38:42 +0100
Message-ID: <20230127183845.597861-5-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127183845.597861-1-vladbu@nvidia.com>
References: <20230127183845.597861-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EC:EE_|DS0PR12MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 18a5f5e4-5252-4e8f-f3a5-08db0095cde0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JUvALr0LNNr5PIuPDdxHSAvZUvj2nB3wjmTHaT3yPXuGoDJyJNZ0WGpTyhPlMEN9/YvvfUamYt3g+KnudF1BkWtCoJR7svynJT249U88vo/dYf60R5waF7CMZcvfWB7eRiTAHIA6zrywtT4mUy5QcoGOsMQI4uhex6Sr5pFf0yYdscOZqZ0icdaTk1Q+wk5DyhT2oCnsS3+9zBjyd/q05ww+6uav/7AQOHDicRvdTZAWeHdynaUlO4laCo+ahj25tdZD4ounmUr1Sm1FO98PMKnxXMpwwnGoPqL5VLelEBjYNJ8a8oxx7CbJdTpvBL1XgWG7ZqXJSU2Pq/xIPFKwToNNRmxFXQtVcgqZyGRfquCUnL9DDUhwF2vSGIzh0U8+ZZ06BxkQiB3uJdslse9RhDeLuApQk1p3vDrY2G33J1DtC1UzOaRtIzdvV5gUfgzMX04+PYWzLJDaVivN2e/AA/IvfWi5wSCxD82jxDMPH6CA785UmkPjLHvbGQyDJRZMQdhk+Zn6zPxglB2kH6ckEzYowYoqEYXUzu6gBUd6xGQRZKVGheirS0IOzmvlYdvOAXVKNDacL0S8ktGTjRurl+w/DYQwnu/56qQeMwqMIBfe7jiXySbhHfqWk2aAy9EqwZ1YxOGiZyupVNSoNSS1V/mfM/gJRlghmWvzGCSHQDdW0Nyh5qX+Ya4w/Ad7lUmffvR55Q6C9g/Qp+vYzMtLWU5PWMS+PJ5NQcj+vaU7IbY=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199018)(46966006)(36840700001)(40470700004)(83380400001)(336012)(36860700001)(40480700001)(36756003)(40460700003)(7636003)(86362001)(82310400005)(316002)(7416002)(110136005)(54906003)(5660300002)(2616005)(426003)(356005)(8936002)(47076005)(82740400003)(186003)(7696005)(478600001)(2906002)(8676002)(4326008)(70206006)(70586007)(1076003)(26005)(6666004)(107886003)(41300700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 18:39:20.6162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a5f5e4-5252-4e8f-f3a5-08db0095cde0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6631
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend struct flow_offload with generic 'ext_data' field. Use the field in
act_ct to cache the last ctinfo value that was used to update the hardware
offload when generating the actions. This is used to optimize the flow
refresh algorithm in following patches.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V3 -> V4:
    
    - New patch replaces gc async update that is no longer needed after
    refactoring of following act_ct patches.

 include/net/netfilter/nf_flow_table.h |  7 ++++---
 net/netfilter/nf_flow_table_inet.c    |  2 +-
 net/netfilter/nf_flow_table_offload.c |  6 +++---
 net/sched/act_ct.c                    | 12 +++++++-----
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 103798ae10fc..6f3250624d49 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -57,7 +57,7 @@ struct nf_flowtable_type {
 						 struct net_device *dev,
 						 enum flow_block_command cmd);
 	int				(*action)(struct net *net,
-						  const struct flow_offload *flow,
+						  struct flow_offload *flow,
 						  enum flow_offload_tuple_dir dir,
 						  struct nf_flow_rule *flow_rule);
 	void				(*free)(struct nf_flowtable *ft);
@@ -178,6 +178,7 @@ enum flow_offload_type {
 struct flow_offload {
 	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
 	struct nf_conn				*ct;
+	void					*ext_data;
 	unsigned long				flags;
 	u16					type;
 	u32					timeout;
@@ -317,10 +318,10 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
-int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule);
-int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule);
 
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index 0ccabf3fa6aa..9505f9d188ff 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -39,7 +39,7 @@ nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
 }
 
 static int nf_flow_rule_route_inet(struct net *net,
-				   const struct flow_offload *flow,
+				   struct flow_offload *flow,
 				   enum flow_offload_tuple_dir dir,
 				   struct nf_flow_rule *flow_rule)
 {
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 8b852f10fab4..1c26f03fc661 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -679,7 +679,7 @@ nf_flow_rule_route_common(struct net *net, const struct flow_offload *flow,
 	return 0;
 }
 
-int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv4(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
 {
@@ -704,7 +704,7 @@ int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
 }
 EXPORT_SYMBOL_GPL(nf_flow_rule_route_ipv4);
 
-int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
+int nf_flow_rule_route_ipv6(struct net *net, struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
 {
@@ -735,7 +735,7 @@ nf_flow_offload_rule_alloc(struct net *net,
 {
 	const struct nf_flowtable *flowtable = offload->flowtable;
 	const struct flow_offload_tuple *tuple, *other_tuple;
-	const struct flow_offload *flow = offload->flow;
+	struct flow_offload *flow = offload->flow;
 	struct dst_entry *other_dst = NULL;
 	struct nf_flow_rule *flow_rule;
 	int err = -ENOMEM;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 861305c9c079..48b88c96de86 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -170,11 +170,11 @@ tcf_ct_flow_table_add_action_nat_udp(const struct nf_conntrack_tuple *tuple,
 
 static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 					      enum ip_conntrack_dir dir,
+					      enum ip_conntrack_info ctinfo,
 					      struct flow_action *action)
 {
 	struct nf_conn_labels *ct_labels;
 	struct flow_action_entry *entry;
-	enum ip_conntrack_info ctinfo;
 	u32 *act_ct_labels;
 
 	entry = tcf_ct_flow_table_flow_action_get_next(action);
@@ -182,8 +182,6 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
 	entry->ct_metadata.mark = READ_ONCE(ct->mark);
 #endif
-	ctinfo = dir == IP_CT_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
-					     IP_CT_ESTABLISHED_REPLY;
 	/* aligns with the CT reference on the SKB nf_ct_set */
 	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
 	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
@@ -237,22 +235,26 @@ static int tcf_ct_flow_table_add_action_nat(struct net *net,
 }
 
 static int tcf_ct_flow_table_fill_actions(struct net *net,
-					  const struct flow_offload *flow,
+					  struct flow_offload *flow,
 					  enum flow_offload_tuple_dir tdir,
 					  struct nf_flow_rule *flow_rule)
 {
 	struct flow_action *action = &flow_rule->rule->action;
 	int num_entries = action->num_entries;
 	struct nf_conn *ct = flow->ct;
+	enum ip_conntrack_info ctinfo;
 	enum ip_conntrack_dir dir;
 	int i, err;
 
 	switch (tdir) {
 	case FLOW_OFFLOAD_DIR_ORIGINAL:
 		dir = IP_CT_DIR_ORIGINAL;
+		ctinfo = IP_CT_ESTABLISHED;
+		WRITE_ONCE(flow->ext_data, (void *)ctinfo);
 		break;
 	case FLOW_OFFLOAD_DIR_REPLY:
 		dir = IP_CT_DIR_REPLY;
+		ctinfo = IP_CT_ESTABLISHED_REPLY;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -262,7 +264,7 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
 	if (err)
 		goto err_nat;
 
-	tcf_ct_flow_table_add_action_meta(ct, dir, action);
+	tcf_ct_flow_table_add_action_meta(ct, dir, ctinfo, action);
 	return 0;
 
 err_nat:
-- 
2.38.1

