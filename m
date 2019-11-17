Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6F0FFB89
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 21:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfKQUAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 15:00:08 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:52274 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfKQUAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 15:00:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=B9e2UHYZAFCbBQsBIwqGKTbc2gaW8g0gGww66sQSAaE=; b=PrbwSX2IduPNDTpHY67LEmO8m
        Hgfu4O4wLgqKFzXvrweKmvSedHwydxHvJrlZuj0y9TCnuySFShGOSB3HJVEMzOBRAfTxuJekiSn09
        jXaibXk7vbfbmtG2WtEQS7vmTCHn1d6hsfv1+rxeMCp2S1VMP3Aty9DxTlFQ04A9/uopZ+dXaeuel
        a1As40ll7MpRWzGfaQ6B9Bwy55mZBpbpmMzNCGvEAppt5frufv1g1yuSt2Ja/e5a8JoCqdeRdCvIX
        Bvx6Be7NdjULQXcBpO0h0gxiSwMj/7QoAYMlhLoIoQcnm7vMnTzbGUdWflAmN3RWZ8otZguTY02Xh
        Pr2/7zzvg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:36832)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iWQiF-0007FJ-Mr; Sun, 17 Nov 2019 19:59:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iWQiD-0007UB-Lz; Sun, 17 Nov 2019 19:59:57 +0000
Date:   Sun, 17 Nov 2019 19:59:57 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: add SFP+ support
Message-ID: <20191117195957.GV25745@shell.armlinux.org.uk>
References: <20191115195339.GR25745@shell.armlinux.org.uk>
 <E1iVhiC-0007bG-Cm@rmk-PC.armlinux.org.uk>
 <20191116160635.GB5653@lunn.ch>
 <20191116214042.GU25745@shell.armlinux.org.uk>
 <20191117192529.GB4084@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191117192529.GB4084@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 17, 2019 at 08:25:29PM +0100, Andrew Lunn wrote:
> > The answer is... it depends.
> 
> Hi Russell
> 
> One issue we have had with phylink is people using the interfaces
> wrongly. When asking this question, i was thinking about
> documentation. Your answer suggests this method is not simply about
> the validation you are doing here, it could also be about
> configuration of the PHY to fit the module.

Err.

Is that not what phylink_sfp_module_insert() is doing - validating that
the module can be supported by the MAC and setting the MAC up for it.

The implementation for marvell10g is no different - I'm not sure why
you're thinking something else is going on here.

> Maybe it would be good to add documentation somewhere about the range
> of things this call can do?
> 
> > So, this patch reflects what can be done with the SFP+ slots on
> > Macchiatobin boards today.
> 
> This all sounds very hardware dependent. So we are going to need some
> more DT properties i guess. Have you thought about this?

I don't see how DT properties help.

DT properties can't stop you plugging in a SFP module into a SFP+ slot
with too strong pullups and corrupting the EEPROM on the SFP module.

There's nothing that really tells you that the module is SFP or SFP+,
and if we wanted to guess, we'd need to read the EEPROM... but reading
the EEPROM might corrupt it - catch-22.

> Maybe we need to add compatibles sff,sfp+ and sff,sff+ ? Indicate the
> board is capable of the higher speeds? And when sfp+/sff+ is used,
> maybe a boolean to indicate it is also sff/sfp compatible?

I've had a patch like that hanging around for a few years.  I've yet to
find anything that could benefit from it or use it to make some kind of
decision in the code.

> sfp_select_interface() can then look at these properties and return
> PHY_INTERFACE_MODE_NA if the board is not capable of supporting the
> module?
> 
> Would it even make sense to make the PHY interface more like the MAC
> interface? A validate function to indicate what it is capable of? A
> configure function to configure its mode towards the SFP?

I don't see how any of that helps.  The problem is not whether the
PHY interface mode is supported it not - on the Macchiatobin DS, the
88x3310 PHY certainly supports 10GBASE-R and 1000BASE-X via the fiber
port.  So it's entirely possible to configure the 3310 to drive a
1G fiber SFP.

The problem on the Macchiatobin is the I2C pull-up resistors, which
either prevent a SFP module being readable or end up corrupting the
SFP module EEPROM in the process of trying (and probably failing) to
read it.  There is nothing the kernel can do to work around that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
