Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368DA1BF282
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgD3IUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:20:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:49510 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgD3IUY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 04:20:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 58E8FABB2;
        Thu, 30 Apr 2020 08:20:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 20FC4604EB; Thu, 30 Apr 2020 10:20:20 +0200 (CEST)
Date:   Thu, 30 Apr 2020 10:20:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY
 master/slave configuration.
Message-ID: <20200430082020.GC17581@lion.mk-sys.cz>
References: <20200428075308.2938-1-o.rempel@pengutronix.de>
 <20200428075308.2938-2-o.rempel@pengutronix.de>
 <20200429195222.GA17581@lion.mk-sys.cz>
 <20200430050058.cetxv76pyboanbkz@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430050058.cetxv76pyboanbkz@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 07:00:58AM +0200, Oleksij Rempel wrote:
> > > diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> > > index 92f737f101178..eb680e3d6bda5 100644
> > > --- a/include/uapi/linux/ethtool.h
> > > +++ b/include/uapi/linux/ethtool.h
> > > @@ -1666,6 +1666,31 @@ static inline int ethtool_validate_duplex(__u8 duplex)
> > >  	return 0;
> > >  }
> > >  
> > > +/* Port mode */
> > > +#define PORT_MODE_CFG_UNKNOWN		0
> > > +#define PORT_MODE_CFG_MASTER_PREFERRED	1
> > > +#define PORT_MODE_CFG_SLAVE_PREFERRED	2
> > > +#define PORT_MODE_CFG_MASTER_FORCE	3
> > > +#define PORT_MODE_CFG_SLAVE_FORCE	4
> > > +#define PORT_MODE_STATE_UNKNOWN		0
> > > +#define PORT_MODE_STATE_MASTER		1
> > > +#define PORT_MODE_STATE_SLAVE		2
> > > +#define PORT_MODE_STATE_ERR		3
> > 
> > You have "MASTER_SLAVE" or "master_slave" everywhere but "PORT_MODE" in
> > these constants which is inconsistent.
> 
> What will be preferred name?

Not sure, that would be rather question for people more familiar with
the hardware. What I wanted to say is that whether we use "master_slave"
or "port_mode", we should use the same everywhere.

> > > +
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
> > Should we really allow CFG_UNKNOWN in client requests? As far as I can
> > see, this value is handled as no-op which should be rather expressed by
> > absence of the attribute. Allowing the client to request a value,
> > keeping current one and returning 0 (success) is IMHO wrong.
> 
> ok
> 
> > Also, should this function be in UAPI header?
> 
> It is placed together with other validate functions:
> ethtool_validate_duplex
> ethtool_validate_speed
> 
> Doing it in a different place, would be inconsistent.

Those two have been there since "ever". The important question is if we
want this function to be provided to userspace as part of UAPI (which
would also limit our options for future modifications.

> 
> > [...]
> > > @@ -119,7 +123,12 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
> > >  	}
> > >  
> > >  	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
> > > -	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
> > > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex) ||
> > > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,
> > > +		       lsettings->master_slave_cfg) ||
> > > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,
> > > +		       lsettings->master_slave_state))
> > > +
> > >  		return -EMSGSIZE;
> > 
> > From the two handlers you introduced, it seems we only get CFG_UNKNOWN
> > or STATE_UNKNOWN if driver or device does not support the feature at all
> > so it would be IMHO more appropriate to omit the attribute in such case.
> 
> STATE_UNKNOWN is returned if link is not active.

How about distinguishing the two cases then? Omitting both if CFG is
CFG_UNKNOWN (i.e. driver does not support the feature) and sending
STATE=STATE_UNKNOWN to userspace only if we know it's a meaningful value
actually reported by the driver?

Michal
