Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5279638C39F
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 11:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbhEUJoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 05:44:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236998AbhEUJoY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 05:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71F5E611AD;
        Fri, 21 May 2021 09:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621590180;
        bh=zBcQCoNeEn7F81G6Lfd6bVakfBgcZDhVPn5bK0XiD7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R3FWrBsTbLNacPwkOoLuppWTIkWev2HpUXsX+dFOem8oPemtfrbLk5TPXrvKfHDg6
         2ZQYswB9VYudyf3uf+rkTGd4YgDONtuRcyBfwqp8tHaCAkxRIuEi80aWJNHXHtlo1a
         95OV0n1jns64oZpm/ciFqMrZExPUj1erRe693Jhg=
Date:   Fri, 21 May 2021 11:42:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com
Subject: Re: [PATCH net] r8152: check the informaton of the device
Message-ID: <YKeAonwHduV8I+NW@kroah.com>
References: <1394712342-15778-363-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394712342-15778-363-Taiwan-albertk@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 05:07:34PM +0800, Hayes Wang wrote:
> Verify some fields of the USB descriptor to make sure the driver
> could be used by the device.
> 
> BugLink: https://syzkaller.appspot.com/bug?id=912c9c373656996801b4de61f1e3cb326fe940aa
> Reported-by: syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com
> Fixes: c2198943e33b ("r8152: search the configuration of vendor mode")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 71 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 69 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 136ea06540ff..f348350f5da1 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -8107,6 +8107,69 @@ static void r8156b_init(struct r8152 *tp)
>  	tp->coalesce = 15000;	/* 15 us */
>  }
>  
> +static bool rtl_check_vendor_ok(struct usb_interface *intf)
> +{
> +	struct usb_host_interface *alt = intf->cur_altsetting;
> +	struct usb_host_endpoint *in = NULL, *out = NULL, *intr = NULL;
> +	unsigned int ep;
> +
> +	if (alt->desc.bNumEndpoints < 3) {
> +		dev_err(&intf->dev, "Unexpected bNumEndpoints %d\n", alt->desc.bNumEndpoints);
> +		return false;
> +	}
> +
> +	for (ep = 0; ep < alt->desc.bNumEndpoints; ep++) {
> +		struct usb_host_endpoint *e;
> +
> +		e = alt->endpoint + ep;
> +
> +		/* ignore endpoints which cannot transfer data */
> +		if (!usb_endpoint_maxp(&e->desc))
> +			continue;
> +
> +		switch (e->desc.bmAttributes) {
> +		case USB_ENDPOINT_XFER_INT:
> +			if (!usb_endpoint_dir_in(&e->desc))
> +				continue;
> +			if (!intr)
> +				intr = e;
> +			break;
> +		case USB_ENDPOINT_XFER_BULK:
> +			if (usb_endpoint_dir_in(&e->desc)) {
> +				if (!in)
> +					in = e;
> +			} else if (!out) {
> +				out = e;
> +			}
> +			break;
> +		default:
> +			continue;
> +		}
> +	}
> +
> +	if (!in || !out || !intr) {
> +		dev_err(&intf->dev, "Miss Endpoints\n");
> +		return false;
> +	}
> +
> +	if ((in->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) != 1) {
> +		dev_err(&intf->dev, "Invalid Rx Endpoints\n");
> +		return false;
> +	}
> +
> +	if ((out->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) != 2) {
> +		dev_err(&intf->dev, "Invalid Tx Endpoints\n");
> +		return false;
> +	}
> +
> +	if ((intr->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) != 3) {
> +		dev_err(&intf->dev, "Invalid interrupt Endpoints\n");
> +		return false;
> +	}
> +
> +	return true;
> +}

We have a USB core function that does all of the above for you, why not
use that instead?

Look at usb_find_common_endpoints() and
usb_find_common_endpoints_reverse() and at the very least
usb_find_bulk_in_endpoint() and related functions.  Please don't
open-code this type of logic, it's easy to get things wrong.

thanks,

greg k-h
