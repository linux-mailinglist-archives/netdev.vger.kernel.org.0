Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3378829404D
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 18:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbgJTQPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 12:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgJTQPp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 12:15:45 -0400
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05DAF2224A;
        Tue, 20 Oct 2020 16:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603210544;
        bh=TLxtKqbBnwzbk2+68Vl+L8mMij84H4r6pvqkTjo4tIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l8MSbFPqYb/OqWP9qeq7GqLgqkv7sdD0U/DJHuFHFslfAH/tgX/TUHMzwEmIz3u3J
         C8KMJVB0Dyji3R0C7xgqjfxS/34Ag8Bzimjecwpj2RrRDT0nJdKDI+FKzeBLOzrBGZ
         lvomF5ohL/kMQ8grX3oe8iMW5YPoo245dW2gyGk0=
Date:   Tue, 20 Oct 2020 18:15:37 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org
Subject: Re: [PATCH russell-kings-net-queue v2 1/3] net: phy: mdio-i2c:
 support I2C MDIO protocol for RollBall SFP modules
Message-ID: <20201020181537.753b1c90@kernel.org>
In-Reply-To: <20201020160039.GI139700@lunn.ch>
References: <20201020150615.11969-1-kabel@kernel.org>
        <20201020150615.11969-2-kabel@kernel.org>
        <20201020160039.GI139700@lunn.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 18:00:39 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > This extends the mdio-i2c driver so that when SFP PHY address 17 is used
> > (which in mdio-i2c terms corresponds to I2C address 0x51), then this
> > different protocol is used for MDIO access.  
> 
> Hi Marek
> 
> I don't see that being very scalable. What happens when the next SFP
> comes along which has a different protocol at address 0x51. Since you
> can identify the SFP via the EEPROM information, i would prefer you
> explicitly tell it to use the rollball protocol when instantiating the
> MDIO bus.

At first I proposed a separate mdio bus driver for RollBall SFPs.
But Russell suggested doing this instead, saying that in the future
this can be changed.

> 
> >   * I2C bus addresses 0x50 and 0x51 are normally an EEPROM, which is
> >   * specified to be present in SFP modules.  These correspond with PHY
> > - * addresses 16 and 17.  Disallow access to these "phy" addresses.
> > + * addresses 16 and 17.  Disallow access to 0x50 "phy" address.
> > + * Use RollBall protocol when accessing via the 0x51 address.
> >   */
> >  static bool i2c_mii_valid_phy_id(int phy_id)
> >  {
> > -	return phy_id != 0x10 && phy_id != 0x11;
> > +	return phy_id != 0x10;
> > +}  
> 
> I'm not sure that is safe. It means that we will scan address 0x11 to
> see if there is a PHY there. And if the SFP does have diagnostics
> registers, that might be enough that phylib thinks there is a PHY
> there.
> 
> I think you only need to allow access to 0x11 if rollball protocol has
> been enabled.

I can do that...

> 
>      Andrew

