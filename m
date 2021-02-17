Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3424E31DB0D
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 14:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhBQN5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 08:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233182AbhBQN5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 08:57:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9540664E0F;
        Wed, 17 Feb 2021 13:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613570181;
        bh=BzetxzCebjrSci6Xj8L7xFQedreOjfG3DhIsy3/gayI=;
        h=From:To:Cc:Subject:Date:From;
        b=jio7QocZ0ydAGt7Fh/53zmoHeIn+HgugHasjLgk91hje1HvsZz5Xi2GkC9pWm3nba
         c6Jwa41nqmdas9V+r8i4CzzXHQQvUdJ1GHhFAj8ETmmr7yt+vMWHBaT127vClq3Drm
         npc0wGC8MO+cNF02UTmjjZxW+EgVaS2RI7UMxs0iWBr9K47Ep/g84S3p3/kHVFtc7B
         48Qtv82oMZAyMBeFkRXOfyOa5xslOSgTTXadX+VB+iqGfVdvnU93q5+7KFT+H+q8Es
         oLi/KzMqsNyERkdVv0ZL0FvInUjp0VbUiApVD6OVTRTZHPRVrxXiGHJEaEv35N+9Hp
         XoAO8dRlzK2NA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, toke@redhat.com, freysteinn.alfredsson@kau.se
Subject: [PATCH bpf-next] bpf: devmap: move drop error path to devmap for XDP_REDIRECT
Date:   Wed, 17 Feb 2021 14:56:03 +0100
Message-Id: <76469732237ce6d6cc6344c9500f9e32a123a56e.1613569803.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to change the current ndo_xdp_xmit drop semantics because
it will allow us to implement better queue overflow handling.
This is working towards the larger goal of a XDP TX queue-hook.
Move XDP_REDIRECT error path handling from each XDP ethernet driver to
devmap code. According to the new APIs, the driver running the
ndo_xdp_xmit pointer, will break tx loop whenever the hw reports a tx
error and it will just return to devmap caller the number of successfully
transmitted frames. It will be devmap responsability to free dropped frames.
Move each XDP ndo_xdp_xmit capable driver to the new APIs:
- veth
- virtio-net
- mvneta
- mvpp2
- socionext
- amazon ena
- bnxt
- freescale (dpaa2, dpaa)
- xen-frontend
- qede
- ice
- igb
- ixgbe
- i40e
- mlx5
- ti (cpsw, cpsw-new)
- tun
- sfc

More details about the new ndo_xdp_xmit design can be found here [0].

[0] https://github.com/xdp-project/xdp-project/blob/master/areas/core/redesign01_ndo_xdp_xmit.org

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 18 ++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 20 ++++++--------
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 12 ++++-----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  2 --
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 15 +++++------
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 15 +++++------
 drivers/net/ethernet/intel/igb/igb_main.c     | 11 ++++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 11 ++++----
 drivers/net/ethernet/marvell/mvneta.c         | 13 +++++----
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 13 +++++----
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 15 +++++------
 drivers/net/ethernet/qlogic/qede/qede_fp.c    | 19 +++++--------
 drivers/net/ethernet/sfc/tx.c                 | 15 +----------
 drivers/net/ethernet/socionext/netsec.c       | 16 +++++------
 drivers/net/ethernet/ti/cpsw.c                | 14 +++++-----
 drivers/net/ethernet/ti/cpsw_new.c            | 14 +++++-----
 drivers/net/ethernet/ti/cpsw_priv.c           | 11 +++-----
 drivers/net/tun.c                             | 15 ++++++-----
 drivers/net/veth.c                            | 27 ++++++++++---------
 drivers/net/virtio_net.c                      | 25 ++++++++---------
 drivers/net/xen-netfront.c                    | 18 ++++++-------
 kernel/bpf/devmap.c                           | 27 +++++++++----------
 22 files changed, 153 insertions(+), 193 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 102f2c91fdb8..7ad0557dedbd 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -300,7 +300,7 @@ static int ena_xdp_xmit_frame(struct ena_ring *xdp_ring,
 
 	rc = ena_xdp_tx_map_frame(xdp_ring, tx_info, xdpf, &push_hdr, &push_len);
 	if (unlikely(rc))
-		goto error_drop_packet;
+		return rc;
 
 	ena_tx_ctx.ena_bufs = tx_info->bufs;
 	ena_tx_ctx.push_header = push_hdr;
@@ -330,8 +330,6 @@ static int ena_xdp_xmit_frame(struct ena_ring *xdp_ring,
 error_unmap_dma:
 	ena_unmap_tx_buff(xdp_ring, tx_info);
 	tx_info->xdpf = NULL;
-error_drop_packet:
-	xdp_return_frame(xdpf);
 	return rc;
 }
 
@@ -339,8 +337,8 @@ static int ena_xdp_xmit(struct net_device *dev, int n,
 			struct xdp_frame **frames, u32 flags)
 {
 	struct ena_adapter *adapter = netdev_priv(dev);
-	int qid, i, err, drops = 0;
 	struct ena_ring *xdp_ring;
+	int qid, i, nxmit = 0;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
@@ -360,12 +358,12 @@ static int ena_xdp_xmit(struct net_device *dev, int n,
 	spin_lock(&xdp_ring->xdp_tx_lock);
 
 	for (i = 0; i < n; i++) {
-		err = ena_xdp_xmit_frame(xdp_ring, dev, frames[i], 0);
 		/* The descriptor is freed by ena_xdp_xmit_frame in case
 		 * of an error.
 		 */
-		if (err)
-			drops++;
+		if (ena_xdp_xmit_frame(xdp_ring, dev, frames[i], 0))
+			break;
+		nxmit++;
 	}
 
 	/* Ring doorbell to make device aware of the packets */
@@ -378,7 +376,7 @@ static int ena_xdp_xmit(struct net_device *dev, int n,
 	spin_unlock(&xdp_ring->xdp_tx_lock);
 
 	/* Return number of packets sent */
-	return n - drops;
+	return nxmit;
 }
 
 static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
@@ -415,7 +413,9 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 		/* The XDP queues are shared between XDP_TX and XDP_REDIRECT */
 		spin_lock(&xdp_ring->xdp_tx_lock);
 
-		ena_xdp_xmit_frame(xdp_ring, rx_ring->netdev, xdpf, XDP_XMIT_FLUSH);
+		if (ena_xdp_xmit_frame(xdp_ring, rx_ring->netdev, xdpf,
+				       XDP_XMIT_FLUSH))
+			xdp_return_frame(xdpf);
 
 		spin_unlock(&xdp_ring->xdp_tx_lock);
 		xdp_stat = &rx_ring->rx_stats.xdp_tx;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 641303894341..ec9564e584e0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -217,7 +217,7 @@ int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 	struct pci_dev *pdev = bp->pdev;
 	struct bnxt_tx_ring_info *txr;
 	dma_addr_t mapping;
-	int drops = 0;
+	int nxmit = 0;
 	int ring;
 	int i;
 
@@ -233,21 +233,17 @@ int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 		struct xdp_frame *xdp = frames[i];
 
 		if (!txr || !bnxt_tx_avail(bp, txr) ||
-		    !(bp->bnapi[ring]->flags & BNXT_NAPI_FLAG_XDP)) {
-			xdp_return_frame_rx_napi(xdp);
-			drops++;
-			continue;
-		}
+		    !(bp->bnapi[ring]->flags & BNXT_NAPI_FLAG_XDP))
+			break;
 
 		mapping = dma_map_single(&pdev->dev, xdp->data, xdp->len,
 					 DMA_TO_DEVICE);
 
-		if (dma_mapping_error(&pdev->dev, mapping)) {
-			xdp_return_frame_rx_napi(xdp);
-			drops++;
-			continue;
-		}
+		if (dma_mapping_error(&pdev->dev, mapping))
+			break;
+
 		__bnxt_xmit_xdp_redirect(bp, txr, mapping, xdp->len, xdp);
+		nxmit++;
 	}
 
 	if (flags & XDP_XMIT_FLUSH) {
@@ -256,7 +252,7 @@ int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 		bnxt_db_write(bp, &txr->tx_db, txr->tx_prod);
 	}
 
-	return num_frames - drops;
+	return nxmit;
 }
 
 /* Under rtnl_lock */
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index ccfe52a50a66..d5ef6cc911f3 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -3081,7 +3081,7 @@ static int dpaa_xdp_xmit(struct net_device *net_dev, int n,
 			 struct xdp_frame **frames, u32 flags)
 {
 	struct xdp_frame *xdpf;
-	int i, err, drops = 0;
+	int i, nxmit = 0;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
@@ -3091,14 +3091,12 @@ static int dpaa_xdp_xmit(struct net_device *net_dev, int n,
 
 	for (i = 0; i < n; i++) {
 		xdpf = frames[i];
-		err = dpaa_xdp_xmit_frame(net_dev, xdpf);
-		if (err) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-		}
+		if (dpaa_xdp_xmit_frame(net_dev, xdpf))
+			break;
+		nxmit++;
 	}
 
-	return n - drops;
+	return nxmit;
 }
 
 static int dpaa_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 492943bb9c48..fc0eb82cdd6a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2431,8 +2431,6 @@ static int dpaa2_eth_xdp_xmit(struct net_device *net_dev, int n,
 	percpu_stats->tx_packets += enqueued;
 	for (i = 0; i < enqueued; i++)
 		percpu_stats->tx_bytes += dpaa2_fd_get_len(&fds[i]);
-	for (i = enqueued; i < n; i++)
-		xdp_return_frame_rx_napi(frames[i]);
 
 	return enqueued;
 }
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index f6f1af94cca0..834b55816a62 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3844,8 +3844,8 @@ netdev_tx_t i40e_lan_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
  * @frames: array of XDP buffer pointers
  * @flags: XDP extra info
  *
- * Returns number of frames successfully sent. Frames that fail are
- * free'ed via XDP return API.
+ * Returns number of frames successfully sent. Failed frames
+ * will be free'ed by XDP core.
  *
  * For error cases, a negative errno code is returned and no-frames
  * are transmitted (caller must handle freeing frames).
@@ -3858,7 +3858,7 @@ int i40e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
 	struct i40e_ring *xdp_ring;
-	int drops = 0;
+	int nxmit = 0;
 	int i;
 
 	if (test_bit(__I40E_VSI_DOWN, vsi->state))
@@ -3878,14 +3878,13 @@ int i40e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		int err;
 
 		err = i40e_xmit_xdp_ring(xdpf, xdp_ring);
-		if (err != I40E_XDP_TX) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-		}
+		if (err != I40E_XDP_TX)
+			break;
+		nxmit++;
 	}
 
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		i40e_xdp_ring_update_tail(xdp_ring);
 
-	return n - drops;
+	return nxmit;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index b7dc25da1202..d4bfa7905652 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -571,8 +571,8 @@ ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
  * @frames: XDP frames to be transmitted
  * @flags: transmit flags
  *
- * Returns number of frames successfully sent. Frames that fail are
- * free'ed via XDP return API.
+ * Returns number of frames successfully sent. Failed frames
+ * will be free'ed by XDP core.
  * For error cases, a negative errno code is returned and no-frames
  * are transmitted (caller must handle freeing frames).
  */
@@ -584,7 +584,7 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	unsigned int queue_index = smp_processor_id();
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_ring *xdp_ring;
-	int drops = 0, i;
+	int nxmit = 0, i;
 
 	if (test_bit(__ICE_DOWN, vsi->state))
 		return -ENETDOWN;
@@ -601,16 +601,15 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		int err;
 
 		err = ice_xmit_xdp_ring(xdpf->data, xdpf->len, xdp_ring);
-		if (err != ICE_XDP_TX) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-		}
+		if (err != ICE_XDP_TX)
+			break;
+		nxmit++;
 	}
 
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		ice_xdp_ring_update_tail(xdp_ring);
 
-	return n - drops;
+	return nxmit;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 878b31d534ec..cb0d07ff2492 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2934,7 +2934,7 @@ static int igb_xdp_xmit(struct net_device *dev, int n,
 	int cpu = smp_processor_id();
 	struct igb_ring *tx_ring;
 	struct netdev_queue *nq;
-	int drops = 0;
+	int nxmit = 0;
 	int i;
 
 	if (unlikely(test_bit(__IGB_DOWN, &adapter->state)))
@@ -2961,10 +2961,9 @@ static int igb_xdp_xmit(struct net_device *dev, int n,
 		int err;
 
 		err = igb_xmit_xdp_ring(adapter, tx_ring, xdpf);
-		if (err != IGB_XDP_TX) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-		}
+		if (err != IGB_XDP_TX)
+			break;
+		nxmit++;
 	}
 
 	__netif_tx_unlock(nq);
@@ -2972,7 +2971,7 @@ static int igb_xdp_xmit(struct net_device *dev, int n,
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		igb_xdp_ring_update_tail(tx_ring);
 
-	return n - drops;
+	return nxmit;
 }
 
 static const struct net_device_ops igb_netdev_ops = {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index fae84202d870..c54b58cfe7b3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10186,7 +10186,7 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
 {
 	struct ixgbe_adapter *adapter = netdev_priv(dev);
 	struct ixgbe_ring *ring;
-	int drops = 0;
+	int nxmit = 0;
 	int i;
 
 	if (unlikely(test_bit(__IXGBE_DOWN, &adapter->state)))
@@ -10210,16 +10210,15 @@ static int ixgbe_xdp_xmit(struct net_device *dev, int n,
 		int err;
 
 		err = ixgbe_xmit_xdp_ring(adapter, xdpf);
-		if (err != IXGBE_XDP_TX) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-		}
+		if (err != IXGBE_XDP_TX)
+			break;
+		nxmit++;
 	}
 
 	if (unlikely(flags & XDP_XMIT_FLUSH))
 		ixgbe_xdp_ring_update_tail(ring);
 
-	return n - drops;
+	return nxmit;
 }
 
 static const struct net_device_ops ixgbe_netdev_ops = {
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index a635cf84608a..20307eec8988 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2137,7 +2137,7 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 {
 	struct mvneta_port *pp = netdev_priv(dev);
 	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
-	int i, nxmit_byte = 0, nxmit = num_frame;
+	int i, nxmit_byte = 0, nxmit = 0;
 	int cpu = smp_processor_id();
 	struct mvneta_tx_queue *txq;
 	struct netdev_queue *nq;
@@ -2155,12 +2155,11 @@ mvneta_xdp_xmit(struct net_device *dev, int num_frame,
 	__netif_tx_lock(nq, cpu);
 	for (i = 0; i < num_frame; i++) {
 		ret = mvneta_xdp_submit_frame(pp, txq, frames[i], true);
-		if (ret == MVNETA_XDP_TX) {
-			nxmit_byte += frames[i]->len;
-		} else {
-			xdp_return_frame_rx_napi(frames[i]);
-			nxmit--;
-		}
+		if (ret != MVNETA_XDP_TX)
+			break;
+
+		nxmit_byte += frames[i]->len;
+		nxmit++;
 	}
 
 	if (unlikely(flags & XDP_XMIT_FLUSH))
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 0507369bb54d..4ac6e43aab96 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3744,7 +3744,7 @@ mvpp2_xdp_xmit(struct net_device *dev, int num_frame,
 	       struct xdp_frame **frames, u32 flags)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
-	int i, nxmit_byte = 0, nxmit = num_frame;
+	int i, nxmit_byte = 0, nxmit = 0;
 	struct mvpp2_pcpu_stats *stats;
 	u16 txq_id;
 	u32 ret;
@@ -3762,12 +3762,11 @@ mvpp2_xdp_xmit(struct net_device *dev, int num_frame,
 
 	for (i = 0; i < num_frame; i++) {
 		ret = mvpp2_xdp_submit_frame(port, txq_id, frames[i], true);
-		if (ret == MVPP2_XDP_TX) {
-			nxmit_byte += frames[i]->len;
-		} else {
-			xdp_return_frame_rx_napi(frames[i]);
-			nxmit--;
-		}
+		if (ret != MVPP2_XDP_TX)
+			break;
+
+		nxmit_byte += frames[i]->len;
+		nxmit++;
 	}
 
 	if (likely(nxmit > 0))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 2e3e78b0f333..2f0df5cc1a2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -500,7 +500,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_xdpsq *sq;
-	int drops = 0;
+	int nxmit = 0;
 	int sq_num;
 	int i;
 
@@ -529,11 +529,8 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		xdptxd.dma_addr = dma_map_single(sq->pdev, xdptxd.data,
 						 xdptxd.len, DMA_TO_DEVICE);
 
-		if (unlikely(dma_mapping_error(sq->pdev, xdptxd.dma_addr))) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-			continue;
-		}
+		if (unlikely(dma_mapping_error(sq->pdev, xdptxd.dma_addr)))
+			break;
 
 		xdpi.mode           = MLX5E_XDP_XMIT_MODE_FRAME;
 		xdpi.frame.xdpf     = xdpf;
@@ -544,9 +541,9 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		if (unlikely(!ret)) {
 			dma_unmap_single(sq->pdev, xdptxd.dma_addr,
 					 xdptxd.len, DMA_TO_DEVICE);
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
+			break;
 		}
+		nxmit++;
 	}
 
 	if (flags & XDP_XMIT_FLUSH) {
@@ -555,7 +552,7 @@ int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		mlx5e_xmit_xdp_doorbell(sq);
 	}
 
-	return n - drops;
+	return nxmit;
 }
 
 void mlx5e_xdp_rx_poll_complete(struct mlx5e_rq *rq)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 8c47a9d2a965..102d0e0808d5 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -345,7 +345,7 @@ int qede_xdp_transmit(struct net_device *dev, int n_frames,
 	struct qede_tx_queue *xdp_tx;
 	struct xdp_frame *xdpf;
 	dma_addr_t mapping;
-	int i, drops = 0;
+	int i, nxmit = 0;
 	u16 xdp_prod;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
@@ -364,18 +364,13 @@ int qede_xdp_transmit(struct net_device *dev, int n_frames,
 
 		mapping = dma_map_single(dmadev, xdpf->data, xdpf->len,
 					 DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dmadev, mapping))) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-
-			continue;
-		}
+		if (unlikely(dma_mapping_error(dmadev, mapping)))
+			break;
 
 		if (unlikely(qede_xdp_xmit(xdp_tx, mapping, 0, xdpf->len,
-					   NULL, xdpf))) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-		}
+					   NULL, xdpf)))
+			break;
+		nxmit++;
 	}
 
 	if (flags & XDP_XMIT_FLUSH) {
@@ -387,7 +382,7 @@ int qede_xdp_transmit(struct net_device *dev, int n_frames,
 
 	spin_unlock(&xdp_tx->xdp_tx_lock);
 
-	return n_frames - drops;
+	return nxmit;
 }
 
 int qede_txq_has_work(struct qede_tx_queue *txq)
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 1665529a7271..0c6650d2e239 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -412,14 +412,6 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
 	return NETDEV_TX_OK;
 }
 
-static void efx_xdp_return_frames(int n,  struct xdp_frame **xdpfs)
-{
-	int i;
-
-	for (i = 0; i < n; i++)
-		xdp_return_frame_rx_napi(xdpfs[i]);
-}
-
 /* Transmit a packet from an XDP buffer
  *
  * Returns number of packets sent on success, error code otherwise.
@@ -492,12 +484,7 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
 	if (flush && i > 0)
 		efx_nic_push_buffers(tx_queue);
 
-	if (i == 0)
-		return -EIO;
-
-	efx_xdp_return_frames(n - i, xdpfs + i);
-
-	return i;
+	return i == 0 ? -EIO : i;
 }
 
 /* Initiate a packet transmission.  We use one channel per CPU
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 3c53051bdacf..b9449cf36e31 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1757,8 +1757,7 @@ static int netsec_xdp_xmit(struct net_device *ndev, int n,
 {
 	struct netsec_priv *priv = netdev_priv(ndev);
 	struct netsec_desc_ring *tx_ring = &priv->desc_ring[NETSEC_RING_TX];
-	int drops = 0;
-	int i;
+	int i, nxmit = 0;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
@@ -1769,12 +1768,11 @@ static int netsec_xdp_xmit(struct net_device *ndev, int n,
 		int err;
 
 		err = netsec_xdp_queue_one(priv, xdpf, true);
-		if (err != NETSEC_XDP_TX) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-		} else {
-			tx_ring->xdp_xmit++;
-		}
+		if (err != NETSEC_XDP_TX)
+			break;
+
+		tx_ring->xdp_xmit++;
+		nxmit++;
 	}
 	spin_unlock(&tx_ring->lock);
 
@@ -1783,7 +1781,7 @@ static int netsec_xdp_xmit(struct net_device *ndev, int n,
 		tx_ring->xdp_xmit = 0;
 	}
 
-	return n - drops;
+	return nxmit;
 }
 
 static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index fd966567464c..074702af3dc6 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1123,25 +1123,23 @@ static int cpsw_ndo_xdp_xmit(struct net_device *ndev, int n,
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
 	struct xdp_frame *xdpf;
-	int i, drops = 0, port;
+	int i, nxmit = 0, port;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
 
 	for (i = 0; i < n; i++) {
 		xdpf = frames[i];
-		if (xdpf->len < CPSW_MIN_PACKET_SIZE) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-			continue;
-		}
+		if (xdpf->len < CPSW_MIN_PACKET_SIZE)
+			break;
 
 		port = priv->emac_port + cpsw->data.dual_emac;
 		if (cpsw_xdp_tx_frame(priv, xdpf, NULL, port))
-			drops++;
+			break;
+		nxmit++;
 	}
 
-	return n - drops;
+	return nxmit;
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 58a64313ac00..0751f77de2c7 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1093,24 +1093,22 @@ static int cpsw_ndo_xdp_xmit(struct net_device *ndev, int n,
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct xdp_frame *xdpf;
-	int i, drops = 0;
+	int i, nxmit = 0;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
 
 	for (i = 0; i < n; i++) {
 		xdpf = frames[i];
-		if (xdpf->len < CPSW_MIN_PACKET_SIZE) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-			continue;
-		}
+		if (xdpf->len < CPSW_MIN_PACKET_SIZE)
+			break;
 
 		if (cpsw_xdp_tx_frame(priv, xdpf, NULL, priv->emac_port))
-			drops++;
+			break;
+		nxmit++;
 	}
 
-	return n - drops;
+	return nxmit;
 }
 
 static int cpsw_get_port_parent_id(struct net_device *ndev,
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index bb59e768915e..5862f0a4a975 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -1305,19 +1305,15 @@ int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
 		ret = cpdma_chan_submit_mapped(txch, cpsw_xdpf_to_handle(xdpf),
 					       dma, xdpf->len, port);
 	} else {
-		if (sizeof(*xmeta) > xdpf->headroom) {
-			xdp_return_frame_rx_napi(xdpf);
+		if (sizeof(*xmeta) > xdpf->headroom)
 			return -EINVAL;
-		}
 
 		ret = cpdma_chan_submit(txch, cpsw_xdpf_to_handle(xdpf),
 					xdpf->data, xdpf->len, port);
 	}
 
-	if (ret) {
+	if (ret)
 		priv->ndev->stats.tx_dropped++;
-		xdp_return_frame_rx_napi(xdpf);
-	}
 
 	return ret;
 }
@@ -1353,7 +1349,8 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 		if (unlikely(!xdpf))
 			goto drop;
 
-		cpsw_xdp_tx_frame(priv, xdpf, page, port);
+		if (cpsw_xdp_tx_frame(priv, xdpf, page, port))
+			xdp_return_frame_rx_napi(xdpf);
 		break;
 	case XDP_REDIRECT:
 		if (xdp_do_redirect(ndev, xdp, prog))
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fc86da7f1628..6e55697315de 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1181,8 +1181,7 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
 	struct tun_struct *tun = netdev_priv(dev);
 	struct tun_file *tfile;
 	u32 numqueues;
-	int drops = 0;
-	int cnt = n;
+	int nxmit = 0;
 	int i;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
@@ -1212,9 +1211,9 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
 
 		if (__ptr_ring_produce(&tfile->tx_ring, frame)) {
 			atomic_long_inc(&dev->tx_dropped);
-			xdp_return_frame_rx_napi(xdp);
-			drops++;
+			break;
 		}
+		nxmit++;
 	}
 	spin_unlock(&tfile->tx_ring.producer_lock);
 
@@ -1222,17 +1221,21 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
 		__tun_xdp_flush_tfile(tfile);
 
 	rcu_read_unlock();
-	return cnt - drops;
+	return nxmit;
 }
 
 static int tun_xdp_tx(struct net_device *dev, struct xdp_buff *xdp)
 {
 	struct xdp_frame *frame = xdp_convert_buff_to_frame(xdp);
+	int nxmit;
 
 	if (unlikely(!frame))
 		return -EOVERFLOW;
 
-	return tun_xdp_xmit(dev, 1, &frame, XDP_XMIT_FLUSH);
+	nxmit = tun_xdp_xmit(dev, 1, &frame, XDP_XMIT_FLUSH);
+	if (!nxmit)
+		xdp_return_frame_rx_napi(frame);
+	return nxmit;
 }
 
 static const struct net_device_ops tap_netdev_ops = {
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index aa1a66ad2ce5..36293a2c3618 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -434,7 +434,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 			 u32 flags, bool ndo_xmit)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
-	int i, ret = -ENXIO, drops = 0;
+	int i, ret = -ENXIO, nxmit = 0;
 	struct net_device *rcv;
 	unsigned int max_len;
 	struct veth_rq *rq;
@@ -464,21 +464,20 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 		void *ptr = veth_xdp_to_ptr(frame);
 
 		if (unlikely(frame->len > max_len ||
-			     __ptr_ring_produce(&rq->xdp_ring, ptr))) {
-			xdp_return_frame_rx_napi(frame);
-			drops++;
-		}
+			     __ptr_ring_produce(&rq->xdp_ring, ptr)))
+			break;
+		nxmit++;
 	}
 	spin_unlock(&rq->xdp_ring.producer_lock);
 
 	if (flags & XDP_XMIT_FLUSH)
 		__veth_xdp_flush(rq);
 
-	ret = n - drops;
+	ret = nxmit;
 	if (ndo_xmit) {
 		u64_stats_update_begin(&rq->stats.syncp);
-		rq->stats.vs.peer_tq_xdp_xmit += n - drops;
-		rq->stats.vs.peer_tq_xdp_xmit_err += drops;
+		rq->stats.vs.peer_tq_xdp_xmit += nxmit;
+		rq->stats.vs.peer_tq_xdp_xmit_err += n - nxmit;
 		u64_stats_update_end(&rq->stats.syncp);
 	}
 
@@ -505,20 +504,24 @@ static int veth_ndo_xdp_xmit(struct net_device *dev, int n,
 
 static void veth_xdp_flush_bq(struct veth_rq *rq, struct veth_xdp_tx_bq *bq)
 {
-	int sent, i, err = 0;
+	int sent, i, err = 0, drops;
 
 	sent = veth_xdp_xmit(rq->dev, bq->count, bq->q, 0, false);
 	if (sent < 0) {
 		err = sent;
 		sent = 0;
-		for (i = 0; i < bq->count; i++)
+	}
+
+	drops = bq->count - sent;
+	if (unlikely(drops > 0)) {
+		for (i = sent; i < bq->count; i++)
 			xdp_return_frame(bq->q[i]);
 	}
-	trace_xdp_bulk_tx(rq->dev, sent, bq->count - sent, err);
+	trace_xdp_bulk_tx(rq->dev, sent, drops, err);
 
 	u64_stats_update_begin(&rq->stats.syncp);
 	rq->stats.vs.xdp_tx += sent;
-	rq->stats.vs.xdp_tx_err += bq->count - sent;
+	rq->stats.vs.xdp_tx_err += drops;
 	u64_stats_update_end(&rq->stats.syncp);
 
 	bq->count = 0;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba8e63792549..ea87830f21d2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -499,10 +499,10 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	unsigned int len;
 	int packets = 0;
 	int bytes = 0;
-	int drops = 0;
+	int nxmit = 0;
 	int kicks = 0;
-	int ret, err;
 	void *ptr;
+	int ret;
 	int i;
 
 	/* Only allow ndo_xdp_xmit if XDP is loaded on dev, as this
@@ -516,7 +516,6 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
 		ret = -EINVAL;
-		drops = n;
 		goto out;
 	}
 
@@ -539,13 +538,11 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	for (i = 0; i < n; i++) {
 		struct xdp_frame *xdpf = frames[i];
 
-		err = __virtnet_xdp_xmit_one(vi, sq, xdpf);
-		if (err) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-		}
+		if (__virtnet_xdp_xmit_one(vi, sq, xdpf))
+			break;
+		nxmit++;
 	}
-	ret = n - drops;
+	ret = nxmit;
 
 	if (flags & XDP_XMIT_FLUSH) {
 		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq))
@@ -556,7 +553,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	sq->stats.bytes += bytes;
 	sq->stats.packets += packets;
 	sq->stats.xdp_tx += n;
-	sq->stats.xdp_tx_drops += drops;
+	sq->stats.xdp_tx_drops += n - nxmit;
 	sq->stats.kicks += kicks;
 	u64_stats_update_end(&sq->stats.syncp);
 
@@ -709,7 +706,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			if (unlikely(!xdpf))
 				goto err_xdp;
 			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
-			if (unlikely(err < 0)) {
+			if (unlikely(!err)) {
+				xdp_return_frame_rx_napi(xdpf);
+			} else if (unlikely(err < 0)) {
 				trace_xdp_exception(vi->dev, xdp_prog, act);
 				goto err_xdp;
 			}
@@ -895,7 +894,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			if (unlikely(!xdpf))
 				goto err_xdp;
 			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
-			if (unlikely(err < 0)) {
+			if (unlikely(!err)) {
+				xdp_return_frame_rx_napi(xdpf);
+			} else if (unlikely(err < 0)) {
 				trace_xdp_exception(vi->dev, xdp_prog, act);
 				if (unlikely(xdp_page != page))
 					put_page(xdp_page);
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index cc19cd9203da..44275908d61a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -608,8 +608,8 @@ static int xennet_xdp_xmit(struct net_device *dev, int n,
 	struct netfront_info *np = netdev_priv(dev);
 	struct netfront_queue *queue = NULL;
 	unsigned long irq_flags;
-	int drops = 0;
-	int i, err;
+	int nxmit = 0;
+	int i;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
 		return -EINVAL;
@@ -622,15 +622,13 @@ static int xennet_xdp_xmit(struct net_device *dev, int n,
 
 		if (!xdpf)
 			continue;
-		err = xennet_xdp_xmit_one(dev, queue, xdpf);
-		if (err) {
-			xdp_return_frame_rx_napi(xdpf);
-			drops++;
-		}
+		if (xennet_xdp_xmit_one(dev, queue, xdpf))
+			break;
+		nxmit++;
 	}
 	spin_unlock_irqrestore(&queue->tx_lock, irq_flags);
 
-	return n - drops;
+	return nxmit;
 }
 
 
@@ -875,7 +873,9 @@ static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
 		get_page(pdata);
 		xdpf = xdp_convert_buff_to_frame(xdp);
 		err = xennet_xdp_xmit(queue->info->netdev, 1, &xdpf, 0);
-		if (unlikely(err < 0))
+		if (unlikely(!err))
+			xdp_return_frame_rx_napi(xdpf);
+		else if (unlikely(err < 0))
 			trace_xdp_exception(queue->info->netdev, prog, act);
 		break;
 	case XDP_REDIRECT:
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 85d9d1b72a33..9f158b3862df 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -344,29 +344,26 @@ static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 
 	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
 	if (sent < 0) {
+		/* If ndo_xdp_xmit fails with an errno, no frames have
+		 * been xmit'ed.
+		 */
 		err = sent;
 		sent = 0;
-		goto error;
 	}
+
 	drops = bq->count - sent;
-out:
-	bq->count = 0;
+	if (unlikely(drops > 0)) {
+		/* If not all frames have been transmitted, it is our
+		 * responsibility to free them
+		 */
+		for (i = sent; i < bq->count; i++)
+			xdp_return_frame_rx_napi(bq->q[i]);
+	}
 
+	bq->count = 0;
 	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
 	bq->dev_rx = NULL;
 	__list_del_clearprev(&bq->flush_node);
-	return;
-error:
-	/* If ndo_xdp_xmit fails with an errno, no frames have been
-	 * xmit'ed and it's our responsibility to them free all.
-	 */
-	for (i = 0; i < bq->count; i++) {
-		struct xdp_frame *xdpf = bq->q[i];
-
-		xdp_return_frame_rx_napi(xdpf);
-		drops++;
-	}
-	goto out;
 }
 
 /* __dev_flush is called from xdp_do_flush() which _must_ be signaled
-- 
2.29.2

