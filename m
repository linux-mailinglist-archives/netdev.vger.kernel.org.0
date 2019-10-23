Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC62E1399
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 10:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390140AbfJWIGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 04:06:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:48138 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727574AbfJWIGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 04:06:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9EFE6BB24;
        Wed, 23 Oct 2019 08:06:40 +0000 (UTC)
Date:   Wed, 23 Oct 2019 10:06:40 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Stefan Wahren <wahrenst@gmx.net>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] net: usb: lan78xx: Use phy_mac_interrupt() for interrupt
 handling
Message-ID: <20191023080640.zcw2f2v7fpanoewm@beryllium.lan>
References: <20191018082817.111480-1-dwagner@suse.de>
 <20191018131532.dsfhyiilsi7cy4cm@linutronix.de>
 <20191022101747.001b6d06@cakuba.netronome.com>
 <20191023074719.gcov5xfrcvns5tlg@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023074719.gcov5xfrcvns5tlg@beryllium.lan>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sebastian suggested to try this here:

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1264,8 +1264,11 @@ static void lan78xx_status(struct lan78xx_net *dev, struct urb *urb)
                netif_dbg(dev, link, dev->net, "PHY INTR: 0x%08x\n", intdata);
                lan78xx_defer_kevent(dev, EVENT_LINK_RESET);
 
-               if (dev->domain_data.phyirq > 0)
+               if (dev->domain_data.phyirq > 0) {
+                       local_irq_disable();
                        generic_handle_irq(dev->domain_data.phyirq);
+                       local_irq_enable();
+               }
        } else
                netdev_warn(dev->net,
                            "unexpected interrupt: 0x%08x\n", intdata);

While this gets rid of the warning, the networking interface is not
really stable:

[   43.999628] nfs: server 192.168.19.2 not responding, still trying
[   43.999633] nfs: server 192.168.19.2 not responding, still trying
[   43.999649] nfs: server 192.168.19.2 not responding, still trying
[   43.999674] nfs: server 192.168.19.2 not responding, still trying
[   43.999678] nfs: server 192.168.19.2 not responding, still trying
[   44.006712] nfs: server 192.168.19.2 OK
[   44.018443] nfs: server 192.168.19.2 OK
[   44.024765] nfs: server 192.168.19.2 OK
[   44.025361] nfs: server 192.168.19.2 OK
[   44.025420] nfs: server 192.168.19.2 OK
[  256.991659] nfs: server 192.168.19.2 not responding, still trying
[  256.991664] nfs: server 192.168.19.2 not responding, still trying
[  256.991669] nfs: server 192.168.19.2 not responding, still trying
[  256.991685] nfs: server 192.168.19.2 not responding, still trying
[  256.991713] nfs: server 192.168.19.2 not responding, still trying
[  256.998797] nfs: server 192.168.19.2 OK
[  256.999745] nfs: server 192.168.19.2 OK
[  256.999828] nfs: server 192.168.19.2 OK
[  257.000438] nfs: server 192.168.19.2 OK
[  257.004784] nfs: server 192.168.19.2 OK


Eventually, the rootfs can be loaded and the system boots. Though the
system is not really usable because it often stalls:


root@debian:~# apt update
Ign:1 http://deb.debian.org/debian stretch InRelease
Hit:2 http://deb.debian.org/debian stretch Release
Reading package lists... 0% 


I don't see this with the irqdomain code reverted.
