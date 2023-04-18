Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD72E6E59D0
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 08:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbjDRGxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 02:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjDRGxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 02:53:39 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386A911D;
        Mon, 17 Apr 2023 23:53:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VgOIH5c_1681800812;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgOIH5c_1681800812)
          by smtp.aliyun-inc.com;
          Tue, 18 Apr 2023 14:53:33 +0800
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
Subject: [PATCH net-next v2 05/14] virtio_net: introduce xdp res enums
Date:   Tue, 18 Apr 2023 14:53:18 +0800
Message-Id: <20230418065327.72281-6-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d931ac25730a
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,URIBL_BLOCKED,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtnet_xdp_handler() is to process all the logic related to XDP. The
caller only needs to care about how to deal with the buf. So this commit
introduces new enums:

1. VIRTNET_XDP_RES_PASS: make skb by the buf
2. VIRTNET_XDP_RES_DROP: xdp return drop action or some error, caller
   should release the buf
3. VIRTNET_XDP_RES_CONSUMED: xdp consumed the buf, the caller doesnot to
   do anything

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0fa64c314ea7..4dfdc211d355 100644
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
 
@@ -803,14 +812,14 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
 
 	switch (act) {
 	case XDP_PASS:
-		return act;
+		return VIRTNET_XDP_RES_PASS;
 
 	case XDP_TX:
 		stats->xdp_tx++;
 		xdpf = xdp_convert_buff_to_frame(xdp);
 		if (unlikely(!xdpf)) {
 			netdev_dbg(dev, "convert buff to frame failed for xdp\n");
-			return XDP_DROP;
+			return VIRTNET_XDP_RES_DROP;
 		}
 
 		err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
@@ -818,19 +827,20 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
 			xdp_return_frame_rx_napi(xdpf);
 		} else if (unlikely(err < 0)) {
 			trace_xdp_exception(dev, xdp_prog, act);
-			return XDP_DROP;
+			return VIRTNET_XDP_RES_DROP;
 		}
+
 		*xdp_xmit |= VIRTIO_XDP_TX;
-		return act;
+		return VIRTNET_XDP_RES_CONSUMED;
 
 	case XDP_REDIRECT:
 		stats->xdp_redirects++;
 		err = xdp_do_redirect(dev, xdp, xdp_prog);
 		if (err)
-			return XDP_DROP;
+			return VIRTNET_XDP_RES_DROP;
 
 		*xdp_xmit |= VIRTIO_XDP_REDIR;
-		return act;
+		return VIRTNET_XDP_RES_CONSUMED;
 
 	default:
 		bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
@@ -839,7 +849,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
 		trace_xdp_exception(dev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-		return XDP_DROP;
+		return VIRTNET_XDP_RES_DROP;
 	}
 }
 
@@ -987,17 +997,18 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
 
 		switch (act) {
-		case XDP_PASS:
+		case VIRTNET_XDP_RES_PASS:
 			/* Recalculate length in case bpf program changed it */
 			delta = orig_data - xdp.data;
 			len = xdp.data_end - xdp.data;
 			metasize = xdp.data - xdp.data_meta;
 			break;
-		case XDP_TX:
-		case XDP_REDIRECT:
+
+		case VIRTNET_XDP_RES_CONSUMED:
 			rcu_read_unlock();
 			goto xdp_xmit;
-		default:
+
+		case VIRTNET_XDP_RES_DROP:
 			goto err_xdp;
 		}
 	}
@@ -1324,18 +1335,19 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
 
 		switch (act) {
-		case XDP_PASS:
+		case VIRTNET_XDP_RES_PASS:
 			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
 			if (unlikely(!head_skb))
 				goto err_xdp_frags;
 
 			rcu_read_unlock();
 			return head_skb;
-		case XDP_TX:
-		case XDP_REDIRECT:
+
+		case VIRTNET_XDP_RES_CONSUMED:
 			rcu_read_unlock();
 			goto xdp_xmit;
-		default:
+
+		case VIRTNET_XDP_RES_DROP:
 			break;
 		}
 err_xdp_frags:
-- 
2.32.0.3.g01195cf9f

