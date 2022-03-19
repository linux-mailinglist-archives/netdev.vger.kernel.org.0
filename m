Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06A84DE6CB
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 08:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242403AbiCSHoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 03:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiCSHoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 03:44:09 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1382D2597
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 00:42:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id F1BE5205E3;
        Sat, 19 Mar 2022 08:42:45 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id srrdLhMn-SUv; Sat, 19 Mar 2022 08:42:45 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 33C7120638;
        Sat, 19 Mar 2022 08:42:45 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 2584080004A;
        Sat, 19 Mar 2022 08:42:45 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 19 Mar 2022 08:42:45 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sat, 19 Mar
 2022 08:42:44 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 4CDFC3180146; Sat, 19 Mar 2022 08:42:44 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/2] xfrm: delete duplicated functions that calls same xfrm_api_check()
Date:   Sat, 19 Mar 2022 08:42:39 +0100
Message-ID: <20220319074240.554227-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220319074240.554227-1-steffen.klassert@secunet.com>
References: <20220319074240.554227-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The xfrm_dev_register() and xfrm_dev_feat_change() have same
implementation of one call to xfrm_api_check(). Instead of doing such
indirection, call to xfrm_api_check() directly and delete duplicated
functions.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_device.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 3fa066419d37..36d6c1835844 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -380,16 +380,6 @@ static int xfrm_api_check(struct net_device *dev)
 	return NOTIFY_DONE;
 }
 
-static int xfrm_dev_register(struct net_device *dev)
-{
-	return xfrm_api_check(dev);
-}
-
-static int xfrm_dev_feat_change(struct net_device *dev)
-{
-	return xfrm_api_check(dev);
-}
-
 static int xfrm_dev_down(struct net_device *dev)
 {
 	if (dev->features & NETIF_F_HW_ESP)
@@ -404,10 +394,10 @@ static int xfrm_dev_event(struct notifier_block *this, unsigned long event, void
 
 	switch (event) {
 	case NETDEV_REGISTER:
-		return xfrm_dev_register(dev);
+		return xfrm_api_check(dev);
 
 	case NETDEV_FEAT_CHANGE:
-		return xfrm_dev_feat_change(dev);
+		return xfrm_api_check(dev);
 
 	case NETDEV_DOWN:
 	case NETDEV_UNREGISTER:
-- 
2.25.1

