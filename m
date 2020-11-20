Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1328A2BA769
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 11:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgKTKZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 05:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgKTKZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 05:25:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B60FC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 02:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cbnfcg8hQqdklPCgA3Zf7SeXW0nLdy3GH5PLOygQOcc=; b=FSekwy7DqS/B558Ca+priXqph
        sbVvcFKh/liKbrvl4Dwrp5F6hs+/5vWdJ7mWAr7wqpMTXKTwAqwL8Kgt9qxB5XnaVC9/SqEc63ufv
        452Rpy2n5htKKscUTa5jp1M4HIPXhGBAjAOudI1W6mZKHVi6DbnCQD4hlS3ZVRI4yIIuYMC4Rt7A3
        j86m7dbP88YddAjNp5CyyUL7sCjbjTOr1uEZ7RZUJV+luj19Jd0T0yWWAVCJ5c2K26j4+I65gP+3M
        ySxpmI/k2a9SeMsikbVABAvdro5YsaMsVEdRq/Eo0vM/q7GF3H1qbSgnP9suyPV9rQ8uSqJVNfuk3
        ZNWoBKuGQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33784)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kg3bp-0003L1-MW; Fri, 20 Nov 2020 10:25:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kg3bm-00034e-7Y; Fri, 20 Nov 2020 10:25:38 +0000
Date:   Fri, 20 Nov 2020 10:25:38 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
Message-ID: <20201120102538.GP1551@shell.armlinux.org.uk>
References: <20201119152246.085514e1@bootlin.com>
 <20201119145500.GL1551@shell.armlinux.org.uk>
 <20201119162451.4c8d220d@bootlin.com>
 <87k0uh9dd0.fsf@waldekranz.com>
 <20201119231613.GN1551@shell.armlinux.org.uk>
 <87eekoanvj.fsf@waldekranz.com>
 <20201120103601.313a166b@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120103601.313a166b@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 10:36:01AM +0100, Maxime Chevallier wrote:
> So maybe we could be a bit more generic, with something along these lines :
> 
>     ethernet-phy@0 {
>         ...
> 
>         mdi {
>             port@0 {
>                 media = "10baseT", "100baseT", "1000baseT";
>                 pairs = <1>;
> 	    };
> 
>             port@1 {
>                 media = "1000baseX", "10gbaseR"
>             };
>         };
>     };

Don't forget that TP requires a minimum of two pairs. However, as
Andrew pointed out, we already have max-speed which can be used to
limit the speed below that which requires four pairs.

I have untested patches that allow the 88x3310 to be reconfigured
between 10GBASE-R and 1000BASE-X depending on the SFP connected -
untested because the I2C pull-ups on the Macchiatobin boards I have
are way too strong and it results in SFP EEPROM corruption and/or
failure to read the EEPROM.

> I also like the idea of having a way to express the "preferred" media,
> although I wonder if that's something we want to include in DT or that
> we would want to tweak at runtime, through ethtool for example.

I think preferred media should be configurable through ethtool -
which is preferred will be specific to the user's application.
However, there may be scope for DT to be able to specify the default
preferred media.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
