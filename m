Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D115A6B02BD
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 10:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjCHJXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 04:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjCHJXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 04:23:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219B84DBE2
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 01:23:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDE4CB81C0D
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 09:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E964AC433D2;
        Wed,  8 Mar 2023 09:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678267398;
        bh=K1qDrJ0OK5FtpdLmtFEk075prNULYOaWAyyomLHmbKA=;
        h=From:To:Cc:Subject:Date:From;
        b=aAOKeia8d0975kjgO5IhR+SbSq4DYRlLCrzt6yM3aTJyloIg3TbVn9yjXT0lkgLd3
         ztud/vxHno3eahzOT4aNKf7s6Jow445LPPXUEXqe4kege3DApdmNst8724d6M+8TOs
         UHSew2naUL/ic2ySnOzHs27hfjUAaknAUhIGUbYJyw1O1fQQYVO0hc4c1j8H8kKdZk
         OrdBzI31PGRhOzf1qjHClZf0shZLSI5lso3DjMXNpsloPJ+SK+3UqcCC15H8tf35Vk
         c/EPb60rU7xkx4OX+X7lGVhU6DMtaxgjNuE7D1XnqeKWd6TX2Br5FDG2cS7wWVLjOL
         Zj+iw4a8eELAA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next] neighbour: delete neigh_lookup_nodev as not used
Date:   Wed,  8 Mar 2023 11:23:13 +0200
Message-Id: <eb5656200d7964b2d177a36b77efa3c597d6d72d.1678267343.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

neigh_lookup_nodev isn't used in the kernel after removal
of DECnet. So let's remove it.

Fixes: 1202cdd66531 ("Remove DECnet support from kernel")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/neighbour.h |  2 --
 net/core/neighbour.c    | 31 -------------------------------
 2 files changed, 33 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 2f2a6023fb0e..234799ca527e 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -336,8 +336,6 @@ void neigh_table_init(int index, struct neigh_table *tbl);
 int neigh_table_clear(int index, struct neigh_table *tbl);
 struct neighbour *neigh_lookup(struct neigh_table *tbl, const void *pkey,
 			       struct net_device *dev);
-struct neighbour *neigh_lookup_nodev(struct neigh_table *tbl, struct net *net,
-				     const void *pkey);
 struct neighbour *__neigh_create(struct neigh_table *tbl, const void *pkey,
 				 struct net_device *dev, bool want_ref);
 static inline struct neighbour *neigh_create(struct neigh_table *tbl,
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 6798f6d2423b..0116b0ff91a7 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -627,37 +627,6 @@ struct neighbour *neigh_lookup(struct neigh_table *tbl, const void *pkey,
 }
 EXPORT_SYMBOL(neigh_lookup);
 
-struct neighbour *neigh_lookup_nodev(struct neigh_table *tbl, struct net *net,
-				     const void *pkey)
-{
-	struct neighbour *n;
-	unsigned int key_len = tbl->key_len;
-	u32 hash_val;
-	struct neigh_hash_table *nht;
-
-	NEIGH_CACHE_STAT_INC(tbl, lookups);
-
-	rcu_read_lock_bh();
-	nht = rcu_dereference_bh(tbl->nht);
-	hash_val = tbl->hash(pkey, NULL, nht->hash_rnd) >> (32 - nht->hash_shift);
-
-	for (n = rcu_dereference_bh(nht->hash_buckets[hash_val]);
-	     n != NULL;
-	     n = rcu_dereference_bh(n->next)) {
-		if (!memcmp(n->primary_key, pkey, key_len) &&
-		    net_eq(dev_net(n->dev), net)) {
-			if (!refcount_inc_not_zero(&n->refcnt))
-				n = NULL;
-			NEIGH_CACHE_STAT_INC(tbl, hits);
-			break;
-		}
-	}
-
-	rcu_read_unlock_bh();
-	return n;
-}
-EXPORT_SYMBOL(neigh_lookup_nodev);
-
 static struct neighbour *
 ___neigh_create(struct neigh_table *tbl, const void *pkey,
 		struct net_device *dev, u32 flags,
-- 
2.39.2

