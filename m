Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A503B040D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 14:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhFVMSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 08:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230393AbhFVMSw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 08:18:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8105B60C41;
        Tue, 22 Jun 2021 12:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624364196;
        bh=mNyb/gADrHsQToqWpHLZJITn6vzAF50b6ulNT3tHuRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zz/3delKwa2AtnTGh5TDwEROCk8xxj1lB762qpjwekZSo/UXEOPMzz5clP6/QCTCi
         JRQR8Hs6AdHN0W4/24bSGIjQ4EtjQDwte+vKOSVgYkN408R4H+SL50vk9qlwsC3kK/
         PzU4/fc+V6IGIqpkikNYnDW0d8+tX663J6DqyD8kMCejYy5diLi2aKqldM2/5CTtAO
         CiPTVHzBk8TyDMPV8X6/UQx3GKEA63iPXB2EoNjxfiaEQWvcAY8EhvxH1roHTjeb8j
         Fys3Al/tnBF1HeX6LuSIJCcbM0i/oSNOBC04ASdfX7OR4h9x1O5d1wo0mIpoxBfVUx
         sd0xCo8GyO47Q==
Date:   Tue, 22 Jun 2021 13:16:31 +0100
From:   Will Deacon <will@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, catalin.marinas@arm.com,
        maz@kernel.org, mark.rutland@arm.com, dbrazdil@google.com,
        qperret@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lipeng321@huawei.com, peterz@infradead.org
Subject: Re: [PATCH net-next 1/3] arm64: barrier: add DGH macros to control
 memory accesses merging
Message-ID: <20210622121630.GC30757@willie-the-truck>
References: <1624360271-17525-1-git-send-email-huangguangbin2@huawei.com>
 <1624360271-17525-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1624360271-17525-2-git-send-email-huangguangbin2@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 07:11:09PM +0800, Guangbin Huang wrote:
> From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> 
> DGH prohibits merging memory accesses with Normal-NC or Device-GRE
> attributes before the hint instruction with any memory accesses
> appearing after the hint instruction. Provide macros to expose it to the
> arch code.

Hmm.

The architecture states:

  | DGH is a hint instruction. A DGH instruction is not expected to be
  | performance optimal to merge memory accesses with Normal Non-cacheable
  | or Device-GRE attributes appearing in program order before the hint
  | instruction with any memory accesses appearing after the hint instruction
  | into a single memory transaction on an interconnect.

which doesn't make a whole lot of sense to me, in all honesty.

> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> Signed-off-by: Cheng Jian <cj.chengjian@huawei.com>
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> ---
>  arch/arm64/include/asm/assembler.h | 7 +++++++
>  arch/arm64/include/asm/barrier.h   | 1 +
>  2 files changed, 8 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index 8418c1bd8f04..d723899328bd 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -90,6 +90,13 @@
>  	.endm
>  
>  /*
> + * Data gathering hint
> + */
> +	.macro	dgh
> +	hint	#6
> +	.endm
> +
> +/*
>   * RAS Error Synchronization barrier
>   */
>  	.macro  esb
> diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
> index 451e11e5fd23..02e1735706d2 100644
> --- a/arch/arm64/include/asm/barrier.h
> +++ b/arch/arm64/include/asm/barrier.h
> @@ -22,6 +22,7 @@
>  #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
>  #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
>  
> +#define dgh()		asm volatile("hint #6" : : : "memory")

Although I'm fine with this in arm64, I don't think this is the interface
which drivers should be using. Instead, once we know what this instruction
is supposed to do, we should look at exposing it as part of the I/O barriers
and providing a NOP implementation for other architectures. That way,
drivers can use it without having to have the #ifdef CONFIG_ARM64 stuff that
you have in the later patches here.

Will
