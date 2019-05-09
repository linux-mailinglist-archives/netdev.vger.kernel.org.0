Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D1F183E9
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 04:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfEICsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 22:48:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49042 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725842AbfEICsV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 22:48:21 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C98C1BC5024CEE25BFFE;
        Thu,  9 May 2019 10:48:18 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Thu, 9 May 2019
 10:48:17 +0800
Subject: Re: [PATCH] packet: Fix error path in packet_init
To:     Eric Dumazet <edumazet@google.com>
References: <20190508153241.30776-1-yuehaibing@huawei.com>
 <CANn89iLbFa2fbJ5zQ_BOWEMUbk1aSWQHHbdEBU7DdfvpvEOiDg@mail.gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, <maximmi@mellanox.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <aea2ec71-575e-2dda-123b-5f66133641a5@huawei.com>
Date:   Thu, 9 May 2019 10:48:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iLbFa2fbJ5zQ_BOWEMUbk1aSWQHHbdEBU7DdfvpvEOiDg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/5/8 23:50, Eric Dumazet wrote:
> On Wed, May 8, 2019 at 8:33 AM YueHaibing <yuehaibing@huawei.com> wrote:
>>
>>  kernel BUG at lib/list_debug.c:47!
>>  invalid opcode: 0000 [#1
>>  CPU: 0 PID: 11195 Comm: rmmod Tainted: G        W         5.1.0+ #33
>>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
>>  RIP: 0010:__list_del_entry_valid+0x55/0x90
>>  Code: 12 48 39 d7 75 39 48 8b 50 08 48 39 d7 75 1d b8 01 00 00 00 5d c3 48 89 c2 48 89 fe
>>  31 c0 48 c7 c7 40 3a fe 82 e8 74 c1 78 ff <0f> 0b 48 89 fe 31 c0 48 c7 c7 f0 3a fe 82 e8 61 c1 78 ff 0f 0b 48
>>  RSP: 0018:ffffc90001b8be48 EFLAGS: 00010246
>>  RAX: 000000000000004e RBX: ffffffffa0210000 RCX: 0000000000000000
>>  RDX: 0000000000000000 RSI: ffff888237a16808 RDI: 00000000ffffffff
>>  RBP: ffffc90001b8be48 R08: 0000000000000000 R09: 0000000000000001
>>  R10: 0000000000000000 R11: ffffffff842c1640 R12: 0000000000000800
>>  R13: 0000000000000000 R14: ffffc90001b8be58 R15: ffffffffa0210000
>>  FS:  00007f58963c7540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
>>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>  CR2: 000056064c7af818 CR3: 00000001e9895000 CR4: 00000000000006f0
>>  Call Trace:
>>   unregister_pernet_operations+0x34/0x110
>>   unregister_pernet_subsys+0x1c/0x30
>>   packet_exit+0x1c/0x1dd [af_packet
>>   __x64_sys_delete_module+0x16b/0x290
>>   ? trace_hardirqs_off_thunk+0x1a/0x1c
>>   do_syscall_64+0x6b/0x1d0
>>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> Fix error handing path in packet_init to
>> avoid possilbe issue if some error occur.
> 
> The trace is about rmmod, and the patch is in packet_init() ?

Sorry for confusion.

When modprobe module, register_pernet_subsys
fails and does a cleanup, ops->list is set to LIST_POISON1,
but the module init is considered to success, then while rmmod
BUG_ON is triggered in __list_del_entry_valid which is called from
unregister_pernet_subsys.

I can rework the commit log in v2.

the full CallTrace:

[  209.641390][T12911] CPU: 0 PID: 12911 Comm: modprobe Tainted: G        W         5.1.0+ #47
[  209.642637][T12911] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
[  209.644436][T12911] Call Trace:
[  209.644912][T12911]  dump_stack+0xa5/0xdc
[  209.645513][T12911]  should_fail+0x145/0x170
[  209.646150][T12911]  __should_failslab+0x49/0x50
[  209.646854][T12911]  should_failslab+0x9/0x14
[  209.647500][T12911]  kmem_cache_alloc+0x47/0x700
[  209.648203][T12911]  __proc_create+0xcb/0x270
[  209.648855][T12911]  proc_create_reg+0x44/0x70
[  209.649515][T12911]  proc_create_net_data+0x24/0x60
[  209.650254][T12911]  packet_net_init+0x52/0x60 [af_packet]
[  209.651088][T12911]  ops_init+0x3f/0x170
[  209.651677][T12911]  register_pernet_operations+0x109/0x1f0
[  209.652513][T12911]  ? 0xffffffffa0187000
[  209.653116][T12911]  register_pernet_subsys+0x23/0x40
[  209.653862][T12911]  packet_init+0x31/0x1000 [af_packet]
[  209.654655][T12911]  do_one_initcall+0x65/0x350
[  209.655333][T12911]  do_init_module+0x5a/0x205
[  209.655996][T12911]  load_module+0x1f07/0x2710
[  209.656674][T12911]  ? ima_post_read_file+0xec/0x130
[  209.657417][T12911]  __do_sys_finit_module+0xd1/0xf0
[  209.658159][T12911]  ? __do_sys_finit_module+0xd1/0xf0
[  209.658924][T12911]  __x64_sys_finit_module+0x15/0x20
[  209.659683][T12911]  do_syscall_64+0x6e/0x1f0
[  209.660329][T12911]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  209.661185][T12911] RIP: 0033:0x7f6eeb066839
[  209.661836][T12911] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 1f f6 2c 00 f7 d8 64 89 01 48
[  209.664697][T12911] RSP: 002b:00007ffe60f7c1d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[  209.665913][T12911] RAX: ffffffffffffffda RBX: 0000563b7b82ab40 RCX: 00007f6eeb066839
[  209.667071][T12911] RDX: 0000000000000000 RSI: 0000563b7aa4ac2e RDI: 0000000000000003
[  209.668226][T12911] RBP: 0000563b7aa4ac2e R08: 0000000000000000 R09: 0000563b7b82ce80
[  209.669388][T12911] R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
[  209.670542][T12911] R13: 0000563b7b8324a0 R14: 0000000000040000 R15: 0000563b7b82ab40
[  209.695525][T12914] list_del corruption, ffffffffa0184000->next is LIST_POISON1 (dead000000000100)
[  209.696916][T12914] ------------[ cut here ]------------
[  209.697736][T12914] kernel BUG at lib/list_debug.c:47!
[  209.698514][T12914] invalid opcode: 0000 [#1] PREEMPT SMP
[  209.699325][T12914] CPU: 0 PID: 12914 Comm: rmmod Tainted: G        W         5.1.0+ #47
[  209.700536][T12914] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.3-0-ge2fc41e-prebuilt.qemu-project.org 04/01/2014
[  209.702391][T12914] RIP: 0010:__list_del_entry_valid+0x53/0x90
[  209.703265][T12914] Code: 48 8b 32 48 39 fe 75 35 48 8b 50 08 48 39 f2 75 40 b8 01 00 00 00 5d c3 48 89 fe 48 89 c2 48 c7 c7 18 75 fe 82 e8 cb 34 78 ff <0f> 0b 48 89 fe 48 c7 c7 50 75 fe 82 e8 ba 34 78 ff 0f 0b 48 89 f2
[  209.706152][T12914] RSP: 0018:ffffc90001c2fe40 EFLAGS: 00010286
[  209.707033][T12914] RAX: 000000000000004e RBX: ffffffffa0184000 RCX: 0000000000000000
[  209.708191][T12914] RDX: 0000000000000000 RSI: ffff888237a17788 RDI: 00000000ffffffff
[  209.709344][T12914] RBP: ffffc90001c2fe40 R08: 0000000000000000 R09: 0000000000000000
[  209.710505][T12914] R10: ffffc90001c2fe10 R11: 0000000000000000 R12: 0000000000000000
[  209.711662][T12914] R13: ffffc90001c2fe50 R14: ffffffffa0184000 R15: 0000000000000000
[  209.712815][T12914] FS:  00007f3d83634540(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
[  209.714125][T12914] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  209.715083][T12914] CR2: 0000555c350ea818 CR3: 0000000231677000 CR4: 00000000000006f0
[  209.716239][T12914] Call Trace:
[  209.716718][T12914]  unregister_pernet_operations+0x34/0x120
[  209.717590][T12914]  unregister_pernet_subsys+0x1c/0x30
[  209.718377][T12914]  packet_exit+0x1c/0x369 [af_packet]
[  209.719160][T12914]  __x64_sys_delete_module+0x156/0x260
[  209.719949][T12914]  ? lockdep_hardirqs_on+0x133/0x1b0
[  209.720720][T12914]  ? do_syscall_64+0x12/0x1f0
[  209.721415][T12914]  do_syscall_64+0x6e/0x1f0
[  209.722082][T12914]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

> 
> So I believe we need more explanations of why you believe this patch
> is fixing the issue
> the bot hit .
> 
> Thanks.
> 
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  net/packet/af_packet.c | 26 +++++++++++++++++++++-----
>>  1 file changed, 21 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
>> index 90d4e3c..3917c75 100644
>> --- a/net/packet/af_packet.c
>> +++ b/net/packet/af_packet.c
>> @@ -4598,14 +4598,30 @@ static void __exit packet_exit(void)
>>
>>  static int __init packet_init(void)
>>  {
>> -       int rc = proto_register(&packet_proto, 0);
>> +       int rc;
>>
>> -       if (rc != 0)
>> +       rc = proto_register(&packet_proto, 0);
>> +       if (rc)
>>                 goto out;
>>
>> -       sock_register(&packet_family_ops);
>> -       register_pernet_subsys(&packet_net_ops);
>> -       register_netdevice_notifier(&packet_netdev_notifier);
>> +       rc = sock_register(&packet_family_ops);
>> +       if (rc)
>> +               goto out_proto;
>> +       rc = register_pernet_subsys(&packet_net_ops);
>> +       if (rc)
>> +               goto out_sock;
>> +       rc = register_netdevice_notifier(&packet_netdev_notifier);
>> +       if (rc)
>> +               goto out_pernet;
>> +
>> +       return 0;
>> +
>> +out_pernet:
>> +       unregister_pernet_subsys(&packet_net_ops);
>> +out_sock:
>> +       sock_unregister(PF_PACKET);
>> +out_proto:
>> +       proto_unregister(&packet_proto);
>>  out:
>>         return rc;
>>  }
>> --
>> 1.8.3.1
>>
>>
> 
> .
> 

