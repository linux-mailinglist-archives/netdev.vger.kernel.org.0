Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5389243FFB6
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhJ2PmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:42:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:57856 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhJ2PmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 11:42:21 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mgTyx-000Er6-T9; Fri, 29 Oct 2021 17:39:51 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mgTyx-00055S-Od; Fri, 29 Oct 2021 17:39:51 +0200
Subject: Re: [RFC] should we allow BPF to transmit empty skbs
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <d732c167-4fbd-b60a-1e1b-8e0147fd9a78@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f91a8348-87ab-86dc-9a10-d934bce0aa87@iogearbox.net>
Date:   Fri, 29 Oct 2021 17:39:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d732c167-4fbd-b60a-1e1b-8e0147fd9a78@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26337/Fri Oct 29 10:19:12 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/21 5:22 PM, Eric Dumazet wrote:
> Some layers in tx path do not expect skb being empty (skb->len == 0)
> 
> syzbot reported a crash [1] in fq_codel.
> 
> But I expect many drivers would also crash later.
> 
> Sure the immediate fq_codel crash could be 'fixed', but I would rather
> add some sanity checks in net/core/filter.c

Makes sense, we shouldn't have to add this to fq_codel fast path, but rather
a sanity check for bpf_clone_redirect().

I wonder if it's only related to bpf_prog_test_run() infra or if it could also
have been generated via stack?

Thanks,
Daniel

> diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
> index bb0cd6d3d2c2749d54e26368fb2558beedea85c9..73688b0ec83c473322669ca6a331bf3f3aefb293 100644
> --- a/net/sched/sch_fq_codel.c
> +++ b/net/sched/sch_fq_codel.c
> @@ -203,7 +203,14 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>          codel_set_enqueue_time(skb);
>          flow = &q->flows[idx];
>          flow_queue_add(flow, skb);
> -       q->backlogs[idx] += qdisc_pkt_len(skb);
> +
> +       /* fq_codel_drop() depends on qdisc_pkt_len(skb) being not zero. */
> +       pkt_len = qdisc_pkt_len(skb);
> +       if (unlikely(!pkt_len)) {
> +               pkt_len = 1;
> +               qdisc_skb_cb(skb)->pkt_len = pkt_len;
> +       }
> +       q->backlogs[idx] += pkt_len;
>          qdisc_qstats_backlog_inc(sch, skb);
>   
>          if (list_empty(&flow->flowchain)) {
> @@ -220,8 +227,6 @@ static int fq_codel_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>          prev_backlog = sch->qstats.backlog;
>          prev_qlen = sch->q.qlen;
>   
> -       /* save this packet length as it might be dropped by fq_codel_drop() */
> -       pkt_len = qdisc_pkt_len(skb);
>          /* fq_codel_drop() is quite expensive, as it performs a linear search
>           * in q->backlogs[] to find a fat flow.
>           * So instead of dropping a single packet, drop half of its backlog
> 
> 
> [1]
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 PID: 6542 Comm: syz-executor965 Not tainted 5.15.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:dequeue_head net/sched/sch_fq_codel.c:120 [inline]
> RIP: 0010:fq_codel_drop net/sched/sch_fq_codel.c:168 [inline]
> RIP: 0010:fq_codel_enqueue+0x83e/0x10c0 net/sched/sch_fq_codel.c:230
> Code: f8 e2 25 fa 45 39 ec 0f 83 cb 00 00 00 e8 1a dc 25 fa 48 8b 44 24 10 80 38 00 0f 85 9a 06 00 00 49 8b 07 48 89 c2 48 c1 ea 03 <42> 80 3c 32 00 0f 85 6e 06 00 00 48 8b 10 48 8d 78 28 49 89 17 48
> RSP: 0018:ffffc90001187310 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff87504776 RDI: 0000000000000003
> RBP: ffffc900011874e0 R08: 0000000000000400 R09: 0000000000000001
> R10: ffffffff875046d6 R11: 0000000000000000 R12: 0000000000000400
> R13: 0000000000000000 R14: dffffc0000000000 R15: ffff888071660000
> FS:  0000555556b21300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9c09885040 CR3: 0000000021c77000 CR4: 00000000003506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   dev_qdisc_enqueue+0x40/0x300 net/core/dev.c:3771
>   __dev_xmit_skb net/core/dev.c:3855 [inline]
>   __dev_queue_xmit+0x1f0e/0x36e0 net/core/dev.c:4170
>   __bpf_tx_skb net/core/filter.c:2114 [inline]
>   __bpf_redirect_no_mac net/core/filter.c:2139 [inline]
>   __bpf_redirect+0x5ba/0xd20 net/core/filter.c:2162
>   ____bpf_clone_redirect net/core/filter.c:2429 [inline]
>   bpf_clone_redirect+0x2ae/0x420 net/core/filter.c:2401
>   ___bpf_prog_run+0x3592/0x77d0 kernel/bpf/core.c:1548
>   __bpf_prog_run512+0x91/0xd0 kernel/bpf/core.c:1776
>   bpf_dispatcher_nop_func include/linux/bpf.h:718 [inline]
>   __bpf_prog_run include/linux/filter.h:624 [inline]
>   bpf_prog_run include/linux/filter.h:631 [inline]
>   bpf_test_run+0x37c/0xa20 net/bpf/test_run.c:119
>   bpf_prog_test_run_skb+0xa7c/0x1cb0 net/bpf/test_run.c:662
>   bpf_prog_test_run kernel/bpf/syscall.c:3307 [inline]
>   __sys_bpf+0x2137/0x5df0 kernel/bpf/syscall.c:4605
>   __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
>   __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
>   __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4689
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 

