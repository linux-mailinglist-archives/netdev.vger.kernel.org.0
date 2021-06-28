Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A553B58B1
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhF1Fr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:47:59 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:40908 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhF1Fr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:47:56 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 6EB8E800055;
        Mon, 28 Jun 2021 07:45:29 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 07:45:29 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 07:45:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 76BB73180319; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 02/17] xfrm: add state hashtable keyed by seq
Date:   Mon, 28 Jun 2021 07:45:07 +0200
Message-ID: <20210628054522.1718786-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628054522.1718786-1-steffen.klassert@secunet.com>
References: <20210628054522.1718786-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

When creating new states with seq set in xfrm_usersa_info, we walk
through all the states already installed in that netns to find a
matching ACQUIRE state (__xfrm_find_acq_byseq, called from
xfrm_state_add). This causes severe slowdowns on systems with a large
number of states.

This patch introduces a hashtable using x->km.seq as key, so that the
corresponding state can be found in a reasonable time.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/netns/xfrm.h |  1 +
 include/net/xfrm.h       |  1 +
 net/xfrm/xfrm_hash.h     |  7 +++++
 net/xfrm/xfrm_state.c    | 65 ++++++++++++++++++++++++++++++++--------
 4 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index e816b6a3ef2b..e946366e8ba5 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -42,6 +42,7 @@ struct netns_xfrm {
 	struct hlist_head	__rcu *state_bydst;
 	struct hlist_head	__rcu *state_bysrc;
 	struct hlist_head	__rcu *state_byspi;
+	struct hlist_head	__rcu *state_byseq;
 	unsigned int		state_hmask;
 	unsigned int		state_num;
 	struct work_struct	state_hash_work;
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c58a6d4eb610..6e11db6fa0ab 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -154,6 +154,7 @@ struct xfrm_state {
 	};
 	struct hlist_node	bysrc;
 	struct hlist_node	byspi;
+	struct hlist_node	byseq;
 
 	refcount_t		refcnt;
 	spinlock_t		lock;
diff --git a/net/xfrm/xfrm_hash.h b/net/xfrm/xfrm_hash.h
index ce66323102f9..d12bb906c9c9 100644
--- a/net/xfrm/xfrm_hash.h
+++ b/net/xfrm/xfrm_hash.h
@@ -131,6 +131,13 @@ __xfrm_spi_hash(const xfrm_address_t *daddr, __be32 spi, u8 proto,
 	return (h ^ (h >> 10) ^ (h >> 20)) & hmask;
 }
 
+static inline unsigned int
+__xfrm_seq_hash(u32 seq, unsigned int hmask)
+{
+	unsigned int h = seq;
+	return (h ^ (h >> 10) ^ (h >> 20)) & hmask;
+}
+
 static inline unsigned int __idx_hash(u32 index, unsigned int hmask)
 {
 	return (index ^ (index >> 8)) & hmask;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 4496f7efa220..8f6058e56f7f 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -78,10 +78,16 @@ xfrm_spi_hash(struct net *net, const xfrm_address_t *daddr,
 	return __xfrm_spi_hash(daddr, spi, proto, family, net->xfrm.state_hmask);
 }
 
+static unsigned int xfrm_seq_hash(struct net *net, u32 seq)
+{
+	return __xfrm_seq_hash(seq, net->xfrm.state_hmask);
+}
+
 static void xfrm_hash_transfer(struct hlist_head *list,
 			       struct hlist_head *ndsttable,
 			       struct hlist_head *nsrctable,
 			       struct hlist_head *nspitable,
+			       struct hlist_head *nseqtable,
 			       unsigned int nhashmask)
 {
 	struct hlist_node *tmp;
@@ -106,6 +112,11 @@ static void xfrm_hash_transfer(struct hlist_head *list,
 					    nhashmask);
 			hlist_add_head_rcu(&x->byspi, nspitable + h);
 		}
+
+		if (x->km.seq) {
+			h = __xfrm_seq_hash(x->km.seq, nhashmask);
+			hlist_add_head_rcu(&x->byseq, nseqtable + h);
+		}
 	}
 }
 
@@ -117,7 +128,7 @@ static unsigned long xfrm_hash_new_size(unsigned int state_hmask)
 static void xfrm_hash_resize(struct work_struct *work)
 {
 	struct net *net = container_of(work, struct net, xfrm.state_hash_work);
-	struct hlist_head *ndst, *nsrc, *nspi, *odst, *osrc, *ospi;
+	struct hlist_head *ndst, *nsrc, *nspi, *nseq, *odst, *osrc, *ospi, *oseq;
 	unsigned long nsize, osize;
 	unsigned int nhashmask, ohashmask;
 	int i;
@@ -137,6 +148,13 @@ static void xfrm_hash_resize(struct work_struct *work)
 		xfrm_hash_free(nsrc, nsize);
 		return;
 	}
+	nseq = xfrm_hash_alloc(nsize);
+	if (!nseq) {
+		xfrm_hash_free(ndst, nsize);
+		xfrm_hash_free(nsrc, nsize);
+		xfrm_hash_free(nspi, nsize);
+		return;
+	}
 
 	spin_lock_bh(&net->xfrm.xfrm_state_lock);
 	write_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
@@ -144,15 +162,17 @@ static void xfrm_hash_resize(struct work_struct *work)
 	nhashmask = (nsize / sizeof(struct hlist_head)) - 1U;
 	odst = xfrm_state_deref_prot(net->xfrm.state_bydst, net);
 	for (i = net->xfrm.state_hmask; i >= 0; i--)
-		xfrm_hash_transfer(odst + i, ndst, nsrc, nspi, nhashmask);
+		xfrm_hash_transfer(odst + i, ndst, nsrc, nspi, nseq, nhashmask);
 
 	osrc = xfrm_state_deref_prot(net->xfrm.state_bysrc, net);
 	ospi = xfrm_state_deref_prot(net->xfrm.state_byspi, net);
+	oseq = xfrm_state_deref_prot(net->xfrm.state_byseq, net);
 	ohashmask = net->xfrm.state_hmask;
 
 	rcu_assign_pointer(net->xfrm.state_bydst, ndst);
 	rcu_assign_pointer(net->xfrm.state_bysrc, nsrc);
 	rcu_assign_pointer(net->xfrm.state_byspi, nspi);
+	rcu_assign_pointer(net->xfrm.state_byseq, nseq);
 	net->xfrm.state_hmask = nhashmask;
 
 	write_seqcount_end(&net->xfrm.xfrm_state_hash_generation);
@@ -165,6 +185,7 @@ static void xfrm_hash_resize(struct work_struct *work)
 	xfrm_hash_free(odst, osize);
 	xfrm_hash_free(osrc, osize);
 	xfrm_hash_free(ospi, osize);
+	xfrm_hash_free(oseq, osize);
 }
 
 static DEFINE_SPINLOCK(xfrm_state_afinfo_lock);
@@ -621,6 +642,7 @@ struct xfrm_state *xfrm_state_alloc(struct net *net)
 		INIT_HLIST_NODE(&x->bydst);
 		INIT_HLIST_NODE(&x->bysrc);
 		INIT_HLIST_NODE(&x->byspi);
+		INIT_HLIST_NODE(&x->byseq);
 		hrtimer_init(&x->mtimer, CLOCK_BOOTTIME, HRTIMER_MODE_ABS_SOFT);
 		x->mtimer.function = xfrm_timer_handler;
 		timer_setup(&x->rtimer, xfrm_replay_timer_handler, 0);
@@ -664,6 +686,8 @@ int __xfrm_state_delete(struct xfrm_state *x)
 		list_del(&x->km.all);
 		hlist_del_rcu(&x->bydst);
 		hlist_del_rcu(&x->bysrc);
+		if (x->km.seq)
+			hlist_del_rcu(&x->byseq);
 		if (x->id.spi)
 			hlist_del_rcu(&x->byspi);
 		net->xfrm.state_num--;
@@ -1148,6 +1172,10 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 				h = xfrm_spi_hash(net, &x->id.daddr, x->id.spi, x->id.proto, encap_family);
 				hlist_add_head_rcu(&x->byspi, net->xfrm.state_byspi + h);
 			}
+			if (x->km.seq) {
+				h = xfrm_seq_hash(net, x->km.seq);
+				hlist_add_head_rcu(&x->byseq, net->xfrm.state_byseq + h);
+			}
 			x->lft.hard_add_expires_seconds = net->xfrm.sysctl_acq_expires;
 			hrtimer_start(&x->mtimer,
 				      ktime_set(net->xfrm.sysctl_acq_expires, 0),
@@ -1263,6 +1291,12 @@ static void __xfrm_state_insert(struct xfrm_state *x)
 		hlist_add_head_rcu(&x->byspi, net->xfrm.state_byspi + h);
 	}
 
+	if (x->km.seq) {
+		h = xfrm_seq_hash(net, x->km.seq);
+
+		hlist_add_head_rcu(&x->byseq, net->xfrm.state_byseq + h);
+	}
+
 	hrtimer_start(&x->mtimer, ktime_set(1, 0), HRTIMER_MODE_REL_SOFT);
 	if (x->replay_maxage)
 		mod_timer(&x->rtimer, jiffies + x->replay_maxage);
@@ -1932,20 +1966,18 @@ xfrm_state_sort(struct xfrm_state **dst, struct xfrm_state **src, int n,
 
 static struct xfrm_state *__xfrm_find_acq_byseq(struct net *net, u32 mark, u32 seq)
 {
-	int i;
-
-	for (i = 0; i <= net->xfrm.state_hmask; i++) {
-		struct xfrm_state *x;
+	unsigned int h = xfrm_seq_hash(net, seq);
+	struct xfrm_state *x;
 
-		hlist_for_each_entry(x, net->xfrm.state_bydst+i, bydst) {
-			if (x->km.seq == seq &&
-			    (mark & x->mark.m) == x->mark.v &&
-			    x->km.state == XFRM_STATE_ACQ) {
-				xfrm_state_hold(x);
-				return x;
-			}
+	hlist_for_each_entry_rcu(x, net->xfrm.state_byseq + h, byseq) {
+		if (x->km.seq == seq &&
+		    (mark & x->mark.m) == x->mark.v &&
+		    x->km.state == XFRM_STATE_ACQ) {
+			xfrm_state_hold(x);
+			return x;
 		}
 	}
+
 	return NULL;
 }
 
@@ -2660,6 +2692,9 @@ int __net_init xfrm_state_init(struct net *net)
 	net->xfrm.state_byspi = xfrm_hash_alloc(sz);
 	if (!net->xfrm.state_byspi)
 		goto out_byspi;
+	net->xfrm.state_byseq = xfrm_hash_alloc(sz);
+	if (!net->xfrm.state_byseq)
+		goto out_byseq;
 	net->xfrm.state_hmask = ((sz / sizeof(struct hlist_head)) - 1);
 
 	net->xfrm.state_num = 0;
@@ -2669,6 +2704,8 @@ int __net_init xfrm_state_init(struct net *net)
 			       &net->xfrm.xfrm_state_lock);
 	return 0;
 
+out_byseq:
+	xfrm_hash_free(net->xfrm.state_byspi, sz);
 out_byspi:
 	xfrm_hash_free(net->xfrm.state_bysrc, sz);
 out_bysrc:
@@ -2688,6 +2725,8 @@ void xfrm_state_fini(struct net *net)
 	WARN_ON(!list_empty(&net->xfrm.state_all));
 
 	sz = (net->xfrm.state_hmask + 1) * sizeof(struct hlist_head);
+	WARN_ON(!hlist_empty(net->xfrm.state_byseq));
+	xfrm_hash_free(net->xfrm.state_byseq, sz);
 	WARN_ON(!hlist_empty(net->xfrm.state_byspi));
 	xfrm_hash_free(net->xfrm.state_byspi, sz);
 	WARN_ON(!hlist_empty(net->xfrm.state_bysrc));
-- 
2.25.1

