Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA839766E
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfHUJyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 05:54:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:44022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbfHUJyV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 05:54:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 192C4ADBB;
        Wed, 21 Aug 2019 09:54:19 +0000 (UTC)
Message-ID: <1566380375.8347.11.camel@suse.com>
Subject: Re: [RFC 2/4] Allow cdc_ncm to set MAC address in hardware
From:   Oliver Neukum <oneukum@suse.com>
To:     Charles.Hyde@dellteam.com, linux-acpi@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     Mario.Limonciello@dell.com, gregkh@linuxfoundation.org,
        nic_swsd@realtek.com, netdev@vger.kernel.org
Date:   Wed, 21 Aug 2019 11:39:35 +0200
In-Reply-To: <1566339663476.54366@Dellteam.com>
References: <1566339663476.54366@Dellteam.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, den 20.08.2019, 22:21 +0000 schrieb
Charles.Hyde@dellteam.com:
> This patch adds support for pushing a MAC address out to USB based
> ethernet controllers driven by cdc_ncm.  With this change, ifconfig can
> now set the device's MAC address.  For example, the Dell Universal Dock
> D6000 is driven by cdc_ncm.  The D6000 can now have its MAC address set
> by ifconfig, as it can be done in Windows.  This was tested with a D6000
> using ifconfig.

On a design note, it looks like you broke S4 with the driver.
Suspend To Disk will cut power and hence reset the MAC to default.
You need to reset it to the user's setting in reset_resume().
Please add that to usbnet.

> 
> Signed-off-by: Charles Hyde <charles.hyde@dellteam.com>
> Cc: Mario Limonciello <mario.limonciello@dell.com>
> Cc: Oliver Neukum <oliver@neukum.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> ---
>  drivers/net/usb/cdc_ncm.c  | 20 +++++++++++++++++++-
>  drivers/net/usb/usbnet.c   | 37 ++++++++++++++++++++++++++++---------
>  include/linux/usb/usbnet.h |  1 +
>  3 files changed, 48 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 50c05d0f44cb..f77c8672f972 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -750,6 +750,24 @@ int cdc_ncm_change_mtu(struct net_device *net, int new_mtu)
>  }
>  EXPORT_SYMBOL_GPL(cdc_ncm_change_mtu);
>  
> +/* Provide method to push MAC address to the USB device's ethernet controller.
> + */
> +int cdc_ncm_set_mac_addr(struct net_device *net, void *p)
> +{
> +	struct usbnet *dev = netdev_priv(net);
> +	struct sockaddr *addr = p;
> +
> +	memcpy(dev->net->dev_addr, addr->sa_data, ETH_ALEN);
> +	/*
> +	 * Try to push the MAC address out to the device.  Ignore any errors,
> +	 * to be compatible with prior versions of this source.
> +	 */
> +	usbnet_set_ethernet_addr(dev);
> +
> +	return eth_mac_addr(net, p);
> +}
> +EXPORT_SYMBOL_GPL(cdc_ncm_set_mac_addr);
> +
>  static const struct net_device_ops cdc_ncm_netdev_ops = {
>  	.ndo_open	     = usbnet_open,
>  	.ndo_stop	     = usbnet_stop,
> @@ -757,7 +775,7 @@ static const struct net_device_ops cdc_ncm_netdev_ops = {
>  	.ndo_tx_timeout	     = usbnet_tx_timeout,
>  	.ndo_get_stats64     = usbnet_get_stats64,
>  	.ndo_change_mtu	     = cdc_ncm_change_mtu,
> -	.ndo_set_mac_address = eth_mac_addr,
> +	.ndo_set_mac_address = cdc_ncm_set_mac_addr,

Why can't this fully go into usbnet?

>  	.ndo_validate_addr   = eth_validate_addr,
>  };
>  
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 72514c46b478..72bdac34b0ee 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -149,20 +149,39 @@ int usbnet_get_ethernet_addr(struct usbnet *dev, int iMACAddress)
>  	int 		tmp = -1, ret;
>  	unsigned char	buf [13];
>  
> -	ret = usb_string(dev->udev, iMACAddress, buf, sizeof buf);
> -	if (ret == 12)
> -		tmp = hex2bin(dev->net->dev_addr, buf, 6);
> -	if (tmp < 0) {
> -		dev_dbg(&dev->udev->dev,
> -			"bad MAC string %d fetch, %d\n", iMACAddress, tmp);
> -		if (ret >= 0)
> -			ret = -EINVAL;
> -		return ret;
> +	ret = usb_get_address(dev->udev, buf);
> +	if (ret == 6)

If you mean ETH_ALEN, you should use it.

> +		memcpy(dev->net->dev_addr, buf, 6);
> +	else if (ret < 0) {
> +		ret = usb_string(dev->udev, iMACAddress, buf, sizeof buf);
> +		if (ret == 12)
> +			tmp = hex2bin(dev->net->dev_addr, buf, 6);
> +		if (tmp < 0) {
> +			dev_dbg(&dev->udev->dev,
> +				"bad MAC string %d fetch, %d\n", iMACAddress,
> +				tmp);
> +			if (ret >= 0)
> +				ret = -EINVAL;
> +			return ret;

Again, you cannot ignore the possibility of getting fewer or more than
6 bytes.

> +		}
>  	}
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(usbnet_get_ethernet_addr);
>  
> +int usbnet_set_ethernet_addr(struct usbnet *dev)
> +{
> +	int ret;
> +
> +	ret = usb_set_address(dev->udev, dev->net->dev_addr);
> +	if (ret < 0) {
> +		dev_dbg(&dev->udev->dev,
> +			"bad MAC address put, %d\n", ret);
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(usbnet_set_ethernet_addr);

What is the purpose of this wrapper?

	Regards
		Oliver

