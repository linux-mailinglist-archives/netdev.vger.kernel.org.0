Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA122A6002
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgKDJAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:00:33 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:46572 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgKDJAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 04:00:32 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 15C4B20512;
        Wed,  4 Nov 2020 10:00:30 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TOHn9XNw7Zrv; Wed,  4 Nov 2020 10:00:25 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2C62620538;
        Wed,  4 Nov 2020 10:00:16 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 4 Nov 2020 10:00:15 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Wed, 4 Nov 2020
 10:00:15 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 18F1D3180AF9;
 Wed,  4 Nov 2020 10:00:15 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/2] net: xfrm: fix a race condition during allocing spi
Date:   Wed, 4 Nov 2020 10:00:10 +0100
Message-ID: <20201104090010.17558-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201104090010.17558-1-steffen.klassert@secunet.com>
References: <20201104090010.17558-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhuoliang zhang <zhuoliang.zhang@mediatek.com>

we found that the following race condition exists in
xfrm_alloc_userspi flow:

user thread                                    state_hash_work thread
----                                           ----
xfrm_alloc_userspi()
 __find_acq_core()
   /*alloc new xfrm_state:x*/
   xfrm_state_alloc()
   /*schedule state_hash_work thread*/
   xfrm_hash_grow_check()   	               xfrm_hash_resize()
 xfrm_alloc_spi                                  /*hold lock*/
      x->id.spi = htonl(spi)                     spin_lock_bh(&net->xfrm.xfrm_state_lock)
      /*waiting lock release*/                     xfrm_hash_transfer()
      spin_lock_bh(&net->xfrm.xfrm_state_lock)      /*add x into hlist:net->xfrm.state_byspi*/
	                                                hlist_add_head_rcu(&x->byspi)
                                                 spin_unlock_bh(&net->xfrm.xfrm_state_lock)

    /*add x into hlist:net->xfrm.state_byspi 2 times*/
    hlist_add_head_rcu(&x->byspi)

1. a new state x is alloced in xfrm_state_alloc() and added into the bydst hlist
in  __find_acq_core() on the LHS;
2. on the RHS, state_hash_work thread travels the old bydst and tranfers every xfrm_state
(include x) into the new bydst hlist and new byspi hlist;
3. user thread on the LHS gets the lock and adds x into the new byspi hlist again.

So the same xfrm_state (x) is added into the same list_hash
(net->xfrm.state_byspi) 2 times that makes the list_hash become
an inifite loop.

To fix the race, x->id.spi = htonl(spi) in the xfrm_alloc_spi() is moved
to the back of spin_lock_bh, sothat state_hash_work thread no longer add x
which id.spi is zero into the hash_list.

Fixes: f034b5d4efdf ("[XFRM]: Dynamic xfrm_state hash table sizing.")
Signed-off-by: zhuoliang zhang <zhuoliang.zhang@mediatek.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_state.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index efc89a92961d..ee6ac32bb06d 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2004,6 +2004,7 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 	int err = -ENOENT;
 	__be32 minspi = htonl(low);
 	__be32 maxspi = htonl(high);
+	__be32 newspi = 0;
 	u32 mark = x->mark.v & x->mark.m;
 
 	spin_lock_bh(&x->lock);
@@ -2022,21 +2023,22 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 			xfrm_state_put(x0);
 			goto unlock;
 		}
-		x->id.spi = minspi;
+		newspi = minspi;
 	} else {
 		u32 spi = 0;
 		for (h = 0; h < high-low+1; h++) {
 			spi = low + prandom_u32()%(high-low+1);
 			x0 = xfrm_state_lookup(net, mark, &x->id.daddr, htonl(spi), x->id.proto, x->props.family);
 			if (x0 == NULL) {
-				x->id.spi = htonl(spi);
+				newspi = htonl(spi);
 				break;
 			}
 			xfrm_state_put(x0);
 		}
 	}
-	if (x->id.spi) {
+	if (newspi) {
 		spin_lock_bh(&net->xfrm.xfrm_state_lock);
+		x->id.spi = newspi;
 		h = xfrm_spi_hash(net, &x->id.daddr, x->id.spi, x->id.proto, x->props.family);
 		hlist_add_head_rcu(&x->byspi, net->xfrm.state_byspi + h);
 		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
-- 
2.17.1

