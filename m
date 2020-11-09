Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6E52ABE34
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbgKIOGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:06:13 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7197 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729854AbgKIOGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 09:06:12 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CVCT31l2VzkgpG;
        Mon,  9 Nov 2020 22:05:59 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Mon, 9 Nov 2020
 22:06:06 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jmaloy@redhat.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <tipc-discussion@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] tipc: fix memory leak in tipc_topsrv_start()
Date:   Mon, 9 Nov 2020 22:09:13 +0800
Message-ID: <20201109140913.47370-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemleak report a memory leak as follows:

unreferenced object 0xffff88810a596800 (size 512):
  comm "ip", pid 21558, jiffies 4297568990 (age 112.120s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 00 83 60 b0 ff ff ff ff  ..........`.....
  backtrace:
    [<0000000022bbe21f>] tipc_topsrv_init_net+0x1f3/0xa70
    [<00000000fe15ddf7>] ops_init+0xa8/0x3c0
    [<00000000138af6f2>] setup_net+0x2de/0x7e0
    [<000000008c6807a3>] copy_net_ns+0x27d/0x530
    [<000000006b21adbd>] create_new_namespaces+0x382/0xa30
    [<00000000bb169746>] unshare_nsproxy_namespaces+0xa1/0x1d0
    [<00000000fe2e42bc>] ksys_unshare+0x39c/0x780
    [<0000000009ba3b19>] __x64_sys_unshare+0x2d/0x40
    [<00000000614ad866>] do_syscall_64+0x56/0xa0
    [<00000000a1b5ca3c>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

'srv' is malloced in tipc_topsrv_start() but not free before
leaving from the error handling cases. We need to free it.

Fixes: 5c45ab24ac77 ("tipc: make struct tipc_server private for server.c")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/tipc/topsrv.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 5f6f86051c83..13f3143609f9 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -664,12 +664,18 @@ static int tipc_topsrv_start(struct net *net)
 
 	ret = tipc_topsrv_work_start(srv);
 	if (ret < 0)
-		return ret;
+		goto err_start;
 
 	ret = tipc_topsrv_create_listener(srv);
 	if (ret < 0)
-		tipc_topsrv_work_stop(srv);
+		goto err_create;
 
+	return 0;
+
+err_create:
+	tipc_topsrv_work_stop(srv);
+err_start:
+	kfree(srv);
 	return ret;
 }
 
-- 
2.17.1

