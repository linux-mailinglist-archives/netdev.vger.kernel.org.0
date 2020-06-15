Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C9E1F8C18
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 03:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgFOBbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 21:31:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5885 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727946AbgFOBbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 21:31:47 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E0DDAEABD68F208B8A26;
        Mon, 15 Jun 2020 09:31:42 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 15 Jun 2020 09:31:33 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Peter Krystad <peter.krystad@linux.intel.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <mptcp@lists.01.org>
Subject: [PATCH net v2] mptcp: fix memory leak in mptcp_subflow_create_socket()
Date:   Mon, 15 Jun 2020 09:35:22 +0800
Message-ID: <20200615013522.96854-1-weiyongjun1@huawei.com>
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

socket malloced  by sock_create_kern() should be release before return
in the error handling, otherwise it cause memory leak.

unreferenced object 0xffff88810910c000 (size 1216):
  comm "00000003_test_m", pid 12238, jiffies 4295050289 (age 54.237s)
  hex dump (first 32 bytes):
    01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 2f 30 0a 81 88 ff ff  ........./0.....
  backtrace:
    [<00000000e877f89f>] sock_alloc_inode+0x18/0x1c0
    [<0000000093d1dd51>] alloc_inode+0x63/0x1d0
    [<000000005673fec6>] new_inode_pseudo+0x14/0xe0
    [<00000000b5db6be8>] sock_alloc+0x3c/0x260
    [<00000000e7e3cbb2>] __sock_create+0x89/0x620
    [<0000000023e48593>] mptcp_subflow_create_socket+0xc0/0x5e0
    [<00000000419795e4>] __mptcp_socket_create+0x1ad/0x3f0
    [<00000000b2f942e8>] mptcp_stream_connect+0x281/0x4f0
    [<00000000c80cd5cc>] __sys_connect_file+0x14d/0x190
    [<00000000dc761f11>] __sys_connect+0x128/0x160
    [<000000008b14e764>] __x64_sys_connect+0x6f/0xb0
    [<000000007b4f93bd>] do_syscall_64+0xa1/0x530
    [<00000000d3e770b6>] entry_SYSCALL_64_after_hwframe+0x49/0xb3

Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
v1 -> v2: add net prefix to subject line
---
 net/mptcp/subflow.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bf132575040d..bbdb74b8bc3c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1053,8 +1053,10 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	err = tcp_set_ulp(sf->sk, "mptcp");
 	release_sock(sf->sk);
 
-	if (err)
+	if (err) {
+		sock_release(sf);
 		return err;
+	}
 
 	/* the newly created socket really belongs to the owning MPTCP master
 	 * socket, even if for additional subflows the allocation is performed
-- 
2.25.1

