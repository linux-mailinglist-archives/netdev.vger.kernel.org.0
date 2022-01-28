Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E26E49F836
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiA1LXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:23:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35418 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiA1LXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 06:23:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8A6DB8253F;
        Fri, 28 Jan 2022 11:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57C4C340E0;
        Fri, 28 Jan 2022 11:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643369016;
        bh=mChaVS62VRMHxG9WuKRILek2xzuVDIFdda4zjzrKGug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lfWbvoHuVgVw8qF5T7BF7/vfDR862M47wwOioeKxyj0dNh+oKPkWjZi103G8axr4N
         E0oMhWORR0EynMfo+F4e3sQHT6qdO37gLlFT3DcI9NAKVIXnDlgHlH/rEI6uxPkdca
         hAwpASLOJ8ujfLF4xzzbsH2KSNYC+I9EyK4rl9DE=
Date:   Fri, 28 Jan 2022 12:23:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Oliver Neukum <oneukum@suse.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <YfPSNSHwTLZBv7me@kroah.com>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
 <YfJ+ceEzvzMM1JsW@kroah.com>
 <20220127123152.GF9150@pengutronix.de>
 <YfKcqcq4Ii1qu2+8@kroah.com>
 <YfPPpkGjL2vcv4oH@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfPPpkGjL2vcv4oH@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 12:12:38PM +0100, Oleksij Rempel wrote:
> On Thu, Jan 27, 2022 at 02:22:49PM +0100, Greg KH wrote:
> > On Thu, Jan 27, 2022 at 01:31:52PM +0100, Oleksij Rempel wrote:
> > > On Thu, Jan 27, 2022 at 12:13:53PM +0100, Greg KH wrote:
> > > > On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> > > > > The weakest link of usbnet devices is the USB cable.
> > > > 
> > > > The weakest link of any USB device is the cable, why is this somehow
> > > > special to usbnet devices?
> > > > 
> > > > > Currently there is
> > > > > no way to automatically detect cable related issues except of analyzing
> > > > > kernel log, which would differ depending on the USB host controller.
> > > > > 
> > > > > The Ethernet packet counter could potentially show evidence of some USB
> > > > > related issues, but can be Ethernet related problem as well.
> > > > > 
> > > > > To provide generic way to detect USB issues or HW issues on different
> > > > > levels we need to make use of devlink.
> > > > 
> > > > Please make this generic to all USB devices, usbnet is not special here
> > > > at all.
> > > 
> > > Ok. I'll need some help. What is the best place to attach devlink
> > > registration in the USB subsystem and the places to attach health
> > > reporters?
> > 
> > You tell us, you are the one that thinks this needs to be reported to
> > userspace. What is only being reported in kernel logs that userspace
> > somehow needs to see?  And what will userspace do with that information?
> 
> The user space should get an event in case there is a problem with the
> USB transfers, i.e. the URB status is != 0.

That's pretty brave, lots of things can have a urb status of != 0 in
semi-normal operation, have you tried this?

> The use space then can decide if the USB device needs to be reset, power
> cycled and so on.
> 
> What about calling a to-be-written devlink function that reports the USB
> status if the URB status is not 0:
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index d0f45600b669..a90134854f32 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -1648,6 +1648,8 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
>  	usb_unanchor_urb(urb);
>  	if (likely(status == 0))
>  		usb_led_activity(USB_LED_EVENT_HOST);
> +	else
> +		devlink_report_usb_status(urb, status);

Try it and do lots of transfers, device additions and removals and other
things and let us know what it reports.

thanks,

greg k-h
