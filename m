Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB09639C3A8
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 01:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhFDXEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 19:04:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46322 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhFDXEW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 19:04:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XnHNL9lXkaLbHEM9f6N6hjdSr6gfj4Pqg+S2saBsR9A=; b=I3N7/RclzjfqTaXqB+0wsQhxSX
        CI1GZtiPlJAkjBhoBeTlmWQQVBM3TdonWBHGE1ztKy3NgVJS/xKowfsYLgWEETUqM2/oY0GslNIYl
        hZMCt8bujzA0Thi8Sp2qhTQoC99R+PBs+3ycFwj/rZ/9ZfNYNKOsmNEXe3o89EaGk5lI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpIpZ-007sCc-AA; Sat, 05 Jun 2021 01:02:21 +0200
Date:   Sat, 5 Jun 2021 01:02:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     dingsenjie@163.com, richardcochran@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingsenjie <dingsenjie@yulong.com>
Subject: Re: [PATCH] net: phy: Simplify the return expression of
 dp83640_ack_interrupt
Message-ID: <YLqw/Z22iMATS1IF@lunn.ch>
References: <20210604032224.136268-1-dingsenjie@163.com>
 <91609670-c3a2-2281-514e-01dfe7907f11@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91609670-c3a2-2281-514e-01dfe7907f11@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 09:49:17AM +0200, Heiner Kallweit wrote:
> On 04.06.2021 05:22, dingsenjie@163.com wrote:
> > From: dingsenjie <dingsenjie@yulong.com>
> > 
> > Simplify the return expression.
> > 
> > Signed-off-by: dingsenjie <dingsenjie@yulong.com>
> > ---
> >  drivers/net/phy/dp83640.c | 7 +------
> >  1 file changed, 1 insertion(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
> > index 0d79f68..bcd14ec 100644
> > --- a/drivers/net/phy/dp83640.c
> > +++ b/drivers/net/phy/dp83640.c
> > @@ -1141,12 +1141,7 @@ static int dp83640_config_init(struct phy_device *phydev)
> >  
> >  static int dp83640_ack_interrupt(struct phy_device *phydev)
> >  {
> > -	int err = phy_read(phydev, MII_DP83640_MISR);
> > -
> > -	if (err < 0)
> > -		return err;
> > -
> > -	return 0;
> > +	return phy_read(phydev, MII_DP83640_MISR);
> >  }
> >  
> >  static int dp83640_config_intr(struct phy_device *phydev)
> > 
> This would be a functional change. You'd return a positive value
> instead of 0.

And looking a bit further down in the code:

static int dp83640_ack_interrupt(struct phy_device *phydev)
{
        int err = phy_read(phydev, MII_DP83640_MISR);

        if (err < 0)
                return err;

        return 0;
}

static int dp83640_config_intr(struct phy_device *phydev)
{
        int micr;
        int misr;
        int err;

        if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
                err = dp83640_ack_interrupt(phydev);
                if (err)
                        return err;

So a positive value is going to break the driver.

NACK

	Andrew
