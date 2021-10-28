Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA1D43DC89
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhJ1H7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:59:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:25321 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJ1H7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:59:14 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HfySj5lDbzbhNc;
        Thu, 28 Oct 2021 15:52:05 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Thu, 28 Oct 2021 15:56:45 +0800
Subject: Re: [PATCH V10 6/8] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20211027212048.GA252528@bhelgaas>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <5773efae-8fb6-bd63-0486-dfcd14d3c8ae@huawei.com>
Date:   Thu, 28 Oct 2021 15:56:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20211027212048.GA252528@bhelgaas>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/28 5:20, Bjorn Helgaas wrote:
> On Sat, Oct 09, 2021 at 06:49:36PM +0800, Dongdong Liu wrote:
>> Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
>> 10-Bit Tag Requester doesn't interact with a device that does not
>> support 10-Bit Tag Completer.
>
> Shouldn't this also take into account Extended Tags (8 bits)?  I think
> the only tag size guaranteed to be supported is 5 bits.
As all PCIe completers are required to support 8-bit tags, seems no need
to take into account Extended Tags.
>
>> Before that happens, the kernel should emit a warning.
>
> The warning is nice, but the critical thing is that the P2PDMA mapping
> should fail so we don't attempt DMA in this situation.  I guess that's
> sort of what you're saying with "ensure that a device ... doesn't
> interact with a device ..."
Yes, that is.
>
>> "echo 0 > /sys/bus/pci/devices/.../10bit_tag" to disable 10-Bit Tag
>> Requester for PF device.
>>
>> "echo 0 > /sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl" to disable
>> 10-Bit Tag Requester for VF device.
>>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
>> ---
>>  drivers/pci/p2pdma.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 48 insertions(+)
>>
>> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
>> index 50cdde3e9a8b..804e390f4c22 100644
>> --- a/drivers/pci/p2pdma.c
>> +++ b/drivers/pci/p2pdma.c
>> @@ -19,6 +19,7 @@
>>  #include <linux/random.h>
>>  #include <linux/seq_buf.h>
>>  #include <linux/xarray.h>
>> +#include "pci.h"
>>
>>  enum pci_p2pdma_map_type {
>>  	PCI_P2PDMA_MAP_UNKNOWN = 0,
>> @@ -410,6 +411,50 @@ static unsigned long map_types_idx(struct pci_dev *client)
>>  		(client->bus->number << 8) | client->devfn;
>>  }
>>
>> +static bool pci_10bit_tags_unsupported(struct pci_dev *a,
>> +				       struct pci_dev *b,
>> +				       bool verbose)
>> +{
>> +	bool req;
>> +	bool comp;
>> +	u16 ctl;
>> +	const char *str = "10bit_tag";
>> +
>> +	if (a->is_virtfn) {
>> +#ifdef CONFIG_PCI_IOV
>> +		req = !!(a->physfn->sriov->ctrl &
>> +			 PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN);
>> +#endif
>> +	} else {
>> +		pcie_capability_read_word(a, PCI_EXP_DEVCTL2, &ctl);
>> +		req = !!(ctl & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
>> +	}
>> +
>> +	comp = !!(b->devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP);
>> +	/* 10-bit tags not enabled on requester */
>> +	if (!req)
>> +		return false;
>> +
>> +	 /* Completer can handle anything */
>> +	if (comp)
>> +		return false;
>> +
>> +	if (!verbose)
>> +		return true;
>> +
>> +	pci_warn(a, "cannot be used for peer-to-peer DMA as 10-Bit Tag Requester enable is set for this device, but peer device (%s) does not support the 10-Bit Tag Completer\n",
>> +		 pci_name(b));
>> +
>> +	if (a->is_virtfn)
>> +		str = "sriov_vf_10bit_tag_ctl";
>> +
>> +	pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/%s\n",
>> +		 pci_name(a), str);
>> +
>> +	return true;
>> +}
>> +
>>  /*
>>   * Calculate the P2PDMA mapping type and distance between two PCI devices.
>>   *
>> @@ -532,6 +577,9 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>>  		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>>  	}
>>  done:
>> +	if (pci_10bit_tags_unsupported(client, provider, verbose))
>> +		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>> +
>>  	rcu_read_lock();
>>  	p2pdma = rcu_dereference(provider->p2pdma);
>>  	if (p2pdma)
>> --
>> 2.22.0
>>
> .
>
