Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4E438D435
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 09:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhEVHeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 03:34:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhEVHeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 May 2021 03:34:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9564E611AD;
        Sat, 22 May 2021 07:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621668781;
        bh=pMNNxW8vCFw1cZVrNSj8D7OeX7/L/+sT0vTQph+ZiLs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lqs3AhMCG8hydm+sx5nHR4mCKxgscvDr1LDWkz28dgne9h8B2IvXha9gskQhex1Gc
         x4un2MLaschALmF8V6114H5ghecEE8I8ycCtnfaSwrKyFot79fwrykra52NpaoQS0N
         GOmWUE/yT5mjoOqPbAVku6jgTJLe87xbjZRw+ItQ=
Date:   Sat, 22 May 2021 09:32:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2] r8152: check the informaton of the device
Message-ID: <YKizqoNIVFo+weI9@kroah.com>
References: <1394712342-15778-363-Taiwan-albertk@realtek.com>
 <1394712342-15778-364-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394712342-15778-364-Taiwan-albertk@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 22, 2021 at 01:24:54PM +0800, Hayes Wang wrote:
> Verify some fields of the USB descriptor to make sure the driver
> could be used by the device.
> 
> Besides, remove the check of endpoint number in rtl8152_probe().
> It has been done in rtl_check_vendor_ok().
> 
> BugLink: https://syzkaller.appspot.com/bug?id=912c9c373656996801b4de61f1e3cb326fe940aa
> Reported-by: syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com
> Fixes: c2198943e33b ("r8152: search the configuration of vendor mode")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
> v2:
> Use usb_find_common_endpoints() and usb_endpoint_num() to replace original
> code.

Much better, just some tiny grammer changes below:

> 
> remove the check of endpoint number in rtl8152_probe(). It has been done
> in rtl_check_vendor_ok().
> 
>  drivers/net/usb/r8152.c | 44 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 136ea06540ff..6e5230d6c721 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -8107,6 +8107,39 @@ static void r8156b_init(struct r8152 *tp)
>  	tp->coalesce = 15000;	/* 15 us */
>  }
>  
> +static bool rtl_check_vendor_ok(struct usb_interface *intf)
> +{
> +	struct usb_host_interface *alt = intf->cur_altsetting;
> +	struct usb_endpoint_descriptor *in, *out, *intr;
> +
> +	if (alt->desc.bNumEndpoints < 3) {
> +		dev_err(&intf->dev, "Unexpected bNumEndpoints %d\n", alt->desc.bNumEndpoints);
> +		return false;
> +	}
> +
> +	if (usb_find_common_endpoints(alt, &in, &out, &intr, NULL) < 0) {
> +		dev_err(&intf->dev, "Miss Endpoints\n");

"Miss" feels ackward, how about "Invalid number of endpoints"?

> +		return false;
> +	}
> +
> +	if (usb_endpoint_num(in) != 1) {
> +		dev_err(&intf->dev, "Invalid Rx Endpoint\n");

"Invalid number of Rx endpoints"

> +		return false;
> +	}
> +
> +	if (usb_endpoint_num(out) != 2) {
> +		dev_err(&intf->dev, "Invalid Tx Endpoint\n");

"Invalid number of RX endpoints"

> +		return false;
> +	}
> +
> +	if (usb_endpoint_num(intr) != 3) {
> +		dev_err(&intf->dev, "Invalid interrupt Endpoint\n");

"Invalid number of interrupt endpoints"

But really, this doesn't matter, all is good if you don't want to change
this :)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
