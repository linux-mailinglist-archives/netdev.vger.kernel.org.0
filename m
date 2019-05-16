Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C37B20646
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfEPLtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbfEPLjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:39:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B52C20848;
        Thu, 16 May 2019 11:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006779;
        bh=3o7ZG68lcEI6A9g1XplUAMFIlx0aRHpJVx0LSfzZZUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XD1bYvQE80mHaYwa1Zz0uHG78OSEWbrtvvSf/3AJaJo+Pq5bPrEomNmP0b+8a8XfQ
         lmPyy+DtOR3m8LUmKIqMl6Ex87Pbu7+X8vw+wuEuExFyFJ9ZC94LM2wDsVGjXdSDUc
         fJcm1gKHefesjQYvyDysoIfe0s4tcuYVK+1+Bw7k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+0bf0519d6e0de15914fe@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 05/34] xfrm: clean up xfrm protocol checks
Date:   Thu, 16 May 2019 07:39:02 -0400
Message-Id: <20190516113932.8348-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit dbb2483b2a46fbaf833cfb5deb5ed9cace9c7399 ]

In commit 6a53b7593233 ("xfrm: check id proto in validate_tmpl()")
I introduced a check for xfrm protocol, but according to Herbert
IPSEC_PROTO_ANY should only be used as a wildcard for lookup, so
it should be removed from validate_tmpl().

And, IPSEC_PROTO_ANY is expected to only match 3 IPSec-specific
protocols, this is why xfrm_state_flush() could still miss
IPPROTO_ROUTING, which leads that those entries are left in
net->xfrm.state_all before exit net. Fix this by replacing
IPSEC_PROTO_ANY with zero.

This patch also extracts the check from validate_tmpl() to
xfrm_id_proto_valid() and uses it in parse_ipsecrequest().
With this, no other protocols should be added into xfrm.

Fixes: 6a53b7593233 ("xfrm: check id proto in validate_tmpl()")
Reported-by: syzbot+0bf0519d6e0de15914fe@syzkaller.appspotmail.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h      | 17 +++++++++++++++++
 net/ipv6/xfrm6_tunnel.c |  2 +-
 net/key/af_key.c        |  4 +++-
 net/xfrm/xfrm_state.c   |  2 +-
 net/xfrm/xfrm_user.c    | 14 +-------------
 5 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 85386becbaea2..902437dfbce77 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1404,6 +1404,23 @@ static inline int xfrm_state_kern(const struct xfrm_state *x)
 	return atomic_read(&x->tunnel_users);
 }
 
+static inline bool xfrm_id_proto_valid(u8 proto)
+{
+	switch (proto) {
+	case IPPROTO_AH:
+	case IPPROTO_ESP:
+	case IPPROTO_COMP:
+#if IS_ENABLED(CONFIG_IPV6)
+	case IPPROTO_ROUTING:
+	case IPPROTO_DSTOPTS:
+#endif
+		return true;
+	default:
+		return false;
+	}
+}
+
+/* IPSEC_PROTO_ANY only matches 3 IPsec protocols, 0 could match all. */
 static inline int xfrm_id_proto_match(u8 proto, u8 userproto)
 {
 	return (!userproto || proto == userproto ||
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 12cb3aa990af4..d9e5f6808811a 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -345,7 +345,7 @@ static void __net_exit xfrm6_tunnel_net_exit(struct net *net)
 	unsigned int i;
 
 	xfrm_flush_gc();
-	xfrm_state_flush(net, IPSEC_PROTO_ANY, false, true);
+	xfrm_state_flush(net, 0, false, true);
 
 	for (i = 0; i < XFRM6_TUNNEL_SPI_BYADDR_HSIZE; i++)
 		WARN_ON_ONCE(!hlist_empty(&xfrm6_tn->spi_byaddr[i]));
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 5651c29cb5bd0..4af1e1d60b9f2 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1951,8 +1951,10 @@ parse_ipsecrequest(struct xfrm_policy *xp, struct sadb_x_ipsecrequest *rq)
 
 	if (rq->sadb_x_ipsecrequest_mode == 0)
 		return -EINVAL;
+	if (!xfrm_id_proto_valid(rq->sadb_x_ipsecrequest_proto))
+		return -EINVAL;
 
-	t->id.proto = rq->sadb_x_ipsecrequest_proto; /* XXX check proto */
+	t->id.proto = rq->sadb_x_ipsecrequest_proto;
 	if ((mode = pfkey_mode_to_xfrm(rq->sadb_x_ipsecrequest_mode)) < 0)
 		return -EINVAL;
 	t->mode = mode;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 1bb971f46fc6f..178baaa037e5b 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2384,7 +2384,7 @@ void xfrm_state_fini(struct net *net)
 
 	flush_work(&net->xfrm.state_hash_work);
 	flush_work(&xfrm_state_gc_work);
-	xfrm_state_flush(net, IPSEC_PROTO_ANY, false, true);
+	xfrm_state_flush(net, 0, false, true);
 
 	WARN_ON(!list_empty(&net->xfrm.state_all));
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 8d4d52fd457b2..6916931b1de1c 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1513,20 +1513,8 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family)
 			return -EINVAL;
 		}
 
-		switch (ut[i].id.proto) {
-		case IPPROTO_AH:
-		case IPPROTO_ESP:
-		case IPPROTO_COMP:
-#if IS_ENABLED(CONFIG_IPV6)
-		case IPPROTO_ROUTING:
-		case IPPROTO_DSTOPTS:
-#endif
-		case IPSEC_PROTO_ANY:
-			break;
-		default:
+		if (!xfrm_id_proto_valid(ut[i].id.proto))
 			return -EINVAL;
-		}
-
 	}
 
 	return 0;
-- 
2.20.1

