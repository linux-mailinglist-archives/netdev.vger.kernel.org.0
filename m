Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7796F4754BE
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 09:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbhLOI46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 03:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbhLOI44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 03:56:56 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AE3C061574;
        Wed, 15 Dec 2021 00:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zR4ncSMvnhcpSMcAgLrlN/BmBmXWpxmJfYrn39NbIdo=; b=Cb7ooSr5ebxYBp8GjQy3WeEvdU
        eD7GCO4y/SsY4OdYJILgm0MPSRWD8e/pD+Dd05yfJrFP0pPKG8AKnkhDzrQmKhOqF0CPzEQGaCUx2
        Pk1TpnjKnqu+UlwZ17IAOKj3sa2JrgL6zXe1cI68SsLjp1sM3XISdWrpTgzqscW+NNZlAyFcMq7Le
        xER8TYrcY3vrUjOmytm4Fu2lnds5/QYaZiAjlhLcYXnYu2i7UuDjeKMYQxDXJj9ijG5c3eA/tBzKG
        BTYzvohHFCZPpVMc4BuNzSiw3eRBe7/VCy9wsV0PGGxi8MjdA53diUSWBFfYyVy82OE8KjAtRzG1c
        YnzblK2g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxQ5c-001Taq-AM; Wed, 15 Dec 2021 08:56:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D3DB3300348;
        Wed, 15 Dec 2021 09:56:42 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B935E2B3206CF; Wed, 15 Dec 2021 09:56:42 +0100 (CET)
Date:   Wed, 15 Dec 2021 09:56:42 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, x86@kernel.org,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/7] bpf: use bytes instead of pages for
 bpf_jit_[charge|uncharge]_modmem
Message-ID: <YbmtyiGpGLug1x5u@hirez.programming.kicks-ass.net>
References: <20211215060102.3793196-1-song@kernel.org>
 <20211215060102.3793196-3-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215060102.3793196-3-song@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 10:00:57PM -0800, Song Liu wrote:
> From: Song Liu <songliubraving@fb.com>
> 
> This enables sub-page memory charge and allocation.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  include/linux/bpf.h     |  4 ++--
>  kernel/bpf/core.c       | 19 +++++++++----------
>  kernel/bpf/trampoline.c |  6 +++---
>  3 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 965fffaf0308..adcdda0019f1 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -775,8 +775,8 @@ void bpf_image_ksym_add(void *data, struct bpf_ksym *ksym);
>  void bpf_image_ksym_del(struct bpf_ksym *ksym);
>  void bpf_ksym_add(struct bpf_ksym *ksym);
>  void bpf_ksym_del(struct bpf_ksym *ksym);
> -int bpf_jit_charge_modmem(u32 pages);
> -void bpf_jit_uncharge_modmem(u32 pages);
> +int bpf_jit_charge_modmem(u32 size);
> +void bpf_jit_uncharge_modmem(u32 size);
>  bool bpf_prog_has_trampoline(const struct bpf_prog *prog);
>  #else
>  static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index de3e5bc6781f..495e3b2c36ff 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -808,7 +808,7 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>  	return slot;
>  }
>  
> -static atomic_long_t bpf_jit_current;
> +static atomic64_t bpf_jit_current;

atomic64_t is atrocious crap on much of 32bit. I suppose it doesn't
matter since this is slow path accounting?
