Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E692443D2BF
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbhJ0UWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239322AbhJ0UWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:22:06 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46422C061745
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:40 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id r5so2847395pls.1
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hQp9I3UY+cb3smQP00qjbPxl0RAUnYl8lVgQGUFwZ1M=;
        b=aIu2M+zRw9gf0/hfaRSKrh1FepyqD6pgS3CGGbpDHpmTYehc04u6Jv7sxxfWQB9yJ9
         V3S6HKtFLZDVqolilV0SQKlg4NK8tbsbVsAuCSHbKkwYk3UjBoNoZUmZt97qu3a2hCvK
         QyRQXWl9Zw8lL+z5M6KPyeM28oOEzGlwE9Tqpfs0BcJJgd0yenoM9aei6R1nqnn/pHTV
         h3AVJOF1qOE3+prnUTRJG557c4LZpjXn9L1YZJibK1mAGQx+BfWfu69M/qH6y4WGCrhz
         s63yjE2iGgBl6fCFfBJDP7lRvBqS46PK4PR3aAWo0fQZAK5HiXFLXUXA4ciNgzj0Tklo
         dYkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hQp9I3UY+cb3smQP00qjbPxl0RAUnYl8lVgQGUFwZ1M=;
        b=ldYHyFpE4c0FiyYTOctYefiZjehppQP6piksmkqh4WC9I1reM+r5yL1TU/V9/kMkZW
         hpYzoW/5IwcM+XDdw/POyOVz7niKBy7uxAuDaqoh68ARkQKRpBEChO+xWWK+4e8xMgua
         asjGGhyQBCM1e2nsH+pN8kBaO3soaXbNv3rJU+vDSNISoEd8kUKKoUfsfwytl7cmQwxy
         c2rufQkKqkyrxzZG7Uzlol4znwuEyCHgO8REQdYY8bsFBynOd3lxbDxqR2a5Lv0GPsK+
         WzzUK83KxhciqFReExKXQSw1gBbIPfwog4GB7Bdl4jS8mHyHApZDi8CR3j6u1gnJlDSu
         3G8Q==
X-Gm-Message-State: AOAM531Uyj8hMFXEAfY9WJe6VSp95vicH47f+iXcIlyD/mtcFWeTcyao
        dUxU+ulvoy/4GTUeo9+sxW0=
X-Google-Smtp-Source: ABdhPJwPGPEmFFIAqwwIf4cutJfBXKKtJFUBDKHBSq4l2GleF2qQJ9tJyvgEjADIOGVEYHe7T5QRsQ==
X-Received: by 2002:a17:90a:4d44:: with SMTP id l4mr8063066pjh.64.1635365979865;
        Wed, 27 Oct 2021 13:19:39 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:19fb:5287:bbfe:fc2a])
        by smtp.gmail.com with ESMTPSA id fr12sm5338295pjb.36.2021.10.27.13.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:19:39 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 7/7] tcp: do not clear TCP_SKB_CB(skb)->sacked if already zero
Date:   Wed, 27 Oct 2021 13:19:23 -0700
Message-Id: <20211027201923.4162520-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211027201923.4162520-1-eric.dumazet@gmail.com>
References: <20211027201923.4162520-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Freshly allocated skbs have zero in skb->cb[] already.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c        | 1 -
 net/ipv4/tcp_output.c | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 88475b64034432d4bb3c6989a69a3041ae6e7711..7a7b9aa8f19a76861b2aa21395e085c1dde6deb0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -660,7 +660,6 @@ void tcp_skb_entail(struct sock *sk, struct sk_buff *skb)
 
 	tcb->seq     = tcb->end_seq = tp->write_seq;
 	tcb->tcp_flags = TCPHDR_ACK;
-	tcb->sacked  = 0;
 	__skb_header_release(skb);
 	tcp_add_write_queue_tail(sk, skb);
 	sk_wmem_queued_add(sk, skb->truesize);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5664355b0d09abc701ba7b422340ed9699bc71f0..6867e5db3e352d35b94b212db8b72f88672e3d1d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -394,7 +394,6 @@ static void tcp_init_nondata_skb(struct sk_buff *skb, u32 seq, u8 flags)
 	skb->ip_summed = CHECKSUM_PARTIAL;
 
 	TCP_SKB_CB(skb)->tcp_flags = flags;
-	TCP_SKB_CB(skb)->sacked = 0;
 
 	tcp_skb_pcount_set(skb, 1);
 
@@ -2139,9 +2138,6 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 	TCP_SKB_CB(skb)->tcp_flags = flags & ~(TCPHDR_FIN | TCPHDR_PSH);
 	TCP_SKB_CB(buff)->tcp_flags = flags;
 
-	/* This packet was never sent out yet, so no SACK bits. */
-	TCP_SKB_CB(buff)->sacked = 0;
-
 	tcp_skb_fragment_eor(skb, buff);
 
 	skb_split(skb, buff, len);
@@ -2397,7 +2393,6 @@ static int tcp_mtu_probe(struct sock *sk)
 	TCP_SKB_CB(nskb)->seq = TCP_SKB_CB(skb)->seq;
 	TCP_SKB_CB(nskb)->end_seq = TCP_SKB_CB(skb)->seq + probe_size;
 	TCP_SKB_CB(nskb)->tcp_flags = TCPHDR_ACK;
-	TCP_SKB_CB(nskb)->sacked = 0;
 
 	tcp_insert_write_queue_before(nskb, skb, sk);
 	tcp_highest_sack_replace(sk, skb, nskb);
-- 
2.33.0.1079.g6e70778dc9-goog

