Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED1AF93F2
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 16:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfKLPTJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 Nov 2019 10:19:09 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21589 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727453AbfKLPTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 10:19:07 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-cDtggoXXN3ypQBkh7M8LCA-1; Tue, 12 Nov 2019 10:19:03 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F131A93972;
        Tue, 12 Nov 2019 15:19:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9734366099;
        Tue, 12 Nov 2019 15:18:59 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next v5 6/6] xfrm: add espintcp (RFC 8229)
Date:   Tue, 12 Nov 2019 16:18:43 +0100
Message-Id: <0d65ed88663ef992f3d24855616507ad4fd3f036.1573487190.git.sd@queasysnail.net>
In-Reply-To: <cover.1573487190.git.sd@queasysnail.net>
References: <cover.1573487190.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: cDtggoXXN3ypQBkh7M8LCA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP encapsulation of IKE and IPsec messages (RFC 8229) is implemented
as a TCP ULP, overriding in particular the sendmsg and recvmsg
operations. A Stream Parser is used to extract messages out of the TCP
stream using the first 2 bytes as length marker. Received IKE messages
are put on "ike_queue", waiting to be dequeued by the custom recvmsg
implementation. Received ESP messages are sent to XFRM, like with UDP
encapsulation.

Some of this code is taken from the original submission by Herbert
Xu. Currently, only IPv4 is supported, like for UDP encapsulation.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
v5: prevent enabling espintcp if the socket is already part of a
    sockmap
v4: fix sparse warnings related to RCU with icsk_ulp_data
  - use rcu_assign_pointer in espintcp_init_sk
  - use __force cast in espintcp_getctx
v3: rename config option to INET_ESPINTCP and move it to net/ipv4/Kconfig
v2:
  - remove unneeded goto and improve error handling in
    esp_output_tcp_finish
  - clean up the ifdefs by providing dummy implementations of those
    functions
  - fix Kconfig select, missing NET_SOCK_MSG


 include/net/espintcp.h   |  39 +++
 include/net/xfrm.h       |   1 +
 include/uapi/linux/udp.h |   1 +
 net/ipv4/Kconfig         |  11 +
 net/ipv4/esp4.c          | 191 ++++++++++++++-
 net/xfrm/Makefile        |   1 +
 net/xfrm/espintcp.c      | 509 +++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_policy.c   |   7 +
 net/xfrm/xfrm_state.c    |   3 +
 9 files changed, 760 insertions(+), 3 deletions(-)
 create mode 100644 include/net/espintcp.h
 create mode 100644 net/xfrm/espintcp.c

diff --git a/include/net/espintcp.h b/include/net/espintcp.h
new file mode 100644
index 000000000000..dd7026a00066
--- /dev/null
+++ b/include/net/espintcp.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NET_ESPINTCP_H
+#define _NET_ESPINTCP_H
+
+#include <net/strparser.h>
+#include <linux/skmsg.h>
+
+void __init espintcp_init(void);
+
+int espintcp_push_skb(struct sock *sk, struct sk_buff *skb);
+int espintcp_queue_out(struct sock *sk, struct sk_buff *skb);
+bool tcp_is_ulp_esp(struct sock *sk);
+
+struct espintcp_msg {
+	struct sk_buff *skb;
+	struct sk_msg skmsg;
+	int offset;
+	int len;
+};
+
+struct espintcp_ctx {
+	struct strparser strp;
+	struct sk_buff_head ike_queue;
+	struct sk_buff_head out_queue;
+	struct espintcp_msg partial;
+	void (*saved_data_ready)(struct sock *sk);
+	void (*saved_write_space)(struct sock *sk);
+	struct work_struct work;
+	bool tx_running;
+};
+
+static inline struct espintcp_ctx *espintcp_getctx(const struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	/* RCU is only needed for diag */
+	return (__force void *)icsk->icsk_ulp_data;
+}
+#endif
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 56ff86621bb4..8f71c111e65a 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -193,6 +193,7 @@ struct xfrm_state {
 
 	/* Data for encapsulator */
 	struct xfrm_encap_tmpl	*encap;
+	struct sock __rcu	*encap_sk;
 
 	/* Data for care-of address */
 	xfrm_address_t	*coaddr;
diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
index 30baccb6c9c4..4828794efcf8 100644
--- a/include/uapi/linux/udp.h
+++ b/include/uapi/linux/udp.h
@@ -42,5 +42,6 @@ struct udphdr {
 #define UDP_ENCAP_GTP0		4 /* GSM TS 09.60 */
 #define UDP_ENCAP_GTP1U		5 /* 3GPP TS 29.060 */
 #define UDP_ENCAP_RXRPC		6
+#define TCP_ENCAP_ESPINTCP	7 /* Yikes, this is really xfrm encap types. */
 
 #endif /* _UAPI_LINUX_UDP_H */
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 03381f3e12ba..93bf717de8fa 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -378,6 +378,17 @@ config INET_ESP_OFFLOAD
 
 	  If unsure, say N.
 
+config INET_ESPINTCP
+	bool "IP: ESP in TCP encapsulation (RFC 8229)"
+	depends on XFRM && INET_ESP
+	select STREAM_PARSER
+	select NET_SOCK_MSG
+	help
+	  Support for RFC 8229 encapsulation of ESP and IKE over
+	  TCP/IPv4 sockets.
+
+	  If unsure, say N.
+
 config INET_IPCOMP
 	tristate "IP: IPComp transformation"
 	select INET_XFRM_TUNNEL
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 033c61d27148..103c7d599a3c 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -18,6 +18,8 @@
 #include <net/icmp.h>
 #include <net/protocol.h>
 #include <net/udp.h>
+#include <net/tcp.h>
+#include <net/espintcp.h>
 
 #include <linux/highmem.h>
 
@@ -117,6 +119,132 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 			put_page(sg_page(sg));
 }
 
+#ifdef CONFIG_INET_ESPINTCP
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
+static struct sock *esp_find_tcp_sk(struct xfrm_state *x)
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
+	sk = inet_lookup_established(xs_net(x), &tcp_hashinfo, x->id.daddr.a4,
+				     dport, x->props.saddr.a4, sport, 0);
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
+	sk = esp_find_tcp_sk(x);
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
 static void esp_output_done(struct crypto_async_request *base, int err)
 {
 	struct sk_buff *skb = base->data;
@@ -147,7 +275,11 @@ static void esp_output_done(struct crypto_async_request *base, int err)
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
 
@@ -236,7 +368,7 @@ static struct ip_esp_hdr *esp_output_udp_encap(struct sk_buff *skb,
 	unsigned int len;
 
 	len = skb->len + esp->tailen - skb_transport_offset(skb);
-	if (len + sizeof(struct iphdr) >= IP_MAX_MTU)
+	if (len + sizeof(struct iphdr) > IP_MAX_MTU)
 		return ERR_PTR(-EMSGSIZE);
 
 	uh = (struct udphdr *)esp->esph;
@@ -256,6 +388,41 @@ static struct ip_esp_hdr *esp_output_udp_encap(struct sk_buff *skb,
 	return (struct ip_esp_hdr *)(uh + 1);
 }
 
+#ifdef CONFIG_INET_ESPINTCP
+static struct ip_esp_hdr *esp_output_tcp_encap(struct xfrm_state *x,
+						    struct sk_buff *skb,
+						    struct esp_info *esp)
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
+	sk = esp_find_tcp_sk(x);
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
+static struct ip_esp_hdr *esp_output_tcp_encap(struct xfrm_state *x,
+						    struct sk_buff *skb,
+						    struct esp_info *esp)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+#endif
+
 static int esp_output_encap(struct xfrm_state *x, struct sk_buff *skb,
 			    struct esp_info *esp)
 {
@@ -276,6 +443,9 @@ static int esp_output_encap(struct xfrm_state *x, struct sk_buff *skb,
 	case UDP_ENCAP_ESPINUDP_NON_IKE:
 		esph = esp_output_udp_encap(skb, encap_type, esp, sport, dport);
 		break;
+	case TCP_ENCAP_ESPINTCP:
+		esph = esp_output_tcp_encap(x, skb, esp);
+		break;
 	}
 
 	if (IS_ERR(esph))
@@ -296,7 +466,7 @@ int esp_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
 
-	/* this is non-NULL only with UDP Encapsulation */
+	/* this is non-NULL only with TCP/UDP Encapsulation */
 	if (x->encap) {
 		int err = esp_output_encap(x, skb, esp);
 
@@ -491,6 +661,9 @@ int esp_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *
 	if (sg != dsg)
 		esp_ssg_unref(x, tmp);
 
+	if (!err && x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
+		err = esp_output_tail_tcp(x, skb);
+
 error_free:
 	kfree(tmp);
 error:
@@ -617,10 +790,14 @@ int esp_input_done2(struct sk_buff *skb, int err)
 
 	if (x->encap) {
 		struct xfrm_encap_tmpl *encap = x->encap;
+		struct tcphdr *th = (void *)(skb_network_header(skb) + ihl);
 		struct udphdr *uh = (void *)(skb_network_header(skb) + ihl);
 		__be16 source;
 
 		switch (x->encap->encap_type) {
+		case TCP_ENCAP_ESPINTCP:
+			source = th->source;
+			break;
 		case UDP_ENCAP_ESPINUDP:
 		case UDP_ENCAP_ESPINUDP_NON_IKE:
 			source = uh->source;
@@ -1017,6 +1194,14 @@ static int esp_init_state(struct xfrm_state *x)
 		case UDP_ENCAP_ESPINUDP_NON_IKE:
 			x->props.header_len += sizeof(struct udphdr) + 2 * sizeof(u32);
 			break;
+#ifdef CONFIG_INET_ESPINTCP
+		case TCP_ENCAP_ESPINTCP:
+			/* only the length field, TCP encap is done by
+			 * the socket
+			 */
+			x->props.header_len += 2;
+			break;
+#endif
 		}
 	}
 
diff --git a/net/xfrm/Makefile b/net/xfrm/Makefile
index fbc4552d17b8..212a4fcb4a88 100644
--- a/net/xfrm/Makefile
+++ b/net/xfrm/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_XFRM_ALGO) += xfrm_algo.o
 obj-$(CONFIG_XFRM_USER) += xfrm_user.o
 obj-$(CONFIG_XFRM_IPCOMP) += xfrm_ipcomp.o
 obj-$(CONFIG_XFRM_INTERFACE) += xfrm_interface.o
+obj-$(CONFIG_INET_ESPINTCP) += espintcp.o
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
new file mode 100644
index 000000000000..73a626adb96f
--- /dev/null
+++ b/net/xfrm/espintcp.c
@@ -0,0 +1,509 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <net/tcp.h>
+#include <net/strparser.h>
+#include <net/xfrm.h>
+#include <net/esp.h>
+#include <net/espintcp.h>
+#include <linux/skmsg.h>
+#include <net/inet_common.h>
+
+static void handle_nonesp(struct espintcp_ctx *ctx, struct sk_buff *skb,
+			  struct sock *sk)
+{
+	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf ||
+	    !sk_rmem_schedule(sk, skb, skb->truesize)) {
+		kfree_skb(skb);
+		return;
+	}
+
+	skb_set_owner_r(skb, sk);
+
+	memset(skb->cb, 0, sizeof(skb->cb));
+	skb_queue_tail(&ctx->ike_queue, skb);
+	ctx->saved_data_ready(sk);
+}
+
+static void handle_esp(struct sk_buff *skb, struct sock *sk)
+{
+	skb_reset_transport_header(skb);
+	memset(skb->cb, 0, sizeof(skb->cb));
+
+	rcu_read_lock();
+	skb->dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);
+	local_bh_disable();
+	xfrm4_rcv_encap(skb, IPPROTO_ESP, 0, TCP_ENCAP_ESPINTCP);
+	local_bh_enable();
+	rcu_read_unlock();
+}
+
+static void espintcp_rcv(struct strparser *strp, struct sk_buff *skb)
+{
+	struct espintcp_ctx *ctx = container_of(strp, struct espintcp_ctx,
+						strp);
+	struct strp_msg *rxm = strp_msg(skb);
+	u32 nonesp_marker;
+	int err;
+
+	err = skb_copy_bits(skb, rxm->offset + 2, &nonesp_marker,
+			    sizeof(nonesp_marker));
+	if (err < 0) {
+		kfree_skb(skb);
+		return;
+	}
+
+	/* remove header, leave non-ESP marker/SPI */
+	if (!__pskb_pull(skb, rxm->offset + 2)) {
+		kfree_skb(skb);
+		return;
+	}
+
+	if (pskb_trim(skb, rxm->full_len - 2) != 0) {
+		kfree_skb(skb);
+		return;
+	}
+
+	if (nonesp_marker == 0)
+		handle_nonesp(ctx, skb, strp->sk);
+	else
+		handle_esp(skb, strp->sk);
+}
+
+static int espintcp_parse(struct strparser *strp, struct sk_buff *skb)
+{
+	struct strp_msg *rxm = strp_msg(skb);
+	__be16 blen;
+	u16 len;
+	int err;
+
+	if (skb->len < rxm->offset + 2)
+		return 0;
+
+	err = skb_copy_bits(skb, rxm->offset, &blen, sizeof(blen));
+	if (err < 0)
+		return err;
+
+	len = be16_to_cpu(blen);
+	if (len < 6)
+		return -EINVAL;
+
+	return len;
+}
+
+static int espintcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
+			    int nonblock, int flags, int *addr_len)
+{
+	struct espintcp_ctx *ctx = espintcp_getctx(sk);
+	struct sk_buff *skb;
+	int err = 0;
+	int copied;
+	int off = 0;
+
+	flags |= nonblock ? MSG_DONTWAIT : 0;
+
+	skb = __skb_recv_datagram(sk, &ctx->ike_queue, flags, NULL, &off, &err);
+	if (!skb)
+		return err;
+
+	copied = len;
+	if (copied > skb->len)
+		copied = skb->len;
+	else if (copied < skb->len)
+		msg->msg_flags |= MSG_TRUNC;
+
+	err = skb_copy_datagram_msg(skb, 0, msg, copied);
+	if (unlikely(err)) {
+		kfree_skb(skb);
+		return err;
+	}
+
+	if (flags & MSG_TRUNC)
+		copied = skb->len;
+	kfree_skb(skb);
+	return copied;
+}
+
+int espintcp_queue_out(struct sock *sk, struct sk_buff *skb)
+{
+	struct espintcp_ctx *ctx = espintcp_getctx(sk);
+
+	if (skb_queue_len(&ctx->out_queue) >= netdev_max_backlog)
+		return -ENOBUFS;
+
+	__skb_queue_tail(&ctx->out_queue, skb);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(espintcp_queue_out);
+
+/* espintcp length field is 2B and length includes the length field's size */
+#define MAX_ESPINTCP_MSG (((1 << 16) - 1) - 2)
+
+static int espintcp_sendskb_locked(struct sock *sk, struct espintcp_msg *emsg,
+				   int flags)
+{
+	do {
+		int ret;
+
+		ret = skb_send_sock_locked(sk, emsg->skb,
+					   emsg->offset, emsg->len);
+		if (ret < 0)
+			return ret;
+
+		emsg->len -= ret;
+		emsg->offset += ret;
+	} while (emsg->len > 0);
+
+	kfree_skb(emsg->skb);
+	memset(emsg, 0, sizeof(*emsg));
+
+	return 0;
+}
+
+static int espintcp_sendskmsg_locked(struct sock *sk,
+				     struct espintcp_msg *emsg, int flags)
+{
+	struct sk_msg *skmsg = &emsg->skmsg;
+	struct scatterlist *sg;
+	int done = 0;
+	int ret;
+
+	flags |= MSG_SENDPAGE_NOTLAST;
+	sg = &skmsg->sg.data[skmsg->sg.start];
+	do {
+		size_t size = sg->length - emsg->offset;
+		int offset = sg->offset + emsg->offset;
+		struct page *p;
+
+		emsg->offset = 0;
+
+		if (sg_is_last(sg))
+			flags &= ~MSG_SENDPAGE_NOTLAST;
+
+		p = sg_page(sg);
+retry:
+		ret = do_tcp_sendpages(sk, p, offset, size, flags);
+		if (ret < 0) {
+			emsg->offset = offset - sg->offset;
+			skmsg->sg.start += done;
+			return ret;
+		}
+
+		if (ret != size) {
+			offset += ret;
+			size -= ret;
+			goto retry;
+		}
+
+		done++;
+		put_page(p);
+		sk_mem_uncharge(sk, sg->length);
+		sg = sg_next(sg);
+	} while (sg);
+
+	memset(emsg, 0, sizeof(*emsg));
+
+	return 0;
+}
+
+static int espintcp_push_msgs(struct sock *sk)
+{
+	struct espintcp_ctx *ctx = espintcp_getctx(sk);
+	struct espintcp_msg *emsg = &ctx->partial;
+	int err;
+
+	if (!emsg->len)
+		return 0;
+
+	if (ctx->tx_running)
+		return -EAGAIN;
+	ctx->tx_running = 1;
+
+	if (emsg->skb)
+		err = espintcp_sendskb_locked(sk, emsg, 0);
+	else
+		err = espintcp_sendskmsg_locked(sk, emsg, 0);
+	if (err == -EAGAIN) {
+		ctx->tx_running = 0;
+		return 0;
+	}
+	if (!err)
+		memset(emsg, 0, sizeof(*emsg));
+
+	ctx->tx_running = 0;
+
+	return err;
+}
+
+int espintcp_push_skb(struct sock *sk, struct sk_buff *skb)
+{
+	struct espintcp_ctx *ctx = espintcp_getctx(sk);
+	struct espintcp_msg *emsg = &ctx->partial;
+	unsigned int len;
+	int offset;
+
+	if (sk->sk_state != TCP_ESTABLISHED) {
+		kfree_skb(skb);
+		return -ECONNRESET;
+	}
+
+	offset = skb_transport_offset(skb);
+	len = skb->len - offset;
+
+	espintcp_push_msgs(sk);
+
+	if (emsg->len) {
+		kfree_skb(skb);
+		return -ENOBUFS;
+	}
+
+	skb_set_owner_w(skb, sk);
+
+	emsg->offset = offset;
+	emsg->len = len;
+	emsg->skb = skb;
+
+	espintcp_push_msgs(sk);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(espintcp_push_skb);
+
+static int espintcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
+{
+	long timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
+	struct espintcp_ctx *ctx = espintcp_getctx(sk);
+	struct espintcp_msg *emsg = &ctx->partial;
+	struct iov_iter pfx_iter;
+	struct kvec pfx_iov = {};
+	size_t msglen = size + 2;
+	char buf[2] = {0};
+	int err, end;
+
+	if (msg->msg_flags)
+		return -EOPNOTSUPP;
+
+	if (size > MAX_ESPINTCP_MSG)
+		return -EMSGSIZE;
+
+	if (msg->msg_controllen)
+		return -EOPNOTSUPP;
+
+	lock_sock(sk);
+
+	err = espintcp_push_msgs(sk);
+	if (err < 0) {
+		err = -ENOBUFS;
+		goto unlock;
+	}
+
+	sk_msg_init(&emsg->skmsg);
+	while (1) {
+		/* only -ENOMEM is possible since we don't coalesce */
+		err = sk_msg_alloc(sk, &emsg->skmsg, msglen, 0);
+		if (!err)
+			break;
+
+		err = sk_stream_wait_memory(sk, &timeo);
+		if (err)
+			goto fail;
+	}
+
+	*((__be16 *)buf) = cpu_to_be16(msglen);
+	pfx_iov.iov_base = buf;
+	pfx_iov.iov_len = sizeof(buf);
+	iov_iter_kvec(&pfx_iter, WRITE, &pfx_iov, 1, pfx_iov.iov_len);
+
+	err = sk_msg_memcopy_from_iter(sk, &pfx_iter, &emsg->skmsg,
+				       pfx_iov.iov_len);
+	if (err < 0)
+		goto fail;
+
+	err = sk_msg_memcopy_from_iter(sk, &msg->msg_iter, &emsg->skmsg, size);
+	if (err < 0)
+		goto fail;
+
+	end = emsg->skmsg.sg.end;
+	emsg->len = size;
+	sk_msg_iter_var_prev(end);
+	sg_mark_end(sk_msg_elem(&emsg->skmsg, end));
+
+	tcp_rate_check_app_limited(sk);
+
+	err = espintcp_push_msgs(sk);
+	/* this message could be partially sent, keep it */
+	if (err < 0)
+		goto unlock;
+	release_sock(sk);
+
+	return size;
+
+fail:
+	sk_msg_free(sk, &emsg->skmsg);
+	memset(emsg, 0, sizeof(*emsg));
+unlock:
+	release_sock(sk);
+	return err;
+}
+
+static struct proto espintcp_prot __ro_after_init;
+static struct proto_ops espintcp_ops __ro_after_init;
+
+static void espintcp_data_ready(struct sock *sk)
+{
+	struct espintcp_ctx *ctx = espintcp_getctx(sk);
+
+	strp_data_ready(&ctx->strp);
+}
+
+static void espintcp_tx_work(struct work_struct *work)
+{
+	struct espintcp_ctx *ctx = container_of(work,
+						struct espintcp_ctx, work);
+	struct sock *sk = ctx->strp.sk;
+
+	lock_sock(sk);
+	if (!ctx->tx_running)
+		espintcp_push_msgs(sk);
+	release_sock(sk);
+}
+
+static void espintcp_write_space(struct sock *sk)
+{
+	struct espintcp_ctx *ctx = espintcp_getctx(sk);
+
+	schedule_work(&ctx->work);
+	ctx->saved_write_space(sk);
+}
+
+static void espintcp_destruct(struct sock *sk)
+{
+	struct espintcp_ctx *ctx = espintcp_getctx(sk);
+
+	kfree(ctx);
+}
+
+bool tcp_is_ulp_esp(struct sock *sk)
+{
+	return sk->sk_prot == &espintcp_prot;
+}
+EXPORT_SYMBOL_GPL(tcp_is_ulp_esp);
+
+static int espintcp_init_sk(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct strp_callbacks cb = {
+		.rcv_msg = espintcp_rcv,
+		.parse_msg = espintcp_parse,
+	};
+	struct espintcp_ctx *ctx;
+	int err;
+
+	/* sockmap is not compatible with espintcp */
+	if (rcu_access_pointer(sk->sk_user_data))
+		return -EBUSY;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	err = strp_init(&ctx->strp, sk, &cb);
+	if (err)
+		goto free;
+
+	__sk_dst_reset(sk);
+
+	strp_check_rcv(&ctx->strp);
+	skb_queue_head_init(&ctx->ike_queue);
+	skb_queue_head_init(&ctx->out_queue);
+	sk->sk_prot = &espintcp_prot;
+	sk->sk_socket->ops = &espintcp_ops;
+	ctx->saved_data_ready = sk->sk_data_ready;
+	ctx->saved_write_space = sk->sk_write_space;
+	sk->sk_data_ready = espintcp_data_ready;
+	sk->sk_write_space = espintcp_write_space;
+	sk->sk_destruct = espintcp_destruct;
+	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
+	INIT_WORK(&ctx->work, espintcp_tx_work);
+
+	/* avoid using task_frag */
+	sk->sk_allocation = GFP_ATOMIC;
+
+	return 0;
+
+free:
+	kfree(ctx);
+	return err;
+}
+
+static void espintcp_release(struct sock *sk)
+{
+	struct espintcp_ctx *ctx = espintcp_getctx(sk);
+	struct sk_buff_head queue;
+	struct sk_buff *skb;
+
+	__skb_queue_head_init(&queue);
+	skb_queue_splice_init(&ctx->out_queue, &queue);
+
+	while ((skb = __skb_dequeue(&queue)))
+		espintcp_push_skb(sk, skb);
+
+	tcp_release_cb(sk);
+}
+
+static void espintcp_close(struct sock *sk, long timeout)
+{
+	struct espintcp_ctx *ctx = espintcp_getctx(sk);
+	struct espintcp_msg *emsg = &ctx->partial;
+
+	strp_stop(&ctx->strp);
+
+	sk->sk_prot = &tcp_prot;
+	barrier();
+
+	cancel_work_sync(&ctx->work);
+	strp_done(&ctx->strp);
+
+	skb_queue_purge(&ctx->out_queue);
+	skb_queue_purge(&ctx->ike_queue);
+
+	if (emsg->len) {
+		if (emsg->skb)
+			kfree_skb(emsg->skb);
+		else
+			sk_msg_free(sk, &emsg->skmsg);
+	}
+
+	tcp_close(sk, timeout);
+}
+
+static __poll_t espintcp_poll(struct file *file, struct socket *sock,
+			      poll_table *wait)
+{
+	__poll_t mask = datagram_poll(file, sock, wait);
+	struct sock *sk = sock->sk;
+	struct espintcp_ctx *ctx = espintcp_getctx(sk);
+
+	if (!skb_queue_empty(&ctx->ike_queue))
+		mask |= EPOLLIN | EPOLLRDNORM;
+
+	return mask;
+}
+
+static struct tcp_ulp_ops espintcp_ulp __read_mostly = {
+	.name = "espintcp",
+	.owner = THIS_MODULE,
+	.init = espintcp_init_sk,
+};
+
+void __init espintcp_init(void)
+{
+	memcpy(&espintcp_prot, &tcp_prot, sizeof(tcp_prot));
+	memcpy(&espintcp_ops, &inet_stream_ops, sizeof(inet_stream_ops));
+	espintcp_prot.sendmsg = espintcp_sendmsg;
+	espintcp_prot.recvmsg = espintcp_recvmsg;
+	espintcp_prot.close = espintcp_close;
+	espintcp_prot.release_cb = espintcp_release;
+	espintcp_ops.poll = espintcp_poll;
+
+	tcp_register_ulp(&espintcp_ulp);
+}
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 21e939235b39..4af04f74bf30 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -39,6 +39,9 @@
 #ifdef CONFIG_XFRM_STATISTICS
 #include <net/snmp.h>
 #endif
+#ifdef CONFIG_INET_ESPINTCP
+#include <net/espintcp.h>
+#endif
 
 #include "xfrm_hash.h"
 
@@ -4157,6 +4160,10 @@ void __init xfrm_init(void)
 	seqcount_init(&xfrm_policy_hash_generation);
 	xfrm_input_init();
 
+#ifdef CONFIG_INET_ESPINTCP
+	espintcp_init();
+#endif
+
 	RCU_INIT_POINTER(xfrm_if_cb, NULL);
 	synchronize_rcu();
 }
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index c6f3c4a1bd99..acef2d54f869 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -668,6 +668,9 @@ int __xfrm_state_delete(struct xfrm_state *x)
 		net->xfrm.state_num--;
 		spin_unlock(&net->xfrm.xfrm_state_lock);
 
+		if (x->encap_sk)
+			sock_put(rcu_dereference_raw(x->encap_sk));
+
 		xfrm_dev_state_delete(x);
 
 		/* All xfrm_state objects are created by xfrm_state_alloc.
-- 
2.23.0

