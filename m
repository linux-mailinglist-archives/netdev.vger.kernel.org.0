Return-Path: <netdev+bounces-10521-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2BCD72ED4C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8254280FA8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AEB623D54;
	Tue, 13 Jun 2023 20:50:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158E5136A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 20:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DDEC433C0;
	Tue, 13 Jun 2023 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686689411;
	bh=xhD3KsDenC2acGYDfepb2r9sH74k5NXsBZ5Y5v+InHw=;
	h=From:To:Cc:Subject:Date:From;
	b=H2jLraoJ1XAlVcFkdHMOHsjldusi7Zd8q81A3PQLTZsirNIxTahgUfTAgk5ZfvNtT
	 bSOEyfDwp3uFn4pfsmkcygsrsOCTM2zJKo7ob0RBjMrnOMGZT9Q731HCJUgxAtNZm1
	 JaO4TI81Pbzc9u5KsFonpDch7/VDxu35PWt6JxMUVuHaa3Y5PeXSefeDo+6wGmSh2d
	 9bRRu/xOTsNOngT0yl/w8Phib5V6wuh+RH7JXM12ING58uPu34/ZaZggzGzwrJm0hc
	 vQyDpJK9B9glvi+YDlHbMjZMlgIPdhWIbhh+xWLqP6PU0Bp1w0+CsgFsM/P6B9UPkG
	 GwkqjfAU7GBkw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	j.vosburgh@gmail.com,
	andy@greyhouse.net,
	rajur@chelsio.com,
	ayush.sawal@chelsio.com,
	dmichail@fungible.com,
	borisp@nvidia.com,
	saeedm@nvidia.com,
	leon@kernel.org,
	simon.horman@corigine.com,
	john.fastabend@gmail.com,
	anirudh.venkataramanan@intel.com,
	maxtram95@gmail.com,
	tariqt@nvidia.com,
	gal@nvidia.com,
	raeds@nvidia.com,
	liorna@nvidia.com,
	louis.peens@corigine.com,
	yinjun.zhang@corigine.com,
	na.wang@corigine.com,
	linux-rdma@vger.kernel.org,
	oss-drivers@corigine.com
Subject: [PATCH net-next] net: tls: make the offload check helper take skb not socket
Date: Tue, 13 Jun 2023 13:50:06 -0700
Message-Id: <20230613205006.1995873-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All callers of tls_is_sk_tx_device_offloaded() currently do
an equivalent of:

 if (skb->sk && tls_is_skb_tx_device_offloaded(skb->sk))

Have the helper accept skb and do the skb->sk check locally.
Two drivers have local static inlines with similar wrappers
already.

While at it change the ifdef condition to TLS_DEVICE.
Only TLS_DEVICE selects SOCK_VALIDATE_XMIT, so the two are
equivalent. This makes removing the duplicated IS_ENABLED()
check in funeth more obviously correct.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: j.vosburgh@gmail.com
CC: andy@greyhouse.net
CC: rajur@chelsio.com
CC: ayush.sawal@chelsio.com
CC: dmichail@fungible.com
CC: borisp@nvidia.com
CC: saeedm@nvidia.com
CC: leon@kernel.org
CC: simon.horman@corigine.com
CC: john.fastabend@gmail.com
CC: anirudh.venkataramanan@intel.com
CC: maxtram95@gmail.com
CC: tariqt@nvidia.com
CC: gal@nvidia.com
CC: raeds@nvidia.com
CC: liorna@nvidia.com
CC: louis.peens@corigine.com
CC: yinjun.zhang@corigine.com
CC: na.wang@corigine.com
CC: linux-rdma@vger.kernel.org
CC: oss-drivers@corigine.com
---
 drivers/net/bonding/bond_main.c                           | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c           | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h            | 5 -----
 drivers/net/ethernet/chelsio/cxgb4/sge.c                  | 2 +-
 .../ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c    | 2 +-
 drivers/net/ethernet/fungible/funeth/funeth_tx.c          | 3 +--
 .../net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h   | 2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c    | 2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h  | 5 -----
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c       | 4 ++--
 include/net/tls.h                                         | 8 +++++---
 net/tls/tls_device.c                                      | 4 ++--
 12 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 007cec23a92f..16405b84dc2f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5442,7 +5442,7 @@ static netdev_tx_t bond_tls_device_xmit(struct bonding *bond, struct sk_buff *sk
 {
 	struct net_device *tls_netdev = rcu_dereference(tls_get_ctx(skb->sk)->netdev);
 
-	/* tls_netdev might become NULL, even if tls_is_sk_tx_device_offloaded
+	/* tls_netdev might become NULL, even if tls_is_skb_tx_device_offloaded
 	 * was true, if tls_device_down is running in parallel, but it's OK,
 	 * because bond_get_slave_by_dev has a NULL check.
 	 */
@@ -5461,7 +5461,7 @@ static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev
 		return NETDEV_TX_OK;
 
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
-	if (skb->sk && tls_is_sk_tx_device_offloaded(skb->sk))
+	if (tls_is_skb_tx_device_offloaded(skb))
 		return bond_tls_device_xmit(bond, skb, dev);
 #endif
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index f0bc7396ce2b..2eb33a727bba 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1175,7 +1175,7 @@ static u16 cxgb_select_queue(struct net_device *dev, struct sk_buff *skb,
 		txq = netdev_pick_tx(dev, skb, sb_dev);
 		if (xfrm_offload(skb) || is_ptp_enabled(skb, dev) ||
 		    skb->encapsulation ||
-		    cxgb4_is_ktls_skb(skb) ||
+		    tls_is_skb_tx_device_offloaded(skb) ||
 		    (proto != IPPROTO_TCP && proto != IPPROTO_UDP))
 			txq = txq % pi->nqsets;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 34546f5312ee..a9599ba26975 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -497,11 +497,6 @@ struct cxgb4_uld_info {
 #endif
 };
 
-static inline bool cxgb4_is_ktls_skb(struct sk_buff *skb)
-{
-	return skb->sk && tls_is_sk_tx_device_offloaded(skb->sk);
-}
-
 void cxgb4_uld_enable(struct adapter *adap);
 void cxgb4_register_uld(enum cxgb4_uld type, const struct cxgb4_uld_info *p);
 int cxgb4_unregister_uld(enum cxgb4_uld type);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 46809e2d94ee..98dd78551d89 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1530,7 +1530,7 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 #endif /* CHELSIO_IPSEC_INLINE */
 
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
-	if (cxgb4_is_ktls_skb(skb) &&
+	if (tls_is_skb_tx_device_offloaded(skb) &&
 	    (skb->len - skb_tcp_all_headers(skb)))
 		return adap->uld[CXGB4_ULD_KTLS].tx_handler(skb, dev);
 #endif /* CHELSIO_TLS_DEVICE */
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 1a5fdd755e9e..bcdc7fc2f427 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1946,7 +1946,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	tls_ctx = tls_get_ctx(skb->sk);
 	tls_netdev = rcu_dereference_bh(tls_ctx->netdev);
 	/* Don't quit on NULL: if tls_device_down is running in parallel,
-	 * netdev might become NULL, even if tls_is_sk_tx_device_offloaded was
+	 * netdev might become NULL, even if tls_is_skb_tx_device_offloaded was
 	 * true. Rather continue processing this packet.
 	 */
 	if (unlikely(tls_netdev && tls_netdev != dev))
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
index 706d81e39a54..8ddefd3ec15b 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -348,8 +348,7 @@ netdev_tx_t fun_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 	unsigned int tls_len = 0;
 	unsigned int ndesc;
 
-	if (IS_ENABLED(CONFIG_TLS_DEVICE) && skb->sk &&
-	    tls_is_sk_tx_device_offloaded(skb->sk)) {
+	if (tls_is_skb_tx_device_offloaded(skb)) {
 		skb = fun_tls_tx(skb, q, &tls_len);
 		if (unlikely(!skb))
 			goto dropped;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index c964644ee866..bac4717548c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -125,7 +125,7 @@ static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
 
 #ifdef CONFIG_MLX5_EN_TLS
 	/* May send WQEs. */
-	if (mlx5e_ktls_skb_offloaded(skb))
+	if (tls_is_skb_tx_device_offloaded(skb))
 		if (unlikely(!mlx5e_ktls_handle_tx_skb(dev, sq, skb,
 						       &state->tls)))
 			return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 0e4c0a093293..efb2cf74ad6a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -846,7 +846,7 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	tls_ctx = tls_get_ctx(skb->sk);
 	tls_netdev = rcu_dereference_bh(tls_ctx->netdev);
 	/* Don't WARN on NULL: if tls_device_down is running in parallel,
-	 * netdev might become NULL, even if tls_is_sk_tx_device_offloaded was
+	 * netdev might become NULL, even if tls_is_skb_tx_device_offloaded was
 	 * true. Rather continue processing this packet.
 	 */
 	if (WARN_ON_ONCE(tls_netdev && tls_netdev != netdev))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index 2dd78dd4ad65..f87b65c560ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -49,11 +49,6 @@ mlx5e_ktls_rx_pending_resync_list(struct mlx5e_channel *c, int budget)
 	return budget && test_bit(MLX5E_SQ_STATE_PENDING_TLS_RX_RESYNC, &c->async_icosq.state);
 }
 
-static inline bool mlx5e_ktls_skb_offloaded(struct sk_buff *skb)
-{
-	return skb->sk && tls_is_sk_tx_device_offloaded(skb->sk);
-}
-
 static inline void
 mlx5e_ktls_handle_tx_wqe(struct mlx5_wqe_ctrl_seg *cseg,
 			 struct mlx5e_accel_tx_tls_state *state)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b7cce746b5c0..49f2f081ebb5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -598,7 +598,7 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 
 	if (likely(!dp->ktls_tx))
 		return skb;
-	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
+	if (!tls_is_skb_tx_device_offloaded(skb))
 		return skb;
 
 	datalen = skb->len - skb_tcp_all_headers(skb);
@@ -666,7 +666,7 @@ void nfp_net_tls_tx_undo(struct sk_buff *skb, u64 tls_handle)
 
 	if (!tls_handle)
 		return;
-	if (WARN_ON_ONCE(!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk)))
+	if (WARN_ON_ONCE(!tls_is_skb_tx_device_offloaded(skb)))
 		return;
 
 	datalen = skb->len - skb_tcp_all_headers(skb);
diff --git a/include/net/tls.h b/include/net/tls.h
index b7d0f1e3058b..5e71dd3df8ca 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -370,10 +370,12 @@ struct sk_buff *
 tls_validate_xmit_skb_sw(struct sock *sk, struct net_device *dev,
 			 struct sk_buff *skb);
 
-static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
+static inline bool tls_is_skb_tx_device_offloaded(const struct sk_buff *skb)
 {
-#ifdef CONFIG_SOCK_VALIDATE_XMIT
-	return sk_fullsock(sk) &&
+#ifdef CONFIG_TLS_DEVICE
+	struct sock *sk = skb->sk;
+
+	return sk && sk_fullsock(sk) &&
 	       (smp_load_acquire(&sk->sk_validate_xmit_skb) ==
 	       &tls_validate_xmit_skb);
 #else
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b4864d55900f..b82770f68807 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1219,7 +1219,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	tls_device_attach(ctx, sk, netdev);
 	up_read(&device_offload_lock);
 
-	/* following this assignment tls_is_sk_tx_device_offloaded
+	/* following this assignment tls_is_skb_tx_device_offloaded
 	 * will return true and the context might be accessed
 	 * by the netdev's xmit function.
 	 */
@@ -1372,7 +1372,7 @@ static int tls_device_down(struct net_device *netdev)
 
 	list_for_each_entry_safe(ctx, tmp, &list, list)	{
 		/* Stop offloaded TX and switch to the fallback.
-		 * tls_is_sk_tx_device_offloaded will return false.
+		 * tls_is_skb_tx_device_offloaded will return false.
 		 */
 		WRITE_ONCE(ctx->sk->sk_validate_xmit_skb, tls_validate_xmit_skb_sw);
 
-- 
2.40.1


