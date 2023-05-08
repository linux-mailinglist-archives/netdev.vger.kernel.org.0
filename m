Return-Path: <netdev+bounces-791-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FAFC6F9F92
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E3C0280F14
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0983015496;
	Mon,  8 May 2023 06:14:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA96C1548C;
	Mon,  8 May 2023 06:14:26 +0000 (UTC)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4938B11542;
	Sun,  7 May 2023 23:14:25 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Vi.GnCb_1683526461;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vi.GnCb_1683526461)
          by smtp.aliyun-inc.com;
          Mon, 08 May 2023 14:14:22 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: netdev@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	virtualization@lists.linux-foundation.org,
	bpf@vger.kernel.org
Subject: [PATCH net-next v5 03/15] virtio_net: optimize mergeable_xdp_get_buf()
Date: Mon,  8 May 2023 14:14:05 +0800
Message-Id: <20230508061417.65297-4-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230508061417.65297-1-xuanzhuo@linux.alibaba.com>
References: <20230508061417.65297-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 847ebbc5df1e
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The previous patch, in order to facilitate review, I do not do any
modification. This patch has made some optimization on the top.

* remove some repeated logics in this function.
* add fast check for passing without any alloc.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a75745dfe2e1..3c3602982ea2 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1196,6 +1196,11 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 	 */
 	*frame_sz = truesize;
 
+	if (likely(headroom >= virtnet_get_headroom(vi) &&
+		   (*num_buf == 1 || xdp_prog->aux->xdp_has_frags))) {
+		return page_address(*page) + offset;
+	}
+
 	/* This happens when headroom is not enough because
 	 * of the buffer was prefilled before XDP is set.
 	 * This should only happen for the first several packets.
@@ -1204,22 +1209,15 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 	 * support it, and we don't want to bother users who are
 	 * using xdp normally.
 	 */
-	if (!xdp_prog->aux->xdp_has_frags &&
-	    (*num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
+	if (!xdp_prog->aux->xdp_has_frags) {
 		/* linearize data for XDP */
 		xdp_page = xdp_linearize_page(rq, num_buf,
 					      *page, offset,
 					      VIRTIO_XDP_HEADROOM,
 					      len);
-		*frame_sz = PAGE_SIZE;
-
 		if (!xdp_page)
 			return NULL;
-		offset = VIRTIO_XDP_HEADROOM;
-
-		put_page(*page);
-		*page = xdp_page;
-	} else if (unlikely(headroom < virtnet_get_headroom(vi))) {
+	} else {
 		xdp_room = SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
 					  sizeof(struct skb_shared_info));
 		if (*len + xdp_room > PAGE_SIZE)
@@ -1231,14 +1229,15 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 
 		memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
 		       page_address(*page) + offset, *len);
-		*frame_sz = PAGE_SIZE;
-		offset = VIRTIO_XDP_HEADROOM;
-
-		put_page(*page);
-		*page = xdp_page;
 	}
 
-	return page_address(*page) + offset;
+	*frame_sz = PAGE_SIZE;
+
+	put_page(*page);
+
+	*page = xdp_page;
+
+	return page_address(*page) + VIRTIO_XDP_HEADROOM;
 }
 
 static struct sk_buff *receive_mergeable(struct net_device *dev,
-- 
2.32.0.3.g01195cf9f


