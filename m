Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D8C3B1F32
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 19:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhFWRFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 13:05:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33536 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhFWRFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 13:05:31 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 324AF64280;
        Wed, 23 Jun 2021 19:01:47 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 4/6] netfilter: conntrack: pass hook state to log functions
Date:   Wed, 23 Jun 2021 19:02:59 +0200
Message-Id: <20210623170301.59973-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623170301.59973-1-pablo@netfilter.org>
References: <20210623170301.59973-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The packet logger backend is unable to provide the incoming (or
outgoing) interface name because that information isn't available.

Pass the hook state, it contains the network namespace, the protocol
family, the network interfaces and other things.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_l4proto.h | 20 ++++++++++-------
 net/netfilter/nf_conntrack_proto.c           | 16 ++++++++------
 net/netfilter/nf_conntrack_proto_dccp.c      | 14 ++++++------
 net/netfilter/nf_conntrack_proto_icmp.c      |  7 +++---
 net/netfilter/nf_conntrack_proto_icmpv6.c    |  3 +--
 net/netfilter/nf_conntrack_proto_sctp.c      |  2 +-
 net/netfilter/nf_conntrack_proto_tcp.c       | 23 ++++++++++----------
 net/netfilter/nf_conntrack_proto_udp.c       |  6 ++---
 8 files changed, 47 insertions(+), 44 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 96f9cf81f46b..1f47bef51722 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -159,22 +159,26 @@ unsigned int nf_ct_port_nlattr_tuple_size(void);
 extern const struct nla_policy nf_ct_port_nla_policy[];
 
 #ifdef CONFIG_SYSCTL
-__printf(3, 4) __cold
+__printf(4, 5) __cold
 void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 			       const struct nf_conn *ct,
+			       const struct nf_hook_state *state,
 			       const char *fmt, ...);
-__printf(5, 6) __cold
+__printf(4, 5) __cold
 void nf_l4proto_log_invalid(const struct sk_buff *skb,
-			    struct net *net,
-			    u16 pf, u8 protonum,
+			    const struct nf_hook_state *state,
+			    u8 protonum,
 			    const char *fmt, ...);
 #else
-static inline __printf(5, 6) __cold
-void nf_l4proto_log_invalid(const struct sk_buff *skb, struct net *net,
-			    u16 pf, u8 protonum, const char *fmt, ...) {}
-static inline __printf(3, 4) __cold
+static inline __printf(4, 5) __cold
+void nf_l4proto_log_invalid(const struct sk_buff *skb,
+			    const struct nf_hook_state *state,
+			    u8 protonum,
+			    const char *fmt, ...) {}
+static inline __printf(4, 5) __cold
 void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 			       const struct nf_conn *ct,
+			       const struct nf_hook_state *state,
 			       const char *fmt, ...) { }
 #endif /* CONFIG_SYSCTL */
 
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index be14e0bea4c8..55647409a9be 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -45,12 +45,13 @@
 static DEFINE_MUTEX(nf_ct_proto_mutex);
 
 #ifdef CONFIG_SYSCTL
-__printf(5, 6)
+__printf(4, 5)
 void nf_l4proto_log_invalid(const struct sk_buff *skb,
-			    struct net *net,
-			    u16 pf, u8 protonum,
+			    const struct nf_hook_state *state,
+			    u8 protonum,
 			    const char *fmt, ...)
 {
+	struct net *net = state->net;
 	struct va_format vaf;
 	va_list args;
 
@@ -62,15 +63,16 @@ void nf_l4proto_log_invalid(const struct sk_buff *skb,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL,
-		      "nf_ct_proto_%d: %pV ", protonum, &vaf);
+	nf_log_packet(net, state->pf, 0, skb, state->in, state->out,
+		      NULL, "nf_ct_proto_%d: %pV ", protonum, &vaf);
 	va_end(args);
 }
 EXPORT_SYMBOL_GPL(nf_l4proto_log_invalid);
 
-__printf(3, 4)
+__printf(4, 5)
 void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 			       const struct nf_conn *ct,
+			       const struct nf_hook_state *state,
 			       const char *fmt, ...)
 {
 	struct va_format vaf;
@@ -85,7 +87,7 @@ void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	nf_l4proto_log_invalid(skb, net, nf_ct_l3num(ct),
+	nf_l4proto_log_invalid(skb, state,
 			       nf_ct_protonum(ct), "%pV", &vaf);
 	va_end(args);
 }
diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 4f33307fa3cf..c1557d47ccd1 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -382,7 +382,8 @@ dccp_state_table[CT_DCCP_ROLE_MAX + 1][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX + 1] =
 
 static noinline bool
 dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
-	 const struct dccp_hdr *dh)
+	 const struct dccp_hdr *dh,
+	 const struct nf_hook_state *hook_state)
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_dccp_net *dn;
@@ -414,7 +415,7 @@ dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 
 out_invalid:
-	nf_ct_l4proto_log_invalid(skb, ct, "%s", msg);
+	nf_ct_l4proto_log_invalid(skb, ct, hook_state, "%s", msg);
 	return false;
 }
 
@@ -464,8 +465,7 @@ static bool dccp_error(const struct dccp_hdr *dh,
 	}
 	return false;
 out_invalid:
-	nf_l4proto_log_invalid(skb, state->net, state->pf,
-			       IPPROTO_DCCP, "%s", msg);
+	nf_l4proto_log_invalid(skb, state, IPPROTO_DCCP, "%s", msg);
 	return true;
 }
 
@@ -488,7 +488,7 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 		return -NF_ACCEPT;
 
 	type = dh->dccph_type;
-	if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh))
+	if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh, state))
 		return -NF_ACCEPT;
 
 	if (type == DCCP_PKT_RESET &&
@@ -543,11 +543,11 @@ int nf_conntrack_dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 		ct->proto.dccp.last_pkt = type;
 
 		spin_unlock_bh(&ct->lock);
-		nf_ct_l4proto_log_invalid(skb, ct, "%s", "invalid packet");
+		nf_ct_l4proto_log_invalid(skb, ct, state, "%s", "invalid packet");
 		return NF_ACCEPT;
 	case CT_DCCP_INVALID:
 		spin_unlock_bh(&ct->lock);
-		nf_ct_l4proto_log_invalid(skb, ct, "%s", "invalid state transition");
+		nf_ct_l4proto_log_invalid(skb, ct, state, "%s", "invalid state transition");
 		return -NF_ACCEPT;
 	}
 
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index 4efd8741c105..b38b7164acd5 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -170,12 +170,12 @@ int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
 	ct_daddr = &ct->tuplehash[dir].tuple.dst.u3;
 	if (!nf_inet_addr_cmp(outer_daddr, ct_daddr)) {
 		if (state->pf == AF_INET) {
-			nf_l4proto_log_invalid(skb, state->net, state->pf,
+			nf_l4proto_log_invalid(skb, state,
 					       l4proto,
 					       "outer daddr %pI4 != inner %pI4",
 					       &outer_daddr->ip, &ct_daddr->ip);
 		} else if (state->pf == AF_INET6) {
-			nf_l4proto_log_invalid(skb, state->net, state->pf,
+			nf_l4proto_log_invalid(skb, state,
 					       l4proto,
 					       "outer daddr %pI6 != inner %pI6",
 					       &outer_daddr->ip6, &ct_daddr->ip6);
@@ -197,8 +197,7 @@ static void icmp_error_log(const struct sk_buff *skb,
 			   const struct nf_hook_state *state,
 			   const char *msg)
 {
-	nf_l4proto_log_invalid(skb, state->net, state->pf,
-			       IPPROTO_ICMP, "%s", msg);
+	nf_l4proto_log_invalid(skb, state, IPPROTO_ICMP, "%s", msg);
 }
 
 /* Small and modified version of icmp_rcv */
diff --git a/net/netfilter/nf_conntrack_proto_icmpv6.c b/net/netfilter/nf_conntrack_proto_icmpv6.c
index facd8c64ec4e..61e3b05cf02c 100644
--- a/net/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/netfilter/nf_conntrack_proto_icmpv6.c
@@ -126,8 +126,7 @@ static void icmpv6_error_log(const struct sk_buff *skb,
 			     const struct nf_hook_state *state,
 			     const char *msg)
 {
-	nf_l4proto_log_invalid(skb, state->net, state->pf,
-			       IPPROTO_ICMPV6, "%s", msg);
+	nf_l4proto_log_invalid(skb, state, IPPROTO_ICMPV6, "%s", msg);
 }
 
 int nf_conntrack_icmpv6_error(struct nf_conn *tmpl,
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index fb8dc02e502f..2394238d01c9 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -351,7 +351,7 @@ static bool sctp_error(struct sk_buff *skb,
 	}
 	return false;
 out_invalid:
-	nf_l4proto_log_invalid(skb, state->net, state->pf, IPPROTO_SCTP, "%s", logmsg);
+	nf_l4proto_log_invalid(skb, state, IPPROTO_SCTP, "%s", logmsg);
 	return true;
 }
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index de840fc41a2e..f7e8baf59b51 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -446,14 +446,15 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 	}
 }
 
-static bool tcp_in_window(const struct nf_conn *ct,
-			  struct ip_ct_tcp *state,
+static bool tcp_in_window(struct nf_conn *ct,
 			  enum ip_conntrack_dir dir,
 			  unsigned int index,
 			  const struct sk_buff *skb,
 			  unsigned int dataoff,
-			  const struct tcphdr *tcph)
+			  const struct tcphdr *tcph,
+			  const struct nf_hook_state *hook_state)
 {
+	struct ip_ct_tcp *state = &ct->proto.tcp;
 	struct net *net = nf_ct_net(ct);
 	struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
@@ -670,7 +671,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
 		    tn->tcp_be_liberal)
 			res = true;
 		if (!res) {
-			nf_ct_l4proto_log_invalid(skb, ct,
+			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
 			"%s",
 			before(seq, sender->td_maxend + 1) ?
 			in_recv_win ?
@@ -710,7 +711,7 @@ static void tcp_error_log(const struct sk_buff *skb,
 			  const struct nf_hook_state *state,
 			  const char *msg)
 {
-	nf_l4proto_log_invalid(skb, state->net, state->pf, IPPROTO_TCP, "%s", msg);
+	nf_l4proto_log_invalid(skb, state, IPPROTO_TCP, "%s", msg);
 }
 
 /* Protect conntrack agaist broken packets. Code taken from ipt_unclean.c.  */
@@ -970,7 +971,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 					IP_CT_EXP_CHALLENGE_ACK;
 		}
 		spin_unlock_bh(&ct->lock);
-		nf_ct_l4proto_log_invalid(skb, ct,
+		nf_ct_l4proto_log_invalid(skb, ct, state,
 					  "packet (index %d) in dir %d ignored, state %s",
 					  index, dir,
 					  tcp_conntrack_names[old_state]);
@@ -995,7 +996,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		pr_debug("nf_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
 			 dir, get_conntrack_index(th), old_state);
 		spin_unlock_bh(&ct->lock);
-		nf_ct_l4proto_log_invalid(skb, ct, "invalid state");
+		nf_ct_l4proto_log_invalid(skb, ct, state, "invalid state");
 		return -NF_ACCEPT;
 	case TCP_CONNTRACK_TIME_WAIT:
 		/* RFC5961 compliance cause stack to send "challenge-ACK"
@@ -1010,7 +1011,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			/* Detected RFC5961 challenge ACK */
 			ct->proto.tcp.last_flags &= ~IP_CT_EXP_CHALLENGE_ACK;
 			spin_unlock_bh(&ct->lock);
-			nf_ct_l4proto_log_invalid(skb, ct, "challenge-ack ignored");
+			nf_ct_l4proto_log_invalid(skb, ct, state, "challenge-ack ignored");
 			return NF_ACCEPT; /* Don't change state */
 		}
 		break;
@@ -1035,7 +1036,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack)) {
 				/* Invalid RST  */
 				spin_unlock_bh(&ct->lock);
-				nf_ct_l4proto_log_invalid(skb, ct, "invalid rst");
+				nf_ct_l4proto_log_invalid(skb, ct, state, "invalid rst");
 				return -NF_ACCEPT;
 			}
 
@@ -1079,8 +1080,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		break;
 	}
 
-	if (!tcp_in_window(ct, &ct->proto.tcp, dir, index,
-			   skb, dataoff, th)) {
+	if (!tcp_in_window(ct, dir, index,
+			   skb, dataoff, th, state)) {
 		spin_unlock_bh(&ct->lock);
 		return -NF_ACCEPT;
 	}
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 68911fcaa0f1..698fee49e732 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -38,8 +38,7 @@ static void udp_error_log(const struct sk_buff *skb,
 			  const struct nf_hook_state *state,
 			  const char *msg)
 {
-	nf_l4proto_log_invalid(skb, state->net, state->pf,
-			       IPPROTO_UDP, "%s", msg);
+	nf_l4proto_log_invalid(skb, state, IPPROTO_UDP, "%s", msg);
 }
 
 static bool udp_error(struct sk_buff *skb,
@@ -130,8 +129,7 @@ static void udplite_error_log(const struct sk_buff *skb,
 			      const struct nf_hook_state *state,
 			      const char *msg)
 {
-	nf_l4proto_log_invalid(skb, state->net, state->pf,
-			       IPPROTO_UDPLITE, "%s", msg);
+	nf_l4proto_log_invalid(skb, state, IPPROTO_UDPLITE, "%s", msg);
 }
 
 static bool udplite_error(struct sk_buff *skb,
-- 
2.30.2

