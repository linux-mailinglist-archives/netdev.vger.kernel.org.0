Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A486641E8
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbjAJNcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbjAJNba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:31:30 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C832197;
        Tue, 10 Jan 2023 05:31:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LUnvWYYSHrktvYiWeyLzseTzzmTxQCMc5H4pM52uW37ZCi2AapJKUoWouFT5ckFA8fIqF91COKflWKlopZMFMs0mLhr3Wgq5lhvuy2Fb+f0ASfu7Vz0BjRjBQxPit79f+WPZBb6dHEjAdfQT/1nGnwAhFwrALG9w6xmGVCzkmQfETMADC16ew+l0Hbl61Ecg44be7fOpbTd8yRkqNzOlzZ2f4pK3NSkfLak5V2qCDilcPnzPy8zM0HRdtavuYeQhmvJE3NC8DuOUvt7EfxSOpy5Rs28OLWnJbL2rAvMGcWdrCjx1AzqwufFhHKM3RzvoerW9lAXnUsHnzzS68Crqsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLJekRO2OoO/bta6mmFV6UN1TNc44YJFaehwu0WnfqI=;
 b=f5cuwMR6u3ufN/nlYOa7CLeUPL22//u41ZQazpvF1dOfJNvy2SaTvcPzJAFSpXC0naeyZMGHApcPsdhzqSlGz+4aJNE1yIj7Pla9By/MNZck0+ipPoQMo4qZK41IxNHzpcSDSyPtWBczfVaCHSB0k9S+cZ3jkcj/oyxWJjYYsGbSijUjGgLYIf01FOmFr7sE2EgAuFKer/ZCbIomnvimqDaba15U32mUHip7PpirL6U5Ibt7sWs1J8xto/ZcRbyfyDdF8er7Ln1s/RU/nLofMfK4pu3JocSaQTfu3Enu5/Dt3gQQoBPIboowFlq7z/Zg9oMpyNVIeeE0oIbgyFfVDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLJekRO2OoO/bta6mmFV6UN1TNc44YJFaehwu0WnfqI=;
 b=ogXNbSjvKCHG/r/JR5l7aUSPNCmmYJoREGwqa/SIRJqJTFHQypXLP1s9C5tKuC4FjoFdX8pr3EhWXcj0agq0zMlm83rGgFcAPLyOgVeADW96nN1AMqQOtOXlUOoPgNCri31acOh99eIBbYH7aSb93ggsk5dlI1gCBWwV50o9RMEO2Aisbb0FoexNJFodq3Mpa3voGF05EmcFmagJEhTDv3BpDJ0hnEZsvLWL2Bi7DEztl+OWc2SIEUedG+YpBcWqOs0lXebHwYUQT338CXbeO85g3B3oqBya8CQWjWd3oL+vQwuZ7K/HI/lcfOUtrYiLi5kerQ90rNAuuJ60/+8uSg==
Received: from BN9PR03CA0574.namprd03.prod.outlook.com (2603:10b6:408:10d::9)
 by BY5PR12MB4936.namprd12.prod.outlook.com (2603:10b6:a03:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 13:31:25 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::a1) by BN9PR03CA0574.outlook.office365.com
 (2603:10b6:408:10d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 13:31:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Tue, 10 Jan 2023 13:31:24 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:02 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:02 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 10 Jan
 2023 05:30:58 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v1 1/7] net: flow_offload: provision conntrack info in ct_metadata
Date:   Tue, 10 Jan 2023 14:30:17 +0100
Message-ID: <20230110133023.2366381-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110133023.2366381-1-vladbu@nvidia.com>
References: <20230110133023.2366381-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT052:EE_|BY5PR12MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: 5711a2ed-eb3c-4a68-c753-08daf30ef800
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YHdJvJmRbF9EPuh15OFABcF4Ok4F8pdmVwtmef5rE20DUnX6aHfYDLNS79aHv5HZKSiL34oOwvMDelJgyn9rZ8+xkMF+OSZ7+nlmNOMjfdaRLkfQRaZMjdxYHKWYZfCTggbCdgZv1tXSqkdCnYLLzVSCN1ddxLjgYwsO7myk6o69t+k0otUw1eT63Axigf9ns6wfEAM08LG2saNwhRRS5uy/CZ6P0y/190ySAPQWyA8753CkJorMTPNHhC0OddF19H5zQ/IqoBurdYTB7PO61RXzn4BOCgDBOF+mHr/Zez3IFUUrDYqAjDghClnVoKNFWbTFU4vkIQ8qnoglgszz5U1D2hI8z6TuIPu6D1Je2saNckGdOapG0CahhCuyK8hIlmXxSy/4HM5MIZuU4vQG2hOOTphFEWHmP9CEAKcNrW19S7GcQ1X9PxpG62G/GLo/xFp1WsHOLgFgoR+4u20YPHoCoe8Yu4zG3yHmIFwGWT+nllU9MLTLUmVOp+V2ebTWSvd3nEIOBNmcjLLYura/EfM+Q1H0rXcNr2P6R/QX/Okq5VVgb7QsXepWHQay8B/WpfJZ5vdCORLPkKep+UhdRvf5h0qBA+d4WHEibEQpAvqV463i/N/wQhPjOoRqTmgHxr98Fiy2YOuIjkvMC7NswyEBlrA59WUGzaKc0SFWyfOv1ONBZ89SjiEa1EfZ4ui8aUzjna9xj/+pDUBVtLOihqbJV8GoYcwBT/3w/9pG5Q8=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(36840700001)(46966006)(40470700004)(2906002)(82310400005)(47076005)(83380400001)(336012)(36860700001)(426003)(2616005)(1076003)(7696005)(7416002)(5660300002)(40480700001)(107886003)(6666004)(8936002)(26005)(186003)(36756003)(478600001)(7636003)(70586007)(110136005)(70206006)(54906003)(8676002)(41300700001)(356005)(86362001)(4326008)(316002)(40460700003)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 13:31:24.0051
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5711a2ed-eb3c-4a68-c753-08daf30ef800
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4936
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
Extend flow offload intermediate representation data structure
flow_action_entry->ct_metadata with new enum ip_conntrack_info field and
fill it in tcf_ct_flow_table_add_action_meta() callback.

Reject offloading IP_CT_NEW connections for now by returning an error in
relevant driver callbacks based on value of ctinfo. Support for offloading
such connections will need to be added to the drivers afterwards.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  2 +-
 .../ethernet/netronome/nfp/flower/conntrack.c | 20 +++++++++++++++++++
 include/net/flow_offload.h                    |  1 +
 net/sched/act_ct.c                            |  1 +
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 313df8232db7..8cad5cf3305d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1077,7 +1077,7 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	int err;
 
 	meta_action = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
-	if (!meta_action)
+	if (!meta_action || meta_action->ct_metadata.ctinfo == IP_CT_NEW)
 		return -EOPNOTSUPP;
 
 	spin_lock_bh(&ct_priv->ht_lock);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index f693119541d5..2c550a1792b7 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1964,6 +1964,23 @@ int nfp_fl_ct_stats(struct flow_cls_offload *flow,
 	return 0;
 }
 
+static bool
+nfp_fl_ct_offload_supported(struct flow_cls_offload *flow)
+{
+	struct flow_rule *flow_rule = flow->rule;
+	struct flow_action *flow_action =
+		&flow_rule->action;
+	struct flow_action_entry *act;
+	int i;
+
+	flow_action_for_each(i, act, flow_action) {
+		if (act->id == FLOW_ACTION_CT_METADATA)
+			return act->ct_metadata.ctinfo != IP_CT_NEW;
+	}
+
+	return false;
+}
+
 static int
 nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offload *flow)
 {
@@ -1976,6 +1993,9 @@ nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offl
 	extack = flow->common.extack;
 	switch (flow->command) {
 	case FLOW_CLS_REPLACE:
+		if (!nfp_fl_ct_offload_supported(flow))
+			return -EOPNOTSUPP;
+
 		/* Netfilter can request offload multiple times for the same
 		 * flow - protect against adding duplicates.
 		 */
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 0400a0ac8a29..4a350f518b40 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -288,6 +288,7 @@ struct flow_action_entry {
 		} ct;
 		struct {
 			unsigned long cookie;
+			enum ip_conntrack_info ctinfo;
 			u32 mark;
 			u32 labels[4];
 			bool orig_dir;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 0ca2bb8ed026..515577f913a3 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -187,6 +187,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 	/* aligns with the CT reference on the SKB nf_ct_set */
 	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
 	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
+	entry->ct_metadata.ctinfo = ctinfo;
 
 	act_ct_labels = entry->ct_metadata.labels;
 	ct_labels = nf_ct_labels_find(ct);
-- 
2.38.1

