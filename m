Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D14966AA1D
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 09:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjANIWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 03:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjANIWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 03:22:46 -0500
Received: from out30-7.freemail.mail.aliyun.com (out30-7.freemail.mail.aliyun.com [115.124.30.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBC14EF8;
        Sat, 14 Jan 2023 00:22:40 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VZX.hpk_1673684556;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VZX.hpk_1673684556)
          by smtp.aliyun-inc.com;
          Sat, 14 Jan 2023 16:22:37 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH net-next v5 06/10] virtio-net: construct multi-buffer xdp in mergeable
Date:   Sat, 14 Jan 2023 16:22:25 +0800
Message-Id: <20230114082229.62143-7-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230114082229.62143-1-hengqi@linux.alibaba.com>
References: <20230114082229.62143-1-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build multi-buffer xdp using virtnet_build_xdp_buff_mrg().

For the prefilled buffer before xdp is set, we will probably use
vq reset in the future. At the same time, virtio net currently
uses comp pages, and bpf_xdp_frags_increase_tail() needs to calculate
the tailroom of the last frag, which will involve the offset of the
corresponding page and cause a negative value, so we disable tail
increase by not setting xdp_rxq->frag_size.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 58 ++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 699e376b8f8b..ab01cf3855bc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1036,7 +1036,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	unsigned int metasize = 0;
 	unsigned int tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
 	unsigned int room = SKB_DATA_ALIGN(headroom + tailroom);
-	unsigned int frame_sz;
+	unsigned int frame_sz, xdp_room;
 	int err;
 
 	head_skb = NULL;
@@ -1057,11 +1057,14 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	rcu_read_lock();
 	xdp_prog = rcu_dereference(rq->xdp_prog);
 	if (xdp_prog) {
+		unsigned int xdp_frags_truesz = 0;
+		struct skb_shared_info *shinfo;
 		struct xdp_frame *xdpf;
 		struct page *xdp_page;
 		struct xdp_buff xdp;
 		void *data;
 		u32 act;
+		int i;
 
 		/* Transient failure which in theory could occur if
 		 * in-flight packets from before XDP was enabled reach
@@ -1077,14 +1080,16 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		 */
 		frame_sz = truesize;
 
-		/* This happens when rx buffer size is underestimated
-		 * or headroom is not enough because of the buffer
-		 * was refilled before XDP is set. This should only
-		 * happen for the first several packets, so we don't
-		 * care much about its performance.
+		/* This happens when headroom is not enough because
+		 * of the buffer was prefilled before XDP is set.
+		 * This should only happen for the first several packets.
+		 * In fact, vq reset can be used here to help us clean up
+		 * the prefilled buffers, but many existing devices do not
+		 * support it, and we don't want to bother users who are
+		 * using xdp normally.
 		 */
-		if (unlikely(num_buf > 1 ||
-			     headroom < virtnet_get_headroom(vi))) {
+		if (!xdp_prog->aux->xdp_has_frags &&
+		    (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
 			/* linearize data for XDP */
 			xdp_page = xdp_linearize_page(rq, &num_buf,
 						      page, offset,
@@ -1095,17 +1100,29 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			if (!xdp_page)
 				goto err_xdp;
 			offset = VIRTIO_XDP_HEADROOM;
+		} else if (unlikely(headroom < virtnet_get_headroom(vi))) {
+			xdp_room = SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
+						  sizeof(struct skb_shared_info));
+			if (len + xdp_room > PAGE_SIZE)
+				goto err_xdp;
+
+			xdp_page = alloc_page(GFP_ATOMIC);
+			if (!xdp_page)
+				goto err_xdp;
+
+			memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
+			       page_address(page) + offset, len);
+			frame_sz = PAGE_SIZE;
+			offset = VIRTIO_XDP_HEADROOM;
 		} else {
 			xdp_page = page;
 		}
 
-		/* Allow consuming headroom but reserve enough space to push
-		 * the descriptor on if we get an XDP_TX return code.
-		 */
 		data = page_address(xdp_page) + offset;
-		xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_rxq);
-		xdp_prepare_buff(&xdp, data - VIRTIO_XDP_HEADROOM + vi->hdr_len,
-				 VIRTIO_XDP_HEADROOM, len - vi->hdr_len, true);
+		err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame_sz,
+						 &num_buf, &xdp_frags_truesz, stats);
+		if (unlikely(err))
+			goto err_xdp_frags;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
@@ -1201,6 +1218,19 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 				__free_pages(xdp_page, 0);
 			goto err_xdp;
 		}
+err_xdp_frags:
+		if (unlikely(xdp_page != page))
+			__free_pages(xdp_page, 0);
+
+		if (xdp_buff_has_frags(&xdp)) {
+			shinfo = xdp_get_shared_info_from_buff(&xdp);
+			for (i = 0; i < shinfo->nr_frags; i++) {
+				xdp_page = skb_frag_page(&shinfo->frags[i]);
+				put_page(xdp_page);
+			}
+		}
+
+		goto err_xdp;
 	}
 	rcu_read_unlock();
 
-- 
2.19.1.6.gb485710b

