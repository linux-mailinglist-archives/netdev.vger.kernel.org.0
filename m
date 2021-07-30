Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878353DB873
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 14:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbhG3MQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 08:16:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230350AbhG3MQt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 08:16:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13D8361057;
        Fri, 30 Jul 2021 12:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627647404;
        bh=pTMZZqemx+Fyjde1qOP0j/hlEPsMgoeVfnOx61G/VbU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d6DFxDhZ3UyrtglKUDq1+KvfXECMqI0NZ0vRISO3fH7EeQXdEdDyj5JY/yoTXhxjX
         GxZXXu5wSYBq9BegfKnvtrtVkdIuTOa+TTPFCNkoHs1H1mTMiNsWhgzxHyOrEn7YNE
         sQJJWKXqgnucGVeBsRkMyMHtse49JYLkO2oSMwldPRvERmPoDmT8cjNatp+R0xcQW8
         d2nxYgu+sy1zn3xIGyE9uMUH3e4xBeHZyaPwxPfe71V7MN7nxSL7Iu101NFnWj7hXG
         CUv8WREPDbuqRLyJ4krQWfu18/KLEf4Wx4qcpFcgF2/XJ0/+NP9snMpb6A1BIplrNT
         S/96kUvSr8ACg==
Date:   Fri, 30 Jul 2021 05:16:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] virtio-net: fix for build_skb()
Message-ID: <20210730051643.54198a9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210601070610-mutt-send-email-mst@kernel.org>
References: <20210601064000.66909-1-xuanzhuo@linux.alibaba.com>
        <20210601070610-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021 07:06:43 -0400 Michael S. Tsirkin wrote:
> On Tue, Jun 01, 2021 at 02:39:58PM +0800, Xuan Zhuo wrote:
> > #1 Fixed a serious error.
> > #2 Fixed a logical error, but this error did not cause any serious consequences.
> > 
> > The logic of this piece is really messy. Fortunately, my refactored patch can be
> > completed with a small amount of testing.  
> 
> Looks good, thanks!
> Also needed for stable I think.
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Just a heads up folks, looks like we ended up merging both this and the
net-next version of the patch set:

8fb7da9e9907 virtio_net: get build_skb() buf by data ptr
5c37711d9f27 virtio-net: fix for unable to handle page fault for address

and

7bf64460e3b2 virtio-net: get build_skb() buf by data ptr
6c66c147b9a4 virtio-net: fix for unable to handle page fault for address

Are you okay with the code as is or should we commit something like:

---

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
