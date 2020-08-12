Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954D1242D15
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 18:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHLQWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 12:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgHLQWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 12:22:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC12C061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 09:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ad4ptKyF4KtYj02k+yKPTmhDKS5D30dM0hdznERb3fM=; b=FDz1azZICWtOJj3K70552ztZ1
        NCaQ0C860J/V0pBr1D/Qi7lCQn0+rEtx53x18Fy5T3THQsVAeTWSAra9/FR0yL1E9vDey1lWGH2kM
        /Marx/00MBFe0O8TsrJR2uaqNhDnUIVsRuSZ2FQ/iaDW4DhyCKE26HzJXHEKQIA2bOU28f7v3wkXH
        G1YF0GbOgetaBUFRv/hpzo8oklJTP6fxc6wBkgWYqQRWqDvoV3EfpxBDivZea0hwa8wBRuHqBBGES
        cWfjGfVL1O8FpAIGy2sVgDH9UysZQbaFeA5LrczmtcmGcwYNEbPyApqDv9IBxxfKXCmYpdi8gltah
        9fhxkJEJA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51624)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k5tWK-0002tF-SF; Wed, 12 Aug 2020 17:22:32 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k5tWK-0003xH-E7; Wed, 12 Aug 2020 17:22:32 +0100
Date:   Wed, 12 Aug 2020 17:22:32 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200812162232.GT1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
 <20200810220645.19326-4-marek.behun@nic.cz>
 <20200811152144.GN1551@shell.armlinux.org.uk>
 <20200812164431.34cf569f@dellmb.labs.office.nic.cz>
 <20200812150054.GP1551@shell.armlinux.org.uk>
 <20200812173716.140bed4d@dellmb.labs.office.nic.cz>
 <20200812154837.GQ1551@shell.armlinux.org.uk>
 <20200812181333.69191baf@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200812181333.69191baf@dellmb.labs.office.nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 06:13:33PM +0200, Marek Behún wrote:
> The MACTYPE is not being lost. But changing it requires Port Software
> Reset, which resets the link, so it cannot be done for example in
> read_status.

Wouldn't the right place to configure it be in the config_init()
method - which is called once we have a MAC attaching to the PHY?
As I mentioned, if we had a way to pass the MAC interface supported
mask into phylib, config_init() could then use that to determine what
to do.

> I think the MACTYPE should be set sometime during PHY initialisation,
> and only once: either to XFI with rate matching, if the underlying MAC
> does not support lower modes, or to 10gbase-r/2500base-x/sgmii mode, if
> the underlying MAC supports only slower modes than 10G.

Yes - only changing the MAC type if we have good reason to do so to
support other rates.

There is a related problem however.  Note that if you have an 88x3310
(non-P) in the SFP, then when rate matching is enabled, the PHY will
_not_ generate pause frames, and the PHY expects the MAC to be
configured to pace itself to the slower speed.  I don't believe we
have support in MACs for that, but phylib and therefore phylink
provides the information:

	interface - 10GBASE-R
	speed - media speed
	pause - media pause modes

So, if speed != SPEED_10000 and there are no pause modes, we should,
for the sake of the entire link, pace the MAC to the media speed by
controlling its egress rate.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
