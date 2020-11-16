Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6D2B3FB7
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbgKPJ02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgKPJ01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:26:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A967C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 01:26:27 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1keam2-0004FB-Dh; Mon, 16 Nov 2020 10:26:10 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kealz-0002Qj-L7; Mon, 16 Nov 2020 10:26:07 +0100
Date:   Mon, 16 Nov 2020 10:26:07 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Zhang Changzhong <zhangchangzhong@huawei.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: phy: smsc: add missed clk_disable_unprepare in
 smsc_phy_probe()
Message-ID: <20201116092607.psaelzuga3kcrryu@pengutronix.de>
References: <1605180239-1792-1-git-send-email-zhangchangzhong@huawei.com>
 <20201114112625.440b52f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <fc03d4de-14d2-1b61-ac9b-40ea26e6fa9a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc03d4de-14d2-1b61-ac9b-40ea26e6fa9a@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:23:41 up 367 days, 42 min, 32 users,  load average: 0.00, 0.05,
 0.04
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-11-14 11:45, Florian Fainelli wrote:
> 
> 
> On 11/14/2020 11:26 AM, Jakub Kicinski wrote:
> > On Thu, 12 Nov 2020 19:23:59 +0800 Zhang Changzhong wrote:
> >> Add the missing clk_disable_unprepare() before return from
> >> smsc_phy_probe() in the error handling case.
> >>
> >> Fixes: bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in support")
> >> Reported-by: Hulk Robot <hulkci@huawei.com>
> >> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> >> ---
> >>  drivers/net/phy/smsc.c | 4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> >> index ec97669..0fc39ac 100644
> >> --- a/drivers/net/phy/smsc.c
> >> +++ b/drivers/net/phy/smsc.c
> >> @@ -291,8 +291,10 @@ static int smsc_phy_probe(struct phy_device *phydev)
> >>  		return ret;
> >>  
> >>  	ret = clk_set_rate(priv->refclk, 50 * 1000 * 1000);
> >> -	if (ret)
> >> +	if (ret) {
> >> +		clk_disable_unprepare(priv->refclk);
> >>  		return ret;
> >> +	}
> >>  
> >>  	return 0;
> >>  }
> > 
> > Applied, thanks!
> > 
> > The code right above looks highly questionable as well:
> > 
> >         priv->refclk = clk_get_optional(dev, NULL);
> >         if (IS_ERR(priv->refclk))
> >                 dev_err_probe(dev, PTR_ERR(priv->refclk), "Failed to request clock\n");
> >  
> >         ret = clk_prepare_enable(priv->refclk);
> >         if (ret)
> >                 return ret;
> > 
> > I don't think clk_prepare_enable() will be too happy to see an error
> > pointer. This should probably be:
> > 
> >         priv->refclk = clk_get_optional(dev, NULL);
> >         if (IS_ERR(priv->refclk))
> >                 return dev_err_probe(dev, PTR_ERR(priv->refclk), 
> > 				      "Failed to request clock\n");
> 
> Right, especially if EPROBE_DEFER must be returned because the clock
> provider is not ready yet, we should have a chance to do that.

Hi,

damn.. I missed the return here. Thanks for covering that. Should I send
a fix or did you do that already?

Regards,
  Marco
