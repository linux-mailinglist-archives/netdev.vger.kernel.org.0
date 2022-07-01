Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B2D563CBF
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 01:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiGAXU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 19:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiGAXU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 19:20:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F1071BCF;
        Fri,  1 Jul 2022 16:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8B/HM3ptEJgCCgROywH5nKBQG04ILNP2c9THBpwMy1E=; b=qiyDwZOkrvOmJOoe2FwDFbTzFM
        K/d9ILfyE80Adsq2huKQqv752UIZTaV+hTXUS//Gcquo/ncQJr6sXzLf+OauLpeLiNkd268e3kkq6
        uk3l6mgAFRcLLg5WVDcGJtO5DvfjaNgQ6CMhTzlQoZ/c+YzFruH6viS5XgXK+A23UW9jfL6ifivfA
        oZs6oECzIgv/RuYmuJ9eRXH0ySFS5uCcQYKLA22Plhr5AKVsyKOTE0dcplyb2aNcA8bjuZ+gp1e20
        e07JtJcocOG0f0dJ8nMOUPv/o/W/06KI9Eg8bd9GUE11LyOXOu0LgvQ38HTVZeWVdLuc3uubuQqZ3
        7Rk2xVVg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o7PwV-007P44-2w; Fri, 01 Jul 2022 23:20:55 +0000
Date:   Fri, 1 Jul 2022 16:20:55 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        x86@vger.kernel.org, dave.hansen@linux.intel.com,
        rick.p.edgecombe@intel.com, kernel-team@fb.com,
        daniel@iogearbox.net
Subject: Re: [PATCH v5 bpf-next 1/5] module: introduce module_alloc_huge
Message-ID: <Yr+BV+HLZikpCU42@bombadil.infradead.org>
References: <20220624215712.3050672-1-song@kernel.org>
 <20220624215712.3050672-2-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624215712.3050672-2-song@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 02:57:08PM -0700, Song Liu wrote:
> Introduce module_alloc_huge, which allocates huge page backed memory in
> module memory space. The primary user of this memory is bpf_prog_pack
> (multiple BPF programs sharing a huge page).
> 
> Signed-off-by: Song Liu <song@kernel.org>

I see mm not Cc'd. I'd like review from them.

> ---
>  arch/x86/kernel/module.c     | 21 +++++++++++++++++++++
>  include/linux/moduleloader.h |  5 +++++
>  kernel/module/main.c         |  8 ++++++++
>  3 files changed, 34 insertions(+)
> 
> diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
> index b98ffcf4d250..63f6a16c70dc 100644
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -86,6 +86,27 @@ void *module_alloc(unsigned long size)
>  	return p;
>  }
>  
> +void *module_alloc_huge(unsigned long size)
> +{
> +	gfp_t gfp_mask = GFP_KERNEL;
> +	void *p;
> +
> +	if (PAGE_ALIGN(size) > MODULES_LEN)
> +		return NULL;
> +
> +	p = __vmalloc_node_range(size, MODULE_ALIGN,
> +				 MODULES_VADDR + get_module_load_offset(),
> +				 MODULES_END, gfp_mask, PAGE_KERNEL,
> +				 VM_DEFER_KMEMLEAK | VM_ALLOW_HUGE_VMAP,
> +				 NUMA_NO_NODE, __builtin_return_address(0));
> +	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
> +		vfree(p);
> +		return NULL;
> +	}
> +
> +	return p;
> +}

1) When things like kernel/bpf/core.c start using a module alloc it
   is time to consider genearlizing this.

2) How we free is important, and each arch does something funky for
   this. This is not addressed here.

And yes I welcome generalizing generic module_alloc() too as suggested
before. The concern on my part is the sloppiness this enables.

  Luis

> +
>  #ifdef CONFIG_X86_32
>  int apply_relocate(Elf32_Shdr *sechdrs,
>  		   const char *strtab,
> diff --git a/include/linux/moduleloader.h b/include/linux/moduleloader.h
> index 9e09d11ffe5b..d34743a88938 100644
> --- a/include/linux/moduleloader.h
> +++ b/include/linux/moduleloader.h
> @@ -26,6 +26,11 @@ unsigned int arch_mod_section_prepend(struct module *mod, unsigned int section);
>     sections.  Returns NULL on failure. */
>  void *module_alloc(unsigned long size);
>  
> +/* Allocator used for allocating memory in module memory space. If size is
> + * greater than PMD_SIZE, allow using huge pages. Returns NULL on failure.
> + */
> +void *module_alloc_huge(unsigned long size);
> +
>  /* Free memory returned from module_alloc. */
>  void module_memfree(void *module_region);
>  
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index fed58d30725d..349b2a8bd20f 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -1613,6 +1613,14 @@ void * __weak module_alloc(unsigned long size)
>  			NUMA_NO_NODE, __builtin_return_address(0));
>  }
>  
> +void * __weak module_alloc_huge(unsigned long size)
> +{
> +	return __vmalloc_node_range(size, 1, VMALLOC_START, VMALLOC_END,
> +				    GFP_KERNEL, PAGE_KERNEL_EXEC,
> +				    VM_FLUSH_RESET_PERMS | VM_ALLOW_HUGE_VMAP,
> +				    NUMA_NO_NODE, __builtin_return_address(0));
> +}
> +
>  bool __weak module_init_section(const char *name)
>  {
>  	return strstarts(name, ".init");
> -- 
> 2.30.2
> 
