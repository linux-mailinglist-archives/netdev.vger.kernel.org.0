Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA34269AD69
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjBQOKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjBQOKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:10:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66126B30A
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 06:10:35 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pT1Ra-0002yN-CR
        for netdev@vger.kernel.org; Fri, 17 Feb 2023 15:10:34 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 63DEB17C164
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:10:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 594AC17C13E;
        Fri, 17 Feb 2023 14:10:31 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id e7d5ae8f;
        Fri, 17 Feb 2023 14:10:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Yang Li <yang.lee@linux.alibaba.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 1/4] can: ctucanfd: ctucan_platform_probe(): use devm_platform_ioremap_resource()
Date:   Fri, 17 Feb 2023 15:10:26 +0100
Message-Id: <20230217141029.3734802-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230217141029.3734802-1-mkl@pengutronix.de>
References: <20230217141029.3734802-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

Convert platform_get_resource(), devm_ioremap_resource() to a single
call to Use devm_platform_ioremap_resource(), as this is exactly what
this function does.

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Link: https://lore.kernel.org/all/20230216090610.130860-1-yang.lee@linux.alibaba.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/ctucanfd/ctucanfd_platform.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c b/drivers/net/can/ctucanfd/ctucanfd_platform.c
index f83684f006ea..a17561d97192 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_platform.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
@@ -47,7 +47,6 @@ static void ctucan_platform_set_drvdata(struct device *dev,
  */
 static int ctucan_platform_probe(struct platform_device *pdev)
 {
-	struct resource *res; /* IO mem resources */
 	struct device	*dev = &pdev->dev;
 	void __iomem *addr;
 	int ret;
@@ -55,8 +54,7 @@ static int ctucan_platform_probe(struct platform_device *pdev)
 	int irq;
 
 	/* Get the virtual base address for the device */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	addr = devm_ioremap_resource(dev, res);
+	addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(addr)) {
 		ret = PTR_ERR(addr);
 		goto err;

base-commit: 40967f77dfa9fa728b7f36a5d2eb432f39de185c
-- 
2.39.1


