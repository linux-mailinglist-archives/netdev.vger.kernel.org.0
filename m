Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19CF12B78E
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbfL0RuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:50:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:42350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728393AbfL0RoS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B192222C2;
        Fri, 27 Dec 2019 17:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468657;
        bh=85mxCa5KdB1OA4pYkAMhRlSfScvPXqcsNuof4Jqh048=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TeXz8Kfgpu9ydpDJqf3n116U8myZGxkhJo7oN/5fZzs04h0Zs9QjOrIWul1K2dob7
         1XlZV75xVbltbOKnC4BOGJSksmH+APad1usYPTE1RwsiVT2Y3WBibf7/BjpBxqtpVp
         6NMgaNMw12KXeIjJ8R4Gc3MSWT/0xAHwsJCZGooA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 19/84] netfilter: nft_set_rbtree: bogus lookup/get on consecutive elements in named sets
Date:   Fri, 27 Dec 2019 12:42:47 -0500
Message-Id: <20191227174352.6264-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit db3b665dd77b34e34df00e17d7b299c98fcfb2c5 ]

The existing rbtree implementation might store consecutive elements
where the closing element and the opening element might overlap, eg.

	[ a, a+1) [ a+1, a+2)

This patch removes the optimization for non-anonymous sets in the exact
matching case, where it is assumed to stop searching in case that the
closing element is found. Instead, invalidate candidate interval and
keep looking further in the tree.

The lookup/get operation might return false, while there is an element
in the rbtree. Moreover, the get operation returns true as if a+2 would
be in the tree. This happens with named sets after several set updates.

The existing lookup optimization (that only works for the anonymous
sets) might not reach the opening [ a+1,... element if the closing
...,a+1) is found in first place when walking over the rbtree. Hence,
walking the full tree in that case is needed.

This patch fixes the lookup and get operations.

Fixes: e701001e7cbe ("netfilter: nft_rbtree: allow adjacent intervals with dynamic updates")
Fixes: ba0e4d9917b4 ("netfilter: nf_tables: get set elements via netlink")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index b3e75f9cb686..0221510328d4 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -77,8 +77,13 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 				parent = rcu_dereference_raw(parent->rb_left);
 				continue;
 			}
-			if (nft_rbtree_interval_end(rbe))
-				goto out;
+			if (nft_rbtree_interval_end(rbe)) {
+				if (nft_set_is_anonymous(set))
+					return false;
+				parent = rcu_dereference_raw(parent->rb_left);
+				interval = NULL;
+				continue;
+			}
 
 			*ext = &rbe->ext;
 			return true;
@@ -91,7 +96,7 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
 		*ext = &interval->ext;
 		return true;
 	}
-out:
+
 	return false;
 }
 
@@ -139,8 +144,10 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 		} else if (d > 0) {
 			parent = rcu_dereference_raw(parent->rb_right);
 		} else {
-			if (!nft_set_elem_active(&rbe->ext, genmask))
+			if (!nft_set_elem_active(&rbe->ext, genmask)) {
 				parent = rcu_dereference_raw(parent->rb_left);
+				continue;
+			}
 
 			if (!nft_set_ext_exists(&rbe->ext, NFT_SET_EXT_FLAGS) ||
 			    (*nft_set_ext_flags(&rbe->ext) & NFT_SET_ELEM_INTERVAL_END) ==
@@ -148,7 +155,11 @@ static bool __nft_rbtree_get(const struct net *net, const struct nft_set *set,
 				*elem = rbe;
 				return true;
 			}
-			return false;
+
+			if (nft_rbtree_interval_end(rbe))
+				interval = NULL;
+
+			parent = rcu_dereference_raw(parent->rb_left);
 		}
 	}
 
-- 
2.20.1

