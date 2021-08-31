Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33F13FC9A3
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 16:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhHaOVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 10:21:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230135AbhHaOVy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 10:21:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bkzQryUC9VMNEg1re0qIAX363VNCQlN54z1700v8XqI=; b=bfZP1pxv2sP2bSyYP4Ni9erzqv
        Esy3NVVdGUpCG5rGpoAMDmjX8feP3djTiXZEU/bP4y7Z4SwFF3ZYyO9gL8suXHKG5IBj4f98rfJfa
        oyzEfe1TfkBzicZBd5kvGht4adR7JH9zA6DzeypHVWoPRDxwE5SwGanYDbkCBKiUCPvU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mL4d7-004jET-9a; Tue, 31 Aug 2021 16:20:49 +0200
Date:   Tue, 31 Aug 2021 16:20:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+6a916267d9bc5fa2d9a6@syzkaller.appspotmail.com>,
        davem@davemloft.net, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [syzbot] KASAN: null-ptr-deref Read in phy_disconnect
Message-ID: <YS46wWr6WegVF4Er@lunn.ch>
References: <0000000000006a17f905cad88525@google.com>
 <20210831064845.1a8f5c14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831064845.1a8f5c14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 06:48:45AM -0700, Jakub Kicinski wrote:
> On Tue, 31 Aug 2021 03:36:23 -0700 syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    9c1587d99f93 usb: isp1760: otg control register access
> > git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16907291300000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=24756feea212a6b0
> > dashboard link: https://syzkaller.appspot.com/bug?extid=6a916267d9bc5fa2d9a6
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166de449300000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c5ddce300000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+6a916267d9bc5fa2d9a6@syzkaller.appspotmail.com
> > 
> > asix 1-1:0.0 eth1: register 'asix' at usb-dummy_hcd.0-1, ASIX AX88178 USB 2.0 Ethernet, 8a:c0:d1:1e:27:4c
> > usb 1-1: USB disconnect, device number 2
> > asix 1-1:0.0 eth1: unregister 'asix' usb-dummy_hcd.0-1, ASIX AX88178 USB 2.0 Ethernet
> > general protection fault, probably for non-canonical address 0xdffffc00000000c3: 0000 [#1] SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000618-0x000000000000061f]
> > CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 5.14.0-rc7-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Workqueue: usb_hub_wq hub_event
> > RIP: 0010:phy_is_started include/linux/phy.h:947 [inline]
> > RIP: 0010:phy_disconnect+0x22/0x110 drivers/net/phy/phy_device.c:1097
> > Code: 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 46 33 68 fe 48 8d bd 18 06 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e c5 00 00 00 8b 9d 18 06 00 00
> > RSP: 0018:ffffc900001a7780 EFLAGS: 00010206
> > RAX: dffffc0000000000 RBX: ffff88811a410bc0 RCX: 0000000000000000
> > RDX: 00000000000000c3 RSI: ffffffff82d9305a RDI: 0000000000000618
> > RBP: 0000000000000000 R08: 0000000000000055 R09: 0000000000000000
> > R10: ffffffff814c05fb R11: 0000000000000000 R12: ffff8881063cc300
> > R13: ffffffff83870d90 R14: ffffffff86805a20 R15: ffffffff868059e0
> > FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fb4c30b3008 CR3: 00000001021e1000 CR4: 00000000001506e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  ax88772_unbind+0x51/0x90 drivers/net/usb/asix_devices.c:816

Looking at the console messages:

[   36.456221][   T32] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[   36.976035][   T32] usb 1-1: New USB device found, idVendor=0df6, idProduct=0056, bcdDevice=42.6c
[   36.985338][   T32] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   36.993579][   T32] usb 1-1: Product: syz
[   36.997817][   T32] usb 1-1: Manufacturer: syz
[   37.002423][   T32] usb 1-1: SerialNumber: syz
[   37.013578][   T32] usb 1-1: config 0 descriptor??
[   37.276018][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized): invalid hw address, using random
executing program
[   37.715517][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
[   37.725693][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to send software reset: ffffffb9
[   37.925418][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
[   37.936461][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to send software reset: ffffffb9
[   38.119561][   T32] asix 1-1:0.0 eth1: register 'asix' at usb-dummy_hcd.0-1, ASIX AX88178 USB 2.0 Ethernet, 8a:c0:d1:1e:27:4c
[   38.138828][   T32] usb 1-1: USB disconnect, device number 2
[   38.150689][   T32] asix 1-1:0.0 eth1: unregister 'asix' usb-dummy_hcd.0-1, ASIX AX88178 USB 2.0 Ethernet

So this is a AX88178, and you would expect it to use
ax88178_bind(). That function never calls ax88772_init_phy() which is
what connects the PHY to the MAC, and sets priv->phydev.

static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
{
        struct asix_common_private *priv = dev->driver_priv;

        phy_disconnect(priv->phydev);

So this passes a NULL pointer.

static const struct driver_info ax88178_info = {
        .description = "ASIX AX88178 USB 2.0 Ethernet",
        .bind = ax88178_bind,
        .unbind = ax88772_unbind,
        .status = asix_status,

You cannot pair ax88178_bind with ax88772_unbind. Either a
ax88178_unbind is needed, or ax88772_unbind needs to check for a NULL
pointer.

	Andrew
