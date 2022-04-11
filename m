Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666924FB99E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345501AbiDKKaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiDKKaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:30:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3AA8A3DDE7;
        Mon, 11 Apr 2022 03:27:52 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id D3E4163032;
        Mon, 11 Apr 2022 12:23:50 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/11] netfilter: cttimeout: inc/dec module refcount per object, not per use refcount
Date:   Mon, 11 Apr 2022 12:27:37 +0200
Message-Id: <20220411102744.282101-5-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

There is no need to increment the module refcount again, its enough to
obtain one reference per object, i.e. take a reference on object
creation and put it on object destruction.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index b0d8888a539b..eea486f32971 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -158,6 +158,7 @@ static int cttimeout_new_timeout(struct sk_buff *skb,
 	timeout->timeout.l3num = l3num;
 	timeout->timeout.l4proto = l4proto;
 	refcount_set(&timeout->refcnt, 1);
+	__module_get(THIS_MODULE);
 	list_add_tail_rcu(&timeout->head, &pernet->nfct_timeout_list);
 
 	return 0;
@@ -506,13 +507,8 @@ static struct nf_ct_timeout *ctnl_timeout_find_get(struct net *net,
 		if (strncmp(timeout->name, name, CTNL_TIMEOUT_NAME_MAX) != 0)
 			continue;
 
-		if (!try_module_get(THIS_MODULE))
+		if (!refcount_inc_not_zero(&timeout->refcnt))
 			goto err;
-
-		if (!refcount_inc_not_zero(&timeout->refcnt)) {
-			module_put(THIS_MODULE);
-			goto err;
-		}
 		matching = timeout;
 		break;
 	}
@@ -525,10 +521,10 @@ static void ctnl_timeout_put(struct nf_ct_timeout *t)
 	struct ctnl_timeout *timeout =
 		container_of(t, struct ctnl_timeout, timeout);
 
-	if (refcount_dec_and_test(&timeout->refcnt))
+	if (refcount_dec_and_test(&timeout->refcnt)) {
 		kfree_rcu(timeout, rcu_head);
-
-	module_put(THIS_MODULE);
+		module_put(THIS_MODULE);
+	}
 }
 
 static const struct nfnl_callback cttimeout_cb[IPCTNL_MSG_TIMEOUT_MAX] = {
-- 
2.30.2

