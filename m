Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06D12B9042
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 11:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgKSKiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 05:38:16 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7936 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgKSKiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 05:38:15 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CcGNN4TCpz6wHs;
        Thu, 19 Nov 2020 18:37:56 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 19 Nov 2020
 18:38:10 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <horms@verge.net.au>, <ja@ssi.bg>, <pablo@netfilter.org>,
        <kadlec@netfilter.org>, <fw@strlen.de>, <davem@davemloft.net>,
        <kuba@kernel.org>, <christian@brauner.io>,
        <hans.schillstrom@ericsson.com>
CC:     <lvs-devel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] ipvs: fix possible memory leak in ip_vs_control_net_init
Date:   Thu, 19 Nov 2020 18:41:02 +0800
Message-ID: <20201119104102.67427-1-wanghai38@huawei.com>
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
comm "syz-executor.3", pid 6484, jiffies 4297476946 (age 48.546s)
hex dump (first 32 bytes):
00 00 00 00 01 00 00 00 08 a0 9e 75 80 88 ff ff ...........u....
08 a0 9e 75 80 88 ff ff 00 00 00 00 ad 4e ad de ...u.........N..
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

Fixes: b17fc9963f83 ("IPVS: netns, ip_vs_stats and its procfs")
Fixes: 61b1ab4583e2 ("IPVS: netns, add basic init per netns.")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index e279ded4e306..d99bb89e7c25 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4180,6 +4180,9 @@ int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
 	return 0;
 
 err:
+	remove_proc_entry("ip_vs_stats_percpu", ipvs->net->proc_net);
+	remove_proc_entry("ip_vs_stats", ipvs->net->proc_net);
+	remove_proc_entry("ip_vs", ipvs->net->proc_net);
 	free_percpu(ipvs->tot_stats.cpustats);
 	return -ENOMEM;
 }
-- 
2.17.1

