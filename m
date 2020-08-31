Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDC1257E6F
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgHaQPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 12:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbgHaQPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 12:15:53 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAAA32073A;
        Mon, 31 Aug 2020 16:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598890552;
        bh=Ln9Sn7wYppBxt0ZyPsyxJFKtZrB9aE8hFWqmQlAkL7w=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=sReLWEntjn9RUEG9TyzPm/P4a6SX3mRCODi8OfhLvjXvVSWMxv8G5VzGRvGLr3yoX
         Tt8CwGok7HoqqIqLu9K8sK8xQskxmqBRlm+m5aa9P4wNY0R7SyL64N6e0oZNkvAMdt
         l2jaBDinTVv9k5OWMDsHB3pHy/C0k7ckFMwb68o0=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id BECF73522A20; Mon, 31 Aug 2020 09:15:52 -0700 (PDT)
Date:   Mon, 31 Aug 2020 09:15:52 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next] bpf: Fix build without BPF_SYSCALL, but with
 BPF_JIT.
Message-ID: <20200831161552.GA2855@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200831155155.62754-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200831155155.62754-1-alexei.starovoitov@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 08:51:55AM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> When CONFIG_BPF_SYSCALL is not set, but CONFIG_BPF_JIT=y
> the kernel build fails:
> In file included from ../kernel/bpf/trampoline.c:11:
> ../kernel/bpf/trampoline.c: In function ‘bpf_trampoline_update’:
> ../kernel/bpf/trampoline.c:220:39: error: ‘call_rcu_tasks_trace’ undeclared
> ../kernel/bpf/trampoline.c: In function ‘__bpf_prog_enter_sleepable’:
> ../kernel/bpf/trampoline.c:411:2: error: implicit declaration of function ‘rcu_read_lock_trace’
> ../kernel/bpf/trampoline.c: In function ‘__bpf_prog_exit_sleepable’:
> ../kernel/bpf/trampoline.c:416:2: error: implicit declaration of function ‘rcu_read_unlock_trace’
> 
> This is due to:
> obj-$(CONFIG_BPF_JIT) += trampoline.o
> obj-$(CONFIG_BPF_JIT) += dispatcher.o
> There is a number of functions that arch/x86/net/bpf_jit_comp.c is
> using from these two files, but none of them will be used when
> only cBPF is on (which is the case for BPF_SYSCALL=n BPF_JIT=y).
> 
> Add rcu_trace functions to rcupdate_trace.h. The JITed code won't execute them
> and BPF trampoline logic won't be used without BPF_SYSCALL.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
> Acked-by: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Looks good, and unless someone tells me otherwise, I am assuming that
this one goes up the normal BPF patch route.

							Thanx, Paul

> ---
>  include/linux/rcupdate_trace.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/rcupdate_trace.h b/include/linux/rcupdate_trace.h
> index d9015aac78c6..aaaac8ac927c 100644
> --- a/include/linux/rcupdate_trace.h
> +++ b/include/linux/rcupdate_trace.h
> @@ -82,7 +82,14 @@ static inline void rcu_read_unlock_trace(void)
>  void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func);
>  void synchronize_rcu_tasks_trace(void);
>  void rcu_barrier_tasks_trace(void);
> -
> +#else
> +/*
> + * The BPF JIT forms these addresses even when it doesn't call these
> + * functions, so provide definitions that result in runtime errors.
> + */
> +static inline void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func) { BUG(); }
> +static inline void rcu_read_lock_trace(void) { BUG(); }
> +static inline void rcu_read_unlock_trace(void) { BUG(); }
>  #endif /* #ifdef CONFIG_TASKS_TRACE_RCU */
>  
>  #endif /* __LINUX_RCUPDATE_TRACE_H */
> -- 
> 2.23.0
> 
