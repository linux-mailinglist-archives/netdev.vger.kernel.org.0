Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67D71659AD
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 09:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgBTIz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 03:55:58 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38239 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgBTIz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 03:55:57 -0500
Received: by mail-pl1-f194.google.com with SMTP id t6so1290628plj.5;
        Thu, 20 Feb 2020 00:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dP0Z87CkXINV1ZhQ5TGeCzcU6kns51QhnUdWFKav+rY=;
        b=valEnfgU/nd2Y4yFnPgzTEIc7dtwMV0slu4mk8Dz8bep0kgP+w+vMhIeKFJ4gS/JSl
         F/M5PJ2O3/B16f7B4HZrt44YYsaWnWUaxvUD7LjYYA9PXTThG9C9tTKuviZa3EpzoIHf
         ifuV1JT9Q1LRmOT7n+yftdY22FyfCzkfcVW0QIROM2MBr09yI0lQhDc6EjMFgjP2nRsT
         8t4ERmTDMPNzhN954vRvM9tA6r7kmSBXChDXEncXMLR6RHMuxOhyDC07rQ/vqHYSP2GX
         KbYfEUIRc8ROVgh3ay7msTreKOmvdm7IiUIhwjj6ajab396OpXRIddvIjFz4swLWdrCB
         aE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dP0Z87CkXINV1ZhQ5TGeCzcU6kns51QhnUdWFKav+rY=;
        b=kJUNZXs3h7CBpplDxDQvb98UrnNvtd3ubi+6q8GfWrGZcCy/6HZdjNIWgO6ebMsbSZ
         JwIPEyNl8uJ3A+9P+5MmjtRvJU7BEob8AihjcYgEsAkeEdrv64Pfht//Z6xz2Kh6De76
         dU473sl6/8smuJyuHYAfo1NWBOW2vIF0fdWRt9LPmN8+mqaWF31mXr6giErMm0XxKsKo
         UaE5i3jrqezHS3x26SlkoRSbGZrMaFyXhSxLH7e1KGMbjp4mijHJfUEcg/UtOq/2PY9j
         x6UM5KkihwYGlYfT3Fl5XGA4lhBHT8CkbtJTtY3w3tWwLp8/5j0vGPd0qNGy5XnMEuf1
         kQ/g==
X-Gm-Message-State: APjAAAWzLh9VQngTv5JpH4FJ4OZrMxaoKNajamuYLghf0hhY6WVwtfuA
        i8BMnAuHBrCUYEegCC/NApk=
X-Google-Smtp-Source: APXvYqw6htsz+OYrdOJdOhJcOxfgKL/86sJsV5kZo4Q7KNDgjhrKgeY/WAmQCMOgxjP5exrlq6rQGA==
X-Received: by 2002:a17:90a:c78f:: with SMTP id gn15mr2358709pjb.64.1582188956706;
        Thu, 20 Feb 2020 00:55:56 -0800 (PST)
Received: from localhost.localdomain ([103.202.217.14])
        by smtp.gmail.com with ESMTPSA id x11sm2386742pfn.53.2020.02.20.00.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 00:55:56 -0800 (PST)
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
To:     jasowang@redhat.com
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        yuya.kusakabe@gmail.com
Subject: [PATCH bpf-next v5] virtio_net: add XDP meta data support
Date:   Thu, 20 Feb 2020 17:55:49 +0900
Message-Id: <20200220085549.269795-1-yuya.kusakabe@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <0c5eaba2-dd5a-fc3f-0e8f-154f7ad52881@redhat.com>
References: <0c5eaba2-dd5a-fc3f-0e8f-154f7ad52881@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for transferring XDP meta data into skb for
virtio_net driver; before calling into the program, xdp.data_meta points
to xdp.data, where on program return with pass verdict, we call
into skb_metadata_set().

Tested with the script at
https://github.com/higebu/virtio_net-xdp-metadata-test.

Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
---
v5:
 - page_to_skb(): copy vnet header if hdr_valid without checking metasize.
 - receive_small(): do not copy vnet header if xdp_prog is availavle.
 - __virtnet_xdp_xmit_one(): remove the xdp_set_data_meta_invalid().
 - improve comments.
v4:
 - improve commit message
v3:
 - fix preserve the vnet header in receive_small().
v2:
 - keep copy untouched in page_to_skb().
 - preserve the vnet header in receive_small().
 - fix indentation.
---
 drivers/net/virtio_net.c | 54 ++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2fe7a3188282..4ea0ae60c000 100644
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
@@ -393,6 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	else
 		hdr_padded_len = sizeof(struct padded_vnet_hdr);
 
+	/* hdr_valid means no XDP, so we can copy the vnet header */
 	if (hdr_valid)
 		memcpy(hdr, p, hdr_len);
 
@@ -405,6 +406,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 		copy = skb_tailroom(skb);
 	skb_put_data(skb, p, copy);
 
+	if (metasize) {
+		__skb_pull(skb, metasize);
+		skb_metadata_set(skb, metasize);
+	}
+
 	len -= copy;
 	offset += copy;
 
@@ -450,10 +456,6 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
 	struct virtio_net_hdr_mrg_rxbuf *hdr;
 	int err;
 
-	/* virtqueue want to use data area in-front of packet */
-	if (unlikely(xdpf->metasize > 0))
-		return -EOPNOTSUPP;
-
 	if (unlikely(xdpf->headroom < vi->hdr_len))
 		return -EOVERFLOW;
 
@@ -644,6 +646,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	unsigned int delta = 0;
 	struct page *xdp_page;
 	int err;
+	unsigned int metasize = 0;
 
 	len -= vi->hdr_len;
 	stats->bytes += len;
@@ -683,8 +686,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
 		xdp.data = xdp.data_hard_start + xdp_headroom;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		orig_data = xdp.data;
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -695,6 +698,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 			/* Recalculate length in case bpf program changed it */
 			delta = orig_data - xdp.data;
 			len = xdp.data_end - xdp.data;
+			metasize = xdp.data - xdp.data_meta;
 			break;
 		case XDP_TX:
 			stats->xdp_tx++;
@@ -735,11 +739,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	}
 	skb_reserve(skb, headroom - delta);
 	skb_put(skb, len);
-	if (!delta) {
+	if (!xdp_prog) {
 		buf += header_offset;
 		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
 	} /* keep zeroed vnet hdr since packet was changed by bpf */
 
+	if (metasize)
+		skb_metadata_set(skb, metasize);
+
 err:
 	return skb;
 
@@ -760,8 +767,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
 				   struct virtnet_rq_stats *stats)
 {
 	struct page *page = buf;
-	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
-					  PAGE_SIZE, true);
+	struct sk_buff *skb =
+		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -793,6 +800,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	unsigned int truesize;
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
 	int err;
+	unsigned int metasize = 0;
 
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
@@ -839,8 +847,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		data = page_address(xdp_page) + offset;
 		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
 		xdp.data = data + vi->hdr_len;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + (len - vi->hdr_len);
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -848,24 +856,27 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 
 		switch (act) {
 		case XDP_PASS:
+			metasize = xdp.data - xdp.data_meta;
+
 			/* recalculate offset to account for any header
-			 * adjustments. Note other cases do not build an
-			 * skb and avoid using offset
+			 * adjustments and minus the metasize to copy the
+			 * metadata in page_to_skb(). Note other cases do not
+			 * build an skb and avoid using offset
 			 */
-			offset = xdp.data -
-					page_address(xdp_page) - vi->hdr_len;
+			offset = xdp.data - page_address(xdp_page) -
+				 vi->hdr_len - metasize;
 
-			/* recalculate len if xdp.data or xdp.data_end were
-			 * adjusted
+			/* recalculate len if xdp.data, xdp.data_end or
+			 * xdp.data_meta were adjusted
 			 */
-			len = xdp.data_end - xdp.data + vi->hdr_len;
+			len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
 			/* We can only create skb based on xdp_page. */
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
@@ -921,7 +932,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
+	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
+			       metasize);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.24.1

