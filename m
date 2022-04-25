Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A89850DC5B
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiDYJVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241600AbiDYJTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:19:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35C08C64;
        Mon, 25 Apr 2022 02:16:37 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/4] netfilter: nft_set_rbtree: overlap detection with element re-addition after deletion
Date:   Mon, 25 Apr 2022 11:16:29 +0200
Message-Id: <20220425091631.109320-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220425091631.109320-1-pablo@netfilter.org>
References: <20220425091631.109320-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes spurious EEXIST errors.

Extend d2df92e98a34 ("netfilter: nft_set_rbtree: handle element
re-addition after deletion") to deal with elements with same end flags
in the same transation.

Reset the overlap flag as described by 7c84d41416d8 ("netfilter:
nft_set_rbtree: Detect partial overlaps on insertion").

Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Fixes: d2df92e98a34 ("netfilter: nft_set_rbtree: handle element re-addition after deletion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index d600a566da32..7325bee7d144 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -349,7 +349,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 				*ext = &rbe->ext;
 				return -EEXIST;
 			} else {
-				p = &parent->rb_left;
+				overlap = false;
+				if (nft_rbtree_interval_end(rbe))
+					p = &parent->rb_left;
+				else
+					p = &parent->rb_right;
 			}
 		}
 
-- 
2.30.2

