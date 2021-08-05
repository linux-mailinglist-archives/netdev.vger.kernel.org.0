Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952903E108E
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 10:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239643AbhHEItU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 04:49:20 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7931 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238304AbhHEItU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 04:49:20 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GgMcm2VWtz84Cq;
        Thu,  5 Aug 2021 16:45:12 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 5 Aug 2021 16:49:04 +0800
Subject: Re: [PATCH V7 9/9] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
To:     Logan Gunthorpe <logang@deltatee.com>, <helgaas@kernel.org>,
        <hch@infradead.org>, <kw@linux.com>, <leon@kernel.org>,
        <linux-pci@vger.kernel.org>, <rajur@chelsio.com>,
        <hverkuil-cisco@xs4all.nl>
References: <1628084828-119542-1-git-send-email-liudongdong3@huawei.com>
 <1628084828-119542-10-git-send-email-liudongdong3@huawei.com>
 <640662ff-e464-2cb5-318b-aa75d1ece1eb@deltatee.com>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <1489da74-04b8-e208-40fa-7f97bb796288@huawei.com>
Date:   Thu, 5 Aug 2021 16:49:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <640662ff-e464-2cb5-318b-aa75d1ece1eb@deltatee.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Logan

Many thanks for your review.
On 2021/8/4 23:56, Logan Gunthorpe wrote:
>
>
> On 2021-08-04 7:47 a.m., Dongdong Liu wrote:
>> Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
>> 10-Bit Tag Requester doesn't interact with a device that does not
>> support 10-BIT Tag Completer. Before that happens, the kernel should
>> emit a warning. "echo 0 > /sys/bus/pci/devices/.../10bit_tag" to
>> disable 10-BIT Tag Requester for PF device.
>> "echo 0 > /sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl" to disable
>> 10-BIT Tag Requester for VF device.
>>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> ---
>>  drivers/pci/p2pdma.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 40 insertions(+)
>>
>> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
>> index 50cdde3..948f2be 100644
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
>> @@ -410,6 +411,41 @@ static unsigned long map_types_idx(struct pci_dev *client)
>>  		(client->bus->number << 8) | client->devfn;
>>  }
>>
>> +static bool check_10bit_tags_vaild(struct pci_dev *a, struct pci_dev *b,
>> +				   bool verbose)
>> +{
>> +	bool req;
>> +	bool comp;
>> +	u16 ctl2;
>> +
>> +	if (a->is_virtfn) {
>> +#ifdef CONFIG_PCI_IOV
>> +		req = !!(a->physfn->sriov->ctrl &
>> +			 PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN);
>> +#endif
>> +	} else {
>> +		pcie_capability_read_word(a, PCI_EXP_DEVCTL2, &ctl2);
>> +		req = !!(ctl2 & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
>> +	}
>> +
>> +	comp = !!(b->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP);
>> +	if (req && (!comp)) {
>
> I think the brackets around !comp are unnecessary.
Yes, will fix.
>
>> +		if (verbose) {
>> +			pci_warn(a, "cannot be used for peer-to-peer DMA as 10-Bit Tag Requester enable is set in device (%s), but peer device (%s) does not support the 10-Bit Tag Completer\n",
>> +				 pci_name(a), pci_name(b));
>> +			if (a->is_virtfn)
>> +				pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/sriov_vf_10bit_tag_ctl\n",
>> +					 pci_name(a));
>> +			else
>> +				pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/10bit_tag\n",
>> +					 pci_name(a));
>
> Can we not simplify this slightly by having a const char * set to the
> tag in the above if (a->is_virtfn)?
>
> pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 >
> /sys/bus/pci/devices/%s/%s\n", pci_name(a), tag);
Good point, will fix.

Thanks,
Dongdong
>
>> +		}
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>  /*
>>   * Calculate the P2PDMA mapping type and distance between two PCI devices.
>>   *
>> @@ -532,6 +568,10 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>>  		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>>  	}
>>  done:
>> +	if (!check_10bit_tags_vaild(client, provider, verbose) ||
>> +	    !check_10bit_tags_vaild(provider, client, verbose))
>> +		map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
>> +
>>  	rcu_read_lock();
>>  	p2pdma = rcu_dereference(provider->p2pdma);
>>  	if (p2pdma)
>>
> .
>
