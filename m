Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF966827C1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 09:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjAaIz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 03:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjAaIzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 03:55:39 -0500
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE274B493;
        Tue, 31 Jan 2023 00:50:50 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VaW9vg9_1675155005;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VaW9vg9_1675155005)
          by smtp.aliyun-inc.com;
          Tue, 31 Jan 2023 16:50:05 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH net-next v2] virtio-net: fix possible unsigned integer overflow
Date:   Tue, 31 Jan 2023 16:50:04 +0800
Message-Id: <20230131085004.98687-1-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the single-buffer xdp is loaded and after xdp_linearize_page()
is called, *num_buf becomes 0 and (*num_buf - 1) may overflow into
a large integer in virtnet_build_xdp_buff_mrg(), resulting in
unexpected packet dropping.

Fixes: ef75cb51f139 ("virtio-net: build xdp_buff with multi buffers")
Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
v1->v2:
- Change the type of num_buf from unsigned int to int. @Michael S . Tsirkin
- Some cleaner codes. @Michael S . Tsirkin

 drivers/net/virtio_net.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index aaa6fe9b214a..8102861785a2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -716,7 +716,7 @@ static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
  * have enough headroom.
  */
 static struct page *xdp_linearize_page(struct receive_queue *rq,
-				       u16 *num_buf,
+				       int *num_buf,
 				       struct page *p,
 				       int offset,
 				       int page_off,
@@ -816,7 +816,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
 			int offset = buf - page_address(page) + header_offset;
 			unsigned int tlen = len + vi->hdr_len;
-			u16 num_buf = 1;
+			int num_buf = 1;
 
 			xdp_headroom = virtnet_get_headroom(vi);
 			header_offset = VIRTNET_RX_PAD + xdp_headroom;
@@ -989,7 +989,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 				      void *buf,
 				      unsigned int len,
 				      unsigned int frame_sz,
-				      u16 *num_buf,
+				      int *num_buf,
 				      unsigned int *xdp_frags_truesize,
 				      struct virtnet_rq_stats *stats)
 {
@@ -1007,6 +1007,9 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 	xdp_prepare_buff(xdp, buf - VIRTIO_XDP_HEADROOM,
 			 VIRTIO_XDP_HEADROOM + vi->hdr_len, len - vi->hdr_len, true);
 
+	if (!*num_buf)
+		return 0;
+
 	if (*num_buf > 1) {
 		/* If we want to build multi-buffer xdp, we need
 		 * to specify that the flags of xdp_buff have the
@@ -1020,10 +1023,10 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
 		shinfo->xdp_frags_size = 0;
 	}
 
-	if ((*num_buf - 1) > MAX_SKB_FRAGS)
+	if (*num_buf > MAX_SKB_FRAGS + 1)
 		return -EINVAL;
 
-	while ((--*num_buf) >= 1) {
+	while (--*num_buf > 0) {
 		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
 		if (unlikely(!buf)) {
 			pr_debug("%s: rx error: %d buffers out of %d missing\n",
@@ -1076,7 +1079,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 					 struct virtnet_rq_stats *stats)
 {
 	struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
-	u16 num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
+	int num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
 	struct page *page = virt_to_head_page(buf);
 	int offset = buf - page_address(page);
 	struct sk_buff *head_skb, *curr_skb;
-- 
2.19.1.6.gb485710b

