Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA8C64F8BF
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 11:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiLQKrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 05:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiLQKrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 05:47:42 -0500
X-Greylist: delayed 301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 17 Dec 2022 02:47:40 PST
Received: from mail-108-mta205.mxroute.com (mail-108-mta205.mxroute.com [136.175.108.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A90A10076
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 02:47:39 -0800 (PST)
Received: from mail-111-mta2.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta205.mxroute.com (ZoneMTA) with ESMTPSA id 1851fadb42f0001d7e.007
 for <netdev@vger.kernel.org>
 (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256);
 Sat, 17 Dec 2022 10:42:35 +0000
X-Zone-Loop: 0e4a4605631c313401ee2f11d540b85a73145c7942c2
X-Originating-IP: [136.175.111.2]
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=c8h4.io;
        s=x; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:
        From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
        References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
        List-Owner:List-Archive; bh=PvmwkN+BYUCQUQdJYFAdNwIAg6Wx6lg7uwVGd3w86p8=; b=c
        e2KTpl4ljuZzZwscxfRQsObKC9ppNfMaMr/Swx1cFAdzgIp8NBX4x61gBTdDXJvUGb42PeiMlKYmg
        eTFajhQD2A4HQNKEP/IevCe3iimpPtgebn7XhUfFiG3Vr3DqQyAliDuIqhIxhrlKUyGyPJdDdXvjX
        hWNOdXv7wQUg6LXNpB9bhIhw1s2cOkSr+bKD7YHG1Ljrd3G+jq5ftMq7QiEI2fGPHXm+8A6Ljx0k5
        QDB6VYtK99IMVnQJ8CC2KApfajYdTY2kdTCVNIogPkbMtoVi7DSASwLuv+wNwu8L4bq4yWoNYh60q
        p7epfEz3rk3lkcZnsH5J+GVsg6vrKtQqQ==;
From:   Christoph Heiss <christoph@c8h4.io>
To:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: alx: Switch to DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr()
Date:   Sat, 17 Dec 2022 11:40:24 +0100
Message-Id: <20221217104024.1954875-1-christoph@c8h4.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Id: christoph@c8h4.io
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using these macros allows to remove an #ifdef-guard on CONFIG_PM_SLEEP.
No functional changes.

Signed-off-by: Christoph Heiss <christoph@c8h4.io>
---
 drivers/net/ethernet/atheros/alx/main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index d30d11872719..306393f8eeca 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1905,7 +1905,6 @@ static void alx_remove(struct pci_dev *pdev)
 	free_netdev(alx->dev);
 }

-#ifdef CONFIG_PM_SLEEP
 static int alx_suspend(struct device *dev)
 {
 	struct alx_priv *alx = dev_get_drvdata(dev);
@@ -1951,12 +1950,7 @@ static int alx_resume(struct device *dev)
 	return err;
 }

-static SIMPLE_DEV_PM_OPS(alx_pm_ops, alx_suspend, alx_resume);
-#define ALX_PM_OPS      (&alx_pm_ops)
-#else
-#define ALX_PM_OPS      NULL
-#endif
-
+static DEFINE_SIMPLE_DEV_PM_OPS(alx_pm_ops, alx_suspend, alx_resume);

 static pci_ers_result_t alx_pci_error_detected(struct pci_dev *pdev,
 					       pci_channel_state_t state)
@@ -2055,7 +2049,7 @@ static struct pci_driver alx_driver = {
 	.probe       = alx_probe,
 	.remove      = alx_remove,
 	.err_handler = &alx_err_handlers,
-	.driver.pm   = ALX_PM_OPS,
+	.driver.pm   = pm_sleep_ptr(&alx_pm_ops),
 };

 module_pci_driver(alx_driver);
--
2.39.0

