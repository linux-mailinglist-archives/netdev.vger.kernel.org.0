Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B998C1E7A9A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 12:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgE2KaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 06:30:21 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37558 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2KaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 06:30:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 12C3C205AA;
        Fri, 29 May 2020 12:30:19 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hjISyhPsBJvY; Fri, 29 May 2020 12:30:18 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9F1A72054D;
        Fri, 29 May 2020 12:30:18 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 29 May 2020 12:30:18 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 29 May
 2020 12:30:18 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E48C7318009D;
 Fri, 29 May 2020 12:30:17 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 01/11] xfrm interface: don't take extra reference to netdev
Date:   Fri, 29 May 2020 12:30:01 +0200
Message-ID: <20200529103011.30127-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529103011.30127-1-steffen.klassert@secunet.com>
References: <20200529103011.30127-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

I don't see any reason to do this. Maybe needed before
commit 56c5ee1a5823 ("xfrm interface: fix memory leak on creation").

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 3361e3ac5714..eb9928c0a87c 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -145,7 +145,6 @@ static int xfrmi_create(struct net_device *dev)
 	if (err < 0)
 		goto out;
 
-	dev_hold(dev);
 	xfrmi_link(xfrmn, xi);
 
 	return 0;
@@ -175,7 +174,6 @@ static void xfrmi_dev_uninit(struct net_device *dev)
 	struct xfrmi_net *xfrmn = net_generic(xi->net, xfrmi_net_id);
 
 	xfrmi_unlink(xfrmn, xi);
-	dev_put(dev);
 }
 
 static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
-- 
2.17.1

