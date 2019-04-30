Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC95F08D
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfD3Ghs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:48 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48814 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbfD3Ghj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5828F2027C;
        Tue, 30 Apr 2019 08:37:38 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gzUeIp6S7cyp; Tue, 30 Apr 2019 08:37:37 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 72E91201E6;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:32 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 4455C318066B;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 15/18] xfrm: remove tos indirection from afinfo_policy
Date:   Tue, 30 Apr 2019 08:37:24 +0200
Message-ID: <20190430063727.10908-16-steffen.klassert@secunet.com>
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
X-G-Data-MailSecurity-for-Exchange-Guid: 88C2FADE-CF82-421E-BD9A-39E925F4CD65
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Only used by ipv4, we can read the fl4 tos value directly instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h      |  1 -
 net/ipv4/xfrm4_policy.c |  6 ------
 net/ipv6/xfrm6_policy.c |  6 ------
 net/xfrm/xfrm_policy.c  | 14 +++-----------
 4 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 77eb578a0384..652da5861772 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -329,7 +329,6 @@ struct xfrm_policy_afinfo {
 	void			(*decode_session)(struct sk_buff *skb,
 						  struct flowi *fl,
 						  int reverse);
-	int			(*get_tos)(const struct flowi *fl);
 	int			(*init_path)(struct xfrm_dst *path,
 					     struct dst_entry *dst,
 					     int nfheader_len);
diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index d73a6d6652f6..244d26baa3af 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -69,11 +69,6 @@ static int xfrm4_get_saddr(struct net *net, int oif,
 	return 0;
 }
 
-static int xfrm4_get_tos(const struct flowi *fl)
-{
-	return IPTOS_RT_MASK & fl->u.ip4.flowi4_tos; /* Strip ECN bits */
-}
-
 static int xfrm4_init_path(struct xfrm_dst *path, struct dst_entry *dst,
 			   int nfheader_len)
 {
@@ -272,7 +267,6 @@ static const struct xfrm_policy_afinfo xfrm4_policy_afinfo = {
 	.dst_lookup =		xfrm4_dst_lookup,
 	.get_saddr =		xfrm4_get_saddr,
 	.decode_session =	_decode_session4,
-	.get_tos =		xfrm4_get_tos,
 	.init_path =		xfrm4_init_path,
 	.fill_dst =		xfrm4_fill_dst,
 	.blackhole_route =	ipv4_blackhole_route,
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 769f8f78d3b8..0e92fa2f9678 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -71,11 +71,6 @@ static int xfrm6_get_saddr(struct net *net, int oif,
 	return 0;
 }
 
-static int xfrm6_get_tos(const struct flowi *fl)
-{
-	return 0;
-}
-
 static int xfrm6_init_path(struct xfrm_dst *path, struct dst_entry *dst,
 			   int nfheader_len)
 {
@@ -292,7 +287,6 @@ static const struct xfrm_policy_afinfo xfrm6_policy_afinfo = {
 	.dst_lookup =		xfrm6_dst_lookup,
 	.get_saddr =		xfrm6_get_saddr,
 	.decode_session =	_decode_session6,
-	.get_tos =		xfrm6_get_tos,
 	.init_path =		xfrm6_init_path,
 	.fill_dst =		xfrm6_fill_dst,
 	.blackhole_route =	ip6_blackhole_route,
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 16e70fc547b1..1d1335eab76c 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2450,18 +2450,10 @@ xfrm_tmpl_resolve(struct xfrm_policy **pols, int npols, const struct flowi *fl,
 
 static int xfrm_get_tos(const struct flowi *fl, int family)
 {
-	const struct xfrm_policy_afinfo *afinfo;
-	int tos;
-
-	afinfo = xfrm_policy_get_afinfo(family);
-	if (!afinfo)
-		return 0;
-
-	tos = afinfo->get_tos(fl);
+	if (family == AF_INET)
+		return IPTOS_RT_MASK & fl->u.ip4.flowi4_tos;
 
-	rcu_read_unlock();
-
-	return tos;
+	return 0;
 }
 
 static inline struct xfrm_dst *xfrm_alloc_dst(struct net *net, int family)
-- 
2.17.1

