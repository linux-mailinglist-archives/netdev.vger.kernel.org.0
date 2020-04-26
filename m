Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6041C1B93BD
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 21:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgDZTq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 15:46:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:60438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgDZTq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 15:46:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A7742AD39;
        Sun, 26 Apr 2020 19:46:54 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 01F3E602EE; Sun, 26 Apr 2020 21:46:54 +0200 (CEST)
Date:   Sun, 26 Apr 2020 21:46:54 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next v1 1/9] net: phy: Add cable test support to
 state machine
Message-ID: <20200426194654.GC23225@lion.mk-sys.cz>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425180621.1140452-2-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 25, 2020 at 08:06:13PM +0200, Andrew Lunn wrote:
> Running a cable test is desruptive to normal operation of the PHY and
> can take a 5 to 10 seconds to complete. The RTNL lock cannot be held
> for this amount of time, and add a new state to the state machine for
> running a cable test.
> 
> The driver is expected to implement two functions. The first is used
> to start a cable test. Once the test has started, it should return.
> 
> The second function is called once per second, or on interrupt to
> check if the cable test is complete, and to allow the PHY to report
> the status.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/phy.c | 65 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/phy.h   | 28 +++++++++++++++++++
>  2 files changed, 93 insertions(+)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index 72c69a9c8a98..4a6279c4a3a3 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
[...]
> @@ -470,6 +472,51 @@ static void phy_trigger_machine(struct phy_device *phydev)
>  	phy_queue_state_machine(phydev, 0);
>  }
>  
> +static void phy_cable_test_abort(struct phy_device *phydev)
> +{
> +	genphy_soft_reset(phydev);
> +}
> +
> +int phy_start_cable_test(struct phy_device *phydev,
> +			 struct netlink_ext_ack *extack)

Nitpick: the naming (phy_cable_test_abort() vs phy_start_cable_test())
should probably be consistent.

> +{
> +	int err;
> +
> +	if (!(phydev->drv &&
> +	      phydev->drv->cable_test_start &&
> +	      phydev->drv->cable_test_get_status)) {
> +		NL_SET_ERR_MSG(extack,
> +			       "PHY driver does not support cable testing");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	mutex_lock(&phydev->lock);
> +	if (phydev->state < PHY_UP ||
> +	    phydev->state >= PHY_CABLETEST) {
> +		NL_SET_ERR_MSG(extack,
> +			       "PHY not configured. Try setting interface up");
> +		err = -EBUSY;
> +		goto out;
> +	}

If I read the code correctly, this check would also catch an attempt to
start a cable test while the test is already in progress in which case
the error message would be rather misleading. I'm not sure what would be
more appropriate in such case: we can return -EBUSY (with more fitting
error message) but we could also silently ignore the request and let the
client wait for the notification from the test which is already in
progress.

Michal
