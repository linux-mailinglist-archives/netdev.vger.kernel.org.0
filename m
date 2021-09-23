Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D69A415C85
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbhIWLIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:08:07 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9761 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240448AbhIWLIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 07:08:05 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HFXPp6GcLzWN6B;
        Thu, 23 Sep 2021 19:05:18 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 23 Sep 2021 19:06:30 +0800
Subject: Re: [PATCH V9 4/8] PCI/sysfs: Add a 10-Bit Tag sysfs file PCIe
 Endpoint devices
To:     =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>
References: <20210922133655.51811-1-liudongdong3@huawei.com>
 <20210922133655.51811-5-liudongdong3@huawei.com> <YUwA5eC7wiDoHy0F@rocinante>
CC:     <helgaas@kernel.org>, <hch@infradead.org>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <cdd4b942-a9c3-9646-05fc-f55f587e3456@huawei.com>
Date:   Thu, 23 Sep 2021 19:06:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <YUwA5eC7wiDoHy0F@rocinante>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof

Many thanks for your review.
On 2021/9/23 12:21, Krzysztof Wilczyński wrote:
> Hi,
>
> Thank you for sending the patch over!  A few small comments below.
>
> [...]
>> +static ssize_t pci_10bit_tag_store(struct device *dev,
>> +				   struct device_attribute *attr,
>> +				   const char *buf, size_t count)
>> +{
>> +	struct pci_dev *pdev = to_pci_dev(dev);
>> +	bool enable;
>
> Would you mind adding the following capabilities check here?
OK, will do.
>
> 	if (!capable(CAP_SYS_ADMIN))
> 		return -EPERM;
>
> This is so we make sure that whatever user is going to use this sysfs
> attribute actually has enough permissions to update this value safely.
>
>> +	if (kstrtobool(buf, &enable) < 0)
>> +		return -EINVAL;
>> +
>> +	if (pdev->driver)
>> +		return -EBUSY;
>> +
>> +	if (enable) {
>> +		if (!pcie_rp_10bit_tag_cmp_supported(pdev))
>> +			return -EPERM;
>
> Would it make sense to also verify 10-Bit Tag Completer support on the
> "disable" path too?   We won't be able to set a value if there is no
> support, but nothing will stop us from clearing it regardless - unless
> this would be safe to do?  What do you think?
Seems make sense, Will do. It is better do the same thing on the
"disable" path too.
>
>> +		pcie_capability_set_word(pdev, PCI_EXP_DEVCTL2,
>> +				PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
>> +	} else {
>> +		pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL2,
>> +				   PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
>> +	}
>> +
>> +	return count;
>> +}
>
> [...]
>> +> +static umode_t pcie_dev_10bit_tag_attrs_are_visible(struct kobject *kobj,
>> +					  struct attribute *a, int n)
>
> The preferred function name for the .is_visible() callback in a case when
> there is only a single sysfs attribute being added would be:
>
>   pcie_dev_10bit_tag_attr_is_visible()
Will fix.

Thanks,
Dongdong
>
> Albeit, I appreciate that you followed the existing naming pattern.
>
> 	Krzysztof
> .
>
