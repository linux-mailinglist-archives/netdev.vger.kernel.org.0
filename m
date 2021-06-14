Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737443A686A
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbhFNNx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233180AbhFNNxX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 09:53:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AF7C6102A;
        Mon, 14 Jun 2021 13:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623678680;
        bh=8IzECU7eHlJMjDQFB8s1Qw6JGmtQq0c3I/cE7rJ4Qrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2Htqu7IBXLoNAN50Z7d9D009mnP7brJ5nMN927jYUTtWbFZq0HMAdgj0TrjU9VJ7S
         o7YtLCveaklyDYHjTVsAZYM4U5q9HQiGj6XrOc79bEiENM82ICBh/kHMaYVhRkmuYV
         P6jESntpPymnS/ZT2352OKPVEZzyJaByRj5evZDY=
Date:   Mon, 14 Jun 2021 15:51:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Davies <jonathan.davies@nutanix.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH] net: usbnet: allow overriding of default USB interface
 naming
Message-ID: <YMde1fN+qIBfCWpD@kroah.com>
References: <20210611152339.182710-1-jonathan.davies@nutanix.com>
 <YMRbt+or+QTlqqP9@kroah.com>
 <469dd530-ebd2-37a4-9c6a-9de86e7a38dc@nutanix.com>
 <YMckz2Yu8L3IQNX9@kroah.com>
 <a620bc87-5ee7-6132-6aa0-6b99e1052960@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a620bc87-5ee7-6132-6aa0-6b99e1052960@nutanix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 11:58:57AM +0100, Jonathan Davies wrote:
> On 14/06/2021 10:43, Greg KH wrote:
> > On Mon, Jun 14, 2021 at 10:32:05AM +0100, Jonathan Davies wrote:
> > > On 12/06/2021 08:01, Greg KH wrote:
> > > > On Fri, Jun 11, 2021 at 03:23:39PM +0000, Jonathan Davies wrote:
> > > > > When the predictable device naming scheme for NICs is not in use, it is
> > > > > common for there to be udev rules to rename interfaces to names with
> > > > > prefix "eth".
> > > > > 
> > > > > Since the timing at which USB NICs are discovered is unpredictable, it
> > > > > can be interfere with udev's attempt to rename another interface to
> > > > > "eth0" if a freshly discovered USB interface is initially given the name
> > > > > "eth0".
> > > > > 
> > > > > Hence it is useful to be able to override the default name. A new usbnet
> > > > > module parameter allows this to be configured.
> > > > > 
> > > > > Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>
> > > > > Suggested-by: Prashanth Sreenivasa <prashanth.sreenivasa@nutanix.com>
> > > > > ---
> > > > >    drivers/net/usb/usbnet.c | 13 ++++++++++---
> > > > >    1 file changed, 10 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> > > > > index ecf6284..55f6230 100644
> > > > > --- a/drivers/net/usb/usbnet.c
> > > > > +++ b/drivers/net/usb/usbnet.c
> > > > > @@ -72,6 +72,13 @@ static int msg_level = -1;
> > > > >    module_param (msg_level, int, 0);
> > > > >    MODULE_PARM_DESC (msg_level, "Override default message level");
> > > > > +#define DEFAULT_ETH_DEV_NAME "eth%d"
> > > > > +
> > > > > +static char *eth_device_name = DEFAULT_ETH_DEV_NAME;
> > > > > +module_param(eth_device_name, charp, 0644);
> > > > > +MODULE_PARM_DESC(eth_device_name, "Device name pattern for Ethernet devices"
> > > > > +				  " (default: \"" DEFAULT_ETH_DEV_NAME "\")");
> > > > 
> > > > This is not the 1990's, please do not add new module parameters as they
> > > > are on a global driver level, and not on a device level.
> > > 
> > > The initial name is set at probe-time, so the device doesn't exist yet. So I
> > > felt like it was a choice between either changing the hard-coded "eth%d"
> > > string or providing a driver-level module parameter. Is there a better
> > > alternative?
> > 
> > This has always been this way, why is this suddenly an issue?  What
> > changed to cause the way we can name these devices after they have been
> > found like we have been for the past decade+?
> 
> The thing that changed for me was that system-udevd does *not* have the
> backoff and retry logic that traditional versions of udev had.
> 
> Compare implementations of rename_netif in
> https://git.kernel.org/pub/scm/linux/hotplug/udev.git/tree/src/udev-event.c
> (traditional udev, which handles collisions) and
> https://github.com/systemd/systemd/blob/main/src/udev/udev-event.c
> (systemd-udevd, which does not handle collisions).

Then submit a change to add the logic back.  This looks like a userspace
tool breaking existing setups, so please take it up with the developers
of that tool.  The kernel has not changed or "broken" anything here.

> I think this logic was removed under the assumption that users of
> systemd-udevd would also use the predictable device naming scheme, meaning
> renames are guaranteed to not collide with devices being probed.

Why are you not using the predictable device naming scheme?  If you have
multiple network devices in the system, it seems like that is a good
idea to follow as the developers added that for a reason.

> > > > Also changing the way usb network devices are named is up to userspace,
> > > > the kernel should not be involved in this.  What is wrong with just
> > > > renaming it in userspace as you want to today?
> > > 
> > > Yes, renaming devices is the responsibility of userspace. Normally udev will
> > > rename a device shortly after it is probed. But there's a window during
> > > which it has the name the kernel initially assigns. If there's other
> > > renaming activity happening during that window there's a chance of
> > > collisions.
> > > 
> > > Userspace solutions include:
> > >   1. udev backing off and retrying in the event of a collision; or
> > >   2. avoiding ever renaming a device to a name in the "eth%d" namespace.
> > 
> > Picking a different namespace does not cause a lack of collisions to
> > happen, you could have multiple usb network devices being found at the
> > same time, right?
> > 
> > So no matter what, 1) has to happen.
> 
> Within a namespace, the "%d" in "eth%d" means __dev_alloc_name finds a name
> that's not taken. I didn't check the locking but assume that can only happen
> serially, in which case two devices probed in parallel would not mutually
> collide.
> 
> So I don't think it's necessarily true that 1) has to happen.

Multiple USB devices in the system will cause the same exact thing to
happen with your patch, so you still need 1).

thanks

greg k-h
