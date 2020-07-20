Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1346225B13
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 11:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgGTJO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 05:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgGTJO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 05:14:56 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C5CC0619D2
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 02:14:56 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a6so17063686wrm.4
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 02:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=FCuuqmMApvaU0Jwh7PcOCLNiDVR6v/liq9Ls1s10hKA=;
        b=d4j8ocWYj51cHVR4q5X/if/LQqG86BYtWS6u2KYiBLNhC7tWZ4RiqwxKHlCao/nwA4
         by9Xch6API6gFoHz5qYgTOtYPH/GZBzbtQ9Z8aA2oPGnCGfVr4Sw5Z2QokkizcTw+lHB
         sqlPyoynRsh+y+p7XCJ29LwWW+OKxb3feJMeE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=FCuuqmMApvaU0Jwh7PcOCLNiDVR6v/liq9Ls1s10hKA=;
        b=Unznr1zi5ppsxC6dyS/pTkHAIJ9rH3LGE5x2rKKRZbM5/KEUqaxXzW8q9DVOCDw2cW
         1SwtGAj43+1vet5yfr8sr3AtPFon64SjtJmwkSbO0ooSCHukDWs6hsdkf41CUXugIw8J
         47Kd+iSi8vYFiKnxNiAN2vg+jkTp0sFaFuhK1iBZsNj95WzhseCdRSDuf1xWHLs77hhw
         R8NUMTlxuBtevyFMLrWdjCNz8u/8t7g+4BFtndXin9i0rg2QD3/2NRM2X8VE9HYDA3c7
         yZx/ug/qmY4MowTkB0bjYo2fSrR/D+Ea9xPfaoZuabn7lrhgtLHBgBW9n03DIQmSdQDl
         OzMw==
X-Gm-Message-State: AOAM532LxlT0XojGSfOv7LO6FeDWejwg+SEkuz7+0dX087+li2yywYBB
        9gawGHQEX5NcgPM4NEflHJCvwv001XM=
X-Google-Smtp-Source: ABdhPJylmYdJt+GG+Su47rxKKiz3INJHvP7IRSYpjjruNjFjQ38o16HNzgz4fMgPaD+y3VIvTXnraQ==
X-Received: by 2002:adf:f248:: with SMTP id b8mr8613305wrp.247.1595236494694;
        Mon, 20 Jul 2020 02:14:54 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id v12sm19640320wrs.2.2020.07.20.02.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 02:14:54 -0700 (PDT)
References: <e54f2aabf959f298939e5507b09c48f8c2e380be.1595170625.git.lorenzo@kernel.org>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, kuba@kernel.org
Subject: Re: [PATCH bpf-next] bpf: cpumap: fix possible rcpu kthread hung
In-reply-to: <e54f2aabf959f298939e5507b09c48f8c2e380be.1595170625.git.lorenzo@kernel.org>
Date:   Mon, 20 Jul 2020 11:14:53 +0200
Message-ID: <874kq2y2cy.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 05:52 PM CEST, Lorenzo Bianconi wrote:
> Fix the following cpumap kthread hung. The issue is currently occurring
> when __cpu_map_load_bpf_program fails (e.g if the bpf prog has not
> BPF_XDP_CPUMAP as expected_attach_type)
>
> $./test_progs -n 101
> 101/1 cpumap_with_progs:OK
> 101 xdp_cpumap_attach:OK
> Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED
> [  369.996478] INFO: task cpumap/0/map:7:205 blocked for more than 122 seconds.
> [  369.998463]       Not tainted 5.8.0-rc4-01472-ge57892f50a07 #212
> [  370.000102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  370.001918] cpumap/0/map:7  D    0   205      2 0x00004000
> [  370.003228] Call Trace:
> [  370.003930]  __schedule+0x5c7/0xf50
> [  370.004901]  ? io_schedule_timeout+0xb0/0xb0
> [  370.005934]  ? static_obj+0x31/0x80
> [  370.006788]  ? mark_held_locks+0x24/0x90
> [  370.007752]  ? cpu_map_bpf_prog_run_xdp+0x6c0/0x6c0
> [  370.008930]  schedule+0x6f/0x160
> [  370.009728]  schedule_preempt_disabled+0x14/0x20
> [  370.010829]  kthread+0x17b/0x240
> [  370.011433]  ? kthread_create_worker_on_cpu+0xd0/0xd0
> [  370.011944]  ret_from_fork+0x1f/0x30
> [  370.012348]
>                Showing all locks held in the system:
> [  370.013025] 1 lock held by khungtaskd/33:
> [  370.013432]  #0: ffffffff82b24720 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x28/0x1c3
>
> [  370.014461] =============================================
>
> Fixes: 9216477449f3 ("bpf: cpumap: Add the possibility to attach an eBPF program to cpumap")
> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  kernel/bpf/cpumap.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 4c95d0615ca2..f1c46529929b 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -453,24 +453,27 @@ __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
>  	rcpu->map_id = map_id;
>  	rcpu->value.qsize  = value->qsize;
>
> +	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, fd))
> +		goto free_ptr_ring;
> +

I realize it's a code move, but fd == 0 is a valid descriptor number.
The check is too strict, IMHO.

>  	/* Setup kthread */
>  	rcpu->kthread = kthread_create_on_node(cpu_map_kthread_run, rcpu, numa,
>  					       "cpumap/%d/map:%d", cpu, map_id);
>  	if (IS_ERR(rcpu->kthread))
> -		goto free_ptr_ring;
> +		goto free_prog;
>
>  	get_cpu_map_entry(rcpu); /* 1-refcnt for being in cmap->cpu_map[] */
>  	get_cpu_map_entry(rcpu); /* 1-refcnt for kthread */
>
> -	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, fd))
> -		goto free_ptr_ring;
> -
>  	/* Make sure kthread runs on a single CPU */
>  	kthread_bind(rcpu->kthread, cpu);
>  	wake_up_process(rcpu->kthread);
>
>  	return rcpu;
>
> +free_prog:
> +	if (rcpu->prog)
> +		bpf_prog_put(rcpu->prog);
>  free_ptr_ring:
>  	ptr_ring_cleanup(rcpu->queue, NULL);
>  free_queue:

Hung task splat is gone:

Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
