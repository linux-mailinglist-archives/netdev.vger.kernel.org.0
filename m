Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AAC2FFA05
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 02:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbhAVBg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 20:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbhAVBgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 20:36:23 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5B3C0613D6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 17:35:43 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id o125so2201341vsc.6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 17:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhDwpu3ikwYygM4oiSvm5B6mg/6Q+Vve0WMVsVsakY4=;
        b=PmNF7zWGGkMfysydqUgdfw8ZFBT3QyNGV/qCuIzIUrdQf3W2gkDYX+Ovl18s47yLJY
         7MGkbPn0xFs9X6/oDNNSfWXI49rYwU5ksle28/XOxNZVk0t84b41OL8h/NmkBlpLAX09
         /Mfb+moQkFL5oXLlwHbRKfpinqZj/m+pJogto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dhDwpu3ikwYygM4oiSvm5B6mg/6Q+Vve0WMVsVsakY4=;
        b=AqBIWmbPUu+jopqKN1Zu5bxDo1uAznaWWYPA1OIsqY+vO0ti4p39e+IReSq9HTpltv
         l+kwoTTBdDjBWzONT8a2ga3OTX9A9UQhuOw3gL7N1h6kITqFcG2VXKK2A8Oq5tegerIx
         xetWRKP+wwyOAiBocCJ5H0p9wPV3MaPikFkRcbjePJjxtHGgJbvN4q0rpYvAQynJgLIx
         wU/WjgcopHmT4txGxWLQHhJ2pBBpigozEnIzd2cnxUdZZSBl9ixQKYxBkcMQjaqU0bwM
         rex0A2aX0uMkNCkZCzdmok5jD7rbqs6w/FFUkuzfCfc2WjuxjOLsa2W0da7Xj68QucEb
         98Pw==
X-Gm-Message-State: AOAM531v8J6mRqn3YfQkPuf4+jSa9NNZnhT8saPdb/uENjuo+2AmiuJX
        aimZymU9w+S0ymvEFe7Ie0Gcmud58gW3YoFeOQJJA7jjhhg=
X-Google-Smtp-Source: ABdhPJxAzbn6qsV5vmVMszjjWZdlKgI+b8c8HrvMZ7QiBzYLP5bBwHUoXRQKsamE1AvwtkWo7UmSiMw5LV2TW2pCU24=
X-Received: by 2002:a05:6102:226f:: with SMTP id v15mr200762vsd.36.1611279341078;
 Thu, 21 Jan 2021 17:35:41 -0800 (PST)
MIME-Version: 1.0
References: <20210121125731.19425-1-oneukum@suse.com> <20210121125731.19425-3-oneukum@suse.com>
In-Reply-To: <20210121125731.19425-3-oneukum@suse.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Fri, 22 Jan 2021 01:35:29 +0000
Message-ID: <CANEJEGu8vhKmFzjHfxWAhK13EQwFG3nv9xXY4=sFvJ_03Ec0fA@mail.gmail.com>
Subject: Re: [PATCHv2 2/3] usbnet: add method for reporting speed without MDIO
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Hayes Wang <hayeswang@realtek.com>,
        Grant Grundler <grundler@chromium.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        Roland Dreier <roland@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 12:57 PM Oliver Neukum <oneukum@suse.com> wrote:
>
> The old method for reporting network speed upwards
> assumed that a device uses MDIO and uses the generic phy
> functions based on that.
> Add a a primitive internal version not making the assumption
> reporting back directly what the status operations record.

Excellent!  I wasted a bunch of time looking at emulating the MDIO
interface and decided that was too hacky.  I didn't realize it could
be so easy to fork off a different method to collect the most recently
reported speed. Thank you!

> v2: adjusted to recent changes
>
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Tested-by: Roland Dreier <roland@kernel.org>
> ---
>  drivers/net/usb/usbnet.c   | 23 +++++++++++++++++++++++
>  include/linux/usb/usbnet.h |  4 ++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index e2ca88259b05..6f8fcc276ca7 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -961,6 +961,27 @@ int usbnet_get_link_ksettings_mdio(struct net_device *net,
>  }
>  EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_mdio);
>
> +int usbnet_get_link_ksettings_internal(struct net_device *net,
> +                                       struct ethtool_link_ksettings *cmd)
> +{
> +       struct usbnet *dev = netdev_priv(net);
> +
> +       /* the assumption that speed is equal on tx and rx
> +        * is deeply engrained into the networking layer.
> +        * For wireless stuff it is not true.
> +        * We assume that rxspeed matters more.
> +        */
> +       if (dev->rxspeed != SPEED_UNKNOWN)
> +               cmd->base.speed = dev->rxspeed / 1000000;
> +       else if (dev->txspeed != SPEED_UNKNOWN)
> +               cmd->base.speed = dev->txspeed / 1000000;
> +       else
> +               cmd->base.speed = SPEED_UNKNOWN;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_internal);
> +
>  int usbnet_set_link_ksettings_mdio(struct net_device *net,
>                               const struct ethtool_link_ksettings *cmd)
>  {
> @@ -1664,6 +1685,8 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
>         dev->intf = udev;
>         dev->driver_info = info;
>         dev->driver_name = name;
> +       dev->rxspeed = SPEED_UNKNOWN; /* unknown or handled by MII */
> +       dev->txspeed = SPEED_UNKNOWN;

Nit: Use of SPEED_UNKNOWN here can be confusing since the units for
rxspeed/txspeed are bps, not Mbps (AFAICT SPEED_XXX are Mbps numbers).
In other words, this is the only usbnet location that could use
SPEED_xxx define and other developers might not realize that.
Personally, I'd rather set the fields to zero here.

>
>         net->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
>         if (!net->tstats)
> diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
> index fd65b7a5ee15..a91c6defb104 100644
> --- a/include/linux/usb/usbnet.h
> +++ b/include/linux/usb/usbnet.h
> @@ -53,6 +53,8 @@ struct usbnet {
>         u32                     hard_mtu;       /* count any extra framing */
>         size_t                  rx_urb_size;    /* size for rx urbs */
>         struct mii_if_info      mii;
> +       long                    rxspeed;        /* if MII is not used */
> +       long                    txspeed;        /* if MII is not used */

Do you want to note the units used (bps) in the trailing comment?

The numbers for cdc_ncm and cdc_ether will be "bits per second" due to
how older modems could report "odd" (from an ethernet point of view)
speeds.

Also, the changes I just submitted (and kuba@kernel.org accepted)
named these "rx_speed" (with underscore). I don't care which it is but
just wanted to warn about and apologize for the conflict.

cheers,
grant

>         /* various kinds of pending driver work */
>         struct sk_buff_head     rxq;
> @@ -269,6 +271,8 @@ extern void usbnet_purge_paused_rxq(struct usbnet *);
>
>  extern int usbnet_get_link_ksettings_mdio(struct net_device *net,
>                                      struct ethtool_link_ksettings *cmd);
> +extern int usbnet_get_link_ksettings_internal(struct net_device *net,
> +                                       struct ethtool_link_ksettings *cmd);
>  extern int usbnet_set_link_ksettings_mdio(struct net_device *net,
>                                      const struct ethtool_link_ksettings *cmd);
>  extern u32 usbnet_get_link(struct net_device *net);
> --
> 2.26.2
>
