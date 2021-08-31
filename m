Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BB73FCAEF
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 17:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239460AbhHaPfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 11:35:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234068AbhHaPfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 11:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5397161027;
        Tue, 31 Aug 2021 15:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630424087;
        bh=ljSui+3X1JKu0t7ml1Ngl8Kot0p+PiQcPJhO7JyIay8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KUlx18TfuGfyOloBjvVCMfmNv6PE9SvmULMFiO9uydntufR6NpoplZMBXQfifcM4V
         /tWPWSSJP8/pdSZT+rSSxSqoZIncr2ifU302wC2aPtJ2JhHBA100RKK2Y9nFM/vbA7
         4iaaURzbZcSTKBGTCr0r4fzE3XATd0r3PtnYDoBzORt1zGMeSlG6463UmRM6KgEWPO
         ohaFpvzOwLgU+A0yXbGvho0Dt+L/YZSAZPpO6mfpQYSSCCPsEXX/DL1cYa1oPEOXPw
         LVn3RRmm31yMAQQK0nJz7xnRTtT5FgTf0vGxZISQgmnaJpQBMcvig5ZfSAU51Kqy5Q
         FK7MATV4gYQ0g==
Date:   Tue, 31 Aug 2021 08:34:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <linux@rempel-privat.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        syzbot <syzbot+6a916267d9bc5fa2d9a6@syzkaller.appspotmail.com>,
        davem@davemloft.net, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: null-ptr-deref Read in phy_disconnect
Message-ID: <20210831083446.43effd7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a2135e89-e68e-1ba2-770a-84b3b0f5d3ed@rempel-privat.de>
References: <0000000000006a17f905cad88525@google.com>
        <20210831064845.1a8f5c14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YS46wWr6WegVF4Er@lunn.ch>
        <a2135e89-e68e-1ba2-770a-84b3b0f5d3ed@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 17:30:19 +0200 Oleksij Rempel wrote:
> Am 31.08.21 um 16:20 schrieb Andrew Lunn:
> > On Tue, Aug 31, 2021 at 06:48:45AM -0700, Jakub Kicinski wrote:  
> >> On Tue, 31 Aug 2021 03:36:23 -0700 syzbot wrote:  
>  [...]  
> >
> > Looking at the console messages:
> >
> > [   36.456221][   T32] usb 1-1: new high-speed USB device number 2 using dummy_hcd
> > [   36.976035][   T32] usb 1-1: New USB device found, idVendor=0df6, idProduct=0056, bcdDevice=42.6c
> > [   36.985338][   T32] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> > [   36.993579][   T32] usb 1-1: Product: syz
> > [   36.997817][   T32] usb 1-1: Manufacturer: syz
> > [   37.002423][   T32] usb 1-1: SerialNumber: syz
> > [   37.013578][   T32] usb 1-1: config 0 descriptor??
> > [   37.276018][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized): invalid hw address, using random
> > executing program
> > [   37.715517][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
> > [   37.725693][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to send software reset: ffffffb9
> > [   37.925418][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to write reg index 0x0000: -71
> > [   37.936461][   T32] asix 1-1:0.0 (unnamed net_device) (uninitialized): Failed to send software reset: ffffffb9
> > [   38.119561][   T32] asix 1-1:0.0 eth1: register 'asix' at usb-dummy_hcd.0-1, ASIX AX88178 USB 2.0 Ethernet, 8a:c0:d1:1e:27:4c
> > [   38.138828][   T32] usb 1-1: USB disconnect, device number 2
> > [   38.150689][   T32] asix 1-1:0.0 eth1: unregister 'asix' usb-dummy_hcd.0-1, ASIX AX88178 USB 2.0 Ethernet
> >
> > So this is a AX88178, and you would expect it to use
> > ax88178_bind(). That function never calls ax88772_init_phy() which is
> > what connects the PHY to the MAC, and sets priv->phydev.
> >
> > static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
> > {
> >         struct asix_common_private *priv = dev->driver_priv;
> >
> >         phy_disconnect(priv->phydev);
> >
> > So this passes a NULL pointer.
> >
> > static const struct driver_info ax88178_info = {
> >         .description = "ASIX AX88178 USB 2.0 Ethernet",
> >         .bind = ax88178_bind,
> >         .unbind = ax88772_unbind,
> >         .status = asix_status,
> >
> > You cannot pair ax88178_bind with ax88772_unbind. Either a
> > ax88178_unbind is needed, or ax88772_unbind needs to check for a NULL
> > pointer.
> >
> > 	Andrew
> >  
> 
> Yes, this was fixed following patch:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/drivers/net/usb/asix_devices.c?id=1406e8cb4b05fdc67692b1af2da39d7ca5278713

#syz fix: net: usb: asix: do not call phy_disconnect() for ax88178
