Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F65D1BBA4
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 19:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbfEMRRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 13:17:55 -0400
Received: from foss.arm.com ([217.140.101.70]:33992 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728118AbfEMRRz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 13:17:55 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64BF2341;
        Mon, 13 May 2019 10:17:54 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96BA13F6C4;
        Mon, 13 May 2019 10:17:52 -0700 (PDT)
Date:   Mon, 13 May 2019 18:17:46 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH net] flow_dissector: disable preemption around BPF calls
Message-ID: <20190513171745.GA16567@lakrids.cambridge.arm.com>
References: <20190513163855.225489-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513163855.225489-1-edumazet@google.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 09:38:55AM -0700, 'Eric Dumazet' via syzkaller wrote:
> Various things in eBPF really require us to disable preemption
> before running an eBPF program.

Is that true for all eBPF uses? I note that we don't disable preemption
in the lib/test_bpf.c module, for example.

If it's a general requirement, perhaps it's worth an assertion within
BPF_PROG_RUN()?

Thanks,
Mark.

> 
> syzbot reported :
> 
> BUG: assuming atomic context at net/core/flow_dissector.c:737
> in_atomic(): 0, irqs_disabled(): 0, pid: 24710, name: syz-executor.3
> 2 locks held by syz-executor.3/24710:
>  #0: 00000000e81a4bf1 (&tfile->napi_mutex){+.+.}, at: tun_get_user+0x168e/0x3ff0 drivers/net/tun.c:1850
>  #1: 00000000254afebd (rcu_read_lock){....}, at: __skb_flow_dissect+0x1e1/0x4bb0 net/core/flow_dissector.c:822
> CPU: 1 PID: 24710 Comm: syz-executor.3 Not tainted 5.1.0+ #6
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  __cant_sleep kernel/sched/core.c:6165 [inline]
>  __cant_sleep.cold+0xa3/0xbb kernel/sched/core.c:6142
>  bpf_flow_dissect+0xfe/0x390 net/core/flow_dissector.c:737
>  __skb_flow_dissect+0x362/0x4bb0 net/core/flow_dissector.c:853
>  skb_flow_dissect_flow_keys_basic include/linux/skbuff.h:1322 [inline]
>  skb_probe_transport_header include/linux/skbuff.h:2500 [inline]
>  skb_probe_transport_header include/linux/skbuff.h:2493 [inline]
>  tun_get_user+0x2cfe/0x3ff0 drivers/net/tun.c:1940
>  tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2037
>  call_write_iter include/linux/fs.h:1872 [inline]
>  do_iter_readv_writev+0x5fd/0x900 fs/read_write.c:693
>  do_iter_write fs/read_write.c:970 [inline]
>  do_iter_write+0x184/0x610 fs/read_write.c:951
>  vfs_writev+0x1b3/0x2f0 fs/read_write.c:1015
>  do_writev+0x15b/0x330 fs/read_write.c:1058
>  __do_sys_writev fs/read_write.c:1131 [inline]
>  __se_sys_writev fs/read_write.c:1128 [inline]
>  __x64_sys_writev+0x75/0xb0 fs/read_write.c:1128
>  do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Petar Penkov <ppenkov@google.com>
> Cc: Stanislav Fomichev <sdf@google.com>
> ---
>  net/core/flow_dissector.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 9ca784c592ac8c9c58282289a81889fbe4658a9e..548f39dde30711ac5be9e921993a6d8e53f74161 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -734,7 +734,9 @@ bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
>  	flow_keys->nhoff = nhoff;
>  	flow_keys->thoff = flow_keys->nhoff;
>  
> +	preempt_disable();
>  	result = BPF_PROG_RUN(prog, ctx);
> +	preempt_enable();
>  
>  	flow_keys->nhoff = clamp_t(u16, flow_keys->nhoff, nhoff, hlen);
>  	flow_keys->thoff = clamp_t(u16, flow_keys->thoff,
> -- 
> 2.21.0.1020.gf2820cf01a-goog
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller/20190513163855.225489-1-edumazet%40google.com.
> For more options, visit https://groups.google.com/d/optout.
