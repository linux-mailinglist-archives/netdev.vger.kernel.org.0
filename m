Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BF32EFD32
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 03:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbhAICvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 21:51:07 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:49369 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbhAICvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 21:51:06 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 23A681817;
        Fri,  8 Jan 2021 21:50:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 08 Jan 2021 21:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=8O6tkM6rLdkMy31cMVWWi4mIxbdNRVOljnwEZqG8mtE=; b=P0EnEub4
        69bkbVHIeZf3/xjJo8GZFVS2qt6ZfCk5dGrBnajHxhZxesGt880K7QoDpTgp/aEy
        SLWXTVpZCUfW38KCiqPbt2Ie/+Y5H2mOsENqbl1L7OlAde2gS+2aJA+3SfFyMsft
        v6dVClt3dW7MGFmuu1xtbT6ZBy6jQvAyAK5ciHLfpbpTZe7GJsolzBLjfnTi9iF+
        LrPdvw2undP+L0OS/vLsVVJzwVMQhATQjc8s4i0Puh5aRwspdBybtoP3KFmPS5dM
        jFyGRyEx1YiKTGW8DmGWwLQ9mzVtpcKiAHbzV7LV5vjk+v3WNhmyU1hhFpAbGAMn
        bwZNVTTvX3mgig==
X-ME-Sender: <xms:7Bn5X9c-TmR5pIE0cd5FAumxNvzbKCDN1cWe4dWwSouNDqWdwEOQWg>
    <xme:7Bn5X7MH8KnaqZHOyx662Rk8SfHyOSDEZiyFDGuY3aOq-GCSo-GUGFpz3AyFyCt4g
    gc3mppPVBO7HtCDeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeghedgudegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeevhhgrrhhlihgvucfuohhmvghrvhhilhhlvgcuoegthhgr
    rhhlihgvsegthhgrrhhlihgvrdgsiieqnecuggftrfgrthhtvghrnhepkedtleduudehhe
    dvfeehvefgvdehffdvveeftdevhfejfffhteelffevueduteeunecukfhppedvtddvrddu
    heefrddvvddtrdejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegthhgrrhhlihgvsegthhgrrhhlihgvrdgsii
X-ME-Proxy: <xmx:7Bn5X2hxgkyAx9PXEG07PFaIIOqxJ4bdRyoLxcQAmwZ-BlVnK8fAKw>
    <xmx:7Bn5X28lMcboUSd2SasRC5YPW5IEhKs96hr6RW6-qcVyPS5qcsoNNg>
    <xmx:7Bn5X5tuJoujmAQP4QhXIjcsn_dxEp-GSslN9hjMjRVgSWOqA7CYQg>
    <xmx:7Bn5XxJ1v1oQDJKTvbMTSuWN_i6gvAFcBqWDxQrBcvzuxBFbMuOWfA>
Received: from charlie-arch.home.charlie.bz (202-153-220-71.ca99dc.mel.static.aussiebb.net [202.153.220.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id DAE4924005D;
        Fri,  8 Jan 2021 21:50:18 -0500 (EST)
From:   Charlie Somerville <charlie@charlie.bz>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com
Cc:     netdev@vger.kernel.org, Charlie Somerville <charlie@charlie.bz>
Subject: [PATCH net-next 2/2] virtio_net: Implement XDP_FLAGS_NO_TX support
Date:   Sat,  9 Jan 2021 13:49:50 +1100
Message-Id: <20210109024950.4043819-3-charlie@charlie.bz>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109024950.4043819-1-charlie@charlie.bz>
References: <20210109024950.4043819-1-charlie@charlie.bz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No send queues will be allocated for XDP filters. Attempts to transmit
packets when no XDP send queues exist will fail with EOPNOTSUPP.

Signed-off-by: Charlie Somerville <charlie@charlie.bz>
---
 drivers/net/virtio_net.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 508408fbe78f..ed08998765e0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -485,6 +485,10 @@ static struct send_queue *virtnet_xdp_sq(struct virtnet_info *vi)
 {
 	unsigned int qp;
 
+	/* If no queue pairs are allocated for XDP use, return NULL */
+	if (vi->xdp_queue_pairs == 0)
+		return NULL;
+
 	qp = vi->curr_queue_pairs - vi->xdp_queue_pairs + smp_processor_id();
 	return &vi->sq[qp];
 }
@@ -514,6 +518,11 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 
 	sq = virtnet_xdp_sq(vi);
 
+	/* No send queue exists if program was attached with XDP_NO_TX */
+	if (unlikely(!sq)) {
+		return -EOPNOTSUPP;
+	}
+
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
 		ret = -EINVAL;
 		drops = n;
@@ -1464,7 +1473,7 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 
 	if (xdp_xmit & VIRTIO_XDP_TX) {
 		sq = virtnet_xdp_sq(vi);
-		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
+		if (sq && virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
 			u64_stats_update_begin(&sq->stats.syncp);
 			sq->stats.kicks++;
 			u64_stats_update_end(&sq->stats.syncp);
@@ -2388,7 +2397,7 @@ static int virtnet_restore_guest_offloads(struct virtnet_info *vi)
 }
 
 static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
-			   struct netlink_ext_ack *extack)
+			   struct netlink_ext_ack *extack, u32 flags)
 {
 	unsigned long int max_sz = PAGE_SIZE - sizeof(struct padded_vnet_hdr);
 	struct virtnet_info *vi = netdev_priv(dev);
@@ -2418,7 +2427,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	}
 
 	curr_qp = vi->curr_queue_pairs - vi->xdp_queue_pairs;
-	if (prog)
+	if (prog && !(flags & XDP_FLAGS_NO_TX))
 		xdp_qp = nr_cpu_ids;
 
 	/* XDP requires extra queues for XDP_TX */
@@ -2502,7 +2511,7 @@ static int virtnet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 {
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
-		return virtnet_xdp_set(dev, xdp->prog, xdp->extack);
+		return virtnet_xdp_set(dev, xdp->prog, xdp->extack, xdp->flags);
 	default:
 		return -EINVAL;
 	}
-- 
2.30.0

