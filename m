Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000232F5831
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbhANCPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:15:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbhAMVWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:22:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F1AC061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bGLVOlLkBohnhoS0gzHJ866sklUDLEGWyezjZOSoJ8w=; b=LSRxDMbfI/rbWaIlfNb7mMmd8
        FAE1h6IAtLnH5fL1IdjfvED8CzzkCPghD17mCunudCUSy890FwGnp3LWLGqKI40v9r7++0EH+jMja
        vCbWxn0pacV6KYRDi2P8X3IUOhMa7yxTGY5A862RvLsjpknA1xXA8Pk9mPkJXL2et/LGF6PBwkSG0
        Bx1GM0c3uQDwa5b38S7rDEcyncyrVfw6fqfWkhFyHecyiRxTP0V5wYpzxCEeNpZdSVORwYWB04HlX
        7LnqRVeqVEn1nUU0KBGaRBCPoOrd5x+ankfrVY1UrOvbP2/dIACdbOkOUpJSWpcxqae3JrVyg4Qjl
        sgf+EQCdw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47586)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kzna2-0001gY-Cs; Wed, 13 Jan 2021 21:21:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kzna1-0007dY-FC; Wed, 13 Jan 2021 21:21:25 +0000
Date:   Wed, 13 Jan 2021 21:21:25 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        pavana.sharma@digi.com
Subject: Re: mv88e6xxx: 2500base-x inband AN is broken on Amethyst? what to
 do?
Message-ID: <20210113212125.GJ1551@shell.armlinux.org.uk>
References: <20210113011823.3e407b31@kernel.org>
 <20210113102849.GG1551@shell.armlinux.org.uk>
 <20210113210839.40bb9446@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210113210839.40bb9446@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 09:08:39PM +0100, Marek Behún wrote:
> OK, so I did some tests with Peridot and 88X3310:
> 
> On 88E6390 switch, when CMODE in the port register for a port capable of
> SerDes is set to 1000base-x, the switch self-configures the SerDes PHY
> to inband AN:
>   register 4.2000 has value 0x1940
> 
> but when CMODE is set to 2500base-x, the switch self-configure the PHY
> without inband AN:
>   register 4.2000 has value 0x0940
> 
> Also the 88X3310 PHY, when configured with MACTYPE=4
>  (that is the mode that switches host interface between
>   10gbase-r/5gbase-r/2500base-x/sgmii, depending on copper speed)
> and when copper speed is 2500, the PHY self-configures without inband
> AN:
>   register 4.2000 has value 0x0140
> 
> It seems to me that on these Marvell devices, they consider 2500base-x
> not capable of inband AN and disable it by default.
> 
> Moreover when the PHY has disabled inband AN and the Peridot switch has
> it enabled (by software), they won't link. I tried enabling the inband
> AN on the PHY, but it does not seem to work. Peridot can only
> communicate with the PHY in 2500base-x with inband AN disabled.
> 
> This means that the commit
>   a5a6858b793ff ("net: dsa: mv88e6xxx: extend phylink to Serdes PHYs")
> causes a regression, since the code started enabling inband AN on
> 2500base-x mode on the mv88e6390 family, and they stopped working with
> the PHY.
> 
> Russell, could we, for now, just edit the code so that when
>   mv88e6390_serdes_pcs_config
> is being configured with inband mode in 2500base-x, the inband mode
> won't be enabled and the function will print a warning?
> This could come with a Fixes tag so that it is backported to stable.

I don't see any other easy option, so yes, please do that.

> Afterwards we can work on refactoring the phylink code so that either
> the driver can inform phylink whether 2500base-x inband AN is supported,
> or maybe we can determine from some documentation or whatnot whether
> inband AN is supported on 2500base-x at all.

I suspect there is no definitive documentation on exactly what
2500base-x actually is. I suspect it may just be easier to turn off AN
for 2500base-x everywhere, so at least all Linux systems are compatible
irrespective of the hardware.

Yes, it means losing pause negotiation, and people will have to
manually set pause on each end.

One thing that I don't know is whether the GPON SFP ONT modules that
use 2500base-x will still function with AN disabled - although I have
the modules, it appeared that they both needed a connection to the ONU
to switch from 1000base-x to 2500base-x on the host side - and as I
don't have an ONU I can test with, I have no way to check their
behaviour.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
