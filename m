Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5092FD7C8
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 19:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391832AbhATSFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 13:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404141AbhATSE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 13:04:29 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5C7C061575;
        Wed, 20 Jan 2021 10:03:26 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l2HpE-009Eds-Mc; Wed, 20 Jan 2021 19:03:24 +0100
Message-ID: <85abb9009642c3a13321970c04f73cf0cf91c2e3.camel@sipsolutions.net>
Subject: Re: [PATCH v2] cfg80211: avoid holding the RTNL when calling the
 driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Date:   Wed, 20 Jan 2021 19:03:23 +0100
In-Reply-To: <20210119102145.99917b8fc5d6.Iacd5916c0e01f71342159f6d419e56dc4c3f07a2@changeid> (sfid-20210119_153923_221115_D0602D5A)
References: <20210119102145.99917b8fc5d6.Iacd5916c0e01f71342159f6d419e56dc4c3f07a2@changeid>
         (sfid-20210119_153923_221115_D0602D5A)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oliver,


Could you take a look at these bits to see if that's fine with you? I'd
like to merge it through mac80211-next (pending some logistics with a
conflict)

> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 1447da1d5729..47c4c1182ef1 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -1560,6 +1560,8 @@ void usbnet_disconnect (struct usb_interface *intf)
>  	struct usbnet		*dev;
>  	struct usb_device	*xdev;
>  	struct net_device	*net;
> +	const struct driver_info *info;
> +	void (*unregdev)(struct net_device *);
>  
>  	dev = usb_get_intfdata(intf);
>  	usb_set_intfdata(intf, NULL);
> @@ -1574,7 +1576,10 @@ void usbnet_disconnect (struct usb_interface *intf)
>  		   dev->driver_info->description);
>  
>  	net = dev->net;
> -	unregister_netdev (net);
> +
> +	info = dev->driver_info;
> +	unregdev = info->unregister_netdev ?: unregister_netdev;
> +	unregdev(net);
>  
>  	cancel_work_sync(&dev->kevent);
>  
> @@ -1627,6 +1632,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>  	int				status;
>  	const char			*name;
>  	struct usb_driver 	*driver = to_usb_driver(udev->dev.driver);
> +	int (*regdev)(struct net_device *);
>  
>  	/* usbnet already took usb runtime pm, so have to enable the feature
>  	 * for usb interface, otherwise usb_autopm_get_interface may return
> @@ -1646,6 +1652,8 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>  	xdev = interface_to_usbdev (udev);
>  	interface = udev->cur_altsetting;
>  
> +	regdev = info->register_netdev ?: register_netdev;
> +
>  	status = -ENOMEM;
>  
>  	// set up our own records
> @@ -1768,7 +1776,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>  		}
>  	}
>  
> -	status = register_netdev (net);
> +	status = regdev(net);
>  	if (status)
>  		goto out5;
>  	netif_info(dev, probe, dev->net,

[...]

> diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
> index 9fe77556858e..b646d4295cfd 100644
> --- a/drivers/net/wireless/rndis_wlan.c
> +++ b/drivers/net/wireless/rndis_wlan.c
> @@ -3598,6 +3598,8 @@ static const struct driver_info	bcm4320b_info = {
>  	.stop =		rndis_wlan_stop,
>  	.early_init =	bcm4320b_early_init,
>  	.indication =	rndis_wlan_indication,
> +	.register_netdev = cfg80211_register_netdev,
> +	.unregister_netdev = cfg80211_unregister_netdev,
>  };
>  
>  static const struct driver_info	bcm4320a_info = {
> @@ -3613,6 +3615,8 @@ static const struct driver_info	bcm4320a_info = {
>  	.stop =		rndis_wlan_stop,
>  	.early_init =	bcm4320a_early_init,
>  	.indication =	rndis_wlan_indication,
> +	.register_netdev = cfg80211_register_netdev,
> +	.unregister_netdev = cfg80211_unregister_netdev,
>  };
>  
>  static const struct driver_info rndis_wlan_info = {
> @@ -3628,6 +3632,8 @@ static const struct driver_info rndis_wlan_info = {
>  	.stop =		rndis_wlan_stop,
>  	.early_init =	unknown_early_init,
>  	.indication =	rndis_wlan_indication,
> +	.register_netdev = cfg80211_register_netdev,
> +	.unregister_netdev = cfg80211_unregister_netdev,
>  };
>  
>  /*-------------------------------------------------------------------------*/

[...]

> diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
> index 88a7673894d5..11e57803acf9 100644
> --- a/include/linux/usb/usbnet.h
> +++ b/include/linux/usb/usbnet.h
> @@ -165,6 +165,12 @@ struct driver_info {
>  	/* rx mode change (device changes address list filtering) */
>  	void	(*set_rx_mode)(struct usbnet *dev);
>  
> +	/* register netdev - defaults to register_netdev() */
> +	int	(*register_netdev)(struct net_device *dev);
> +
> +	/* unregister netdev - defaults to unregister_netdev() */
> +	void	(*unregister_netdev)(struct net_device *dev);
> +
>  	/* for new devices, use the descriptor-reading code instead */
>  	int		in;		/* rx endpoint */
>  	int		out;		/* tx endpoint *

