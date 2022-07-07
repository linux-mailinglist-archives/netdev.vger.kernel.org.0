Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887B356AC90
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 22:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbiGGULp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 16:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiGGULo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 16:11:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A6ECE9;
        Thu,  7 Jul 2022 13:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YvxVbi0s8pdES8Ig1gSBYhIVsLmPB4xtFIWqaVBPjdc=; b=BMPjaWOnqsQRsLxJ8XGws3zvDd
        RhhCBijfg3pyR660vMVQgjveB3wrPXHfrtcK/WhychCeHPT7axZxzeepRb9v2Ahm/H8C4z4Co3xau
        /aUM7EGC//W6yq3U14JH6zc/bSRcqTg0YCe5ACYS9NMiuvVKu0btDKW511kIu35ammzENIt/Td45T
        Z/ZlTDUBYl7KFbXabCmX8r0feHweSpO3s9Vyx9DUFoUaYhsDCDM5FoNXJEvd6tGOd4kGSV5GVbDKS
        0fJquinBuJhKW2g9rU40MS5/hcU9l7BdT8Ead/wJDuA3Rhnjj4VPPrOPDpf1Ry9RSyxoVMKB4C6Pa
        lWzZsblw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o9Xqc-0005C6-Jz; Thu, 07 Jul 2022 20:11:38 +0000
Date:   Thu, 7 Jul 2022 13:11:38 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Song Liu <song@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@vger.kernel.org" <x86@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        Kernel Team <Kernel-team@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH v5 bpf-next 1/5] module: introduce module_alloc_huge
Message-ID: <Ysc9+r2R6WKMIa3i@bombadil.infradead.org>
References: <20220624215712.3050672-1-song@kernel.org>
 <20220624215712.3050672-2-song@kernel.org>
 <Yr+BV+HLZikpCU42@bombadil.infradead.org>
 <16959523-ABD1-4D2B-B249-118DDADD7976@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16959523-ABD1-4D2B-B249-118DDADD7976@fb.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 04:39:13AM +0000, Song Liu wrote:
> > On Jul 1, 2022, at 4:20 PM, Luis Chamberlain <mcgrof@kernel.org> wrote:
> > On Fri, Jun 24, 2022 at 02:57:08PM -0700, Song Liu wrote:
> >> +void *module_alloc_huge(unsigned long size)
> >> +{
> >> +	gfp_t gfp_mask = GFP_KERNEL;
> >> +	void *p;
> >> +
> >> +	if (PAGE_ALIGN(size) > MODULES_LEN)
> >> +		return NULL;
> >> +
> >> +	p = __vmalloc_node_range(size, MODULE_ALIGN,
> >> +				 MODULES_VADDR + get_module_load_offset(),
> >> +				 MODULES_END, gfp_mask, PAGE_KERNEL,
> >> +				 VM_DEFER_KMEMLEAK | VM_ALLOW_HUGE_VMAP,
> >> +				 NUMA_NO_NODE, __builtin_return_address(0));
> >> +	if (p && (kasan_alloc_module_shadow(p, size, gfp_mask) < 0)) {
> >> +		vfree(p);
> >> +		return NULL;
> >> +	}
> >> +
> >> +	return p;
> >> +}
> > 
> > 1) When things like kernel/bpf/core.c start using a module alloc it
> > is time to consider genearlizing this.
> 
> I am not quite sure what the generalization would look like. IMHO, the
> ideal case would have:
>   a) A kernel_text_rw_allocator, similar to current module_alloc.
>   b) A kernel_text_ro_allocator, similar to current bpf_prog_pack_alloc.
>      This is built on top of kernel_text_rw_allocator. Different 
>      allocations could share a page, thus it requires text_poke like 
>      support from the arch. 
>   c) If the arch supports text_poke, kprobes, ftrace trampolines, and
>      bpf trampolines should use kernel_text_ro_allocator.
>   d) Major archs should support CONFIG_ARCH_WANTS_MODULES_DATA_IN_VMALLOC,
>      and they should use kernel_text_ro_allocator for module text. 
> 
> Does this sound reasonable to you?

Yes, and a respective free call may have an arch specific stuff which
removes exec stuff.

In so far as the bikeshedding, I do think this is generic so
vmalloc_text_*() suffices or vmalloc_exec_*() take your pick for
a starter and let the world throw in their preference.

> I tried to enable CONFIG_ARCH_WANTS_MODULES_DATA_IN_VMALLOC for x86_64, 
> but that doesn't really work. Do we have plan to make this combination
> work?

Oh nice.

Good stuff. Perhaps it just requires a little love from mm folks.
Don't beat yourself up if it does not yet. We can work towards that
later.

> > 2) How we free is important, and each arch does something funky for
> > this. This is not addressed here.
> 
> How should we address this? IIUC, x86_64 just calls vfree. 

That's not the case for all archs is it? I'm talking about the generic
module_alloc() too. I'd like to see that go the way we discussed above.

> > And yes I welcome generalizing generic module_alloc() too as suggested
> > before. The concern on my part is the sloppiness this enables.
> 
> One question I have is, does module_alloc (or kernel_text_*_allocator 
> above) belong to module code, or mm code (maybe vmalloc)?

The evolution of its uses indicates it is growing outside of modules and
so mm should be the new home.

> I am planning to let BPF trampoline use bpf_prog_pack on x86_64, which 
> is another baby step of c) above. 

OK!

  Luis
