Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4935748CC4E
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243194AbiALTuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:50:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357264AbiALTty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 14:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=V+fwtpnv6Kg/p6mGfblOkGgb7Sj5L/xaXFGBpK3ajPw=; b=00umd5N82Bl1xinjIkxlOaymnF
        c3GJi/ZLGO+pwdSUD3xNFVicXGoSQxzHMQpBJBQn5sBShBnlPky5+niElorRAb9Rj+Tcin1x4ps6K
        8G8RvWBQHWqu0P717z57d+vRdhnMS7HOwuQKH5ZxU6o2VOXxgK9ZpGtR5zjREhRBrULw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n7jcz-001EJ9-Vc; Wed, 12 Jan 2022 20:49:49 +0100
Date:   Wed, 12 Jan 2022 20:49:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: phy: at803x: add fiber support
Message-ID: <Yd8w3a39GRDE7SUw@lunn.ch>
References: <20220111215504.2714643-1-robert.hancock@calian.com>
 <20220111215504.2714643-3-robert.hancock@calian.com>
 <Yd4cgGZ2tHzjBLqS@lunn.ch>
 <acb08860e200f94638663e48eb85565a41903fca.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acb08860e200f94638663e48eb85565a41903fca.camel@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 12:42:00AM +0000, Robert Hancock wrote:
> On Wed, 2022-01-12 at 01:10 +0100, Andrew Lunn wrote:
> > >  #define AT803X_MODE_CFG_MASK			0x0F
> > > -#define AT803X_MODE_CFG_SGMII			0x01
> > > +#define AT803X_MODE_CFG_BASET_RGMII		0x00
> > > +#define AT803X_MODE_CFG_BASET_SGMII		0x01
> > > +#define AT803X_MODE_CFG_BX1000_RGMII_50		0x02
> > > +#define AT803X_MODE_CFG_BX1000_RGMII_75		0x03
> > > +#define AT803X_MODE_CFG_BX1000_CONV_50		0x04
> > > +#define AT803X_MODE_CFG_BX1000_CONV_75		0x05
> > > +#define AT803X_MODE_CFG_FX100_RGMII_50		0x06
> > > +#define AT803X_MODE_CFG_FX100_CONV_50		0x07
> > > +#define AT803X_MODE_CFG_RGMII_AUTO_MDET		0x0B
> > > +#define AT803X_MODE_CFG_FX100_RGMII_75		0x0E
> > > +#define AT803X_MODE_CFG_FX100_CONV_75		0x0F
> > 
> > Hi Robert
> > 
> > What do these _50, and _75 mean?
> 
> 50 or 75 ohm impedance. Can refer to page 82 of the datasheet at 
> https://www.digikey.ca/en/datasheets/qualcomm/qualcommar8031dsatherosrev10aug2011
>  - these names were chosen to match what it uses.

I know they are getting long, but maybe add OHM to the end?

> > >  #define AT803X_PSSR				0x11	/*PHY-
> > > Specific Status Register*/
> > >  #define AT803X_PSSR_MR_AN_COMPLETE		0x0200
> > > @@ -283,6 +295,8 @@ struct at803x_priv {
> > >  	u16 clk_25m_mask;
> > >  	u8 smarteee_lpi_tw_1g;
> > >  	u8 smarteee_lpi_tw_100m;
> > > +	bool is_fiber;
> > 
> > Is maybe is_100basefx a better name? It makes it clearer it represents
> > a link mode?
> 
> This is meant to indicate the chip is set for any fiber mode (100Base-FX or
> 1000Base-X).

O.K, then is_fibre is O.K.

I noticed code removing the link mode 1000BaseX in the case of
is_fibre && !is_100basex. Does 100BaseFX need removing for !is_fibre?

	Andrew
