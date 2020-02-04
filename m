Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA15515165B
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 08:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgBDHRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 02:17:05 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39603 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgBDHRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 02:17:04 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so6895568plp.6;
        Mon, 03 Feb 2020 23:17:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ilfu3WmKSVrH6Kay2DlwZBIEnaGW/2gaQGQqUnhH9hk=;
        b=pFUVVWD73rNuHHpblzOfrscS+2bxtu6qIh6DZl+zrryQNRN5p1SEsdWjc2Sz4809iS
         Tx1UqSf82dVdUZIq40auQ3cATkRuyVPHMQMgPrToXY32ZFx+dnN0tpoXktM+sFOkAndb
         3qHh4e4++2fbz2lYgLy2pudPQTPOEnoIyK6OChdA5vpFn60OnqQnLz4KV4/RYteLFCX9
         LZXlwchAx9/9zlJ3NmtlwmwF0rLDOOkc7BF2wuCyM1/w9mtHb2/O+VEPy6woTLiQ5gPy
         tMKYNXAOiLtMU8XHjiB0xvN8E1lXjMBiLbs5pHQqcJNA/GoY2QQ+H5XKiWLawbdmTIR6
         gsdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ilfu3WmKSVrH6Kay2DlwZBIEnaGW/2gaQGQqUnhH9hk=;
        b=phM2o1qYGcl3stW7vsZ1KE95Q9ikEqGKBiURAQuWptjmGWQ38st8J5QexbOHxyqPn2
         IUUctXCB+dboYyfpLQvf1m0V0WQp2JrLQ7wHLxVy080Vpk5+QrjdFx1tlUpByUyoKxAm
         +ueXKbPW70sGISvsfRLc/c+1jqd70hKDCNBrhdAFm4YfNwjBmgGhKu5R+igus68awWw+
         uRKuYUdilC0feLDvZ4xriNgX/TDRS3RNmGqZ1ez8BDVuy63XxPULqP/3nh6YbW7AEVHs
         x2X6DvHhLL7ROAJrrjX4dr+PDfFAjq9LKd9URe+c4cwQkLBUtD0I/ktqhZzRHjHjPbJg
         GEvw==
X-Gm-Message-State: APjAAAUK2EHeyKSgt1AFMnaZN0TVZPuGpHnIym7T3G6YJCo1PV7oCXYf
        WFAOXosxz399OdS79Y4iabvh+U0jbTT9Tg==
X-Google-Smtp-Source: APXvYqzU+olYyf72/JexE1NOLO+sa3FwkTxIL5iLLtGkCcjAYdUhxvXHsxP9wipTCCin1BcTEQKNAw==
X-Received: by 2002:a17:902:341:: with SMTP id 59mr29290084pld.29.1580800623869;
        Mon, 03 Feb 2020 23:17:03 -0800 (PST)
Received: from localhost.localdomain ([103.202.217.14])
        by smtp.gmail.com with ESMTPSA id v10sm22016045pgk.24.2020.02.03.23.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 23:17:03 -0800 (PST)
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
To:     jasowang@redhat.com
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        mst@redhat.com, songliubraving@fb.com, yhs@fb.com, kuba@kernel.org,
        andriin@fb.com, yuya.kusakabe@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v4] virtio_net: add XDP meta data support
Date:   Tue,  4 Feb 2020 16:16:55 +0900
Message-Id: <20200204071655.94474-1-yuya.kusakabe@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <8da1b560-3128-b885-b453-13de5c7431fb@redhat.com>
References: <8da1b560-3128-b885-b453-13de5c7431fb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for transferring XDP meta data into skb for
virtio_net driver; before calling into the program, xdp.data_meta points
to xdp.data and copy vnet header to the front of xdp.data_hard_start
to avoid overwriting it, where on program return with pass verdict,
we call into skb_metadata_set().

Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
---
 drivers/net/virtio_net.c | 47 ++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2fe7a3188282..5fdd6ea0e3f1 100644
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
@@ -683,10 +689,15 @@ static struct sk_buff *receive_small(struct net_device *dev,
 
 		xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
 		xdp.data = xdp.data_hard_start + xdp_headroom;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 		orig_data = xdp.data;
+		/* Copy the vnet header to the front of data_hard_start to avoid
+		 * overwriting it by XDP meta data.
+		 */
+		memcpy(xdp.data_hard_start - vi->hdr_len,
+		       xdp.data - vi->hdr_len, vi->hdr_len);
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		stats->xdp_packets++;
 
@@ -695,9 +706,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
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
@@ -736,10 +749,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
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
 
@@ -760,8 +775,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
 				   struct virtnet_rq_stats *stats)
 {
 	struct page *page = buf;
-	struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
-					  PAGE_SIZE, true);
+	struct sk_buff *skb =
+		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
 
 	stats->bytes += len - vi->hdr_len;
 	if (unlikely(!skb))
@@ -793,6 +808,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	unsigned int truesize;
 	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
 	int err;
+	unsigned int metasize = 0;
 
 	head_skb = NULL;
 	stats->bytes += len - vi->hdr_len;
@@ -839,8 +855,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		data = page_address(xdp_page) + offset;
 		xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
 		xdp.data = data + vi->hdr_len;
-		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + (len - vi->hdr_len);
+		xdp.data_meta = xdp.data;
 		xdp.rxq = &rq->xdp_rxq;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -852,8 +868,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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
@@ -863,14 +880,15 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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
@@ -921,7 +939,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		goto err_skb;
 	}
 
-	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
+	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
+			       metasize);
 	curr_skb = head_skb;
 
 	if (unlikely(!curr_skb))
-- 
2.24.1

