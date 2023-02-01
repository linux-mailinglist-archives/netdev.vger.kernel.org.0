Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F1D686BBB
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbjBAQbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjBAQbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:31:34 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462657922B;
        Wed,  1 Feb 2023 08:31:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VssNsV3Jcwl1ukT2ZXjSFA6pCAobedE/IXbb9PT5wpdUYf007qe8hPo5XLwxH7RJitut57ILVbNnqm4dNC5D0YlK/r0z9LpG2Ur0WO27sQt0xe2gu0tO7//nDECkx0AHJyPE1xCjL00tBHyseDEQoP4VID4WFj8vkPZxozrwWRNguX3PEqfSaELsJyabdRgTEF9NGsVvv5X58EIRMUCnQQhA5Q4bf4FlMgtWX+uLptlVn9tqBghPll1eaDONnsFTocLdkzYoauHUBpU0x6Y+5maAY9sUCKOKrDRr7YUqC416an8yX9aFdW2pbEeMP/DrFQkfcAvcH7oW22Knzwm2ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5yCSI090vdvvgrXiokyByxwXHMggpZF2LwKEnNUtykU=;
 b=SUoxpB0c3wjcFkdgg0WaQAzdbAyUlFIHL2p6mXkZXmjqpmljxv2HNRcPi5uj9ka4MvCsvMqJ35CHz8XbYZEXjjjecWauTx1gLyR7wXKF+ZSkLufxZMor2wd/pBIvyGF7id0Oqbt2DITGIIIzZpL/ql9dpOQiFD4PQA/fwYgeccYdyORAZJMnkhkht2dv+uj6qgJiZdLO12vgd/Rh3ryHgaDwDfG0zzjAd9ZuYmdCpV3kcTyu2Q7mE4jFSuEMYkBcJyD0MmbMbpWzfxp/16zCGXMXP55dTwLZ2Chc8n/4Kgt7wSupGTZszi7wwmbs9pHA2OWiunXstdwzeUS3A9r+/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yCSI090vdvvgrXiokyByxwXHMggpZF2LwKEnNUtykU=;
 b=hZyGo083Bb9ZQ0hkO9qkvhkz4IFhuXL7EVsg0MtKXrQuWvtReU6wj+DkNt4GOlUYsg6p0a5081p6TKDmbl+5rRjBmHHuhajUDNEASppgugGmKM53NGq5d7ZsV2F6wE44T1/JF6AmQXRNsRJuJY1mHX/Y0YyypBJC5y6pz5TNwntGggvqUfmGN5BcitnCXb3w+ATZKCIjtpCG+CKQj1+Sp3Hx1qy0Cf1JA2ppIwa/6aE8I+hTzO8Ws+jE0N78Iv5Qxfabzush0eX0oacy75KaoDSUqmJEpNqn5qCM7EWOnlMug2Br6z1UMCkqvzUNzRheMx972n5dbHirBgQ00emjiQ==
Received: from MW4PR04CA0198.namprd04.prod.outlook.com (2603:10b6:303:86::23)
 by SA1PR12MB6701.namprd12.prod.outlook.com (2603:10b6:806:251::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 16:31:31 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::27) by MW4PR04CA0198.outlook.office365.com
 (2603:10b6:303:86::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 16:31:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Wed, 1 Feb 2023 16:31:31 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:31:22 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 1 Feb 2023 08:31:21 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Wed, 1 Feb 2023 08:31:18 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v6 1/7] net: flow_offload: provision conntrack info in ct_metadata
Date:   Wed, 1 Feb 2023 17:30:54 +0100
Message-ID: <20230201163100.1001180-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230201163100.1001180-1-vladbu@nvidia.com>
References: <20230201163100.1001180-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT058:EE_|SA1PR12MB6701:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d11e31c-48b1-4dcd-3e03-08db0471c6b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kxn38RQA0gZZTnPtPflrZHU6RLktRyDTbZIe2P5CMwlCL1rILq0UW+0QQ19/nx2P7wP5eWyk4k0Z/pCouxzU2t8Eke7Ww4mr5DwGj7cPYlULZ46vOgPvnWNch9SE6WkA7y388cx9llVBB/2tOaQBwZdaVppIP91wIZTGK9zqNkaWtZR5HZfi20hLd9UmxhThxcBpm1kR9T1Rn5vBxmRXzZCQD3vfBDKledXS54pWMal9AqjRLOGRRS05M7ozBdD47eGc5L3TODI8Jv6TboFzBA6OOMQ05oWzMCkExzQhWiLkg4DIgTYuW9Ez2yzgajdWbay72fMOeHZosudGhxE9OL3b/fJJgD88v+Y0Hf+VUF6PVgwiW2N2jRyEEujSE1YLOAwoGddPs2Kbh4dPX8bKVOm2FF7dwLIw/odJOHLgJeN2+fvr1zpSaSSvoCRC6fcyopwwVXkQFlFruREsdnKcKyYsx0MtDAnJHUWni2YRkA1jDypr7kDb5V2TFLws6Qwdxx8IVjjc98O3V8WQAXiZ4M0n4OmiQhHAMf3YsKwH/L7JatVe0lVk/bVn8fy4smq/KyRAytBOWJckFUclyDpimQb2UbUOcXYmamJnLJaB+ytxhylchKStJv6F8LjesbOhXyIXvdeEezAOIT11eRrKJALiZ286dgZ9+VdtqdEVmtJboPnnOCGvGw+cAJBVD+aaKR5sfO71nw5gWLajpqu2TiYpNNJ0mP+LULmfK89AW2w=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199018)(46966006)(36840700001)(40470700004)(2906002)(8936002)(8676002)(4326008)(336012)(478600001)(36756003)(6666004)(40460700003)(426003)(5660300002)(186003)(2616005)(107886003)(47076005)(26005)(86362001)(40480700001)(7416002)(1076003)(7696005)(41300700001)(356005)(82310400005)(83380400001)(70206006)(70586007)(7636003)(82740400003)(316002)(36860700001)(54906003)(110136005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:31:31.3898
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d11e31c-48b1-4dcd-3e03-08db0471c6b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6701
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

