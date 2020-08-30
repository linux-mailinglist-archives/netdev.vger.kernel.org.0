Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95ED2570CF
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 00:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgH3WDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 18:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgH3WDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 18:03:13 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 300252083E;
        Sun, 30 Aug 2020 22:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598824993;
        bh=9LuOYxc5B5+rJM02abnd3x2WHpHxbVXmyaL2KDo0FwM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=ADLJHr2sjXwfhoy5vlVQjVaLtbm1lkfd8umuuEYTu86loI4DaAn/9RjCfTjYfbTnV
         WNumGcx+V+IXoqYztI/EPiCGCtT5OtdSyNTc+O3cq5ox6b5kCa1JDPSXXfZIM/i907
         yKWXweKn3BrlHBtclII8AuxhVWa1gy+S2B8EmNO8=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 0EEBB35226AC; Sun, 30 Aug 2020 15:03:13 -0700 (PDT)
Date:   Sun, 30 Aug 2020 15:03:13 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, josef@toxicpanda.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Fix build without BPF_SYSCALL, but with
 BPF_JIT.
Message-ID: <20200830220313.GV2855@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200830204328.50419-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200830204328.50419-1-alexei.starovoitov@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 30, 2020 at 01:43:28PM -0700, Alexei Starovoitov wrote:
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
> Add these functions to rcupdate_trace.h.
> The JIT won't call them and BPF trampoline logic won't be used without BPF_SYSCALL.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1e6c62a88215 ("bpf: Introduce sleepable BPF programs")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

A couple of nits below, but overall:

Acked-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  include/linux/rcupdate_trace.h | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/rcupdate_trace.h b/include/linux/rcupdate_trace.h
> index d9015aac78c6..334840f4f245 100644
> --- a/include/linux/rcupdate_trace.h
> +++ b/include/linux/rcupdate_trace.h
> @@ -82,7 +82,19 @@ static inline void rcu_read_unlock_trace(void)
>  void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func);
>  void synchronize_rcu_tasks_trace(void);
>  void rcu_barrier_tasks_trace(void);
> -
> +#else

This formulation is a bit novel for RCU.  Could we therefore please add
a comment something like this?

// The BPF JIT forms these addresses even when it doesn't call these
// functions, so provide definitions that result in runtime errors.

> +static inline void call_rcu_tasks_trace(struct rcu_head *rhp, rcu_callback_t func)
> +{
> +	BUG();
> +}
> +static inline void rcu_read_lock_trace(void)
> +{
> +	BUG();
> +}
> +static inline void rcu_read_unlock_trace(void)
> +{
> +	BUG();
> +}

People have been moving towards one-liner for things like these last two:

static inline void rcu_read_lock_trace(void) { BUG(); }
static inline void rcu_read_unlock_trace(void) { BUG(); }

>  #endif /* #ifdef CONFIG_TASKS_TRACE_RCU */
>  
>  #endif /* __LINUX_RCUPDATE_TRACE_H */
> -- 
> 2.23.0
> 
