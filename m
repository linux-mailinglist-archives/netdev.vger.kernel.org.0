Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B4D530D33
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbiEWJoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbiEWJoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:44:02 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDFE18352;
        Mon, 23 May 2022 02:43:46 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id EC68010045C16;
        Mon, 23 May 2022 11:43:43 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id CC43171D1E; Mon, 23 May 2022 11:43:43 +0200 (CEST)
Date:   Mon, 23 May 2022 11:43:43 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY interrupts
 to PHY driver to avoid polling
Message-ID: <20220523094343.GA7237@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
 <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
 <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
 <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
 <20220519190841.GA30869@wunner.de>
 <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 11:22:36PM +0200, Marek Szyprowski wrote:
> On 19.05.2022 21:08, Lukas Wunner wrote:
> > Taking a step back though, I'm wondering if there's a bigger problem here:
> > This is a USB device, so we stop receiving interrupts once the Interrupt
> > Endpoint is no longer polled.  But what if a PHY's interrupt is attached
> > to a GPIO of the SoC and that interrupt is raised while the system is
> > suspending?  The interrupt handler may likewise try to reach an
> > inaccessible (suspended) device.
> >
> > The right thing to do would probably be to signal wakeup.  But the
> > PHY drivers' irq handlers instead schedule the phy_state_machine().
> > Perhaps we need something like the following at the top of
> > phy_state_machine():
> >
> > 	if (phydev->suspended) {
> > 		pm_wakeup_dev_event(&phydev->mdio.dev, 0, true);
> > 		return;
> > 	}
> >
> > However, phydev->suspended is set at the *bottom* of phy_suspend(),
> > it would have to be set at the *top* of mdio_bus_phy_suspend()
> > for the above to be correct.  Hmmm...
> 
> Well, your concern sounds valid, but I don't have a board with such hw 
> configuration, so I cannot really test.

I'm torn whether I should submit the quick fix in my last e-mail
or attempt to address the deeper issue.  The quick fix would ensure
v5.19-rc1 isn't broken, but if possible I'd rather address the deeper
issue...

Below is another patch.  Would you mind testing if it fixes the problem
for you?  It's a replacement for the patch in my last e-mail and seeks
to fix the problem for all drivers, not just smsc95xx.  If you don't
have time to test it, let me know and I'll just submit the quick fix
in my previous e-mail.

BTW, getting a PHY interrupt on suspend seems like a corner case to me,
so I'm amazed you found this and seem to be able to reproduce it 100%.
Out of curiosity, is this a CI test you're performing?

Thanks,

Lukas

-- >8 --

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index ef62f357b76d..c2442c38d312 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -31,6 +31,7 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
+#include <linux/suspend.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 #include <net/sock.h>
@@ -976,6 +977,25 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 	struct phy_driver *drv = phydev->drv;
 	irqreturn_t ret;
 
+	if (IS_ENABLED(CONFIG_PM_SLEEP) &&
+	    (phydev->mdio.dev.power.is_prepared ||
+	     phydev->mdio.dev.power.is_suspended)) {
+		struct net_device *netdev = phydev->attached_dev;
+
+		if (netdev) {
+			struct device *parent = netdev->dev.parent;
+
+			if (netdev->wol_enabled)
+				pm_system_wakeup();
+			else if (device_may_wakeup(&netdev->dev))
+				pm_wakeup_dev_event(&netdev->dev, 0, true);
+			else if (parent && device_may_wakeup(parent))
+				pm_wakeup_dev_event(parent, 0, true);
+		}
+
+		return IRQ_HANDLED;
+	}
+
 	mutex_lock(&phydev->lock);
 	ret = drv->handle_interrupt(phydev);
 	mutex_unlock(&phydev->lock);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 431a8719c635..da6d70ddf167 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -283,8 +283,11 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
 	 * may call phy routines that try to grab the same lock, and that may
 	 * lead to a deadlock.
 	 */
-	if (phydev->attached_dev && phydev->adjust_link)
+	if (phydev->attached_dev && phydev->adjust_link) {
+		if (phy_interrupt_is_valid(phydev))
+			synchronize_irq(phydev->irq);
 		phy_stop_machine(phydev);
+	}
 
 	if (!mdio_bus_phy_may_suspend(phydev))
 		return 0;
