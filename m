Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B251043D2BD
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbhJ0UWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239127AbhJ0UWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:22:00 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD2BC061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:35 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id c4so4052391pgv.11
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wxx8AczavcqaTVRCre8Jg2I2NRl2TMakN1ZpvN9azgY=;
        b=IWcJH52lOkDtlnRy4DxEggj6V796OvmrIe3/zyycJKupJiouvrDeI3qix01PgkRPm0
         UfbdEMLCSaWs4jx4Au+rAIVNhZTC3qAXwFDklTFNXq8eVfQs3XxpU/6Vbc2txH0haddP
         sUWMGAv3WT6vWJyB+vlpRZ6SMuhY9a6J1A5n8+0MedZ7TvaJp+41zGzLRKHYWtkRfTvC
         e3mSGpNG6jtykkwb4ru0nDvUdb2fQYxfDJEA9e0fJdvdLj05NEIef2JEKhzghutnBcDQ
         EMJB2JRbkaCbSUpSV5lJU6xJe7L/nmYtl3Vm5/ItomH/5HSW8mbRCP2xtUzB0lWVTASC
         goYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wxx8AczavcqaTVRCre8Jg2I2NRl2TMakN1ZpvN9azgY=;
        b=MMAw/W/DO7XuGV+pz1X3m3ipjZcrgqGcHjLFoYA//UxAb6jA1mMe1YTw4NPq65Z3oZ
         M6KNdQnAObKtTRVNTMtKRkxgipP+1yqXyMTxeUUnVRDQBRfhM7YQRj0Ts66WK3RhjSM7
         Q4zdQTVy72TymVzC0UNf3laaQ4jPVowtrd0CsjSS1yusbh+ANZZd2Xdbuvc1KgiPg/ti
         P5p+1Ay7m4qkIcFvjdKWVVTC5hsHJnLXrndUH1PYTIJLMIiLLGyCy0htskd6EKaLQwzr
         Tr0YzDfDMrMkxPSfj4Kr8f91O86P2FuYXjTGApZPYAAe+HeAU8jPLKS4HgEuiGy76F2s
         HE4g==
X-Gm-Message-State: AOAM531YZm/bEiJrwLEbvmEnn1Tu1AqKV4aLufvnN9LlAQYEHmuwz9Js
        qGQ9T2GmXO6IuFGaxlP9FMQ=
X-Google-Smtp-Source: ABdhPJzH9R2CJLJVtdLgdDJ9J4f+0IiaCFf4JQd5uncXCPI4rRzf16q6Zng19dzYLv05TeDSbehNWg==
X-Received: by 2002:a62:5804:0:b0:44b:b75b:ec8f with SMTP id m4-20020a625804000000b0044bb75bec8fmr34550504pfb.63.1635365974879;
        Wed, 27 Oct 2021 13:19:34 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:19fb:5287:bbfe:fc2a])
        by smtp.gmail.com with ESMTPSA id fr12sm5338295pjb.36.2021.10.27.13.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:19:34 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 5/7] tcp: factorize ip_summed setting
Date:   Wed, 27 Oct 2021 13:19:21 -0700
Message-Id: <20211027201923.4162520-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211027201923.4162520-1-eric.dumazet@gmail.com>
References: <20211027201923.4162520-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Setting skb->ip_summed to CHECKSUM_PARTIAL can be centralized
in tcp_stream_alloc_skb() and __mptcp_do_alloc_tx_skb()
instead of being done multiple times.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c        | 3 +--
 net/ipv4/tcp_output.c | 6 ------
 net/mptcp/protocol.c  | 2 +-
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 66ed0d79f41472f013edffe19802441e995175c9..c58d448b45a098b23fdc09530c2565326e77c29f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -876,6 +876,7 @@ struct sk_buff *tcp_stream_alloc_skb(struct sock *sk, int size, gfp_t gfp,
 		}
 		if (likely(mem_scheduled)) {
 			skb_reserve(skb, MAX_TCP_HEADER);
+			skb->ip_summed = CHECKSUM_PARTIAL;
 			INIT_LIST_HEAD(&skb->tcp_tsorted_anchor);
 			return skb;
 		}
@@ -993,7 +994,6 @@ static struct sk_buff *tcp_build_frag(struct sock *sk, int size_goal, int flags,
 	skb->truesize += copy;
 	sk_wmem_queued_add(sk, copy);
 	sk_mem_charge(sk, copy);
-	skb->ip_summed = CHECKSUM_PARTIAL;
 	WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
 	TCP_SKB_CB(skb)->end_seq += copy;
 	tcp_skb_pcount_set(skb, 0);
@@ -1289,7 +1289,6 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				goto wait_for_space;
 
 			process_backlog++;
-			skb->ip_summed = CHECKSUM_PARTIAL;
 
 			tcp_skb_entail(sk, skb);
 			copy = size_goal;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index e1dcc93d5b6daf34e41817658c4f2029d429e82b..7ecf35d0f847c0c6aa34d3cb05e3f28a623216bd 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1590,8 +1590,6 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 
 	skb_split(skb, buff, len);
 
-	buff->ip_summed = CHECKSUM_PARTIAL;
-
 	buff->tstamp = skb->tstamp;
 	tcp_fragment_tstamp(skb, buff);
 
@@ -1676,7 +1674,6 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 	delta_truesize = __pskb_trim_head(skb, len);
 
 	TCP_SKB_CB(skb)->seq += len;
-	skb->ip_summed = CHECKSUM_PARTIAL;
 
 	if (delta_truesize) {
 		skb->truesize	   -= delta_truesize;
@@ -2147,7 +2144,6 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 
 	tcp_skb_fragment_eor(skb, buff);
 
-	buff->ip_summed = CHECKSUM_PARTIAL;
 	skb_split(skb, buff, len);
 	tcp_fragment_tstamp(skb, buff);
 
@@ -2403,7 +2399,6 @@ static int tcp_mtu_probe(struct sock *sk)
 	TCP_SKB_CB(nskb)->tcp_flags = TCPHDR_ACK;
 	TCP_SKB_CB(nskb)->sacked = 0;
 	nskb->csum = 0;
-	nskb->ip_summed = CHECKSUM_PARTIAL;
 
 	tcp_insert_write_queue_before(nskb, skb, sk);
 	tcp_highest_sack_replace(sk, skb, nskb);
@@ -3753,7 +3748,6 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 	syn_data = tcp_stream_alloc_skb(sk, space, sk->sk_allocation, false);
 	if (!syn_data)
 		goto fallback;
-	syn_data->ip_summed = CHECKSUM_PARTIAL;
 	memcpy(syn_data->cb, syn->cb, sizeof(syn->cb));
 	if (space) {
 		int copied = copy_from_iter(skb_put(syn_data, space), space,
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 22c7d10db15f8321e988602b8c97a46ffd872298..b84a89b2897114f6efb95fd75d5959fd4f5fd083 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1218,6 +1218,7 @@ static struct sk_buff *__mptcp_do_alloc_tx_skb(struct sock *sk, gfp_t gfp)
 	if (likely(skb)) {
 		if (likely(__mptcp_add_ext(skb, gfp))) {
 			skb_reserve(skb, MAX_TCP_HEADER);
+			skb->ip_summed = CHECKSUM_PARTIAL;
 			INIT_LIST_HEAD(&skb->tcp_tsorted_anchor);
 			return skb;
 		}
@@ -1366,7 +1367,6 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	skb->truesize += copy;
 	sk_wmem_queued_add(ssk, copy);
 	sk_mem_charge(ssk, copy);
-	skb->ip_summed = CHECKSUM_PARTIAL;
 	WRITE_ONCE(tcp_sk(ssk)->write_seq, tcp_sk(ssk)->write_seq + copy);
 	TCP_SKB_CB(skb)->end_seq += copy;
 	tcp_skb_pcount_set(skb, 0);
-- 
2.33.0.1079.g6e70778dc9-goog

