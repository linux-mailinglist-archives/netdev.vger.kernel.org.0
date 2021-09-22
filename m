Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E0D414304
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 09:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhIVH6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 03:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbhIVH6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 03:58:17 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58696C06175F;
        Wed, 22 Sep 2021 00:56:47 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q26so4085306wrc.7;
        Wed, 22 Sep 2021 00:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=52u3Kx6+oceyZzsP4B5cGpXydkf+1La7S++4cahoPkI=;
        b=kA5Es8jbfNrdyFFxj9A4H7bSne4xin503tcBu9igNQqQkIsSY0o8I9s3vtKX73Js5e
         xwrzcjYvR8zfWbClu5nCPljSGzOJn9k69KkJCPBF9XdllZM13pCKqpvcjZII9dXAi5FP
         JcALayeOnEx9oJZFZr4Bb9od5jjX3vLvfpxpVN1sgzasNEpm52QEbAsGe9cQAmlKtrFa
         A5nh9iZatkdkQuL73wehGdQvI/4CCeZ+gsGsE5n3FjKUzfDXyw0z5JFW8WgGMyZJsU8f
         8QDD2laabNbOeZf90Xgfhx5Ay3TespphdoMHu/yiBbjvwuZFhETvgJq2cUu+ltp2+kjZ
         AhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=52u3Kx6+oceyZzsP4B5cGpXydkf+1La7S++4cahoPkI=;
        b=bmZMfqTmz//Lld8KZ98P0GA+5DCesneVrG74eUbBVxyoYGNYeOJIB44gBlL4bfERo4
         RbGhrSML0XrTwcaZK6894lHrzCp2K4nixiJ8J8l/cYHUecREcn6kshU/s6dJQlmRm2ZF
         oKsLYrmeBTTnKEAH6qXrzk/etKKItYYBYdfrXi6qonnsN8NyimtQs8XglkKGYWgKd+GD
         5ea3tsgIa7hec3TGEJPGyFg9G8u3loAO+Ko/x8RKxTjsFgjB4DG3IH161eBWDdarRY46
         xJjV2h37bRw7WZ67F+PwEsJYlx4EmuZmYdQ92XZdqp8GUWfn9qaHtFXOuGmD9gmXxi4v
         higQ==
X-Gm-Message-State: AOAM531OVjwzTV6Ymlgq8UX93BfiC3sUJppUdPxGvSgvZSJyC/p8RiQG
        qtOFUENh1vJrluN+WSSv1J/v5cV1nmdHjZ2F
X-Google-Smtp-Source: ABdhPJxAf+k5QeBzIthpr7DXTd5RWk1OdFLBV4CBSWKjt9/S6CRnfLVDhbOWYSGD45zk0ge9BtiwgQ==
X-Received: by 2002:adf:9bdb:: with SMTP id e27mr39489302wrc.162.1632297405942;
        Wed, 22 Sep 2021 00:56:45 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id j7sm1673087wrr.27.2021.09.22.00.56.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Sep 2021 00:56:45 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, ciara.loftus@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH bpf-next 03/13] ice: use xdp_buf instead of rx_buf for xsk zero-copy
Date:   Wed, 22 Sep 2021 09:56:03 +0200
Message-Id: <20210922075613.12186-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210922075613.12186-1-magnus.karlsson@gmail.com>
References: <20210922075613.12186-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

In order to use the new xsk batched buffer allocation interface, a
pointer to an array of struct xsk_buff pointers need to be provided so
that the function can put the result of the allocation there. In the
ice driver, we already have a ring that stores pointers to
xdp_buffs. This is only used for the xsk zero-copy driver and is a
union with the structure that is used for the regular non zero-copy
path. Unfortunately, that structure is larger than the xdp_buffs
pointers which mean that there will be a stride (of 20 bytes) between
each xdp_buff pointer. And feeding this into the xsk_buff_alloc_batch
interface will not work since it assumes a regular array of xdp_buff
pointers (each 8 bytes with 0 bytes in-between them on a 64-bit
system).

To fix this, remove the xdp_buff pointer from the rx_buf union and
move it one step higher to the union above which only has pointers to
arrays in it. This solves the problem and we can directly feed the SW
ring of xdp_buff pointers straight into the allocation function in the
next patch when that interface is used. This will improve performance.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.h | 16 ++-----
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 56 +++++++++++------------
 2 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index 1e46e80f3d6f..7c2328529ff8 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -164,17 +164,10 @@ struct ice_tx_offload_params {
 };
 
 struct ice_rx_buf {
-	union {
-		struct {
-			dma_addr_t dma;
-			struct page *page;
-			unsigned int page_offset;
-			u16 pagecnt_bias;
-		};
-		struct {
-			struct xdp_buff *xdp;
-		};
-	};
+	dma_addr_t dma;
+	struct page *page;
+	unsigned int page_offset;
+	u16 pagecnt_bias;
 };
 
 struct ice_q_stats {
@@ -270,6 +263,7 @@ struct ice_ring {
 	union {
 		struct ice_tx_buf *tx_buf;
 		struct ice_rx_buf *rx_buf;
+		struct xdp_buff **xdp_buf;
 	};
 	/* CL2 - 2nd cacheline starts here */
 	u16 q_index;			/* Queue number of ring */
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 5a9f61deeb38..f4ab5259a56c 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -364,7 +364,7 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 {
 	union ice_32b_rx_flex_desc *rx_desc;
 	u16 ntu = rx_ring->next_to_use;
-	struct ice_rx_buf *rx_buf;
+	struct xdp_buff **xdp;
 	bool ok = true;
 	dma_addr_t dma;
 
@@ -372,26 +372,26 @@ bool ice_alloc_rx_bufs_zc(struct ice_ring *rx_ring, u16 count)
 		return true;
 
 	rx_desc = ICE_RX_DESC(rx_ring, ntu);
-	rx_buf = &rx_ring->rx_buf[ntu];
+	xdp = &rx_ring->xdp_buf[ntu];
 
 	do {
-		rx_buf->xdp = xsk_buff_alloc(rx_ring->xsk_pool);
-		if (!rx_buf->xdp) {
+		*xdp = xsk_buff_alloc(rx_ring->xsk_pool);
+		if (!xdp) {
 			ok = false;
 			break;
 		}
 
-		dma = xsk_buff_xdp_get_dma(rx_buf->xdp);
+		dma = xsk_buff_xdp_get_dma(*xdp);
 		rx_desc->read.pkt_addr = cpu_to_le64(dma);
 		rx_desc->wb.status_error0 = 0;
 
 		rx_desc++;
-		rx_buf++;
+		xdp++;
 		ntu++;
 
 		if (unlikely(ntu == rx_ring->count)) {
 			rx_desc = ICE_RX_DESC(rx_ring, 0);
-			rx_buf = rx_ring->rx_buf;
+			xdp = rx_ring->xdp_buf;
 			ntu = 0;
 		}
 	} while (--count);
@@ -421,19 +421,19 @@ static void ice_bump_ntc(struct ice_ring *rx_ring)
 /**
  * ice_construct_skb_zc - Create an sk_buff from zero-copy buffer
  * @rx_ring: Rx ring
- * @rx_buf: zero-copy Rx buffer
+ * @xdp_arr: Pointer to the SW ring of xdp_buff pointers
  *
  * This function allocates a new skb from a zero-copy Rx buffer.
  *
  * Returns the skb on success, NULL on failure.
  */
 static struct sk_buff *
-ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
+ice_construct_skb_zc(struct ice_ring *rx_ring, struct xdp_buff **xdp_arr)
 {
-	unsigned int metasize = rx_buf->xdp->data - rx_buf->xdp->data_meta;
-	unsigned int datasize = rx_buf->xdp->data_end - rx_buf->xdp->data;
-	unsigned int datasize_hard = rx_buf->xdp->data_end -
-				     rx_buf->xdp->data_hard_start;
+	struct xdp_buff *xdp = *xdp_arr;
+	unsigned int metasize = xdp->data - xdp->data_meta;
+	unsigned int datasize = xdp->data_end - xdp->data;
+	unsigned int datasize_hard = xdp->data_end - xdp->data_hard_start;
 	struct sk_buff *skb;
 
 	skb = __napi_alloc_skb(&rx_ring->q_vector->napi, datasize_hard,
@@ -441,13 +441,13 @@ ice_construct_skb_zc(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 	if (unlikely(!skb))
 		return NULL;
 
-	skb_reserve(skb, rx_buf->xdp->data - rx_buf->xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), rx_buf->xdp->data, datasize);
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
+	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-	xsk_buff_free(rx_buf->xdp);
-	rx_buf->xdp = NULL;
+	xsk_buff_free(xdp);
+	*xdp_arr = NULL;
 	return skb;
 }
 
@@ -521,7 +521,7 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union ice_32b_rx_flex_desc *rx_desc;
 		unsigned int size, xdp_res = 0;
-		struct ice_rx_buf *rx_buf;
+		struct xdp_buff **xdp;
 		struct sk_buff *skb;
 		u16 stat_err_bits;
 		u16 vlan_tag = 0;
@@ -544,18 +544,18 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		if (!size)
 			break;
 
-		rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
-		rx_buf->xdp->data_end = rx_buf->xdp->data + size;
-		xsk_buff_dma_sync_for_cpu(rx_buf->xdp, rx_ring->xsk_pool);
+		xdp = &rx_ring->xdp_buf[rx_ring->next_to_clean];
+		(*xdp)->data_end = (*xdp)->data + size;
+		xsk_buff_dma_sync_for_cpu(*xdp, rx_ring->xsk_pool);
 
-		xdp_res = ice_run_xdp_zc(rx_ring, rx_buf->xdp);
+		xdp_res = ice_run_xdp_zc(rx_ring, *xdp);
 		if (xdp_res) {
 			if (xdp_res & (ICE_XDP_TX | ICE_XDP_REDIR))
 				xdp_xmit |= xdp_res;
 			else
-				xsk_buff_free(rx_buf->xdp);
+				xsk_buff_free(*xdp);
 
-			rx_buf->xdp = NULL;
+			*xdp = NULL;
 			total_rx_bytes += size;
 			total_rx_packets++;
 			cleaned_count++;
@@ -565,7 +565,7 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		}
 
 		/* XDP_PASS path */
-		skb = ice_construct_skb_zc(rx_ring, rx_buf);
+		skb = ice_construct_skb_zc(rx_ring, xdp);
 		if (!skb) {
 			rx_ring->rx_stats.alloc_buf_failed++;
 			break;
@@ -813,12 +813,12 @@ void ice_xsk_clean_rx_ring(struct ice_ring *rx_ring)
 	u16 i;
 
 	for (i = 0; i < rx_ring->count; i++) {
-		struct ice_rx_buf *rx_buf = &rx_ring->rx_buf[i];
+		struct xdp_buff **xdp = &rx_ring->xdp_buf[i];
 
-		if (!rx_buf->xdp)
+		if (!xdp)
 			continue;
 
-		rx_buf->xdp = NULL;
+		*xdp = NULL;
 	}
 }
 
-- 
2.29.0

