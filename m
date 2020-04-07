Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B37AB1A02E3
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgDGABi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727115AbgDGABh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E96BF2078A;
        Tue,  7 Apr 2020 00:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217695;
        bh=MQo4JrUK0tCJzj0nCxLS7KvVp9c85pC9+ZbJrm18i48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qAO5+D1UzbgOmfX4OJy4pUTK3mfB3gVy7S/v8ybIdOG5Bg3YbyJZqIqdVjdPp2dFZ
         6cqszF57ylKAMsylOyUq83WMWMcl9NaS9LGkD/yU+ropU8PQecWHf753c86KTh0a6Y
         eqjVf+ur7ahPF3SeFPnKnOifMNMpsHVwdX0pSZdI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 29/35] netfilter: nft_set_rbtree: Detect partial overlaps on insertion
Date:   Mon,  6 Apr 2020 20:00:51 -0400
Message-Id: <20200407000058.16423-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 7c84d41416d836ef7e533bd4d64ccbdf40c5ac70 ]

...and return -ENOTEMPTY to the front-end in this case, instead of
proceeding. Currently, nft takes care of checking for these cases
and not sending them to the kernel, but if we drop the set_overlap()
call in nft we can end up in situations like:

 # nft add table t
 # nft add set t s '{ type inet_service ; flags interval ; }'
 # nft add element t s '{ 1 - 5 }'
 # nft add element t s '{ 6 - 10 }'
 # nft add element t s '{ 4 - 7 }'
 # nft list set t s
 table ip t {
 	set s {
 		type inet_service
 		flags interval
 		elements = { 1-3, 4-5, 6-7 }
 	}
 }

This change has the primary purpose of making the behaviour
consistent with nft_set_pipapo, but is also functional to avoid
inconsistent behaviour if userspace sends overlapping elements for
any reason.

v2: When we meet the same key data in the tree, as start element while
    inserting an end element, or as end element while inserting a start
    element, actually check that the existing element is active, before
    resetting the overlap flag (Pablo Neira Ayuso)

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 70 ++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 95fcba34bfd35..996fd9dc6160c 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -213,8 +213,43 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	u8 genmask = nft_genmask_next(net);
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *parent, **p;
+	bool overlap = false;
 	int d;
 
+	/* Detect overlaps as we descend the tree. Set the flag in these cases:
+	 *
+	 * a1. |__ _ _?  >|__ _ _  (insert start after existing start)
+	 * a2. _ _ __>|  ?_ _ __|  (insert end before existing end)
+	 * a3. _ _ ___|  ?_ _ _>|  (insert end after existing end)
+	 * a4. >|__ _ _   _ _ __|  (insert start before existing end)
+	 *
+	 * and clear it later on, as we eventually reach the points indicated by
+	 * '?' above, in the cases described below. We'll always meet these
+	 * later, locally, due to tree ordering, and overlaps for the intervals
+	 * that are the closest together are always evaluated last.
+	 *
+	 * b1. |__ _ _!  >|__ _ _  (insert start after existing end)
+	 * b2. _ _ __>|  !_ _ __|  (insert end before existing start)
+	 * b3. !_____>|            (insert end after existing start)
+	 *
+	 * Case a4. resolves to b1.:
+	 * - if the inserted start element is the leftmost, because the '0'
+	 *   element in the tree serves as end element
+	 * - otherwise, if an existing end is found. Note that end elements are
+	 *   always inserted after corresponding start elements.
+	 *
+	 * For a new, rightmost pair of elements, we'll hit cases b1. and b3.,
+	 * in that order.
+	 *
+	 * The flag is also cleared in two special cases:
+	 *
+	 * b4. |__ _ _!|<_ _ _   (insert start right before existing end)
+	 * b5. |__ _ >|!__ _ _   (insert end right after existing start)
+	 *
+	 * which always happen as last step and imply that no further
+	 * overlapping is possible.
+	 */
+
 	parent = NULL;
 	p = &priv->root.rb_node;
 	while (*p != NULL) {
@@ -223,17 +258,42 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		d = memcmp(nft_set_ext_key(&rbe->ext),
 			   nft_set_ext_key(&new->ext),
 			   set->klen);
-		if (d < 0)
+		if (d < 0) {
 			p = &parent->rb_left;
-		else if (d > 0)
+
+			if (nft_rbtree_interval_start(new)) {
+				overlap = nft_rbtree_interval_start(rbe) &&
+					  nft_set_elem_active(&rbe->ext,
+							      genmask);
+			} else {
+				overlap = nft_rbtree_interval_end(rbe) &&
+					  nft_set_elem_active(&rbe->ext,
+							      genmask);
+			}
+		} else if (d > 0) {
 			p = &parent->rb_right;
-		else {
+
+			if (nft_rbtree_interval_end(new)) {
+				overlap = nft_rbtree_interval_end(rbe) &&
+					  nft_set_elem_active(&rbe->ext,
+							      genmask);
+			} else if (nft_rbtree_interval_end(rbe) &&
+				   nft_set_elem_active(&rbe->ext, genmask)) {
+				overlap = true;
+			}
+		} else {
 			if (nft_rbtree_interval_end(rbe) &&
 			    nft_rbtree_interval_start(new)) {
 				p = &parent->rb_left;
+
+				if (nft_set_elem_active(&rbe->ext, genmask))
+					overlap = false;
 			} else if (nft_rbtree_interval_start(rbe) &&
 				   nft_rbtree_interval_end(new)) {
 				p = &parent->rb_right;
+
+				if (nft_set_elem_active(&rbe->ext, genmask))
+					overlap = false;
 			} else if (nft_set_elem_active(&rbe->ext, genmask)) {
 				*ext = &rbe->ext;
 				return -EEXIST;
@@ -242,6 +302,10 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			}
 		}
 	}
+
+	if (overlap)
+		return -ENOTEMPTY;
+
 	rb_link_node_rcu(&new->node, parent, p);
 	rb_insert_color(&new->node, &priv->root);
 	return 0;
-- 
2.20.1

