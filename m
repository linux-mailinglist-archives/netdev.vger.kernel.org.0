Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BEE6BD0F7
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjCPNhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjCPNho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:37:44 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34A597FDE;
        Thu, 16 Mar 2023 06:37:22 -0700 (PDT)
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 32GDZEVW013709-32GDZEVa013709
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 16 Mar 2023 21:35:20 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] wifi: ray_cs: remove one redundant del_timer
Date:   Thu, 16 Mar 2023 21:32:35 +0800
Message-Id: <20230316133236.556198-2-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316133236.556198-1-dzm91@hust.edu.cn>
References: <20230316133236.556198-1-dzm91@hust.edu.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ray_detach, it and its child function ray_release both call
del_timer(_sync) on the same timer.

Fix this by removing the del_timer_sync in the ray_detach, and revising
the del_timer to del_timer_sync.

Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
---
 drivers/net/wireless/ray_cs.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 1f57a0055bbd..ce7911137014 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -322,7 +322,6 @@ static int ray_probe(struct pcmcia_device *p_dev)
 static void ray_detach(struct pcmcia_device *link)
 {
 	struct net_device *dev;
-	ray_dev_t *local;
 
 	dev_dbg(&link->dev, "ray_detach\n");
 
@@ -331,9 +330,6 @@ static void ray_detach(struct pcmcia_device *link)
 
 	ray_release(link);
 
-	local = netdev_priv(dev);
-	del_timer_sync(&local->timer);
-
 	if (link->priv) {
 		unregister_netdev(dev);
 		free_netdev(dev);
@@ -734,7 +730,7 @@ static void ray_release(struct pcmcia_device *link)
 
 	dev_dbg(&link->dev, "ray_release\n");
 
-	del_timer(&local->timer);
+	del_timer_sync(&local->timer);
 
 	iounmap(local->sram);
 	iounmap(local->rmem);
-- 
2.39.2

