Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D281731F7
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 08:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgB1Ho7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 02:44:59 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:54984 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726969AbgB1Ho7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 02:44:59 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CEA0B37CD72BC9FC7880;
        Fri, 28 Feb 2020 15:44:51 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 28 Feb 2020
 15:44:51 +0800
Subject: Re: [stable-Linux 4.4.214] BUG: KASAN: use-after-free in
 rcu_accelerate_cbs+0x2f3/0x3c0 at addr ffff88007e419db0
To:     linux-kernel <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <steffen.klassert@secunet.com>
References: <213f493d-1451-ac7c-3208-86c44b73cd00@huawei.com>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <80f22e34-9580-6b26-8cd7-c78c6db22cdf@huawei.com>
Date:   Fri, 28 Feb 2020 15:44:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <213f493d-1451-ac7c-3208-86c44b73cd00@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LTS 4.19.106 also have this issue:

[71353.879282] BUG: KASAN: use-after-free in rcu_cblist_dequeue+0xad/0xc0
[71353.880314] Read of size 8 at addr ffff8882885c3528 by task ksoftirqd/2/22
[71353.881403]
[71353.881672] CPU: 2 PID: 22 Comm: ksoftirqd/2 Not tainted 4.19.106-514.55.6.9.x86_64 #5
[71353.882920] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[71353.884431] Call Trace:
[71353.884876]  dump_stack+0xaf/0xfb
[71353.885439]  print_address_description+0x75/0x290
[71353.886201]  kasan_report+0x28e/0x390
[71353.886809]  ? rcu_cblist_dequeue+0xad/0xc0
[71353.887494]  ? xfrm_policy_register_afinfo+0x2b0/0x2b0
[71353.888318]  rcu_cblist_dequeue+0xad/0xc0
[71353.888963]  rcu_process_callbacks+0x53b/0x1940
[71353.889698]  ? note_gp_changes+0x170/0x170
[71353.890371]  __do_softirq+0x22e/0x868
[71353.890990]  ? takeover_tasklets+0x700/0x700
[71353.891673]  run_ksoftirqd+0x30/0x60
[71353.892245]  smpboot_thread_fn+0x3ad/0x790
[71353.892902]  ? _raw_spin_unlock_irqrestore+0x32/0x60
[71353.893685]  ? sort_range+0x20/0x20
[71353.894254]  ? __kthread_parkme+0xad/0x180
[71353.894913]  ? sort_range+0x20/0x20
[71353.895467]  kthread+0x2e4/0x3e0
[71353.895990]  ? kthread_cancel_delayed_work_sync+0x10/0x10
[71353.896844]  ret_from_fork+0x3a/0x50
[71353.897434]
[71353.897698] Allocated by task 15407:
[71353.898278]  kasan_kmalloc+0xa6/0xd0
[71353.898854]  kmem_cache_alloc_trace+0x137/0x2c0
[71353.899568]  xfrm_policy_alloc+0x4d/0x340
[71353.900213]  xfrm_policy_construct+0x26/0x820
[71353.900906]  xfrm_add_policy+0x34f/0x6b0
[71353.901533]  xfrm_user_rcv_msg+0x32a/0x550
[71353.902214]  netlink_rcv_skb+0x26b/0x3b0
[71353.902854]  xfrm_netlink_rcv+0x68/0x80
[71353.903460]  netlink_unicast+0x408/0x590
[71353.904087]  netlink_sendmsg+0x77a/0xb40
[71353.904725]  sock_sendmsg+0xb3/0xf0
[71353.905277]  ___sys_sendmsg+0x67b/0x890
[71353.905891]  __sys_sendmsg+0xde/0x170
[71353.906483]  do_syscall_64+0xa5/0x490
[71353.907072]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[71353.907885]
[71353.908140] Freed by task 0:
[71353.908627]  __kasan_slab_free+0x132/0x180
[71353.909292]  kfree+0xef/0x2c0
[71353.909788]  rcu_process_callbacks+0x5ad/0x1940
[71353.910517]  __do_softirq+0x22e/0x868
[71353.911134]
[71353.911394] The buggy address belongs to the object at ffff8882885c3180
[71353.911394]  which belongs to the cache kmalloc-1024 of size 1024
[71353.913423] The buggy address is located 936 bytes inside of
[71353.913423]  1024-byte region [ffff8882885c3180, ffff8882885c3580)
[71353.915330] The buggy address belongs to the page:
[71353.916126] page:ffffea000a217000 count:1 mapcount:0 mapping:ffff888107c02a00 index:0x0 compound_mapcount: 0
[71353.917717] flags: 0x2fffff80008100(slab|head)
[71353.918445] raw: 002fffff80008100 0000000000000000 0000001a00000001 ffff888107c02a00
[71353.919703] raw: 0000000000000000 00000000001c001c 00000001ffffffff 0000000000000000
[71353.920947] page dumped because: kasan: bad access detected
[71353.921855]
[71353.922120] Memory state around the buggy address:
[71353.922902]  ffff8882885c3400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[71353.924048]  ffff8882885c3480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[71353.925183] >ffff8882885c3500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[71353.926313]                                   ^
[71353.927039]  ffff8882885c3580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[71353.928171]  ffff8882885c3600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[71353.929317] ==================================================================
[71353.930480] Disabling lock debugging due to kernel taint
[71353.931382] Kernel panic - not syncing: panic_on_warn set ...
[71353.931382]
[71353.932551] CPU: 2 PID: 22 Comm: ksoftirqd/2 Tainted: G    B             4.19.106-514.55.6.9.x86_64 #5
[71353.934050] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[71353.935567] Call Trace:
[71353.935991]  dump_stack+0xaf/0xfb
[71353.936536]  panic+0x1c0/0x35b
[71353.937051]  ? refcount_error_report+0x1a5/0x1a5
[71353.937817]  ? do_raw_spin_unlock+0x54/0x230
[71353.938508]  ? do_raw_spin_unlock+0x54/0x230
[71353.939207]  kasan_end_report+0x4f/0x50
[71353.939837]  kasan_report+0x113/0x390
[71353.940436]  ? rcu_cblist_dequeue+0xad/0xc0
[71353.941141]  ? xfrm_policy_register_afinfo+0x2b0/0x2b0
[71353.941981]  rcu_cblist_dequeue+0xad/0xc0
[71353.942630]  rcu_process_callbacks+0x53b/0x1940
[71353.943352]  ? note_gp_changes+0x170/0x170
[71353.944018]  __do_softirq+0x22e/0x868
[71353.944614]  ? takeover_tasklets+0x700/0x700
[71353.945289]  run_ksoftirqd+0x30/0x60
[71353.945868]  smpboot_thread_fn+0x3ad/0x790
[71353.946529]  ? _raw_spin_unlock_irqrestore+0x32/0x60
[71353.947327]  ? sort_range+0x20/0x20
[71353.947907]  ? __kthread_parkme+0xad/0x180
[71353.948560]  ? sort_range+0x20/0x20
[71353.949127]  kthread+0x2e4/0x3e0
[71353.949659]  ? kthread_cancel_delayed_work_sync+0x10/0x10
[71353.950516]  ret_from_fork+0x3a/0x50
[71353.952194] Dumping ftrace buffer:
[71353.952787]    (ftrace buffer empty)
[71353.953367] Kernel Offset: disabled
[71353.953940] Rebooting in 1 seconds..

On 2020/2/24 17:50, Yuehaibing wrote:
> We get this bug report, the config and reproducing procedure is attached.
> 
> Any comment is appreciated.
> 
.....

