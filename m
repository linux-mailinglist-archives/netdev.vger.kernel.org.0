Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CA35C7A3
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 05:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfGBDPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 23:15:54 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42917 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfGBDPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 23:15:54 -0400
Received: by mail-pg1-f193.google.com with SMTP id t132so3584718pgb.9
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 20:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DpipoyivYgLzMlHHNa1+fq49nt2ms5SulxMVVBqQKqM=;
        b=ufbdqHg/x1kImHLGjuw/gmGe8X7Wx7sCRwP5jjrnBBB+FwIa6xXTgiFlWqZIl7RlxG
         EViPuQ0fV3JwZsZ/d7c/bIRJ9fLqQGt5W8zPdRHYPafwFaWn5LMI3XUlSpM5Ir7/Rimu
         0jwYcQW4/FLqOt4cs6e/nlORUshJbe/lDY61kFEXCmGS73Uad0G6iEbjpWyM6VaBoXDx
         H9D4/W/Ead2p06F3anT3sjvdlz1EOlMVfox6EEZxHzt7JPLeA7qIaeR/mR4PPHbqflkz
         7+dOG0kg8D7K0Q1sVfT8FRd2n4pl4JPdxYdBHrhv7xOAy/vbQ4hqsIQRAz83lrBYSSKi
         E1iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DpipoyivYgLzMlHHNa1+fq49nt2ms5SulxMVVBqQKqM=;
        b=WPyNJMoH0ROcq6jiRoYQKW+s99n/Mo9sc0ZJ2aY/OUDtyR8cz3Ss0xHHbcbFO9YgNQ
         EERMHRlnmy2USE0pw9Dy/qDQWKy/7A50KIbG2u9Grle9fPgmUG5x4tVDQkfVjTazPnSr
         0p1oj1+k2AcADrOwz/iKYCPnkJt6shdPyXg+61x0VUPN4Uesz5KVAddE1dXCm33bZDK1
         2XrlLlvODDRCxvG5qpkihq7yCbw6aYWNKiWWPOu6m+hjt7zZ9yXXV0nF14XyhqabRJ8q
         bMFu/AyqTLM0KLT/6HjTUvyuUTWFcFiv0T3b74V1zQ83L9D2XDdgOKGF4gmLhTfJaeFZ
         oFVQ==
X-Gm-Message-State: APjAAAWBywQCm39vQ1PJz23RAindWpekkCKZZP77iZw0kl6wTukR7y6L
        aMwGq3wyAsyQ2/c4NYv8RhI=
X-Google-Smtp-Source: APXvYqy4DBlCGHYmuECiM3x3WHSRZrM9XvE4Oea+DrEhZgQKKWs/8Fc4K1c7klLaoVWSZvoM9p5mQg==
X-Received: by 2002:a63:6c4a:: with SMTP id h71mr27741733pgc.331.1562037353215;
        Mon, 01 Jul 2019 20:15:53 -0700 (PDT)
Received: from localhost.localdomain (osnfw.sakura.ad.jp. [210.224.179.167])
        by smtp.gmail.com with ESMTPSA id e63sm12940862pgc.62.2019.07.01.20.15.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 20:15:52 -0700 (PDT)
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
To:     yuya.kusakabe@gmail.com
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, jakub.kicinski@netronome.com, jasowang@redhat.com,
        john.fastabend@gmail.com, kafai@fb.com, mst@redhat.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: [PATCH bpf-next v2] virtio_net: add XDP meta data support
Date:   Tue,  2 Jul 2019 12:15:42 +0900
Message-Id: <20190702031542.5096-1-yuya.kusakabe@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <455941f9-aadb-ab70-2745-34f8fd893e89@gmail.com>
References: <455941f9-aadb-ab70-2745-34f8fd893e89@gmail.com>
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
v2:
 - keep copy untouched in page_to_skb().
 - preserve the vnet header in receive_small().
 - fix indentation.
---
 drivers/net/virtio_net.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4f3de0ac8b0b..2ebabb08b824 100644
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
@@ -393,7 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
-	if (hdr_valid)
+	if (hdr_valid && !metasize)
 		memcpy(hdr, p, hdr_len);
 
 	len -= hdr_len;
@@ -405,6 +405,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 		copy = skb_tailroom(skb);
 	skb_put_data(skb, p, copy);
 
+	if (metasize) {
+		__skb_pull(skb, metasize);
+		skb_metadata_set(skb, metasize);
+	}
+
 	len -= copy;
 	offset += copy;
 
@@ -644,6 +649,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	unsigned int delta = 0;
 	struct page *xdp_page;
 	int err;
+	unsigned int metasize = 0;
 
 	len -= vi->hdr_len;
 	stats->bytes += len;
@@ -683,8 +689,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
 		xdp.data = xdp.data_hard_start + xdp_headroom;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -695,9 +701,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
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
@@ -740,6 +748,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
 	} /* keep zeroed vnet hdr since packet was changed by bpf */
 
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
 err:
 	return skb;
 
@@ -760,8 +771,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
 				   struct virtnet_rq_stats *stats)
 {
 	struct page *page = buf;
-	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
-					  PAGE_SIZE, true);
+	struct sk_buff *skb =
+		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -793,6 +804,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	unsigned int truesize;
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
 	int err;
+	unsigned int metasize = 0;
 
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
@@ -839,8 +851,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		data = page_address(xdp_page) + offset;
 		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
 		xdp.data = data + vi->hdr_len;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + (len - vi->hdr_len);
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -852,8 +864,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			 * adjustments. Note other cases do not build an
 			 * skb and avoid using offset
 			 */
-			offset = xdp.data -
-					page_address(xdp_page) - vi->hdr_len;
+			metasize = xdp.data - xdp.data_meta;
+			offset = xdp.data - page_address(xdp_page) -
+				 vi->hdr_len - metasize;
 
 			/* recalculate len if xdp.data or xdp.data_end were
 			 * adjusted
@@ -863,14 +876,15 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 			if (unlikely(xdp_page != page)) {
 				rcu_read_unlock();
 				put_page(page);
-				head_skb = page_to_skb(vi, rq, xdp_page,
-						       offset, len,
-						       PAGE_SIZE, false);
+				head_skb = page_to_skb(vi, rq, xdp_page, offset,
+						       len, PAGE_SIZE, false,
+						       metasize);
 				return head_skb;
 			}
 			break;
 		case XDP_TX:
 			stats->xdp_tx++;
+			xdp.data_meta = xdp.data;
 			xdpf = convert_to_xdp_frame(&xdp);
 			if (unlikely(!xdpf))
 				goto err_xdp;
@@ -921,7 +935,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
+	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
+			       metasize);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.20.1

