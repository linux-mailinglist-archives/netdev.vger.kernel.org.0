Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329E06BD0F2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjCPNgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjCPNgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:36:07 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C127A8EA37;
        Thu, 16 Mar 2023 06:36:01 -0700 (PDT)
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 32GDZEVW013709-32GDZEVb013709
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 16 Mar 2023 21:35:22 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] wifi: ray_cs: add sanity check on local->sram/rmem/amem
Date:   Thu, 16 Mar 2023 21:32:36 +0800
Message-Id: <20230316133236.556198-3-dzm91@hust.edu.cn>
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

The ray_config uses ray_release as its unified error handling function.
However, it does not know if local->sram/rmem/amem succeeds or not.

Fix this by adding sanity check on local->sram/rmem/amem in the
ray_relase.

Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
---
 drivers/net/wireless/ray_cs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index ce7911137014..808b37352f39 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -732,9 +732,12 @@ static void ray_release(struct pcmcia_device *link)
 
 	del_timer_sync(&local->timer);
 
-	iounmap(local->sram);
-	iounmap(local->rmem);
-	iounmap(local->amem);
+	if (local->sram)
+		iounmap(local->sram);
+	if (local->rmem)
+		iounmap(local->rmem);
+	if (local->amem)
+		iounmap(local->amem);
 	pcmcia_disable_device(link);
 
 	dev_dbg(&link->dev, "ray_release ending\n");
-- 
2.39.2

