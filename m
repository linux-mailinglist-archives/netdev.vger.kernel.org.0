Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 141F23503F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 21:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfFDT3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 15:29:46 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:40699 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDT3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 15:29:46 -0400
Received: by mail-qk1-f201.google.com with SMTP id n5so4508382qkf.7
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 12:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=YPrZbErCneTjkdgy036JZcQDFLnW2U29jhRa+A327is=;
        b=egTxWL7IiIZBzay36DfQX+fFzdgm5Yq6QE2JaEE4CNrCUbMe2hnIk7QL2sdlzuzocE
         x0bAIiLGjglraunqK/eALmGhS8Y+AoEee1V+S4ionZzxp5RQYllydXr/g+kytkyEPi2P
         fVgPbQBwFvus4acaE90pdtuK6gNs/ZRCjq8ZCNnDTxQlYQrWZ4f1isfXvA1CHAfQsilI
         nHC2DsQbjC3Tj7u7ltwj4aWwSc2FyoGgcEe3wQlyAFYfv8Y52LigMre56qRKGLTnf6Vq
         9ZJ/wg5N7LMg8/bcQ3Bjy2Hu5wLUOrPyPPh7zA9j/MMXC+01yOZboIESw3knA+oMLX+9
         nx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=YPrZbErCneTjkdgy036JZcQDFLnW2U29jhRa+A327is=;
        b=YgJ8AEFq5a9zDDbjFiYbLt+G0vWfVhnXNaBel3sGVFDjyuyIUSsRKDK2TalnTUv1Na
         e77XJb9XXVX3eqgZpX4VvAdoz9NksyB6T98wAX/56+z9jvNUfG/AbAwtGaxfHnBXPSzE
         fYFa/Z/2U1IBBR6ENLg/vLrxJgRJqoPtB6aN/Z8F6HqhFtbPxAJRCRHstzBsS6XpMWd1
         OoValG+DYELiLN2+EkHr5Xye4z07aZcMI2/VIMsCb6vl78aBO9McqpZQYbiSkez/mqhC
         0orl4awjRxwioLthE5wa6OrQasdO35ya/RVshE7s06aPVbQpXi0jYPZNsyi6Wp4z7d59
         UdAQ==
X-Gm-Message-State: APjAAAWEBdJ2UBgHdNeCWJSZ4gVTaurpKoyRaFNKUYBu1U/E7lUqNwNG
        Z4fqeHGGVF2ssqvqo7fbBRdrp5EG/57pUw==
X-Google-Smtp-Source: APXvYqwjbnhBlQkq6u5/kCS69hCs9JJffC1LNaIMLCfhB7DM/GX/lcQ9VgWyeYOPOvAp4rWhE2eKO/Ih132swQ==
X-Received: by 2002:a0c:d196:: with SMTP id e22mr28579096qvh.75.1559676585216;
 Tue, 04 Jun 2019 12:29:45 -0700 (PDT)
Date:   Tue,  4 Jun 2019 12:29:42 -0700
Message-Id: <20190604192942.118949-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH net] ipv6: tcp: enable flowlabel reflection in some RST packets
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This extends commit 22b6722bfa59 ("ipv6: Add sysctl for per
namespace flow label reflection"), for some TCP RST packets.

When RST packets are sent because no socket could be found,
it makes sense to use flowlabel_reflect sysctl to decide
if a reflection of the flowlabel is requested.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/tcp_ipv6.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index beaf284563015ef0677c39fc056e6ecde3518920..07684f1e02f773a9d3e22a86ae4e7b853cc0b73e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -916,15 +916,17 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 {
 	const struct tcphdr *th = tcp_hdr(skb);
+	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	u32 seq = 0, ack_seq = 0;
 	struct tcp_md5sig_key *key = NULL;
 #ifdef CONFIG_TCP_MD5SIG
 	const __u8 *hash_location = NULL;
-	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	unsigned char newhash[16];
 	int genhash;
 	struct sock *sk1 = NULL;
 #endif
+	__be32 label = 0;
+	struct net *net;
 	int oif = 0;
 
 	if (th->rst)
@@ -936,6 +938,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 	if (!sk && !ipv6_unicast_destination(skb))
 		return;
 
+	net = dev_net(skb_dst(skb)->dev);
 #ifdef CONFIG_TCP_MD5SIG
 	rcu_read_lock();
 	hash_location = tcp_parse_md5sig_option(th);
@@ -949,7 +952,7 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		 * Incoming packet is checked with md5 hash with finding key,
 		 * no RST generated if md5 hash doesn't match.
 		 */
-		sk1 = inet6_lookup_listener(dev_net(skb_dst(skb)->dev),
+		sk1 = inet6_lookup_listener(net,
 					   &tcp_hashinfo, NULL, 0,
 					   &ipv6h->saddr,
 					   th->source, &ipv6h->daddr,
@@ -979,9 +982,13 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 		oif = sk->sk_bound_dev_if;
 		if (sk_fullsock(sk))
 			trace_tcp_send_reset(sk, skb);
+	} else {
+		if (net->ipv6.sysctl.flowlabel_reflect)
+			label = ip6_flowlabel(ipv6h);
 	}
 
-	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1, 0, 0);
+	tcp_v6_send_response(sk, skb, seq, ack_seq, 0, 0, 0, oif, key, 1, 0,
+			     label);
 
 #ifdef CONFIG_TCP_MD5SIG
 out:
-- 
2.22.0.rc1.311.g5d7573a151-goog

