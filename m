Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C22D1E7AA3
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgE2Kat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:30:49 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37576 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgE2KaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 06:30:24 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 56C0520581;
        Fri, 29 May 2020 12:30:20 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nHK9kznZqvB5; Fri, 29 May 2020 12:30:19 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 132E1205B4;
        Fri, 29 May 2020 12:30:19 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 12:30:18 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 12:30:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id EC5B03180266;
 Fri, 29 May 2020 12:30:17 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 02/11] xfrm: add support for UDPv6 encapsulation of ESP
Date:   Fri, 29 May 2020 12:30:02 +0200
Message-ID: <20200529103011.30127-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529103011.30127-1-steffen.klassert@secunet.com>
References: <20200529103011.30127-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

This patch adds support for encapsulation of ESP over UDPv6. The code
is very similar to the IPv4 encapsulation implementation, and allows
to easily add espintcp on IPv6 as a follow-up.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/ipv6_stubs.h  |   3 +
 include/net/xfrm.h        |   5 +
 net/ipv4/udp.c            |  10 +-
 net/ipv6/af_inet6.c       |   4 +
 net/ipv6/ah6.c            |   1 +
 net/ipv6/esp6.c           | 226 +++++++++++++++++++++++++++++++++-----
 net/ipv6/esp6_offload.c   |   7 +-
 net/ipv6/ip6_vti.c        |  18 ++-
 net/ipv6/ipcomp6.c        |   1 +
 net/ipv6/xfrm6_input.c    | 106 +++++++++++++++++-
 net/ipv6/xfrm6_protocol.c |  48 ++++++++
 net/xfrm/xfrm_interface.c |   3 +
 12 files changed, 395 insertions(+), 37 deletions(-)

diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 3e7d2c0e79ca..f033a17b53b6 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -56,6 +56,9 @@ struct ipv6_stub {
 	void (*ndisc_send_na)(struct net_device *dev, const struct in6_addr *daddr,
 			      const struct in6_addr *solicited_addr,
 			      bool router, bool solicited, bool override, bool inc_opt);
+#if IS_ENABLED(CONFIG_XFRM)
+	int (*xfrm6_udp_encap_rcv)(struct sock *sk, struct sk_buff *skb);
+#endif
 	struct neigh_table *nd_tbl;
 };
 extern const struct ipv6_stub *ipv6_stub __read_mostly;
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 8f71c111e65a..2577666c34c8 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1406,6 +1406,8 @@ struct xfrm4_protocol {
 
 struct xfrm6_protocol {
 	int (*handler)(struct sk_buff *skb);
+	int (*input_handler)(struct sk_buff *skb, int nexthdr, __be32 spi,
+			     int encap_type);
 	int (*cb_handler)(struct sk_buff *skb, int err);
 	int (*err_handler)(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			   u8 type, u8 code, int offset, __be32 info);
@@ -1590,6 +1592,8 @@ int xfrm6_extract_header(struct sk_buff *skb);
 int xfrm6_extract_input(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi,
 		  struct ip6_tnl *t);
+int xfrm6_rcv_encap(struct sk_buff *skb, int nexthdr, __be32 spi,
+		    int encap_type);
 int xfrm6_transport_finish(struct sk_buff *skb, int async);
 int xfrm6_rcv_tnl(struct sk_buff *skb, struct ip6_tnl *t);
 int xfrm6_rcv(struct sk_buff *skb);
@@ -1610,6 +1614,7 @@ int xfrm6_find_1stfragopt(struct xfrm_state *x, struct sk_buff *skb,
 
 #ifdef CONFIG_XFRM
 int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb);
+int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb);
 int xfrm_user_policy(struct sock *sk, int optname,
 		     u8 __user *optval, int optlen);
 #else
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 32564b350823..1b7ebbcae497 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -112,6 +112,9 @@
 #include <net/sock_reuseport.h>
 #include <net/addrconf.h>
 #include <net/udp_tunnel.h>
+#if IS_ENABLED(CONFIG_IPV6)
+#include <net/ipv6_stubs.h>
+#endif
 
 struct udp_table udp_table __read_mostly;
 EXPORT_SYMBOL(udp_table);
@@ -2563,7 +2566,12 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 #ifdef CONFIG_XFRM
 		case UDP_ENCAP_ESPINUDP:
 		case UDP_ENCAP_ESPINUDP_NON_IKE:
-			up->encap_rcv = xfrm4_udp_encap_rcv;
+#if IS_ENABLED(CONFIG_IPV6)
+			if (sk->sk_family == AF_INET6)
+				up->encap_rcv = ipv6_stub->xfrm6_udp_encap_rcv;
+			else
+#endif
+				up->encap_rcv = xfrm4_udp_encap_rcv;
 #endif
 			fallthrough;
 		case UDP_ENCAP_L2TPINUDP:
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 345baa0a754f..b0b99c08350a 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -60,6 +60,7 @@
 #include <net/calipso.h>
 #include <net/seg6.h>
 #include <net/rpl.h>
+#include <net/xfrm.h>
 
 #include <linux/uaccess.h>
 #include <linux/mroute6.h>
@@ -961,6 +962,9 @@ static const struct ipv6_stub ipv6_stub_impl = {
 	.ip6_del_rt	   = ip6_del_rt,
 	.udpv6_encap_enable = udpv6_encap_enable,
 	.ndisc_send_na = ndisc_send_na,
+#if IS_ENABLED(CONFIG_XFRM)
+	.xfrm6_udp_encap_rcv = xfrm6_udp_encap_rcv,
+#endif
 	.nd_tbl	= &nd_tbl,
 };
 
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 45e2adc56610..d88d97617f7e 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -767,6 +767,7 @@ static const struct xfrm_type ah6_type = {
 
 static struct xfrm6_protocol ah6_protocol = {
 	.handler	=	xfrm6_rcv,
+	.input_handler	=	xfrm_input,
 	.cb_handler	=	ah6_rcv_cb,
 	.err_handler	=	ah6_err,
 	.priority	=	0,
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 11143d039f16..e8800968e209 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -26,10 +26,12 @@
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
+#include <net/ip6_checksum.h>
 #include <net/ip6_route.h>
 #include <net/icmp.h>
 #include <net/ipv6.h>
 #include <net/protocol.h>
+#include <net/udp.h>
 #include <linux/icmpv6.h>
 
 #include <linux/highmem.h>
@@ -39,6 +41,11 @@ struct esp_skb_cb {
 	void *tmp;
 };
 
+struct esp_output_extra {
+	__be32 seqhi;
+	u32 esphoff;
+};
+
 #define ESP_SKB_CB(__skb) ((struct esp_skb_cb *)&((__skb)->cb[0]))
 
 /*
@@ -72,9 +79,9 @@ static void *esp_alloc_tmp(struct crypto_aead *aead, int nfrags, int seqihlen)
 	return kmalloc(len, GFP_ATOMIC);
 }
 
-static inline __be32 *esp_tmp_seqhi(void *tmp)
+static inline void *esp_tmp_extra(void *tmp)
 {
-	return PTR_ALIGN((__be32 *)tmp, __alignof__(__be32));
+	return PTR_ALIGN(tmp, __alignof__(struct esp_output_extra));
 }
 
 static inline u8 *esp_tmp_iv(struct crypto_aead *aead, void *tmp, int seqhilen)
@@ -104,16 +111,17 @@ static inline struct scatterlist *esp_req_sg(struct crypto_aead *aead,
 
 static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 {
+	struct esp_output_extra *extra = esp_tmp_extra(tmp);
 	struct crypto_aead *aead = x->data;
-	int seqhilen = 0;
+	int extralen = 0;
 	u8 *iv;
 	struct aead_request *req;
 	struct scatterlist *sg;
 
 	if (x->props.flags & XFRM_STATE_ESN)
-		seqhilen += sizeof(__be32);
+		extralen += sizeof(*extra);
 
-	iv = esp_tmp_iv(aead, tmp, seqhilen);
+	iv = esp_tmp_iv(aead, tmp, extralen);
 	req = esp_tmp_req(aead, iv);
 
 	/* Unref skb_frag_pages in the src scatterlist if necessary.
@@ -124,6 +132,23 @@ static void esp_ssg_unref(struct xfrm_state *x, void *tmp)
 			put_page(sg_page(sg));
 }
 
+static void esp_output_encap_csum(struct sk_buff *skb)
+{
+	/* UDP encap with IPv6 requires a valid checksum */
+	if (*skb_mac_header(skb) == IPPROTO_UDP) {
+		struct udphdr *uh = udp_hdr(skb);
+		struct ipv6hdr *ip6h = ipv6_hdr(skb);
+		int len = ntohs(uh->len);
+		unsigned int offset = skb_transport_offset(skb);
+		__wsum csum = skb_checksum(skb, offset, skb->len - offset, 0);
+
+		uh->check = csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
+					    len, IPPROTO_UDP, csum);
+		if (uh->check == 0)
+			uh->check = CSUM_MANGLED_0;
+	}
+}
+
 static void esp_output_done(struct crypto_async_request *base, int err)
 {
 	struct sk_buff *skb = base->data;
@@ -143,6 +168,8 @@ static void esp_output_done(struct crypto_async_request *base, int err)
 	esp_ssg_unref(x, tmp);
 	kfree(tmp);
 
+	esp_output_encap_csum(skb);
+
 	if (xo && (xo->flags & XFRM_DEV_RESUME)) {
 		if (err) {
 			XFRM_INC_STATS(xs_net(x), LINUX_MIB_XFRMOUTSTATEPROTOERROR);
@@ -163,7 +190,7 @@ static void esp_restore_header(struct sk_buff *skb, unsigned int offset)
 {
 	struct ip_esp_hdr *esph = (void *)(skb->data + offset);
 	void *tmp = ESP_SKB_CB(skb)->tmp;
-	__be32 *seqhi = esp_tmp_seqhi(tmp);
+	__be32 *seqhi = esp_tmp_extra(tmp);
 
 	esph->seq_no = esph->spi;
 	esph->spi = *seqhi;
@@ -171,27 +198,36 @@ static void esp_restore_header(struct sk_buff *skb, unsigned int offset)
 
 static void esp_output_restore_header(struct sk_buff *skb)
 {
-	esp_restore_header(skb, skb_transport_offset(skb) - sizeof(__be32));
+	void *tmp = ESP_SKB_CB(skb)->tmp;
+	struct esp_output_extra *extra = esp_tmp_extra(tmp);
+
+	esp_restore_header(skb, skb_transport_offset(skb) + extra->esphoff -
+				sizeof(__be32));
 }
 
 static struct ip_esp_hdr *esp_output_set_esn(struct sk_buff *skb,
 					     struct xfrm_state *x,
 					     struct ip_esp_hdr *esph,
-					     __be32 *seqhi)
+					     struct esp_output_extra *extra)
 {
 	/* For ESN we move the header forward by 4 bytes to
 	 * accomodate the high bits.  We will move it back after
 	 * encryption.
 	 */
 	if ((x->props.flags & XFRM_STATE_ESN)) {
+		__u32 seqhi;
 		struct xfrm_offload *xo = xfrm_offload(skb);
 
-		esph = (void *)(skb_transport_header(skb) - sizeof(__be32));
-		*seqhi = esph->spi;
 		if (xo)
-			esph->seq_no = htonl(xo->seq.hi);
+			seqhi = xo->seq.hi;
 		else
-			esph->seq_no = htonl(XFRM_SKB_CB(skb)->seq.output.hi);
+			seqhi = XFRM_SKB_CB(skb)->seq.output.hi;
+
+		extra->esphoff = (unsigned char *)esph -
+				 skb_transport_header(skb);
+		esph = (struct ip_esp_hdr *)((unsigned char *)esph - 4);
+		extra->seqhi = esph->spi;
+		esph->seq_no = htonl(seqhi);
 	}
 
 	esph->spi = x->id.spi;
@@ -207,15 +243,84 @@ static void esp_output_done_esn(struct crypto_async_request *base, int err)
 	esp_output_done(base, err);
 }
 
+static struct ip_esp_hdr *esp6_output_udp_encap(struct sk_buff *skb,
+					       int encap_type,
+					       struct esp_info *esp,
+					       __be16 sport,
+					       __be16 dport)
+{
+	struct udphdr *uh;
+	__be32 *udpdata32;
+	unsigned int len;
+
+	len = skb->len + esp->tailen - skb_transport_offset(skb);
+	if (len > U16_MAX)
+		return ERR_PTR(-EMSGSIZE);
+
+	uh = (struct udphdr *)esp->esph;
+	uh->source = sport;
+	uh->dest = dport;
+	uh->len = htons(len);
+	uh->check = 0;
+
+	*skb_mac_header(skb) = IPPROTO_UDP;
+
+	if (encap_type == UDP_ENCAP_ESPINUDP_NON_IKE) {
+		udpdata32 = (__be32 *)(uh + 1);
+		udpdata32[0] = udpdata32[1] = 0;
+		return (struct ip_esp_hdr *)(udpdata32 + 2);
+	}
+
+	return (struct ip_esp_hdr *)(uh + 1);
+}
+
+static int esp6_output_encap(struct xfrm_state *x, struct sk_buff *skb,
+			    struct esp_info *esp)
+{
+	struct xfrm_encap_tmpl *encap = x->encap;
+	struct ip_esp_hdr *esph;
+	__be16 sport, dport;
+	int encap_type;
+
+	spin_lock_bh(&x->lock);
+	sport = encap->encap_sport;
+	dport = encap->encap_dport;
+	encap_type = encap->encap_type;
+	spin_unlock_bh(&x->lock);
+
+	switch (encap_type) {
+	default:
+	case UDP_ENCAP_ESPINUDP:
+	case UDP_ENCAP_ESPINUDP_NON_IKE:
+		esph = esp6_output_udp_encap(skb, encap_type, esp, sport, dport);
+		break;
+	}
+
+	if (IS_ERR(esph))
+		return PTR_ERR(esph);
+
+	esp->esph = esph;
+
+	return 0;
+}
+
 int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info *esp)
 {
 	u8 *tail;
 	u8 *vaddr;
 	int nfrags;
+	int esph_offset;
 	struct page *page;
 	struct sk_buff *trailer;
 	int tailen = esp->tailen;
 
+	if (x->encap) {
+		int err = esp6_output_encap(x, skb, esp);
+
+		if (err < 0)
+			return err;
+	}
+
 	if (!skb_cloned(skb)) {
 		if (tailen <= skb_tailroom(skb)) {
 			nfrags = 1;
@@ -274,10 +379,13 @@ int esp6_output_head(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	}
 
 cow:
+	esph_offset = (unsigned char *)esp->esph - skb_transport_header(skb);
+
 	nfrags = skb_cow_data(skb, tailen, &trailer);
 	if (nfrags < 0)
 		goto out;
 	tail = skb_tail_pointer(trailer);
+	esp->esph = (struct ip_esp_hdr *)(skb_transport_header(skb) + esph_offset);
 
 skip_cow:
 	esp_output_fill_trailer(tail, esp->tfclen, esp->plen, esp->proto);
@@ -295,20 +403,20 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	void *tmp;
 	int ivlen;
 	int assoclen;
-	int seqhilen;
-	__be32 *seqhi;
+	int extralen;
 	struct page *page;
 	struct ip_esp_hdr *esph;
 	struct aead_request *req;
 	struct crypto_aead *aead;
 	struct scatterlist *sg, *dsg;
+	struct esp_output_extra *extra;
 	int err = -ENOMEM;
 
 	assoclen = sizeof(struct ip_esp_hdr);
-	seqhilen = 0;
+	extralen = 0;
 
 	if (x->props.flags & XFRM_STATE_ESN) {
-		seqhilen += sizeof(__be32);
+		extralen += sizeof(*extra);
 		assoclen += sizeof(__be32);
 	}
 
@@ -316,12 +424,12 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	alen = crypto_aead_authsize(aead);
 	ivlen = crypto_aead_ivsize(aead);
 
-	tmp = esp_alloc_tmp(aead, esp->nfrags + 2, seqhilen);
+	tmp = esp_alloc_tmp(aead, esp->nfrags + 2, extralen);
 	if (!tmp)
 		goto error;
 
-	seqhi = esp_tmp_seqhi(tmp);
-	iv = esp_tmp_iv(aead, tmp, seqhilen);
+	extra = esp_tmp_extra(tmp);
+	iv = esp_tmp_iv(aead, tmp, extralen);
 	req = esp_tmp_req(aead, iv);
 	sg = esp_req_sg(aead, req);
 
@@ -330,7 +438,8 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	else
 		dsg = &sg[esp->nfrags];
 
-	esph = esp_output_set_esn(skb, x, ip_esp_hdr(skb), seqhi);
+	esph = esp_output_set_esn(skb, x, esp->esph, extra);
+	esp->esph = esph;
 
 	sg_init_table(sg, esp->nfrags);
 	err = skb_to_sgvec(skb, sg,
@@ -394,6 +503,7 @@ int esp6_output_tail(struct xfrm_state *x, struct sk_buff *skb, struct esp_info
 	case 0:
 		if ((x->props.flags & XFRM_STATE_ESN))
 			esp_output_restore_header(skb);
+		esp_output_encap_csum(skb);
 	}
 
 	if (sg != dsg)
@@ -438,11 +548,13 @@ static int esp6_output(struct xfrm_state *x, struct sk_buff *skb)
 	esp.plen = esp.clen - skb->len - esp.tfclen;
 	esp.tailen = esp.tfclen + esp.plen + alen;
 
+	esp.esph = ip_esp_hdr(skb);
+
 	esp.nfrags = esp6_output_head(x, skb, &esp);
 	if (esp.nfrags < 0)
 		return esp.nfrags;
 
-	esph = ip_esp_hdr(skb);
+	esph = esp.esph;
 	esph->spi = x->id.spi;
 
 	esph->seq_no = htonl(XFRM_SKB_CB(skb)->seq.output.low);
@@ -517,6 +629,56 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 	if (unlikely(err < 0))
 		goto out;
 
+	if (x->encap) {
+		const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+		struct xfrm_encap_tmpl *encap = x->encap;
+		struct udphdr *uh = (void *)(skb_network_header(skb) + hdr_len);
+		__be16 source;
+
+		switch (x->encap->encap_type) {
+		case UDP_ENCAP_ESPINUDP:
+		case UDP_ENCAP_ESPINUDP_NON_IKE:
+			source = uh->source;
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			err = -EINVAL;
+			goto out;
+		}
+
+		/*
+		 * 1) if the NAT-T peer's IP or port changed then
+		 *    advertize the change to the keying daemon.
+		 *    This is an inbound SA, so just compare
+		 *    SRC ports.
+		 */
+		if (!ipv6_addr_equal(&ip6h->saddr, &x->props.saddr.in6) ||
+		    source != encap->encap_sport) {
+			xfrm_address_t ipaddr;
+
+			memcpy(&ipaddr.a6, &ip6h->saddr.s6_addr, sizeof(ipaddr.a6));
+			km_new_mapping(x, &ipaddr, source);
+
+			/* XXX: perhaps add an extra
+			 * policy check here, to see
+			 * if we should allow or
+			 * reject a packet from a
+			 * different source
+			 * address/port.
+			 */
+		}
+
+		/*
+		 * 2) ignore UDP/TCP checksums in case
+		 *    of NAT-T in Transport Mode, or
+		 *    perform other post-processing fixes
+		 *    as per draft-ietf-ipsec-udp-encaps-06,
+		 *    section 3.1.2
+		 */
+		if (x->props.mode == XFRM_MODE_TRANSPORT)
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+	}
+
 	skb_postpull_rcsum(skb, skb_network_header(skb),
 			   skb_network_header_len(skb));
 	skb_pull_rcsum(skb, hlen);
@@ -632,7 +794,7 @@ static int esp6_input(struct xfrm_state *x, struct sk_buff *skb)
 		goto out;
 
 	ESP_SKB_CB(skb)->tmp = tmp;
-	seqhi = esp_tmp_seqhi(tmp);
+	seqhi = esp_tmp_extra(tmp);
 	iv = esp_tmp_iv(aead, tmp, seqhilen);
 	req = esp_tmp_req(aead, iv);
 	sg = esp_req_sg(aead, req);
@@ -836,9 +998,6 @@ static int esp6_init_state(struct xfrm_state *x)
 	u32 align;
 	int err;
 
-	if (x->encap)
-		return -EINVAL;
-
 	x->data = NULL;
 
 	if (x->aead)
@@ -867,6 +1026,22 @@ static int esp6_init_state(struct xfrm_state *x)
 		break;
 	}
 
+	if (x->encap) {
+		struct xfrm_encap_tmpl *encap = x->encap;
+
+		switch (encap->encap_type) {
+		default:
+			err = -EINVAL;
+			goto error;
+		case UDP_ENCAP_ESPINUDP:
+			x->props.header_len += sizeof(struct udphdr);
+			break;
+		case UDP_ENCAP_ESPINUDP_NON_IKE:
+			x->props.header_len += sizeof(struct udphdr) + 2 * sizeof(u32);
+			break;
+		}
+	}
+
 	align = ALIGN(crypto_aead_blocksize(aead), 4);
 	x->props.trailer_len = align + 1 + crypto_aead_authsize(aead);
 
@@ -893,6 +1068,7 @@ static const struct xfrm_type esp6_type = {
 
 static struct xfrm6_protocol esp6_protocol = {
 	.handler	=	xfrm6_rcv,
+	.input_handler	=	xfrm_input,
 	.cb_handler	=	esp6_rcv_cb,
 	.err_handler	=	esp6_err,
 	.priority	=	0,
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 8eab2c869d61..06163cc15844 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -271,7 +271,6 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 	int alen;
 	int blksize;
 	struct xfrm_offload *xo;
-	struct ip_esp_hdr *esph;
 	struct crypto_aead *aead;
 	struct esp_info esp;
 	bool hw_offload = true;
@@ -312,13 +311,13 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 
 	seq = xo->seq.low;
 
-	esph = ip_esp_hdr(skb);
-	esph->spi = x->id.spi;
+	esp.esph = ip_esp_hdr(skb);
+	esp.esph->spi = x->id.spi;
 
 	skb_push(skb, -skb_network_offset(skb));
 
 	if (xo->flags & XFRM_GSO_SEGMENT) {
-		esph->seq_no = htonl(seq);
+		esp.esph->seq_no = htonl(seq);
 
 		if (!skb_is_gso(skb))
 			xo->seq.low++;
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index cc6180e08a4f..1147f647b9a0 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -296,7 +296,8 @@ static void vti6_dev_uninit(struct net_device *dev)
 	dev_put(dev);
 }
 
-static int vti6_rcv(struct sk_buff *skb)
+static int vti6_input_proto(struct sk_buff *skb, int nexthdr, __be32 spi,
+			    int encap_type)
 {
 	struct ip6_tnl *t;
 	const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
@@ -323,7 +324,10 @@ static int vti6_rcv(struct sk_buff *skb)
 
 		rcu_read_unlock();
 
-		return xfrm6_rcv_tnl(skb, t);
+		XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = t;
+		XFRM_SPI_SKB_CB(skb)->family = AF_INET6;
+		XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct ipv6hdr, daddr);
+		return xfrm_input(skb, nexthdr, spi, encap_type);
 	}
 	rcu_read_unlock();
 	return -EINVAL;
@@ -332,6 +336,13 @@ static int vti6_rcv(struct sk_buff *skb)
 	return 0;
 }
 
+static int vti6_rcv(struct sk_buff *skb)
+{
+	int nexthdr = skb_network_header(skb)[IP6CB(skb)->nhoff];
+
+	return vti6_input_proto(skb, nexthdr, 0, 0);
+}
+
 static int vti6_rcv_cb(struct sk_buff *skb, int err)
 {
 	unsigned short family;
@@ -1185,6 +1196,7 @@ static struct pernet_operations vti6_net_ops = {
 
 static struct xfrm6_protocol vti_esp6_protocol __read_mostly = {
 	.handler	=	vti6_rcv,
+	.input_handler	=	vti6_input_proto,
 	.cb_handler	=	vti6_rcv_cb,
 	.err_handler	=	vti6_err,
 	.priority	=	100,
@@ -1192,6 +1204,7 @@ static struct xfrm6_protocol vti_esp6_protocol __read_mostly = {
 
 static struct xfrm6_protocol vti_ah6_protocol __read_mostly = {
 	.handler	=	vti6_rcv,
+	.input_handler	=	vti6_input_proto,
 	.cb_handler	=	vti6_rcv_cb,
 	.err_handler	=	vti6_err,
 	.priority	=	100,
@@ -1199,6 +1212,7 @@ static struct xfrm6_protocol vti_ah6_protocol __read_mostly = {
 
 static struct xfrm6_protocol vti_ipcomp6_protocol __read_mostly = {
 	.handler	=	vti6_rcv,
+	.input_handler	=	vti6_input_proto,
 	.cb_handler	=	vti6_rcv_cb,
 	.err_handler	=	vti6_err,
 	.priority	=	100,
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 3752bd3e92ce..99668bfebd85 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -183,6 +183,7 @@ static const struct xfrm_type ipcomp6_type = {
 
 static struct xfrm6_protocol ipcomp6_protocol = {
 	.handler	= xfrm6_rcv,
+	.input_handler	= xfrm_input,
 	.cb_handler	= ipcomp6_rcv_cb,
 	.err_handler	= ipcomp6_err,
 	.priority	= 0,
diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index a52cb3fc6df5..56f52353b324 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -35,9 +35,12 @@ EXPORT_SYMBOL(xfrm6_rcv_spi);
 static int xfrm6_transport_finish2(struct net *net, struct sock *sk,
 				   struct sk_buff *skb)
 {
-	if (xfrm_trans_queue(skb, ip6_rcv_finish))
-		__kfree_skb(skb);
-	return -1;
+	if (xfrm_trans_queue(skb, ip6_rcv_finish)) {
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
+
+	return 0;
 }
 
 int xfrm6_transport_finish(struct sk_buff *skb, int async)
@@ -60,13 +63,106 @@ int xfrm6_transport_finish(struct sk_buff *skb, int async)
 	if (xo && (xo->flags & XFRM_GRO)) {
 		skb_mac_header_rebuild(skb);
 		skb_reset_transport_header(skb);
-		return -1;
+		return 0;
 	}
 
 	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
 		dev_net(skb->dev), NULL, skb, skb->dev, NULL,
 		xfrm6_transport_finish2);
-	return -1;
+	return 0;
+}
+
+/* If it's a keepalive packet, then just eat it.
+ * If it's an encapsulated packet, then pass it to the
+ * IPsec xfrm input.
+ * Returns 0 if skb passed to xfrm or was dropped.
+ * Returns >0 if skb should be passed to UDP.
+ * Returns <0 if skb should be resubmitted (-ret is protocol)
+ */
+int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	struct udp_sock *up = udp_sk(sk);
+	struct udphdr *uh;
+	struct ipv6hdr *ip6h;
+	int len;
+	int ip6hlen = sizeof(struct ipv6hdr);
+
+	__u8 *udpdata;
+	__be32 *udpdata32;
+	__u16 encap_type = up->encap_type;
+
+	/* if this is not encapsulated socket, then just return now */
+	if (!encap_type)
+		return 1;
+
+	/* If this is a paged skb, make sure we pull up
+	 * whatever data we need to look at. */
+	len = skb->len - sizeof(struct udphdr);
+	if (!pskb_may_pull(skb, sizeof(struct udphdr) + min(len, 8)))
+		return 1;
+
+	/* Now we can get the pointers */
+	uh = udp_hdr(skb);
+	udpdata = (__u8 *)uh + sizeof(struct udphdr);
+	udpdata32 = (__be32 *)udpdata;
+
+	switch (encap_type) {
+	default:
+	case UDP_ENCAP_ESPINUDP:
+		/* Check if this is a keepalive packet.  If so, eat it. */
+		if (len == 1 && udpdata[0] == 0xff) {
+			goto drop;
+		} else if (len > sizeof(struct ip_esp_hdr) && udpdata32[0] != 0) {
+			/* ESP Packet without Non-ESP header */
+			len = sizeof(struct udphdr);
+		} else
+			/* Must be an IKE packet.. pass it through */
+			return 1;
+		break;
+	case UDP_ENCAP_ESPINUDP_NON_IKE:
+		/* Check if this is a keepalive packet.  If so, eat it. */
+		if (len == 1 && udpdata[0] == 0xff) {
+			goto drop;
+		} else if (len > 2 * sizeof(u32) + sizeof(struct ip_esp_hdr) &&
+			   udpdata32[0] == 0 && udpdata32[1] == 0) {
+
+			/* ESP Packet with Non-IKE marker */
+			len = sizeof(struct udphdr) + 2 * sizeof(u32);
+		} else
+			/* Must be an IKE packet.. pass it through */
+			return 1;
+		break;
+	}
+
+	/* At this point we are sure that this is an ESPinUDP packet,
+	 * so we need to remove 'len' bytes from the packet (the UDP
+	 * header and optional ESP marker bytes) and then modify the
+	 * protocol to ESP, and then call into the transform receiver.
+	 */
+	if (skb_unclone(skb, GFP_ATOMIC))
+		goto drop;
+
+	/* Now we can update and verify the packet length... */
+	ip6h = ipv6_hdr(skb);
+	ip6h->payload_len = htons(ntohs(ip6h->payload_len) - len);
+	if (skb->len < ip6hlen + len) {
+		/* packet is too small!?! */
+		goto drop;
+	}
+
+	/* pull the data buffer up to the ESP header and set the
+	 * transport header to point to ESP.  Keep UDP on the stack
+	 * for later.
+	 */
+	__skb_pull(skb, len);
+	skb_reset_transport_header(skb);
+
+	/* process ESP */
+	return xfrm6_rcv_encap(skb, IPPROTO_ESP, 0, encap_type);
+
+drop:
+	kfree_skb(skb);
+	return 0;
 }
 
 int xfrm6_rcv_tnl(struct sk_buff *skb, struct ip6_tnl *t)
diff --git a/net/ipv6/xfrm6_protocol.c b/net/ipv6/xfrm6_protocol.c
index 34cb65c7d5a7..ea2f805d3b01 100644
--- a/net/ipv6/xfrm6_protocol.c
+++ b/net/ipv6/xfrm6_protocol.c
@@ -14,6 +14,7 @@
 #include <linux/mutex.h>
 #include <linux/skbuff.h>
 #include <linux/icmpv6.h>
+#include <net/ip6_route.h>
 #include <net/ipv6.h>
 #include <net/protocol.h>
 #include <net/xfrm.h>
@@ -58,6 +59,53 @@ static int xfrm6_rcv_cb(struct sk_buff *skb, u8 protocol, int err)
 	return 0;
 }
 
+int xfrm6_rcv_encap(struct sk_buff *skb, int nexthdr, __be32 spi,
+		    int encap_type)
+{
+	int ret;
+	struct xfrm6_protocol *handler;
+	struct xfrm6_protocol __rcu **head = proto_handlers(nexthdr);
+
+	XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip6 = NULL;
+	XFRM_SPI_SKB_CB(skb)->family = AF_INET6;
+	XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct ipv6hdr, daddr);
+
+	if (!head)
+		goto out;
+
+	if (!skb_dst(skb)) {
+		const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+		int flags = RT6_LOOKUP_F_HAS_SADDR;
+		struct dst_entry *dst;
+		struct flowi6 fl6 = {
+			.flowi6_iif   = skb->dev->ifindex,
+			.daddr        = ip6h->daddr,
+			.saddr        = ip6h->saddr,
+			.flowlabel    = ip6_flowinfo(ip6h),
+			.flowi6_mark  = skb->mark,
+			.flowi6_proto = ip6h->nexthdr,
+		};
+
+		dst = ip6_route_input_lookup(dev_net(skb->dev), skb->dev, &fl6,
+					     skb, flags);
+		if (dst->error)
+			goto drop;
+		skb_dst_set(skb, dst);
+	}
+
+	for_each_protocol_rcu(*head, handler)
+		if ((ret = handler->input_handler(skb, nexthdr, spi, encap_type)) != -EINVAL)
+			return ret;
+
+out:
+	icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_PORT_UNREACH, 0);
+
+drop:
+	kfree_skb(skb);
+	return 0;
+}
+EXPORT_SYMBOL(xfrm6_rcv_encap);
+
 static int xfrm6_esp_rcv(struct sk_buff *skb)
 {
 	int ret;
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index eb9928c0a87c..02f8f46d0cc5 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -755,6 +755,7 @@ static struct pernet_operations xfrmi_net_ops = {
 
 static struct xfrm6_protocol xfrmi_esp6_protocol __read_mostly = {
 	.handler	=	xfrm6_rcv,
+	.input_handler	=	xfrm_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
 	.priority	=	10,
@@ -762,6 +763,7 @@ static struct xfrm6_protocol xfrmi_esp6_protocol __read_mostly = {
 
 static struct xfrm6_protocol xfrmi_ah6_protocol __read_mostly = {
 	.handler	=	xfrm6_rcv,
+	.input_handler	=	xfrm_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
 	.priority	=	10,
@@ -769,6 +771,7 @@ static struct xfrm6_protocol xfrmi_ah6_protocol __read_mostly = {
 
 static struct xfrm6_protocol xfrmi_ipcomp6_protocol __read_mostly = {
 	.handler	=	xfrm6_rcv,
+	.input_handler	=	xfrm_input,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
 	.priority	=	10,
-- 
2.17.1

