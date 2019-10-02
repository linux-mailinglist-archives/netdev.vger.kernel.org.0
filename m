Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5F1C8E84
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfJBQjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:39:00 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:48641 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJBQjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:39:00 -0400
Received: by mail-vs1-f74.google.com with SMTP id h11so2456275vsj.15
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7lKqCJ9TVE8tFLHn5rVQZEyU0CT5dgJIILtE31aRTEE=;
        b=LwFeArPrN3lOc+JAjSdxu/LRTczKq7JPhcfiq6rkaHS+Tc1CQEiNIPPU3ktKTY303K
         86J/uvny0Z88aY1kvLRy5cnEuQ/uSZW6tWKj3wvHYb/fu9ues9xq+NhcnaPG6Zj4C54e
         DQhXgapPQlGly5zl79UqbwRYipO7993BkpFZ9pNGT57xC8+cJIHw3KpDctKs1SXCyzHD
         O5tjZ8iwGQIIkMbfO7FRhJ2vMAqIxJIkJb7/17qIUZy5dTAwUUFd7Nzng0AaSw2b84xF
         GyRUllqRiuB3MtCxZJlzUyyBuA+1cReZh+K4C8LLctNPJJg53JOedh1bTzei4JdTfIIx
         OUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7lKqCJ9TVE8tFLHn5rVQZEyU0CT5dgJIILtE31aRTEE=;
        b=Plk5kB0EaRbXe6mZuK2Wk+ZbrrJ/c1g1GjdLYYjDesyRtjDGChBZ2kyT307Zsuq96p
         FIaaQ6AWSEbm72L3MmZLi/3mXbi86TNCbRk8VnThvQodlXky3IENwfx+2CBfkh2bPaTt
         L/K2tnJYLSVoaAOTGpg0nqGYxr6MsD/RNfNCDBfXSXwjUeRxjDWK7DwtH9uFyxlSh2dR
         zlGI6pMH8tHnq34GiqFzd8o4q4uX9zdwCH9hMsEshsF6rEbLoHyjy3XgwRDr+T68fQVK
         QUjR8aoZqeZ0N1im+umyrucDZATeO3wwo90cKvwg2RztCfeky8+Zpwuy9maYdnVEPUv/
         Bm5Q==
X-Gm-Message-State: APjAAAWlCQZ/cEAcLk8DKkvg0iob3aigvJpJEl60ayQGDtXZJujY4CQ2
        1gqjSbuTTbznlEEJnLFvnGTpX2DvAejcJA==
X-Google-Smtp-Source: APXvYqyej8JFQybhoa/Gz8umL/7KFXyEtM522gU/6NfVgMrA/3pz1VJzEEW2cVfGq0H3DEKsfqgY4wRuJziGDA==
X-Received: by 2002:ab0:30e1:: with SMTP id d1mr2196242uam.29.1570034339184;
 Wed, 02 Oct 2019 09:38:59 -0700 (PDT)
Date:   Wed,  2 Oct 2019 09:38:55 -0700
Message-Id: <20191002163855.145178-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] ipv6: drop incoming packets having a v4mapped source address
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This began with a syzbot report. syzkaller was injecting
IPv6 TCP SYN packets having a v4mapped source address.

After an unsuccessful 4-tuple lookup, TCP creates a request
socket (SYN_RECV) and calls reqsk_queue_hash_req()

reqsk_queue_hash_req() calls sk_ehashfn(sk)

At this point we have AF_INET6 sockets, and the heuristic
used by sk_ehashfn() to either hash the IPv4 or IPv6 addresses
is to use ipv6_addr_v4mapped(&sk->sk_v6_daddr)

For the particular spoofed packet, we end up hashing V4 addresses
which were not initialized by the TCP IPv6 stack, so KMSAN fired
a warning.

I first fixed sk_ehashfn() to test both source and destination addresses,
but then faced various problems, including user-space programs
like packetdrill that had similar assumptions.

Instead of trying to fix the whole ecosystem, it is better
to admit that we have a dual stack behavior, and that we
can not build linux kernels without V4 stack anyway.

The dual stack API automatically forces the traffic to be IPv4
if v4mapped addresses are used at bind() or connect(), so it makes
no sense to allow IPv6 traffic to use the same v4mapped class.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/ip6_input.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index d432d0011c160f41aec09640e95179dd7b364cfc..2bb0b66181a741c7fb73cacbdf34c5160f52d186 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -223,6 +223,16 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	if (ipv6_addr_is_multicast(&hdr->saddr))
 		goto err;
 
+	/* While RFC4291 is not explicit about v4mapped addresses
+	 * in IPv6 headers, it seems clear linux dual-stack
+	 * model can not deal properly with these.
+	 * Security models could be fooled by ::ffff:127.0.0.1 for example.
+	 *
+	 * https://tools.ietf.org/html/draft-itojun-v6ops-v4mapped-harmful-02
+	 */
+	if (ipv6_addr_v4mapped(&hdr->saddr))
+		goto err;
+
 	skb->transport_header = skb->network_header + sizeof(*hdr);
 	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);
 
-- 
2.23.0.581.g78d2f28ef7-goog

