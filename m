Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0733B22F72C
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731529AbgG0R6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:32784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729686AbgG0R6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 13:58:05 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E29820714;
        Mon, 27 Jul 2020 17:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595872684;
        bh=CA4nKbNPAW8fMZ9ZLQytkTZcWotgaZypXd7jV3UWu4k=;
        h=Date:From:To:Cc:Subject:From;
        b=JMuv/vD+0Ef5m4HgdJexhqp7LsShRNCoYmvZMz6RY00aO4TTHgzsIdBHBYygfaux8
         6BTDFRJMZY7fzX7bxUBOEmz+stqYlzs6N5HllYk4NA5ZDbX/TFaIaT7yhb23uOK3ox
         1hEXbQxo9dWCIdcHZCXSLNlGXUatE/XVy70MBVsQ=
Date:   Mon, 27 Jul 2020 13:03:56 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] net/mlx5: Use fallthrough pseudo-keyword
Message-ID: <20200727180356.GA26612@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
fall-through markings when it is the case.

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h         | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c          | 4 ++--
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c      | 2 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c       | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c          | 8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/vport.c           | 2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index cf425a60cddc..5067bbdfc284 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -360,7 +360,7 @@ mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
 	switch (swp_spec->tun_l4_proto) {
 	case IPPROTO_UDP:
 		eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
-		/* fall through */
+		fallthrough;
 	case IPPROTO_TCP:
 		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index e0c1b010d41a..e5b276489cf3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -153,11 +153,11 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		return true;
 	default:
 		bpf_warn_invalid_xdp_action(act);
-		/* fall through */
+		fallthrough;
 	case XDP_ABORTED:
 xdp_abort:
 		trace_xdp_exception(rq->netdev, prog, act);
-		/* fall through */
+		fallthrough;
 	case XDP_DROP:
 		rq->stats->xdp_drop++;
 		return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 0e6698d1b4ca..f4861545b236 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -470,7 +470,7 @@ bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_txqsq *s
 			if (likely(!skb->decrypted))
 				goto out;
 			WARN_ON_ONCE(1);
-			/* fall-through */
+			fallthrough;
 		case MLX5E_KTLS_SYNC_FAIL:
 			goto err_out;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index af849bc83c30..08270987c506 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -243,7 +243,7 @@ int mlx5e_ethtool_get_sset_count(struct mlx5e_priv *priv, int sset)
 		return MLX5E_NUM_PFLAGS;
 	case ETH_SS_TEST:
 		return mlx5e_self_test_num(priv);
-	/* fallthrough */
+		fallthrough;
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index db856d70c4f8..5748ebb437e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2353,7 +2353,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	case MLX5_CAP_INLINE_MODE_NOT_REQUIRED:
 		if (mode == DEVLINK_ESWITCH_INLINE_MODE_NONE)
 			goto out;
-		/* fall through */
+		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		NL_SET_ERR_MSG_MOD(extack, "Inline mode can't be set");
 		err = -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 182d3ac3e73f..831d2c39e153 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -339,14 +339,14 @@ static void mlx5_fpga_conn_handle_cqe(struct mlx5_fpga_conn *conn,
 	switch (opcode) {
 	case MLX5_CQE_REQ_ERR:
 		status = ((struct mlx5_err_cqe *)cqe)->syndrome;
-		/* Fall through */
+		fallthrough;
 	case MLX5_CQE_REQ:
 		mlx5_fpga_conn_sq_cqe(conn, cqe, status);
 		break;
 
 	case MLX5_CQE_RESP_ERR:
 		status = ((struct mlx5_err_cqe *)cqe)->syndrome;
-		/* Fall through */
+		fallthrough;
 	case MLX5_CQE_RESP_SEND:
 		mlx5_fpga_conn_rq_cqe(conn, cqe, status);
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index e9089a793632..9e68f5926ab6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -198,13 +198,13 @@ static void mlx5_lag_fib_update(struct work_struct *work)
 	/* Protect internal structures from changes */
 	rtnl_lock();
 	switch (fib_work->event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		mlx5_lag_fib_route_event(ldev, fib_work->event,
 					 fib_work->fen_info.fi);
 		fib_info_put(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_NH_ADD: /* fall through */
+	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
 		fib_nh = fib_work->fnh_info.fib_nh;
 		mlx5_lag_fib_nexthop_event(ldev,
@@ -255,7 +255,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		return NOTIFY_DONE;
 
 	switch (event) {
-	case FIB_EVENT_ENTRY_REPLACE: /* fall through */
+	case FIB_EVENT_ENTRY_REPLACE:
 	case FIB_EVENT_ENTRY_DEL:
 		fen_info = container_of(info, struct fib_entry_notifier_info,
 					info);
@@ -278,7 +278,7 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 		 */
 		fib_info_hold(fib_work->fen_info.fi);
 		break;
-	case FIB_EVENT_NH_ADD: /* fall through */
+	case FIB_EVENT_NH_ADD:
 	case FIB_EVENT_NH_DEL:
 		fnh_info = container_of(info, struct fib_nh_notifier_info,
 					info);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 88cdb9bb4c4a..bdafc85fd874 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -110,7 +110,7 @@ void mlx5_query_min_inline(struct mlx5_core_dev *mdev,
 	case MLX5_CAP_INLINE_MODE_VPORT_CONTEXT:
 		if (!mlx5_query_nic_vport_min_inline(mdev, 0, min_inline_mode))
 			break;
-		/* fall through */
+		fallthrough;
 	case MLX5_CAP_INLINE_MODE_L2:
 		*min_inline_mode = MLX5_INLINE_MODE_L2;
 		break;
-- 
2.27.0

