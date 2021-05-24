Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE75038E215
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 10:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhEXICK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 04:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232099AbhEXICJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 04:02:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF857610CB;
        Mon, 24 May 2021 08:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621843241;
        bh=52KsqdGcL2hpzhP2uHKfCo1RQ1DyXlefkr5za28RcXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iSMgCeWjzCBZekKyZtae/NbX1FqQ/8UPzOYjm637Q+XzaVuhRTv88G3EY53YgbO8s
         C0xD0bf7P4D+9gYjWCEO1i6HqMa5zsPKLMgfCeDSBi2ukzdnvcTK00005TxYOJnJQI
         BZk/wD4A6imNccxqY1t3L7ZPXS+XtZK7fey//UqdM3QOT+HLnBiMTsQqA05fuz7Nou
         m5Yl+uiXogxq1Tv7D356HfHBs23TFccj9Spub+SovWY/KFCju5A12QvqHfeWr03GGN
         KEHMJkZjgjly1fN1AgFw4U6EOhpvcyF0UMxyUOx4dHq8f5PB44ACBPbLwNMStK+jYw
         OYu2Bv7lFQZIQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ll5Vu-00043B-GA; Mon, 24 May 2021 10:00:39 +0200
Date:   Mon, 24 May 2021 10:00:38 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com
Subject: Re: [PATCH net v3] r8152: check the informaton of the device
Message-ID: <YKtdJnvZTxE1yqEK@hovoldconsulting.com>
References: <1394712342-15778-363-Taiwan-albertk@realtek.com>
 <1394712342-15778-365-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394712342-15778-365-Taiwan-albertk@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 02:49:42PM +0800, Hayes Wang wrote:
> Verify some fields of the USB descriptor to make sure the driver
> could be used by the device.
> 
> Besides, remove the check of endpoint number in rtl8152_probe().
> usb_find_common_endpoints() includes it.
> 
> BugLink: https://syzkaller.appspot.com/bug?id=912c9c373656996801b4de61f1e3cb326fe940aa
> Reported-by: syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com
> Fixes: c2198943e33b ("r8152: search the configuration of vendor mode")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
> v3:
> Remove the check of endpoint number in rtl_check_vendor_ok().
> 
> Adjust the error message and ccommit message.
> 
> v2:
> Use usb_find_common_endpoints() and usb_endpoint_num() to replace original
> code.
> 
> remove the check of endpoint number in rtl8152_probe(). It has been done
> in rtl_check_vendor_ok().
> 
>  drivers/net/usb/r8152.c | 42 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 136ea06540ff..f6abb2fbf972 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -8107,6 +8107,37 @@ static void r8156b_init(struct r8152 *tp)
>  	tp->coalesce = 15000;	/* 15 us */
>  }
>  
> +static bool rtl_check_vendor_ok(struct usb_interface *intf)
> +{
> +	struct usb_host_interface *alt = intf->cur_altsetting;
> +	struct usb_endpoint_descriptor *in, *out, *intr;
> +
> +	if (usb_find_common_endpoints(alt, &in, &out, &intr, NULL) < 0) {
> +		dev_err(&intf->dev, "Expected endpoints are not found\n");
> +		return false;
> +	}
> +
> +	/* Check Rx endpoint address */
> +	if (usb_endpoint_num(in) != 1) {
> +		dev_err(&intf->dev, "Invalid Rx endpoint address\n");
> +		return false;
> +	}
> +
> +	/* Check Tx endpoint address */
> +	if (usb_endpoint_num(out) != 2) {
> +		dev_err(&intf->dev, "Invalid Tx endpoint address\n");
> +		return false;
> +	}
> +
> +	/* Check interrupt endpoint address */
> +	if (usb_endpoint_num(intr) != 3) {
> +		dev_err(&intf->dev, "Invalid interrupt endpoint address\n");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  static bool rtl_vendor_mode(struct usb_interface *intf)
>  {
>  	struct usb_host_interface *alt = intf->cur_altsetting;
> @@ -8115,12 +8146,15 @@ static bool rtl_vendor_mode(struct usb_interface *intf)
>  	int i, num_configs;
>  
>  	if (alt->desc.bInterfaceClass == USB_CLASS_VENDOR_SPEC)
> -		return true;
> +		return rtl_check_vendor_ok(intf);
>  
>  	/* The vendor mode is not always config #1, so to find it out. */
>  	udev = interface_to_usbdev(intf);
>  	c = udev->config;
>  	num_configs = udev->descriptor.bNumConfigurations;
> +	if (num_configs < 2)
> +		return false;
> +

Nit: This check looks unnecessary also as the driver can handle a single
configuration just fine, and by removing it you'd be logging "Unexpected
Device\n" below also in the single config case.

>  	for (i = 0; i < num_configs; (i++, c++)) {
>  		struct usb_interface_descriptor	*desc = NULL;
>  
> @@ -8135,7 +8169,8 @@ static bool rtl_vendor_mode(struct usb_interface *intf)
>  		}
>  	}
>  
> -	WARN_ON_ONCE(i == num_configs);
> +	if (i == num_configs)
> +		dev_err(&intf->dev, "Unexpected Device\n");
>  
>  	return false;
>  }
> @@ -9381,9 +9416,6 @@ static int rtl8152_probe(struct usb_interface *intf,
>  	if (!rtl_vendor_mode(intf))
>  		return -ENODEV;
>  
> -	if (intf->cur_altsetting->desc.bNumEndpoints < 3)
> -		return -ENODEV;
> -
>  	usb_reset_device(udev);
>  	netdev = alloc_etherdev(sizeof(struct r8152));
>  	if (!netdev) {

Other than that, looks good to me now.

Reviewed-by: Johan Hovold <johan@kernel.org>

Johan
