Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E52B633611
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 08:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbiKVHoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 02:44:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbiKVHoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 02:44:02 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D606317CA;
        Mon, 21 Nov 2022 23:43:59 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVR5.Fl_1669103035;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VVR5.Fl_1669103035)
          by smtp.aliyun-inc.com;
          Tue, 22 Nov 2022 15:43:56 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC PATCH 5/9] virtio_net: build xdp_buff with multi buffers
Date:   Tue, 22 Nov 2022 15:43:44 +0800
Message-Id: <20221122074348.88601-6-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221122074348.88601-1-hengqi@linux.alibaba.com>
References: <20221122074348.88601-1-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support xdp for multi buffer packets.

Putting the first buffer as the linear part for xdp_buff,
and the rest of the buffers as non-linear fragments to struct
skb_shared_info in the tailroom belonging to xdp_buff.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 74 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index cd65f85d5075..20784b1d8236 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -911,6 +911,80 @@ static struct sk_buff *receive_big(struct net_device *dev,
 	return NULL;
 }
 
+static int virtnet_build_xdp_buff(struct net_device *dev,
+				  struct virtnet_info *vi,
+				  struct receive_queue *rq,
+				  struct xdp_buff *xdp,
+				  void *buf,
+				  unsigned int len,
+				  unsigned int frame_sz,
+				  u16 *num_buf,
+				  unsigned int *xdp_frags_truesize,
+				  struct virtnet_rq_stats *stats)
+{
+	unsigned int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
+	unsigned int truesize, headroom;
+	struct skb_shared_info *shinfo;
+	unsigned int xdp_frags_truesz = 0;
+	unsigned int cur_frag_size;
+	struct page *page;
+	skb_frag_t *frag;
+	int offset;
+	void *ctx;
+
+	xdp_init_buff(xdp, frame_sz, &rq->xdp_rxq);
+	xdp_prepare_buff(xdp, buf - VIRTIO_XDP_HEADROOM,
+			 VIRTIO_XDP_HEADROOM + vi->hdr_len, len - vi->hdr_len, true);
+	shinfo = xdp_get_shared_info_from_buff(xdp);
+	shinfo->nr_frags = 0;
+	shinfo->xdp_frags_size = 0;
+
+	if ((*num_buf - 1) > MAX_SKB_FRAGS)
+		return -EINVAL;
+
+	while ((--*num_buf) >= 1) {
+		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
+		if (unlikely(!buf)) {
+			pr_debug("%s: rx error: %d buffers out of %d missing\n",
+				 dev->name, *num_buf,
+				 virtio16_to_cpu(vi->vdev, hdr->num_buffers));
+			dev->stats.rx_length_errors++;
+			return -EINVAL;
+		}
+
+		if (!xdp_buff_has_frags(xdp))
+			xdp_buff_set_frags_flag(xdp);
+
+		stats->bytes += len;
+		page = virt_to_head_page(buf);
+		offset = buf - page_address(page);
+		truesize = mergeable_ctx_to_truesize(ctx);
+		headroom = mergeable_ctx_to_headroom(ctx);
+
+		cur_frag_size = truesize + (headroom ? (headroom + tailroom) : 0);
+		xdp_frags_truesz += cur_frag_size;
+		if (unlikely(len > truesize || cur_frag_size > PAGE_SIZE)) {
+			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
+				 dev->name, len, (unsigned long)ctx);
+			dev->stats.rx_length_errors++;
+			return -EINVAL;
+		}
+
+		frag = &shinfo->frags[shinfo->nr_frags++];
+		__skb_frag_set_page(frag, page);
+		skb_frag_off_set(frag, offset);
+		skb_frag_size_set(frag, len);
+		if (page_is_pfmemalloc(page))
+			xdp_buff_set_frag_pfmemalloc(xdp);
+
+		shinfo->xdp_frags_size += len;
+	}
+
+	*xdp_frags_truesize = xdp_frags_truesz;
+	return 0;
+}
+
 static struct sk_buff *receive_mergeable(struct net_device *dev,
 					 struct virtnet_info *vi,
 					 struct receive_queue *rq,
-- 
2.19.1.6.gb485710b

