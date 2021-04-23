Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3869368EA8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 10:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241470AbhDWIO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 04:14:59 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:50552 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241147AbhDWIOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 04:14:54 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id C9AD680005A;
        Fri, 23 Apr 2021 10:14:17 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 10:14:17 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 23 Apr
 2021 10:14:17 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 453D831805B6; Fri, 23 Apr 2021 10:14:16 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/4] xfrm: avoid synchronize_rcu during netns destruction
Date:   Fri, 23 Apr 2021 10:14:08 +0200
Message-ID: <20210423081409.729557-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210423081409.729557-1-steffen.klassert@secunet.com>
References: <20210423081409.729557-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Use the new exit_pre hook to NULL the netlink socket.
The net namespace core will do a synchronize_rcu() between the exit_pre
and exit/exit_batch handlers.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_user.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index df8bc8fc724c..f0aecee4d539 100644
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
2.25.1

