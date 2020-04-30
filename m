Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D461BFDFC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgD3OYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:24:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33996 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728124AbgD3OY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 10:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=x1qcW327bi40rJCDOA/3VQNP7BlakD04Fq3hF5EemCU=; b=gp2QReN3m19PvBPCArNU9deQZU
        z7Ie2O7sL0SVI7By+LoWyF79XjtTG/m43F6uGABWeaGlNwS1GoWTM7YrSuNAGg2zYicn+9LVs7YXi
        AcWN7yw36LigxHcr/hp5lQaoxICF7/vveF3BQCa0PhYpRyvtIA0qepksqvBm5n/lqTHM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUA6t-000Q0O-LU; Thu, 30 Apr 2020 16:24:19 +0200
Date:   Thu, 30 Apr 2020 16:24:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY
 master/slave configuration.
Message-ID: <20200430142419.GC76972@lunn.ch>
References: <20200428075308.2938-1-o.rempel@pengutronix.de>
 <20200428075308.2938-2-o.rempel@pengutronix.de>
 <20200429181614.GL30459@lunn.ch>
 <20200430043751.ojvcgtubkbfunolb@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430043751.ojvcgtubkbfunolb@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 06:37:51AM +0200, Oleksij Rempel wrote:
> Hi Andrew,
> 
> On Wed, Apr 29, 2020 at 08:16:14PM +0200, Andrew Lunn wrote:
> > On Tue, Apr 28, 2020 at 09:53:07AM +0200, Oleksij Rempel wrote:
> > 
> > Hi Oleksij
> > 
> > Sorry for taking a while to review this. I was busy fixing the FEC
> > driver which i broke :-(
> 
> Not problem.
> Interesting, what is wrong with FEC? We use it a lot.

I broke MDIO transactions, when making them faster. Hopefully fixed.

> > > diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> > > index 92f737f101178..eb680e3d6bda5 100644
> > > --- a/include/uapi/linux/ethtool.h
> > > +++ b/include/uapi/linux/ethtool.h
> > > @@ -1666,6 +1666,31 @@ static inline int ethtool_validate_duplex(__u8 duplex)
> > >  	return 0;
> > >  }
> > >  
> > > +static inline int ethtool_validate_master_slave_cfg(__u8 cfg)
> > > +{
> > > +	switch (cfg) {
> > > +	case PORT_MODE_CFG_MASTER_PREFERRED:
> > > +	case PORT_MODE_CFG_SLAVE_PREFERRED:
> > > +	case PORT_MODE_CFG_MASTER_FORCE:
> > > +	case PORT_MODE_CFG_SLAVE_FORCE:
> > > +	case PORT_MODE_CFG_UNKNOWN:
> > > +		return 1;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > 
> > Does this need to be an inline function? 
> 
> Yes, otherwise we get a lot of "defined but not used " warnings.

Sorry, was not clear enough. I think there is only one user of this
function? Why not put it in the same compilation unit, as a normal
static function?

	Andrew
