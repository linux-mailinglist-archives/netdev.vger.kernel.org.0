Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2506A23A249
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 11:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHCJtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 05:49:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgHCJtt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 05:49:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC5DD20738;
        Mon,  3 Aug 2020 09:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596448188;
        bh=AOd5mU/IV5ma2vZu6WbSVyum0I7+XwIbnJfqfk7G3hI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SzIafBdpFWTmYPKo9r5jdMekjBOjDiB1icU5H7Z0VfYw4sdDGKMxldlF+DTbNCwdx
         mdRqXcHp8FINdHQWjuR0lTOAEEuE/EB03vN++iGSwBVxjPP+2E00CqCDwS77J07oPk
         q2ffpdmRZFAqyGzFHI9ynLFht5NkUXdGaKRUpiFU=
Date:   Mon, 3 Aug 2020 11:49:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     yzc666@netease.com, =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb <linux-usb@vger.kernel.org>,
        carl <carl.yin@quectel.com>
Subject: Re: [PATCH] qmi_wwan: support modify usbnet's rx_urb_size
Message-ID: <20200803094931.GD635660@kroah.com>
References: <20200803065105.8997-1-yzc666@netease.com>
 <20200803081604.GC493272@kroah.com>
 <CAGRyCJE-BF=0tWakreObGv-skahDp-ui8zP1TPPkX48sMFk4-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGRyCJE-BF=0tWakreObGv-skahDp-ui8zP1TPPkX48sMFk4-w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 10:26:18AM +0200, Daniele Palmas wrote:
> Hi Greg,
> 
> Il giorno lun 3 ago 2020 alle ore 10:18 Greg KH
> <gregkh@linuxfoundation.org> ha scritto:
> >
> > On Mon, Aug 03, 2020 at 02:51:05PM +0800, yzc666@netease.com wrote:
> > > From: carl <carl.yin@quectel.com>
> > >
> > >     When QMUX enabled, the 'dl-datagram-max-size' can be 4KB/16KB/31KB depend on QUALCOMM's chipsets.
> > >     User can set 'dl-datagram-max-size' by 'QMI_WDA_SET_DATA_FORMAT'.
> > >     The usbnet's rx_urb_size must lager than or equal to the 'dl-datagram-max-size'.
> > >     This patch allow user to modify usbnet's rx_urb_size by next command.
> > >
> > >               echo 4096 > /sys/class/net/wwan0/qmi/rx_urb_size
> > >
> > >               Next commnds show how to set and query 'dl-datagram-max-size' by qmicli
> > >               # qmicli -d /dev/cdc-wdm1 --wda-set-data-format="link-layer-protocol=raw-ip, ul-protocol=qmap,
> > >                               dl-protocol=qmap, dl-max-datagrams=32, dl-datagram-max-size=31744, ep-type=hsusb, ep-iface-number=4"
> > >               [/dev/cdc-wdm1] Successfully set data format
> > >                                       QoS flow header: no
> > >                                   Link layer protocol: 'raw-ip'
> > >                      Uplink data aggregation protocol: 'qmap'
> > >                    Downlink data aggregation protocol: 'qmap'
> > >                                         NDP signature: '0'
> > >               Downlink data aggregation max datagrams: '10'
> > >                    Downlink data aggregation max size: '4096'
> > >
> > >           # qmicli -d /dev/cdc-wdm1 --wda-get-data-format
> > >               [/dev/cdc-wdm1] Successfully got data format
> > >                                  QoS flow header: no
> > >                              Link layer protocol: 'raw-ip'
> > >                 Uplink data aggregation protocol: 'qmap'
> > >               Downlink data aggregation protocol: 'qmap'
> > >                                    NDP signature: '0'
> > >               Downlink data aggregation max datagrams: '10'
> > >               Downlink data aggregation max size: '4096'
> > >
> > > Signed-off-by: carl <carl.yin@quectel.com>
> > > ---
> > >  drivers/net/usb/qmi_wwan.c | 39 ++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 39 insertions(+)
> > >
> > > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > > index 07c42c0719f5b..8ea57fd99ae43 100644
> > > --- a/drivers/net/usb/qmi_wwan.c
> > > +++ b/drivers/net/usb/qmi_wwan.c
> > > @@ -400,6 +400,44 @@ static ssize_t raw_ip_store(struct device *d,  struct device_attribute *attr, co
> > >       return ret;
> > >  }
> > >
> > > +static ssize_t rx_urb_size_show(struct device *d, struct device_attribute *attr, char *buf)
> > > +{
> > > +     struct usbnet *dev = netdev_priv(to_net_dev(d));
> > > +
> > > +     return sprintf(buf, "%zd\n", dev->rx_urb_size);
> >
> > Why do you care about this?
> >
> > > +}
> > > +
> > > +static ssize_t rx_urb_size_store(struct device *d,  struct device_attribute *attr,
> > > +                              const char *buf, size_t len)
> > > +{
> > > +     struct usbnet *dev = netdev_priv(to_net_dev(d));
> > > +     u32 rx_urb_size;
> > > +     int ret;
> > > +
> > > +     if (kstrtou32(buf, 0, &rx_urb_size))
> > > +             return -EINVAL;
> > > +
> > > +     /* no change? */
> > > +     if (rx_urb_size == dev->rx_urb_size)
> > > +             return len;
> > > +
> > > +     if (!rtnl_trylock())
> > > +             return restart_syscall();
> > > +
> > > +     /* we don't want to modify a running netdev */
> > > +     if (netif_running(dev->net)) {
> > > +             netdev_err(dev->net, "Cannot change a running device\n");
> > > +             ret = -EBUSY;
> > > +             goto err;
> > > +     }
> > > +
> > > +     dev->rx_urb_size = rx_urb_size;
> > > +     ret = len;
> > > +err:
> > > +     rtnl_unlock();
> > > +     return ret;
> > > +}
> > > +
> > >  static ssize_t add_mux_show(struct device *d, struct device_attribute *attr, char *buf)
> > >  {
> > >       struct net_device *dev = to_net_dev(d);
> > > @@ -505,6 +543,7 @@ static DEVICE_ATTR_RW(add_mux);
> > >  static DEVICE_ATTR_RW(del_mux);
> > >
> > >  static struct attribute *qmi_wwan_sysfs_attrs[] = {
> > > +     &dev_attr_rx_urb_size.attr,
> >
> > You added a driver-specific sysfs file and did not document in in
> > Documentation/ABI?  That's not ok, sorry, please fix up.
> >
> > Actually, no, this all should be done "automatically", do not change the
> > urb size on the fly.  Change it at probe time based on the device you
> > are using, do not force userspace to "know" what to do here, as it will
> > not know that at all.
> >
> 
> the problem with doing at probe time is that rx_urb_size is not fixed,
> but depends on the configuration done at the userspace level with
> QMI_WDA_SET_DATA_FORMAT, so the userspace knows that.

Where does QMI_WDA_SET_DATA_FORMAT come from?

And the commit log says that this "depends on the chipset being used",
so why don't you know that at probe time, does the chipset change?  :)

> Currently there's a workaround for setting rx_urb_size i.e. changing
> the network interface MTU: this is fine for most uses with qmap, but
> there's the limitation that certain values (multiple of the endpoint
> size) are not allowed.

Why not just set it really high to start with?  That should not affect
any older devices, as the urb size does not matter.  The only thing is
if it is too small that things can not move as fast as they might be
able to.

thanks,

greg k-h
