Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5B7423917
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237399AbhJFHpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:45:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:8624 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230013AbhJFHpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 03:45:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10128"; a="212875074"
X-IronPort-AV: E=Sophos;i="5.85,350,1624345200"; 
   d="scan'208";a="212875074"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2021 00:43:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,350,1624345200"; 
   d="scan'208";a="623779592"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 06 Oct 2021 00:43:14 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Wed, 06 Oct 2021 10:43:13 +0300
Date:   Wed, 6 Oct 2021 10:43:13 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] device property: add a helper for loading
 netdev->dev_addr
Message-ID: <YV1TkRtiu/q2vm/S@kuha.fi.intel.com>
References: <20211005155321.2966828-1-kuba@kernel.org>
 <20211005155321.2966828-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005155321.2966828-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 08:53:20AM -0700, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> There is a handful of drivers which pass netdev->dev_addr as
> the destination buffer to device_get_mac_address(). Add a helper
> which takes a dev pointer instead, so it can call an appropriate
> helper.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/base/property.c  | 20 ++++++++++++++++++++
>  include/linux/property.h |  2 ++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index 453918eb7390..1c8d4676addc 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -997,6 +997,26 @@ void *device_get_mac_address(struct device *dev, char *addr, int alen)
>  }
>  EXPORT_SYMBOL(device_get_mac_address);
>  
> +/**
> + * device_get_ethdev_addr - Set netdev's MAC address from a given device
> + * @dev:	Pointer to the device
> + * @netdev:	Pointer to netdev to write the address to
> + *
> + * Wrapper around device_get_mac_address() which writes the address
> + * directly to netdev->dev_addr.
> + */
> +void *device_get_ethdev_addr(struct device *dev, struct net_device *netdev)
> +{
> +	u8 addr[ETH_ALEN];
> +	void *ret;
> +
> +	ret = device_get_mac_address(dev, addr, ETH_ALEN);
> +	if (ret)
> +		eth_hw_addr_set(netdev, addr);
> +	return ret;
> +}
> +EXPORT_SYMBOL(device_get_ethdev_addr);

Is there some reason why can't this be in net/ethernet/eth.c?

I would really prefer that we don't add any more subsystem specific
functions into this file (drivers/base/property.c).

Shouldn't actually fwnode_get_mac_addr() and fwnode_get_mac_address()
be moved to net/ethernet/eth.c as well?

>  /**
>   * fwnode_irq_get - Get IRQ directly from a fwnode
>   * @fwnode:	Pointer to the firmware node
> diff --git a/include/linux/property.h b/include/linux/property.h
> index 357513a977e5..24dc4d2b9dbd 100644
> --- a/include/linux/property.h
> +++ b/include/linux/property.h
> @@ -15,6 +15,7 @@
>  #include <linux/types.h>
>  
>  struct device;
> +struct net_device;
>  
>  enum dev_prop_type {
>  	DEV_PROP_U8,
> @@ -390,6 +391,7 @@ const void *device_get_match_data(struct device *dev);
>  int device_get_phy_mode(struct device *dev);
>  
>  void *device_get_mac_address(struct device *dev, char *addr, int alen);
> +void *device_get_ethdev_addr(struct device *dev, struct net_device *netdev);

So this you would then introduce in linux/etherdevce.h (?)
But not here, in include/linux/property.h

thanks,

-- 
heikki
