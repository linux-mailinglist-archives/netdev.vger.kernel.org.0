Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB2C75CA5
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 03:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGZBun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 21:50:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2729 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfGZBum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 21:50:42 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D45B9F512131EE80859A;
        Fri, 26 Jul 2019 09:50:40 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Fri, 26 Jul 2019
 09:50:33 +0800
Subject: Re: [PATCH net-next 06/11] net: hns3: modify firmware version display
 format
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
 <1563938327-9865-7-git-send-email-tanhuazhong@huawei.com>
 <4c4ce27c9a9372340c0e2b0f654b3fb9cd85b3e4.camel@mellanox.com>
 <95783289-9b3b-f085-876b-49815b07d595@huawei.com>
 <d6a32434af7e9c883f104ae66e62b7b376abb39c.camel@mellanox.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <6c51adfc-b587-428a-2617-0532095d3d0a@huawei.com>
Date:   Fri, 26 Jul 2019 09:50:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <d6a32434af7e9c883f104ae66e62b7b376abb39c.camel@mellanox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/26 5:32, Saeed Mahameed wrote:
> On Thu, 2019-07-25 at 10:34 +0800, tanhuazhong wrote:
>>
>> On 2019/7/25 2:34, Saeed Mahameed wrote:
>>> On Wed, 2019-07-24 at 11:18 +0800, Huazhong Tan wrote:
>>>> From: Yufeng Mo <moyufeng@huawei.com>
>>>>
>>>> This patch modifies firmware version display format in
>>>> hclge(vf)_cmd_init() and hns3_get_drvinfo(). Also, adds
>>>> some optimizations for firmware version display format.
>>>>
>>>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>>>> Signed-off-by: Peng Li <lipeng321@huawei.com>
>>>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>>>> ---
>>>>    drivers/net/ethernet/hisilicon/hns3/hnae3.h              |  9
>>>> +++++++++
>>>>    drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c       | 15
>>>> +++++++++++++--
>>>>    drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c   | 10
>>>> +++++++++-
>>>>    drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c | 11
>>>> +++++++++--
>>>>    4 files changed, 40 insertions(+), 5 deletions(-)
>>>>
>>>>
> 
> [...]
> 
>>>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
>>>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
>>>> @@ -419,7 +419,15 @@ int hclge_cmd_init(struct hclge_dev *hdev)
>>>>    	}
>>>>    	hdev->fw_version = version;
>>>>    
>>>> -	dev_info(&hdev->pdev->dev, "The firmware version is %08x\n",
>>>> version);
>>>> +	pr_info_once("The firmware version is %lu.%lu.%lu.%lu\n",
>>>> +		     hnae3_get_field(version,
>>>> HNAE3_FW_VERSION_BYTE3_MASK,
>>>> +				     HNAE3_FW_VERSION_BYTE3_SHIFT),
>>>> +		     hnae3_get_field(version,
>>>> HNAE3_FW_VERSION_BYTE2_MASK,
>>>> +				     HNAE3_FW_VERSION_BYTE2_SHIFT),
>>>> +		     hnae3_get_field(version,
>>>> HNAE3_FW_VERSION_BYTE1_MASK,
>>>> +				     HNAE3_FW_VERSION_BYTE1_SHIFT),
>>>> +		     hnae3_get_field(version,
>>>> HNAE3_FW_VERSION_BYTE0_MASK,
>>>> +				     HNAE3_FW_VERSION_BYTE0_SHIFT));
>>>>    
>>>
>>> Device name/string will not be printed now, what happens if i have
>>> multiple devices ? at least print the device name as it was before
>>>
>> Since on each board we only have one firmware, the firmware
>> version is same per device, and will not change when running.
>> So pr_info_once() looks good for this case.
>>
> 
> boards change too often to have such static assumption.

Ok, I will use dev_info instead of pr_info here.

> 
>> BTW, maybe we should change below print in the end of
>> hclge_init_ae_dev(), use dev_info() instead of pr_info(),
>> then we can know that which device has already initialized.
>> I will send other patch to do that, is it acceptable for you?
>>
>> "pr_info("%s driver initialization finished.\n", HCLGE_DRIVER_NAME);"
>>
> 
> I would avoid using pr_info when i can ! if you have the option to
> print with dev information as it was before that is preferable.
> 
> Thanks,
> Saeed.
> 

Thanks,
Huazhong.

