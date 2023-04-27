Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF446F06D6
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 15:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243563AbjD0Npt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 09:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243632AbjD0Npr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 09:45:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D93046BE
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 06:45:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E825963AF3
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 13:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E12C433EF;
        Thu, 27 Apr 2023 13:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682603136;
        bh=5LnV+4V+kW36pEYNJSHv33xikOcQ0aoo9d7P6dCzLBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hy1NYPzMTHlrsDlwTvfAd3BEFkzZBmIMJqHxMpeAIjEEkmlc+CEAnqDyyVpjoXpVk
         aaOBGvnuV4Xim6CypGLx2PrhI72xuW7RPQJBjKa63AzN1jF9FR467D2ij0ePeHcK2m
         NiMEnR4idp5R4eR6aBhyXHaU3caaRpwlQFx6y7DQI5Pwt/Xhx7YXUSZb0gsd62C+Dx
         MZhWICGBja0bp+3HzvC+Av9uWI4oj5DVA1alYyjNC6NkCa6XuHVtHBtW2pf7EcBzRm
         uz3qLuM+HmKLTgMmMh0pn43VWFfewmAynaNO7hRjDSKkw4TT5t/REgfy23RjyfFhWa
         376Nst2vObZyw==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/4] net: ipv4: use consistent txhash in TIME_WAIT and SYN_RECV
Date:   Thu, 27 Apr 2023 15:45:25 +0200
Message-Id: <20230427134527.18127-3-atenart@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230427134527.18127-1-atenart@kernel.org>
References: <20230427134527.18127-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using IPv4/TCP, skb->hash comes from sk->sk_txhash except in
TIME_WAIT and SYN_RECV where it's not set in the reply skb from
ip_send_unicast_reply. Those packets will have a mismatched hash with
others from the same flow as their hashes will be 0. IPv6 does not have
the same issue as the hash is set from the socket txhash in those cases.

This commits sets the hash in the reply skb from ip_send_unicast_reply,
which makes the IPv4 code behaving like IPv6.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/net/ip.h     |  2 +-
 net/ipv4/ip_output.c |  4 +++-
 net/ipv4/tcp_ipv4.c  | 14 +++++++++-----
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index c3fffaa92d6e..749735171e2c 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -280,7 +280,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 			   const struct ip_options *sopt,
 			   __be32 daddr, __be32 saddr,
 			   const struct ip_reply_arg *arg,
-			   unsigned int len, u64 transmit_time);
+			   unsigned int len, u64 transmit_time, u32 txhash);
 
 #define IP_INC_STATS(net, field)	SNMP_INC_STATS64((net)->mib.ip_statistics, field)
 #define __IP_INC_STATS(net, field)	__SNMP_INC_STATS64((net)->mib.ip_statistics, field)
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 22a90a9392eb..268d8d6f4d8e 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1682,7 +1682,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 			   const struct ip_options *sopt,
 			   __be32 daddr, __be32 saddr,
 			   const struct ip_reply_arg *arg,
-			   unsigned int len, u64 transmit_time)
+			   unsigned int len, u64 transmit_time, u32 txhash)
 {
 	struct ip_options_data replyopts;
 	struct ipcm_cookie ipc;
@@ -1745,6 +1745,8 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 								arg->csum));
 		nskb->ip_summed = CHECKSUM_NONE;
 		nskb->mono_delivery_time = !!transmit_time;
+		if (txhash)
+			skb_set_hash(nskb, txhash, PKT_HASH_TYPE_L4);
 		ip_push_pending_frames(sk, &fl4);
 	}
 out:
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 39bda2b1066e..8fd4b548d448 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -692,6 +692,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	u64 transmit_time = 0;
 	struct sock *ctl_sk;
 	struct net *net;
+	u32 txhash = 0;
 
 	/* Never send a reset in response to a reset. */
 	if (th->rst)
@@ -829,12 +830,14 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
 		xfrm_sk_clone_policy(ctl_sk, sk);
+		txhash = (sk->sk_state == TCP_TIME_WAIT) ?
+			 inet_twsk(sk)->tw_txhash : sk->sk_txhash;
 	}
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
 			      ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
 			      &arg, arg.iov[0].iov_len,
-			      transmit_time);
+			      transmit_time, txhash);
 
 	ctl_sk->sk_mark = 0;
 	xfrm_sk_free_policy(ctl_sk);
@@ -857,7 +860,7 @@ static void tcp_v4_send_ack(const struct sock *sk,
 			    struct sk_buff *skb, u32 seq, u32 ack,
 			    u32 win, u32 tsval, u32 tsecr, int oif,
 			    struct tcp_md5sig_key *key,
-			    int reply_flags, u8 tos)
+			    int reply_flags, u8 tos, u32 txhash)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
 	struct {
@@ -933,7 +936,7 @@ static void tcp_v4_send_ack(const struct sock *sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
 			      ip_hdr(skb)->saddr, ip_hdr(skb)->daddr,
 			      &arg, arg.iov[0].iov_len,
-			      transmit_time);
+			      transmit_time, txhash);
 
 	ctl_sk->sk_mark = 0;
 	sock_net_set(ctl_sk, &init_net);
@@ -954,7 +957,8 @@ static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 			tw->tw_bound_dev_if,
 			tcp_twsk_md5_key(tcptw),
 			tw->tw_transparent ? IP_REPLY_ARG_NOSRCCHECK : 0,
-			tw->tw_tos
+			tw->tw_tos,
+			tw->tw_txhash
 			);
 
 	inet_twsk_put(tw);
@@ -987,7 +991,7 @@ static void tcp_v4_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 			0,
 			tcp_md5_do_lookup(sk, l3index, addr, AF_INET),
 			inet_rsk(req)->no_srccheck ? IP_REPLY_ARG_NOSRCCHECK : 0,
-			ip_hdr(skb)->tos);
+			ip_hdr(skb)->tos, tcp_rsk(req)->txhash);
 }
 
 /*
-- 
2.40.0

