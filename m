Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396D9513439
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 14:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235580AbiD1MzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 08:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232445AbiD1MzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 08:55:06 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB025AC068;
        Thu, 28 Apr 2022 05:51:49 -0700 (PDT)
Received: from kwepemi100003.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KpwRT7587zGp2D;
        Thu, 28 Apr 2022 20:49:09 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi100003.china.huawei.com (7.221.188.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Apr 2022 20:51:47 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Apr 2022 20:51:46 +0800
Message-ID: <3bf34932-1444-b914-3610-422de259d60d@huawei.com>
Date:   Thu, 28 Apr 2022 20:51:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] SUNRPC: Fix local socket leak in
 xs_local_setup_socket()
From:   "wanghai (M)" <wanghai38@huawei.com>
To:     Trond Myklebust <trondmy@hammerspace.com>,
        "anna@kernel.org" <anna@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220426132011.25418-1-wanghai38@huawei.com>
 <d013bdc75085e380250cb79edf2b27680cbc9f7e.camel@hammerspace.com>
 <2edb137e-b12f-e912-8c2b-9ad3737a0182@huawei.com>
In-Reply-To: <2edb137e-b12f-e912-8c2b-9ad3737a0182@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/27 15:15, wanghai (M) 写道:
>
> 在 2022/4/27 2:51, Trond Myklebust 写道:
>> On Tue, 2022-04-26 at 21:20 +0800, Wang Hai wrote:
>>> If the connection to a local endpoint in xs_local_setup_socket()
>>> fails,
>>> fput() is missing in the error path, which will result in a socket
>>> leak.
>>> It can be reproduced in simple script below.
>>>
>>> while true
>>> do
>>>          systemctl stop rpcbind.service
>>>          systemctl stop rpc-statd.service
>>>          systemctl stop nfs-server.service
>>>
>>>          systemctl restart rpcbind.service
>>>          systemctl restart rpc-statd.service
>>>          systemctl restart nfs-server.service
>>> done
>>>
>>> When executing the script, you can observe that the
>>> "cat /proc/net/unix | wc -l" count keeps growing.
>>>
>>> Add the missing fput(), and restore transport to old socket.
>>>
>>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>>> ---
>>>   net/sunrpc/xprtsock.c | 20 ++++++++++++++++++--
>>>   1 file changed, 18 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
>>> index 0f39e08ee580..7219c545385e 100644
>>> --- a/net/sunrpc/xprtsock.c
>>> +++ b/net/sunrpc/xprtsock.c
>>> @@ -1819,6 +1819,9 @@ static int xs_local_finish_connecting(struct
>>> rpc_xprt *xprt,
>>>   {
>>>          struct sock_xprt *transport = container_of(xprt, struct
>>> sock_xprt,
>>>     xprt);
>>> +       struct socket *trans_sock = NULL;
>>> +       struct sock *trans_inet = NULL;
>>> +       int ret;
>>>            if (!transport->inet) {
>>>                  struct sock *sk = sock->sk;
>>> @@ -1835,6 +1838,9 @@ static int xs_local_finish_connecting(struct
>>> rpc_xprt *xprt,
>>>                    xprt_clear_connected(xprt);
>>>   +               trans_sock = transport->sock;
>>> +               trans_inet = transport->inet;
>>> +
>> Both values are NULL here
> Got it, thanks
>>
>>>                  /* Reset to new socket */
>>>                  transport->sock = sock;
>>>                  transport->inet = sk;
>>> @@ -1844,7 +1850,14 @@ static int xs_local_finish_connecting(struct
>>> rpc_xprt *xprt,
>>>            xs_stream_start_connect(transport);
>>>   -       return kernel_connect(sock, xs_addr(xprt), xprt->addrlen, 0);
>>> +       ret = kernel_connect(sock, xs_addr(xprt), xprt->addrlen, 0);
>>> +       /* Restore to old socket */
>>> +       if (ret && trans_inet) {
>>> +               transport->sock = trans_sock;
>>> +               transport->inet = trans_inet;
>>> +       }
>>> +
>>> +       return ret;
>>>   }
>>>     /**
>>> @@ -1887,7 +1900,7 @@ static int xs_local_setup_socket(struct
>>> sock_xprt *transport)
>>>                  xprt->stat.connect_time += (long)jiffies -
>>> xprt->stat.connect_start;
>>>                  xprt_set_connected(xprt);
>>> -               break;
>>> +               goto out;
>>>          case -ENOBUFS:
>>>                  break;
>>>          case -ENOENT:
>>> @@ -1904,6 +1917,9 @@ static int xs_local_setup_socket(struct
>>> sock_xprt *transport)
>>>                                  xprt-
>>>> address_strings[RPC_DISPLAY_ADDR]);
>>>          }
>>>   +       transport->file = NULL;
>>> +       fput(filp);
>> Please just call xprt_force_disconnect() so that this can be cleaned up
>> from     a safe context.
>
> Hi, Trond
>
> Thank you for your advice, I tried this, but it doesn't seem to
>
> work and an error is reported. I'll analyze why this happens
>
>
Hi, Trond.

If I call xprt_force_disconnect(), it reports the following error,
I spent a long time but couldn't find the cause of the error. If I
call xs_close(), it works, is it possible to call xs_close() here?

[  107.147326][ T7128] 
======================================================
[  107.147329][ T7128] WARNING: possible circular locking dependency 
detected
[  107.147333][ T7128] 5.17.0+ #10 Not tainted
[  107.147340][ T7128] 
------------------------------------------------------
[  107.147343][ T7128] rpc.nfsd/7128 is trying to acquire lock:
[  107.147349][ T7128] ffffffff850f4960 (console_owner){..-.}-{0:0}, at: 
console_unlock+0x1d7/0x790
[  107.147384][ T7128]
[  107.147384][ T7128] but task is already holding lock:
[  107.147387][ T7128] ffff88824010b418 (&pool->lock/1){-.-.}-{2:2}, at: 
__queue_work+0x450/0x810
[  107.147420][ T7128]
[  107.147420][ T7128] which lock already depends on the new lock.
[  107.147420][ T7128]
[  107.147423][ T7128]
[  107.147423][ T7128] the existing dependency chain (in reverse order) is:
[  107.147426][ T7128]
[  107.147426][ T7128] -> #2 (&pool->lock/1){-.-.}-{2:2}:
[  107.147444][ T7128]        _raw_spin_lock+0x32/0x50
[  107.147482][ T7128]        __queue_work+0x131/0x810
[  107.147496][ T7128]        queue_work_on+0x88/0x90
[  107.147509][ T7128]        tty_flip_buffer_push+0x34/0x40
[  107.147525][ T7128]        serial8250_rx_chars+0x73/0x80
[  107.147537][ T7128] serial8250_handle_irq.part.21+0x124/0x160
[  107.147552][ T7128] serial8250_default_handle_irq+0x79/0x90
[  107.147566][ T7128]        serial8250_interrupt+0x73/0xd0
[  107.147581][ T7128]        __handle_irq_event_percpu+0x54/0x3c0
[  107.147597][ T7128]        handle_irq_event_percpu+0x1c/0x50
[  107.147611][ T7128]        handle_irq_event+0x3e/0x60
[  107.147624][ T7128]        handle_edge_irq+0xc3/0x250
[  107.147636][ T7128]        __common_interrupt+0x71/0x140
[  107.147649][ T7128]        common_interrupt+0xbc/0xe0
[  107.147664][ T7128]        asm_common_interrupt+0x1e/0x40
[  107.147677][ T7128]        default_idle+0x14/0x20
[  107.147687][ T7128]        arch_cpu_idle+0xf/0x20
[  107.147698][ T7128]        default_idle_call+0x6f/0x230
[  107.147709][ T7128]        do_idle+0x1c4/0x250
[  107.147722][ T7128]        cpu_startup_entry+0x1d/0x20
[  107.147736][ T7128]        start_secondary+0xe6/0xf0
[  107.147751][ T7128] secondary_startup_64_no_verify+0xc3/0xcb
[  107.147767][ T7128]
[  107.147767][ T7128] -> #1 (&port_lock_key){-.-.}-{2:2}:
[  107.147783][ T7128]        _raw_spin_lock_irqsave+0x42/0x60
[  107.147795][ T7128]        serial8250_console_write+0x31b/0x380
[  107.147808][ T7128]        univ8250_console_write+0x3a/0x50
[  107.147820][ T7128]        console_unlock+0x51d/0x790
[  107.147832][ T7128]        vprintk_emit+0x252/0x320
[  107.147844][ T7128]        vprintk_default+0x2b/0x30
[  107.147856][ T7128]        vprintk+0x71/0x80
[  107.147868][ T7128]        _printk+0x63/0x82
[  107.147879][ T7128]        register_console+0x233/0x400
[  107.147892][ T7128]        univ8250_console_init+0x35/0x3f
[  107.147907][ T7128]        console_init+0x233/0x345
[  107.147920][ T7128]        start_kernel+0xa70/0xbf8
[  107.147931][ T7128]        x86_64_start_reservations+0x2a/0x2c
[  107.147947][ T7128]        x86_64_start_kernel+0x90/0x95
[  107.147961][ T7128] secondary_startup_64_no_verify+0xc3/0xcb
[  107.147975][ T7128]
[  107.147975][ T7128] -> #0 (console_owner){..-.}-{0:0}:
[  107.147990][ T7128]        __lock_acquire+0x1552/0x1a30
[  107.148002][ T7128]        lock_acquire+0x25e/0x2f0
[  107.148014][ T7128]        console_unlock+0x22e/0x790
[  107.148026][ T7128]        vprintk_emit+0x252/0x320
[  107.148038][ T7128]        vprintk_default+0x2b/0x30
[  107.148050][ T7128]        vprintk+0x71/0x80
[  107.148061][ T7128]        _printk+0x63/0x82
[  107.148072][ T7128]        report_bug+0x1a6/0x1c0
[  107.148085][ T7128]        handle_bug+0x43/0x70
[  107.148098][ T7128]        exc_invalid_op+0x18/0x70
[  107.148111][ T7128]        asm_exc_invalid_op+0x12/0x20
[  107.148123][ T7128]        __queue_work+0x72a/0x810
[  107.148136][ T7128]        queue_work_on+0x88/0x90
[  107.148149][ T7128] xprt_schedule_autoclose_locked+0x7a/0xb0
[  107.148162][ T7128]        xprt_force_disconnect+0x53/0x150
[  107.148173][ T7128]        xs_local_setup_socket+0x2b2/0x480
[  107.148188][ T7128]        xs_setup_local+0x24b/0x280
[  107.148200][ T7128]        xprt_create_transport+0xb0/0x340
[  107.148212][ T7128]        rpc_create+0x104/0x2b0
[  107.148226][ T7128]        rpcb_create_local_unix+0xb2/0x2c0
[  107.148242][ T7128]        rpcb_create_local+0x79/0x90
[  107.148256][ T7128]        svc_bind+0x92/0xd0
[  107.148267][ T7128]        nfsd_create_serv+0x131/0x3a0
[  107.148280][ T7128]        write_ports+0x2d4/0x8d0
[  107.148292][ T7128]        nfsctl_transaction_write+0x70/0xb0
[  107.148305][ T7128]        vfs_write+0x11d/0x4b0
[  107.148319][ T7128]        ksys_write+0xe0/0x130
[  107.148330][ T7128]        __x64_sys_write+0x23/0x30
[  107.148343][ T7128]        do_syscall_64+0x34/0xb0
[  107.148356][ T7128] entry_SYSCALL_64_after_hwframe+0x44/0xae
[  107.148369][ T7128]
[  107.148369][ T7128] other info that might help us debug this:
[  107.148369][ T7128]
[  107.148372][ T7128] Chain exists of:
[  107.148372][ T7128]   console_owner --> &port_lock_key --> &pool->lock/1
[  107.148372][ T7128]
[  107.148392][ T7128]  Possible unsafe locking scenario:
[  107.148392][ T7128]
[  107.148395][ T7128]        CPU0                    CPU1
[  107.148397][ T7128]        ----                    ----
[  107.148399][ T7128]   lock(&pool->lock/1);
[  107.148409][ T7128] lock(&port_lock_key);
[  107.148416][ T7128] lock(&pool->lock/1);
[  107.148426][ T7128]   lock(console_owner);
[  107.148432][ T7128]
[  107.148432][ T7128]  *** DEADLOCK ***
[  107.148432][ T7128]
[  107.148434][ T7128] 7 locks held by rpc.nfsd/7128:
[  107.148442][ T7128]  #0: ffff8882480a4460 
(sb_writers#12){.+.+}-{0:0}, at: ksys_write+0xe0/0x130
[  107.148474][ T7128]  #1: ffffffff8526ee88 (nfsd_mutex){+.+.}-{3:3}, 
at: write_ports+0x41/0x8d0
[  107.148503][ T7128]  #2: ffffffff854cdc88 
(rpcb_create_local_mutex){+.+.}-{3:3}, at: rpcb_create_local+0x43/0x90
[  107.148534][ T7128]  #3: ffff888243f14740 
(&xprt->transport_lock){+.+.}-{2:2}, at: xprt_force_disconnect+0x4b/0x150
[  107.148562][ T7128]  #4: ffffffff851d7a60 
(rcu_read_lock){....}-{1:2}, at: __queue_work+0x5a/0x810
[  107.148592][ T7128]  #5: ffff88824010b418 
(&pool->lock/1){-.-.}-{2:2}, at: __queue_work+0x450/0x810
[  107.148625][ T7128]  #6: ffffffff851d4d60 (console_lock){+.+.}-{0:0}, 
at: vprintk_emit+0x114/0x320
[  107.148653][ T7128]
[  107.148653][ T7128] stack backtrace:
[  107.148656][ T7128] CPU: 3 PID: 7128 Comm: rpc.nfsd Not tainted 
5.17.0+ #10
[  107.148670][ T7128] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[  107.148677][ T7128] Call Trace:
[  107.148680][ T7128]  <TASK>
[  107.148685][ T7128]  dump_stack_lvl+0x6c/0x8b
[  107.148702][ T7128]  dump_stack+0x15/0x17
[  107.148715][ T7128]  print_circular_bug.isra.46+0x261/0x2c0
[  107.148767][ T7128]  check_noncircular+0x105/0x120
[  107.148787][ T7128]  __lock_acquire+0x1552/0x1a30
[  107.148800][ T7128]  ? __lock_acquire+0x1552/0x1a30
[  107.148820][ T7128]  lock_acquire+0x25e/0x2f0
[  107.148833][ T7128]  ? console_unlock+0x1d7/0x790
[  107.148848][ T7128]  ? lock_release+0x204/0x2c0
[  107.148865][ T7128]  console_unlock+0x22e/0x790
[  107.148878][ T7128]  ? console_unlock+0x1d7/0x790
[  107.148900][ T7128]  vprintk_emit+0x252/0x320
[  107.148916][ T7128]  vprintk_default+0x2b/0x30
[  107.148931][ T7128]  vprintk+0x71/0x80
[  107.148945][ T7128]  _printk+0x63/0x82
[  107.148959][ T7128]  ? report_bug+0x19a/0x1c0
[  107.148974][ T7128]  ? __queue_work+0x72a/0x810
[  107.148988][ T7128]  report_bug+0x1a6/0x1c0
[  107.149004][ T7128]  handle_bug+0x43/0x70
[  107.149019][ T7128]  exc_invalid_op+0x18/0x70
[  107.149034][ T7128]  asm_exc_invalid_op+0x12/0x20
[  107.149047][ T7128] RIP: 0010:__queue_work+0x72a/0x810
[  107.149063][ T7128] Code: 48 c7 c7 78 7b b8 84 c6 05 b1 f4 39 04 01 
e8 ad 65 05 00 e9 7f fe ff ff e8 33 94 11 00 4c 8b 33 e9 ff f9 ff ff e8 
26 94 11 00 <0f> 0b e9 d2 fa ff ff e8 1a 94 11 00 4c 8d 7b 68 41 83 cc 
02 e9 aa
[  107.149077][ T7128] RSP: 0018:ffffc900042efa88 EFLAGS: 00010093
[  107.149087][ T7128] RAX: 0000000000000000 RBX: ffff88824013c100 RCX: 
0000000000000000
[  107.149096][ T7128] RDX: ffff888111b15140 RSI: ffffffff8119be6a RDI: 
ffffffff84c6fd9e
[  107.149104][ T7128] RBP: ffffc900042efac8 R08: 0000000000000001 R09: 
0000000000000000
[  107.149112][ T7128] R10: 0000000000000002 R11: 000000000000f2ce R12: 
0000000000000000
[  107.149120][ T7128] R13: ffff888243f14668 R14: ffff888237c2d440 R15: 
ffff888240ffc000
[  107.149134][ T7128]  ? __queue_work+0x72a/0x810
[  107.149151][ T7128]  ? __queue_work+0x72a/0x810
[  107.149169][ T7128]  queue_work_on+0x88/0x90
[  107.149185][ T7128]  xprt_schedule_autoclose_locked+0x7a/0xb0
[  107.149200][ T7128]  xprt_force_disconnect+0x53/0x150
[  107.149213][ T7128]  xs_local_setup_socket+0x2b2/0x480
[  107.149230][ T7128]  xs_setup_local+0x24b/0x280
[  107.149245][ T7128]  xprt_create_transport+0xb0/0x340
[  107.149259][ T7128]  rpc_create+0x104/0x2b0
[  107.149278][ T7128]  ? __this_cpu_preempt_check+0x1c/0x20
[  107.149293][ T7128]  ? lock_is_held_type+0xde/0x130
[  107.149307][ T7128]  rpcb_create_local_unix+0xb2/0x2c0
[  107.149332][ T7128]  rpcb_create_local+0x79/0x90
[  107.149348][ T7128]  svc_bind+0x92/0xd0
[  107.149363][ T7128]  nfsd_create_serv+0x131/0x3a0
[  107.149378][ T7128]  write_ports+0x2d4/0x8d0
[  107.149392][ T7128]  ? _copy_from_user+0x8b/0xe0
[  107.149411][ T7128]  ? nfsd_init_net+0x2d0/0x2d0
[  107.149425][ T7128]  nfsctl_transaction_write+0x70/0xb0
[  107.149439][ T7128]  ? export_features_show+0x30/0x30
[  107.149454][ T7128]  vfs_write+0x11d/0x4b0
[  107.149470][ T7128]  ksys_write+0xe0/0x130
[  107.149486][ T7128]  __x64_sys_write+0x23/0x30
[  107.149501][ T7128]  do_syscall_64+0x34/0xb0
[  107.149515][ T7128]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  107.149530][ T7128] RIP: 0033:0x7feb99b00130
[  107.149540][ T7128] Code: 73 01 c3 48 8b 0d 58 ed 2c 00 f7 d8 64 89 
01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d b9 45 2d 00 00 75 10 b8 01 00 
00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 3e f3 01 00 48 
89 04 24
[  107.149553][ T7128] RSP: 002b:00007ffc849b68e8 EFLAGS: 00000246 
ORIG_RAX: 0000000000000001
[  107.149565][ T7128] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 
00007feb99b00130
[  107.149574][ T7128] RDX: 0000000000000002 RSI: 000055d532e09620 RDI: 
0000000000000003
[  107.149581][ T7128] RBP: 0000000000000003 R08: 000055d532c06704 R09: 
0000000000000000
[  107.149589][ T7128] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000004
[  107.149597][ T7128] R13: 000055d532e09620 R14: 000055d532c066bf R15: 
000055d533474730
[  107.149614][ T7128]  </TASK>
[  107.283659][ T7128] WARNING: CPU: 3 PID: 7128 at 
kernel/workqueue.c:1499 __queue_work+0x72a/0x810
[  107.283659][ T7128] Modules linked in:
[  107.283659][ T7128] CPU: 3 PID: 7128 Comm: rpc.nfsd Not tainted 
5.17.0+ #10
[  107.283659][ T7128] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[  107.283659][ T7128] RIP: 0010:__queue_work+0x72a/0x810
[  107.283659][ T7128] Code: 48 c7 c7 78 7b b8 84 c6 05 b1 f4 39 04 01 
e8 ad 65 05 00 e9 7f fe ff ff e8 33 94 11 00 4c 8b 33 e9 ff f9 ff ff e8 
26 94 11 00 <0f> 0b e9 d2 fa ff ff e8 1a 94 11 00 4c 8d 7b 68 41 83 cc 
02 e9 aa
[  107.283659][ T7128] RSP: 0018:ffffc900042efa88 EFLAGS: 00010093
[  107.283659][ T7128] RAX: 0000000000000000 RBX: ffff88824013c100 RCX: 
0000000000000000
[  107.283659][ T7128] RDX: ffff888111b15140 RSI: ffffffff8119be6a RDI: 
ffffffff84c6fd9e
[  107.283659][ T7128] RBP: ffffc900042efac8 R08: 0000000000000001 R09: 
0000000000000000
[  107.283659][ T7128] R10: 0000000000000002 R11: 000000000000f2ce R12: 
0000000000000000
[  107.283659][ T7128] R13: ffff888243f14668 R14: ffff888237c2d440 R15: 
ffff888240ffc000
[  107.283659][ T7128] FS:  00007feb9a89ac80(0000) 
GS:ffff888437c80000(0000) knlGS:0000000000000000
[  107.283659][ T7128] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  107.283659][ T7128] CR2: 00007ffc849ba084 CR3: 0000000247402000 CR4: 
00000000000006e0
[  107.283659][ T7128] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  107.283659][ T7128] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  107.283659][ T7128] Call Trace:
[  107.283659][ T7128]  <TASK>
[  107.283659][ T7128]  queue_work_on+0x88/0x90
[  107.283659][ T7128]  xprt_schedule_autoclose_locked+0x7a/0xb0
[  107.283659][ T7128]  xprt_force_disconnect+0x53/0x150
[  107.283659][ T7128]  xs_local_setup_socket+0x2b2/0x480
[  107.283659][ T7128]  xs_setup_local+0x24b/0x280
[  107.283659][ T7128]  xprt_create_transport+0xb0/0x340
[  107.283659][ T7128]  rpc_create+0x104/0x2b0
[  107.283659][ T7128]  ? __this_cpu_preempt_check+0x1c/0x20
[  107.283659][ T7128]  ? lock_is_held_type+0xde/0x130
[  107.283659][ T7128]  rpcb_create_local_unix+0xb2/0x2c0
[  107.283659][ T7128]  rpcb_create_local+0x79/0x90
[  107.283659][ T7128]  svc_bind+0x92/0xd0
[  107.283659][ T7128]  nfsd_create_serv+0x131/0x3a0
[  107.283659][ T7128]  write_ports+0x2d4/0x8d0
[  107.283659][ T7128]  ? _copy_from_user+0x8b/0xe0
[  107.283659][ T7128]  ? nfsd_init_net+0x2d0/0x2d0
[  107.283659][ T7128]  nfsctl_transaction_write+0x70/0xb0
[  107.283659][ T7128]  ? export_features_show+0x30/0x30
[  107.283659][ T7128]  vfs_write+0x11d/0x4b0
[  107.283659][ T7128]  ksys_write+0xe0/0x130
[  107.283659][ T7128]  __x64_sys_write+0x23/0x30
[  107.283659][ T7128]  do_syscall_64+0x34/0xb0
[  107.283659][ T7128]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  107.283659][ T7128] RIP: 0033:0x7feb99b00130
[  107.283659][ T7128] Code: 73 01 c3 48 8b 0d 58 ed 2c 00 f7 d8 64 89 
01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d b9 45 2d 00 00 75 10 b8 01 00 
00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 3e f3 01 00 48 
89 04 24
[  107.283659][ T7128] RSP: 002b:00007ffc849b68e8 EFLAGS: 00000246 
ORIG_RAX: 0000000000000001
[  107.283659][ T7128] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 
00007feb99b00130
[  107.283659][ T7128] RDX: 0000000000000002 RSI: 000055d532e09620 RDI: 
0000000000000003
[  107.283659][ T7128] RBP: 0000000000000003 R08: 000055d532c06704 R09: 
0000000000000000
[  107.283659][ T7128] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000004
[  107.283659][ T7128] R13: 000055d532e09620 R14: 000055d532c066bf R15: 
000055d533474730
[  107.283659][ T7128]  </TASK>
[  107.283659][ T7128] irq event stamp: 33702
[  107.283659][ T7128] hardirqs last  enabled at (33701): 
[<ffffffff814c2288>] cmpxchg_double_slab.isra.52+0xe8/0x220
[  107.283659][ T7128] hardirqs last disabled at (33702): 
[<ffffffff8119bfc3>] queue_work_on+0x73/0x90
[  107.283659][ T7128] softirqs last  enabled at (33670): 
[<ffffffff8367b7cc>] unix_release_sock+0xfc/0x540
[  107.283659][ T7128] softirqs last disabled at (33668): 
[<ffffffff8367b7a8>] unix_release_sock+0xd8/0x540
[  107.283659][ T7128] ---[ end trace 0000000000000000 ]---
[  107.622086][ T7128] svc: failed to register nfsdv2 RPC service (errno 
111).
[  107.627373][ T7128] svc: failed to register nfsaclv2 RPC service 
(errno 111).
Job for nfs-server.service canceled.
[  109.560632][ T7174] NFSD: Using UMH upcall client tracking operations.
[  109.564229][ T7174] NFSD: starting 90-second grace period (net f0000000)
>>> +
>>>   out:
>>>          xprt_clear_connecting(xprt);
>>>          xprt_wake_pending_tasks(xprt, status);
>
-- 
Wang Hai

