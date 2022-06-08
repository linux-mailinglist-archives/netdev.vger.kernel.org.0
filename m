Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC475439C5
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242387AbiFHQzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343727AbiFHQxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:53:44 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855B63C7E46
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:51:31 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id s12so35408186ejx.3
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c+3GCirlvyznBBrVu6oPXaX+KYWRV3Xhpy2k9G10VWo=;
        b=e2zOSGbKtXKLpefQa3BSp5hjNi+a3w6DM+GlBwxiTF4HJl02rGoJ4LTgVbT1qTE7Qn
         Ht8jCRGfUTwAWeYi3srFxn82SNxYVVMvCP2RKSBbbb7bXshDhajw8AiGAvJdcThhw98p
         mt42c6/ANt/1EYmXUWMQrcd3hff3Y7wHDx5Cc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c+3GCirlvyznBBrVu6oPXaX+KYWRV3Xhpy2k9G10VWo=;
        b=tOLKLd37OSn0ADG+n5I3GWJNr2zDIBBfyc4Hj359zCyI9/xO74s+qFuRHxfVZ20RHF
         Pd7AxGsR4bf/S6bMDsW9Z2rEe4b++u+APZCJoQsXj3z8bSBSdaIjGYYOsjbNwAy5x4Jt
         jDgk+aFIy1oW3LM5VT9eXwhfxtjvzhFybPfSI/plhtcHxbTGXCIbHuzMx9KdEi4OSCXU
         SdOOoWjftb37TreaAoR2niubmV0NlbzGGbUK2McTo9WTFbrXnEncCnnIrJfEP2JpiMc2
         e9qiw9reww26Y4ocoApeOBtAy1y47RYDfJdsKuYxXiQiWyKZlPBXGLAP5H8TI+lPbpJd
         deew==
X-Gm-Message-State: AOAM5321+LbbchSi/cZM5Lhbkz3oKpI4Ftu6kxgTbzi/1kG0nDnYHJeb
        fyTgfgSCIWtnxNP3Ae51ai2HzQ==
X-Google-Smtp-Source: ABdhPJxB2NOAkywI8QbxaLZM9M6JWilbjddIiYskmxN5RO7qX1o5TFGCkYi9XM+bzpilNd5AmET4YA==
X-Received: by 2002:a17:907:1b25:b0:6da:8206:fc56 with SMTP id mp37-20020a1709071b2500b006da8206fc56mr32386194ejc.81.1654707089355;
        Wed, 08 Jun 2022 09:51:29 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id c22-20020a17090654d600b0070587f81bcfsm9569071ejp.19.2022.06.08.09.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:51:28 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 04/13] can: slcan: use CAN network device driver API
Date:   Wed,  8 Jun 2022 18:51:07 +0200
Message-Id: <20220608165116.1575390-5-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
References: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
must be a non-zero value, the bitrate is set to a fake value (-1) before
it is called.

[1] 39549eef3587f ("can: CAN Network device driver and Netlink interface")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

---

Changes in v2:
- Move CAN_SLCAN Kconfig option inside CAN_DEV scope.
- Improve the commit message.

 drivers/net/can/Kconfig |  40 +++++++-------
 drivers/net/can/slcan.c | 112 ++++++++++++++++++++--------------------
 2 files changed, 77 insertions(+), 75 deletions(-)

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
index 5d87e25e2285..929cb55e08af 100644
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
@@ -373,7 +374,7 @@ static netdev_tx_t slc_xmit(struct sk_buff *skb, struct net_device *dev)
 	spin_unlock(&sl->lock);
 
 out:
-	kfree_skb(skb);
+	can_put_echo_skb(skb, dev, 0, 0);
 	return NETDEV_TX_OK;
 }
 
@@ -393,6 +394,8 @@ static int slc_close(struct net_device *dev)
 		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
 	}
 	netif_stop_queue(dev);
+	close_candev(dev);
+	sl->can.state = CAN_STATE_STOPPED;
 	sl->rcount   = 0;
 	sl->xleft    = 0;
 	spin_unlock_bh(&sl->lock);
@@ -404,21 +407,36 @@ static int slc_close(struct net_device *dev)
 static int slc_open(struct net_device *dev)
 {
 	struct slcan *sl = netdev_priv(dev);
+	int err;
 
 	if (sl->tty == NULL)
 		return -ENODEV;
 
+	/* The baud rate is not set with the command
+	 * `ip link set <iface> type can bitrate <baud>' and therefore
+	 * can.bittiming.bitrate is 0, causing open_candev() to fail.
+	 * So let's set to a fake value.
+	 */
+	sl->can.bittiming.bitrate = -1;
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
 
-	slcan_devs[i] = NULL;
+	free_candev(sl->dev);
+	if (slcan_devs)
+		slcan_devs[i] = NULL;
 }
 
 static int slcan_change_mtu(struct net_device *dev, int new_mtu)
@@ -433,24 +451,6 @@ static const struct net_device_ops slc_netdev_ops = {
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
@@ -513,11 +513,8 @@ static void slc_sync(void)
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
@@ -530,16 +527,14 @@ static struct slcan *slc_alloc(void)
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
@@ -572,11 +567,7 @@ static int slcan_open(struct tty_struct *tty)
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
@@ -604,13 +595,15 @@ static int slcan_open(struct tty_struct *tty)
 
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
@@ -620,14 +613,10 @@ static int slcan_open(struct tty_struct *tty)
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
@@ -657,9 +646,11 @@ static void slcan_close(struct tty_struct *tty)
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
@@ -767,18 +758,29 @@ static void __exit slcan_exit(void)
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

