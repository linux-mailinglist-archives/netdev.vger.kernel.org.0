Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE23251E40
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 19:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgHYR2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 13:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgHYR2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 13:28:03 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C804C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:28:03 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id m71so7896627pfd.1
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 10:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UtTChdCSLkSxd+sRXkD3oHe4KiRrekM2v0o2HWq7aYE=;
        b=sUxJoH9zpt6SuA5osAlwo1d+vTxGq5s+dhoDOxQMH24drU45b16tlDQRuSnqNlpVOz
         0egYRvPAQvHLnUZ83ptqVonRUSuK0NW7PY8lE+zHqvRc4i+/Gajo6SnNkBAq3kXgCQ8M
         nMlx9zwLxf/6gyPZhJveWddB3Ww1K19715v9HAQnXsMONGvEpfgQbrBdK+HMIrw38p8M
         cm3AJccqpBIOsmEKoTDaEljamy6XigkrCDSo0LO82NP41HoX2Ku0fw+5bOwvPPr122hK
         ZMaNAOSbV6TBdW2K0h89pKklvK/gKDWqRm+ebd5e4Yhyo0jDMaxIYUy10FZ5CN72GaEj
         y79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UtTChdCSLkSxd+sRXkD3oHe4KiRrekM2v0o2HWq7aYE=;
        b=XuqVZ1ktRa+5nrdb0CWGgNanHo4nuGyv2OeNRnA37BeMdA58lvIHCjYphLnYr7yoUI
         DkdldkkvuExiQqzf7UN0/K71ewTxRIy4sgA7TOpkeCgq0cwgvz38l3h3lw/7k84t5Dnr
         oYgOuTyKLqxJO6HyKdfbZLPKNICCyLEBMti3coN9tUkUWqV+I1oXXMxM2woMR0KIWqi2
         f3WTZWhi91gDEdaUKbmH2eV9Uo3PcnNin+5Y9+TtFkQe0lKEvYGcgiCOCYhNf054WfDn
         /gnBv4nofrhERVq0jcMhTNmWwZzne3i2lhRvRbeacsbQ8k3yVP88rJ+ZbJE/7aJBSVMD
         SBNw==
X-Gm-Message-State: AOAM531aXNKy+WMclY1MeMvGia/dX54YTgtNAxErpPtbFUjSS0ICQ8hh
        Gi14G+nFVn2k+hPFO9vREM4=
X-Google-Smtp-Source: ABdhPJwHXCV6f7HcpXf/XOWCWj9ykyOSpU1Vpf67OdpO3iCpGXAugCjRQN+/bAWkhGM8VXeLC5zcEQ==
X-Received: by 2002:a63:c62:: with SMTP id 34mr7671828pgm.115.1598376483039;
        Tue, 25 Aug 2020 10:28:03 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([134.134.137.77])
        by smtp.gmail.com with ESMTPSA id n72sm11685763pfd.93.2020.08.25.10.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 10:28:02 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: [PATCH net v3 2/3] ixgbe: avoid premature Rx buffer reuse
Date:   Tue, 25 Aug 2020 19:27:35 +0200
Message-Id: <20200825172736.27318-3-bjorn.topel@gmail.com>
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

Fixes: 6453073987ba ("ixgbe: add initial support for xdp redirect")
Reported-and-analyzed-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 2f8a4cfc5fa1..824c776a3abc 100644
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
@@ -2021,11 +2022,18 @@ static void ixgbe_add_rx_frag(struct ixgbe_ring *rx_ring,
 static struct ixgbe_rx_buffer *ixgbe_get_rx_buffer(struct ixgbe_ring *rx_ring,
 						   union ixgbe_adv_rx_desc *rx_desc,
 						   struct sk_buff **skb,
-						   const unsigned int size)
+						   const unsigned int size,
+						   int *rx_buffer_pgcnt)
 {
 	struct ixgbe_rx_buffer *rx_buffer;
 
 	rx_buffer = &rx_ring->rx_buffer_info[rx_ring->next_to_clean];
+	*rx_buffer_pgcnt =
+#if (PAGE_SIZE < 8192)
+		page_count(rx_buffer->page);
+#else
+		0;
+#endif
 	prefetchw(rx_buffer->page);
 	*skb = rx_buffer->skb;
 
@@ -2055,9 +2063,10 @@ static struct ixgbe_rx_buffer *ixgbe_get_rx_buffer(struct ixgbe_ring *rx_ring,
 
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
@@ -2308,6 +2317,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		union ixgbe_adv_rx_desc *rx_desc;
 		struct ixgbe_rx_buffer *rx_buffer;
 		struct sk_buff *skb;
+		int rx_buffer_pgcnt;
 		unsigned int size;
 
 		/* return some buffers to hardware, one at a time is too slow */
@@ -2327,7 +2337,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		 */
 		dma_rmb();
 
-		rx_buffer = ixgbe_get_rx_buffer(rx_ring, rx_desc, &skb, size);
+		rx_buffer = ixgbe_get_rx_buffer(rx_ring, rx_desc, &skb, size, &rx_buffer_pgcnt);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -2372,7 +2382,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			break;
 		}
 
-		ixgbe_put_rx_buffer(rx_ring, rx_buffer, skb);
+		ixgbe_put_rx_buffer(rx_ring, rx_buffer, skb, rx_buffer_pgcnt);
 		cleaned_count++;
 
 		/* place incomplete frames back on ring for completion */
-- 
2.25.1

