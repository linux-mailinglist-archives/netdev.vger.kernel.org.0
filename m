Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757CC2601CE
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731220AbgIGRMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730621AbgIGQc3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:32:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7A6520757;
        Mon,  7 Sep 2020 16:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496348;
        bh=g9SHDM3H2JEOEEdifkFbeSNLr4gOLGNQG+IjRWov03Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZWQweq7AiT9GhSpqgD0NkB8pGl3Xi5XBo8BM6+lbzPWlSGRH5Wt5wJYnaPA5CWTr
         MHYhEPT+Si/xkkamRvJqdot1F0uoRL9+OkShFf9LpjDly+ged6pUOIjn0ZSzYKmWDH
         Dbr8RXM7UFqx5AVEvbsiNljF4mEyrvZPH0nb8Xes=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 06/53] netfilter: nft_set_rbtree: Detect partial overlap with start endpoint match
Date:   Mon,  7 Sep 2020 12:31:32 -0400
Message-Id: <20200907163220.1280412-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 0726763043dc10dd4c12481f050b1a5ef8f15410 ]

Getting creative with nft and omitting the interval_overlap()
check from the set_overlap() function, without omitting
set_overlap() altogether, led to the observation of a partial
overlap that wasn't detected, and would actually result in
replacement of the end element of an existing interval.

This is due to the fact that we'll return -EEXIST on a matching,
pre-existing start element, instead of -ENOTEMPTY, and the error
is cleared by API if NLM_F_EXCL is not given. At this point, we
can insert a matching start, and duplicate the end element as long
as we don't end up into other intervals.

For instance, inserting interval 0 - 2 with an existing 0 - 3
interval would result in a single 0 - 2 interval, and a dangling
'3' end element. This is because nft will proceed after inserting
the '0' start element as no error is reported, and no further
conflicting intervals are detected on insertion of the end element.

This needs a different approach as it's a local condition that can
be detected by looking for duplicate ends coming from left and
right, separately. Track those and directly report -ENOTEMPTY on
duplicated end elements for a matching start.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index b85ce6f0c0a6f..f317ad80cd6bc 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -218,11 +218,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
 			       struct nft_set_ext **ext)
 {
+	bool overlap = false, dup_end_left = false, dup_end_right = false;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 genmask = nft_genmask_next(net);
 	struct nft_rbtree_elem *rbe;
 	struct rb_node *parent, **p;
-	bool overlap = false;
 	int d;
 
 	/* Detect overlaps as we descend the tree. Set the flag in these cases:
@@ -262,6 +262,20 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	 *
 	 * which always happen as last step and imply that no further
 	 * overlapping is possible.
+	 *
+	 * Another special case comes from the fact that start elements matching
+	 * an already existing start element are allowed: insertion is not
+	 * performed but we return -EEXIST in that case, and the error will be
+	 * cleared by the caller if NLM_F_EXCL is not present in the request.
+	 * This way, request for insertion of an exact overlap isn't reported as
+	 * error to userspace if not desired.
+	 *
+	 * However, if the existing start matches a pre-existing start, but the
+	 * end element doesn't match the corresponding pre-existing end element,
+	 * we need to report a partial overlap. This is a local condition that
+	 * can be noticed without need for a tracking flag, by checking for a
+	 * local duplicated end for a corresponding start, from left and right,
+	 * separately.
 	 */
 
 	parent = NULL;
@@ -281,19 +295,35 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 				    !nft_set_elem_expired(&rbe->ext) && !*p)
 					overlap = false;
 			} else {
+				if (dup_end_left && !*p)
+					return -ENOTEMPTY;
+
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
 							      genmask) &&
 					  !nft_set_elem_expired(&rbe->ext);
+
+				if (overlap) {
+					dup_end_right = true;
+					continue;
+				}
 			}
 		} else if (d > 0) {
 			p = &parent->rb_right;
 
 			if (nft_rbtree_interval_end(new)) {
+				if (dup_end_right && !*p)
+					return -ENOTEMPTY;
+
 				overlap = nft_rbtree_interval_end(rbe) &&
 					  nft_set_elem_active(&rbe->ext,
 							      genmask) &&
 					  !nft_set_elem_expired(&rbe->ext);
+
+				if (overlap) {
+					dup_end_left = true;
+					continue;
+				}
 			} else if (nft_set_elem_active(&rbe->ext, genmask) &&
 				   !nft_set_elem_expired(&rbe->ext)) {
 				overlap = nft_rbtree_interval_end(rbe);
@@ -321,6 +351,8 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 				p = &parent->rb_left;
 			}
 		}
+
+		dup_end_left = dup_end_right = false;
 	}
 
 	if (overlap)
-- 
2.25.1

