Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E811BF97D
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgD3N2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726829AbgD3N2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:28:35 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D05BC035495
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 06:28:35 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id h26so4874589qtu.8
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 06:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=E9rbrg1IxJEr6jgvyyKVFBSGdXtil0+leZY5SgOPSw8=;
        b=gphaMxlr/hBL+ey+RXu0iH9wbYHn7s6QYEzRgcmU+l0sbNZ5aTeWN0xMplMeVOJyLc
         FLPfyrl8gc/tHcGhsJREwSsQOIWtI0JMBcoUkqOrBlj1q/cx9wJvjyAH9NX3T9cjp1/c
         7Sp8HTq/MYWRuxHk6bEruPRA4n7iHIoIpK2YnWeUN6iGZZie5mdyDQlbCfe2lCKh+vnB
         AEMsP5ZuxLnwi2SITUqO1D8BE1ZjPtbONwVWQI4IOvbnYySDyosDyxf0dd88hVlWA8if
         sbr6Sm3Wo1tpo/Z/ZYkNFK4YYcANK1JumnPJUpa0fv4EDnxyjlusHilaYuDozLb83Kzj
         zc+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=E9rbrg1IxJEr6jgvyyKVFBSGdXtil0+leZY5SgOPSw8=;
        b=o42wvimCKHiWu95nPn8Z12ChMLg/9ZYCJVOx2WQPEJDjluglsKMZHW+Namv8USYshE
         aFvQj5ckvqTqVYub26Yi7ePwk0IGZZpHNS76cHN7ysW+xGoVb5MWiTjzhFRRwHzb4PB8
         /aRg10t8G1UvsD8ZVolhBu99JFzH7nkSp5swDJrmFz9XtxqfcN0naUG5OGE0DAssH67q
         l6htjMmiBaimPhCQvZkgURLCl+T9LjTH4Id2f/Fu2uV0+SMjN8OmNtdBhrjvea5o8TBH
         R19o8YH9rG6sdZQfuI6zUBYWkOwFdEq3I8ckLMtG0zVXJxcC8/yzWZ1fTgRF7VAGf951
         WXAw==
X-Gm-Message-State: AGi0PuaponjYmpOnKpksLIW0zrvgxDqZFDRcO5WoYEeOjTwp7VbW8hwS
        lRkJO9lKi2OuIL1uBRsx6ueISg==
X-Google-Smtp-Source: APiQypIpoW/MXWAlQF5Fwjmq3/MaLTgJVnshsVPrt553hfLPqTQnxNeCT8i6VvRvlHTWb44Mcr+uOw==
X-Received: by 2002:aed:2450:: with SMTP id s16mr3509399qtc.345.1588253314180;
        Thu, 30 Apr 2020 06:28:34 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id m12sm2101613qtu.42.2020.04.30.06.28.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Apr 2020 06:28:33 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: rcu_barrier() + membarrier() + scheduler deadlock?
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <20200430131500.GQ7560@paulmck-ThinkPad-P72>
Date:   Thu, 30 Apr 2020 09:28:32 -0400
Cc:     LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3B7EF208-EFA3-488D-BD58-E7711545FBC4@lca.pw>
References: <F64C791A-0EA7-458E-82C0-B98A1032066C@lca.pw>
 <20200430032238.GP7560@paulmck-ThinkPad-P72>
 <1591D10D-9125-4876-8769-85CAA563A435@lca.pw>
 <20200430131500.GQ7560@paulmck-ThinkPad-P72>
To:     "Paul E. McKenney" <paulmck@kernel.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 30, 2020, at 9:15 AM, Paul E. McKenney <paulmck@kernel.org> =
wrote:
>>=20
>> https://raw.githubusercontent.com/cailca/linux-mm/master/x86.config
>>=20
>> [53294.651754][T149877] futex_wake_op: trinity-c25 tries to shift op =
by -17; fix this program
>> [53323.947396][T150988] futex_wake_op: trinity-c6 tries to shift op =
by -5; fix this program
>> [53458.295837][  T215] INFO: task kworker/u64:0:8 blocked for more =
than 122 seconds.
>> [53458.304063][  T215]       Tainted: G           O L    =
5.7.0-rc3-next-20200429 #1
>> [53458.311568][  T215] "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [53458.320190][  T215] kworker/u64:0   D10584     8      2 0x90004000
>> [53458.326668][  T215] Workqueue: netns cleanup_net
>> [53458.331330][  T215] Call Trace:
>> [53458.334510][  T215]  __schedule+0x47b/0xa50
>> [53458.338765][  T215]  ? wait_for_completion+0x80/0x120
>> [53458.343920][  T215]  schedule+0x59/0xd0
>> [53458.348013][  T215]  schedule_timeout+0x10a/0x150
>> [53458.352762][  T215]  ? wait_for_completion+0x80/0x120
>> [53458.357881][  T215]  ? _raw_spin_unlock_irq+0x30/0x40
>> [53458.362997][  T215]  ? trace_hardirqs_on+0x22/0x100
>> [53458.367948][  T215]  ? wait_for_completion+0x80/0x120
>> [53458.373195][  T215]  wait_for_completion+0xb4/0x120
>> [53458.378149][  T215]  __flush_work+0x3ff/0x6e0
>> [53458.382586][  T215]  ? init_pwq+0x210/0x210
>> [53458.386840][  T215]  flush_work+0x20/0x30
>> [53458.390891][  T215]  rollback_registered_many+0x3d6/0x950
>> [53458.396438][  T215]  ? mark_held_locks+0x4e/0x80
>> [53458.401339][  T215]  unregister_netdevice_many+0x5d/0x200
>> [53458.406816][  T215]  default_device_exit_batch+0x213/0x240
>> [53458.412348][  T215]  ? do_wait_intr_irq+0xe0/0xe0
>> [53458.417225][  T215]  ? dev_change_net_namespace+0x6d0/0x6d0
>> [53458.423000][  T215]  ops_exit_list+0xa2/0xc0
>> [53458.427367][  T215]  cleanup_net+0x3d0/0x600
>> [53458.431778][  T215]  process_one_work+0x560/0xba0
>> [53458.436629][  T215]  worker_thread+0x80/0x5f0
>> [53458.441078][  T215]  ? process_scheduled_works+0x90/0x90
>> [53458.446485][  T215]  kthread+0x1de/0x200
>> [53458.450600][  T215]  ? kthread_unpark+0xd0/0xd0
>> [53458.455227][  T215]  ret_from_fork+0x27/0x50
>> [53458.460332][  T215] INFO: task trinity-c17:150651 blocked for more =
than 123 seconds.
>> [53458.468180][  T215]       Tainted: G           O L    =
5.7.0-rc3-next-20200429 #1
>> [53458.475924][  T215] "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [53458.484511][  T215] trinity-c17     D12312 150651  93301 =
0x10000004
>> [53458.490862][  T215] Call Trace:
>> [53458.494039][  T215]  __schedule+0x47b/0xa50
>> [53458.498452][  T215]  schedule+0x59/0xd0
>> [53458.502376][  T215]  schedule_preempt_disabled+0x15/0x20
>> [53458.507809][  T215]  __mutex_lock+0x6f2/0xbf0
>> [53458.512296][  T215]  ? rtnl_lock+0x20/0x30
>> [53458.516484][  T215]  mutex_lock_nested+0x31/0x40
>> [53458.521157][  T215]  ? mutex_lock_nested+0x31/0x40
>> [53458.526195][  T215]  rtnl_lock+0x20/0x30
>> [53458.530251][  T215]  do_ip_setsockopt.isra.12+0xec/0x1b90
>> [53458.535875][  T215]  ? find_held_lock+0x35/0xa0
>> [53458.540603][  T215]  ? rb_insert_color+0x10f/0x390
>> [53458.545436][  T215]  ? lock_acquire+0xcd/0x450
>> [53458.550126][  T215]  ? find_held_lock+0x35/0xa0
>> [53458.554717][  T215]  ? =
__cgroup_bpf_prog_array_is_empty+0x121/0x230
>> [53458.561127][  T215]  ip_setsockopt+0x3e/0x90
>> [53458.565511][  T215]  udp_setsockopt+0x49/0x80
>> [53458.570059][  T215]  sock_common_setsockopt+0x6d/0x90
>> [53458.575303][  T215]  __sys_setsockopt+0x194/0x2e0
>> [53458.580128][  T215]  __x64_sys_setsockopt+0x70/0x90
>> [53458.585066][  T215]  do_syscall_64+0x91/0xb10
>> [53458.589504][  T215]  ? perf_call_bpf_enter+0x120/0x120
>> [53458.594741][  T215]  ? trace_hardirqs_off_thunk+0x1a/0x1c
>> [53458.600467][  T215]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>> [53458.606296][  T215] RIP: 0033:0x7f2cbe1b270d
>> [53458.610611][  T215] Code: Bad RIP value.
>> [53458.614570][  T215] RSP: 002b:00007ffe6a4b18d8 EFLAGS: 00000246 =
ORIG_RAX: 0000000000000036
>> [53458.623094][  T215] RAX: ffffffffffffffda RBX: 0000000000000036 =
RCX: 00007f2cbe1b270d
>> [53458.631024][  T215] RDX: 000000000000002a RSI: 0000000000000000 =
RDI: 0000000000000060
>> [53458.638954][  T215] RBP: 0000000000000036 R08: 0000000000000088 =
R09: 00000000000000f0
>> [53458.647044][  T215] R10: 00000000025557f0 R11: 0000000000000246 =
R12: 0000000000000002
>> [53458.654960][  T215] R13: 00007f2cbcaeb058 R14: 00007f2cbe0716c0 =
R15: 00007f2cbcaeb000
>> [53458.662899][  T215] INFO: task trinity-c10:150896 blocked for more =
than 123 seconds.
>> [53458.670757][  T215]       Tainted: G           O L    =
5.7.0-rc3-next-20200429 #1
>> [53458.678380][  T215] "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [53458.687007][  T215] trinity-c10     D11512 150896  93301 =
0x10000004
>> [53458.693334][  T215] Call Trace:
>> [53458.696545][  T215]  __schedule+0x47b/0xa50
>> [53458.700944][  T215]  schedule+0x59/0xd0
>> [53458.704817][  T215]  schedule_preempt_disabled+0x15/0x20
>> [53458.710246][  T215]  __mutex_lock+0x6f2/0xbf0
>> [53458.714686][  T215]  ? rtnl_lock+0x20/0x30
>> [53458.718851][  T215]  mutex_lock_nested+0x31/0x40
>> [53458.723649][  T215]  ? mutex_lock_nested+0x31/0x40
>> [53458.728556][  T215]  rtnl_lock+0x20/0x30
>> [53458.732520][  T215]  do_ip_setsockopt.isra.12+0xec/0x1b90
>> [53458.737998][  T215]  ? find_held_lock+0x35/0xa0
>> [53458.742646][  T215]  ? rb_insert_color+0x10f/0x390
>> [53458.747672][  T215]  ? lock_acquire+0xcd/0x450
>> [53458.752236][  T215]  ? find_held_lock+0x35/0xa0
>> [53458.756847][  T215]  ? =
__cgroup_bpf_prog_array_is_empty+0x121/0x230
>> [53458.763169][  T215]  ip_setsockopt+0x3e/0x90
>> [53458.767509][  T215]  udp_setsockopt+0x49/0x80
>> [53458.772061][  T215]  sock_common_setsockopt+0x6d/0x90
>> [53458.777192][  T215]  __sys_setsockopt+0x194/0x2e0
>> [53458.781976][  T215]  __x64_sys_setsockopt+0x70/0x90
>> [53458.786994][  T215]  do_syscall_64+0x91/0xb10
>> [53458.791460][  T215]  ? perf_call_bpf_enter+0x120/0x120
>> [53458.797008][  T215]  ? trace_hardirqs_off_thunk+0x1a/0x1c
>> [53458.802523][  T215]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
>> [53458.808368][  T215] RIP: 0033:0x7f2cbe1b270d
>> [53458.812678][  T215] Code: Bad RIP value.
>> [53458.816669][  T215] RSP: 002b:00007ffe6a4b18d8 EFLAGS: 00000246 =
ORIG_RAX: 0000000000000036
>> [53458.825143][  T215] RAX: ffffffffffffffda RBX: 0000000000000036 =
RCX: 00007f2cbe1b270d
>> [53458.833070][  T215] RDX: 000000000000002c RSI: 0000000000000000 =
RDI: 000000000000005c
>> [53458.840997][  T215] RBP: 0000000000000036 R08: 0000000000000108 =
R09: 00000000b5b5b5b5
>> [53458.849155][  T215] R10: 000000000255b5a0 R11: 0000000000000246 =
R12: 0000000000000002
>> [53458.857072][  T215] R13: 00007f2cbcb1c058 R14: 00007f2cbe0716c0 =
R15: 00007f2cbcb1c000
>> [53458.865076][  T215]=20
>> [53458.865076][  T215] Showing all locks held in the system:
>> [53458.872936][  T215] 5 locks held by kworker/u64:0/8:
>> [53458.878066][  T215]  #0: ffff95b4734e4538 =
((wq_completion)netns){+.+.}-{0:0}, at: process_one_work+0x454/0xba0
>> [53458.888191][  T215]  #1: ffffa459431abe18 =
(net_cleanup_work){+.+.}-{0:0}, at: process_one_work+0x454/0xba0
>> [53458.898177][  T215]  #2: ffffffff955917b0 =
(pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x6d/0x600
>> [53458.907469][  T215]  #3: ffffffff955975a8 =
(rtnl_mutexl_mutex){+.+.}-{3:3}, at: rtnl_lock_killable+0x21/0x30
>> [53459.304598][  T215] 1 lock held by trinity-c17/150651:
>> [53459.309827][  T215]  #0: ffffffff955975a8 =
(rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock+0x20/0x30
>> [53459.318343][  T215] 2 locks held by trinity-c11/150712:
>> [53459.323744][  T215]  #0: ffffffff955917b0 =
(pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x15c/0x26e
>> [53459.333092][  T215]  #1: ffffffff955975a8 =
(rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock_killable+0x21/0x30
>> [53459.342364][  T215] 2 locks held by trinity-c7/150739:
>> [53459.347768][  T215]  #0: ffffffff955917b0 =
(pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x15c/0x26e
>> [53459.357179][  T215]  #1: ffffffff955975a8 =
(rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock_killable+0x21/0x30
>> [53459.366479][  T215] 2 locks held by trinity-c15/150758:
>> [53459.372006][  T215]  #0: ffffffff955917b0 =
(pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x15c/0x26e
>> [53459.381398][  T215]  #1: ffffffff955975a8 =
(rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock_killable+0x21/0x30
>=20
> If you have lots of threads doing networking configuration changes,
> then contention on RTNL (as evidenced above) is expected behavior.

Right, I=E2=80=99ll remove the CAP_NET_ADMIN from the fuzzer container =
to see if it helps. I thought it was no biggie because it was inside a =
net namespace. I=E2=80=99ll also reduce the number of fuzzer child =
process (one per active CPU right now) to see if it could get a bit =
clear picture. At least, it triggers quite a few memory leak over there, =
so it could be some error handing is not robust enough. I=E2=80=99ll dig =
a bit.

unreferenced object 0xffff97008e4c4040 (size 176):
  comm "softirq", pid 0, jiffies 4295173845 (age 32012.550s)
  hex dump (first 32 bytes):
    00 d0 a5 74 04 97 ff ff 40 72 1a 96 ff ff ff ff  ...t....@r......
    c1 a3 c5 95 ff ff ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000030483fae>] kmem_cache_alloc+0x184/0x430
    [<000000007ae17545>] dst_alloc+0x8e/0x128
    [<000000001efe9a1f>] rt_dst_alloc+0x6f/0x1e0
rt_dst_alloc at net/ipv4/route.c:1628
    [<00000000e67d4dac>] ip_route_input_rcu+0xdfe/0x1640
ip_route_input_slow at net/ipv4/route.c:2218
(inlined by) ip_route_input_rcu at net/ipv4/route.c:2348
    [<000000009f30cbc0>] ip_route_input_noref+0xab/0x1a0
    [<000000004f53bd04>] arp_process+0x83a/0xf50
arp_process at net/ipv4/arp.c:813 (discriminator 1)
    [<0000000061fd547d>] arp_rcv+0x276/0x330
    [<0000000007dbfa7a>] __netif_receive_skb_list_core+0x4d2/0x500
    [<0000000062d5f6d2>] netif_receive_skb_list_internal+0x4cb/0x7d0
    [<000000002baa2b74>] gro_normal_list+0x55/0xc0
    [<0000000093d04885>] napi_complete_done+0xea/0x350
    [<00000000467dd088>] tg3_poll_msix+0x174/0x310 [tg3]
    [<00000000498af7d9>] net_rx_action+0x278/0x890
    [<000000001e81d7e6>] __do_softirq+0xd9/0x589
    [<00000000087ee354>] irq_exit+0xa2/0xc0
    [<000000001c4db0cd>] do_IRQ+0x87/0x180
unreferenced object 0xffff96ffe4218700 (size 176):
  comm "softirq", pid 0, jiffies 4295173865 (age 32012.360s)
  hex dump (first 32 bytes):
    00 d0 a5 74 04 97 ff ff 40 72 1a 96 ff ff ff ff  ...t....@r......
    c1 a3 c5 95 ff ff ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<0000000030483fae>] kmem_cache_alloc+0x184/0x430
    [<000000007ae17545>] dst_alloc+0x8e/0x128
    [<000000001efe9a1f>] rt_dst_alloc+0x6f/0x1e0
    [<00000000e67d4dac>] ip_route_input_rcu+0xdfe/0x1640
    [<000000009f30cbc0>] ip_route_input_noref+0xab/0x1a0
    [<000000004f53bd04>] arp_process+0x83a/0xf50
    [<0000000061fd547d>] arp_rcv+0x276/0x330
    [<0000000007dbfa7a>] __netif_receive_skb_list_core+0x4d2/0x500
    [<0000000062d5f6d2>] netif_receive_skb_list_internal+0x4cb/0x7d0
    [<000000002baa2b74>] gro_normal_list+0x55/0xc0
    [<0000000093d04885>] napi_complete_done+0xea/0x350
    [<00000000467dd088>] tg3_poll_msix+0x174/0x310 [tg3]
    [<00000000498af7d9>] net_rx_action+0x278/0x890
    [<000000001e81d7e6>] __do_softirq+0xd9/0x589
    [<00000000087ee354>] irq_exit+0xa2/0xc0
    [<000000001c4db0cd>] do_IRQ+0x87/0x180=
