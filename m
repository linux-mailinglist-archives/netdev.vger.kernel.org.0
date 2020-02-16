Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C83CE16034B
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgBPKBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:01:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44768 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726116AbgBPKBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:43 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:39 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1ce6007834;
        Sun, 16 Feb 2020 12:01:39 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next-mlx5 v3 10/16] net/mlx5: E-Switch, Restore chain id on miss
Date:   Sun, 16 Feb 2020 12:01:30 +0200
Message-Id: <1581847296-19194-11-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chain ids are mapped to the lower part of reg C, and after loopback
are copied to to CQE via a restore rule's flow_tag.

To let tc continue in the correct chain, we find the corresponding
chain id in the eswitch chain id <-> reg C mapping, and set the SKB's
tc extension chain to it.

That tells tc to continue processing from this set chain.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |  6 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 43 +++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h |  2 ++
 3 files changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 454ce4c..e0abe79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1225,6 +1225,9 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (rep->vlan && skb_vlan_tag_present(skb))
 		skb_vlan_pop(skb);
 
+	if (!mlx5e_tc_rep_update_skb(cqe, skb))
+		goto free_wqe;
+
 	napi_gro_receive(rq->cq.napi, skb);
 
 free_wqe:
@@ -1275,6 +1278,9 @@ void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq,
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
+	if (!mlx5e_tc_rep_update_skb(cqe, skb))
+		goto mpwrq_cqe_out;
+
 	napi_gro_receive(rq->cq.napi, skb);
 
 mpwrq_cqe_out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2ee80f0..ac1ecf8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4339,3 +4339,46 @@ void mlx5e_tc_reoffload_flows_work(struct work_struct *work)
 	}
 	mutex_unlock(&rpriv->unready_flows_lock);
 }
+
+bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
+			     struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	struct tc_skb_ext *tc_skb_ext;
+	struct mlx5_eswitch *esw;
+	struct mlx5e_priv *priv;
+	u32 chain = 0, reg_c0;
+	int err;
+
+	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
+	if (reg_c0 == MLX5_FS_DEFAULT_FLOW_TAG)
+		reg_c0 = 0;
+
+	if (!reg_c0)
+		return true;
+
+	priv = netdev_priv(skb->dev);
+	esw = priv->mdev->priv.eswitch;
+
+	err = mlx5_eswitch_get_chain_for_tag(esw, reg_c0, &chain);
+	if (err) {
+		netdev_dbg(priv->netdev,
+			   "Couldn't find chain for chain tag: %d, err: %d\n",
+			   reg_c0, err);
+		return false;
+	}
+
+	if (!chain)
+		return true;
+
+	tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
+	if (!tc_skb_ext) {
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
+	tc_skb_ext->chain = chain;
+#endif /* CONFIG_NET_TC_SKB_EXT */
+
+	return true;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index e2dbbae..9d5fcf6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -106,6 +106,8 @@ struct mlx5e_tc_attr_to_reg_mapping {
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev);
 
+bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb);
+
 #else /* CONFIG_MLX5_ESWITCH */
 static inline int  mlx5e_tc_nic_init(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv) {}
-- 
1.8.3.1

