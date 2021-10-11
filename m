Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68B5428CC8
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 14:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbhJKMOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 08:14:49 -0400
Received: from www62.your-server.de ([213.133.104.62]:36932 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbhJKMOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 08:14:47 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mZuAg-000Edr-59; Mon, 11 Oct 2021 14:12:46 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net-next 1/4] net, neigh: Fix NTF_EXT_LEARNED in combination with NTF_USE
Date:   Mon, 11 Oct 2021 14:12:35 +0200
Message-Id: <20211011121238.25542-2-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211011121238.25542-1-daniel@iogearbox.net>
References: <20211011121238.25542-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26319/Mon Oct 11 10:18:47 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NTF_EXT_LEARNED neigh flag is usually propagated back to user space
upon dump of the neighbor table. However, when used in combination with
NTF_USE flag this is not the case despite exempting the entry from the
garbage collector. This results in inconsistent state since entries are
typically marked in neigh->flags with NTF_EXT_LEARNED, but here they are
not. Fix it by propagating the creation flag to ___neigh_create().

Before fix:

  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use extern_learn
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a REACHABLE
  [...]

After fix:

  # ./ip/ip n replace 192.168.178.30 dev enp5s0 use extern_learn
  # ./ip/ip n
  192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a extern_learn REACHABLE
  [...]

Fixes: 9ce33e46531d ("neighbour: support for NTF_EXT_LEARNED flag")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Roopa Prabhu <roopa@nvidia.com>
---
 net/core/neighbour.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 2d5bc3a75fae..8457d5f97022 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -379,7 +379,7 @@ EXPORT_SYMBOL(neigh_ifdown);
 
 static struct neighbour *neigh_alloc(struct neigh_table *tbl,
 				     struct net_device *dev,
-				     bool exempt_from_gc)
+				     u8 flags, bool exempt_from_gc)
 {
 	struct neighbour *n = NULL;
 	unsigned long now = jiffies;
@@ -412,6 +412,7 @@ static struct neighbour *neigh_alloc(struct neigh_table *tbl,
 	n->updated	  = n->used = now;
 	n->nud_state	  = NUD_NONE;
 	n->output	  = neigh_blackhole;
+	n->flags	  = flags;
 	seqlock_init(&n->hh.hh_lock);
 	n->parms	  = neigh_parms_clone(&tbl->parms);
 	timer_setup(&n->timer, neigh_timer_handler, 0);
@@ -575,19 +576,18 @@ struct neighbour *neigh_lookup_nodev(struct neigh_table *tbl, struct net *net,
 }
 EXPORT_SYMBOL(neigh_lookup_nodev);
 
-static struct neighbour *___neigh_create(struct neigh_table *tbl,
-					 const void *pkey,
-					 struct net_device *dev,
-					 bool exempt_from_gc, bool want_ref)
+static struct neighbour *
+___neigh_create(struct neigh_table *tbl, const void *pkey,
+		struct net_device *dev, u8 flags,
+		bool exempt_from_gc, bool want_ref)
 {
-	struct neighbour *n1, *rc, *n = neigh_alloc(tbl, dev, exempt_from_gc);
-	u32 hash_val;
-	unsigned int key_len = tbl->key_len;
-	int error;
+	u32 hash_val, key_len = tbl->key_len;
+	struct neighbour *n1, *rc, *n;
 	struct neigh_hash_table *nht;
+	int error;
 
+	n = neigh_alloc(tbl, dev, flags, exempt_from_gc);
 	trace_neigh_create(tbl, dev, pkey, n, exempt_from_gc);
-
 	if (!n) {
 		rc = ERR_PTR(-ENOBUFS);
 		goto out;
@@ -674,7 +674,7 @@ static struct neighbour *___neigh_create(struct neigh_table *tbl,
 struct neighbour *__neigh_create(struct neigh_table *tbl, const void *pkey,
 				 struct net_device *dev, bool want_ref)
 {
-	return ___neigh_create(tbl, pkey, dev, false, want_ref);
+	return ___neigh_create(tbl, pkey, dev, 0, false, want_ref);
 }
 EXPORT_SYMBOL(__neigh_create);
 
@@ -1942,7 +1942,9 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 		exempt_from_gc = ndm->ndm_state & NUD_PERMANENT ||
 				 ndm->ndm_flags & NTF_EXT_LEARNED;
-		neigh = ___neigh_create(tbl, dst, dev, exempt_from_gc, true);
+		neigh = ___neigh_create(tbl, dst, dev,
+					ndm->ndm_flags & NTF_EXT_LEARNED,
+					exempt_from_gc, true);
 		if (IS_ERR(neigh)) {
 			err = PTR_ERR(neigh);
 			goto out;
-- 
2.27.0

