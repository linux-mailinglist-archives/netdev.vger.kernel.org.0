Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B21F2E1596
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbgLWCuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729533AbgLWCuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:50:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBB332256F;
        Wed, 23 Dec 2020 02:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608691768;
        bh=eS4fWQh/jaxSMtCZ4b30PYeWYMXX9WVqGZxVxgBaCjA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tqNxEfPhUKCrxH1as8VAfyxu6FNEFS4WWJWysumBmamEe79YCgYp8AcSvhaYmbyW4
         khuN6WcOcls+mPGylfKkWzPiVkPn1Msh80E5cJv3vjfvomjg4zAEK+c7suR7DxXhPG
         MlTJvt8Q3nutK+lA5+dxEA5IFavxR6OKtpnQiXW4WjO497CcQ3nE16MAOIfLxLRcVu
         SBoj051RKD36lQc5v14wmKurFtoK21RooSjNIxKnSyRRJpntWWM8vTOcJqf1c+Eoq4
         SK5xzYoCG5ocNwhJsLfqNvLbbvn86yOBao20RYGpjHURtP3aXXCWog478xWtjMoX2o
         WfJkLA9nUdY0A==
Date:   Tue, 22 Dec 2020 18:49:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roland Dreier <roland@kernel.org>
Cc:     Oliver Neukum <oliver@neukum.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: cdc_ncm kernel log spam with trendnet 2.5G USB adapter
Message-ID: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201219222140.4161646-1-roland@kernel.org>
References: <3a9b2c8c275d56d9c7904cf9b5177047b196173d.camel@neukum.org>
        <20201219222140.4161646-1-roland@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Dec 2020 14:21:40 -0800 Roland Dreier wrote:
> (Apologies, trying one more time with a better mailer)
> 
> Sorry it took so long, but I finally got a chance to test the patches.  They
> seem to work well, but they only get rid of the downlink / uplink speed spam -
> I still get the following filling my kernel log with a patched kernel:
> 
>   [   29.830383] cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
>   [   29.894359] cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
>   [   29.958601] cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
>   [   30.022473] cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
>   [   30.086548] cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
> 
> with the below patch on top of your 3, then my kernel log is clean.
> 
> Please apply your patches plus my patch, and feel free to add
> 
> Tested-by: Roland Dreier <roland@kernel.org>
> 
> to the other three.

Hi Ronald, thanks for the patch.

I'm not sure what the story here is but if this change is expected to
get into the networking tree we'll need a fresh posting. This sort of
scissored reply does not get into patchwork.

> Subject: [PATCH] CDC-NCM: remove "connected" log message
> 
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

It sounds like you're getting tens of those messages a second, we can
remove the message but the device is still generating spurious events,
wasting CPU cycles. Was blocking those events deemed unfeasible? 
