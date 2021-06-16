Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9643A9612
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhFPJ3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:29:39 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4808 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbhFPJ3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:29:36 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4fpp1CSzzXg1n;
        Wed, 16 Jun 2021 17:22:26 +0800 (CST)
Received: from dggpemm500021.china.huawei.com (7.185.36.109) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:27:24 +0800
Received: from huawei.com (10.175.113.32) by dggpemm500021.china.huawei.com
 (7.185.36.109) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 16 Jun
 2021 17:27:23 +0800
From:   Chengyang Fan <cy.fan@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cy.fan@huawei.com>
Subject: [PATCH] net: ipv4: fix memory leak in ip_mc_add1_src
Date:   Wed, 16 Jun 2021 17:59:25 +0800
Message-ID: <20210616095925.1571600-1-cy.fan@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500021.china.huawei.com (7.185.36.109)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BUG: memory leak
unreferenced object 0xffff888101bc4c00 (size 32):
  comm "syz-executor527", pid 360, jiffies 4294807421 (age 19.329s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
    01 00 00 00 00 00 00 00 ac 14 14 bb 00 00 02 00 ................
  backtrace:
    [<00000000f17c5244>] kmalloc include/linux/slab.h:558 [inline]
    [<00000000f17c5244>] kzalloc include/linux/slab.h:688 [inline]
    [<00000000f17c5244>] ip_mc_add1_src net/ipv4/igmp.c:1971 [inline]
    [<00000000f17c5244>] ip_mc_add_src+0x95f/0xdb0 net/ipv4/igmp.c:2095
    [<000000001cb99709>] ip_mc_source+0x84c/0xea0 net/ipv4/igmp.c:2416
    [<0000000052cf19ed>] do_ip_setsockopt net/ipv4/ip_sockglue.c:1294 [inline]
    [<0000000052cf19ed>] ip_setsockopt+0x114b/0x30c0 net/ipv4/ip_sockglue.c:1423
    [<00000000477edfbc>] raw_setsockopt+0x13d/0x170 net/ipv4/raw.c:857
    [<00000000e75ca9bb>] __sys_setsockopt+0x158/0x270 net/socket.c:2117
    [<00000000bdb993a8>] __do_sys_setsockopt net/socket.c:2128 [inline]
    [<00000000bdb993a8>] __se_sys_setsockopt net/socket.c:2125 [inline]
    [<00000000bdb993a8>] __x64_sys_setsockopt+0xba/0x150 net/socket.c:2125
    [<000000006a1ffdbd>] do_syscall_64+0x40/0x80 arch/x86/entry/common.c:47
    [<00000000b11467c4>] entry_SYSCALL_64_after_hwframe+0x44/0xae

In commit 24803f38a5c0 ("igmp: do not remove igmp souce list info when set
link down"), the ip_mc_clear_src() in ip_mc_destroy_dev() was removed,
because it was also called in igmpv3_clear_delrec().

Rough callgraph:

inetdev_destroy
-> ip_mc_destroy_dev
     -> igmpv3_clear_delrec
        -> ip_mc_clear_src
-> RCU_INIT_POINTER(dev->ip_ptr, NULL)

However, ip_mc_clear_src() called in igmpv3_clear_delrec() doesn't
release in_dev->mc_list->sources. And RCU_INIT_POINTER() assigns the
NULL to dev->ip_ptr. As a result, in_dev cannot be obtained through
inetdev_by_index() and then in_dev->mc_list->sources cannot be released
by ip_mc_del1_src() in the sock_close. Rough call sequence goes like:

sock_close
-> __sock_release
   -> inet_release
      -> ip_mc_drop_socket
         -> inetdev_by_index
         -> ip_mc_leave_src
            -> ip_mc_del_src
               -> ip_mc_del1_src

So we still need to call ip_mc_clear_src() in ip_mc_destroy_dev() to free
in_dev->mc_list->sources.

Fixes: 24803f38a5c0 ("igmp: do not remove igmp souce list info ...")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chengyang Fan <cy.fan@huawei.com>
---
 net/ipv4/igmp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7b272bbed2b4..6b3c558a4f23 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1801,6 +1801,7 @@ void ip_mc_destroy_dev(struct in_device *in_dev)
 	while ((i = rtnl_dereference(in_dev->mc_list)) != NULL) {
 		in_dev->mc_list = i->next_rcu;
 		in_dev->mc_count--;
+		ip_mc_clear_src(i);
 		ip_ma_put(i);
 	}
 }
-- 
2.18.0.huawei.25

