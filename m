Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7643442EBF
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 14:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhKBNGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 09:06:11 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:14701 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhKBNGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 09:06:11 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hk95L58zBzZcVs;
        Tue,  2 Nov 2021 21:01:26 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Tue, 2 Nov 2021 21:03:30 +0800
Subject: Re: [PATCH V11 4/8] PCI/sysfs: Add a tags sysfs file for PCIe
 Endpoint devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20211101205442.GA546492@bhelgaas>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <40e675a1-6931-8daa-d98d-7b9c64785012@huawei.com>
Date:   Tue, 2 Nov 2021 21:03:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20211101205442.GA546492@bhelgaas>
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

Many thanks for you review.
On 2021/11/2 4:54, Bjorn Helgaas wrote:
> On Sat, Oct 30, 2021 at 09:53:44PM +0800, Dongdong Liu wrote:
>> PCIe spec 5.0 r1.0 section 2.2.6.2 says:
>>
>>   If an Endpoint supports sending Requests to other Endpoints (as
>>   opposed to host memory), the Endpoint must not send 10-Bit Tag
>>   Requests to another given Endpoint unless an implementation-specific
>>   mechanism determines that the Endpoint supports 10-Bit Tag Completer
>>   capability.
>>
>> Add a tags sysfs file, write 0 to disable 10-Bit Tag Requester
>> when the driver does not bind the device. The typical use case is for
>> p2pdma when the peer device does not support 10-Bit Tag Completer.
>> Write 10 to enable 10-Bit Tag Requester when RC supports 10-Bit Tag
>> Completer capability. The typical use case is for host memory targeted
>> by DMA Requests. The tags file content indicate current status of Tags
>> Enable.
>>
>> PCIe r5.0, sec 2.2.6.2 says:
>>
>>   Receivers/Completers must handle 8-bit Tag values correctly regardless
>>   of the setting of their Extended Tag Field Enable bit (see Section
>>   7.5.3.4).
>>
>> Add this comment in pci_configure_extended_tags(). As all PCIe completers
>> are required to support 8-bit tags, so we do not use tags sysfs file
>> to manage 8-bit tags.
>
>> +What:		/sys/bus/pci/devices/.../tags
>> +Date:		September 2021
>> +Contact:	Dongdong Liu <liudongdong3@huawei.com>
>> +Description:
>> +		The file will be visible when the device supports 10-Bit Tag
>> +		Requester. The file is readable, the value indicate current
>> +		status of Tags Enable(5-Bit, 8-Bit, 10-Bit).
>> +
>> +		The file is also writable, The values accepted are:
>> +		* > 0 - this number will be reported as tags bit to be
>> +			enabled. current only 10 is accepted
>> +		* < 0 - not valid
>> +		* = 0 - disable 10-Bit Tag, use Extended Tags(8-Bit or 5-Bit)
>> +
>> +		write 0 to disable 10-Bit Tag Requester when the driver does
>> +		not bind the device. The typical use case is for p2pdma when
>> +		the peer device does not support 10-Bit Tag Completer.
>> +
>> +		Write 10 to enable 10-Bit Tag Requester when RC supports 10-Bit
>> +		Tag Completer capability. The typical use case is for host
>> +		memory targeted by DMA Requests.
>
> 1) I think I would rename this from "tags" to "tag_bits".  A file
>    named "tags" that contains 8 suggests that we can use 8 tags, but
>    in fact, we can use 256 tags.
Looks good, Will do.
>
> 2) This controls tag size the requester will use.  The current knobs
>    in the hardware allow 5, 8, or 10 bits.
>
>    "0" to disable 10-bit tags without specifying whether we should use
>    5- or 8-bit tags doesn't seem right.  All completers are *supposed*
>    to support 8-bit, but we've tripped over a few that don't.
>
>    I don't think we currently have a run-time (or even a boot-time)
>    way to disable 8-bit tags; all we have is the quirk_no_ext_tags()
>    quirk.  But if we ever wanted to *add* that, maybe we would want:
>
>       5 - use 5-bit tags
>       8 - use 8-bit tags
>      10 - use 10-bit tags
will do.
>    Maybe we just say "0" is invalid, since there's no obvious way to
>    map this?
OK, will do.
>
>> +static ssize_t tags_show(struct device *dev,
>> +			 struct device_attribute *attr,
>> +			 char *buf)
>> +{
>> + ...
>
>> +	if (ctl & PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN)
>> +		return sysfs_emit(buf, "%s\n", "10-Bit");
>> +
>> +	ret = pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &ctl);
>> +	if (ret)
>> +		return -EINVAL;
>> +
>> +	if (ctl & PCI_EXP_DEVCTL_EXT_TAG)
>> +		return sysfs_emit(buf, "%s\n", "8-Bit");
>> +
>> +	return sysfs_emit(buf, "%s\n", "5-Bit");
>
> Since I prefer the "tag_bits" name, my preference would be bare
> numbers here: "10", "8", "5".
Will do.
>
> Both comments apply to the sriov files, too.
Will do.
>
>> +static umode_t pcie_dev_tags_attrs_is_visible(struct kobject *kobj,
>> +					      struct attribute *a, int n)
>> +{
>> +	struct device *dev = kobj_to_dev(kobj);
>> +	struct pci_dev *pdev = to_pci_dev(dev);
>> +
>> +	if (pdev->is_virtfn)
>> +		return 0;
>> +
>> +	if (pci_pcie_type(pdev) != PCI_EXP_TYPE_ENDPOINT)
>> +		return 0;
>> +
>> +	if (!(pdev->devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ))
>> +		return 0;
>
> Makes sense for now that the file is only visible if a requester
> supports 10-bit tags.  If we ever wanted to extend this to control 5-
> vs 8-bit tags, we could make it visible in more cases then.
Will do.
>
>> +
>> +	return a->mode;
>> +}
>
>> @@ -2075,6 +2089,12 @@ int pci_configure_extended_tags(struct pci_dev *dev, void *ign)
>>  		return 0;
>>  	}
>>
>> +	/*
>> +	 * PCIe r5.0, sec 2.2.6.2 says "Receivers/Completers must handle 8-bit
>> +	 * Tag values correctly regardless of the setting of their Extended Tag
>> +	 * Field Enable bit (see Section 7.5.3.4)", so it is safe to enable
>> +	 * Extented Tags.
>
> s/Extented/Extended/
Will fix.

Thanks,
Dongdong
>
>> +	 */
>>  	if (!(ctl & PCI_EXP_DEVCTL_EXT_TAG)) {
>>  		pci_info(dev, "enabling Extended Tags\n");
>>  		pcie_capability_set_word(dev, PCI_EXP_DEVCTL,
>> --
>> 2.22.0
>>
> .
>
