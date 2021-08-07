Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CBE3E33E3
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 09:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhHGHL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 03:11:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7805 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhHGHLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 03:11:55 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GhYRd1sF5zYdSk;
        Sat,  7 Aug 2021 15:11:25 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 7 Aug 2021 15:11:34 +0800
Subject: Re: [PATCH V7 9/9] PCI/P2PDMA: Add a 10-Bit Tag check in P2PDMA
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210805181233.GA1765293@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <11f98331-cc39-ee37-85f7-185fdd1ccea5@huawei.com>
Date:   Sat, 7 Aug 2021 15:11:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210805181233.GA1765293@bjorn-Precision-5520>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/8/6 2:12, Bjorn Helgaas wrote:
> On Wed, Aug 04, 2021 at 09:47:08PM +0800, Dongdong Liu wrote:
>> Add a 10-Bit Tag check in the P2PDMA code to ensure that a device with
>> 10-Bit Tag Requester doesn't interact with a device that does not
>> support 10-BIT Tag Completer. Before that happens, the kernel should
>> emit a warning. "echo 0 > /sys/bus/pci/devices/.../10bit_tag" to
>> disable 10-BIT Tag Requester for PF device.
>> "echo 0 > /sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl" to disable
>> 10-BIT Tag Requester for VF device.
>
> s/10-BIT/10-Bit/ several times.
Will fix.
>
> Add blank lines between paragraphs.
Will fix.
>
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
>
> s/vaild/valid/
>
> Or maybe s/valid/safe/ or s/valid/supported/, since "valid" isn't
> quite the right word here.  We want to know whether the source is
> enabled to generate 10-bit tags, and if so, whether the destination
> can handle them.
>
> "if (check_10bit_tags_valid())" does not make sense because
> "check_10bit_tags_valid()" is not a question with a yes/no answer.
>
> "10bit_tags_valid()" *might* be, because "if (10bit_tags_valid())"
> makes sense.  But I don't think you can start with a digit.
>
> Or maybe you want to invert the sense, e.g.,
> "10bit_tags_unsupported()", since that avoids negation at the caller:
>
>   if (10bit_tags_unsupported(a, b) ||
>       10bit_tags_unsupported(b, a))
>         map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;
Good suggestion. add a pci_ prefix.

if (pci_10bit_tags_unsupported(a, b) ||
     pci_10bit_tags_unsupported(b, a))
	map_type = PCI_P2PDMA_MAP_NOT_SUPPORTED;

> Doesn't this patch need to be at the very beginning, before you start
> enabling 10-bit tags?  Otherwise there's a hole in the middle where we
> enable them and P2P DMA might break.
Yes, will do.
>
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
>
> No point in printing pci_name(a) twice.  pci_warn() prints it already;
> that should be enough.
Will fix.
>
> I think you can simplify this a little, e.g.,
>
>   if (!req)           /* 10-bit tags not enabled on requester */
>     return true;
>
>   if (comp)           /* completer can handle anything */
>     return true;
>
>   /* error case */
>   if (!verbose)
>     return false;
>
>   pci_warn(...);
>   return false;

Good point, this will make code more clean and readable.

Thanks,
Dongdong
>
>> +			if (a->is_virtfn)
>> +				pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/sriov_vf_10bit_tag_ctl\n",
>> +					 pci_name(a));
>> +			else
>> +				pci_warn(a, "to disable 10-Bit Tag Requester for this device, echo 0 > /sys/bus/pci/devices/%s/10bit_tag\n",
>> +					 pci_name(a));
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
>> --
>> 2.7.4
>>
> .
>
