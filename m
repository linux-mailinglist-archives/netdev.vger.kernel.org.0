Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC192162618
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 13:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgBRM0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 07:26:18 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10638 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbgBRM0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 07:26:18 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D4EEA935B4138836A188;
        Tue, 18 Feb 2020 20:25:07 +0800 (CST)
Received: from [127.0.0.1] (10.177.223.23) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 18 Feb 2020
 20:24:58 +0800
Subject: Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
To:     "Pankaj Bansal (OSS)" <pankaj.bansal@oss.nxp.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC:     Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "nleeder@codeaurora.org" <nleeder@codeaurora.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        "Will Deacon" <will@kernel.org>,
        "jon@solid-run.com" <jon@solid-run.com>,
        "Russell King" <linux@armlinux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andy Wang <Andy.Wang@arm.com>, Varun Sethi <V.Sethi@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Paul Yang <Paul.Yang@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <VI1PR04MB5135D7D8597D33DB76DA05BDB0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
From:   Hanjun Guo <guohanjun@huawei.com>
Message-ID: <615c6807-c018-92c9-b66a-8afdda183699@huawei.com>
Date:   Tue, 18 Feb 2020 20:24:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
MIME-Version: 1.0
In-Reply-To: <VI1PR04MB5135D7D8597D33DB76DA05BDB0110@VI1PR04MB5135.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.223.23]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pankaj,

On 2020/2/18 16:00, Pankaj Bansal (OSS) wrote:
[...]
>>>> Side note: would you mind removing the email headers (as above) in your
>>>> replies please ?
>>
>> Read the question above please.
>>
>> [...]
>>
>>>>> As stated above, in Linux MC is a bus (just like PCI bus, AMBA bus etc)
>>>>> There can be multiple devices attached to this bus. Moreover, we can
>>>> dynamically create/destroy these devices.
>>>>> Now, we want to represent this BUS (not individual devices connected to
>> bus)
>>>> in IORT table.
>>>>> The only possible way right now we see is that we describe it as Named
>>>> components having a pool of ID mappings.
>>>>> As and when devices are created and attached to bus, we sift through this
>> pool
>>>> to correctly determine the output ID for the device.
>>>>> Now the input ID that we provide, can come from device itself.
>>>>> Then we can use the Platform MSI framework for MC bus devices.
>>>>
>>>> So are you asking me if that's OK ? Or there is something you can't
>>>> describe with IORT ?
>>>
>>> I am asking if that would be acceptable?
>>> i.e. we represent MC bus as Named component is IORT table with a pool of IDs
>> (without single ID mapping flag)
>>> and then we use the Platform MSI framework for all children devices of MC
>> bus.
>>> Note that it would require the Platform MSI layer to correctly pass an input id
>> for a platform device to IORT layer.
>>
>> How is this solved in DT ? You don't seem to need any DT binding on top
>> of the msi-parent property, which is equivalent to IORT single mappings
>> AFAICS so I would like to understand the whole DT flow (so that I
>> understand how this FSL bus works) before commenting any further.
> 
> In DT case, we create the domain DOMAIN_BUS_FSL_MC_MSI for MC bus and it's children.
> And then when MC child device is created, we search the "msi-parent" property from the MC
> DT node and get the ITS associated with MC bus. Then we search DOMAIN_BUS_FSL_MC_MSI
> on that ITS. Once we find the domain, we can call msi_domain_alloc_irqs for that domain.
> 
> This is exactly what we tried to do initially with ACPI. But the searching DOMAIN_BUS_FSL_MC_MSI
> associated to an ITS, is something that is part of drivers/acpi/arm64/iort.c.
> (similar to DOMAIN_BUS_PLATFORM_MSI and DOMAIN_BUS_PCI_MSI)

Can you have a look at mbigen driver (drivers/irqchip/irq-mbigen.c) to see if
it helps you?

mbigen is an irq converter to convert device's wired interrupts into MSI
(connecting to ITS), which will alloc a bunch of MSIs from ITS platform MSI
domain at the setup.

Thanks
Hanjun

