Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652D714365E
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 05:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgAUEyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 23:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgAUEyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 23:54:44 -0500
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 247BD24653;
        Tue, 21 Jan 2020 04:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579582483;
        bh=YQ38mVpjQZHpusPeDpF8uz55Se31rHxLJgTzd+LPI4k=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=UFYnZfeXIVCE7WvV0ESV5me39RbySqfd+AG4s0SLSYnocI8qhKCe9TaEttgLla/FP
         C5/ykxYVixrA9nWN6/0QG/vbADyj7+o8jxhRloY4beVoTF7NExZ0DeBhwrF0sSLsdn
         4kLvfK7qvUIoeNLTYPhY1HctNw4H7BUQuOGNf0M4=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id F3C443520AE0; Mon, 20 Jan 2020 20:54:42 -0800 (PST)
Date:   Mon, 20 Jan 2020 20:54:42 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, jannh@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Fix trampoline usage in preempt
Message-ID: <20200121045442.GN2935@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200121032231.3292185-1-ast@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121032231.3292185-1-ast@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 07:22:31PM -0800, Alexei Starovoitov wrote:
> Though the second half of trampoline page is unused a task could be
> preempted in the middle of the first half of trampoline and two
> updates to trampoline would change the code from underneath the
> preempted task. Hence wait for tasks to voluntarily schedule or go
> to userspace.
> Add similar wait before freeing the trampoline.
> 
> Fixes: fec56f5890d9 ("bpf: Introduce BPF trampoline")
> Reported-by: Jann Horn <jannh@google.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/trampoline.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 79a04417050d..7657ede7aee2 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -160,6 +160,14 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
>  	if (fexit_cnt)
>  		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
>  
> +	/* Though the second half of trampoline page is unused a task could be
> +	 * preempted in the middle of the first half of trampoline and two
> +	 * updates to trampoline would change the code from underneath the
> +	 * preempted task. Hence wait for tasks to voluntarily schedule or go
> +	 * to userspace.
> +	 */
> +	synchronize_rcu_tasks();

So in this case, although the trampoline is not freed, it is reused.
And we need to clear everyone off of the trampoline before reusing it.

If this states the situation correctly:

Acked-by: Paul E. McKenney <paulmck@kernel.org>

>  	err = arch_prepare_bpf_trampoline(new_image, new_image + PAGE_SIZE / 2,
>  					  &tr->func.model, flags,
>  					  fentry, fentry_cnt,
> @@ -251,6 +259,8 @@ void bpf_trampoline_put(struct bpf_trampoline *tr)
>  		goto out;
>  	if (WARN_ON_ONCE(!hlist_empty(&tr->progs_hlist[BPF_TRAMP_FEXIT])))
>  		goto out;
> +	/* wait for tasks to get out of trampoline before freeing it */
> +	synchronize_rcu_tasks();
>  	bpf_jit_free_exec(tr->image);
>  	hlist_del(&tr->hlist);
>  	kfree(tr);
> -- 
> 2.23.0
> 
