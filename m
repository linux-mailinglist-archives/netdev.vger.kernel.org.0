Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5C9103136
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfKTBg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 20:36:57 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:33402 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726874AbfKTBg4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 20:36:56 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 608C93AEE0F3A86D25D2;
        Wed, 20 Nov 2019 09:36:54 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 20 Nov 2019
 09:36:44 +0800
Subject: Re: [PATCH net] net: hns3: fix a wrong reset interrupt status mask
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>
References: <1574130708-30767-1-git-send-email-tanhuazhong@huawei.com>
 <20191119.153603.2158592594523337284.davem@davemloft.net>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <707be979-7716-5669-ad91-ff0fdbcc101d@huawei.com>
Date:   Wed, 20 Nov 2019 09:36:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20191119.153603.2158592594523337284.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/11/20 7:36, David Miller wrote:
> From: Huazhong Tan <tanhuazhong@huawei.com>
> Date: Tue, 19 Nov 2019 10:31:48 +0800
> 
>> According to hardware user manual, bits5~7 in register
>> HCLGE_MISC_VECTOR_INT_STS means reset interrupts status,
>> but HCLGE_RESET_INT_M is defined as bits0~2 now. So it
>> will make hclge_reset_err_handle() read the wrong reset
>> interrupt status.
>>
>> This patch fixes it and prints out the register value.
>>
>> Fixes: 2336f19d7892 ("net: hns3: check reset interrupt status when reset fails")
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> Fix exactly _one_ thing or else you make your patch hard to review.
> 
> The bug is that the bits are wrong, just fix the bits!
> 

ok, thanks

>>   
>> +	u32 msix_sts_reg;
>> +
>> +	msix_sts_reg = hclge_read_dev(&hdev->hw, HCLGE_MISC_VECTOR_INT_STS);
>> +
>>   	if (hdev->reset_pending) {
> 
> Now you are reading a register, and potentially clearing status bits and
> causing other side effects, that would not happen in this code path
> where hdev->reset_pending is true.
> 
> Don't do stuff like this!
> 
> If you want to add code to print out the register value, that is a
> separate patch, for net-next, and it must be done properly.  In that
> you should only read the register in the same code paths you do
> previously.   Otherwise you must _clearly_ explain why reading the
> register value in new code paths is OK, and the side effects will
> not potentially cause problems for the pending reset operation.  It
> is still going to be a net-next improvement only.
> 
> Thank you.

I will separate it, and resend the fix to -net.
Thanks.

> 
> .
> 

