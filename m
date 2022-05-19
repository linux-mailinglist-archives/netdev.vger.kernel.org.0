Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB6E52DFC6
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 00:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245402AbiESWCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 18:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242204AbiESWCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 18:02:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC773F68BC;
        Thu, 19 May 2022 15:02:19 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net-next 10/11] netfilter: cttimeout: fix slab-out-of-bounds read in cttimeout_net_exit
Date:   Fri, 20 May 2022 00:02:05 +0200
Message-Id: <20220519220206.722153-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220519220206.722153-1-pablo@netfilter.org>
References: <20220519220206.722153-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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

No reproducer so far. Looking at recent changes in this area
its clear that the free_head must not be at the end of the
structure because nf_ct_timeout structure has variable size.

Reported-by: <syzbot+92968395eedbdbd3617d@syzkaller.appspotmail.com>
Fixes: 78222bacfca9 ("netfilter: cttimeout: decouple unlink and free on netns destruction")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index f069c24c6146..af15102bc696 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -35,12 +35,13 @@ static unsigned int nfct_timeout_id __read_mostly;
 
 struct ctnl_timeout {
 	struct list_head	head;
+	struct list_head	free_head;
 	struct rcu_head		rcu_head;
 	refcount_t		refcnt;
 	char			name[CTNL_TIMEOUT_NAME_MAX];
-	struct nf_ct_timeout	timeout;
 
-	struct list_head	free_head;
+	/* must be at the end */
+	struct nf_ct_timeout	timeout;
 };
 
 struct nfct_timeout_pernet {
-- 
2.30.2

