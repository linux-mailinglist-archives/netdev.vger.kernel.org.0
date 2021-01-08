Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA47B2EF649
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 18:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbhAHRMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 12:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbhAHRMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 12:12:37 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3248C061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 09:11:57 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id h19so6956696qtq.13
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 09:11:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zX1KVOpyBappsSnNg0k+iRQDKdP/WgwvzGOnOf5giSM=;
        b=Gns2tIgzxbMxLmQ+hdSG92lrKSG/hYJQU0qqJMpNzRJHfIL2ig4zjnsZp43bS3ICzF
         oDsOAat1aB9Qf7DHMRrjtHN374clGzzlWGjD30rZ88hFz94t5WvFk6drTWe/o/lauv/3
         kJ5ZU71117ofgazcQwMFUwsCn7cAKgtDXykYpbypgDp/frdsXXO6Gar5GKVWrOB5xwjH
         xRW58E/oV/9pRPgkcP0/tNeORR/sY66zrbsz7h4S0deEE6qngN3reG1Hiq8JIuAlmIDr
         PksFSe9pSy0IV+h1mIXHmlr0PBmicOE8f6CyUi2sEQGOdUVwwY7yOXUSGXEFkgrLg9Sx
         cPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zX1KVOpyBappsSnNg0k+iRQDKdP/WgwvzGOnOf5giSM=;
        b=WckpWdLoNzimXXnBDIA5TEkuI8TYqXJSiTZ3bv7MCiDXpcAriA2aWxXB+8m1c+cXSH
         YS7NJBKNn9zEMo7XyXJ4S9XIDJ2d5jZm6jazIV0Ivt8uX7GLkrRTDSsWpzhCAtWBGkbF
         lZPP4DI39KfnzpONyn7fBZ85KVVvBsuhN9gUyxS6xutW9t/P1pMpkOwiIwMw5ZdqyIAj
         lLpxdvuOeKsMx9CR3P5wgAYEsp6a2JWAKlQ8M+eQ94n2vraDTFmLxAc14D2gbGy1SDzo
         /2NeksioRUNeVNkkc3zkJbqlzICeFkqWF/BA7KPYDvAhSNGZuWTFBsHBUhQRgEOEZPNA
         fmTQ==
X-Gm-Message-State: AOAM530mCRIIH6p/ukj9pZ8vyWGFtqero3txIUZxidPZzf+mrnTrPJJC
        478s+7lDThIZ2tyvSWu6+eQf02J4+ko=
X-Google-Smtp-Source: ABdhPJzgjMxHdL206Nwy03LxFc5ollQ6smzj160B+5ezhnZ3D6f6R9DAFo0XteTWbb9kLr1NH32H5w==
X-Received: by 2002:ac8:6f77:: with SMTP id u23mr4486363qtv.118.1610125916643;
        Fri, 08 Jan 2021 09:11:56 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id c2sm5081600qke.109.2021.01.08.09.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 09:11:55 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH net 1/3] net: support kmap_local forced debugging in skb_frag_foreach
Date:   Fri,  8 Jan 2021 12:11:50 -0500
Message-Id: <20210108171152.2961251-2-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
In-Reply-To: <20210108171152.2961251-1-willemdebruijn.kernel@gmail.com>
References: <20210108171152.2961251-1-willemdebruijn.kernel@gmail.com>
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

