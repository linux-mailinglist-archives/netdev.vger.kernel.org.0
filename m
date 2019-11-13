Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5033FFAFC8
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 12:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfKMLeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 06:34:07 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:50384 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfKMLeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 06:34:05 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 18A3F20591;
        Wed, 13 Nov 2019 12:34:04 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gb4KB7eRQXay; Wed, 13 Nov 2019 12:34:03 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A604D2058E;
        Wed, 13 Nov 2019 12:34:03 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 13 Nov 2019
 12:34:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A2335318017F;
 Wed, 13 Nov 2019 12:34:01 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/2] xfrm: remove the unnecessary .net_exit for xfrmi
Date:   Wed, 13 Nov 2019 12:33:57 +0100
Message-ID: <20191113113358.4740-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191113113358.4740-1-steffen.klassert@secunet.com>
References: <20191113113358.4740-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

The xfrm_if(s) on each netns can be deleted when its xfrmi dev is
deleted. xfrmi dev's removal can happen when:

  a. netns is being removed and all xfrmi devs will be deleted.

  b. rtnl_link_unregister(&xfrmi_link_ops) in xfrmi_fini() when
     xfrm_interface.ko is being unloaded.

So there's no need to use xfrmi_exit_net() to clean any xfrm_if up.

v1->v2:
  - Fix some changelog.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 2ab4859df55a..fb4d1f99b0a7 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -732,30 +732,7 @@ static struct rtnl_link_ops xfrmi_link_ops __read_mostly = {
 	.get_link_net	= xfrmi_get_link_net,
 };
 
-static void __net_exit xfrmi_destroy_interfaces(struct xfrmi_net *xfrmn)
-{
-	struct xfrm_if *xi;
-	LIST_HEAD(list);
-
-	xi = rtnl_dereference(xfrmn->xfrmi[0]);
-	if (!xi)
-		return;
-
-	unregister_netdevice_queue(xi->dev, &list);
-	unregister_netdevice_many(&list);
-}
-
-static void __net_exit xfrmi_exit_net(struct net *net)
-{
-	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
-
-	rtnl_lock();
-	xfrmi_destroy_interfaces(xfrmn);
-	rtnl_unlock();
-}
-
 static struct pernet_operations xfrmi_net_ops = {
-	.exit = xfrmi_exit_net,
 	.id   = &xfrmi_net_id,
 	.size = sizeof(struct xfrmi_net),
 };
-- 
2.17.1

