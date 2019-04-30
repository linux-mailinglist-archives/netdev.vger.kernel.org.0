Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF14F097
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfD3GiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:38:09 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48802 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbfD3Ghh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 133BA2026B;
        Tue, 30 Apr 2019 08:37:34 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id slwuvYxppxHo; Tue, 30 Apr 2019 08:37:33 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 07A772026F;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 25A563180608;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 08/18] xfrm: remove gso_segment indirection from xfrm_mode
Date:   Tue, 30 Apr 2019 08:37:17 +0200
Message-ID: <20190430063727.10908-9-steffen.klassert@secunet.com>
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
X-G-Data-MailSecurity-for-Exchange-Guid: E89FAB86-4555-4C43-8EA0-53499204C024
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

These functions are small and we only have versions for tunnel
and transport mode for ipv4 and ipv6 respectively.

Just place the 'transport or tunnel' conditional in the protocol
specific function instead of using an indirection.

Before:
    3226       12       0     3238   net/ipv4/esp4_offload.o
    7004      492       0     7496   net/ipv4/ip_vti.o
    3339       12       0     3351   net/ipv6/esp6_offload.o
   11294      460       0    11754   net/ipv6/ip6_vti.o
    1180       72       0     1252   net/ipv4/xfrm4_mode_beet.o
     428       48       0      476   net/ipv4/xfrm4_mode_transport.o
    1271       48       0     1319   net/ipv4/xfrm4_mode_tunnel.o
    1083       60       0     1143   net/ipv6/xfrm6_mode_beet.o
     172       48       0      220   net/ipv6/xfrm6_mode_ro.o
     429       48       0      477   net/ipv6/xfrm6_mode_transport.o
    1164       48       0     1212   net/ipv6/xfrm6_mode_tunnel.o
15730428  6937008 4046908 26714344   vmlinux

After:
    3461       12       0     3473   net/ipv4/esp4_offload.o
    7000      492       0     7492   net/ipv4/ip_vti.o
    3574       12       0     3586   net/ipv6/esp6_offload.o
   11295      460       0    11755   net/ipv6/ip6_vti.o
    1180       64       0     1244   net/ipv4/xfrm4_mode_beet.o
     171       40       0      211   net/ipv4/xfrm4_mode_transport.o
    1163       40       0     1203   net/ipv4/xfrm4_mode_tunnel.o
    1083       52       0     1135   net/ipv6/xfrm6_mode_beet.o
     172       40       0      212   net/ipv6/xfrm6_mode_ro.o
     172       40       0      212   net/ipv6/xfrm6_mode_transport.o
    1056       40       0     1096   net/ipv6/xfrm6_mode_tunnel.o
15730424  6937008 4046908 26714340   vmlinux

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h              |  5 -----
 net/ipv4/esp4_offload.c         | 40 ++++++++++++++++++++++++++++++++-
 net/ipv4/xfrm4_mode_transport.c | 17 --------------
 net/ipv4/xfrm4_mode_tunnel.c    |  9 --------
 net/ipv6/esp6_offload.c         | 40 ++++++++++++++++++++++++++++++++-
 net/ipv6/xfrm6_mode_transport.c | 17 --------------
 net/ipv6/xfrm6_mode_tunnel.c    |  8 -------
 7 files changed, 78 insertions(+), 58 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 07966a27e4a4..de103a6d1ef8 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -449,11 +449,6 @@ struct xfrm_mode {
 	 */
 	int (*output2)(struct xfrm_state *x,struct sk_buff *skb);
 
-	/*
-	 * Adjust pointers into the packet and do GSO segmentation.
-	 */
-	struct sk_buff *(*gso_segment)(struct xfrm_state *x, struct sk_buff *skb, netdev_features_t features);
-
 	struct xfrm_state_afinfo *afinfo;
 	struct module *owner;
 	u8 encap;
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index c6c84f2bc41c..74d59e0177a7 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -107,6 +107,44 @@ static void esp4_gso_encap(struct xfrm_state *x, struct sk_buff *skb)
 	xo->proto = proto;
 }
 
+static struct sk_buff *xfrm4_tunnel_gso_segment(struct xfrm_state *x,
+						struct sk_buff *skb,
+						netdev_features_t features)
+{
+	__skb_push(skb, skb->mac_len);
+	return skb_mac_gso_segment(skb, features);
+}
+
+static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
+						   struct sk_buff *skb,
+						   netdev_features_t features)
+{
+	const struct net_offload *ops;
+	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	struct xfrm_offload *xo = xfrm_offload(skb);
+
+	skb->transport_header += x->props.header_len;
+	ops = rcu_dereference(inet_offloads[xo->proto]);
+	if (likely(ops && ops->callbacks.gso_segment))
+		segs = ops->callbacks.gso_segment(skb, features);
+
+	return segs;
+}
+
+static struct sk_buff *xfrm4_outer_mode_gso_segment(struct xfrm_state *x,
+						    struct sk_buff *skb,
+						    netdev_features_t features)
+{
+	switch (x->outer_mode->encap) {
+	case XFRM_MODE_TUNNEL:
+		return xfrm4_tunnel_gso_segment(x, skb, features);
+	case XFRM_MODE_TRANSPORT:
+		return xfrm4_transport_gso_segment(x, skb, features);
+	}
+
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 				        netdev_features_t features)
 {
@@ -147,7 +185,7 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
-	return x->outer_mode->gso_segment(x, skb, esp_features);
+	return xfrm4_outer_mode_gso_segment(x, skb, esp_features);
 }
 
 static int esp_input_tail(struct xfrm_state *x, struct sk_buff *skb)
diff --git a/net/ipv4/xfrm4_mode_transport.c b/net/ipv4/xfrm4_mode_transport.c
index d4b34bb2de00..397863ea762b 100644
--- a/net/ipv4/xfrm4_mode_transport.c
+++ b/net/ipv4/xfrm4_mode_transport.c
@@ -14,24 +14,7 @@
 #include <net/xfrm.h>
 #include <net/protocol.h>
 
-static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
-						   struct sk_buff *skb,
-						   netdev_features_t features)
-{
-	const struct net_offload *ops;
-	struct sk_buff *segs = ERR_PTR(-EINVAL);
-	struct xfrm_offload *xo = xfrm_offload(skb);
-
-	skb->transport_header += x->props.header_len;
-	ops = rcu_dereference(inet_offloads[xo->proto]);
-	if (likely(ops && ops->callbacks.gso_segment))
-		segs = ops->callbacks.gso_segment(skb, features);
-
-	return segs;
-}
-
 static struct xfrm_mode xfrm4_transport_mode = {
-	.gso_segment = xfrm4_transport_gso_segment,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TRANSPORT,
 	.family = AF_INET,
diff --git a/net/ipv4/xfrm4_mode_tunnel.c b/net/ipv4/xfrm4_mode_tunnel.c
index 8bd5112b3ee3..b5d4ba41758e 100644
--- a/net/ipv4/xfrm4_mode_tunnel.c
+++ b/net/ipv4/xfrm4_mode_tunnel.c
@@ -101,18 +101,9 @@ static int xfrm4_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
 	return err;
 }
 
-static struct sk_buff *xfrm4_mode_tunnel_gso_segment(struct xfrm_state *x,
-						     struct sk_buff *skb,
-						     netdev_features_t features)
-{
-	__skb_push(skb, skb->mac_len);
-	return skb_mac_gso_segment(skb, features);
-}
-
 static struct xfrm_mode xfrm4_tunnel_mode = {
 	.input2 = xfrm4_mode_tunnel_input,
 	.output2 = xfrm4_mode_tunnel_output,
-	.gso_segment = xfrm4_mode_tunnel_gso_segment,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TUNNEL,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index d46b4eb645c2..c793a2ace77d 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -134,6 +134,44 @@ static void esp6_gso_encap(struct xfrm_state *x, struct sk_buff *skb)
 	xo->proto = proto;
 }
 
+static struct sk_buff *xfrm6_tunnel_gso_segment(struct xfrm_state *x,
+						struct sk_buff *skb,
+						netdev_features_t features)
+{
+	__skb_push(skb, skb->mac_len);
+	return skb_mac_gso_segment(skb, features);
+}
+
+static struct sk_buff *xfrm6_transport_gso_segment(struct xfrm_state *x,
+						   struct sk_buff *skb,
+						   netdev_features_t features)
+{
+	const struct net_offload *ops;
+	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	struct xfrm_offload *xo = xfrm_offload(skb);
+
+	skb->transport_header += x->props.header_len;
+	ops = rcu_dereference(inet6_offloads[xo->proto]);
+	if (likely(ops && ops->callbacks.gso_segment))
+		segs = ops->callbacks.gso_segment(skb, features);
+
+	return segs;
+}
+
+static struct sk_buff *xfrm6_outer_mode_gso_segment(struct xfrm_state *x,
+						    struct sk_buff *skb,
+						    netdev_features_t features)
+{
+	switch (x->outer_mode->encap) {
+	case XFRM_MODE_TUNNEL:
+		return xfrm6_tunnel_gso_segment(x, skb, features);
+	case XFRM_MODE_TRANSPORT:
+		return xfrm6_transport_gso_segment(x, skb, features);
+	}
+
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 				        netdev_features_t features)
 {
@@ -172,7 +210,7 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
-	return x->outer_mode->gso_segment(x, skb, esp_features);
+	return xfrm6_outer_mode_gso_segment(x, skb, esp_features);
 }
 
 static int esp6_input_tail(struct xfrm_state *x, struct sk_buff *skb)
diff --git a/net/ipv6/xfrm6_mode_transport.c b/net/ipv6/xfrm6_mode_transport.c
index 6a72ff39bc05..d90c934c2f1a 100644
--- a/net/ipv6/xfrm6_mode_transport.c
+++ b/net/ipv6/xfrm6_mode_transport.c
@@ -15,24 +15,7 @@
 #include <net/xfrm.h>
 #include <net/protocol.h>
 
-static struct sk_buff *xfrm4_transport_gso_segment(struct xfrm_state *x,
-						   struct sk_buff *skb,
-						   netdev_features_t features)
-{
-	const struct net_offload *ops;
-	struct sk_buff *segs = ERR_PTR(-EINVAL);
-	struct xfrm_offload *xo = xfrm_offload(skb);
-
-	skb->transport_header += x->props.header_len;
-	ops = rcu_dereference(inet6_offloads[xo->proto]);
-	if (likely(ops && ops->callbacks.gso_segment))
-		segs = ops->callbacks.gso_segment(skb, features);
-
-	return segs;
-}
-
 static struct xfrm_mode xfrm6_transport_mode = {
-	.gso_segment = xfrm4_transport_gso_segment,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TRANSPORT,
 	.family = AF_INET6,
diff --git a/net/ipv6/xfrm6_mode_tunnel.c b/net/ipv6/xfrm6_mode_tunnel.c
index 7450dd87f27d..8e23a2fba617 100644
--- a/net/ipv6/xfrm6_mode_tunnel.c
+++ b/net/ipv6/xfrm6_mode_tunnel.c
@@ -101,18 +101,10 @@ static int xfrm6_mode_tunnel_input(struct xfrm_state *x, struct sk_buff *skb)
 	return err;
 }
 
-static struct sk_buff *xfrm6_mode_tunnel_gso_segment(struct xfrm_state *x,
-						     struct sk_buff *skb,
-						     netdev_features_t features)
-{
-	__skb_push(skb, skb->mac_len);
-	return skb_mac_gso_segment(skb, features);
-}
 
 static struct xfrm_mode xfrm6_tunnel_mode = {
 	.input2 = xfrm6_mode_tunnel_input,
 	.output2 = xfrm6_mode_tunnel_output,
-	.gso_segment = xfrm6_mode_tunnel_gso_segment,
 	.owner = THIS_MODULE,
 	.encap = XFRM_MODE_TUNNEL,
 	.flags = XFRM_MODE_FLAG_TUNNEL,
-- 
2.17.1

