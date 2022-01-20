Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209C6494E58
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244543AbiATMw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:52:26 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38724 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbiATMwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 07:52:20 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 06FFC60799;
        Thu, 20 Jan 2022 13:49:20 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/5] netfilter: nf_tables: set last expression in register tracking area
Date:   Thu, 20 Jan 2022 13:52:10 +0100
Message-Id: <20220120125212.991271-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120125212.991271-1-pablo@netfilter.org>
References: <20220120125212.991271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nft_rule_for_each_expr() sets on last to nft_rule_last(), however, this
is coming after track.last field is set on.

Use nft_expr_last() to set track.last accordingly.

Fixes: 12e4ecfa244b ("netfilter: nf_tables: add register tracking infrastructure")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1cde8cd0d1a7..cf454f8ca2b0 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8299,7 +8299,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 			return -ENOMEM;
 
 		size = 0;
-		track.last = last;
+		track.last = nft_expr_last(rule);
 		nft_rule_for_each_expr(expr, last, rule) {
 			track.cur = expr;
 
-- 
2.30.2

