Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403974754F8
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbhLOJRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236009AbhLOJRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 04:17:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AED4C061574;
        Wed, 15 Dec 2021 01:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ciNIolSnF0w3P4/6NyIscaHcZqy7GkcNoYmDZxekxE0=; b=fyZ6hxbhOxZ+QdfRh+XzozqNdX
        LzkhWrjFTvoKMboLzrttB6OAu3GPt8RqWlC8W4wF/wQLAquUQ9r6KIFtqke/8+d6YtamSjUwbOUJt
        7MUFTiY5qFS45cDBpMSO5QEVFY9fVLN7hwgJi0cQ36D9OPiyBqkqwX6tM0IRCnpnI9p7VLEDXGPq+
        ukGxcg2E+SQX6YtO/cuZUmIUgOF9PQL7zWndvSauuM42a9hBz0PlaimTTh2Pa7jcAVFO9SPPtlmV6
        RmKMI6kge2kPQ+Jc2HpTlD959l/5WJNEkNsXNIz7JgdXO7ZbiUZcphFKtBTkDaJZENUL6vMkZH/gq
        sn9S9Llg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxQPm-00EVNv-Q0; Wed, 15 Dec 2021 09:17:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 25103300252;
        Wed, 15 Dec 2021 10:17:35 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0DF642B3204AF; Wed, 15 Dec 2021 10:17:35 +0100 (CET)
Date:   Wed, 15 Dec 2021 10:17:35 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, x86@kernel.org
Subject: Re: [PATCH v2 bpf-next 5/7] x86/alternative: introduce text_poke_jit
Message-ID: <Ybmyr3GB5+nZbso2@hirez.programming.kicks-ass.net>
References: <20211215060102.3793196-1-song@kernel.org>
 <20211215060102.3793196-6-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215060102.3793196-6-song@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 10:01:00PM -0800, Song Liu wrote:
> This will be used by BPF jit compiler to dump JITed binary to a RWX huge

OK, I read the actually allocator you use and the relevant code for this
patch and the above is a typo, you meant: RX. Those pages are most
definitely not writable.


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

Cute, should work.

> +
> +		__text_poke((void *)ptr, opcode + patched, s);
> +		patched += s;
> +	}
> +	return addr;
> +}
