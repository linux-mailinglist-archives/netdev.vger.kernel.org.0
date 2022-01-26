Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2F849D16A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 19:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbiAZSHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 13:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiAZSHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 13:07:19 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5871C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 10:07:19 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id r59so407069pjg.4
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 10:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0U+VWc2OMJHZavzm1G6VqOpxzkLwQbtULvahec56s6c=;
        b=K+69qJBNUoIHlf0fq38F0BoA9/gHJ/+tpzs6lPrp/w/AAYKvKd+cAOj/OezpVxY8kE
         kzbAheVRcZJINmrNpsOY0n0t9/+CWygI20+WG5AmFp2ZiFjbfn5dd3OkaFYXGftgeRyh
         +y+vEUSwUEr4YgzGDGomOs2QRqD1PNPrBqiRswezlb2oVlxDy7vBiKpCJpnvCQZjRbke
         nbfThLc8R2bPLNdbmBnvEWvvBn4ZLDWDeGGKrqanXKsZRIFiK/L7YnA5k6hmymUthCou
         mr/e5bunkeBNgBE7vLNkxrIC2ZmPuij1lYbg+wxPP29CpRdpoVNr/omrgsOdCulvppHN
         179A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0U+VWc2OMJHZavzm1G6VqOpxzkLwQbtULvahec56s6c=;
        b=cMmmrHIN6wPKdkm9Qi/uV1LPUs+aInmPjb9l9ZWxqSFiXyEA4EOQfYzZfibYZC4RnC
         ImkyqVP87zGYWhYvCtBBCW3s4HBX7seqQ0Gf4T3j8aqP8xuJMwS7XugPvcAY+69iA/n/
         3iD+DMPEHYA5ocEGi2jy2RwhbHDrXG3PMJhJUvGF72g/WjenYTXPwm5/70DrstAWNt6+
         jjynsNJpSroxjWYXGrBM1naK/0D2pWdwQ9LoAHkYtxQ746bwvJcGQBMPqYuvqsJMu76L
         e6F1EVx+ur+98+XkUJaKBMc5bBugv69HSQckf4Rd3a8EGK7lJiYi4P6sttdzUstUBFkK
         d+oA==
X-Gm-Message-State: AOAM530rfvN1a3GpWXfEf7sYsme7HMhtch4wigVEuLZAZCn8f/5erctl
        fnLBh5UKczHQmBRwPwKSU8k=
X-Google-Smtp-Source: ABdhPJx3JyR2KhjD7cMOgoddhowQtLPZHha+kZPFJIL45He2BiiVu0DPlXi3KHT4rFzeFhZzNyGVrQ==
X-Received: by 2002:a17:90b:4d84:: with SMTP id oj4mr91898pjb.192.1643220439053;
        Wed, 26 Jan 2022 10:07:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:cfcb:2c25:b567:59da])
        by smtp.gmail.com with ESMTPSA id a17sm17116737pgh.9.2022.01.26.10.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 10:07:18 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next] tcp: allocate tcp_death_row outside of struct netns_ipv4
Date:   Wed, 26 Jan 2022 10:07:14 -0800
Message-Id: <20220126180714.845362-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

I forgot tcp had per netns tracking of timewait sockets,
and their sysctl to change the limit.

After 0dad4087a86a ("tcp/dccp: get rid of inet_twsk_purge()"),
whole struct net can be freed before last tw socket is freed.

We need to allocate a separate struct inet_timewait_death_row
object per netns.

tw_count becomes a refcount and gains associated debugging infrastructure.

BUG: KASAN: use-after-free in inet_twsk_kill+0x358/0x3c0 net/ipv4/inet_timewait_sock.c:46
Read of size 8 at addr ffff88807d5f9f40 by task kworker/1:7/3690

CPU: 1 PID: 3690 Comm: kworker/1:7 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events pwq_unbound_release_workfn
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 inet_twsk_kill+0x358/0x3c0 net/ipv4/inet_timewait_sock.c:46
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x67c/0xa30 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:lockdep_unregister_key+0x1c9/0x250 kernel/locking/lockdep.c:6328
Code: 00 00 00 48 89 ee e8 46 fd ff ff 4c 89 f7 e8 5e c9 ff ff e8 09 cc ff ff 9c 58 f6 c4 02 75 26 41 f7 c4 00 02 00 00 74 01 fb 5b <5d> 41 5c 41 5d 41 5e 41 5f e9 19 4a 08 00 0f 0b 5b 5d 41 5c 41 5d
RSP: 0018:ffffc90004077cb8 EFLAGS: 00000206
RAX: 0000000000000046 RBX: ffff88807b61b498 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888077027128 R08: 0000000000000001 R09: ffffffff8f1ea4fc
R10: fffffbfff1ff93ee R11: 000000000000af1e R12: 0000000000000246
R13: 0000000000000000 R14: ffffffff8ffc89b8 R15: ffffffff90157fb0
 wq_unregister_lockdep kernel/workqueue.c:3508 [inline]
 pwq_unbound_release_workfn+0x254/0x340 kernel/workqueue.c:3746
 process_one_work+0x9ac/0x1650 kernel/workqueue.c:2307
 worker_thread+0x657/0x1110 kernel/workqueue.c:2454
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Allocated by task 3635:
 kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:437 [inline]
 __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:470
 kasan_slab_alloc include/linux/kasan.h:260 [inline]
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3230 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc+0x202/0x3a0 mm/slub.c:3243
 kmem_cache_zalloc include/linux/slab.h:705 [inline]
 net_alloc net/core/net_namespace.c:407 [inline]
 copy_net_ns+0x125/0x760 net/core/net_namespace.c:462
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3048
 __do_sys_unshare kernel/fork.c:3119 [inline]
 __se_sys_unshare kernel/fork.c:3117 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3117
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88807d5f9a80
 which belongs to the cache net_namespace of size 6528
The buggy address is located 1216 bytes inside of
 6528-byte region [ffff88807d5f9a80, ffff88807d5fb400)
The buggy address belongs to the page:
page:ffffea0001f57e00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88807d5f9a80 pfn:0x7d5f8
head:ffffea0001f57e00 order:3 compound_mapcount:0 compound_pincount:0
memcg:ffff888070023001
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 ffff888010dd4f48 ffffea0001404e08 ffff8880118fd000
raw: ffff88807d5f9a80 0000000000040002 00000001ffffffff ffff888070023001
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3634, ts 119694798460, free_ts 119693556950
 prep_new_page mm/page_alloc.c:2434 [inline]
 get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab mm/slub.c:1944 [inline]
 new_slab+0x28a/0x3b0 mm/slub.c:2004
 ___slab_alloc+0x87c/0xe90 mm/slub.c:3018
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
 slab_alloc_node mm/slub.c:3196 [inline]
 slab_alloc mm/slub.c:3238 [inline]
 kmem_cache_alloc+0x35c/0x3a0 mm/slub.c:3243
 kmem_cache_zalloc include/linux/slab.h:705 [inline]
 net_alloc net/core/net_namespace.c:407 [inline]
 copy_net_ns+0x125/0x760 net/core/net_namespace.c:462
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3048
 __do_sys_unshare kernel/fork.c:3119 [inline]
 __se_sys_unshare kernel/fork.c:3117 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3117
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1352 [inline]
 free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
 free_unref_page_prepare mm/page_alloc.c:3325 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3404
 skb_free_head net/core/skbuff.c:655 [inline]
 skb_release_data+0x65d/0x790 net/core/skbuff.c:677
 skb_release_all net/core/skbuff.c:742 [inline]
 __kfree_skb net/core/skbuff.c:756 [inline]
 consume_skb net/core/skbuff.c:914 [inline]
 consume_skb+0xc2/0x160 net/core/skbuff.c:908
 skb_free_datagram+0x1b/0x1f0 net/core/datagram.c:325
 netlink_recvmsg+0x636/0xea0 net/netlink/af_netlink.c:1998
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 ____sys_recvmsg+0x2c4/0x600 net/socket.c:2632
 ___sys_recvmsg+0x127/0x200 net/socket.c:2674
 __sys_recvmsg+0xe2/0x1a0 net/socket.c:2704
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88807d5f9e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807d5f9e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88807d5f9f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88807d5f9f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807d5fa000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Fixes: 0dad4087a86a ("tcp/dccp: get rid of inet_twsk_purge()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/netns/ipv4.h      |  8 +++-----
 net/dccp/minisocks.c          |  1 +
 net/ipv4/inet_timewait_sock.c |  8 +++++---
 net/ipv4/proc.c               |  4 ++--
 net/ipv4/sysctl_net_ipv4.c    | 20 ++++++++++++--------
 net/ipv4/tcp_ipv4.c           | 14 +++++++++++---
 net/ipv4/tcp_minisocks.c      |  2 +-
 net/ipv6/tcp_ipv6.c           |  3 ++-
 8 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 22b4c6df1d2b383cd10dd3dc11cf8c39388c50bf..94568e02200134efd3c187823e545bcea5dfafeb 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -31,18 +31,16 @@ struct ping_group_range {
 struct inet_hashinfo;
 
 struct inet_timewait_death_row {
-	atomic_t		tw_count;
-	char			tw_pad[L1_CACHE_BYTES - sizeof(atomic_t)];
+	refcount_t		tw_refcount;
 
-	struct inet_hashinfo 	*hashinfo;
+	struct inet_hashinfo 	*hashinfo ____cacheline_aligned_in_smp;
 	int			sysctl_max_tw_buckets;
 };
 
 struct tcp_fastopen_context;
 
 struct netns_ipv4 {
-	/* Please keep tcp_death_row at first field in netns_ipv4 */
-	struct inet_timewait_death_row tcp_death_row ____cacheline_aligned_in_smp;
+	struct inet_timewait_death_row *tcp_death_row;
 
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*forw_hdr;
diff --git a/net/dccp/minisocks.c b/net/dccp/minisocks.c
index 91e7a2202697143fddd1e81e2c528ea9bbc4ae4e..64d805b27addea27b3fb0b93fb27514a5ec0ae64 100644
--- a/net/dccp/minisocks.c
+++ b/net/dccp/minisocks.c
@@ -22,6 +22,7 @@
 #include "feat.h"
 
 struct inet_timewait_death_row dccp_death_row = {
+	.tw_refcount = REFCOUNT_INIT(1),
 	.sysctl_max_tw_buckets = NR_FILE * 2,
 	.hashinfo	= &dccp_hashinfo,
 };
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 71808c7a7025c0a3a811b629a7796ad148152a4c..9e0bbd02656013e6e8be5765a7b86fc16e6bf831 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -58,7 +58,9 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
 	inet_twsk_bind_unhash(tw, hashinfo);
 	spin_unlock(&bhead->lock);
 
-	atomic_dec(&tw->tw_dr->tw_count);
+	if (refcount_dec_and_test(&tw->tw_dr->tw_refcount))
+		kfree(tw->tw_dr);
+
 	inet_twsk_put(tw);
 }
 
@@ -157,7 +159,7 @@ struct inet_timewait_sock *inet_twsk_alloc(const struct sock *sk,
 {
 	struct inet_timewait_sock *tw;
 
-	if (atomic_read(&dr->tw_count) >= dr->sysctl_max_tw_buckets)
+	if (refcount_read(&dr->tw_refcount) - 1 >= dr->sysctl_max_tw_buckets)
 		return NULL;
 
 	tw = kmem_cache_alloc(sk->sk_prot_creator->twsk_prot->twsk_slab,
@@ -249,7 +251,7 @@ void __inet_twsk_schedule(struct inet_timewait_sock *tw, int timeo, bool rearm)
 		__NET_INC_STATS(twsk_net(tw), kill ? LINUX_MIB_TIMEWAITKILLED :
 						     LINUX_MIB_TIMEWAITED);
 		BUG_ON(mod_timer(&tw->tw_timer, jiffies + timeo));
-		atomic_inc(&tw->tw_dr->tw_count);
+		refcount_inc(&tw->tw_dr->tw_refcount);
 	} else {
 		mod_timer_pending(&tw->tw_timer, jiffies + timeo);
 	}
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index f30273afb5399ddf0122e46e36da2ddae720a1c3..28836071f0a691dc23952f0273a7faf61b1ebb2c 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -59,8 +59,8 @@ static int sockstat_seq_show(struct seq_file *seq, void *v)
 	socket_seq_show(seq);
 	seq_printf(seq, "TCP: inuse %d orphan %d tw %d alloc %d mem %ld\n",
 		   sock_prot_inuse_get(net, &tcp_prot), orphans,
-		   atomic_read(&net->ipv4.tcp_death_row.tw_count), sockets,
-		   proto_memory_allocated(&tcp_prot));
+		   refcount_read(&net->ipv4.tcp_death_row->tw_refcount) - 1,
+		   sockets, proto_memory_allocated(&tcp_prot));
 	seq_printf(seq, "UDP: inuse %d mem %ld\n",
 		   sock_prot_inuse_get(net, &udp_prot),
 		   proto_memory_allocated(&udp_prot));
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 97eb54774924471ab71ea65e6240ed01a9785232..1cae27b5dcd836f1c5ae1ba1b0d4bae5899b3e6f 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -589,6 +589,14 @@ static struct ctl_table ipv4_table[] = {
 };
 
 static struct ctl_table ipv4_net_table[] = {
+	/* tcp_max_tw_buckets must be first in this table. */
+	{
+		.procname	= "tcp_max_tw_buckets",
+/*		.data		= &init_net.ipv4.tcp_death_row.sysctl_max_tw_buckets, */
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
 	{
 		.procname	= "icmp_echo_ignore_all",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_ignore_all,
@@ -1000,13 +1008,6 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
-	{
-		.procname	= "tcp_max_tw_buckets",
-		.data		= &init_net.ipv4.tcp_death_row.sysctl_max_tw_buckets,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec
-	},
 	{
 		.procname	= "tcp_max_syn_backlog",
 		.data		= &init_net.ipv4.sysctl_max_syn_backlog,
@@ -1400,7 +1401,8 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
 		if (!table)
 			goto err_alloc;
 
-		for (i = 0; i < ARRAY_SIZE(ipv4_net_table) - 1; i++) {
+		/* skip first entry (sysctl_max_tw_buckets) */
+		for (i = 1; i < ARRAY_SIZE(ipv4_net_table) - 1; i++) {
 			if (table[i].data) {
 				/* Update the variables to point into
 				 * the current struct net
@@ -1415,6 +1417,8 @@ static __net_init int ipv4_sysctl_init_net(struct net *net)
 		}
 	}
 
+	table[0].data = &net->ipv4.tcp_death_row->sysctl_max_tw_buckets;
+
 	net->ipv4.ipv4_hdr = register_net_sysctl(net, "net/ipv4", table);
 	if (!net->ipv4.ipv4_hdr)
 		goto err_reg;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a7d83ceea42076e89862619f4b0cd7ae9277e7de..00cd6ccf3ab480cfb6f1ea3ab7c4c3df70c39a19 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -208,7 +208,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	struct rtable *rt;
 	int err;
 	struct ip_options_rcu *inet_opt;
-	struct inet_timewait_death_row *tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
+	struct inet_timewait_death_row *tcp_death_row = sock_net(sk)->ipv4.tcp_death_row;
 
 	if (addr_len < sizeof(struct sockaddr_in))
 		return -EINVAL;
@@ -3117,9 +3117,13 @@ EXPORT_SYMBOL(tcp_prot);
 
 static void __net_exit tcp_sk_exit(struct net *net)
 {
+	struct inet_timewait_death_row *tcp_death_row = net->ipv4.tcp_death_row;
+
 	if (net->ipv4.tcp_congestion_control)
 		bpf_module_put(net->ipv4.tcp_congestion_control,
 			       net->ipv4.tcp_congestion_control->owner);
+	if (refcount_dec_and_test(&tcp_death_row->tw_refcount))
+		kfree(tcp_death_row);
 }
 
 static int __net_init tcp_sk_init(struct net *net)
@@ -3151,9 +3155,13 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_tw_reuse = 2;
 	net->ipv4.sysctl_tcp_no_ssthresh_metrics_save = 1;
 
+	net->ipv4.tcp_death_row = kzalloc(sizeof(struct inet_timewait_death_row), GFP_KERNEL);
+	if (!net->ipv4.tcp_death_row)
+		return -ENOMEM;
+	refcount_set(&net->ipv4.tcp_death_row->tw_refcount, 1);
 	cnt = tcp_hashinfo.ehash_mask + 1;
-	net->ipv4.tcp_death_row.sysctl_max_tw_buckets = cnt / 2;
-	net->ipv4.tcp_death_row.hashinfo = &tcp_hashinfo;
+	net->ipv4.tcp_death_row->sysctl_max_tw_buckets = cnt / 2;
+	net->ipv4.tcp_death_row->hashinfo = &tcp_hashinfo;
 
 	net->ipv4.sysctl_max_syn_backlog = max(128, cnt / 128);
 	net->ipv4.sysctl_tcp_sack = 1;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 7c2d3ac2363acebcfd92d7a4886c052c8aa120b9..3977257f80d9963c84a117d4d65d426f1952449f 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -248,7 +248,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	const struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_timewait_sock *tw;
-	struct inet_timewait_death_row *tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
+	struct inet_timewait_death_row *tcp_death_row = sock_net(sk)->ipv4.tcp_death_row;
 
 	tw = inet_twsk_alloc(sk, tcp_death_row, state);
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 1e55ee98dfedac67a591a8a04ce98f334a4b8b7c..0c648bf07f395d5e1ec0917d32fe55a46e853912 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -148,6 +148,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	struct sockaddr_in6 *usin = (struct sockaddr_in6 *) uaddr;
 	struct inet_sock *inet = inet_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct inet_timewait_death_row *tcp_death_row;
 	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct in6_addr *saddr = NULL, *final_p, final;
@@ -156,7 +157,6 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	struct dst_entry *dst;
 	int addr_type;
 	int err;
-	struct inet_timewait_death_row *tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
 
 	if (addr_len < SIN6_LEN_RFC2133)
 		return -EINVAL;
@@ -308,6 +308,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	inet->inet_dport = usin->sin6_port;
 
 	tcp_set_state(sk, TCP_SYN_SENT);
+	tcp_death_row = sock_net(sk)->ipv4.tcp_death_row;
 	err = inet6_hash_connect(tcp_death_row, sk);
 	if (err)
 		goto late_failure;
-- 
2.35.0.rc0.227.g00780c9af4-goog

