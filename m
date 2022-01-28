Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46AB49F852
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbiA1LbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbiA1LbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 06:31:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65183C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 03:31:12 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nDPTB-0003hG-H3; Fri, 28 Jan 2022 12:31:09 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1nDPTA-00Cldy-Hw; Fri, 28 Jan 2022 12:31:08 +0100
Date:   Fri, 28 Jan 2022 12:31:08 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Oliver Neukum <oneukum@suse.com>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 1/1] usbnet: add devlink support
Message-ID: <YfPT/CZCh9WPNYI3@pengutronix.de>
References: <20220127110742.922752-1-o.rempel@pengutronix.de>
 <YfJ+ceEzvzMM1JsW@kroah.com>
 <20220127123152.GF9150@pengutronix.de>
 <YfKcqcq4Ii1qu2+8@kroah.com>
 <YfPPpkGjL2vcv4oH@pengutronix.de>
 <YfPSNSHwTLZBv7me@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YfPSNSHwTLZBv7me@kroah.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:28:20 up 92 days, 17:55, 123 users,  load average: 2.68, 5.84,
 7.25
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 12:23:33PM +0100, Greg KH wrote:
> On Fri, Jan 28, 2022 at 12:12:38PM +0100, Oleksij Rempel wrote:
> > On Thu, Jan 27, 2022 at 02:22:49PM +0100, Greg KH wrote:
> > > On Thu, Jan 27, 2022 at 01:31:52PM +0100, Oleksij Rempel wrote:
> > > > On Thu, Jan 27, 2022 at 12:13:53PM +0100, Greg KH wrote:
> > > > > On Thu, Jan 27, 2022 at 12:07:42PM +0100, Oleksij Rempel wrote:
> > > > > > The weakest link of usbnet devices is the USB cable.
> > > > > 
> > > > > The weakest link of any USB device is the cable, why is this somehow
> > > > > special to usbnet devices?
> > > > > 
> > > > > > Currently there is
> > > > > > no way to automatically detect cable related issues except of analyzing
> > > > > > kernel log, which would differ depending on the USB host controller.
> > > > > > 
> > > > > > The Ethernet packet counter could potentially show evidence of some USB
> > > > > > related issues, but can be Ethernet related problem as well.
> > > > > > 
> > > > > > To provide generic way to detect USB issues or HW issues on different
> > > > > > levels we need to make use of devlink.
> > > > > 
> > > > > Please make this generic to all USB devices, usbnet is not special here
> > > > > at all.
> > > > 
> > > > Ok. I'll need some help. What is the best place to attach devlink
> > > > registration in the USB subsystem and the places to attach health
> > > > reporters?
> > > 
> > > You tell us, you are the one that thinks this needs to be reported to
> > > userspace. What is only being reported in kernel logs that userspace
> > > somehow needs to see?  And what will userspace do with that information?
> > 
> > The user space should get an event in case there is a problem with the
> > USB transfers, i.e. the URB status is != 0.
> 
> That's pretty brave, lots of things can have a urb status of != 0 in
> semi-normal operation, have you tried this?
> 
> > The use space then can decide if the USB device needs to be reset, power
> > cycled and so on.
> > 
> > What about calling a to-be-written devlink function that reports the USB
> > status if the URB status is not 0:
> > 
> > diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> > index d0f45600b669..a90134854f32 100644
> > --- a/drivers/usb/core/hcd.c
> > +++ b/drivers/usb/core/hcd.c
> > @@ -1648,6 +1648,8 @@ static void __usb_hcd_giveback_urb(struct urb *urb)
> >  	usb_unanchor_urb(urb);
> >  	if (likely(status == 0))
> >  		usb_led_activity(USB_LED_EVENT_HOST);
> > +	else
> > +		devlink_report_usb_status(urb, status);
> 
> Try it and do lots of transfers, device additions and removals and other
> things and let us know what it reports.

Ok :)

I'll need make some other tasks next week, will respond ASAP as i'll
continue on this task. 

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
