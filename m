Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2B65646A7
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 12:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbiGCK0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 06:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiGCK0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 06:26:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C04631B
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 03:26:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7wnk-00065y-Gm
        for netdev@vger.kernel.org; Sun, 03 Jul 2022 12:26:04 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 09B6AA69AE
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 10:14:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1ED6FA6994;
        Sun,  3 Jul 2022 10:14:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6e856e4a;
        Sun, 3 Jul 2022 10:14:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 08/15] can: slcan: use CAN network device driver API
Date:   Sun,  3 Jul 2022 12:14:22 +0200
Message-Id: <20220703101430.1306048-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220703101430.1306048-1-mkl@pengutronix.de>
References: <20220703101430.1306048-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

As suggested by commit [1], now the driver uses the functions and the
data structures provided by the CAN network device driver interface.

Currently the driver doesn't implement a way to set bitrate for SLCAN
based devices via ip tool, so you'll have to do this by slcand or
slcan_attach invocation through the -sX parameter:

- slcan_attach -f -s6 -o /dev/ttyACM0
- slcand -f -s8 -o /dev/ttyUSB0

where -s6 in will set adapter's bitrate to 500 Kbit/s and -s8 to
1Mbit/s.
See the table below for further CAN bitrates:
- s0 ->   10 Kbit/s
- s1 ->   20 Kbit/s
- s2 ->   50 Kbit/s
- s3 ->  100 Kbit/s
- s4 ->  125 Kbit/s
- s5 ->  250 Kbit/s
- s6 ->  500 Kbit/s
- s7 ->  800 Kbit/s
- s8 -> 1000 Kbit/s

In doing so, the struct can_priv::bittiming.bitrate of the driver is not
set and since the open_candev() checks that the bitrate has been set, it
must be a non-zero value, the bitrate is set to a fake value (-1U)
before it is called.

Using the rtnl_lock()/rtnl_unlock() functions has become a bit more
tricky as the register_candev() function indirectly calls rtnl_lock()
via register_netdev(). To avoid a deadlock it is therefore necessary to
call rtnl_unlock() before calling register_candev(). The same goes for
the unregister_candev() function.

[1] commit 39549eef3587f ("can: CAN Network device driver and Netlink interface")

Link: https://lore.kernel.org/all/20220628163137.413025-6-dario.binacchi@amarulasolutions.com
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Tested-by: Jeroen Hofstee <jhofstee@victronenergy.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/Kconfig | 40 ++++++++++----------
 drivers/net/can/slcan.c | 82 ++++++++++++++++++++---------------------
 2 files changed, 60 insertions(+), 62 deletions(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index 4078d0775572..3048ad77edb3 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -49,26 +49,6 @@ config CAN_VXCAN
 	  This driver can also be built as a module.  If so, the module
 	  will be called vxcan.
 
-config CAN_SLCAN
-	tristate "Serial / USB serial CAN Adaptors (slcan)"
-	depends on TTY
-	help
-	  CAN driver for several 'low cost' CAN interfaces that are attached
-	  via serial lines or via USB-to-serial adapters using the LAWICEL
-	  ASCII protocol. The driver implements the tty linediscipline N_SLCAN.
-
-	  As only the sending and receiving of CAN frames is implemented, this
-	  driver should work with the (serial/USB) CAN hardware from:
-	  www.canusb.com / www.can232.com / www.mictronics.de / www.canhack.de
-
-	  Userspace tools to attach the SLCAN line discipline (slcan_attach,
-	  slcand) can be found in the can-utils at the linux-can project, see
-	  https://github.com/linux-can/can-utils for details.
-
-	  The slcan driver supports up to 10 CAN netdevices by default which
-	  can be changed by the 'maxdev=xx' module option. This driver can
-	  also be built as a module. If so, the module will be called slcan.
-
 config CAN_NETLINK
 	bool "CAN device drivers with Netlink support"
 	default y
@@ -172,6 +152,26 @@ config CAN_KVASER_PCIEFD
 	    Kvaser Mini PCI Express HS v2
 	    Kvaser Mini PCI Express 2xHS v2
 
+config CAN_SLCAN
+	tristate "Serial / USB serial CAN Adaptors (slcan)"
+	depends on TTY
+	help
+	  CAN driver for several 'low cost' CAN interfaces that are attached
+	  via serial lines or via USB-to-serial adapters using the LAWICEL
+	  ASCII protocol. The driver implements the tty linediscipline N_SLCAN.
+
+	  As only the sending and receiving of CAN frames is implemented, this
+	  driver should work with the (serial/USB) CAN hardware from:
+	  www.canusb.com / www.can232.com / www.mictronics.de / www.canhack.de
+
+	  Userspace tools to attach the SLCAN line discipline (slcan_attach,
+	  slcand) can be found in the can-utils at the linux-can project, see
+	  https://github.com/linux-can/can-utils for details.
+
+	  The slcan driver supports up to 10 CAN netdevices by default which
+	  can be changed by the 'maxdev=xx' module option. This driver can
+	  also be built as a module. If so, the module will be called slcan.
+
 config CAN_SUN4I
 	tristate "Allwinner A10 CAN controller"
 	depends on MACH_SUN4I || MACH_SUN7I || COMPILE_TEST
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index c39580b142e0..bf84698f1a81 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -56,7 +56,6 @@
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/skb.h>
-#include <linux/can/can-ml.h>
 
 MODULE_ALIAS_LDISC(N_SLCAN);
 MODULE_DESCRIPTION("serial line CAN interface");
@@ -79,6 +78,7 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
 #define SLC_EFF_ID_LEN 8
 
 struct slcan {
+	struct can_priv         can;
 	int			magic;
 
 	/* Various fields. */
@@ -394,6 +394,8 @@ static int slc_close(struct net_device *dev)
 		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 	}
 	netif_stop_queue(dev);
+	close_candev(dev);
+	sl->can.state = CAN_STATE_STOPPED;
 	sl->rcount   = 0;
 	sl->xleft    = 0;
 	spin_unlock_bh(&sl->lock);
@@ -405,20 +407,34 @@ static int slc_close(struct net_device *dev)
 static int slc_open(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
+	int err;
 
 	if (sl->tty == NULL)
 		return -ENODEV;
 
+	/* The baud rate is not set with the command
+	 * `ip link set <iface> type can bitrate <baud>' and therefore
+	 * can.bittiming.bitrate is CAN_BITRATE_UNSET (0), causing
+	 * open_candev() to fail. So let's set to a fake value.
+	 */
+	sl->can.bittiming.bitrate = CAN_BITRATE_UNKNOWN;
+	err = open_candev(dev);
+	if (err) {
+		netdev_err(dev, "failed to open can device\n");
+		return err;
+	}
+
+	sl->can.state = CAN_STATE_ERROR_ACTIVE;
 	sl->flags &= BIT(SLF_INUSE);
 	netif_start_queue(dev);
 	return 0;
 }
 
-/* Hook the destructor so we can free slcan devs at the right point in time */
-static void slc_free_netdev(struct net_device *dev)
+static void slc_dealloc(struct slcan *sl)
 {
-	int i = dev->base_addr;
+	int i = sl->dev->base_addr;
 
+	free_candev(sl->dev);
 	slcan_devs[i] = NULL;
 }
 
@@ -434,24 +450,6 @@ static const struct net_device_ops slc_netdev_ops = {
 	.ndo_change_mtu         = slcan_change_mtu,
 };
 
-static void slc_setup(struct net_device *dev)
-{
-	dev->netdev_ops		= &slc_netdev_ops;
-	dev->needs_free_netdev	= true;
-	dev->priv_destructor	= slc_free_netdev;
-
-	dev->hard_header_len	= 0;
-	dev->addr_len		= 0;
-	dev->tx_queue_len	= 10;
-
-	dev->mtu		= CAN_MTU;
-	dev->type		= ARPHRD_CAN;
-
-	/* New-style flags. */
-	dev->flags		= IFF_NOARP;
-	dev->features           = NETIF_F_HW_CSUM;
-}
-
 /******************************************
   Routines looking at TTY side.
  ******************************************/
@@ -514,11 +512,8 @@ static void slc_sync(void)
 static struct slcan *slc_alloc(void)
 {
 	int i;
-	char name[IFNAMSIZ];
 	struct net_device *dev = NULL;
-	struct can_ml_priv *can_ml;
 	struct slcan       *sl;
-	int size;
 
 	for (i = 0; i < maxdev; i++) {
 		dev = slcan_devs[i];
@@ -531,16 +526,14 @@ static struct slcan *slc_alloc(void)
 	if (i >= maxdev)
 		return NULL;
 
-	sprintf(name, "slcan%d", i);
-	size = ALIGN(sizeof(*sl), NETDEV_ALIGN) + sizeof(struct can_ml_priv);
-	dev = alloc_netdev(size, name, NET_NAME_UNKNOWN, slc_setup);
+	dev = alloc_candev(sizeof(*sl), 1);
 	if (!dev)
 		return NULL;
 
+	snprintf(dev->name, sizeof(dev->name), "slcan%d", i);
+	dev->netdev_ops = &slc_netdev_ops;
 	dev->base_addr  = i;
 	sl = netdev_priv(dev);
-	can_ml = (void *)sl + ALIGN(sizeof(*sl), NETDEV_ALIGN);
-	can_set_ml_priv(dev, can_ml);
 
 	/* Initialize channel control data */
 	sl->magic = SLCAN_MAGIC;
@@ -605,26 +598,28 @@ static int slcan_open(struct tty_struct *tty)
 
 		set_bit(SLF_INUSE, &sl->flags);
 
-		err = register_netdevice(sl->dev);
-		if (err)
+		rtnl_unlock();
+		err = register_candev(sl->dev);
+		if (err) {
+			pr_err("slcan: can't register candev\n");
 			goto err_free_chan;
+		}
+	} else {
+		rtnl_unlock();
 	}
 
-	/* Done.  We have linked the TTY line to a channel. */
-	rtnl_unlock();
 	tty->receive_room = 65536;	/* We don't flow control */
 
 	/* TTY layer expects 0 on success */
 	return 0;
 
 err_free_chan:
+	rtnl_lock();
 	sl->tty = NULL;
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
-	slc_free_netdev(sl->dev);
-	/* do not call free_netdev before rtnl_unlock */
+	slc_dealloc(sl);
 	rtnl_unlock();
-	free_netdev(sl->dev);
 	return err;
 
 err_exit:
@@ -658,9 +653,11 @@ static void slcan_close(struct tty_struct *tty)
 	synchronize_rcu();
 	flush_work(&sl->tx_work);
 
-	/* Flush network side */
-	unregister_netdev(sl->dev);
-	/* This will complete via sl_free_netdev */
+	slc_close(sl->dev);
+	unregister_candev(sl->dev);
+	rtnl_lock();
+	slc_dealloc(sl);
+	rtnl_unlock();
 }
 
 static void slcan_hangup(struct tty_struct *tty)
@@ -768,14 +765,15 @@ static void __exit slcan_exit(void)
 		dev = slcan_devs[i];
 		if (!dev)
 			continue;
-		slcan_devs[i] = NULL;
 
 		sl = netdev_priv(dev);
 		if (sl->tty) {
 			netdev_err(dev, "tty discipline still running\n");
 		}
 
-		unregister_netdev(dev);
+		slc_close(dev);
+		unregister_candev(dev);
+		slc_dealloc(sl);
 	}
 
 	kfree(slcan_devs);
-- 
2.35.1


