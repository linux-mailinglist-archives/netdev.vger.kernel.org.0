Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5DF251527
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgHYJQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbgHYJQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:16:51 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D5EC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:16:51 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o5so6392181pgb.2
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b4uiR7mjiUEO8q/J67JSbBTgAuzIsuSUAuOtPzxxrK0=;
        b=dKNfoIkozlHWaHujT1mzqUPk6evaug7/VktNscdnpKS8wZ/CBMC4y5tJMkqWEPP2j+
         6wxF+ohJeaTMM9zH352iYNj3pSsHGRXa2WujPLqbL09to6lJMpB9bNlKhhC6J7BDQk8k
         Zt7FeRz+2LtfI0T8UnGbtoX4D+a5tWBcuLtcsWol+qbi+KzAD49u64bFvKPk5yFZg40T
         VVBMEX9MAmPOeY3g5Fs06i7L/ldJAJviDFmpXAMM78bcUDi1CyVRv58F56juIhS15tr5
         jVy2ITGI8zWoao23JxAFaatZkbv4Qgej+jjP49hfX0MclsWpPrytaegs9uTA0AogMnPw
         EnLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b4uiR7mjiUEO8q/J67JSbBTgAuzIsuSUAuOtPzxxrK0=;
        b=E69Cz6czF8/5RJ0CrHsNJsy/6v3eU+KmMFSBpTNqBtE0sNhaQgdEeidHTW1TZEZwSP
         SsWYrNdp8FwFkGighpswhMasJqfYrjVO6UQmSa9N/U6XGNPonudJPmtI5odhOoKfP7pc
         hxuflFHRq5wXy0FIi2Kb/QW/BTwkGj9pvvE9cXQr/XBWz8tKp+WLksutdI1WX6ILVzpC
         I5UlvsPbylgjQVIscyVnJG4Q1/wjvSZhCzHDiTexU3P92/0fpGbClgHqiePX1k4bocuZ
         W1O1MZkKqukNRvNqtcCFfTMyieJLLNx7HQRe0RlEXps/k6xa+9VFWOhjnspF2dZ9vhEl
         pRWw==
X-Gm-Message-State: AOAM530tksy/Kk8u3ihrt0bqWBk4Ucnhe2ffQHnIMP3lgWxysZU5VoyQ
        GvVITauRV5KSc4zuHB3QaqY=
X-Google-Smtp-Source: ABdhPJzHBBNilV6r/snjUSKwBGOSJHXBrAS2V/2nBmJVpI8OLkFynozFebZswPvi4RWt2aDmbn9w+A==
X-Received: by 2002:a17:902:6bc6:: with SMTP id m6mr6899554plt.302.1598347010745;
        Tue, 25 Aug 2020 02:16:50 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 2sm2121857pjg.32.2020.08.25.02.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 02:16:50 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: [PATCH net 1/3] i40e: avoid premature Rx buffer reuse
Date:   Tue, 25 Aug 2020 11:16:27 +0200
Message-Id: <20200825091629.12949-2-bjorn.topel@gmail.com>
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

Longer explanation:

Intel NICs have a recycle mechanism. The main idea is that a page is
split into two parts. One part is owned by the driver, one part might
be owned by someone else, such as the stack.

t0: Page is allocated, and put on the Rx ring
              +---------------
used by NIC ->| upper buffer
(rx_buffer)   +---------------
              | lower buffer
              +---------------
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX

t1: Buffer is received, and passed to the stack (e.g.)
              +---------------
              | upper buff (skb)
              +---------------
used by NIC ->| lower buffer
(rx_buffer)   +---------------
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX - 1

t2: Buffer is received, and redirected
              +---------------
              | upper buff (skb)
              +---------------
used by NIC ->| lower buffer
(rx_buffer)   +---------------

Now, prior calling xdp_do_redirect():
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX - 2

This means that buffer *cannot* be flipped/reused, because the skb is
still using it.

The problem arises when xdp_do_redirect() actually frees the
segment. Then we get:
  page count  == USHRT_MAX - 1
  rx_buffer->pagecnt_bias == USHRT_MAX - 2

From a recycle perspective, the buffer can be flipped and reused,
which means that the skb data area is passed to the Rx HW ring!

To work around this, the page count is stored prior calling
xdp_do_redirect().

Note that this is not optimal, since the NIC could actually reuse the
"lower buffer" again. However, then we need to track whether
XDP_REDIRECT consumed the buffer or not.

Fixes: d9314c474d4f ("i40e: add support for XDP_REDIRECT")
Reported-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 28 +++++++++++++++------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 3e5c566ceb01..5e446dc39190 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1873,7 +1873,8 @@ static inline bool i40e_page_is_reusable(struct page *page)
  *
  * In either case, if the page is reusable its refcount is increased.
  **/
-static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer)
+static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
+				   int rx_buffer_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
@@ -1884,7 +1885,7 @@ static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 #define I40E_LAST_OFFSET \
@@ -1939,6 +1940,15 @@ static void i40e_add_rx_frag(struct i40e_ring *rx_ring,
 #endif
 }
 
+static int i40e_rx_buffer_page_count(struct i40e_rx_buffer *rx_buffer)
+{
+#if (PAGE_SIZE < 8192)
+	return page_count(rx_buffer->page);
+#else
+	return 0;
+#endif
+}
+
 /**
  * i40e_get_rx_buffer - Fetch Rx buffer and synchronize data for use
  * @rx_ring: rx descriptor ring to transact packets on
@@ -1948,11 +1958,13 @@ static void i40e_add_rx_frag(struct i40e_ring *rx_ring,
  * for use by the CPU.
  */
 static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
-						 const unsigned int size)
+						 const unsigned int size,
+						 int *rx_buffer_pgcnt)
 {
 	struct i40e_rx_buffer *rx_buffer;
 
 	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
+	*rx_buffer_pgcnt = i40e_rx_buffer_page_count(rx_buffer);
 	prefetchw(rx_buffer->page);
 
 	/* we are reusing so sync this buffer for CPU use */
@@ -2112,9 +2124,10 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
  * either recycle the buffer or unmap it and free the associated resources.
  */
 static void i40e_put_rx_buffer(struct i40e_ring *rx_ring,
-			       struct i40e_rx_buffer *rx_buffer)
+			       struct i40e_rx_buffer *rx_buffer,
+			       int rx_buffer_pgcnt)
 {
-	if (i40e_can_reuse_rx_page(rx_buffer)) {
+	if (i40e_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
 		/* hand second half of page back to the ring */
 		i40e_reuse_rx_page(rx_ring, rx_buffer);
 	} else {
@@ -2319,6 +2332,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	unsigned int xdp_xmit = 0;
 	bool failure = false;
 	struct xdp_buff xdp;
+	int rx_buffer_pgcnt;
 
 #if (PAGE_SIZE < 8192)
 	xdp.frame_sz = i40e_rx_frame_truesize(rx_ring, 0);
@@ -2370,7 +2384,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			break;
 
 		i40e_trace(clean_rx_irq, rx_ring, rx_desc, skb);
-		rx_buffer = i40e_get_rx_buffer(rx_ring, size);
+		rx_buffer = i40e_get_rx_buffer(rx_ring, size, &rx_buffer_pgcnt);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -2413,7 +2427,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			break;
 		}
 
-		i40e_put_rx_buffer(rx_ring, rx_buffer);
+		i40e_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
 		cleaned_count++;
 
 		if (i40e_is_non_eop(rx_ring, rx_desc, skb))
-- 
2.25.1

