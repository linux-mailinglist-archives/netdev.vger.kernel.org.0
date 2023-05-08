Return-Path: <netdev+bounces-823-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 756746FA28B
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 10:46:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CC1D280EC2
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2674125DF;
	Mon,  8 May 2023 08:46:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15597497
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 08:46:27 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A490944AB
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 01:46:21 -0700 (PDT)
Received: from kwepemm600019.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QFFG32DZvzsRFy;
	Mon,  8 May 2023 16:44:27 +0800 (CST)
Received: from huawei.com (10.44.134.232) by kwepemm600019.china.huawei.com
 (7.193.23.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 8 May
 2023 16:46:17 +0800
From: t.feng <fengtao40@huawei.com>
To: <netdev@vger.kernel.org>, <lucien.xin@gmail.com>, <luwei32@huawei.com>,
	<pabeni@redhat.com>, <kuba@kernel.org>, <edumazet@google.com>,
	<davem@davemloft.net>
CC: <yanan@huawei.com>, <fw@strlen.de>, <fengtao40@huawei.com>
Subject: [PATCH] ipvlan:Fix out-of-bounds caused by unclear skb->cb
Date: Mon, 8 May 2023 16:47:13 +0800
Message-ID: <20230508084713.3070489-1-fengtao40@huawei.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.134.232]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600019.china.huawei.com (7.193.23.64)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If skb enqueue the qdisc, fq_skb_cb(skb)->time_to_send is changed which
is actually skb->cb, and IPCB(skb_in)->opt will be used in
__ip_options_echo. It is possible that memcpy is out of bounds and lead
to stack overflow.
We should clear skb->cb before ip_local_out or ip6_local_out.

Stack info:
crash on stable-5.10(reproduce in kasan kernel).
------------[ cut here ]------------
[ 2203.651571] BUG: KASAN: stack-out-of-bounds in
__ip_options_echo+0x589/0x800
[ 2203.653327] Write of size 4 at addr ffff88811a388f27 by task
swapper/3/0

[ 2203.655460] CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Not tainted
5.10.0-60.18.0.50.h856.kasan.eulerosv2r11.x86_64 #1
[ 2203.655466] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.10.2-0-g5f4c7b1-20181220_000000-szxrtosci10000 04/01/2014
[ 2203.655475] Call Trace:
[ 2203.655481]  <IRQ>
[ 2203.655501]  dump_stack+0x9c/0xd3
[ 2203.655514]  print_address_description.constprop.0+0x19/0x170
[ 2203.655522]  ? __ip_options_echo+0x589/0x800
[ 2203.655530]  __kasan_report.cold+0x6c/0x84
[ 2203.655569]  ? resolve_normal_ct+0x301/0x430 [nf_conntrack]
[ 2203.655576]  ? __ip_options_echo+0x589/0x800
[ 2203.655586]  kasan_report+0x3a/0x50
[ 2203.655594]  check_memory_region+0xfd/0x1f0
[ 2203.655601]  memcpy+0x39/0x60
[ 2203.655608]  __ip_options_echo+0x589/0x800
[ 2203.655616]  ? ip_options_build+0x390/0x390
[ 2203.655628]  ? _raw_spin_trylock+0x91/0xe0
[ 2203.655635]  ? _raw_spin_lock_bh+0xe0/0xe0
[ 2203.655647]  ? icmp_global_allow+0x9d/0x120
[ 2203.655654]  __icmp_send+0x59a/0x960
[ 2203.655662]  ? icmpv4_global_allow+0x90/0x90
[ 2203.655675]  ? nf_nat_cleanup_conntrack+0xe0/0xe0 [nf_nat]
[ 2203.655702]  ? tcp_print_conntrack+0xb0/0xb0 [nf_conntrack]
[ 2203.655709]  ? memset+0x20/0x50
[ 2203.655719]  ? nf_nat_setup_info+0x2fb/0x480 [nf_nat]
[ 2203.655729]  ? get_unique_tuple+0x390/0x390 [nf_nat]
[ 2203.655735]  ? tcp_mt+0x456/0x550
[ 2203.655747]  ? ipt_do_table+0x776/0xa40 [ip_tables]
[ 2203.655755]  nf_send_unreach+0x129/0x3d0 [nf_reject_ipv4]
[ 2203.655763]  reject_tg+0x77/0x1bf [ipt_REJECT]
[ 2203.655772]  ipt_do_table+0x691/0xa40 [ip_tables]
[ 2203.655783]  ? ip_tables_net_init+0x20/0x20 [ip_tables]
[ 2203.655794]  ? nf_nat_icmp_reply_translation+0x380/0x380 [nf_nat]
[ 2203.655804]  ? nf_nat_ipv4_local_fn+0x1ba/0x290 [nf_nat]
[ 2203.655812]  ? iptable_filter_net_pre_exit+0x50/0x50 [iptable_filter]
[ 2203.655821]  nf_hook_slow+0x69/0x100
[ 2203.655828]  __ip_local_out+0x21e/0x2b0
[ 2203.655836]  ? ip_finish_output+0x190/0x190
[ 2203.655842]  ? ip_route_output_flow+0x114/0x1b0
[ 2203.655850]  ? ip_forward_options+0x330/0x330
[ 2203.655857]  ip_local_out+0x28/0x90
[ 2203.655868]  ipvlan_process_v4_outbound+0x21e/0x260 [ipvlan]
[ 2203.655878]  ? ipvlan_process_v6_forward+0x280/0x280 [ipvlan]
[ 2203.655887]  ? dst_release.part.0+0x3a/0xb0
[ 2203.655931]  ipvlan_xmit_mode_l3+0x3bd/0x400 [ipvlan]
[ 2203.655942]  ? ipvlan_xmit_mode_l2+0x3a0/0x3a0 [ipvlan]
[ 2203.655950]  ? skb_network_protocol+0xd5/0x2d0
[ 2203.655957]  ? skb_crc32c_csum_help+0x50/0x50
[ 2203.655967]  ipvlan_queue_xmit+0xb3/0x190 [ipvlan]
[ 2203.655977]  ipvlan_start_xmit+0x2e/0xb0 [ipvlan]
[ 2203.655984]  xmit_one.constprop.0+0xe1/0x280
[ 2203.655992]  dev_hard_start_xmit+0x62/0x100
[ 2203.656000]  sch_direct_xmit+0x215/0x640
[ 2203.656009]  ? pvclock_clocksource_read+0xf6/0x1d0
[ 2203.656015]  ? qdisc_free_cb+0x80/0x80
[ 2203.656022]  ? dequeue_skb+0x1d7/0x810
[ 2203.656028]  __qdisc_run+0x153/0x1f0
[ 2203.656035]  ? sch_direct_xmit+0x640/0x640
[ 2203.656046]  ? netem_dequeue+0x621/0x700 [sch_netem]
[ 2203.656053]  ? _raw_spin_lock+0x7a/0xd0
[ 2203.656060]  ? _raw_spin_lock_irq+0xd0/0xd0
[ 2203.656069]  __dev_queue_xmit+0x77f/0x1030
[ 2203.656082]  ? netdev_core_pick_tx+0x160/0x160
[ 2203.656126]  ? stack_trace_consume_entry+0x60/0x90
[ 2203.656139]  ? pollwake+0x123/0x180
[ 2203.656159]  ? selinux_peerlbl_enabled+0x81/0x90
[ 2203.656173]  ip_finish_output2+0x59b/0xc20
[ 2203.656184]  ? ip_rcv+0xbf/0x1b0
[ 2203.656195]  ? ip_reply_glue_bits+0x80/0x80
[ 2203.656206]  ? napi_poll+0x14f/0x420
[ 2203.656213]  ? __do_softirq+0xfd/0x402
[ 2203.656220]  ? asm_call_irq_on_stack+0x12/0x20
[ 2203.656228]  ? do_softirq_own_stack+0x37/0x50
[ 2203.656235]  ? get_stack_info_noinstr+0x14/0x110
[ 2203.656244]  __ip_finish_output.part.0+0x318/0x3d0
[ 2203.656258]  ? ip_finish_output_gso+0x130/0x130
[ 2203.656277]  ? get_stack_info+0x32/0xa0
[ 2203.656289]  ? get_stack_info_noinstr+0x14/0x110
[ 2203.656301]  ? get_stack_info_noinstr+0x14/0x110
[ 2203.656312]  ip_finish_output+0x168/0x190
[ 2203.656320]  ip_output+0x12d/0x220
[ 2203.656327]  ? ip_mc_output+0x500/0x500
[ 2203.656335]  ? secondary_startup_64_no_verify+0xc2/0xcb
[ 2203.656343]  ? __ip_finish_output+0xb0/0xb0
[ 2203.656349]  ? ipv4_dst_check+0x8b/0xb0
[ 2203.656357]  __ip_queue_xmit+0x392/0x880
[ 2203.656369]  ? __ip_queue_xmit+0x880/0x880
[ 2203.656380]  __tcp_transmit_skb+0x1088/0x11c0
[ 2203.656395]  ? tcp_event_new_data_sent+0x190/0x190
[ 2203.656402]  ? __tcp_select_window+0x490/0x490
[ 2203.656407]  ? tcp_trim_head+0x240/0x240
[ 2203.656414]  ? ipv4_dst_check+0x8b/0xb0
[ 2203.656421]  ? tcp_retrans_try_collapse+0x58/0x200
[ 2203.656428]  ? __sk_dst_check+0x7f/0xe0
[ 2203.656436]  __tcp_retransmit_skb+0x475/0xa30
[ 2203.656452]  ? tcp_retrans_try_collapse+0x200/0x200
[ 2203.656465]  ? tcp_mark_skb_lost+0x158/0x1c0
[ 2203.656477]  ? rb_next+0x1e/0x90
[ 2203.656484]  ? tcp_timeout_mark_lost+0x1b7/0x230
[ 2203.656492]  ? bictcp_cwnd_event+0x15/0xa0
[ 2203.656498]  ? bictcp_state+0x18c/0x1a0
[ 2203.656505]  tcp_retransmit_skb+0x2d/0x190
[ 2203.656512]  tcp_retransmit_timer+0x3af/0x9a0
[ 2203.656519]  tcp_write_timer_handler+0x3ba/0x510
[ 2203.656529]  tcp_write_timer+0x55/0x180
[ 2203.656536]  ? tcp_write_timer_handler+0x510/0x510
[ 2203.656542]  call_timer_fn+0x3f/0x1d0
[ 2203.656549]  ? tcp_write_timer_handler+0x510/0x510
[ 2203.656555]  expire_timers+0x160/0x200
[ 2203.656562]  run_timer_softirq+0x1f4/0x480
[ 2203.656569]  ? expire_timers+0x200/0x200
[ 2203.656576]  ? pvclock_clocksource_read+0xf6/0x1d0
[ 2203.656584]  ? kvm_sched_clock_read+0xd/0x20
[ 2203.656590]  ? sched_clock+0x5/0x10
[ 2203.656598]  ? sched_clock_cpu+0x18/0x130
[ 2203.656606]  __do_softirq+0xfd/0x402
[ 2203.656613]  asm_call_irq_on_stack+0x12/0x20
[ 2203.656617]  </IRQ>
[ 2203.656623]  do_softirq_own_stack+0x37/0x50
[ 2203.656631]  irq_exit_rcu+0x134/0x1a0
[ 2203.656639]  sysvec_apic_timer_interrupt+0x36/0x80
[ 2203.656646]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[ 2203.656654] RIP: 0010:default_idle+0x13/0x20
[ 2203.656663] Code: 89 f0 5d 41 5c 41 5d 41 5e c3 cc cc cc cc cc cc cc
cc cc cc cc cc cc 0f 1f 44 00 00 0f 1f 44 00 00 0f 00 2d 9f 32 57 00 fb
f4 <c3> cc cc cc cc 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 be 08
[ 2203.656668] RSP: 0018:ffff88810036fe78 EFLAGS: 00000256
[ 2203.656676] RAX: ffffffffaf2a87f0 RBX: ffff888100360000 RCX:
ffffffffaf290191
[ 2203.656681] RDX: 0000000000098b5e RSI: 0000000000000004 RDI:
ffff88811a3c4f60
[ 2203.656686] RBP: 0000000000000000 R08: 0000000000000001 R09:
ffff88811a3c4f63
[ 2203.656690] R10: ffffed10234789ec R11: 0000000000000001 R12:
0000000000000003
[ 2203.656695] R13: ffff888100360000 R14: 0000000000000000 R15:
0000000000000000
[ 2203.656703]  ? __cpuidle_text_start+0x8/0x8
[ 2203.656713]  ? rcu_eqs_enter.constprop.0+0x81/0xa0
[ 2203.656722]  ? __cpuidle_text_start+0x8/0x8
[ 2203.656729]  default_idle_call+0x5a/0x150
[ 2203.656735]  cpuidle_idle_call+0x1c6/0x220
[ 2203.656742]  ? arch_cpu_idle_exit+0x40/0x40
[ 2203.656748]  ? kvm_sched_clock_read+0xd/0x20
[ 2203.656754]  ? sched_clock+0x5/0x10
[ 2203.656760]  ? sched_clock_cpu+0x18/0x130
[ 2203.656767]  ? kvm_clock_get_cycles+0xd/0x20
[ 2203.656774]  ? tsc_verify_tsc_adjust+0x11f/0x160
[ 2203.656780]  do_idle+0xab/0x100
[ 2203.656786]  cpu_startup_entry+0x19/0x20
[ 2203.656793]  secondary_startup_64_no_verify+0xc2/0xcb

[ 2203.657409] The buggy address belongs to the page:
[ 2203.658648] page:0000000027a9842f refcount:1 mapcount:0
mapping:0000000000000000 index:0x0 pfn:0x11a388
[ 2203.658665] flags:
0x17ffffc0001000(reserved|node=0|zone=2|lastcpupid=0x1fffff)
[ 2203.658675] raw: 0017ffffc0001000 ffffea000468e208 ffffea000468e208
0000000000000000
[ 2203.658682] raw: 0000000000000000 0000000000000000 00000001ffffffff
0000000000000000
[ 2203.658686] page dumped because: kasan: bad access detected
------------[ cut here ]-----------

To reproduce(ipvlan with IPVLAN_MODE_L3):
Env setting:
=======================================================
modprobe ipvlan ipvlan_default_mode=1
sysctl net.ipv4.conf.eth0.forwarding=1
iptables -t nat -A POSTROUTING -s 20.0.0.0/255.255.255.0 -o eth0 -j
MASQUERADE
ip link add gw link eth0 type ipvlan
ip -4 addr add 20.0.0.254/24 dev gw
ip netns add net1
ip link add ipv1 link eth0 type ipvlan
ip link set ipv1 netns net1
ip netns exec net1 ip link set ipv1 up
ip netns exec net1 ip -4 addr add 20.0.0.4/24 dev ipv1
ip netns exec net1 route add default gw 20.0.0.254
ip netns exec net1 tc qdisc add dev ipv1 root netem loss 10%
ifconfig gw up
iptables -t filter -A OUTPUT -p tcp --dport 8888 -j REJECT --reject-with
icmp-port-unreachable
=======================================================
And then excute the shell(curl any address of eth0 can reach):

for((i=1;i<=100000;i++))
do
        ip netns exec net1 curl x.x.x.x:8888
done
=======================================================

Signed-off-by: "t.feng" <fengtao40@huawei.com>
Suggested-by: Florian Westphal <fw@strlen.de>
---
 drivers/net/ipvlan/ipvlan_core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 460b3d4f2245..9937d9f3df72 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -436,6 +436,9 @@ static int ipvlan_process_v4_outbound(struct sk_buff *skb)
 		goto err;
 	}
 	skb_dst_set(skb, &rt->dst);
+
+	memset(skb->cb, 0, sizeof(struct inet_skb_parm));
+
 	err = ip_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(err)))
 		dev->stats.tx_errors++;
@@ -474,6 +477,9 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
 		goto err;
 	}
 	skb_dst_set(skb, dst);
+
+	memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
+
 	err = ip6_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(err)))
 		dev->stats.tx_errors++;
-- 
2.27.0


