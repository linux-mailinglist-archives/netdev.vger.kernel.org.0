Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1DB6109AF
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 07:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJ1FUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 01:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJ1FUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 01:20:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EF627155;
        Thu, 27 Oct 2022 22:20:06 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mz9pY5ZTBzHvXP;
        Fri, 28 Oct 2022 13:19:49 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 13:20:03 +0800
Message-ID: <8fbd060e-bf77-9f42-7771-0ea058401827@huawei.com>
Date:   Fri, 28 Oct 2022 13:20:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH bpf-next v3 0/4] bpf, sockmap: Fix memleaks and issues of
 mem charge/uncharge
To:     Jakub Sitnicki <jakub@cloudflare.com>, <john.fastabend@gmail.com>
CC:     <daniel@iogearbox.net>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <bpf@vger.kernel.org>,
        <edumazet@google.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>
References: <20220304081145.2037182-1-wangyufen@huawei.com>
 <87v8o5gdw2.fsf@cloudflare.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <87v8o5gdw2.fsf@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/10/28 5:10, Jakub Sitnicki 写道:
> Wang, John,
>
> On Fri, Mar 04, 2022 at 04:11 PM +08, Wang Yufen wrote:
>> This patchset fixes memleaks and incorrect charge/uncharge memory, these
>> issues cause the following info:
>>
>> WARNING: CPU: 0 PID: 9202 at net/core/stream.c:205 sk_stream_kill_queues+0xc8/0xe0
>> Call Trace:
>>   <IRQ>
>>   inet_csk_destroy_sock+0x55/0x110
>>   tcp_rcv_state_process+0xe5f/0xe90
>>   ? sk_filter_trim_cap+0x10d/0x230
>>   ? tcp_v4_do_rcv+0x161/0x250
>>   tcp_v4_do_rcv+0x161/0x250
>>   tcp_v4_rcv+0xc3a/0xce0
>>   ip_protocol_deliver_rcu+0x3d/0x230
>>   ip_local_deliver_finish+0x54/0x60
>>   ip_local_deliver+0xfd/0x110
>>   ? ip_protocol_deliver_rcu+0x230/0x230
>>   ip_rcv+0xd6/0x100
>>   ? ip_local_deliver+0x110/0x110
>>   __netif_receive_skb_one_core+0x85/0xa0
>>   process_backlog+0xa4/0x160
>>   __napi_poll+0x29/0x1b0
>>   net_rx_action+0x287/0x300
>>   __do_softirq+0xff/0x2fc
>>   do_softirq+0x79/0x90
>>   </IRQ>
>>
>> WARNING: CPU: 0 PID: 531 at net/ipv4/af_inet.c:154 inet_sock_destruct+0x175/0x1b0
>> Call Trace:
>>   <TASK>
>>   __sk_destruct+0x24/0x1f0
>>   sk_psock_destroy+0x19b/0x1c0
>>   process_one_work+0x1b3/0x3c0
>>   ? process_one_work+0x3c0/0x3c0
>>   worker_thread+0x30/0x350
>>   ? process_one_work+0x3c0/0x3c0
>>   kthread+0xe6/0x110
>>   ? kthread_complete_and_exit+0x20/0x20
>>   ret_from_fork+0x22/0x30
>>   </TASK>
>>
>> Changes since v2:
>> -Move sk_msg_trim() logic into sk_msg_alloc while -ENOMEM occurs, as
>> Cong Wang suggested.
>>
>> Changes since v1:
>> -Update the commit message of patch #2, the error path is from ENOMEM not
>> the ENOSPC.
>> -Simply returning an error code when psock is null, as John Fastabend
>> suggested.
> This is going to sound a bit weird, but I'm actually observing the
> mentioned warnings with these patches applied, when running
> `test_sockmap` selftests. Without the patch set - all is well.
>
> Bisect went like so:
>
> broken  [bpf-next] 31af1aa09fb9 ("Merge branch 'bpf: Fixes for kprobe multi on kernel modules'")
> ...
> broken  2486ab434b2c ("bpf, sockmap: Fix double uncharge the mem of sk_msg")
> broken  84472b436e76 ("bpf, sockmap: Fix more uncharged while msg has more_data")
> working 9c34e38c4a87 ("bpf, sockmap: Fix memleak in tcp_bpf_sendmsg while sk msg is full")
> working 938d3480b92f ("bpf, sockmap: Fix memleak in sk_psock_queue_msg")
> working [base] d3b351f65bf4 ("selftests/bpf: Fix a clang compilation error for send_signal.c")
>
> At 84472b436e76 ("bpf, sockmap: Fix more uncharged while msg has
> more_data") I'm seeing:
>
> bash-5.1# uname -r
> 5.17.0-rc6-01987-g84472b436e76
> bash-5.1# cd tools/testing/selftests/bpf/
> bash-5.1# ./test_sockmap
> # 1/ 6  sockmap::txmsg test passthrough:OK
> # 2/ 6  sockmap::txmsg test redirect:OK
> # 3/ 6  sockmap::txmsg test drop:OK
> # 4/ 6  sockmap::txmsg test ingress redirect:OK
> # 5/ 7  sockmap::txmsg test skb:OK
> # 6/ 8  sockmap::txmsg test apply:OK
> # 7/12  sockmap::txmsg test cork:OK
> [   16.399282] ------------[ cut here ]------------
> [   16.400465] WARNING: CPU: 2 PID: 197 at net/core/stream.c:205 sk_stream_kill_queues+0xd3/0xf0
> [   16.402718] Modules linked in:
> [   16.403504] CPU: 2 PID: 197 Comm: test_sockmap Not tainted 5.17.0-rc6-01987-g84472b436e76 #76
> [   16.404276] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35 04/01/2014
> [   16.404800] RIP: 0010:sk_stream_kill_queues+0xd3/0xf0
> [   16.405110] Code: 29 5b 5d 31 c0 89 c2 89 c6 89 c7 c3 48 89 df e8 63 db fe ff 8b 83 78 02 00 00 8b b3 30 02 00 00 85 c0 74 d9 0f 0b 85 f6 74 d7 <0f> 0b 5b 5d 31 c0 89 c2 89 c6 89 c7 c3 0f 0b eb 92 66 66 2e 0f 1f
> [   16.406226] RSP: 0018:ffffc90000423d48 EFLAGS: 00010206
> [   16.406545] RAX: 0000000000000000 RBX: ffff888104208000 RCX: 0000000000000000
> [   16.407117] RDX: 0000000000000000 RSI: 0000000000000fc0 RDI: ffff8881042081b8
> [   16.407571] RBP: ffff8881042081b8 R08: 0000000000000000 R09: 0000000000000000
> [   16.407995] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888104208000
> [   16.408413] R13: ffff888102763000 R14: ffff888101b528e0 R15: ffff888104208130
> [   16.408837] FS:  00007f3728652000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
> [   16.409318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   16.409666] CR2: 00007f3728651f78 CR3: 0000000100872005 CR4: 0000000000370ee0
> [   16.410098] Call Trace:
> [   16.410248]  <TASK>
> [   16.410378]  inet_csk_destroy_sock+0x55/0x110
> [   16.410647]  tcp_rcv_state_process+0xd28/0x1380
> [   16.410934]  ? tcp_v4_do_rcv+0x77/0x2c0
> [   16.411166]  tcp_v4_do_rcv+0x77/0x2c0
> [   16.411388]  __release_sock+0x106/0x130
> [   16.411626]  __tcp_close+0x1a7/0x4e0
> [   16.411844]  tcp_close+0x20/0x70
> [   16.412045]  inet_release+0x3c/0x80
> [   16.412257]  __sock_release+0x3a/0xb0
> [   16.412509]  sock_close+0x14/0x20
> [   16.412770]  __fput+0xa3/0x260
> [   16.413022]  task_work_run+0x59/0xb0
> [   16.413286]  exit_to_user_mode_prepare+0x1b3/0x1c0
> [   16.413665]  syscall_exit_to_user_mode+0x19/0x50
> [   16.414020]  do_syscall_64+0x48/0x90
> [   16.414285]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   16.414659] RIP: 0033:0x7f3728791eb7
> [   16.414916] Code: ff e8 7d e2 01 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 41 c3 48 83 ec 18 89 7c 24 0c e8 43 cd f5 ff
> [   16.416286] RSP: 002b:00007ffe6c91bb98 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> [   16.416841] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f3728791eb7
> [   16.417296] RDX: 0000000000000090 RSI: 00007ffe6c91baf0 RDI: 0000000000000019
> [   16.417723] RBP: 00007ffe6c91bbe0 R08: 00007ffe6c91baf0 R09: 00007ffe6c91baf0
> [   16.418178] R10: 00007ffe6c91baf0 R11: 0000000000000246 R12: 00007ffe6c91beb8
> [   16.418669] R13: 000000000040de7f R14: 0000000000471de8 R15: 00007f37288ec000
> [   16.419148]  </TASK>
> [   16.419283] irq event stamp: 135687
> [   16.419492] hardirqs last  enabled at (135695): [<ffffffff810ee6a2>] __up_console_sem+0x52/0x60
> [   16.420065] hardirqs last disabled at (135712): [<ffffffff810ee687>] __up_console_sem+0x37/0x60
> [   16.420606] softirqs last  enabled at (135710): [<ffffffff81078fe1>] irq_exit_rcu+0xe1/0x130
> [   16.421201] softirqs last disabled at (135703): [<ffffffff81078fe1>] irq_exit_rcu+0xe1/0x130
> [   16.421839] ---[ end trace 0000000000000000 ]---
> [   16.422195] ------------[ cut here ]------------
> [   16.422550] WARNING: CPU: 2 PID: 197 at net/ipv4/af_inet.c:154 inet_sock_destruct+0x198/0x1d0
> [   16.423142] Modules linked in:
> [   16.423327] CPU: 2 PID: 197 Comm: test_sockmap Tainted: G        W         5.17.0-rc6-01987-g84472b436e76 #76
> [   16.423908] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35 04/01/2014
> [   16.424436] RIP: 0010:inet_sock_destruct+0x198/0x1d0
> [   16.424737] Code: ff 49 8b bc 24 68 02 00 00 e8 b4 65 e9 ff 49 8b bc 24 88 00 00 00 5b 41 5c e9 a4 65 e9 ff 41 8b 84 24 30 02 00 00 85 c0 74 ca <0f> 0b eb c6 4c 89 e7 e8 bc 41 e6 ff e9 4d ff ff ff 0f 0b 41 8b 84
> [   16.425858] RSP: 0018:ffffc90000423e40 EFLAGS: 00010206
> [   16.426172] RAX: 0000000000000fc0 RBX: ffff888104208160 RCX: 0000000000000000
> [   16.426593] RDX: 0000000000000000 RSI: 0000000000000fc0 RDI: ffff888104208160
> [   16.427024] RBP: ffff888104208000 R08: 0000000000000000 R09: 0000000000000000
> [   16.427485] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888104208000
> [   16.428016] R13: ffff8881001ce8e0 R14: ffff888103170c30 R15: 0000000000000000
> [   16.428561] FS:  00007f3728652000(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
> [   16.429207] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   16.429638] CR2: 00007f3728651f78 CR3: 0000000100872005 CR4: 0000000000370ee0
> [   16.430178] Call Trace:
> [   16.430366]  <TASK>
> [   16.430524]  __sk_destruct+0x23/0x220
> [   16.430753]  inet_release+0x3c/0x80
> [   16.430969]  __sock_release+0x3a/0xb0
> [   16.431189]  sock_close+0x14/0x20
> [   16.431388]  __fput+0xa3/0x260
> [   16.431578]  task_work_run+0x59/0xb0
> [   16.431793]  exit_to_user_mode_prepare+0x1b3/0x1c0
> [   16.432085]  syscall_exit_to_user_mode+0x19/0x50
> [   16.432359]  do_syscall_64+0x48/0x90
> [   16.432578]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   16.432877] RIP: 0033:0x7f3728791eb7
> [   16.433099] Code: ff e8 7d e2 01 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 41 c3 48 83 ec 18 89 7c 24 0c e8 43 cd f5 ff
> [   16.434190] RSP: 002b:00007ffe6c91bb98 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> [   16.434637] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f3728791eb7
> [   16.435058] RDX: 0000000000000090 RSI: 00007ffe6c91baf0 RDI: 0000000000000019
> [   16.435476] RBP: 00007ffe6c91bbe0 R08: 00007ffe6c91baf0 R09: 00007ffe6c91baf0
> [   16.435893] R10: 00007ffe6c91baf0 R11: 0000000000000246 R12: 00007ffe6c91beb8
> [   16.436315] R13: 000000000040de7f R14: 0000000000471de8 R15: 00007f37288ec000
> [   16.436741]  </TASK>
> [   16.436876] irq event stamp: 136127
> [   16.437089] hardirqs last  enabled at (136137): [<ffffffff810ee6a2>] __up_console_sem+0x52/0x60
> [   16.437599] hardirqs last disabled at (136144): [<ffffffff810ee687>] __up_console_sem+0x37/0x60
> [   16.438115] softirqs last  enabled at (135830): [<ffffffff81078fe1>] irq_exit_rcu+0xe1/0x130
> [   16.438641] softirqs last disabled at (135817): [<ffffffff81078fe1>] irq_exit_rcu+0xe1/0x130
> [   16.439277] ---[ end trace 0000000000000000 ]---
> # 8/ 3  sockmap::txmsg test hanging corks:OK
> # 9/11  sockmap::txmsg test push_data:OK
> #10/17  sockmap::txmsg test pull-data:OK
> #11/ 9  sockmap::txmsg test pop-data:OK
> #12/ 1  sockmap::txmsg test push/pop data:OK
> #13/ 1  sockmap::txmsg test ingress parser:OK
> #14/ 1  sockmap::txmsg test ingress parser2:OK
> #15/ 6 sockhash::txmsg test passthrough:OK
> #16/ 6 sockhash::txmsg test redirect:OK
> #17/ 6 sockhash::txmsg test drop:OK
> #18/ 6 sockhash::txmsg test ingress redirect:OK
> #19/ 7 sockhash::txmsg test skb:OK
> #20/ 8 sockhash::txmsg test apply:OK
> #21/12 sockhash::txmsg test cork:OK
> #22/ 3 sockhash::txmsg test hanging corks:OK
> #23/11 sockhash::txmsg test push_data:OK
> #24/17 sockhash::txmsg test pull-data:OK
> #25/ 9 sockhash::txmsg test pop-data:OK
> #26/ 1 sockhash::txmsg test push/pop data:OK
> #27/ 1 sockhash::txmsg test ingress parser:OK
> #28/ 1 sockhash::txmsg test ingress parser2:OK
> #29/ 6 sockhash:ktls:txmsg test passthrough:OK
> #30/ 6 sockhash:ktls:txmsg test redirect:OK
> #31/ 6 sockhash:ktls:txmsg test drop:OK
> #32/ 6 sockhash:ktls:txmsg test ingress redirect:OK
> #33/ 7 sockhash:ktls:txmsg test skb:OK
> #34/ 8 sockhash:ktls:txmsg test apply:OK
> #35/12 sockhash:ktls:txmsg test cork:OK
> #36/ 3 sockhash:ktls:txmsg test hanging corks:OK
> #37/11 sockhash:ktls:txmsg test push_data:OK
> #38/17 sockhash:ktls:txmsg test pull-data:OK
> #39/ 9 sockhash:ktls:txmsg test pop-data:OK
> #40/ 1 sockhash:ktls:txmsg test push/pop data:OK
> #41/ 1 sockhash:ktls:txmsg test ingress parser:OK
> #42/ 0 sockhash:ktls:txmsg test ingress parser2:OK
> Pass: 42 Fail: 0
> bash-5.1#
>
> No idea why yet. I will need to dig into what is happening.
>
> Wang, can you please take a look as well?

Sorry for the breakage. In commit 84472b436e76 ("bpf, sockmap: Fix more uncharged while msg has
more_data") , I used msg->sg.size replace tosend rudely, which break the
if (msg->apply_bytes && msg->apply_bytes < send) scene.

The following modifications can fix the issue.

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index a1626afe87a1..38d47357dd68 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -278,7 +278,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
  {
         bool cork = false, enospc = sk_msg_full(msg);
         struct sock *sk_redir;
-       u32 tosend, delta = 0;
+       u32 tosend, orgsize, sended, delta = 0;
         u32 eval = __SK_NONE;
         int ret;
  
@@ -333,10 +333,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
                         cork = true;
                         psock->cork = NULL;
                 }
-               sk_msg_return(sk, msg, msg->sg.size);
+               sk_msg_return(sk, msg, tosend);
                 release_sock(sk);
  
+               orgsize = msg->sg.size;
                 ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
+               sended = orgsize - msg->sg.size;
  
                 if (eval == __SK_REDIRECT)
                         sock_put(sk_redir);
@@ -374,8 +376,8 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
                 if (msg &&
                     msg->sg.data[msg->sg.start].page_link &&
                     msg->sg.data[msg->sg.start].length) {
-                       if (eval == __SK_REDIRECT)
-                               sk_mem_charge(sk, msg->sg.size);
+                       if (eval == __SK_REDIRECT && tosend > sended)
+                               sk_mem_charge(sk, tosend - sended);
                         goto more_data;
                 }
         }

>
> Thanks,
> Jakub
>
