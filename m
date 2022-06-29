Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C995555FC30
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbiF2Jh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiF2Jh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:37:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDC13B3EE
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:37:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j2-20020a2597c2000000b0064b3e54191aso13508273ybo.20
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 02:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2vmOW5O+3X6jjcHv25xR/wkZ3qN26t3IZu4/4ShklkU=;
        b=Q/WVfWYrCCRrXUHdHdUntQaFpIZeUDVeDcHgsA8/7QIXA3pu147cw4U/XxmNlR+EV8
         JPjj31R1grZwDQmassvn+C/zkSFKLP+6CgrLxthDMhfANTOnfyu0PTWjakq8hU/3ELV6
         tjHmGlgFvD0/MgLWpRQjOgG8MPqUi7tIpK+efHCsq6fEIsC2AArBnz8bCrV9vBMEc4SC
         sV7dWq8kmyaOtOW0K9wirsG+yI3wiqIrf0UlZMyO9mP3s245u78Rga7hYzGvO+SjV18G
         NPZvOgHqSai5zdmCEXbivNBWJ+6Rq5QU7pYoNT8UxesKJoDDkmVcY/4PtFV6T5nFVPeN
         f0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2vmOW5O+3X6jjcHv25xR/wkZ3qN26t3IZu4/4ShklkU=;
        b=lhfobV4R8N7Hjbzp4AuTnKa/F9DrkOI4NjItgN3QMRzGfb4ID5uomaE8Bf4Lvbwu4q
         LxjHPveZNJNFqUpZJICTzRyZ/CBjVfVtbGpEFq0enAEsXQvYyKgilKH5pd6ydLmLCpP2
         jNX7TL0NspiSDPhKYrR0+ePHZaiZeI2RQ7vPORa6zOd4NDw3sYfnmXFm6XVTwuwDO28u
         7YnU0kJQQ/p0MBtpyaLezXvDsTJqUCs0OJdZxD6v30zJh7N3TQhZ6AF+IpK6T9hLs+li
         kWtxbSvB9H+sq6DHmcQhQv0j0vIwkjrqPmSToz+6QUMqX5VIV/FX94CKmNqVvuHab2Qi
         uYAg==
X-Gm-Message-State: AJIora/JtlIXModVvriQkj2GYTKfKiO56SAHWSiK1pCYt8VyPn9/NK7p
        jLvx8Y3B1ibOt0pJtRvw/rZ0SLOIMzYpDQ==
X-Google-Smtp-Source: AGRyM1uXr0jmzhPjkQBzi74H0612Pr4D0ApPpzxhx4S8dT8awlnhEa68RHfeyn6GbG2jg7WlcmrEAUb6fCfv7A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:431d:0:b0:317:8897:3d94 with SMTP id
 q29-20020a81431d000000b0031788973d94mr2774363ywa.456.1656495474309; Wed, 29
 Jun 2022 02:37:54 -0700 (PDT)
Date:   Wed, 29 Jun 2022 09:37:52 +0000
Message-Id: <20220629093752.1935215-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH net] net: tun: do not call napi_disable() twice
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Petar Penkov <ppenkov@aviatrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a hang in tun_napi_disable() while RTNL is held.

Because tun.c logic is complicated, I chose to:

1) rename tun->napi_enabled to tun->napi_configured

2) Add a new boolean, tracking if tun->napi is enabled or not.

INFO: task kworker/0:1:14 blocked for more than 143 seconds.
Not tainted 5.19.0-rc3-syzkaller-00144-g3b0dc529f56b #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:1 state:D stack:27168 pid: 14 ppid: 2 flags:0x00004000
Workqueue: ipv6_addrconf addrconf_verify_work
Call Trace:
<TASK>
context_switch kernel/sched/core.c:5146 [inline]
__schedule+0xa00/0x4b50 kernel/sched/core.c:6458
schedule+0xd2/0x1f0 kernel/sched/core.c:6530
schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6589
__mutex_lock_common kernel/locking/mutex.c:679 [inline]
__mutex_lock+0xa70/0x1350 kernel/locking/mutex.c:747
addrconf_verify_work+0xe/0x20 net/ipv6/addrconf.c:4616
process_one_work+0x996/0x1610 kernel/workqueue.c:2289
worker_thread+0x665/0x1080 kernel/workqueue.c:2436
kthread+0x2e9/0x3a0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
</TASK>
INFO: task dhcpcd:3190 blocked for more than 143 seconds.
Not tainted 5.19.0-rc3-syzkaller-00144-g3b0dc529f56b #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:dhcpcd state:D stack:22976 pid: 3190 ppid: 3189 flags:0x00000000
Call Trace:
<TASK>
context_switch kernel/sched/core.c:5146 [inline]
__schedule+0xa00/0x4b50 kernel/sched/core.c:6458
schedule+0xd2/0x1f0 kernel/sched/core.c:6530
schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6589
__mutex_lock_common kernel/locking/mutex.c:679 [inline]
__mutex_lock+0xa70/0x1350 kernel/locking/mutex.c:747
__netlink_dump_start+0x16a/0x900 net/netlink/af_netlink.c:2344
netlink_dump_start include/linux/netlink.h:245 [inline]
rtnetlink_rcv_msg+0x73e/0xc90 net/core/rtnetlink.c:6046
netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg+0xcf/0x120 net/socket.c:734
__sys_sendto+0x21a/0x320 net/socket.c:2119
__do_sys_sendto net/socket.c:2131 [inline]
__se_sys_sendto net/socket.c:2127 [inline]
__x64_sys_sendto+0xdd/0x1b0 net/socket.c:2127
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fca4209d206
RSP: 002b:00007fff12495ae8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fff12496c20 RCX: 00007fca4209d206
RDX: 0000000000000014 RSI: 00007fff12496b40 RDI: 0000000000000018
RBP: 00007fff12496bb0 R08: 00007fff12496b24 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff12496b40
R13: 00007fff12496b24 R14: 0000000000000000 R15: 00007fff12495af0
</TASK>

Showing all locks held in the system:
3 locks held by kworker/0:1/14:
1 lock held by khungtaskd/29:
1 lock held by dhcpcd/3190:
2 locks held by getty/3293:
1 lock held by syz-executor658/3647:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 29 Comm: khungtaskd Not tainted 5.19.0-rc3-syzkaller-00144-g3b0dc529f56b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
nmi_trigger_cpumask_backtrace+0x1e6/0x230 lib/nmi_backtrace.c:62
trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
check_hung_uninterruptible_tasks kernel/hung_task.c:220 [inline]
watchdog+0xc22/0xf90 kernel/hung_task.c:378
kthread+0x2e9/0x3a0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
</TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 3647 Comm: syz-executor658 Not tainted 5.19.0-rc3-syzkaller-00144-g3b0dc529f56b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:137 [inline]
RIP: 0010:lock_is_held_type+0xf0/0x140 kernel/locking/lockdep.c:5710
Code: f0 41 0f 94 c5 48 c7 c7 e0 7c cc 89 e8 69 0d 00 00 b8 ff ff ff ff 65 0f c1 05 d4 79 8b 76 83 f8 01 75 29 9c 58 f6 c4 02 75 3d <48> f7 04 24 00 02 00 00 74 01 fb 48 83 c4 08 44 89 e8 5b 5d 41 5c
RSP: 0018:ffffc90002fcf928 EFLAGS: 00000046
RAX: 0000000000000046 RBX: 0000000000000001 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: ffff8880b9b39ed8 R08: ffff8880b9b3a908 R09: ffffffff8dbb8517
R10: fffffbfff1b770a2 R11: dffffc0000000000 R12: ffff88801ba31d80
R13: 0000000000000001 R14: 00000000ffffffff R15: ffff88801ba32808
FS: 0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055fe675980b0 CR3: 000000000ba8e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
lock_is_held include/linux/lockdep.h:279 [inline]
lockdep_assert_rq_held kernel/sched/sched.h:1295 [inline]
rq_clock kernel/sched/sched.h:1450 [inline]
sched_info_arrive kernel/sched/stats.h:239 [inline]
sched_info_switch kernel/sched/stats.h:295 [inline]
prepare_task_switch kernel/sched/core.c:4955 [inline]
context_switch kernel/sched/core.c:5098 [inline]
__schedule+0x2b44/0x4b50 kernel/sched/core.c:6458
schedule+0xd2/0x1f0 kernel/sched/core.c:6530
schedule_hrtimeout_range_clock+0x195/0x390 kernel/time/hrtimer.c:2305
usleep_range_state+0x129/0x1b0 kernel/time/timer.c:2132
usleep_range include/linux/delay.h:67 [inline]
napi_disable+0xff/0x120 net/core/dev.c:6402
tun_napi_disable drivers/net/tun.c:285 [inline]
__tun_detach+0x165/0x1440 drivers/net/tun.c:643
tun_detach drivers/net/tun.c:700 [inline]
tun_chr_close+0xc4/0x180 drivers/net/tun.c:3454
__fput+0x277/0x9d0 fs/file_table.c:317
task_work_run+0xdd/0x1a0 kernel/task_work.c:177
exit_task_work include/linux/task_work.h:38 [inline]
do_exit+0xaff/0x2a00 kernel/exit.c:795
do_group_exit+0xd2/0x2f0 kernel/exit.c:925
__do_sys_exit_group kernel/exit.c:936 [inline]
__se_sys_exit_group kernel/exit.c:934 [inline]
__x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7efd8d173a29
Code: Unable to access opcode bytes at RIP 0x7efd8d1739ff.
RSP: 002b:00007ffdb72544d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007efd8d1e7330 RCX: 00007efd8d173a29
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 00007ffdb72546c8
R10: 00007ffdb72546c8 R11: 0000000000000246 R12: 00007efd8d1e7330
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
</TASK>

Fixes: a8fc8cb5692a ("net: tun: stop NAPI when detaching queues")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Petar Penkov <ppenkov@aviatrix.com>
---
 drivers/net/tun.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e2eb35887394e384972f573745f5870ba8c9d19b..7dab3dc1c387a4f98c72490e955e78b8d5d9da25 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -138,6 +138,7 @@ struct tun_file {
 		unsigned int ifindex;
 	};
 	struct napi_struct napi;
+	bool napi_configured;
 	bool napi_enabled;
 	bool napi_frags_enabled;
 	struct mutex napi_mutex;	/* Protects access to the above napi */
@@ -265,29 +266,34 @@ static int tun_napi_poll(struct napi_struct *napi, int budget)
 static void tun_napi_init(struct tun_struct *tun, struct tun_file *tfile,
 			  bool napi_en, bool napi_frags)
 {
-	tfile->napi_enabled = napi_en;
+	tfile->napi_configured = napi_en;
 	tfile->napi_frags_enabled = napi_en && napi_frags;
 	if (napi_en) {
 		netif_napi_add_tx(tun->dev, &tfile->napi, tun_napi_poll);
 		napi_enable(&tfile->napi);
+		tfile->napi_enabled = true;
 	}
 }
 
 static void tun_napi_enable(struct tun_file *tfile)
 {
-	if (tfile->napi_enabled)
+	if (tfile->napi_configured && !tfile->napi_enabled) {
 		napi_enable(&tfile->napi);
+		tfile->napi_enabled = true;
+	}
 }
 
 static void tun_napi_disable(struct tun_file *tfile)
 {
-	if (tfile->napi_enabled)
+	if (tfile->napi_configured && tfile->napi_enabled) {
 		napi_disable(&tfile->napi);
+		tfile->napi_enabled = false;
+	}
 }
 
 static void tun_napi_del(struct tun_file *tfile)
 {
-	if (tfile->napi_enabled)
+	if (tfile->napi_configured)
 		netif_napi_del(&tfile->napi);
 }
 
@@ -1977,7 +1983,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		napi_gro_frags(&tfile->napi);
 		local_bh_enable();
 		mutex_unlock(&tfile->napi_mutex);
-	} else if (tfile->napi_enabled) {
+	} else if (tfile->napi_configured) {
 		struct sk_buff_head *queue = &tfile->sk.sk_write_queue;
 		int queue_len;
 
@@ -2498,7 +2504,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	    !tfile->detached)
 		rxhash = __skb_get_hash_symmetric(skb);
 
-	if (tfile->napi_enabled) {
+	if (tfile->napi_configured) {
 		queue = &tfile->sk.sk_write_queue;
 		spin_lock(&queue->lock);
 		__skb_queue_tail(queue, skb);
@@ -2553,7 +2559,7 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 		if (flush)
 			xdp_do_flush();
 
-		if (tfile->napi_enabled && queued > 0)
+		if (tfile->napi_configured && queued > 0)
 			napi_schedule(&tfile->napi);
 
 		rcu_read_unlock();
-- 
2.37.0.rc0.161.g10f37bed90-goog

