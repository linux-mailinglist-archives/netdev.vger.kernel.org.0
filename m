Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED043CBA1D
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240696AbhGPPyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:54:33 -0400
Received: from ale.deltatee.com ([204.191.154.188]:56566 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbhGPPyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 11:54:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=CDFVzQSWuNRMGCf8MH35qzWG3e/KgXu0vrM/hkxVtvs=; b=mLkS+CIUjmZtZIofu2VtxU+2zv
        ESag6YCC3FQVhKXtDCa1jV1netTgdUXUztVPPGChwTIcVS4TUveJ9HYi1gbYq6ySndWzDbxjYynN2
        Q+0fhGAbK/oCC+7TAtGGoBVzxEL9mdK5/aGjYYSgqSRE9StHKg+z45evhQU3zEXNh9wgoBwDgt8mQ
        mP5nB0+PJArEGN2QHzIzyD6UeLf8CSW1Vol3eQkbFSjH6HKtqQkH7fMe3Vxe9iw2oaQw+hEKZPfvC
        yjJ4t1HF61CNTFOpopiux/NmmEIdno6P4nmXqd/lkJqgMKjpZs9iD8rOksQyuaLiTtn2Ll+/aeIbF
        rgmEMIBw==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtp (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1m4Q7f-0003BA-7d; Fri, 16 Jul 2021 09:51:32 -0600
To:     Dongdong Liu <liudongdong3@huawei.com>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     hch@infradead.org, kw@linux.com, linux-pci@vger.kernel.org,
        rajur@chelsio.com, hverkuil-cisco@xs4all.nl,
        linux-media@vger.kernel.org, netdev@vger.kernel.org
References: <20210715172336.GA1972959@bjorn-Precision-5520>
 <db506d81-3cb9-4cdc-fb4a-f2d28587b9b2@huawei.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <dcad182a-fafc-39ad-b1f2-8ed86f3634d9@deltatee.com>
Date:   Fri, 16 Jul 2021 09:51:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <db506d81-3cb9-4cdc-fb4a-f2d28587b9b2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, linux-media@vger.kernel.org, hverkuil-cisco@xs4all.nl, rajur@chelsio.com, linux-pci@vger.kernel.org, kw@linux.com, hch@infradead.org, helgaas@kernel.org, liudongdong3@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH V5 4/6] PCI: Enable 10-Bit tag support for PCIe Endpoint
 devices
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-16 5:12 a.m., Dongdong Liu wrote:
> Hi Bjorn
> 
> Many thanks for your review.
> 
> On 2021/7/16 1:23, Bjorn Helgaas wrote:
>> [+cc Logan]
>>
>> On Mon, Jun 21, 2021 at 06:27:20PM +0800, Dongdong Liu wrote:
>>> 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
>>> field size from 8 bits to 10 bits.
>>>
>>> For platforms where the RC supports 10-Bit Tag Completer capability,
>>> it is highly recommended for platform firmware or operating software
>>
>> Recommended by whom?  If the spec recommends it, we should provide the
>> citation.
> PCIe spec 5.0 r1.0 section 2.2.6.2 IMPLEMENTATION NOTE says that.
> Will fix.
>>
>>> that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
>>> bit automatically in Endpoints with 10-Bit Tag Requester capability. This
>>> enables the important class of 10-Bit Tag capable adapters that send
>>> Memory Read Requests only to host memory.
>>
>> What is the implication for P2PDMA?  What happens if we enable 10-bit
>> tags for device A, and A generates Mem Read Requests to device B,
>> which does not support 10-bit tags?
> PCIe spec 5.0 r1.0 section 2.2.6.2 says
> If an Endpoint supports sending Requests to other Endpoints (as opposed 
> to host memory), the Endpoint must not send 10-Bit Tag Requests to 
> another given Endpoint unless an implementation-specific mechanism 
> determines that the Endpoint supports 10-Bit Tag Completer capability. 
> Not sending 10-Bit Tag Requests to other Endpoints at all
> may be acceptable for some implementations. More sophisticated 
> mechanisms are outside the scope of this specification.
> 
> Not sending 10-Bit Tag Requests to other Endpoints at all seems simple.
> Add kernel parameter pci=pcie_bus_peer2peer when boot kernel with 
> P2PDMA, then do not config 10-BIT Tag.
> 
> if (pcie_bus_config != PCIE_BUS_PEER2PEER)
> 	pci_configure_10bit_tags(dev);
> 
> Bjorn and Logan, any suggestion?

I think we need a check in the P2PDMA code to ensure that a device with
10bit tags doesn't interact with a device that has no 10bit tags. Before
that happens, the kernel should emit a warning saying to enable a
specific kernel parameter.

Though a parameter with a bit more granularity might be appropriate. See
what was done for disable_acs_redir where it affects only the devices
specified in the list.

Thanks,

Logan
