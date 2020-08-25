Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3D3251E42
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgHYR2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgHYR2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:28:08 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66109C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:28:08 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mw10so1583599pjb.2
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eOjCRr1iyADG+ZRax7slSjtpeURMGhBQuIQOuCjnTx8=;
        b=UQMPPCu9M7VXhMA2GaLJ4yrUVAp6ZvDzxQBrBPBJgJo7OBwsGEj9hJ0XfpVEy4L0sX
         1237QHrWSjzASMkKCOF2uW9K2yRK7pI6Vi10dZoy6whPg1o3kQOX+i4ORkIH66R6sCJ8
         g8Cm8aCUl/j21Ll6nsFAo9EGr+fXeNEZLvpXeP5vPxGON6OkfFTk0U3hgu9TGs2Zb11X
         lDRY4i17sB8oWW8U0jgZ2N6eByQZW5kZ4mIgqFh8kYvWLg4IS752RWcEapYe+FdoKHMc
         DlZwwNH6vodyLV2ffiZYFGTWa93F06MAq7zjutlwWbyScdjn0rA/fn40ejMzqjaCsyHJ
         3Iww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eOjCRr1iyADG+ZRax7slSjtpeURMGhBQuIQOuCjnTx8=;
        b=FTKvOGFSqIbOP+7cO9yBdQ1v4ks1i/h41i9/RJFmAbOBb4AbY8Zunb3+To4BwYQvQx
         vmM6NAuJMvs+SV4fR2Y13WTz54Sli+NmgnoxHdY7Id+gRqXLQ5Ib4A2rAyQeVbDM6qOu
         AsMxEzqWAVZoGcO6+pLmodPM1SmU4EfdR1ObWiXYZrjJ+eeCVEsPMMnHQi1Rq2feVoHN
         cF+H7/gjV/3exUzQD5ovsH6j6qVDqshaVV+I/yp96KAoIKlYeYGzHM4iSThhtl91nGqr
         RbUAGl845UG6zS4qL561koBQQXVbP494ELoxg9M7yaHI7DBz50eCjzBunOZaYALiBFOZ
         YZMQ==
X-Gm-Message-State: AOAM532xiPPPJnT4rb3471lLXnkVw4sCzP3sIi8odypz7w5+jozH603c
        hs5bNlFhpbiFC4uQe12lanE=
X-Google-Smtp-Source: ABdhPJzt9xTZoria9TuDD0fHYCIwHqwrTx86olUY6ebNvc1ipmlGyW4r7NvlhOCFaxSo8SayouuSyQ==
X-Received: by 2002:a17:90a:ee08:: with SMTP id e8mr2566409pjy.86.1598376487967;
        Tue, 25 Aug 2020 10:28:07 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([134.134.137.77])
        by smtp.gmail.com with ESMTPSA id n72sm11685763pfd.93.2020.08.25.10.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 10:28:07 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: [PATCH net v3 3/3] ice: avoid premature Rx buffer reuse
Date:   Tue, 25 Aug 2020 19:27:36 +0200
Message-Id: <20200825172736.27318-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200825172736.27318-1-bjorn.topel@gmail.com>
References: <20200825172736.27318-1-bjorn.topel@gmail.com>
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
 drivers/net/ethernet/intel/ice/ice_txrx.c | 30 ++++++++++++++++-------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 9d0d6b0025cf..61279adf3561 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -762,13 +762,15 @@ ice_rx_buf_adjust_pg_offset(struct ice_rx_buf *rx_buf, unsigned int size)
 /**
  * ice_can_reuse_rx_page - Determine if page can be reused for another Rx
  * @rx_buf: buffer containing the page
+ * @rx_buf_pgcnt: rx_buf page refcount pre xdp_do_redirect() call
  *
  * If page is reusable, we have a green light for calling ice_reuse_rx_page,
  * which will assign the current buffer to the buffer that next_to_alloc is
  * pointing to; otherwise, the DMA mapping needs to be destroyed and
  * page freed
  */
-static bool ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
+static bool ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf,
+				  int rx_buf_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buf->pagecnt_bias;
 	struct page *page = rx_buf->page;
@@ -779,7 +781,7 @@ static bool ice_can_reuse_rx_page(struct ice_rx_buf *rx_buf)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buf_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 #define ICE_LAST_OFFSET \
@@ -864,17 +866,25 @@ ice_reuse_rx_page(struct ice_ring *rx_ring, struct ice_rx_buf *old_buf)
  * @rx_ring: Rx descriptor ring to transact packets on
  * @skb: skb to be used
  * @size: size of buffer to add to skb
+ * @rx_buf_pgcnt: rx_buf page refcount
  *
  * This function will pull an Rx buffer from the ring and synchronize it
  * for use by the CPU.
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
 
@@ -1012,12 +1022,13 @@ ice_construct_skb(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf,
  * ice_put_rx_buf - Clean up used buffer and either recycle or free
  * @rx_ring: Rx descriptor ring to transact packets on
  * @rx_buf: Rx buffer to pull data from
+ * @rx_buf_pgcnt: Rx buffer page count pre xdp_do_redirect()
  *
  * This function will update next_to_clean and then clean up the contents
  * of the rx_buf. It will either recycle the buffer or unmap it and free
  * the associated resources.
  */
-static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
+static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf, int rx_buf_pgcnt)
 {
 	u16 ntc = rx_ring->next_to_clean + 1;
 
@@ -1028,7 +1039,7 @@ static void ice_put_rx_buf(struct ice_ring *rx_ring, struct ice_rx_buf *rx_buf)
 	if (!rx_buf)
 		return;
 
-	if (ice_can_reuse_rx_page(rx_buf)) {
+	if (ice_can_reuse_rx_page(rx_buf, rx_buf_pgcnt)) {
 		/* hand second half of page back to the ring */
 		ice_reuse_rx_page(rx_ring, rx_buf);
 	} else {
@@ -1103,6 +1114,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		struct sk_buff *skb;
 		unsigned int size;
 		u16 stat_err_bits;
+		int rx_buf_pgcnt;
 		u16 vlan_tag = 0;
 		u8 rx_ptype;
 
@@ -1125,7 +1137,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		dma_rmb();
 
 		if (rx_desc->wb.rxdid == FDIR_DESC_RXDID || !rx_ring->netdev) {
-			ice_put_rx_buf(rx_ring, NULL);
+			ice_put_rx_buf(rx_ring, NULL, 0);
 			cleaned_count++;
 			continue;
 		}
@@ -1134,7 +1146,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			ICE_RX_FLX_DESC_PKT_LEN_M;
 
 		/* retrieve a buffer from the ring */
-		rx_buf = ice_get_rx_buf(rx_ring, &skb, size);
+		rx_buf = ice_get_rx_buf(rx_ring, &skb, size, &rx_buf_pgcnt);
 
 		if (!size) {
 			xdp.data = NULL;
@@ -1174,7 +1186,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 		total_rx_pkts++;
 
 		cleaned_count++;
-		ice_put_rx_buf(rx_ring, rx_buf);
+		ice_put_rx_buf(rx_ring, rx_buf, rx_buf_pgcnt);
 		continue;
 construct_skb:
 		if (skb) {
@@ -1193,7 +1205,7 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
 			break;
 		}
 
-		ice_put_rx_buf(rx_ring, rx_buf);
+		ice_put_rx_buf(rx_ring, rx_buf, rx_buf_pgcnt);
 		cleaned_count++;
 
 		/* skip if it is NOP desc */
-- 
2.25.1

