Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E7C434B0F
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhJTMWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:22:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48580 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230174AbhJTMWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 08:22:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YBO3q4jEfT92PWEmRoF47QEYl0r14ymXhDoJSvd0+ro=; b=vl8D85LS4Vbhi4CRvAYx6q6W9J
        VgrDPYJEOMr30QH08xecELIRkjzsj4m55g842HPcrR7cHPN7AQJGoTh7BshwOgMrDU87qJC3EtRCL
        OoaoQV0DeP5rvIpIHpm4QA8dadMQGx6feiRHcEnyJNToFrmo0uyYkyBjNVYz3vlSJBVU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mdAZw-00BBO0-Ab; Wed, 20 Oct 2021 14:20:20 +0200
Date:   Wed, 20 Oct 2021 14:20:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jie Luo <quic_luoj@quicinc.com>
Cc:     Luo Jie <luoj@codeaurora.org>, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sricharan@codeaurora.org
Subject: Re: [PATCH v3 07/13] net: phy: add qca8081 get_features
Message-ID: <YXAJhM4/zCC/vY0U@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-8-luoj@codeaurora.org>
 <YW3qrFRzvPlFrms0@lunn.ch>
 <cf1c8c0a-eeab-d5d2-fa04-ff6e4d37b960@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf1c8c0a-eeab-d5d2-fa04-ff6e4d37b960@quicinc.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 02:39:57PM +0800, Jie Luo wrote:
> 
> On 10/19/2021 5:44 AM, Andrew Lunn wrote:
> > On Mon, Oct 18, 2021 at 11:33:27AM +0800, Luo Jie wrote:
> > > Reuse the at803x phy driver get_features excepting
> > > adding 2500M capability.
> > > 
> > > Signed-off-by: Luo Jie<luoj@codeaurora.org>
> > > ---
> > >   drivers/net/phy/at803x.c | 10 ++++++++++
> > >   1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
> > > index 42d3f8ccca94..0c22ef735230 100644
> > > --- a/drivers/net/phy/at803x.c
> > > +++ b/drivers/net/phy/at803x.c
> > > @@ -719,6 +719,15 @@ static int at803x_get_features(struct phy_device *phydev)
> > >   	if (err)
> > >   		return err;
> > > +	if (phydev->drv->phy_id == QCA8081_PHY_ID) {
> > > +		err = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);
> > > +		if (err < 0)
> > > +			return err;
> > > +
> > > +		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->supported,
> > > +				err & MDIO_PMA_NG_EXTABLE_2_5GBT);
> > > +	}
> > genphy_c45_pma_read_abilities()?
> > 
> > 	Andrew
> 
> Hi Andrew,
> 
> Thanks for this comment, if we use genphy_c45_pma_read_abilities here, the
> ETHTOOL_LINK_MODE_Autoneg_BIT
> 
> will be lost, since MDIO_MMD_AN.MDIO_STAT1 does not have bit
> MDIO_AN_STAT1_ABLE.
 
Yes, if your PHY breaks the standard, the helpers are not much use,
that assume standard compliment PHYs.

     Andrew
