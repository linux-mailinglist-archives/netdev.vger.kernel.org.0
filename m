Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E112F0412
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbhAIWTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbhAIWTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 17:19:30 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C27C0617A3
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 14:18:50 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id u26so13764966iof.3
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 14:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w66f1ZKevlb8Uuzhhrx+rTk8V4QHn7SP2CQf7TQF9Oo=;
        b=HCxftBJO6Fto1tmxb/jAR4IIKczm3y+Owfm4Tkv64r/ZUdyqgDQTCW3sKZ7YB1IQi6
         O8qgDGchSjK9x93nNnbxt+X1QP3Sjfi8e5Ab54wHt4jMr7Q9UJ+MHsAtjiucCBwtcdBv
         2fCXa5bgFEVFXOa1LyoX/PhA74sk81+PQ3AUv8cjcugOkVTv4/345kqqr7HPUFBwmkes
         vEW/COGkHlQVZt8YmaScvVt9MU9Itk+bXzvj8zbohviza79DiR0zU25F7PbULe5YB0C8
         wB02XlJ3yDU/vGepcNAwkWljinAFt340cLRf124Tm9os8FkcJ6H7MMCLluGNqECM6T3J
         SpYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w66f1ZKevlb8Uuzhhrx+rTk8V4QHn7SP2CQf7TQF9Oo=;
        b=D4Xj2rCpU3vV6+PoM9uCz+ZaAwNvYdESko51ey9oeIEFDVg6Kglo5Ig7zbiqiUySBV
         ZmaAVDxWSblTXW82BuvSY+84UIoO/eu2ei0MzSt8LmL4Az5qXm5gsQQIxIVf4urDSb0v
         kIVoXNXmTukpm56uqnYGCg3b9O5cU5ZVBiYfTIY2JgvwSGbS72tQtmrvrcTAfPV12esV
         SYhB4EDNnkdXqrUcSe7mBoeOKfIiKRy7bVMQgGGUbcdYq2Zz/OVmJQTufixTgoCNnGJ8
         4FKHQCJFSIDAwxbhdbS/lxEwfNLYNuESBFWXW8I+0fxTAi7CSg0gwo96I064RhcWFPJS
         B4/w==
X-Gm-Message-State: AOAM532dIFPlCK+K/LtIXjm6O7xYIKU5i1JCHcdrGEmNZIargEoyHUds
        fsYEQyuWowEGop95sPlk1FxTx8Kim4Q=
X-Google-Smtp-Source: ABdhPJyI2q5F2Fn/fnRj4cXcgifp+EIeePuJSf49Wur4tpb0l5TKpmgqJ5QkuDppwqu2wWsm0pm6rQ==
X-Received: by 2002:a5e:dd0d:: with SMTP id t13mr10562117iop.132.1610230729135;
        Sat, 09 Jan 2021 14:18:49 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id i27sm11415849ill.45.2021.01.09.14.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 14:18:48 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net v2 3/3] esp: avoid unneeded kmap_atomic call
Date:   Sat,  9 Jan 2021 17:18:34 -0500
Message-Id: <20210109221834.3459768-4-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
In-Reply-To: <20210109221834.3459768-1-willemdebruijn.kernel@gmail.com>
References: <20210109221834.3459768-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

esp(6)_output_head uses skb_page_frag_refill to allocate a buffer for
the esp trailer.

It accesses the page with kmap_atomic to handle highmem. But
skb_page_frag_refill can return compound pages, of which
kmap_atomic only maps the first underlying page.

skb_page_frag_refill does not return highmem, because flag
__GFP_HIGHMEM is not set. ESP uses it in the same manner as TCP.
That also does not call kmap_atomic, but directly uses page_address,
in skb_copy_to_page_nocache. Do the same for ESP.

This issue has become easier to trigger with recent kmap local
debugging feature CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP.

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Fixes: 03e2a30f6a27 ("esp6: Avoid skb_cow_data whenever possible")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4.c | 7 +------
 net/ipv6/esp6.c | 7 +------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 8b07f3a4f2db..a3271ec3e162 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -443,7 +443,6 @@ static int esp_output_encap(struct xfrm_state *x, struct sk_buff *skb,
 int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	u8 *tail;
-	u8 *vaddr;
 	int nfrags;
 	int esph_offset;
 	struct page *page;
@@ -485,14 +484,10 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 			page = pfrag->page;
 			get_page(page);
 
-			vaddr = kmap_atomic(page);
-
-			tail = vaddr + pfrag->offset;
+			tail = page_address(page) + pfrag->offset;
 
 			esp_output_fill_trailer(tail, esp->tfclen, esp->plen, esp->proto);
 
-			kunmap_atomic(vaddr);
-
 			nfrags = skb_shinfo(skb)->nr_frags;
 
 			__skb_fill_page_desc(skb, nfrags, page, pfrag->offset,
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 52c2f063529f..2b804fcebcc6 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -478,7 +478,6 @@ static int esp6_output_encap(struct xfrm_state *x, struct sk_buff *skb,
 int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	u8 *tail;
-	u8 *vaddr;
 	int nfrags;
 	int esph_offset;
 	struct page *page;
@@ -519,14 +518,10 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 			page = pfrag->page;
 			get_page(page);
 
-			vaddr = kmap_atomic(page);
-
-			tail = vaddr + pfrag->offset;
+			tail = page_address(page) + pfrag->offset;
 
 			esp_output_fill_trailer(tail, esp->tfclen, esp->plen, esp->proto);
 
-			kunmap_atomic(vaddr);
-
 			nfrags = skb_shinfo(skb)->nr_frags;
 
 			__skb_fill_page_desc(skb, nfrags, page, pfrag->offset,
-- 
2.30.0.284.gd98b1dd5eaa7-goog

