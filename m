Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5672F1FD29A
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgFQQsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:48:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbgFQQsC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 12:48:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlbEG-000yzg-BC; Wed, 17 Jun 2020 18:48:00 +0200
Date:   Wed, 17 Jun 2020 18:48:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tanjeff-Nicolai Moos <tmoos@eltec.de>
Cc:     netdev@vger.kernel.org
Subject: Re: qmi_wwan not using netif_carrier_*()
Message-ID: <20200617164800.GG205574@lunn.ch>
References: <20200617152153.2e66ccaf@pm-tm-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617152153.2e66ccaf@pm-tm-ubuntu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 03:21:53PM +0200, Tanjeff-Nicolai Moos wrote:
> Hi netdevs,
> 
> Kernel version:
> 
>   I'm working with kernel 4.14.137 (OpenWRT project). But I looked at
>   the source of kernel 5.7 and found the same situation.
> 
> Problem:
> 
>   I'm using the qmi_wwan driver for a Sierra Wireless EM7455 LTE
>   modem. This driver does not use
>   netif_carrier_on()/netif_carrier_off() to update its link status.
>   This confuses ledtrig_netdev which uses netif_carrier_ok() to obtain
>   the link status.
> 
> My solution:
> 
>   As a solution (or workaround?) I would try:
> 
>   1) In drivers/net/usb/qmi_wwan.c, lines 904/913: Add the flag
>      FLAG_LINK_INTR.
> 
>   2) In drivers/net/usb/usbnet.c, functions usbnet_open() and
>      usbnet_stop(): Add a call to netif_carrier_*(),
>      but only if FLAG_LINK_INTR is set.
> 
> Question:
> 
>   Is this the intended way to use FLAG_LINK_INTR and netif_carrier_*()?
>   Or is there another recommended way to obtain the link status of
>   network devices (I could change ledtrig_netdev)?

Hi Tanjeff

With Ethernet, having a carrier means there is a link partner, the
layer 2 of the OSI 7 layer stack model is working. If the interface is
not open()ed, it clearly should not have carrier. However, just
because it is open, does not mean it has carrier. The cable could be
unplugged, etc.

This is an LTE modem. What does carrier mean here? I don't know if it
is well defined, but i would guess it is connected to a base station
which is offering service. I'm assuming you are interested in data
here, not wanting to make a 911/999/112/$EMERGENCY_SERVICE call which
in theory all base stations should accept.

Is there a way to get this state information from the hardware? That
would be the correct way to set the carrier.

      Andrew
