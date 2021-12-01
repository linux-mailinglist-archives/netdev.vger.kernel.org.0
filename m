Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2073146570E
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245633AbhLAU3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:29:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245634AbhLAU3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 15:29:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PDkGo42W9CyFWJ3+gCVfJVB+qAGoQmWBqGyzwCPKWaM=; b=UjSgTjzJy5qHc/gdQrgBwdW78U
        PuLxCJBD2X1wuam9935rzb2Ns/VsiZ61tLUJzlX+1PjmYmabwASEXLtpcbN9qfOHh0xnAyt+3VIKJ
        0G6gri3RsgiajAp5aXvrCIqh2ZkqMewT0c5Z5auMStO2u214BEXBAuEek/nB5zCiVOVI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msWAS-00FGAG-CK; Wed, 01 Dec 2021 21:25:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [patch RFC net-next v2 3/3] udp6: Use Segment Routing Header for dest address if present
Date:   Wed,  1 Dec 2021 21:25:19 +0100
Message-Id: <20211201202519.3637005-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211201202519.3637005-1-andrew@lunn.ch>
References: <20211201202519.3637005-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When finding the socket to report an error on, if the invoking packet
is using Segment Routing, the IPv6 destination address is that of an
intermediate router, not the end destination. Extract the ultimate
destination address from the segment address.

This change allows traceroute to function in the presence of Segment
Routing.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ipv6/udp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 6a0e569f0bb8..6a2288e7ddda 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -40,6 +40,7 @@
 #include <net/transp_v6.h>
 #include <net/ip6_route.h>
 #include <net/raw.h>
+#include <net/seg6.h>
 #include <net/tcp_states.h>
 #include <net/ip6_checksum.h>
 #include <net/ip6_tunnel.h>
@@ -563,12 +564,18 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	const struct in6_addr *saddr = &hdr->saddr;
 	const struct in6_addr *daddr = &hdr->daddr;
 	struct udphdr *uh = (struct udphdr *)(skb->data+offset);
+	struct ipv6_sr_hdr *srh;
 	bool tunnel = false;
 	struct sock *sk;
 	int harderr;
 	int err;
 	struct net *net = dev_net(skb->dev);
 
+	if (opt->flags & IP6SKB_SEG6) {
+		srh = (struct ipv6_sr_hdr *)(skb->data + opt->srhoff);
+		daddr = &srh->segments[0];
+	}
+
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
 			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
 
-- 
2.33.1

