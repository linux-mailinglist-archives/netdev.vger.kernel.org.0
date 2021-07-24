Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700253D472F
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 12:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbhGXJzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 05:55:40 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15066 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235253AbhGXJzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 05:55:39 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GX2ZM2ZkrzZrsp;
        Sat, 24 Jul 2021 18:32:43 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 24 Jul 2021 18:36:08 +0800
Subject: Re: [PATCH V6 8/8] PCI/P2PDMA: Add a 10-bit tag check in P2PDMA
To:     Logan Gunthorpe <logang@deltatee.com>, <helgaas@kernel.org>,
        <hch@infradead.org>, <kw@linux.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>
References: <1627038402-114183-1-git-send-email-liudongdong3@huawei.com>
 <1627038402-114183-9-git-send-email-liudongdong3@huawei.com>
 <24bc5deb-1fa3-8e81-2d9d-18836dc3aec9@deltatee.com>
CC:     <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <5d05dcaa-db5c-3cb0-e2a7-6ac87786dbd2@huawei.com>
Date:   Sat, 24 Jul 2021 18:36:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <24bc5deb-1fa3-8e81-2d9d-18836dc3aec9@deltatee.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Logan
Many thanks for your review.
On 2021/7/24 0:25, Logan Gunthorpe wrote:
>
>
>
> On 2021-07-23 5:06 a.m., Dongdong Liu wrote:
>> Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
>> 10-Bit Tag Requester doesn't interact with a device that does not
>> support 10-BIT tag Completer. Before that happens, the kernel should
>> emit a warning saying to enable a ”pci=disable_10bit_tag=“ kernel
>> parameter.
>>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> ---
>>  drivers/pci/p2pdma.c | 38 ++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 38 insertions(+)
>>
>> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
>> index 50cdde3..bd93840 100644
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
>> @@ -541,6 +542,39 @@ calc_map_type_and_dist(struct pci_dev *provider, struct pci_dev *client,
>>  	return map_type;
>>  }
>>
>> +
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
>> +		if (verbose) {
>> +			pci_warn(a, "cannot be used for peer-to-peer DMA as 10-Bit Tag Requester enable is set in device (%s), but peer device (%s) does not support the 10-Bit Tag Completer\n",
>> +				 pci_name(a), pci_name(b));
>> +
>> +			pci_warn(a, "to disable 10-Bit Tag Requester for this device, add the kernel parameter: pci=disable_10bit_tag=%s\n",
>> +				 pci_name(a));
>> +		}
>> +		return false;
>> +	}
>> +
>> +	return true;
>> +}
>> +
>>  /**
>>   * pci_p2pdma_distance_many - Determine the cumulative distance between
>>   *	a p2pdma provider and the clients in use.
>> @@ -579,6 +613,10 @@ int pci_p2pdma_distance_many(struct pci_dev *provider, struct device **clients,
>>  			return -1;
>>  		}
>>
>> +		if (!check_10bit_tags_vaild(pci_client, provider, verbose) ||
>> +		    !check_10bit_tags_vaild(provider, pci_client, verbose))
>> +			not_supported = true;
>> +
>
> This check needs to be done in calc_map_type_and_dist(). The mapping
> type needs to be correctly stored in the xarray cache as other functions
> rely on the cached value (and upcoming work will be calling
> calc_map_type_and_dist() without pci_p2pdma_distance_many()).
>
Will fix.

Thanks,
Dongdong
> Logan
> .
>
