Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53006B6FD0
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjCMHBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjCMHBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:01:53 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AED302A4;
        Mon, 13 Mar 2023 00:01:52 -0700 (PDT)
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 32D7107A005037-32D7107D005037
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 13 Mar 2023 15:01:05 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wifi: ray_cs: remove one redundant del_timer
Date:   Mon, 13 Mar 2023 14:58:22 +0800
Message-Id: <20230313065823.256731-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.39.2
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
 drivers/net/wireless/ray_cs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 1f57a0055bbd..785a5be72b2b 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -331,9 +331,6 @@ static void ray_detach(struct pcmcia_device *link)
 
 	ray_release(link);
 
-	local = netdev_priv(dev);
-	del_timer_sync(&local->timer);
-
 	if (link->priv) {
 		unregister_netdev(dev);
 		free_netdev(dev);
@@ -734,7 +731,7 @@ static void ray_release(struct pcmcia_device *link)
 
 	dev_dbg(&link->dev, "ray_release\n");
 
-	del_timer(&local->timer);
+	del_timer_sync(&local->timer);
 
 	iounmap(local->sram);
 	iounmap(local->rmem);
-- 
2.39.2

