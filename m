Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042AC4A97E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbfFRSJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:09:12 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:54397 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbfFRSJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:09:11 -0400
Received: by mail-ua1-f74.google.com with SMTP id c21so1823613uao.21
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0+dUGJD551BQn4Oab52qpg8uOCxzOCLS66N7T3ZBQBU=;
        b=YLPS/w93FLfY4JzFN1+gO2zijAj8GT/LrSdhqkHWf6mrXezmWZUEbq5APOtpZNRjag
         VL5kajG5SfWiTkOwBcIY3N+WKufLIWMrXbJLnvrfcCxNp2Zf5gL0o3auAQMialFYvw+A
         GTsD0ZQ2w9CRBScgFOMwIfgHEl72uxddJEBWW9WdjjL/XvX98C6s057JnGLCtzwJYFoT
         /jOXGDmKshQy1sYm/D1HEfCMR4Ch7+VtHsvwB9fvQBCMGtqs/Zx6AtprLAM6TpVgy2yU
         W1LCXEIStP0ovlieAieOYlsvliXO+CnmTfDx6np1CWiSeI9o4V0FYBOw53szsbmt+ctk
         M9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0+dUGJD551BQn4Oab52qpg8uOCxzOCLS66N7T3ZBQBU=;
        b=XQWrBYISpJLZ1aX0wg70aCRPgfVR/iGIDx0WUks55cVNaOqVmpWRX+9H6FGxEaA1fy
         JB6+k/BJmxPYOZvtYYYAP89YH/4hsZeNiAQDX8unDkjlU5vW7aFIY19ZJx/Kc6jBm+Rd
         WJAe2BrUD1Lrp4hYvpaLGGQ5Smz6wAo2eFqzwiJbQm+wtdb95SPUDR4dhWZ5UvtmyF3d
         CztsrqcQ3zBqsqLKSLznTnpvy8ggmdhjBbWjV08jhE6fKV7K6R3wVjzhH9gtYZgRwtGW
         qhd96HIXHTpspUEjK7SvBUtz5xWxzTYDaFOkb7Hi+ulsEvBFGJGyfmuwjjxeReDqWPg8
         CwWQ==
X-Gm-Message-State: APjAAAWDwGSuepXFqskH89nDxdopESrazqYvTACfmL0YJsxtDjh2ePLN
        MMtDjzrgYOYj6roAs1Pv9VfBlz3GVc3Wyw==
X-Google-Smtp-Source: APXvYqx7zQFgcrjshm+YY2/V1A7iFVYTPL7XfyQqGFnwvVUmEHt9U7wMntgHipIDzHbs2rzTU/JWn4GRZXHbbg==
X-Received: by 2002:ab0:6988:: with SMTP id t8mr19682363uaq.49.1560881350276;
 Tue, 18 Jun 2019 11:09:10 -0700 (PDT)
Date:   Tue, 18 Jun 2019 11:09:00 -0700
In-Reply-To: <20190618180900.88939-1-edumazet@google.com>
Message-Id: <20190618180900.88939-3-edumazet@google.com>
Mime-Version: 1.0
References: <20190618180900.88939-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net-next 2/2] inet: fix various use-after-free in defrags units
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported another issue caused by my recent patches. [1]

The issue here is that fqdir_exit() is initiating a work queue
and immediately returns. A bit later cleanup_net() was able
to free the MIB (percpu data) and the whole struct net was freed,
but we had active frag timers that fired and triggered use-after-free.

We need to make sure that timers can catch fqdir->dead being set,
to bailout.

Since RCU is used for the reader side, this means
we want to respect an RCU grace period between these operations :

1) qfdir->dead = 1;

2) netns dismantle (freeing of various data structure)

This patch uses new new (struct pernet_operations)->pre_exit
infrastructure to ensures a full RCU grace period
happens between fqdir_pre_exit() and fqdir_exit()

This also means we can use a regular work queue, we no
longer need rcu_work.

Tested:

$ time for i in {1..1000}; do unshare -n /bin/false;done

real	0m2.585s
user	0m0.160s
sys	0m2.214s

[1]

BUG: KASAN: use-after-free in ip_expire+0x73e/0x800 net/ipv4/ip_fragment.c:152
Read of size 8 at addr ffff88808b9fe330 by task syz-executor.4/11860

CPU: 1 PID: 11860 Comm: syz-executor.4 Not tainted 5.2.0-rc2+ #22
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
 __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
 kasan_report+0x12/0x20 mm/kasan/common.c:614
 __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
 ip_expire+0x73e/0x800 net/ipv4/ip_fragment.c:152
 call_timer_fn+0x193/0x720 kernel/time/timer.c:1322
 expire_timers kernel/time/timer.c:1366 [inline]
 __run_timers kernel/time/timer.c:1685 [inline]
 __run_timers kernel/time/timer.c:1653 [inline]
 run_timer_softirq+0x66f/0x1740 kernel/time/timer.c:1698
 __do_softirq+0x25c/0x94c kernel/softirq.c:293
 invoke_softirq kernel/softirq.c:374 [inline]
 irq_exit+0x180/0x1d0 kernel/softirq.c:414
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x13b/0x550 arch/x86/kernel/apic/apic.c:1068
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:806
 </IRQ>
RIP: 0010:tomoyo_domain_quota_is_ok+0x131/0x540 security/tomoyo/util.c:1035
Code: 24 4c 3b 65 d0 0f 84 9c 00 00 00 e8 19 1d 73 fe 49 8d 7c 24 18 48 ba 00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 0f b6 04 10 <48> 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 69 03 00 00 41 0f b6 5c
RSP: 0018:ffff88806ae079c0 EFLAGS: 00000a02 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: 0000000000000010 RCX: ffffc9000e655000
RDX: dffffc0000000000 RSI: ffffffff82fd88a7 RDI: ffff888086202398
RBP: ffff88806ae07a00 R08: ffff88808b6c8700 R09: ffffed100d5c0f4d
R10: ffffed100d5c0f4c R11: 0000000000000000 R12: ffff888086202380
R13: 0000000000000030 R14: 00000000000000d3 R15: 0000000000000000
 tomoyo_supervisor+0x2e8/0xef0 security/tomoyo/common.c:2087
 tomoyo_audit_path_number_log security/tomoyo/file.c:235 [inline]
 tomoyo_path_number_perm+0x42f/0x520 security/tomoyo/file.c:734
 tomoyo_file_ioctl+0x23/0x30 security/tomoyo/tomoyo.c:335
 security_file_ioctl+0x77/0xc0 security/security.c:1370
 ksys_ioctl+0x57/0xd0 fs/ioctl.c:711
 __do_sys_ioctl fs/ioctl.c:720 [inline]
 __se_sys_ioctl fs/ioctl.c:718 [inline]
 __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4592c9
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f8db5e44c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004592c9
RDX: 0000000020000080 RSI: 00000000000089f1 RDI: 0000000000000006
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f8db5e456d4
R13: 00000000004cc770 R14: 00000000004d5cd8 R15: 00000000ffffffff

Allocated by task 9047:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_kmalloc mm/kasan/common.c:489 [inline]
 __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
 kasan_slab_alloc+0xf/0x20 mm/kasan/common.c:497
 slab_post_alloc_hook mm/slab.h:437 [inline]
 slab_alloc mm/slab.c:3326 [inline]
 kmem_cache_alloc+0x11a/0x6f0 mm/slab.c:3488
 kmem_cache_zalloc include/linux/slab.h:732 [inline]
 net_alloc net/core/net_namespace.c:386 [inline]
 copy_net_ns+0xed/0x340 net/core/net_namespace.c:426
 create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:107
 unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:206
 ksys_unshare+0x440/0x980 kernel/fork.c:2692
 __do_sys_unshare kernel/fork.c:2760 [inline]
 __se_sys_unshare kernel/fork.c:2758 [inline]
 __x64_sys_unshare+0x31/0x40 kernel/fork.c:2758
 do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 2541:
 save_stack+0x23/0x90 mm/kasan/common.c:71
 set_track mm/kasan/common.c:79 [inline]
 __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
 kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
 __cache_free mm/slab.c:3432 [inline]
 kmem_cache_free+0x86/0x260 mm/slab.c:3698
 net_free net/core/net_namespace.c:402 [inline]
 net_drop_ns.part.0+0x70/0x90 net/core/net_namespace.c:409
 net_drop_ns net/core/net_namespace.c:408 [inline]
 cleanup_net+0x538/0x960 net/core/net_namespace.c:571
 process_one_work+0x989/0x1790 kernel/workqueue.c:2269
 worker_thread+0x98/0xe40 kernel/workqueue.c:2415
 kthread+0x354/0x420 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352

The buggy address belongs to the object at ffff88808b9fe100
 which belongs to the cache net_namespace of size 6784
The buggy address is located 560 bytes inside of
 6784-byte region [ffff88808b9fe100, ffff88808b9ffb80)
The buggy address belongs to the page:
page:ffffea00022e7f80 refcount:1 mapcount:0 mapping:ffff88821b6f60c0 index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea000256f288 ffffea0001bbef08 ffff88821b6f60c0
raw: 0000000000000000 ffff88808b9fe100 0000000100000001 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88808b9fe200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88808b9fe280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88808b9fe300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff88808b9fe380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88808b9fe400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 3c8fc8782044 ("inet: frags: rework rhashtable dismantle")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/inet_frag.h                 |  8 +++++++-
 include/net/ipv6_frag.h                 |  2 ++
 net/ieee802154/6lowpan/reassembly.c     | 13 +++++++++++--
 net/ipv4/inet_fragment.c                | 19 ++++---------------
 net/ipv4/ip_fragment.c                  | 14 ++++++++++++--
 net/ipv6/netfilter/nf_conntrack_reasm.c | 10 ++++++++--
 net/ipv6/reassembly.c                   | 10 ++++++++--
 7 files changed, 52 insertions(+), 24 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index e91b79ad4e4adfc1dadb9d00a91f2f2c669d732d..46574d996f1dc658487283de2ca469f1db42be03 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -20,7 +20,7 @@ struct fqdir {
 
 	/* Keep atomic mem on separate cachelines in structs that include it */
 	atomic_long_t		mem ____cacheline_aligned_in_smp;
-	struct rcu_work		destroy_rwork;
+	struct work_struct	destroy_work;
 };
 
 /**
@@ -113,6 +113,12 @@ int inet_frags_init(struct inet_frags *);
 void inet_frags_fini(struct inet_frags *);
 
 int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net);
+
+static void inline fqdir_pre_exit(struct fqdir *fqdir)
+{
+	fqdir->high_thresh = 0; /* prevent creation of new frags */
+	fqdir->dead = true;
+}
 void fqdir_exit(struct fqdir *fqdir);
 
 void inet_frag_kill(struct inet_frag_queue *q);
diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
index 1f77fb4dc79df6bc4e41d6d2f4d49ace32082ca4..a21e8b1381a107c8afd4a832f523bc87d045b890 100644
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -67,6 +67,8 @@ ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
 	struct sk_buff *head;
 
 	rcu_read_lock();
+	if (fq->q.fqdir->dead)
+		goto out_rcu_unlock;
 	spin_lock(&fq->q.lock);
 
 	if (fq->q.flags & INET_FRAG_COMPLETE)
diff --git a/net/ieee802154/6lowpan/reassembly.c b/net/ieee802154/6lowpan/reassembly.c
index a0ed13cd120e783114bf75309006b6d04901cd63..e4aba5d485be6a59c639a23b75172f5015c4280f 100644
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -459,6 +459,14 @@ static int __net_init lowpan_frags_init_net(struct net *net)
 	return res;
 }
 
+static void __net_exit lowpan_frags_pre_exit_net(struct net *net)
+{
+	struct netns_ieee802154_lowpan *ieee802154_lowpan =
+		net_ieee802154_lowpan(net);
+
+	fqdir_pre_exit(ieee802154_lowpan->fqdir);
+}
+
 static void __net_exit lowpan_frags_exit_net(struct net *net)
 {
 	struct netns_ieee802154_lowpan *ieee802154_lowpan =
@@ -469,8 +477,9 @@ static void __net_exit lowpan_frags_exit_net(struct net *net)
 }
 
 static struct pernet_operations lowpan_frags_ops = {
-	.init = lowpan_frags_init_net,
-	.exit = lowpan_frags_exit_net,
+	.init		= lowpan_frags_init_net,
+	.pre_exit	= lowpan_frags_pre_exit_net,
+	.exit		= lowpan_frags_exit_net,
 };
 
 static u32 lowpan_key_hashfn(const void *data, u32 len, u32 seed)
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 5c25727d491e75bec4c31457784676d90e29e80a..d666756be5f18404ce8e85a95e9f09636d5f2694 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -145,10 +145,9 @@ static void inet_frags_free_cb(void *ptr, void *arg)
 		inet_frag_destroy(fq);
 }
 
-static void fqdir_rwork_fn(struct work_struct *work)
+static void fqdir_work_fn(struct work_struct *work)
 {
-	struct fqdir *fqdir = container_of(to_rcu_work(work),
-					   struct fqdir, destroy_rwork);
+	struct fqdir *fqdir = container_of(work, struct fqdir, destroy_work);
 	struct inet_frags *f = fqdir->f;
 
 	rhashtable_free_and_destroy(&fqdir->rhashtable, inet_frags_free_cb, NULL);
@@ -187,18 +186,8 @@ EXPORT_SYMBOL(fqdir_init);
 
 void fqdir_exit(struct fqdir *fqdir)
 {
-	fqdir->high_thresh = 0; /* prevent creation of new frags */
-
-	fqdir->dead = true;
-
-	/* call_rcu is supposed to provide memory barrier semantics,
-	 * separating the setting of fqdir->dead with the destruction
-	 * work.  This implicit barrier is paired with inet_frag_kill().
-	 */
-
-	INIT_RCU_WORK(&fqdir->destroy_rwork, fqdir_rwork_fn);
-	queue_rcu_work(system_wq, &fqdir->destroy_rwork);
-
+	INIT_WORK(&fqdir->destroy_work, fqdir_work_fn);
+	queue_work(system_wq, &fqdir->destroy_work);
 }
 EXPORT_SYMBOL(fqdir_exit);
 
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 1ffaec056821b8e0bd0915403b0a3a1d449690ec..4385eb9e781ffc017a65d166ddf12c11fc901c0e 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -143,6 +143,10 @@ static void ip_expire(struct timer_list *t)
 	net = qp->q.fqdir->net;
 
 	rcu_read_lock();
+
+	if (qp->q.fqdir->dead)
+		goto out_rcu_unlock;
+
 	spin_lock(&qp->q.lock);
 
 	if (qp->q.flags & INET_FRAG_COMPLETE)
@@ -676,6 +680,11 @@ static int __net_init ipv4_frags_init_net(struct net *net)
 	return res;
 }
 
+static void __net_exit ipv4_frags_pre_exit_net(struct net *net)
+{
+	fqdir_pre_exit(net->ipv4.fqdir);
+}
+
 static void __net_exit ipv4_frags_exit_net(struct net *net)
 {
 	ip4_frags_ns_ctl_unregister(net);
@@ -683,8 +692,9 @@ static void __net_exit ipv4_frags_exit_net(struct net *net)
 }
 
 static struct pernet_operations ip4_frags_ops = {
-	.init = ipv4_frags_init_net,
-	.exit = ipv4_frags_exit_net,
+	.init		= ipv4_frags_init_net,
+	.pre_exit	= ipv4_frags_pre_exit_net,
+	.exit		= ipv4_frags_exit_net,
 };
 
 
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index b8962d4d6ae650f890fec8de754d4ff92a050974..3299a389d166b69467e741813822f8182321ce39 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -499,6 +499,11 @@ static int nf_ct_net_init(struct net *net)
 	return res;
 }
 
+static void nf_ct_net_pre_exit(struct net *net)
+{
+	fqdir_pre_exit(net->nf_frag.fqdir);
+}
+
 static void nf_ct_net_exit(struct net *net)
 {
 	nf_ct_frags6_sysctl_unregister(net);
@@ -506,8 +511,9 @@ static void nf_ct_net_exit(struct net *net)
 }
 
 static struct pernet_operations nf_ct_net_ops = {
-	.init = nf_ct_net_init,
-	.exit = nf_ct_net_exit,
+	.init		= nf_ct_net_init,
+	.pre_exit	= nf_ct_net_pre_exit,
+	.exit		= nf_ct_net_exit,
 };
 
 static const struct rhashtable_params nfct_rhash_params = {
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 0c9fd8a7c4e726c2be8c7831f9b32f728c3b973c..ca05b16f1bb95d4122a79fa9759011fd204f3e6f 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -520,6 +520,11 @@ static int __net_init ipv6_frags_init_net(struct net *net)
 	return res;
 }
 
+static void __net_exit ipv6_frags_pre_exit_net(struct net *net)
+{
+	fqdir_pre_exit(net->ipv6.fqdir);
+}
+
 static void __net_exit ipv6_frags_exit_net(struct net *net)
 {
 	ip6_frags_ns_sysctl_unregister(net);
@@ -527,8 +532,9 @@ static void __net_exit ipv6_frags_exit_net(struct net *net)
 }
 
 static struct pernet_operations ip6_frags_ops = {
-	.init = ipv6_frags_init_net,
-	.exit = ipv6_frags_exit_net,
+	.init		= ipv6_frags_init_net,
+	.pre_exit	= ipv6_frags_pre_exit_net,
+	.exit		= ipv6_frags_exit_net,
 };
 
 static const struct rhashtable_params ip6_rhash_params = {
-- 
2.22.0.410.gd8fdbe21b5-goog

