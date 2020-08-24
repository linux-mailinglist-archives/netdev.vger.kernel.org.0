Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B6524FCC5
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 13:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgHXLk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 07:40:26 -0400
Received: from correo.us.es ([193.147.175.20]:41822 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgHXLjz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 07:39:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9300E81A10
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 13:39:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00A7DFC5F5
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 13:39:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77339C21D3; Mon, 24 Aug 2020 13:39:49 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85F9FDA791;
        Mon, 24 Aug 2020 13:39:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 24 Aug 2020 13:39:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id DB10942EE38E;
        Mon, 24 Aug 2020 13:39:46 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 2/6] netfilter: nft_set_rbtree: Handle outcomes of tree rotations in overlap detection
Date:   Mon, 24 Aug 2020 13:39:37 +0200
Message-Id: <20200824113941.25423-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200824113941.25423-1-pablo@netfilter.org>
References: <20200824113941.25423-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

Checks for partial overlaps on insertion assume that end elements
are always descendant nodes of their corresponding start, because
they are inserted later. However, this is not the case if a
previous delete operation caused a tree rotation as part of
rebalancing.

Taking the issue reported by Andreas Fischer as an example, if we
omit delete operations, the existing procedure works because,
equivalently, we are inserting a start item with value 40 in the
this region of the red-black tree with single-sized intervals:

                                  overlap flag
                   10 (start)
                  /  \            false
                      20 (start)
                     /  \         false
                         30 (start)
                        /  \      false
                            60 (start)
                           /  \   false
                         50 (end)
                        /  \      false
                      20 (end)
                     /  \         false
                         40 (start)

if we now delete interval 30 - 30, the tree can be rearranged in
a way similar to this (note the rotation involving 50 - 50):

                                  overlap flag
                   10 (start)
                  /  \            false
                      20 (start)
                     /  \         false
                         25 (start)
                        /  \      false
                            70 (start)
                           /  \   false
                         50 (end)
                        /  \      true (from rule a1.)
                      50 (start)
                     /  \         true
                   40 (start)

and we traverse interval 50 - 50 from the opposite direction
compared to what was expected.

To deal with those cases, add a start-before-start rule, b4.,
that covers traversal of existing intervals from the right.

We now need to restrict start-after-end rule b3. to cases
where there are no occurring nodes between existing start and
end elements, because addition of rule b4. isn't sufficient to
ensure that the pre-existing end element we encounter while
descending the tree corresponds to a start element of an
interval that we already traversed entirely.

Different types of overlap detection on trees with rotations
resulting from re-balancing will be covered by nft test case
sets/0044interval_overlap_1.

Reported-by: Andreas Fischer <netfilter@d9c.eu>
Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1449
Cc: <stable@vger.kernel.org> # 5.6.x
Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 4b2834fd17b2..27668f4e44ea 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -238,21 +238,27 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 *
 	 * b1. _ _ __>|  !_ _ __|  (insert end before existing start)
 	 * b2. _ _ ___|  !_ _ _>|  (insert end after existing start)
-	 * b3. _ _ ___! >|_ _ __|  (insert start after existing end)
+	 * b3. _ _ ___! >|_ _ __|  (insert start after existing end, as a leaf)
+	 *            '--' no nodes falling in this range
+	 * b4.          >|_ _   !  (insert start before existing start)
 	 *
 	 * Case a3. resolves to b3.:
 	 * - if the inserted start element is the leftmost, because the '0'
 	 *   element in the tree serves as end element
-	 * - otherwise, if an existing end is found. Note that end elements are
-	 *   always inserted after corresponding start elements.
+	 * - otherwise, if an existing end is found immediately to the left. If
+	 *   there are existing nodes in between, we need to further descend the
+	 *   tree before we can conclude the new start isn't causing an overlap
+	 *
+	 * or to b4., which, preceded by a3., means we already traversed one or
+	 * more existing intervals entirely, from the right.
 	 *
 	 * For a new, rightmost pair of elements, we'll hit cases b3. and b2.,
 	 * in that order.
 	 *
 	 * The flag is also cleared in two special cases:
 	 *
-	 * b4. |__ _ _!|<_ _ _   (insert start right before existing end)
-	 * b5. |__ _ >|!__ _ _   (insert end right after existing start)
+	 * b5. |__ _ _!|<_ _ _   (insert start right before existing end)
+	 * b6. |__ _ >|!__ _ _   (insert end right after existing start)
 	 *
 	 * which always happen as last step and imply that no further
 	 * overlapping is possible.
@@ -272,7 +278,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			if (nft_rbtree_interval_start(new)) {
 				if (nft_rbtree_interval_end(rbe) &&
 				    nft_set_elem_active(&rbe->ext, genmask) &&
-				    !nft_set_elem_expired(&rbe->ext))
+				    !nft_set_elem_expired(&rbe->ext) && !*p)
 					overlap = false;
 			} else {
 				overlap = nft_rbtree_interval_end(rbe) &&
@@ -288,10 +294,9 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 					  nft_set_elem_active(&rbe->ext,
 							      genmask) &&
 					  !nft_set_elem_expired(&rbe->ext);
-			} else if (nft_rbtree_interval_end(rbe) &&
-				   nft_set_elem_active(&rbe->ext, genmask) &&
+			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
 				   !nft_set_elem_expired(&rbe->ext)) {
-				overlap = true;
+				overlap = nft_rbtree_interval_end(rbe);
 			}
 		} else {
 			if (nft_rbtree_interval_end(rbe) &&
-- 
2.20.1

