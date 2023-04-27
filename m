Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B96B6EFF83
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242859AbjD0DFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242863AbjD0DFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:05:43 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6193AB0;
        Wed, 26 Apr 2023 20:05:41 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vh5XEpn_1682564737;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vh5XEpn_1682564737)
          by smtp.aliyun-inc.com;
          Thu, 27 Apr 2023 11:05:38 +0800
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
Subject: [PATCH net-next v4 03/15] virtio_net: optimize mergeable_xdp_get_buf()
Date:   Thu, 27 Apr 2023 11:05:22 +0800
Message-Id: <20230427030534.115066-4-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230427030534.115066-1-xuanzhuo@linux.alibaba.com>
References: <20230427030534.115066-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 69b1082fef22
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index b8832b0cc215..6f66d73097b4 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1192,6 +1192,11 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
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
@@ -1200,22 +1205,15 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
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
@@ -1227,14 +1225,15 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
 
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

