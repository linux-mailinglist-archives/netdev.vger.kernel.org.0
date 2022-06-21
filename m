Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A35552DB4
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348453AbiFUI4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347109AbiFUI4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:56:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E03E26AC0;
        Tue, 21 Jun 2022 01:56:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 2/5] netfilter: cttimeout: fix slab-out-of-bounds read typo in cttimeout_net_exit
Date:   Tue, 21 Jun 2022 10:56:15 +0200
Message-Id: <20220621085618.3975-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220621085618.3975-1-pablo@netfilter.org>
References: <20220621085618.3975-1-pablo@netfilter.org>
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

syzbot reports:
  BUG: KASAN: slab-out-of-bounds in __list_del_entry_valid+0xcc/0xf0 lib/list_debug.c:42
  [..]
  list_del include/linux/list.h:148 [inline]
  cttimeout_net_exit+0x211/0x540 net/netfilter/nfnetlink_cttimeout.c:617

Problem is the wrong name of the list member, so container_of() result is wrong.

Reported-by: <syzbot+92968395eedbdbd3617d@syzkaller.appspotmail.com>
Fixes: 78222bacfca9 ("netfilter: cttimeout: decouple unlink and free on netns destruction")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_cttimeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index af15102bc696..f466af4f8531 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -614,7 +614,7 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 
 	nf_ct_untimeout(net, NULL);
 
-	list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_freelist, head) {
+	list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_freelist, free_head) {
 		list_del(&cur->free_head);
 
 		if (refcount_dec_and_test(&cur->refcnt))
-- 
2.30.2

