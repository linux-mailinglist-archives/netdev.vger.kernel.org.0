Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1ADC22CC2B
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 19:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgGXR0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 13:26:30 -0400
Received: from foss.arm.com ([217.140.110.172]:37468 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgGXR02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 13:26:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B18D431B;
        Fri, 24 Jul 2020 10:26:27 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5186D3F66F;
        Fri, 24 Jul 2020 10:26:27 -0700 (PDT)
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
Date:   Fri, 24 Jul 2020 12:26:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200724133931.GF1472201@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/24/20 8:39 AM, Andrew Lunn wrote:
>> Otherwise the MDIO bus and its phy should be a
>> child of the nic/mac using it, with standardized behaviors/etc left up to
>> the OSPM when it comes to MDIO bus enumeration/etc.
> 
> Hi Jeremy
> 
> Could you be a bit more specific here please.
> 
> DT allows
> 
>          macb0: ethernet@fffc4000 {
>                  compatible = "cdns,at32ap7000-macb";
>                  reg = <0xfffc4000 0x4000>;
>                  interrupts = <21>;
>                  phy-mode = "rmii";
>                  local-mac-address = [3a 0e 03 04 05 06];
>                  clock-names = "pclk", "hclk", "tx_clk";
>                  clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
>                  ethernet-phy@1 {
>                          reg = <0x1>;
>                          reset-gpios = <&pioE 6 1>;
>                  };
>          };
> 
> So the PHY is a direct child of the MAC. The MDIO bus is not modelled
> at all. Although this is allowed, it is deprecated, because it results > in problems with advanced systems which have multiple different
> children, and the need to differentiate them. So drivers are slowly

I don't think i'm suggesting that, because AFAIK in ACPI you would have 
to specify the DEVICE() for mdio, in order to nest a further set of 
phy's via _ADR(). I think in general what I was describing would look 
more like what you have below. But..

> migrating to always modelling the MDIO bus. In that case, the
> phy-handle is always used to point to the PHY:
> 
>          eth0: ethernet@522d0000 {
>                  compatible = "socionext,synquacer-netsec";
>                  reg = <0 0x522d0000 0x0 0x10000>, <0 0x10000000 0x0 0x10000>;
>                  interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
>                  clocks = <&clk_netsec>;
>                  clock-names = "phy_ref_clk";
>                  phy-mode = "rgmii";
>                  max-speed = <1000>;
>                  max-frame-size = <9000>;
>                  phy-handle = <&phy1>;
> 
>                  mdio {
>                          #address-cells = <1>;
>                          #size-cells = <0>;
>                          phy1: ethernet-phy@1 {
>                                  compatible = "ethernet-phy-ieee802.3-c22";
>                                  reg = <1>;
>                          };
>                  };
> 
> "mdio-handle" is just half of phy-handle.
> 
> What you seem to be say is that although we have defined a generic
> solution for ACPI which should work in all cases, it is suggested to
> not use it? What exactly are you suggesting in its place?

When you put it that way, what i'm saying sounds crazy.

In this case what are are doing isn't as clean as what you have 
described above, its more like:

mdio: {
   phy1: {}
   phy2: {}
}
...
// somewhere else
dmac1: {
     phy-handle = <&phy1>;
}

... //somewhere else
eth0: {
    //another device talking to the mgmt controller
}


Which is special in a couple ways.

Lets rewind for a moment and say for ARM/ACPI, what we are talking about 
are "edge/server class" devices (with RAS statements/etc) where the 
expectation is that they will be running virtualized workloads using LTS 
distros, or non linux OSes. DT/etc remains an option for networking 
devices which are more "embedded", aren't SBSA, etc. So an Arm 
based/ACPI machine should be more regular and share more in the way of 
system architecture with other SBSA/SBBR/ACPI/etc machines than has been 
the case for DT machines.

A concern is then how we punch networking devices into an arbitrary VM 
in a standardized way using libvirt/whatever. If the networking device 
doesn't look like a simple self contained memory mapped resource with an 
IOMMU domain, I think everything becomes more complicated and you have 
to start going down the path of special caseing the VM firmware beyond 
how its done for self contained PCIe/SRIOV devices. The latter manage to 
pull this all off with a PCIe id, and a couple BARs fed into the VM.

So, I would hope an ACPI nic representation is closer to just a minimal 
resource list like:

eth0: {
       compatible = "cdns,at32ap7000-macb";
       reg = <0xfffc4000 0x4000>;
       interrupts = <21>;
}
or in ACPI speak:
Device (ETH0)
{
       Name (_HID, "CDNSXXX")
       Method (_CRS, 0x0, Serialized)
       {
         Name (RBUF, ResourceTemplate ()
         {
           Memory32Fixed (ReadWrite, 0xfffc4000, 0x4000, )
           Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive)
           {
             21
           }
         })
         Return (RBUF)
       }
}

(Plus methods for pwr mgmt/etc as needed, the iommu info comes from 
another table).

Returning to the NXP part. They avoid the entirety of the above 
discussion because all this MDIO/PHY mgmt is just feeding the data into 
the mgmt controller, and the bits that are punched into the VM are 
fairly standalone.

Anyway, I think this set is generally fine, I would like to see this 
part working well with ACPI given its what we have available today. For 
the future, we also need to continue pushing everyone towards common 
hardware standards. One of the ways of doing this is having hardware 
which can be automatically enumerated/configured. Suggesting that the 
kernel has a recommended way of doing this which aids fragmentation 
isn't what we are trying to achieve with ACPI. Hence my previous comment 
that we should consider this an escape hatch rather than the last word 
in how to describe networking on ACPI/SBSA platforms.

Thanks,
