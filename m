Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A351C5373
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 12:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgEEKmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 06:42:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:45362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbgEEKm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 06:42:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A7F7AAC61;
        Tue,  5 May 2020 10:42:29 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 828B8602B9; Tue,  5 May 2020 12:42:26 +0200 (CEST)
Date:   Tue, 5 May 2020 12:42:26 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 06/10] net: ethtool: Add infrastructure for
 reporting cable test results
Message-ID: <20200505104226.GJ8237@lion.mk-sys.cz>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-7-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505001821.208534-7-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 02:18:17AM +0200, Andrew Lunn wrote:
> Provide infrastructure for PHY drivers to report the cable test
> results.  A netlink skb is associated to the phydev. Helpers will be
> added which can add results to this skb. Once the test has finished
> the results are sent to user space.
> 
> When netlink ethtool is not part of the kernel configuration stubs are
> provided. It is also impossible to trigger a cable test, so the error
> code returned by the alloc function is of no consequence.
> 
> v2:
> Include the status complete in the netlink notification message
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/phy.c           | 22 +++++++++++--
>  include/linux/ethtool_netlink.h | 20 ++++++++++++
>  include/linux/phy.h             |  5 +++
>  net/ethtool/cabletest.c         | 55 +++++++++++++++++++++++++++++++++
>  4 files changed, 100 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index cea89785bcd4..039e41e15c7e 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -22,6 +22,7 @@
>  #include <linux/module.h>
>  #include <linux/mii.h>
>  #include <linux/ethtool.h>
> +#include <linux/ethtool_netlink.h>
>  #include <linux/phy.h>
>  #include <linux/phy_led_triggers.h>
>  #include <linux/sfp.h>
> @@ -30,6 +31,9 @@
>  #include <linux/io.h>
>  #include <linux/uaccess.h>
>  #include <linux/atomic.h>
> +#include <net/netlink.h>
> +#include <net/genetlink.h>
> +#include <net/sock.h>
>  
>  #define PHY_STATE_TIME	HZ
>  
> @@ -476,6 +480,8 @@ static void phy_abort_cable_test(struct phy_device *phydev)
>  {
>  	int err;
>  
> +	ethnl_cable_test_finished(phydev);
> +
>  	err = phy_init_hw(phydev);
>  	if (err)
>  		phydev_err(phydev, "Error while aborting cable test");
> @@ -484,7 +490,7 @@ static void phy_abort_cable_test(struct phy_device *phydev)
>  int phy_start_cable_test(struct phy_device *phydev,
>  			 struct netlink_ext_ack *extack)
>  {
> -	int err;
> +	int err = -ENOMEM;
>  
>  	if (!(phydev->drv &&
>  	      phydev->drv->cable_test_start &&
> @@ -510,19 +516,30 @@ int phy_start_cable_test(struct phy_device *phydev,
>  		goto out;
>  	}
>  
> +	err = ethnl_cable_test_alloc(phydev);
> +	if (err)
> +		goto out;
> +
>  	/* Mark the carrier down until the test is complete */
>  	phy_link_down(phydev, true);
>  
>  	err = phydev->drv->cable_test_start(phydev);
>  	if (err) {
>  		phy_link_up(phydev);
> -		goto out;
> +		goto out_free;
>  	}
>  
>  	phydev->state = PHY_CABLETEST;
>  
>  	if (phy_polling_mode(phydev))
>  		phy_trigger_machine(phydev);
> +
> +	mutex_unlock(&phydev->lock);
> +
> +	return 0;
> +
> +out_free:
> +	ethnl_cable_test_free(phydev);
>  out:
>  	mutex_unlock(&phydev->lock);
>  
> @@ -962,6 +979,7 @@ void phy_state_machine(struct work_struct *work)
>  		}
>  
>  		if (finished) {
> +			ethnl_cable_test_finished(phydev);
>  			needs_aneg = true;
>  			phydev->state = PHY_UP;
>  		}
> diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
> index d01b77887f82..7d763ba22f6f 100644
> --- a/include/linux/ethtool_netlink.h
> +++ b/include/linux/ethtool_netlink.h
> @@ -14,4 +14,24 @@ enum ethtool_multicast_groups {
>  	ETHNL_MCGRP_MONITOR,
>  };
>  
> +struct phy_device;
> +
> +#if IS_ENABLED(CONFIG_ETHTOOL_NETLINK)
> +int ethnl_cable_test_alloc(struct phy_device *phydev);
> +void ethnl_cable_test_free(struct phy_device *phydev);
> +void ethnl_cable_test_finished(struct phy_device *phydev);
> +#else
> +static inline int ethnl_cable_test_alloc(struct phy_device *phydev)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static inline void ethnl_cable_test_free(struct phy_device *phydev)
> +{
> +}
> +
> +static inline void ethnl_cable_test_finished(struct phy_device *phydev)
> +{
> +}
> +#endif /* IS_ENABLED(ETHTOOL_NETLINK) */
>  #endif /* _LINUX_ETHTOOL_NETLINK_H_ */
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 593da2c6041d..ee69f781995a 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -487,6 +487,11 @@ struct phy_device {
>  	/* For use by PHYs to maintain extra state */
>  	void *priv;
>  
> +	/* Reporting cable test results */
> +	struct sk_buff *skb;
> +	void *ehdr;
> +	struct nlattr *nest;
> +
>  	/* Interrupt and Polling infrastructure */
>  	struct delayed_work state_queue;
>  
> diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
> index 6e5782a7da80..4c888db33ef0 100644
> --- a/net/ethtool/cabletest.c
> +++ b/net/ethtool/cabletest.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  
>  #include <linux/phy.h>
> +#include <linux/ethtool_netlink.h>
>  #include "netlink.h"
>  #include "common.h"
>  #include "bitset.h"
> @@ -59,3 +60,57 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
>  	dev_put(dev);
>  	return ret;
>  }
> +
> +int ethnl_cable_test_alloc(struct phy_device *phydev)
> +{
> +	int err = -ENOMEM;
> +
> +	phydev->skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +	if (!phydev->skb)
> +		goto out;
> +
> +	phydev->ehdr = ethnl_bcastmsg_put(phydev->skb,
> +					  ETHTOOL_MSG_CABLE_TEST_NTF);
> +	if (!phydev->ehdr) {
> +		err = -EINVAL;

This should be -EMSGSIZE.

> +		goto out;
> +	}
> +
> +	err = ethnl_fill_reply_header(phydev->skb, phydev->attached_dev,
> +				      ETHTOOL_A_CABLE_TEST_NTF_HEADER);
> +	if (err)
> +		goto out;
> +
> +	err = nla_put_u8(phydev->skb, ETHTOOL_A_CABLE_TEST_NTF_STATUS,
> +			 ETHTOOL_A_CABLE_TEST_NTF_STATUS_COMPLETED);
> +	if (err)
> +		goto out;
> +
> +	phydev->nest = nla_nest_start(phydev->skb,
> +				      ETHTOOL_A_CABLE_TEST_NTF_NEST);
> +	if (!phydev->nest)
> +		goto out;

If nla_nest_start() fails, we still have 0 in err.

> +
> +	return 0;
> +
> +out:
> +	nlmsg_free(phydev->skb);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(ethnl_cable_test_alloc);

Do you think it would make sense to set phydev->skb to NULL on failure
and also in ethnl_cable_test_free() and ethnl_cable_test_finished() so
that if driver messes up, it hits null pointer dereference which is much
easier to debug than use after free?

Michal
