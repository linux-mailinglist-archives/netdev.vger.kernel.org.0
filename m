Return-Path: <netdev+bounces-6405-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B21907162BE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:57:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 193B21C20BEA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6BA2106D;
	Tue, 30 May 2023 13:57:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9A91993C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:57:08 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1A5D9;
	Tue, 30 May 2023 06:57:05 -0700 (PDT)
Received: from dggpeml100026.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QVv570mwMzLq8h;
	Tue, 30 May 2023 21:54:03 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggpeml100026.china.huawei.com (7.185.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 21:57:01 +0800
Received: from dggpeml500020.china.huawei.com ([7.185.36.88]) by
 dggpeml500020.china.huawei.com ([7.185.36.88]) with mapi id 15.01.2507.023;
 Tue, 30 May 2023 21:57:01 +0800
From: "jiangheng (G)" <jiangheng14@huawei.com>
To: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "shakeelb@google.com"
	<shakeelb@google.com>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>,
	shaozhengchao <shaozhengchao@huawei.com>, "vasily.averin@linux.dev"
	<vasily.averin@linux.dev>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [BUG REPORT] softlock up in net/core cleanup_net
Thread-Topic: [BUG REPORT] softlock up in net/core cleanup_net
Thread-Index: AdmS/oB2zuwwtRmFQNyBzJRXz7YUCQ==
Date: Tue, 30 May 2023 13:57:01 +0000
Message-ID: <d2b08adaa6654692a15b57c9cbbc0bd7@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.136.117.195]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi all,
on linux 5.10,=A0 we want to use docker interactively when testing an inter=
nal feature. When docker restarts the container, it will call cleanup_net a=
nd a crash will occur.

[=A0 843.330515] CPU: 0 PID: 158 Comm: kworker/u8:2 Kdump: loaded Tainted: =
G=A0=A0=A0 B=A0=A0=A0=A0=A0 OEL=A0=A0=A0 #1 [=A0 843.330516] Hardware name:=
 QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015 [=A0 843.330523] Workqueue=
: netns cleanup_net [=A0 843.330526] pstate: 60400085 (nZCv daIf +PAN -UAO =
-TCO BTYPE=3D--) [=A0 843.330529] pc : machine_kexec+0x48/0x2b0 [=A0 843.33=
0531] lr : machine_kexec+0x48/0x2b0 [=A0 843.330531] sp : ffff80010284bb10 =
[=A0 843.330533] x29: ffff80010284bb10 x28: ffff0000ff851cf8 [=A0 843.33053=
5] x27: ffff0000ff851d78 x26: ffff80010284bda0 [=A0 843.330537] x25: ffff80=
0101d9c000 x24: 0000000000000001 [=A0 843.330539] x23: ffff800101d9c650 x22=
: ffff800101eb6000 [=A0 843.330541] x21: ffff800101eb6000 x20: ffff0000cba2=
3c00 [=A0 843.330543] x19: ffff0000cba23c00 x18: 0000000000000020 [ =A0843.=
330545] x17: 0000000000000000 x16: ffff800100d27a3c [=A0 843.330548] x15: f=
fffffffffffffff x14: 0000000060000085 [=A0 843.330550] x13: ffff8001001c090=
c x12: 0000000000000040 [=A0 843.330552] x11: ffff800101aad158 x10: 0000000=
0ffff8000 [=A0 843.330554] x9 : ffff800100157654 x8 : 0000000000000000 [=A0=
 843.330556] x7 : ffff8001017ed158 x6 : 0000000000017ffd [=A0 843.330559] x=
5 : ffff0000ff84b410 x4 : ffff80010284b910 [=A0 843.330561] x3 : 0000000000=
000001 x2 : 0000000000000000 [=A0 843.330563] x1 : 0000000000000000 x0 : ff=
ff0000c09eb9c0 [=A0 843.330566] Call trace:
[=A0 843.330569]=A0 machine_kexec+0x48/0x2b0 [=A0 843.330573]=A0 __crash_ke=
xec+0x90/0x13c [=A0 843.330578]=A0 panic+0x314/0x4d8 [=A0 843.330582]=A0 wa=
tchdog_timer_fn+0x26c/0x2f0 [=A0 843.330585]=A0 __run_hrtimer+0x98/0x2b4 [=
=A0 843.330586]=A0 __hrtimer_run_queues+0xbc/0x130 [=A0 843.330588]=A0 hrti=
mer_interrupt+0x150/0x3e4 [=A0 843.330592]=A0 arch_timer_handler_virt+0x3c/=
0x50 [=A0 843.330596]=A0 handle_percpu_devid_irq+0x90/0x1f4
[=A0 843.330599]=A0 __handle_domain_irq+0x84/0x100 [=A0 843.330601]=A0 gic_=
handle_irq+0x88/0x2b0 [=A0 843.330603]=A0 el1_irq+0xb8/0x140 [=A0 843.33060=
5]=A0 smp_call_function_single+0x1b8/0x1dc
[=A0 843.330608]=A0 rcu_barrier+0x1c4/0x2d0
[=A0 843.330612]=A0 netdev_run_todo+0x7c/0x330 [=A0 843.330615]=A0 rtnl_unl=
ock+0x18/0x24 [=A0 843.330616]=A0 default_device_exit_batch+0x15c/0x190
[=A0 843.330621]=A0 ops_exit_list+0x70/0x84
[=A0 843.330622]=A0 cleanup_net+0x184/0x2e0
[=A0 843.330625]=A0 process_one_work+0x1d4/0x4bc [=A0 843.330627]=A0 worker=
_thread+0x150/0x400 [=A0 843.330629]=A0 kthread+0x108/0x134 [=A0 843.330631=
]=A0 ret_from_fork+0x10/0x18 [=A0 843.330633] ---[ end trace 8378c01c76c90c=
c4 ]--- [=A0 843.330637] Bye!

Crash:bt -l
PID: 158=A0=A0=A0 TASK: ffff0000c09eb9c0=A0 CPU: 0=A0=A0 COMMAND: "kworker/=
u8:2"
PID: 158=A0=A0=A0 TASK: ffff0000c09eb9c0=A0 CPU: 0=A0=A0 COMMAND: "kworker/=
u8:2"
bt: invalid kernel virtual address: 0=A0 type: "IRQ stack contents"
bt: read of IRQ stack at 0 failed
#0 [ffff80010284bb60] __crash_kexec at ffff8001001c0908
=A0=A0=A0 /usr/src/debug/kernel/./arch/arm64/include/asm/kexec.h: 57
#1 [ffff80010284bcf0] panic at ffff800100d256a4
=A0=A0=A0 /usr/src/debug/kernel/kernel/panic.c: 392
#2 [ffff80010284bde0] watchdog_timer_fn at ffff80010020a5c8
=A0=A0=A0 /usr/src/debug/kernel/kernel/watchdog.c: 578
#3 [ffff80010284be30] __run_hrtimer at ffff800100191d24
=A0=A0=A0 /usr/src/debug/kernel/kernel/time/hrtimer.c: 1586
#4 [ffff80010284be80] __hrtimer_run_queues at ffff800100191ffc
=A0=A0=A0 /usr/src/debug/kernel/kernel/time/hrtimer.c: 1650
#5 [ffff80010284bee0] hrtimer_interrupt at ffff80010019267c
=A0=A0=A0 /usr/src/debug/kernel/kernel/time/hrtimer.c: 1712
#6 [ffff80010284bf50] arch_timer_handler_virt at ffff800100aa9a38
=A0=A0=A0 /usr/src/debug/kernel/drivers/clocksource/arm_arch_timer.c: 674
#7 [ffff80010284bf60] handle_percpu_devid_irq at ffff80010016500c
=A0=A0=A0 /usr/src/debug/kernel/./arch/arm64/include/asm/percpu.h: 45
#8 [ffff80010284bf90] __handle_domain_irq at ffff80010015b840
=A0=A0=A0 /usr/src/debug/kernel/./include/linux/irqdesc.h: 153
#9 [ffff80010284bfd0] gic_handle_irq at ffff800100010144
=A0=A0=A0 /usr/src/debug/kernel/./include/linux/irqdesc.h: 171
--- <IRQ stack> ---
#10 [ffff800102d4bb20] el1_irq at ffff800100012374
=A0=A0=A0 /usr/src/debug/kernel/arch/arm64/kernel/entry.S: 672
#11 [ffff800102d4bb40] smp_call_function_single at ffff8001001b1e68
=A0=A0=A0 /usr/src/debug/kernel/./arch/arm64/include/asm/cmpxchg.h: 278
#12 [ffff800102d4bba0] rcu_barrier at ffff800100178ba0
=A0=A0=A0 /usr/src/debug/kernel/kernel/rcu/tree.c: 3920
#13 [ffff800102d4bc00] netdev_run_todo at ffff800100b3f768
=A0=A0=A0 /usr/src/debug/kernel/net/core/dev.c: 10313
#14 [ffff800102d4bc80] rtnl_unlock at ffff800100b4cb54
=A0=A0=A0 /usr/src/debug/kernel/net/core/rtnetlink.c: 114
#15 [ffff800102d4bc90] default_device_exit_batch at ffff800100b378d8
=A0=A0=A0 /usr/src/debug/kernel/net/core/dev.c: 11287
#16 [ffff800102d4bd00] ops_exit_list at ffff800100b2337c
=A0=A0=A0 /usr/src/debug/kernel/net/core/net_namespace.c: 200
#17 [ffff800102d4bd30] cleanup_net at ffff800100b25ab0
=A0=A0=A0 /usr/src/debug/kernel/net/core/net_namespace.c: 616
#18 [ffff800102d4bd90] process_one_work at ffff8001000de784
=A0=A0=A0 /usr/src/debug/kernel/kernel/workqueue.c: 2354
#19 [ffff800102d4bdf0] worker_thread at ffff8001000df18c
=A0=A0=A0 /usr/src/debug/kernel/kernel/workqueue.c: 2500
#20 [ffff800102d4be50] kthread at ffff8001000e75a4
=A0=A0=A0 /usr/src/debug/kernel/kernel/kthread.c: 313

The above backtrace seems to be caused func:netdev_run_todo() that the size=
 of list not null.
void netdev_run_todo(void)
{
=A0=A0=A0=A0=A0=A0=A0=A0 struct net_device *dev, *tmp;
=A0=A0=A0=A0=A0=A0=A0=A0 struct list_head list;
#ifdef CONFIG_LOCKDEP
=A0=A0=A0=A0=A0=A0=A0=A0 struct list_head unlink_list;

=A0=A0=A0=A0=A0=A0=A0=A0 list_replace_init(&net_unlink_list, &unlink_list);

=A0=A0=A0=A0=A0=A0=A0=A0 while (!list_empty(&unlink_list)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct net_device *d=
ev =3D list_first_entry(&unlink_list,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0         =
                     struct net_device,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0unlink_li=
st);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 list_del_init(&dev->=
unlink_list);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev->nested_level =
=3D dev->lower_level - 1;
=A0=A0=A0=A0=A0=A0=A0=A0 }
#endif

=A0=A0=A0=A0=A0=A0=A0=A0 /* Snapshot list, allow later requests */
=A0=A0=A0=A0=A0=A0=A0=A0 list_replace_init(&net_todo_list, &list);

=A0=A0=A0=A0=A0=A0=A0=A0 __rtnl_unlock();

=A0=A0=A0=A0=A0=A0=A0=A0 /* Wait for rcu callbacks to finish before next ph=
ase */
=A0=A0=A0=A0=A0=A0=A0=A0 if !(list_empty(&list))
=A0=A0=A0=A0=A0=A0=A0=A0=A0          rcu_barrier();

I wonder if softlockup is due to the above code? Please help analyze the po=
ssible causes of this.


