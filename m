Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28027251524
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgHYJQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729351AbgHYJQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:16:55 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CD7C061755
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:16:55 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mt12so913036pjb.4
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R8XTi8qvu+toNhdfEJW+FeTXeAE1uYK8ZjIgOFsPChs=;
        b=DAg8CGn//Li0QGdpYMY1ZV0Evl5CbSIXuCdVKC2uYBYv1XAmKF8hAKNiXisfUdSmxH
         qmFSr0WKJZBcppTQ6WH7ezGvpq5pto1Veo9UqRk6gHDLSv06imc5NplC/uQB8EE5TX5y
         nlaC8MRyl91cKGxhWDv7hLGk35Zqit5P2L+X4uqDGkg5lMSu1bqqkcZiweJkNz2jucgY
         h4MrruWencTIr1ndxxocusN04+1yF0HEJXoVdmzQUDB/YrSbq4oR11aQeVDGFJPAsj/b
         rZmW/NODRsBSk5CU/0qmYOEbL8Y//tM1f7OIVxRBb7G8/Hw9wyOwSpPL7hlal43kdgQw
         M31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8XTi8qvu+toNhdfEJW+FeTXeAE1uYK8ZjIgOFsPChs=;
        b=kd2ZOXHhprrnoh5s4Q4Px2J/RZhXVVmqafzwsF564y9kIWqxSkx7YkrTpPH+FmfZIy
         BBp1+dUPfOxm3/WRhUd8wyZI5oGPPVd/p0+YSh4CA90+QPKbzh/RUqIzxKx/08b/TQ3D
         qtg9gu07N6ThcPs+m2gOZsU7JUtD81wP9I6f5YfUA+TGUvVCr8peBChXsElJ6CCpY7Oj
         u7OAZcw2UbQGC6ilCdY6WSMxoMocitWEPibyCufZ/GpNI4kKUT2PFJvBrYUsaxlhrBxm
         3AP9JnPWb9TLFSYvoc2tTqupZHVLlY7agxKTt52qJg7KxXqk58P6s3Yy8ZfC8V3tROE+
         Z/Tw==
X-Gm-Message-State: AOAM533QfCs69yCvohWXkBeTHLOVdSk3uDO/SbbOJ2MTL+SxPmznPYDI
        tmEvA7AwGiQQ2FDoZ6/8DU4+lWr+aozlbQ==
X-Google-Smtp-Source: ABdhPJx6RmfZMrj9BxYXpc2JaWUs+lxm8tEAqhpdGCByfEK/MApwWSZPVNerqpnfQ4kTyhiTw5vLFw==
X-Received: by 2002:a17:90a:d808:: with SMTP id a8mr835295pjv.127.1598347014929;
        Tue, 25 Aug 2020 02:16:54 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 2sm2121857pjg.32.2020.08.25.02.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 02:16:53 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: [PATCH net 2/3] ixgbe: avoid premature Rx buffer reuse
Date:   Tue, 25 Aug 2020 11:16:28 +0200
Message-Id: <20200825091629.12949-3-bjorn.topel@gmail.com>
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

Fixes: 6453073987ba ("ixgbe: add initial support for xdp redirect")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 28 ++++++++++++++-----
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 2f8a4cfc5fa1..fb5c311d72b6 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1945,7 +1945,8 @@ static inline bool ixgbe_page_is_reserved(struct page *page)
 	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
-static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer)
+static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer,
+				    int rx_buffer_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
@@ -1956,7 +1957,7 @@ static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_ref_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 	/* The last offset is a bit aggressive in that we assume the
@@ -2018,14 +2019,25 @@ static void ixgbe_add_rx_frag(struct ixgbe_ring *rx_ring,
 #endif
 }
 
+static int ixgbe_rx_buffer_page_count(struct ixgbe_rx_buffer *rx_buffer)
+{
+#if (PAGE_SIZE < 8192)
+	return page_count(rx_buffer->page);
+#else
+	return 0;
+#endif
+}
+
 static struct ixgbe_rx_buffer *ixgbe_get_rx_buffer(struct ixgbe_ring *rx_ring,
 						   union ixgbe_adv_rx_desc *rx_desc,
 						   struct sk_buff **skb,
-						   const unsigned int size)
+						   const unsigned int size,
+						   int *rx_buffer_pgcnt)
 {
 	struct ixgbe_rx_buffer *rx_buffer;
 
 	rx_buffer = &rx_ring->rx_buffer_info[rx_ring->next_to_clean];
+	*rx_buffer_pgcnt = ixgbe_rx_buffer_page_count(rx_buffer);
 	prefetchw(rx_buffer->page);
 	*skb = rx_buffer->skb;
 
@@ -2055,9 +2067,10 @@ static struct ixgbe_rx_buffer *ixgbe_get_rx_buffer(struct ixgbe_ring *rx_ring,
 
 static void ixgbe_put_rx_buffer(struct ixgbe_ring *rx_ring,
 				struct ixgbe_rx_buffer *rx_buffer,
-				struct sk_buff *skb)
+				struct sk_buff *skb,
+				int rx_buffer_pgcnt)
 {
-	if (ixgbe_can_reuse_rx_page(rx_buffer)) {
+	if (ixgbe_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
 		/* hand second half of page back to the ring */
 		ixgbe_reuse_rx_page(rx_ring, rx_buffer);
 	} else {
@@ -2296,6 +2309,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 	u16 cleaned_count = ixgbe_desc_unused(rx_ring);
 	unsigned int xdp_xmit = 0;
 	struct xdp_buff xdp;
+	int rx_buffer_pgcnt;
 
 	xdp.rxq = &rx_ring->xdp_rxq;
 
@@ -2327,7 +2341,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		 */
 		dma_rmb();
 
-		rx_buffer = ixgbe_get_rx_buffer(rx_ring, rx_desc, &skb, size);
+		rx_buffer = ixgbe_get_rx_buffer(rx_ring, rx_desc, &skb, size, &rx_buffer_pgcnt);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -2372,7 +2386,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			break;
 		}
 
-		ixgbe_put_rx_buffer(rx_ring, rx_buffer, skb);
+		ixgbe_put_rx_buffer(rx_ring, rx_buffer, skb, rx_buffer_pgcnt);
 		cleaned_count++;
 
 		/* place incomplete frames back on ring for completion */
-- 
2.25.1

