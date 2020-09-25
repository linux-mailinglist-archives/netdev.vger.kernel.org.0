Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8D3278F50
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbgIYREq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729477AbgIYREq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:04:46 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75F6C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:04:45 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 60so2449238qtf.21
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 10:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=436BrWsA80ToWEcQPbIaaI07QH/vu1GtRZGSncsEHfo=;
        b=XbNRFdY7cUlooqt16QcAeXZNH0gRhxZa1flvmCPTD2uFKGyLClcNBEf7UR7f1ROcek
         A99nelMz17uc53pebhzB3Wdee+LA5OnAMo3bUUmGqi4evVIyrfUwe+IY3x4szegi7I3i
         dO8HaqbhlppIOc4QSkTPn/8GZYoXgHyQ3DAayna2GaK4HvZ5+VyN5NHkDpy0/zmemntL
         CNbvKUt8s19YceEdj958vFRfLxAZIB8mW8vTgL8qi9fOyAsiR5i1RskdBwEwmdAvQbie
         lYhasBWOaidan4+v8GW2BNb13etWBnvz6Ahrxo7lBnft3X84MTnNtekAtRxQQwIbyYaf
         sBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=436BrWsA80ToWEcQPbIaaI07QH/vu1GtRZGSncsEHfo=;
        b=EVxK3NUpSJI69/xDpevaQVsW2WylGfCahk6fUQMYtxoGBHNnwjY0Aezw0Yn2W0/OmZ
         g2a3OrvJZXLqdbKSR/4fci484ij8BoFS+/cliFfgKFBVCxhzb/wn1+Z3Ml1WHOY2xj17
         WdLBNl8xMaP6Mo1tSv8sOOvrN5Ebj7DNglZfnQYrfqx7crWLnfy3/CArQ4htm10mfOP7
         88Q/gKeK+1UjS/GUNHmD1yr5a9yiyngKjNJ7x5WuMDGF1JTTI1I2HN7P0Jlwkul2uu+s
         BlqsIMC+NLok7iWQXMX0n8TdqFWlllyqFN8O/d0dFzvlx48d15C4aeq3kAGSoEdAEwbo
         YT7w==
X-Gm-Message-State: AOAM531pCLOe4NQbNZNtE/4g5SXTXZBe3SKaSALF5ajdIkIOOYqD1k2/
        znfa4fvZGX3LM+dXR1qek2YlMwRzdvM=
X-Google-Smtp-Source: ABdhPJyuPPbpUMwqX3IPQEiYAEuICvKIbNVAwXhb6e7wvZqFKIjr5FMU0tPLFewJcXvt5dtcht3UwKM1Y2g=
Sender: "ycheng via sendgmr" <ycheng@ycheng.svl.corp.google.com>
X-Received: from ycheng.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:fef4:fc76])
 (user=ycheng job=sendgmr) by 2002:a0c:8001:: with SMTP id 1mr267593qva.21.1601053484679;
 Fri, 25 Sep 2020 10:04:44 -0700 (PDT)
Date:   Fri, 25 Sep 2020 10:04:31 -0700
In-Reply-To: <20200925170431.1099943-1-ycheng@google.com>
Message-Id: <20200925170431.1099943-5-ycheng@google.com>
Mime-Version: 1.0
References: <20200925170431.1099943-1-ycheng@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net-next 4/4] tcp: consolidate tcp_mark_skb_lost and tcp_skb_mark_lost
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_skb_mark_lost is used by RFC6675-SACK and can easily be replaced
with the new tcp_mark_skb_lost handler.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9be41b69a75b..2ebfe87210f7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1043,17 +1043,6 @@ void tcp_mark_skb_lost(struct sock *sk, struct sk_buff *skb)
 	}
 }
 
-static void tcp_skb_mark_lost(struct tcp_sock *tp, struct sk_buff *skb)
-{
-	if (!(TCP_SKB_CB(skb)->sacked & (TCPCB_LOST|TCPCB_SACKED_ACKED))) {
-		tcp_verify_retransmit_hint(tp, skb);
-
-		tp->lost_out += tcp_skb_pcount(skb);
-		tcp_sum_lost(tp, skb);
-		TCP_SKB_CB(skb)->sacked |= TCPCB_LOST;
-	}
-}
-
 /* Updates the delivered and delivered_ce counts */
 static void tcp_count_delivered(struct tcp_sock *tp, u32 delivered,
 				bool ece_ack)
@@ -2308,7 +2297,8 @@ static void tcp_mark_head_lost(struct sock *sk, int packets, int mark_head)
 		if (cnt > packets)
 			break;
 
-		tcp_skb_mark_lost(tp, skb);
+		if (!(TCP_SKB_CB(skb)->sacked & TCPCB_LOST))
+			tcp_mark_skb_lost(sk, skb);
 
 		if (mark_head)
 			break;
-- 
2.28.0.681.g6f77f65b4e-goog

