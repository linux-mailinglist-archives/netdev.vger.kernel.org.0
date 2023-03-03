Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F2D6A9BD9
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 17:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjCCQiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 11:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjCCQiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 11:38:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9A51114C
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 08:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pMp0LVmnrkUZg3wQA4O4SAhBC4dYPd/SxW+zoVsyCh4=; b=TpeADC+Q8Y8AGpyqeJHtLicJQs
        x181fUsRyTWFNPBrByemLYtTqfUe/pQn/pI8WMGlSUk8ss57MlFytQTojLbsbsQh3NsZgZ9OWndQ2
        sw3Q+KVwoCc5Nr6cGwRUg+cBYb9Wh9jnMTIglZpedqarEmxxV4S4m7ESZkAUMND/Fyu3Ezx3s1tio
        wVPpTM6RWBpdgnXAvP+7RFOwQKP4Eyz6Op8hu1gKCXFybmV4Pe6zNnyM/io1S90LRsArytkcpkNQe
        NwHHzJhF+vba+ULnnfvyLzAM0N7wW74qXok3Ypdjj9ByGpCM69vKnsiUBLL6kQhFrOeMGWlxlxEu4
        R8fYlAVw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46992 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pY8Pr-0001BV-Ap; Fri, 03 Mar 2023 16:37:55 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pY8Pq-00D0sw-NY; Fri, 03 Mar 2023 16:37:54 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net] net: phylib: get rid of unnecessary locking
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pY8Pq-00D0sw-NY@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 03 Mar 2023 16:37:54 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The locking in phy_probe() and phy_remove() does very little to prevent
any races with e.g. phy_attach_direct(), but instead causes lockdep ABBA
warnings. Remove it.

======================================================
WARNING: possible circular locking dependency detected
6.2.0-dirty #1108 Tainted: G        W   E
------------------------------------------------------
ip/415 is trying to acquire lock:
ffff5c268f81ef50 (&dev->lock){+.+.}-{3:3}, at: phy_attach_direct+0x17c/0x3a0 [libphy]

but task is already holding lock:
ffffaef6496cb518 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x154/0x560

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (rtnl_mutex){+.+.}-{3:3}:
       __lock_acquire+0x35c/0x6c0
       lock_acquire.part.0+0xcc/0x220
       lock_acquire+0x68/0x84
       __mutex_lock+0x8c/0x414
       mutex_lock_nested+0x34/0x40
       rtnl_lock+0x24/0x30
       sfp_bus_add_upstream+0x34/0x150
       phy_sfp_probe+0x4c/0x94 [libphy]
       mv3310_probe+0x148/0x184 [marvell10g]
       phy_probe+0x8c/0x200 [libphy]
       call_driver_probe+0xbc/0x15c
       really_probe+0xc0/0x320
       __driver_probe_device+0x84/0x120
       driver_probe_device+0x44/0x120
       __device_attach_driver+0xc4/0x160
       bus_for_each_drv+0x80/0xe0
       __device_attach+0xb0/0x1f0
       device_initial_probe+0x1c/0x2c
       bus_probe_device+0xa4/0xb0
       device_add+0x360/0x53c
       phy_device_register+0x60/0xa4 [libphy]
       fwnode_mdiobus_phy_device_register+0xc0/0x190 [fwnode_mdio]
       fwnode_mdiobus_register_phy+0x160/0xd80 [fwnode_mdio]
       of_mdiobus_register+0x140/0x340 [of_mdio]
       orion_mdio_probe+0x298/0x3c0 [mvmdio]
       platform_probe+0x70/0xe0
       call_driver_probe+0x34/0x15c
       really_probe+0xc0/0x320
       __driver_probe_device+0x84/0x120
       driver_probe_device+0x44/0x120
       __driver_attach+0x104/0x210
       bus_for_each_dev+0x78/0xdc
       driver_attach+0x2c/0x3c
       bus_add_driver+0x184/0x240
       driver_register+0x80/0x13c
       __platform_driver_register+0x30/0x3c
       xt_compat_calc_jump+0x28/0xa4 [x_tables]
       do_one_initcall+0x50/0x1b0
       do_init_module+0x50/0x1fc
       load_module+0x684/0x744
       __do_sys_finit_module+0xc4/0x140
       __arm64_sys_finit_module+0x28/0x34
       invoke_syscall+0x50/0x120
       el0_svc_common.constprop.0+0x6c/0x1b0
       do_el0_svc+0x34/0x44
       el0_svc+0x48/0xf0
       el0t_64_sync_handler+0xb8/0xc0
       el0t_64_sync+0x1a0/0x1a4

-> #0 (&dev->lock){+.+.}-{3:3}:
       check_prev_add+0xb4/0xc80
       validate_chain+0x414/0x47c
       __lock_acquire+0x35c/0x6c0
       lock_acquire.part.0+0xcc/0x220
       lock_acquire+0x68/0x84
       __mutex_lock+0x8c/0x414
       mutex_lock_nested+0x34/0x40
       phy_attach_direct+0x17c/0x3a0 [libphy]
       phylink_fwnode_phy_connect.part.0+0x70/0xe4 [phylink]
       phylink_fwnode_phy_connect+0x48/0x60 [phylink]
       mvpp2_open+0xec/0x2e0 [mvpp2]
       __dev_open+0x104/0x214
       __dev_change_flags+0x1d4/0x254
       dev_change_flags+0x2c/0x7c
       do_setlink+0x254/0xa50
       __rtnl_newlink+0x430/0x514
       rtnl_newlink+0x58/0x8c
       rtnetlink_rcv_msg+0x17c/0x560
       netlink_rcv_skb+0x64/0x150
       rtnetlink_rcv+0x20/0x30
       netlink_unicast+0x1d4/0x2b4
       netlink_sendmsg+0x1a4/0x400
       ____sys_sendmsg+0x228/0x290
       ___sys_sendmsg+0x88/0xec
       __sys_sendmsg+0x70/0xd0
       __arm64_sys_sendmsg+0x2c/0x40
       invoke_syscall+0x50/0x120
       el0_svc_common.constprop.0+0x6c/0x1b0
       do_el0_svc+0x34/0x44
       el0_svc+0x48/0xf0
       el0t_64_sync_handler+0xb8/0xc0
       el0t_64_sync+0x1a0/0x1a4

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(rtnl_mutex);
                               lock(&dev->lock);
                               lock(rtnl_mutex);
  lock(&dev->lock);

 *** DEADLOCK ***

Fixes: 298e54fa810e ("net: phy: add core phylib sfp support")
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9e9fd8ff00f6..1785f1cead97 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3098,8 +3098,6 @@ static int phy_probe(struct device *dev)
 	if (phydrv->flags & PHY_IS_INTERNAL)
 		phydev->is_internal = true;
 
-	mutex_lock(&phydev->lock);
-
 	/* Deassert the reset signal */
 	phy_device_reset(phydev, 0);
 
@@ -3188,12 +3186,10 @@ static int phy_probe(struct device *dev)
 	phydev->state = PHY_READY;
 
 out:
-	/* Assert the reset signal */
+	/* Re-assert the reset signal on error */
 	if (err)
 		phy_device_reset(phydev, 1);
 
-	mutex_unlock(&phydev->lock);
-
 	return err;
 }
 
@@ -3203,9 +3199,7 @@ static int phy_remove(struct device *dev)
 
 	cancel_delayed_work_sync(&phydev->state_queue);
 
-	mutex_lock(&phydev->lock);
 	phydev->state = PHY_DOWN;
-	mutex_unlock(&phydev->lock);
 
 	sfp_bus_del_upstream(phydev->sfp_bus);
 	phydev->sfp_bus = NULL;
-- 
2.30.2

