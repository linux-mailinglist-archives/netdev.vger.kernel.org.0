Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FC626FDD5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIRNJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:09:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43258 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgIRNJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 09:09:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJG8S-00FEeU-AL; Fri, 18 Sep 2020 15:09:08 +0200
Date:   Fri, 18 Sep 2020 15:09:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 net-next 7/9] net: dsa: mv88e6xxx: Add devlink regions
Message-ID: <20200918130908.GA3631014@lunn.ch>
References: <20200909235827.3335881-1-andrew@lunn.ch>
 <20200909235827.3335881-8-andrew@lunn.ch>
 <f4942b08-3bf8-cdd6-a8b7-61b77c746648@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4942b08-3bf8-cdd6-a8b7-61b77c746648@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int mv88e6xxx_region_global_snapshot(struct devlink *dl,
> > +					    const struct devlink_region_ops *ops,
> > +					    struct netlink_ext_ack *extack,
> > +					    u8 **data)
> > +{
> > +	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
> > +	struct mv88e6xxx_chip *chip = ds->priv;
> > +	u16 *registers;
> > +	int i, err;
> > +
> > +	registers = kmalloc_array(32, sizeof(u16), GFP_KERNEL);
> > +	if (!registers)
> > +		return -ENOMEM;
> > +
> > +	mv88e6xxx_reg_lock(chip);
> > +	for (i = 0; i < 32; i++) {
> > +		switch ((long)ops->priv) {
> > +		case 1:
> > +			err = mv88e6xxx_g1_read(chip, i, &registers[i]);
> > +			break;
> > +		case 2:
> > +			err = mv88e6xxx_g1_read(chip, i, &registers[i]);
> 
> Should this be mv88e6xxx_g2_read() here?

Doh! Thanks.

> Can you use the region IDs you defined above?

Yes. That would be more readable. I probably need to make ops->priv
point to a real structure, to avoid compiler warnings about down
sizing types on casts.

       Andrew
