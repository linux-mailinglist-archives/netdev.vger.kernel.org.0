Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19BB15E374
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393402AbgBNQ35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:29:57 -0500
Received: from foss.arm.com ([217.140.110.172]:38500 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393432AbgBNQ34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:29:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACE4C328;
        Fri, 14 Feb 2020 08:29:55 -0800 (PST)
Received: from [10.1.196.37] (e121345-lin.cambridge.arm.com [10.1.196.37])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95FC63F68E;
        Fri, 14 Feb 2020 08:29:45 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
To:     Pankaj Bansal <pankaj.bansal@nxp.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@nxp.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "nleeder@codeaurora.org" <nleeder@codeaurora.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Will Deacon <will@kernel.org>,
        "jon@solid-run.com" <jon@solid-run.com>,
        Russell King <linux@armlinux.org.uk>,
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
        Sudeep Holla <sudeep.holla@arm.com>
References: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
 <20200128110916.GA491@e121166-lin.cambridge.arm.com>
 <DB8PR04MB7164DDF48480956F05886DABEB070@DB8PR04MB7164.eurprd04.prod.outlook.com>
 <12531d6c569c7e14dffe8e288d9f4a0b@kernel.org>
 <CAKv+Gu8uaJBmy5wDgk=uzcmC4vkEyOjW=JRvhpjfsdh-HcOCLg@mail.gmail.com>
 <VI1PR0401MB249622CFA9B213632F1DE955F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
 <7349fa0e6d62a3e0d0e540f2e17646e0@kernel.org>
 <VI1PR0401MB2496373E0C6D1097F22B3026F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <7e1ab651-1eb5-b461-1d21-6fd5c8f3ade8@arm.com>
Date:   Fri, 14 Feb 2020 16:29:40 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0401MB2496373E0C6D1097F22B3026F1150@VI1PR0401MB2496.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2020 3:58 pm, Pankaj Bansal wrote:
[...]
>> I don't understand what you mean. Platform MSI using IORT uses the DevID of
>> end-points. How could the ITS could work without specifying a DevID?
>> See for example how the SMMUv3 driver uses platform MSI.
> 
> DevID is input ID for PCIe devices. BUT what would be the input ID for platform device? Are we saying that Platform devices can't specify an Input ID ?

No, from the IORT perspective, the input for the ID mappings belonging 
to a root complex is the PCI requester ID. The (ITS) DevID is the 
ultimate *output* of a root complex mapping.

Whilst you can indeed represent the MC as a black-box Named Component 
with an ID mapping range not using the "single mapping" flag, that means 
your input IDs come from some device-specific domain beyond the scope of 
IORT. That's why you can't easily get away from your special bus 
integration code.

>>> While, IORT spec doesn't specify any such limitation.
>>>
>>> we can easily update iort.c to remove this limitation.
>>> But, I am not sure how the input id would be passed from platform MSI
>>> GIC layer to IORT.
>>> Most obviously, the input id should be supplied by dev itself.
>>
>> Why should the device know about its own ID? That's a bus/interconnect thing.
>> And nothing should be passed *to* IORT. IORT is the source.
> 
> IORT is translation between Input IDs <-> Output IDs. The Input ID is still expected to be passed to parse IORT table.

...except for single mappings, where the input ID is ignored and the 
output ID is the "source", which is exactly what iort_node_get_id() 
deals with for devices represented in IORT. With what you're talking 
about, "the device" is *not* represented in IORT, but is something 
beyond the MC 'bridge'. Now it probably is technically possible to 
handle that somehow, but it's definitely not something that the existing 
code was ever designed to anticipate.

Robin.
