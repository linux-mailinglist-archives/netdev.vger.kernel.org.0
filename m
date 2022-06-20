Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AB15524CD
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 21:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244994AbiFTTri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 15:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240882AbiFTTrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 15:47:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140801CFF5;
        Mon, 20 Jun 2022 12:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vlTtblH9D41r6dqll6MyR6DASss9XlNO9zQiEWLxQgk=; b=Rlh3jiZ/GWkhoGj+xIEMzvjrbV
        JJmnXj2GBV31a0Umz6JQ9JwtOLxwgGHkrp4KU9NMZC0mpl3RuGMjyhDQrlckcZsawQocjem+psG/u
        7aaO8KWpOIfMjj60vheC/N+nflnSBBT7cdS2aE0zjBckJmc2/X2W6gOBWxqfzMs9Tu+I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o3NMx-007eEK-RN; Mon, 20 Jun 2022 21:47:31 +0200
Date:   Mon, 20 Jun 2022 21:47:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, lenb@kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA
 description
Message-ID: <YrDO05TMK8SVgnBP@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-10-mw@semihalf.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +In DSDT/SSDT the scope of switch device is extended by the front-panel
> +and one or more so called 'CPU' switch ports. Additionally
> +subsequent MDIO busses with attached PHYs can be described.

Humm, dsa.yaml says nothing about MDIO busses with attached PHYs.
That is up to each individual DSA drivers binding.

Please spilt this into a generic DSA binding, similar to dsa.yaml, and
a Marvell specific binding, similar to marvell.txt. It might be you
also need a generic MDIO binding, since the marvell device is just an
MDIO device, and inherits some of its properties from MDIO.

> +
> +This document presents the switch description with the required subnodes
> +and _DSD properties.
> +
> +These properties are defined in accordance with the "Device
> +Properties UUID For _DSD" [dsd-guide] document and the
> +daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
> +Data Descriptors containing them.
> +
> +Switch device
> +=============
> +
> +The switch device is represented as a child node of the MDIO bus.
> +It must comprise the _HID (and optionally _CID) field, so to allow matching
> +with appropriate driver via ACPI ID. The other obligatory field is
> +_ADR with the device address on the MDIO bus [adr]. Below example
> +shows 'SWI0' switch device at address 0x4 on the 'SMI0' bus.
>
> +.. code-block:: none
> +
> +    Scope (\_SB.SMI0)
> +    {
> +        Name (_HID, "MRVL0100")
> +        Name (_UID, 0x00)
> +        Method (_STA)
> +        {
> +            Return (0xF)
> +        }
> +        Name (_CRS, ResourceTemplate ()
> +        {
> +            Memory32Fixed (ReadWrite,
> +                0xf212a200,
> +                0x00000010,

What do these magic numbers mean?

> +                )
> +        })
> +        Device (SWI0)
> +        {
> +            Name (_HID, "MRVL0120")
> +            Name (_UID, 0x00)
> +            Name (_ADR, 0x4)
> +            <...>
> +        }

I guess it is not normal for ACPI, but could you add some comments
which explain this. In DT we have

    properties:
      reg:
        minimum: 0
        maximum: 31
        description:
          The ID number for the device.

which i guess what this _ADR property is, but it would be nice if it
actually described what it is supposed to mean. You have a lot of
undocumented properties here.


> +label
> +-----
> +A property with a string value describing port's name in the OS. In case the
> +port is connected to the MAC ('CPU' port), its value should be set to "cpu".

Each port is a MAC, so "is connected to the MAC" is a bit
meaningless. "CPU Port" is well defined in DSA, and is a DSA concept,
not a DT concept, so you might as well just use it here.

> +
> +phy-handle
> +----------
> +For each MAC node, a device property "phy-handle" is used to reference
> +the PHY that is registered on an MDIO bus. This is mandatory for
> +network interfaces that have PHYs connected to MAC via MDIO bus.

It is not mandatory. The DSA core will assume that port 0 has a PHY
using address 0, port 1 has a PHY using address 1, etc. You only need
a phy-handle when this assumption does not work.

> +See [phy] for more details.
> +
> +ethernet
> +--------
> +A property valid for the so called 'CPU' port and should comprise a reference
> +to the MAC object declared in the DSDT/SSDT.

Is "MAC" an ACPI term? Because this does not seem very descriptive to
me. DT says:

      Should be a phandle to a valid Ethernet device node.  This host
      device is what the switch port is connected to

> +
> +fixed-link
> +----------
> +The 'fixed-link' is described by a data-only subnode of the
> +port, which is linked in the _DSD package via
> +hierarchical data extension (UUID dbb8e3e6-5886-4ba6-8795-1319f52a966b
> +in accordance with [dsd-guide] "_DSD Implementation Guide" document).
> +The subnode should comprise a required property ("speed") and
> +possibly the optional ones - complete list of parameters and
> +their values are specified in [ethernet-controller].

You appear to be cut/pasting
Documentation/firmware-guide/acpi/dsd/phy.txt. Please just reference
it.

> +Below example comprises MDIO bus ('SMI0') with a PHY at address 0x0 ('PHY0')
> +and a switch ('SWI0') at 0x4. The so called 'CPU' port ('PRT5') is connected to
> +the SoC's MAC (\_SB.PP20.ETH2). 'PRT2' port is configured as 1G fixed-link.

This is ACPI, so it is less likely to be a SoC. The hosts CPU port
could well be an external PCIe device for example. Yes, there are AMD
devices with built in MACs, but in the ACPI world, they don't happen
so often.

I assume you have 3 different 'compatible' strings for the nv88e6xxx
driver? You should document them somewhere and say how they map to
different marvell switches,

	Andrew
