Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A01BF696C57
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 19:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbjBNSG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 13:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjBNSG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 13:06:56 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681662F7B8;
        Tue, 14 Feb 2023 10:06:55 -0800 (PST)
Received: from [192.168.1.90] (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 6B8E866020A4;
        Tue, 14 Feb 2023 18:06:52 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676398013;
        bh=ft8PH/ZqA6nSgApIqin+YnV9fYbavSwte6N7D71qPzY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Tw/5LqZEgofQMm+jUdg1ofHxTTLysSEGiKAK2I5nemTdfdb+gbMdIoqHQBC2up2c7
         IQURtYbXkNEgW3EWE5RDCRXlmI7GZ2+JnuRafMUmhIk+Fl9XrDoypvR7x5Q3xnfQKs
         Tz/AAOZS9L/NcQKckHwdb5WWXm+Q6W3OWUX6SQJ9tT9dWaUr83u0WMhVowSq1cIuJU
         2m3NmAatl/MPmyhMUBiG3WbjrJmCeth69VFTvcV17fZHQylzNJDnBjv26rwQ5qGzPP
         CRTqFqSfedTHbhAElWszPSsMja6HWQypl72R+5CRptn6hKxBjpbQQqimgz6IM5yC7x
         9hoBu6favdwZA==
Message-ID: <3256853a-d744-4a41-41b6-752b5c95eedc@collabora.com>
Date:   Tue, 14 Feb 2023 20:06:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 05/12] riscv: Implement non-coherent DMA support via
 SiFive cache flushing
Content-Language: en-US
To:     Ben Dooks <ben.dooks@codethink.co.uk>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-6-cristian.ciocaltea@collabora.com>
 <f1a6c357-b7e0-2869-72e0-e850b63e6ca9@codethink.co.uk>
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
In-Reply-To: <f1a6c357-b7e0-2869-72e0-e850b63e6ca9@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/13/23 10:30, Ben Dooks wrote:
> On 11/02/2023 03:18, Cristian Ciocaltea wrote:
>> From: Emil Renner Berthing <kernel@esmil.dk>
>>
>> This variant is used on the StarFive JH7100 SoC.
>>
>> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
>> ---
>>   arch/riscv/Kconfig              |  6 ++++--
>>   arch/riscv/mm/dma-noncoherent.c | 37 +++++++++++++++++++++++++++++++--
>>   2 files changed, 39 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>> index 9c687da7756d..05f6c77faf6f 100644
>> --- a/arch/riscv/Kconfig
>> +++ b/arch/riscv/Kconfig
>> @@ -232,12 +232,14 @@ config LOCKDEP_SUPPORT
>>       def_bool y
>>   config RISCV_DMA_NONCOHERENT
>> -    bool
>> +    bool "Support non-coherent DMA"
>> +    default SOC_STARFIVE
>>       select ARCH_HAS_DMA_PREP_COHERENT
>> +    select ARCH_HAS_DMA_SET_UNCACHED
>> +    select ARCH_HAS_DMA_CLEAR_UNCACHED
>>       select ARCH_HAS_SYNC_DMA_FOR_DEVICE
>>       select ARCH_HAS_SYNC_DMA_FOR_CPU
>>       select ARCH_HAS_SETUP_DMA_OPS
>> -    select DMA_DIRECT_REMAP
>>   config AS_HAS_INSN
>>       def_bool $(as-instr,.insn r 51$(comma) 0$(comma) 0$(comma) 
>> t0$(comma) t0$(comma) zero)
>> diff --git a/arch/riscv/mm/dma-noncoherent.c 
>> b/arch/riscv/mm/dma-noncoherent.c
>> index d919efab6eba..e07e53aea537 100644
>> --- a/arch/riscv/mm/dma-noncoherent.c
>> +++ b/arch/riscv/mm/dma-noncoherent.c
>> @@ -9,14 +9,21 @@
>>   #include <linux/dma-map-ops.h>
>>   #include <linux/mm.h>
>>   #include <asm/cacheflush.h>
>> +#include <soc/sifive/sifive_ccache.h>
>>   static bool noncoherent_supported;
>>   void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
>>                     enum dma_data_direction dir)
>>   {
>> -    void *vaddr = phys_to_virt(paddr);
>> +    void *vaddr;
>> +    if (sifive_ccache_handle_noncoherent()) {
>> +        sifive_ccache_flush_range(paddr, size);
>> +        return;
>> +    }
>> +
>> +    vaddr = phys_to_virt(paddr);
>>       switch (dir) {
>>       case DMA_TO_DEVICE:
>>           ALT_CMO_OP(clean, vaddr, size, riscv_cbom_block_size);
>> @@ -35,8 +42,14 @@ void arch_sync_dma_for_device(phys_addr_t paddr, 
>> size_t size,
>>   void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
>>                  enum dma_data_direction dir)
>>   {
>> -    void *vaddr = phys_to_virt(paddr);
>> +    void *vaddr;
>> +
>> +    if (sifive_ccache_handle_noncoherent()) {
>> +        sifive_ccache_flush_range(paddr, size);
>> +        return;
>> +    }
> 
> ok, what happens if we have an system where the ccache and another level
> of cache also requires maintenance operations?

According to [1], the handling of non-coherent DMA on RISC-V is 
currently being worked on, so I will respin the series as soon as the 
proper support arrives.

[1] https://lore.kernel.org/lkml/Y+d36nz0xdfXmDI1@spud/


>> +    vaddr = phys_to_virt(paddr);
>>       switch (dir) {
>>       case DMA_TO_DEVICE:
>>           break;
>> @@ -49,10 +62,30 @@ void arch_sync_dma_for_cpu(phys_addr_t paddr, 
>> size_t size,
>>       }
>>   }
>> +void *arch_dma_set_uncached(void *addr, size_t size)
>> +{
>> +    if (sifive_ccache_handle_noncoherent())
>> +        return sifive_ccache_set_uncached(addr, size);
>> +
>> +    return addr;
>> +}
>> +
>> +void arch_dma_clear_uncached(void *addr, size_t size)
>> +{
>> +    if (sifive_ccache_handle_noncoherent())
>> +        sifive_ccache_clear_uncached(addr, size);
>> +}
>> +
>>   void arch_dma_prep_coherent(struct page *page, size_t size)
>>   {
>>       void *flush_addr = page_address(page);
>> +    if (sifive_ccache_handle_noncoherent()) {
>> +        memset(flush_addr, 0, size);
>> +        sifive_ccache_flush_range(__pa(flush_addr), size);
>> +        return;
>> +    }
>> +
>>       ALT_CMO_OP(flush, flush_addr, size, riscv_cbom_block_size);
>>   }
> 
