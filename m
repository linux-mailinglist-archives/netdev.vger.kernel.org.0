Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C0D6C40B9
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 04:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjCVDD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 23:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCVDDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 23:03:17 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBE311647;
        Tue, 21 Mar 2023 20:03:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VeP3pzv_1679454191;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VeP3pzv_1679454191)
          by smtp.aliyun-inc.com;
          Wed, 22 Mar 2023 11:03:12 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH net-next 3/8] virtio_net: introduce virtnet_xdp_handler() to seprate the logic of run xdp
Date:   Wed, 22 Mar 2023 11:03:03 +0800
Message-Id: <20230322030308.16046-4-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
References: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 7e9e1372f356
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present, we have two similar logic to perform the XDP prog.

Therefore, this PATCH separates the code of executing XDP, which is
conducive to later maintenance.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 142 +++++++++++++++++++++------------------
 1 file changed, 75 insertions(+), 67 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index bb426958cdd4..72b9d6ee4024 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -301,6 +301,15 @@ struct padded_vnet_hdr {
 	char padding[12];
 };
 
+enum {
+	/* xdp pass */
+	VIRTNET_XDP_RES_PASS,
+	/* drop packet. the caller needs to release the page. */
+	VIRTNET_XDP_RES_DROP,
+	/* packet is consumed by xdp. the caller needs to do nothing. */
+	VIRTNET_XDP_RES_CONSUMED,
+};
+
 static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
 static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
 
@@ -789,6 +798,59 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	return ret;
 }
 
+static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
+			       struct net_device *dev,
+			       unsigned int *xdp_xmit,
+			       struct virtnet_rq_stats *stats)
+{
+	struct xdp_frame *xdpf;
+	int err;
+	u32 act;
+
+	act = bpf_prog_run_xdp(xdp_prog, xdp);
+	stats->xdp_packets++;
+
+	switch (act) {
+	case XDP_PASS:
+		return VIRTNET_XDP_RES_PASS;
+
+	case XDP_TX:
+		stats->xdp_tx++;
+		xdpf = xdp_convert_buff_to_frame(xdp);
+		if (unlikely(!xdpf))
+			return VIRTNET_XDP_RES_DROP;
+
+		err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
+		if (unlikely(!err)) {
+			xdp_return_frame_rx_napi(xdpf);
+		} else if (unlikely(err < 0)) {
+			trace_xdp_exception(dev, xdp_prog, act);
+			return VIRTNET_XDP_RES_DROP;
+		}
+
+		*xdp_xmit |= VIRTIO_XDP_TX;
+		return VIRTNET_XDP_RES_CONSUMED;
+
+	case XDP_REDIRECT:
+		stats->xdp_redirects++;
+		err = xdp_do_redirect(dev, xdp, xdp_prog);
+		if (err)
+			return VIRTNET_XDP_RES_DROP;
+
+		*xdp_xmit |= VIRTIO_XDP_REDIR;
+		return VIRTNET_XDP_RES_CONSUMED;
+
+	default:
+		bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(dev, xdp_prog, act);
+		fallthrough;
+	case XDP_DROP:
+		return VIRTNET_XDP_RES_DROP;
+	}
+}
+
 static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
 {
 	return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
@@ -876,7 +938,6 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	struct page *page = virt_to_head_page(buf);
 	unsigned int delta = 0;
 	struct page *xdp_page;
-	int err;
 	unsigned int metasize = 0;
 
 	len -= vi->hdr_len;
@@ -898,7 +959,6 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
 		struct virtio_net_hdr_mrg_rxbuf *hdr = buf + header_offset;
-		struct xdp_frame *xdpf;
 		struct xdp_buff xdp;
 		void *orig_data;
 		u32 act;
@@ -931,46 +991,22 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len,
 				 xdp_headroom, len, true);
 		orig_data = xdp.data;
-		act = bpf_prog_run_xdp(xdp_prog, &xdp);
-		stats->xdp_packets++;
+
+		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
 
 		switch (act) {
-		case XDP_PASS:
+		case VIRTNET_XDP_RES_PASS:
 			/* Recalculate length in case bpf program changed it */
 			delta = orig_data - xdp.data;
 			len = xdp.data_end - xdp.data;
 			metasize = xdp.data - xdp.data_meta;
 			break;
-		case XDP_TX:
-			stats->xdp_tx++;
-			xdpf = xdp_convert_buff_to_frame(&xdp);
-			if (unlikely(!xdpf))
-				goto err_xdp;
-			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
-			if (unlikely(!err)) {
-				xdp_return_frame_rx_napi(xdpf);
-			} else if (unlikely(err < 0)) {
-				trace_xdp_exception(vi->dev, xdp_prog, act);
-				goto err_xdp;
-			}
-			*xdp_xmit |= VIRTIO_XDP_TX;
-			rcu_read_unlock();
-			goto xdp_xmit;
-		case XDP_REDIRECT:
-			stats->xdp_redirects++;
-			err = xdp_do_redirect(dev, &xdp, xdp_prog);
-			if (err)
-				goto err_xdp;
-			*xdp_xmit |= VIRTIO_XDP_REDIR;
+
+		case VIRTNET_XDP_RES_CONSUMED:
 			rcu_read_unlock();
 			goto xdp_xmit;
-		default:
-			bpf_warn_invalid_xdp_action(vi->dev, xdp_prog, act);
-			fallthrough;
-		case XDP_ABORTED:
-			trace_xdp_exception(vi->dev, xdp_prog, act);
-			goto err_xdp;
-		case XDP_DROP:
+
+		case VIRTNET_XDP_RES_DROP:
 			goto err_xdp;
 		}
 	}
@@ -1277,7 +1313,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	if (xdp_prog) {
 		unsigned int xdp_frags_truesz = 0;
 		struct skb_shared_info *shinfo;
-		struct xdp_frame *xdpf;
 		struct page *xdp_page;
 		struct xdp_buff xdp;
 		void *data;
@@ -1294,49 +1329,22 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		if (unlikely(err))
 			goto err_xdp_frags;
 
-		act = bpf_prog_run_xdp(xdp_prog, &xdp);
-		stats->xdp_packets++;
+		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
 
 		switch (act) {
-		case XDP_PASS:
+		case VIRTNET_XDP_RES_PASS:
 			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
 			if (unlikely(!head_skb))
 				goto err_xdp_frags;
 
 			rcu_read_unlock();
 			return head_skb;
-		case XDP_TX:
-			stats->xdp_tx++;
-			xdpf = xdp_convert_buff_to_frame(&xdp);
-			if (unlikely(!xdpf)) {
-				netdev_dbg(dev, "convert buff to frame failed for xdp\n");
-				goto err_xdp_frags;
-			}
-			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
-			if (unlikely(!err)) {
-				xdp_return_frame_rx_napi(xdpf);
-			} else if (unlikely(err < 0)) {
-				trace_xdp_exception(vi->dev, xdp_prog, act);
-				goto err_xdp_frags;
-			}
-			*xdp_xmit |= VIRTIO_XDP_TX;
-			rcu_read_unlock();
-			goto xdp_xmit;
-		case XDP_REDIRECT:
-			stats->xdp_redirects++;
-			err = xdp_do_redirect(dev, &xdp, xdp_prog);
-			if (err)
-				goto err_xdp_frags;
-			*xdp_xmit |= VIRTIO_XDP_REDIR;
+
+		case VIRTNET_XDP_RES_CONSUMED:
 			rcu_read_unlock();
 			goto xdp_xmit;
-		default:
-			bpf_warn_invalid_xdp_action(vi->dev, xdp_prog, act);
-			fallthrough;
-		case XDP_ABORTED:
-			trace_xdp_exception(vi->dev, xdp_prog, act);
-			fallthrough;
-		case XDP_DROP:
+
+		case VIRTNET_XDP_RES_DROP:
 			goto err_xdp_frags;
 		}
 err_xdp_frags:
-- 
2.32.0.3.g01195cf9f

