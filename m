Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7323E59BD
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240531AbhHJMQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:16:48 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8390 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240385AbhHJMQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:16:48 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GkWzb4RNTz83BW;
        Tue, 10 Aug 2021 20:12:27 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 10 Aug 2021 20:16:23 +0800
Subject: Re: [PATCH V7 7/9] PCI/sysfs: Add a 10-Bit Tag sysfs file
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210809173733.GA2167121@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <614f640d-c442-4f79-8761-a33b1c7af3c6@huawei.com>
Date:   Tue, 10 Aug 2021 20:16:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210809173733.GA2167121@bjorn-Precision-5520>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/10 1:37, Bjorn Helgaas wrote:
> On Sat, Aug 07, 2021 at 03:01:56PM +0800, Dongdong Liu wrote:
>>
>> On 2021/8/5 23:31, Bjorn Helgaas wrote:
>>> On Thu, Aug 05, 2021 at 04:37:39PM +0800, Dongdong Liu wrote:
>>>>
>>>>
>>>> On 2021/8/5 7:49, Bjorn Helgaas wrote:
>>>>> On Wed, Aug 04, 2021 at 09:47:06PM +0800, Dongdong Liu wrote:
>>>>>> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
>>>>>> sending Requests to other Endpoints (as opposed to host memory), the
>>>>>> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
>>>>>> unless an implementation-specific mechanism determines that the Endpoint
>>>>>> supports 10-Bit Tag Completer capability. Add a 10bit_tag sysfs file,
>>>>>> write 0 to disable 10-Bit Tag Requester when the driver does not bind
>>>>>> the device if the peer device does not support the 10-Bit Tag Completer.
>>>>>> This will make P2P traffic safe. the 10bit_tag file content indicate
>>>>>> current 10-Bit Tag Requester Enable status.
>>>>>>
>>>>>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>>>>>> ---
>>>>>>  Documentation/ABI/testing/sysfs-bus-pci | 16 +++++++-
>>>>>>  drivers/pci/pci-sysfs.c                 | 69 +++++++++++++++++++++++++++++++++
>>>>>>  2 files changed, 84 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
>>>>>> index 793cbb7..0e0c97d 100644
>>>>>> --- a/Documentation/ABI/testing/sysfs-bus-pci
>>>>>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
>>>>>> @@ -139,7 +139,7 @@ Description:
>>>>>>  		binary file containing the Vital Product Data for the
>>>>>>  		device.  It should follow the VPD format defined in
>>>>>>  		PCI Specification 2.1 or 2.2, but users should consider
>>>>>> -		that some devices may have incorrectly formatted data.
>>>>>> +		that some devices may have incorrectly formatted data.
>>>>>>  		If the underlying VPD has a writable section then the
>>>>>>  		corresponding section of this file will be writable.
>>>>>>
>>>>>> @@ -407,3 +407,17 @@ Description:
>>>>>>
>>>>>>  		The file is writable if the PF is bound to a driver that
>>>>>>  		implements ->sriov_set_msix_vec_count().
>>>>>> +
>>>>>> +What:		/sys/bus/pci/devices/.../10bit_tag
>>>>>> +Date:		August 2021
>>>>>> +Contact:	Dongdong Liu <liudongdong3@huawei.com>
>>>>>> +Description:
>>>>>> +		If a PCI device support 10-Bit Tag Requester, will create the
>>>>>> +		10bit_tag sysfs file. The file is readable, the value
>>>>>> +		indicate current 10-Bit Tag Requester Enable.
>>>>>> +		1 - enabled, 0 - disabled.
>>>>>> +
>>>>>> +		The file is also writeable, the value only accept by write 0
>>>>>> +		to disable 10-Bit Tag Requester when the driver does not bind
>>>>>> +		the deivce. The typical use case is for p2pdma when the peer
>>>>>> +		device does not support 10-BIT Tag Completer.
>>>
>>>>>> +static ssize_t pci_10bit_tag_store(struct device *dev,
>>>>>> +				   struct device_attribute *attr,
>>>>>> +				   const char *buf, size_t count)
>>>>>> +{
>>>>>> +	struct pci_dev *pdev = to_pci_dev(dev);
>>>>>> +	bool enable;
>>>>>> +
>>>>>> +	if (kstrtobool(buf, &enable) < 0)
>>>>>> +		return -EINVAL;
>>>>>> +
>>>>>> +	if (enable != false )
>>>>>> +		return -EINVAL;
>>>>>
>>>>> Is this the same as "if (enable)"?
>>>> Yes, Will fix.
>>>
>>> I actually don't like the one-way nature of this.  When the hierarchy
>>> supports 10-bit tags, we automatically enable them during enumeration.
>>>
>>> Then we provide this sysfs file, but it can only *disable* 10-bit
>>> tags.  There's no way to re-enable them except by rebooting (or using
>>> setpci, I guess).
>>>
>>> Why can't we allow *enabling* them here if they're supported in this
>>> hierarchy?
>> Yes, we can also provide this sysfs to enable 10-bit tag for EP devices
>> when the hierarchy supports 10-bit tags.
>>
>> I do not want to provide sysfs to enable/disable 10-bit tag for RP
>> devices as I can not tell current if the the Function has outstanding
>> Non-Posted Requests, may need to unbind all the EP drivers under the
>> RP, and current seems no scenario need to do this. This will make things
>> more complex.
>
> You mean "no scenario requires disabling 10-bit tags and then
> re-enabling them"?
Just for Root Port devices.
> That may be true, but I'm still hesitant to
> provide a switch than can only be reversed by rebooting.
>
> This is similar to the issue Leon raised that it's not practical to
> reboot machines.  Maybe we accept a one-way switch if the sole purpose
> is to work around a hardware defect.  Or maybe a kernel parameter that
> disables 10-bit tags completely is the defect mitigation.  I think we
> probably need such a parameter in case a defect prevents us from
> booting far enough to use the sysfs switch.
Make sense, will provide sysfs to enable and disable 10-bit tag.

Thanks,
Dongdong
> .
>
