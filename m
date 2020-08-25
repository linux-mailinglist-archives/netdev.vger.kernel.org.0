Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D13251E3E
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgHYR2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgHYR16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:27:58 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012ABC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:27:58 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id v15so7292769pgh.6
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RPPjpseeI12KajTqOZcrVQDuT5wYkHZ78/zbtPhX050=;
        b=f0Na09xFoKZ877fDN1ImYymRU/09a882j+HPkKHlr8a+qXchBndxYaqeP6pqzgknbI
         l2+Bfn1/OAVpuojXHLiwwgOZgGIFF8cZAY40JK8Sx2csi3FvFSOg0LvPHT8V60Z1t0NY
         a0Nshzqvz1B2VLxuey1NRPjTEg0nELn+gLNP56C6lWQra4+rx0WK3GTY/cJEruLktoCr
         wZQcVcwpWh9Pmr1rVfz0R3hStBBNM3PIkr/WWFq9EaHiOmTjdM89HsQ5y0Wu5a63BdH6
         s7jvCm0bLi8Vp8u1yNc+o1ThctYo7qYgRB+CrLVQIZOfmOUpkD1i6jmds6aKlFItSAnL
         KmjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RPPjpseeI12KajTqOZcrVQDuT5wYkHZ78/zbtPhX050=;
        b=T53blUCWdvlnhGac9F6Z4Kuj9GTYDoyfkZ298Iu/hMA7lDgAGXNKcyuAzNIRq7ZjMY
         7Hyy0SSKyjg6wQhdAb6QWiKH9PbHVd1ZaJsuLor1OU6z//LSBLmI8rcv7+IDFMSTtNj2
         h/RkPXKRqPa4ey95ctqinn3e7B/2rHGuid/b4b73++ABHCJbH/KYAbfoAXcotaaouRfH
         WrI5OHttwc01yVlGwZoo81dCcJGvGjDvyLEIU+8dyfWV7eJhdcOZqG+9hu/CSGawAMIq
         n1KH7El1aOZlwoybidtdCbJqyTKrzpXOEUvjsUn72H3oXqo05kBOWhTCxvp6MeXg27lE
         kC9A==
X-Gm-Message-State: AOAM532NZCxAg5f3JBp1q+PEBA/czhyiLU+IWxbYz4QfkheZAKdZrnf9
        9oqBI4xHPDruFwXsqtn79Xs=
X-Google-Smtp-Source: ABdhPJx20wECYE02lK6Crb6sU4ARjYqVmP/saAwoXd8kWHvj8yi3hyuVFmmYoQpUlzPw5CYmXA5azA==
X-Received: by 2002:a63:d157:: with SMTP id c23mr151030pgj.281.1598376477524;
        Tue, 25 Aug 2020 10:27:57 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([134.134.137.77])
        by smtp.gmail.com with ESMTPSA id n72sm11685763pfd.93.2020.08.25.10.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 10:27:56 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: [PATCH net v3 1/3] i40e: avoid premature Rx buffer reuse
Date:   Tue, 25 Aug 2020 19:27:34 +0200
Message-Id: <20200825172736.27318-2-bjorn.topel@gmail.com>
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
Reported-and-analyzed-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 27 +++++++++++++++------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 3e5c566ceb01..37af1ad16591 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1851,6 +1851,7 @@ static inline bool i40e_page_is_reusable(struct page *page)
  * the adapter for another receive
  *
  * @rx_buffer: buffer containing the page
+ * @rx_buffer_pgcnt: buffer page refcount pre xdp_do_redirect() call
  *
  * If page is reusable, rx_buffer->page_offset is adjusted to point to
  * an unused region in the page.
@@ -1873,7 +1874,8 @@ static inline bool i40e_page_is_reusable(struct page *page)
  *
  * In either case, if the page is reusable its refcount is increased.
  **/
-static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer)
+static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer,
+				   int rx_buffer_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
@@ -1884,7 +1886,7 @@ static bool i40e_can_reuse_rx_page(struct i40e_rx_buffer *rx_buffer)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 #define I40E_LAST_OFFSET \
@@ -1943,16 +1945,24 @@ static void i40e_add_rx_frag(struct i40e_ring *rx_ring,
  * i40e_get_rx_buffer - Fetch Rx buffer and synchronize data for use
  * @rx_ring: rx descriptor ring to transact packets on
  * @size: size of buffer to add to skb
+ * @rx_buffer_pgcnt: buffer page refcount
  *
  * This function will pull an Rx buffer from the ring and synchronize it
  * for use by the CPU.
  */
 static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
-						 const unsigned int size)
+						 const unsigned int size,
+						 int *rx_buffer_pgcnt)
 {
 	struct i40e_rx_buffer *rx_buffer;
 
 	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
+	*rx_buffer_pgcnt =
+#if (PAGE_SIZE < 8192)
+		page_count(rx_buffer->page);
+#else
+		0;
+#endif
 	prefetchw(rx_buffer->page);
 
 	/* we are reusing so sync this buffer for CPU use */
@@ -2107,14 +2117,16 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
  * i40e_put_rx_buffer - Clean up used buffer and either recycle or free
  * @rx_ring: rx descriptor ring to transact packets on
  * @rx_buffer: rx buffer to pull data from
+ * @rx_buffer_pgcnt: rx buffer page refcount pre xdp_do_redirect() call
  *
  * This function will clean up the contents of the rx_buffer.  It will
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
@@ -2328,6 +2340,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		struct i40e_rx_buffer *rx_buffer;
 		union i40e_rx_desc *rx_desc;
+		int rx_buffer_pgcnt;
 		unsigned int size;
 		u64 qword;
 
@@ -2370,7 +2383,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			break;
 
 		i40e_trace(clean_rx_irq, rx_ring, rx_desc, skb);
-		rx_buffer = i40e_get_rx_buffer(rx_ring, size);
+		rx_buffer = i40e_get_rx_buffer(rx_ring, size, &rx_buffer_pgcnt);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -2413,7 +2426,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			break;
 		}
 
-		i40e_put_rx_buffer(rx_ring, rx_buffer);
+		i40e_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
 		cleaned_count++;
 
 		if (i40e_is_non_eop(rx_ring, rx_desc, skb))
-- 
2.25.1

