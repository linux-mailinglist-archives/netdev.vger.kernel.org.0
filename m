Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D833DFBAC
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbhHDHDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:03:50 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41844 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235722AbhHDHDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 03:03:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 32B7C205A4;
        Wed,  4 Aug 2021 09:03:33 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nm3TiZ8Je_36; Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2F7A220534;
        Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 20AD080004A;
        Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 09:03:31 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 4 Aug 2021
 09:03:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0B0C1318083F; Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/6] Revert "xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype"
Date:   Wed, 4 Aug 2021 09:03:25 +0200
Message-ID: <20210804070329.1357123-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804070329.1357123-1-steffen.klassert@secunet.com>
References: <20210804070329.1357123-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit d7b0408934c749f546b01f2b33d07421a49b6f3e.

This commit tried to fix a locking bug introduced by commit 77cc278f7b20
("xfrm: policy: Use sequence counters with associated lock"). As it
turned out, this patch did not really fix the bug. A proper fix
for this bug is applied on top of this revert.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_policy.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index e9d0df2a2ab1..ce500f847b99 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2092,15 +2092,12 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 	if (unlikely(!daddr || !saddr))
 		return NULL;
 
- retry:
-	sequence = read_seqcount_begin(&xfrm_policy_hash_generation);
 	rcu_read_lock();
-
-	chain = policy_hash_direct(net, daddr, saddr, family, dir);
-	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence)) {
-		rcu_read_unlock();
-		goto retry;
-	}
+ retry:
+	do {
+		sequence = read_seqcount_begin(&xfrm_policy_hash_generation);
+		chain = policy_hash_direct(net, daddr, saddr, family, dir);
+	} while (read_seqcount_retry(&xfrm_policy_hash_generation, sequence));
 
 	ret = NULL;
 	hlist_for_each_entry_rcu(pol, chain, bydst) {
@@ -2131,15 +2128,11 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 	}
 
 skip_inexact:
-	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence)) {
-		rcu_read_unlock();
+	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence))
 		goto retry;
-	}
 
-	if (ret && !xfrm_pol_hold_rcu(ret)) {
-		rcu_read_unlock();
+	if (ret && !xfrm_pol_hold_rcu(ret))
 		goto retry;
-	}
 fail:
 	rcu_read_unlock();
 
-- 
2.25.1

