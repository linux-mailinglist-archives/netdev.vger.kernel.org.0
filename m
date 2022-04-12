Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C264FE4E1
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 17:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346175AbiDLPlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 11:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242001AbiDLPlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 11:41:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325845A15D;
        Tue, 12 Apr 2022 08:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9PiloLG5jlTcO46ESKKigvFqoJS8Cciwgeir2CUSEZY=; b=lhiGFotIglWz3eWuatKV0A2rNX
        oGEepGqGbdtB7jamRHw+78FYJtRkD6cCYVIDbs7tCREBdQy/JlgHMR5Sfii2KassouNB4ixOBCqL3
        mE+B5BV+q1OG0scp/OM8r/mrRkIlAxr+nuBKpKjXyMeLu2WOveGIQhRnN0/32qGL5jC9lPmrl+lYX
        awNwWmUztkuTfTY7JkQZM3vKr1QEQQeyQkUJfifuKg0CCSRr98wJpEj5lsbZyQABzR1TCi6Pqoixt
        L3oLGNT/or9iFwOmd3Gs2dSd6OVYXRxolNqio+pQ78XNLs4f2YEftUqq6wCUhhadTMXwkxdRqDi9w
        AZiXDTsQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1neIbI-00EyA6-0b; Tue, 12 Apr 2022 15:38:40 +0000
Date:   Tue, 12 Apr 2022 08:38:39 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, akpm@linux-foundation.org,
        rick.p.edgecombe@intel.com, hch@infradead.org,
        imbrenda@linux.ibm.com
Subject: Re: [PATCH v2 bpf 0/3] vmalloc: bpf: introduce VM_ALLOW_HUGE_VMAP
Message-ID: <YlWc/yDjWbeSuVP4@bombadil.infradead.org>
References: <20220411231808.667073-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411231808.667073-1-song@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 04:18:05PM -0700, Song Liu wrote:
> Changes v1 => v2:
> 1. Add vmalloc_huge(). (Christoph Hellwig)
> 2. Add module_alloc_huge(). (Christoph Hellwig)
> 3. Add Fixes tag and Link tag. (Thorsten Leemhuis)
> 
> Enabling HAVE_ARCH_HUGE_VMALLOC on x86_64 and use it for bpf_prog_pack has
> caused some issues [1], as many users of vmalloc are not yet ready to
> handle huge pages. To enable a more smooth transition to use huge page
> backed vmalloc memory, this set replaces VM_NO_HUGE_VMAP flag with an new
> opt-in flag, VM_ALLOW_HUGE_VMAP. More discussions about this topic can be
> found at [2].
> 
> Patch 1 removes VM_NO_HUGE_VMAP and adds VM_ALLOW_HUGE_VMAP.
> Patch 2 uses VM_ALLOW_HUGE_VMAP in bpf_prog_pack.
> 
> [1] https://lore.kernel.org/lkml/20220204185742.271030-1-song@kernel.org/
> [2] https://lore.kernel.org/linux-mm/20220330225642.1163897-1-song@kernel.org/
> 
> Song Liu (3):
>   vmalloc: replace VM_NO_HUGE_VMAP with VM_ALLOW_HUGE_VMAP
>   module: introduce module_alloc_huge
>   bpf: use vmalloc with VM_ALLOW_HUGE_VMAP for bpf_prog_pack
> 
>  arch/Kconfig                 |  6 ++----
>  arch/powerpc/kernel/module.c |  2 +-
>  arch/s390/kvm/pv.c           |  2 +-
>  arch/x86/kernel/module.c     | 21 +++++++++++++++++++
>  include/linux/moduleloader.h |  5 +++++
>  include/linux/vmalloc.h      |  4 ++--
>  kernel/bpf/core.c            |  9 +++++----
>  kernel/module.c              |  8 ++++++++

Please use modules-next [0] as that has queued up changes which change
kernel/module.c quite a bit.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=modules-next

 Luis
