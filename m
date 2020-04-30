Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A006B1BF82F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 14:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgD3MZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 08:25:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:33934 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgD3MZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 08:25:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4ED94AB3D;
        Thu, 30 Apr 2020 12:25:52 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B49F960341; Thu, 30 Apr 2020 14:25:51 +0200 (CEST)
Date:   Thu, 30 Apr 2020 14:25:51 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <20200430122551.GB8934@lion.mk-sys.cz>
References: <20200428075308.2938-1-o.rempel@pengutronix.de>
 <20200428075308.2938-2-o.rempel@pengutronix.de>
 <20200429195222.GA17581@lion.mk-sys.cz>
 <20200430050058.cetxv76pyboanbkz@pengutronix.de>
 <20200430082020.GC17581@lion.mk-sys.cz>
 <20200430120945.GA7370@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430120945.GA7370@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 02:09:45PM +0200, Oleksij Rempel wrote:
> > > > > @@ -119,7 +123,12 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
> > > > >  	}
> > > > >  
> > > > >  	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
> > > > > -	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
> > > > > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex) ||
> > > > > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,
> > > > > +		       lsettings->master_slave_cfg) ||
> > > > > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,
> > > > > +		       lsettings->master_slave_state))
> > > > > +
> > > > >  		return -EMSGSIZE;
> > > > 
> > > > From the two handlers you introduced, it seems we only get CFG_UNKNOWN
> > > > or STATE_UNKNOWN if driver or device does not support the feature at all
> > > > so it would be IMHO more appropriate to omit the attribute in such case.
> > > 
> > > STATE_UNKNOWN is returned if link is not active.
> > 
> > How about distinguishing the two cases then? Omitting both if CFG is
> > CFG_UNKNOWN (i.e. driver does not support the feature) and sending
> > STATE=STATE_UNKNOWN to userspace only if we know it's a meaningful value
> > actually reported by the driver?
> 
> Hm... after thinking about it, we should keep state and config
> separately. The TJA1102 PHY do not provide actual state. Even no error
> related to Master/Master conflict. I reworked the code to have
> unsupported and unknown values.  In case we know, that state or config
> is not supported, it will not be exported to the user space.

Sounds good to me, splitting "unsupported" and "unknown" states will be
probably the best option.

Michal
