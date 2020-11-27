Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3E12C6BD2
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 20:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbgK0TFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 14:05:55 -0500
Received: from correo.us.es ([193.147.175.20]:53146 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729796AbgK0TD3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 14:03:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6CF1FBAEE5
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 20:03:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BD8ADA8F4
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 20:03:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 511E2DA73D; Fri, 27 Nov 2020 20:03:25 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BBA53DA704;
        Fri, 27 Nov 2020 20:03:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 27 Nov 2020 20:03:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 8FAF84265A5A;
        Fri, 27 Nov 2020 20:03:22 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/5] ipvs: fix possible memory leak in ip_vs_control_net_init
Date:   Fri, 27 Nov 2020 20:03:11 +0100
Message-Id: <20201127190313.24947-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201127190313.24947-1-pablo@netfilter.org>
References: <20201127190313.24947-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

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
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.20.1

