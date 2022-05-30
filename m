Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D21D538133
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbiE3OO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240581AbiE3OMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:12:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88C9E52A5;
        Mon, 30 May 2022 06:43:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C6E9B80D83;
        Mon, 30 May 2022 13:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22821C3411E;
        Mon, 30 May 2022 13:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918162;
        bh=x4B8zV580+azv9vAE3GUqPaunN3G/DT9gCW5iU7BFrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oM4olH1TiNqqzik2850SNFLatZbXcFlqLgbnCsxmwmLvC5zTezvC4hQH870yyGi+7
         FFNifitfw78O0YZk4CnrWF4cwleRmDH9MT/yfy+bveoGDxz8VYsrnb90HODVAeyVig
         4wMpr6iGobcHARW3lhYG03s1AeotWEgjYieRdNFpPzsNn1uZVOkupQE8baW0NgO4SI
         m7BZaNUo29QnuPeV+uHbVmDkJ33XWNfiLkGZy0SXbJPLe9YhyL4vULxSvlxghk8BQx
         SXpFVKvObAqUy0o7fLP224RgIKhrDjPgL7OIHLy7bEEPOwXN5w9a9rzlhTsfS4vtey
         AZB6a29WRNb1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Wunner <lukas@wunner.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Martyn Welch <martyn.welch@collabora.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, linux@rempel-privat.de,
        colin.king@intel.com, paskripkin@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 082/109] usbnet: Run unregister_netdev() before unbind() again
Date:   Mon, 30 May 2022 09:37:58 -0400
Message-Id: <20220530133825.1933431-82-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit d1408f6b4dd78fb1b9e26bcf64477984e5f85409 ]

Commit 2c9d6c2b871d ("usbnet: run unbind() before unregister_netdev()")
sought to fix a use-after-free on disconnect of USB Ethernet adapters.

It turns out that a different fix is necessary to address the issue:
https://lore.kernel.org/netdev/18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de/

So the commit was not necessary.

The commit made binding and unbinding of USB Ethernet asymmetrical:
Before, usbnet_probe() first invoked the ->bind() callback and then
register_netdev().  usbnet_disconnect() mirrored that by first invoking
unregister_netdev() and then ->unbind().

Since the commit, the order in usbnet_disconnect() is reversed and no
longer mirrors usbnet_probe().

One consequence is that a PHY disconnected (and stopped) in ->unbind()
is afterwards stopped once more by unregister_netdev() as it closes the
netdev before unregistering.  That necessitates a contortion in ->stop()
because the PHY may only be stopped if it hasn't already been
disconnected.

Reverting the commit allows making the call to phy_stop() unconditional
in ->stop().

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Oliver Neukum <oneukum@suse.com>
Cc: Martyn Welch <martyn.welch@collabora.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_devices.c | 6 +-----
 drivers/net/usb/smsc95xx.c     | 3 +--
 drivers/net/usb/usbnet.c       | 6 +++---
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index bd8f8619ad6f..396505396a2e 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -799,11 +799,7 @@ static int ax88772_stop(struct usbnet *dev)
 {
 	struct asix_common_private *priv = dev->driver_priv;
 
-	/* On unplugged USB, we will get MDIO communication errors and the
-	 * PHY will be set in to PHY_HALTED state.
-	 */
-	if (priv->phydev->state != PHY_HALTED)
-		phy_stop(priv->phydev);
+	phy_stop(priv->phydev);
 
 	return 0;
 }
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index eb0d325e92b7..4e39e4345084 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1217,8 +1217,7 @@ static int smsc95xx_start_phy(struct usbnet *dev)
 
 static int smsc95xx_stop(struct usbnet *dev)
 {
-	if (dev->net->phydev)
-		phy_stop(dev->net->phydev);
+	phy_stop(dev->net->phydev);
 
 	return 0;
 }
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index a33d7fb82a00..af2bbaff2478 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1614,9 +1614,6 @@ void usbnet_disconnect (struct usb_interface *intf)
 		   xdev->bus->bus_name, xdev->devpath,
 		   dev->driver_info->description);
 
-	if (dev->driver_info->unbind)
-		dev->driver_info->unbind(dev, intf);
-
 	net = dev->net;
 	unregister_netdev (net);
 
@@ -1624,6 +1621,9 @@ void usbnet_disconnect (struct usb_interface *intf)
 
 	usb_scuttle_anchored_urbs(&dev->deferred);
 
+	if (dev->driver_info->unbind)
+		dev->driver_info->unbind(dev, intf);
+
 	usb_kill_urb(dev->interrupt);
 	usb_free_urb(dev->interrupt);
 	kfree(dev->padding_pkt);
-- 
2.35.1

