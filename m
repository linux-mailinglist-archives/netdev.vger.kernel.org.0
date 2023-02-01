Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEB7686BC9
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjBAQb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbjBAQbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:31:53 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2042.outbound.protection.outlook.com [40.107.102.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C172F79613;
        Wed,  1 Feb 2023 08:31:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtMAJhRb0D6xS9wjRt6yyAcecak6A+4jCzsPRXy0L2R8ShAxRHZOxdwCEePY1MRvEgORSdsRKBwvOJe3lmiRCkugi3/jYBgigvhcG/D9kw5n/0E0BwVRoYEigLrzdbBaNk+BmwGlcQ5S29BOkppkVOwmIuah9SpwBER33DtbFbvEX//+i9PkL+h9zlEdXq5PchARlj/qMceGCMCPzfyqK57SdGOTM6zHZHWeFzsA59e91j3K5hdgp/CGQTGEkFWkpMD1OPyDNwrBbEbKbKP6yaM/78JRRVNq8w7Bxg7fNgrhIrVRpqLj98qP0h1aW4nAAJw3DFPB+6hDWT3Ro2RtaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7yw8iysmAzf7U1K7YO7uEYZwafeQzoXEnRG7RqpZfpw=;
 b=k4usnCdo60moxyE6D/QZKuzuqXF23ylhikAJQ04jJTgWxEXBzN7ZRyon0oTps3xh8DVOUw9iePQxwqzrsMzhxcP/I1HQHxQA+dl+NOFY3dK1gq2ngXHaYFkItBXaULTeMb6Y1ojMxnoxSoFqWDM1JQosPcDe0zeGyMCFsL4McOvi+wVkSsVgSRlkjvMhUg3jMSIidpOAawFEncMCLNIY/uWAbntNINDO41ZfSaNyOQRkiFApf9tCUh25LVSBG/M3DznSdee5D912rqHnkB4mzTiJYZQazH+r+mj2w0sBMvcZdHoM+tUSVhB45YXtHXt/QK6+B684gbk7c0rpcMW/ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7yw8iysmAzf7U1K7YO7uEYZwafeQzoXEnRG7RqpZfpw=;
 b=l04s4zmdZIyZV0LCBTeAMlTU/Ig1aYb0fyu2BisyrGDaUw+AmElfA1wmzhK7yosVvSOYyNoqFr/1W36xtSft8UCBaclrK0il9uGhJ64AAcmZklknB0la740Ll7kKcsN3FwI8UbYBSPBcx7zcN8Q7tX8e1QKYq+43VfTbfGoedI8tdeb6/35mZRM/OwVsOhtvwPN95zWCt10r5efApvPjLxdWzu591yxIagzQMLeJIuU0eUIkQlNgLB8l/6+o7ss1RRDHiaEGPBwLhECZoRIKbhrK0LHXZWgM/FBtUk7/xCGlmSABRanZIoTkj/Di8HDOShFHlOUaEImtgsMDfDKqsw==
Received: from MW4P223CA0026.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::31)
 by BN9PR12MB5083.namprd12.prod.outlook.com (2603:10b6:408:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Wed, 1 Feb
 2023 16:31:47 +0000
Received: from CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::bb) by MW4P223CA0026.outlook.office365.com
 (2603:10b6:303:80::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36 via Frontend
 Transport; Wed, 1 Feb 2023 16:31:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT105.mail.protection.outlook.com (10.13.175.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Wed, 1 Feb 2023 16:31:45 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:31:32 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 1 Feb 2023 08:31:32 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 1 Feb 2023 08:31:29 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v6 4/7] netfilter: flowtable: cache info of last offload
Date:   Wed, 1 Feb 2023 17:30:57 +0100
Message-ID: <20230201163100.1001180-5-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230201163100.1001180-1-vladbu@nvidia.com>
References: <20230201163100.1001180-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT105:EE_|BN9PR12MB5083:EE_
X-MS-Office365-Filtering-Correlation-Id: cf9573a8-efbf-4abd-0a1c-08db0471cf54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DHgXHHzhjyZRFSo4a7KKd9iYpbJlGhIq30Yd5thYhdwT3J7M4pBLo/nBLkomvYzqpWlCBifzfOiEUMiA40no5p8oq5pcOLnmDfyLgWLR10Mp3+ZV/FJP1VUTcoJ1qgcwc1NnKEelgwA1aLJyLiK7pDE/e4hOv6GPayXI4SxToOkgq+TVLCujIaYwQRFwYDi0Xrl9BZRJlJT+d/vU+Yhc/AfKFT7u5W6DpPdhZ0YpM84u8tGrd6rDduY8jfrOL8SSFhwgo8wsgPB6uETSWgfQSEofiBg69jS/VNoLEgco2bChFBOYQ9/r9eRfFuySsg/n3nvg2Y4xy2M0WRXmX1X+khWwhZLiQOmwnzjX2vA2WD+S6f8PgIHKWwh9Hb+ZPvhFT9N2Vbs/MGlcX2UhHCbHjda3WzdNDA6AE5gJ+UC1y4hD0xOnRh9TOAEyb9XDpfb6RJtmLQKL3WS4vtwF2pUKFXwKuPxdb5NmDhsIFz1CI8/lP/vD5em6TaMmgJ8JkQ5v2KUp9TR7AMPypmWidPDKQNCAEnar5kGl1QqyfQ1bGjT3nqx4SJ3+se65wcmlb1RZtfUAY/AOVGrfJ+kfCj8PJgQGVvPMz3d8dhM+xaWD7nZVNIeLEyqVoSWsJdBN1jRYaYcxYK14y8wjPF0+egUuFVXHMRO+GikrDHoNRyCaIOBeB1yySgkjj4xxe5GO0KHdfxgBwogBhgjzpCz2oCS8aS3s1SYVw02Q/3MknsVq8Hc=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199018)(46966006)(40470700004)(36840700001)(107886003)(6666004)(478600001)(82310400005)(36756003)(36860700001)(47076005)(83380400001)(86362001)(426003)(40480700001)(356005)(82740400003)(40460700003)(7636003)(1076003)(336012)(2616005)(26005)(186003)(8936002)(41300700001)(2906002)(5660300002)(7416002)(54906003)(110136005)(7696005)(70586007)(70206006)(4326008)(8676002)(316002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:31:45.8326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf9573a8-efbf-4abd-0a1c-08db0471cf54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5083
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify flow table offload to cache the last ct info status that was passed
to the driver offload callbacks by extending enum nf_flow_flags with new
"NF_FLOW_HW_ESTABLISHED" flag. Set the flag if ctinfo was 'established'
during last act_ct meta actions fill call. This infrastructure change is
necessary to optimize promoting of UDP connections from 'new' to
'established' in following patches in this series.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V5 -> V6:
    
    - Rework the patch to only set flow_offload NF_FLOW_HW_ESTABLISHED flag
    instead of caching whole ctinfo in dedicated field.
    
    Changes V3 -> V4:
    
    - New patch replaces gc async update that is no longer needed after
    refactoring of following act_ct patches.

 include/net/netfilter/nf_flow_table.h |  7 ++++---
 net/netfilter/nf_flow_table_inet.c    |  2 +-
 net/netfilter/nf_flow_table_offload.c |  6 +++---
 net/sched/act_ct.c                    | 12 +++++++-----
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 88ab98ab41d9..ebb28ec5b6fa 100644
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
@@ -165,6 +165,7 @@ enum nf_flow_flags {
 	NF_FLOW_HW_DEAD,
 	NF_FLOW_HW_PENDING,
 	NF_FLOW_HW_BIDIRECTIONAL,
+	NF_FLOW_HW_ESTABLISHED,
 };
 
 enum flow_offload_type {
@@ -313,10 +314,10 @@ void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
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
index 0ca2bb8ed026..5837f6258b17 100644
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
+		set_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
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

