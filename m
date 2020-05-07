Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC20D1C9B67
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 21:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgEGTyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 15:54:12 -0400
Received: from foss.arm.com ([217.140.110.172]:38360 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgEGTyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 15:54:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E7961FB;
        Thu,  7 May 2020 12:54:11 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D60F83F68F;
        Thu,  7 May 2020 12:54:09 -0700 (PDT)
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
 <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
 <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
Date:   Thu, 7 May 2020 14:54:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/7/20 12:27 PM, Andy Shevchenko wrote:
> On Thu, May 7, 2020 at 4:26 PM Jeremy Linton <jeremy.linton@arm.com> wrote:
>> On 5/5/20 8:29 AM, Calvin Johnson wrote:
> 
>>> +             if (sscanf(cp, "ethernet-phy-id%4x.%4x",
>>> +                        &upper, &lower) == 2) {
>>> +                     *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
>>> +                     return 0;
>>> +             }
> 
>> Isn't the ACPI _CID() conceptually similar to the DT compatible
>> property?
> 
> Where?

Not, sure I understand exactly what your asking. AFAIK, in general the 
dt property is used to select a device driver/etc based on a more to 
less compatible set of substrings. The phy case is a bit different 
because it codes a numerical part number into the string rather than 
just using arbitrary strings to select a driver and device. But it uses 
that as a vendor selector for binding to the correct driver/device.

Rephrasing the ACPI spec, the _CID() is either a single compatible id, 
or a list of ids in order of preference. Each id is either a HID (string 
or EISA type id) or a bus specific string encoding vendor/device/etc. 
(https://elixir.bootlin.com/linux/v5.7-rc4/source/drivers/acpi/acpica/utids.c#L186). 
One of the examples is "PCI\VEN_vvvv&DEV_dddd"

So that latter case seems to be almost exactly what we have here.

> 
>> It even appears to be getting used in a similar way to
>> identify particular phy drivers in this case.
> 
> _CID() is a string. It can't be used as pure number.
> 

It does have a numeric version defined for EISA types. OTOH I suspect 
that your right. If there were a "PHY\VEN_IDvvvv&ID_DDDD" definition, it 
may not be ideal to parse it. Instead the normal ACPI model of exactly 
matching the complete string in the phy driver might be more appropriate.

Similarly to how I suspect the next patch's use of "compatible" isn't 
ideal either, because whether a device is c45 or not, should tend to be 
fixed to a particular vendor/device implementation and not a firmware 
provided property.
