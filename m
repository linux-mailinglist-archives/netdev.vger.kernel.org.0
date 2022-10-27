Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907F160F711
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiJ0MV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbiJ0MVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:21:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE105B7A9;
        Thu, 27 Oct 2022 05:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=xsGtsidvxvyfqpXeJMajzF00+EPlnmxjEEENNgRqwIk=; b=yS
        W4WeALI5A3+voHv6z2AQ8Y9fgHothwYySsklSOPalHOwZNxrzi+to4nwrBqhWaNqkGA3DWEmqXoc+
        dLyubpCvgqSvCCp7xNrffQJ4nxkD8KqU7LY3HApCL4xWaL33Qv+lsc2E1KVFA4BKSLRRRP+/8hgb/
        g943WZpoDIWXurI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oo1sJ-000hio-7p; Thu, 27 Oct 2022 14:20:43 +0200
Date:   Thu, 27 Oct 2022 14:20:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Camel Guo <camelg@axis.com>
Cc:     Camel Guo <Camel.Guo@axis.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, kernel <kernel@axis.com>
Subject: Re: [RFC net-next 2/2] net: dsa: Add driver for Maxlinear GSW1XX
 switch
Message-ID: <Y1p3m9lEMuJg1pUe@lunn.ch>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-3-camel.guo@axis.com>
 <Y1f4bIavgSv0OWi0@lunn.ch>
 <a04fc8bd-e18e-c300-8300-7cba8fe33557@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a04fc8bd-e18e-c300-8300-7cba8fe33557@axis.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +}
> >> +
> >> +static int gsw1xx_mdio_wr(struct mii_bus *bus, int addr, int reg, u16 val)
> >> +{
> >> +     struct gsw1xx_priv *priv = bus->priv;
> >> +     int err;
> >
> > Please check for C45 and return -EOPNOTSUPP.
> 
> Maybe not need. According to the datasheet of gsw145 "The interface uses the
> serial protocol defined by IEEE 802.3, clause 22.",  I think it is enough to
> add "ds->slave_mii_bus->probe_capabilities = MDIOBUS_C22" into gsw1xx_mdio. It
> probe_capabilities is static and never changes.

probe_capabilities only limits probing the bus when it is
registered. It does not prevent C45 transfers from being requested by
PHY drivers. And there are some funky PHY drivers which mix C22 and
C45. They can probe via C22 and then use C45. So it is much better to
check and return an error if requested to do something which the
hardware cannot do. Also, if you don't check, and convert a C45
request into a C22 request, you often end up with really odd accesses,
depending on the hardware, reads could become writes, etc.

> > I noticed there is no tagging protocol defined. How are frames
> > direction out a specific port?
> 
> Yes, this chip supports Special Tags which should be enabled, but unfortunately
> I have no make it work.

You need to make this work. You added support to set the port spanning
tree status. But that makes no sense if you cannot send/receive bridge
PDUs out specific ports, etc.

> The chip in my dev board works in self-start, managed switch mode. So far, it
> works fine on this board.
> 
> >
> > I've also not yet looked at the overlap with lantiq_gswip.c.
> 
> The version of GSWIP changes and also the management interface of
> it is memory-mapped io. I tried to use the same logic in my gsw145 chip
> (with mdio interface update), lots of parts (e.g: fdb, vlan) don't work
> at all.

There has been past attempts at a driver for this hardware and it was
argued that they are sufficiently different that a new driver was
needed. As i said, i've not compared the code yet, so i cannot comment
on that yet.

   Andrew
