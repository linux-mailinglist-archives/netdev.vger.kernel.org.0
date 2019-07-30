Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3B279DF9
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 03:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbfG3BbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 21:31:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3237 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729473AbfG3BbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 21:31:24 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9DA0B8677B88E1F2180E;
        Tue, 30 Jul 2019 09:31:21 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Jul 2019
 09:31:20 +0800
Subject: Re: [PATCH stable 4.9] tcp: reset sk_send_head in
 tcp_write_queue_purge
To:     Sasha Levin <sashal@kernel.org>
References: <20190729132108.162320-1-maowenan@huawei.com>
 <20190729153218.GA29162@sasha-vm>
CC:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <29c1ee9c-4a5d-4f61-f526-85980185f0bd@huawei.com>
Date:   Tue, 30 Jul 2019 09:31:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190729153218.GA29162@sasha-vm>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/29 23:32, Sasha Levin wrote:
> On Mon, Jul 29, 2019 at 09:21:08PM +0800, Mao Wenan wrote:
>> From: Soheil Hassas Yeganeh <soheil@google.com>
>>
>> tcp_write_queue_purge clears all the SKBs in the write queue
>> but does not reset the sk_send_head. As a result, we can have
>> a NULL pointer dereference anywhere that we use tcp_send_head
>> instead of the tcp_write_queue_tail.
>>
>> For example, after a27fd7a8ed38 (tcp: purge write queue upon RST),
>> we can purge the write queue on RST. Prior to
>> 75c119afe14f (tcp: implement rb-tree based retransmit queue),
>> tcp_push will only check tcp_send_head and then accesses
>> tcp_write_queue_tail to send the actual SKB. As a result, it will
>> dereference a NULL pointer.
>>
>> This has been reported twice for 4.14 where we don't have
>> 75c119afe14f:
>>
>> By Timofey Titovets:
>>
>> [  422.081094] BUG: unable to handle kernel NULL pointer dereference
>> at 0000000000000038
>> [  422.081254] IP: tcp_push+0x42/0x110
>> [  422.081314] PGD 0 P4D 0
>> [  422.081364] Oops: 0002 [#1] SMP PTI
>>
>> By Yongjian Xu:
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
>> IP: tcp_push+0x48/0x120
>> PGD 80000007ff77b067 P4D 80000007ff77b067 PUD 7fd989067 PMD 0
>> Oops: 0002 [#18] SMP PTI
>> Modules linked in: tcp_diag inet_diag tcp_bbr sch_fq iTCO_wdt
>> iTCO_vendor_support pcspkr ixgbe mdio i2c_i801 lpc_ich joydev input_leds shpchp
>> e1000e igb dca ptp pps_core hwmon mei_me mei ipmi_si ipmi_msghandler sg ses
>> scsi_transport_sas enclosure ext4 jbd2 mbcache sd_mod ahci libahci megaraid_sas
>> wmi ast ttm dm_mirror dm_region_hash dm_log dm_mod dax
>> CPU: 6 PID: 14156 Comm: [ET_NET 6] Tainted: G D 4.14.26-1.el6.x86_64 #1
>> Hardware name: LENOVO ThinkServer RD440 /ThinkServer RD440, BIOS A0TS80A
>> 09/22/2014
>> task: ffff8807d78d8140 task.stack: ffffc9000e944000
>> RIP: 0010:tcp_push+0x48/0x120
>> RSP: 0018:ffffc9000e947a88 EFLAGS: 00010246
>> RAX: 00000000000005b4 RBX: ffff880f7cce9c00 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 0000000000000040 RDI: ffff8807d00f5000
>> RBP: ffffc9000e947aa8 R08: 0000000000001c84 R09: 0000000000000000
>> R10: ffff8807d00f5158 R11: 0000000000000000 R12: ffff8807d00f5000
>> R13: 0000000000000020 R14: 00000000000256d4 R15: 0000000000000000
>> FS: 00007f5916de9700(0000) GS:ffff88107fd00000(0000) knlGS:0000000000000000
>> CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000000000038 CR3: 00000007f8226004 CR4: 00000000001606e0
>> Call Trace:
>> tcp_sendmsg_locked+0x33d/0xe50
>> tcp_sendmsg+0x37/0x60
>> inet_sendmsg+0x39/0xc0
>> sock_sendmsg+0x49/0x60
>> sock_write_iter+0xb6/0x100
>> do_iter_readv_writev+0xec/0x130
>> ? rw_verify_area+0x49/0xb0
>> do_iter_write+0x97/0xd0
>> vfs_writev+0x7e/0xe0
>> ? __wake_up_common_lock+0x80/0xa0
>> ? __fget_light+0x2c/0x70
>> ? __do_page_fault+0x1e7/0x530
>> do_writev+0x60/0xf0
>> ? inet_shutdown+0xac/0x110
>> SyS_writev+0x10/0x20
>> do_syscall_64+0x6f/0x140
>> ? prepare_exit_to_usermode+0x8b/0xa0
>> entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>> RIP: 0033:0x3135ce0c57
>> RSP: 002b:00007f5916de4b00 EFLAGS: 00000293 ORIG_RAX: 0000000000000014
>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000003135ce0c57
>> RDX: 0000000000000002 RSI: 00007f5916de4b90 RDI: 000000000000606f
>> RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f5916de8c38
>> R10: 0000000000000000 R11: 0000000000000293 R12: 00000000000464cc
>> R13: 00007f5916de8c30 R14: 00007f58d8bef080 R15: 0000000000000002
>> Code: 48 8b 97 60 01 00 00 4c 8d 97 58 01 00 00 41 b9 00 00 00 00 41 89 f3 4c 39
>> d2 49 0f 44 d1 41 81 e3 00 80 00 00 0f 85 b0 00 00 00 <80> 4a 38 08 44 8b 8f 74
>> 06 00 00 44 89 8f 7c 06 00 00 83 e6 01
>> RIP: tcp_push+0x48/0x120 RSP: ffffc9000e947a88
>> CR2: 0000000000000038
>> ---[ end trace 8d545c2e93515549 ]---
>>
>> There is other scenario which found in stable 4.4:
>> Allocated:
>> [<ffffffff82f380a6>] __alloc_skb+0xe6/0x600 net/core/skbuff.c:218
>> [<ffffffff832466c3>] alloc_skb_fclone include/linux/skbuff.h:856 [inline]
>> [<ffffffff832466c3>] sk_stream_alloc_skb+0xa3/0x5d0 net/ipv4/tcp.c:833
>> [<ffffffff83249164>] tcp_sendmsg+0xd34/0x2b00 net/ipv4/tcp.c:1178
>> [<ffffffff83300ef3>] inet_sendmsg+0x203/0x4d0 net/ipv4/af_inet.c:755
>> Freed:
>> [<ffffffff82f372fd>] __kfree_skb+0x1d/0x20 net/core/skbuff.c:676
>> [<ffffffff83288834>] sk_wmem_free_skb include/net/sock.h:1447 [inline]
>> [<ffffffff83288834>] tcp_write_queue_purge include/net/tcp.h:1460 [inline]
>> [<ffffffff83288834>] tcp_connect_init net/ipv4/tcp_output.c:3122 [inline]
>> [<ffffffff83288834>] tcp_connect+0xb24/0x30c0 net/ipv4/tcp_output.c:3261
>> [<ffffffff8329b991>] tcp_v4_connect+0xf31/0x1890 net/ipv4/tcp_ipv4.c:246
>>
>> BUG: KASAN: use-after-free in tcp_skb_pcount include/net/tcp.h:796 [inline]
>> BUG: KASAN: use-after-free in tcp_init_tso_segs net/ipv4/tcp_output.c:1619 [inline]
>> BUG: KASAN: use-after-free in tcp_write_xmit+0x3fc2/0x4cb0 net/ipv4/tcp_output.c:2056
>> [<ffffffff81515cd5>] kasan_report.cold.7+0x175/0x2f7 mm/kasan/report.c:408
>> [<ffffffff814f9784>] __asan_report_load2_noabort+0x14/0x20 mm/kasan/report.c:427
>> [<ffffffff83286582>] tcp_skb_pcount include/net/tcp.h:796 [inline]
>> [<ffffffff83286582>] tcp_init_tso_segs net/ipv4/tcp_output.c:1619 [inline]
>> [<ffffffff83286582>] tcp_write_xmit+0x3fc2/0x4cb0 net/ipv4/tcp_output.c:2056
>> [<ffffffff83287a40>] __tcp_push_pending_frames+0xa0/0x290 net/ipv4/tcp_output.c:2307
>>
>> stable 4.4 and stable 4.9 don't have the commit abb4a8b870b5 ("tcp: purge write queue upon RST")
>> which is referred in dbbf2d1e4077,
>> in tcp_connect_init, it calls tcp_write_queue_purge, and does not reset sk_send_head, then UAF.
>>
>> stable 4.14 have the commit abb4a8b870b5 ("tcp: purge write queue upon RST"),
>> in tcp_reset, it calls tcp_write_queue_purge(sk), and does not reset sk_send_head, then UAF.
>>
>> So this patch can be used to fix stable 4.4 and 4.9.
>>
>> Fixes: a27fd7a8ed38 (tcp: purge write queue upon RST)
>> Reported-by: Timofey Titovets <nefelim4ag@gmail.com>
>> Reported-by: Yongjian Xu <yongjianchn@gmail.com>
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
>> Tested-by: Yongjian Xu <yongjianchn@gmail.com>
>>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> 
> So the "Fixes:" commit in the commit message is wrong? What's the actual
> commit that this fixes?

Upstream commit is 7f582b248d0a ("tcp: purge write queue in tcp_connect_init()")
linux-4.4.y
Fixes: 5bbe138a250e ("tcp: purge write queue in tcp_connect_init()")
linux-4.9.y
Fixes: 74a4c09d4b05 ("tcp: purge write queue in tcp_connect_init()")
linux-4.14.y
Fixes: a27fd7a8ed38 ("tcp: purge write queue upon RST")

> 
> -- 
> Thanks,
> Sasha
> 
> .
> 

