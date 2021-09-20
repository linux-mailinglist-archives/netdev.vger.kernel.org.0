Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4897412991
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 01:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239514AbhITXui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 19:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239852AbhITXsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 19:48:37 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E055CC0313D5;
        Mon, 20 Sep 2021 10:47:19 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f3-20020a17090a638300b00199097ddf1aso43401pjj.0;
        Mon, 20 Sep 2021 10:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KX+qJ6QxxdZWgtPQyYSlC2wD8Lj+T2sz39am4Jm+46M=;
        b=D4/eY8LMBNeGqBXmX0lN+NutmWsBuRPEOsa7xNFNM1OIPht7Xb486B9TdvMMQv2jy8
         NEj39TYJwSgaa764m/2rY3Pzw8BGAVZKTySw69JdF9FnA1VePztHLo/MohdIQ/nghVFs
         2lhsRcAzVpDdnrO7Tjlf1++fAEBVEBx2kypLJife1doKsuVQu8UTVanybVgRyrTpayUK
         glme1BtcsB9uVufDXaMO658C+gMfTvfAGcjDzHZmVBeV5Nlb0fQXJclEZXRu7glfytmg
         So6sTIpozv5LA7p+J4f7m4eHmaGnObEJhNYinh18al7vW2KryxW0aBzXoUv8kSOOo3h+
         gUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KX+qJ6QxxdZWgtPQyYSlC2wD8Lj+T2sz39am4Jm+46M=;
        b=Z70rhKK2Tc5JCHpfuXBNknE1HojlUYjRdLOZTS5B0v7CetATuZ0JKYgYKtVDoATvk0
         fF/uInLc5gEx7wy907gpxlWZHzi/Wk+C9PPxHlQDkiiHNtERhDdhi+/Lt6La4wmWW7XU
         RhDGmHUiHgkWSHccspByiD3KBAd7uq4gFvf43bgb+dagcrWyhwz0TVT8LqyWGSu2C20I
         2Z+UlzHLyzYHtNKowdZnUkV/20EDrY6XSQ4fxcoQwKtQSDHubgQR/Qe9USWdogQrF1/T
         cm6dNryXfgL0CwaEU82vvinSfkpNWnUR18rmRmvf/QKlr9QSiE0nnbzjzykDA41lF4nU
         bTDw==
X-Gm-Message-State: AOAM531kuhpz2Cb6GAHQ80Vu6fkGaBde3OIOm9AZlyz7raqsJ9b/rr9w
        qN++xVQRiccr6/+873NxEMn0gKb8mKlp9aTP
X-Google-Smtp-Source: ABdhPJxDz/0vGs6IU2JCsMxhsLcPblmNfhXdhPNWSigpAytWJ+0u/Bo5ZwCdKZS6j1j9E2/l/iReBA==
X-Received: by 2002:a17:90b:4c44:: with SMTP id np4mr278578pjb.30.1632160039380;
        Mon, 20 Sep 2021 10:47:19 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id q21sm15801281pgk.71.2021.09.20.10.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 10:47:18 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next] Introducing lockless cache built on top of slab allocator
Date:   Tue, 21 Sep 2021 02:47:13 +0900
Message-Id: <20210920174713.4998-1-l4stpr0gr4m@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is just introducing and proof of concept.
The patch code is based on other RFC patches. So, the code is not
correct yet, it is just simple proof of concept.

Recently block layer implemented percpu, lockless cache on the top
of slab allocator. It can be used for IO polling.

Link: https://lwn.net/Articles/868070/
Link: https://www.spinics.net/lists/linux-block/msg71964.html

It gained some IOPS increase (performance increased by about 10%
on the block layer).

And there are attempts to implement the percpu, lockless cache.

Link: https://lore.kernel.org/linux-mm/20210920154816.31832-1-42.hyeyoo@gmail.com/T/#u

If this cache is implemented successfully,
how about use this cache to allocate skb instead of kmem_cache_alloc_bulk()
in napi_skb_cache_get()?

I want your comment/opinion.

Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
 net/core/skbuff.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7c2ab27fcbf9..f9a9deca423d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -170,11 +170,15 @@ static struct sk_buff *napi_skb_cache_get(void)
 	struct napi_alloc_cache *nc = this_cpu_ptr(&napi_alloc_cache);
 	struct sk_buff *skb;
 
-	if (unlikely(!nc->skb_count))
-		nc->skb_count = kmem_cache_alloc_bulk(skbuff_head_cache,
-						      GFP_ATOMIC,
-						      NAPI_SKB_CACHE_BULK,
-						      nc->skb_cache);
+	if (unlikely(!nc->skb_count)) {
+		/* kmem_cache_alloc_cached should be changed to return the size of
+		 * the allocated cache
+		 */
+		nc->skb_cache = kmem_cache_alloc_cached(skbuff_head_cache,
+							GFP_ATOMIC | SLB_LOCKLESS_CACHE);
+		nc->skb_count = this_cpu_ptr(skbuff_head_cache)->size;
+	}
+
 	if (unlikely(!nc->skb_count))
 		return NULL;
 
-- 
2.26.2

