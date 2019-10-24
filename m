Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A19E2FED
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 13:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405174AbfJXLGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 07:06:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:39108 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390184AbfJXLGP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 07:06:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF395B360;
        Thu, 24 Oct 2019 11:06:12 +0000 (UTC)
Date:   Thu, 24 Oct 2019 13:06:10 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
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
Message-ID: <20191024110610.lwwy75dkgwjdxml6@beryllium.lan>
References: <20191018082817.111480-1-dwagner@suse.de>
 <20191018131532.dsfhyiilsi7cy4cm@linutronix.de>
 <20191022101747.001b6d06@cakuba.netronome.com>
 <20191023074719.gcov5xfrcvns5tlg@beryllium.lan>
 <20191023080640.zcw2f2v7fpanoewm@beryllium.lan>
 <20191024104317.32bp32krrjmfb36p@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024104317.32bp32krrjmfb36p@linutronix.de>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 12:43:17PM +0200, Sebastian Andrzej Siewior wrote:
> On 2019-10-23 10:06:40 [+0200], Daniel Wagner wrote:
> 
> Since this does not improve the situation as a whole it might be best to
> remove the code as suggested by Daniel.

I have tried to fix the above issue. It looks like the interrupt
handler doesn't work at all. Below is the log with all debug prints
enabled. I just see one PHY interrupt. Don't know if that is okay or
not.


[    3.719647] lan78xx 1-1.1.1:1.0 (unnamed net_device) (uninitialized): deferred multicast write 0x00007ca0
[    3.861125] lan78xx 1-1.1.1:1.0 (unnamed net_device) (uninitialized): No External EEPROM. Setting MAC Speed
[    3.872500] libphy: lan78xx-mdiobus: probed
[    3.883927] lan78xx 1-1.1.1:1.0 (unnamed net_device) (uninitialized): registered mdiobus bus usb-001:004
[    3.893600] lan78xx 1-1.1.1:1.0 (unnamed net_device) (uninitialized): phydev->irq = 79
[    4.274367] random: crng init done
[    4.929478] lan78xx 1-1.1.1:1.0 eth0: receive multicast hash filter
[    4.935922] lan78xx 1-1.1.1:1.0 eth0: deferred multicast write 0x00007ca2
[    6.537962] lan78xx 1-1.1.1:1.0 eth0: PHY INTR: 0x00020000
[    6.549129] lan78xx 1-1.1.1:1.0 eth0: speed: 1000 duplex: 1 anadv: 0x05e1 anlpa: 0xc1e1
[    6.557293] lan78xx 1-1.1.1:1.0 eth0: rx pause disabled, tx pause disabled
[    6.572581] Sending DHCP requests ..., OK
[   12.200693] IP-Config: Got DHCP answer from 192.168.19.2, my address is 192.168.19.53
[   12.208654] IP-Config: Complete:
[   12.211929]      device=eth0, hwaddr=b8:27:eb:85:c7:c9, ipaddr=192.168.19.53, mask=255.255.255.0, gw=192.168.19.1
[   12.222350]      host=192.168.19.53, domain=, nis-domain=(none)
[   12.228364]      bootserver=192.168.19.2, rootserver=192.168.19.2, rootpath=
[   12.228369]      nameserver0=192.168.19.2
[   12.239812] ALSA device list:
[   12.242839]   No soundcards found.
[   12.256896] VFS: Mounted root (nfs filesystem) on device 0:19.
[   12.263501] devtmpfs: mounted
[   12.273037] Freeing unused kernel memory: 5504K
[   12.277769] Run /sbin/init as init process



and after this the NFS timeouts appear. I tried to figure out how the
PHY works [1] and played a bit around with fiddling with a few bits in
the registers. But now success at all.

I agree with Sebastian, with the revert the driver works at least.

Thanks,
Daniel

[1] http://ww1.microchip.com/downloads/en/DeviceDoc/LAN7800-Data-Sheet-DS00001992G.pdf
