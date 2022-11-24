Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F26637FE8
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 20:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiKXT5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 14:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiKXT5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 14:57:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FA791525
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 11:57:17 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyILT-0004gg-Ga
        for netdev@vger.kernel.org; Thu, 24 Nov 2022 20:57:15 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 676D312898B
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 19:57:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 49E3312894D;
        Thu, 24 Nov 2022 19:57:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1e779dc7;
        Thu, 24 Nov 2022 19:57:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 7/8] can: m_can: Add check for devm_clk_get
Date:   Thu, 24 Nov 2022 20:57:07 +0100
Message-Id: <20221124195708.1473369-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221124195708.1473369-1-mkl@pengutronix.de>
References: <20221124195708.1473369-1-mkl@pengutronix.de>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

Since the devm_clk_get may return error,
it should be better to add check for the cdev->hclk,
as same as cdev->cclk.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/all/20221123063651.26199-1-jiasheng@iscas.ac.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 00d11e95fd98..e5575d2755e4 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1909,7 +1909,7 @@ int m_can_class_get_clocks(struct m_can_classdev *cdev)
 	cdev->hclk = devm_clk_get(cdev->dev, "hclk");
 	cdev->cclk = devm_clk_get(cdev->dev, "cclk");
 
-	if (IS_ERR(cdev->cclk)) {
+	if (IS_ERR(cdev->hclk) || IS_ERR(cdev->cclk)) {
 		dev_err(cdev->dev, "no clock found\n");
 		ret = -ENODEV;
 	}
-- 
2.35.1


