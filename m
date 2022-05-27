Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5712535D42
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348443AbiE0JUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiE0JUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:20:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAC977A455;
        Fri, 27 May 2022 02:20:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 1/4] netfilter: nfnetlink: fix warn in nfnetlink_unbind
Date:   Fri, 27 May 2022 11:20:20 +0200
Message-Id: <20220527092023.327441-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220527092023.327441-1-pablo@netfilter.org>
References: <20220527092023.327441-1-pablo@netfilter.org>
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

syzbot reports following warn:
WARNING: CPU: 0 PID: 3600 at net/netfilter/nfnetlink.c:703 nfnetlink_unbind+0x357/0x3b0 net/netfilter/nfnetlink.c:694

The syzbot generated program does this:

socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER) = 3
setsockopt(3, SOL_NETLINK, NETLINK_DROP_MEMBERSHIP, [1], 4) = 0

... which triggers 'WARN_ON_ONCE(nfnlnet->ctnetlink_listeners == 0)' check.

Instead of counting, just enable reporting for every bind request
and check if we still have listeners on unbind.

While at it, also add the needed bounds check on nfnl_group2type[]
access.

Reported-by: <syzbot+4903218f7fba0a2d6226@syzkaller.appspotmail.com>
Reported-by: <syzbot+afd2d80e495f96049571@syzkaller.appspotmail.com>
Fixes: 2794cdb0b97b ("netfilter: nfnetlink: allow to detect if ctnetlink listeners exist")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index ad3bbe34ca88..2f7c477fc9e7 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -45,7 +45,6 @@ MODULE_DESCRIPTION("Netfilter messages via netlink socket");
 static unsigned int nfnetlink_pernet_id __read_mostly;
 
 struct nfnl_net {
-	unsigned int ctnetlink_listeners;
 	struct sock *nfnl;
 };
 
@@ -673,18 +672,8 @@ static int nfnetlink_bind(struct net *net, int group)
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	if (type == NFNL_SUBSYS_CTNETLINK) {
-		struct nfnl_net *nfnlnet = nfnl_pernet(net);
-
 		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
-
-		if (WARN_ON_ONCE(nfnlnet->ctnetlink_listeners == UINT_MAX)) {
-			nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
-			return -EOVERFLOW;
-		}
-
-		nfnlnet->ctnetlink_listeners++;
-		if (nfnlnet->ctnetlink_listeners == 1)
-			WRITE_ONCE(net->ct.ctnetlink_has_listener, true);
+		WRITE_ONCE(net->ct.ctnetlink_has_listener, true);
 		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
 	}
 #endif
@@ -694,15 +683,12 @@ static int nfnetlink_bind(struct net *net, int group)
 static void nfnetlink_unbind(struct net *net, int group)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	int type = nfnl_group2type[group];
-
-	if (type == NFNL_SUBSYS_CTNETLINK) {
-		struct nfnl_net *nfnlnet = nfnl_pernet(net);
+	if (group <= NFNLGRP_NONE || group > NFNLGRP_MAX)
+		return;
 
+	if (nfnl_group2type[group] == NFNL_SUBSYS_CTNETLINK) {
 		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
-		WARN_ON_ONCE(nfnlnet->ctnetlink_listeners == 0);
-		nfnlnet->ctnetlink_listeners--;
-		if (nfnlnet->ctnetlink_listeners == 0)
+		if (!nfnetlink_has_listeners(net, group))
 			WRITE_ONCE(net->ct.ctnetlink_has_listener, false);
 		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
 	}
-- 
2.30.2

