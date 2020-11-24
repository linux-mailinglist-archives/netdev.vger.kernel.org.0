Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A852C1F63
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 09:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgKXIFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 03:05:12 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7670 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730363AbgKXIFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 03:05:12 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CgGlM088Fz15QpZ;
        Tue, 24 Nov 2020 16:04:47 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Tue, 24 Nov 2020
 16:05:04 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <ja@ssi.bg>
CC:     <horms@verge.net.au>, <pablo@netfilter.org>,
        <kadlec@netfilter.org>, <fw@strlen.de>, <davem@davemloft.net>,
        <kuba@kernel.org>, <christian@brauner.io>,
        <hans.schillstrom@ericsson.com>, <lvs-devel@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net v3] ipvs: fix possible memory leak in ip_vs_control_net_init
Date:   Tue, 24 Nov 2020 16:07:49 +0800
Message-ID: <20201124080749.69160-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak report a memory leak as follows:

BUG: memory leak
unreferenced object 0xffff8880759ea000 (size 256):
backtrace:
[<00000000c0bf2deb>] kmem_cache_zalloc include/linux/slab.h:656 [inline]
[<00000000c0bf2deb>] __proc_create+0x23d/0x7d0 fs/proc/generic.c:421
[<000000009d718d02>] proc_create_reg+0x8e/0x140 fs/proc/generic.c:535
[<0000000097bbfc4f>] proc_create_net_data+0x8c/0x1b0 fs/proc/proc_net.c:126
[<00000000652480fc>] ip_vs_control_net_init+0x308/0x13a0 net/netfilter/ipvs/ip_vs_ctl.c:4169
[<000000004c927ebe>] __ip_vs_init+0x211/0x400 net/netfilter/ipvs/ip_vs_core.c:2429
[<00000000aa6b72d9>] ops_init+0xa8/0x3c0 net/core/net_namespace.c:151
[<00000000153fd114>] setup_net+0x2de/0x7e0 net/core/net_namespace.c:341
[<00000000be4e4f07>] copy_net_ns+0x27d/0x530 net/core/net_namespace.c:482
[<00000000f1c23ec9>] create_new_namespaces+0x382/0xa30 kernel/nsproxy.c:110
[<00000000098a5757>] copy_namespaces+0x2e6/0x3b0 kernel/nsproxy.c:179
[<0000000026ce39e9>] copy_process+0x220a/0x5f00 kernel/fork.c:2072
[<00000000b71f4efe>] _do_fork+0xc7/0xda0 kernel/fork.c:2428
[<000000002974ee96>] __do_sys_clone3+0x18a/0x280 kernel/fork.c:2703
[<0000000062ac0a4d>] do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
[<0000000093f1ce2c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

In the error path of ip_vs_control_net_init(), remove_proc_entry() needs
to be called to remove the added proc entry, otherwise a memory leak
will occur.

Also, add some '#ifdef CONFIG_PROC_FS' because proc_create_net* return NULL
when PROC is not used.

Fixes: b17fc9963f83 ("IPVS: netns, ip_vs_stats and its procfs")
Fixes: 61b1ab4583e2 ("IPVS: netns, add basic init per netns.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
v2->v3: improve code format
v1->v2: add some '#ifdef CONFIG_PROC_FS' and check the return value of proc_create_net*
 net/netfilter/ipvs/ip_vs_ctl.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index e279ded4e306..d45dbcba8b49 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4167,12 +4167,18 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
 
 	spin_lock_init(&ipvs->tot_stats.lock);
 
-	proc_create_net("ip_vs", 0, ipvs->net->proc_net, &ip_vs_info_seq_ops,
-			sizeof(struct ip_vs_iter));
-	proc_create_net_single("ip_vs_stats", 0, ipvs->net->proc_net,
-			ip_vs_stats_show, NULL);
-	proc_create_net_single("ip_vs_stats_percpu", 0, ipvs->net->proc_net,
-			ip_vs_stats_percpu_show, NULL);
+#ifdef CONFIG_PROC_FS
+	if (!proc_create_net("ip_vs", 0, ipvs->net->proc_net,
+			     &ip_vs_info_seq_ops, sizeof(struct ip_vs_iter)))
+		goto err_vs;
+	if (!proc_create_net_single("ip_vs_stats", 0, ipvs->net->proc_net,
+				    ip_vs_stats_show, NULL))
+		goto err_stats;
+	if (!proc_create_net_single("ip_vs_stats_percpu", 0,
+				    ipvs->net->proc_net,
+				    ip_vs_stats_percpu_show, NULL))
+		goto err_percpu;
+#endif
 
 	if (ip_vs_control_net_init_sysctl(ipvs))
 		goto err;
@@ -4180,6 +4186,17 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
 	return 0;
 
 err:
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("ip_vs_stats_percpu", ipvs->net->proc_net);
+
+err_percpu:
+	remove_proc_entry("ip_vs_stats", ipvs->net->proc_net);
+
+err_stats:
+	remove_proc_entry("ip_vs", ipvs->net->proc_net);
+
+err_vs:
+#endif
 	free_percpu(ipvs->tot_stats.cpustats);
 	return -ENOMEM;
 }
@@ -4188,9 +4205,11 @@ void __net_exit ip_vs_control_net_cleanup(struct netns_ipvs *ipvs)
 {
 	ip_vs_trash_cleanup(ipvs);
 	ip_vs_control_net_cleanup_sysctl(ipvs);
+#ifdef CONFIG_PROC_FS
 	remove_proc_entry("ip_vs_stats_percpu", ipvs->net->proc_net);
 	remove_proc_entry("ip_vs_stats", ipvs->net->proc_net);
 	remove_proc_entry("ip_vs", ipvs->net->proc_net);
+#endif
 	free_percpu(ipvs->tot_stats.cpustats);
 }
 
-- 
2.17.1

