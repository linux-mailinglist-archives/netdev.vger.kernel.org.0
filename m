Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A0848AD46
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 13:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbiAKMEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 07:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238920AbiAKMEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 07:04:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEE0C06173F;
        Tue, 11 Jan 2022 04:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HeOqrODruHJYoGhiIvE7xeArlICCLmpsE+auxaJxBT8=; b=wAQOxiZwAk4ItscXSee9zJ+J6r
        NFxQIpIw7GERCNdaULkH9vuzIyCpIsheEN380GF4tL/ly1rOq3CZpJ4qGx+2Gt1SrOGDcEKSayfAm
        KXWkP1QUNyes3WQGOynKRAY9IFtJK4yss6zY+qxZiAZLqml9aYgQXeOuT5tWwvmNZzcSbVa7axVJd
        TdSjwktyW4eZyh49CeonzR1Cz/CpTHSfO6iR9jwHT4E2PgfowCtgwNW3oAbLYAwV3ZsNmJPwCUny9
        CHH+INUJg1gajPbsr831ym5I2JGmK3gTF7khNs/ToP6lnWP84GLmyfvVldsu8gQ1BQSLPkMNOn1iD
        D9FGcrDQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7Fsq-003DVP-PD; Tue, 11 Jan 2022 12:04:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A31B63000E6;
        Tue, 11 Jan 2022 13:04:12 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 881552B323544; Tue, 11 Jan 2022 13:04:12 +0100 (CET)
Date:   Tue, 11 Jan 2022 13:04:12 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, x86@kernel.org,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v3 bpf-next 7/7] bpf, x86_64: use bpf_prog_pack allocator
Message-ID: <Yd1yPATp1viijqbi@hirez.programming.kicks-ass.net>
References: <20220106022533.2950016-1-song@kernel.org>
 <20220106022533.2950016-8-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106022533.2950016-8-song@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 06:25:33PM -0800, Song Liu wrote:
> From: Song Liu <songliubraving@fb.com>
> 
> Use bpf_prog_pack allocator in x86_64 jit.
> 
> The program header from bpf_prog_pack is read only during the jit process.
> Therefore, the binary is first written to a temporary buffer, and later
> copied to final location with text_poke_jit().
> 
> Similarly, jit_fill_hole() is updated to fill the hole with 0xcc using
> text_poke_jit().
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 131 +++++++++++++++++++++++++++---------
>  1 file changed, 100 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index fe4f08e25a1d..ad69a64ee4fe 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -216,11 +216,33 @@ static u8 simple_alu_opcodes[] = {
>  	[BPF_ARSH] = 0xF8,
>  };
>  
> +static char jit_hole_buffer[PAGE_SIZE] = {};
> +
>  static void jit_fill_hole(void *area, unsigned int size)
> +{
> +	struct bpf_binary_header *hdr = area;
> +	int i;
> +
> +	for (i = 0; i < roundup(size, PAGE_SIZE); i += PAGE_SIZE) {
> +		int s;
> +
> +		s = min_t(int, PAGE_SIZE, size - i);
> +		text_poke_jit(area + i, jit_hole_buffer, s);
> +	}
> +
> +	/* bpf_jit_binary_alloc_pack cannot write size directly to the ro
> +	 * mapping. Write it here with text_poke_jit().
> +	 */

Could we move this file towards regular comment style please? It's
already mixed style, let's take the opportunity and not add more
net-style comments.

> +	text_poke_jit(&hdr->size, &size, sizeof(size));
> +}
