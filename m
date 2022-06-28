Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A56C55E9F1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbiF1Qfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238142AbiF1Qer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:34:47 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14610326E2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:57 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id q6so26822779eji.13
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5bhO0o16CDU7mHwhFJvR1vi2tTSkwNkLZnvwcLoYiRw=;
        b=IiB8f+RtxlhRNOkn1i3FVhtmxLTgv3mPWHKd6LHY2/Vh1Re+GuYv4t4vvHsS+w/e1m
         3KlGTNBUjUZvwy1RyvRVDkulUYGk9FC9lpJ0RjjpaCc8dGVLf9lwcVokRrjBCC1k2pPU
         a43iZRo3lx+HynF1bz0hSPngeKAG1HhvnWx4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5bhO0o16CDU7mHwhFJvR1vi2tTSkwNkLZnvwcLoYiRw=;
        b=sdlQaLCJaEMh3U1MfhyPJ+f0Tk/A/gzD0LaD6L9moieI9YABGI1dme3Ry7dGtwa2p+
         JKStvyZvRc+hMAZMZPDOT+9PIdoMK46rxgJ06YeY0b7kgdw2my9H+4DdfPXRsRHwBF/B
         4aaNzTuhWkOOLyuXtswc/QwDV6KOXKjOKpOgGky6CTMxBQA89cSaFniQCBFJzlapXmEQ
         lLvnAc1S+3lZwbHTcU7kXlIdIUzKyFFSD0D0vWcJefxHbrgOblEi6yUFJOCAJd/2K5JR
         vVNz4ZsD9X8PEQSbrM0Vsggr3H4j3m/RIhNcSVqy/i710DiifihD8eEx6pZwhM4SeuCH
         Xiog==
X-Gm-Message-State: AJIora+2aZQsNWRzWtNcYbC7U9NQP66sf8wt4BccVYeL9wHa+NDsymay
        OtaJIOIa3lUQH5L9wlfBK7dYqw==
X-Google-Smtp-Source: AGRyM1vusOxzzKlbAJJcAxRJ1IHRBdRZ2NSK2Q4SoNxpnA6I11skUooZAwFIivv1eHKp0QW4cJ8nAA==
X-Received: by 2002:a17:907:1b25:b0:6da:8206:fc56 with SMTP id mp37-20020a1709071b2500b006da8206fc56mr286036ejc.81.1656433915553;
        Tue, 28 Jun 2022 09:31:55 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm9916952edb.8.2022.06.28.09.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:31:55 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 05/12] can: slcan: use CAN network device driver API
Date:   Tue, 28 Jun 2022 18:31:29 +0200
Message-Id: <20220628163137.413025-6-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
References: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v5:
- Update the commit message.
- Restore the use of rtnl_lock() and rtnl_unlock().

Changes in v4:
- Update the commit description.
- Use the CAN_BITRATE_UNKNOWN macro.
- Use kfree_skb() instead of can_put_echo_skb() in the slc_xmit().
- Remove the `if (slcan_devs)' check in the slc_dealloc().

Changes in v3:
- Replace (-1) with (-1U) in the commit description.

Changes in v2:
- Move CAN_SLCAN Kconfig option inside CAN_DEV scope.
- Improve the commit message.

 drivers/net/can/Kconfig | 40 ++++++++++----------
 drivers/net/can/slcan.c | 82 ++++++++++++++++++++---------------------
 2 files changed, 60 insertions(+), 62 deletions(-)

diff --git a/drivers/net/can/Kconfig b/drivers/net/can/Kconfig
index b2dcc1e5a388..45997d39621c 100644
--- a/drivers/net/can/Kconfig
+++ b/drivers/net/can/Kconfig
@@ -28,26 +28,6 @@ config CAN_VXCAN
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
 config CAN_DEV
 	tristate "Platform CAN drivers with Netlink support"
 	default y
@@ -118,6 +98,26 @@ config CAN_KVASER_PCIEFD
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
2.32.0

