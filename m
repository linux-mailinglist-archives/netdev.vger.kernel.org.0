Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63A869425F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 11:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjBMKLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 05:11:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjBMKLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 05:11:18 -0500
X-Greylist: delayed 1817 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Feb 2023 02:11:17 PST
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262E0E387;
        Mon, 13 Feb 2023 02:11:17 -0800 (PST)
Received: from [167.98.27.226] (helo=[172.16.101.148])
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1pRUEB-002EmZ-C6; Mon, 13 Feb 2023 08:30:23 +0000
Message-ID: <f1a6c357-b7e0-2869-72e0-e850b63e6ca9@codethink.co.uk>
Date:   Mon, 13 Feb 2023 08:30:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 05/12] riscv: Implement non-coherent DMA support via
 SiFive cache flushing
Content-Language: en-GB
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
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
From:   Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <20230211031821.976408-6-cristian.ciocaltea@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/02/2023 03:18, Cristian Ciocaltea wrote:
> From: Emil Renner Berthing <kernel@esmil.dk>
> 
> This variant is used on the StarFive JH7100 SoC.
> 
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> ---
>   arch/riscv/Kconfig              |  6 ++++--
>   arch/riscv/mm/dma-noncoherent.c | 37 +++++++++++++++++++++++++++++++--
>   2 files changed, 39 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 9c687da7756d..05f6c77faf6f 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -232,12 +232,14 @@ config LOCKDEP_SUPPORT
>   	def_bool y
>   
>   config RISCV_DMA_NONCOHERENT
> -	bool
> +	bool "Support non-coherent DMA"
> +	default SOC_STARFIVE
>   	select ARCH_HAS_DMA_PREP_COHERENT
> +	select ARCH_HAS_DMA_SET_UNCACHED
> +	select ARCH_HAS_DMA_CLEAR_UNCACHED
>   	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
>   	select ARCH_HAS_SYNC_DMA_FOR_CPU
>   	select ARCH_HAS_SETUP_DMA_OPS
> -	select DMA_DIRECT_REMAP
>   
>   config AS_HAS_INSN
>   	def_bool $(as-instr,.insn r 51$(comma) 0$(comma) 0$(comma) t0$(comma) t0$(comma) zero)
> diff --git a/arch/riscv/mm/dma-noncoherent.c b/arch/riscv/mm/dma-noncoherent.c
> index d919efab6eba..e07e53aea537 100644
> --- a/arch/riscv/mm/dma-noncoherent.c
> +++ b/arch/riscv/mm/dma-noncoherent.c
> @@ -9,14 +9,21 @@
>   #include <linux/dma-map-ops.h>
>   #include <linux/mm.h>
>   #include <asm/cacheflush.h>
> +#include <soc/sifive/sifive_ccache.h>
>   
>   static bool noncoherent_supported;
>   
>   void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
>   			      enum dma_data_direction dir)
>   {
> -	void *vaddr = phys_to_virt(paddr);
> +	void *vaddr;
>   
> +	if (sifive_ccache_handle_noncoherent()) {
> +		sifive_ccache_flush_range(paddr, size);
> +		return;
> +	}
> +
> +	vaddr = phys_to_virt(paddr);
>   	switch (dir) {
>   	case DMA_TO_DEVICE:
>   		ALT_CMO_OP(clean, vaddr, size, riscv_cbom_block_size);
> @@ -35,8 +42,14 @@ void arch_sync_dma_for_device(phys_addr_t paddr, size_t size,
>   void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
>   			   enum dma_data_direction dir)
>   {
> -	void *vaddr = phys_to_virt(paddr);
> +	void *vaddr;
> +
> +	if (sifive_ccache_handle_noncoherent()) {
> +		sifive_ccache_flush_range(paddr, size);
> +		return;
> +	}

ok, what happens if we have an system where the ccache and another level
of cache also requires maintenance operations?

>   
> +	vaddr = phys_to_virt(paddr);
>   	switch (dir) {
>   	case DMA_TO_DEVICE:
>   		break;
> @@ -49,10 +62,30 @@ void arch_sync_dma_for_cpu(phys_addr_t paddr, size_t size,
>   	}
>   }
>   
> +void *arch_dma_set_uncached(void *addr, size_t size)
> +{
> +	if (sifive_ccache_handle_noncoherent())
> +		return sifive_ccache_set_uncached(addr, size);
> +
> +	return addr;
> +}
> +
> +void arch_dma_clear_uncached(void *addr, size_t size)
> +{
> +	if (sifive_ccache_handle_noncoherent())
> +		sifive_ccache_clear_uncached(addr, size);
> +}
> +
>   void arch_dma_prep_coherent(struct page *page, size_t size)
>   {
>   	void *flush_addr = page_address(page);
>   
> +	if (sifive_ccache_handle_noncoherent()) {
> +		memset(flush_addr, 0, size);
> +		sifive_ccache_flush_range(__pa(flush_addr), size);
> +		return;
> +	}
> +
>   	ALT_CMO_OP(flush, flush_addr, size, riscv_cbom_block_size);
>   }
>   

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

