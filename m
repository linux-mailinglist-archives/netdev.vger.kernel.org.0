Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4968869AB8F
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjBQMa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjBQMaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:30:11 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71B8467833;
        Fri, 17 Feb 2023 04:30:05 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 2/6] netfilter: nf_tables: fix wrong pointer passed to PTR_ERR()
Date:   Fri, 17 Feb 2023 13:29:53 +0100
Message-Id: <20230217122957.799277-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230217122957.799277-1-pablo@netfilter.org>
References: <20230217122957.799277-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

It should be 'chain' passed to PTR_ERR() in the error path
after calling nft_chain_lookup() in nf_tables_delrule().

Fixes: f80a612dd77c ("netfilter: nf_tables: add support to destroy operation")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2abf473c8f67..d73edbd4eec4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3724,7 +3724,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN],
 					 genmask);
 		if (IS_ERR(chain)) {
-			if (PTR_ERR(rule) == -ENOENT &&
+			if (PTR_ERR(chain) == -ENOENT &&
 			    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
 				return 0;
 
-- 
2.30.2

