Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0D0279D34
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 02:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgI0ApS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 20:45:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57552 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbgI0ApR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 20:45:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMKoU-00GKsB-NX; Sun, 27 Sep 2020 02:45:14 +0200
Date:   Sun, 27 Sep 2020 02:45:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 3/7] net: dsa: Register devlink ports before
 calling DSA driver setup()
Message-ID: <20200927004514.GC3889809@lunn.ch>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-4-andrew@lunn.ch>
 <20200926233725.fagc4znatjpufu6q@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926233725.fagc4znatjpufu6q@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int dsa_port_devlink_setup(struct dsa_port *dp)
> >  {
> >  	struct devlink_port *dlp = &dp->devlink_port;
> > +	struct dsa_switch_tree *dst = dp->ds->dst;
> > +	struct devlink_port_attrs attrs = {};
> > +	struct devlink *dl = dp->ds->devlink;
> > +	const unsigned char *id;
> > +	unsigned char len;
> > +	int err;
> > +
> > +	id = (const unsigned char *)&dst->index;
> > +	len = sizeof(dst->index);
> > +
> > +	attrs.phys.port_number = dp->index;
> > +	memcpy(attrs.switch_id.id, id, len);
> > +	attrs.switch_id.id_len = len;
> > +
> > +	if (dp->setup)
> > +		return 0;
> >  
> 
> I wonder what this is protecting against? I ran on a multi-switch tree
> without these 2 lines and I didn't get anything like multiple
> registration or things like that. What is the call path that would call
> dsa_port_devlink_setup twice?

I made a duplicate copy of dsa_port_setup() and trimmed out what was
not needed to give the new dsa_port_setup() and
dsa_port_devlink_setup(). I did not trim enough...

> 
> > +	switch (dp->type) {
> > +	case DSA_PORT_TYPE_UNUSED:
> > +		memset(dlp, 0, sizeof(*dlp));
> > +		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
> 
> > +		devlink_port_attrs_set(dlp, &attrs);
> > +		err = devlink_port_register(dl, dlp, dp->index);
> 
> These 2 lines are common everywhere. Could you move them out of the
> switch-case statement?

Yes, that makes sense. Too much blind copy/paste without actually
reviewing the code afterwards.

	  Andrew
