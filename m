Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D317554DFFC
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 13:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376824AbiFPL0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 07:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376816AbiFPL0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 07:26:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8BF5E75C
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 04:26:05 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o1ndK-0004ZU-7z; Thu, 16 Jun 2022 13:25:54 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o1ndH-000rIF-Jw; Thu, 16 Jun 2022 13:25:53 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1o1ndI-003gFG-7W; Thu, 16 Jun 2022 13:25:52 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v1 1/1] net: dsa: ar9331: fix potential dead lock on mdio access
Date:   Thu, 16 Jun 2022 13:25:50 +0200
Message-Id: <20220616112550.877118-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
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

Rework MDIO locking to avoid potential  circular locking:

 WARNING: possible circular locking dependency detected
 5.19.0-rc1-ar9331-00017-g3ab364c7c48c #5 Not tainted
 ------------------------------------------------------
 kworker/u2:4/68 is trying to acquire lock:
 81f3c83c (ar9331:1005:(&ar9331_mdio_regmap_config)->lock){+.+.}-{4:4}, at: regmap_write+0x50/0x8c

 but task is already holding lock:
 81f60494 (&bus->mdio_lock){+.+.}-{4:4}, at: mdiobus_read+0x40/0x78

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (&bus->mdio_lock){+.+.}-{4:4}:
        lock_acquire+0x2d4/0x360
        __mutex_lock+0xf8/0x384
        mutex_lock_nested+0x2c/0x38
        mdiobus_write+0x44/0x80
        ar9331_sw_bus_write+0x50/0xe4
        _regmap_raw_write_impl+0x604/0x724
        _regmap_bus_raw_write+0x9c/0xb4
        _regmap_write+0xdc/0x1a0
        _regmap_update_bits+0xf4/0x118
        _regmap_select_page+0x108/0x138
        _regmap_raw_read+0x25c/0x288
        _regmap_bus_read+0x60/0x98
        _regmap_read+0xd4/0x1b0
        _regmap_update_bits+0xc4/0x118
        regmap_update_bits_base+0x64/0x8c
        ar9331_sw_irq_bus_sync_unlock+0x40/0x6c
        __irq_set_handler+0x7c/0xac
        ar9331_sw_irq_map+0x48/0x7c
        irq_domain_associate+0x174/0x208
        irq_create_mapping_affinity+0x1a8/0x230
        ar9331_sw_probe+0x22c/0x388
        mdio_probe+0x44/0x70
        really_probe+0x200/0x424
        __driver_probe_device+0x290/0x298
        driver_probe_device+0x54/0xe4
        __device_attach_driver+0xe4/0x130
        bus_for_each_drv+0xb4/0xd8
        __device_attach+0x104/0x1a4
        bus_probe_device+0x48/0xc4
        device_add+0x600/0x800
        mdio_device_register+0x68/0xa0
        of_mdiobus_register+0x2bc/0x3c4
        ag71xx_probe+0x6e4/0x984
        platform_probe+0x78/0xd0
        really_probe+0x200/0x424
        __driver_probe_device+0x290/0x298
        driver_probe_device+0x54/0xe4
        __driver_attach+0x17c/0x190
        bus_for_each_dev+0x8c/0xd0
        bus_add_driver+0x110/0x228
        driver_register+0xe4/0x12c
        do_one_initcall+0x104/0x2a0
        kernel_init_freeable+0x250/0x288
        kernel_init+0x34/0x130
        ret_from_kernel_thread+0x14/0x1c

 -> #0 (ar9331:1005:(&ar9331_mdio_regmap_config)->lock){+.+.}-{4:4}:
        check_noncircular+0x88/0xc0
        __lock_acquire+0x10bc/0x18bc
        lock_acquire+0x2d4/0x360
        __mutex_lock+0xf8/0x384
        mutex_lock_nested+0x2c/0x38
        regmap_write+0x50/0x8c
        ar9331_sw_mbus_read+0x74/0x1b8
        __mdiobus_read+0x90/0xec
        mdiobus_read+0x50/0x78
        get_phy_device+0xa0/0x18c
        fwnode_mdiobus_register_phy+0x120/0x1d4
        of_mdiobus_register+0x244/0x3c4
        devm_of_mdiobus_register+0xe8/0x100
        ar9331_sw_setup+0x16c/0x3a0
        dsa_register_switch+0x7dc/0xcc0
        ar9331_sw_probe+0x370/0x388
        mdio_probe+0x44/0x70
        really_probe+0x200/0x424
        __driver_probe_device+0x290/0x298
        driver_probe_device+0x54/0xe4
        __device_attach_driver+0xe4/0x130
        bus_for_each_drv+0xb4/0xd8
        __device_attach+0x104/0x1a4
        bus_probe_device+0x48/0xc4
        deferred_probe_work_func+0xf0/0x10c
        process_one_work+0x314/0x4d4
        worker_thread+0x2a4/0x354
        kthread+0x134/0x13c
        ret_from_kernel_thread+0x14/0x1c

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&bus->mdio_lock);
                                lock(ar9331:1005:(&ar9331_mdio_regmap_config)->lock);
                                lock(&bus->mdio_lock);
   lock(ar9331:1005:(&ar9331_mdio_regmap_config)->lock);

  *** DEADLOCK ***

 5 locks held by kworker/u2:4/68:
  #0: 81c04eb4 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1e4/0x4d4
  #1: 81f0de78 (deferred_probe_work){+.+.}-{0:0}, at: process_one_work+0x1e4/0x4d4
  #2: 81f0a880 (&dev->mutex){....}-{4:4}, at: __device_attach+0x40/0x1a4
  #3: 80c8aee0 (dsa2_mutex){+.+.}-{4:4}, at: dsa_register_switch+0x5c/0xcc0
  #4: 81f60494 (&bus->mdio_lock){+.+.}-{4:4}, at: mdiobus_read+0x40/0x78

 stack backtrace:
 CPU: 0 PID: 68 Comm: kworker/u2:4 Not tainted 5.19.0-rc1-ar9331-00017-g3ab364c7c48c #5
 Workqueue: events_unbound deferred_probe_work_func
 Stack : 00000056 800d4638 81f0d64c 00000004 00000018 00000000 80a20000 80a20000
         80937590 81ef3858 81f0d760 3913578a 00000005 8045e824 81f0d600 a8db84cc
         00000000 00000000 80937590 00000a44 00000000 00000002 00000001 ffffffff
         81f0d6a4 80982d7c 0000000f 20202020 80a20000 00000001 80937590 81ef3858
         81f0d760 3913578a 00000005 00000005 00000000 03bd0000 00000000 80e00000
         ...
 Call Trace:
 [<80069db0>] show_stack+0x94/0x130
 [<8045e824>] dump_stack_lvl+0x54/0x8c
 [<800c7fac>] check_noncircular+0x88/0xc0
 [<800ca068>] __lock_acquire+0x10bc/0x18bc
 [<800cb478>] lock_acquire+0x2d4/0x360
 [<807b84c4>] __mutex_lock+0xf8/0x384
 [<807b877c>] mutex_lock_nested+0x2c/0x38
 [<804ea640>] regmap_write+0x50/0x8c
 [<80501e38>] ar9331_sw_mbus_read+0x74/0x1b8
 [<804fe9a0>] __mdiobus_read+0x90/0xec
 [<804feac4>] mdiobus_read+0x50/0x78
 [<804fcf74>] get_phy_device+0xa0/0x18c
 [<804ffeb4>] fwnode_mdiobus_register_phy+0x120/0x1d4
 [<805004f0>] of_mdiobus_register+0x244/0x3c4
 [<804f0c50>] devm_of_mdiobus_register+0xe8/0x100
 [<805017a0>] ar9331_sw_setup+0x16c/0x3a0
 [<807355c8>] dsa_register_switch+0x7dc/0xcc0
 [<80501468>] ar9331_sw_probe+0x370/0x388
 [<804ff0c0>] mdio_probe+0x44/0x70
 [<804d1848>] really_probe+0x200/0x424
 [<804d1cfc>] __driver_probe_device+0x290/0x298
 [<804d1d58>] driver_probe_device+0x54/0xe4
 [<804d2298>] __device_attach_driver+0xe4/0x130
 [<804cf048>] bus_for_each_drv+0xb4/0xd8
 [<804d200c>] __device_attach+0x104/0x1a4
 [<804d026c>] bus_probe_device+0x48/0xc4
 [<804d108c>] deferred_probe_work_func+0xf0/0x10c
 [<800a0ffc>] process_one_work+0x314/0x4d4
 [<800a17fc>] worker_thread+0x2a4/0x354
 [<800a9a54>] kthread+0x134/0x13c
 [<8006306c>] ret_from_kernel_thread+0x14/0x1c
[

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/dsa/qca/ar9331.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index e5098cfe44bc..f23ce56fa591 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -818,7 +818,7 @@ static int __ar9331_mdio_write(struct mii_bus *sbus, u8 mode, u16 reg, u16 val)
 		FIELD_GET(AR9331_SW_LOW_ADDR_PHY, reg);
 	r = FIELD_GET(AR9331_SW_LOW_ADDR_REG, reg);
 
-	return mdiobus_write(sbus, p, r, val);
+	return __mdiobus_write(sbus, p, r, val);
 }
 
 static int __ar9331_mdio_read(struct mii_bus *sbus, u16 reg)
@@ -829,7 +829,7 @@ static int __ar9331_mdio_read(struct mii_bus *sbus, u16 reg)
 		FIELD_GET(AR9331_SW_LOW_ADDR_PHY, reg);
 	r = FIELD_GET(AR9331_SW_LOW_ADDR_REG, reg);
 
-	return mdiobus_read(sbus, p, r);
+	return __mdiobus_read(sbus, p, r);
 }
 
 static int ar9331_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
@@ -849,6 +849,8 @@ static int ar9331_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
 		return 0;
 	}
 
+	mutex_lock_nested(&sbus->mdio_lock, MDIO_MUTEX_NESTED);
+
 	ret = __ar9331_mdio_read(sbus, reg);
 	if (ret < 0)
 		goto error;
@@ -860,9 +862,13 @@ static int ar9331_mdio_read(void *ctx, const void *reg_buf, size_t reg_len,
 
 	*(u32 *)val_buf |= ret << 16;
 
+	mutex_unlock(&sbus->mdio_lock);
+
 	return 0;
 error:
+	mutex_unlock(&sbus->mdio_lock);
 	dev_err_ratelimited(&sbus->dev, "Bus error. Failed to read register.\n");
+
 	return ret;
 }
 
@@ -872,12 +878,15 @@ static int ar9331_mdio_write(void *ctx, u32 reg, u32 val)
 	struct mii_bus *sbus = priv->sbus;
 	int ret;
 
+	mutex_lock_nested(&sbus->mdio_lock, MDIO_MUTEX_NESTED);
 	if (reg == AR9331_SW_REG_PAGE) {
 		ret = __ar9331_mdio_write(sbus, AR9331_SW_MDIO_PHY_MODE_PAGE,
 					  0, val);
 		if (ret < 0)
 			goto error;
 
+		mutex_unlock(&sbus->mdio_lock);
+
 		return 0;
 	}
 
@@ -897,10 +906,14 @@ static int ar9331_mdio_write(void *ctx, u32 reg, u32 val)
 	if (ret < 0)
 		goto error;
 
+	mutex_unlock(&sbus->mdio_lock);
+
 	return 0;
 
 error:
+	mutex_unlock(&sbus->mdio_lock);
 	dev_err_ratelimited(&sbus->dev, "Bus error. Failed to write register.\n");
+
 	return ret;
 }
 
-- 
2.30.2

