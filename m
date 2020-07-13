Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B0121DAFB
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 17:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbgGMP7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 11:59:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34232 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729027AbgGMP7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 11:59:23 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5DC39D54C4F417C8F8CB;
        Mon, 13 Jul 2020 23:56:14 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 13 Jul 2020 23:56:04 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <hulkci@huawei.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>
Subject: [PATCH] ip6_gre: fix null-ptr-deref in ip6gre_init_net()
Date:   Mon, 13 Jul 2020 23:59:50 +0800
Message-ID: <20200713155950.71793-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KASAN report null-ptr-deref error when register_netdev() failed:

KASAN: null-ptr-deref in range [0x00000000000003c0-0x00000000000003c7]
CPU: 2 PID: 422 Comm: ip Not tainted 5.8.0-rc4+ #12
Call Trace:
 ip6gre_init_net+0x4ab/0x580
 ? ip6gre_tunnel_uninit+0x3f0/0x3f0
 ops_init+0xa8/0x3c0
 setup_net+0x2de/0x7e0
 ? rcu_read_lock_bh_held+0xb0/0xb0
 ? ops_init+0x3c0/0x3c0
 ? kasan_unpoison_shadow+0x33/0x40
 ? __kasan_kmalloc.constprop.0+0xc2/0xd0
 copy_net_ns+0x27d/0x530
 create_new_namespaces+0x382/0xa30
 unshare_nsproxy_namespaces+0xa1/0x1d0
 ksys_unshare+0x39c/0x780
 ? walk_process_tree+0x2a0/0x2a0
 ? trace_hardirqs_on+0x4a/0x1b0
 ? _raw_spin_unlock_irq+0x1f/0x30
 ? syscall_trace_enter+0x1a7/0x330
 ? do_syscall_64+0x1c/0xa0
 __x64_sys_unshare+0x2d/0x40
 do_syscall_64+0x56/0xa0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

ip6gre_tunnel_uninit() has set 'ign->fb_tunnel_dev' to NULL, later
access to ign->fb_tunnel_dev cause null-ptr-deref. Fix it by saving
'ign->fb_tunnel_dev' to local variable ndev.

Fixes: dafabb6590cb ("ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 6532bde82b40..3a57fb9ce049 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1562,17 +1562,18 @@ static void ip6gre_destroy_tunnels(struct net *net, struct list_head *head)
 static int __net_init ip6gre_init_net(struct net *net)
 {
 	struct ip6gre_net *ign = net_generic(net, ip6gre_net_id);
+	struct net_device *ndev;
 	int err;
 
 	if (!net_has_fallback_tunnels(net))
 		return 0;
-	ign->fb_tunnel_dev = alloc_netdev(sizeof(struct ip6_tnl), "ip6gre0",
-					  NET_NAME_UNKNOWN,
-					  ip6gre_tunnel_setup);
-	if (!ign->fb_tunnel_dev) {
+	ndev = alloc_netdev(sizeof(struct ip6_tnl), "ip6gre0",
+			    NET_NAME_UNKNOWN, ip6gre_tunnel_setup);
+	if (!ndev) {
 		err = -ENOMEM;
 		goto err_alloc_dev;
 	}
+	ign->fb_tunnel_dev = ndev;
 	dev_net_set(ign->fb_tunnel_dev, net);
 	/* FB netdevice is special: we have one, and only one per netns.
 	 * Allowing to move it to another netns is clearly unsafe.
@@ -1592,7 +1593,7 @@ static int __net_init ip6gre_init_net(struct net *net)
 	return 0;
 
 err_reg_dev:
-	free_netdev(ign->fb_tunnel_dev);
+	free_netdev(ndev);
 err_alloc_dev:
 	return err;
 }
-- 
2.25.1

