Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8788CCBE
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 09:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbfHNH2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 03:28:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:57242 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfHNH2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 03:28:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 00:28:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,384,1559545200"; 
   d="scan'208";a="327922995"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.52.109])
  by orsmga004.jf.intel.com with ESMTP; 14 Aug 2019 00:27:57 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com,
        maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, jonathan.lemon@gmail.com,
        kiran.patil@intel.com, axboe@kernel.dk,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v4 1/8] xsk: replace ndo_xsk_async_xmit with ndo_xsk_wakeup
Date:   Wed, 14 Aug 2019 09:27:16 +0200
Message-Id: <1565767643-4908-2-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit replaces ndo_xsk_async_xmit with ndo_xsk_wakeup. This new
ndo provides the same functionality as before but with the addition of
a new flags field that is used to specifiy if Rx, Tx or both should be
woken up. The previous ndo only woke up Tx, as implied by the
name. The i40e and ixgbe drivers (which are all the supported ones)
are updated with this new interface.

This new ndo will be used by the new need_wakeup functionality of XDP
sockets that need to be able to wake up both Rx and Tx driver
processing.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c          |  5 +++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.c           |  7 ++++---
 drivers/net/ethernet/intel/i40e/i40e_xsk.h           |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c        |  5 +++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c         |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  2 +-
 include/linux/netdevice.h                            | 14 ++++++++++++--
 net/xdp/xdp_umem.c                                   |  3 +--
 net/xdp/xsk.c                                        |  3 ++-
 12 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6d456e5..a75c66c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12570,7 +12570,8 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
 	if (need_reset && prog)
 		for (i = 0; i < vsi->num_queue_pairs; i++)
 			if (vsi->xdp_rings[i]->xsk_umem)
-				(void)i40e_xsk_async_xmit(vsi->netdev, i);
+				(void)i40e_xsk_wakeup(vsi->netdev, i,
+						      XDP_WAKEUP_RX);
 
 	return 0;
 }
@@ -12892,7 +12893,7 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_bridge_setlink	= i40e_ndo_bridge_setlink,
 	.ndo_bpf		= i40e_xdp,
 	.ndo_xdp_xmit		= i40e_xdp_xmit,
-	.ndo_xsk_async_xmit	= i40e_xsk_async_xmit,
+	.ndo_xsk_wakeup	        = i40e_xsk_wakeup,
 	.ndo_dfwd_add_station	= i40e_fwd_add,
 	.ndo_dfwd_del_station	= i40e_fwd_del,
 };
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 32bad01..d0ff5d8 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -116,7 +116,7 @@ static int i40e_xsk_umem_enable(struct i40e_vsi *vsi, struct xdp_umem *umem,
 			return err;
 
 		/* Kick start the NAPI context so that receiving will start */
-		err = i40e_xsk_async_xmit(vsi->netdev, qid);
+		err = i40e_xsk_wakeup(vsi->netdev, qid, XDP_WAKEUP_RX);
 		if (err)
 			return err;
 	}
@@ -765,13 +765,14 @@ bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi,
 }
 
 /**
- * i40e_xsk_async_xmit - Implements the ndo_xsk_async_xmit
+ * i40e_xsk_wakeup - Implements the ndo_xsk_wakeup
  * @dev: the netdevice
  * @queue_id: queue id to wake up
+ * @flags: ignored in our case since we have Rx and Tx in the same NAPI.
  *
  * Returns <0 for errors, 0 otherwise.
  **/
-int i40e_xsk_async_xmit(struct net_device *dev, u32 queue_id)
+int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags)
 {
 	struct i40e_netdev_priv *np = netdev_priv(dev);
 	struct i40e_vsi *vsi = np->vsi;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
index 8cc0a2e..9ed59c1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
@@ -18,6 +18,6 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget);
 
 bool i40e_clean_xdp_tx_irq(struct i40e_vsi *vsi,
 			   struct i40e_ring *tx_ring, int napi_budget);
-int i40e_xsk_async_xmit(struct net_device *dev, u32 queue_id);
+int i40e_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags);
 
 #endif /* _I40E_XSK_H_ */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index dc7b128..05729b4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10263,7 +10263,8 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 	if (need_reset && prog)
 		for (i = 0; i < adapter->num_rx_queues; i++)
 			if (adapter->xdp_ring[i]->xsk_umem)
-				(void)ixgbe_xsk_async_xmit(adapter->netdev, i);
+				(void)ixgbe_xsk_wakeup(adapter->netdev, i,
+						       XDP_WAKEUP_RX);
 
 	return 0;
 }
@@ -10382,7 +10383,7 @@ static const struct net_device_ops ixgbe_netdev_ops = {
 	.ndo_features_check	= ixgbe_features_check,
 	.ndo_bpf		= ixgbe_xdp,
 	.ndo_xdp_xmit		= ixgbe_xdp_xmit,
-	.ndo_xsk_async_xmit	= ixgbe_xsk_async_xmit,
+	.ndo_xsk_wakeup         = ixgbe_xsk_wakeup,
 };
 
 static void ixgbe_disable_txr_hw(struct ixgbe_adapter *adapter,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
index d93a690..6d01700 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
@@ -42,7 +42,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
 void ixgbe_xsk_clean_rx_ring(struct ixgbe_ring *rx_ring);
 bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 			    struct ixgbe_ring *tx_ring, int napi_budget);
-int ixgbe_xsk_async_xmit(struct net_device *dev, u32 queue_id);
+int ixgbe_xsk_wakeup(struct net_device *dev, u32 queue_id, u32 flags);
 void ixgbe_xsk_clean_tx_ring(struct ixgbe_ring *tx_ring);
 
 #endif /* #define _IXGBE_TXRX_COMMON_H_ */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 6b60955..e598af9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -100,7 +100,7 @@ static int ixgbe_xsk_umem_enable(struct ixgbe_adapter *adapter,
 		ixgbe_txrx_ring_enable(adapter, qid);
 
 		/* Kick start the NAPI context so that receiving will start */
-		err = ixgbe_xsk_async_xmit(adapter->netdev, qid);
+		err = ixgbe_xsk_wakeup(adapter->netdev, qid, XDP_WAKEUP_RX);
 		if (err)
 			return err;
 	}
@@ -692,7 +692,7 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 	return budget > 0 && xmit_done;
 }
 
-int ixgbe_xsk_async_xmit(struct net_device *dev, u32 qid)
+int ixgbe_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(dev);
 	struct ixgbe_ring *ring;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 35e188cf..9704634 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -7,7 +7,7 @@
 #include "en/params.h"
 #include <net/xdp_sock.h>
 
-int mlx5e_xsk_async_xmit(struct net_device *dev, u32 qid)
+int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_params *params = &priv->channels.params;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
index 7add18b..9c50515 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h
@@ -8,7 +8,7 @@
 
 /* TX data path */
 
-int mlx5e_xsk_async_xmit(struct net_device *dev, u32 qid);
+int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags);
 
 bool mlx5e_xsk_tx(struct mlx5e_xdpsq *sq, unsigned int budget);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 9a2fcef..9df7e5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4540,7 +4540,7 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_tx_timeout          = mlx5e_tx_timeout,
 	.ndo_bpf		 = mlx5e_xdp,
 	.ndo_xdp_xmit            = mlx5e_xdp_xmit,
-	.ndo_xsk_async_xmit      = mlx5e_xsk_async_xmit,
+	.ndo_xsk_wakeup          = mlx5e_xsk_wakeup,
 #ifdef CONFIG_MLX5_EN_ARFS
 	.ndo_rx_flow_steer	 = mlx5e_rx_flow_steer,
 #endif
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 55ac223..0ef0570 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -901,6 +901,10 @@ struct netdev_bpf {
 	};
 };
 
+/* Flags for ndo_xsk_wakeup. */
+#define XDP_WAKEUP_RX (1 << 0)
+#define XDP_WAKEUP_TX (1 << 1)
+
 #ifdef CONFIG_XFRM_OFFLOAD
 struct xfrmdev_ops {
 	int	(*xdo_dev_state_add) (struct xfrm_state *x);
@@ -1227,6 +1231,12 @@ struct tlsdev_ops;
  *	that got dropped are freed/returned via xdp_return_frame().
  *	Returns negative number, means general error invoking ndo, meaning
  *	no frames were xmit'ed and core-caller will free all frames.
+ * int (*ndo_xsk_wakeup)(struct net_device *dev, u32 queue_id, u32 flags);
+ *      This function is used to wake up the softirq, ksoftirqd or kthread
+ *	responsible for sending and/or receiving packets on a specific
+ *	queue id bound to an AF_XDP socket. The flags field specifies if
+ *	only RX, only Tx, or both should be woken up using the flags
+ *	XDP_WAKEUP_RX and XDP_WAKEUP_TX.
  * struct devlink_port *(*ndo_get_devlink_port)(struct net_device *dev);
  *	Get devlink port instance associated with a given netdev.
  *	Called with a reference on the netdevice and devlink locks only,
@@ -1426,8 +1436,8 @@ struct net_device_ops {
 	int			(*ndo_xdp_xmit)(struct net_device *dev, int n,
 						struct xdp_frame **xdp,
 						u32 flags);
-	int			(*ndo_xsk_async_xmit)(struct net_device *dev,
-						      u32 queue_id);
+	int			(*ndo_xsk_wakeup)(struct net_device *dev,
+						  u32 queue_id, u32 flags);
 	struct devlink_port *	(*ndo_get_devlink_port)(struct net_device *dev);
 };
 
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index a060796..6e2d4da 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -112,8 +112,7 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 		/* For copy-mode, we are done. */
 		return 0;
 
-	if (!dev->netdev_ops->ndo_bpf ||
-	    !dev->netdev_ops->ndo_xsk_async_xmit) {
+	if (!dev->netdev_ops->ndo_bpf || !dev->netdev_ops->ndo_xsk_wakeup) {
 		err = -EOPNOTSUPP;
 		goto err_unreg_umem;
 	}
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 59b57d7..1fe40a9 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -212,7 +212,8 @@ static int xsk_zc_xmit(struct sock *sk)
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct net_device *dev = xs->dev;
 
-	return dev->netdev_ops->ndo_xsk_async_xmit(dev, xs->queue_id);
+	return dev->netdev_ops->ndo_xsk_wakeup(dev, xs->queue_id,
+					       XDP_WAKEUP_TX);
 }
 
 static void xsk_destruct_skb(struct sk_buff *skb)
-- 
2.7.4

