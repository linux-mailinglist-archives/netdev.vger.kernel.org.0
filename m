Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED27495F64
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 14:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380525AbiAUNFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 08:05:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380522AbiAUNFN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 08:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=er0oO0KQIatdPccLUW/Ds3BOKxbZJ4Hsl46YRpDl6GI=; b=LLW/XfM6vV3EJDL5WGKAWF+jAp
        xaBR6ktXeFtFXHSiPOjgJaSB7LTTaxClspqR9HbV6qXoYjDbLRx5+zc7+qdfRLgGiR4iVliMNVEc8
        ItKL3gn4vyblsUzg9/DSSCxH1k2U5LMQ47qnXid3sNHmtkvaZUlxoAzm//idE5kuxTac=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nAtb9-0025GS-EY; Fri, 21 Jan 2022 14:04:59 +0100
Date:   Fri, 21 Jan 2022 14:04:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <Yeqve+KhJKbZJNCL@lunn.ch>
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <Yelnzrrd0a4Bl5AL@lunn.ch>
 <CAAd53p45BbLy0T8AG5QTKhP00zMBsMHfm7i-bTmZmQWM5DpLnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p45BbLy0T8AG5QTKhP00zMBsMHfm7i-bTmZmQWM5DpLnQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Since you talked about suspend/resume, does this machine support WoL?
> > Is the BIOS configuring LED2 to be used as an interrupt when WoL is
> > enabled in the BIOS? Do you need to save/restore that configuration
> > over suspend/review? And prevent the driver from changing the
> > configuration?
> 
> This NIC on the machine doesn't support WoL.

I'm surprised about that. Are you really sure?

What are you doing for resume? pressing the power button?

> > > +static const struct dmi_system_id platform_flags[] = {
> > > +     {
> > > +             .matches = {
> > > +                     DMI_MATCH(DMI_SYS_VENDOR, "Dell EMC"),
> > > +                     DMI_MATCH(DMI_PRODUCT_NAME, "Edge Gateway 3200"),
> > > +             },
> > > +             .driver_data = (void *)PHY_USE_FIRMWARE_LED,
> > > +     },
> >
> > This needs a big fat warning, that it will affect all LEDs for PHYs
> > which linux is driving, on that machine. So PHYs on USB dongles, PHYs
> > in SFPs, PHYs on plugin PCIe card etc.
> >
> > Have you talked with Dells Product Manager and do they understand the
> > implications of this?
> 
> Right, that's why the original approach is passing the flag from the MAC driver.
> That approach can be more specific and doesn't touch unrelated PHYs.

More specific, but still will go wrong at some point, A PCEe card
using that MAC etc. And this is general infrastructure you are adding
here, it can be used by any machine, any combination of MAC and PHY
etc. So you need to clearly document its limits so others are not
surprised.

	Andrew
