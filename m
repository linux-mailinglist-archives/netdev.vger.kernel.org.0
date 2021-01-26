Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EB1303F71
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405527AbhAZN5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:57:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60198 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405595AbhAZN4w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 08:56:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4OpE-002i07-HC; Tue, 26 Jan 2021 14:56:08 +0100
Date:   Tue, 26 Jan 2021 14:56:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com,
        vadimp@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <YBAfeESYudCENZ2e@lunn.ch>
References: <20210119115610.GZ3565223@nanopsycho.orion>
 <YAbyBbEE7lbhpFkw@lunn.ch>
 <20210120083605.GB3565223@nanopsycho.orion>
 <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121153224.GE3565223@nanopsycho.orion>
 <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
 <20210122072814.GG3565223@nanopsycho.orion>
 <YArdeNwXb9v55o/Z@lunn.ch>
 <20210126113326.GO3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126113326.GO3565223@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 12:33:26PM +0100, Jiri Pirko wrote:
> Fri, Jan 22, 2021 at 03:13:12PM CET, andrew@lunn.ch wrote:
> >> I don't see any way. The userspace is the one who can get the info, from
> >> the i2c driver. The mlxsw driver has no means to get that info itself.
> >
> >Hi Jiri
> >
> >Please can you tell us more about this i2c driver. Do you have any
> >architecture pictures?
> 
> Quoting Vadim Pasternak:
> "
> Not upstreamed yet.
> It will be mlxreg-lc driver for line card in drivers/platfrom/mellanox and
> additional mlxreg-pm for line card powering on/off, setting enable/disable
> and handling power off upon thermal shutdown event.
> "
> 
> 
> >
> >It is not unknown for one driver to embed another driver inside it. So
> >the i2c driver could be inside the mlxsw. It is also possible to link
> >drivers together, the mlxsw could go find the i2c driver and make use
> >of its services.
> 
> Okay. Do you have examples? How could the kernel figure out the relation
> of the instances?

Hi Jiri

One driver, embedded into another? You actually submitted an example:

commit 6882b0aee180f2797b8803bdf699aa45c2e5f2d6
Author: Vadim Pasternak <vadimp@mellanox.com>
Date:   Wed Nov 16 15:20:44 2016 +0100

    mlxsw: Introduce support for I2C bus
    
    Add I2C bus implementation for Mellanox Technologies Switch ASICs.
    This includes command interface implementation using input / out mailboxes,
    whose location is retrieved from the firmware during probe time.
    
    Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
    Reviewed-by: Ido Schimmel <idosch@mellanox.com>
    Signed-off-by: Jiri Pirko <jiri@mellanox.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

There are Linux standard APIs for controlling the power to devices,
the regulator API. So i assume mlxreg-pm will make use of that. There
are also standard APIs for thermal management, which again, mlxreg-pm
should be using. The regulator API allows you to find regulators by
name. So just define a sensible naming convention, and the switch
driver can lookup the regulator, and turn it on/off as needed.

I'm guessing there are no standard Linux API which mlxreg-lc fits. I'm
also not sure it offers anything useful standalone. So i would
actually embed it inside the switchdev driver, and have internal APIs
to get information about the line card.

But i'm missing big picture architecture knowledge here, there could
be reasons why these suggestions don't work.

   Andrew
