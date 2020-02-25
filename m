Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 158A216B81F
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 04:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgBYDc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 22:32:26 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46814 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgBYDc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 22:32:26 -0500
Received: by mail-pg1-f195.google.com with SMTP id y30so6153777pga.13;
        Mon, 24 Feb 2020 19:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nDyrG6UjggPiJJBgIWKrHCM93kwG9flF6MjmMmTAVIo=;
        b=EiQu7Kvdt14sHx2irsWAQFpIMcOOgZIhsxoewOuTaPUCFvb2gEBdwYkz9ModD5fGYq
         K8GPHA1lSF2Dkp6NDSV9TCl5CJ0o2UcZGAPaRtYlKynxw03BMX9PV4Lt1woDSX8EnVTH
         a8tBZ/nl5j2KYjZxNTEH4ef+Su5ZawLG3dW+mnXLQ8/vPgTMfhaxQj7LEAB6sOeE6EcU
         6BFGvNebZHC25FG5NfpoePbXoASBXS7Z2DzrDBnVqrNJtXtbBQss8bLt5vIOKX1BPQ21
         y/Y9p3hXgrRL83e/leKvZfHLktj+HW9cqResCaORsc2cwcyeATKIvly7BJuUK3M8zIWs
         QlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nDyrG6UjggPiJJBgIWKrHCM93kwG9flF6MjmMmTAVIo=;
        b=Mu7YdPNBb+Oyr+5z9nqVGS04u8DrFmOly48knuGWm9EVLyaXavYf3GYS/2zSDG38Fe
         rMp2IhxJAcEXP62LgJKojdyguht3hHWrlVFWTzVEAbJyQCV1Za34G5R9lSOnKS5OOC8q
         woTVrvxO1MYcEKKWgP+5zi4jEWcXj9imsCdBp9MD+UkT/UsgWTzDFNUNKzKcyHuBP+Qi
         2UOUWj9nXbb7sbGJBHIYQQK2iB8S30xTm/EqDLfE+rIoZhRGEuBXCiSiU609fViYzuyz
         3C0pQ04qNKjagkfjo2wRsPaVCKX1H6O3gvY15rj5+K6etvqKNVHHoUVpXTUjWAcvX6FK
         OvDQ==
X-Gm-Message-State: APjAAAUnG1SHw+xtF1efxyPv3ipWq5XP3xD1br/9NKtCKxwb0wnZL9T1
        rFSxbzt6YsVpbUAA4g5W8Rk=
X-Google-Smtp-Source: APXvYqy74Qld+nxxq8N5GPdapbai8b4BMAR2NQsxGiMqzQ5PMfNLbKiEEka4cU2Ou2fAQKwABYW4xA==
X-Received: by 2002:a63:4912:: with SMTP id w18mr9159546pga.122.1582601545131;
        Mon, 24 Feb 2020 19:32:25 -0800 (PST)
Received: from localhost.localdomain ([103.202.217.14])
        by smtp.gmail.com with ESMTPSA id u1sm14322493pfn.133.2020.02.24.19.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 19:32:24 -0800 (PST)
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
To:     jasowang@redhat.com
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        yuya.kusakabe@gmail.com
Subject: [PATCH bpf-next v6 2/2] virtio_net: add XDP meta data support
Date:   Tue, 25 Feb 2020 12:32:12 +0900
Message-Id: <20200225033212.437563-2-yuya.kusakabe@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225033212.437563-1-yuya.kusakabe@gmail.com>
References: <20200225033103.437305-1-yuya.kusakabe@gmail.com>
 <20200225033212.437563-1-yuya.kusakabe@gmail.com>
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

Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
---
 drivers/net/virtio_net.c | 52 ++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f39d0218bdaa..12d115ef5e74 100644
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
@@ -740,6 +744,9 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
 	} /* keep zeroed vnet hdr since XDP is loaded */
 
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

