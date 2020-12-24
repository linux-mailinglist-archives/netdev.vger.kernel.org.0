Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BADE2E2556
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 08:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgLXHyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 02:54:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbgLXHyg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Dec 2020 02:54:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BA2222571;
        Thu, 24 Dec 2020 07:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608796436;
        bh=JpdEM1KFQ9SN6wPewCJ79XuY6eR+d8OwNoFGLsjFUu0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qp/bvnXpT/PnmnCXsrLeKWcmUDYta8PAaXDNiRdYCgphAPyTpAceVFFAVeVtJatWF
         Qookzrnw9T40URK8dgNtLZqoKQEevdsjQ2h0/7UtItuh5GsFxQXYQV1HYTjJujMtkP
         imf7G234fFqee6MGSRfuGUupAuGWau6taCZarQHU=
Date:   Thu, 24 Dec 2020 08:53:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Roland Dreier <roland@kernel.org>
Cc:     Oliver Neukum <oliver@neukum.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] CDC-NCM: remove "connected" log message
Message-ID: <X+RJEI+1AR5E0z3z@kroah.com>
References: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201224032116.2453938-1-roland@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201224032116.2453938-1-roland@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 07:21:16PM -0800, Roland Dreier wrote:
> The cdc_ncm driver passes network connection notifications up to
> usbnet_link_change(), which is the right place for any logging.
> Remove the netdev_info() duplicating this from the driver itself.
> 
> This stops devices such as my "TRENDnet USB 10/100/1G/2.5G LAN"
> (ID 20f4:e02b) adapter from spamming the kernel log with
> 
>     cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
> 
> messages every 60 msec or so.
> 
> Signed-off-by: Roland Dreier <roland@kernel.org>
> ---
>  drivers/net/usb/cdc_ncm.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index a45fcc44facf..50d3a4e6d445 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -1850,9 +1850,6 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
>  		 * USB_CDC_NOTIFY_NETWORK_CONNECTION notification shall be
>  		 * sent by device after USB_CDC_NOTIFY_SPEED_CHANGE.
>  		 */
> -		netif_info(dev, link, dev->net,
> -			   "network connection: %sconnected\n",
> -			   !!event->wValue ? "" : "dis");
>  		usbnet_link_change(dev, !!event->wValue, 0);
>  		break;
>  
> -- 
> 2.29.2
> 

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
