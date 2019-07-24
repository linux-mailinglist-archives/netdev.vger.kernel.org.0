Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB5BF72C71
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 12:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfGXKit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 06:38:49 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2750 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726070AbfGXKis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 06:38:48 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D74983548EEC70FE794C;
        Wed, 24 Jul 2019 18:38:45 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 24 Jul 2019
 18:40:16 +0800
Subject: Re: [PATCH 4.4 stable net] net: tcp: Fix use-after-free in
 tcp_write_xmit
To:     Eric Dumazet <eric.dumazet@gmail.com>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190724091715.137033-1-maowenan@huawei.com>
 <badce2b6-b75e-db01-39c8-d68a0161c101@gmail.com>
 <be1aebb5-fee7-e079-d864-a2e4aa13007f@gmail.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <c7eb64e0-702d-0792-9aea-c303454e7a33@huawei.com>
Date:   Wed, 24 Jul 2019 18:38:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <be1aebb5-fee7-e079-d864-a2e4aa13007f@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/24 18:13, Eric Dumazet wrote:
> 
> 
> On 7/24/19 12:01 PM, Eric Dumazet wrote:
>>
>>
>> On 7/24/19 11:17 AM, Mao Wenan wrote:
>>> There is one report about tcp_write_xmit use-after-free with version 4.4.136:
>>
>> Current stable 4.4 is 4.4.186
>>
>> Can you check the bug is still there ?
>>
> 
> BTW, I tried the C repro and another bug showed up.
> 
> It looks like 4.4.186 misses other fixes :/

I will try 4.4.186.

> 
> [  180.811610] skbuff: skb_under_panic: text:ffffffff825ec6ea len:156 put:84 head:ffff8837dd1f0990 data:ffff8837dd1f098c tail:0x98 end:0xc0 dev:ip6gre0
> [  180.825037] ------------[ cut here ]------------
> [  180.829688] kernel BUG at net/core/skbuff.c:104!
> [  180.834316] invalid opcode: 0000 [#1] SMP KASAN
> [  180.839305] gsmi: Log Shutdown Reason 0x03
> [  180.843426] Modules linked in: ipip bonding bridge stp llc tun veth w1_therm wire i2c_mux_pca954x i2c_mux cdc_acm ehci_pci ehci_hcd ip_gre mlx4_en ib_uverbs mlx4_ib ib_sa ib_mad ib_core ib_addr mlx4_core
> [  180.862052] CPU: 22 PID: 1619 Comm: kworker/22:1 Not tainted 4.4.186-smp-DEV #41
> [  180.869475] Hardware name: Intel BIOS 2.56.0 10/19/2018
> [  180.876463] Workqueue: ipv6_addrconf addrconf_dad_work
> [  180.881658] task: ffff8837f1f59d80 ti: ffff8837eeeb8000 task.ti: ffff8837eeeb8000
> [  180.889171] RIP: 0010:[<ffffffff821ef26f>]  [<ffffffff821ef26f>] skb_panic+0x14f/0x210
> [  180.897162] RSP: 0018:ffff8837eeebf4b8  EFLAGS: 00010282
> [  180.902504] RAX: 0000000000000088 RBX: ffff8837eeeeb600 RCX: 0000000000000000
> [  180.909645] RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffffffff83508c00
> [  180.916854] RBP: ffff8837eeebf520 R08: 0000000000000016 R09: 0000000000000000
> [  180.924029] R10: ffff881fc8abf038 R11: 0000000000000007 R12: ffff881fc8abe720
> [  180.931213] R13: ffffffff82aa9e80 R14: 00000000000000c0 R15: 0000000000000098
> [  180.938390] FS:  0000000000000000(0000) GS:ffff8837ff280000(0000) knlGS:0000000000000000
> [  180.946519] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  180.952290] CR2: 00007f519426f530 CR3: 00000037d37f2000 CR4: 0000000000160670
> [  180.959447] Stack:
> [  180.961458]  ffff8837dd1f098c 0000000000000098 00000000000000c0 ffff881fc8abe720
> [  180.968909]  ffffea00df747c00 ffff881fff404b40 ffff8837ff2a1a20 ffff8837eeebf5b8
> [  180.976371]  ffff8837eeeeb600 ffffffff825ec6ea 1ffff106fddd7eb6 ffff8837eeeeb600
> [  180.983848] Call Trace:
> [  180.986297]  [<ffffffff825ec6ea>] ? ip6gre_header+0xba/0xd50
> [  180.991962]  [<ffffffff821f0e01>] skb_push+0xc1/0x100
> [  180.997023]  [<ffffffff825ec6ea>] ip6gre_header+0xba/0xd50
> [  181.002519]  [<ffffffff8158dc16>] ? memcpy+0x36/0x40
> [  181.007509]  [<ffffffff825ec630>] ? ip6gre_changelink+0x6d0/0x6d0
> [  181.013629]  [<ffffffff82550741>] ? ndisc_constructor+0x5b1/0x770
> [  181.019728]  [<ffffffff82666861>] ? _raw_write_unlock_bh+0x41/0x50
> [  181.025924]  [<ffffffff8226540b>] ? __neigh_create+0xe6b/0x1670
> [  181.031851]  [<ffffffff8225817f>] neigh_connected_output+0x23f/0x480
> [  181.038219]  [<ffffffff824f61ec>] ip6_finish_output2+0x74c/0x1a90
> [  181.044324]  [<ffffffff810f1d33>] ? print_context_stack+0x73/0xf0
> [  181.050429]  [<ffffffff824f5aa0>] ? ip6_xmit+0x1700/0x1700
> [  181.055933]  [<ffffffff82304a28>] ? nf_hook_slow+0x118/0x1b0
> [  181.061617]  [<ffffffff82502d7a>] ip6_finish_output+0x2ba/0x580
> [  181.067546]  [<ffffffff82503179>] ip6_output+0x139/0x380
> [  181.072884]  [<ffffffff82503040>] ? ip6_finish_output+0x580/0x580
> [  181.079004]  [<ffffffff82502ac0>] ? ip6_fragment+0x31b0/0x31b0
> [  181.084852]  [<ffffffff82251b51>] ? dst_init+0x4b1/0x820
> [  181.090172]  [<ffffffff8158da45>] ? kasan_unpoison_shadow+0x35/0x50
> [  181.096437]  [<ffffffff8158da45>] ? kasan_unpoison_shadow+0x35/0x50
> [  181.102712]  [<ffffffff8254f3ca>] NF_HOOK_THRESH.constprop.22+0xca/0x180
> [  181.109421]  [<ffffffff8254f300>] ? ndisc_alloc_skb+0x340/0x340
> [  181.115338]  [<ffffffff8254d820>] ? compat_ipv6_setsockopt+0x180/0x180
> [  181.121874]  [<ffffffff8254fbc2>] ndisc_send_skb+0x742/0xd10
> [  181.127550]  [<ffffffff8254f480>] ? NF_HOOK_THRESH.constprop.22+0x180/0x180
> [  181.134516]  [<ffffffff821f2440>] ? skb_complete_tx_timestamp+0x280/0x280
> [  181.141311]  [<ffffffff8254e2b3>] ? ndisc_fill_addr_option+0x193/0x260
> [  181.147844]  [<ffffffff82553bd9>] ndisc_send_rs+0x179/0x2d0
> [  181.153426]  [<ffffffff8251e7df>] addrconf_dad_completed+0x41f/0x7c0
> [  181.159795]  [<ffffffff81297f78>] ? pick_next_entity+0x198/0x470
> [  181.165807]  [<ffffffff8251e3c0>] ? addrconf_rs_timer+0x4a0/0x4a0
> [  181.171918]  [<ffffffff81aab928>] ? find_next_bit+0x18/0x20
> [  181.177504]  [<ffffffff81a99ec9>] ? prandom_seed+0xd9/0x160
> [  181.183095]  [<ffffffff8251eef5>] addrconf_dad_work+0x375/0x9e0
> [  181.189024]  [<ffffffff8251eb80>] ? addrconf_dad_completed+0x7c0/0x7c0
> [  181.195576]  [<ffffffff81249d8f>] process_one_work+0x52f/0xf60
> [  181.201468]  [<ffffffff8124a89d>] worker_thread+0xdd/0xe80
> [  181.206977]  [<ffffffff8265cf0a>] ? __schedule+0x73a/0x16d0
> [  181.212550]  [<ffffffff8124a7c0>] ? process_one_work+0xf60/0xf60
> [  181.218572]  [<ffffffff8125a115>] kthread+0x205/0x2b0
> [  181.223633]  [<ffffffff81259f10>] ? kthread_worker_fn+0x4e0/0x4e0
> [  181.229743]  [<ffffffff81259f10>] ? kthread_worker_fn+0x4e0/0x4e0
> [  181.235834]  [<ffffffff8266726f>] ret_from_fork+0x3f/0x70
> [  181.241232]  [<ffffffff81259f10>] ? kthread_worker_fn+0x4e0/0x4e0
> 
> 
> .
> 

