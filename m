Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C17325A6A
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 00:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhBYXsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 18:48:23 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:39922 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233374AbhBYXr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 18:47:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614296801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XlgfpRBNef9hVZ/V+4zH/ODJtkoqpIKBJINTpewys3M=;
        b=FJeTCS61uwglFJs4OYesx2oKSQad1KMUGJ7cU8fMvni1uBTS2wJg1BatsdlcvPjmDnGZXt
        8dR2Iw1wMMFsNn73NJqIc2UuVEmZ8VVl3XzDsjfgenp+8cbTO5i+K7LLmX+1X17n960WLB
        Tc1T17CNDANYGPpnZZUTp6b13YEVmuY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 27ea2404 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 25 Feb 2021 23:46:40 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH] net: always use icmp{,v6}_ndo_send from ndo_start_xmit
Date:   Fri, 26 Feb 2021 00:46:31 +0100
Message-Id: <20210225234631.2547776-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There were a few remaining tunnel drivers that didn't receive the prior
conversion to icmp{,v6}_ndo_send. Knowing now that this could lead to
memory corrution (see ee576c47db60 ("net: icmp: pass zeroed opts from
icmp{,v6}_ndo_send before sending") for details), there's even more
imperative to have these all converted. So this commit goes through the
remaining cases that I could find and does a boring translation to the
ndo variety.

Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/ipv4/ip_tunnel.c  |  5 ++---
 net/ipv4/ip_vti.c     |  6 +++---
 net/ipv6/ip6_gre.c    | 16 ++++++++--------
 net/ipv6/ip6_tunnel.c | 10 +++++-----
 net/ipv6/ip6_vti.c    |  6 +++---
 net/ipv6/sit.c        |  2 +-
 6 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 76a420c76f16..f6cc26de5ed3 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -502,8 +502,7 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 		if (!skb_is_gso(skb) &&
 		    (inner_iph->frag_off & htons(IP_DF)) &&
 		    mtu < pkt_size) {
-			memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
-			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED, htonl(mtu));
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED, htonl(mtu));
 			return -E2BIG;
 		}
 	}
@@ -527,7 +526,7 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 
 		if (!skb_is_gso(skb) && mtu >= IPV6_MIN_MTU &&
 					mtu < pkt_size) {
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 			return -E2BIG;
 		}
 	}
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index abc171e79d3e..eb207089ece0 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -238,13 +238,13 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 	if (skb->len > mtu) {
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
 		if (skb->protocol == htons(ETH_P_IP)) {
-			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-				  htonl(mtu));
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+				      htonl(mtu));
 		} else {
 			if (mtu < IPV6_MIN_MTU)
 				mtu = IPV6_MIN_MTU;
 
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		}
 
 		dst_release(dst);
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index c3bc89b6b1a1..1baf43aacb2e 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -678,8 +678,8 @@ static int prepare_ip6gre_xmit_ipv6(struct sk_buff *skb,
 
 		tel = (struct ipv6_tlv_tnl_enc_lim *)&skb_network_header(skb)[offset];
 		if (tel->encap_limit == 0) {
-			icmpv6_send(skb, ICMPV6_PARAMPROB,
-				    ICMPV6_HDR_FIELD, offset + 2);
+			icmpv6_ndo_send(skb, ICMPV6_PARAMPROB,
+					ICMPV6_HDR_FIELD, offset + 2);
 			return -1;
 		}
 		*encap_limit = tel->encap_limit - 1;
@@ -805,8 +805,8 @@ static inline int ip6gre_xmit_ipv4(struct sk_buff *skb, struct net_device *dev)
 	if (err != 0) {
 		/* XXX: send ICMP error even if DF is not set. */
 		if (err == -EMSGSIZE)
-			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-				  htonl(mtu));
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+				      htonl(mtu));
 		return -1;
 	}
 
@@ -837,7 +837,7 @@ static inline int ip6gre_xmit_ipv6(struct sk_buff *skb, struct net_device *dev)
 			  &mtu, skb->protocol);
 	if (err != 0) {
 		if (err == -EMSGSIZE)
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		return -1;
 	}
 
@@ -1063,10 +1063,10 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		/* XXX: send ICMP error even if DF is not set. */
 		if (err == -EMSGSIZE) {
 			if (skb->protocol == htons(ETH_P_IP))
-				icmp_send(skb, ICMP_DEST_UNREACH,
-					  ICMP_FRAG_NEEDED, htonl(mtu));
+				icmp_ndo_send(skb, ICMP_DEST_UNREACH,
+					      ICMP_FRAG_NEEDED, htonl(mtu));
 			else
-				icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+				icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		}
 
 		goto tx_err;
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index a7950baa05e5..3fa0eca5a06f 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1332,8 +1332,8 @@ ipxip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev,
 
 				tel = (void *)&skb_network_header(skb)[offset];
 				if (tel->encap_limit == 0) {
-					icmpv6_send(skb, ICMPV6_PARAMPROB,
-						ICMPV6_HDR_FIELD, offset + 2);
+					icmpv6_ndo_send(skb, ICMPV6_PARAMPROB,
+							ICMPV6_HDR_FIELD, offset + 2);
 					return -1;
 				}
 				encap_limit = tel->encap_limit - 1;
@@ -1385,11 +1385,11 @@ ipxip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev,
 		if (err == -EMSGSIZE)
 			switch (protocol) {
 			case IPPROTO_IPIP:
-				icmp_send(skb, ICMP_DEST_UNREACH,
-					  ICMP_FRAG_NEEDED, htonl(mtu));
+				icmp_ndo_send(skb, ICMP_DEST_UNREACH,
+					      ICMP_FRAG_NEEDED, htonl(mtu));
 				break;
 			case IPPROTO_IPV6:
-				icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+				icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 				break;
 			default:
 				break;
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 0225fd694192..f10e7a72ea62 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -521,10 +521,10 @@ vti6_xmit(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 			if (mtu < IPV6_MIN_MTU)
 				mtu = IPV6_MIN_MTU;
 
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		} else {
-			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-				  htonl(mtu));
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+				      htonl(mtu));
 		}
 
 		err = -EMSGSIZE;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 93636867aee2..63ccd9f2dccc 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -987,7 +987,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 			skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->len > mtu && !skb_is_gso(skb)) {
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 			ip_rt_put(rt);
 			goto tx_error;
 		}
-- 
2.30.1

