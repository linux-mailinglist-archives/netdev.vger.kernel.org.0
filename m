Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA9C4FB992
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345475AbiDKKaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiDKKaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:30:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C9C42B258;
        Mon, 11 Apr 2022 03:27:50 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CD0E1625E1;
        Mon, 11 Apr 2022 12:23:48 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 01/11] netfilter: nf_tables: replace unnecessary use of list_for_each_entry_continue()
Date:   Mon, 11 Apr 2022 12:27:34 +0200
Message-Id: <20220411102744.282101-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220411102744.282101-1-pablo@netfilter.org>
References: <20220411102744.282101-1-pablo@netfilter.org>
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

From: Jakob Koschel <jakobkoschel@gmail.com>

Since there is no way for list_for_each_entry_continue() to start
interating in the middle of the list they can be replaced with a call
to list_for_each_entry().

In preparation to limit the scope of the list iterator to the list
traversal loop, the list iterator variable 'rule' should not be used
past the loop.

v1->v2:
- also replace first usage of list_for_each_entry_continue() (Florian
Westphal)

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5ddfdb2adaf1..060aa56e54d9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8367,10 +8367,8 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	if (chain->blob_next || !nft_is_active_next(net, chain))
 		return 0;
 
-	rule = list_entry(&chain->rules, struct nft_rule, list);
-
 	data_size = 0;
-	list_for_each_entry_continue(rule, &chain->rules, list) {
+	list_for_each_entry(rule, &chain->rules, list) {
 		if (nft_is_active_next(net, rule)) {
 			data_size += sizeof(*prule) + rule->dlen;
 			if (data_size > INT_MAX)
@@ -8387,7 +8385,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	data_boundary = data + data_size;
 	size = 0;
 
-	list_for_each_entry_continue(rule, &chain->rules, list) {
+	list_for_each_entry(rule, &chain->rules, list) {
 		if (!nft_is_active_next(net, rule))
 			continue;
 
-- 
2.30.2

