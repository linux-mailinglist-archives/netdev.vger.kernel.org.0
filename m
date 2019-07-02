Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA005CBE3
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 10:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfGBIQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 04:16:59 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36464 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfGBIQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 04:16:58 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so8750859plt.3
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 01:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xiOgtSE1dTCIrCoidYY9ow8lK0Pal47m50/wvPtq1xA=;
        b=escQgOnPI+WiSKw5dyIL2ytbOHK4ELBsB6bH86HB7fz1lQBYPfc/87btWrPSOxmW7t
         KbOedEYoQH8qmRspAQ+1so2o7mmbfm8fg+BFjGQ7u+/GNUykDg8XvfZIZmW9DLb+DEoa
         19Z7laGVoXDV9g3ZTUIefe3hwDxUnuSg1SjVqe5IwKwCLILWyJGVCLlXspNRbh2qy2ah
         jfbp4JHB2saiPALzra/NZcTFQSNTxM64wiLY9nqgdx2gFvWCijFUQ1/azkk73hCMDdMa
         pwKPTLmO1A7diWjzHfRArQwoZYQukmhejIVOODP/x5DUFsllqlptfo2BVS/gnbkx2Yas
         UFaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xiOgtSE1dTCIrCoidYY9ow8lK0Pal47m50/wvPtq1xA=;
        b=A/M/qbIaLGP13kg83tcyzMrvGrC9iDfkNMtoqzBQ6GdQieKKWpVKpizInvn06IKQOA
         rWodTS28w6/IneDA5Sncove/bs8rKPK7ASaY7OZEYC9bb80KnSz4tyZt7tbWtHdAxMz7
         rZN6E4ZS0ri7U7EQ5Gi0r4W4EFHTDNw4pwzgRsTDDs0J2YdskVqFvtKKAHlmdlIZN1ks
         UAHB/E67MfDOk5Kk+7/78l+pTDS8ng6htgXbD25egDTuOaH/B2TjvKUdCtF8Ud5WVvRF
         +vk3sTiBLAUQusPj/nhOQeZUcdilSZyxAmp0WpEfu4YGIvoRUQfMG3OM83O1xwosenuG
         L8XA==
X-Gm-Message-State: APjAAAWV5+WC3y2NhC8f0n/otyYnzxu6eRKLbrYdexTP2vUHjQ0ctTtS
        hTklb1oOSR1SppEl/xVUmnc=
X-Google-Smtp-Source: APXvYqzvkfuKpYH6Vh7ozS9C1JvcHMT20l2I7JqHVWn+LWNC6z8TizZJ6ZEvvMBvl5bzZZqFz5i6fw==
X-Received: by 2002:a17:902:7603:: with SMTP id k3mr34199796pll.245.1562055417886;
        Tue, 02 Jul 2019 01:16:57 -0700 (PDT)
Received: from localhost.localdomain (osnfw.sakura.ad.jp. [210.224.179.167])
        by smtp.gmail.com with ESMTPSA id z13sm1551762pjn.32.2019.07.02.01.16.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 01:16:56 -0700 (PDT)
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
To:     jasowang@redhat.com
Cc:     yuya.kusakabe@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com, mst@redhat.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: [PATCH bpf-next v3] virtio_net: add XDP meta data support
Date:   Tue,  2 Jul 2019 17:16:46 +0900
Message-Id: <20190702081646.23230-1-yuya.kusakabe@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <32dc2f4e-4f19-4fa5-1d24-17a025a08297@gmail.com>
References: <32dc2f4e-4f19-4fa5-1d24-17a025a08297@gmail.com>
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
v3:
 - fix preserve the vnet header in receive_small().
v2:
 - keep copy untouched in page_to_skb().
 - preserve the vnet header in receive_small().
 - fix indentation.
---
 drivers/net/virtio_net.c | 45 +++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4f3de0ac8b0b..03a1ae6fe267 100644
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
@@ -683,10 +689,13 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
 		xdp.data = xdp.data_hard_start + xdp_headroom;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		orig_data = xdp.data;
+		/* Copy the vnet header to the front of data_hard_start to avoid
+		 * overwriting by XDP meta data */
+		memcpy(xdp.data_hard_start - vi->hdr_len, xdp.data - vi->hdr_len, vi->hdr_len);
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
 
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
@@ -736,10 +747,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	skb_reserve(skb, headroom - delta);
 	skb_put(skb, len);
 	if (!delta) {
-		buf += header_offset;
-		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
+		memcpy(skb_vnet_hdr(skb), buf + VIRTNET_RX_PAD, vi->hdr_len);
 	} /* keep zeroed vnet hdr since packet was changed by bpf */
 
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
 err:
 	return skb;
 
@@ -760,8 +773,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
 				   struct virtnet_rq_stats *stats)
 {
 	struct page *page = buf;
-	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
-					  PAGE_SIZE, true);
+	struct sk_buff *skb =
+		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -793,6 +806,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	unsigned int truesize;
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
 	int err;
+	unsigned int metasize = 0;
 
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
@@ -839,8 +853,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		data = page_address(xdp_page) + offset;
 		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
 		xdp.data = data + vi->hdr_len;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + (len - vi->hdr_len);
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -852,8 +866,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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
@@ -863,14 +878,15 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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
@@ -921,7 +937,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
+	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
+			       metasize);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.20.1

