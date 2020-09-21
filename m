Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288E7271980
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 05:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgIUDCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 23:02:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46618 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgIUDCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 23:02:15 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kKC5l-00FXHa-5F; Mon, 21 Sep 2020 05:02:13 +0200
Date:   Mon, 21 Sep 2020 05:02:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 1/4] net: devlink: Add support for port
 regions
Message-ID: <20200921030213.GC3702050@lunn.ch>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200919144332.3665538-2-andrew@lunn.ch>
 <20200920234539.ayzonwdptqp27zgl@skbuf>
 <20200921002317.ltl4b4oqow6o6tba@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921002317.ltl4b4oqow6o6tba@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 12:23:18AM +0000, Vladimir Oltean wrote:
> On Mon, Sep 21, 2020 at 02:45:39AM +0300, Vladimir Oltean wrote:
> > This looks like a simple enough solution, but am I right that old
> > kernels, which ignore this new DEVLINK_ATTR_PORT_INDEX netlink
> > attribute, will consequently interpret any devlink command for a port as
> > being for a global region? Sure, in the end, that kernel will probably
> > fail anyway, due to the region name mismatch. And at the moment there
> > isn't any driver that registers a global and a port region with the same
> > name. But when that will happen, the user space tools of the future will
> > trigger incorrect behavior into the kernel of today, instead of it
> > reporting an unsupported operation as it should. Or am I
> > misunderstanding?
> 
> Thinking about this more, I believe that the only conditions that need
> to be avoided are:
> - mlx4 should never create a port region called "cr-space" or "fw-health"
> - ice should never create a port region called "nvm-flash" or
>   "device-caps"
> - netdevsim should never create a port region called "dummy"
> - mv88e6xxx should never create a port region called "global1",
>   "global2" or "atu"
> 
> Because these are the only region names supported by kernels that don't
> parse DEVLINK_ATTR_PORT_INDEX, I think we don't need to complicate the
> solution, and go with DEVLINK_ATTR_PORT_INDEX.

It would be easy to check when adding a per port region if a global
region of the same name already exists. Checking when adding a global
region to see if there is a port region with the same name is a bit
more work, but doable.

     Andrew
