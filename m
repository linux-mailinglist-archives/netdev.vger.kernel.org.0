Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AB96BA5EF
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 05:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjCOEK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 00:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjCOEKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 00:10:53 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFADF4A1FB;
        Tue, 14 Mar 2023 21:10:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vdui0Om_1678853444;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vdui0Om_1678853444)
          by smtp.aliyun-inc.com;
          Wed, 15 Mar 2023 12:10:44 +0800
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
Subject: [RFC net-next 1/8] virtio_net: mergeable xdp: put old page immediately
Date:   Wed, 15 Mar 2023 12:10:35 +0800
Message-Id: <20230315041042.88138-2-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230315041042.88138-1-xuanzhuo@linux.alibaba.com>
References: <20230315041042.88138-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: a046238c058f
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the xdp implementation of virtio-net mergeable, it always checks
whether two page is used and a page is selected to release. This is
complicated for the processing of action, and be careful.

In the entire process, we have such principles:
* If xdp_page is used (PASS, TX, Redirect), then we release the old
  page.
* If it is a drop case, we will release two. The old page obtained from
  buf is release inside err_xdp, and xdp_page needs be relased by us.

But in fact, when we allocate a new page, we can release the old page
immediately. Then just one is using, we just need to release the new
page for drop case. On the drop path, err_xdp will release the variable
"page", so we only need to let "page" point to the new xdp_page in
advance.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 6e88c023cdcc..36be30319660 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1175,6 +1175,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			if (!xdp_page)
 				goto err_xdp;
 			offset = VIRTIO_XDP_HEADROOM;
+
+			put_page(page);
+			page = xdp_page;
 		} else if (unlikely(headroom < virtnet_get_headroom(vi))) {
 			xdp_room = SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
 						  sizeof(struct skb_shared_info));
@@ -1189,6 +1192,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			       page_address(page) + offset, len);
 			frame_sz = PAGE_SIZE;
 			offset = VIRTIO_XDP_HEADROOM;
+
+			put_page(page);
+			page = xdp_page;
 		} else {
 			xdp_page = page;
 		}
@@ -1208,8 +1214,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			if (unlikely(!head_skb))
 				goto err_xdp_frags;
 
-			if (unlikely(xdp_page != page))
-				put_page(page);
 			rcu_read_unlock();
 			return head_skb;
 		case XDP_TX:
@@ -1227,8 +1231,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 				goto err_xdp_frags;
 			}
 			*xdp_xmit |= VIRTIO_XDP_TX;
-			if (unlikely(xdp_page != page))
-				put_page(page);
 			rcu_read_unlock();
 			goto xdp_xmit;
 		case XDP_REDIRECT:
@@ -1237,8 +1239,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			if (err)
 				goto err_xdp_frags;
 			*xdp_xmit |= VIRTIO_XDP_REDIR;
-			if (unlikely(xdp_page != page))
-				put_page(page);
 			rcu_read_unlock();
 			goto xdp_xmit;
 		default:
@@ -1251,9 +1251,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			goto err_xdp_frags;
 		}
 err_xdp_frags:
-		if (unlikely(xdp_page != page))
-			__free_pages(xdp_page, 0);
-
 		if (xdp_buff_has_frags(&xdp)) {
 			shinfo = xdp_get_shared_info_from_buff(&xdp);
 			for (i = 0; i < shinfo->nr_frags; i++) {
-- 
2.32.0.3.g01195cf9f

