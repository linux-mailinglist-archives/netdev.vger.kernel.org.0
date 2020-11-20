Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEDE2BBA21
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgKTXYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:24:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728740AbgKTXYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 18:24:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kgFlf-008BKk-9K; Sat, 21 Nov 2020 00:24:39 +0100
Date:   Sat, 21 Nov 2020 00:24:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201120232439.GA1949248@lunn.ch>
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-3-george.mccollister@gmail.com>
 <20201120193321.GP1853236@lunn.ch>
 <CAFSKS=P=epx3Sr3OzkCg9ycoftmXm__PaMee7HWbAGXYdqgbDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=P=epx3Sr3OzkCg9ycoftmXm__PaMee7HWbAGXYdqgbDw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi George

> > > +static void xrs700x_port_stp_state_set(struct dsa_switch *ds, int port,
> > > +                                    u8 state)
> > > +{
> > > +     struct xrs700x *priv = ds->priv;
> > > +     unsigned int val;
> > > +
> > > +     switch (state) {
> > > +     case BR_STATE_DISABLED:
> > > +             val = XRS_PORT_DISABLED;
> > > +             break;
> > > +     case BR_STATE_LISTENING:
> > > +             val = XRS_PORT_DISABLED;
> > > +             break;
> >
> > No listening state?
> 
> No, just forwarding, learning and disabled. See:
> https://www.flexibilis.com/downloads/xrs/SpeedChip_XRS7000_3000_User_Manual.pdf
> page 82.
> 
> >
> > > +     case BR_STATE_LEARNING:
> > > +             val = XRS_PORT_LEARNING;
> > > +             break;
> > > +     case BR_STATE_FORWARDING:
> > > +             val = XRS_PORT_FORWARDING;
> > > +             break;
> > > +     case BR_STATE_BLOCKING:
> > > +             val = XRS_PORT_DISABLED;
> > > +             break;
> >
> > Hum. What exactly does XRS_PORT_DISABLED mean? When blocking, it is
> > expected you can still send/receive BPDUs.
> 
> Datasheet says: "Disabled. Port neither learns MAC addresses nor forwards data."

I think you need to do some testing here. Put the device into a loop
with another switch, the bridge will block a port, and see if it still
can send/receive BPDUs on the blocked port.

If it cannot send/receive BPDUs, it might get into an oscillating
state. They see each other via BPDUs, decide there is a loop, and
block a port. The BPDUs stop, they think the loop has been broken and
so unblock. They see each other via BPUS, decide there is a loop,...

> > > +static int xrs700x_i2c_reg_read(void *context, unsigned int reg,
> > > +                             unsigned int *val)
> > > +{
> > > +     int ret;
> > > +     unsigned char buf[4];
> > > +     struct device *dev = context;
> > > +     struct i2c_client *i2c = to_i2c_client(dev);
> > > +
> > > +     buf[0] = reg >> 23 & 0xff;
> > > +     buf[1] = reg >> 15 & 0xff;
> > > +     buf[2] = reg >> 7 & 0xff;
> > > +     buf[3] = (reg & 0x7f) << 1;
> > > +
> > > +     ret = i2c_master_send(i2c, buf, sizeof(buf));
> >
> > Are you allowed to perform transfers on stack buffers? I think any I2C
> > bus driver using DMA is going to be unhappy.
> 
> It should be fine. See the following file, there is a good write up about this:
> See Documentation/i2c/dma-considerations.rst

O.K, thanks for the pointer.

> > > +static const struct of_device_id xrs700x_i2c_dt_ids[] = {
> > > +     { .compatible = "arrow,xrs7003" },
> > > +     { .compatible = "arrow,xrs7004" },
> > > +     {},
> >
> > Please validate that the compatible string actually matches the switch
> > found. Otherwise we can get into all sorts of horrible backward
> > compatibility issues.
> 
> Okay. What kind of compatibility issues? Do you have a hypothetical
> example? I guess I will just use of_device_is_compatible() to check.

Since it currently does not matter, you can expect 50% of the boards
to get it wrong. Sometime later, you find some difference between the
two, you want to add additional optional properties dependent on the
compatible string. But that is made hard, because 50% of the boards
are broken, and the compatible string is now worthless.

Either you need to verify the compatible from day one so it is not
wrong, or you just use a single compatible "arrow,xrs700x", which
cannot be wrong.

  Andrew
