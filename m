Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E8A3E1036
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 10:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237464AbhHEIZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 04:25:41 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7792 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhHEIZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 04:25:40 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GgM9n0pF0zYkV1;
        Thu,  5 Aug 2021 16:25:17 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 5 Aug 2021 16:25:24 +0800
Subject: Re: [PATCH V7 6/9] PCI: Enable 10-Bit Tag support for PCIe RP devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210804233850.GA1691988@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <d2e8b035-42c1-9eb6-986f-1de78cffeef0@huawei.com>
Date:   Thu, 5 Aug 2021 16:25:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210804233850.GA1691988@bjorn-Precision-5520>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/5 7:38, Bjorn Helgaas wrote:
> On Wed, Aug 04, 2021 at 09:47:05PM +0800, Dongdong Liu wrote:
>> PCIe spec 5.0r1.0 section 2.2.6.2 implementation note, In configurations
>> where a Requester with 10-Bit Tag Requester capability needs to target
>> multiple Completers, one needs to ensure that the Requester sends 10-Bit
>> Tag Requests only to Completers that have 10-Bit Tag Completer capability.
>> So we enable 10-Bit Tag Requester for root port only when the devices
>> under the root port support 10-Bit Tag Completer.
>
> Fix quoting.  I can't tell what is from the spec and what you wrote.
Will fix.
>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> ---
>>  drivers/pci/pcie/portdrv_pci.c | 69 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 69 insertions(+)
>>
>> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
>> index c7ff1ee..2382cd2 100644
>> --- a/drivers/pci/pcie/portdrv_pci.c
>> +++ b/drivers/pci/pcie/portdrv_pci.c
>> @@ -90,6 +90,72 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
>>  #define PCIE_PORTDRV_PM_OPS	NULL
>>  #endif /* !PM */
>>
>> +static int pci_10bit_tag_comp_support(struct pci_dev *dev, void *data)
>> +{
>> +	bool *support = (bool *)data;
>> +
>> +	if (!pci_is_pcie(dev)) {
>> +		*support = false;
>> +		return 1;
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
>> +		*support = false;
>> +		return 1;
>> +	}
>> +
>> +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP)) {
>> +		*support = false;
>> +		return 1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void pci_configure_rp_10bit_tag(struct pci_dev *dev)
>> +{
>> +	bool support = true;
>> +
>> +	if (dev->subordinate == NULL)
>> +		return;
>> +
>> +	/* If no devices under the root port, no need to enable 10-Bit Tag. */
>> +	if (list_empty(&dev->subordinate->devices))
>> +		return;
>> +
>> +	pci_10bit_tag_comp_support(dev, &support);
>> +	if (!support)
>> +		return;
>> +
>> +	/*
>> +	 * PCIe spec 5.0r1.0 section 2.2.6.2 implementation note.
>> +	 * In configurations where a Requester with 10-Bit Tag Requester
>> +	 * capability needs to target multiple Completers, one needs to ensure
>> +	 * that the Requester sends 10-Bit Tag Requests only to Completers
>> +	 * that have 10-Bit Tag Completer capability. So we enable 10-Bit Tag
>> +	 * Requester for root port only when the devices under the root port
>> +	 * support 10-Bit Tag Completer.
>> +	 */
>> +	pci_walk_bus(dev->subordinate, pci_10bit_tag_comp_support, &support);
>> +	if (!support)
>> +		return;
>> +
>> +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ))
>> +		return;
>> +
>> +	pci_dbg(dev, "enabling 10-Bit Tag Requester\n");
>> +	pcie_capability_set_word(dev, PCI_EXP_DEVCTL2,
>> +				 PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
>> +}
>> +
>>  /*
>>   * pcie_portdrv_probe - Probe PCI-Express port devices
>>   * @dev: PCI-Express port device being probed
>> @@ -111,6 +177,9 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
>>  	     (type != PCI_EXP_TYPE_RC_EC)))
>>  		return -ENODEV;
>>
>> +	if (type == PCI_EXP_TYPE_ROOT_PORT)
>> +		pci_configure_rp_10bit_tag(dev);
>
> I don't think this has anything to do with the portdrv, so all this
> should go somewhere else.
Yes, any suggestion where to put the code?
>
> Out of curiosity, IIUC this enables 10-bit tags for MMIO transactions
> from the root port toward the device, i.e., traffic that originates
> from a CPU.  Is that a significant benefit?  I would expect high-speed
> devices would primarily operate via DMA with relatively little MMIO
> traffic.
The benefits of 10-Bit Tag for EP are obvious.
There are few RP scenarios. Unless there are two:
1. RC has its own DMA.
2. The P2P tag is replaced at the RP when the P2PDMA go through RP.

Thanks,
Dongdong
>
>>  	if (type == PCI_EXP_TYPE_RC_EC)
>>  		pcie_link_rcec(dev);
>>
>> --
>> 2.7.4
>>
> .
>
