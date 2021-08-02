Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9063DDECF
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhHBR5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhHBR5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 13:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A223760243;
        Mon,  2 Aug 2021 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627927060;
        bh=5T0HCKLZyhrW7YHupQ3Lg50yrpe8R6p/IufbvTsxsXY=;
        h=From:To:Cc:Subject:Date:From;
        b=o+v/X7x1496rci3PQ8k8ebD0GZnGZ9Dkf8+el36yiH3oI6r9pMoWOpeBbya1K1+g8
         +UEbxWSuZdh/r9Bme7BAkXDM4frIQB3SWduglLfULuc087lnvqr8bZ6io+sJEkjkPE
         b7uAyEzUQaD/Sj/yDMhKj2++GECaZcSbSWVBn6lYN9beP5WcDlknnVJapBzxCLUrrc
         f+d8ZlfYV80DGaTP1385sb/MuPVAN7bktvCSWr3YoFwLpvJSzQHzYGJNYmzeTpaN/U
         eL/rmquC4BkYn+EJbqiOnxnERfTDZo+n3iXNGg4FBfcLAdqyiFjtkNGiDdQNp7rDSB
         MolKpr6Hm3PmA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        xuanzhuo@linux.alibaba.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] virtio-net: realign page_to_skb() after merges
Date:   Mon,  2 Aug 2021 10:57:29 -0700
Message-Id: <20210802175729.2042133-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We ended up merging two versions of the same patch set:

commit 8fb7da9e9907 ("virtio_net: get build_skb() buf by data ptr")
commit 5c37711d9f27 ("virtio-net: fix for unable to handle page fault for address")

into net, and

commit 7bf64460e3b2 ("virtio-net: get build_skb() buf by data ptr")
commit 6c66c147b9a4 ("virtio-net: fix for unable to handle page fault for address")

into net-next. Redo the merge from commit 126285651b7f ("Merge
ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net"), so that
the most recent code remains.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/virtio_net.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 56c3f8519093..74482a52f076 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -380,7 +380,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct page *page, unsigned int offset,
 				   unsigned int len, unsigned int truesize,
 				   bool hdr_valid, unsigned int metasize,
-				   bool whole_page)
+				   unsigned int headroom)
 {
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
@@ -398,28 +398,16 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
-	/* If whole_page, there is an offset between the beginning of the
+	/* If headroom is not 0, there is an offset between the beginning of the
 	 * data and the allocated space, otherwise the data and the allocated
 	 * space are aligned.
 	 *
 	 * Buffers with headroom use PAGE_SIZE as alloc size, see
 	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
 	 */
-	if (whole_page) {
-		/* Buffers with whole_page use PAGE_SIZE as alloc size,
-		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
-		 */
-		truesize = PAGE_SIZE;
-
-		/* page maybe head page, so we should get the buf by p, not the
-		 * page
-		 */
-		tailroom = truesize - len - offset_in_page(p);
-		buf = (char *)((unsigned long)p & PAGE_MASK);
-	} else {
-		tailroom = truesize - len;
-		buf = p;
-	}
+	truesize = headroom ? PAGE_SIZE : truesize;
+	tailroom = truesize - len - headroom;
+	buf = p - headroom;
 
 	len -= hdr_len;
 	offset += hdr_padded_len;
@@ -978,7 +966,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 				put_page(page);
 				head_skb = page_to_skb(vi, rq, xdp_page, offset,
 						       len, PAGE_SIZE, false,
-						       metasize, true);
+						       metasize,
+						       VIRTIO_XDP_HEADROOM);
 				return head_skb;
 			}
 			break;
@@ -1029,7 +1018,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	rcu_read_unlock();
 
 	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
-			       metasize, !!headroom);
+			       metasize, headroom);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.31.1

