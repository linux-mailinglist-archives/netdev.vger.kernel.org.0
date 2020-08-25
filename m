Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B3225185C
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 14:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgHYMNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 08:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgHYMNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 08:13:39 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE14C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 05:13:38 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id t9so3041417pfq.8
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 05:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JBAzRDlmS5llybdKuvOihg+SoXiBd1/lSywPiogf424=;
        b=RJhThgoXqFgQ9SQ2gljP5KUmAw5SaZL8B7HScravCb0yNKIDR/pk4PTYU37GwBnfh0
         NPmfpcBTmc0SQEvOscjuEetprSb2Qtbhknm7hCOkNj0WFnv7LwFCpXL8BwBLNjVe9CxM
         Hkov65LUhACU2L+cB9+vPwERBmt3z0aP3pqYeJFJ875AYyyFHqn9+PpTfN5GMrDUlXTV
         bHGBO/8BeRDke+UBvq8mRXretB4ih7RBAMmtzIUF3OB6qpStN37CPoNvDpeKZRq0/ZNs
         J5RiBPrpHHiV+YXPDRPLvjYe85il7435LbQvHHJSN2W3vK5aVUoh0yavPE9HWFr7YiQP
         ki4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JBAzRDlmS5llybdKuvOihg+SoXiBd1/lSywPiogf424=;
        b=fRW0TX+nfH2MtuflAMXJi4uAS5IE39+GwSf4ChaiQthW1gA6OClxwhtN9g8y/enyci
         m/H7zt1Ir0kMHMQXgWyGpvR3rd7TJ83nSh1I5lTT7syy2oSYCUjwiVgwKS9m7srTVSrs
         E5szZLd+gZ1TBhWP/THI2YafG1Uv6YP9cLr5GqUFFRoFczCDFDuYZaeymNGc0iuBvWRH
         mVEZ7RYhZu00nGW8BiTbtDn4B85MQMfivfmUDP5qhMnFtVle8tHiLCbfRkK9HIsNYPY9
         RvCHc4/mNSHe/FJyph2CMp+y5/Elnbax2aQH0LoAowMGbR6qXAJpnvP2IMIxrCWSTd3H
         sMBw==
X-Gm-Message-State: AOAM532WqNq9Y34TDUNJzeBRzFAy1nwuv78gXFI7EnVCc2gINFZHea5v
        /RSBEADrZOVbaRJ/9CUGG9o=
X-Google-Smtp-Source: ABdhPJxt5YX/AfbT46BlfoL8S4vrOrK73hnuC1JpwI3oqvUiHNHkb7wWVSGL/y7kPPXUE0XhU/WNCg==
X-Received: by 2002:aa7:9569:: with SMTP id x9mr7827579pfq.16.1598357618463;
        Tue, 25 Aug 2020 05:13:38 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id d5sm2700031pjw.18.2020.08.25.05.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 05:13:37 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: [PATCH net v2 1/3] i40e: avoid premature Rx buffer reuse
Date:   Tue, 25 Aug 2020 14:13:21 +0200
Message-Id: <20200825121323.20239-2-bjorn.topel@gmail.com>
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
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 24 +++++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 3e5c566ceb01..07d8f8a684b3 100644
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
@@ -1948,11 +1949,18 @@ static void i40e_add_rx_frag(struct i40e_ring *rx_ring,
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
@@ -2112,9 +2120,10 @@ static struct sk_buff *i40e_build_skb(struct i40e_ring *rx_ring,
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
@@ -2328,6 +2337,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		struct i40e_rx_buffer *rx_buffer;
 		union i40e_rx_desc *rx_desc;
+		int rx_buffer_pgcnt;
 		unsigned int size;
 		u64 qword;
 
@@ -2370,7 +2380,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			break;
 
 		i40e_trace(clean_rx_irq, rx_ring, rx_desc, skb);
-		rx_buffer = i40e_get_rx_buffer(rx_ring, size);
+		rx_buffer = i40e_get_rx_buffer(rx_ring, size, &rx_buffer_pgcnt);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -2413,7 +2423,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 			break;
 		}
 
-		i40e_put_rx_buffer(rx_ring, rx_buffer);
+		i40e_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
 		cleaned_count++;
 
 		if (i40e_is_non_eop(rx_ring, rx_desc, skb))
-- 
2.25.1

