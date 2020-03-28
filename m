Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4F3196715
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 16:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbgC1Phw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 11:37:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36378 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgC1Phw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 11:37:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so15374996wrs.3
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 08:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KBNHEx44xCPQtswLnuwT8tarSkL4hv2VtxZfejh5EBw=;
        b=g9CKwT6zcm9IKSCuAJmgWWIpmQQcOKcy3cSSKzpc9UiZ/W1BjigSHJODcE5h6gqC98
         J4VaasGJrFy/IPAq176b8l79BT/kL0981Hpko/b4WFbBqEjH5D/cRsLrL8VpcC8Xb+d6
         69NNmUtsX8iYbsD9n5BPrdn4cKB+fJnsrd9J7aLbrrLE+PcVCD8QLWlzTtZWLxYL4BZ1
         pcdwl13rrXavHU+aXJdIGpG9E0aHrgHRtGJeybkMI8w6Q4M1PLaeNpLgo9H1r6IVLAzX
         e7DL1BZCggpccSK9QXk38TSdyPbYlyTQcsuRgmQ5qF6cVrOCYkwrXLGccKco3f3ARqb5
         PyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KBNHEx44xCPQtswLnuwT8tarSkL4hv2VtxZfejh5EBw=;
        b=GvU/ez2ale89sC30Z2ShiqKW01EPoQyunVQH8nmrHTnh8U17/xqyqEjXdjY8hbL/rR
         UzVCMzithaDBU2M11L0yNh4/8gN96mXRK8Z2j14bV2RB47g2rQk5jk/y4LD0ytu9tqeK
         Y96Hpznv4kjM6NRxMh3DUc3rMU5XorQGtDvU9eUr+c6maHMgItImhhOGyLjGE7w/ITFa
         4ZIWXikuDrCs1XK008mAotmXmgK/ppo3gcfhzjHLXBYu7SAmGhJmaZYlbBJCPI1nVaVq
         QDsVm74+gVMnJolsUzHfcmXrDqH/9S5WAX4InLwvWUpO75B9Ry/C8WhyNTvBVjhtYZ09
         tIIw==
X-Gm-Message-State: ANhLgQ0u/urvbjE3XJd6sAib5TP2G5tkgLMioIq7THCxBrd4uFHVDQi1
        yC8hNzVz5wFgRI4GVPrbO6K/Uyex6p4=
X-Google-Smtp-Source: ADFU+vuJ/YRCbWct+ijNKUeEI/SssWqXEGOjtQ/L57UCnh9vu9eOZiuF9QinzKj/AVh6b+fLn5enCw==
X-Received: by 2002:adf:fc8a:: with SMTP id g10mr5099068wrr.383.1585409868903;
        Sat, 28 Mar 2020 08:37:48 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w4sm10894498wmc.18.2020.03.28.08.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 08:37:47 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, pablo@netfilter.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, paulb@mellanox.com,
        alexandre.belloni@bootlin.com, ozsh@mellanox.com,
        roid@mellanox.com, john.hurley@netronome.com,
        simon.horman@netronome.com, pieter.jansenvanvuuren@netronome.com
Subject: [patch net-next 2/2] net: sched: expose HW stats types per action used by drivers
Date:   Sat, 28 Mar 2020 16:37:43 +0100
Message-Id: <20200328153743.6363-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200328153743.6363-1-jiri@resnulli.us>
References: <20200328153743.6363-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

It may be up to the driver (in case ANY HW stats is passed) to select
which type of HW stats he is going to use. Add an infrastructure to
expose this information to user.

$ tc filter add dev enp3s0np1 ingress proto ip handle 1 pref 1 flower dst_ip 192.168.1.1 action drop
$ tc -s filter show dev enp3s0np1 ingress
filter protocol ip pref 1 flower chain 0
filter protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  dst_ip 192.168.1.1
  in_hw in_hw_count 2
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 10 sec used 10 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        used_hw_stats immediate     <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c         |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c |  3 ++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c   |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c   |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |  6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h       |  3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c   |  4 +++-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c    |  5 +++--
 drivers/net/ethernet/mscc/ocelot_flower.c            |  3 ++-
 drivers/net/ethernet/netronome/nfp/flower/offload.c  |  3 ++-
 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c |  3 ++-
 include/net/act_api.h                                |  2 ++
 include/net/flow_offload.h                           | 12 +++++++++++-
 include/net/pkt_cls.h                                |  5 ++++-
 include/uapi/linux/pkt_cls.h                         |  1 +
 net/sched/act_api.c                                  |  5 +++++
 net/sched/cls_flower.c                               |  4 +++-
 net/sched/cls_matchall.c                             |  4 +++-
 18 files changed, 54 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index b19be7549aad..782ea0771221 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1639,7 +1639,7 @@ static int bnxt_tc_get_flow_stats(struct bnxt *bp,
 	spin_unlock(&flow->stats_lock);
 
 	flow_stats_update(&tc_flow_cmd->stats, stats.bytes, stats.packets,
-			  lastused);
+			  lastused, FLOW_ACTION_HW_STATS_DELAYED);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index aec9b90313e7..4a5fa9eba0b6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -903,7 +903,8 @@ int cxgb4_tc_flower_stats(struct net_device *dev,
 			ofld_stats->last_used = jiffies;
 		flow_stats_update(&cls->stats, bytes - ofld_stats->byte_count,
 				  packets - ofld_stats->packet_count,
-				  ofld_stats->last_used);
+				  ofld_stats->last_used,
+				  FLOW_ACTION_HW_STATS_IMMEDIATE);
 
 		ofld_stats->packet_count = packets;
 		ofld_stats->byte_count = bytes;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 8a5ae8bc9b7d..c88c47a14fbb 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -346,7 +346,8 @@ int cxgb4_tc_matchall_stats(struct net_device *dev,
 		flow_stats_update(&cls_matchall->stats,
 				  bytes - tc_port_matchall->ingress.bytes,
 				  packets - tc_port_matchall->ingress.packets,
-				  tc_port_matchall->ingress.last_used);
+				  tc_port_matchall->ingress.last_used,
+				  FLOW_ACTION_HW_STATS_IMMEDIATE);
 
 		tc_port_matchall->ingress.packets = packets;
 		tc_port_matchall->ingress.bytes = bytes;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index a22ad6b90847..dca449722ea7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -666,7 +666,8 @@ mlx5_tc_ct_block_flow_offload_stats(struct mlx5_ct_ft *ft,
 		return -ENOENT;
 
 	mlx5_fc_query_cached(entry->counter, &bytes, &packets, &lastuse);
-	flow_stats_update(&f->stats, bytes, packets, lastuse);
+	flow_stats_update(&f->stats, bytes, packets, lastuse,
+			  FLOW_ACTION_HW_STATS_DELAYED);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 901b5fa5568f..efa143874cde 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4468,7 +4468,8 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
 no_peer_counter:
 	mlx5_devcom_release_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
 out:
-	flow_stats_update(&f->stats, bytes, packets, lastuse);
+	flow_stats_update(&f->stats, bytes, packets, lastuse,
+			  FLOW_ACTION_HW_STATS_DELAYED);
 	trace_mlx5e_stats_flower(f);
 errout:
 	mlx5e_flow_put(priv, flow);
@@ -4585,7 +4586,8 @@ void mlx5e_tc_stats_matchall(struct mlx5e_priv *priv,
 	dpkts = cur_stats.rx_packets - rpriv->prev_vf_vport_stats.rx_packets;
 	dbytes = cur_stats.rx_bytes - rpriv->prev_vf_vport_stats.rx_bytes;
 	rpriv->prev_vf_vport_stats = cur_stats;
-	flow_stats_update(&ma->stats, dpkts, dbytes, jiffies);
+	flow_stats_update(&ma->stats, dpkts, dbytes, jiffies,
+			  FLOW_ACTION_HW_STATS_DELAYED);
 }
 
 static void mlx5e_tc_hairpin_update_dead_peer(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 273e373a37b6..9f06f7a5308a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -786,7 +786,8 @@ struct mlxsw_sp_acl_rule_info *
 mlxsw_sp_acl_rule_rulei(struct mlxsw_sp_acl_rule *rule);
 int mlxsw_sp_acl_rule_get_stats(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_acl_rule *rule,
-				u64 *packets, u64 *bytes, u64 *last_use);
+				u64 *packets, u64 *bytes, u64 *last_use,
+				enum flow_action_hw_stats *used_hw_stats);
 
 struct mlxsw_sp_fid *mlxsw_sp_acl_dummy_fid(struct mlxsw_sp *mlxsw_sp);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 6fc1496b9514..67ee880a8727 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -967,7 +967,8 @@ static void mlxsw_sp_acl_rule_activity_update_work(struct work_struct *work)
 
 int mlxsw_sp_acl_rule_get_stats(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_acl_rule *rule,
-				u64 *packets, u64 *bytes, u64 *last_use)
+				u64 *packets, u64 *bytes, u64 *last_use,
+				enum flow_action_hw_stats *used_hw_stats)
 
 {
 	struct mlxsw_sp_acl_rule_info *rulei;
@@ -982,6 +983,7 @@ int mlxsw_sp_acl_rule_get_stats(struct mlxsw_sp *mlxsw_sp,
 						&current_bytes);
 		if (err)
 			return err;
+		*used_hw_stats = FLOW_ACTION_HW_STATS_IMMEDIATE;
 	}
 	*packets = current_packets - rule->last_packets;
 	*bytes = current_bytes - rule->last_bytes;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 33a5e2a0a1ad..2f76908cae73 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -571,6 +571,7 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 			  struct mlxsw_sp_acl_block *block,
 			  struct flow_cls_offload *f)
 {
+	enum flow_action_hw_stats used_hw_stats = FLOW_ACTION_HW_STATS_DISABLED;
 	struct mlxsw_sp_acl_ruleset *ruleset;
 	struct mlxsw_sp_acl_rule *rule;
 	u64 packets;
@@ -589,11 +590,11 @@ int mlxsw_sp_flower_stats(struct mlxsw_sp *mlxsw_sp,
 		return -EINVAL;
 
 	err = mlxsw_sp_acl_rule_get_stats(mlxsw_sp, rule, &packets, &bytes,
-					  &lastuse);
+					  &lastuse, &used_hw_stats);
 	if (err)
 		goto err_rule_get_stats;
 
-	flow_stats_update(&f->stats, bytes, packets, lastuse);
+	flow_stats_update(&f->stats, bytes, packets, lastuse, used_hw_stats);
 
 	mlxsw_sp_acl_ruleset_put(mlxsw_sp, ruleset);
 	return 0;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 873a9944fbfb..829987eb74cb 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -224,7 +224,8 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 	if (ret)
 		return ret;
 
-	flow_stats_update(&f->stats, 0x0, ace.stats.pkts, 0x0);
+	flow_stats_update(&f->stats, 0x0, ace.stats.pkts, 0x0,
+			  FLOW_ACTION_HW_STATS_IMMEDIATE);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_stats);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 7ca5c1becfcf..c694dbc239d0 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1490,7 +1490,8 @@ nfp_flower_get_stats(struct nfp_app *app, struct net_device *netdev,
 		nfp_flower_update_merge_stats(app, nfp_flow);
 
 	flow_stats_update(&flow->stats, priv->stats[ctx_id].bytes,
-			  priv->stats[ctx_id].pkts, priv->stats[ctx_id].used);
+			  priv->stats[ctx_id].pkts, priv->stats[ctx_id].used,
+			  FLOW_ACTION_HW_STATS_DELAYED);
 
 	priv->stats[ctx_id].pkts = 0;
 	priv->stats[ctx_id].bytes = 0;
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 124a43dc136a..d18a830e4264 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -320,7 +320,8 @@ nfp_flower_stats_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 	spin_unlock_bh(&fl_priv->qos_stats_lock);
 
 	flow_stats_update(&flow->stats, diff_bytes, diff_pkts,
-			  repr_priv->qos_table.last_update);
+			  repr_priv->qos_table.last_update,
+			  FLOW_ACTION_HW_STATS_DELAYED);
 	return 0;
 }
 
diff --git a/include/net/act_api.h b/include/net/act_api.h
index ecdec9d6ead0..c24d7643548e 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -42,6 +42,8 @@ struct tc_action {
 	struct tcf_chain	__rcu *goto_chain;
 	u32			tcfa_flags;
 	u8			hw_stats;
+	u8			used_hw_stats;
+	bool			used_hw_stats_valid;
 };
 #define tcf_index	common.tcfa_index
 #define tcf_refcnt	common.tcfa_refcnt
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index ff071eaede17..f66fc6a3020d 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -370,14 +370,24 @@ struct flow_stats {
 	u64	pkts;
 	u64	bytes;
 	u64	lastused;
+	enum flow_action_hw_stats used_hw_stats;
+	bool used_hw_stats_valid;
 };
 
 static inline void flow_stats_update(struct flow_stats *flow_stats,
-				     u64 bytes, u64 pkts, u64 lastused)
+				     u64 bytes, u64 pkts, u64 lastused,
+				     enum flow_action_hw_stats used_hw_stats)
 {
 	flow_stats->pkts	+= pkts;
 	flow_stats->bytes	+= bytes;
 	flow_stats->lastused	= max_t(u64, flow_stats->lastused, lastused);
+
+	/* The driver should pass value with a maximum of one bit set.
+	 * Passing FLOW_ACTION_HW_STATS_ANY is invalid.
+	 */
+	WARN_ON(used_hw_stats == FLOW_ACTION_HW_STATS_ANY);
+	flow_stats->used_hw_stats |= used_hw_stats;
+	flow_stats->used_hw_stats_valid = true;
 }
 
 enum flow_block_command {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 41902e10d503..04aa0649f3b0 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -262,7 +262,8 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
-		      u64 bytes, u64 packets, u64 lastuse)
+		      u64 bytes, u64 packets, u64 lastuse,
+		      u8 used_hw_stats, bool used_hw_stats_valid)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
@@ -273,6 +274,8 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
 		struct tc_action *a = exts->actions[i];
 
 		tcf_action_stats_update(a, bytes, packets, lastuse, true);
+		a->used_hw_stats = used_hw_stats;
+		a->used_hw_stats_valid = used_hw_stats_valid;
 	}
 
 	preempt_enable();
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 6fcf7307e534..9f06d29cab70 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -18,6 +18,7 @@ enum {
 	TCA_ACT_COOKIE,
 	TCA_ACT_FLAGS,
 	TCA_ACT_HW_STATS,
+	TCA_ACT_USED_HW_STATS,
 	__TCA_ACT_MAX
 };
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 33cc77e6e56c..df4560909157 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -794,6 +794,11 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 			       a->hw_stats, TCA_ACT_HW_STATS_ANY))
 		goto nla_put_failure;
 
+	if (a->used_hw_stats_valid &&
+	    nla_put_bitfield32(skb, TCA_ACT_USED_HW_STATS,
+			       a->used_hw_stats, TCA_ACT_HW_STATS_ANY))
+		goto nla_put_failure;
+
 	if (a->tcfa_flags &&
 	    nla_put_bitfield32(skb, TCA_ACT_FLAGS,
 			       a->tcfa_flags, a->tcfa_flags))
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 9b6acd736dc8..74a0febcafb8 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -492,7 +492,9 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 
 	tcf_exts_stats_update(&f->exts, cls_flower.stats.bytes,
 			      cls_flower.stats.pkts,
-			      cls_flower.stats.lastused);
+			      cls_flower.stats.lastused,
+			      cls_flower.stats.used_hw_stats,
+			      cls_flower.stats.used_hw_stats_valid);
 }
 
 static void __fl_put(struct cls_fl_filter *f)
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index a34b36adb9b7..8d39dbcf1746 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -338,7 +338,9 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
 	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
 
 	tcf_exts_stats_update(&head->exts, cls_mall.stats.bytes,
-			      cls_mall.stats.pkts, cls_mall.stats.lastused);
+			      cls_mall.stats.pkts, cls_mall.stats.lastused,
+			      cls_mall.stats.used_hw_stats,
+			      cls_mall.stats.used_hw_stats_valid);
 }
 
 static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
-- 
2.21.1

