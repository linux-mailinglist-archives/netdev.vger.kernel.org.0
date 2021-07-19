Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A193CCFEA
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbhGSIXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:23:23 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11445 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235528AbhGSIXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:23:22 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GSwmQ4RRgzcg1t;
        Mon, 19 Jul 2021 17:00:38 +0800 (CST)
Received: from dggpemm500015.china.huawei.com (7.185.36.181) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:03:54 +0800
Received: from [10.174.179.224] (10.174.179.224) by
 dggpemm500015.china.huawei.com (7.185.36.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 17:03:54 +0800
Subject: Re: [PATCH v2] Bluetooth: fix use-after-free error in
 lock_sock_nested()
To:     Hillf Danton <hdanton@sina.com>
CC:     <cj.chengjian@huawei.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <huawei.libin@huawei.com>,
        <marcel@holtmann.org>, <luiz.dentz@gmail.com>,
        <johan.hedberg@gmail.com>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+664818c59309176d03ee@syzkaller.appspotmail.com>,
        syzbot <syzbot+9a0875bc1b2ca466b484@syzkaller.appspotmail.com>
References: <20210719024937.9542-1-bobo.shaobowang@huawei.com>
 <20210719074829.2554-1-hdanton@sina.com>
From:   "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Message-ID: <97b64908-45d3-f074-bd9c-0bb04624bad1@huawei.com>
Date:   Mon, 19 Jul 2021 17:03:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <20210719074829.2554-1-hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.224]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500015.china.huawei.com (7.185.36.181)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/19 15:48, Hillf Danton 写道:
> On Mon, 19 Jul 2021 10:49:37 +0800 Wang ShaoBo wrote:
>> use-after-free error in lock_sock_nested is reported:
> There are similar reports from syzbot.
>
> [1] https://lore.kernel.org/netdev/000000000000f335f205b5649c70@google.com/
> [2] https://lore.kernel.org/netdev/000000000000c4fd0405b6cc8e53@google.com/
>
>> [  179.140137][ T3731] =====================================================
>> [  179.142675][ T3731] BUG: KMSAN: use-after-free in lock_sock_nested+0x280/0x2c0
>> [  179.145494][ T3731] CPU: 4 PID: 3731 Comm: kworker/4:2 Not tainted 5.12.0-rc6+ #54
>> [  179.148432][ T3731] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
>> [  179.151806][ T3731] Workqueue: events l2cap_chan_timeout
>> [  179.152730][ T3731] Call Trace:
>> [  179.153301][ T3731]  dump_stack+0x24c/0x2e0
>> [  179.154063][ T3731]  kmsan_report+0xfb/0x1e0
>> [  179.154855][ T3731]  __msan_warning+0x5c/0xa0
>> [  179.155579][ T3731]  lock_sock_nested+0x280/0x2c0
>> [  179.156436][ T3731]  ? kmsan_get_metadata+0x116/0x180
>> [  179.157257][ T3731]  l2cap_sock_teardown_cb+0xb8/0x890
>> [  179.158154][ T3731]  ? __msan_metadata_ptr_for_load_8+0x10/0x20
>> [  179.159141][ T3731]  ? kmsan_get_metadata+0x116/0x180
>> [  179.159994][ T3731]  ? kmsan_get_shadow_origin_ptr+0x84/0xb0
>> [  179.160959][ T3731]  ? l2cap_sock_recv_cb+0x420/0x420
>> [  179.161834][ T3731]  l2cap_chan_del+0x3e1/0x1d50
>> [  179.162608][ T3731]  ? kmsan_get_metadata+0x116/0x180
>> [  179.163435][ T3731]  ? kmsan_get_shadow_origin_ptr+0x84/0xb0
>> [  179.164406][ T3731]  l2cap_chan_close+0xeea/0x1050
>> [  179.165189][ T3731]  ? kmsan_internal_unpoison_shadow+0x42/0x70
>> [  179.166180][ T3731]  l2cap_chan_timeout+0x1da/0x590
>> [  179.167066][ T3731]  ? __msan_metadata_ptr_for_load_8+0x10/0x20
>> [  179.168023][ T3731]  ? l2cap_chan_create+0x560/0x560
>> [  179.168818][ T3731]  process_one_work+0x121d/0x1ff0
>> [  179.169598][ T3731]  worker_thread+0x121b/0x2370
>> [  179.170346][ T3731]  kthread+0x4ef/0x610
>> [  179.171010][ T3731]  ? process_one_work+0x1ff0/0x1ff0
>> [  179.171828][ T3731]  ? kthread_blkcg+0x110/0x110
>> [  179.172587][ T3731]  ret_from_fork+0x1f/0x30
>> [  179.173348][ T3731]
>> [  179.173752][ T3731] Uninit was created at:
>> [  179.174409][ T3731]  kmsan_internal_poison_shadow+0x5c/0xf0
>> [  179.175373][ T3731]  kmsan_slab_free+0x76/0xc0
>> [  179.176060][ T3731]  kfree+0x3a5/0x1180
>> [  179.176664][ T3731]  __sk_destruct+0x8af/0xb80
>> [  179.177375][ T3731]  __sk_free+0x812/0x8c0
>> [  179.178032][ T3731]  sk_free+0x97/0x130
>> [  179.178686][ T3731]  l2cap_sock_release+0x3d5/0x4d0
>> [  179.179457][ T3731]  sock_close+0x150/0x450
>> [  179.180117][ T3731]  __fput+0x6bd/0xf00
>> [  179.180787][ T3731]  ____fput+0x37/0x40
>> [  179.181481][ T3731]  task_work_run+0x140/0x280
>> [  179.182219][ T3731]  do_exit+0xe51/0x3e60
>> [  179.182930][ T3731]  do_group_exit+0x20e/0x450
>> [  179.183656][ T3731]  get_signal+0x2dfb/0x38f0
>> [  179.184344][ T3731]  arch_do_signal_or_restart+0xaa/0xe10
>> [  179.185266][ T3731]  exit_to_user_mode_prepare+0x2d2/0x560
>> [  179.186136][ T3731]  syscall_exit_to_user_mode+0x35/0x60
>> [  179.186984][ T3731]  do_syscall_64+0xc5/0x140
>> [  179.187681][ T3731]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [  179.188604][ T3731] =====================================================
>>
>> In our case, there are two Thread A and B:
>>
>> Context: Thread A:              Context: Thread B:
>>
>> l2cap_chan_timeout()            __se_sys_shutdown()
>>   l2cap_chan_close()              l2cap_sock_shutdown()
>>     l2cap_chan_del()                l2cap_chan_close()
>>       l2cap_sock_teardown_cb()        l2cap_sock_teardown_cb()
>>
>> Once l2cap_sock_teardown_cb() excuted, this sock will be marked as SOCK_ZAPPED,
>> and can be treated as killable in l2cap_sock_kill() if sock_orphan() has
>> excuted, at this time we close sock through sock_close() which end to call
>> l2cap_sock_kill() like Thread C:
>>
>> Context: Thread C:
>>
>> sock_close()
>>   l2cap_sock_release()
>>     sock_orphan()
>>     l2cap_sock_kill()  #free sock if refcnt is 1
>>
>> If C completed, Once A or B reaches l2cap_sock_teardown_cb() again,
>> use-after-free happened.
>>
>> We should set chan->data to NULL if sock is destructed, for telling teardown
>> operation is not allowed in l2cap_sock_teardown_cb(), and also we should
> Alternatively ensure it is safe to invoke the teardown cb by holding extra
> grab to sock, see diff below,
>
>> avoid killing an already killed socket in l2cap_sock_close_cb().
> with an eye on double kill.
>
>> Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
>> ---
>> v2:
>>   put chan->data = NULL in l2cap_socl_destruct(), this refers to
>>   Luiz Augusto von Dentz <luiz.dentz@gmail.com>'s proposal.
>> ---
>> net/bluetooth/l2cap_sock.c | 10 +++++++++-
>> 1 file changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
>> index c99d65ef13b1..160c016a5dfb 100644
>> --- a/net/bluetooth/l2cap_sock.c
>> +++ b/net/bluetooth/l2cap_sock.c
>> @@ -1508,6 +1508,9 @@ static void l2cap_sock_close_cb(struct l2cap_chan *chan)
>> {
>> 	struct sock *sk = chan->data;
>>
>> +	if (!sk)
>> +		return;
>> +
>> 	l2cap_sock_kill(sk);
>> }
>>
>> @@ -1516,6 +1519,9 @@ static void l2cap_sock_teardown_cb(struct l2cap_chan *chan, int err)
>> 	struct sock *sk = chan->data;
>> 	struct sock *parent;
>>
>> +	if (!sk)
>> +		return;
>> +
>> 	BT_DBG("chan %p state %s", chan, state_to_string(chan->state));
>>
>> 	/* This callback can be called both for server (BT_LISTEN)
>> @@ -1707,8 +1713,10 @@ static void l2cap_sock_destruct(struct sock *sk)
>> {
>> 	BT_DBG("sk %p", sk);
>>
>> -	if (l2cap_pi(sk)->chan)
>> +	if (l2cap_pi(sk)->chan) {
>> +		l2cap_pi(sk)->chan->data = NULL;
>> 		l2cap_chan_put(l2cap_pi(sk)->chan);
>> +	}
>>
>> 	if (l2cap_pi(sk)->rx_busy_skb) {
>> 		kfree_skb(l2cap_pi(sk)->rx_busy_skb);
>> -- 
>> 2.27.0
>
> Hold sock until it is killed to make l2cap callbacks safe.
> Now only for thoughts.
>
> +++ x/net/bluetooth/l2cap_sock.c
> @@ -1509,6 +1509,8 @@ static void l2cap_sock_close_cb(struct l
>   	struct sock *sk = chan->data;
>   
>   	l2cap_sock_kill(sk);
> +	/* put the extra hold in l2cap_sock_init() */
> +	sock_put(sk);
>   }
>   
>   static void l2cap_sock_teardown_cb(struct l2cap_chan *chan, int err)
> @@ -1794,6 +1796,8 @@ static void l2cap_sock_init(struct sock
>   	/* Default config options */
>   	chan->flush_to = L2CAP_DEFAULT_FLUSH_TO;
>   
> +	/* will be put in l2cap_sock_close_cb() */
> +	sock_hold(sk);
>   	chan->data = sk;
>   	chan->ops = &l2cap_chan_ops;
>   }
> .

Dear Danton，

I have tried this before, this will trigger error "underflow of refcount 
of chan" as following:

[  118.708179][ T3086] ------------[ cut here ]------------
[  118.710172][ T3086] refcount_t: underflow; use-after-free.
[  118.713391][ T3086] WARNING: CPU: 4 PID: 3086 at lib/refcount.c:28 
refcount_warn_saturate+0x30a/0x3c0
[  118.716774][ T3086] Modules linked in:
[  118.718279][ T3086] CPU: 4 PID: 3086 Comm: kworker/4:2 Not tainted 
5.12.0-rc6+ #84
[  118.721005][ T3086] Hardware name: QEMU Standard PC (i440FX + PIIX, 
1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[  118.722846][ T3086] Workqueue: events l2cap_chan_timeout
[  118.723786][ T3086] RIP: 0010:refcount_warn_saturate+0x30a/0x3c0
...
[  118.737912][ T3086] CR2: 0000000020000040 CR3: 0000000011029000 CR4: 
00000000000006e0
[  118.739187][ T3086] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  118.740451][ T3086] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  118.741720][ T3086] Call Trace:
[  118.742262][ T3086]  l2cap_sock_close_cb+0x165/0x170
[  118.743124][ T3086]  ? l2cap_sock_teardown_cb+0x560/0x560

Actually, if adding sock_hold(sk) in l2cap_sock_init(), 
l2cap_sock_kill() will continue to excute untill it found

now chan's refcount is 0, this is because sock was not freed in last 
round execution of l2cap_sock_kill().


this method also makes l2cap_sock_init()'s logic more difficult to 
understand,   we have set refcount

of sock to 1 when allocating it, why do we need hold it again ?

-- Wang ShaoBo

