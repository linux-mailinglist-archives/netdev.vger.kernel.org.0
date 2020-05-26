Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7F21E24D4
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgEZPBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbgEZPBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 11:01:18 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A7A8207FB;
        Tue, 26 May 2020 15:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590505277;
        bh=GZGJPAQZzYW42Kg8RLnUDGmGG0VY0gWF+9tmGeoVgRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8VBl3AZbWrwRF+ehNPpzmFuViQsGKof2hYAjdO1Uhz9ibBFte+8f9w0qwoFT7EB/
         O5M4jAebwgA5I3wwinKAp8Vy1pmo+qcY5dq2m6gOLxuVzen9inws/wq39TqXHJkrFj
         FDyk60B4pJZXQ6TxuDxOWAUx6OFdsSVo4OFdsWCc=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nikolay@cumulusnetworks.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net 4/5] ipv4: Refactor nhc evaluation in fib_table_lookup
Date:   Tue, 26 May 2020 09:01:13 -0600
Message-Id: <20200526150114.41687-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200526150114.41687-1-dsahern@kernel.org>
References: <20200526150114.41687-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

FIB lookups can return an entry that references an external nexthop.
While walking the nexthop struct we do not want to make multiple calls
into the nexthop code which can result in 2 different structs getting
accessed - one returning the number of paths the rest of the loop
seeing a different nh_grp struct. If the nexthop group shrunk, the
result is an attempt to access a fib_nh_common that does not exist for
the new nh_grp struct but did for the old one.

To fix that move the device evaluation code to a helper that can be
used for inline fib_nh path as well as external nexthops.

Update the existing check for fi->nh in fib_table_lookup to call a
new helper, nexthop_get_nhc_lookup, which walks the external nexthop
with a single rcu dereference.

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h  |  2 ++
 include/net/nexthop.h | 33 ++++++++++++++++++++++++++++
 net/ipv4/fib_trie.c   | 51 ++++++++++++++++++++++++++++++-------------
 3 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 59e0d4e99f94..1f1dd22980e4 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -480,6 +480,8 @@ void fib_nh_common_release(struct fib_nh_common *nhc);
 void fib_alias_hw_flags_set(struct net *net, const struct fib_rt_info *fri);
 void fib_trie_init(void);
 struct fib_table *fib_trie_table(u32 id, struct fib_table *alias);
+bool fib_lookup_good_nhc(const struct fib_nh_common *nhc, int fib_flags,
+			 const struct flowi4 *flp);
 
 static inline void fib_combine_itag(u32 *itag, const struct fib_result *res)
 {
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index f09e8d7d9886..9414ae46fc1c 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -233,6 +233,39 @@ struct fib_nh_common *nexthop_fib_nhc(struct nexthop *nh, int nhsel)
 	return &nhi->fib_nhc;
 }
 
+/* called from fib_table_lookup with rcu_lock */
+static inline
+struct fib_nh_common *nexthop_get_nhc_lookup(const struct nexthop *nh,
+					     int fib_flags,
+					     const struct flowi4 *flp,
+					     int *nhsel)
+{
+	struct nh_info *nhi;
+
+	if (nh->is_group) {
+		struct nh_group *nhg = rcu_dereference(nh->nh_grp);
+		int i;
+
+		for (i = 0; i < nhg->num_nh; i++) {
+			struct nexthop *nhe = nhg->nh_entries[i].nh;
+
+			nhi = rcu_dereference(nhe->nh_info);
+			if (fib_lookup_good_nhc(&nhi->fib_nhc, fib_flags, flp)) {
+				*nhsel = i;
+				return &nhi->fib_nhc;
+			}
+		}
+	} else {
+		nhi = rcu_dereference(nh->nh_info);
+		if (fib_lookup_good_nhc(&nhi->fib_nhc, fib_flags, flp)) {
+			*nhsel = 0;
+			return &nhi->fib_nhc;
+		}
+	}
+
+	return NULL;
+}
+
 static inline unsigned int fib_info_num_path(const struct fib_info *fi)
 {
 	if (unlikely(fi->nh))
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 4f334b425538..248f1c1959a6 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1371,6 +1371,26 @@ static inline t_key prefix_mismatch(t_key key, struct key_vector *n)
 	return (key ^ prefix) & (prefix | -prefix);
 }
 
+bool fib_lookup_good_nhc(const struct fib_nh_common *nhc, int fib_flags,
+			 const struct flowi4 *flp)
+{
+	if (nhc->nhc_flags & RTNH_F_DEAD)
+		return false;
+
+	if (ip_ignore_linkdown(nhc->nhc_dev) &&
+	    nhc->nhc_flags & RTNH_F_LINKDOWN &&
+	    !(fib_flags & FIB_LOOKUP_IGNORE_LINKSTATE))
+		return false;
+
+	if (!(flp->flowi4_flags & FLOWI_FLAG_SKIP_NH_OIF)) {
+		if (flp->flowi4_oif &&
+		    flp->flowi4_oif != nhc->nhc_oif)
+			return false;
+	}
+
+	return true;
+}
+
 /* should be called with rcu_read_lock */
 int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 		     struct fib_result *res, int fib_flags)
@@ -1503,6 +1523,7 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 	/* Step 3: Process the leaf, if that fails fall back to backtracing */
 	hlist_for_each_entry_rcu(fa, &n->leaf, fa_list) {
 		struct fib_info *fi = fa->fa_info;
+		struct fib_nh_common *nhc;
 		int nhsel, err;
 
 		if ((BITS_PER_LONG > KEYLENGTH) || (fa->fa_slen < KEYLENGTH)) {
@@ -1528,26 +1549,25 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 		if (fi->fib_flags & RTNH_F_DEAD)
 			continue;
 
-		if (unlikely(fi->nh && nexthop_is_blackhole(fi->nh))) {
-			err = fib_props[RTN_BLACKHOLE].error;
-			goto out_reject;
+		if (unlikely(fi->nh)) {
+			if (nexthop_is_blackhole(fi->nh)) {
+				err = fib_props[RTN_BLACKHOLE].error;
+				goto out_reject;
+			}
+
+			nhc = nexthop_get_nhc_lookup(fi->nh, fib_flags, flp,
+						     &nhsel);
+			if (nhc)
+				goto set_result;
+			goto miss;
 		}
 
 		for (nhsel = 0; nhsel < fib_info_num_path(fi); nhsel++) {
-			struct fib_nh_common *nhc = fib_info_nhc(fi, nhsel);
+			nhc = fib_info_nhc(fi, nhsel);
 
-			if (nhc->nhc_flags & RTNH_F_DEAD)
+			if (!fib_lookup_good_nhc(nhc, fib_flags, flp))
 				continue;
-			if (ip_ignore_linkdown(nhc->nhc_dev) &&
-			    nhc->nhc_flags & RTNH_F_LINKDOWN &&
-			    !(fib_flags & FIB_LOOKUP_IGNORE_LINKSTATE))
-				continue;
-			if (!(flp->flowi4_flags & FLOWI_FLAG_SKIP_NH_OIF)) {
-				if (flp->flowi4_oif &&
-				    flp->flowi4_oif != nhc->nhc_oif)
-					continue;
-			}
-
+set_result:
 			if (!(fib_flags & FIB_LOOKUP_NOREF))
 				refcount_inc(&fi->fib_clntref);
 
@@ -1568,6 +1588,7 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 			return err;
 		}
 	}
+miss:
 #ifdef CONFIG_IP_FIB_TRIE_STATS
 	this_cpu_inc(stats->semantic_match_miss);
 #endif
-- 
2.21.1 (Apple Git-122.3)

