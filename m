Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A2C1B7173
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 12:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgDXKEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 06:04:23 -0400
Received: from mga18.intel.com ([134.134.136.126]:16160 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgDXKEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 06:04:23 -0400
IronPort-SDR: lQNevgnSAYdpCRG7u5HvZw6CJRI9+B4RSG5cUKXCutorunxqVf/6ShU8VIIbDlLaLXpxuW+5Ks
 +Z8u5G8iaR9g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 03:04:22 -0700
IronPort-SDR: 0rZ8bHp+me5uUBc2xp4wacOWeGz9KMvj9xxyBNfUJ9cPDNC6hHi/MaFgNt6E34vFpUvmg9UlRC
 +YWwO73fwrWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="366299723"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 24 Apr 2020 03:04:15 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Fri, 24 Apr 2020 13:04:15 +0300
Date:   Fri, 24 Apr 2020 13:04:15 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Varun Sethi <V.Sethi@nxp.com>, Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [net-next PATCH v1 1/2] device property: Introduce
 fwnode_phy_find_device()
Message-ID: <20200424100415.GA1575367@kuha.fi.intel.com>
References: <20200424031617.24033-1-calvin.johnson@oss.nxp.com>
 <20200424031617.24033-2-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424031617.24033-2-calvin.johnson@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 08:46:16AM +0530, Calvin Johnson wrote:
> Define fwnode_phy_find_device() to iterate an mdiobus and find the
> phy device of the provided phy fwnode.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
>  drivers/base/property.c  | 41 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/property.h |  5 +++++
>  2 files changed, 46 insertions(+)
> 
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index 5f35c0ccf5e0..7c0c14c800b7 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -870,6 +870,47 @@ int device_get_phy_mode(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(device_get_phy_mode);
>  
> +/**
> + * fwnode_phy_find_device - Give a phy fwnode to find the corresponding
> + * phy_device on the mdiobus.
> + * @phy_fwnode: Pointer to the phy's fwnode.
> + *
> + * If successful, returns a pointer to the phy_device with the embedded
> + * struct device refcount incremented by one, or NULL on failure.
> + */
> +struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
> +{
> +	struct device *d;
> +	struct mdio_device *mdiodev;
> +
> +	if (!phy_fwnode)
> +		return NULL;
> +
> +	d = bus_find_device_by_fwnode(&mdio_bus_type, phy_fwnode);
> +	if (d) {
> +		mdiodev = to_mdio_device(d);
> +		if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
> +			return to_phy_device(d);
> +		put_device(d);
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(fwnode_phy_find_device);
> +
> +/**
> + * device_phy_find_device - For the given device, get the phy_device
> + * @dev: Pointer to the given device
> + *
> + * If successful, returns a pointer to the phy_device with the embedded
> + * struct device refcount incremented by one, or NULL on failure.
> + */
> +struct phy_device *device_phy_find_device(struct device *dev)
> +{
> +	return fwnode_phy_find_device(dev_fwnode(dev));
> +}
> +EXPORT_SYMBOL_GPL(device_phy_find_device);

Let's not put any more subsystem specific functions into property.c.

thanks,

-- 
heikki
