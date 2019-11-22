Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5233C107448
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 15:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfKVOxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 09:53:05 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34395 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfKVOxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 09:53:04 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iYAIo-0006w3-Um; Fri, 22 Nov 2019 15:52:55 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pankaj Sharma <pankj.sharma@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 1/2] can: m_can_platform: set net_device structure as driver data
Date:   Fri, 22 Nov 2019 15:52:50 +0100
Message-Id: <20191122145251.9775-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122145251.9775-1-mkl@pengutronix.de>
References: <20191122145251.9775-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pankaj Sharma <pankj.sharma@samsung.com>

The current code is failing during clock prepare enable because of not
getting proper clock from platform device.

[    0.852089] Call trace:
[    0.854516]  0xffff0000fa22a668
[    0.857638]  clk_prepare+0x20/0x34
[    0.861019]  m_can_runtime_resume+0x2c/0xe4
[    0.865180]  pm_generic_runtime_resume+0x28/0x38
[    0.869770]  __rpm_callback+0x16c/0x1bc
[    0.873583]  rpm_callback+0x24/0x78
[    0.877050]  rpm_resume+0x428/0x560
[    0.880517]  __pm_runtime_resume+0x7c/0xa8
[    0.884593]  m_can_clk_start.isra.9.part.10+0x1c/0xa8
[    0.889618]  m_can_class_register+0x138/0x370
[    0.893950]  m_can_plat_probe+0x120/0x170
[    0.897939]  platform_drv_probe+0x4c/0xa0
[    0.901924]  really_probe+0xd8/0x31c
[    0.905477]  driver_probe_device+0x58/0xe8
[    0.909551]  device_driver_attach+0x68/0x70
[    0.913711]  __driver_attach+0x9c/0xf8
[    0.917437]  bus_for_each_dev+0x50/0xa0
[    0.921251]  driver_attach+0x20/0x28
[    0.924804]  bus_add_driver+0x148/0x1fc
[    0.928617]  driver_register+0x6c/0x124
[    0.932431]  __platform_driver_register+0x48/0x50
[    0.937113]  m_can_plat_driver_init+0x18/0x20
[    0.941446]  do_one_initcall+0x4c/0x19c
[    0.945259]  kernel_init_freeable+0x1d0/0x280
[    0.949591]  kernel_init+0x10/0x100
[    0.953057]  ret_from_fork+0x10/0x18
[    0.956614] Code: 00000000 00000000 00000000 00000000 (fa22a668)
[    0.962681] ---[ end trace 881f71bd609de763 ]---
[    0.967301] Kernel panic - not syncing: Attempted to kill init!

A device driver for CAN controller hardware registers itself with the
Linux network layer as a network device. So, the driver data for m_can
should ideally be of type net_device.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
Acked-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 6ac4c35f247a..2eaa3543d233 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -107,7 +107,7 @@ static int m_can_plat_probe(struct platform_device *pdev)
 
 	mcan_class->is_peripheral = false;
 
-	platform_set_drvdata(pdev, mcan_class->dev);
+	platform_set_drvdata(pdev, mcan_class->net);
 
 	m_can_init_ram(mcan_class);
 
-- 
2.24.0

