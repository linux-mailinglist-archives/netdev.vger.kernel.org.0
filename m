Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB894FAC2B
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 07:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiDJFnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 01:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiDJFnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 01:43:04 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2784EA03
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 22:40:54 -0700 (PDT)
Received: from fsav415.sakura.ne.jp (fsav415.sakura.ne.jp [133.242.250.114])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23A5dW5a062781;
        Sun, 10 Apr 2022 14:39:32 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav415.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp);
 Sun, 10 Apr 2022 14:39:32 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav415.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23A5dWJY062776
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 10 Apr 2022 14:39:32 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <fa445f0e-32b7-5e0d-9326-94bc5adba4c1@I-love.SAKURA.ne.jp>
Date:   Sun, 10 Apr 2022 14:39:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] KASAN: use-after-free Read in tcp_retransmit_timer (5)
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Eric Dumazet <edumazet@google.com>
Cc:     bpf <bpf@vger.kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tpa@hlghospital.com, Yonghong Song <yhs@fb.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Trond Myklebust <trondmy@hammerspace.com>
References: <00000000000045dc96059f4d7b02@google.com>
 <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
 <CANn89i+wAtSy0aajXqbZBgAh+M4_-t7mDb9TfqQTRG3aHQkmrQ@mail.gmail.com>
 <CANn89i+484ffqb93aQm1N-tjxxvb3WDKX0EbD7318RwRgsatjw@mail.gmail.com>
 <CANn89i+rkip6uQ2SySspG+3WX6mR-CTHbQFLw1qUo4G4W5cn8g@mail.gmail.com>
 <af8a3cc6-ee2f-f1ab-ee78-8e5988a9a2f8@I-love.SAKURA.ne.jp>
In-Reply-To: <af8a3cc6-ee2f-f1ab-ee78-8e5988a9a2f8@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/04/10 9:38, Tetsuo Handa wrote:
> I haven't identified where the socket
> 
> [  260.295512][    C0] BUG: Trying to access destroyed net=ffff888036278000 sk=ffff88800e2d8000
> [  260.301941][    C0] sk->sk_family=10 sk->sk_prot_creator->name=TCPv6 sk->sk_state=11 sk->sk_flags=0x30b net->ns.count=0
> 
> came from. Can you identify the location?
> 

It seems that a socket with sk->sk_net_refcnt=0 is created by unshare(CLONE_NEWNET)

------------------------------------------------------------
[   84.507864][ T2877] sock: sk_alloc(): family=10 net=ffff88800ec88000 sk=ffff888104138c40 sk->sk_net_refcnt=0
[   84.512117][ T2877] CPU: 0 PID: 2877 Comm: a.out Not tainted 5.17.0-dirty #756
[   84.515103][ T2877] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   84.518916][ T2877] Call Trace:
[   84.520346][ T2877]  <TASK>
[   84.521671][ T2877]  dump_stack_lvl+0xcd/0x134
[   84.523633][ T2877]  sk_alloc.cold+0x26/0x2b
[   84.525523][ T2877]  inet6_create+0x215/0x840
[   84.527600][ T2877]  __sock_create+0x20e/0x4f0
[   84.529576][ T2877]  rds_tcp_listen_init+0x69/0x1f0
[   84.531689][ T2877]  ? do_raw_spin_unlock+0x50/0xd0
[   84.533826][ T2877]  ? _raw_spin_unlock+0x24/0x40
[   84.535866][ T2877]  ? __sanitizer_cov_trace_pc+0x1a/0x40
[   84.538109][ T2877]  ? __register_sysctl_table+0x384/0x6d0
[   84.540459][ T2877]  rds_tcp_init_net+0x154/0x300
[   84.542512][ T2877]  ? rds_tcp_exit+0x1f0/0x1f0
[   84.544488][ T2877]  ops_init+0x4e/0x210
[   84.546237][ T2877]  setup_net+0x22b/0x4a0
[   84.548075][ T2877]  copy_net_ns+0x1a3/0x380
[   84.550132][ T2877]  create_new_namespaces.isra.0+0x187/0x460
[   84.552740][ T2877]  unshare_nsproxy_namespaces+0xa2/0x120
[   84.555040][ T2877]  ksys_unshare+0x2fe/0x640
[   84.556861][ T2877]  __x64_sys_unshare+0x12/0x20
[   84.558756][ T2877]  do_syscall_64+0x35/0xb0
[   84.561296][ T2877]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   84.563605][ T2877] RIP: 0033:0x7f9030c55e2b
[   84.565323][ T2877] Code: 73 01 c3 48 8b 0d 65 c0 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 35 c0 0c 00 f7 d8 64 89 01 48
[   84.572520][ T2877] RSP: 002b:00007fffddd1ef88 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
[   84.576338][ T2877] RAX: ffffffffffffffda RBX: 000055c460627880 RCX: 00007f9030c55e2b
[   84.579952][ T2877] RDX: 00007fffddd1f198 RSI: 00007fffddd1f188 RDI: 0000000040000000
[   84.583656][ T2877] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f9030d67d50
[   84.586688][ T2877] R10: 0000000000000000 R11: 0000000000000246 R12: 000055c460627410
[   84.589682][ T2877] R13: 00007fffddd1f180 R14: 0000000000000000 R15: 0000000000000000
[   84.593111][ T2877]  </TASK>
------------------------------------------------------------

and something creates a new socket by invoking sk_clone_lock().
But since sk->sk_net_refcnt=0, net->ns.count is not incremented when the new socket is created.

------------------------------------------------------------
[   85.280860][    C0] sock: sk_clone_lock(): sk=ffff888104138c40 net=ffff88800ec88000 sk->sk_family=10 sk->sk_net_refcnt=0 refcount_read(&net->ns.count)=2
[   85.286319][    C0] sock: sk_clone_lock(): newsk=ffff888104139880 net=ffff88800ec88000 newsk->sk_family=10 newsk->sk_net_refcnt=0 refcount_read(&net->ns.count)=2
[   85.292668][    C0] CPU: 0 PID: 2877 Comm: a.out Not tainted 5.17.0-dirty #756
[   85.295870][    C0] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[   85.299371][    C0] Call Trace:
[   85.300734][    C0]  <IRQ>
[   85.302049][    C0]  dump_stack_lvl+0xcd/0x134
[   85.303996][    C0]  sk_clone_lock.cold+0x37/0x70
[   85.305959][    C0]  inet_csk_clone_lock+0x1f/0x110
[   85.308022][    C0]  tcp_create_openreq_child+0x2c/0x560
[   85.310198][    C0]  tcp_v4_syn_recv_sock+0x73/0x810
[   85.312460][    C0]  tcp_v6_syn_recv_sock+0x9cf/0x1020
[   85.314549][    C0]  ? find_held_lock+0x2b/0x80
[   85.316714][    C0]  ? write_comp_data+0x1c/0x70
[   85.318581][    C0]  ? write_comp_data+0x1c/0x70
[   85.320685][    C0]  ? tcp_parse_options+0xb4/0x660
[   85.322841][    C0]  tcp_check_req+0x31a/0xa60
[   85.324750][    C0]  tcp_v4_rcv+0x150f/0x1de0
[   85.326518][    C0]  ip_protocol_deliver_rcu+0x52/0x630
[   85.328923][    C0]  ip_local_deliver_finish+0xb4/0x1d0
[   85.331626][    C0]  ip_local_deliver+0xa7/0x320
[   85.333702][    C0]  ? ip_protocol_deliver_rcu+0x630/0x630
[   85.335873][    C0]  ip_rcv_finish+0x108/0x170
[   85.337775][    C0]  ip_rcv+0x69/0x2f0
[   85.339461][    C0]  ? ip_rcv_finish_core.isra.0+0xbb0/0xbb0
[   85.341973][    C0]  __netif_receive_skb_one_core+0x6a/0xa0
[   85.344625][    C0]  __netif_receive_skb+0x24/0xa0
[   85.346637][    C0]  process_backlog+0x11d/0x320
[   85.348778][    C0]  __napi_poll+0x3d/0x3e0
[   85.350974][    C0]  net_rx_action+0x34e/0x480
[   85.353042][    C0]  __do_softirq+0xde/0x539
[   85.354871][    C0]  ? sock_setsockopt+0x103/0x19f0
[   85.356926][    C0]  do_softirq+0xb1/0xf0
[   85.358650][    C0]  </IRQ>
[   85.359962][    C0]  <TASK>
[   85.361518][    C0]  __local_bh_enable_ip+0xbf/0xd0
[   85.364170][    C0]  sock_setsockopt+0x103/0x19f0
[   85.366200][    C0]  ? __sanitizer_cov_trace_pc+0x1a/0x40
[   85.368309][    C0]  __sys_setsockopt+0x2d1/0x330
[   85.370298][    C0]  __x64_sys_setsockopt+0x22/0x30
[   85.372428][    C0]  do_syscall_64+0x35/0xb0
[   85.374243][    C0]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   85.376538][    C0] RIP: 0033:0x7f9030c5677e
[   85.378474][    C0] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb bb 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e2 b6 0c 00 f7 d8 64 89 01 48
[   85.386716][    C0] RSP: 002b:00007fffddd1ef88 EFLAGS: 00000217 ORIG_RAX: 0000000000000036
[   85.389991][    C0] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f9030c5677e
[   85.393300][    C0] RDX: 0000000000000032 RSI: 0000000000000001 RDI: 0000000000000004
[   85.396636][    C0] RBP: 00007fffddd1ef9c R08: 0000000000000004 R09: 0000000000000000
[   85.399672][    C0] R10: 00007fffddd1ef9c R11: 0000000000000217 R12: 00007fffddd1efa0
[   85.403298][    C0] R13: 0000000000000003 R14: 00007fffddd1eff0 R15: 0000000000000000
[   85.406311][    C0]  </TASK>
------------------------------------------------------------

Then, when the original socket is close()d and destructed, net->ns.count is decremented.

------------------------------------------------------------
[  204.164238][    C1] sock: __sk_destruct(): sk=ffff888104138c40 family=10 net=ffff88800ec88000 sk->sk_net_refcnt=0
------------------------------------------------------------

But the cloned socket is still there and TCP retransmit timer fires.

------------------------------------------------------------
[  224.550620][    C0] BUG: Trying to access destroyed net=ffff88800ec88000 sk=ffff888104139880
[  224.555669][    C0] sk->sk_family=10 sk->sk_prot_creator->name=TCPv6 sk->sk_state=11 sk->sk_flags=0x30b net->ns.count=0
[  224.562340][    C0] ------------[ cut here ]------------
[  224.564697][    C0] WARNING: CPU: 0 PID: 0 at net/ipv4/tcp_timer.c:461 tcp_retransmit_timer.cold+0xdf/0xe6
[  224.569214][    C0] Modules linked in:
[  224.571197][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-dirty #756
[  224.574659][    C0] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  224.578719][    C0] RIP: 0010:tcp_retransmit_timer.cold+0xdf/0xe6
[  224.581467][    C0] Code: 10 48 c7 c7 08 9f ff 83 48 8b 85 a0 03 00 00 44 8b 8b 4c 01 00 00 4c 8b 45 60 0f b6 4d 12 48 8d 90 88 01 00 00 e8 fe 24 f2 ff <0f> 0b e9 9c 40 5f ff e8 49 59 ee fd 41 0f b6 d5 4c 89 e6 48 c7 c7
[  224.589620][    C0] RSP: 0018:ffffc90000003d90 EFLAGS: 00010286
[  224.592253][    C0] RAX: 0000000000000063 RBX: ffff88800ec88000 RCX: ffffffff842622c0
[  224.595621][    C0] RDX: 0000000000000000 RSI: ffffffff842622c0 RDI: 0000000000000002
[  224.599035][    C0] RBP: ffff888104139880 R08: ffffffff81170398 R09: 0000000000000000
[  224.602406][    C0] R10: 0000000000000005 R11: 0000000000080000 R12: 0000000000000001
[  224.605791][    C0] R13: ffff888104139880 R14: ffff888104139918 R15: ffff888104139900
[  224.609110][    C0] FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
[  224.612767][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  224.615409][    C0] CR2: 00007f11279aa340 CR3: 000000000d735000 CR4: 00000000000506f0
[  224.618937][    C0] Call Trace:
[  224.620480][    C0]  <IRQ>
[  224.621889][    C0]  ? lockdep_hardirqs_on+0x79/0x100
[  224.624114][    C0]  ? __sanitizer_cov_trace_pc+0x1a/0x40
[  224.626512][    C0]  ? ktime_get+0x2d3/0x400
[  224.628463][    C0]  tcp_write_timer_handler+0x257/0x3f0
[  224.630776][    C0]  tcp_write_timer+0x19c/0x240
[  224.632860][    C0]  ? tcp_write_timer_handler+0x3f0/0x3f0
[  224.635251][    C0]  call_timer_fn+0xe3/0x4f0
[  224.637699][    C0]  ? tcp_write_timer_handler+0x3f0/0x3f0
[  224.640055][    C0]  run_timer_softirq+0x812/0xac0
[  224.642270][    C0]  __do_softirq+0xde/0x539
[  224.644238][    C0]  irq_exit_rcu+0xb6/0xf0
[  224.646170][    C0]  sysvec_apic_timer_interrupt+0x8e/0xc0
[  224.648543][    C0]  </IRQ>
[  224.650083][    C0]  <TASK>
[  224.651715][    C0]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[  224.654189][    C0] RIP: 0010:default_idle+0xb/0x10
[  224.656669][    C0] Code: 00 00 00 75 09 48 83 c4 18 5b 5d 41 5c c3 e8 5c 96 fe ff cc cc cc cc cc cc cc cc cc cc cc cc eb 07 0f 00 2d e3 08 48 00 fb f4 <c3> 0f 1f 40 00 65 48 8b 04 25 40 af 01 00 f0 80 48 02 20 48 8b 10
[  224.663980][    C0] RSP: 0018:ffffffff84203e90 EFLAGS: 00000202
[  224.666737][    C0] RAX: 0000000000030067 RBX: 0000000000000000 RCX: ffffffff842622c0
[  224.670022][    C0] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
[  224.673311][    C0] RBP: ffffffff842622c0 R08: 0000000000000001 R09: 0000000000000001
[  224.676957][    C0] R10: 0000000000000001 R11: 0000000000080000 R12: 0000000000000000
[  224.680232][    C0] R13: ffffffff842622c0 R14: 0000000000000000 R15: 0000000000000000
[  224.683617][    C0]  default_idle_call+0x6a/0x260
[  224.685750][    C0]  do_idle+0x20c/0x260
[  224.687593][    C0]  ? trace_init_perf_perm_irq_work_exit+0xe/0xe
[  224.690199][    C0]  cpu_startup_entry+0x14/0x20
[  224.692248][    C0]  start_kernel+0x8f7/0x91e
[  224.694223][    C0]  secondary_startup_64_no_verify+0xc3/0xcb
[  224.697014][    C0]  </TASK>
------------------------------------------------------------

mptcp_subflow_create_socket() increments net->ns.count and sets
sk->sk_net_refcnt = 1, but e.g. rds_tcp_listen_init() does not?

------------------------------------------------------------
int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
{
        struct mptcp_subflow_context *subflow;
        struct net *net = sock_net(sk);
        struct socket *sf;
        int err;

        /* un-accepted server sockets can reach here - on bad configuration
         * bail early to avoid greater trouble later
         */
        if (unlikely(!sk->sk_socket))
                return -EINVAL;

        err = sock_create_kern(net, sk->sk_family, SOCK_STREAM, IPPROTO_TCP,
                               &sf);
        if (err)
                return err;

        lock_sock(sf->sk);

        /* the newly created socket has to be in the same cgroup as its parent */
        mptcp_attach_cgroup(sk, sf->sk);

        /* kernel sockets do not by default acquire net ref, but TCP timer
         * needs it.
         */
        sf->sk->sk_net_refcnt = 1;
        get_net_track(net, &sf->sk->ns_tracker, GFP_KERNEL);
        sock_inuse_add(net, 1);
------------------------------------------------------------
