Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A190E3D0BF0
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 12:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236675AbhGUIxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 04:53:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7408 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237295AbhGUIvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 04:51:11 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GV9F86LLtz7xbt;
        Wed, 21 Jul 2021 17:26:20 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 21 Jul 2021 17:29:59 +0800
Subject: Re: [PATCH net] can: raw: fix raw_rcv panic for sock UAF
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mkl@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20210721010937.670275-1-william.xuanziyang@huawei.com>
 <YPeoQG19PSh3B3Dc@kroah.com>
 <44c3e0e2-03c5-80e5-001c-03e7e9758bca@hartkopp.net>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <e3f56f35-00ca-e8f9-ba41-fdc87dc9bfd4@huawei.com>
Date:   Wed, 21 Jul 2021 17:29:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <44c3e0e2-03c5-80e5-001c-03e7e9758bca@hartkopp.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/21/2021 2:35 PM, Oliver Hartkopp wrote:
> 
> 
> On 21.07.21 06:53, Greg KH wrote:
>> On Wed, Jul 21, 2021 at 09:09:37AM +0800, Ziyang Xuan wrote:
>>> We get a bug during ltp can_filter test as following.
>>>
>>> ===========================================
>>> [60919.264984] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
>>> [60919.265223] PGD 8000003dda726067 P4D 8000003dda726067 PUD 3dda727067 PMD 0
>>> [60919.265443] Oops: 0000 [#1] SMP PTI
>>> [60919.265550] CPU: 30 PID: 3638365 Comm: can_filter Kdump: loaded Tainted: G        W         4.19.90+ #1
> 
> This kernel version 4.19.90 is definitely outdated.
> 
> Can you please check your issue with the latest uptream kernel as this problem should have been fixed with this patch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8d0caedb759683041d9db82069937525999ada53
> ("can: bcm/raw/isotp: use per module netdevice notifier")
> 
> Thanks!

I have tested it under the latest 5.14-rc2 kernel version which includes commit 8d0caedb7596 before I submit the patch.
Although I failed to get the vmcore-dmesg file after updating the kernel version to 5.14-rc2 to display here.
But we can get the conclusion according to the following debug messages and my problem analysis.

==========================================
[ 1048.953574] unlist_netdevice name[vcan0]
[ 1048.953661] raw_notify 283: enter, waiting
[ 1050.950967] raw_setsockopt 552: ro->bound[1] ro->ifindex[8] sk[ffff9420c5699800]
[ 1053.956002] can: receive list entry not found for dev any, id 000, mask 000
[ 1053.961989] can: receive list entry not found for dev vcan0, id 123, mask 7FF

raw_setsockopt() executes after unlist_netdevice() and before raw_notify().
The problem always exists.

> 
>>> [60919.266068] RIP: 0010:selinux_socket_sock_rcv_skb+0x3e/0x200
>>> [60919.293289] RSP: 0018:ffff8d53bfc03cf8 EFLAGS: 00010246
>>> [60919.307140] RAX: 0000000000000000 RBX: 000000000000001d RCX: 0000000000000007
>>> [60919.320756] RDX: 0000000000000001 RSI: ffff8d5104a8ed00 RDI: ffff8d53bfc03d30
>>> [60919.334319] RBP: ffff8d9338056800 R08: ffff8d53bfc29d80 R09: 0000000000000001
>>> [60919.347969] R10: ffff8d53bfc03ec0 R11: ffffb8526ef47c98 R12: ffff8d53bfc03d30
>>> [60919.350320] perf: interrupt took too long (3063 > 2500), lowering kernel.perf_event_max_sample_rate to 65000
>>> [60919.361148] R13: 0000000000000001 R14: ffff8d53bcf90000 R15: 0000000000000000
>>> [60919.361151] FS:  00007fb78b6b3600(0000) GS:ffff8d53bfc00000(0000) knlGS:0000000000000000
>>> [60919.400812] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [60919.413730] CR2: 0000000000000010 CR3: 0000003e3f784006 CR4: 00000000007606e0
>>> [60919.426479] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [60919.439339] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> [60919.451608] PKRU: 55555554
>>> [60919.463622] Call Trace:
>>> [60919.475617]  <IRQ>
>>> [60919.487122]  ? update_load_avg+0x89/0x5d0
>>> [60919.498478]  ? update_load_avg+0x89/0x5d0
>>> [60919.509822]  ? account_entity_enqueue+0xc5/0xf0
>>> [60919.520709]  security_sock_rcv_skb+0x2a/0x40
>>> [60919.531413]  sk_filter_trim_cap+0x47/0x1b0
>>> [60919.542178]  ? kmem_cache_alloc+0x38/0x1b0
>>> [60919.552444]  sock_queue_rcv_skb+0x17/0x30
>>> [60919.562477]  raw_rcv+0x110/0x190 [can_raw]
>>> [60919.572539]  can_rcv_filter+0xbc/0x1b0 [can]
>>> [60919.582173]  can_receive+0x6b/0xb0 [can]
>>> [60919.591595]  can_rcv+0x31/0x70 [can]
>>> [60919.600783]  __netif_receive_skb_one_core+0x5a/0x80
>>> [60919.609864]  process_backlog+0x9b/0x150
>>> [60919.618691]  net_rx_action+0x156/0x400
>>> [60919.627310]  ? sched_clock_cpu+0xc/0xa0
>>> [60919.635714]  __do_softirq+0xe8/0x2e9
>>> [60919.644161]  do_softirq_own_stack+0x2a/0x40
>>> [60919.652154]  </IRQ>
>>> [60919.659899]  do_softirq.part.17+0x4f/0x60
>>> [60919.667475]  __local_bh_enable_ip+0x60/0x70
>>> [60919.675089]  __dev_queue_xmit+0x539/0x920
>>> [60919.682267]  ? finish_wait+0x80/0x80
>>> [60919.689218]  ? finish_wait+0x80/0x80
>>> [60919.695886]  ? sock_alloc_send_pskb+0x211/0x230
>>> [60919.702395]  ? can_send+0xe5/0x1f0 [can]
>>> [60919.708882]  can_send+0xe5/0x1f0 [can]
>>> [60919.715037]  raw_sendmsg+0x16d/0x268 [can_raw]
>>>
>>> It's because raw_setsockopt() concurrently with
>>> unregister_netdevice_many(). Concurrent scenario as following.
>>>
>>>     cpu0                        cpu1
>>> raw_bind
>>> raw_setsockopt                    unregister_netdevice_many
>>>                         unlist_netdevice
>>> dev_get_by_index                raw_notifier
>>> raw_enable_filters                ......
>>> can_rx_register
>>> can_rcv_list_find(..., net->can.rx_alldev_list)
>>>
>>> ......
>>>
>>> sock_close
>>> raw_release(sock_a)
>>>
>>> ......
>>>
>>> can_receive
>>> can_rcv_filter(net->can.rx_alldev_list, ...)
>>> raw_rcv(skb, sock_a)
>>> BUG
>>>
>>> After unlist_netdevice(), dev_get_by_index() return NULL in
>>> raw_setsockopt(). Function raw_enable_filters() will add sock
>>> and can_filter to net->can.rx_alldev_list. Then the sock is closed.
>>> Followed by, we sock_sendmsg() to a new vcan device use the same
>>> can_filter. Protocol stack match the old receiver whose sock has
>>> been released on net->can.rx_alldev_list in can_rcv_filter().
>>> Function raw_rcv() uses the freed sock. UAF BUG is triggered.
>>>
>>> We can find that the key issue is that net_device has not been
>>> protected in raw_setsockopt(). Use rtnl_lock to protect net_device
>>> in raw_setsockopt().
>>>
>>> Fixes: c18ce101f2e4 ("[CAN]: Add raw protocol")
>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>> ---
>>>   net/can/raw.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/net/can/raw.c b/net/can/raw.c
>>> index ed4fcb7ab0c3..a63e9915c66a 100644
>>> --- a/net/can/raw.c
>>> +++ b/net/can/raw.c
>>> @@ -546,6 +546,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>>>                   return -EFAULT;
>>>           }
>>>   +        rtnl_lock();
>>>           lock_sock(sk);
>>>             if (ro->bound && ro->ifindex)
>>> @@ -588,6 +589,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>>>               dev_put(dev);
>>>             release_sock(sk);
>>> +        rtnl_unlock();
>>>             break;
>>>   @@ -600,6 +602,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>>>             err_mask &= CAN_ERR_MASK;
>>>   +        rtnl_lock();
>>>           lock_sock(sk);
>>>             if (ro->bound && ro->ifindex)
>>> @@ -627,6 +630,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>>>               dev_put(dev);
>>>             release_sock(sk);
>>> +        rtnl_unlock();
>>>             break;
>>>   -- 
>>> 2.25.1
>>>
>>
>>
>> <formletter>
>>
>> This is not the correct way to submit patches for inclusion in the
>> stable kernel tree.  Please read:
>>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>> for how to do this properly.
>>
>> </formletter>
>>
> .
