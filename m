Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392A22E97DB
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 15:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbhADO6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 09:58:24 -0500
Received: from mx2.suse.de ([195.135.220.15]:53516 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbhADO6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 09:58:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1609772257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L5yNjEafPzP289xRpFdvzul6uqGS/O26nEe9wkdAtpU=;
        b=IDS5q66n+uNOcJ5f0xHaC8VZoRnMPK4p1WzhVg08jiD0nV8CL78yZYBjU+RrG7jqgr3jyW
        6iTS6eCCQ825zBo0OIwIb3W7if4WGdAxgo8lDi96Cxu3obAPUMZeK+OUHlkzio4hBVRZ8u
        FKaAseN4nqcoiKMbTxKmD/3ppXzGBlA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E1711ACBA;
        Mon,  4 Jan 2021 14:57:36 +0000 (UTC)
Message-ID: <cebe1c1bf2fcbb6c39fd297e4a4a0ca52642fe18.camel@suse.com>
Subject: Re: [PATCH] CDC-NCM: remove "connected" log message
From:   Oliver Neukum <oneukum@suse.com>
To:     Roland Dreier <roland@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Date:   Mon, 04 Jan 2021 15:57:35 +0100
In-Reply-To: <CAG4TOxOOPgAqUtX14V7k-qPCbOm7+5gaHOqBvgWBYQwJkO6v8g@mail.gmail.com>
References: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20201224032116.2453938-1-roland@kernel.org> <X+RJEI+1AR5E0z3z@kroah.com>
         <20201228133036.3a2e9fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <CAG4TOxNM8du=xadLeVwNU5Zq=MW7Kj74-1d9ThZ0q2OrXHE5qQ@mail.gmail.com>
         <24c6faa2a4f91c721d9a7f14bb7b641b89ae987d.camel@neukum.org>
         <CAG4TOxOc2OJnzJg9mwd2h+k0mj250S6NdNQmhK7BbHhT4_KdVA@mail.gmail.com>
         <12f345107c0832a00c43767ac6bb3aeda4241d4e.camel@suse.com>
         <CAG4TOxOOPgAqUtX14V7k-qPCbOm7+5gaHOqBvgWBYQwJkO6v8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Donnerstag, den 31.12.2020, 10:51 -0800 schrieb Roland Dreier:
> I haven't tried these patches yet but they don't look quite right to
> me.  inlining the first 0001 patch:

OK, let's see.

>  > diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
>  > index 1447da1d5729..bcd17f6d6de6 100644
>  > --- a/drivers/net/usb/usbnet.c
>  > +++ b/drivers/net/usb/usbnet.c
[...]
>  > +EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_mdio);
> 
> why keep and export the old function when it will have no callers?

But they will callers. Have a dozen drivers use them. The goal
of this patch set is to not touch them.
> 
>  > +int usbnet_get_link_ksettings(struct net_device *net,
>  > +                    struct ethtool_link_ksettings *cmd)
>  > +{
>  > +    struct usbnet *dev = netdev_priv(net);
>  > +
>  > +    /* the assumption that speed is equal on tx and rx
>  > +     * is deeply engrained into the networking layer.
>  > +     * For wireless stuff it is not true.
>  > +     * We assume that rxspeed matters more.
>  > +     */
>  > +    if (dev->rxspeed != SPEED_UNKNOWN)
>  > +        cmd->base.speed = dev->rxspeed / 1000000;
>  > +    else if (dev->txspeed != SPEED_UNKNOWN)
>  > +        cmd->base.speed = dev->txspeed / 1000000;
>  > +    /* if a minidriver does not record speed we try to
>  > +     * fall back on MDIO
>  > +     */
>  > +    else if (!dev->mii.mdio_read)
>  > +        cmd->base.speed = SPEED_UNKNOWN;
>  > +    else
>  > +        mii_ethtool_get_link_ksettings(&dev->mii, cmd);
>  > +
>  > +    return 0;
> 
> This is a change in behavior for every driver that doesn't set rxspeed
> / txspeed - the old get_link function would return EOPNOTSUPP if
> mdio_read isn't implemented, now we give SPEED_UNKNOWN with a
> successful return code.

Yes. This is a drawback. Yet the speed is unknown is it not?

>  > @@ -1661,6 +1687,8 @@ usbnet_probe (struct usb_interface *udev,
> const struct usb_device_id *prod)
>  >      dev->intf = udev;
>  >      dev->driver_info = info;
>  >      dev->driver_name = name;
>  > +    dev->rxspeed = -1; /* unknown or handled by MII */
>  > +    dev->txspeed = -1;
> 
> Minor nit: if we're going to test these against SPEED_UNKNOWN above,
> then I think it's clearer to initialize them to that value via the
> same constant.

Correct. The next iteration will do that.

>  > diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
>  > index 88a7673894d5..f748c758f82a 100644
>  > --- a/include/linux/usb/usbnet.h
>  > +++ b/include/linux/usb/usbnet.h
>  > @@ -267,8 +269,11 @@ extern void usbnet_purge_paused_rxq(struct usbnet *);
>  >
>  >  extern int usbnet_get_link_ksettings(struct net_device *net,
>  >                       struct ethtool_link_ksettings *cmd);
>  > -extern int usbnet_set_link_ksettings(struct net_device *net,
>  > +extern int usbnet_set_link_ksettings_mdio(struct net_device *net,
>  >                       const struct ethtool_link_ksettings *cmd);
>  > +/* Legacy - to be used if you really need an error to be returned */
>  > +extern int usbnet_set_link_ksettings(struct net_device *net,
>  > +                    const struct ethtool_link_ksettings *cmd);
>  >  extern u32 usbnet_get_link(struct net_device *net);
>  >  extern u32 usbnet_get_msglevel(struct net_device *);
>  >  extern void usbnet_set_msglevel(struct net_device *, u32);
> 
> I think this was meant to be changing get_link, not set_link.
> 
> Also I don't understand the "Legacy" comment.  Is that referring to
> the EOPNOTSUPP change I mentioned above?  If so, wouldn't it be better

Yes.

> to preserve the legacy behavior rather than changing the behavior of
> every usbnet driver all at once?  Like make a new
> usbnet_get_link_ksettings_nonmdio and update only cdc_ncm to use it?

Then I would have to touch them all. The problem is that the MDIO
stuff really is pretty much a layering violation. It should never
have been default. But now it is.

	Regards
		Oliver


