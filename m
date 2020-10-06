Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C907A2853F0
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 23:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgJFVhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 17:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgJFVhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 17:37:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DDDC061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 14:37:35 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kPueL-0001We-Sh; Tue, 06 Oct 2020 23:37:33 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Lucas Stach <l.stach@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH] can: m_can_platform: don't call m_can_class_suspend in runtime suspend
Date:   Tue,  6 Oct 2020 23:37:24 +0200
Message-Id: <20201006213723.1842481-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201006213723.1842481-1-mkl@pengutronix.de>
References: <20201006213723.1842481-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

    0704c5743694 can: m_can_platform: remove unnecessary m_can_class_resume() call

removed the m_can_class_resume() call in the runtime resume path to get
rid of a infinite recursion, so the runtime resume now only handles the device
clocks.

Unfortunately it did not remove the complementary m_can_class_suspend() call in
the runtime suspend function, so those paths are now unbalanced, which causes
the pinctrl state to get stuck on the "sleep" state, which breaks all CAN
functionality on SoCs where this state is defined. Remove the
m_can_class_suspend() call to fix this.

Fixes: 0704c5743694 can: m_can_platform: remove unnecessary m_can_class_resume() call
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://lore.kernel.org/r/20200811081545.19921-1-l.stach@pengutronix.de
Acked-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can_platform.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 38ea5e600fb8..e6d0cb9ee02f 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -144,8 +144,6 @@ static int __maybe_unused m_can_runtime_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct m_can_classdev *mcan_class = netdev_priv(ndev);
 
-	m_can_class_suspend(dev);
-
 	clk_disable_unprepare(mcan_class->cclk);
 	clk_disable_unprepare(mcan_class->hclk);
 
-- 
2.28.0

