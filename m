Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876FC36A90E
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 21:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhDYTsR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 25 Apr 2021 15:48:17 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:49093 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230494AbhDYTsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 15:48:17 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-wiec5V3mN2-wS34zbrqB4A-1; Sun, 25 Apr 2021 15:47:33 -0400
X-MC-Unique: wiec5V3mN2-wS34zbrqB4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F173107ACC7;
        Sun, 25 Apr 2021 19:47:32 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.192.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2182D100763B;
        Sun, 25 Apr 2021 19:47:30 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next] xfrm: add state hashtable keyed by seq
Date:   Sun, 25 Apr 2021 21:47:12 +0200
Message-Id: <d5f097821cddd17ddcba75f5153f034322c9fc6b.1619194963.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating new states with seq set in xfrm_usersa_info, we walk
through all the states already installed in that netns to find a
matching ACQUIRE state (__xfrm_find_acq_byseq, called from
xfrm_state_add). This causes severe slowdowns on systems with a large
number of states.

This patch introduces a hashtable using x->km.seq as key, so that the
corresponding state can be found in a reasonable time.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.31.1

