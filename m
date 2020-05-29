Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEEF1E7AA5
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgE2Ka5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:30:57 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37614 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbgE2Ka0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 06:30:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A527F205DB;
        Fri, 29 May 2020 12:30:22 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jajq9d70WNWL; Fri, 29 May 2020 12:30:20 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7AAFC205B5;
        Fri, 29 May 2020 12:30:19 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 12:30:19 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 12:30:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id F0F4E31802A2;
 Fri, 29 May 2020 12:30:17 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 03/11] xfrm: add IPv6 support for espintcp
Date:   Fri, 29 May 2020 12:30:03 +0200
Message-ID: <20200529103011.30127-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529103011.30127-1-steffen.klassert@secunet.com>
References: <20200529103011.30127-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

This extends espintcp to support IPv6, building on the existing code
and the new UDPv6 encapsulation support. Most of the code is either
reused directly (stream parser, ULP) or very similar to the IPv4
variant (net/ipv6/esp6.c changes).

The separation of config options for IPv4 and IPv6 espintcp requires a
bit of Kconfig gymnastics to enable the core code.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/ipv6_stubs.h |   2 +
 net/ipv4/Kconfig         |   1 +
 net/ipv6/Kconfig         |  12 +++
 net/ipv6/af_inet6.c      |   1 +
 net/ipv6/esp6.c          | 188 ++++++++++++++++++++++++++++++++++++++-
 net/xfrm/Kconfig         |   3 +
 net/xfrm/Makefile        |   2 +-
 net/xfrm/espintcp.c      |  56 +++++++++---
 8 files changed, 252 insertions(+), 13 deletions(-)

diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index f033a17b53b6..1e9e0cf7dc75 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -58,6 +58,8 @@ struct ipv6_stub {
 			      bool router, bool solicited, bool override, bool inc_opt);
 #if IS_ENABLED(CONFIG_XFRM)
 	int (*xfrm6_udp_encap_rcv)(struct sock *sk, struct sk_buff *skb);
+	int (*xfrm6_rcv_encap)(struct sk_buff *skb, int nexthdr, __be32 spi,
+			       int encap_type);
 #endif
 	struct neigh_table *nd_tbl;
 };
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 25a8888826b8..014aaa17dc79 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -384,6 +384,7 @@ config INET_ESPINTCP
 	depends on XFRM && INET_ESP
 	select STREAM_PARSER
 	select NET_SOCK_MSG
+	select XFRM_ESPINTCP
 	help
 	  Support for RFC 8229 encapsulation of ESP and IKE over
 	  TCP/IPv4 sockets.
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 2ccaee98fddb..468a2faadc7d 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -88,6 +88,18 @@ config INET6_ESP_OFFLOAD
 
 	  If unsure, say N.
 
+config INET6_ESPINTCP
+	bool "IPv6: ESP in TCP encapsulation (RFC 8229)"
+	depends on XFRM && INET6_ESP
+	select STREAM_PARSER
+	select NET_SOCK_MSG
+	select XFRM_ESPINTCP
+	help
+	  Support for RFC 8229 encapsulation of ESP and IKE over
+	  TCP/IPv6 sockets.
+
+	  If unsure, say N.
+
 config INET6_IPCOMP
 	tristate "IPv6: IPComp transformation"
 	select INET6_XFRM_TUNNEL
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b0b99c08350a..cbbb00bad20e 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -964,6 +964,7 @@ static const struct ipv6_stub ipv6_stub_impl = {
 	.ndisc_send_na = ndisc_send_na,
 #if IS_ENABLED(CONFIG_XFRM)
 	.xfrm6_udp_encap_rcv = xfrm6_udp_encap_rcv,
+	.xfrm6_rcv_encap = xfrm6_rcv_encap,
 #endif
 	.nd_tbl	= &nd_tbl,
 };
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index e8800968e209..c43592771126 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -33,6 +33,9 @@
 #include <net/protocol.h>
 #include <net/udp.h>
 #include <linux/icmpv6.h>
+#include <net/tcp.h>
+#include <net/espintcp.h>
+#include <net/inet6_hashtables.h>
 
 #include <linux/highmem.h>
 
@@ -132,6 +135,132 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 			put_page(sg_page(sg));
 }
 
+#ifdef CONFIG_INET6_ESPINTCP
+struct esp_tcp_sk {
+	struct sock *sk;
+	struct rcu_head rcu;
+};
+
+static void esp_free_tcp_sk(struct rcu_head *head)
+{
+	struct esp_tcp_sk *esk = container_of(head, struct esp_tcp_sk, rcu);
+
+	sock_put(esk->sk);
+	kfree(esk);
+}
+
+static struct sock *esp6_find_tcp_sk(struct xfrm_state *x)
+{
+	struct xfrm_encap_tmpl *encap = x->encap;
+	struct esp_tcp_sk *esk;
+	__be16 sport, dport;
+	struct sock *nsk;
+	struct sock *sk;
+
+	sk = rcu_dereference(x->encap_sk);
+	if (sk && sk->sk_state == TCP_ESTABLISHED)
+		return sk;
+
+	spin_lock_bh(&x->lock);
+	sport = encap->encap_sport;
+	dport = encap->encap_dport;
+	nsk = rcu_dereference_protected(x->encap_sk,
+					lockdep_is_held(&x->lock));
+	if (sk && sk == nsk) {
+		esk = kmalloc(sizeof(*esk), GFP_ATOMIC);
+		if (!esk) {
+			spin_unlock_bh(&x->lock);
+			return ERR_PTR(-ENOMEM);
+		}
+		RCU_INIT_POINTER(x->encap_sk, NULL);
+		esk->sk = sk;
+		call_rcu(&esk->rcu, esp_free_tcp_sk);
+	}
+	spin_unlock_bh(&x->lock);
+
+	sk = __inet6_lookup_established(xs_net(x), &tcp_hashinfo, &x->id.daddr.in6,
+					dport, &x->props.saddr.in6, ntohs(sport), 0, 0);
+	if (!sk)
+		return ERR_PTR(-ENOENT);
+
+	if (!tcp_is_ulp_esp(sk)) {
+		sock_put(sk);
+		return ERR_PTR(-EINVAL);
+	}
+
+	spin_lock_bh(&x->lock);
+	nsk = rcu_dereference_protected(x->encap_sk,
+					lockdep_is_held(&x->lock));
+	if (encap->encap_sport != sport ||
+	    encap->encap_dport != dport) {
+		sock_put(sk);
+		sk = nsk ?: ERR_PTR(-EREMCHG);
+	} else if (sk == nsk) {
+		sock_put(sk);
+	} else {
+		rcu_assign_pointer(x->encap_sk, sk);
+	}
+	spin_unlock_bh(&x->lock);
+
+	return sk;
+}
+
+static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
+{
+	struct sock *sk;
+	int err;
+
+	rcu_read_lock();
+
+	sk = esp6_find_tcp_sk(x);
+	err = PTR_ERR_OR_ZERO(sk);
+	if (err)
+		goto out;
+
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk))
+		err = espintcp_queue_out(sk, skb);
+	else
+		err = espintcp_push_skb(sk, skb);
+	bh_unlock_sock(sk);
+
+out:
+	rcu_read_unlock();
+	return err;
+}
+
+static int esp_output_tcp_encap_cb(struct net *net, struct sock *sk,
+				   struct sk_buff *skb)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct xfrm_state *x = dst->xfrm;
+
+	return esp_output_tcp_finish(x, skb);
+}
+
+static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
+{
+	int err;
+
+	local_bh_disable();
+	err = xfrm_trans_queue_net(xs_net(x), skb, esp_output_tcp_encap_cb);
+	local_bh_enable();
+
+	/* EINPROGRESS just happens to do the right thing.  It
+	 * actually means that the skb has been consumed and
+	 * isn't coming back.
+	 */
+	return err ?: -EINPROGRESS;
+}
+#else
+static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
+{
+	kfree_skb(skb);
+
+	return -EOPNOTSUPP;
+}
+#endif
+
 static void esp_output_encap_csum(struct sk_buff *skb)
 {
 	/* UDP encap with IPv6 requires a valid checksum */
@@ -181,7 +310,11 @@ static void esp_output_done(struct crypto_async_request *base, int err)
 		secpath_reset(skb);
 		xfrm_dev_resume(skb);
 	} else {
-		xfrm_output_resume(skb, err);
+		if (!err &&
+		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
+			esp_output_tail_tcp(x, skb);
+		else
+			xfrm_output_resume(skb, err);
 	}
 }
 
@@ -274,6 +407,41 @@ static struct ip_esp_hdr *esp6_output_udp_encap(struct sk_buff *skb,
 	return (struct ip_esp_hdr *)(uh + 1);
 }
 
+#ifdef CONFIG_INET6_ESPINTCP
+static struct ip_esp_hdr *esp6_output_tcp_encap(struct xfrm_state *x,
+						struct sk_buff *skb,
+						struct esp_info *esp)
+{
+	__be16 *lenp = (void *)esp->esph;
+	struct ip_esp_hdr *esph;
+	unsigned int len;
+	struct sock *sk;
+
+	len = skb->len + esp->tailen - skb_transport_offset(skb);
+	if (len > IP_MAX_MTU)
+		return ERR_PTR(-EMSGSIZE);
+
+	rcu_read_lock();
+	sk = esp6_find_tcp_sk(x);
+	rcu_read_unlock();
+
+	if (IS_ERR(sk))
+		return ERR_CAST(sk);
+
+	*lenp = htons(len);
+	esph = (struct ip_esp_hdr *)(lenp + 1);
+
+	return esph;
+}
+#else
+static struct ip_esp_hdr *esp6_output_tcp_encap(struct xfrm_state *x,
+						struct sk_buff *skb,
+						struct esp_info *esp)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+#endif
+
 static int esp6_output_encap(struct xfrm_state *x, struct sk_buff *skb,
 			    struct esp_info *esp)
 {
@@ -294,6 +462,9 @@ static int esp6_output_encap(struct xfrm_state *x, struct sk_buff *skb,
 	case UDP_ENCAP_ESPINUDP_NON_IKE:
 		esph = esp6_output_udp_encap(skb, encap_type, esp, sport, dport);
 		break;
+	case TCP_ENCAP_ESPINTCP:
+		esph = esp6_output_tcp_encap(x, skb, esp);
+		break;
 	}
 
 	if (IS_ERR(esph))
@@ -509,6 +680,9 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	if (sg != dsg)
 		esp_ssg_unref(x, tmp);
 
+	if (!err && x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
+		err = esp_output_tail_tcp(x, skb);
+
 error_free:
 	kfree(tmp);
 error:
@@ -633,9 +807,13 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 		const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 		struct xfrm_encap_tmpl *encap = x->encap;
 		struct udphdr *uh = (void *)(skb_network_header(skb) + hdr_len);
+		struct tcphdr *th = (void *)(skb_network_header(skb) + hdr_len);
 		__be16 source;
 
 		switch (x->encap->encap_type) {
+		case TCP_ENCAP_ESPINTCP:
+			source = th->source;
+			break;
 		case UDP_ENCAP_ESPINUDP:
 		case UDP_ENCAP_ESPINUDP_NON_IKE:
 			source = uh->source;
@@ -1039,6 +1217,14 @@ static int esp6_init_state(struct xfrm_state *x)
 		case UDP_ENCAP_ESPINUDP_NON_IKE:
 			x->props.header_len += sizeof(struct udphdr) + 2 * sizeof(u32);
 			break;
+#ifdef CONFIG_INET6_ESPINTCP
+		case TCP_ENCAP_ESPINTCP:
+			/* only the length field, TCP encap is done by
+			 * the socket
+			 */
+			x->props.header_len += 2;
+			break;
+#endif
 		}
 	}
 
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 6921a18201a0..b7fd9c838416 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -99,4 +99,7 @@ config NET_KEY_MIGRATE
 
 	  If unsure, say N.
 
+config XFRM_ESPINTCP
+	bool
+
 endif # INET
diff --git a/net/xfrm/Makefile b/net/xfrm/Makefile
index 212a4fcb4a88..2d4bb4b9f75e 100644
--- a/net/xfrm/Makefile
+++ b/net/xfrm/Makefile
@@ -11,4 +11,4 @@ obj-$(CONFIG_XFRM_ALGO) += xfrm_algo.o
 obj-$(CONFIG_XFRM_USER) += xfrm_user.o
 obj-$(CONFIG_XFRM_IPCOMP) += xfrm_ipcomp.o
 obj-$(CONFIG_XFRM_INTERFACE) += xfrm_interface.o
-obj-$(CONFIG_INET_ESPINTCP) += espintcp.o
+obj-$(CONFIG_XFRM_ESPINTCP) += espintcp.o
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 037ea156d2f9..2132a3b6df0f 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -6,6 +6,9 @@
 #include <net/espintcp.h>
 #include <linux/skmsg.h>
 #include <net/inet_common.h>
+#if IS_ENABLED(CONFIG_IPV6)
+#include <net/ipv6_stubs.h>
+#endif
 
 static void handle_nonesp(struct espintcp_ctx *ctx, struct sk_buff *skb,
 			  struct sock *sk)
@@ -31,7 +34,12 @@ static void handle_esp(struct sk_buff *skb, struct sock *sk)
 	rcu_read_lock();
 	skb->dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);
 	local_bh_disable();
-	xfrm4_rcv_encap(skb, IPPROTO_ESP, 0, TCP_ENCAP_ESPINTCP);
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family == AF_INET6)
+		ipv6_stub->xfrm6_rcv_encap(skb, IPPROTO_ESP, 0, TCP_ENCAP_ESPINTCP);
+	else
+#endif
+		xfrm4_rcv_encap(skb, IPPROTO_ESP, 0, TCP_ENCAP_ESPINTCP);
 	local_bh_enable();
 	rcu_read_unlock();
 }
@@ -347,6 +355,9 @@ static int espintcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 
 static struct proto espintcp_prot __ro_after_init;
 static struct proto_ops espintcp_ops __ro_after_init;
+static struct proto espintcp6_prot;
+static struct proto_ops espintcp6_ops;
+static DEFINE_MUTEX(tcpv6_prot_mutex);
 
 static void espintcp_data_ready(struct sock *sk)
 {
@@ -384,10 +395,14 @@ static void espintcp_destruct(struct sock *sk)
 
 bool tcp_is_ulp_esp(struct sock *sk)
 {
-	return sk->sk_prot == &espintcp_prot;
+	return sk->sk_prot == &espintcp_prot || sk->sk_prot == &espintcp6_prot;
 }
 EXPORT_SYMBOL_GPL(tcp_is_ulp_esp);
 
+static void build_protos(struct proto *espintcp_prot,
+			 struct proto_ops *espintcp_ops,
+			 const struct proto *orig_prot,
+			 const struct proto_ops *orig_ops);
 static int espintcp_init_sk(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -415,8 +430,19 @@ static int espintcp_init_sk(struct sock *sk)
 	strp_check_rcv(&ctx->strp);
 	skb_queue_head_init(&ctx->ike_queue);
 	skb_queue_head_init(&ctx->out_queue);
-	sk->sk_prot = &espintcp_prot;
-	sk->sk_socket->ops = &espintcp_ops;
+
+	if (sk->sk_family == AF_INET) {
+		sk->sk_prot = &espintcp_prot;
+		sk->sk_socket->ops = &espintcp_ops;
+	} else {
+		mutex_lock(&tcpv6_prot_mutex);
+		if (!espintcp6_prot.recvmsg)
+			build_protos(&espintcp6_prot, &espintcp6_ops, sk->sk_prot, sk->sk_socket->ops);
+		mutex_unlock(&tcpv6_prot_mutex);
+
+		sk->sk_prot = &espintcp6_prot;
+		sk->sk_socket->ops = &espintcp6_ops;
+	}
 	ctx->saved_data_ready = sk->sk_data_ready;
 	ctx->saved_write_space = sk->sk_write_space;
 	sk->sk_data_ready = espintcp_data_ready;
@@ -489,6 +515,20 @@ static __poll_t espintcp_poll(struct file *file, struct socket *sock,
 	return mask;
 }
 
+static void build_protos(struct proto *espintcp_prot,
+			 struct proto_ops *espintcp_ops,
+			 const struct proto *orig_prot,
+			 const struct proto_ops *orig_ops)
+{
+	memcpy(espintcp_prot, orig_prot, sizeof(struct proto));
+	memcpy(espintcp_ops, orig_ops, sizeof(struct proto_ops));
+	espintcp_prot->sendmsg = espintcp_sendmsg;
+	espintcp_prot->recvmsg = espintcp_recvmsg;
+	espintcp_prot->close = espintcp_close;
+	espintcp_prot->release_cb = espintcp_release;
+	espintcp_ops->poll = espintcp_poll;
+}
+
 static struct tcp_ulp_ops espintcp_ulp __read_mostly = {
 	.name = "espintcp",
 	.owner = THIS_MODULE,
@@ -497,13 +537,7 @@ static struct tcp_ulp_ops espintcp_ulp __read_mostly = {
 
 void __init espintcp_init(void)
 {
-	memcpy(&espintcp_prot, &tcp_prot, sizeof(tcp_prot));
-	memcpy(&espintcp_ops, &inet_stream_ops, sizeof(inet_stream_ops));
-	espintcp_prot.sendmsg = espintcp_sendmsg;
-	espintcp_prot.recvmsg = espintcp_recvmsg;
-	espintcp_prot.close = espintcp_close;
-	espintcp_prot.release_cb = espintcp_release;
-	espintcp_ops.poll = espintcp_poll;
+	build_protos(&espintcp_prot, &espintcp_ops, &tcp_prot, &inet_stream_ops);
 
 	tcp_register_ulp(&espintcp_ulp);
 }
-- 
2.17.1

