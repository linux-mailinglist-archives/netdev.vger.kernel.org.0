Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7FE20014
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 09:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfEPHT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 03:19:56 -0400
Received: from orcrist.hmeau.com ([5.180.42.13]:44074 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbfEPHTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 03:19:55 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hRAg8-0004Pa-Bo; Thu, 16 May 2019 15:19:48 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hRAg8-0004Fy-0O; Thu, 16 May 2019 15:19:48 +0800
Subject: [PATCH 2/2] rhashtable: Fix cmpxchg RCU warnings
References: <20190516051622.b4x6hlkuevof4jzr@gondor.apana.org.au>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net,
        tgraf@suug.ch, netdev@vger.kernel.org, oss-drivers@netronome.com,
        neilb@suse.com, Simon Horman <simon.horman@netronome.com>
Message-Id: <E1hRAg8-0004Fy-0O@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 16 May 2019 15:19:48 +0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As cmpxchg is a non-RCU mechanism it will cause sparse warnings
when we use it for RCU.  This patch adds explicit casts to silence
those warnings.  This should probably be moved to RCU itself in
future.
  
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 lib/rhashtable.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 7708699a5b96..935ec80f213f 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -131,7 +131,7 @@ static union nested_table *nested_table_alloc(struct rhashtable *ht,
 			INIT_RHT_NULLS_HEAD(ntbl[i].bucket);
 	}
 
-	if (cmpxchg(prev, NULL, ntbl) == NULL)
+	if (cmpxchg((union nested_table **)prev, NULL, ntbl) == NULL)
 		return ntbl;
 	/* Raced with another thread. */
 	kfree(ntbl);
@@ -296,7 +296,8 @@ static int rhashtable_rehash_attach(struct rhashtable *ht,
 	 * rcu_assign_pointer().
 	 */
 
-	if (cmpxchg(&old_tbl->future_tbl, NULL, new_tbl) != NULL)
+	if (cmpxchg((struct bucket_table **)&old_tbl->future_tbl, NULL,
+		    new_tbl) != NULL)
 		return -EEXIST;
 
 	return 0;
