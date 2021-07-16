Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CBB3CB698
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 13:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhGPLPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 07:15:15 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15027 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbhGPLPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 07:15:14 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GR7ls5x07zZqfH;
        Fri, 16 Jul 2021 19:08:57 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 16 Jul 2021 19:12:16 +0800
Subject: Re: [PATCH V5 4/6] PCI: Enable 10-Bit tag support for PCIe Endpoint
 devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210715172336.GA1972959@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <db506d81-3cb9-4cdc-fb4a-f2d28587b9b2@huawei.com>
Date:   Fri, 16 Jul 2021 19:12:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210715172336.GA1972959@bjorn-Precision-5520>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn

Many thanks for your review.

On 2021/7/16 1:23, Bjorn Helgaas wrote:
> [+cc Logan]
>
> On Mon, Jun 21, 2021 at 06:27:20PM +0800, Dongdong Liu wrote:
>> 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
>> field size from 8 bits to 10 bits.
>>
>> For platforms where the RC supports 10-Bit Tag Completer capability,
>> it is highly recommended for platform firmware or operating software
>
> Recommended by whom?  If the spec recommends it, we should provide the
> citation.
PCIe spec 5.0 r1.0 section 2.2.6.2 IMPLEMENTATION NOTE says that.
Will fix.
>
>> that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
>> bit automatically in Endpoints with 10-Bit Tag Requester capability. This
>> enables the important class of 10-Bit Tag capable adapters that send
>> Memory Read Requests only to host memory.
>
> What is the implication for P2PDMA?  What happens if we enable 10-bit
> tags for device A, and A generates Mem Read Requests to device B,
> which does not support 10-bit tags?
PCIe spec 5.0 r1.0 section 2.2.6.2 says
If an Endpoint supports sending Requests to other Endpoints (as opposed 
to host memory), the Endpoint must not send 10-Bit Tag Requests to 
another given Endpoint unless an implementation-specific mechanism 
determines that the Endpoint supports 10-Bit Tag Completer capability. 
Not sending 10-Bit Tag Requests to other Endpoints at all
may be acceptable for some implementations. More sophisticated 
mechanisms are outside the scope of this specification.

Not sending 10-Bit Tag Requests to other Endpoints at all seems simple.
Add kernel parameter pci=pcie_bus_peer2peer when boot kernel with 
P2PDMA, then do not config 10-BIT Tag.

if (pcie_bus_config != PCIE_BUS_PEER2PEER)
	pci_configure_10bit_tags(dev);

Bjorn and Logan, any suggestion?
>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  drivers/pci/probe.c | 33 +++++++++++++++++++++++++++++++++
>>  include/linux/pci.h |  2 ++
>>  2 files changed, 35 insertions(+)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index 0208865..33241fb 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -2048,6 +2048,38 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>>  	return 0;
>>  }
>>
>> +static void pci_configure_10bit_tags(struct pci_dev *dev)
>> +{
>> +	struct pci_dev *bridge;
>> +
>> +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP))
>> +		return;
>> +
>> +	if (pci_pcie_type(dev) == PCI_EXP_TYPE_ROOT_PORT) {
>> +		dev->ext_10bit_tag = 1;
>> +		return;
>> +	}
>> +
>> +	bridge = pci_upstream_bridge(dev);
>> +	if (bridge && bridge->ext_10bit_tag)
>> +		dev->ext_10bit_tag = 1;
>> +
>> +	/*
>> +	 * 10-Bit Tag Requester Enable in Device Control 2 Register is RsvdP
>> +	 * for VF.
>> +	 */
>> +	if (dev->is_virtfn)
>> +		return;
>> +
>> +	if (pci_pcie_type(dev) == PCI_EXP_TYPE_ENDPOINT &&
>> +	    dev->ext_10bit_tag == 1 &&
>> +	    (dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ)) {
>> +		pci_dbg(dev, "enabling 10-Bit Tag Requester\n");
>> +		pcie_capability_set_word(dev, PCI_EXP_DEVCTL2,
>> +					PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
>> +	}
>> +}
>> +
>>  /**
>>   * pcie_relaxed_ordering_enabled - Probe for PCIe relaxed ordering enable
>>   * @dev: PCI device to query
>> @@ -2184,6 +2216,7 @@ static void pci_configure_device(struct pci_dev *dev)
>>  {
>>  	pci_configure_mps(dev);
>>  	pci_configure_extended_tags(dev, NULL);
>> +	pci_configure_10bit_tags(dev);
>
> I think 10-bit tag support should be integrated with extended (8-bit)
> tag support instead of having two separate functions.
>
> If we have "no_ext_tags" set because some device doesn't support 8-bit
> tags correctly, we probably shouldn't try to enable 10-bit tags
> either.
Looks good, will fix.

Thanks
Dongdong
>
>>  	pci_configure_relaxed_ordering(dev);
>>  	pci_configure_ltr(dev);
>>  	pci_configure_eetlp_prefix(dev);
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index de1fc24..445d102 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -393,6 +393,8 @@ struct pci_dev {
>>  #endif
>>  	unsigned int	eetlp_prefix_path:1;	/* End-to-End TLP Prefix */
>>
>> +	unsigned int	ext_10bit_tag:1; /* 10-Bit Tag Completer Supported
>> +					    from root to here */
>>  	pci_channel_state_t error_state;	/* Current connectivity state */
>>  	struct device	dev;			/* Generic device interface */
>>
>> --
>> 2.7.4
>>
> .
>
