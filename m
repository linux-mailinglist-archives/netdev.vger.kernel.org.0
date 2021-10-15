Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A74442E63F
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 03:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbhJOBu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 21:50:26 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14354 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhJOBuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 21:50:25 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HVpvL2hJpz903c;
        Fri, 15 Oct 2021 09:43:26 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 15 Oct 2021 09:48:17 +0800
Received: from [10.174.179.5] (10.174.179.5) by dggpemm500002.china.huawei.com
 (7.185.36.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 15 Oct
 2021 09:48:17 +0800
Subject: Re: Re: [PATCH net-next 2/4] io: add function to flush the write
 combine buffer to device immediately
To:     Will Deacon <will@kernel.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <catalin.marinas@arm.com>, <maz@kernel.org>,
        <mark.rutland@arm.com>, <dbrazdil@google.com>,
        <qperret@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <lipeng321@huawei.com>,
        <peterz@infradead.org>
References: <1627614864-50824-1-git-send-email-huangguangbin2@huawei.com>
 <1627614864-50824-3-git-send-email-huangguangbin2@huawei.com>
 <20210730090056.GA22968@willie-the-truck>
From:   Xiongfeng Wang <wangxiongfeng2@huawei.com>
Message-ID: <d5f6f22b-3426-a114-cb76-97019ae44c97@huawei.com>
Date:   Fri, 15 Oct 2021 09:48:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20210730090056.GA22968@willie-the-truck>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.5]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Will

On 2021/7/30 17:00, Will Deacon wrote:
> Hi,
> 
> On Fri, Jul 30, 2021 at 11:14:22AM +0800, Guangbin Huang wrote:
>> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
>>
>> Device registers can be mapped as write-combine type. In this case, data
>> are not written into the device immediately. They are temporarily stored
>> in the write combine buffer and written into the device when the buffer
>> is full. But in some situation, we need to flush the write combine
>> buffer to device immediately for better performance. So we add a general
>> function called 'flush_wc_write()'. We use DGH instruction to implement
>> this function for ARM64.
>>
>> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>  arch/arm64/include/asm/io.h | 2 ++
>>  include/linux/io.h          | 6 ++++++
>>  2 files changed, 8 insertions(+)
> 
> -ENODOCUMENTATION
> 
>> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
>> index 7fd836bea7eb..5315d023b2dd 100644
>> --- a/arch/arm64/include/asm/io.h
>> +++ b/arch/arm64/include/asm/io.h
>> @@ -112,6 +112,8 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
>>  #define __iowmb()		dma_wmb()
>>  #define __iomb()		dma_mb()
>>  
>> +#define flush_wc_write()	dgh()
> 
> I think it would be worthwhile to look at what architectures other than
> arm64 offer here. For example, is there anything similar to this on riscv,
> x86 or power? Doing a quick survery of what's out there might help us define
> a macro that can be used across multiple architectures.

I searched in 'barrier.h' of different architectures and didn't find similar
merge preventing instructions. Could you give me some advice on naming this
common interface ?

Thanks,
Xiongfeng

> 
> Thanks,
> 
> Will
> 
>>  /*
>>   * Relaxed I/O memory access primitives. These follow the Device memory
>>   * ordering rules but do not guarantee any ordering relative to Normal memory
>> diff --git a/include/linux/io.h b/include/linux/io.h
>> index 9595151d800d..469d53444218 100644
>> --- a/include/linux/io.h
>> +++ b/include/linux/io.h
>> @@ -166,4 +166,10 @@ static inline void arch_io_free_memtype_wc(resource_size_t base,
>>  }
>>  #endif
>>  
>> +/* IO barriers */
>> +
>> +#ifndef flush_wc_write
>> +#define flush_wc_write()		do { } while (0)
>> +#endif
>> +
>>  #endif /* _LINUX_IO_H */
>> -- 
>> 2.8.1
>>
> .
> 
