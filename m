Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99402D57BF
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgLJJ5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728476AbgLJJ4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 04:56:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4DEAC061282
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 01:55:18 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1knIfN-0000zF-Ab
        for netdev@vger.kernel.org; Thu, 10 Dec 2020 10:55:17 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 716A65AA1C4
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:55:14 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id DAFFE5AA19D;
        Thu, 10 Dec 2020 09:55:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a12aba87;
        Thu, 10 Dec 2020 09:55:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Patrik Flykt <patrik.flykt@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 4/7] can: m_can: move runtime PM enable/disable to m_can_platform
Date:   Thu, 10 Dec 2020 10:55:04 +0100
Message-Id: <20201210095507.1551220-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210095507.1551220-1-mkl@pengutronix.de>
References: <20201210095507.1551220-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrik Flykt <patrik.flykt@linux.intel.com>

This is a preparatory patch for upcoming PCI based M_CAN devices. The current
PM implementation would cause PCI based drivers to enable PM twice, once when
the PCI device is added and a second time in m_can_class_register(). This will
cause 'Unbalanced pm_runtime_enable!' to be logged, and is a situation that
should be avoided.

Therefore, in anticipation of PCI devices, move PM enabling out from M_CAN
class registration to its only user, the m_can_platform driver.

Signed-off-by: Patrik Flykt <patrik.flykt@linux.intel.com>
Link: https://lore.kernel.org/r/20201023115800.46538-2-patrik.flykt@linux.intel.com
[mkl: m_can_plat_probe(): fix error handling
      m_can_class_register(): simplify error handling]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c          | 8 +-------
 drivers/net/can/m_can/m_can_platform.c | 9 ++++++++-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 8f389df26afc..06c136961c7c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1826,10 +1826,9 @@ int m_can_class_register(struct m_can_classdev *m_can_dev)
 	int ret;
 
 	if (m_can_dev->pm_clock_support) {
-		pm_runtime_enable(m_can_dev->dev);
 		ret = m_can_clk_start(m_can_dev);
 		if (ret)
-			goto pm_runtime_fail;
+			return ret;
 	}
 
 	ret = m_can_dev_setup(m_can_dev);
@@ -1855,11 +1854,6 @@ int m_can_class_register(struct m_can_classdev *m_can_dev)
 	 */
 clk_disable:
 	m_can_clk_stop(m_can_dev);
-pm_runtime_fail:
-	if (ret) {
-		if (m_can_dev->pm_clock_support)
-			pm_runtime_disable(m_can_dev->dev);
-	}
 
 	return ret;
 }
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index c45a889a1afd..36ef791da388 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -115,8 +115,15 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	m_can_init_ram(mcan_class);
 
-	return m_can_class_register(mcan_class);
+	pm_runtime_enable(mcan_class->dev);
+	ret = m_can_class_register(mcan_class);
+	if (ret)
+		goto out_runtime_disable;
+
+	return ret;
 
+out_runtime_disable:
+	pm_runtime_disable(mcan_class->dev);
 probe_fail:
 	m_can_class_free_dev(mcan_class->net);
 	return ret;
-- 
2.29.2


