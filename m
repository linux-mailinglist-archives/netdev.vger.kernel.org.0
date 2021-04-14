Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2316535F8CD
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351600AbhDNQNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351591AbhDNQNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 12:13:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E76C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 09:13:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lWi8g-0005rm-Uc; Wed, 14 Apr 2021 18:13:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net, kuba@kernel.org,
        herbert@gondor.apana.org.au, Florian Westphal <fw@strlen.de>
Subject: [PATCH ipsec-next 3/3] xfrm: avoid synchronize_rcu during netns destruction
Date:   Wed, 14 Apr 2021 18:12:53 +0200
Message-Id: <20210414161253.27586-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210414161253.27586-1-fw@strlen.de>
References: <20210414161253.27586-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new exit_pre hook to NULL the netlink socket.
The net namespace core will do a synchronize_rcu() between the exit_pre
and exit/exit_batch handlers.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/xfrm/xfrm_user.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 5a0ef4361e43..9313592fa01f 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3480,18 +3480,22 @@ static int __net_init xfrm_user_net_init(struct net *net)
 	return 0;
 }
 
+static void __net_exit xfrm_user_net_pre_exit(struct net *net)
+{
+	RCU_INIT_POINTER(net->xfrm.nlsk, NULL);
+}
+
 static void __net_exit xfrm_user_net_exit(struct list_head *net_exit_list)
 {
 	struct net *net;
-	list_for_each_entry(net, net_exit_list, exit_list)
-		RCU_INIT_POINTER(net->xfrm.nlsk, NULL);
-	synchronize_net();
+
 	list_for_each_entry(net, net_exit_list, exit_list)
 		netlink_kernel_release(net->xfrm.nlsk_stash);
 }
 
 static struct pernet_operations xfrm_user_net_ops = {
 	.init	    = xfrm_user_net_init,
+	.pre_exit   = xfrm_user_net_pre_exit,
 	.exit_batch = xfrm_user_net_exit,
 };
 
-- 
2.26.3

