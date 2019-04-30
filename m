Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74A1CF08C
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfD3Ghq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:46 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48802 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfD3Ghk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:40 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D5B492026D;
        Tue, 30 Apr 2019 08:37:37 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id I2y6YEMDmQxM; Tue, 30 Apr 2019 08:37:37 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 41F912027D;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3D66D318063D;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 13/18] xfrm: store xfrm_mode directly, not its address
Date:   Tue, 30 Apr 2019 08:37:22 +0200
Message-ID: <20190430063727.10908-14-steffen.klassert@secunet.com>
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
X-G-Data-MailSecurity-for-Exchange-Guid: EBE5A83F-B3C0-49DD-8CC2-CD0B56895ECC
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This structure is now only 4 bytes, so its more efficient
to cache a copy rather than its address.

No significant size difference in allmodconfig vmlinux.

With non-modular kernel that has all XFRM options enabled, this
series reduces vmlinux image size by ~11kb. All xfrm_mode
indirections are gone and all modes are built-in.

before (ipsec-next master):
    text      data      bss         dec   filename
21071494   7233140 11104324    39408958   vmlinux.master

after this series:
21066448   7226772 11104324    39397544   vmlinux.patched

With allmodconfig kernel, the size increase is only 362 bytes,
even all the xfrm config options removed in this series are
modular.

before:
    text      data     bss      dec   filename
15731286   6936912 4046908 26715106   vmlinux.master

after this series:
15731492   6937068  4046908  26715468 vmlinux

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h        | 34 +++++++++++++++++-----------------
 net/ipv4/esp4_offload.c   |  2 +-
 net/ipv4/ip_vti.c         |  2 +-
 net/ipv4/xfrm4_output.c   |  2 +-
 net/ipv6/esp6_offload.c   |  2 +-
 net/ipv6/ip6_vti.c        |  2 +-
 net/ipv6/xfrm6_output.c   |  2 +-
 net/xfrm/xfrm_device.c    | 10 +++++-----
 net/xfrm/xfrm_input.c     | 14 +++++++-------
 net/xfrm/xfrm_interface.c |  2 +-
 net/xfrm/xfrm_output.c    | 20 ++++++++++----------
 net/xfrm/xfrm_policy.c    |  2 +-
 net/xfrm/xfrm_state.c     | 16 ++++++++--------
 13 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 4ca79cdc3460..77eb578a0384 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -132,6 +132,17 @@ struct xfrm_state_offload {
 	u8			flags;
 };
 
+struct xfrm_mode {
+	u8 encap;
+	u8 family;
+	u8 flags;
+};
+
+/* Flags for xfrm_mode. */
+enum {
+	XFRM_MODE_FLAG_TUNNEL = 1,
+};
+
 /* Full description of state of transformer. */
 struct xfrm_state {
 	possible_net_t		xs_net;
@@ -234,9 +245,9 @@ struct xfrm_state {
 	/* Reference to data common to all the instances of this
 	 * transformer. */
 	const struct xfrm_type	*type;
-	const struct xfrm_mode	*inner_mode;
-	const struct xfrm_mode	*inner_mode_iaf;
-	const struct xfrm_mode	*outer_mode;
+	struct xfrm_mode	inner_mode;
+	struct xfrm_mode	inner_mode_iaf;
+	struct xfrm_mode	outer_mode;
 
 	const struct xfrm_type_offload	*type_offload;
 
@@ -421,17 +432,6 @@ struct xfrm_type_offload {
 int xfrm_register_type_offload(const struct xfrm_type_offload *type, unsigned short family);
 int xfrm_unregister_type_offload(const struct xfrm_type_offload *type, unsigned short family);
 
-struct xfrm_mode {
-	u8 encap;
-	u8 family;
-	u8 flags;
-};
-
-/* Flags for xfrm_mode. */
-enum {
-	XFRM_MODE_FLAG_TUNNEL = 1,
-};
-
 static inline int xfrm_af2proto(unsigned int family)
 {
 	switch(family) {
@@ -448,9 +448,9 @@ static inline const struct xfrm_mode *xfrm_ip2inner_mode(struct xfrm_state *x, i
 {
 	if ((ipproto == IPPROTO_IPIP && x->props.family == AF_INET) ||
 	    (ipproto == IPPROTO_IPV6 && x->props.family == AF_INET6))
-		return x->inner_mode;
+		return &x->inner_mode;
 	else
-		return x->inner_mode_iaf;
+		return &x->inner_mode_iaf;
 }
 
 struct xfrm_tmpl {
@@ -1990,7 +1990,7 @@ static inline int xfrm_tunnel_check(struct sk_buff *skb, struct xfrm_state *x,
 			tunnel = true;
 		break;
 	}
-	if (tunnel && !(x->outer_mode->flags & XFRM_MODE_FLAG_TUNNEL))
+	if (tunnel && !(x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL))
 		return -EINVAL;
 
 	return 0;
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 74d59e0177a7..b61a8ff558f9 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -135,7 +135,7 @@ static struct sk_buff *xfrm4_outer_mode_gso_segment(struct xfrm_state *x,
 						    struct sk_buff *skb,
 						    netdev_features_t features)
 {
-	switch (x->outer_mode->encap) {
+	switch (x->outer_mode.encap) {
 	case XFRM_MODE_TUNNEL:
 		return xfrm4_tunnel_gso_segment(x, skb, features);
 	case XFRM_MODE_TRANSPORT:
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 91926c9a3bc9..cc5d9c0a8a10 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -126,7 +126,7 @@ static int vti_rcv_cb(struct sk_buff *skb, int err)
 
 	x = xfrm_input_state(skb);
 
-	inner_mode = x->inner_mode;
+	inner_mode = &x->inner_mode;
 
 	if (x->sel.family == AF_UNSPEC) {
 		inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
diff --git a/net/ipv4/xfrm4_output.c b/net/ipv4/xfrm4_output.c
index 7c3df14daef3..9bb8905088c7 100644
--- a/net/ipv4/xfrm4_output.c
+++ b/net/ipv4/xfrm4_output.c
@@ -83,7 +83,7 @@ static int __xfrm4_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 #endif
 
 	rcu_read_lock();
-	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode->family);
+	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode.family);
 	if (likely(afinfo))
 		ret = afinfo->output_finish(sk, skb);
 	else
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index c793a2ace77d..bff83279d76f 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -162,7 +162,7 @@ static struct sk_buff *xfrm6_outer_mode_gso_segment(struct xfrm_state *x,
 						    struct sk_buff *skb,
 						    netdev_features_t features)
 {
-	switch (x->outer_mode->encap) {
+	switch (x->outer_mode.encap) {
 	case XFRM_MODE_TUNNEL:
 		return xfrm6_tunnel_gso_segment(x, skb, features);
 	case XFRM_MODE_TRANSPORT:
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 71ec5e60cf8f..218a0dedc8f4 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -361,7 +361,7 @@ static int vti6_rcv_cb(struct sk_buff *skb, int err)
 
 	x = xfrm_input_state(skb);
 
-	inner_mode = x->inner_mode;
+	inner_mode = &x->inner_mode;
 
 	if (x->sel.family == AF_UNSPEC) {
 		inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
diff --git a/net/ipv6/xfrm6_output.c b/net/ipv6/xfrm6_output.c
index 455fbf3b91cf..8ad5e54eb8ca 100644
--- a/net/ipv6/xfrm6_output.c
+++ b/net/ipv6/xfrm6_output.c
@@ -129,7 +129,7 @@ static int __xfrm6_output_state_finish(struct xfrm_state *x, struct sock *sk,
 	int ret = -EAFNOSUPPORT;
 
 	rcu_read_lock();
-	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode->family);
+	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode.family);
 	if (likely(afinfo))
 		ret = afinfo->output_finish(sk, skb);
 	else
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index a20f376fe71f..b24cd86a02c3 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -53,20 +53,20 @@ static void __xfrm_mode_tunnel_prep(struct xfrm_state *x, struct sk_buff *skb,
 /* Adjust pointers into the packet when IPsec is done at layer2 */
 static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
 {
-	switch (x->outer_mode->encap) {
+	switch (x->outer_mode.encap) {
 	case XFRM_MODE_TUNNEL:
-		if (x->outer_mode->family == AF_INET)
+		if (x->outer_mode.family == AF_INET)
 			return __xfrm_mode_tunnel_prep(x, skb,
 						       sizeof(struct iphdr));
-		if (x->outer_mode->family == AF_INET6)
+		if (x->outer_mode.family == AF_INET6)
 			return __xfrm_mode_tunnel_prep(x, skb,
 						       sizeof(struct ipv6hdr));
 		break;
 	case XFRM_MODE_TRANSPORT:
-		if (x->outer_mode->family == AF_INET)
+		if (x->outer_mode.family == AF_INET)
 			return __xfrm_transport_prep(x, skb,
 						     sizeof(struct iphdr));
-		if (x->outer_mode->family == AF_INET6)
+		if (x->outer_mode.family == AF_INET6)
 			return __xfrm_transport_prep(x, skb,
 						     sizeof(struct ipv6hdr));
 		break;
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index b5a31c8e2088..314973aaa414 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -351,12 +351,12 @@ xfrm_inner_mode_encap_remove(struct xfrm_state *x,
 
 static int xfrm_prepare_input(struct xfrm_state *x, struct sk_buff *skb)
 {
-	const struct xfrm_mode *inner_mode = x->inner_mode;
+	const struct xfrm_mode *inner_mode = &x->inner_mode;
 	const struct xfrm_state_afinfo *afinfo;
 	int err = -EAFNOSUPPORT;
 
 	rcu_read_lock();
-	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode->family);
+	afinfo = xfrm_state_afinfo_get_rcu(x->outer_mode.family);
 	if (likely(afinfo))
 		err = afinfo->extract_input(x, skb);
 
@@ -482,7 +482,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			goto drop;
 		}
 
-		family = x->outer_mode->family;
+		family = x->outer_mode.family;
 
 		/* An encap_type of -1 indicates async resumption. */
 		if (encap_type == -1) {
@@ -666,7 +666,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 		XFRM_MODE_SKB_CB(skb)->protocol = nexthdr;
 
-		inner_mode = x->inner_mode;
+		inner_mode = &x->inner_mode;
 
 		if (x->sel.family == AF_UNSPEC) {
 			inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
@@ -681,7 +681,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			goto drop;
 		}
 
-		if (x->outer_mode->flags & XFRM_MODE_FLAG_TUNNEL) {
+		if (x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL) {
 			decaps = 1;
 			break;
 		}
@@ -691,7 +691,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		 * transport mode so the outer address is identical.
 		 */
 		daddr = &x->id.daddr;
-		family = x->outer_mode->family;
+		family = x->outer_mode.family;
 
 		err = xfrm_parse_spi(skb, nexthdr, &spi, &seq);
 		if (err < 0) {
@@ -721,7 +721,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 		err = -EAFNOSUPPORT;
 		rcu_read_lock();
-		afinfo = xfrm_state_afinfo_get_rcu(x->inner_mode->family);
+		afinfo = xfrm_state_afinfo_get_rcu(x->inner_mode.family);
 		if (likely(afinfo))
 			err = afinfo->transport_finish(skb, xfrm_gro || async);
 		rcu_read_unlock();
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 4fc49dbf3edf..b9f118530db6 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -273,7 +273,7 @@ static int xfrmi_rcv_cb(struct sk_buff *skb, int err)
 	xnet = !net_eq(xi->net, dev_net(skb->dev));
 
 	if (xnet) {
-		inner_mode = x->inner_mode;
+		inner_mode = &x->inner_mode;
 
 		if (x->sel.family == AF_UNSPEC) {
 			inner_mode = xfrm_ip2inner_mode(x, XFRM_MODE_SKB_CB(skb)->protocol);
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 3cb2a328a8ab..a55510f9ff35 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -334,7 +334,7 @@ static int xfrm4_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
 	IPCB(skb)->flags |= IPSKB_XFRM_TUNNEL_SIZE;
 	skb->protocol = htons(ETH_P_IP);
 
-	switch (x->outer_mode->encap) {
+	switch (x->outer_mode.encap) {
 	case XFRM_MODE_BEET:
 		return xfrm4_beet_encap_add(x, skb);
 	case XFRM_MODE_TUNNEL:
@@ -357,7 +357,7 @@ static int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
 	skb->ignore_df = 1;
 	skb->protocol = htons(ETH_P_IPV6);
 
-	switch (x->outer_mode->encap) {
+	switch (x->outer_mode.encap) {
 	case XFRM_MODE_BEET:
 		return xfrm6_beet_encap_add(x, skb);
 	case XFRM_MODE_TUNNEL:
@@ -373,22 +373,22 @@ static int xfrm6_prepare_output(struct xfrm_state *x, struct sk_buff *skb)
 
 static int xfrm_outer_mode_output(struct xfrm_state *x, struct sk_buff *skb)
 {
-	switch (x->outer_mode->encap) {
+	switch (x->outer_mode.encap) {
 	case XFRM_MODE_BEET:
 	case XFRM_MODE_TUNNEL:
-		if (x->outer_mode->family == AF_INET)
+		if (x->outer_mode.family == AF_INET)
 			return xfrm4_prepare_output(x, skb);
-		if (x->outer_mode->family == AF_INET6)
+		if (x->outer_mode.family == AF_INET6)
 			return xfrm6_prepare_output(x, skb);
 		break;
 	case XFRM_MODE_TRANSPORT:
-		if (x->outer_mode->family == AF_INET)
+		if (x->outer_mode.family == AF_INET)
 			return xfrm4_transport_output(x, skb);
-		if (x->outer_mode->family == AF_INET6)
+		if (x->outer_mode.family == AF_INET6)
 			return xfrm6_transport_output(x, skb);
 		break;
 	case XFRM_MODE_ROUTEOPTIMIZATION:
-		if (x->outer_mode->family == AF_INET6)
+		if (x->outer_mode.family == AF_INET6)
 			return xfrm6_ro_output(x, skb);
 		WARN_ON_ONCE(1);
 		break;
@@ -489,7 +489,7 @@ static int xfrm_output_one(struct sk_buff *skb, int err)
 		}
 		skb_dst_set(skb, dst);
 		x = dst->xfrm;
-	} while (x && !(x->outer_mode->flags & XFRM_MODE_FLAG_TUNNEL));
+	} while (x && !(x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL));
 
 	return 0;
 
@@ -626,7 +626,7 @@ static int xfrm_inner_extract_output(struct xfrm_state *x, struct sk_buff *skb)
 		inner_mode = xfrm_ip2inner_mode(x,
 				xfrm_af2proto(skb_dst(skb)->ops->family));
 	else
-		inner_mode = x->inner_mode;
+		inner_mode = &x->inner_mode;
 
 	if (inner_mode == NULL)
 		return -EAFNOSUPPORT;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 1a5fd2296556..16e70fc547b1 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2595,7 +2595,7 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 				goto put_states;
 			}
 		} else
-			inner_mode = xfrm[i]->inner_mode;
+			inner_mode = &xfrm[i]->inner_mode;
 
 		xdst->route = dst;
 		dst_copy_metrics(dst1, dst);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index ace26f6dc790..d3d87c409f44 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -551,8 +551,6 @@ struct xfrm_state *xfrm_state_alloc(struct net *net)
 		x->lft.hard_packet_limit = XFRM_INF;
 		x->replay_maxage = 0;
 		x->replay_maxdiff = 0;
-		x->inner_mode = NULL;
-		x->inner_mode_iaf = NULL;
 		spin_lock_init(&x->lock);
 	}
 	return x;
@@ -2204,8 +2202,9 @@ int xfrm_state_mtu(struct xfrm_state *x, int mtu)
 
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 {
-	const struct xfrm_mode *inner_mode;
 	const struct xfrm_state_afinfo *afinfo;
+	const struct xfrm_mode *inner_mode;
+	const struct xfrm_mode *outer_mode;
 	int family = x->props.family;
 	int err;
 
@@ -2234,7 +2233,7 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 		    family != x->sel.family)
 			goto error;
 
-		x->inner_mode = inner_mode;
+		x->inner_mode = *inner_mode;
 	} else {
 		const struct xfrm_mode *inner_mode_iaf;
 		int iafamily = AF_INET;
@@ -2246,7 +2245,7 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL))
 			goto error;
 
-		x->inner_mode = inner_mode;
+		x->inner_mode = *inner_mode;
 
 		if (x->props.family == AF_INET)
 			iafamily = AF_INET6;
@@ -2254,7 +2253,7 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 		inner_mode_iaf = xfrm_get_mode(x->props.mode, iafamily);
 		if (inner_mode_iaf) {
 			if (inner_mode_iaf->flags & XFRM_MODE_FLAG_TUNNEL)
-				x->inner_mode_iaf = inner_mode_iaf;
+				x->inner_mode_iaf = *inner_mode_iaf;
 		}
 	}
 
@@ -2268,12 +2267,13 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 	if (err)
 		goto error;
 
-	x->outer_mode = xfrm_get_mode(x->props.mode, family);
-	if (x->outer_mode == NULL) {
+	outer_mode = xfrm_get_mode(x->props.mode, family);
+	if (!outer_mode) {
 		err = -EPROTONOSUPPORT;
 		goto error;
 	}
 
+	x->outer_mode = *outer_mode;
 	if (init_replay) {
 		err = xfrm_init_replay(x);
 		if (err)
-- 
2.17.1

