Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BCF57DE2
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 10:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfF0IGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 04:06:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33992 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfF0IGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 04:06:53 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so830941pfc.1
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 01:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QEgyxlVekWnYGrB2+rXaZRvF6Od6LAR0sZBzwMqn7zY=;
        b=YLfiIJOZY/zPSQEffZ4cRGRfVXSqRdXALJLCCaAu7HS8tymq8xngMUaegWTKzPDIE3
         34jRrKtXBBOiPxW+3/9exRhhXryTVIwUEk3thcQITVdSbwAscq+VNB0noX9Yr1cT6Bo2
         BXC6MF0S1jJizAtcpwqqsOQ2kPLKqrtLF27JIQgXnxVtNuagPJKm+9EqzdXSn7VPKoQq
         1YUUNhuYh42n+BFXWpkYzOSHsWqOHnI4hnmAE8LiKgO+gq+hFynKU+NwcLbuyffAyXWt
         sGS92ql+g5ZdeTPSNzHaeRUiBxBgiUqSGlsopHsq4zb2Jc1jVw+sR2jsQ2G8ibYh91dp
         UiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QEgyxlVekWnYGrB2+rXaZRvF6Od6LAR0sZBzwMqn7zY=;
        b=r+BDuqBVDSVOU0SxPfG9BEZObHqKMM+SbnWTrCWKYujOZgJFvhzb1BE7/YlwtOpuoG
         nDrEaw6t7WxA8lMsv/Y5zfwFGmL0mb6RDQ0CmW9LORNktDS2/Gnn0G+JDUW5vKVVd5Gv
         Ibe/iZppgNlHEMXTy1MUeJNdw41nmFRv0QHLFSExuDMrNTv07FiVBfTWIoE4KblcdvoK
         epNTeUX5h7EGnB7XeZhQEPYamBxjRU/kHYgw0dZ8qXV0g+Vo9Jy7K7g29lVqjTZQv21a
         14haR52E/UNJg53AnH/E5InDO6sirWNrbNfRAe/QF2wgMZ8xR9x78zaRO08z5jkM1UM2
         pqTA==
X-Gm-Message-State: APjAAAWnFZJCdb5h2wTIYizBe5+Dflc4pm7rjtuo0Kye9OLUu2o5lcnx
        kK0/TyknMBOwKPxBLBWbkdk=
X-Google-Smtp-Source: APXvYqwPnyD7Dxm0Np1XmE8ip25TJgfjtzUl6R/cA9kJxVhZQaAdQqFtcQNpH7YWmviTqa0Tcd1VLw==
X-Received: by 2002:a65:4945:: with SMTP id q5mr2550753pgs.9.1561622811885;
        Thu, 27 Jun 2019 01:06:51 -0700 (PDT)
Received: from localhost.localdomain (osnfw.sakura.ad.jp. [210.224.179.167])
        by smtp.gmail.com with ESMTPSA id n5sm1448107pgd.26.2019.06.27.01.06.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 01:06:50 -0700 (PDT)
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
To:     davem@davemloft.net
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, Yuya Kusakabe <yuya.kusakabe@gmail.com>
Subject: [PATCH bpf-next] virtio_net: add XDP meta data support
Date:   Thu, 27 Jun 2019 17:06:41 +0900
Message-Id: <20190627080641.3266-1-yuya.kusakabe@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds XDP meta data support to both receive_small() and
receive_mergeable().

Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
---
 drivers/net/virtio_net.c | 40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4f3de0ac8b0b..e787657fc568 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -371,7 +371,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 				   struct receive_queue *rq,
 				   struct page *page, unsigned int offset,
 				   unsigned int len, unsigned int truesize,
-				   bool hdr_valid)
+				   bool hdr_valid, unsigned int metasize)
 {
 	struct sk_buff *skb;
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
@@ -393,17 +393,25 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
-	if (hdr_valid)
+	if (hdr_valid && !metasize)
 		memcpy(hdr, p, hdr_len);
 
 	len -= hdr_len;
 	offset += hdr_padded_len;
 	p += hdr_padded_len;
 
-	copy = len;
+	copy = len + metasize;
 	if (copy > skb_tailroom(skb))
 		copy = skb_tailroom(skb);
-	skb_put_data(skb, p, copy);
+
+	if (metasize) {
+		skb_put_data(skb, p - metasize, copy);
+		__skb_pull(skb, metasize);
+		skb_metadata_set(skb, metasize);
+		copy -= metasize;
+	} else {
+		skb_put_data(skb, p, copy);
+	}
 
 	len -= copy;
 	offset += copy;
@@ -644,6 +652,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	unsigned int delta = 0;
 	struct page *xdp_page;
 	int err;
+	unsigned int metasize = 0;
 
 	len -= vi->hdr_len;
 	stats->bytes += len;
@@ -683,8 +692,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
 		xdp.data = xdp.data_hard_start + xdp_headroom;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -695,9 +704,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			/* Recalculate length in case bpf program changed it */
 			delta = orig_data - xdp.data;
 			len = xdp.data_end - xdp.data;
+			metasize = xdp.data - xdp.data_meta;
 			break;
 		case XDP_TX:
 			stats->xdp_tx++;
+			xdp.data_meta = xdp.data;
 			xdpf = convert_to_xdp_frame(&xdp);
 			if (unlikely(!xdpf))
 				goto err_xdp;
@@ -735,11 +746,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	}
 	skb_reserve(skb, headroom - delta);
 	skb_put(skb, len);
-	if (!delta) {
+	if (!delta && !metasize) {
 		buf += header_offset;
 		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
 	} /* keep zeroed vnet hdr since packet was changed by bpf */
 
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
 err:
 	return skb;
 
@@ -761,7 +775,7 @@ static struct sk_buff *receive_big(struct net_device *dev,
 {
 	struct page *page = buf;
 	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
-					  PAGE_SIZE, true);
+					  PAGE_SIZE, true, 0);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -793,6 +807,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	unsigned int truesize;
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
 	int err;
+	unsigned int metasize = 0;
 
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
@@ -839,8 +854,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		data = page_address(xdp_page) + offset;
 		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
 		xdp.data = data + vi->hdr_len;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + (len - vi->hdr_len);
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -859,18 +874,20 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			 * adjusted
 			 */
 			len = xdp.data_end - xdp.data + vi->hdr_len;
+			metasize = xdp.data - xdp.data_meta;
 			/* We can only create skb based on xdp_page. */
 			if (unlikely(xdp_page != page)) {
 				rcu_read_unlock();
 				put_page(page);
 				head_skb = page_to_skb(vi, rq, xdp_page,
-						       offset, len,
-						       PAGE_SIZE, false);
+					       offset, len,
+					       PAGE_SIZE, false, metasize);
 				return head_skb;
 			}
 			break;
 		case XDP_TX:
 			stats->xdp_tx++;
+			xdp.data_meta = xdp.data;
 			xdpf = convert_to_xdp_frame(&xdp);
 			if (unlikely(!xdpf))
 				goto err_xdp;
@@ -921,7 +938,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
+	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
+			       metasize);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.20.1

