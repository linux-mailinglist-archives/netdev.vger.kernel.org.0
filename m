Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71875640DA9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbiLBSoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbiLBSng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:43:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D538191
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:42:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE48962387
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3531C433D7;
        Fri,  2 Dec 2022 18:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670006521;
        bh=bGfjq8Xf6mRa6IrlqKHND4Q6m0owL5kwCtFN7lsHLNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvvM/Dkwxld+7ud9P/Zhdi/Fja2M9eH/vnYV8TcbwB7E7/xQR8s6DzXGIsJMhdsDS
         6UwqrtFuAyc3/r2G/hwqliD+au54tG44iWgdjs5ZWEeTYBJCm7KhypyRI922YrCHyG
         JfN06ashf7gXUskRP0It6RBxSd2wqdYExzcB4EynMLRdmbKVZkutdS+p4qYR0wKuOd
         o62PEXhPySp79pyooy6zzRXJ8Z8to9TEPYsIw4I76vX9A8xKBkFNqGDAyOwZo/8MMt
         kxDP1ydxaas5sDSeFWV/sc1LHhwlwkBOEVpVDkwoV3XuaiuLXvWRPGqy4NRWFt79MP
         8pTi40OXq+WKA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next v10 6/8] xfrm: speed-up lookup of HW policies
Date:   Fri,  2 Dec 2022 20:41:32 +0200
Message-Id: <db726b7ea28eafac216b749c4359942c59e8d8ae.1670005543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670005543.git.leonro@nvidia.com>
References: <cover.1670005543.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devices that implement IPsec packet offload mode should offload SA and
policies too. In RX path, it causes to the situation that HW will always
have higher priority over any SW policies.

It means that we don't need to perform any search of inexact policies
and/or priority checks if HW policy was discovered. In such situation,
the HW will catch the packets anyway and HW can still implement inexact
lookups.

In case specific policy is not found, we will continue with packet lookup and
check for existence of HW policies in inexact list.

HW policies are added to the head of SPD to ensure fast lookup, as XFRM
iterates over all policies in the loop.

The same solution of adding HW SAs at the begging of the list is applied
to SA database too. However, we don't need to change lookups as they are
sorted by insertion order and not priority.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_policy.c | 16 ++++++----
 net/xfrm/xfrm_state.c  | 66 ++++++++++++++++++++++++++++++++----------
 2 files changed, 62 insertions(+), 20 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 8b8760907563..e9eb82c5457d 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -536,7 +536,7 @@ static void xfrm_dst_hash_transfer(struct net *net,
 		__get_hash_thresh(net, pol->family, dir, &dbits, &sbits);
 		h = __addr_hash(&pol->selector.daddr, &pol->selector.saddr,
 				pol->family, nhashmask, dbits, sbits);
-		if (!entry0) {
+		if (!entry0 || pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
 			hlist_del_rcu(&pol->bydst);
 			hlist_add_head_rcu(&pol->bydst, ndsttable + h);
 			h0 = h;
@@ -867,7 +867,7 @@ static void xfrm_policy_inexact_list_reinsert(struct net *net,
 				break;
 		}
 
-		if (newpos)
+		if (newpos && policy->xdo.type != XFRM_DEV_OFFLOAD_PACKET)
 			hlist_add_behind_rcu(&policy->bydst, newpos);
 		else
 			hlist_add_head_rcu(&policy->bydst, &n->hhead);
@@ -1348,7 +1348,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 			else
 				break;
 		}
-		if (newpos)
+		if (newpos && policy->xdo.type != XFRM_DEV_OFFLOAD_PACKET)
 			hlist_add_behind_rcu(&policy->bydst, newpos);
 		else
 			hlist_add_head_rcu(&policy->bydst, chain);
@@ -1525,7 +1525,7 @@ static void xfrm_policy_insert_inexact_list(struct hlist_head *chain,
 			break;
 	}
 
-	if (newpos)
+	if (newpos && policy->xdo.type != XFRM_DEV_OFFLOAD_PACKET)
 		hlist_add_behind_rcu(&policy->bydst_inexact_list, newpos);
 	else
 		hlist_add_head_rcu(&policy->bydst_inexact_list, chain);
@@ -1562,9 +1562,12 @@ static struct xfrm_policy *xfrm_policy_insert_list(struct hlist_head *chain,
 			break;
 	}
 
-	if (newpos)
+	if (newpos && policy->xdo.type != XFRM_DEV_OFFLOAD_PACKET)
 		hlist_add_behind_rcu(&policy->bydst, &newpos->bydst);
 	else
+		/* Packet offload policies enter to the head
+		 * to speed-up lookups.
+		 */
 		hlist_add_head_rcu(&policy->bydst, chain);
 
 	return delpol;
@@ -2181,6 +2184,9 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 			break;
 		}
 	}
+	if (ret && ret->xdo.type == XFRM_DEV_OFFLOAD_PACKET)
+		goto skip_inexact;
+
 	bin = xfrm_policy_inexact_lookup_rcu(net, type, family, dir, if_id);
 	if (!bin || !xfrm_policy_find_inexact_candidates(&cand, bin, saddr,
 							 daddr))
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 4d315e1a88fa..2a190e85da80 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -84,6 +84,25 @@ static unsigned int xfrm_seq_hash(struct net *net, u32 seq)
 	return __xfrm_seq_hash(seq, net->xfrm.state_hmask);
 }
 
+#define XFRM_STATE_INSERT(by, _n, _h, _type)                               \
+	{                                                                  \
+		struct xfrm_state *_x = NULL;                              \
+									   \
+		if (_type != XFRM_DEV_OFFLOAD_PACKET) {                    \
+			hlist_for_each_entry_rcu(_x, _h, by) {             \
+				if (_x->xso.type == XFRM_DEV_OFFLOAD_PACKET) \
+					continue;                          \
+				break;                                     \
+			}                                                  \
+		}                                                          \
+									   \
+		if (!_x || _x->xso.type == XFRM_DEV_OFFLOAD_PACKET)        \
+			/* SAD is empty or consist from HW SAs only */     \
+			hlist_add_head_rcu(_n, _h);                        \
+		else                                                       \
+			hlist_add_before_rcu(_n, &_x->by);                 \
+	}
+
 static void xfrm_hash_transfer(struct hlist_head *list,
 			       struct hlist_head *ndsttable,
 			       struct hlist_head *nsrctable,
@@ -100,23 +119,25 @@ static void xfrm_hash_transfer(struct hlist_head *list,
 		h = __xfrm_dst_hash(&x->id.daddr, &x->props.saddr,
 				    x->props.reqid, x->props.family,
 				    nhashmask);
-		hlist_add_head_rcu(&x->bydst, ndsttable + h);
+		XFRM_STATE_INSERT(bydst, &x->bydst, ndsttable + h, x->xso.type);
 
 		h = __xfrm_src_hash(&x->id.daddr, &x->props.saddr,
 				    x->props.family,
 				    nhashmask);
-		hlist_add_head_rcu(&x->bysrc, nsrctable + h);
+		XFRM_STATE_INSERT(bysrc, &x->bysrc, nsrctable + h, x->xso.type);
 
 		if (x->id.spi) {
 			h = __xfrm_spi_hash(&x->id.daddr, x->id.spi,
 					    x->id.proto, x->props.family,
 					    nhashmask);
-			hlist_add_head_rcu(&x->byspi, nspitable + h);
+			XFRM_STATE_INSERT(byspi, &x->byspi, nspitable + h,
+					  x->xso.type);
 		}
 
 		if (x->km.seq) {
 			h = __xfrm_seq_hash(x->km.seq, nhashmask);
-			hlist_add_head_rcu(&x->byseq, nseqtable + h);
+			XFRM_STATE_INSERT(byseq, &x->byseq, nseqtable + h,
+					  x->xso.type);
 		}
 	}
 }
@@ -1269,16 +1290,24 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			spin_lock_bh(&net->xfrm.xfrm_state_lock);
 			x->km.state = XFRM_STATE_ACQ;
 			list_add(&x->km.all, &net->xfrm.state_all);
-			hlist_add_head_rcu(&x->bydst, net->xfrm.state_bydst + h);
+			XFRM_STATE_INSERT(bydst, &x->bydst,
+					  net->xfrm.state_bydst + h,
+					  x->xso.type);
 			h = xfrm_src_hash(net, daddr, saddr, encap_family);
-			hlist_add_head_rcu(&x->bysrc, net->xfrm.state_bysrc + h);
+			XFRM_STATE_INSERT(bysrc, &x->bysrc,
+					  net->xfrm.state_bysrc + h,
+					  x->xso.type);
 			if (x->id.spi) {
 				h = xfrm_spi_hash(net, &x->id.daddr, x->id.spi, x->id.proto, encap_family);
-				hlist_add_head_rcu(&x->byspi, net->xfrm.state_byspi + h);
+				XFRM_STATE_INSERT(byspi, &x->byspi,
+						  net->xfrm.state_byspi + h,
+						  x->xso.type);
 			}
 			if (x->km.seq) {
 				h = xfrm_seq_hash(net, x->km.seq);
-				hlist_add_head_rcu(&x->byseq, net->xfrm.state_byseq + h);
+				XFRM_STATE_INSERT(byseq, &x->byseq,
+						  net->xfrm.state_byseq + h,
+						  x->xso.type);
 			}
 			x->lft.hard_add_expires_seconds = net->xfrm.sysctl_acq_expires;
 			hrtimer_start(&x->mtimer,
@@ -1395,22 +1424,26 @@ static void __xfrm_state_insert(struct xfrm_state *x)
 
 	h = xfrm_dst_hash(net, &x->id.daddr, &x->props.saddr,
 			  x->props.reqid, x->props.family);
-	hlist_add_head_rcu(&x->bydst, net->xfrm.state_bydst + h);
+	XFRM_STATE_INSERT(bydst, &x->bydst, net->xfrm.state_bydst + h,
+			  x->xso.type);
 
 	h = xfrm_src_hash(net, &x->id.daddr, &x->props.saddr, x->props.family);
-	hlist_add_head_rcu(&x->bysrc, net->xfrm.state_bysrc + h);
+	XFRM_STATE_INSERT(bysrc, &x->bysrc, net->xfrm.state_bysrc + h,
+			  x->xso.type);
 
 	if (x->id.spi) {
 		h = xfrm_spi_hash(net, &x->id.daddr, x->id.spi, x->id.proto,
 				  x->props.family);
 
-		hlist_add_head_rcu(&x->byspi, net->xfrm.state_byspi + h);
+		XFRM_STATE_INSERT(byspi, &x->byspi, net->xfrm.state_byspi + h,
+				  x->xso.type);
 	}
 
 	if (x->km.seq) {
 		h = xfrm_seq_hash(net, x->km.seq);
 
-		hlist_add_head_rcu(&x->byseq, net->xfrm.state_byseq + h);
+		XFRM_STATE_INSERT(byseq, &x->byseq, net->xfrm.state_byseq + h,
+				  x->xso.type);
 	}
 
 	hrtimer_start(&x->mtimer, ktime_set(1, 0), HRTIMER_MODE_REL_SOFT);
@@ -1524,9 +1557,11 @@ static struct xfrm_state *__find_acq_core(struct net *net,
 			      ktime_set(net->xfrm.sysctl_acq_expires, 0),
 			      HRTIMER_MODE_REL_SOFT);
 		list_add(&x->km.all, &net->xfrm.state_all);
-		hlist_add_head_rcu(&x->bydst, net->xfrm.state_bydst + h);
+		XFRM_STATE_INSERT(bydst, &x->bydst, net->xfrm.state_bydst + h,
+				  x->xso.type);
 		h = xfrm_src_hash(net, daddr, saddr, family);
-		hlist_add_head_rcu(&x->bysrc, net->xfrm.state_bysrc + h);
+		XFRM_STATE_INSERT(bysrc, &x->bysrc, net->xfrm.state_bysrc + h,
+				  x->xso.type);
 
 		net->xfrm.state_num++;
 
@@ -2209,7 +2244,8 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high,
 		spin_lock_bh(&net->xfrm.xfrm_state_lock);
 		x->id.spi = newspi;
 		h = xfrm_spi_hash(net, &x->id.daddr, x->id.spi, x->id.proto, x->props.family);
-		hlist_add_head_rcu(&x->byspi, net->xfrm.state_byspi + h);
+		XFRM_STATE_INSERT(byspi, &x->byspi, net->xfrm.state_byspi + h,
+				  x->xso.type);
 		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
 		err = 0;
-- 
2.38.1

