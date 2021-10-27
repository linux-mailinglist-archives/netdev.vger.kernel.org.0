Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453A643D2B9
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238627AbhJ0UV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbhJ0UVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:21:54 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AE8C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id in13so586007pjb.1
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kfwB6qoOHuGBEL7W0pzkeDjfh9Ste+Vt+lwQy8VDrgA=;
        b=HsB/tJZlTwAcxjGTCTJ9/PVNQg0jfQZdBkOA26e7Men3BQhsObftBI1rym+YxOnzo0
         K+I8c8nisX/l79BtBgOX4rYSfgOGE5FOvSLAWwJOW1C9f30kVqJ6+ByKApYza0oJRFmI
         MJ/ppZ3hNxj/gxJb1mpCTY5QsS6yhiBsBuASjqkWnC5jJCwc3cDaHpBHf7W9dfhqyUsq
         tCa0OiWnuPNg7FwG1im/enFPftqteOUMpjZvZBzTo89xOyIxAahArTvDHzdT/7HJYKlX
         TPgjO6c6gwq2QHIoxr0M1ZNVfswRoLtQQBHCK/We2e811OqpVBEC5ead8PYW2YWRW+3F
         YGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kfwB6qoOHuGBEL7W0pzkeDjfh9Ste+Vt+lwQy8VDrgA=;
        b=YFwyaLIlAiqi4HSBhNQZ/C7pieLpZPn4lXrS7XZY6N/aK9u7tKrJSm3wWxyLgzVkap
         Tyrp2s9QwMIytRJ1bMmRY1y9UmhZHy9Yn0yfI1I9XTgWtNNJx6x/vZ2OY9m5ebczmuPq
         Q8JY+Xvr9CoCjrj45Z2OHb0HTQ1hmDFObmBeOk+GffXFG0aFzC3ZmWAHnT12Gcu+qnnD
         m8w3+o0hYIyzF375HESywoc+aS1WHvRIzp28L9WJwI7HxR/gCRrkR9yFZQCU6WEMW8pm
         xVwZ6Wby+pMZnFpZf2yvyfRRNzw1Lrn39+nUddRIGX7eZrmkrqM6yWTn2i7w4+ZQB39l
         laSg==
X-Gm-Message-State: AOAM530Sg+nNrtwiXiQyBrZ0eh38Oo/+kbtmD1bHPr4HIoTUv/nD7Bym
        6UA8phwHuh9hWfrY+i1JAHo=
X-Google-Smtp-Source: ABdhPJxodx+jwDEHYUWjuZ6oBXDsnh2Ou5u+uFsMxMi0xNISGXsth8iF45K47WMTzDz4OaIv1L952A==
X-Received: by 2002:a17:90b:4c4a:: with SMTP id np10mr8206536pjb.233.1635365968182;
        Wed, 27 Oct 2021 13:19:28 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:19fb:5287:bbfe:fc2a])
        by smtp.gmail.com with ESMTPSA id fr12sm5338295pjb.36.2021.10.27.13.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:19:27 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/7] tcp: remove dead code from tcp_sendmsg_locked()
Date:   Wed, 27 Oct 2021 13:19:17 -0700
Message-Id: <20211027201923.4162520-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211027201923.4162520-1-eric.dumazet@gmail.com>
References: <20211027201923.4162520-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

TCP sendmsg() no longer puts payload in skb head, we can remove
dead code.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d0b848ff5c0f1f7c34cea1b178b700c264893724..4053ace0cd76fbf076e422017fa31a472f00d7ba 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1309,14 +1309,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (copy > msg_data_left(msg))
 			copy = msg_data_left(msg);
 
-		/* Where to copy to? */
-		if (skb_availroom(skb) > 0 && !zc) {
-			/* We have some space in skb head. Superb! */
-			copy = min_t(int, copy, skb_availroom(skb));
-			err = skb_add_data_nocache(sk, skb, &msg->msg_iter, copy);
-			if (err)
-				goto do_fault;
-		} else if (!zc) {
+		if (!zc) {
 			bool merge = true;
 			int i = skb_shinfo(skb)->nr_frags;
 			struct page_frag *pfrag = sk_page_frag(sk);
@@ -1416,7 +1409,6 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 do_error:
 	skb = tcp_write_queue_tail(sk);
-do_fault:
 	tcp_remove_empty_skb(sk, skb);
 
 	if (copied + copied_syn)
-- 
2.33.0.1079.g6e70778dc9-goog

