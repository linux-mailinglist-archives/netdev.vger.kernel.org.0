Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C149765B6FE
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 20:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjABTwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 14:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjABTwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 14:52:36 -0500
Received: from mail-108-mta128.mxroute.com (mail-108-mta128.mxroute.com [136.175.108.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9566D42
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 11:52:33 -0800 (PST)
Received: from mail-111-mta2.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta128.mxroute.com (ZoneMTA) with ESMTPSA id 185740aea35000011e.007
 for <netdev@vger.kernel.org>
 (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256);
 Mon, 02 Jan 2023 19:52:30 +0000
X-Zone-Loop: 47eadb05d0e781a1fc8c986103fa8bd508818ebcc420
X-Originating-IP: [136.175.111.2]
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=c8h4.io;
        s=x; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:
        From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
        References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
        List-Owner:List-Archive; bh=PvmwkN+BYUCQUQdJYFAdNwIAg6Wx6lg7uwVGd3w86p8=; b=v
        puUTB7H/Bk2aXZySHZLXjZXjcaXmBM4US4tl2Mczo/KGnNK1h06QO7QVWcG6mPFR6Ua7dnvPGWfNa
        4Fp6LYm+8pRF8awM6mt6DNy5CFxq02U+nF/McR5ywRn6/L2IXeeEr2tMlZ8m19D8ek7mCumLFy0bU
        l7p1Gg7qYqBuOC6TK4y58oat4/f4OZDKJyoX9ASK0MaQ5B5c1mTOH13qlRf9S73mFt3pEvsodux9O
        MXaATBenMIHWS2W/RhfgzRUGsnlGCOuo6opfd8uHo6fSuYGcoXVDgGZaepU7ZqazRvlTn9F9VeNXD
        9gcySyR1urHIRp6RRnHSoTzS8x4z7Vd8Q==;
From:   Christoph Heiss <christoph@c8h4.io>
To:     Chris Snook <chris.snook@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: alx: Switch to DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr()
Date:   Mon,  2 Jan 2023 20:51:18 +0100
Message-Id: <20230102195118.1164280-1-christoph@c8h4.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Id: christoph@c8h4.io
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

