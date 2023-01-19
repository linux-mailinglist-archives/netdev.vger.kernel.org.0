Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24FC06742E5
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjASTdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjASTdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:33:47 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B844CE7B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 11:33:45 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 794BF204B4;
        Thu, 19 Jan 2023 20:33:44 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lXqhbLXUo1vq; Thu, 19 Jan 2023 20:33:43 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B5A2920460;
        Thu, 19 Jan 2023 20:33:43 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id A6D8480004A;
        Thu, 19 Jan 2023 20:33:43 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 19 Jan 2023 20:33:43 +0100
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 20:33:42 +0100
Date:   Thu, 19 Jan 2023 20:33:37 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH 2/3] xfrm: Support GRO for IPv4 ESP in UDP encapsulation.
Message-ID: <2527cc66bfbcf70bcfd64efdf8ff79d60199827e.1674156645.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
References: <6dfd03c5fa0afb99f255f4a35772df19e33880db.1674156645.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6dfd03c5fa0afb99f255f4a35772df19e33880db.1674156645.git.antony.antony@secunet.com>
Organization: secunet
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

This patch enables the GRO codepath for IPv4 ESP in UDP encapsulated
packets. Decapsulation happens at L2 and saves a full round through
the stack for each packet. This is also needed to support HW offload
for ESP in UDP encapsulation.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Co-developed-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 include/net/gro.h       |  2 +-
 include/net/xfrm.h      |  4 ++
 net/ipv4/esp4_offload.c | 11 ++++-
 net/ipv4/udp.c          |  4 +-
 net/ipv4/xfrm4_input.c  | 99 +++++++++++++++++++++++++++++++++--------
 5 files changed, 99 insertions(+), 21 deletions(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index a4fab706240d..41c12c5d1ea1 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -29,7 +29,7 @@ struct napi_gro_cb {
 	/* Number of segments aggregated. */
 	u16	count;
 
-	/* Used in ipv6_gro_receive() and foo-over-udp */
+	/* Used in ipv6_gro_receive() and foo-over-udp and esp-in-udp */
 	u16	proto;
 
 	/* jiffies when first packet was created/queued */
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 3e1f70e8e424..74dba98fbf2c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1666,6 +1666,8 @@ void xfrm_local_error(struct sk_buff *skb, int mtu);
 int xfrm4_extract_input(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm4_rcv_encap(struct sk_buff *skb, int nexthdr, __be32 spi,
 		    int encap_type);
+struct sk_buff *xfrm4_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
+					struct sk_buff *skb);
 int xfrm4_transport_finish(struct sk_buff *skb, int async);
 int xfrm4_rcv(struct sk_buff *skb);
 
@@ -1706,6 +1708,8 @@ int xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 void xfrm6_local_rxpmtu(struct sk_buff *skb, u32 mtu);
 int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb);
 int xfrm6_udp_encap_rcv(struct sock *sk, struct sk_buff *skb);
+struct sk_buff *xfrm4_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
+					struct sk_buff *skb);
 int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval,
 		     int optlen);
 #else
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 77bb01032667..8769bb669fdd 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -32,6 +32,7 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 	int offset = skb_gro_offset(skb);
 	struct xfrm_offload *xo;
 	struct xfrm_state *x;
+	int encap_type = 0;
 	__be32 seq;
 	__be32 spi;
 
@@ -69,6 +70,14 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 
 	xo->flags |= XFRM_GRO;
 
+	if (NAPI_GRO_CB(skb)->proto == IPPROTO_UDP && skb->sk &&
+	    (udp_sk(skb->sk)->encap_type == UDP_ENCAP_ESPINUDP ||
+	     udp_sk(skb->sk)->encap_type == UDP_ENCAP_ESPINUDP_NON_IKE)) {
+		encap_type = udp_sk(skb->sk)->encap_type;
+		sock_put(skb->sk);
+		skb->sk = NULL;
+	}
+
 	XFRM_TUNNEL_SKB_CB(skb)->tunnel.ip4 = NULL;
 	XFRM_SPI_SKB_CB(skb)->family = AF_INET;
 	XFRM_SPI_SKB_CB(skb)->daddroff = offsetof(struct iphdr, daddr);
@@ -76,7 +85,7 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 
 	/* We don't need to handle errors from xfrm_input, it does all
 	 * the error handling and frees the resources on error. */
-	xfrm_input(skb, IPPROTO_ESP, spi, 0);
+	xfrm_input(skb, IPPROTO_ESP, spi, encap_type);
 
 	return ERR_PTR(-EINPROGRESS);
 out_reset:
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9592fe3e444a..6a30d0210c4e 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2729,9 +2729,11 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 #if IS_ENABLED(CONFIG_IPV6)
 			if (sk->sk_family == AF_INET6)
 				up->encap_rcv = ipv6_stub->xfrm6_udp_encap_rcv;
-			else
 #endif
+			if (sk->sk_family == AF_INET) {
 				up->encap_rcv = xfrm4_udp_encap_rcv;
+				up->gro_receive = xfrm4_gro_udp_encap_rcv;
+			}
 #endif
 			fallthrough;
 		case UDP_ENCAP_L2TPINUDP:
diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index ad2afeef4f10..768d12491a48 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -17,6 +17,8 @@
 #include <linux/netfilter_ipv4.h>
 #include <net/ip.h>
 #include <net/xfrm.h>
+#include <net/protocol.h>
+#include <net/gro.h>
 
 static int xfrm4_rcv_encap_finish2(struct net *net, struct sock *sk,
 				   struct sk_buff *skb)
@@ -72,14 +74,7 @@ int xfrm4_transport_finish(struct sk_buff *skb, int async)
 	return 0;
 }
 
-/* If it's a keepalive packet, then just eat it.
- * If it's an encapsulated packet, then pass it to the
- * IPsec xfrm input.
- * Returns 0 if skb passed to xfrm or was dropped.
- * Returns >0 if skb should be passed to UDP.
- * Returns <0 if skb should be resubmitted (-ret is protocol)
- */
-int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
+static int __xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb, bool pull)
 {
 	struct udp_sock *up = udp_sk(sk);
 	struct udphdr *uh;
@@ -110,7 +105,7 @@ int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
 	case UDP_ENCAP_ESPINUDP:
 		/* Check if this is a keepalive packet.  If so, eat it. */
 		if (len == 1 && udpdata[0] == 0xff) {
-			goto drop;
+			return -EINVAL;
 		} else if (len > sizeof(struct ip_esp_hdr) && udpdata32[0] != 0) {
 			/* ESP Packet without Non-ESP header */
 			len = sizeof(struct udphdr);
@@ -121,7 +116,7 @@ int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
 	case UDP_ENCAP_ESPINUDP_NON_IKE:
 		/* Check if this is a keepalive packet.  If so, eat it. */
 		if (len == 1 && udpdata[0] == 0xff) {
-			goto drop;
+			return -EINVAL;
 		} else if (len > 2 * sizeof(u32) + sizeof(struct ip_esp_hdr) &&
 			   udpdata32[0] == 0 && udpdata32[1] == 0) {
 
@@ -139,7 +134,7 @@ int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
 	 * protocol to ESP, and then call into the transform receiver.
 	 */
 	if (skb_unclone(skb, GFP_ATOMIC))
-		goto drop;
+		return -EINVAL;
 
 	/* Now we can update and verify the packet length... */
 	iph = ip_hdr(skb);
@@ -147,24 +142,92 @@ int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
 	iph->tot_len = htons(ntohs(iph->tot_len) - len);
 	if (skb->len < iphlen + len) {
 		/* packet is too small!?! */
-		goto drop;
+		return -EINVAL;
 	}
 
 	/* pull the data buffer up to the ESP header and set the
 	 * transport header to point to ESP.  Keep UDP on the stack
 	 * for later.
 	 */
-	__skb_pull(skb, len);
-	skb_reset_transport_header(skb);
+	if (pull) {
+		__skb_pull(skb, len);
+		skb_reset_transport_header(skb);
+	} else {
+		skb_set_transport_header(skb, len);
+	}
 
 	/* process ESP */
-	return xfrm4_rcv_encap(skb, IPPROTO_ESP, 0, encap_type);
-
-drop:
-	kfree_skb(skb);
 	return 0;
 }
 
+/* If it's a keepalive packet, then just eat it.
+ * If it's an encapsulated packet, then pass it to the
+ * IPsec xfrm input.
+ * Returns 0 if skb passed to xfrm or was dropped.
+ * Returns >0 if skb should be passed to UDP.
+ * Returns <0 if skb should be resubmitted (-ret is protocol)
+ */
+int xfrm4_udp_encap_rcv(struct sock *sk, struct sk_buff *skb)
+{
+	int ret;
+
+	ret = __xfrm4_udp_encap_rcv(sk, skb, true);
+	if (!ret)
+		return xfrm4_rcv_encap(skb, IPPROTO_ESP, 0,
+				       udp_sk(sk)->encap_type);
+
+	if (ret < 0) {
+		kfree_skb(skb);
+		return 0;
+	}
+
+	return ret;
+}
+
+struct sk_buff *xfrm4_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
+					struct sk_buff *skb)
+{
+	int offset = skb_gro_offset(skb);
+	const struct net_offload *ops;
+	struct sk_buff *pp = NULL;
+	int ret;
+
+	offset = offset - sizeof(struct udphdr);
+
+	if (!pskb_pull(skb, offset))
+		return NULL;
+
+	if (!refcount_inc_not_zero(&sk->sk_refcnt))
+		return NULL;
+
+	rcu_read_lock();
+	ops = rcu_dereference(inet_offloads[IPPROTO_ESP]);
+	if (!ops || !ops->callbacks.gro_receive)
+		goto out;
+
+	ret = __xfrm4_udp_encap_rcv(sk, skb, false);
+	if (ret)
+		goto out;
+
+	skb->sk = sk;
+	skb_push(skb, offset);
+	NAPI_GRO_CB(skb)->proto = IPPROTO_UDP;
+
+	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
+	rcu_read_unlock();
+
+	return pp;
+
+out:
+	rcu_read_unlock();
+	sock_put(sk);
+	skb_push(skb, offset);
+	NAPI_GRO_CB(skb)->same_flow = 0;
+	NAPI_GRO_CB(skb)->flush = 1;
+
+	return NULL;
+}
+
 int xfrm4_rcv(struct sk_buff *skb)
 {
 	return xfrm4_rcv_spi(skb, ip_hdr(skb)->protocol, 0);
-- 
2.30.2

