Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADE545627A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhKRSj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbhKRSj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:39:28 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B620C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:36:28 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so7235790pjj.0
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YlTzf9HvsnD/SJ7tagvq7ACsKvenWN0xKNiM3KMMUjI=;
        b=L2m0yzLSotnm5qOw5oEC310OpEIX/1/G2/HPA/hzE+S5RgUXU9+wCDsM/XsCbk/xjf
         Gv3SAVMRWjvbh1g6nSdg4zAIl2Oh4KD46+RtrTs5zUI4iE2Y0a6r0M1g/VKN+URZBIf9
         vTlgMQCrR3lJWcmG2s4wbCbQQywSkYRphwksI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YlTzf9HvsnD/SJ7tagvq7ACsKvenWN0xKNiM3KMMUjI=;
        b=Wq7NPmZ09c1ZXUU4rNkbfjG4ADZ1yCTd6KZlOh5lV8j72qPXo5HtSoC+BeQqE+Yp2+
         NTqV7DBD60ce4O+zMo4YVUVaAaX1A4g5WWGwBJW+t4rGfdpUPMu3FzSnnUujmeZtfgB0
         XFmNSJhuqGFm95l+GoqdsEdkBwu3ufCd8PQNZgU5nUn55IihNvyBna/tPHBj23R+AjKO
         E0sRDimxwi60RZ7aDWEnlJoWKIB1iyd0jDgccZD4/P4RDwWNYDbV+4DmCNQ68MXctOCM
         N+2+uEORvFbX5AmG1OzKcwjfoLFog8/mn3PVlILlcfc2oN9swveBjbqYfs2J/yPQ1N1n
         Ncjw==
X-Gm-Message-State: AOAM530R3wAR+ZY9rwkOEYZ/l5uWe4/+qm8U6JXUi2HSBjH29gZc4x0F
        nP1gzqUcW++lS8aFZ4X00G+vXw==
X-Google-Smtp-Source: ABdhPJwLw/Z+NiFLVitVLmhyKbYnnP+vsm8CyogXNh3orPUSnIpPrvpiL3fuFgJdsJZuPmgJoaHZAw==
X-Received: by 2002:a17:902:c245:b0:141:f279:1c72 with SMTP id 5-20020a170902c24500b00141f2791c72mr67786012plg.18.1637260587856;
        Thu, 18 Nov 2021 10:36:27 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a11sm314924pfh.108.2021.11.18.10.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:36:27 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] skbuff: Switch structure bounds to struct_group()
Date:   Thu, 18 Nov 2021 10:36:15 -0800
Message-Id: <20211118183615.1281978-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4061; h=from:subject; bh=eLrpED7FZqUoJk+VlPqZr/4GZEqJGGaAVIJQscuOOaA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlp0fyYfop8bO0CmUbw53UxC0mPage9gmgeRuKkzh 5o9H7xKJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZadHwAKCRCJcvTf3G3AJvQSEA CbhDo0mTa0pyUIROF4KRjFgnwaE6Q6O9STI5LWIwL9s5/YFPFrHJQS7Pkhsnh24AYdYYG9vSiFZc75 jzk9C6S/YPGf2Vih3hjo8xBmYGPU2nX5VniojXu0bGk898GpLwnxBlHWyMNypy/f+w/rutgR1VlEWJ V9uTEapdU891FoF5pGnfINzN7r+lFb+aSunXyVBnlyL/8zL469x749ZxC0e71XwYseQX7RN0sl6241 tMdh0Mmn+5jaKnReK6BmUqM45ACZ9Mr7qq7lqb+DJOHBpykmo7vBCZZY9ASOo0rjleM5j7SFcugteI vJj9PQywHLn1Up+d/K0CXsuqqILFwG543GFlPYK6orIoVTH8ArnkTnzyueFDqGSmWzwOtzt8jbQGq0 eFebclVzxo2Qhx13FwNeZRPMUcVp0ZRjnbwvqMKOuTRYGMlcsnHjK+WJGy6yu2jnOPsM77XsYiTQhS e78+TXl+pz00Qk3f4uNH/eMlG3vBWBuDy/jPMkLvbydZnZxpCl3TbDa1ig/J4i+E3SXifNsRYYvMOl V2kzgpxP8QnA8mhtQ8RCGRHk65eBpWGKmtx7rmIUD28KnrzdvHOwtGxNFmJF+Vdq2istdyctGyGsQU HYJ+DKF8jDxz9wMjquNNDyLClqKt1ZcDmn8A18Jtti8okrpLyZ5drZWI+cUQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Replace the existing empty member position markers "headers_start" and
"headers_end" with a struct_group(). This will allow memcpy() and sizeof()
to more easily reason about sizes, and improve readability.

"pahole" shows no size nor member offset changes to struct sk_buff.
"objdump -d" shows no object code changes (outside of WARNs affected by
source line number changes).

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com> # drivers/net/wireguard/*
---
 drivers/net/wireguard/queueing.h |  4 +---
 include/linux/skbuff.h           | 10 +++-------
 net/core/skbuff.c                | 14 +++++---------
 3 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index 4ef2944a68bc..52da5e963003 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -79,9 +79,7 @@ static inline void wg_reset_packet(struct sk_buff *skb, bool encapsulating)
 	u8 sw_hash = skb->sw_hash;
 	u32 hash = skb->hash;
 	skb_scrub_packet(skb, true);
-	memset(&skb->headers_start, 0,
-	       offsetof(struct sk_buff, headers_end) -
-		       offsetof(struct sk_buff, headers_start));
+	memset(&skb->headers, 0, sizeof(skb->headers));
 	if (encapsulating) {
 		skb->l4_hash = l4_hash;
 		skb->sw_hash = sw_hash;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 686a666d073d..875adfd056b6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -808,12 +808,10 @@ struct sk_buff {
 	__u8			active_extensions;
 #endif
 
-	/* fields enclosed in headers_start/headers_end are copied
+	/* Fields enclosed in headers group are copied
 	 * using a single memcpy() in __copy_skb_header()
 	 */
-	/* private: */
-	__u32			headers_start[0];
-	/* public: */
+	struct_group(headers,
 
 /* if you move pkt_type around you also must adapt those constants */
 #ifdef __BIG_ENDIAN_BITFIELD
@@ -932,9 +930,7 @@ struct sk_buff {
 	u64			kcov_handle;
 #endif
 
-	/* private: */
-	__u32			headers_end[0];
-	/* public: */
+	); /* end headers group */
 
 	/* These elements must be at the end, see alloc_skb() for details.  */
 	sk_buff_data_t		tail;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ba2f38246f07..3a42b2a3a571 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -992,12 +992,10 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 }
 EXPORT_SYMBOL(napi_consume_skb);
 
-/* Make sure a field is enclosed inside headers_start/headers_end section */
+/* Make sure a field is contained by headers group */
 #define CHECK_SKB_FIELD(field) \
-	BUILD_BUG_ON(offsetof(struct sk_buff, field) <		\
-		     offsetof(struct sk_buff, headers_start));	\
-	BUILD_BUG_ON(offsetof(struct sk_buff, field) >		\
-		     offsetof(struct sk_buff, headers_end));	\
+	BUILD_BUG_ON(offsetof(struct sk_buff, field) !=		\
+		     offsetof(struct sk_buff, headers.field));	\
 
 static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 {
@@ -1009,14 +1007,12 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	__skb_ext_copy(new, old);
 	__nf_copy(new, old, false);
 
-	/* Note : this field could be in headers_start/headers_end section
+	/* Note : this field could be in the headers group.
 	 * It is not yet because we do not want to have a 16 bit hole
 	 */
 	new->queue_mapping = old->queue_mapping;
 
-	memcpy(&new->headers_start, &old->headers_start,
-	       offsetof(struct sk_buff, headers_end) -
-	       offsetof(struct sk_buff, headers_start));
+	memcpy(&new->headers, &old->headers, sizeof(new->headers));
 	CHECK_SKB_FIELD(protocol);
 	CHECK_SKB_FIELD(csum);
 	CHECK_SKB_FIELD(hash);
-- 
2.30.2

