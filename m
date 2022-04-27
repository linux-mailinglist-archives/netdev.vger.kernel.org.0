Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2B9511233
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 09:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358706AbiD0HTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 03:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358835AbiD0HTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 03:19:15 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF7742A14;
        Wed, 27 Apr 2022 00:16:02 -0700 (PDT)
Received: from kwepemi100019.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Kp90J06YNzCsPs;
        Wed, 27 Apr 2022 15:11:27 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 kwepemi100019.china.huawei.com (7.221.188.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 27 Apr 2022 15:16:00 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 27 Apr 2022 15:15:59 +0800
Message-ID: <2edb137e-b12f-e912-8c2b-9ad3737a0182@huawei.com>
Date:   Wed, 27 Apr 2022 15:15:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] SUNRPC: Fix local socket leak in
 xs_local_setup_socket()
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
From:   "wanghai (M)" <wanghai38@huawei.com>
In-Reply-To: <d013bdc75085e380250cb79edf2b27680cbc9f7e.camel@hammerspace.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/27 2:51, Trond Myklebust 写道:
> On Tue, 2022-04-26 at 21:20 +0800, Wang Hai wrote:
>> If the connection to a local endpoint in xs_local_setup_socket()
>> fails,
>> fput() is missing in the error path, which will result in a socket
>> leak.
>> It can be reproduced in simple script below.
>>
>> while true
>> do
>>          systemctl stop rpcbind.service
>>          systemctl stop rpc-statd.service
>>          systemctl stop nfs-server.service
>>
>>          systemctl restart rpcbind.service
>>          systemctl restart rpc-statd.service
>>          systemctl restart nfs-server.service
>> done
>>
>> When executing the script, you can observe that the
>> "cat /proc/net/unix | wc -l" count keeps growing.
>>
>> Add the missing fput(), and restore transport to old socket.
>>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
>>   net/sunrpc/xprtsock.c | 20 ++++++++++++++++++--
>>   1 file changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
>> index 0f39e08ee580..7219c545385e 100644
>> --- a/net/sunrpc/xprtsock.c
>> +++ b/net/sunrpc/xprtsock.c
>> @@ -1819,6 +1819,9 @@ static int xs_local_finish_connecting(struct
>> rpc_xprt *xprt,
>>   {
>>          struct sock_xprt *transport = container_of(xprt, struct
>> sock_xprt,
>>                                                                       
>>     xprt);
>> +       struct socket *trans_sock = NULL;
>> +       struct sock *trans_inet = NULL;
>> +       int ret;
>>   
>>          if (!transport->inet) {
>>                  struct sock *sk = sock->sk;
>> @@ -1835,6 +1838,9 @@ static int xs_local_finish_connecting(struct
>> rpc_xprt *xprt,
>>   
>>                  xprt_clear_connected(xprt);
>>   
>> +               trans_sock = transport->sock;
>> +               trans_inet = transport->inet;
>> +
> Both values are NULL here
Got it, thanks
>
>>                  /* Reset to new socket */
>>                  transport->sock = sock;
>>                  transport->inet = sk;
>> @@ -1844,7 +1850,14 @@ static int xs_local_finish_connecting(struct
>> rpc_xprt *xprt,
>>   
>>          xs_stream_start_connect(transport);
>>   
>> -       return kernel_connect(sock, xs_addr(xprt), xprt->addrlen, 0);
>> +       ret = kernel_connect(sock, xs_addr(xprt), xprt->addrlen, 0);
>> +       /* Restore to old socket */
>> +       if (ret && trans_inet) {
>> +               transport->sock = trans_sock;
>> +               transport->inet = trans_inet;
>> +       }
>> +
>> +       return ret;
>>   }
>>   
>>   /**
>> @@ -1887,7 +1900,7 @@ static int xs_local_setup_socket(struct
>> sock_xprt *transport)
>>                  xprt->stat.connect_time += (long)jiffies -
>>                                             xprt->stat.connect_start;
>>                  xprt_set_connected(xprt);
>> -               break;
>> +               goto out;
>>          case -ENOBUFS:
>>                  break;
>>          case -ENOENT:
>> @@ -1904,6 +1917,9 @@ static int xs_local_setup_socket(struct
>> sock_xprt *transport)
>>                                  xprt-
>>> address_strings[RPC_DISPLAY_ADDR]);
>>          }
>>   
>> +       transport->file = NULL;
>> +       fput(filp);
> Please just call xprt_force_disconnect() so that this can be cleaned up
> from 	a safe context.

Hi, Trond

Thank you for your advice, I tried this, but it doesn't seem to

work and an error is reported. I'll analyze why this happens

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 0f39e08ee580..3d1387b2cfbf 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1887,7 +1887,7 @@ static int xs_local_setup_socket(struct sock_xprt 
*transport)
                 xprt->stat.connect_time += (long)jiffies -
xprt->stat.connect_start;
                 xprt_set_connected(xprt);
-               break;
+               goto out;
         case -ENOBUFS:
                 break;
         case -ENOENT:
@@ -1904,6 +1904,8 @@ static int xs_local_setup_socket(struct sock_xprt 
*transport)
xprt->address_strings[RPC_DISPLAY_ADDR]);
         }

+       xprt_force_disconnect(xprt);
+
  out:
         xprt_clear_connecting(xprt);
         xprt_wake_pending_tasks(xprt, status);


[ 2541.763895][ T8289] ------------[ cut here ]------------
[ 2541.765829][ T8289] WARNING: CPU: 0 PID: 8289 at 
kernel/workqueue.c:1499 __queue_work+0x72a/0x810
[ 2541.768862][ T8289] Modules linked in:
[ 2541.770085][ T8289] CPU: 0 PID: 8289 Comm: gssproxy Tainted: G        
W         5.17.0+ #762
[ 2541.772724][ T8289] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 2541.773788][ T8289] RIP: 0010:__queue_work+0x72a/0x810
[ 2541.773788][ T8289] Code: 48 c7 c7 f8 7b b8 84 c6 05 b1 f4 39 04 01 
e8 ad 65 05 00 e9 7f fe ff ff e8 33 94 11 00 4c 8b 33 e9 ff f9 ff ff e8 
26 94 11 00 <0f> 0b e9 d2 fa ff ff e8 1a 94 11 00 4c 8d 7b 68 41 83 cc 
02 e9 aa
[ 2541.773788][ T8289] RSP: 0018:ffffc900083dfb20 EFLAGS: 00010093
[ 2541.773788][ T8289] RAX: 0000000000000000 RBX: ffff8881002a7900 RCX: 
0000000000000000
[ 2541.773788][ T8289] RDX: ffff88824e091b40 RSI: ffffffff8119be6a RDI: 
ffffc900083dfb07
[ 2541.773788][ T8289] RBP: ffffc900083dfb60 R08: 0000000000000001 R09: 
0000000000000000
[ 2541.773788][ T8289] R10: 0000000000000000 R11: 6e75732f74656e5b R12: 
0000000000000000
[ 2541.773788][ T8289] R13: ffff88811a284668 R14: ffff888237c2d440 R15: 
ffff888243141c00
[ 2541.773788][ T8289] FS:  00007f3bb3f9dc40(0000) 
GS:ffff888237c00000(0000) knlGS:0000000000000000
[ 2541.773788][ T8289] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2541.773788][ T8289] CR2: 00007f3bb04a72e0 CR3: 00000002602c5000 CR4: 
00000000000006f0
[ 2541.773788][ T8289] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 2541.773788][ T8289] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[ 2541.773788][ T8289] Call Trace:
[ 2541.773788][ T8289]  <TASK>
[ 2541.773788][ T8289]  queue_work_on+0x88/0x90
[ 2541.773788][ T8289]  xprt_schedule_autoclose_locked+0x7a/0xb0
[ 2541.773788][ T8289]  xprt_force_disconnect+0x53/0x150
[ 2541.773788][ T8289]  xs_local_setup_socket+0x131/0x3e0
[ 2541.823215][ T8289]  xs_setup_local+0x24b/0x280
[ 2541.823215][ T8289]  xprt_create_transport+0xb0/0x340
[ 2541.823215][ T8289]  rpc_create+0x104/0x2b0
[ 2541.823215][ T8289]  gssp_rpc_create+0x93/0xe0
[ 2541.823215][ T8289]  set_gssp_clnt+0xd9/0x230
[ 2541.823215][ T8289]  write_gssp+0xb9/0x130
[ 2541.823215][ T8289]  ? lock_acquire+0x1de/0x2f0
[ 2541.823215][ T8289]  proc_reg_write+0xd2/0x110
[ 2541.823215][ T8289]  ? set_gss_proxy+0x1d0/0x1d0
[ 2541.823215][ T8289]  ? proc_reg_compat_ioctl+0x100/0x100
[ 2541.823215][ T8289]  vfs_write+0x11d/0x4b0
[ 2541.841496][ T8289]  ksys_write+0xe0/0x130
[ 2541.841496][ T8289]  __x64_sys_write+0x23/0x30
[ 2541.841496][ T8289]  do_syscall_64+0x34/0xb0
[ 2541.841496][ T8289]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 2541.841496][ T8289] RIP: 0033:0x7f3bb0811280
[ 2541.841496][ T8289] Code: 00 c3 0f 1f 84 00 00 00 00 00 48 8b 05 c1 
8c 20 00 c3 0f 1f 84 00 00 00 00 00 83 3d 09 cf 20 00 00 75 10 b8 01 00 
00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 6e fd ff ff 48 
89 04 24
[ 2541.841496][ T8289] RSP: 002b:00007ffc59024c98 EFLAGS: 00000246 
ORIG_RAX: 0000000000000001
[ 2541.841496][ T8289] RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 
00007f3bb0811280
[ 2541.841496][ T8289] RDX: 0000000000000001 RSI: 00007ffc59024ca6 RDI: 
0000000000000009
[ 2541.841496][ T8289] RBP: 0000000000000000 R08: 0000000000000020 R09: 
0000000000000060
[ 2541.841496][ T8289] R10: 0000561545627900 R11: 0000000000000246 R12: 
0000561545630580
[ 2541.841496][ T8289] R13: 00007ffc59024fd0 R14: 0000000000000000 R15: 
0000000000000000
[ 2541.841496][ T8289]  </TASK>
[ 2541.841496][ T8289] irq event stamp: 0
[ 2541.841496][ T8289] hardirqs last  enabled at (0): 
[<0000000000000000>] 0x0
[ 2541.841496][ T8289] hardirqs last disabled at (0): 
[<ffffffff81165e25>] copy_process+0xb35/0x2410
[ 2541.841496][ T8289] softirqs last  enabled at (0): 
[<ffffffff81165e25>] copy_process+0xb35/0x2410
[ 2541.841496][ T8289] softirqs last disabled at (0): 
[<0000000000000000>] 0x0
[ 2541.841496][ T8289] ---[ end trace 0000000000000000 ]---
>> +
>>   out:
>>          xprt_clear_connecting(xprt);
>>          xprt_wake_pending_tasks(xprt, status);

-- 
Wang Hai

