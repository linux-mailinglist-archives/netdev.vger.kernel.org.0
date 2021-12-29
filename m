Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3561848134E
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 14:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239658AbhL2NO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 08:14:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48418 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240418AbhL2NOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 08:14:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E82AE614CA;
        Wed, 29 Dec 2021 13:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07403C36AE9;
        Wed, 29 Dec 2021 13:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640783657;
        bh=imPdmxzZUglWX07rnNIT1/7x7bo67M5eeIds1Wp26FE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wk1Hq2Cwb0v4jpW2/Ddn6yI6DkVBVkDo6xP7Y4Q4u7Fn7vPwi96z6AG9oqr6tYmXH
         9zB4qhHS4ZKRVLEo1LcuW4CKxOgbGCGPSaTYiZw8Nf1kcWnTSa0ZphTfDhZ/iZIKlF
         J5P0s6CVGKwsukbvMqQo8yG0KFbhGkg+j5p00ojE=
Date:   Wed, 29 Dec 2021 14:14:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adam Kandur <sys.arch.adam@gmail.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/usb: remove goto in ax88772_reset()
Message-ID: <YcxfJjpTBm6Gbiwb@kroah.com>
References: <20211229125730.6779-1-sys.arch.adam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229125730.6779-1-sys.arch.adam@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 03:57:30PM +0300, Adam Kandur wrote:
> goto statements in ax88772_reset() in net/usb/asix_devices.c are used
> to return ret variable. As function by default returns 0 if ret
> variable >= 0 and "out:" only returns ret, I assume goto might be
> removed.
> 
> Signed-off-by: Adam Kandur <sys.arch.adam@gmail.com>
> 
> ---
>  drivers/net/usb/asix_devices.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 4514d35ef..9de5fc53f 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -332,23 +332,20 @@ static int ax88772_reset(struct usbnet *dev)
>  	ret = asix_write_cmd(dev, AX_CMD_WRITE_NODE_ID, 0, 0,
>  			     ETH_ALEN, data->mac_addr, 0);
>  	if (ret < 0)
> -		goto out;
> +		return ret;
>  
>  	/* Set RX_CTL to default values with 2k buffer, and enable cactus */
>  	ret = asix_write_rx_ctl(dev, AX_DEFAULT_RX_CTL, 0);
>  	if (ret < 0)
> -		goto out;
> +		return ret;
>  
>  	ret = asix_write_medium_mode(dev, AX88772_MEDIUM_DEFAULT, 0);
>  	if (ret < 0)
> -		goto out;
> +		return ret;
>  
>  	phy_start(priv->phydev);
>  
>  	return 0;
> -
> -out:
> -	return ret;
>  }

There is nothing wrong with the goto here, it's the common error path
style for the kernel.  Why should it be removed?  What is the benefit
here?

thanks,

greg k-h
