Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52C7A16033D
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgBPKBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:01:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44769 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726142AbgBPKBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:43 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:40 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1ceC007834;
        Sun, 16 Feb 2020 12:01:40 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next-mlx5 v3 16/16] net/mlx5e: Restore tunnel metadata on miss
Date:   Sun, 16 Feb 2020 12:01:36 +0200
Message-Id: <1581847296-19194-17-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tunnel and chains setup, we decapsulate the packets on first chain hop,
if we miss on later chains, the packet will comes up without tunnel header,
so it won't be taken by the tunnel device automatically, which fills the
tunnel metadata, and further tc tunnel matches won't work.

On miss, we get the tunnel mapping id, which was set on the chain 0 rule
that decapsulated the packet. This rule matched the tunnel outer
headers. From the tunnel mapping id, we get to this tunnel matches
and restore the equivalent tunnel info metadata dst on the skb.
We also set the skb->dev to the relevant device (tunnel device).
Now further tc processing can be done on the relevant device.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |  10 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 110 ++++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h |   9 +-
 3 files changed, 117 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index e0abe79..135b8a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1193,6 +1193,7 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_rep_priv *rpriv  = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
+	struct mlx5e_tc_update_priv tc_priv = {};
 	struct mlx5_wq_cyc *wq = &rq->wqe.wq;
 	struct mlx5e_wqe_frag_info *wi;
 	struct sk_buff *skb;
@@ -1225,11 +1226,13 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	if (rep->vlan && skb_vlan_tag_present(skb))
 		skb_vlan_pop(skb);
 
-	if (!mlx5e_tc_rep_update_skb(cqe, skb))
+	if (!mlx5e_tc_rep_update_skb(cqe, skb, &tc_priv))
 		goto free_wqe;
 
 	napi_gro_receive(rq->cq.napi, skb);
 
+	mlx5_tc_rep_post_napi_receive(&tc_priv);
+
 free_wqe:
 	mlx5e_free_rx_wqe(rq, wi, true);
 wq_cyc_pop:
@@ -1246,6 +1249,7 @@ void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq,
 	u32 wqe_offset     = stride_ix << rq->mpwqe.log_stride_sz;
 	u32 head_offset    = wqe_offset & (PAGE_SIZE - 1);
 	u32 page_idx       = wqe_offset >> PAGE_SHIFT;
+	struct mlx5e_tc_update_priv tc_priv = {};
 	struct mlx5e_rx_wqe_ll *wqe;
 	struct mlx5_wq_ll *wq;
 	struct sk_buff *skb;
@@ -1278,11 +1282,13 @@ void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq,
 
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
-	if (!mlx5e_tc_rep_update_skb(cqe, skb))
+	if (!mlx5e_tc_rep_update_skb(cqe, skb, &tc_priv))
 		goto mpwrq_cqe_out;
 
 	napi_gro_receive(rq->cq.napi, skb);
 
+	mlx5_tc_rep_post_napi_receive(&tc_priv);
+
 mpwrq_cqe_out:
 	if (likely(wi->consumed_strides < rq->mpwqe.num_strides))
 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 3f1b812..70b5fe2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4635,19 +4635,102 @@ void mlx5e_tc_reoffload_flows_work(struct work_struct *work)
 	mutex_unlock(&rpriv->unready_flows_lock);
 }
 
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
+				 struct mlx5e_tc_update_priv *tc_priv,
+				 u32 tunnel_id)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct flow_dissector_key_enc_opts enc_opts = {};
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct metadata_dst *tun_dst;
+	struct tunnel_match_key key;
+	u32 tun_id, enc_opts_id;
+	struct net_device *dev;
+	int err;
+
+	enc_opts_id = tunnel_id & ENC_OPTS_BITS_MASK;
+	tun_id = tunnel_id >> ENC_OPTS_BITS;
+
+	if (!tun_id)
+		return true;
+
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+
+	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
+	if (err) {
+		WARN_ON_ONCE(true);
+		netdev_dbg(priv->netdev,
+			   "Couldn't find tunnel for tun_id: %d, err: %d\n",
+			   tun_id, err);
+		return false;
+	}
+
+	if (enc_opts_id) {
+		err = mapping_find(uplink_priv->tunnel_enc_opts_mapping,
+				   enc_opts_id, &enc_opts);
+		if (err) {
+			netdev_dbg(priv->netdev,
+				   "Couldn't find tunnel (opts) for tun_id: %d, err: %d\n",
+				   enc_opts_id, err);
+			return false;
+		}
+	}
+
+	tun_dst = tun_rx_dst(enc_opts.len);
+	if (!tun_dst) {
+		WARN_ON_ONCE(true);
+		return false;
+	}
+
+	ip_tunnel_key_init(&tun_dst->u.tun_info.key,
+			   key.enc_ipv4.src, key.enc_ipv4.dst,
+			   key.enc_ip.tos, key.enc_ip.ttl,
+			   0, /* label */
+			   key.enc_tp.src, key.enc_tp.dst,
+			   key32_to_tunnel_id(key.enc_key_id.keyid),
+			   TUNNEL_KEY);
+
+	if (enc_opts.len)
+		ip_tunnel_info_opts_set(&tun_dst->u.tun_info, enc_opts.data,
+					enc_opts.len, enc_opts.dst_opt_type);
+
+	skb_dst_set(skb, (struct dst_entry *)tun_dst);
+	dev = dev_get_by_index(&init_net, key.filter_ifindex);
+	if (!dev) {
+		netdev_dbg(priv->netdev,
+			   "Couldn't find tunnel device with ifindex: %d\n",
+			   key.filter_ifindex);
+		return false;
+	}
+
+	/* Set tun_dev so we do dev_put() after datapath */
+	tc_priv->tun_dev = dev;
+
+	skb->dev = dev;
+
+	return true;
+}
+#endif /* CONFIG_NET_TC_SKB_EXT */
+
 bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
-			     struct sk_buff *skb)
+			     struct sk_buff *skb,
+			     struct mlx5e_tc_update_priv *tc_priv)
 {
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	u32 chain = 0, reg_c0, reg_c1, tunnel_id;
 	struct tc_skb_ext *tc_skb_ext;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
-	u32 chain = 0, reg_c0;
+	int tunnel_moffset;
 	int err;
 
 	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
 	if (reg_c0 == MLX5_FS_DEFAULT_FLOW_TAG)
 		reg_c0 = 0;
+	reg_c1 = be32_to_cpu(cqe->imm_inval_pkey);
 
 	if (!reg_c0)
 		return true;
@@ -4663,17 +4746,26 @@ bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
 		return false;
 	}
 
-	if (!chain)
-		return true;
+	if (chain) {
+		tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
+		if (!tc_skb_ext) {
+			WARN_ON(1);
+			return false;
+		}
 
-	tc_skb_ext = skb_ext_add(skb, TC_SKB_EXT);
-	if (!tc_skb_ext) {
-		WARN_ON_ONCE(1);
-		return false;
+		tc_skb_ext->chain = chain;
 	}
 
-	tc_skb_ext->chain = chain;
+	tunnel_moffset = mlx5e_tc_attr_to_reg_mappings[TUNNEL_TO_REG].moffset;
+	tunnel_id = reg_c1 >> (8 * tunnel_moffset);
+	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
 #endif /* CONFIG_NET_TC_SKB_EXT */
 
 	return true;
 }
+
+void mlx5_tc_rep_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv)
+{
+	if (tc_priv->tun_dev)
+		dev_put(tc_priv->tun_dev);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 2fab76b..21cbde4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -109,7 +109,14 @@ struct mlx5e_tc_attr_to_reg_mapping {
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev);
 
-bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb);
+struct mlx5e_tc_update_priv {
+	struct net_device *tun_dev;
+};
+
+bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb,
+			     struct mlx5e_tc_update_priv *tc_priv);
+
+void mlx5_tc_rep_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv);
 
 struct mlx5e_tc_mod_hdr_acts {
 	int num_actions;
-- 
1.8.3.1

