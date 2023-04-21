Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B486EB5DC
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbjDUXuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbjDUXua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:50:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DC322129;
        Fri, 21 Apr 2023 16:50:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 04/19] netfilter: nf_tables: don't write table validation state without mutex
Date:   Sat, 22 Apr 2023 01:50:06 +0200
Message-Id: <20230421235021.216950-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421235021.216950-1-pablo@netfilter.org>
References: <20230421235021.216950-1-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

The ->cleanup callback needs to be removed, this doesn't work anymore as
the transaction mutex is already released in the ->abort function.

Just do it after a successful validation pass, this either happens
from commit or abort phases where transaction mutex is held.

Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink.h | 1 -
 net/netfilter/nf_tables_api.c       | 8 ++------
 net/netfilter/nfnetlink.c           | 2 --
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 241e005f290a..e9a9ab34a7cc 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -45,7 +45,6 @@ struct nfnetlink_subsystem {
 	int (*commit)(struct net *net, struct sk_buff *skb);
 	int (*abort)(struct net *net, struct sk_buff *skb,
 		     enum nfnl_abort_action action);
-	void (*cleanup)(struct net *net);
 	bool (*valid_genid)(struct net *net, u32 genid);
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0e1c86bb51a2..21eb273d2740 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8639,6 +8639,8 @@ static int nf_tables_validate(struct net *net)
 			if (nft_table_validate(net, table) < 0)
 				return -EAGAIN;
 		}
+
+		nft_validate_state_update(net, NFT_VALIDATE_SKIP);
 		break;
 	}
 
@@ -9578,11 +9580,6 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	return 0;
 }
 
-static void nf_tables_cleanup(struct net *net)
-{
-	nft_validate_state_update(net, NFT_VALIDATE_SKIP);
-}
-
 static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 			   enum nfnl_abort_action action)
 {
@@ -9616,7 +9613,6 @@ static const struct nfnetlink_subsystem nf_tables_subsys = {
 	.cb		= nf_tables_cb,
 	.commit		= nf_tables_commit,
 	.abort		= nf_tables_abort,
-	.cleanup	= nf_tables_cleanup,
 	.valid_genid	= nf_tables_valid_genid,
 	.owner		= THIS_MODULE,
 };
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 81c7737c803a..ae7146475d17 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -590,8 +590,6 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			goto replay_abort;
 		}
 	}
-	if (ss->cleanup)
-		ss->cleanup(net);
 
 	nfnl_err_deliver(&err_list, oskb);
 	kfree_skb(skb);
-- 
2.30.2

