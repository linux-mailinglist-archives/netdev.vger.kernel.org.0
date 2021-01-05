Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931812EB600
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbhAEXQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbhAEXQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:16:36 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDC2C061796;
        Tue,  5 Jan 2021 15:15:56 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kwvYO-0000Rb-GV; Wed, 06 Jan 2021 00:15:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     christian.perle@secunet.com, steffen.klassert@secunet.com,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH net 2/3] net: fix pmtu check in nopmtudisc mode
Date:   Wed,  6 Jan 2021 00:15:22 +0100
Message-Id: <20210105231523.622-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105231523.622-1-fw@strlen.de>
References: <20210105121208.GA11593@cell>
 <20210105231523.622-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some reason ip_tunnel insist on setting the DF bit anyway when the
inner header has the DF bit set, EVEN if the tunnel was configured with
'nopmtudisc'.

This means that the script added in the previous commit
cannot be made to work by adding the 'nopmtudisc' flag to the
ip tunnel configuration. Doing so breaks connectivity even for the
without-conntrack/netfilter scenario.

When nopmtudisc is set, the tunnel will skip the mtu check, so no
icmp error is sent to client. Then, because inner header has DF set,
the outer header gets added with DF bit set as well.

IP stack then sends an error to itself because the packet exceeds
the device MTU.

Fixes: 23a3647bc4f93 ("ip_tunnels: Use skb-len to PMTU check.")
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/ip_tunnel.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index ee65c9225178..64594aa755f0 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -759,8 +759,11 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 		goto tx_error;
 	}
 
-	if (tnl_update_pmtu(dev, skb, rt, tnl_params->frag_off, inner_iph,
-			    0, 0, false)) {
+	df = tnl_params->frag_off;
+	if (skb->protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
+		df |= (inner_iph->frag_off & htons(IP_DF));
+
+	if (tnl_update_pmtu(dev, skb, rt, df, inner_iph, 0, 0, false)) {
 		ip_rt_put(rt);
 		goto tx_error;
 	}
@@ -788,10 +791,6 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 			ttl = ip4_dst_hoplimit(&rt->dst);
 	}
 
-	df = tnl_params->frag_off;
-	if (skb->protocol == htons(ETH_P_IP) && !tunnel->ignore_df)
-		df |= (inner_iph->frag_off&htons(IP_DF));
-
 	max_headroom = LL_RESERVED_SPACE(rt->dst.dev) + sizeof(struct iphdr)
 			+ rt->dst.header_len + ip_encap_hlen(&tunnel->encap);
 	if (max_headroom > dev->needed_headroom)
-- 
2.26.2

