Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431CF3E1089
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 10:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbhHEIrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 04:47:37 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:13280 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238708AbhHEIrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 04:47:37 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GgMYd2C1vz8327;
        Thu,  5 Aug 2021 16:42:29 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 5 Aug 2021 16:47:21 +0800
Subject: Re: [PATCH V7 8/9] PCI/IOV: Add 10-Bit Tag sysfs files for VF devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210805000525.GA1693795@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <035fbe52-379e-ba6f-52d1-400d2197860e@huawei.com>
Date:   Thu, 5 Aug 2021 16:47:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210805000525.GA1693795@bjorn-Precision-5520>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/8/5 8:05, Bjorn Helgaas wrote:
> On Wed, Aug 04, 2021 at 09:47:07PM +0800, Dongdong Liu wrote:
>> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
>> sending Requests to other Endpoints (as opposed to host memory), the
>> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
>> unless an implementation-specific mechanism determines that the
>> Endpoint supports 10-Bit Tag Completer capability.
>> Add sriov_vf_10bit_tag file to query the status of VF 10-Bit Tag
>> Requester Enable. Add sriov_vf_10bit_tag_ctl file to disable the VF
>> 10-Bit Tag Requester. The typical use case is for p2pdma when the peer
>> device does not support 10-BIT Tag Completer.
>
> Fix the usual spec quoting issue.  Or maybe this is not actually
> quoted but is missing blank lines between paragraphs.
Will fix.
>
> s/10-BIT/10-Bit/
Will fix.
>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> ---
>>  Documentation/ABI/testing/sysfs-bus-pci | 20 +++++++++++++
>>  drivers/pci/iov.c                       | 50 +++++++++++++++++++++++++++++++++
>>  2 files changed, 70 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
>> index 0e0c97d..8fdbfae 100644
>> --- a/Documentation/ABI/testing/sysfs-bus-pci
>> +++ b/Documentation/ABI/testing/sysfs-bus-pci
>> @@ -421,3 +421,23 @@ Description:
>>  		to disable 10-Bit Tag Requester when the driver does not bind
>>  		the deivce. The typical use case is for p2pdma when the peer
>>  		device does not support 10-BIT Tag Completer.
>> +
>> +What:		/sys/bus/pci/devices/.../sriov_vf_10bit_tag
>> +Date:		August 2021
>> +Contact:	Dongdong Liu <liudongdong3@huawei.com>
>> +Description:
>> +		This file is associated with a SR-IOV physical function (PF).
>> +		It is visible when the device has VF 10-Bit Tag Requester
>> +		Supported. It contains the status of VF 10-Bit Tag Requester
>> +		Enable. The file is only readable.
>
> s/only readable/read-only/
Will fix.
>
>> +What:		/sys/bus/pci/devices/.../sriov_vf_10bit_tag_ctl
>
> Why does this file have "_ctl" on the end when the one in patch 7/9
> does not?
>
>> +Date:		August 2021
>> +Contact:	Dongdong Liu <liudongdong3@huawei.com>
>> +Description:
>> +		This file is associated with a SR-IOV virtual function (VF).
>> +		It is visible when the device has VF 10-Bit Tag Requester
>> +		Supported. It only allows to write 0 to disable VF 10-Bit
>> +		Tag Requester. The file is only writeable when the vf driver
>> +		does not bind to a dirver. The typical use case is for p2pdma
>> +		when the peer device does not support 10-BIT Tag Completer.
>
> s/vf/VF/
> s/dirver/driver/
> s/10-BIT/10-Bit/
Will fix.
>
> "when the vr driver does not bind to a driver"?  Not quite right.
> Must be a "device" in there somewhere.
Will fix.
>
> So IIUC this file is associated with a VF, but the bit it writes is
> actually in the *PF*?  So writing 0 to any VF's file disables 10-bit
> tags for *all* VFs?  That's worth mentioning here.
Yes, will do.
>
>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>> index 0d0bed1..04c1298 100644
>> --- a/drivers/pci/iov.c
>> +++ b/drivers/pci/iov.c
>> @@ -220,10 +220,38 @@ static ssize_t sriov_vf_msix_count_store(struct device *dev,
>>  static DEVICE_ATTR_WO(sriov_vf_msix_count);
>>  #endif
>>
>> +static ssize_t sriov_vf_10bit_tag_ctl_store(struct device *dev,
>> +					    struct device_attribute *attr,
>> +					    const char *buf, size_t count)
>> +{
>> +	struct pci_dev *vf_dev = to_pci_dev(dev);
>> +	struct pci_dev *pdev = pci_physfn(vf_dev);
>> +	struct pci_sriov *iov;
>> +	bool enable;
>> +
>> +	if (kstrtobool(buf, &enable) < 0)
>> +		return -EINVAL;
>> +
>> +	if (enable != false)
>> +		return -EINVAL;
>
> Is this "if (enable)" again?
Will fix.
>
>> +	if (vf_dev->driver)
>> +		return -EBUSY;
>> +
>> +	iov = pdev->sriov;
>> +	iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
>> +	pci_write_config_word(pdev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>> +	pci_info(pdev, "disabled SRIOV 10-Bit Tag Requester\n");
>
> s/SRIOV/SR-IOV/ to match spec and other usages.
Will fix.

Thanks,
Dongdong
>
>> +
>> +	return count;
>> +}
>> +static DEVICE_ATTR_WO(sriov_vf_10bit_tag_ctl);
>> +
>>  static struct attribute *sriov_vf_dev_attrs[] = {
>>  #ifdef CONFIG_PCI_MSI
>>  	&dev_attr_sriov_vf_msix_count.attr,
>>  #endif
>> +	&dev_attr_sriov_vf_10bit_tag_ctl.attr,
>>  	NULL,
>>  };
>>
>> @@ -236,6 +264,11 @@ static umode_t sriov_vf_attrs_are_visible(struct kobject *kobj,
>>  	if (!pdev->is_virtfn)
>>  		return 0;
>>
>> +	pdev = pci_physfn(pdev);
>> +	if ((a == &dev_attr_sriov_vf_10bit_tag_ctl.attr) &&
>> +	     !(pdev->sriov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ))
>> +		return 0;
>> +
>>  	return a->mode;
>>  }
>>
>> @@ -487,12 +520,23 @@ static ssize_t sriov_drivers_autoprobe_store(struct device *dev,
>>  	return count;
>>  }
>>
>> +static ssize_t sriov_vf_10bit_tag_show(struct device *dev,
>> +				       struct device_attribute *attr,
>> +				       char *buf)
>> +{
>> +	struct pci_dev *pdev = to_pci_dev(dev);
>> +
>> +	return sysfs_emit(buf, "%u\n",
>> +		!!(pdev->sriov->ctrl & PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN));
>> +}
>> +
>>  static DEVICE_ATTR_RO(sriov_totalvfs);
>>  static DEVICE_ATTR_RW(sriov_numvfs);
>>  static DEVICE_ATTR_RO(sriov_offset);
>>  static DEVICE_ATTR_RO(sriov_stride);
>>  static DEVICE_ATTR_RO(sriov_vf_device);
>>  static DEVICE_ATTR_RW(sriov_drivers_autoprobe);
>> +static DEVICE_ATTR_RO(sriov_vf_10bit_tag);
>>
>>  static struct attribute *sriov_pf_dev_attrs[] = {
>>  	&dev_attr_sriov_totalvfs.attr,
>> @@ -501,6 +545,7 @@ static struct attribute *sriov_pf_dev_attrs[] = {
>>  	&dev_attr_sriov_stride.attr,
>>  	&dev_attr_sriov_vf_device.attr,
>>  	&dev_attr_sriov_drivers_autoprobe.attr,
>> +	&dev_attr_sriov_vf_10bit_tag.attr,
>>  #ifdef CONFIG_PCI_MSI
>>  	&dev_attr_sriov_vf_total_msix.attr,
>>  #endif
>> @@ -511,10 +556,15 @@ static umode_t sriov_pf_attrs_are_visible(struct kobject *kobj,
>>  					  struct attribute *a, int n)
>>  {
>>  	struct device *dev = kobj_to_dev(kobj);
>> +	struct pci_dev *pdev = to_pci_dev(dev);
>>
>>  	if (!dev_is_pf(dev))
>>  		return 0;
>>
>> +	if ((a == &dev_attr_sriov_vf_10bit_tag.attr) &&
>> +	     !(pdev->sriov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ))
>> +		return 0;
>> +
>>  	return a->mode;
>>  }
>>
>> --
>> 2.7.4
>>
> .
>
