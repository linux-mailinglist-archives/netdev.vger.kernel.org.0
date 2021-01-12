Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5472F35D6
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392743AbhALQa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392179AbhALQaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:30:25 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940A9C06179F
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 08:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AhHHiuPGvMNUmEiXO/NNkJkFQnW3au6lNGVQrV2PKec=; b=wMyco02XJBnN2ZBZPFaNX54ep
        yBjmLTK4gRhfxAIxj5UIsRMWGfLy7sxcdz1QOGeZKK5a1KEH5tzYVjla1d50lyYtFz0boO19i4unv
        oHFpJugfMXsr2G+tCe4MSF1WpeMWrrjeVUcgU8QK5zAZpVnp9NcuOpL0bs2a0CLd+xVzVckrglAp4
        acCSNo9zBl2CiIusJnrbK6Z4DvQqgj0qJnPijEMvLXBc2gBkRYoZGE2hF+fTB29xYc7b5XsFzM7Na
        +A0udklTPnI0QRgvCBL5EgrF6ItR3kXuR5gM8lZDmtFy8xkh3ht7U5c1mJvVFwtasywtrEORCyh8r
        uqFJyXWKQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47088)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kzMXn-00007p-95; Tue, 12 Jan 2021 16:29:19 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kzMXd-0006Pv-W9; Tue, 12 Jan 2021 16:29:10 +0000
Date:   Tue, 12 Jan 2021 16:29:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH net-next v14 5/6] net: dsa: mv88e6xxx: Add support for
 mv88e6393x family of Marvell
Message-ID: <20210112162909.GD1551@shell.armlinux.org.uk>
References: <20210111012156.27799-1-kabel@kernel.org>
 <20210111012156.27799-6-kabel@kernel.org>
 <20210112111139.hp56x5nzgadqlthw@skbuf>
 <20210112170226.3f2009bd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210112170226.3f2009bd@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 05:02:26PM +0100, Marek Behún wrote:
> > > +static void mv88e6393x_phylink_validate(struct mv88e6xxx_chip *chip, int port,
> > > +					unsigned long *mask,
> > > +					struct phylink_link_state *state)
> > > +{
> > > +	if (port == 0 || port == 9 || port == 10) {
> > > +		phylink_set(mask, 10000baseT_Full);
> > > +		phylink_set(mask, 10000baseKR_Full);  
> > 
> > I think I understand the reason for declaring 10GBase-KR support in
> > phylink_validate, in case the PHY supports that link mode on the media
> > side, but...
> 
> Hmm, yes, maybe KR shouldn't be here, but then why is it in
> mv88e6390x_phylink_validate?

I'm seriously thinking about changing the phylink_validate() interface
such that the question of which link _modes_ are supported no longer
comes up with MAC drivers, but instead MAC drivers say what interface
modes, speeds for each interface mode, duplexes for each speed are
supported.

There are certainly PHYs out there that take XAUI/RXAUI on the host
side and provide 10GBASE-KR on the "media" side. VSC8489 is an
example of such a PHY.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
