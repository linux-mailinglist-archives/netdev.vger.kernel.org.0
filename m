Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314E4EFF9
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 07:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfD3FbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 01:31:02 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46876 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfD3Faw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 01:30:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6989920276;
        Tue, 30 Apr 2019 07:30:51 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iRrx-c70im_k; Tue, 30 Apr 2019 07:30:50 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 22E252027B;
        Tue, 30 Apr 2019 07:30:48 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 07:30:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 0CEA53180608;
 Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 08/12] xfrm: clean up xfrm protocol checks
Date:   Tue, 30 Apr 2019 07:30:26 +0200
Message-ID: <20190430053030.27009-9-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430053030.27009-1-steffen.klassert@secunet.com>
References: <20190430053030.27009-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 01BB88E7-BBB5-4A39-9BFA-872E463B2341
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

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
---
 include/net/xfrm.h      | 17 +++++++++++++++++
 net/ipv6/xfrm6_tunnel.c |  2 +-
 net/key/af_key.c        |  4 +++-
 net/xfrm/xfrm_state.c   |  2 +-
 net/xfrm/xfrm_user.c    | 14 +-------------
 5 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 85386becbaea..902437dfbce7 100644
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
index 12cb3aa990af..d9e5f6808811 100644
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
index 5651c29cb5bd..4af1e1d60b9f 100644
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
index 1bb971f46fc6..178baaa037e5 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2384,7 +2384,7 @@ void xfrm_state_fini(struct net *net)
 
 	flush_work(&net->xfrm.state_hash_work);
 	flush_work(&xfrm_state_gc_work);
-	xfrm_state_flush(net, IPSEC_PROTO_ANY, false, true);
+	xfrm_state_flush(net, 0, false, true);
 
 	WARN_ON(!list_empty(&net->xfrm.state_all));
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 8d4d52fd457b..6916931b1de1 100644
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
2.17.1

