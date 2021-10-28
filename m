Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF9343DC50
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhJ1Hrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:47:40 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:26131 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbhJ1Hrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:47:40 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HfyGT38BCz1DHgZ;
        Thu, 28 Oct 2021 15:43:13 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Thu, 28 Oct 2021 15:45:09 +0800
Subject: Re: [PATCH V10 4/8] PCI/sysfs: Add a 10-Bit Tag sysfs file PCIe
 Endpoint devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20211027222839.GA252933@bhelgaas>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <29edb35a-4c46-8b5d-26e5-debf6b3a72bc@huawei.com>
Date:   Thu, 28 Oct 2021 15:44:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20211027222839.GA252933@bhelgaas>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn

Many thanks for your review.
On 2021/10/28 6:28, Bjorn Helgaas wrote:
> On Sat, Oct 09, 2021 at 06:49:34PM +0800, Dongdong Liu wrote:
>> PCIe spec 5.0 r1.0 section 2.2.6.2 says:
>>
>>   If an Endpoint supports sending Requests to other Endpoints (as
>>   opposed to host memory), the Endpoint must not send 10-Bit Tag
>>   Requests to another given Endpoint unless an implementation-specific
>>   mechanism determines that the Endpoint supports 10-Bit Tag Completer
>>   capability.
>>
>> Add a 10bit_tag sysfs file, write 0 to disable 10-Bit Tag Requester
>> when the driver does not bind the device. The typical use case is for
>> p2pdma when the peer device does not support 10-Bit Tag Completer.
>> Write 1 to enable 10-Bit Tag Requester when RC supports 10-Bit Tag
>> Completer capability. The typical use case is for host memory targeted
>> by DMA Requests. The 10bit_tag file content indicate current status of
>> 10-Bit Tag Requester Enable.
>
> Don't we have a hole here?  We're adding knobs to control 10-Bit Tag
> usage, but don't we have basically the same issues with Extended
> (8-bit) Tags?

All PCIe completers are required to support 8-bit tags
from the "[PATCH] PCI: enable extended tags support for PCIe endpoints"
(https://patchwork.kernel.org/project/linux-arm-msm/patch/1474769434-5756-1-git-send-email-okaya@codeaurora.org/).

I ask hardware colleagues, also says all PCIe devices should support
8-bit tags completer default, so seems no need to do this for 8-bit tags.
>
> I wonder if we should be adding a more general "tags" file that can
> manage both 8-bit and 10-bit tag usage.
>
>> +static struct device_attribute dev_attr_10bit_tag = __ATTR(10bit_tag, 0644,
>> +							   pci_10bit_tag_show,
>> +							   pci_10bit_tag_store);
>
> I think this should use DEVICE_ATTR().
Yes, will do.

Thanks,
Dongdong
> Or even better, if the name doesn't start with a digit, DEVICE_ATTR_RW().
> .
>
