Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98EC3E33FF
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 09:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhHGHqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 03:46:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:16058 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhHGHqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 03:46:48 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GhZ7w3HQ3zZy8r;
        Sat,  7 Aug 2021 15:42:52 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 7 Aug 2021 15:46:28 +0800
Subject: Re: [PATCH V7 5/9] PCI/IOV: Enable 10-Bit tag support for PCIe VF
 devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210806225917.GA1897594@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <8f261291-ced7-45dd-cb8b-429bcdd512d1@huawei.com>
Date:   Sat, 7 Aug 2021 15:46:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210806225917.GA1897594@bjorn-Precision-5520>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/7 6:59, Bjorn Helgaas wrote:
> On Thu, Aug 05, 2021 at 04:03:58PM +0800, Dongdong Liu wrote:
>>
>> On 2021/8/5 7:29, Bjorn Helgaas wrote:
>>> On Wed, Aug 04, 2021 at 09:47:04PM +0800, Dongdong Liu wrote:
>>>> Enable VF 10-Bit Tag Requester when it's upstream component support
>>>> 10-bit Tag Completer.
>>>
>>> I think "upstream component" here means the PF, doesn't it?  I don't
>>> think the PF is really an *upstream* component; there's no routing
>>> like with a switch.
>>
>> I want to say the switch and root port devices that support 10-Bit
>> Tag Completer. Sure, VF also needs to have 10-bit Tag Requester
>> Supported capability.
>
> OK.  IIUC we're not talking about P2PDMA here; we're talking about
> regular DMA to host memory, which means I *think* only the Root Port
> is important, since it is the completer for DMA to host memory.  We're
> not talking about P2PDMA to a switch BAR, where the switch would be
> the completer.

Yes, only the Root Port is important, this is also PCIe spec
recommended.

Only when switch detects an error with an NPR carrying a 10-Bit Tag,
and that Switch handles the error by acting as the Completer for the
NPR, the resulting Completion will have an invalid 10-Bit Tag.

Enable 10-bit for EP devices depend on the hierarchy(include switch)
supports 10-bit tags in "[PATCH V7 4/9] PCI: Enable 10-Bit Tag support
for PCIe Endpoint devices". This seems complex.
I will fix this. Enable 10-bit tag for EP devices only depend on Root
Port 10-bit tag completer about regular DMA to host memory.

The below is the PCIe spec describe:
PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
10-Bit Tag Capabilities" Implementation Note.

   For platforms where the RC supports 10-Bit Tag Completer capability,
   it is highly recommended for platform firmware or operating software
   that configures PCIe hierarchies to Set the 10-Bit Tag Requester
   Enable bit automatically in Endpoints with 10-Bit Tag Requester
   capability. This enables the important class of 10-Bit Tag capable
   adapters that send Memory Read Requests only to host memory.

...
   Switches that lack 10-Bit Tag Completer capability are still able to
   forward NPRs and Completions carrying 10-Bit Tags correctly, since the
   two new Tag bits are in TLP Header bits that were formerly Reserved,
   and Switches are required to forward Reserved TLP Header bits without
   modification. However, if such a Switch detects an error with an NPR
   carrying a 10-Bit Tag, and that Switch handles the error by acting as
   the Completer for the NPR, the resulting Completion will have an
   invalid 10-Bit Tag. Thus, it is strongly recommended that Switches
   between any components using 10-Bit Tags support 10-Bit Tag Completer
   capability.  Note that Switches supporting 16.0 GT/s data rates or
   greater must support 10-Bit Tag Completer capability.

Thanks,
Dongdong

> .
>
