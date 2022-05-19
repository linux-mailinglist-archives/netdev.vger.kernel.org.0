Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E554F52DD6E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 21:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243590AbiESTIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 15:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiESTIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 15:08:51 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0077AAE26B;
        Thu, 19 May 2022 12:08:49 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id BB09B280F2F66;
        Thu, 19 May 2022 21:08:41 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id A2A862E66F4; Thu, 19 May 2022 21:08:41 +0200 (CEST)
Date:   Thu, 19 May 2022 21:08:41 +0200
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
Message-ID: <20220519190841.GA30869@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
 <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
 <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
 <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 12:18:45PM +0200, Marek Szyprowski wrote:
> This patch landed in the recent linux next-20220516 as commit 
> 1ce8b37241ed ("usbnet: smsc95xx: Forward PHY interrupts to PHY driver to 
> avoid polling"). Unfortunately it breaks smsc95xx usb ethernet operation 
> after system suspend-resume cycle. On the Odroid XU3 board I got the 
> following warning in the kernel log:
> 
> # time rtcwake -s10 -mmem
> rtcwake: wakeup from "mem" using /dev/rtc0 at Tue May 17 09:16:07 2022
> PM: suspend entry (deep)
> Filesystems sync: 0.001 seconds
> Freezing user space processes ... (elapsed 0.002 seconds) done.
> OOM killer disabled.
> Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> printk: Suspending console(s) (use no_console_suspend to debug)
> smsc95xx 4-1.1:1.0 eth0: entering SUSPEND2 mode
> smsc95xx 4-1.1:1.0 eth0: Failed to read reg index 0x00000114: -113
> smsc95xx 4-1.1:1.0 eth0: Error reading MII_ACCESS
> smsc95xx 4-1.1:1.0 eth0: __smsc95xx_mdio_read: MII is busy
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 73 at drivers/net/phy/phy.c:946
> phy_state_machine+0x98/0x28c
[...]
> It looks that the driver's suspend/resume operations might need some 
> adjustments. After the system suspend/resume cycle the driver is not 
> operational anymore. Reverting the $subject patch on top of linux 
> next-20220516 restores ethernet operation after system suspend/resume.

Thanks a lot for the report.  It seems the PHY is signaling a link change
shortly before system sleep and by the time the phy_state_machine() worker
gets around to handle it, the device has already been suspended and thus
refuses any further USB requests with -EHOSTUNREACH (-113):

usb_suspend_both()
  usb_suspend_interface()
    smsc95xx_suspend()
      usbnet_suspend()
        __usbnet_status_stop_force() # stops interrupt polling,
                                     # link change is signaled before this

  udev->can_submit = 0               # refuse further URBs

Assuming the above theory is correct, calling phy_stop_machine()
after usbnet_suspend() would be sufficient to fix the issue.
It cancels the phy_state_machine() worker.

The small patch below does that.  Could you give it a spin?

Taking a step back though, I'm wondering if there's a bigger problem here:
This is a USB device, so we stop receiving interrupts once the Interrupt
Endpoint is no longer polled.  But what if a PHY's interrupt is attached
to a GPIO of the SoC and that interrupt is raised while the system is
suspending?  The interrupt handler may likewise try to reach an
inaccessible (suspended) device.

The right thing to do would probably be to signal wakeup.  But the
PHY drivers' irq handlers instead schedule the phy_state_machine().
Perhaps we need something like the following at the top of
phy_state_machine():

	if (phydev->suspended) {
		pm_wakeup_dev_event(&phydev->mdio.dev, 0, true);
		return;
	}

However, phydev->suspended is set at the *bottom* of phy_suspend(),
it would have to be set at the *top* of mdio_bus_phy_suspend()
for the above to be correct.  Hmmm...

Thanks,

Lukas

-- >8 --
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bd03e16..d351a6c 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1201,6 +1201,7 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 
 	pdata->phydev->irq = phy_irq;
+	pdata->phydev->mac_managed_pm = true;
 	pdata->phydev->is_internal = is_internal_phy;
 
 	/* detect device revision as different features may be available */
@@ -1496,6 +1497,9 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 		return ret;
 	}
 
+	if (netif_running(dev->net))
+		phy_stop(pdata->phydev);
+
 	if (pdata->suspend_flags) {
 		netdev_warn(dev->net, "error during last resume\n");
 		pdata->suspend_flags = 0;
@@ -1778,6 +1782,8 @@ static int smsc95xx_resume(struct usb_interface *intf)
 	}
 
 	phy_init_hw(pdata->phydev);
+	if (netif_running(dev->net))
+		phy_start(pdata->phydev);
 
 	ret = usbnet_resume(intf);
 	if (ret < 0)
