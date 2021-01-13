Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5152F4FA8
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbhAMQPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 11:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbhAMQPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 11:15:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1026C061575
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PBQn7luIUMvKVzEKkwdwD8vgETG6YE1K+Fh1IlRaogM=; b=SIhaeSI5xo23T4SyXzfFiUwXv
        L8wH0YKSMuRn2J2nyTC9vQSFTNmTOJSOH7M63DLjGLV0ey0xuwHBHogSh3O7E2v0shlJ9g3yM/pV7
        VQ6EL36C3F/d9yVbDigHOYMsqYUDP+YRHAZPGgyxjgTpNP65sAs/5owoWI4SfCi77pzb9jVgfhIZi
        WmKiP2ySNB48qnIpNq0N7uQvjg7A/lPTGt+xxyO+fFOsKBy/UqHCXNk+p0dxFHwsK0fgLLqFO4eYC
        Y+iwtbNjdpqbfOR/aOeBlup1pYuOD0uGY+XGpbypyR8DXobodFUI2HaOC3+RVNubJBjmRy0XO0G96
        0K85Ls1Dg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47498)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kzinA-0001RG-BE; Wed, 13 Jan 2021 16:14:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kzin9-0007RT-5M; Wed, 13 Jan 2021 16:14:39 +0000
Date:   Wed, 13 Jan 2021 16:14:39 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20210113161438.GI1551@shell.armlinux.org.uk>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
 <20210113112204.h3piuoni7amvx7i2@pali>
 <X/77/eB4aq5csmoe@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <X/77/eB4aq5csmoe@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 02:56:13PM +0100, Andrew Lunn wrote:
> On Wed, Jan 13, 2021 at 12:22:04PM +0100, Pali Rohár wrote:
> > Hello! See my comments below.
> > 
> > On Monday 11 January 2021 06:00:41 Marek Behún wrote:
> > > Some multigig SFPs from RollBall and Hilink do not expose functional
> > > MDIO access to the internal PHY of the SFP via I2C address 0x56
> > > (although there seems to be read-only clause 22 access on this address).
> > 
> > Maybe it could be interesting to test if clause 22 access via i2c
> > address 0x56 can work also in write mode after setting rollball
> > password...
> > 
> > > Instead these SFPs PHY can be accessed via I2C via the SFP Enhanced
> > > Digital Diagnostic Interface - I2C address 0x51. The SFP_PAGE has to be
> > > selected to 3 and the password must be filled with 0xff bytes for this
> > > PHY communication to work.
> > > 
> > > This extends the mdio-i2c driver to support this protocol by adding a
> > > special parameter to mdio_i2c_alloc function via which this RollBall
> > > protocol can be selected.
> > > 
> > > Signed-off-by: Marek Behún <kabel@kernel.org>
> > > Cc: Andrew Lunn <andrew@lunn.ch>
> > > Cc: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  drivers/net/mdio/mdio-i2c.c   | 319 +++++++++++++++++++++++++++++++++-
> > >  drivers/net/phy/sfp.c         |   2 +-
> > >  include/linux/mdio/mdio-i2c.h |   8 +-
> > >  3 files changed, 322 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/net/mdio/mdio-i2c.c b/drivers/net/mdio/mdio-i2c.c
> > > index 09200a70b315..7be582c0891a 100644
> > > --- a/drivers/net/mdio/mdio-i2c.c
> > > +++ b/drivers/net/mdio/mdio-i2c.c
> > ...
> > > @@ -91,9 +94,297 @@ static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
> > >  	return ret < 0 ? ret : 0;
> > >  }
> > >  
> > > -struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
> > > +/* RollBall SFPs do not access internal PHY via I2C address 0x56, but
> > > + * instead via address 0x51, when SFP page is set to 0x03 and password to
> > > + * 0xffffffff.
> > > + * Since current SFP code does not modify SFP_PAGE, we set it to 0x03 only at
> > > + * bus creation time, and expect it to remain set to 0x03 throughout the
> > > + * lifetime of the module plugged into the system. If the SFP code starts
> > > + * modifying SFP_PAGE in the future, this code will need to change.
> > > + *
> > > + * address  size  contents  description
> > > + * -------  ----  --------  -----------
> > > + * 0x80     1     CMD       0x01/0x02/0x04 for write/read/done
> > > + * 0x81     1     DEV       Clause 45 device
> > > + * 0x82     2     REG       Clause 45 register
> > > + * 0x84     2     VAL       Register value
> > > + */
> > > +#define ROLLBALL_PHY_I2C_ADDR		0x51
> > > +#define ROLLBALL_SFP_PASSWORD_ADDR	0x7b
> > 
> > It looks like that this password entry is standard field described in
> > QSFP+ specifications SFF-8436 and SFF-8636. Should not it be rather
> > named vendor-neutral (as it is not Rollball specific)? And maybe defined
> > in include/linux/sfp.h file where also also other standard macros, like
> > SFP_PAGE macro?
> 
> If it is generic, the functions themselves should probably move into
> sfp.c. Being able to swap pages is something needed for accessing the
> diagnostic registers under some conditions. Because we don't have
> support for changing the page, the HWMON support is disabled in this
> condition.

QSFPs are quite different from SFPs.
- the data structures in the "I2C device" are quite different.
- they don't have as many controls signals either - signals such as
  RX_LOS, TX_DISABLE etc are handled per channel and are only exposed
  via the I2C bus.

I've some rudimentary code for QSFP support in my CEX7 branch, which is
currently entirely separate from the SFP code. I haven't done much on
that for quite some time due to the historical difficulties of working
with NXP, but I have over the course of the last week updated my branch
to 5.10 and have patches to move SFP support forward. However, I expect
further difficulties interacting with NXP and fully expect to be
blocked from being able to achieve anything useful.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
