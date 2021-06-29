Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B84E3B7127
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 13:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbhF2LOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 07:14:07 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:9297 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbhF2LOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 07:14:05 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GDhVZ36TVz1BSN7;
        Tue, 29 Jun 2021 19:06:14 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 29 Jun 2021 19:11:32 +0800
Received: from [10.174.179.5] (10.174.179.5) by dggpemm500002.china.huawei.com
 (7.185.36.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 29 Jun
 2021 19:11:31 +0800
Subject: Re: [PATCH net-next 1/3] arm64: barrier: add DGH macros to control
 memory accesses merging
To:     Will Deacon <will@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <catalin.marinas@arm.com>, <maz@kernel.org>,
        <mark.rutland@arm.com>, <dbrazdil@google.com>,
        <qperret@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <lipeng321@huawei.com>,
        <peterz@infradead.org>
References: <1624360271-17525-1-git-send-email-huangguangbin2@huawei.com>
 <1624360271-17525-2-git-send-email-huangguangbin2@huawei.com>
 <20210622121630.GC30757@willie-the-truck>
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
Message-ID: <0c8f931b-9da8-ffb0-4b7c-7d291e9af8aa@huawei.com>
Date:   Tue, 29 Jun 2021 19:11:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20210622121630.GC30757@willie-the-truck>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.5]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will,

On 2021/6/22 20:16, Will Deacon wrote:
> On Tue, Jun 22, 2021 at 07:11:09PM +0800, Guangbin Huang wrote:
>> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
>>
>> DGH prohibits merging memory accesses with Normal-NC or Device-GRE
>> attributes before the hint instruction with any memory accesses
>> appearing after the hint instruction. Provide macros to expose it to the
>> arch code.
> 
> Hmm.
> 
> The architecture states:
> 
>   | DGH is a hint instruction. A DGH instruction is not expected to be
>   | performance optimal to merge memory accesses with Normal Non-cacheable
>   | or Device-GRE attributes appearing in program order before the hint
>   | instruction with any memory accesses appearing after the hint instruction
>   | into a single memory transaction on an interconnect.
> 
> which doesn't make a whole lot of sense to me, in all honesty.
> 
>> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
>> Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
>> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
>> ---
>>  arch/arm64/include/asm/assembler.h | 7 +++++++
>>  arch/arm64/include/asm/barrier.h   | 1 +
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
>> index 8418c1bd8f04..d723899328bd 100644
>> --- a/arch/arm64/include/asm/assembler.h
>> +++ b/arch/arm64/include/asm/assembler.h
>> @@ -90,6 +90,13 @@
>>  	.endm
>>  
>>  /*
>> + * Data gathering hint
>> + */
>> +	.macro	dgh
>> +	hint	#6
>> +	.endm
>> +
>> +/*
>>   * RAS Error Synchronization barrier
>>   */
>>  	.macro  esb
>> diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
>> index 451e11e5fd23..02e1735706d2 100644
>> --- a/arch/arm64/include/asm/barrier.h
>> +++ b/arch/arm64/include/asm/barrier.h
>> @@ -22,6 +22,7 @@
>>  #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
>>  #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
>>  
>> +#define dgh()		asm volatile("hint #6" : : : "memory")
> 
> Although I'm fine with this in arm64, I don't think this is the interface
> which drivers should be using. Instead, once we know what this instruction
> is supposed to do, we should look at exposing it as part of the I/O barriers
> and providing a NOP implementation for other architectures. That way,
> drivers can use it without having to have the #ifdef CONFIG_ARM64 stuff that
> you have in the later patches here.

How about we adding a interface called flush_wc_writeX(), which can be used to
flush the write-combined buffers to the device immediately.
I found it has been disscussed in the below link, but it is unnessary in their
situation.
https://patchwork.ozlabs.org/project/netdev/patch/20200102180830.66676-3-liran.alon@oracle.com/

Thanks,
Xiongfeng

> 
> Will
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> .
> 
