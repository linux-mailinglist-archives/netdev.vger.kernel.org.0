Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20016686B4D
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbjBAQND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbjBAQMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:12:49 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6D47642E
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:12:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKgsuMGoqo//3aQ9nnQQ+xWU2oBAVhubUuPr9qTswM+2CtWCq18gp2A2dwxtKEvU2wNmmW6xms/INn6vp8mztrzlWHvajWiBEkOQU4oi6sQLp0GUjfDHi/5fBUj7Hy/M45lOXMvDl8ekxS+LOirgEw4IxW0oDujQCBYGxgk9tSJhQB4VKO8fOYt88QGkk6wz1MAeFtls7IQBm+oeCUBus3jm84o3BshUS5xBNMZE6KodnPgdDMe2Xvp1q7+vjtZ4KREpC/r6rSRApqIxvrX4GaRdkmfTD6qcI3fx15WWaUOzXEgTD6MxTS6WtCaQXB5CuQNHWIdu7pV66B3ieioNyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KaISgpC5voDKifEzzzqYhorE/phygihpt+k/s6RbayI=;
 b=NTo9/C9diZ1N2Qxy15/vTuirIDOPXzwBoHnT5ooDE5BQg+pKWLMOs++OXKbck+trELb5js+gYHwv+/fFiQO95gn4+FTSOw7IY6Spwp0r5T8dOJ/jVII0Z2eBkMkz6VXcJjRQcZ9RCyKvuRPnyrxz3JigX8NWc29i3XBxVmxbL8tQME0AyeTl9kckgkEhVXp/uuiLvN3ozcnUY9Pzx6v1z0h6bvm8GCoK9xJuUXg+CwBdr/UQUCdpVcLGxmnVLo59tV106Yi5Nwdwq6JF75e223Vr2szytE80jBmFJFEQgmhyr298W1QagB2z1VY+JfcIFh6kCyFjIAKr1ie8LZ+D3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaISgpC5voDKifEzzzqYhorE/phygihpt+k/s6RbayI=;
 b=KYj/yhy0w7LeG2wNOo/ffBYnCeTf8iu6JX+6/CZDLB1Z01OikZpQ0ndA0IDdy2S6EBCOGmnXQQ4Eix4FmgCwrM6emJvvM9OHROYX99M/GDSTfc1TNS8n6WbZTGGAM80CrMuL48eCNLLvg5T1iBlCbTZjFDcwqkqF9LvxepCvgeT15o+1vhwcsqv9FsfKMySIgKulZu7FQJxDNs1164ffhYtDuY1+8/gSeA892aEriDPEX7NlC3UQ3SG7G/1eLWaZMjVTqnSY2BX7EvOGjXUIYX007pfWOUBWIzooYhZ85iQOZx3NZluluBmK2RTp2VQo+RO+DBRN2vT/FO6z5D9hXQ==
Received: from DS7PR03CA0093.namprd03.prod.outlook.com (2603:10b6:5:3b7::8) by
 PH8PR12MB7133.namprd12.prod.outlook.com (2603:10b6:510:22e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 16:12:19 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::32) by DS7PR03CA0093.outlook.office365.com
 (2603:10b6:5:3b7::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Wed, 1 Feb 2023 16:12:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25 via Frontend Transport; Wed, 1 Feb 2023 16:12:19 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:12:11 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:12:11 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 1 Feb 2023 08:12:08 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next 9/9] net/sched: TC, support per action stats
Date:   Wed, 1 Feb 2023 18:10:38 +0200
Message-ID: <20230201161039.20714-10-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230201161039.20714-1-ozsh@nvidia.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|PH8PR12MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: 23bac678-29ce-4889-c330-08db046f1844
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T24qgR8TS5UgyiubC6W4JuaW+i2JCHg+uoie6U+rXoy8N6V6STFKDinuNZxz2Yt30mCu0zkHlKxiFAjSY81qi1xDbzbUbGg1bErQx3j8RI0cL5yAd34jsCJcfF5LJKsDcAKH9BlYdjPiNNy33eExPYcaD67hCZOFxMmnMgsNBfAXc7DdVLrgMTTJlJZQnEXpHz0zDRgsEc7qPaHKbWXukmfBtmuti8+I+i4CnlP8aVz/GoygSMs9++25oC9RRTMTZ1hVa/hUYpvehwKO3opltBsT6I47m/EcMvMqHYGB1yuPQG9IxeJ4Bg6g09kmFw1jpgtJrbT1njDmq6pFTy+i2FZmuHszGBbUwX/V7pxlE8bElCFRcv5sLDrx4sEX1K38iokk4pl397UeaKpz6ViMWJgO2bmn4deVuYDyHakOlfT6Gvng2d6G7hqCMhG+A4PQ3qrCRXjxh5UxGMHGvWFNylC/7vEQtxzZnT+zY6F1LYyThm1bJel5qyNBlFQwbdvivJnSdStHEN3YVN2Um3MdIPs1uQ9JaY+0iCXDH9JrDv1hoNporh10R14ID/TPU3yHI/hGke9c62Ny6VSP4EM4c9nQC7Yr3zVxwDaHGUvZFlBHukjxuDvdHOUI1/tVdBl7IFQje24ZQDXfdqZOKeE6IjS4fA+sTTb6n3bdoFrQ8aYGnMeHt161EwPNljrGPtJvjTwqzd4j/sTukf5TbUr+Rg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(8936002)(336012)(2616005)(186003)(54906003)(6666004)(26005)(5660300002)(40460700003)(8676002)(1076003)(107886003)(82310400005)(36756003)(4326008)(70206006)(6916009)(40480700001)(70586007)(41300700001)(426003)(36860700001)(47076005)(2906002)(478600001)(316002)(83380400001)(356005)(86362001)(7636003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:12:19.6535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23bac678-29ce-4889-c330-08db046f1844
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7133
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the action stats callback implementation to update stats for actions
that are associated with hw counters.
Note that the callback may be called from tc action utility or from tc
flower. Both apis expect the driver to return the stats difference from
the last update. As such, query the raw counter value and maintain
the diff from the last api call in the tc layer, instead of the fs_core
layer.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  | 44 ++++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.h  |  4 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 39 +++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  2 +
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  | 10 +++++
 include/linux/mlx5/fs.h                            |  2 +
 8 files changed, 91 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index b08339d986d5..3b590cfe33b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -589,7 +589,7 @@ static bool mlx5e_rep_macvlan_mode_supported(const struct net_device *dev)
 
 	act = mlx5e_tc_act_get(fl_act->id, ns_type);
 	if (!act || !act->stats_action)
-		return -EOPNOTSUPP;
+		return mlx5e_tc_fill_action_stats(priv, fl_act);
 
 	return act->stats_action(priv, fl_act);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
index d1272c0f883c..f71766dca660 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
@@ -102,6 +102,9 @@ void mlx5e_tc_act_stats_free(struct mlx5e_tc_act_stats_handle *handle)
 	struct mlx5e_tc_act_stats *act_stats;
 	int i;
 
+	if (!flow_flag_test(flow, USE_ACT_STATS))
+		return;
+
 	list_for_each_entry(attr, &flow->attrs, list) {
 		for (i = 0; i < attr->tc_act_cookies_count; i++) {
 			struct rhashtable *ht = &handle->ht;
@@ -130,6 +133,9 @@ void mlx5e_tc_act_stats_free(struct mlx5e_tc_act_stats_handle *handle)
 	int err;
 	int i;
 
+	if (!flow_flag_test(flow, USE_ACT_STATS))
+		return 0;
+
 	list_for_each_entry(attr, &flow->attrs, list) {
 		if (attr->counter)
 			curr_counter = attr->counter;
@@ -151,3 +157,41 @@ void mlx5e_tc_act_stats_free(struct mlx5e_tc_act_stats_handle *handle)
 	mlx5e_tc_act_stats_del_flow(handle, flow);
 	return err;
 }
+
+int
+mlx5e_tc_act_stats_fill_stats(struct mlx5e_tc_act_stats_handle *handle,
+			      struct flow_offload_action *fl_act)
+{
+	struct rhashtable *ht = &handle->ht;
+	struct mlx5e_tc_act_stats *item;
+	struct mlx5e_tc_act_stats key;
+	u64 pkts, bytes, lastused;
+	int err = 0;
+
+	key.tc_act_cookie = fl_act->cookie;
+
+	rcu_read_lock();
+	item = rhashtable_lookup(ht, &key, act_counters_ht_params);
+	if (!item) {
+		rcu_read_unlock();
+		err = -ENOENT;
+		goto err_out;
+	}
+
+	mlx5_fc_query_cached_raw(item->counter,
+				 &bytes, &pkts, &lastused);
+
+	flow_stats_update(&fl_act->stats,
+			  bytes - item->lastbytes,
+			  pkts - item->lastpackets,
+			  0, lastused, FLOW_ACTION_HW_STATS_DELAYED);
+
+	item->lastpackets = pkts;
+	item->lastbytes = bytes;
+	rcu_read_unlock();
+
+	return 0;
+
+err_out:
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h
index 4929301a5260..002292c2567c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h
@@ -20,4 +20,8 @@
 mlx5e_tc_act_stats_del_flow(struct mlx5e_tc_act_stats_handle *handle,
 			    struct mlx5e_tc_flow *flow);
 
+int
+mlx5e_tc_act_stats_fill_stats(struct mlx5e_tc_act_stats_handle *handle,
+			      struct flow_offload_action *fl_act);
+
 #endif /* __MLX5_EN_ACT_STATS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index f575646d2f50..451fd4342a5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -30,6 +30,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_TUN_RX                = MLX5E_TC_FLOW_BASE + 9,
 	MLX5E_TC_FLOW_FLAG_FAILED                = MLX5E_TC_FLOW_BASE + 10,
 	MLX5E_TC_FLOW_FLAG_SAMPLE                = MLX5E_TC_FLOW_BASE + 11,
+	MLX5E_TC_FLOW_FLAG_USE_ACT_STATS	 = MLX5E_TC_FLOW_BASE + 12,
 };
 
 struct mlx5e_tc_flow_parse_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index ec5d1fbae22e..50432c9d78c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4128,6 +4128,7 @@ struct mlx5_flow_attr *
 
 	/* branching action requires its own counter */
 	attr->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	flow_flag_set(flow, USE_ACT_STATS);
 
 	return 0;
 
@@ -4978,6 +4979,12 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	return err;
 }
 
+int mlx5e_tc_fill_action_stats(struct mlx5e_priv *priv,
+			       struct flow_offload_action *fl_act)
+{
+	return mlx5e_tc_act_stats_fill_stats(get_act_stats_handle(priv), fl_act);
+}
+
 int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 		       struct flow_cls_offload *f, unsigned long flags)
 {
@@ -5004,11 +5011,15 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	}
 
 	if (mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, CT)) {
-		counter = mlx5e_tc_get_counter(flow);
-		if (!counter)
-			goto errout;
+		if (flow_flag_test(flow, USE_ACT_STATS)) {
+			f->use_act_stats = true;
+		} else {
+			counter = mlx5e_tc_get_counter(flow);
+			if (!counter)
+				goto errout;
 
-		mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
+			mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
+		}
 	}
 
 	/* Under multipath it's possible for one rule to be currently
@@ -5024,14 +5035,18 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 		u64 packets2;
 		u64 lastuse2;
 
-		counter = mlx5e_tc_get_counter(flow->peer_flow);
-		if (!counter)
-			goto no_peer_counter;
-		mlx5_fc_query_cached(counter, &bytes2, &packets2, &lastuse2);
-
-		bytes += bytes2;
-		packets += packets2;
-		lastuse = max_t(u64, lastuse, lastuse2);
+		if (flow_flag_test(flow, USE_ACT_STATS)) {
+			f->use_act_stats = true;
+		} else {
+			counter = mlx5e_tc_get_counter(flow->peer_flow);
+			if (!counter)
+				goto no_peer_counter;
+			mlx5_fc_query_cached(counter, &bytes2, &packets2, &lastuse2);
+
+			bytes += bytes2;
+			packets += packets2;
+			lastuse = max_t(u64, lastuse, lastuse2);
+		}
 	}
 
 no_peer_counter:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 8aa25d8bac86..a54f26dcd23a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -199,6 +199,8 @@ int mlx5e_delete_flower(struct net_device *dev, struct mlx5e_priv *priv,
 
 int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 		       struct flow_cls_offload *f, unsigned long flags);
+int mlx5e_tc_fill_action_stats(struct mlx5e_priv *priv,
+			       struct flow_offload_action *fl_act);
 
 int mlx5e_tc_configure_matchall(struct mlx5e_priv *priv,
 				struct tc_cls_matchall_offload *f);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index b406e0367af6..17fe30a4c06c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -504,6 +504,16 @@ void mlx5_fc_query_cached(struct mlx5_fc *counter,
 	counter->lastpackets = c.packets;
 }
 
+void mlx5_fc_query_cached_raw(struct mlx5_fc *counter,
+			      u64 *bytes, u64 *packets, u64 *lastuse)
+{
+	struct mlx5_fc_cache c = counter->cache;
+
+	*bytes = c.bytes;
+	*packets = c.packets;
+	*lastuse = c.lastuse;
+}
+
 void mlx5_fc_queue_stats_work(struct mlx5_core_dev *dev,
 			      struct delayed_work *dwork,
 			      unsigned long delay)
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index ba6958b49a8e..90a2fe5839fa 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -296,6 +296,8 @@ int mlx5_modify_rule_destination(struct mlx5_flow_handle *handler,
 u64 mlx5_fc_query_lastuse(struct mlx5_fc *counter);
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
 			  u64 *bytes, u64 *packets, u64 *lastuse);
+void mlx5_fc_query_cached_raw(struct mlx5_fc *counter,
+			      u64 *bytes, u64 *packets, u64 *lastuse);
 int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
 		  u64 *packets, u64 *bytes);
 u32 mlx5_fc_id(struct mlx5_fc *counter);
-- 
1.8.3.1

