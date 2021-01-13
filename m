Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099642F48B1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 11:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbhAMK3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 05:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbhAMK3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 05:29:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941C9C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 02:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=z2j4ZRdIfF/WO+9aHK4oZputsnpWdOLry7+NE0MM8dQ=; b=w1SLGilCm67u6Rv+ryswy6tuf
        4RfQY90Rg8cEA1Wh+PL7/vRuYrytv5XH5IhNU6gsyP8CoOzxaeUOp4TbC2IK+HXNHIGWWdQkLu6oc
        oZYb0JqcanX31IIw62c2VmRS8iiTj9pgaetTFvLq7KMaO7RLNqVs1lYQ/Lcgw+WFo68+5NP6xRWkj
        BPaWrgJMDxHUnyB22yDiCQIeCLQQXJNUeUmInawIxF3sPbS6XL2mODl8+6IqMpG+50kOi2wFc4dWO
        L8YaPaOcSCYZQcbH/ZyRLOccyMN9iPf+pv9saW7sAJNbk9FQRxlTSJbRSH19022mM+ndnRHyqKmpz
        bpe0UjUOw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47392)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kzdOU-00013j-1k; Wed, 13 Jan 2021 10:28:50 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kzdOT-0007Dv-6B; Wed, 13 Jan 2021 10:28:49 +0000
Date:   Wed, 13 Jan 2021 10:28:49 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, olteanv@gmail.com,
        pavana.sharma@digi.com
Subject: Re: mv88e6xxx: 2500base-x inband AN is broken on Amethyst? what to
 do?
Message-ID: <20210113102849.GG1551@shell.armlinux.org.uk>
References: <20210113011823.3e407b31@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210113011823.3e407b31@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:18:23AM +0100, Marek Behún wrote:
> Hello,
> 
> it seems that inband AN is broken on Amethyst when on 2500base-x mode.
> 
> Even SERDES scripts for Amethyst from Marvell has autonegotiation
> disabled for 2500base-x mode. For all the other supported Serdes modes
> autonegotiation is enabled in these scripts.
> 
> The current implementation in mv88e6390_serdes_pcs_config() enables
> autonegotiation if phylink_autoneg_inband(mode) is true:
> 
>   if (phylink_autoneg_inband(mode))
>     bmcr = val | BMCR_ANENABLE;
>   else
>     bmcr = val & ~BMCR_ANENABLE;
> 
> But for PHY_INTERFACE_MODE_2500BASEX this is broken on Amethyst. The
> 2500base-x mode seems to work only with autoneg disabled.
> 
> The result is that when I connect via a passive SFP cable Amethyst
> serdes port with a Peridot serdes port, they will not link. If I
> disable autonegotiation on both sides, they will link, though.
> 
> What is strange is that if I don't use Peridot, but connect the SFP
> directly to Serdes on Armada 3720, where the mvneta driver also enables
> autonegotiation for 2500base-x mode, they will link even if Amethyst
> does not enable 2500base-x.
> 
> To summarize:
> 	Amethyst  <->	Peridot
> 	AN -		AN -		works
> 	AN -		AN +		does not work
> 
> 	Amethyst  <->	Armada 3720 serdes
> 	AN -		AN +		works
> 
> (It is possible that Marvell may find some workaround by touch some
>  undocumented registers, to solve this. I will try to open a bug
>  report.)
> 
> Should we just print an error in the serdes_pcs_config method if inband
> autonegotiation is being requested?
> 
> phylink's code currently allows connecting SFPs in non MLO_AN_INBAND
> mode only for when there is Broadcom BCM84881 PHY inside the SFP (by
> method phylink_phy_no_inband() in phylink.c).
> 
> I wonder whether we can somehow in a sane way implement code to inform
> phylink from the mv88e6xxx driver that inband is not supported for the
> specific mode. Maybe the .mac_config/.pcs_config method could return an
> error indicating this? Or the mv88e6xxx driver can just print an error
> that the mode is not supported, and try to ask the user to disable AN?
> That would need implementing this in ethtool for SFP, though.
> 
> What do you guys think?

It's regrettable that some have decided not to have working in-band
AN for 2500base-X, since it prevents the automatic use of pause modes -
which is essentially the only use of in-band negotiation with
1000base-X since many Gigabit MACs do not support half duplex.

I don't know whether the 88x3310 on the host side uses AN or not for
2500base-X - that detail isn't mentioned in the datasheet, and I don't
have a setup that I could test that with.

I had assumed that most people would implement 2500base-X as merely an
upclocked 1000base-X, as mvneta does - unfortunately, there is /no/
published standard for 2500base-X, so we're left guessing what this
should be from the implementations available at the time.

As you have found, whether AN is supported at 2500base-X appears to be
pretty random.

However, phylib has no way to report whether a PHY wants to use in-band
AN to the MAC. Hence the hack in the phylink code for BCM84881. We
really need a better way for phylib to communicate the capabilities of
the PHY to its user (things like which interface modes are supported,
which interface modes may be dynamically switched between, and whether
they can use in-band AN, and whether in-band AN bypass is supported).
Also similar properties for MAC/PCS drivers, then phylink can work out
what should be done.

That still leaves an issue for SFP modules - when they're capable of
supporting 2500base-X, we have no knowledge of the remote side. This is
where knowing whether the MAC/PCS supports in-band AN bypass or not
matters - if it doesn't then disabling in-band AN for 2500base-X may
make sense, otherwise having in-and AN enabled but with bypass enabled
would probably be sensible.

Right now, we just don't have the information to make the correct
decisions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
