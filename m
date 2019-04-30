Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72130F08E
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfD3Ght (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:49 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48816 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfD3Ghi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 08FC420273;
        Tue, 30 Apr 2019 08:37:35 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FSpL5q6avjKs; Tue, 30 Apr 2019 08:37:34 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0F0E820278;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 2116A3180606;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 07/18] xfrm: remove xmit indirection from xfrm_mode
Date:   Tue, 30 Apr 2019 08:37:16 +0200
Message-ID: <20190430063727.10908-8-steffen.klassert@secunet.com>
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
X-G-Data-MailSecurity-for-Exchange-Guid: 5F2369ED-051C-4EA4-B7B6-62A8834ED2EE
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

There are only two versions (tunnel and transport). The ip/ipv6 versions
are only differ in sizeof(iphdr) vs ipv6hdr.

Place this in the core and use x->outer_mode->encap type to call the
correct adjustment helper.

Before:
   text   data    bss     dec      filename
15730311  6937008 4046908 26714227 vmlinux

After:
15730428  6937008 4046908 26714344 vmlinux

(about 117 byte increase)

v2: use family from x->outer_mode, not inner

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h              |  5 ---
 net/ipv4/xfrm4_mode_transport.c | 14 --------
 net/ipv4/xfrm4_mode_tunnel.c    | 13 --------
 net/ipv6/xfrm6_mode_transport.c | 14 --------
 net/ipv6/xfrm6_mode_tunnel.c    | 12 -------
 net/xfrm/xfrm_device.c          | 58 +++++++++++++++++++++++++++++++--
 6 files changed, 56 insertions(+), 60 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 01e7e9c0e8a9..07966a27e4a4 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -454,11 +454,6 @@ struct xfrm_mode {
 	 */
 	struct sk_buff *(*gso_segment)(struct xfrm_state *x, struct sk_buff *skb, netdev_features_t features);
 
-	/*
-	 * Adjust pointers into the packet when IPsec is done at layer2.
-	 */
-	void (*xmit)(struct xfrm_state *x, struct sk_buff *skb);
-
 	struct xfrm_state_afinfo *afinfo;
 	struct module *owner;
 	u8 encap;
diff --git a/net/ipv4/xfrm4_mode_transport.c b/net/ipv4/xfrm4_mode_transport.c
index 6f8cf09ff0ef..d4b34bb2de00 100644
--- a/net/ipv4/xfrm4_mode_transport.c
+++ b/net/ipv4/xfrm4_mode_transport.c
@@ -30,22 +30,8 @@ static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
 	return segs;
 }
 
-static void xfrm4_transport_xmit(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct xfrm_offload *xo = xfrm_offload(skb);
-
-	skb_reset_mac_len(skb);
-	pskb_pull(skb, skb->mac_len + sizeof(struct iphdr) + x->props.header_len);
-
-	if (xo->flags & XFRM_GSO_SEGMENT) {
-		 skb_reset_transport_header(skb);
-		 skb->transport_header -= x->props.header_len;
-	}
-}
-
 static struct xfrm_mode xfrm4_transport_mode = {
 	.gso_segment = xfrm4_transport_gso_segment,
-	.xmit = xfrm4_transport_xmit,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TRANSPORT,
 	.family = AF_INET,
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index 823bc54b47de..8bd5112b3ee3 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -109,23 +109,10 @@ static struct sk_buff *xfrm4_mode_tunnel_gso_segment(struct xfrm_state *x,
 	return skb_mac_gso_segment(skb, features);
 }
 
-static void xfrm4_mode_tunnel_xmit(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct xfrm_offload *xo = xfrm_offload(skb);
-
-	if (xo->flags & XFRM_GSO_SEGMENT)
-		skb->transport_header = skb->network_header +
-					sizeof(struct iphdr);
-
-	skb_reset_mac_len(skb);
-	pskb_pull(skb, skb->mac_len + x->props.header_len);
-}
-
 static struct xfrm_mode xfrm4_tunnel_mode = {
 	.input2 = xfrm4_mode_tunnel_input,
 	.output2 = xfrm4_mode_tunnel_output,
 	.gso_segment = xfrm4_mode_tunnel_gso_segment,
-	.xmit = xfrm4_mode_tunnel_xmit,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TUNNEL,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
diff --git a/net/ipv6/xfrm6_mode_transport.c b/net/ipv6/xfrm6_mode_transport.c
index 1e7165a8481a..6a72ff39bc05 100644
--- a/net/ipv6/xfrm6_mode_transport.c
+++ b/net/ipv6/xfrm6_mode_transport.c
@@ -31,22 +31,8 @@ static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
 	return segs;
 }
 
-static void xfrm6_transport_xmit(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct xfrm_offload *xo = xfrm_offload(skb);
-
-	skb_reset_mac_len(skb);
-	pskb_pull(skb, skb->mac_len + sizeof(struct ipv6hdr) + x->props.header_len);
-
-	if (xo->flags & XFRM_GSO_SEGMENT) {
-		 skb_reset_transport_header(skb);
-		 skb->transport_header -= x->props.header_len;
-	}
-}
-
 static struct xfrm_mode xfrm6_transport_mode = {
 	.gso_segment = xfrm4_transport_gso_segment,
-	.xmit = xfrm6_transport_xmit,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TRANSPORT,
 	.family = AF_INET6,
diff --git a/net/ipv6/xfrm6_mode_tunnel.c b/net/ipv6/xfrm6_mode_tunnel.c
index e1a129524dde..7450dd87f27d 100644
--- a/net/ipv6/xfrm6_mode_tunnel.c
+++ b/net/ipv6/xfrm6_mode_tunnel.c
@@ -109,22 +109,10 @@ static struct sk_buff *xfrm6_mode_tunnel_gso_segment(struct xfrm_state *x,
 	return skb_mac_gso_segment(skb, features);
 }
 
-static void xfrm6_mode_tunnel_xmit(struct xfrm_state *x, struct sk_buff *skb)
-{
-	struct xfrm_offload *xo = xfrm_offload(skb);
-
-	if (xo->flags & XFRM_GSO_SEGMENT)
-		skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
-
-	skb_reset_mac_len(skb);
-	pskb_pull(skb, skb->mac_len + x->props.header_len);
-}
-
 static struct xfrm_mode xfrm6_tunnel_mode = {
 	.input2 = xfrm6_mode_tunnel_input,
 	.output2 = xfrm6_mode_tunnel_output,
 	.gso_segment = xfrm6_mode_tunnel_gso_segment,
-	.xmit = xfrm6_mode_tunnel_xmit,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TUNNEL,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index e437b60fba51..a20f376fe71f 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -23,6 +23,60 @@
 #include <linux/notifier.h>
 
 #ifdef CONFIG_XFRM_OFFLOAD
+static void __xfrm_transport_prep(struct xfrm_state *x, struct sk_buff *skb,
+				  unsigned int hsize)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+
+	skb_reset_mac_len(skb);
+	pskb_pull(skb, skb->mac_len + hsize + x->props.header_len);
+
+	if (xo->flags & XFRM_GSO_SEGMENT) {
+		skb_reset_transport_header(skb);
+		skb->transport_header -= x->props.header_len;
+	}
+}
+
+static void __xfrm_mode_tunnel_prep(struct xfrm_state *x, struct sk_buff *skb,
+				    unsigned int hsize)
+
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+
+	if (xo->flags & XFRM_GSO_SEGMENT)
+		skb->transport_header = skb->network_header + hsize;
+
+	skb_reset_mac_len(skb);
+	pskb_pull(skb, skb->mac_len + x->props.header_len);
+}
+
+/* Adjust pointers into the packet when IPsec is done at layer2 */
+static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
+{
+	switch (x->outer_mode->encap) {
+	case XFRM_MODE_TUNNEL:
+		if (x->outer_mode->family == AF_INET)
+			return __xfrm_mode_tunnel_prep(x, skb,
+						       sizeof(struct iphdr));
+		if (x->outer_mode->family == AF_INET6)
+			return __xfrm_mode_tunnel_prep(x, skb,
+						       sizeof(struct ipv6hdr));
+		break;
+	case XFRM_MODE_TRANSPORT:
+		if (x->outer_mode->family == AF_INET)
+			return __xfrm_transport_prep(x, skb,
+						     sizeof(struct iphdr));
+		if (x->outer_mode->family == AF_INET6)
+			return __xfrm_transport_prep(x, skb,
+						     sizeof(struct ipv6hdr));
+		break;
+	case XFRM_MODE_ROUTEOPTIMIZATION:
+	case XFRM_MODE_IN_TRIGGER:
+	case XFRM_MODE_BEET:
+		break;
+	}
+}
+
 struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again)
 {
 	int err;
@@ -79,7 +133,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 
 	if (!skb->next) {
 		esp_features |= skb->dev->gso_partial_features;
-		x->outer_mode->xmit(x, skb);
+		xfrm_outer_mode_prep(x, skb);
 
 		xo->flags |= XFRM_DEV_RESUME;
 
@@ -109,7 +163,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		xo = xfrm_offload(skb2);
 		xo->flags |= XFRM_DEV_RESUME;
 
-		x->outer_mode->xmit(x, skb2);
+		xfrm_outer_mode_prep(x, skb2);
 
 		err = x->type_offload->xmit(x, skb2, esp_features);
 		if (!err) {
-- 
2.17.1

