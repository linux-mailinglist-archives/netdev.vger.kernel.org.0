Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A687943A65B
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhJYWQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhJYWQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 18:16:10 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134A6C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 15:13:48 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so583948pje.0
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 15:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m7iabE0+4yufql12fKo8HPgyYuWgvD4a915iTVOnQz4=;
        b=AkSgFNUbH4kwza1EjnFOWnTWPF+8+U7BED6w3rpXF5IfIWqbpcILS8NWQWK0zqHfx1
         iqhUMcEnaXGs2bHQiDeLMbYjALdEDCP39LEJd2mIBhq6fX1/hx7zMrAjA/PcZXJDHw7c
         e4iZKgZdOm4v/+c8HY4/lQI11oWpQze9o+q4ngincAqu+VdZDoTxPIoTtlx8smUPdxym
         W1p4zUOOX/mv0thleD1RPxoJUGOcYVXOej6u8MeCX+sPzgzZU9vfh7D1EP90O4VnADXW
         S4IxQrdjZhSb+F7QmO5gD+9UPdFAFR35WEMCIFCbXSZew2bIXBLV/G8huLxMYlwnxju2
         Bo+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m7iabE0+4yufql12fKo8HPgyYuWgvD4a915iTVOnQz4=;
        b=PblwcccAZC+7wmouJ5W/B3LfYor/rxSVTPYDtBRi1mj5OcddhdXIzbkIPzq7reQWhp
         0NRpV4mp2kWAFWgKdYKR4txO8YFkB9sqIcB626jIQN2JhMyds31H9+XAE7BxD1icRvTs
         dfkub/kwfvJlG62Hc6yZMtejFuZCnt1tVZKb28k7BEERX54Oc9DdbnRW8OZZTmP6YblG
         3Z8YYq/h1Sdu8+NZXHbpI36dq0YIFGM/oU8egDq5wuBaKO9b+GAIYTqO+7FEroEbPcMz
         ib4zHYehqOFT2B7SUyNCXuN1wCfpi5jo4qHIYxzGfugB74FIJb1es2HfSyEd/8/2d8Yw
         Zq2Q==
X-Gm-Message-State: AOAM53032BHx2Y7K+HiEdfOltqECRi03DBb+O8fsaVohQMJKzURB6Hzj
        eglBWT8HNhMHa6BnrZsNVRQ=
X-Google-Smtp-Source: ABdhPJxqGCKfnkKe9UsytvqMUM/9nRR3mkBYnrn9EkhFofgeArP5pl77SSWwmW5/QIhdnalfesEZEg==
X-Received: by 2002:a17:90a:6b0b:: with SMTP id v11mr24621444pjj.178.1635200027687;
        Mon, 25 Oct 2021 15:13:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id f15sm22351108pfe.132.2021.10.25.15.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 15:13:47 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/3] tcp: use MAX_TCP_HEADER in tcp_stream_alloc_skb
Date:   Mon, 25 Oct 2021 15:13:41 -0700
Message-Id: <20211025221342.806029-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211025221342.806029-1-eric.dumazet@gmail.com>
References: <20211025221342.806029-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Both IPv4 and IPv6 uses same reserve, no need risking
cache line misses to fetch its value.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 68dd580dba3d0e04412466868135c49225a4a33b..121400557fde898283a8eae3b09d93479c4a089e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -867,7 +867,7 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 	if (unlikely(tcp_under_memory_pressure(sk)))
 		sk_mem_reclaim_partial(sk);
 
-	skb = alloc_skb_fclone(size + sk->sk_prot->max_header, gfp);
+	skb = alloc_skb_fclone(size + MAX_TCP_HEADER, gfp);
 	if (likely(skb)) {
 		bool mem_scheduled;
 
@@ -878,7 +878,7 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 			mem_scheduled = sk_wmem_schedule(sk, skb->truesize);
 		}
 		if (likely(mem_scheduled)) {
-			skb_reserve(skb, sk->sk_prot->max_header);
+			skb_reserve(skb, MAX_TCP_HEADER);
 			/*
 			 * Make sure that we have exactly size bytes
 			 * available to the caller, no more, no less.
-- 
2.33.0.1079.g6e70778dc9-goog

