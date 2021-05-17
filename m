Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4474038263B
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbhEQIIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233675AbhEQIIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 04:08:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 894B96117A;
        Mon, 17 May 2021 08:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621238848;
        bh=S1xEZIZ5CsbZYKrV5iPkhrgOe6N7EuOvzRyWvsqEDo0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kC1hJRDu/KEZWeBj0mZJuNH+4yuoAPz96307kF96JP11oUMJmNGf/NhWgQ1b2zR+K
         +L3ckOmdMbPW9Y4lMxsl8uGoPdSu1KVu+Tkr2yjdHLlEGcqyuqdP4L1ubI/k8zJ31Y
         rc7hRpdLzTKSXvaEnn644KZ+kx0R6VJjOHH2dNsDfSqRYcRDFjw6Vl9fUpJcfUNJ+s
         7rPqr5/TEA0OZZNFNz1NwtPK71zYT+7NV7xA2sUXHbYZGCnMUJ/7sfqeMUV39oS1Ay
         AcUCP05HNZmFQkxsj1IvESxtFd/emMY0cowTjeNXbjiJxyzo9BeNN0UBgIkSntGGEs
         LPGPNtsjoPmwQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1liYHd-0003Mx-Ds; Mon, 17 May 2021 10:07:26 +0200
Date:   Mon, 17 May 2021 10:07:25 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Rustam Kovhaev <rkovhaev@gmail.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net] net: hso: check for allocation failure in
 hso_create_bulk_serial_device()
Message-ID: <YKIkPS/RNh32i042@hovoldconsulting.com>
References: <YJurlxqQ9L+zzIAS@hovoldconsulting.com>
 <YJ6IMH7jI9QFdGIX@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ6IMH7jI9QFdGIX@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 05:24:48PM +0300, Dan Carpenter wrote:
> In current kernels, small allocations never actually fail so this
> patch shouldn't affect runtime.
> 
> Originally this error handling code written with the idea that if
> the "serial->tiocmget" allocation failed, then we would continue
> operating instead of bailing out early.  But in later years we added
> an unchecked dereference on the next line.
> 
> 	serial->tiocmget->serial_state_notification = kzalloc();
>         ^^^^^^^^^^^^^^^^^^
> 
> Since these allocations are never going fail in real life, this is
> mostly a philosophical debate, but I think bailing out early is the
> correct behavior that the user would want.  And generally it's safer to
> bail as soon an error happens.
> 
> Fixes: af0de1303c4e ("usb: hso: obey DMA rules in tiocmget")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Do more extensive clean up.  As Johan pointed out the comments and
> later NULL checks can be removed.
> 
>  drivers/net/usb/hso.c | 37 ++++++++++++++++++-------------------
>  1 file changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index 3ef4b2841402..260f850d69eb 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -2618,29 +2618,28 @@ static struct hso_device *hso_create_bulk_serial_device(
>  		num_urbs = 2;
>  		serial->tiocmget = kzalloc(sizeof(struct hso_tiocmget),
>  					   GFP_KERNEL);
> +		if (!serial->tiocmget)
> +			goto exit;
>  		serial->tiocmget->serial_state_notification
>  			= kzalloc(sizeof(struct hso_serial_state_notification),
>  					   GFP_KERNEL);
> -		/* it isn't going to break our heart if serial->tiocmget
> -		 *  allocation fails don't bother checking this.
> -		 */
> -		if (serial->tiocmget && serial->tiocmget->serial_state_notification) {
> -			tiocmget = serial->tiocmget;
> -			tiocmget->endp = hso_get_ep(interface,
> -						    USB_ENDPOINT_XFER_INT,
> -						    USB_DIR_IN);
> -			if (!tiocmget->endp) {
> -				dev_err(&interface->dev, "Failed to find INT IN ep\n");
> -				goto exit;
> -			}
> -
> -			tiocmget->urb = usb_alloc_urb(0, GFP_KERNEL);
> -			if (tiocmget->urb) {
> -				mutex_init(&tiocmget->mutex);
> -				init_waitqueue_head(&tiocmget->waitq);
> -			} else
> -				hso_free_tiomget(serial);
> +		if (!serial->tiocmget->serial_state_notification)
> +			goto exit;
> +		tiocmget = serial->tiocmget;
> +		tiocmget->endp = hso_get_ep(interface,
> +					    USB_ENDPOINT_XFER_INT,
> +					    USB_DIR_IN);
> +		if (!tiocmget->endp) {
> +			dev_err(&interface->dev, "Failed to find INT IN ep\n");
> +			goto exit;
>  		}
> +
> +		tiocmget->urb = usb_alloc_urb(0, GFP_KERNEL);
> +		if (tiocmget->urb) {
> +			mutex_init(&tiocmget->mutex);
> +			init_waitqueue_head(&tiocmget->waitq);
> +		} else
> +			hso_free_tiomget(serial);

This should probably be changed to bail out on allocation errors as well
now but that can be done as a follow-up. Either way:

Reviewed-by: Johan Hovold <johan@kernel.org>

>  	}
>  	else
>  		num_urbs = 1;

Johan
