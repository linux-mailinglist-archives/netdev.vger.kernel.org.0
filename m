Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35CC3A2E02
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhFJOYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbhFJOYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:24:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAD5C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 07:22:40 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lrLZo-0007eu-1E; Thu, 10 Jun 2021 16:22:32 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lrLZn-0002iX-JU; Thu, 10 Jun 2021 16:22:31 +0200
Date:   Thu, 10 Jun 2021 16:22:31 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/8] net: usb: asix: ax88772: add phylib
 support
Message-ID: <20210610142231.jwan57reetfsuyjw@pengutronix.de>
References: <20210607082727.26045-1-o.rempel@pengutronix.de>
 <20210607082727.26045-5-o.rempel@pengutronix.de>
 <CGME20210609095923eucas1p2e692c9a482151742d543316c91f29802@eucas1p2.samsung.com>
 <84ff1dab-ab0a-f27c-a948-e1ebdf778485@samsung.com>
 <0ebb1698-cd52-d8ad-b5cc-045d29ea964f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ebb1698-cd52-d8ad-b5cc-045d29ea964f@nvidia.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:21:02 up 190 days,  4:27, 50 users,  load average: 0.07, 0.04,
 0.01
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek and Jon,

I just send a patch to fix suspend/resume. It was tested on ax88772A and ax88772C
on iMX6 host. Can you please confirm if it works for you?

Regards,
Oleksij

net: usb: asix: ax88772: manage PHY PM from MAC 

On Thu, Jun 10, 2021 at 01:54:12PM +0100, Jon Hunter wrote:
> 
> On 09/06/2021 10:59, Marek Szyprowski wrote:
> > Hi Oleksij,
> > 
> > On 07.06.2021 10:27, Oleksij Rempel wrote:
> >> To be able to use ax88772 with external PHYs and use advantage of
> >> existing PHY drivers, we need to port at least ax88772 part of asix
> >> driver to the phylib framework.
> >>
> >> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > 
> > This patch landed recently in linux-next as commit e532a096be0e ("net: 
> > usb: asix: ax88772: add phylib support"). I found that it causes some 
> > warnings on boards with those devices, see the following log:
> > 
> > root@target:~# time rtcwake -s10 -mmem
> > rtcwake: wakeup from "mem" using /dev/rtc0 at Wed Jun  9 08:16:41 2021
> > [  231.226579] PM: suspend entry (deep)
> > [  231.231697] Filesystems sync: 0.002 seconds
> > [  231.261761] Freezing user space processes ... (elapsed 0.002 seconds) 
> > done.
> > [  231.270526] OOM killer disabled.
> > [  231.273557] Freezing remaining freezable tasks ... (elapsed 0.002 
> > seconds) done.
> > [  231.282229] printk: Suspending console(s) (use no_console_suspend to 
> > debug)
> > ...
> > [  231.710852] Disabling non-boot CPUs ...
> > ...
> > [  231.901794] Enabling non-boot CPUs ...
> > ...
> > [  232.225640] usb usb3: root hub lost power or was reset
> > [  232.225746] usb usb1: root hub lost power or was reset
> > [  232.225864] usb usb5: root hub lost power or was reset
> > [  232.226206] usb usb6: root hub lost power or was reset
> > [  232.226207] usb usb4: root hub lost power or was reset
> > [  232.297749] usb usb2: root hub lost power or was reset
> > [  232.343227] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
> > [  232.343293] asix 3-1:1.0 eth0: Failed to enable software MII access
> > [  232.344486] asix 3-1:1.0 eth0: Failed to read reg index 0x0000: -22
> > [  232.344512] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -22
> > [  232.344529] PM: dpm_run_callback(): mdio_bus_phy_resume+0x0/0x78 
> > returns -22
> > [  232.344554] Asix Electronics AX88772C usb-003:002:10: PM: failed to 
> > resume: error -22
> > [  232.563712] usb 1-1: reset high-speed USB device number 2 using 
> > exynos-ehci
> > [  232.757653] usb 3-1: reset high-speed USB device number 2 using xhci-hcd
> > [  233.730994] OOM killer enabled.
> > [  233.734122] Restarting tasks ... done.
> > [  233.754992] PM: suspend exit
> 
> 
> I am seeing a similar problem on a couple of our Tegra boards that
> use AX88772A device. When resuming from suspend I see ...
> 
> [   54.733266] PM: suspend entry (deep)
> 
> [   54.737179] Filesystems sync: 0.000 seconds
> 
> [   54.741904] Freezing user space processes ... (elapsed 0.001 seconds) done.
> 
> [   54.750895] OOM killer disabled.
> 
> [   54.754452] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
> 
> [   54.763505] printk: Suspending console(s) (use no_console_suspend to debug)
> 
> [   54.898334] Disabling non-boot CPUs ...
> 
> [   54.899546] IRQ 26: no longer affine to CPU1
> 
> [   54.924373] Entering suspend state LP1
> 
> [   54.924493] Enabling non-boot CPUs ...
> 
> [   54.933164] CPU1 is up
> 
> [   55.005166] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -113
> 
> [   55.005226] asix 3-1:1.0 eth0: Failed to enable software MII access
> 
> [   55.006579] asix 3-1:1.0 eth0: Failed to read reg index 0x0000: -113
> 
> [   55.006722] asix 3-1:1.0 eth0: Failed to write reg index 0x0000: -113
> 
> [   55.006762] asix 3-1:1.0 eth0: Failed to enable software MII access
> 
> 
> Interestingly once commit d275afb66371 ("net: usb: asix: add error
> handling for asix_mdio_* functions") is applied, then resume from
> suspend completely fails because the error is propagated. Bisect
> is pointing to that patch, however, it is this patch that is
> causing the problem.
> 
> Cheers
> Jon
> 
> -- 
> nvpublic
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
