Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E4364DEC9
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiLOQj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLOQj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:39:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D764D20F50;
        Thu, 15 Dec 2022 08:39:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91A67B81C0F;
        Thu, 15 Dec 2022 16:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD6EC433EF;
        Thu, 15 Dec 2022 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671122363;
        bh=2OPO4m4zGufDKQ8laFBnT5+ykmpwqmAwuJDyZQqQLAs=;
        h=From:To:Cc:Subject:Date:From;
        b=cB66ibYY5YG+vvmy4HAotIH2AcVlI5B87zecW1Ia36abgl+C2N+RQx7qZEkLjp5Q9
         /uvyeOsuCc5grEphZqY1uC6uBCxqFAszRqpB7cwZvq2wNO/jrrJofbqxeWk5e1Ciil
         kAZzIsNrupTaJJVRMZvw32WMlLZ5SJJfi6nX/99PuOKBTqo76kaQGudWeSRbO0FK9o
         n6f9+YlPJXYiJjdr1SvE1OiXvZ4cJoosoNQQPPUKeqv1Ggy0IuN3RQ3cZhKafw8MUq
         FLBvRCbBQGpnKJDclKd97FUN9lMAKWQbJR45QrzVTq6oPdpdFTVKkFo+fmkyfvJ2TX
         IvL7UqYa4H4Qw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Roger Quadros <rogerq@kernel.org>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: ti: am65-cpsw: fix CONFIG_PM #ifdef
Date:   Thu, 15 Dec 2022 17:39:05 +0100
Message-Id: <20221215163918.611609-1-arnd@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The #ifdef check is incorrect and leads to a warning:

drivers/net/ethernet/ti/am65-cpsw-nuss.c:1679:13: error: 'am65_cpsw_nuss_remove_rx_chns' defined but not used [-Werror=unused-function]
 1679 | static void am65_cpsw_nuss_remove_rx_chns(void *data)

It's better to remove the #ifdef here and use the modern
SYSTEM_SLEEP_PM_OPS() macro instead.

Fixes: 24bc19b05f1f ("net: ethernet: ti: am65-cpsw: Add suspend/resume support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 9decb0c7961b..ecbde83b5243 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2878,7 +2878,6 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int am65_cpsw_nuss_suspend(struct device *dev)
 {
 	struct am65_cpsw_common *common = dev_get_drvdata(dev);
@@ -2964,10 +2963,9 @@ static int am65_cpsw_nuss_resume(struct device *dev)
 
 	return 0;
 }
-#endif /* CONFIG_PM_SLEEP */
 
 static const struct dev_pm_ops am65_cpsw_nuss_dev_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(am65_cpsw_nuss_suspend, am65_cpsw_nuss_resume)
+	SYSTEM_SLEEP_PM_OPS(am65_cpsw_nuss_suspend, am65_cpsw_nuss_resume)
 };
 
 static struct platform_driver am65_cpsw_nuss_driver = {
-- 
2.35.1

