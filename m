Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D94584B2
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 16:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfF0Ono (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 10:43:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37094 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726425AbfF0Onn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 10:43:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tx6dF92XYQvz4YacD0VR8WVxRaiNwFBa+2vW1h35TBI=; b=F1tWzUYqbyKtgS6PIeqs3RaAq/
        Q/TGgUztRsGKuL0McSm5Sa5oRGuSsC4zkZiof69ujvLInt7txfhqHyQMgsCNYEpP2QJ55mxWB00u1
        Or12BnnWm+Wc1RVkI9tqCCGVTE71TW+kWZqjxrHv1a9z9piOaW82mLB96XZnBk3/+9JM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgVch-0000Yx-16; Thu, 27 Jun 2019 16:43:39 +0200
Date:   Thu, 27 Jun 2019 16:43:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     jacmet@sunsite.dk, davem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] net: dm9600: false link status
Message-ID: <20190627144339.GG31189@lunn.ch>
References: <20190627132137.GB29016@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627132137.GB29016@Red>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 03:21:37PM +0200, Corentin Labbe wrote:
> Hello
> 
> I own an USB dongle which is a "Davicom DM96xx USB 10/100 Ethernet".
> According to the CHIP_ID, it is a DM9620.
> 
> Since I needed for bringing network to uboot for a board, I have started to create its uboot's driver.
> My uboot driver is based on the dm9600 Linux driver.
> 
> The dongle was working but very very slowy (24Kib/s).
> After some debug i found that the main problem was that it always link to 10Mbit/s Half-duplex. (according to the MAC registers)
> 
> For checking the status of the dongle I have plugged it on a Linux box which give me:
> dm9601 6-2:1.0 enp0s29f0u2: link up, 100Mbps, full-duplex, lpa 0xFFFF
> 
> But in fact the Linux driver is tricked.
> 
> I have added debug of MDIO write/read and got:
> [157550.926974] dm9601 6-2:1.0 (unnamed net_device) (uninitialized): dm9601_mdio_write() phy_id=0x00, loc=0x00, val=0x8000

Writing the reset bit. Ideally you should read back the register and
wait for this bit to clear. Try adding this, and see if this helps, or
you get 0xffff.

> [157550.931962] dm9601 6-2:1.0 (unnamed net_device) (uninitialized): dm9601_mdio_write() phy_id=0x00, loc=0x04, val=0x05e1

Advertisement control register.  

> [157550.951967] dm9601 6-2:1.0 (unnamed net_device) (uninitialized): dm9601_mdio_read() phy_id=0x00, loc=0x00, returns=0xffff

And now things are bad. In theory, the power down bit is set, and some
PHYs don't respond properly when powered down. However, it is unclear
how it got into this state. Did the reset kill it, or setting the
advertisement? Or is the PHY simply not responding at all. The MDIO
data lines have a pull up, so if the device does not respond, reads
give 0xffff.

Maybe also check register 0, bit 7, EXT_PHY. Is it 0, indicating the
internal PHY should be used?

You could also try reading PHY registers 2 and 3 and see if you can
get a valid looking PHY ID. Maybe try that before hitting the reset
bit?

> So it exsists two problem:
> - Linux saying 100Mbps, full-duplex even if it is false.

The driver is using the old mii code, not a phy driver. So i cannot
help too much with linux. But if you can get the MDIO bus working
reliably, it should be possible to move this over to phylib. The
internal PHY appears to have all the standard registers, so the
generic PHY driver has a good chance of working.

     Andrew
