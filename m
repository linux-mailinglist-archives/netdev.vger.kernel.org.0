Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3118C2B374C
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 18:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbgKORlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 12:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727435AbgKORlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 12:41:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE2FC061A4B
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 09:41:45 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1keM23-0005uQ-H5; Sun, 15 Nov 2020 18:41:43 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 13/15] can: m_can: m_can_class_free_dev(): introduce new function
Date:   Sun, 15 Nov 2020 18:41:29 +0100
Message-Id: <20201115174131.2089251-14-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201115174131.2089251-1-mkl@pengutronix.de>
References: <20201115174131.2089251-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

This patch creates a common function that peripherials can call to free the
netdev device when failures occur.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Link: http://lore.kernel.org/r/20200227183829.21854-2-dmurphy@ti.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 6 ++++++
 drivers/net/can/m_can/m_can.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 63887e23d89c..f2c87b76e569 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1812,6 +1812,12 @@ struct m_can_classdev *m_can_class_allocate_dev(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(m_can_class_allocate_dev);
 
+void m_can_class_free_dev(struct net_device *net)
+{
+	free_candev(net);
+}
+EXPORT_SYMBOL_GPL(m_can_class_free_dev);
+
 int m_can_class_register(struct m_can_classdev *m_can_dev)
 {
 	int ret;
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 49f42b50627a..b2699a7c9997 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -99,6 +99,7 @@ struct m_can_classdev {
 };
 
 struct m_can_classdev *m_can_class_allocate_dev(struct device *dev);
+void m_can_class_free_dev(struct net_device *net);
 int m_can_class_register(struct m_can_classdev *cdev);
 void m_can_class_unregister(struct m_can_classdev *cdev);
 int m_can_class_get_clocks(struct m_can_classdev *cdev);
-- 
2.29.2

