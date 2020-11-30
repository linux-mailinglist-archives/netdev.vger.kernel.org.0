Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8328E2C8666
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgK3OQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbgK3OQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:16:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61625C08E864
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:14:50 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjjx2-0007lT-UF
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 15:14:48 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 01E3459FB37
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:14:41 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8DBD659FAE4;
        Mon, 30 Nov 2020 14:14:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b17998df;
        Mon, 30 Nov 2020 14:14:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>
Subject: [net-next 14/14] can: m_can: m_can_class_unregister(): move right after m_can_class_register()
Date:   Mon, 30 Nov 2020 15:14:32 +0100
Message-Id: <20201130141432.278219-15-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130141432.278219-1-mkl@pengutronix.de>
References: <20201130141432.278219-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves the function m_can_class_unregister() directly after the
m_can_class_register() function.

Link: https://lore.kernel.org/r/20201130133713.269256-7-mkl@pengutronix.de
Reviewed-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 553ff39199aa..05c978d1c53d 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1869,6 +1869,14 @@ int m_can_class_register(struct m_can_classdev *m_can_dev)
 }
 EXPORT_SYMBOL_GPL(m_can_class_register);
 
+void m_can_class_unregister(struct m_can_classdev *m_can_dev)
+{
+	unregister_candev(m_can_dev->net);
+
+	m_can_clk_stop(m_can_dev);
+}
+EXPORT_SYMBOL_GPL(m_can_class_unregister);
+
 int m_can_class_suspend(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
@@ -1915,14 +1923,6 @@ int m_can_class_resume(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(m_can_class_resume);
 
-void m_can_class_unregister(struct m_can_classdev *m_can_dev)
-{
-	unregister_candev(m_can_dev->net);
-
-	m_can_clk_stop(m_can_dev);
-}
-EXPORT_SYMBOL_GPL(m_can_class_unregister);
-
 MODULE_AUTHOR("Dong Aisheng <b29396@freescale.com>");
 MODULE_AUTHOR("Dan Murphy <dmurphy@ti.com>");
 MODULE_LICENSE("GPL v2");
-- 
2.29.2


