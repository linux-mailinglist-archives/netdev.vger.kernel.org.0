Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5E32317CC
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 04:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbgG2Cxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 22:53:46 -0400
Received: from foss.arm.com ([217.140.110.172]:44142 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731052AbgG2Cxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 22:53:46 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81CDD31B;
        Tue, 28 Jul 2020 19:53:45 -0700 (PDT)
Received: from [192.168.122.166] (unknown [10.119.48.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 007BD3F66E;
        Tue, 28 Jul 2020 19:53:44 -0700 (PDT)
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Dan Callaghan <dan.callaghan@opengear.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King <linux@armlinux.org.uk>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        linux-acpi <linux-acpi@vger.kernel.org>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
 <1595922651-sup-5323@galangal.danc.bne.opengear.com>
 <9e63aabf-8993-9ce0-1274-c29d7a5fc267@arm.com>
 <1e4301bf-cbf2-a96b-0b76-611ed08aa39a@gmail.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <f046fa8b-6bac-22c3-0d9f-9afb20877fc9@arm.com>
Date:   Tue, 28 Jul 2020 21:53:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1e4301bf-cbf2-a96b-0b76-611ed08aa39a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/28/20 7:39 PM, Florian Fainelli wrote:
> On 7/28/2020 3:30 PM, Jeremy Linton wrote:
>> Hi,
>>
>> On 7/28/20 3:06 AM, Dan Callaghan wrote:
>>> Excerpts from Andrew Lunn's message of 2020-07-24 21:14:36 +02:00:
>>>> Now i could be wrong, but are Ethernet switches something you expect
>>>> to see on ACPI/SBSA platforms? Or is this a legitimate use of the
>>>> escape hatch?
>>>
>>> As an extra data point: right now I am working on an x86 embedded
>>> appliance (ACPI not Device Tree) with 3x integrated Marvell switches.
>>> I have been watching this patch series with great interest, because
>>> right now there is no way for me to configure a complex switch topology
>>> in DSA without Device Tree.
>>
>> DSA though, the switch is hung off a normal MAC/MDIO, right? (ignoring
>> whether that NIC/MAC is actually hug off PCIe for the moment).
> 
> There is no specific bus, we have memory mapped, MDIO, SPI, I2C swiches
> all supported within the driver framework right now.
> 
>>
>> It just has a bunch of phy devices strung out on that single MAC/MDIO.
> 
> It has a number of built-in PHYs that typically appear on a MDIO bus,
> whether that bus is the switch's internal MDIO bus, or another MDIO bus
> (which could be provided with just two GPIOs) depends on how the switch
> is connected to its management host.
> 
> When the switch is interfaced via MDIO the switch also typically has a
> MDIO interface called the pseudo-PHY which is how you can actually tap
> into the control interface of the switch, as opposed to reading its
> internal PHYs from the MDIO bus.
> 
>> So in ACPI land it would still have a relationship similar to the one
>> Andrew pointed out with his DT example where the eth0->mdio->phy are all
>> contained in their physical parent. The phy in that case associated with
>> the parent adapter would be the first direct decedent of the mdio, the
>> switch itself could then be represented with another device, with a
>> further string of device/phys representing the devices. (I dislike
>> drawing acsii art, but if this isn't clear I will, its also worthwhile
>> to look at the dpaa2 docs for how the mac/phys work on this device for
>> contrast.).
> 
> The eth0->mdio->phy relationship you describe is the simple case that
> you are well aware of which is say what we have on the Raspberry Pi 4
> with GENET and the external Broadcom PHY.
> 
> For an Ethernet switch connected to an Ethernet MAC, we have 4 different
> types of objects:
> 
> - the Ethernet MAC which sits on its specific bus
> 
> - the Ethernet switch which also sits on its specific bus
> 
> - the built-in PHYs of the Ethernet switch which sit on whatever
> bus/interface the switch provides to make them accessible
> 
> - the specific bus controller that provides access to the Ethernet switch
> 
> and this is a simplification that does not take into account Physical
> Coding Sublayer devices, pure MDIO devices (with no foot in the Ethernet
> land such as PCIe, USB3 or SATA PHYs), SFP, SFF and other pluggable modules.

Which is why I've stayed away from much of the switch discussion. There 
are a lot of edge cases to fall into, because for whatever reason 
networking seems to be unique in all this non-enumerable customization 
vs many other areas of the system. Storage, being an example i'm more 
familiar with which has very similar problems yet, somehow has managed 
to avoid much of this, despite having run on fabrics significantly more 
complex than basic ethernet (including running on a wide range of hot 
pluggable GBIC/SFP/QSFP/etc media layers).

ACPI's "problem" here is that its strongly influenced by the "Plug and 
Play" revolution of the 1990's where the industry went from having 
humans describing hardware using machine readable languages, to hardware 
which was enumerable using standard protocols. ACPI's device 
descriptions are there as a crutch for the remaining non plug an play 
hardware in the system.

So at a basic level, if your describing hardware in ACPI rather than 
abstracting it, that is a problem.



Thanks,
