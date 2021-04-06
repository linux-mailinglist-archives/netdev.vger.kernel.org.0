Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7FE35546A
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 15:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344264AbhDFNAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 09:00:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35734 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237885AbhDFNAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 09:00:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lTlJU-00F7Go-B3; Tue, 06 Apr 2021 15:00:12 +0200
Date:   Tue, 6 Apr 2021 15:00:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4 0/4] usbnet: speed reporting for devices
 without MDIO
Message-ID: <YGxbXOXquilXNV2W@lunn.ch>
References: <20210405231344.1403025-1-grundler@chromium.org>
 <YGumuzcPl+9l5ZHV@lunn.ch>
 <CANEJEGsYQm9EhqVLA4oedP2fuKrP=3bOUDV9=7owfdZzX7SpUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGsYQm9EhqVLA4oedP2fuKrP=3bOUDV9=7owfdZzX7SpUA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Speed: 2500Mb/s and Duplex: Half is very unlikely. You really only
> > ever see 10 Half and occasionally 100 Half. Anything above that will
> > be full duplex.
> >
> > It is probably best to admit the truth and use DUPLEX_UNKNOWN.
> 
> Agreed. I didn't notice this "lie" until I was writing the commit
> message and wasn't sure off-hand how to fix it. Decided a follow on
> patch could fix it up once this series lands.
> 
> You are right that DUPLEX_UNKNOWN is the safest (and usually correct) default.
> Additionally, if RX and TX speed are equal, I am willing to assume
> this is DUPLEX_FULL.

Is this same interface used by WiFi? Ethernet does not support
different rates in each direction. So if RX and TX are different, i
would actually say something is broken. 10 Half is still doing 10Mbps
in each direction, it just cannot do both at the same time.
WiFi can have asymmetric speeds.

> I can propose something like this in a patch:
> 
> grundler <1637>git diff
> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> index 86eb1d107433..a7ad9a0fb6ae 100644
> --- a/drivers/net/usb/usbnet.c
> +++ b/drivers/net/usb/usbnet.c
> @@ -978,6 +978,11 @@ int usbnet_get_link_ksettings_internal(struct
> net_device *net,
>         else
>                 cmd->base.speed = SPEED_UNKNOWN;
> 
> +       if (dev->rx_speed == dev->tx_speed)
> +               cmd->base.duplex = DUPLEX_FULL;
> +       else
> +               cmd->base.duplex =DUPLEX_UNKNOWN;
> +
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_internal);

So i would say this is wrong. I would just set DUPLEX_UNKNOWN and be
done.

> I can send this out later once this series lands or you are welcome to
> post this with additional checks if you like.

Yes, this discussion should not prevent this patchset from being
merged.

> If we want to assume autoneg is always on (regardless of which type of
> media cdc_ncm/cdc_ether are talking to), we could set both supported
> and advertising to AUTO and lp_advertising to UNKNOWN.

I pretty much agree autoneg has to be on. If it is not, and it is
using a forced speed, there would need to be an additional API to set
what it is forced to. There could be such proprietary calls, but the
generic cdc_ncm/cdc_ether won't support them.

But i also don't know how setting autoneg actually helps the user.
Everybody just assumes it is supported. If you really know auto-neg is
not supported and you can reliably indicate that autoneg is not
supported, that would be useful. But i expect most users want to know
if their USB 2.0 device is just doing 100Mbps, or if their USB 3.0
device can do 2.5G. For that, you need to see what is actually
supported.

	Andrew
