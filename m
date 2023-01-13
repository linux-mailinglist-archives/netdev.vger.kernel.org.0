Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37715669ED0
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjAMQ4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjAMQ4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:56:40 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABA338AE3;
        Fri, 13 Jan 2023 08:56:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0ejipIAcwlnqSLCYJYEm9gh0/gGVe6UB6p6tKGhRR8Gq31zDjCpE6BNj8zvD5WDpAYktMcjidjzJD1Ay79sPsS6IGm3T2nkvsLcWP2o45DoHWP3S7g8uUTxduoVls9rDZRYEPTyDwqFJetePt4iUjEhNzl/RWTpMkcATeDnls8xL/xDrGk+Ds4t4d4HpMc96bfBOn18OBQbYwbNuvXlc0aCPi8aQOs3L78jbbCrQb0dZ6iijWpyLXhrfDseY5q+KIO51txiDBme7JhJu1FgYoxsfpCfaKnOKm2Z2aMxTPeijjMcaClx/4y/CW8v1FUW9i1Uf3F9YOcMviI5/aoL0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEEJgQznU3MBGCUBLRmHdBKj3L9D9g3O21HEOTpLrH4=;
 b=RexVSx1neH+nXa/uIXtjFP3zhFuO0ADLVIDUAskjLWaPaZXkozM3w70AOweD4COQXhhoQ3AEIreSzikwaMYpssYxSPvVjuG+S1/UAqJM3PGWfkQFid3+4e9trOb7GRQauaVFo24GjPfYTlvRR9D9Teq0wM/xVXWIv3Vlv5SmJ1B5/xQSobZ8NllrWmLizibNaGobY1B1wxuuff2bk61wLPqYXvm/lmwEtjr0l0TtCE+cyepxCL4pdAMDJdYkKaU/koXHiJr6BSv0SWTKb+ewFtdmIQbGVh4fal+/rRZFJcyTssb89kVIfdVY0P82P5lm+mgtOB3mb6ri8kJbsvQvDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEEJgQznU3MBGCUBLRmHdBKj3L9D9g3O21HEOTpLrH4=;
 b=FoPYw1Ru1qGgI/A2sTwDMegbyApVBtEng77Tbd8TJQXnba1T9A53xY6VtVJJtOch9EPFg3hWcUXlbCkGv3hM5vG0izgzgZcXLjdxFvrsHiYug6izcVaF7KRSjBLg/CPgNAmy3lCAz1R/Risdo7Nn2mhW43oFP6hEXSlgXPaEgitfcT7IBKiJN3fWG+unOqiAMib19Bu7h+9hxVlRXiwp5GB6QEyAkm68POYmtRBkrDmeRdv807P+9D+m2kR/9cEIijH1DgWTTnsoPaKeWsM1rzf5KU/F5hgLnezXsCGALvYkivSTme31yqrYErcBOrf2xKn/XzLoK+Y82F24UPB/rw==
Received: from DS7PR03CA0291.namprd03.prod.outlook.com (2603:10b6:5:3ad::26)
 by DS0PR12MB7971.namprd12.prod.outlook.com (2603:10b6:8:14e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 16:56:38 +0000
Received: from DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::3f) by DS7PR03CA0291.outlook.office365.com
 (2603:10b6:5:3ad::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.14 via Frontend
 Transport; Fri, 13 Jan 2023 16:56:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT071.mail.protection.outlook.com (10.13.173.48) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 16:56:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:27 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:56:26 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 13 Jan
 2023 08:56:23 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v2 1/7] net: flow_offload: provision conntrack info in ct_metadata
Date:   Fri, 13 Jan 2023 17:55:42 +0100
Message-ID: <20230113165548.2692720-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113165548.2692720-1-vladbu@nvidia.com>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT071:EE_|DS0PR12MB7971:EE_
X-MS-Office365-Filtering-Correlation-Id: 4519e116-5e36-49f9-5ba8-08daf587230b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 60/yK3WzxIA2BuDLxsp6jce9KFjjrmYNuQedpCO+AbmBB75KO3Z49fe3RS+WUEeVl0rlEZrD5Fr9BjY9uDBuxixo78wDrnhEXT/W0D+3NYV2TjwJ0laLp+dQ+4wUCcUeO51JmKaEqhAHYEAll4rMfI1VCKJBJfyMrag5lqZKgKQjk2VjMllthvF09ClyYS8ZMz8BK/dE0+3/vRKG/Bmdk0qk8Ffe6QMwB0ivi0IdU6mL+gLWAknXL5yplfgs5NQJfl+ESYgfTZjHsLRkQjSPaTUs8GIzhBMYp0AO8OJ/0MmeeVC20G5pqyDCSnU9gb8KxmUGZY0l/epEDdsHVpd1k3ka1/AgGUKnhX1Wut0s3t0VgQqhwdUywIsr9fCpZQ4CZ9+/i3wzCTph5qGsR7+iEhWbJAg/EW1WgGnQHiRxmPSfCskW4tmTvcQC3lrbRHr/dh6b53Gq+sPu7r1albQOViLUifO83x0Ce9FhsOlTyTn04X97mXiDPi0m42u7Ps1LIX1egMlxGckrcKHE4ZxzboER5twijl3ofwKBlE/feRge/gwKQJXK6ti/KnFY5jwak+Hyv2ZkNbngRxzFgXeh0ZiPOzJ7YXrw0m1rGd2Y9RoKaXeAcalXgF/1BfPWk7S7WxBpzcUq7rNYUtRoFytseQggdvxX6BbuwXG4O4JUDph65DrJHrjXGGgzUJwA+ysxRI9FHUrVJfCeHYCG3VnI89dHUADT0l8bMGp5RLhXzJ4=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199015)(36840700001)(46966006)(40470700004)(8936002)(5660300002)(7416002)(54906003)(41300700001)(4326008)(70206006)(70586007)(316002)(2906002)(110136005)(8676002)(7696005)(7636003)(356005)(82740400003)(478600001)(186003)(107886003)(82310400005)(26005)(36756003)(6666004)(36860700001)(336012)(426003)(47076005)(1076003)(40480700001)(40460700003)(86362001)(2616005)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:56:38.1964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4519e116-5e36-49f9-5ba8-08daf587230b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT071.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7971
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

Notes:
    Changes V1 -> V2:
    
    - Add missing include that caused compilation errors on certain configs.
    
    - Change naming in nfp driver as suggested by Simon and Baowen.

 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  2 +-
 .../ethernet/netronome/nfp/flower/conntrack.c | 20 +++++++++++++++++++
 include/net/flow_offload.h                    |  2 ++
 net/sched/act_ct.c                            |  1 +
 4 files changed, 24 insertions(+), 1 deletion(-)

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
index f693119541d5..f7569584b9d8 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -1964,6 +1964,23 @@ int nfp_fl_ct_stats(struct flow_cls_offload *flow,
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
+		if (!nfp_fl_ct_offload_nft_supported(flow))
+			return -EOPNOTSUPP;
+
 		/* Netfilter can request offload multiple times for the same
 		 * flow - protect against adding duplicates.
 		 */
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 0400a0ac8a29..a6adaffb68fb 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/netlink.h>
+#include <linux/netfilter/nf_conntrack_common.h>
 #include <net/flow_dissector.h>
 
 struct flow_match {
@@ -288,6 +289,7 @@ struct flow_action_entry {
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

