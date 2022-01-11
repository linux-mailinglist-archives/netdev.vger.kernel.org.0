Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D765748AD63
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 13:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiAKMOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 07:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239613AbiAKMOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 07:14:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8B3C06173F;
        Tue, 11 Jan 2022 04:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DhDkiEPn5JGUZnMHwMsgyfl+B6fjvmEHCm3pq7u5958=; b=KpLOIxN+GaIw7gaHD4vNd1cafQ
        U02ud691p2Gk0bmPI45C6i/HhYJ4ulVnHzt4E0sLc4I4aEkKGHiWjaY6nohspyne7vW4QSBtJNn0P
        CDa9QjJSYCalbLeJTfJPjarmHmd91cd7P2V1cJw483Oh2DS1c9rHH2+1CEOpcmtVOAhCLXNOjUhyM
        x5JdC7tK+Qj3sr22g344F8FKSUtriqaq/tlLlx0TVeTYhnhNs3nkA7RyzhJK3RgbNwLcmpLfUc0pu
        Twka7k8bJSIOHzPk0Ba6a2mqvUpV2Ky/A9Yv0sH9MSH/zSg/6gSggr5pL8wGLdKMrhqF4AHYjRvuS
        xHAdAPVg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n7G2I-003DnK-3A; Tue, 11 Jan 2022 12:13:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B7A123000E6;
        Tue, 11 Jan 2022 13:13:57 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 987532B323545; Tue, 11 Jan 2022 13:13:57 +0100 (CET)
Date:   Tue, 11 Jan 2022 13:13:57 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, x86@kernel.org
Subject: Re: [PATCH v3 bpf-next 5/7] x86/alternative: introduce text_poke_jit
Message-ID: <Yd10heJVckednY07@hirez.programming.kicks-ass.net>
References: <20220106022533.2950016-1-song@kernel.org>
 <20220106022533.2950016-6-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106022533.2950016-6-song@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 06:25:31PM -0800, Song Liu wrote:

> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 23fb4d51a5da..02c35725cc62 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -1102,6 +1102,34 @@ void *text_poke_kgdb(void *addr, const void *opcode, size_t len)
>  	return __text_poke(addr, opcode, len);
>  }
>  
> +/**
> + * text_poke_jit - Update instructions on a live kernel by jit engine
> + * @addr: address to modify
> + * @opcode: source of the copy
> + * @len: length to copy, could be more than 2x PAGE_SIZE
> + *
> + * Only module memory taking jit text (e.g. for bpf) should be patched.
> + */

Maybe:

	text_poke_copy() - Copy instructions into (an unused part of) RX memory
	@args...

	Not safe against concurrent execution; useful for JITs to dump
	new code blocks into unused regions of RX memory. Can be used in
	conjunction with synchronize_rcu_tasks() to wait for existing
	execution to quiesce after having made sure no existing
	functions pointers are life.

or something along those lines?

> +void *text_poke_jit(void *addr, const void *opcode, size_t len)
> +{
> +	unsigned long start = (unsigned long)addr;
> +	size_t patched = 0;
> +
> +	if (WARN_ON_ONCE(core_kernel_text(start)))
> +		return NULL;
> +
> +	while (patched < len) {
> +		unsigned long ptr = start + patched;
> +		size_t s;
> +
> +		s = min_t(size_t, PAGE_SIZE * 2 - offset_in_page(ptr), len - patched);
> +
> +		__text_poke((void *)ptr, opcode + patched, s);
> +		patched += s;
> +	}
> +	return addr;
> +}
> +
>  static void do_sync_core(void *info)
>  {
>  	sync_core();
> -- 
> 2.30.2
> 
