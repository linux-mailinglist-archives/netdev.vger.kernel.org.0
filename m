Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D88C3A74A4
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 05:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhFODKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 23:10:14 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:10065 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhFODKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 23:10:13 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G3tTz5sJczZdcP;
        Tue, 15 Jun 2021 11:05:11 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 11:08:05 +0800
Subject: Re: [RESEND PATCH V3 6/6] PCI: Enable 10-Bit tag support for PCIe RP
 devices
To:     Christoph Hellwig <hch@infradead.org>
References: <1623576555-40338-1-git-send-email-liudongdong3@huawei.com>
 <1623576555-40338-7-git-send-email-liudongdong3@huawei.com>
 <YMbv0FVV9J53M0L7@infradead.org>
CC:     <helgaas@kernel.org>, <kw@linux.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <c2311d23-e4f3-0ec7-4eb0-aa5735b7e9de@huawei.com>
Date:   Tue, 15 Jun 2021 11:08:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YMbv0FVV9J53M0L7@infradead.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/14 13:57, Christoph Hellwig wrote:
> On Sun, Jun 13, 2021 at 05:29:15PM +0800, Dongdong Liu wrote:
>> PCIe spec 5.0r1.0 section 2.2.6.2 implementation note, In configurations
>> where a Requester with 10-Bit Tag Requester capability needs to target
>> multiple Completers, one needs to ensure that the Requester sends 10-Bit
>> Tag Requests only to Completers that have 10-Bit Tag Completer capability.
>> So we enable 10-Bit Tag Requester for root port only when the devices
>> under the root port support 10-Bit Tag Completer.
>>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> ---
>>  drivers/pci/pcie/portdrv_pci.c | 75 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 75 insertions(+)
>>
>> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
>> index c7ff1ee..baf413f 100644
>> --- a/drivers/pci/pcie/portdrv_pci.c
>> +++ b/drivers/pci/pcie/portdrv_pci.c
>> @@ -90,6 +90,78 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
>>  #define PCIE_PORTDRV_PM_OPS	NULL
>>  #endif /* !PM */
>>
>> +static int pci_10bit_tag_comp_support(struct pci_dev *dev, void *data)
>> +{
>> +	u8 *support = data;
>> +
>> +	if (*support == 0)
>> +		return 0;
>> +
>> +	if (!pci_is_pcie(dev)) {
>> +		*support = 0;
>> +		return 0;
>> +	}
>> +
>> +	/*
>> +	 * PCIe spec 5.0r1.0 section 2.2.6.2 implementation note.
>> +	 * For configurations where a Requester with 10-Bit Tag Requester
>> +	 * capability targets Completers where some do and some do not have
>> +	 * 10-Bit Tag Completer capability, how the Requester determines which
>> +	 * NPRs include 10-Bit Tags is outside the scope of this specification.
>> +	 * So we do not consider hotplug scenario.
>> +	 */
>> +	if (dev->is_hotplug_bridge) {
>> +		*support = 0;
>> +		return 0;
>> +	}
>> +
>> +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP)) {
>> +		*support = 0;
>> +		return 0;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void pci_configure_rp_10bit_tag(struct pci_dev *dev)
>> +{
>> +	u8 support = 1;
>> +	struct pci_dev *pchild;
>> +
>> +	if (dev->subordinate == NULL)
>> +		return;
>> +
>> +	/* If no devices under the root port, no need to enable 10-Bit Tag. */
>> +	pchild = list_first_entry_or_null(&dev->subordinate->devices,
>> +					  struct pci_dev, bus_list);
>> +	if (pchild == NULL)
>> +		return;
>
> pchild is never used after this check, so this could be simplified to
> a list_empty(&dev->subordinate->devices).
Good point, will do.

Thanks,
Dongdong
> .
>
