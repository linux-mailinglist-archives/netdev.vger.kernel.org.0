Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBA92EB604
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbhAEXQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbhAEXQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:16:44 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B25C06179A;
        Tue,  5 Jan 2021 15:16:02 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kwvYT-0000Rl-Ru; Wed, 06 Jan 2021 00:15:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     christian.perle@secunet.com, steffen.klassert@secunet.com,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net 3/3] net: ip: always refragment ip defragmented packets
Date:   Wed,  6 Jan 2021 00:15:23 +0100
Message-Id: <20210105231523.622-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105231523.622-1-fw@strlen.de>
References: <20210105121208.GA11593@cell>
 <20210105231523.622-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Conntrack reassembly records the largest fragment size seen in IPCB.
However, when this gets forwarded/transmitted, fragmentation will only
be forced if one of the fragmented packets had the DF bit set.

In that case, a flag in IPCB will force fragmentation even if the
MTU is large enough.

This should work fine, but this breaks with ip tunnels.
Consider client that sends a UDP datagram of size X to another host.

The client fragments the datagram, so two packets, of size y and z, are
sent. DF bit is not set on any of these packets.

Middlebox netfilter reassembles those packets back to single size-X
packet, before routing decision.

packet-size-vs-mtu checks in ip_forward are irrelevant, because DF bit
isn't set.  At output time, ip refragmentation is skipped as well
because x is still smaller than the mtu of the output device.

If ttransmit device is an ip tunnel, the packet size increases to
x+overhead.

Also, tunnel might be configured to force DF bit on outer header.

In this case, packet will be dropped (exceeds MTU) and an ICMP error is
generated back to sender.

But sender already respects the announced MTU, all the packets that
it sent did fit the announced mtu.

Force refragmentation as per original sizes unconditionally so ip tunnel
will encapsulate the fragments instead.

The only other solution I see is to place ip refragmentation in
the ip_tunnel code to handle this case.

Fixes: d6b915e29f4ad ("ip_fragment: don't forward defragmented DF packet")
Reported-by: Christian Perle <christian.perle@secunet.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/ip_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 89fff5f59eea..2ed0b01f72f0 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -302,7 +302,7 @@ static int __ip_finish_output(struct net *net, struct sock *sk, struct sk_buff *
 	if (skb_is_gso(skb))
 		return ip_finish_output_gso(net, sk, skb, mtu);
 
-	if (skb->len > mtu || (IPCB(skb)->flags & IPSKB_FRAG_PMTU))
+	if (skb->len > mtu || IPCB(skb)->frag_max_size)
 		return ip_fragment(net, sk, skb, mtu, ip_finish_output2);
 
 	return ip_finish_output2(net, sk, skb);
-- 
2.26.2

