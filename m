Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A954558DD
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244259AbhKRKW6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Nov 2021 05:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244770AbhKRKWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 05:22:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DC9C061766
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 02:19:31 -0800 (PST)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1mneVo-0007U0-08; Thu, 18 Nov 2021 11:19:24 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1mneVm-0005wT-St; Thu, 18 Nov 2021 11:19:22 +0100
Message-ID: <cdb9c0c334823505a2ce499e36be9507112f4298.camel@pengutronix.de>
Subject: Re: [PATCH net-next 2/5] net: lan966x: add the basic lan966x driver
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 18 Nov 2021 11:19:22 +0100
In-Reply-To: <20211117214231.yiv2s6nxl6yx4klq@soft-dev3-1.localhost>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
         <20211117091858.1971414-3-horatiu.vultur@microchip.com>
         <9ab98fba364f736b267dbd5e1d305d3e8426e877.camel@pengutronix.de>
         <20211117214231.yiv2s6nxl6yx4klq@soft-dev3-1.localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Wed, 2021-11-17 at 22:42 +0100, Horatiu Vultur wrote:
> > On Wed, 2021-11-17 at 10:18 +0100, Horatiu Vultur wrote:
> > > +static int lan966x_reset_switch(struct lan966x *lan966x)
> > > +{
> > > +     struct reset_control *reset;
> > > +     int val = 0;
> > > +     int ret;
> > > +
> > > +     reset = devm_reset_control_get_shared(lan966x->dev, "switch");
> > > +     if (IS_ERR(reset))
> > > +             dev_warn(lan966x->dev, "Could not obtain switch reset: %ld\n",
> > > +                      PTR_ERR(reset));
> > > +     else
> > > +             reset_control_reset(reset);
> > 
> > According to the device tree bindings, both resets are required.
> > I'd expect this to return on error.
> > Is there any chance of the device working with out the switch reset
> > being triggered?
> 
> The only case that I see is if the bootloader triggers this switch
> reset and then when bootloader starts the kernel and doesn't set back
> the switch in reset. Is this a valid scenario or is a bug in the
> bootloader?

I'm not sure. In general, the kernel shouldn't rely on the bootloader to
have put the devices into a certain working state. If the driver will
not work or worse, if register access could hang the system if the
bootloader has passed control to the kernel with the switch held in
reset and no reset control is available to the driver, it should not
continue after failure to get the reset handle.

I'd suggest to just use:

	reset = devm_reset_control_get_shared(lan966x->dev, "switch");
	if (IS_ERR(reset))
		return dev_err_probe(lan966x->dev, PTR_ERR(reset),
				     "Could not obtain switch reset");
	reset_control_reset(reset);

unless you have a good reason to do otherwise.

regards
Philipp
