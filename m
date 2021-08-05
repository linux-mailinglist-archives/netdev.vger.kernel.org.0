Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BA23E0F89
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 09:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbhHEHsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 03:48:17 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13234 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237095AbhHEHrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 03:47:51 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GgLL50NJ5z1CRRl;
        Thu,  5 Aug 2021 15:47:25 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 5 Aug 2021 15:47:31 +0800
Subject: Re: [PATCH V7 4/9] PCI: Enable 10-Bit Tag support for PCIe Endpoint
 devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210804231729.GA1679826@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <7d84ede9-8983-50f0-8387-3d4c6db1b042@huawei.com>
Date:   Thu, 5 Aug 2021 15:47:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210804231729.GA1679826@bjorn-Precision-5520>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn

Many thanks for your review.
On 2021/8/5 7:17, Bjorn Helgaas wrote:
> On Wed, Aug 04, 2021 at 09:47:03PM +0800, Dongdong Liu wrote:
>> 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
>> field size from 8 bits to 10 bits.
>>
>> PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
>> 10-Bit Tag Capabilities" Implementation Note.
>> For platforms where the RC supports 10-Bit Tag Completer capability,
>> it is highly recommended for platform firmware or operating software
>> that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
>> bit automatically in Endpoints with 10-Bit Tag Requester capability. This
>> enables the important class of 10-Bit Tag capable adapters that send
>> Memory Read Requests only to host memory.
>
> Quoted material should be set off with a blank line before it and
> indented by two spaces so it's clear exactly what comes from the spec
> and what you've added.  For example, see
> https://git.kernel.org/linus/ec411e02b7a2
Good point, will fix.
>
> We need to say why we assume it's safe to enable 10-bit tags for all
> devices below a Root Port that supports them.  I think this has to do
> with switches being required to forward 10-bit tags correctly even if
> they were designed before 10-bit tags were added to the spec.

PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
10-Bit Tag Capabilities" Implementation Note:

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

This patch also consider to enable 10-Bit Tag for EP device need RP
and Switch device support 10-Bit Tag Completer capability.
>
> And it should call out any cases where it is *not* safe, e.g., if P2P
> traffic is an issue.
Yes, indeed.
>
> If there are cases where we don't want to enable 10-bit tags, whether
> it's to enable P2P traffic or merely to work around device defects,
> that ability needs to be here from the beginning.  If somebody needs
> to bisect with 10-bit tags disabled, we don't want a bisection hole
> between this commit and the commit that adds the control.
We provide sysfs file to disable 10-bit tag for P2P traffic when needed.
The details see PATCH 7/8/9.

Current we do not know the 10-bit tag defective devices, current may no
need do as 8-bit tag does in quirk_no_ext_tags().
>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  drivers/pci/probe.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
>>  include/linux/pci.h |  2 ++
>>  2 files changed, 48 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index c83245b..3da7baa 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -2029,10 +2029,42 @@ static void pci_configure_mps(struct pci_dev *dev)
>>  		 p_mps, mps, mpss);
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
>
> Is it meaningful to set dev->ext_10bit_tag when "dev" is a VF?  I
> suspect only if the VF could be a switch.  Is that possible?  If not,
Yes, no need.
> I think the dev->is_virtfn check could be done first.
Will do.
>
>> +
>> +	/*
>> +	 * 10-Bit Tag Requester Enable in Device Control 2 Register is RsvdP
>> +	 * for VF.
>
> (Per 9.3.5.10)
Will fix.

Thanks,
Dongdong
>
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
>>  int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>>  {
>>  	struct pci_host_bridge *host;
>> -	u16 ctl;
>> +	u16 ctl, ctl2;
>>  	int ret;
>>
>>  	if (!pci_is_pcie(dev))
>> @@ -2045,6 +2077,10 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>>  	if (ret)
>>  		return 0;
>>
>> +	ret = pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &ctl2);
>> +	if (ret)
>> +		return 0;
>> +
>>  	host = pci_find_host_bridge(dev->bus);
>>  	if (!host)
>>  		return 0;
>> @@ -2059,6 +2095,12 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>>  			pcie_capability_clear_word(dev, PCI_EXP_DEVCTL,
>>  						   PCI_EXP_DEVCTL_EXT_TAG);
>>  		}
>> +
>> +		if (ctl2 & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN) {
>> +			pci_info(dev, "disabling 10-Bit Tags\n");
>> +			pcie_capability_clear_word(dev, PCI_EXP_DEVCTL2,
>> +					PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
>> +		}
>>  		return 0;
>>  	}
>>
>> @@ -2067,6 +2109,9 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>>  		pcie_capability_set_word(dev, PCI_EXP_DEVCTL,
>>  					 PCI_EXP_DEVCTL_EXT_TAG);
>>  	}
>> +
>> +	pci_configure_10bit_tags(dev);
>> +
>>  	return 0;
>>  }
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 9aab67f..af6cb53 100644
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
