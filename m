Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8FE5D21EC
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 09:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387450AbfJJHjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 03:39:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733088AbfJJHgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 03:36:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WpK+tHhD79sRpUxX2TvDfN4NB5JxjZXZLIF/L+pB+ho=; b=B/+yaJLtn2cVn4Y0JCaEnkp8z
        GCO9Pgjkv1e7IN5X5omdjhKjp0h3cXym7YDQFNfspg0x6rFAZEKgMD469ZTUiT3LZZoOrmuch6kCk
        r9bUwJEZEjsGkrez/t8rbuuygdXtEpKAt5LaIEgtPcmqbAFStqCgVMqHnyPNj7tK5krrMJOKjgkja
        5DwsM6zPJ/qSvjzgn/fbscBbwt5w3l03sEwpOpD/0++5ca1IBMSBuQcE8Bj3RgPXcRhBjKRZRVKOz
        NjpStHdkwSLIs2KTsfXKVZZZ4vvJTNLXJ5haAS6C+mT6/ofAzN+ilh9bGzwmr22Hbpj2uPPf+KtwZ
        hLPatH60Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iISza-0004Yw-5a; Thu, 10 Oct 2019 07:36:10 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5D6B3301A79;
        Thu, 10 Oct 2019 09:35:16 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 86BE4202F4F4F; Thu, 10 Oct 2019 09:36:08 +0200 (CEST)
Date:   Thu, 10 Oct 2019 09:36:08 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com, stable@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 2/2] bpf/stackmap: fix A-A deadlock in
 bpf_get_stack()
Message-ID: <20191010073608.GO2311@hirez.programming.kicks-ass.net>
References: <20191010061916.198761-1-songliubraving@fb.com>
 <20191010061916.198761-3-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010061916.198761-3-songliubraving@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 11:19:16PM -0700, Song Liu wrote:
> bpf stackmap with build-id lookup (BPF_F_STACK_BUILD_ID) can trigger A-A
> deadlock on rq_lock():
> 
> rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
> [...]
> Call Trace:
>  try_to_wake_up+0x1ad/0x590
>  wake_up_q+0x54/0x80
>  rwsem_wake+0x8a/0xb0
>  bpf_get_stack+0x13c/0x150
>  bpf_prog_fbdaf42eded9fe46_on_event+0x5e3/0x1000
>  bpf_overflow_handler+0x60/0x100
>  __perf_event_overflow+0x4f/0xf0
>  perf_swevent_overflow+0x99/0xc0
>  ___perf_sw_event+0xe7/0x120
>  __schedule+0x47d/0x620
>  schedule+0x29/0x90
>  futex_wait_queue_me+0xb9/0x110
>  futex_wait+0x139/0x230
>  do_futex+0x2ac/0xa50
>  __x64_sys_futex+0x13c/0x180
>  do_syscall_64+0x42/0x100
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 

> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 052580c33d26..3b278f6b0c3e 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -287,7 +287,7 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
>  	bool irq_work_busy = false;
>  	struct stack_map_irq_work *work = NULL;
> 
> -	if (in_nmi()) {
> +	if (in_nmi() || this_rq_is_locked()) {
>  		work = this_cpu_ptr(&up_read_work);
>  		if (work->irq_work.flags & IRQ_WORK_BUSY)
>  			/* cannot queue more up_read, fallback */

This is horrific crap. Just say no to that get_build_id_offset()
trainwreck.
