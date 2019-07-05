Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB9C66028A
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbfGEIqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:46:16 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37438 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfGEIqQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 04:46:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F242420253;
        Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id h839JWUghMe5; Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 831F4200AC;
        Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 5 Jul 2019
 10:46:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 4ABAF3180793;
 Fri,  5 Jul 2019 10:46:14 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/9] xfrm: remove init_flags indirection from xfrm_state_afinfo
Date:   Fri, 5 Jul 2019 10:46:04 +0200
Message-ID: <20190705084610.3646-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190705084610.3646-1-steffen.klassert@secunet.com>
References: <20190705084610.3646-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

There is only one implementation of this function; just call it directly.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  1 -
 net/ipv4/xfrm4_state.c |  8 --------
 net/xfrm/xfrm_state.c  | 17 +++--------------
 3 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index e8f676ce27be..61214f5c3205 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -353,7 +353,6 @@ struct xfrm_state_afinfo {
 	const struct xfrm_type		*type_map[IPPROTO_MAX];
 	const struct xfrm_type_offload	*type_offload_map[IPPROTO_MAX];
 
-	int			(*init_flags)(struct xfrm_state *x);
 	int			(*tmpl_sort)(struct xfrm_tmpl **dst, struct xfrm_tmpl **src, int n);
 	int			(*state_sort)(struct xfrm_state **dst, struct xfrm_state **src, int n);
 	int			(*output)(struct net *net, struct sock *sk, struct sk_buff *skb);
diff --git a/net/ipv4/xfrm4_state.c b/net/ipv4/xfrm4_state.c
index 018448e222af..62c96da38b4e 100644
--- a/net/ipv4/xfrm4_state.c
+++ b/net/ipv4/xfrm4_state.c
@@ -15,13 +15,6 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/export.h>
 
-static int xfrm4_init_flags(struct xfrm_state *x)
-{
-	if (xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc)
-		x->props.flags |= XFRM_STATE_NOPMTUDISC;
-	return 0;
-}
-
 int xfrm4_extract_header(struct sk_buff *skb)
 {
 	const struct iphdr *iph = ip_hdr(skb);
@@ -43,7 +36,6 @@ static struct xfrm_state_afinfo xfrm4_state_afinfo = {
 	.proto			= IPPROTO_IPIP,
 	.eth_proto		= htons(ETH_P_IP),
 	.owner			= THIS_MODULE,
-	.init_flags		= xfrm4_init_flags,
 	.output			= xfrm4_output,
 	.output_finish		= xfrm4_output_finish,
 	.extract_input		= xfrm4_extract_input,
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 336d3f6a1a51..5c13a8021d4c 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2263,25 +2263,14 @@ int xfrm_state_mtu(struct xfrm_state *x, int mtu)
 
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 {
-	const struct xfrm_state_afinfo *afinfo;
 	const struct xfrm_mode *inner_mode;
 	const struct xfrm_mode *outer_mode;
 	int family = x->props.family;
 	int err;
 
-	err = -EAFNOSUPPORT;
-	afinfo = xfrm_state_get_afinfo(family);
-	if (!afinfo)
-		goto error;
-
-	err = 0;
-	if (afinfo->init_flags)
-		err = afinfo->init_flags(x);
-
-	rcu_read_unlock();
-
-	if (err)
-		goto error;
+	if (family == AF_INET &&
+	    xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc)
+		x->props.flags |= XFRM_STATE_NOPMTUDISC;
 
 	err = -EPROTONOSUPPORT;
 
-- 
2.17.1

