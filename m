Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95DA2679B01
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbjAXODs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234383AbjAXODq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:03:46 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46784166F4;
        Tue, 24 Jan 2023 06:03:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1RiTcupa/8z4XAGE9REmUx9BU65LO+lW7H3CpTIi7ilqBrhG9jZj+bl10UBFm6K26LIltl5I0GFUqvGZ+Ix8nCgXEIowZeGcOxeeogcIDTgOAu3/YVG4luRQI/HTtuuT7R6LLv08alF8otlMtYWIAz/jhqjsSMLbhinVm7t6Ua5aARo2EaKXLl0N1HCKiWSL7Y5PK1gVZumRedFQNpKgNuXeoaytA5HcV7bFEx1oCCHbtHtmNoCtAuGyHF7Y5tuixorFyxz8LqneeBXpzyB5d/mR2NvlwdPT+cEecf8NZl/otM4nHy5/gz+vljzx+E7AA+weaytgEWOUvwj+MZg4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5yCSI090vdvvgrXiokyByxwXHMggpZF2LwKEnNUtykU=;
 b=YcMUIGhHA6mzqJLYW7NHFwHK2xv7b730bVzeTlTe56v9yM92SuSkmRzbrQeFDVDhyKPfFtBTmFxR3lQGjGCVlUZLuNJitUWAnreRS5hfOGuxQRGb3I1mbp7dKhhujqRxQEFIm/1OSV9rdqgqiSVpEaDwcONz36yPfLbp1ULKUwwyOO7IEAF8Q5V7xCHi+w0WcSv0Amtrrn5bV5YpmGgKeZD0Vb0ekA7MgzMLBXevhdgrWQcqvApTdOyKnLPYNgQKJHNxy+2cF6Da6N+Iam5H5n3DSN5w13vKAryxYok9hKOR8r8Bd0roY3Fhny8WOgod6Uw6m/8zGL/SknZxkNvS+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yCSI090vdvvgrXiokyByxwXHMggpZF2LwKEnNUtykU=;
 b=p1vLBBfOOlppPbyzsBwIszyxgkQgIGIV3QgoDPfyM8W8oq/84t9tqppPJxNDdLLeBs6VPNMcEqmXq1XYEwxSb9vXjMo5Wu/MLxqTIg5ud+tj1iYslsulWgCyx/gjBazxrhYcs/xrzNjU+dXxcicEhr+zcGihnY5qtCjSfNy8JW6ics9LxKm/wKU1cmkfLY5oLLHIS/Aml/zr3JzWkpDluZ6OOb+67LuDZpuO9A48s6/hFsSZVKcn6B8x47r6a5CMkzD4im1l0Q8QIgtV/xjHzUPDvGY87Mz6Mxt0TNLkCT3z3DBRAyyTih435kdYIXQciwTEZT9yIKk2LNll9lIZBA==
Received: from BN9P223CA0008.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::13)
 by CO6PR12MB5459.namprd12.prod.outlook.com (2603:10b6:303:13b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:03:14 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::c7) by BN9P223CA0008.outlook.office365.com
 (2603:10b6:408:10b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 14:03:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17 via Frontend Transport; Tue, 24 Jan 2023 14:03:13 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:02:52 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 24 Jan
 2023 06:02:52 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 24 Jan
 2023 06:02:47 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v4 1/7] net: flow_offload: provision conntrack info in ct_metadata
Date:   Tue, 24 Jan 2023 15:02:01 +0100
Message-ID: <20230124140207.3975283-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230124140207.3975283-1-vladbu@nvidia.com>
References: <20230124140207.3975283-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT047:EE_|CO6PR12MB5459:EE_
X-MS-Office365-Filtering-Correlation-Id: cdcfe3dd-ae27-4c8d-0f88-08dafe13bc09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nx6594WyGYVicv55MDa0S7LN7/ZepqyUyypXunQIeVoBHISyuILwXd3+VIn50VwdWh9C9OrMgnVeuPgoFT99yED260OWLTXEz4nUqujyBYeZVbTv4Gx2SYGb9sbJmtal+6zJ2APo1YVdDfd9edBj1cr9lNQB+btqKMCT/HwtLo3ONdTobK/uZS/rIDz/kEczE35cF40glOoVSBj+I95jA+cT2PpPVa0rRrY2INkBkRcVHc4Ywmd6OQo7s9tUI1eswPmDc8BCDDiL7x/0gkbzL5EK6hdbGUQMBhw1S3g7O6MMxV9Xw4l9J1LK9sOxqd/A3F++Oo6L98BaER31Az5rwRLzHVpmFzxmOdLRwwBHZPwK2hWqSm6Ov8neHDoU9Dn7M+C2xf417gcSj/LncoTPICJtAIQ7F8v3id09M6IjNBExH1xxHNd0kNaEV/AbNl1F7qLQ2ur55lYTCTBNStozuRLhHVWFqUKXlqfSN1M+lTKeLw7EWAB9MdSpBCCQJE6ZrYPyoaN+mFbZHp38hmOkTO5T8EoB/4jbCfz4+IyviyG6zV1iXizMe7od7ZUlrB8ZSfd6bp6pNp/MQJbqq+XXpElxIG/BJrLhndwsr3NBH/m4RVgX9tZJXHVvvePDPw2P6soBNS1Hacjh/Xgyv85CUwnPQ5Q5cQmQe1Rrs0XlqHP0vViD7Gl2/D9bRFbnH7ynh/TXMdIn3I4iE8vUi6AU9zaFvSPdQK7hgHEE8gu6aIQ=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199015)(40470700004)(46966006)(36840700001)(36756003)(82740400003)(2906002)(5660300002)(356005)(7416002)(7636003)(8936002)(4326008)(82310400005)(41300700001)(83380400001)(36860700001)(86362001)(40460700003)(478600001)(7696005)(110136005)(40480700001)(26005)(186003)(8676002)(316002)(54906003)(70206006)(2616005)(336012)(1076003)(426003)(107886003)(70586007)(47076005)(6666004)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:03:13.6859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cdcfe3dd-ae27-4c8d-0f88-08dafe13bc09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5459
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to offload connections in other states besides "established" the
driver offload callbacks need to have access to connection conntrack info.
Flow offload intermediate representation data structure already contains
that data encoded in 'cookie' field, so just reuse it in the drivers.

Reject offloading IP_CT_NEW connections for now by returning an error in
relevant driver callbacks based on value of ctinfo. Support for offloading
such connections will need to be added to the drivers afterwards.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---

Notes:
    Changes V3 -> V4:
    
    - Only obtain ctinfo in mlx5 after checking the meta action pointer.
    
    Changes V2 -> V3:
    
    - Reuse existing meta action 'cookie' field to obtain ctinfo instead of
    introducing a new field as suggested by Marcelo.
    
    Changes V1 -> V2:
    
    - Add missing include that caused compilation errors on certain configs.
    
    - Change naming in nfp driver as suggested by Simon and Baowen.

 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  4 ++++
 .../ethernet/netronome/nfp/flower/conntrack.c | 24 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 313df8232db7..193562c14c44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1073,12 +1073,16 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
 	struct flow_action_entry *meta_action;
 	unsigned long cookie = flow->cookie;
+	enum ip_conntrack_info ctinfo;
 	struct mlx5_ct_entry *entry;
 	int err;
 
 	meta_action = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
 	if (!meta_action)
 		return -EOPNOTSUPP;
+	ctinfo = meta_action->ct_metadata.cookie & NFCT_INFOMASK;
+	if (ctinfo == IP_CT_NEW)
+		return -EOPNOTSUPP;
 
 	spin_lock_bh(&ct_priv->ht_lock);
 	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index f693119541d5..d23830b5bcb8 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1964,6 +1964,27 @@ int nfp_fl_ct_stats(struct flow_cls_offload *flow,
 	return 0;
 }
 
+static bool
+nfp_fl_ct_offload_nft_supported(struct flow_cls_offload *flow)
+{
+	struct flow_rule *flow_rule = flow->rule;
+	struct flow_action *flow_action =
+		&flow_rule->action;
+	struct flow_action_entry *act;
+	int i;
+
+	flow_action_for_each(i, act, flow_action) {
+		if (act->id == FLOW_ACTION_CT_METADATA) {
+			enum ip_conntrack_info ctinfo =
+				act->ct_metadata.cookie & NFCT_INFOMASK;
+
+			return ctinfo != IP_CT_NEW;
+		}
+	}
+
+	return false;
+}
+
 static int
 nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offload *flow)
 {
@@ -1976,6 +1997,9 @@ nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offl
 	extack = flow->common.extack;
 	switch (flow->command) {
 	case FLOW_CLS_REPLACE:
+		if (!nfp_fl_ct_offload_nft_supported(flow))
+			return -EOPNOTSUPP;
+
 		/* Netfilter can request offload multiple times for the same
 		 * flow - protect against adding duplicates.
 		 */
-- 
2.38.1

