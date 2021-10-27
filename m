Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF8843D2BE
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbhJ0UWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239306AbhJ0UWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:22:02 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FEEC061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:37 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id c4so4052436pgv.11
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R0iLonij+R27Z6+6JWptuMSg+2MKMt0QXgYcyv0uR2s=;
        b=SbzoDjr3bVei9w8gCEXAsubX1wYeOXrPoD7VTIHxdYnnbHCUlo3Cku8yMEStMZ5nch
         txHBsAmW2g8M41/H91I1vh2nM9ZJ4Io0yApHBwgGg8IVTKwT8Dc+3d0aJwLNRzs8zLpi
         IcAKbiHvWjXHrlc61C/GP5ZlHRBgTyp/LdrXg2m3QgglHi/5g4yboZmfF75DXCKi5pjA
         CaF3cNIkQJ5Z4ZK/FgPW8YcZrPypbOmzsCfOoK2CdjvaSmyBHDuW8NK/br1m8fbbX7BT
         xWUmZqIfHI6i7mP5PObmy7omOvZMJWQroxwitreaQDooWkb8BMy2+aUsJxnwvCxfhWc6
         vM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R0iLonij+R27Z6+6JWptuMSg+2MKMt0QXgYcyv0uR2s=;
        b=u9jfYiFIQm6u1N0Fs5PvMtpZ/rQKpBH2RBMZprDtNZAqqJ+E/ME6c0WhbXJi1S6et/
         0BKI7hSUHkwtckZ2/X7oSkD/LDgfRf50R/jCGZOcZdHL51my1eUG5ce2/jNcrJx+8ioy
         7OLud78ghiaNeKy//GEG/0LPpOnnPrK94PYWrSpwgooVc9XfLK3ugUEcQkU5s9AqrN9L
         THU78HxpYuYjGxFE1pk9oBavDY5qemKetEDeUzDvA7D6GeBdx+P6VH0n0qNt4sLDJV76
         5iGTp8avjkmoe3brV44Enfct7fHxInrPBfmDbzu1OI5Fr/6ctz9qS34IbKlCLSRYZyn8
         tSkw==
X-Gm-Message-State: AOAM533GGXNpXqBoDejx9akf2xMYGJWJh3+4E9LrJyEXm5VyQZGLP+Gn
        ghjGgsYNVv9WQd6agwTChpM=
X-Google-Smtp-Source: ABdhPJzeW9uNTyXp7QWGN3vSnnM/nr/upucKYl5Bq9BpwH+G3nfFXiv9zsmt5tsESeixfvbhcl44lg==
X-Received: by 2002:a05:6a00:21c1:b0:47c:11e0:84e9 with SMTP id t1-20020a056a0021c100b0047c11e084e9mr12617510pfj.23.1635365976487;
        Wed, 27 Oct 2021 13:19:36 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:19fb:5287:bbfe:fc2a])
        by smtp.gmail.com with ESMTPSA id fr12sm5338295pjb.36.2021.10.27.13.19.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:19:36 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 6/7] tcp: do not clear skb->csum if already zero
Date:   Wed, 27 Oct 2021 13:19:22 -0700
Message-Id: <20211027201923.4162520-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211027201923.4162520-1-eric.dumazet@gmail.com>
References: <20211027201923.4162520-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Freshly allocated skbs have their csum field cleared already.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c        | 1 -
 net/ipv4/tcp_output.c | 1 -
 net/ipv6/tcp_ipv6.c   | 1 -
 3 files changed, 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index c58d448b45a098b23fdc09530c2565326e77c29f..88475b64034432d4bb3c6989a69a3041ae6e7711 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -658,7 +658,6 @@ void tcp_skb_entail(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_skb_cb *tcb = TCP_SKB_CB(skb);
 
-	skb->csum    = 0;
 	tcb->seq     = tcb->end_seq = tp->write_seq;
 	tcb->tcp_flags = TCPHDR_ACK;
 	tcb->sacked  = 0;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 7ecf35d0f847c0c6aa34d3cb05e3f28a623216bd..5664355b0d09abc701ba7b422340ed9699bc71f0 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2398,7 +2398,6 @@ static int tcp_mtu_probe(struct sock *sk)
 	TCP_SKB_CB(nskb)->end_seq = TCP_SKB_CB(skb)->seq + probe_size;
 	TCP_SKB_CB(nskb)->tcp_flags = TCPHDR_ACK;
 	TCP_SKB_CB(nskb)->sacked = 0;
-	nskb->csum = 0;
 
 	tcp_insert_write_queue_before(nskb, skb, sk);
 	tcp_highest_sack_replace(sk, skb, nskb);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c678e778c1fb8f8cb7300c23cb876ef0d8e750c8..2cc9b0e53ad1c8e2d35fc9c6dbd1e90fee40b632 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -969,7 +969,6 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	fl6.flowlabel = label;
 
 	buff->ip_summed = CHECKSUM_PARTIAL;
-	buff->csum = 0;
 
 	__tcp_v6_send_check(buff, &fl6.saddr, &fl6.daddr);
 
-- 
2.33.0.1079.g6e70778dc9-goog

