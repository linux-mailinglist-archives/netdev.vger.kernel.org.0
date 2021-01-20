Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F362FDB1F
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389949AbhATUpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 15:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388690AbhATUnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 15:43:01 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6527AC061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 12:41:59 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v187so30588171ybv.21
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 12:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=C9TY2mKaHHbmxg/glb3jC7yXHLagxC67WVs37+n6mSo=;
        b=q8y8NDH8vIDdyb/5w+JRbQR5ZCWjwNP4cxmwC/QRHWzLhkFap6uy6jh9qub9r+alLf
         RxEff+6ZRv3Cq6oXqMzGbJmOapIm17eHbUS5tSEnuyZhKqlpB4OHek4hxI7K2WPFS4fo
         iHauXzHDwpEfYqgt7mbfKyu9DDEIBa6b2oXiuZpWPjeESTs5n44V5P7S+elquQEOYMLh
         l+1PAreURyoNc2M7G0P1cBIsVOJM0jjnXob8+4+w8A3rAAFm5tRDkWRTpVOC0HMF+Pk6
         0JY+S+FBvWrCX4b0xwmdX0KOomnIP2fYzeq+VdWvCTknLD8mM9Fc4x7jzTnikWoiZ4/O
         /NwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=C9TY2mKaHHbmxg/glb3jC7yXHLagxC67WVs37+n6mSo=;
        b=mlTPZ1RLMoKEqJNGPzk1GRtiqosA8YrRdX1VMcqT+6aTq7akkVs950SrOGPJ0OuXcn
         ZTRhQqzlmUfTWxX/3iz/WdhVmSwChfNneHO6U6Nq3/6+L8VfTGB/suj85vkuJCJx8Ths
         iRfdga4be5B4ZKp5xtCkJqK9LzblNrxYRiELON7bMHKeTGv4UP82KoKltlB/rWHPxd0A
         YD83huoujL8JJ0XJGGZuQe0hgEltU37cwGKLnzNOhGqgVFey53jIJ4i6qFFhxC0q7XUg
         h5MPOplylFSB6ejP2LwiYntOYzX7HO/r+/ncAWyt0Qtoge4F7JwbWXclyTTpXtz/4nn1
         Z7YA==
X-Gm-Message-State: AOAM532e08fMGgr7fTWEQ/aU4vK7+MtRf9f5weCyPTlFpWvwlelWngfe
        UrBPOqHP7oI7Zep7lWz0RoKYLLHgOAZv
X-Google-Smtp-Source: ABdhPJzcfXDxl4CXG81tEoaxft5d5XKmQf3e94DK4znimBNbuGHzdj1rWQiTKIimFkPxZH3FrjsZbVD9ASS/
Sender: "ysseung via sendgmr" <ysseung@ysseung.svl.corp.google.com>
X-Received: from ysseung.svl.corp.google.com ([2620:15c:2c4:201:a28c:fdff:fedb:ff64])
 (user=ysseung job=sendgmr) by 2002:a25:b9c7:: with SMTP id
 y7mr14502902ybj.458.1611175318619; Wed, 20 Jan 2021 12:41:58 -0800 (PST)
Date:   Wed, 20 Jan 2021 12:41:55 -0800
Message-Id: <20210120204155.552275-1-ysseung@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.296.g2bfb1c46d8-goog
Subject: [PATCH net-next] tcp: add TTL to SCM_TIMESTAMPING_OPT_STATS
From:   Yousuk Seung <ysseung@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Yousuk Seung <ysseung@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds TCP_NLA_TTL to SCM_TIMESTAMPING_OPT_STATS that exports
the time-to-live or hop limit of the latest incoming packet with
SCM_TSTAMP_ACK. The value exported may not be from the packet that acks
the sequence when incoming packets are aggregated. Exporting the
time-to-live or hop limit value of incoming packets helps to estimate
the hop count of the path of the flow that may change over time.

Signed-off-by: Yousuk Seung <ysseung@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
---
 include/linux/skbuff.h   |  2 +-
 include/linux/tcp.h      |  3 ++-
 include/uapi/linux/tcp.h |  1 +
 net/core/dev.c           |  2 +-
 net/core/skbuff.c        |  6 ++++--
 net/ipv4/tcp.c           | 18 +++++++++++++++++-
 net/ipv4/tcp_input.c     | 16 ++++++++--------
 7 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 46f901adf1a8..77a74a3b511e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3859,7 +3859,7 @@ static inline bool skb_defer_rx_timestamp(struct sk_buff *skb)
 void skb_complete_tx_timestamp(struct sk_buff *skb,
 			       struct skb_shared_hwtstamps *hwtstamps);
 
-void __skb_tstamp_tx(struct sk_buff *orig_skb,
+void __skb_tstamp_tx(struct sk_buff *orig_skb, const struct sk_buff *ack_skb,
 		     struct skb_shared_hwtstamps *hwtstamps,
 		     struct sock *sk, int tstype);
 
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 2f87377e9af7..48d8a363319e 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -496,7 +496,8 @@ static inline u32 tcp_saved_syn_len(const struct saved_syn *saved_syn)
 }
 
 struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
-					       const struct sk_buff *orig_skb);
+					       const struct sk_buff *orig_skb,
+					       const struct sk_buff *ack_skb);
 
 static inline u16 tcp_mss_clamp(const struct tcp_sock *tp, u16 mss)
 {
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 768e93bd5b51..16dfa40bdac3 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -314,6 +314,7 @@ enum {
 	TCP_NLA_TIMEOUT_REHASH, /* Timeout-triggered rehash attempts */
 	TCP_NLA_BYTES_NOTSENT,	/* Bytes in write queue not yet sent */
 	TCP_NLA_EDT,		/* Earliest departure time (CLOCK_MONOTONIC) */
+	TCP_NLA_TTL,		/* TTL or hop limit of a packet received */
 };
 
 /* for TCP_MD5SIG socket option */
diff --git a/net/core/dev.c b/net/core/dev.c
index 0332f2e8f7da..8492b1560787 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4083,7 +4083,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	skb_reset_mac_header(skb);
 
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
-		__skb_tstamp_tx(skb, NULL, skb->sk, SCM_TSTAMP_SCHED);
+		__skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);
 
 	/* Disable soft irqs for various locks below. Also
 	 * stops preemption for RCU.
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index cf2c4dcf4257..7b9351ba4a20 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4717,6 +4717,7 @@ void skb_complete_tx_timestamp(struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(skb_complete_tx_timestamp);
 
 void __skb_tstamp_tx(struct sk_buff *orig_skb,
+		     const struct sk_buff *ack_skb,
 		     struct skb_shared_hwtstamps *hwtstamps,
 		     struct sock *sk, int tstype)
 {
@@ -4739,7 +4740,8 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
 		if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_STATS) &&
 		    sk->sk_protocol == IPPROTO_TCP &&
 		    sk->sk_type == SOCK_STREAM) {
-			skb = tcp_get_timestamping_opt_stats(sk, orig_skb);
+			skb = tcp_get_timestamping_opt_stats(sk, orig_skb,
+							     ack_skb);
 			opt_stats = true;
 		} else
 #endif
@@ -4768,7 +4770,7 @@ EXPORT_SYMBOL_GPL(__skb_tstamp_tx);
 void skb_tstamp_tx(struct sk_buff *orig_skb,
 		   struct skb_shared_hwtstamps *hwtstamps)
 {
-	return __skb_tstamp_tx(orig_skb, hwtstamps, orig_skb->sk,
+	return __skb_tstamp_tx(orig_skb, NULL, hwtstamps, orig_skb->sk,
 			       SCM_TSTAMP_SND);
 }
 EXPORT_SYMBOL_GPL(skb_tstamp_tx);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2267d21c73a6..6ba6c5b6579c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3766,11 +3766,24 @@ static size_t tcp_opt_stats_get_size(void)
 		nla_total_size(sizeof(u16)) + /* TCP_NLA_TIMEOUT_REHASH */
 		nla_total_size(sizeof(u32)) + /* TCP_NLA_BYTES_NOTSENT */
 		nla_total_size_64bit(sizeof(u64)) + /* TCP_NLA_EDT */
+		nla_total_size(sizeof(u8)) + /* TCP_NLA_TTL */
 		0;
 }
 
+/* Returns TTL or hop limit of an incoming packet from skb. */
+static u8 tcp_skb_ttl_or_hop_limit(const struct sk_buff *skb)
+{
+	if (skb->protocol == htons(ETH_P_IP))
+		return ip_hdr(skb)->ttl;
+	else if (skb->protocol == htons(ETH_P_IPV6))
+		return ipv6_hdr(skb)->hop_limit;
+	else
+		return 0;
+}
+
 struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
-					       const struct sk_buff *orig_skb)
+					       const struct sk_buff *orig_skb,
+					       const struct sk_buff *ack_skb)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *stats;
@@ -3826,6 +3839,9 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
 	nla_put_u64_64bit(stats, TCP_NLA_EDT, orig_skb->skb_mstamp_ns,
 			  TCP_NLA_PAD);
+	if (ack_skb)
+		nla_put_u8(stats, TCP_NLA_TTL,
+			   tcp_skb_ttl_or_hop_limit(ack_skb));
 
 	return stats;
 }
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c7e16b0ed791..5905e604344e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3145,7 +3145,7 @@ static u32 tcp_tso_acked(struct sock *sk, struct sk_buff *skb)
 }
 
 static void tcp_ack_tstamp(struct sock *sk, struct sk_buff *skb,
-			   u32 prior_snd_una)
+			   const struct sk_buff *ack_skb, u32 prior_snd_una)
 {
 	const struct skb_shared_info *shinfo;
 
@@ -3157,7 +3157,7 @@ static void tcp_ack_tstamp(struct sock *sk, struct sk_buff *skb,
 	if (!before(shinfo->tskey, prior_snd_una) &&
 	    before(shinfo->tskey, tcp_sk(sk)->snd_una)) {
 		tcp_skb_tsorted_save(skb) {
-			__skb_tstamp_tx(skb, NULL, sk, SCM_TSTAMP_ACK);
+			__skb_tstamp_tx(skb, ack_skb, NULL, sk, SCM_TSTAMP_ACK);
 		} tcp_skb_tsorted_restore(skb);
 	}
 }
@@ -3166,8 +3166,8 @@ static void tcp_ack_tstamp(struct sock *sk, struct sk_buff *skb,
  * is before the ack sequence we can discard it as it's confirmed to have
  * arrived at the other end.
  */
-static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
-			       u32 prior_snd_una,
+static int tcp_clean_rtx_queue(struct sock *sk, const struct sk_buff *ack_skb,
+			       u32 prior_fack, u32 prior_snd_una,
 			       struct tcp_sacktag_state *sack, bool ece_ack)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
@@ -3256,7 +3256,7 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 		if (!fully_acked)
 			break;
 
-		tcp_ack_tstamp(sk, skb, prior_snd_una);
+		tcp_ack_tstamp(sk, skb, ack_skb, prior_snd_una);
 
 		next = skb_rb_next(skb);
 		if (unlikely(skb == tp->retransmit_skb_hint))
@@ -3274,7 +3274,7 @@ static int tcp_clean_rtx_queue(struct sock *sk, u32 prior_fack,
 		tp->snd_up = tp->snd_una;
 
 	if (skb) {
-		tcp_ack_tstamp(sk, skb, prior_snd_una);
+		tcp_ack_tstamp(sk, skb, ack_skb, prior_snd_una);
 		if (TCP_SKB_CB(skb)->sacked & TCPCB_SACKED_ACKED)
 			flag |= FLAG_SACK_RENEGING;
 	}
@@ -3808,8 +3808,8 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 		goto no_queue;
 
 	/* See if we can take anything off of the retransmit queue. */
-	flag |= tcp_clean_rtx_queue(sk, prior_fack, prior_snd_una, &sack_state,
-				    flag & FLAG_ECE);
+	flag |= tcp_clean_rtx_queue(sk, skb, prior_fack, prior_snd_una,
+				    &sack_state, flag & FLAG_ECE);
 
 	tcp_rack_update_reo_wnd(sk, &rs);
 
-- 
2.30.0.296.g2bfb1c46d8-goog

