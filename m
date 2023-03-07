Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46796AF651
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 21:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbjCGUBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 15:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbjCGUAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 15:00:37 -0500
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3447685;
        Tue,  7 Mar 2023 11:58:01 -0800 (PST)
Received: from dslb-188-097-045-043.188.097.pools.vodafone-ip.de ([188.97.45.43] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1pZdRR-0008QZ-4e; Tue, 07 Mar 2023 20:57:45 +0100
From:   Martin Kaiser <martin@kaiser.cx>
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Martin Kaiser <martin@kaiser.cx>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: rtl8xxxu: use module_usb_driver
Date:   Tue,  7 Mar 2023 20:57:17 +0100
Message-Id: <20230307195718.168021-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can use the module_usb_driver macro instead of open-coding the driver's
init and exit functions. This is simpler and saves some lines of code.
Other realtek wireless drivers use module_usb_driver as well.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 20 +------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index e619ed21fbfe..58dbad9a14c2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -7455,24 +7455,6 @@ static struct usb_driver rtl8xxxu_driver = {
 	.disable_hub_initiated_lpm = 1,
 };
 
-static int __init rtl8xxxu_module_init(void)
-{
-	int res;
-
-	res = usb_register(&rtl8xxxu_driver);
-	if (res < 0)
-		pr_err(DRIVER_NAME ": usb_register() failed (%i)\n", res);
-
-	return res;
-}
-
-static void __exit rtl8xxxu_module_exit(void)
-{
-	usb_deregister(&rtl8xxxu_driver);
-}
-
-
 MODULE_DEVICE_TABLE(usb, dev_table);
 
-module_init(rtl8xxxu_module_init);
-module_exit(rtl8xxxu_module_exit);
+module_usb_driver(rtl8xxxu_driver);
-- 
2.30.2

