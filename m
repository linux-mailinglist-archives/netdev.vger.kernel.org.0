Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9501925185F
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 14:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbgHYMN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 08:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729627AbgHYMNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 08:13:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58D0C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 05:13:46 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id p11so4029287pfn.11
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 05:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E3FCU1ysVCQIS/y1LR8GDdyKBD7FyoWGv58ugE95k9E=;
        b=V2Gd3bMSWjb7++EjJGkSGGumtzMg4VDVUyC/lsdu1LTIUAPBkaWWuaoQpPq7FnENNE
         h05mQeLPZII16LAJZ/Z/vxq+jtlu8PSpA0Js48LBqfaHSPdNyGgW2zRvS1gqVrQ8YAK3
         9rT0dJd879yasu5lrYr6CZa1Z9xxXAdXTha7tl3XsQfQ9H4n3L7O5antaVyHubmLuxxv
         DRkz8yw/guX+VB08PJpLbFKKrsB0eggBEUzAn5WreBR0Ygv6Vl8eVlVI8PV+oAAzktBM
         9MBqUgGt+NvQjg9kBpTbUROOwmZ2XSBNH8wvMuBRN7j7k/cX6TcA+10Yl9Tx9xbE4238
         LNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E3FCU1ysVCQIS/y1LR8GDdyKBD7FyoWGv58ugE95k9E=;
        b=BtRr2BSaspwAB4gxtJaVZVvXxUnggy4MbygQylBgLDg7TY8qdHQbtTUvYJvMMASalB
         SS2laaBYpn5fR06PKha4CvlA8dxibqAKPZhU0B2HtxbAo/ANFpGJLwhp2cuxmESkgfv9
         cfTgnYJUoeKUwBHx+zoMO2hWgG7uJM2qsSmFpgip+uVnC4A7KdkIBs/nPG/5eus225yd
         BPlT9aKuOoppAshoGjH1MG70o9ljr/9kqEw7LFjYzPiOj7ng1Hff7t99FiAIHJWekC9Q
         UOD8dmdy74Dso1DfFkh2sVGiKeBBswS15vqPg5hXxrO5XNYO2PrwIrC1jbDU/g0PJkZm
         Ozyw==
X-Gm-Message-State: AOAM532IUzeY8R4WSGZeL1TQ6yOrteGZ4PvWmxFueQV/day1aR43hQeC
        BBCgPpF0yS9/2/d+HT7f8WQ=
X-Google-Smtp-Source: ABdhPJxz8r9wVR00AicZeBN5vv6rNG38IzyW6IBd9yFmG0BNmLXpZnq4GyFjyOdM+yt6o4wnV8gO1Q==
X-Received: by 2002:aa7:84d1:: with SMTP id x17mr7591486pfn.87.1598357626371;
        Tue, 25 Aug 2020 05:13:46 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id d5sm2700031pjw.18.2020.08.25.05.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 05:13:45 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: [PATCH net v2 3/3] ice: avoid premature Rx buffer reuse
Date:   Tue, 25 Aug 2020 14:13:23 +0200
Message-Id: <20200825121323.20239-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200825121323.20239-1-bjorn.topel@gmail.com>
References: <20200825121323.20239-1-bjorn.topel@gmail.com>
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
Reported-and-analyzed-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 27 +++++++++++++++--------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 9d0d6b0025cf..924d34ad9fa4 100644
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
@@ -870,11 +871,18 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
  */
 static struct ice_rx_buf *
 ice_get_rx_buf(struct ice_ring *rx_ring, struct sk_buff **skb,
-	       const unsigned int size)
+	       const unsigned int size,
+	       int *rx_buf_pgcnt)
 {
 	struct ice_rx_buf *rx_buf;
 
 	rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
+	*rx_buf_pgcnt =
+#if (PAGE_SIZE < 8192)
+		page_count(rx_buf->page);
+#else
+		0;
+#endif
 	prefetchw(rx_buf->page);
 	*skb = rx_buf->skb;
 
@@ -1017,7 +1025,7 @@ ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * of the rx_buf. It will either recycle the buffer or unmap it and free
  * the associated resources.
  */
-static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
+static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf, int rx_buf_pgcnt)
 {
 	u16 ntc = rx_ring->next_to_clean + 1;
 
@@ -1028,7 +1036,7 @@ static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 	if (!rx_buf)
 		return;
 
-	if (ice_can_reuse_rx_page(rx_buf)) {
+	if (ice_can_reuse_rx_page(rx_buf, rx_buf_pgcnt)) {
 		/* hand second half of page back to the ring */
 		ice_reuse_rx_page(rx_ring, rx_buf);
 	} else {
@@ -1103,6 +1111,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		struct sk_buff *skb;
 		unsigned int size;
 		u16 stat_err_bits;
+		int rx_buf_pgcnt;
 		u16 vlan_tag = 0;
 		u8 rx_ptype;
 
@@ -1125,7 +1134,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		dma_rmb();
 
 		if (rx_desc->wb.rxdid == FDIR_DESC_RXDID || !rx_ring->netdev) {
-			ice_put_rx_buf(rx_ring, NULL);
+			ice_put_rx_buf(rx_ring, NULL, 0);
 			cleaned_count++;
 			continue;
 		}
@@ -1134,7 +1143,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
 		/* retrieve a buffer from the ring */
-		rx_buf = ice_get_rx_buf(rx_ring, &skb, size);
+		rx_buf = ice_get_rx_buf(rx_ring, &skb, size, &rx_buf_pgcnt);
 
 		if (!size) {
 			xdp.data = NULL;
@@ -1174,7 +1183,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		total_rx_pkts++;
 
 		cleaned_count++;
-		ice_put_rx_buf(rx_ring, rx_buf);
+		ice_put_rx_buf(rx_ring, rx_buf, rx_buf_pgcnt);
 		continue;
 construct_skb:
 		if (skb) {
@@ -1193,7 +1202,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			break;
 		}
 
-		ice_put_rx_buf(rx_ring, rx_buf);
+		ice_put_rx_buf(rx_ring, rx_buf, rx_buf_pgcnt);
 		cleaned_count++;
 
 		/* skip if it is NOP desc */
-- 
2.25.1

