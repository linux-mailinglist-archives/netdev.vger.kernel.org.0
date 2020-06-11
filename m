Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C661F6313
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 09:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgFKH6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 03:58:34 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5818 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726841AbgFKH6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 03:58:33 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B5FCD816C6078CF54E4E;
        Thu, 11 Jun 2020 15:58:27 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Thu, 11 Jun 2020
 15:58:21 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <liuhangbin@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <wanghai38@huawei.com>
Subject: [PATCH] mld: fix memory leak in ipv6_mc_destroy_dev()
Date:   Thu, 11 Jun 2020 15:57:50 +0800
Message-ID: <20200611075750.18545-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a84d01647989 ("mld: fix memory leak in mld_del_delrec()") fixed
the memory leak of MLD, but missing the ipv6_mc_destroy_dev() path, in
which mca_sources are leaked after ma_put().

Using ip6_mc_clear_src() to take care of the missing free.

BUG: memory leak
unreferenced object 0xffff8881113d3180 (size 64):
  comm "syz-executor071", pid 389, jiffies 4294887985 (age 17.943s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 ff 02 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000002cbc483c>] kmalloc include/linux/slab.h:555 [inline]
    [<000000002cbc483c>] kzalloc include/linux/slab.h:669 [inline]
    [<000000002cbc483c>] ip6_mc_add1_src net/ipv6/mcast.c:2237 [inline]
    [<000000002cbc483c>] ip6_mc_add_src+0x7f5/0xbb0 net/ipv6/mcast.c:2357
    [<0000000058b8b1ff>] ip6_mc_source+0xe0c/0x1530 net/ipv6/mcast.c:449
    [<000000000bfc4fb5>] do_ipv6_setsockopt.isra.12+0x1b2c/0x3b30 net/ipv6/ipv6_sockglue.c:754
    [<00000000e4e7a722>] ipv6_setsockopt+0xda/0x150 net/ipv6/ipv6_sockglue.c:950
    [<0000000029260d9a>] rawv6_setsockopt+0x45/0x100 net/ipv6/raw.c:1081
    [<000000005c1b46f9>] __sys_setsockopt+0x131/0x210 net/socket.c:2132
    [<000000008491f7db>] __do_sys_setsockopt net/socket.c:2148 [inline]
    [<000000008491f7db>] __se_sys_setsockopt net/socket.c:2145 [inline]
    [<000000008491f7db>] __x64_sys_setsockopt+0xba/0x150 net/socket.c:2145
    [<00000000c7bc11c5>] do_syscall_64+0xa1/0x530 arch/x86/entry/common.c:295
    [<000000005fb7a3f3>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

Fixes: 1666d49e1d41 ("mld: do not remove mld souce list info when set link down")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/ipv6/mcast.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 7e12d2114158..8cd2782a31e4 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2615,6 +2615,7 @@ void ipv6_mc_destroy_dev(struct inet6_dev *idev)
 		idev->mc_list = i->next;
 
 		write_unlock_bh(&idev->lock);
+		ip6_mc_clear_src(i);
 		ma_put(i);
 		write_lock_bh(&idev->lock);
 	}
-- 
2.17.1

