Return-Path: <netdev+bounces-7662-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADD2E721049
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 15:55:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41126281A48
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 13:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A638BC8E2;
	Sat,  3 Jun 2023 13:54:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF4E1FD9
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 13:54:58 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07DC123;
	Sat,  3 Jun 2023 06:54:54 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QYLsW2ryzztQTW;
	Sat,  3 Jun 2023 21:52:31 +0800 (CST)
Received: from [10.136.112.224] (10.136.112.224) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 3 Jun 2023 21:54:48 +0800
Message-ID: <4d2f356a-9a81-7868-2b62-e977672407e3@huawei.com>
Date: Sat, 3 Jun 2023 21:54:48 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
To: <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
	<kuba@kernel.org>, <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <yanan@huawei.com>, <caowangbao@huawei.com>
From: l00450120 <liaichun@huawei.com>
Subject: [report net/ipv6] neighbor table overflow causing CPU lockup followed
 by reset
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.136.112.224]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

     My server has 96 CPUs. When a large number of packets are sent and 
received, soft lockup alarms are generated on a large number of CPUs, 
and the stack is waiting for the spin_lock.

The following logs appear many times in my dmesg：
[  563.176845] neighbour: ndisc_cache: neighbor table overflow!
[ 1861.114898] Route cache is full: consider increasing sysctl 
net.ipv6.route.max_size.
[ 1892.475051] watchdog: BUG: soft lockup - CPU#48 stuck for 21s! 
[ksoftirqd/48:255]
[ 1892.483796] Sample time: 4008751670 ns(HZ: 250)
[ 1892.483797] Sample stat:
[ 1892.483800]  curr: user: 7437909680, nice: 0, sys: 49226747760, idle: 
1792240181470, iowait: 135261640, irq: 1422047840, softirq: 41069616090, 
st: 0
[ 1892.483802]  deta: user: 0, nice: 0, sys: 0, idle: 0, iowait: 0, irq: 
2903860, softirq: 3997094320, st: 0
[ 1892.483803] Sample softirq:
[ 1892.483804] Sample irqstat:
[ 1892.483807]     irq   14: delta       1001, curr:     473989, arch_timer
[ 1892.483839]     irq  342: delta          1, curr:        929, 
enp129s0f0-TxRx-0
[ 1892.483896] CPU: 48 PID: 255 Comm: ksoftirqd/48 Kdump: loaded 
Tainted: G           O      5.10.0-136.12.0.86
[ 1892.483898] Hardware name: Huawei S920X00/BC82AMDDA, BIOS 1.75 04/26/2021
[ 1892.483900] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO BTYPE=--)
[ 1892.483908] pc : native_queued_spin_lock_slowpath+0x254/0x37c
[ 1892.483912] lr : fib6_run_gc+0x234/0x25c
[ 1892.483914] sp : ffff8001046cb990
[ 1892.483915] x29: ffff8001046cb990 x28: ffff800101cfd810
[ 1892.483917] x27: ffff800100cee1a8 x26: 000000010006129b
[ 1892.483919] x25: 000000000000007d x24: ffff800101c94fc0
[ 1892.483921] x23: ffff800101c95048 x22: ffff8001017cafa8
[ 1892.483924] x21: ffff800100cc857c x20: 000000000000025b
[ 1892.483926] x19: ffff800101c94700 x18: 0000000000000001
[ 1892.483928] x17: 0000000000000040 x16: ffffffffffffffff
[ 1892.483930] x15: 00003fffffffffff x14: 000000000000ffff
[ 1892.483932] x13: 00000000000003f0 x12: ffff203f7fad7770
[ 1892.483934] x11: 5e0e1ffeff348dae x10: 00000000000080fe
[ 1892.483936] x9 : ffff803e7e682000 x8 : 0000000000000000
[ 1892.483938] x7 : ffff203f7fae8040 x6 : ffff800101466040
[ 1892.483940] x5 : ffff203f7fae8040 x4 : 0000000000000000
[ 1892.483942] x3 : ffff800101c95048 x2 : 0000000000000000
[ 1892.483944] x1 : 0000000000c40000 x0 : ffff203f7fae8048
[ 1892.483949] Call trace:
[ 1892.483951]  native_queued_spin_lock_slowpath+0x254/0x37c
[ 1892.483955]  ip6_dst_gc+0xb8/0x14c
[ 1892.483960]  dst_alloc+0xa4/0xe0
[ 1892.483962]  ip6_dst_alloc+0x30/0xb0
[ 1892.483964]  icmp6_dst_alloc+0x8c/0x21c
[ 1892.483966]  mld_sendpack+0x178/0x374
[ 1892.483968]  mld_send_cr+0x350/0x530
[ 1892.483970]  mld_ifc_timer_expire+0x28/0x174
[ 1892.483972]  call_timer_fn+0x3c/0x180
[ 1892.483973]  expire_timers+0x150/0x1d0
[ 1892.483974]  run_timer_softirq+0x134/0x380
[ 1892.483978]  __do_softirq+0x130/0x358
[ 1892.483980]  run_ksoftirqd+0x68/0x90
[ 1892.483983]  smpboot_thread_fn+0x15c/0x1a0
[ 1892.483985]  kthread+0x108/0x134
[ 1892.483987]  ret_from_fork+0x10/0x18

And i found out that other people had almost the same situation:
https://forum.proxmox.com/threads/unexplained-neighbor-table-overflow-causing-cpu-lockup-followed-by-reset.121289/

Looks like it's not an isolated case.

Could you give me some help?

Best regards,

LAC

