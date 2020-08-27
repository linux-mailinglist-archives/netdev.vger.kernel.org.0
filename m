Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66C5725511D
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgH0WdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbgH0WdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 18:33:15 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AAAE2087E;
        Thu, 27 Aug 2020 22:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598567593;
        bh=erQnBkkSKdqjbPqqm1tM/+r3/xbs4IaqD6pd5jy/rOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TrGFjPFdwGGdar1vKhurvmFo9b1VJ5+zNEFUH3th1GfrQ7YFNWlbM2OMfvZkdjvNV
         dx/CH6KZTSLzVwuEuJxaOZq6/ZauEpGpWiHjuuQDjtS5IacfN3Hs0A5LojR+EJMu6b
         5gZVZVo4+ezCjEcG4kqc/qbTvrTUt9E/bt0usdqs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     eric.dumazet@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC -next 1/3] net: remove napi_hash_del() from driver-facing API
Date:   Thu, 27 Aug 2020 15:32:48 -0700
Message-Id: <20200827223250.2045503-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200827223250.2045503-1-kuba@kernel.org>
References: <20200827104753.29d836bb@kicinski-fedora-PC1C0HJN>
 <20200827223250.2045503-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We allow drivers to call napi_hash_del() before calling
netif_napi_del() to batch RCU grace periods. This makes
the API asymmetric and leaks internal implementation details.
Soon we will want the grace period to protect more than just
the NAPI hash table.

Restructure the API and have drivers call a new function -
__netif_napi_del() if they want to take care of RCU waits.

Note that only core was checking the return status from
napi_hash_del() so the new helper does not report if the
NAPI was actually deleted.

Some notes on driver oddness:
 - veth observed the grace period before calling netif_napi_del()
   but that should not matter
 - myri10ge observed normal RCU flavor
 - bnx2x and enic did not actually observe the grace period
   (unless they did so implicitly)
 - virtio_net and enic only unhashed Rx NAPIs

The last two points seem to indicate that the calls to
napi_hash_del() were a left over rather than an optimization.
Regardless, it's easy enough to correct them.

This patch may introduce extra synchronize_net() calls for
interfaces which set NAPI_STATE_NO_BUSY_POLL and depend on
free_netdev() to call netif_napi_del(). This seems inevitable
since we want to use RCU for netpoll dev->napi_list traversal,
and almost no drivers set IFF_DISABLE_NETPOLL.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  8 ++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  5 ++-
 drivers/net/ethernet/cisco/enic/enic_main.c   | 12 ++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  |  4 +--
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  5 ++-
 drivers/net/veth.c                            |  3 +-
 drivers/net/virtio_net.c                      |  7 ++--
 include/linux/netdevice.h                     | 32 +++++++++----------
 net/core/dev.c                                | 19 ++++-------
 9 files changed, 43 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index 7e4c93be4451..d8b1824c334d 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -825,9 +825,9 @@ static inline void bnx2x_del_all_napi_cnic(struct bnx2x *bp)
 	int i;
 
 	for_each_rx_queue_cnic(bp, i) {
-		napi_hash_del(&bnx2x_fp(bp, i, napi));
-		netif_napi_del(&bnx2x_fp(bp, i, napi));
+		__netif_napi_del(&bnx2x_fp(bp, i, napi));
 	}
+	synchronize_net();
 }
 
 static inline void bnx2x_del_all_napi(struct bnx2x *bp)
@@ -835,9 +835,9 @@ static inline void bnx2x_del_all_napi(struct bnx2x *bp)
 	int i;
 
 	for_each_eth_queue(bp, i) {
-		napi_hash_del(&bnx2x_fp(bp, i, napi));
-		netif_napi_del(&bnx2x_fp(bp, i, napi));
+		__netif_napi_del(&bnx2x_fp(bp, i, napi));
 	}
+	synchronize_net();
 }
 
 int bnx2x_set_int_mode(struct bnx2x *bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 57d0e195cddf..fda2e6a2e68a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8634,10 +8634,9 @@ static void bnxt_del_napi(struct bnxt *bp)
 	for (i = 0; i < bp->cp_nr_rings; i++) {
 		struct bnxt_napi *bnapi = bp->bnapi[i];
 
-		napi_hash_del(&bnapi->napi);
-		netif_napi_del(&bnapi->napi);
+		__netif_napi_del(&bnapi->napi);
 	}
-	/* We called napi_hash_del() before netif_napi_del(), we need
+	/* We called __netif_napi_del(), we need
 	 * to respect an RCU grace period before freeing napi structures.
 	 */
 	synchronize_net();
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 6bc7e7ba38c3..8f30f33a6da2 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2527,13 +2527,15 @@ static void enic_dev_deinit(struct enic *enic)
 {
 	unsigned int i;
 
-	for (i = 0; i < enic->rq_count; i++) {
-		napi_hash_del(&enic->napi[i]);
-		netif_napi_del(&enic->napi[i]);
-	}
+	for (i = 0; i < enic->rq_count; i++)
+		__netif_napi_del(&enic->napi[i]);
+
 	if (vnic_dev_get_intr_mode(enic->vdev) == VNIC_DEV_INTR_MODE_MSIX)
 		for (i = 0; i < enic->wq_count; i++)
-			netif_napi_del(&enic->napi[enic_cq_wq(enic, i)]);
+			__netif_napi_del(&enic->napi[enic_cq_wq(enic, i)]);
+
+	/* observe RCU grace period after __netif_napi_del() calls */
+	synchronize_net();
 
 	enic_free_vnic_resources(enic);
 	enic_clear_intr_mode(enic);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index 2e35c5706cf1..df389a11d3af 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -1029,10 +1029,10 @@ static void ixgbe_free_q_vector(struct ixgbe_adapter *adapter, int v_idx)
 		WRITE_ONCE(adapter->rx_ring[ring->queue_index], NULL);
 
 	adapter->q_vector[v_idx] = NULL;
-	napi_hash_del(&q_vector->napi);
-	netif_napi_del(&q_vector->napi);
+	__netif_napi_del(&q_vector->napi);
 
 	/*
+	 * after a call to __netif_napi_del() napi may still be used and
 	 * ixgbe_get_stats64() might access the rings on this vector,
 	 * we must wait a grace period before freeing it.
 	 */
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 4a5beafa0493..1634ca6d4a8f 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3543,11 +3543,10 @@ static void myri10ge_free_slices(struct myri10ge_priv *mgp)
 					  ss->fw_stats, ss->fw_stats_bus);
 			ss->fw_stats = NULL;
 		}
-		napi_hash_del(&ss->napi);
-		netif_napi_del(&ss->napi);
+		__netif_napi_del(&ss->napi);
 	}
 	/* Wait till napi structs are no longer used, and then free ss. */
-	synchronize_rcu();
+	synchronize_net();
 	kfree(mgp->ss);
 	mgp->ss = NULL;
 }
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index e56cd562a664..7efe5d969c31 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -897,14 +897,13 @@ static void veth_napi_del(struct net_device *dev)
 		struct veth_rq *rq = &priv->rq[i];
 
 		napi_disable(&rq->xdp_napi);
-		napi_hash_del(&rq->xdp_napi);
+		__netif_napi_del(&rq->xdp_napi);
 	}
 	synchronize_net();
 
 	for (i = 0; i < dev->real_num_rx_queues; i++) {
 		struct veth_rq *rq = &priv->rq[i];
 
-		netif_napi_del(&rq->xdp_napi);
 		rq->rx_notify_masked = false;
 		ptr_ring_cleanup(&rq->xdp_ring, veth_ptr_free);
 	}
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0ada48edf749..dbc9f8aad84e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2604,12 +2604,11 @@ static void virtnet_free_queues(struct virtnet_info *vi)
 	int i;
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		napi_hash_del(&vi->rq[i].napi);
-		netif_napi_del(&vi->rq[i].napi);
-		netif_napi_del(&vi->sq[i].napi);
+		__netif_napi_del(&vi->rq[i].napi);
+		__netif_napi_del(&vi->sq[i].napi);
 	}
 
-	/* We called napi_hash_del() before netif_napi_del(),
+	/* We called __netif_napi_del(),
 	 * we need to respect an RCU grace period before freeing vi->rq
 	 */
 	synchronize_net();
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b0e303f6603f..67400efa6f00 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -70,6 +70,7 @@ struct udp_tunnel_nic;
 struct bpf_prog;
 struct xdp_buff;
 
+void synchronize_net(void);
 void netdev_set_default_ethtool_ops(struct net_device *dev,
 				    const struct ethtool_ops *ops);
 
@@ -488,20 +489,6 @@ static inline bool napi_complete(struct napi_struct *n)
 	return napi_complete_done(n, 0);
 }
 
-/**
- *	napi_hash_del - remove a NAPI from global table
- *	@napi: NAPI context
- *
- * Warning: caller must observe RCU grace period
- * before freeing memory containing @napi, if
- * this function returns true.
- * Note: core networking stack automatically calls it
- * from netif_napi_del().
- * Drivers might want to call this helper to combine all
- * the needed RCU grace periods into a single one.
- */
-bool napi_hash_del(struct napi_struct *napi);
-
 /**
  *	napi_disable - prevent NAPI from scheduling
  *	@n: NAPI context
@@ -2347,13 +2334,27 @@ static inline void netif_tx_napi_add(struct net_device *dev,
 	netif_napi_add(dev, napi, poll, weight);
 }
 
+/**
+ *  ___netif_napi_del - remove a NAPI context
+ *  @napi: NAPI context
+ *
+ * Warning: caller must observe RCU grace period before freeing memory
+ * containing @napi. Drivers might want to call this helper to combine
+ * all the needed RCU grace periods into a single one.
+ */
+void __netif_napi_del(struct napi_struct *napi);
+
 /**
  *  netif_napi_del - remove a NAPI context
  *  @napi: NAPI context
  *
  *  netif_napi_del() removes a NAPI context from the network device NAPI list
  */
-void netif_napi_del(struct napi_struct *napi);
+static inline void netif_napi_del(struct napi_struct *napi)
+{
+	__netif_napi_del(napi);
+	synchronize_net();
+}
 
 struct napi_gro_cb {
 	/* Virtual address of skb_shinfo(skb)->frags[0].page + offset. */
@@ -2777,7 +2778,6 @@ static inline void unregister_netdevice(struct net_device *dev)
 int netdev_refcnt_read(const struct net_device *dev);
 void free_netdev(struct net_device *dev);
 void netdev_freemem(struct net_device *dev);
-void synchronize_net(void);
 int init_dummy_netdev(struct net_device *dev);
 
 struct net_device *netdev_get_xmit_slave(struct net_device *dev,
diff --git a/net/core/dev.c b/net/core/dev.c
index 95ac7568f693..d2c6fa24aa23 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6555,20 +6555,15 @@ static void napi_hash_add(struct napi_struct *napi)
 /* Warning : caller is responsible to make sure rcu grace period
  * is respected before freeing memory containing @napi
  */
-bool napi_hash_del(struct napi_struct *napi)
+static void napi_hash_del(struct napi_struct *napi)
 {
-	bool rcu_sync_needed = false;
-
 	spin_lock(&napi_hash_lock);
 
-	if (test_and_clear_bit(NAPI_STATE_HASHED, &napi->state)) {
-		rcu_sync_needed = true;
+	if (test_and_clear_bit(NAPI_STATE_HASHED, &napi->state))
 		hlist_del_rcu(&napi->napi_hash_node);
-	}
+
 	spin_unlock(&napi_hash_lock);
-	return rcu_sync_needed;
 }
-EXPORT_SYMBOL_GPL(napi_hash_del);
 
 static enum hrtimer_restart napi_watchdog(struct hrtimer *timer)
 {
@@ -6653,18 +6648,16 @@ static void flush_gro_hash(struct napi_struct *napi)
 }
 
 /* Must be called in process context */
-void netif_napi_del(struct napi_struct *napi)
+void __netif_napi_del(struct napi_struct *napi)
 {
-	might_sleep();
-	if (napi_hash_del(napi))
-		synchronize_net();
+	napi_hash_del(napi);
 	list_del_init(&napi->dev_list);
 	napi_free_frags(napi);
 
 	flush_gro_hash(napi);
 	napi->gro_bitmask = 0;
 }
-EXPORT_SYMBOL(netif_napi_del);
+EXPORT_SYMBOL(__netif_napi_del);
 
 static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 {
-- 
2.26.2

