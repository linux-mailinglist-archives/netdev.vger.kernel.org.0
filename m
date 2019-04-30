Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4EF1F08B
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfD3Ghq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:37:46 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48894 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfD3Ghl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5F3442027B;
        Tue, 30 Apr 2019 08:37:39 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id X6_VlxbZjEO0; Tue, 30 Apr 2019 08:37:38 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A363F20283;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:32 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 485893180676;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 16/18] xfrm: remove init_path indirection from afinfo_policy
Date:   Tue, 30 Apr 2019 08:37:25 +0200
Message-ID: <20190430063727.10908-17-steffen.klassert@secunet.com>
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
X-G-Data-MailSecurity-for-Exchange-Guid: 1B4C0813-E5A0-484F-ADC6-BE2660864CD3
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

handle this directly, its only used by ipv6.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h      |  3 ---
 net/ipv4/xfrm4_policy.c |  7 -------
 net/ipv6/xfrm6_policy.c | 14 --------------
 net/xfrm/xfrm_policy.c  | 21 +++++++--------------
 4 files changed, 7 insertions(+), 38 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 652da5861772..b8de1622141a 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -329,9 +329,6 @@ struct xfrm_policy_afinfo {
 	void			(*decode_session)(struct sk_buff *skb,
 						  struct flowi *fl,
 						  int reverse);
-	int			(*init_path)(struct xfrm_dst *path,
-					     struct dst_entry *dst,
-					     int nfheader_len);
 	int			(*fill_dst)(struct xfrm_dst *xdst,
 					    struct net_device *dev,
 					    const struct flowi *fl);
diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index 244d26baa3af..6e89378668ae 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -69,12 +69,6 @@ static int xfrm4_get_saddr(struct net *net, int oif,
 	return 0;
 }
 
-static int xfrm4_init_path(struct xfrm_dst *path, struct dst_entry *dst,
-			   int nfheader_len)
-{
-	return 0;
-}
-
 static int xfrm4_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 			  const struct flowi *fl)
 {
@@ -267,7 +261,6 @@ static const struct xfrm_policy_afinfo xfrm4_policy_afinfo = {
 	.dst_lookup =		xfrm4_dst_lookup,
 	.get_saddr =		xfrm4_get_saddr,
 	.decode_session =	_decode_session4,
-	.init_path =		xfrm4_init_path,
 	.fill_dst =		xfrm4_fill_dst,
 	.blackhole_route =	ipv4_blackhole_route,
 };
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 0e92fa2f9678..358e834fedce 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -71,19 +71,6 @@ static int xfrm6_get_saddr(struct net *net, int oif,
 	return 0;
 }
 
-static int xfrm6_init_path(struct xfrm_dst *path, struct dst_entry *dst,
-			   int nfheader_len)
-{
-	if (dst->ops->family == AF_INET6) {
-		struct rt6_info *rt = (struct rt6_info *)dst;
-		path->path_cookie = rt6_get_cookie(rt);
-	}
-
-	path->u.rt6.rt6i_nfheader_len = nfheader_len;
-
-	return 0;
-}
-
 static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 			  const struct flowi *fl)
 {
@@ -287,7 +274,6 @@ static const struct xfrm_policy_afinfo xfrm6_policy_afinfo = {
 	.dst_lookup =		xfrm6_dst_lookup,
 	.get_saddr =		xfrm6_get_saddr,
 	.decode_session =	_decode_session6,
-	.init_path =		xfrm6_init_path,
 	.fill_dst =		xfrm6_fill_dst,
 	.blackhole_route =	ip6_blackhole_route,
 };
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 1d1335eab76c..5359c312f016 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2491,21 +2491,14 @@ static inline struct xfrm_dst *xfrm_alloc_dst(struct net *net, int family)
 	return xdst;
 }
 
-static inline int xfrm_init_path(struct xfrm_dst *path, struct dst_entry *dst,
-				 int nfheader_len)
+static void xfrm_init_path(struct xfrm_dst *path, struct dst_entry *dst,
+			   int nfheader_len)
 {
-	const struct xfrm_policy_afinfo *afinfo =
-		xfrm_policy_get_afinfo(dst->ops->family);
-	int err;
-
-	if (!afinfo)
-		return -EINVAL;
-
-	err = afinfo->init_path(path, dst, nfheader_len);
-
-	rcu_read_unlock();
-
-	return err;
+	if (dst->ops->family == AF_INET6) {
+		struct rt6_info *rt = (struct rt6_info *)dst;
+		path->path_cookie = rt6_get_cookie(rt);
+		path->u.rt6.rt6i_nfheader_len = nfheader_len;
+	}
 }
 
 static inline int xfrm_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
-- 
2.17.1

