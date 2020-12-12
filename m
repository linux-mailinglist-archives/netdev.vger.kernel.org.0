Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1472D8A92
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 00:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408165AbgLLXIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 18:08:23 -0500
Received: from correo.us.es ([193.147.175.20]:46768 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408159AbgLLXGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 18:06:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CCB44303D09
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8857DA78E
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 00:05:12 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AE2F7DA73D; Sun, 13 Dec 2020 00:05:12 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3ABBCDA73D;
        Sun, 13 Dec 2020 00:05:10 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 13 Dec 2020 00:05:10 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 119794265A5A;
        Sun, 13 Dec 2020 00:05:10 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/10] netfilter: use actual socket sk for REJECT action
Date:   Sun, 13 Dec 2020 00:05:08 +0100
Message-Id: <20201212230513.3465-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201212230513.3465-1-pablo@netfilter.org>
References: <20201212230513.3465-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jan Engelhardt <jengelh@inai.de>

True to the message of commit v5.10-rc1-105-g46d6c5ae953c, _do_
actually make use of state->sk when possible, such as in the REJECT
modules.

Reported-by: Minqiang Chen <ptpt52@gmail.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ipv4/nf_reject.h | 4 ++--
 include/net/netfilter/ipv6/nf_reject.h | 5 ++---
 net/ipv4/netfilter/ipt_REJECT.c        | 3 ++-
 net/ipv4/netfilter/nf_reject_ipv4.c    | 6 +++---
 net/ipv4/netfilter/nft_reject_ipv4.c   | 3 ++-
 net/ipv6/netfilter/ip6t_REJECT.c       | 2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c    | 5 +++--
 net/ipv6/netfilter/nft_reject_ipv6.c   | 3 ++-
 net/netfilter/nft_reject_inet.c        | 6 ++++--
 9 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_reject.h b/include/net/netfilter/ipv4/nf_reject.h
index 0d8ff84a2588..c653fcb88354 100644
--- a/include/net/netfilter/ipv4/nf_reject.h
+++ b/include/net/netfilter/ipv4/nf_reject.h
@@ -8,8 +8,8 @@
 #include <net/netfilter/nf_reject.h>
 
 void nf_send_unreach(struct sk_buff *skb_in, int code, int hook);
-void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook);
-
+void nf_send_reset(struct net *net, struct sock *, struct sk_buff *oldskb,
+		   int hook);
 const struct tcphdr *nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
 					     struct tcphdr *_oth, int hook);
 struct iphdr *nf_reject_iphdr_put(struct sk_buff *nskb,
diff --git a/include/net/netfilter/ipv6/nf_reject.h b/include/net/netfilter/ipv6/nf_reject.h
index edcf6d1cd316..d729344ba644 100644
--- a/include/net/netfilter/ipv6/nf_reject.h
+++ b/include/net/netfilter/ipv6/nf_reject.h
@@ -7,9 +7,8 @@
 
 void nf_send_unreach6(struct net *net, struct sk_buff *skb_in, unsigned char code,
 		      unsigned int hooknum);
-
-void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook);
-
+void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
+		    int hook);
 const struct tcphdr *nf_reject_ip6_tcphdr_get(struct sk_buff *oldskb,
 					      struct tcphdr *otcph,
 					      unsigned int *otcplen, int hook);
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index e16b98ee6266..4b8840734762 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -56,7 +56,8 @@ reject_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		nf_send_unreach(skb, ICMP_PKT_FILTERED, hook);
 		break;
 	case IPT_TCP_RESET:
-		nf_send_reset(xt_net(par), skb, hook);
+		nf_send_reset(xt_net(par), par->state->sk, skb, hook);
+		break;
 	case IPT_ICMP_ECHOREPLY:
 		/* Doesn't happen. */
 		break;
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 4109055cdea6..4eed5afca392 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -234,7 +234,8 @@ static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
 }
 
 /* Send RST reply */
-void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
+void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
+		   int hook)
 {
 	struct net_device *br_indev __maybe_unused;
 	struct sk_buff *nskb;
@@ -267,8 +268,7 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
 				   ip4_dst_hoplimit(skb_dst(nskb)));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
-
-	if (ip_route_me_harder(net, nskb->sk, nskb, RTN_UNSPEC))
+	if (ip_route_me_harder(net, sk, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
 	niph = ip_hdr(nskb);
diff --git a/net/ipv4/netfilter/nft_reject_ipv4.c b/net/ipv4/netfilter/nft_reject_ipv4.c
index e408f813f5d8..ff437e4ed6db 100644
--- a/net/ipv4/netfilter/nft_reject_ipv4.c
+++ b/net/ipv4/netfilter/nft_reject_ipv4.c
@@ -27,7 +27,8 @@ static void nft_reject_ipv4_eval(const struct nft_expr *expr,
 		nf_send_unreach(pkt->skb, priv->icmp_code, nft_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset(nft_net(pkt), pkt->skb, nft_hook(pkt));
+		nf_send_reset(nft_net(pkt), pkt->xt.state->sk, pkt->skb,
+			      nft_hook(pkt));
 		break;
 	default:
 		break;
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 3ac5485049f0..a35019d2e480 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -61,7 +61,7 @@ reject_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		/* Do nothing */
 		break;
 	case IP6T_TCP_RESET:
-		nf_send_reset6(net, skb, xt_hooknum(par));
+		nf_send_reset6(net, par->state->sk, skb, xt_hooknum(par));
 		break;
 	case IP6T_ICMP6_POLICY_FAIL:
 		nf_send_unreach6(net, skb, ICMPV6_POLICY_FAIL, xt_hooknum(par));
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index aa35e6e37c1f..570d1d76c44d 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -275,7 +275,8 @@ static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
 	return 0;
 }
 
-void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
+void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
+		    int hook)
 {
 	struct net_device *br_indev __maybe_unused;
 	struct sk_buff *nskb;
@@ -367,7 +368,7 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 		dev_queue_xmit(nskb);
 	} else
 #endif
-		ip6_local_out(net, nskb->sk, nskb);
+		ip6_local_out(net, sk, nskb);
 }
 EXPORT_SYMBOL_GPL(nf_send_reset6);
 
diff --git a/net/ipv6/netfilter/nft_reject_ipv6.c b/net/ipv6/netfilter/nft_reject_ipv6.c
index c1098a1968e1..7969d1f3018d 100644
--- a/net/ipv6/netfilter/nft_reject_ipv6.c
+++ b/net/ipv6/netfilter/nft_reject_ipv6.c
@@ -28,7 +28,8 @@ static void nft_reject_ipv6_eval(const struct nft_expr *expr,
 				 nft_hook(pkt));
 		break;
 	case NFT_REJECT_TCP_RST:
-		nf_send_reset6(nft_net(pkt), pkt->skb, nft_hook(pkt));
+		nf_send_reset6(nft_net(pkt), pkt->xt.state->sk, pkt->skb,
+			       nft_hook(pkt));
 		break;
 	default:
 		break;
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 32f3ea398ddf..95090186ee90 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -28,7 +28,8 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 					nft_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset(nft_net(pkt), pkt->skb, nft_hook(pkt));
+			nf_send_reset(nft_net(pkt), pkt->xt.state->sk,
+				      pkt->skb, nft_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
 			nf_send_unreach(pkt->skb,
@@ -44,7 +45,8 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 					 priv->icmp_code, nft_hook(pkt));
 			break;
 		case NFT_REJECT_TCP_RST:
-			nf_send_reset6(nft_net(pkt), pkt->skb, nft_hook(pkt));
+			nf_send_reset6(nft_net(pkt), pkt->xt.state->sk,
+				       pkt->skb, nft_hook(pkt));
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
 			nf_send_unreach6(nft_net(pkt), pkt->skb,
-- 
2.20.1

