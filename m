Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0442E7C1C
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 20:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgL3TTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 14:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgL3TTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 14:19:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C664AC061573;
        Wed, 30 Dec 2020 11:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=r/z1inj8FQdVisFvXnpwI9YCFx5TnOdX+x4O7YbttV0=; b=T227hwb8T/177T2Zid5Cdrydk
        YmBY01dQwc2DVlR0qjcC7BySVrZAB9VZKIlJdCiCLLf6HRjy4Xx1W4eq+JtCym9gTawjRbkVnr3kM
        /wbFgAr0RQQrFlVFZA6q/rEQvrjp7zOfigL5s1cZza79nrKKiJV9F1Nc1kA6x3VaQcJxMX2OlYjpn
        qklQenkgM0ujaVrmGTmNR02VfsVF3rcS8fkiXvMPZr/XiAov5dNW3ivUAqonRp3oBqAqEyL0ookGa
        +Lgt3akjuKmEs25JZhg8Olm2xiE3lS0YVZQ+umDRlqwcAtjZ9p8eUS/UY3xkiuxSE4o/w1TbTzXkA
        kK4tMWUkg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44930)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kugzJ-0005tv-Ny; Wed, 30 Dec 2020 19:18:25 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kugzJ-0002RK-C5; Wed, 30 Dec 2020 19:18:25 +0000
Date:   Wed, 30 Dec 2020 19:18:25 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20201230191825.GY1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <20201230173152.7dlq6t5erhspwhvs@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230173152.7dlq6t5erhspwhvs@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 06:31:52PM +0100, Pali Rohár wrote:
> On Wednesday 30 December 2020 17:05:46 Russell King - ARM Linux admin wrote:
> > On Wed, Dec 30, 2020 at 05:56:34PM +0100, Pali Rohár wrote:
> > > This change is really required for those Realtek chips. I thought that
> > > it is obvious that from *both* addresses 0x50 and 0x51 can be read only
> > > one byte at the same time. Reading 2 bytes (for be16 value) cannot be
> > > really done by one i2 transfer, it must be done in two.
> > 
> > Then these modules are even more broken than first throught, and
> > quite simply it is pointless supporting the diagnostics on them
> > because we can never read the values in an atomic way.
> 
> They are broken in a way that neither holy water help them...
> 
> But from diagnostic 0x51 address we can read at least 8bit registers in
> atomic way :-)

... which doesn't fit the requirements.

> > It's also a violation of the SFF-8472 that _requires_ multi-byte reads
> > to read these 16 byte values atomically. Reading them with individual
> > byte reads results in a non-atomic read, and the 16-bit value can not
> > be trusted to be correct.
> > 
> > That is really not optional, no matter what any manufacturer says - if
> > they claim the SFP MSAs allows it, they're quite simply talking out of
> > a donkey's backside and you should dispose of the module in biohazard
> > packaging. :)
> > 
> > So no, I hadn't understood this from your emails, and as I say above,
> > if this is the case, then we quite simply disable diagnostics on these
> > modules since they are _highly_ noncompliant.
> 
> We have just two options:
> 
> Disable 2 (and more) bytes reads from 0x51 address and therefore disable
> sfp_hwmon_read_sensor() function.
> 
> Or allow 2 bytes non-atomic reads and allow at least semi-correct values
> for hwmon. I guess that upper 8bits would not change between two single
> byte i2c transfers too much (when they are done immediately one by one).

So when you read the temperature, and the MSB reads as the next higher
value than the LSB, causing an error of 256, or vice versa causing an
error of -256, which when scaled according to the factors causes a big
error, that's acceptable.

No, it isn't. If the data can't be read reliably, the data is useless.

Consider a system that implements userspace monitoring for modules and
checks the current values against pre-set thresholds - it suddenly gets
a value that is outside of its alarm threshold due to this. It raises a
false alarm. This is not good.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
