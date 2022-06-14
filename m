Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36A254B143
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242468AbiFNM33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243706AbiFNM2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:28:39 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9E43FBF9
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:34 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id v19so11411848edd.4
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PCpFnoF0UtSjQMBZCRUGNujFKva7GVFTMHpSRjoSZYI=;
        b=p11hVCXeVpoI4jaYhEX2aVuViXksLsfnSUtDJVZ7CRjm8KtSuaDtexG36cDaB+SpVk
         xiEFrVK9L+OBageUvZuFE4GTlDySaY3MaD4RzB6dS5G/tQLHR/hDYmwYuIU3abi6egtz
         t2YusYMRTU9RbQiv1VpLYD/nFixv+2ABTvgLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PCpFnoF0UtSjQMBZCRUGNujFKva7GVFTMHpSRjoSZYI=;
        b=zl5KPcfBHkyUjkwve7hllQavC6r++Svsx8ivJTyci14hRLFiZkLUkP/3QHw5V93fEp
         A8US55ab+ZtodEfEG+e8Xf1ItjPCHkf7P1gV4Q3zbpcFnb8GXnChk7GWfScPojJJkG4Z
         4OCjFFEJFoqzl7KcAJ3IgPsGEhd1szHTg0XA6UB1YC/qiIEApJ0OEJoy8VdsUDF85/0z
         WMHA3kZ9lT0GYPqP142LEso3y3W56Oe8BsYh6/kMJvx/oKPo11PizKdvkHqHCJLhjbhm
         bFaVSJiTTJIzj7AMw0ZHzSitjj9s8Tt8r2Tvygx1FH1+0AxjnoWEQ54XqioUU0XLsGcm
         Rkcw==
X-Gm-Message-State: AOAM533J5Eq0Sh5lBqsHP+dXFsUU0J1C3KaKrSpiqhKljYoibpf2Fnq9
        M3m4I+muZBoVr+LYkA9YKfUcHA==
X-Google-Smtp-Source: AGRyM1v5hqSfaAsHORrhfP+QmLrPijgXNMVZAVIwerpbvzkpUkK2MVtBWM7M6o3I1VatuxOFHpGv2A==
X-Received: by 2002:a05:6402:254e:b0:431:35df:5e38 with SMTP id l14-20020a056402254e00b0043135df5e38mr5790736edb.385.1655209712935;
        Tue, 14 Jun 2022 05:28:32 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.amarulasolutions.com (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090655d600b006f3ef214e2csm5087043ejp.146.2022.06.14.05.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:28:32 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 05/12] can: slcan: use CAN network device driver API
Date:   Tue, 14 Jun 2022 14:28:14 +0200
Message-Id: <20220614122821.3646071-6-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
References: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
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

The patch also changes the slcan_devs locking from rtnl to spin_lock. The
change was tested with a kernel with the CONFIG_PROVE_LOCKING option
enabled that did not show any errors.

[1] commit 39549eef3587f ("can: CAN Network device driver and Netlink interface")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

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

 drivers/net/can/Kconfig |  40 +++++++--------
 drivers/net/can/slcan.c | 107 ++++++++++++++++++++--------------------
 2 files changed, 74 insertions(+), 73 deletions(-)

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
index c39580b142e0..c7ff11dd2278 100644
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
@@ -100,6 +100,7 @@ struct slcan {
 };
 
 static struct net_device **slcan_devs;
+static DEFINE_SPINLOCK(slcan_lock);
 
  /************************************************************************
   *			SLCAN ENCAPSULATION FORMAT			 *
@@ -394,6 +395,8 @@ static int slc_close(struct net_device *dev)
 		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 	}
 	netif_stop_queue(dev);
+	close_candev(dev);
+	sl->can.state = CAN_STATE_STOPPED;
 	sl->rcount   = 0;
 	sl->xleft    = 0;
 	spin_unlock_bh(&sl->lock);
@@ -405,20 +408,34 @@ static int slc_close(struct net_device *dev)
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
 
@@ -434,24 +451,6 @@ static const struct net_device_ops slc_netdev_ops = {
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
@@ -514,11 +513,8 @@ static void slc_sync(void)
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
@@ -531,16 +527,14 @@ static struct slcan *slc_alloc(void)
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
@@ -573,11 +567,7 @@ static int slcan_open(struct tty_struct *tty)
 	if (tty->ops->write == NULL)
 		return -EOPNOTSUPP;
 
-	/* RTnetlink lock is misused here to serialize concurrent
-	   opens of slcan channels. There are better ways, but it is
-	   the simplest one.
-	 */
-	rtnl_lock();
+	spin_lock(&slcan_lock);
 
 	/* Collect hanged up channels. */
 	slc_sync();
@@ -605,13 +595,15 @@ static int slcan_open(struct tty_struct *tty)
 
 		set_bit(SLF_INUSE, &sl->flags);
 
-		err = register_netdevice(sl->dev);
-		if (err)
+		err = register_candev(sl->dev);
+		if (err) {
+			pr_err("slcan: can't register candev\n");
 			goto err_free_chan;
+		}
 	}
 
 	/* Done.  We have linked the TTY line to a channel. */
-	rtnl_unlock();
+	spin_unlock(&slcan_lock);
 	tty->receive_room = 65536;	/* We don't flow control */
 
 	/* TTY layer expects 0 on success */
@@ -621,14 +613,10 @@ static int slcan_open(struct tty_struct *tty)
 	sl->tty = NULL;
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
-	slc_free_netdev(sl->dev);
-	/* do not call free_netdev before rtnl_unlock */
-	rtnl_unlock();
-	free_netdev(sl->dev);
-	return err;
+	slc_dealloc(sl);
 
 err_exit:
-	rtnl_unlock();
+	spin_unlock(&slcan_lock);
 
 	/* Count references from TTY module */
 	return err;
@@ -658,9 +646,11 @@ static void slcan_close(struct tty_struct *tty)
 	synchronize_rcu();
 	flush_work(&sl->tx_work);
 
-	/* Flush network side */
-	unregister_netdev(sl->dev);
-	/* This will complete via sl_free_netdev */
+	slc_close(sl->dev);
+	unregister_candev(sl->dev);
+	spin_lock(&slcan_lock);
+	slc_dealloc(sl);
+	spin_unlock(&slcan_lock);
 }
 
 static void slcan_hangup(struct tty_struct *tty)
@@ -768,18 +758,29 @@ static void __exit slcan_exit(void)
 		dev = slcan_devs[i];
 		if (!dev)
 			continue;
-		slcan_devs[i] = NULL;
 
-		sl = netdev_priv(dev);
-		if (sl->tty) {
-			netdev_err(dev, "tty discipline still running\n");
-		}
+		spin_lock(&slcan_lock);
+		dev = slcan_devs[i];
+		if (dev) {
+			slcan_devs[i] = NULL;
+			spin_unlock(&slcan_lock);
+			sl = netdev_priv(dev);
+			if (sl->tty) {
+				netdev_err(dev,
+					   "tty discipline still running\n");
+			}
 
-		unregister_netdev(dev);
+			slc_close(dev);
+			unregister_candev(dev);
+		} else {
+			spin_unlock(&slcan_lock);
+		}
 	}
 
+	spin_lock(&slcan_lock);
 	kfree(slcan_devs);
 	slcan_devs = NULL;
+	spin_unlock(&slcan_lock);
 
 	tty_unregister_ldisc(&slc_ldisc);
 }
-- 
2.32.0

