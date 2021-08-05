Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF463E0FD5
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 10:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbhHEIEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 04:04:43 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:13235 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbhHEIER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 04:04:17 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GgLj33fdfz1CRVR;
        Thu,  5 Aug 2021 16:03:51 +0800 (CST)
Received: from [10.67.103.235] (10.67.103.235) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 5 Aug 2021 16:03:58 +0800
Subject: Re: [PATCH V7 5/9] PCI/IOV: Enable 10-Bit tag support for PCIe VF
 devices
To:     Bjorn Helgaas <helgaas@kernel.org>
References: <20210804232937.GA1691653@bjorn-Precision-5520>
CC:     <hch@infradead.org>, <kw@linux.com>, <logang@deltatee.com>,
        <leon@kernel.org>, <linux-pci@vger.kernel.org>,
        <rajur@chelsio.com>, <hverkuil-cisco@xs4all.nl>,
        <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Dongdong Liu <liudongdong3@huawei.com>
Message-ID: <08b7a9b7-2951-43c3-5e81-3461b6724955@huawei.com>
Date:   Thu, 5 Aug 2021 16:03:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210804232937.GA1691653@bjorn-Precision-5520>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.235]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/8/5 7:29, Bjorn Helgaas wrote:
> On Wed, Aug 04, 2021 at 09:47:04PM +0800, Dongdong Liu wrote:
>> Enable VF 10-Bit Tag Requester when it's upstream component support
>> 10-bit Tag Completer.
>
> s/it's/its/
> s/support/supports/
Will fix.
>
> I think "upstream component" here means the PF, doesn't it?  I don't
> think the PF is really an *upstream* component; there's no routing
> like with a switch.
I want to say the switch and root port devices that support 10-Bit
Tag Completer. Sure, VF also needs to have 10-bit Tag Requester
Supported capability.
>
>> Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  drivers/pci/iov.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>> index dafdc65..0d0bed1 100644
>> --- a/drivers/pci/iov.c
>> +++ b/drivers/pci/iov.c
>> @@ -634,6 +634,10 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
>>
>>  	pci_iov_set_numvfs(dev, nr_virtfn);
>>  	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
>> +	if ((iov->cap & PCI_SRIOV_CAP_VF_10BIT_TAG_REQ) &&
>> +	    dev->ext_10bit_tag)
>> +		iov->ctrl |= PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
>> +
>>  	pci_cfg_access_lock(dev);
>>  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>>  	msleep(100);
>> @@ -650,6 +654,8 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
>>
>>  err_pcibios:
>>  	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
>> +	if (iov->ctrl & PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN)
>> +		iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
>>  	pci_cfg_access_lock(dev);
>>  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>>  	ssleep(1);
>> @@ -682,6 +688,8 @@ static void sriov_disable(struct pci_dev *dev)
>>
>>  	sriov_del_vfs(dev);
>>  	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
>> +	if (iov->ctrl & PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN)
>> +		iov->ctrl &= ~PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN;
>
> You can just clear PCI_SRIOV_CTRL_VF_10BIT_TAG_REQ_EN unconditionally,
> can't you?  I know it wouldn't change anything, but removing the "if"
> makes the code prettier.  You could just add it in the existing
> PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE mask.
Will do.

Thanks,
Dongdong
>
>>  	pci_cfg_access_lock(dev);
>>  	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
>>  	ssleep(1);
>> --
>> 2.7.4
>>
> .
>
