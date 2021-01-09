Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B792F0410
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbhAIWT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbhAIWT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 17:19:26 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912FFC06179F
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 14:18:46 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id u12so14272828ilv.3
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 14:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zX1KVOpyBappsSnNg0k+iRQDKdP/WgwvzGOnOf5giSM=;
        b=BGeq7W03A8lmjZg8XncyX650Lto6RshxdOPe1f53P4/zfNFGSOlVKut6tCBo7dzDfm
         TqFVS/snbOXB2xvRfKfb3KqrbKEPJD+1Weq4LVTbiYcYb2Y+1Vb6SfZ5O6ESa7+MOlcu
         Hblo5P4w+67sJtPsmkiVpJlP/bdlWlJ0eC38u+abt0tRo3hwVUUbyFXzl3/qSmFlJKty
         l/zBNO/1dRM7dB1nNqCsVjXFSUr1v1fzXkOrR/M8uexau4N4g4ajIoehvzcm+zPmWM4F
         l+yHllR39ohGBMhkgvVQWESE9MYLt45CTl6miRBiS+jE4l98n+PnmzOYtFyngdGP3ROB
         VV0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zX1KVOpyBappsSnNg0k+iRQDKdP/WgwvzGOnOf5giSM=;
        b=YS3Vk98akiOAztpk5xyRrQLBM3CKiDXge4kNOhFIFgsI1FJDcK5DnFc/GdUYtXT3lX
         hmET/zSfUtsprg8YDAVcyqTDFIuMPdfuEKF0EwYUD5dRbECu+PEhFJWh/3z0QLGtysEL
         67X4QH7TSTCAh1SlFcDqn14Ikm3jPyEXSHZANheZe91QtKw6H9aOjzSfSKfxUwih4OHU
         hgVTCyMfy6TdtSBFR8L7Gl1tpWPmNd9kvYCAwCn+CvTt4sHG+ondssZiGV5qSOQ2ZjKm
         eDzYGdiN2WwadGlvjm1/Fl9AQnsOF8qlIXaUdHrzvQVDf55+LgG23lGhFpgea8eo49Z0
         0CRQ==
X-Gm-Message-State: AOAM530mVDQfruyJpCsS73oZi71LOQLi5UoImbCQtaaTjLnCirvQxsOw
        P1+U4t+eCtSiGTjtRuZMhIrwX+JxfY4=
X-Google-Smtp-Source: ABdhPJySX5220PoPVLXNVuNwllS29zPrjdv+r6BpQty3pvNzngqOVJs+3l//ekcsg1AnV0mdlhWiog==
X-Received: by 2002:a05:6e02:18c9:: with SMTP id s9mr8357636ilu.265.1610230725722;
        Sat, 09 Jan 2021 14:18:45 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id i27sm11415849ill.45.2021.01.09.14.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 14:18:45 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH net v2 1/3] net: support kmap_local forced debugging in skb_frag_foreach
Date:   Sat,  9 Jan 2021 17:18:32 -0500
Message-Id: <20210109221834.3459768-2-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
In-Reply-To: <20210109221834.3459768-1-willemdebruijn.kernel@gmail.com>
References: <20210109221834.3459768-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Skb frags may be backed by highmem and/or compound pages. Highmem
pages need kmap_atomic mappings to access. But kmap_atomic maps a
single page, not the entire compound page.

skb_foreach_page iterates over an skb frag, in one step in the common
case, page by page only if kmap_atomic must be called for each page.
The decision logic is captured in skb_frag_must_loop.

CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP extends kmap from highmem to all
pages, to increase code coverage.

Extend skb_frag_must_loop to this new condition.

Link: https://lore.kernel.org/linux-mm/20210106180132.41dc249d@gandalf.local.home/
Fixes: 0e91a0c6984c ("mm/highmem: Provide CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP")
Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Tested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/linux/skbuff.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 333bcdc39635..c858adfb5a82 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -366,7 +366,7 @@ static inline void skb_frag_size_sub(skb_frag_t *frag, int delta)
 static inline bool skb_frag_must_loop(struct page *p)
 {
 #if defined(CONFIG_HIGHMEM)
-	if (PageHighMem(p))
+	if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP) || PageHighMem(p))
 		return true;
 #endif
 	return false;
-- 
2.30.0.284.gd98b1dd5eaa7-goog

