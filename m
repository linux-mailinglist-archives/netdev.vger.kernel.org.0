Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B65FD95B5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 17:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405055AbfJPPgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 11:36:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48680 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbfJPPgx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 11:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+5f6dY8evhyxODaTKehL/4N9iRbwuC90F8UXeraO9vA=; b=KGODKytivjW/MSdVeEUIQ+rVkz
        3ilT5scwlhtrAdRHOF5qItaKrEvpjoegAiPCMPGunYirlMsdopw/WifZ62cYSu1bXEWg3cGchJyqv
        I2zBjIlQlLU5Ufceb9tXkmUxGwTa9MBw9eRtzdp5iw7V2/FWc8ui2HX70BCRCMcncdK8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKlLy-0008Fe-Gc; Wed, 16 Oct 2019 17:36:46 +0200
Date:   Wed, 16 Oct 2019 17:36:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Daniel Wagner <dwagner@suse.de>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Stefan Wahren <wahrenst@gmx.net>,
        linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: lan78xx and phy_state_machine
Message-ID: <20191016153646.GG17013@lunn.ch>
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191014163004.GP25745@shell.armlinux.org.uk>
 <20191014192529.z7c5x6hzixxeplvw@beryllium.lan>
 <25cfc92d-f72b-d195-71b1-f5f238c7988d@gmx.net>
 <b9afd836-613a-dc63-f77b-f9a77d33acc4@gmail.com>
 <20191014221211.GR25745@shell.armlinux.org.uk>
 <524267e6-df8e-d884-aeef-1ed8700e4e58@gmail.com>
 <20191015220925.GW25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015220925.GW25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > - lan78xx_phy_init() (incl. the call to phy_connect_direct()) is called
> >   after register_netdev(). This may cause races.
> 
> That isn't a problem.  We have lots of network device drivers that do
> this - in their open() function.

Hi Russell

Actually, here is it. lan7801_phy_init() finds the PHY device and
connects it to the MAC. lan78xx_open() calls phy_start(), with the
assumption lan7801_phy_init() has been called.

But the stack trace just provided shows this assumption is wrong. As
soon a register_netdev() is called, the kernel auto configuration is
kicking in and opening the device.

lan78xx_phy_init() needs to happen before register_netdev(), or inside
lan78xx_open().

	Andrew
