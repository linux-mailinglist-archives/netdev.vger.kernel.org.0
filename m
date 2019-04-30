Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2BA0F086
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfD3Ghh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:37 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48808 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbfD3Ghg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 60FE22026F;
        Tue, 30 Apr 2019 08:37:34 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yFS0y1yEj0_y; Tue, 30 Apr 2019 08:37:33 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 097CF20276;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 1CC1B3180604;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 06/18] xfrm: remove output indirection from xfrm_mode
Date:   Tue, 30 Apr 2019 08:37:15 +0200
Message-ID: <20190430063727.10908-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430063727.10908-1-steffen.klassert@secunet.com>
References: <20190430063727.10908-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 461329AE-2909-4A27-9016-21ED5CDA3330
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Same is input indirection.  Only exception: we need to export
xfrm_outer_mode_output for pktgen.

Increases size of vmlinux by about 163 byte:
Before:
   text    data     bss     dec      filename
15730208  6936948 4046908 26714064   vmlinux

After:
15730311  6937008 4046908 26714227   vmlinux

xfrm_inner_extract_output has no more external callers, make it static.

v2: add IS_ENABLED(IPV6) guard in xfrm6_prepare_output
    add two missing breaks in xfrm_outer_mode_output (Sabrina Dubroca)
    add WARN_ON_ONCE for 'call AF_INET6 related output function, but
    CONFIG_IPV6=n' case.
    make xfrm_inner_extract_output static

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h              |  19 +---
 net/core/pktgen.c               |   2 +-
 net/ipv4/xfrm4_mode_beet.c      |   1 -
 net/ipv4/xfrm4_mode_transport.c |  22 -----
 net/ipv4/xfrm4_mode_tunnel.c    |   1 -
 net/ipv4/xfrm4_output.c         |  15 ---
 net/ipv6/xfrm6_mode_beet.c      |   1 -
 net/ipv6/xfrm6_mode_ro.c        |  28 ------
 net/ipv6/xfrm6_mode_transport.c |  26 -----
 net/ipv6/xfrm6_mode_tunnel.c    |   1 -
 net/ipv6/xfrm6_output.c         |  15 ---
 net/xfrm/xfrm_output.c          | 166 +++++++++++++++++++++++++++++++-
 12 files changed, 169 insertions(+), 128 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2c5fc9cc367d..01e7e9c0e8a9 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -449,17 +449,6 @@ struct xfrm_mode {
 	 */
 	int (*output2)(struct xfrm_state *x,struct sk_buff *skb);
 
-	/*
-	 * This is the actual output entry point.
-	 *
-	 * For transport mode and equivalent this would be identical to
-	 * output2 (which does not need to be set).  While tunnel mode
-	 * and equivalent would set this to a tunnel encapsulation function
-	 * (xfrm4_prepare_output or xfrm6_prepare_output) that would in turn
-	 * call output2.
-	 */
-	int (*output)(struct xfrm_state *x, struct sk_buff *skb);
-
 	/*
 	 * Adjust pointers into the packet and do GSO segmentation.
 	 */
@@ -1603,7 +1592,11 @@ int xfrm_trans_queue(struct sk_buff *skb,
 				   struct sk_buff *));
 int xfrm_output_resume(struct sk_buff *skb, int err);
 int xfrm_output(struct sock *sk, struct sk_buff *skb);
-int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb);
+
+#if IS_ENABLED(CONFIG_NET_PKTGEN)
+int pktgen_xfrm_outer_mode_output(struct xfrm_state *x, struct sk_buff *skb);
+#endif
+
 void xfrm_local_error(struct sk_buff *skb, int mtu);
 int xfrm4_extract_header(struct sk_buff *skb);
 int xfrm4_extract_input(struct xfrm_state *x, struct sk_buff *skb);
@@ -1622,7 +1615,6 @@ static inline int xfrm4_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi)
 }
 
 int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb);
-int xfrm4_prepare_output(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 int xfrm4_output_finish(struct sock *sk, struct sk_buff *skb);
 int xfrm4_rcv_cb(struct sk_buff *skb, u8 protocol, int err);
@@ -1649,7 +1641,6 @@ int xfrm6_tunnel_deregister(struct xfrm6_tunnel *handler, unsigned short family)
 __be32 xfrm6_tunnel_alloc_spi(struct net *net, xfrm_address_t *saddr);
 __be32 xfrm6_tunnel_spi_lookup(struct net *net, const xfrm_address_t *saddr);
 int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb);
-int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm6_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb);
 int xfrm6_find_1stfragopt(struct xfrm_state *x, struct sk_buff *skb,
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index f3f5a78cd062..319ad5490fb3 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2521,7 +2521,7 @@ static int pktgen_output_ipsec(struct sk_buff *skb, struct pktgen_dev *pkt_dev)
 		skb->_skb_refdst = (unsigned long)&pkt_dev->xdst.u.dst | SKB_DST_NOREF;
 
 	rcu_read_lock_bh();
-	err = x->outer_mode->output(x, skb);
+	err = pktgen_xfrm_outer_mode_output(x, skb);
 	rcu_read_unlock_bh();
 	if (err) {
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTSTATEMODEERROR);
diff --git a/net/ipv4/xfrm4_mode_beet.c b/net/ipv4/xfrm4_mode_beet.c
index 264c4c9e2473..f02cc8237d54 100644
--- a/net/ipv4/xfrm4_mode_beet.c
+++ b/net/ipv4/xfrm4_mode_beet.c
@@ -129,7 +129,6 @@ static int xfrm4_beet_input(struct xfrm_state *x, struct sk_buff *skb)
 static struct xfrm_mode xfrm4_beet_mode = {
 	.input2 = xfrm4_beet_input,
 	.output2 = xfrm4_beet_output,
-	.output = xfrm4_prepare_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_BEET,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
diff --git a/net/ipv4/xfrm4_mode_transport.c b/net/ipv4/xfrm4_mode_transport.c
index c943d710f302..6f8cf09ff0ef 100644
--- a/net/ipv4/xfrm4_mode_transport.c
+++ b/net/ipv4/xfrm4_mode_transport.c
@@ -14,27 +14,6 @@
 #include <net/xfrm.h>
 #include <net/protocol.h>
 
-/* Add encapsulation header.
- *
- * The IP header will be moved forward to make space for the encapsulation
- * header.
- */
-static int xfrm4_transport_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct iphdr *iph = ip_hdr(skb);
-	int ihl = iph->ihl * 4;
-
-	skb_set_inner_transport_header(skb, skb_transport_offset(skb));
-
-	skb_set_network_header(skb, -x->props.header_len);
-	skb->mac_header = skb->network_header +
-			  offsetof(struct iphdr, protocol);
-	skb->transport_header = skb->network_header + ihl;
-	__skb_pull(skb, ihl);
-	memmove(skb_network_header(skb), iph, ihl);
-	return 0;
-}
-
 static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
 						   struct sk_buff *skb,
 						   netdev_features_t features)
@@ -65,7 +44,6 @@ static void xfrm4_transport_xmit(struct xfrm_state *x, struct sk_buff *skb)
 }
 
 static struct xfrm_mode xfrm4_transport_mode = {
-	.output = xfrm4_transport_output,
 	.gso_segment = xfrm4_transport_gso_segment,
 	.xmit = xfrm4_transport_xmit,
 	.owner = THIS_MODULE,
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index 678b91754b5e..823bc54b47de 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -124,7 +124,6 @@ static void xfrm4_mode_tunnel_xmit(struct xfrm_state *x, struct sk_buff *skb)
 static struct xfrm_mode xfrm4_tunnel_mode = {
 	.input2 = xfrm4_mode_tunnel_input,
 	.output2 = xfrm4_mode_tunnel_output,
-	.output = xfrm4_prepare_output,
 	.gso_segment = xfrm4_mode_tunnel_gso_segment,
 	.xmit = xfrm4_mode_tunnel_xmit,
 	.owner = THIS_MODULE,
diff --git a/net/ipv4/xfrm4_output.c b/net/ipv4/xfrm4_output.c
index be980c195fc5..6802d1aee424 100644
--- a/net/ipv4/xfrm4_output.c
+++ b/net/ipv4/xfrm4_output.c
@@ -58,21 +58,6 @@ int xfrm4_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 	return xfrm4_extract_header(skb);
 }
 
-int xfrm4_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	int err;
-
-	err = xfrm_inner_extract_output(x, skb);
-	if (err)
-		return err;
-
-	IPCB(skb)->flags |= IPSKB_XFRM_TUNNEL_SIZE;
-	skb->protocol = htons(ETH_P_IP);
-
-	return x->outer_mode->output2(x, skb);
-}
-EXPORT_SYMBOL(xfrm4_prepare_output);
-
 int xfrm4_output_finish(struct sock *sk, struct sk_buff *skb)
 {
 	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
diff --git a/net/ipv6/xfrm6_mode_beet.c b/net/ipv6/xfrm6_mode_beet.c
index eadacaddfcae..6f35e24f0077 100644
--- a/net/ipv6/xfrm6_mode_beet.c
+++ b/net/ipv6/xfrm6_mode_beet.c
@@ -105,7 +105,6 @@ static int xfrm6_beet_input(struct xfrm_state *x, struct sk_buff *skb)
 static struct xfrm_mode xfrm6_beet_mode = {
 	.input2 = xfrm6_beet_input,
 	.output2 = xfrm6_beet_output,
-	.output = xfrm6_prepare_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_BEET,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
diff --git a/net/ipv6/xfrm6_mode_ro.c b/net/ipv6/xfrm6_mode_ro.c
index 0408547d01ab..d0a6a4dbd689 100644
--- a/net/ipv6/xfrm6_mode_ro.c
+++ b/net/ipv6/xfrm6_mode_ro.c
@@ -33,35 +33,7 @@
 #include <net/ipv6.h>
 #include <net/xfrm.h>
 
-/* Add route optimization header space.
- *
- * The IP header and mutable extension headers will be moved forward to make
- * space for the route optimization header.
- */
-static int xfrm6_ro_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct ipv6hdr *iph;
-	u8 *prevhdr;
-	int hdr_len;
-
-	iph = ipv6_hdr(skb);
-
-	hdr_len = x->type->hdr_offset(x, skb, &prevhdr);
-	if (hdr_len < 0)
-		return hdr_len;
-	skb_set_mac_header(skb, (prevhdr - x->props.header_len) - skb->data);
-	skb_set_network_header(skb, -x->props.header_len);
-	skb->transport_header = skb->network_header + hdr_len;
-	__skb_pull(skb, hdr_len);
-	memmove(ipv6_hdr(skb), iph, hdr_len);
-
-	x->lastused = ktime_get_real_seconds();
-
-	return 0;
-}
-
 static struct xfrm_mode xfrm6_ro_mode = {
-	.output = xfrm6_ro_output,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_ROUTEOPTIMIZATION,
 	.family = AF_INET6,
diff --git a/net/ipv6/xfrm6_mode_transport.c b/net/ipv6/xfrm6_mode_transport.c
index 4c306bb99284..1e7165a8481a 100644
--- a/net/ipv6/xfrm6_mode_transport.c
+++ b/net/ipv6/xfrm6_mode_transport.c
@@ -15,31 +15,6 @@
 #include <net/xfrm.h>
 #include <net/protocol.h>
 
-/* Add encapsulation header.
- *
- * The IP header and mutable extension headers will be moved forward to make
- * space for the encapsulation header.
- */
-static int xfrm6_transport_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct ipv6hdr *iph;
-	u8 *prevhdr;
-	int hdr_len;
-
-	iph = ipv6_hdr(skb);
-	skb_set_inner_transport_header(skb, skb_transport_offset(skb));
-
-	hdr_len = x->type->hdr_offset(x, skb, &prevhdr);
-	if (hdr_len < 0)
-		return hdr_len;
-	skb_set_mac_header(skb, (prevhdr - x->props.header_len) - skb->data);
-	skb_set_network_header(skb, -x->props.header_len);
-	skb->transport_header = skb->network_header + hdr_len;
-	__skb_pull(skb, hdr_len);
-	memmove(ipv6_hdr(skb), iph, hdr_len);
-	return 0;
-}
-
 static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
 						   struct sk_buff *skb,
 						   netdev_features_t features)
@@ -70,7 +45,6 @@ static void xfrm6_transport_xmit(struct xfrm_state *x, struct sk_buff *skb)
 }
 
 static struct xfrm_mode xfrm6_transport_mode = {
-	.output = xfrm6_transport_output,
 	.gso_segment = xfrm4_transport_gso_segment,
 	.xmit = xfrm6_transport_xmit,
 	.owner = THIS_MODULE,
diff --git a/net/ipv6/xfrm6_mode_tunnel.c b/net/ipv6/xfrm6_mode_tunnel.c
index 1e9677fd6559..e1a129524dde 100644
--- a/net/ipv6/xfrm6_mode_tunnel.c
+++ b/net/ipv6/xfrm6_mode_tunnel.c
@@ -123,7 +123,6 @@ static void xfrm6_mode_tunnel_xmit(struct xfrm_state *x, struct sk_buff *skb)
 static struct xfrm_mode xfrm6_tunnel_mode = {
 	.input2 = xfrm6_mode_tunnel_input,
 	.output2 = xfrm6_mode_tunnel_output,
-	.output = xfrm6_prepare_output,
 	.gso_segment = xfrm6_mode_tunnel_gso_segment,
 	.xmit = xfrm6_mode_tunnel_xmit,
 	.owner = THIS_MODULE,
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index 6a74080005cf..2b663d2ffdcd 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -111,21 +111,6 @@ int xfrm6_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 	return xfrm6_extract_header(skb);
 }
 
-int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
-{
-	int err;
-
-	err = xfrm_inner_extract_output(x, skb);
-	if (err)
-		return err;
-
-	skb->ignore_df = 1;
-	skb->protocol = htons(ETH_P_IPV6);
-
-	return x->outer_mode->output2(x, skb);
-}
-EXPORT_SYMBOL(xfrm6_prepare_output);
-
 int xfrm6_output_finish(struct sock *sk, struct sk_buff *skb)
 {
 	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 9333153bafda..05926dcf5d17 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -20,6 +20,7 @@
 #include <net/xfrm.h>
 
 static int xfrm_output2(struct net *net, struct sock *sk, struct sk_buff *skb);
+static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb);
 
 static int xfrm_skb_check_space(struct sk_buff *skb)
 {
@@ -50,6 +51,166 @@ static struct dst_entry *skb_dst_pop(struct sk_buff *skb)
 	return child;
 }
 
+/* Add encapsulation header.
+ *
+ * The IP header will be moved forward to make space for the encapsulation
+ * header.
+ */
+static int xfrm4_transport_output(struct xfrm_state *x, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_INET_XFRM_MODE_TRANSPORT)
+	struct iphdr *iph = ip_hdr(skb);
+	int ihl = iph->ihl * 4;
+
+	skb_set_inner_transport_header(skb, skb_transport_offset(skb));
+
+	skb_set_network_header(skb, -x->props.header_len);
+	skb->mac_header = skb->network_header +
+			  offsetof(struct iphdr, protocol);
+	skb->transport_header = skb->network_header + ihl;
+	__skb_pull(skb, ihl);
+	memmove(skb_network_header(skb), iph, ihl);
+	return 0;
+#else
+	WARN_ON_ONCE(1);
+	return -EOPNOTSUPP;
+#endif
+}
+
+/* Add encapsulation header.
+ *
+ * The IP header and mutable extension headers will be moved forward to make
+ * space for the encapsulation header.
+ */
+static int xfrm6_transport_output(struct xfrm_state *x, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_INET6_XFRM_MODE_TRANSPORT)
+	struct ipv6hdr *iph;
+	u8 *prevhdr;
+	int hdr_len;
+
+	iph = ipv6_hdr(skb);
+	skb_set_inner_transport_header(skb, skb_transport_offset(skb));
+
+	hdr_len = x->type->hdr_offset(x, skb, &prevhdr);
+	if (hdr_len < 0)
+		return hdr_len;
+	skb_set_mac_header(skb,
+			   (prevhdr - x->props.header_len) - skb->data);
+	skb_set_network_header(skb, -x->props.header_len);
+	skb->transport_header = skb->network_header + hdr_len;
+	__skb_pull(skb, hdr_len);
+	memmove(ipv6_hdr(skb), iph, hdr_len);
+	return 0;
+#else
+	WARN_ON_ONCE(1);
+	return -EOPNOTSUPP;
+#endif
+}
+
+/* Add route optimization header space.
+ *
+ * The IP header and mutable extension headers will be moved forward to make
+ * space for the route optimization header.
+ */
+static int xfrm6_ro_output(struct xfrm_state *x, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION)
+	struct ipv6hdr *iph;
+	u8 *prevhdr;
+	int hdr_len;
+
+	iph = ipv6_hdr(skb);
+
+	hdr_len = x->type->hdr_offset(x, skb, &prevhdr);
+	if (hdr_len < 0)
+		return hdr_len;
+	skb_set_mac_header(skb,
+			   (prevhdr - x->props.header_len) - skb->data);
+	skb_set_network_header(skb, -x->props.header_len);
+	skb->transport_header = skb->network_header + hdr_len;
+	__skb_pull(skb, hdr_len);
+	memmove(ipv6_hdr(skb), iph, hdr_len);
+
+	x->lastused = ktime_get_real_seconds();
+
+	return 0;
+#else
+	WARN_ON_ONCE(1);
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int xfrm4_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
+{
+	int err;
+
+	err = xfrm_inner_extract_output(x, skb);
+	if (err)
+		return err;
+
+	IPCB(skb)->flags |= IPSKB_XFRM_TUNNEL_SIZE;
+	skb->protocol = htons(ETH_P_IP);
+
+	return x->outer_mode->output2(x, skb);
+}
+
+static int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	int err;
+
+	err = xfrm_inner_extract_output(x, skb);
+	if (err)
+		return err;
+
+	skb->ignore_df = 1;
+	skb->protocol = htons(ETH_P_IPV6);
+
+	return x->outer_mode->output2(x, skb);
+#else
+	WARN_ON_ONCE(1);
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int xfrm_outer_mode_output(struct xfrm_state *x, struct sk_buff *skb)
+{
+	switch (x->outer_mode->encap) {
+	case XFRM_MODE_BEET:
+	case XFRM_MODE_TUNNEL:
+		if (x->outer_mode->family == AF_INET)
+			return xfrm4_prepare_output(x, skb);
+		if (x->outer_mode->family == AF_INET6)
+			return xfrm6_prepare_output(x, skb);
+		break;
+	case XFRM_MODE_TRANSPORT:
+		if (x->outer_mode->family == AF_INET)
+			return xfrm4_transport_output(x, skb);
+		if (x->outer_mode->family == AF_INET6)
+			return xfrm6_transport_output(x, skb);
+		break;
+	case XFRM_MODE_ROUTEOPTIMIZATION:
+		if (x->outer_mode->family == AF_INET6)
+			return xfrm6_ro_output(x, skb);
+		WARN_ON_ONCE(1);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+#if IS_ENABLED(CONFIG_NET_PKTGEN)
+int pktgen_xfrm_outer_mode_output(struct xfrm_state *x, struct sk_buff *skb)
+{
+	return xfrm_outer_mode_output(x, skb);
+}
+EXPORT_SYMBOL_GPL(pktgen_xfrm_outer_mode_output);
+#endif
+
 static int xfrm_output_one(struct sk_buff *skb, int err)
 {
 	struct dst_entry *dst = skb_dst(skb);
@@ -68,7 +229,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 
 		skb->mark = xfrm_smark_get(skb->mark, x);
 
-		err = x->outer_mode->output(x, skb);
+		err = xfrm_outer_mode_output(x, skb);
 		if (err) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTSTATEMODEERROR);
 			goto error_nolock;
@@ -258,7 +419,7 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(xfrm_output);
 
-int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
+static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 {
 	struct xfrm_mode *inner_mode;
 	if (x->sel.family == AF_UNSPEC)
@@ -271,7 +432,6 @@ int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 		return -EAFNOSUPPORT;
 	return inner_mode->afinfo->extract_output(x, skb);
 }
-EXPORT_SYMBOL_GPL(xfrm_inner_extract_output);
 
 void xfrm_local_error(struct sk_buff *skb, int mtu)
 {
-- 
2.17.1

