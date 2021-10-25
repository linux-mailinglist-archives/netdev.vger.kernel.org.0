Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF98243A65C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhJYWQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhJYWQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 18:16:12 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B33BC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 15:13:49 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t11so8867548plq.11
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 15:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yxG4+xzDXI12+XDNxP2xEzoUnFRzWOWw6t0IGnV6Cbg=;
        b=OLVn0GfCYMbqKpmogH9rbCKyAqAh5b/0Uqi9/JgeVLBjphcR2P5Vgktb9H4qBq8KGe
         husPyKfuozSKcplrZrte0QisyjWwtDB6ajjtbA+p6A++ZHepoQ+/7TBmtt3xXdNxCCTO
         wTHEJyh+Orr+XHUhVQgfERKqxp0J/L0vySOXikKaD9JVssfefg4W6QurIgzqUTCmlutp
         vS2IChvATW2pV7kgvupYc4NtgF6vO2jXP3tDJQhHApAqbG30USQ7oBEoD7iwLHAG6mxg
         AZheUf5S/S1xtvAwRd104KlaXED6Po6P2GxiQCdqNCSIVBb3AfCkrXsd8Faalq50RVKV
         bRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yxG4+xzDXI12+XDNxP2xEzoUnFRzWOWw6t0IGnV6Cbg=;
        b=geAsHcDbdPoNw0Q6YmGwZSNaBxtz9RT9Q+zH4BFNvasoTdUo/gc3qqdRyzfImO76YO
         Q69zAw2yDu/7t3h4m0LTs7UTzXT82wHCmMnkiB6r2ZK0Bqb1u13aE1mQ1aoU39PkgrF/
         m9PoVVh6lmKayax0WzyuZ1TCJtcAPPeTg9yzBe4Nf0cOtq1F2X5SVBvb4i6D2ax93aCS
         ajZ7A5ExNAbJ3cv6rzvz0NPYp0y4pK3Y46ctcs8g74QzGLkXj4t+4RZauYu7Ote6C6F9
         L7BTRL4pmyF0l2KO8mVIfwgHmUwpj129owW/I5Pi1xOMJAjJQXBNsanRVOCw3LawR+MS
         n2PQ==
X-Gm-Message-State: AOAM531EGEBECknrPeIYZ0sqP8gCayUek0AQwlPfuIkN8uYnR3ECCnPO
        nbVgeI7Xg8GfVTvCmyqIxpq1qzG0sEI=
X-Google-Smtp-Source: ABdhPJxgPIp7gFQKppkYPHAytTPfX1nvAyLrwpzCsps2JtPEX5UVPFcEkBIfBARcvyO4Z5Bp+dYefg==
X-Received: by 2002:a17:90b:4b06:: with SMTP id lx6mr37840012pjb.220.1635200028992;
        Mon, 25 Oct 2021 15:13:48 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id f15sm22351108pfe.132.2021.10.25.15.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 15:13:48 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/3] tcp: remove unneeded code from tcp_stream_alloc_skb()
Date:   Mon, 25 Oct 2021 15:13:42 -0700
Message-Id: <20211025221342.806029-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025221342.806029-1-eric.dumazet@gmail.com>
References: <20211025221342.806029-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Aligning @size argument to 4 bytes is not needed.

The header alignment has nothing to do with @size.

It really depends on skb->head alignment and MAX_TCP_HEADER.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 121400557fde898283a8eae3b09d93479c4a089e..0a27b7ef1a9db8aea8d98cff4b8ab7092994febd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -861,9 +861,6 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 {
 	struct sk_buff *skb;
 
-	/* The TCP header must be at least 32-bit aligned.  */
-	size = ALIGN(size, 4);
-
 	if (unlikely(tcp_under_memory_pressure(sk)))
 		sk_mem_reclaim_partial(sk);
 
-- 
2.33.0.1079.g6e70778dc9-goog

