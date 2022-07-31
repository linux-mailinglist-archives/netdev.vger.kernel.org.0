Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B075860DE
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbiGaTVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbiGaTUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:20:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CFFDF82
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUW-0007LF-6F
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:44 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A5A65BEC91
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B3DB3BEC6A;
        Sun, 31 Jul 2022 19:20:36 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 431ebc7d;
        Sun, 31 Jul 2022 19:20:30 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        Max Staudt <max@enpas.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 16/36] can: slcan: remove legacy infrastructure
Date:   Sun, 31 Jul 2022 21:20:09 +0200
Message-Id: <20220731192029.746751-17-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220731192029.746751-1-mkl@pengutronix.de>
References: <20220731192029.746751-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

Taking inspiration from the drivers/net/can/can327.c driver and at the
suggestion of its author Max Staudt, I removed legacy stuff like
`SLCAN_MAGIC' and `slcan_devs' resulting in simplification of the code
and its maintainability.

The use of slcan_devs is derived from a very old kernel, since slip.c
is about 30 years old, so today's kernel allows us to remove it.

The .hangup() ldisc function, which only called the ldisc .close(), has
been removed since the ldisc layer calls .close() in a good place
anyway.

The old slcanX name has been dropped in order to use the standard canX
interface naming. The ioctl SIOCGIFNAME can be used to query the name of
the created interface. Furthermore, there are several ways to get stable
interfaces names in user space, e.g. udev or systemd-networkd.

The `maxdev' module parameter has also been removed.

CC: Max Staudt <max@enpas.org>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Reviewed-by: Max Staudt <max@enpas.org>
Link: https://lore.kernel.org/all/20220728070254.267974-4-dario.binacchi@amarulasolutions.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/slcan/slcan-core.c | 318 ++++++-----------------------
 1 file changed, 63 insertions(+), 255 deletions(-)

diff --git a/drivers/net/can/slcan/slcan-core.c b/drivers/net/can/slcan/slcan-core.c
index 509053ea1742..133a9e045760 100644
--- a/drivers/net/can/slcan/slcan-core.c
+++ b/drivers/net/can/slcan/slcan-core.c
@@ -1,11 +1,14 @@
 /*
  * slcan.c - serial line CAN interface driver (using tty line discipline)
  *
- * This file is derived from linux/drivers/net/slip/slip.c
+ * This file is derived from linux/drivers/net/slip/slip.c and got
+ * inspiration from linux/drivers/net/can/can327.c for the rework made
+ * on the line discipline code.
  *
  * slip.c Authors  : Laurence Culhane <loz@holmes.demon.co.uk>
  *                   Fred N. van Kempen <waltje@uwalt.nl.mugnet.org>
  * slcan.c Author  : Oliver Hartkopp <socketcan@hartkopp.net>
+ * can327.c Author : Max Staudt <max-linux@enpas.org>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -38,7 +41,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
@@ -48,7 +50,6 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/rtnetlink.h>
-#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
@@ -63,15 +64,6 @@ MODULE_DESCRIPTION("serial line CAN interface");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Oliver Hartkopp <socketcan@hartkopp.net>");
 
-#define SLCAN_MAGIC 0x53CA
-
-static int maxdev = 10;		/* MAX number of SLCAN channels;
-				 * This can be overridden with
-				 * insmod slcan.ko maxdev=nnn
-				 */
-module_param(maxdev, int, 0);
-MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
-
 /* maximum rx buffer len: extended CAN frame with timestamp */
 #define SLC_MTU (sizeof("T1111222281122334455667788EA5F\r") + 1)
 
@@ -85,7 +77,6 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
 				   SLC_STATE_BE_TXCNT_LEN)
 struct slcan {
 	struct can_priv         can;
-	int			magic;
 
 	/* Various fields. */
 	struct tty_struct	*tty;		/* ptr to TTY structure	     */
@@ -101,17 +92,14 @@ struct slcan {
 	int			xleft;          /* bytes left in XMIT queue  */
 
 	unsigned long		flags;		/* Flag values/ mode etc     */
-#define SLF_INUSE		0		/* Channel in use            */
-#define SLF_ERROR		1               /* Parity, etc. error        */
-#define SLF_XCMD		2               /* Command transmission      */
+#define SLF_ERROR		0               /* Parity, etc. error        */
+#define SLF_XCMD		1               /* Command transmission      */
 	unsigned long           cmd_flags;      /* Command flags             */
 #define CF_ERR_RST		0               /* Reset errors on open      */
 	wait_queue_head_t       xcmd_wait;      /* Wait queue for commands   */
 						/* transmission              */
 };
 
-static struct net_device **slcan_devs;
-
 static const u32 slcan_bitrate_const[] = {
 	10000, 20000, 50000, 100000, 125000,
 	250000, 500000, 800000, 1000000
@@ -556,9 +544,8 @@ static void slcan_transmit(struct work_struct *work)
 
 	spin_lock_bh(&sl->lock);
 	/* First make sure we're connected. */
-	if (!sl->tty || sl->magic != SLCAN_MAGIC ||
-	    (unlikely(!netif_running(sl->dev)) &&
-	     likely(!test_bit(SLF_XCMD, &sl->flags)))) {
+	if (unlikely(!netif_running(sl->dev)) &&
+	    likely(!test_bit(SLF_XCMD, &sl->flags))) {
 		spin_unlock_bh(&sl->lock);
 		return;
 	}
@@ -593,13 +580,9 @@ static void slcan_transmit(struct work_struct *work)
  */
 static void slcan_write_wakeup(struct tty_struct *tty)
 {
-	struct slcan *sl;
+	struct slcan *sl = (struct slcan *)tty->disc_data;
 
-	rcu_read_lock();
-	sl = rcu_dereference(tty->disc_data);
-	if (sl)
-		schedule_work(&sl->tx_work);
-	rcu_read_unlock();
+	schedule_work(&sl->tx_work);
 }
 
 /* Send a can_frame to a TTY queue. */
@@ -670,25 +653,21 @@ static int slc_close(struct net_device *dev)
 	struct slcan *sl = netdev_priv(dev);
 	int err;
 
-	spin_lock_bh(&sl->lock);
-	if (sl->tty) {
-		if (sl->can.bittiming.bitrate &&
-		    sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
-			spin_unlock_bh(&sl->lock);
-			err = slcan_transmit_cmd(sl, "C\r");
-			spin_lock_bh(&sl->lock);
-			if (err)
-				netdev_warn(dev,
-					    "failed to send close command 'C\\r'\n");
-		}
-
-		/* TTY discipline is running. */
-		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
+	if (sl->can.bittiming.bitrate &&
+	    sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
+		err = slcan_transmit_cmd(sl, "C\r");
+		if (err)
+			netdev_warn(dev,
+				    "failed to send close command 'C\\r'\n");
 	}
+
+	/* TTY discipline is running. */
+	clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
+	flush_work(&sl->tx_work);
+
 	netif_stop_queue(dev);
 	sl->rcount   = 0;
 	sl->xleft    = 0;
-	spin_unlock_bh(&sl->lock);
 	close_candev(dev);
 	sl->can.state = CAN_STATE_STOPPED;
 	if (sl->can.bittiming.bitrate == CAN_BITRATE_UNKNOWN)
@@ -704,9 +683,6 @@ static int slc_open(struct net_device *dev)
 	unsigned char cmd[SLC_MTU];
 	int err, s;
 
-	if (!sl->tty)
-		return -ENODEV;
-
 	/* The baud rate is not set with the command
 	 * `ip link set <iface> type can bitrate <baud>' and therefore
 	 * can.bittiming.bitrate is CAN_BITRATE_UNSET (0), causing
@@ -721,8 +697,6 @@ static int slc_open(struct net_device *dev)
 		return err;
 	}
 
-	sl->flags &= BIT(SLF_INUSE);
-
 	if (sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
 		for (s = 0; s < ARRAY_SIZE(slcan_bitrate_const); s++) {
 			if (sl->can.bittiming.bitrate == slcan_bitrate_const[s])
@@ -766,14 +740,6 @@ static int slc_open(struct net_device *dev)
 	return err;
 }
 
-static void slc_dealloc(struct slcan *sl)
-{
-	int i = sl->dev->base_addr;
-
-	free_candev(sl->dev);
-	slcan_devs[i] = NULL;
-}
-
 static int slcan_change_mtu(struct net_device *dev, int new_mtu)
 {
 	return -EINVAL;
@@ -803,7 +769,7 @@ static void slcan_receive_buf(struct tty_struct *tty,
 {
 	struct slcan *sl = (struct slcan *)tty->disc_data;
 
-	if (!sl || sl->magic != SLCAN_MAGIC || !netif_running(sl->dev))
+	if (!netif_running(sl->dev))
 		return;
 
 	/* Read the characters out of the buffer */
@@ -818,80 +784,15 @@ static void slcan_receive_buf(struct tty_struct *tty,
 	}
 }
 
-/************************************
- *  slcan_open helper routines.
- ************************************/
-
-/* Collect hanged up channels */
-static void slc_sync(void)
-{
-	int i;
-	struct net_device *dev;
-	struct slcan	  *sl;
-
-	for (i = 0; i < maxdev; i++) {
-		dev = slcan_devs[i];
-		if (!dev)
-			break;
-
-		sl = netdev_priv(dev);
-		if (sl->tty)
-			continue;
-		if (dev->flags & IFF_UP)
-			dev_close(dev);
-	}
-}
-
-/* Find a free SLCAN channel, and link in this `tty' line. */
-static struct slcan *slc_alloc(void)
-{
-	int i;
-	struct net_device *dev = NULL;
-	struct slcan       *sl;
-
-	for (i = 0; i < maxdev; i++) {
-		dev = slcan_devs[i];
-		if (!dev)
-			break;
-	}
-
-	/* Sorry, too many, all slots in use */
-	if (i >= maxdev)
-		return NULL;
-
-	dev = alloc_candev(sizeof(*sl), 1);
-	if (!dev)
-		return NULL;
-
-	snprintf(dev->name, sizeof(dev->name), KBUILD_MODNAME "%d", i);
-	dev->netdev_ops = &slc_netdev_ops;
-	dev->ethtool_ops = &slcan_ethtool_ops;
-	dev->base_addr  = i;
-	sl = netdev_priv(dev);
-
-	/* Initialize channel control data */
-	sl->magic = SLCAN_MAGIC;
-	sl->dev	= dev;
-	sl->can.bitrate_const = slcan_bitrate_const;
-	sl->can.bitrate_const_cnt = ARRAY_SIZE(slcan_bitrate_const);
-	spin_lock_init(&sl->lock);
-	INIT_WORK(&sl->tx_work, slcan_transmit);
-	init_waitqueue_head(&sl->xcmd_wait);
-	slcan_devs[i] = dev;
-
-	return sl;
-}
-
 /* Open the high-level part of the SLCAN channel.
  * This function is called by the TTY module when the
- * SLCAN line discipline is called for.  Because we are
- * sure the tty line exists, we only have to link it to
- * a free SLCAN channel...
+ * SLCAN line discipline is called for.
  *
  * Called in process context serialized from other ldisc calls.
  */
 static int slcan_open(struct tty_struct *tty)
 {
+	struct net_device *dev;
 	struct slcan *sl;
 	int err;
 
@@ -901,72 +802,49 @@ static int slcan_open(struct tty_struct *tty)
 	if (!tty->ops->write)
 		return -EOPNOTSUPP;
 
-	/* RTnetlink lock is misused here to serialize concurrent
-	 * opens of slcan channels. There are better ways, but it is
-	 * the simplest one.
-	 */
-	rtnl_lock();
+	dev = alloc_candev(sizeof(*sl), 1);
+	if (!dev)
+		return -ENFILE;
 
-	/* Collect hanged up channels. */
-	slc_sync();
+	sl = netdev_priv(dev);
 
-	sl = tty->disc_data;
+	/* Configure TTY interface */
+	tty->receive_room = 65536; /* We don't flow control */
+	sl->rcount = 0;
+	sl->xleft = 0;
+	spin_lock_init(&sl->lock);
+	INIT_WORK(&sl->tx_work, slcan_transmit);
+	init_waitqueue_head(&sl->xcmd_wait);
 
-	err = -EEXIST;
-	/* First make sure we're not already connected. */
-	if (sl && sl->magic == SLCAN_MAGIC)
-		goto err_exit;
+	/* Configure CAN metadata */
+	sl->can.bitrate_const = slcan_bitrate_const;
+	sl->can.bitrate_const_cnt = ARRAY_SIZE(slcan_bitrate_const);
 
-	/* OK.  Find a free SLCAN channel to use. */
-	err = -ENFILE;
-	sl = slc_alloc();
-	if (!sl)
-		goto err_exit;
+	/* Configure netdev interface */
+	sl->dev	= dev;
+	dev->netdev_ops = &slc_netdev_ops;
+	dev->ethtool_ops = &slcan_ethtool_ops;
 
+	/* Mark ldisc channel as alive */
 	sl->tty = tty;
 	tty->disc_data = sl;
 
-	if (!test_bit(SLF_INUSE, &sl->flags)) {
-		/* Perform the low-level SLCAN initialization. */
-		sl->rcount   = 0;
-		sl->xleft    = 0;
-
-		set_bit(SLF_INUSE, &sl->flags);
-
-		rtnl_unlock();
-		err = register_candev(sl->dev);
-		if (err) {
-			pr_err("can't register candev\n");
-			goto err_free_chan;
-		}
-	} else {
-		rtnl_unlock();
+	err = register_candev(dev);
+	if (err) {
+		free_candev(dev);
+		pr_err("can't register candev\n");
+		return err;
 	}
 
-	tty->receive_room = 65536;	/* We don't flow control */
-
+	netdev_info(dev, "slcan on %s.\n", tty->name);
 	/* TTY layer expects 0 on success */
 	return 0;
-
-err_free_chan:
-	rtnl_lock();
-	sl->tty = NULL;
-	tty->disc_data = NULL;
-	clear_bit(SLF_INUSE, &sl->flags);
-	slc_dealloc(sl);
-	rtnl_unlock();
-	return err;
-
-err_exit:
-	rtnl_unlock();
-
-	/* Count references from TTY module */
-	return err;
 }
 
 /* Close down a SLCAN channel.
  * This means flushing out any pending queues, and then returning. This
  * call is serialized against other ldisc functions.
+ * Once this is called, no other ldisc function of ours is entered.
  *
  * We also use this method for a hangup event.
  */
@@ -974,28 +852,20 @@ static void slcan_close(struct tty_struct *tty)
 {
 	struct slcan *sl = (struct slcan *)tty->disc_data;
 
-	/* First make sure we're connected. */
-	if (!sl || sl->magic != SLCAN_MAGIC || sl->tty != tty)
-		return;
+	/* unregister_netdev() calls .ndo_stop() so we don't have to.
+	 * Our .ndo_stop() also flushes the TTY write wakeup handler,
+	 * so we can safely set sl->tty = NULL after this.
+	 */
+	unregister_candev(sl->dev);
 
+	/* Mark channel as dead */
 	spin_lock_bh(&sl->lock);
-	rcu_assign_pointer(tty->disc_data, NULL);
+	tty->disc_data = NULL;
 	sl->tty = NULL;
 	spin_unlock_bh(&sl->lock);
 
-	synchronize_rcu();
-	flush_work(&sl->tx_work);
-
-	slc_close(sl->dev);
-	unregister_candev(sl->dev);
-	rtnl_lock();
-	slc_dealloc(sl);
-	rtnl_unlock();
-}
-
-static void slcan_hangup(struct tty_struct *tty)
-{
-	slcan_close(tty);
+	netdev_info(sl->dev, "slcan off %s.\n", tty->name);
+	free_candev(sl->dev);
 }
 
 /* Perform I/O control on an active SLCAN channel. */
@@ -1005,10 +875,6 @@ static int slcan_ioctl(struct tty_struct *tty, unsigned int cmd,
 	struct slcan *sl = (struct slcan *)tty->disc_data;
 	unsigned int tmp;
 
-	/* First make sure we're connected. */
-	if (!sl || sl->magic != SLCAN_MAGIC)
-		return -EINVAL;
-
 	switch (cmd) {
 	case SIOCGIFNAME:
 		tmp = strlen(sl->dev->name) + 1;
@@ -1030,7 +896,6 @@ static struct tty_ldisc_ops slc_ldisc = {
 	.name		= KBUILD_MODNAME,
 	.open		= slcan_open,
 	.close		= slcan_close,
-	.hangup		= slcan_hangup,
 	.ioctl		= slcan_ioctl,
 	.receive_buf	= slcan_receive_buf,
 	.write_wakeup	= slcan_write_wakeup,
@@ -1040,78 +905,21 @@ static int __init slcan_init(void)
 {
 	int status;
 
-	if (maxdev < 4)
-		maxdev = 4; /* Sanity */
-
 	pr_info("serial line CAN interface driver\n");
-	pr_info("%d dynamic interface channels.\n", maxdev);
-
-	slcan_devs = kcalloc(maxdev, sizeof(struct net_device *), GFP_KERNEL);
-	if (!slcan_devs)
-		return -ENOMEM;
 
 	/* Fill in our line protocol discipline, and register it */
 	status = tty_register_ldisc(&slc_ldisc);
-	if (status)  {
+	if (status)
 		pr_err("can't register line discipline\n");
-		kfree(slcan_devs);
-	}
+
 	return status;
 }
 
 static void __exit slcan_exit(void)
 {
-	int i;
-	struct net_device *dev;
-	struct slcan *sl;
-	unsigned long timeout = jiffies + HZ;
-	int busy = 0;
-
-	if (!slcan_devs)
-		return;
-
-	/* First of all: check for active disciplines and hangup them.
-	 */
-	do {
-		if (busy)
-			msleep_interruptible(100);
-
-		busy = 0;
-		for (i = 0; i < maxdev; i++) {
-			dev = slcan_devs[i];
-			if (!dev)
-				continue;
-			sl = netdev_priv(dev);
-			spin_lock_bh(&sl->lock);
-			if (sl->tty) {
-				busy++;
-				tty_hangup(sl->tty);
-			}
-			spin_unlock_bh(&sl->lock);
-		}
-	} while (busy && time_before(jiffies, timeout));
-
-	/* FIXME: hangup is async so we should wait when doing this second
-	 * phase
+	/* This will only be called when all channels have been closed by
+	 * userspace - tty_ldisc.c takes care of the module's refcount.
 	 */
-
-	for (i = 0; i < maxdev; i++) {
-		dev = slcan_devs[i];
-		if (!dev)
-			continue;
-
-		sl = netdev_priv(dev);
-		if (sl->tty)
-			netdev_err(dev, "tty discipline still running\n");
-
-		slc_close(dev);
-		unregister_candev(dev);
-		slc_dealloc(sl);
-	}
-
-	kfree(slcan_devs);
-	slcan_devs = NULL;
-
 	tty_unregister_ldisc(&slc_ldisc);
 }
 
-- 
2.35.1


