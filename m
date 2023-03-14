Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C206B9612
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbjCNN0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbjCNN0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:26:09 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B211B5709A;
        Tue, 14 Mar 2023 06:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678800211; x=1710336211;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TGDiDejSi2pM7Y9MYRLPhUeRrj4RBTO3Qj8rw4sW7VI=;
  b=ElBlmtorVh3EOEzf0k0eY++Tl8GRTFPp8WHc29PcitmWf+Aw373FaWlo
   DdxCUmUaxBnctRuOHrgMtV9PSAGrRvYacRXzxOd4Dx0bWflUX6XPJZiPG
   yDq/H5NA5fDlfW+LPKz+OfX25N3qmVBmYIX/9ALkDLxI9+eFb39e039rU
   Vba/8NykZzOwYk2X1v3QKAwReJ42HCq3+ivgZpy6cffKYmckuDVH8lfNy
   yFHc2Kuv1DfQP0fxHK0cQJ6QNnI4uEke62VB9eaiv7dC8j/2hLHSR/ZUK
   /Iec4+sjhBRC1B4KmC703vUzhYd1NSyv9n86oMes3lhWhyBvnvHtvp137
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="325784663"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="325784663"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 06:22:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="822371802"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="822371802"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 06:22:46 -0700
Date:   Tue, 14 Mar 2023 14:22:37 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Anton Lundin <glance@acc.umu.se>
Subject: Re: [PATCHv4 net] net: asix: fix modprobe "sysfs: cannot create
 duplicate filename"
Message-ID: <ZBB1HR3ow/sGigFB@localhost.localdomain>
References: <20230314055410.3329480-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314055410.3329480-1-grundler@chromium.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 10:54:10PM -0700, Grant Grundler wrote:
> "modprobe asix ; rmmod asix ; modprobe asix" fails with:
>    sysfs: cannot create duplicate filename \
>    	'/devices/virtual/mdio_bus/usb-003:004'
> 
> Issue was originally reported by Anton Lundin on 2022-06-22 (link below).
> 
> Chrome OS team hit the same issue in Feb, 2023 when trying to find
> work arounds for other issues with AX88172 devices.
> 
> The use of devm_mdiobus_register() with usbnet devices results in the
> MDIO data being associated with the USB device. When the asix driver
> is unloaded, the USB device continues to exist and the corresponding
> "mdiobus_unregister()" is NOT called until the USB device is unplugged
> or unauthorized. So the next "modprobe asix" will fail because the MDIO
> phy sysfs attributes still exist.
> 
> The 'easy' (from a design PoV) fix is to use the non-devm variants of
> mdiobus_* functions and explicitly manage this use in the asix_bind
> and asix_unbind function calls. I've not explored trying to fix usbnet
> initialization so devm_* stuff will work.
> 
> Fixes: e532a096be0e5 ("net: usb: asix: ax88772: add phylib support")
> Reported-by: Anton Lundin <glance@acc.umu.se>
> Link: https://lore.kernel.org/netdev/20220623063649.GD23685@pengutronix.de/T/
> Tested-by: Eizan Miyamoto <eizan@chromium.org>
> Signed-off-by: Grant Grundler <grundler@chromium.org>
> 
> ---
>  drivers/net/usb/asix_devices.c | 33 ++++++++++++++++++++++++++++-----
>  1 file changed, 28 insertions(+), 5 deletions(-)
> 
> V4: add mdio_unregister to ax88172_bind() error handling paths
> 
> V3: rebase against netdev/net.git
>     remove "TEST" prefix in subject line
>     added Link: tag for Reported-by tag
> 
> V2: moved mdiobus_get_phy() call back into ax88772_init_phy()
>    (Lukas Wunner is entirely correct this patch is much easier
>    to backport without this patch hunk.)
>    Added "Fixes:" tag per request from Florian Fainelli
> 
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 743cbf5d662c..b758010bab36 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -666,8 +666,9 @@ static int asix_resume(struct usb_interface *intf)
>  static int ax88772_init_mdio(struct usbnet *dev)
>  {
>  	struct asix_common_private *priv = dev->driver_priv;
> +	int ret;
>  
> -	priv->mdio = devm_mdiobus_alloc(&dev->udev->dev);

Hi,

Patch looks good, one question, are the devm_mdiobus_alloc() and
devm_mdiobus_register functions used anywhere after removing? Maybe it
is worth to remove also the implementation if it isn't used.

Otherwise
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

> +	priv->mdio = mdiobus_alloc();
>  	if (!priv->mdio)
>  		return -ENOMEM;
>  
> @@ -679,7 +680,20 @@ static int ax88772_init_mdio(struct usbnet *dev)
>  	snprintf(priv->mdio->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
>  		 dev->udev->bus->busnum, dev->udev->devnum);
>  
> -	return devm_mdiobus_register(&dev->udev->dev, priv->mdio);
> +	ret = mdiobus_register(priv->mdio);
> +	if (ret) {
> +		netdev_err(dev->net, "Could not register MDIO bus (err %d)\n", ret);
> +		mdiobus_free(priv->mdio);
> +		priv->mdio = NULL;
> +	}
> +
> +	return ret;
> +}
> +
> +static void ax88772_mdio_unregister(struct asix_common_private *priv)
> +{
> +	mdiobus_unregister(priv->mdio);
> +	mdiobus_free(priv->mdio);
>  }
>  
>  static int ax88772_init_phy(struct usbnet *dev)
> @@ -690,6 +704,7 @@ static int ax88772_init_phy(struct usbnet *dev)
>  	priv->phydev = mdiobus_get_phy(priv->mdio, priv->phy_addr);
>  	if (!priv->phydev) {
>  		netdev_err(dev->net, "Could not find PHY\n");
> +		ax88772_mdio_unregister(priv);
>  		return -ENODEV;
>  	}
>  
> @@ -896,16 +911,23 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
>  
>  	ret = ax88772_init_mdio(dev);
>  	if (ret)
> -		return ret;
> +		goto mdio_err;
>  
>  	ret = ax88772_phylink_setup(dev);
>  	if (ret)
> -		return ret;
> +		goto phylink_err;
>  
>  	ret = ax88772_init_phy(dev);
>  	if (ret)
> -		phylink_destroy(priv->phylink);
> +		goto initphy_err;
>  
> +	return 0;
> +
> +initphy_err:
> +	phylink_destroy(priv->phylink);
> +phylink_err:
> +	ax88772_mdio_unregister(priv);
> +mdio_err:
>  	return ret;
>  }
>  
> @@ -926,6 +948,7 @@ static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
>  	phylink_disconnect_phy(priv->phylink);
>  	rtnl_unlock();
>  	phylink_destroy(priv->phylink);
> +	ax88772_mdio_unregister(priv);
>  	asix_rx_fixup_common_free(dev->driver_priv);
>  }
>  
> -- 
> 2.40.0.rc1.284.g88254d51c5-goog
> 
