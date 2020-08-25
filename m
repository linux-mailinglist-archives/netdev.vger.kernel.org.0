Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6AD251528
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgHYJRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729371AbgHYJQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:16:59 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7773DC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:16:59 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g33so6391214pgb.4
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lSOHb2BtMg2wPWXugkRPn8o1h+t2kwdV3CyIiFwfvr8=;
        b=kI1hBVArsOgYGkWu3YDpNcrIjZ/zjWZtkKwTeplIQvAyLW/VjhSFoU9tuza+6o5QXP
         dI6gDDlaXbn6rJm+wbWxLMrV3aa9CIyWhzaBCSchlx/X9wgzBOoiHgH9tQRF8B6USaDM
         VIVz1J17MuptUXI0o30kK9GT5sb6V6JI/z/+syvNUPptvxDNNE3Gh64TE7uBp3KvO3b5
         p/o4JM+fHsoL5hP+nB74Az+C2X8Pv49kAIQuRn+SAfvsQdxT+zuRxoZXncHfDTDrTteG
         GFOtFSpYF5MkLkS3rsVWzs+vjQe61+GtGRcFzxeVCI5stQSNFVm2JsK/no96Mfu9tuS0
         2wlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lSOHb2BtMg2wPWXugkRPn8o1h+t2kwdV3CyIiFwfvr8=;
        b=KCJNXlaiWNQ8SaTciFkb8xpSQKXGjv+P2tWIdNNu19cc2AhPwByiZRl8tndKP3cij5
         joanmFwEORniN7h0deTfcf9dPiA7DmorrBUl1wsr0pezAOPmiMTDEnuWbFoQQeptR6gi
         EOUybCwldEh4FqLKS9VLQT8+zHQquOfC+dCiX5ej2eYPXdiamkJOmrtHZsj5hmDRV/s8
         W/8R025vWwc/LY22cN2zLxgUmoXawzYIJYEPAoR26inoWMw8ZwZzo8x3FPGlJGoleAx2
         r4sLcAdHqSsZp25p1Rbsb4TCS8/pbCu0nzt9UAEcgTb2tJjhjXTVrKv70gLbxTbmFhyP
         z9Tg==
X-Gm-Message-State: AOAM531hMEkKlkSKBmKEWa/xzDAi/YjpSTF4muujvUHRpyICicpIax8B
        Srw/E6EvFfYXh5jMv4TxFn8=
X-Google-Smtp-Source: ABdhPJwWItfwTBa/7GlcEVgEAzPrBO0irVfimfNXGk8E7ihltw5bz80TrhDJLF7RooYRBcUVe1I4SA==
X-Received: by 2002:a63:2944:: with SMTP id p65mr6384832pgp.271.1598347019028;
        Tue, 25 Aug 2020 02:16:59 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 2sm2121857pjg.32.2020.08.25.02.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 02:16:58 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: [PATCH net 3/3] ice: avoid premature Rx buffer reuse
Date:   Tue, 25 Aug 2020 11:16:29 +0200
Message-Id: <20200825091629.12949-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200825091629.12949-1-bjorn.topel@gmail.com>
References: <20200825091629.12949-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The page recycle code, incorrectly, relied on that a page fragment
could not be freed inside xdp_do_redirect(). This assumption leads to
that page fragments that are used by the stack/XDP redirect can be
reused and overwritten.

To avoid this, store the page count prior invoking xdp_do_redirect().

Fixes: efc2214b6047 ("ice: Add support for XDP")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 31 ++++++++++++++++-------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 9d0d6b0025cf..03a88c8f17b7 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -768,7 +768,8 @@ ice_rx_buf_adjust_pg_offset(struct ice_rx_buf *rx_buf, unsigned int size)
  * pointing to; otherwise, the DMA mapping needs to be destroyed and
  * page freed
  */
-static bool ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
+static bool ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf,
+				  int rx_buf_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buf->pagecnt_bias;
 	struct page *page = rx_buf->page;
@@ -779,7 +780,7 @@ static bool ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buf_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 #define ICE_LAST_OFFSET \
@@ -859,6 +860,15 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
 	new_buf->pagecnt_bias = old_buf->pagecnt_bias;
 }
 
+static int ice_rx_buf_page_count(struct ice_rx_buf *rx_buf)
+{
+#if (PAGE_SIZE < 8192)
+	return page_count(rx_buf->page);
+#else
+	return 0;
+#endif
+}
+
 /**
  * ice_get_rx_buf - Fetch Rx buffer and synchronize data for use
  * @rx_ring: Rx descriptor ring to transact packets on
@@ -870,11 +880,13 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
  */
 static struct ice_rx_buf *
 ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
-	       const unsigned int size)
+	       const unsigned int size,
+	       int *rx_buf_pgcnt)
 {
 	struct ice_rx_buf *rx_buf;
 
 	rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
+	*rx_buf_pgcnt = ice_rx_buf_page_count(rx_buf);
 	prefetchw(rx_buf->page);
 	*skb = rx_buf->skb;
 
@@ -1017,7 +1029,7 @@ ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * of the rx_buf. It will either recycle the buffer or unmap it and free
  * the associated resources.
  */
-static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
+static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf, int rx_buf_pgcnt)
 {
 	u16 ntc = rx_ring->next_to_clean + 1;
 
@@ -1028,7 +1040,7 @@ static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 	if (!rx_buf)
 		return;
 
-	if (ice_can_reuse_rx_page(rx_buf)) {
+	if (ice_can_reuse_rx_page(rx_buf, rx_buf_pgcnt)) {
 		/* hand second half of page back to the ring */
 		ice_reuse_rx_page(rx_ring, rx_buf);
 	} else {
@@ -1088,6 +1100,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 	unsigned int xdp_res, xdp_xmit = 0;
 	struct bpf_prog *xdp_prog = NULL;
 	struct xdp_buff xdp;
+	int rx_buf_pgcnt;
 	bool failure;
 
 	xdp.rxq = &rx_ring->xdp_rxq;
@@ -1125,7 +1138,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		dma_rmb();
 
 		if (rx_desc->wb.rxdid == FDIR_DESC_RXDID || !rx_ring->netdev) {
-			ice_put_rx_buf(rx_ring, NULL);
+			ice_put_rx_buf(rx_ring, NULL, 0);
 			cleaned_count++;
 			continue;
 		}
@@ -1134,7 +1147,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
 		/* retrieve a buffer from the ring */
-		rx_buf = ice_get_rx_buf(rx_ring, &skb, size);
+		rx_buf = ice_get_rx_buf(rx_ring, &skb, size, &rx_buf_pgcnt);
 
 		if (!size) {
 			xdp.data = NULL;
@@ -1174,7 +1187,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		total_rx_pkts++;
 
 		cleaned_count++;
-		ice_put_rx_buf(rx_ring, rx_buf);
+		ice_put_rx_buf(rx_ring, rx_buf, rx_buf_pgcnt);
 		continue;
 construct_skb:
 		if (skb) {
@@ -1193,7 +1206,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			break;
 		}
 
-		ice_put_rx_buf(rx_ring, rx_buf);
+		ice_put_rx_buf(rx_ring, rx_buf, rx_buf_pgcnt);
 		cleaned_count++;
 
 		/* skip if it is NOP desc */
-- 
2.25.1

