Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7A03DB594
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 11:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbhG3JBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 05:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230436AbhG3JBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 05:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DB2060EBC;
        Fri, 30 Jul 2021 09:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627635663;
        bh=ZqUXtxocwsf9OoFzcWmFz4ZMIgWoSvnVSWDE/K9rjYc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gsqow/fRGqYWqMYX/Gxs1k8QH2DDnJhaEknI7ikudaKF79bQeRYbdBKX/y+Mf5U9a
         SmNghxm3s85lGNm1JT8JzX/97KQfutuYcRP3dWPWgeturv3mBMm2ITqaVIqCPS2upt
         0baXwj7mBSJn1cZ3BDfMzMwcm8a3N3gY4OTRRjMylvYV/FhhuPrOtNgAR9kUjPEf9m
         CxaeCVfc+UoWO8f3dIM9qUgF3N8tWBPScbMURa3nrgq//bd+oSsV5J4+dDdtmb2/By
         g3CJvntp4P8ghwPpj5f12ShjzM8r2UfqWXMOQtHI9VYcwki3kCQNcdjnf5wauDAzsM
         Kxv8PJ68drXeA==
Date:   Fri, 30 Jul 2021 10:00:57 +0100
From:   Will Deacon <will@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, catalin.marinas@arm.com,
        maz@kernel.org, mark.rutland@arm.com, dbrazdil@google.com,
        qperret@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lipeng321@huawei.com, peterz@infradead.org
Subject: Re: [PATCH net-next 2/4] io: add function to flush the write combine
 buffer to device immediately
Message-ID: <20210730090056.GA22968@willie-the-truck>
References: <1627614864-50824-1-git-send-email-huangguangbin2@huawei.com>
 <1627614864-50824-3-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627614864-50824-3-git-send-email-huangguangbin2@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Jul 30, 2021 at 11:14:22AM +0800, Guangbin Huang wrote:
> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> 
> Device registers can be mapped as write-combine type. In this case, data
> are not written into the device immediately. They are temporarily stored
> in the write combine buffer and written into the device when the buffer
> is full. But in some situation, we need to flush the write combine
> buffer to device immediately for better performance. So we add a general
> function called 'flush_wc_write()'. We use DGH instruction to implement
> this function for ARM64.
> 
> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  arch/arm64/include/asm/io.h | 2 ++
>  include/linux/io.h          | 6 ++++++
>  2 files changed, 8 insertions(+)

-ENODOCUMENTATION

> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 7fd836bea7eb..5315d023b2dd 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -112,6 +112,8 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
>  #define __iowmb()		dma_wmb()
>  #define __iomb()		dma_mb()
>  
> +#define flush_wc_write()	dgh()

I think it would be worthwhile to look at what architectures other than
arm64 offer here. For example, is there anything similar to this on riscv,
x86 or power? Doing a quick survery of what's out there might help us define
a macro that can be used across multiple architectures.

Thanks,

Will

>  /*
>   * Relaxed I/O memory access primitives. These follow the Device memory
>   * ordering rules but do not guarantee any ordering relative to Normal memory
> diff --git a/include/linux/io.h b/include/linux/io.h
> index 9595151d800d..469d53444218 100644
> --- a/include/linux/io.h
> +++ b/include/linux/io.h
> @@ -166,4 +166,10 @@ static inline void arch_io_free_memtype_wc(resource_size_t base,
>  }
>  #endif
>  
> +/* IO barriers */
> +
> +#ifndef flush_wc_write
> +#define flush_wc_write()		do { } while (0)
> +#endif
> +
>  #endif /* _LINUX_IO_H */
> -- 
> 2.8.1
> 
