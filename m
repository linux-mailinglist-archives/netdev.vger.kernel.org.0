Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934F03A5F4E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 11:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhFNJpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 05:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:57116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232744AbhFNJps (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 05:45:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1E3F61380;
        Mon, 14 Jun 2021 09:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623663826;
        bh=yDnvkcL961dddYvd6TtADP5E7K5H1lSTtf2JPmXr+ho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m3smhpcwWmmghTzyTUWqXOgTYr7/t8q0OnN5QO0fWzuZSEucP7Up2F4DD5oYkSma/
         anFOebtaJVYj/nugsplPs5t1Vu9bFIZjwYiVYHfcOy1wXpENVnsGZNGC1p7Sy/B8g2
         KVSWcxMZn6wSjx8pUVHkWvWdkapU6Gg0VKVQCOMY=
Date:   Mon, 14 Jun 2021 11:43:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Davies <jonathan.davies@nutanix.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH] net: usbnet: allow overriding of default USB interface
 naming
Message-ID: <YMckz2Yu8L3IQNX9@kroah.com>
References: <20210611152339.182710-1-jonathan.davies@nutanix.com>
 <YMRbt+or+QTlqqP9@kroah.com>
 <469dd530-ebd2-37a4-9c6a-9de86e7a38dc@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469dd530-ebd2-37a4-9c6a-9de86e7a38dc@nutanix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 10:32:05AM +0100, Jonathan Davies wrote:
> On 12/06/2021 08:01, Greg KH wrote:
> > On Fri, Jun 11, 2021 at 03:23:39PM +0000, Jonathan Davies wrote:
> > > When the predictable device naming scheme for NICs is not in use, it is
> > > common for there to be udev rules to rename interfaces to names with
> > > prefix "eth".
> > > 
> > > Since the timing at which USB NICs are discovered is unpredictable, it
> > > can be interfere with udev's attempt to rename another interface to
> > > "eth0" if a freshly discovered USB interface is initially given the name
> > > "eth0".
> > > 
> > > Hence it is useful to be able to override the default name. A new usbnet
> > > module parameter allows this to be configured.
> > > 
> > > Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>
> > > Suggested-by: Prashanth Sreenivasa <prashanth.sreenivasa@nutanix.com>
> > > ---
> > >   drivers/net/usb/usbnet.c | 13 ++++++++++---
> > >   1 file changed, 10 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> > > index ecf6284..55f6230 100644
> > > --- a/drivers/net/usb/usbnet.c
> > > +++ b/drivers/net/usb/usbnet.c
> > > @@ -72,6 +72,13 @@ static int msg_level = -1;
> > >   module_param (msg_level, int, 0);
> > >   MODULE_PARM_DESC (msg_level, "Override default message level");
> > > +#define DEFAULT_ETH_DEV_NAME "eth%d"
> > > +
> > > +static char *eth_device_name = DEFAULT_ETH_DEV_NAME;
> > > +module_param(eth_device_name, charp, 0644);
> > > +MODULE_PARM_DESC(eth_device_name, "Device name pattern for Ethernet devices"
> > > +				  " (default: \"" DEFAULT_ETH_DEV_NAME "\")");
> > 
> > This is not the 1990's, please do not add new module parameters as they
> > are on a global driver level, and not on a device level.
> 
> The initial name is set at probe-time, so the device doesn't exist yet. So I
> felt like it was a choice between either changing the hard-coded "eth%d"
> string or providing a driver-level module parameter. Is there a better
> alternative?

This has always been this way, why is this suddenly an issue?  What
changed to cause the way we can name these devices after they have been
found like we have been for the past decade+?

> > Also changing the way usb network devices are named is up to userspace,
> > the kernel should not be involved in this.  What is wrong with just
> > renaming it in userspace as you want to today?
> 
> Yes, renaming devices is the responsibility of userspace. Normally udev will
> rename a device shortly after it is probed. But there's a window during
> which it has the name the kernel initially assigns. If there's other
> renaming activity happening during that window there's a chance of
> collisions.
> 
> Userspace solutions include:
>  1. udev backing off and retrying in the event of a collision; or
>  2. avoiding ever renaming a device to a name in the "eth%d" namespace.

Picking a different namespace does not cause a lack of collisions to
happen, you could have multiple usb network devices being found at the
same time, right?

So no matter what, 1) has to happen.

> Solution 1 is ugly and slow. It's much neater to avoid the collisions in the
> first place where possible.

This is not being solved by changing the name as you have to do this no
matter what.

And the code and logic in userspace is already there to do this, right?
This is not a new issue, what changed to cause it to show up for you?

> Solution 2 arises naturally from use of the predictable device naming
> scheme. But when userspace is not using that, solution 2 may not apply.

Again you always have to do 1 no matter what, so might as well just do
it.

> Yes, the problem is a result of userspace decisions, but that doesn't mean
> the kernel can't help make things easier.

Ideally, if you _can_ do something in userspace, you should, especially
for policy decisions like naming.  That is why udev was created 17 years
ago :)

thanks,

greg k-h
