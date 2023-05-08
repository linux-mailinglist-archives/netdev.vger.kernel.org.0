Return-Path: <netdev+bounces-797-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE2CB6F9FA3
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:18:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0018E1C20949
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C6713AE7;
	Mon,  8 May 2023 06:14:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3849171A0;
	Mon,  8 May 2023 06:14:33 +0000 (UTC)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3277211542;
	Sun,  7 May 2023 23:14:32 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Vi.GnHe_1683526468;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vi.GnHe_1683526468)
          by smtp.aliyun-inc.com;
          Mon, 08 May 2023 14:14:29 +0800
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
Subject: [PATCH net-next v5 09/15] virtio_net: merge: remove skip_xdp
Date: Mon,  8 May 2023 14:14:11 +0800
Message-Id: <20230508061417.65297-10-xuanzhuo@linux.alibaba.com>
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

Now, the logic of merge xdp process is simple, we can remove the
skip_xdp.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2bb759deb658..0baa6651dbb0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1382,7 +1382,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	struct page *page = virt_to_head_page(buf);
 	int offset = buf - page_address(page);
 	struct sk_buff *head_skb, *curr_skb;
-	struct bpf_prog *xdp_prog;
 	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
 	unsigned int tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
@@ -1398,22 +1397,20 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	if (likely(!vi->xdp_enabled)) {
-		xdp_prog = NULL;
-		goto skip_xdp;
-	}
+	if (unlikely(vi->xdp_enabled)) {
+		struct bpf_prog *xdp_prog;
 
-	rcu_read_lock();
-	xdp_prog = rcu_dereference(rq->xdp_prog);
-	if (xdp_prog) {
-		head_skb = receive_mergeable_xdp(dev, vi, rq, xdp_prog, buf, ctx,
-						 len, xdp_xmit, stats);
+		rcu_read_lock();
+		xdp_prog = rcu_dereference(rq->xdp_prog);
+		if (xdp_prog) {
+			head_skb = receive_mergeable_xdp(dev, vi, rq, xdp_prog, buf, ctx,
+							 len, xdp_xmit, stats);
+			rcu_read_unlock();
+			return head_skb;
+		}
 		rcu_read_unlock();
-		return head_skb;
 	}
-	rcu_read_unlock();
 
-skip_xdp:
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, headroom);
 	curr_skb = head_skb;
 
-- 
2.32.0.3.g01195cf9f


