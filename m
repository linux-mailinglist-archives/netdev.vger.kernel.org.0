Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAD3560719
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiF2ROB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiF2ROB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:14:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B9A03B3EE;
        Wed, 29 Jun 2022 10:14:00 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/3] netfilter: nft_dynset: restore set element counter when failing to update
Date:   Wed, 29 Jun 2022 19:13:52 +0200
Message-Id: <20220629171354.208773-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220629171354.208773-1-pablo@netfilter.org>
References: <20220629171354.208773-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a race condition.

nft_rhash_update() might fail for two reasons:

- Element already exists in the hashtable.
- Another packet won race to insert an entry in the hashtable.

In both cases, new() has already bumped the counter via atomic_add_unless(),
therefore, decrement the set element counter.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index df40314de21f..76de6c8d9865 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -143,6 +143,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 	/* Another cpu may race to insert the element with the same key */
 	if (prev) {
 		nft_set_elem_destroy(set, he, true);
+		atomic_dec(&set->nelems);
 		he = prev;
 	}
 
@@ -152,6 +153,7 @@ static bool nft_rhash_update(struct nft_set *set, const u32 *key,
 
 err2:
 	nft_set_elem_destroy(set, he, true);
+	atomic_dec(&set->nelems);
 err1:
 	return false;
 }
-- 
2.30.2

