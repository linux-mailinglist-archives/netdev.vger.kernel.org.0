Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B33F088
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfD3Ghj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:39 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48814 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbfD3Ghi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C340A20276;
        Tue, 30 Apr 2019 08:37:34 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G4-1PSIxKDVm; Tue, 30 Apr 2019 08:37:34 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0AFB020277;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 1824731805F4;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 05/18] xfrm: remove input indirection from xfrm_mode
Date:   Tue, 30 Apr 2019 08:37:14 +0200
Message-ID: <20190430063727.10908-6-steffen.klassert@secunet.com>
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
X-G-Data-MailSecurity-for-Exchange-Guid: 1D7F7FE6-62C1-4657-AD89-8221C7D98F6F
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

No need for any indirection or abstraction here, both functions
are pretty much the same and quite small, they also have no external
dependencies.

xfrm_prepare_input can then be made static.

With allmodconfig build, size increase of vmlinux is 25 byte:

Before:
   text   data     bss     dec      filename
15730207  6936924 4046908 26714039  vmlinux

After:
15730208  6936948 4046908 26714064 vmlinux

v2: Fix INET_XFRM_MODE_TRANSPORT name in is-enabled test (Sabrina Dubroca)
    change copied comment to refer to transport and network header,
    not skb->{h,nh}, which don't exist anymore. (Sabrina)
    make xfrm_prepare_input static (Eyal Birger)

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h              | 11 -----
 net/ipv4/xfrm4_mode_beet.c      |  1 -
 net/ipv4/xfrm4_mode_transport.c | 23 ----------
 net/ipv4/xfrm4_mode_tunnel.c    |  1 -
 net/ipv6/xfrm6_mode_beet.c      |  1 -
 net/ipv6/xfrm6_mode_transport.c | 25 -----------
 net/ipv6/xfrm6_mode_tunnel.c    |  1 -
 net/xfrm/xfrm_input.c           | 75 +++++++++++++++++++++++++++++++--
 8 files changed, 72 insertions(+), 66 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 9a155063c25f..2c5fc9cc367d 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -436,16 +436,6 @@ struct xfrm_mode {
 	 */
 	int (*input2)(struct xfrm_state *x, struct sk_buff *skb);
 
-	/*
-	 * This is the actual input entry point.
-	 *
-	 * For transport mode and equivalent this would be identical to
-	 * input2 (which does not need to be set).  While tunnel mode
-	 * and equivalent would set this to the tunnel encapsulation function
-	 * xfrm4_prepare_input that would in turn call input2.
-	 */
-	int (*input)(struct xfrm_state *x, struct sk_buff *skb);
-
 	/*
 	 * Add encapsulation header.
 	 *
@@ -1606,7 +1596,6 @@ int xfrm_init_replay(struct xfrm_state *x);
 int xfrm_state_mtu(struct xfrm_state *x, int mtu);
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
 int xfrm_init_state(struct xfrm_state *x);
-int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb);
 int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type);
 int xfrm_input_resume(struct sk_buff *skb, int nexthdr);
 int xfrm_trans_queue(struct sk_buff *skb,
diff --git a/net/ipv4/xfrm4_mode_beet.c b/net/ipv4/xfrm4_mode_beet.c
index a2e3b52ae46c..264c4c9e2473 100644
--- a/net/ipv4/xfrm4_mode_beet.c
+++ b/net/ipv4/xfrm4_mode_beet.c
@@ -128,7 +128,6 @@ static int xfrm4_beet_input(struct xfrm_state *x, struct sk_buff *skb)
 
 static struct xfrm_mode xfrm4_beet_mode = {
 	.input2 = xfrm4_beet_input,
-	.input = xfrm_prepare_input,
 	.output2 = xfrm4_beet_output,
 	.output = xfrm4_prepare_output,
 	.owner = THIS_MODULE,
diff --git a/net/ipv4/xfrm4_mode_transport.c b/net/ipv4/xfrm4_mode_transport.c
index 7c5443f797cf..c943d710f302 100644
--- a/net/ipv4/xfrm4_mode_transport.c
+++ b/net/ipv4/xfrm4_mode_transport.c
@@ -35,28 +35,6 @@ static int xfrm4_transport_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 }
 
-/* Remove encapsulation header.
- *
- * The IP header will be moved over the top of the encapsulation header.
- *
- * On entry, skb->h shall point to where the IP header should be and skb->nh
- * shall be set to where the IP header currently is.  skb->data shall point
- * to the start of the payload.
- */
-static int xfrm4_transport_input(struct xfrm_state *x, struct sk_buff *skb)
-{
-	int ihl = skb->data - skb_transport_header(skb);
-
-	if (skb->transport_header != skb->network_header) {
-		memmove(skb_transport_header(skb),
-			skb_network_header(skb), ihl);
-		skb->network_header = skb->transport_header;
-	}
-	ip_hdr(skb)->tot_len = htons(skb->len + ihl);
-	skb_reset_transport_header(skb);
-	return 0;
-}
-
 static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
 						   struct sk_buff *skb,
 						   netdev_features_t features)
@@ -87,7 +65,6 @@ static void xfrm4_transport_xmit(struct xfrm_state *x, struct sk_buff *skb)
 }
 
 static struct xfrm_mode xfrm4_transport_mode = {
-	.input = xfrm4_transport_input,
 	.output = xfrm4_transport_output,
 	.gso_segment = xfrm4_transport_gso_segment,
 	.xmit = xfrm4_transport_xmit,
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index cfc6b6d39755..678b91754b5e 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -123,7 +123,6 @@ static void xfrm4_mode_tunnel_xmit(struct xfrm_state *x, struct sk_buff *skb)
 
 static struct xfrm_mode xfrm4_tunnel_mode = {
 	.input2 = xfrm4_mode_tunnel_input,
-	.input = xfrm_prepare_input,
 	.output2 = xfrm4_mode_tunnel_output,
 	.output = xfrm4_prepare_output,
 	.gso_segment = xfrm4_mode_tunnel_gso_segment,
diff --git a/net/ipv6/xfrm6_mode_beet.c b/net/ipv6/xfrm6_mode_beet.c
index 0d440e3a13f8..eadacaddfcae 100644
--- a/net/ipv6/xfrm6_mode_beet.c
+++ b/net/ipv6/xfrm6_mode_beet.c
@@ -104,7 +104,6 @@ static int xfrm6_beet_input(struct xfrm_state *x, struct sk_buff *skb)
 
 static struct xfrm_mode xfrm6_beet_mode = {
 	.input2 = xfrm6_beet_input,
-	.input = xfrm_prepare_input,
 	.output2 = xfrm6_beet_output,
 	.output = xfrm6_prepare_output,
 	.owner = THIS_MODULE,
diff --git a/net/ipv6/xfrm6_mode_transport.c b/net/ipv6/xfrm6_mode_transport.c
index 66ae79218bdf..4c306bb99284 100644
--- a/net/ipv6/xfrm6_mode_transport.c
+++ b/net/ipv6/xfrm6_mode_transport.c
@@ -40,29 +40,6 @@ static int xfrm6_transport_output(struct xfrm_state *x, struct sk_buff *skb)
 	return 0;
 }
 
-/* Remove encapsulation header.
- *
- * The IP header will be moved over the top of the encapsulation header.
- *
- * On entry, skb->h shall point to where the IP header should be and skb->nh
- * shall be set to where the IP header currently is.  skb->data shall point
- * to the start of the payload.
- */
-static int xfrm6_transport_input(struct xfrm_state *x, struct sk_buff *skb)
-{
-	int ihl = skb->data - skb_transport_header(skb);
-
-	if (skb->transport_header != skb->network_header) {
-		memmove(skb_transport_header(skb),
-			skb_network_header(skb), ihl);
-		skb->network_header = skb->transport_header;
-	}
-	ipv6_hdr(skb)->payload_len = htons(skb->len + ihl -
-					   sizeof(struct ipv6hdr));
-	skb_reset_transport_header(skb);
-	return 0;
-}
-
 static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
 						   struct sk_buff *skb,
 						   netdev_features_t features)
@@ -92,9 +69,7 @@ static void xfrm6_transport_xmit(struct xfrm_state *x, struct sk_buff *skb)
 	}
 }
 
-
 static struct xfrm_mode xfrm6_transport_mode = {
-	.input = xfrm6_transport_input,
 	.output = xfrm6_transport_output,
 	.gso_segment = xfrm4_transport_gso_segment,
 	.xmit = xfrm6_transport_xmit,
diff --git a/net/ipv6/xfrm6_mode_tunnel.c b/net/ipv6/xfrm6_mode_tunnel.c
index 6cf12e961ea5..1e9677fd6559 100644
--- a/net/ipv6/xfrm6_mode_tunnel.c
+++ b/net/ipv6/xfrm6_mode_tunnel.c
@@ -122,7 +122,6 @@ static void xfrm6_mode_tunnel_xmit(struct xfrm_state *x, struct sk_buff *skb)
 
 static struct xfrm_mode xfrm6_tunnel_mode = {
 	.input2 = xfrm6_mode_tunnel_input,
-	.input = xfrm_prepare_input,
 	.output2 = xfrm6_mode_tunnel_output,
 	.output = xfrm6_prepare_output,
 	.gso_segment = xfrm6_mode_tunnel_gso_segment,
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index ea5ac053c15d..0edf3fb73585 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -166,7 +166,7 @@ int xfrm_parse_spi(struct sk_buff *skb, u8 nexthdr, __be32 *spi, __be32 *seq)
 }
 EXPORT_SYMBOL(xfrm_parse_spi);
 
-int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
+static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 {
 	struct xfrm_mode *inner_mode = x->inner_mode;
 	int err;
@@ -184,7 +184,76 @@ int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 	skb->protocol = inner_mode->afinfo->eth_proto;
 	return inner_mode->input2(x, skb);
 }
-EXPORT_SYMBOL(xfrm_prepare_input);
+
+/* Remove encapsulation header.
+ *
+ * The IP header will be moved over the top of the encapsulation header.
+ *
+ * On entry, skb_transport_header() shall point to where the IP header
+ * should be and skb_network_header() shall be set to where the IP header
+ * currently is.  skb->data shall point to the start of the payload.
+ */
+static int xfrm4_transport_input(struct xfrm_state *x, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_INET_XFRM_MODE_TRANSPORT)
+	int ihl = skb->data - skb_transport_header(skb);
+
+	if (skb->transport_header != skb->network_header) {
+		memmove(skb_transport_header(skb),
+			skb_network_header(skb), ihl);
+		skb->network_header = skb->transport_header;
+	}
+	ip_hdr(skb)->tot_len = htons(skb->len + ihl);
+	skb_reset_transport_header(skb);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int xfrm6_transport_input(struct xfrm_state *x, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_INET6_XFRM_MODE_TRANSPORT)
+	int ihl = skb->data - skb_transport_header(skb);
+
+	if (skb->transport_header != skb->network_header) {
+		memmove(skb_transport_header(skb),
+			skb_network_header(skb), ihl);
+		skb->network_header = skb->transport_header;
+	}
+	ipv6_hdr(skb)->payload_len = htons(skb->len + ihl -
+					   sizeof(struct ipv6hdr));
+	skb_reset_transport_header(skb);
+	return 0;
+#else
+	return -EOPNOTSUPP;
+#endif
+}
+
+static int xfrm_inner_mode_input(struct xfrm_state *x,
+				 const struct xfrm_mode *inner_mode,
+				 struct sk_buff *skb)
+{
+	switch (inner_mode->encap) {
+	case XFRM_MODE_BEET:
+	case XFRM_MODE_TUNNEL:
+		return xfrm_prepare_input(x, skb);
+	case XFRM_MODE_TRANSPORT:
+		if (inner_mode->family == AF_INET)
+			return xfrm4_transport_input(x, skb);
+		if (inner_mode->family == AF_INET6)
+			return xfrm6_transport_input(x, skb);
+		break;
+	case XFRM_MODE_ROUTEOPTIMIZATION:
+		WARN_ON_ONCE(1);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
 
 int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 {
@@ -410,7 +479,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			}
 		}
 
-		if (inner_mode->input(x, skb)) {
+		if (xfrm_inner_mode_input(x, inner_mode, skb)) {
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEMODEERROR);
 			goto drop;
 		}
-- 
2.17.1

