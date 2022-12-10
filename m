Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA6D648BC2
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiLJAio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLJAin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:38:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA6390773;
        Fri,  9 Dec 2022 16:38:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43250B82A03;
        Sat, 10 Dec 2022 00:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBCBC433EF;
        Sat, 10 Dec 2022 00:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670632719;
        bh=yiuDxBIJEc9d0QL4Y3+pNdUKDJUasJXcdJHngwE9U4o=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=IF5K4Kc8tCf2YLKDa/QzTQvo3sMTns+7PBUFBZS+sFWpQXNpg5A8RR/K1zEEqplCd
         HZ0uN6wLiC/zMVcgWYqduLE/1fDCdePwJhhcNQVTdgUSbWwiZ1UAifcbKkUW3dc4si
         OpeAwchC3LRl4PeXNNQiCWMJCxKKQjUyxaYw2tB8XGFc5UFs9HiMC5+AV2T03d0vD0
         iFYFuNPmxk3T8IGP1+1Vfkvz54mRQSI4Nj1aOMGCL74GkA7EIB+K6fueUSuyplUi0T
         xGB8f0W2xarcEn2msbuYYuSycD8jJTfY1F2lNGGCn+r4xDdQUXOxbfBWhJG9nctmhQ
         rtAq71/0fpjHw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 876B35C0A6B; Fri,  9 Dec 2022 16:38:38 -0800 (PST)
Date:   Fri, 9 Dec 2022 16:38:38 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@meta.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <song@kernel.org>, Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
Message-ID: <20221210003838.GZ4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <Y5MaffJOe1QtumSN@krava>
 <Y5M9P95l85oMHki9@krava>
 <Y5NSStSi7h9Vdo/j@krava>
 <5c9d77bf-75f5-954a-c691-39869bb22127@meta.com>
 <Y5OuQNmkoIvcV6IL@krava>
 <ee2a087e-b8c5-fc3e-a114-232490a6c3be@iogearbox.net>
 <Y5O/yxcjQLq5oDAv@krava>
 <96b0d9d8-02a7-ce70-de1e-b275a01f5ff3@iogearbox.net>
 <20221209153445.22182ca5@kernel.org>
 <Y5PNeFYJrC6D4P9p@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5PNeFYJrC6D4P9p@krava>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 10, 2022 at 01:06:16AM +0100, Jiri Olsa wrote:
> On Fri, Dec 09, 2022 at 03:34:45PM -0800, Jakub Kicinski wrote:
> > On Sat, 10 Dec 2022 00:32:07 +0100 Daniel Borkmann wrote:
> > > fwiw, these should not be necessary, Documentation/RCU/checklist.rst :
> > > 
> > >    [...] One example of non-obvious pairing is the XDP feature in networking,
> > >    which calls BPF programs from network-driver NAPI (softirq) context. BPF
> > >    relies heavily on RCU protection for its data structures, but because the
> > >    BPF program invocation happens entirely within a single local_bh_disable()
> > >    section in a NAPI poll cycle, this usage is safe. The reason that this usage
> > >    is safe is that readers can use anything that disables BH when updaters use
> > >    call_rcu() or synchronize_rcu(). [...]
> > 
> > FWIW I sent a link to the thread to Paul and he confirmed 
> > the RCU will wait for just the BH.
> 
> so IIUC we can omit the rcu_read_lock/unlock on bpf_prog_run_xdp side
> 
> Paul,
> any thoughts on what we can use in here to synchronize bpf_dispatcher_change_prog
> with bpf_prog_run_xdp callers?
> 
> with synchronize_rcu_tasks I'm getting splats like:
>   https://lore.kernel.org/bpf/20221209153445.22182ca5@kernel.org/T/#m0a869f93404a2744884d922bc96d497ffe8f579f
> 
> synchronize_rcu_tasks_rude seems to work (patch below), but it also sounds special ;-)

It sounds like we are all talking past each other, leaving me no
choice but to supply a wall of text:

It is quite true that synchronize_rcu_tasks_rude() will wait
for bh-disabled regions of code, just like synchronize_rcu()
and synchronize_rcu_tasks() will.  However, please note that
synchronize_rcu_tasks() never waits on any of the idle tasks.  So the
usual approach in tracing is to do both a synchronize_rcu_tasks() and
synchronize_rcu_tasks_rude().  One way of overlapping the resulting
pair of grace periods is to use synchronize_rcu_mult().

But none of these permit readers to sleep.  That is what
synchronize_rcu_tasks_trace() is for, but unlike both
synchronize_rcu_tasks() and synchronize_rcu_tasks_rude(),
you must explicitly mark the readers with rcu_read_lock_trace()
and rcu_read_unlock_trace().  This is used to protect sleepable
BPF programs.

Now, synchronize_rcu() will also wait on bh-disabled lines of code, with
the exception of such code in the exception path, way deep in the idle
loop, early in the CPU-online process, or late in the CPU-offline process.
You can recognize the first two categories of code by the noinstr tags
on the functions.

And yes, synchronize_rcu_rude() is quite special.  ;-)

Does this help, or am I simply adding to the confusion?

							Thanx, Paul

> thanks,
> jirka
> 
> 
> ---
> diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> index c19719f48ce0..e6126f07e85b 100644
> --- a/kernel/bpf/dispatcher.c
> +++ b/kernel/bpf/dispatcher.c
> @@ -124,6 +124,7 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
>  	}
>  
>  	__BPF_DISPATCHER_UPDATE(d, new ?: (void *)&bpf_dispatcher_nop_func);
> +	synchronize_rcu_tasks_rude();
>  
>  	if (new)
>  		d->image_off = noff;
