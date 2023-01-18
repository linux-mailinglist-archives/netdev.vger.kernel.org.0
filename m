Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EA2671D16
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjARNJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjARNI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:08:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899E75AB53;
        Wed, 18 Jan 2023 04:32:48 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pI7cQ-00074w-LD; Wed, 18 Jan 2023 13:32:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 4/9] netfilter: conntrack: move rcu read lock to nf_conntrack_find_get
Date:   Wed, 18 Jan 2023 13:32:03 +0100
Message-Id: <20230118123208.17167-5-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20230118123208.17167-1-fw@strlen.de>
References: <20230118123208.17167-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move rcu_read_lock/unlock to nf_conntrack_find_get(), this avoids
nested rcu_read_lock call from resolve_normal_ct().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9e12cade4e0f..c00858344f02 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -783,8 +783,6 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
 
-	rcu_read_lock();
-
 	h = ____nf_conntrack_find(net, zone, tuple, hash);
 	if (h) {
 		/* We have a candidate that matches the tuple we're interested
@@ -796,7 +794,7 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 			smp_acquire__after_ctrl_dep();
 
 			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
-				goto found;
+				return h;
 
 			/* TYPESAFE_BY_RCU recycled the candidate */
 			nf_ct_put(ct);
@@ -804,8 +802,6 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 
 		h = NULL;
 	}
-found:
-	rcu_read_unlock();
 
 	return h;
 }
@@ -817,16 +813,21 @@ nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 	unsigned int rid, zone_id = nf_ct_zone_id(zone, IP_CT_DIR_ORIGINAL);
 	struct nf_conntrack_tuple_hash *thash;
 
+	rcu_read_lock();
+
 	thash = __nf_conntrack_find_get(net, zone, tuple,
 					hash_conntrack_raw(tuple, zone_id, net));
 
 	if (thash)
-		return thash;
+		goto out_unlock;
 
 	rid = nf_ct_zone_id(zone, IP_CT_DIR_REPLY);
 	if (rid != zone_id)
-		return __nf_conntrack_find_get(net, zone, tuple,
-					       hash_conntrack_raw(tuple, rid, net));
+		thash = __nf_conntrack_find_get(net, zone, tuple,
+						hash_conntrack_raw(tuple, rid, net));
+
+out_unlock:
+	rcu_read_unlock();
 	return thash;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_find_get);
-- 
2.38.2

