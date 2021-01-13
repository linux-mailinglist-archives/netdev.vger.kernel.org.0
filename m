Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AE92F4C90
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbhAMN44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:56:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38234 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725824AbhAMN44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 08:56:56 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzgdB-000Mb5-Mz; Wed, 13 Jan 2021 14:56:13 +0100
Date:   Wed, 13 Jan 2021 14:56:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <X/77/eB4aq5csmoe@lunn.ch>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
 <20210113112204.h3piuoni7amvx7i2@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210113112204.h3piuoni7amvx7i2@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 12:22:04PM +0100, Pali Rohár wrote:
> Hello! See my comments below.
> 
> On Monday 11 January 2021 06:00:41 Marek Behún wrote:
> > Some multigig SFPs from RollBall and Hilink do not expose functional
> > MDIO access to the internal PHY of the SFP via I2C address 0x56
> > (although there seems to be read-only clause 22 access on this address).
> 
> Maybe it could be interesting to test if clause 22 access via i2c
> address 0x56 can work also in write mode after setting rollball
> password...
> 
> > Instead these SFPs PHY can be accessed via I2C via the SFP Enhanced
> > Digital Diagnostic Interface - I2C address 0x51. The SFP_PAGE has to be
> > selected to 3 and the password must be filled with 0xff bytes for this
> > PHY communication to work.
> > 
> > This extends the mdio-i2c driver to support this protocol by adding a
> > special parameter to mdio_i2c_alloc function via which this RollBall
> > protocol can be selected.
> > 
> > Signed-off-by: Marek Behún <kabel@kernel.org>
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/mdio/mdio-i2c.c   | 319 +++++++++++++++++++++++++++++++++-
> >  drivers/net/phy/sfp.c         |   2 +-
> >  include/linux/mdio/mdio-i2c.h |   8 +-
> >  3 files changed, 322 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/mdio/mdio-i2c.c b/drivers/net/mdio/mdio-i2c.c
> > index 09200a70b315..7be582c0891a 100644
> > --- a/drivers/net/mdio/mdio-i2c.c
> > +++ b/drivers/net/mdio/mdio-i2c.c
> ...
> > @@ -91,9 +94,297 @@ static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
> >  	return ret < 0 ? ret : 0;
> >  }
> >  
> > -struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
> > +/* RollBall SFPs do not access internal PHY via I2C address 0x56, but
> > + * instead via address 0x51, when SFP page is set to 0x03 and password to
> > + * 0xffffffff.
> > + * Since current SFP code does not modify SFP_PAGE, we set it to 0x03 only at
> > + * bus creation time, and expect it to remain set to 0x03 throughout the
> > + * lifetime of the module plugged into the system. If the SFP code starts
> > + * modifying SFP_PAGE in the future, this code will need to change.
> > + *
> > + * address  size  contents  description
> > + * -------  ----  --------  -----------
> > + * 0x80     1     CMD       0x01/0x02/0x04 for write/read/done
> > + * 0x81     1     DEV       Clause 45 device
> > + * 0x82     2     REG       Clause 45 register
> > + * 0x84     2     VAL       Register value
> > + */
> > +#define ROLLBALL_PHY_I2C_ADDR		0x51
> > +#define ROLLBALL_SFP_PASSWORD_ADDR	0x7b
> 
> It looks like that this password entry is standard field described in
> QSFP+ specifications SFF-8436 and SFF-8636. Should not it be rather
> named vendor-neutral (as it is not Rollball specific)? And maybe defined
> in include/linux/sfp.h file where also also other standard macros, like
> SFP_PAGE macro?

If it is generic, the functions themselves should probably move into
sfp.c. Being able to swap pages is something needed for accessing the
diagnostic registers under some conditions. Because we don't have
support for changing the page, the HWMON support is disabled in this
condition.

	Andrew
