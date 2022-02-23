Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5D34C0E0F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 09:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbiBWIJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 03:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238866AbiBWIJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 03:09:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA626D961
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 00:09:25 -0800 (PST)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nMmiC-0000N4-8D; Wed, 23 Feb 2022 09:09:24 +0100
Received: from sha by dude02.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nMmiB-00FjwE-Dh; Wed, 23 Feb 2022 09:09:23 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] net: fec: ethtool: fix unbalanced IRQ wake disable
Date:   Wed, 23 Feb 2022 09:09:18 +0100
Message-Id: <20220223080918.3751233-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

Userspace can trigger a kernel warning by using the ethtool ioctls to
disable WoL, when it was not enabled before:

  $ ethtool -s eth0 wol d ; ethtool -s eth0 wol d
  Unbalanced IRQ 54 wake disable
  WARNING: CPU: 2 PID: 17532 at kernel/irq/manage.c:900 irq_set_irq_wake+0x108/0x148

This is because fec_enet_set_wol happily calls disable_irq_wake,
even if the wake IRQ is already disabled.

Looking at other drivers, like lpc_eth, suggests the way to go is to
do wake IRQ enabling/disabling in the suspend/resume callbacks.
Doing so avoids the warning at no loss of functionality.

This only affects userspace with older ethtool versions. Newer ones
use netlink and disabling before enabling will be refused before
reaching the driver.

Fixes: de40ed31b3c5 ("net: fec: add Wake-on-LAN support")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/net/ethernet/freescale/fec_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 796133de527e4..44a0c89d76dd6 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4055,6 +4055,9 @@ static int __maybe_unused fec_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
 
+	if (device_may_wakeup(&ndev->dev) && fep->wake_irq > 0)
+		enable_irq_wake(fep->wake_irq);
+
 	rtnl_lock();
 	if (netif_running(ndev)) {
 		if (fep->wol_flag & FEC_WOL_FLAG_ENABLE)
@@ -4137,6 +4140,9 @@ static int __maybe_unused fec_resume(struct device *dev)
 	}
 	rtnl_unlock();
 
+	if (device_may_wakeup(&ndev->dev) && fep->wake_irq > 0)
+		disable_irq_wake(fep->wake_irq);
+
 	return 0;
 
 failed_clk:
-- 
2.30.2

