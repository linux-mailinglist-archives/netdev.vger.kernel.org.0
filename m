Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC8621B5B38
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 14:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgDWMSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 08:18:10 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:60108 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbgDWMSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 08:18:10 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 7BF311E0F4296EBB6450;
        Thu, 23 Apr 2020 20:17:33 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 23 Apr 2020 20:17:32 +0800
Received: from [10.173.219.71] (10.173.219.71) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 23 Apr 2020 20:17:32 +0800
Subject: Re: [PATCH net-next 2/3] hinic: add sriov feature support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>
References: <20200421045635.8128-1-luobin9@huawei.com>
 <20200421045635.8128-3-luobin9@huawei.com>
 <20200421112121.2f0ddf30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <f739eabf-4254-04ae-53e9-35a6ccf0c831@huawei.com>
Date:   Thu, 23 Apr 2020 20:17:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200421112121.2f0ddf30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.173.219.71]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These bit locks are mainly used for extendibility, and other opinions are accepted.Thanks for your review.

On 2020/4/22 2:21, Jakub Kicinski wrote:
> On Tue, 21 Apr 2020 04:56:34 +0000 Luo bin wrote:
>> +int hinic_pci_sriov_disable(struct pci_dev *pdev)
>> +{
>> +	struct hinic_sriov_info *sriov_info;
>> +	u16 tmp_vfs;
>> +
>> +	sriov_info = hinic_get_sriov_info_by_pcidev(pdev);
>> +	/* if SR-IOV is already disabled then nothing will be done */
>> +	if (!sriov_info->sriov_enabled)
>> +		return 0;
> Can't happen see below.
>
>> +	if (test_and_set_bit(HINIC_SRIOV_DISABLE, &sriov_info->state)) {
>> +		dev_err(&pdev->dev,
>> +			"SR-IOV disable in process, please wait");
>> +		return -EPERM;
>> +	}
> Hm. I don't understand why you need these bit locks.
>
>> +	/* If our VFs are assigned we cannot shut down SR-IOV
>> +	 * without causing issues, so just leave the hardware
>> +	 * available but disabled
>> +	 */
>> +	if (pci_vfs_assigned(sriov_info->pdev)) {
>> +		clear_bit(HINIC_SRIOV_DISABLE, &sriov_info->state);
>> +		dev_warn(&pdev->dev, "Unloading driver while VFs are assigned - VFs will not be deallocated\n");
>> +		return -EPERM;
>> +	}
>> +	sriov_info->sriov_enabled = false;
>> +
>> +	/* disable iov and allow time for transactions to clear */
>> +	pci_disable_sriov(sriov_info->pdev);
>> +
>> +	tmp_vfs = (u16)sriov_info->num_vfs;
>> +	sriov_info->num_vfs = 0;
>> +	hinic_deinit_vf_hw(sriov_info, OS_VF_ID_TO_HW(0),
>> +			   OS_VF_ID_TO_HW(tmp_vfs - 1));
>> +
>> +	clear_bit(HINIC_SRIOV_DISABLE, &sriov_info->state);
>> +
>> +	return 0;
>> +}
>> +
>> +int hinic_pci_sriov_enable(struct pci_dev *pdev, int num_vfs)
>> +{
>> +	struct hinic_sriov_info *sriov_info;
>> +	int pre_existing_vfs = 0;
>> +	int err = 0;
>> +
>> +	sriov_info = hinic_get_sriov_info_by_pcidev(pdev);
>> +
>> +	if (test_and_set_bit(HINIC_SRIOV_ENABLE, &sriov_info->state)) {
>> +		dev_err(&pdev->dev,
>> +			"SR-IOV enable in process, please wait, num_vfs %d\n",
>> +			num_vfs);
>> +		return -EPERM;
>> +	}
> This should never happen, PCI core code will prevent SR-IOV from being
> enabled twice in a row, and concurrently. See sriov_numvfs_store().
>
>> +	pre_existing_vfs = pci_num_vf(sriov_info->pdev);
>> +
>> +	if (num_vfs > pci_sriov_get_totalvfs(sriov_info->pdev)) {
>> +		clear_bit(HINIC_SRIOV_ENABLE, &sriov_info->state);
>> +		return -ERANGE;
>> +	}
> Again, can't happen.
>
>> +	if (pre_existing_vfs && pre_existing_vfs != num_vfs) {
>> +		err = hinic_pci_sriov_disable(sriov_info->pdev);
>> +		if (err) {
>> +			clear_bit(HINIC_SRIOV_ENABLE, &sriov_info->state);
>> +			return err;
>> +		}
> And this.
>
>> +	} else if (pre_existing_vfs == num_vfs) {
> Or this.
>
>> +		clear_bit(HINIC_SRIOV_ENABLE, &sriov_info->state);
>> +		return num_vfs;
>> +	}
>> +
>> +	err = pci_enable_sriov(sriov_info->pdev, num_vfs);
>> +	if (err) {
>> +		dev_err(&pdev->dev,
>> +			"Failed to enable SR-IOV, error %d\n", err);
>> +		clear_bit(HINIC_SRIOV_ENABLE, &sriov_info->state);
>> +		return err;
>> +	}
>> +
>> +	sriov_info->sriov_enabled = true;
>> +	sriov_info->num_vfs = num_vfs;
>> +	clear_bit(HINIC_SRIOV_ENABLE, &sriov_info->state);
>> +
>> +	return num_vfs;
>> +}
>> +
>> +int hinic_pci_sriov_configure(struct pci_dev *dev, int num_vfs)
>> +{
>> +	struct hinic_sriov_info *sriov_info;
>> +
>> +	sriov_info = hinic_get_sriov_info_by_pcidev(dev);
>> +
>> +	if (test_bit(HINIC_FUNC_REMOVE, &sriov_info->state))
>> +		return -EFAULT;
> I don't think EFAULT is not a correct error code here. Use EBUSY, or
> ENODEV?
>
>> +	if (!num_vfs)
>> +		return hinic_pci_sriov_disable(dev);
>> +	else
>> +		return hinic_pci_sriov_enable(dev, num_vfs);
>> +}
> .
