Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8C62EF64F
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 18:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbhAHRMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 12:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbhAHRMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 12:12:40 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C663BC0612FD
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 09:11:59 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id z3so6970769qtw.9
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 09:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w66f1ZKevlb8Uuzhhrx+rTk8V4QHn7SP2CQf7TQF9Oo=;
        b=OLQKzZhbc8dBDAE91N2+hR3D310lXs0s6svgMaeHQLcO/ATZxlwzVDg+W0uxkp0ioP
         fjwu5KrmMGOH//RVWcrulso+xlx3lxMQZ2rNUuqSOetu937SqVYhmVedBbWX5whAEpY4
         FMEaB2fIGg4bwukLyM9gJcZM97OOUx1r8BT/3zVQ/sKTLbgpRWP0RDJE1ICu8iAJDFxB
         hZcAWYvaxfT1sFMtOdxMUL6cjOOOxMtObu5xIyke3G+nVPv1GiCRoEbzgfnU1KUOhmXq
         +8sxTuwGqLwWzWWg3r5ztLIY0hn2aVt2Lsu/LLLFjfxIDqn6WEpa7ga6tOeP05AQyjVY
         OP6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w66f1ZKevlb8Uuzhhrx+rTk8V4QHn7SP2CQf7TQF9Oo=;
        b=R1WCJ3TWJ5P26zJdikJ/Tt+ESNAl5sI/HyAXMTfikhNJL3KWZ5b1TZcksF3zzWAlPy
         r9wyD9kNOhNyBmDXHW56ruqZRxZIEzfWGEPxkS8LdyoOk+C3emB+I2sfpMIToLZGTkAO
         Ybstp25XsNFBMesTM7Va6hiZnrFYVgsWBCP1sO10qqDH2G6Ip7b2vQNGHR165GZmU/sr
         LDnJTa+Ngn1kxu/roz81yyBlHHA3HUpIZ48D/ke1Qmu9FXcRNqoYsrDI1N27gaJoLtPq
         sSObe/ywT8Uct2vrtnBXw2beBGsghEdmqH18kV5QsrVWlRsJk0rD1OHzse3edLfs/Ses
         lhHQ==
X-Gm-Message-State: AOAM532MKZ6Q1s/bovLXT6UFYvGLrikdXfH7Pkzx953tk8poZOlKv+3J
        Q0jtbrTmwMIJDyU9HcAwE5RpeSw67XM=
X-Google-Smtp-Source: ABdhPJyhcSS+Cco1suepuC+PlCNOu0xn/VeI8ycAjLpBOvs5skd1u0VHwZ5pimVRCcfSfWesFGp/fA==
X-Received: by 2002:a05:622a:208:: with SMTP id b8mr4549621qtx.124.1610125918609;
        Fri, 08 Jan 2021 09:11:58 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id c2sm5081600qke.109.2021.01.08.09.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 09:11:57 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net 3/3] esp: avoid unneeded kmap_atomic call
Date:   Fri,  8 Jan 2021 12:11:52 -0500
Message-Id: <20210108171152.2961251-4-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
In-Reply-To: <20210108171152.2961251-1-willemdebruijn.kernel@gmail.com>
References: <20210108171152.2961251-1-willemdebruijn.kernel@gmail.com>
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

