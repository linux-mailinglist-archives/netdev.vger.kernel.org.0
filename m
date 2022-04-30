Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE85D515C1E
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 12:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbiD3KJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 06:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382566AbiD3KJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 06:09:07 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0490725591
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 03:05:44 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 92A0830000648;
        Sat, 30 Apr 2022 12:05:41 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 8127711B170; Sat, 30 Apr 2022 12:05:41 +0200 (CEST)
Date:   Sat, 30 Apr 2022 12:05:41 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
Message-ID: <20220430100541.GA18507@wunner.de>
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
 <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
 <20220423160723.GA20330@wunner.de>
 <20220425074146.1fa27d5f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425074146.1fa27d5f@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 07:41:46AM -0700, Jakub Kicinski wrote:
> On Sat, 23 Apr 2022 18:07:23 +0200 Lukas Wunner wrote:
> > > Looking at the original report it looks like the issue could be
> > > resolved with a more usb-specific change: e.g. it looks like
> > > usbnet_defer_kevent() is not acquiring a dev reference as it should.
> > > 
> > > Have you considered that path?
> > 
> > First of all, the diffstat of the patch shows this is an opportunity
> > to reduce LoC as well as simplify and speed up device teardown.
> > 
> > Second, the approach you're proposing won't work if a driver calls
> > netif_carrier_on/off() after unregister_netdev().
> > 
> > It seems prudent to prevent such a misbehavior in *any* driver,
> > not just usbnet.  usbnet may not be the only one doing it wrong.
> > Jann pointed out that there are more syzbot reports related
> > to a UAF in linkwatch:
> > 
> > https://lore.kernel.org/netdev/?q=__linkwatch_run_queue+syzbot
> > 
> > Third, I think an API which schedules work, invisibly to the driver,
> > is dangerous and misguided.  If it is illegal to call
> > netif_carrier_on/off() for an unregistered but not yet freed netdev,
> > catch that in core networking code and don't expect drivers to respect
> > a rule which isn't even documented.
> 
> Doesn't mean we should make it legal. We can add a warning to catch
> abuses.

It turns out that no, we *cannot* add a warning to catch abuses.

I've identified all the places in USB Ethernet drivers which are
susceptible to calling linkwatch_fire_event() after unregister_netdev(),
see patch below.

I'm fixing each one like this:

-		netif_carrier_on(dev->net);
+		dev_hold(dev->net);
+		if (dev->net->reg_state < NETREG_UNREGISTERED)
+			netif_carrier_on(dev->net);
+		dev_put(dev->net);

If this is called after unregister_netdev(), it becomes a no-op.

However if it is called concurrently to unregister_netdev(),
the reg_state may change to NETREG_UNREGISTERED after the if-clause
has been evaluated and before netif_carrier_on() is called.
Then a linkwatch event *will* be fired.  There won't be a use-after-free
because of the ref I'm acquiring here.  (unregister_netdev() will spin
in netdev_wait_allrefs_any() until the linkwatch event has been handled.)

But this means that we may still call linkwatch_fire_event() after
unregister_netdev()!  So we cannot emit a WARN splat and we cannot
catch use-after-frees outside of the USB Ethernet drivers I'm fixing
in the below patch.  It may thus very well happen that a use-after-free
may still occur for such other drivers and we cannot even WARN about it.

For this reason I would strongly prefer the $SUBJECT_PATCH ("net: linkwatch:
ignore events for unregistered netdevs") instead of the patch below.
I think you are wrong to stall the patch.  It avoids UAFs in *any*
driver, not just the USB Ethernet ones, it reduces LoC and speeds up
netdev unregistration.  What more do you want?

Thanks,

Lukas

-- >8 --

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index ea06d10..279a7ca 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -962,7 +962,11 @@ static int aqc111_link_reset(struct usbnet *dev)
 		aqc111_write16_cmd(dev, AQ_ACCESS_MAC, SFR_RX_CTL,
 				   2, &aqc111_data->rxctl);
 
-		netif_carrier_on(dev->net);
+		dev_hold(dev->net);
+		if (dev->net->reg_state < NETREG_UNREGISTERED)
+			netif_carrier_on(dev->net);
+		dev_put(dev->net);
+
 	} else {
 		aqc111_read16_cmd(dev, AQ_ACCESS_MAC, SFR_MEDIUM_STATUS_MODE,
 				  2, &reg16);
@@ -981,7 +985,10 @@ static int aqc111_link_reset(struct usbnet *dev)
 		aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_BULK_OUT_CTRL,
 				 1, 1, &reg8);
 
-		netif_carrier_off(dev->net);
+		dev_hold(dev->net);
+		if (dev->net->reg_state < NETREG_UNREGISTERED)
+			netif_carrier_off(dev->net);
+		dev_put(dev->net);
 	}
 	return 0;
 }
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 0872ca12..1e97c0a 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -173,7 +173,11 @@ static int ax88172_link_reset(struct usbnet *dev)
 	u8 mode;
 	struct ethtool_cmd ecmd = { .cmd = ETHTOOL_GSET };
 
-	mii_check_media(&dev->mii, 1, 1);
+	dev_hold(dev->net);
+	if (dev->net->reg_state < NETREG_UNREGISTERED)
+		mii_check_media(&dev->mii, 1, 1);
+	dev_put(dev->net);
+
 	mii_ethtool_gset(&dev->mii, &ecmd);
 	mode = AX88172_MEDIUM_DEFAULT;
 
@@ -1013,7 +1017,11 @@ static int ax88178_link_reset(struct usbnet *dev)
 
 	netdev_dbg(dev->net, "ax88178_link_reset()\n");
 
-	mii_check_media(&dev->mii, 1, 1);
+	dev_hold(dev->net);
+	if (dev->net->reg_state < NETREG_UNREGISTERED)
+		mii_check_media(&dev->mii, 1, 1);
+	dev_put(dev->net);
+
 	mii_ethtool_gset(&dev->mii, &ecmd);
 	mode = AX88178_MEDIUM_DEFAULT;
 	speed = ethtool_cmd_speed(&ecmd);
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index a310989..279ddf2 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1632,7 +1632,10 @@ static int ax88179_link_reset(struct usbnet *dev)
 
 	ax179_data->eee_enabled = ax88179_chk_eee(dev);
 
-	netif_carrier_on(dev->net);
+	dev_hold(dev->net);
+	if (dev->net->reg_state < NETREG_UNREGISTERED)
+		netif_carrier_on(dev->net);
+	dev_put(dev->net);
 
 	return 0;
 }
diff --git a/drivers/net/usb/ch9200.c b/drivers/net/usb/ch9200.c
index f69d9b9..5c7904c 100644
--- a/drivers/net/usb/ch9200.c
+++ b/drivers/net/usb/ch9200.c
@@ -214,7 +214,11 @@ static int ch9200_link_reset(struct usbnet *dev)
 {
 	struct ethtool_cmd ecmd;
 
-	mii_check_media(&dev->mii, 1, 1);
+	dev_hold(dev->net);
+	if (dev->net->reg_state < NETREG_UNREGISTERED)
+		mii_check_media(&dev->mii, 1, 1);
+	dev_put(dev->net);
+
 	mii_ethtool_gset(&dev->mii, &ecmd);
 
 	netdev_dbg(dev->net, "%s() speed:%d duplex:%d\n",
diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index bb4cbe8f..9ae9359 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -427,7 +427,11 @@ static void sierra_net_handle_lsi(struct usbnet *dev, char *data,
 	} else {
 		priv->link_up = 0;
 	}
-	usbnet_link_change(dev, link_up, 0);
+
+	dev_hold(dev->net);
+	if (dev->net->reg_state < NETREG_UNREGISTERED)
+		usbnet_link_change(dev, link_up, 0);
+	dev_put(dev->net);
 }
 
 static void sierra_net_dosync(struct usbnet *dev)
@@ -758,6 +762,8 @@ static void sierra_net_unbind(struct usbnet *dev, struct usb_interface *intf)
 
 	dev_dbg(&dev->udev->dev, "%s", __func__);
 
+	usbnet_status_stop(dev);
+
 	/* kill the timer and work */
 	del_timer_sync(&priv->sync_timer);
 	cancel_work_sync(&priv->sierra_net_kevent);
@@ -769,8 +775,6 @@ static void sierra_net_unbind(struct usbnet *dev, struct usb_interface *intf)
 		netdev_err(dev->net,
 			"usb_control_msg failed, status %d\n", status);
 
-	usbnet_status_stop(dev);
-
 	sierra_net_set_private(dev, NULL);
 	kfree(priv);
 }
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 95de452..b7f608a 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -640,7 +640,11 @@ static int smsc75xx_link_reset(struct usbnet *dev)
 		return ret;
 	}
 
-	mii_check_media(mii, 1, 1);
+	dev_hold(dev->net);
+	if (dev->net->reg_state < NETREG_UNREGISTERED)
+		mii_check_media(mii, 1, 1);
+	dev_put(dev->net);
+
 	mii_ethtool_gset(&dev->mii, &ecmd);
 	lcladv = smsc75xx_mdio_read(dev->net, mii->phy_id, MII_ADVERTISE);
 	rmtadv = smsc75xx_mdio_read(dev->net, mii->phy_id, MII_LPA);
