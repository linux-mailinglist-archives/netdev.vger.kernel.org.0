Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2BF1C80BE
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 06:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgEGEKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 00:10:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3875 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbgEGEKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 00:10:38 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5E42A59B51338C268F28;
        Thu,  7 May 2020 12:10:33 +0800 (CST)
Received: from [127.0.0.1] (10.166.212.180) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 7 May 2020
 12:10:28 +0800
Subject: Re: [PATCH -next] iwlwifi: pcie: Use bitwise instead of arithmetic
 operator for flags
To:     Joe Perches <joe@perches.com>,
        Luciano Coelho <luciano.coelho@intel.com>,
        <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <linuxwifi@intel.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, "Julia Lawall" <julia.lawall@lip6.fr>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, cocci <cocci@systeme.lip6.fr>
References: <1588734423-33988-1-git-send-email-zou_wei@huawei.com>
 <f8b258e0c8bb073c445090e637195df2fc989543.camel@perches.com>
 <bfd6b3a7db0c50cd3d084510bd43c9e540688edd.camel@intel.com>
 <2208e464cd8bd399cfb9b49abb5aed211f27b3a8.camel@perches.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <8431ed30-b9c7-e91b-e6e6-2afd03dde360@huawei.com>
Date:   Thu, 7 May 2020 12:10:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2208e464cd8bd399cfb9b49abb5aed211f27b3a8.camel@perches.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.212.180]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both of you are right.
I neglected, and this patch is wrong.

Thanks.

On 2020/5/6 23:15, Joe Perches wrote:
> On Wed, 2020-05-06 at 16:51 +0300, Luciano Coelho wrote:
>> On Tue, 2020-05-05 at 20:19 -0700, Joe Perches wrote:
>>> On Wed, 2020-05-06 at 11:07 +0800, Samuel Zou wrote:
>>>> This silences the following coccinelle warning:
>>>>
>>>> "WARNING: sum of probable bitmasks, consider |"
>>>
>>> I suggest instead ignoring bad and irrelevant warnings.
>>>
>>> PREFIX_LEN is 32 not 0x20 or BIT(5)
>>> PCI_DUMP_SIZE is 352
>>>
>>>> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
>>> []
>>>> @@ -109,9 +109,9 @@ void iwl_trans_pcie_dump_regs(struct iwl_trans *trans)
>>>>   
>>>>   	/* Alloc a max size buffer */
>>>>   	alloc_size = PCI_ERR_ROOT_ERR_SRC +  4 + PREFIX_LEN;
>>>> -	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE + PREFIX_LEN);
>>>> -	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE + PREFIX_LEN);
>>>> -	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE + PREFIX_LEN);
>>>> +	alloc_size = max_t(u32, alloc_size, PCI_DUMP_SIZE | PREFIX_LEN);
>>>> +	alloc_size = max_t(u32, alloc_size, PCI_MEM_DUMP_SIZE | PREFIX_LEN);
>>>> +	alloc_size = max_t(u32, alloc_size, PCI_PARENT_DUMP_SIZE | PREFIX_LEN);
>>>>   
>>>>   	buf = kmalloc(alloc_size, GFP_ATOMIC);
>>>>   	if (!buf)
>>
>> Yeah, those macros are clearly not bitmasks.  I'm dropping this patch.
> 
> Can the cocci script that generated this warning
> 
> scripts/coccinelle/misc/orplus.cocci
> 
> be dropped or improved to validate the likelihood that
> the defines or constants used are more likely than
> not are bit values?
> 
> Maybe these should be defined as hex or BIT or BIT_ULL
> or GENMASK or the like?
> 
> 
> Right now it seems it just tests for two constants.
> 
> 
> 
> .
> 

