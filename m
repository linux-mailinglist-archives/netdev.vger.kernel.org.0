Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3A85B074B
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 05:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfILDpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 23:45:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2267 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727873AbfILDpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 23:45:05 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D6A97EC9127A2D852B99;
        Thu, 12 Sep 2019 11:45:03 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Thu, 12 Sep 2019 11:44:53 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>
CC:     <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH v2 net 3/3] sctp: destroy bucket if failed to bind addr
Date:   Thu, 12 Sep 2019 12:02:19 +0800
Message-ID: <20190912040219.67517-4-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190912040219.67517-1-maowenan@huawei.com>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
 <20190912040219.67517-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is one memory leak bug report:
BUG: memory leak
unreferenced object 0xffff8881dc4c5ec0 (size 40):
  comm "syz-executor.0", pid 5673, jiffies 4298198457 (age 27.578s)
  hex dump (first 32 bytes):
    02 00 00 00 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    f8 63 3d c1 81 88 ff ff 00 00 00 00 00 00 00 00  .c=.............
  backtrace:
    [<0000000072006339>] sctp_get_port_local+0x2a1/0xa00 [sctp]
    [<00000000c7b379ec>] sctp_do_bind+0x176/0x2c0 [sctp]
    [<000000005be274a2>] sctp_bind+0x5a/0x80 [sctp]
    [<00000000b66b4044>] inet6_bind+0x59/0xd0 [ipv6]
    [<00000000c68c7f42>] __sys_bind+0x120/0x1f0 net/socket.c:1647
    [<000000004513635b>] __do_sys_bind net/socket.c:1658 [inline]
    [<000000004513635b>] __se_sys_bind net/socket.c:1656 [inline]
    [<000000004513635b>] __x64_sys_bind+0x3e/0x50 net/socket.c:1656
    [<0000000061f2501e>] do_syscall_64+0x72/0x2e0 arch/x86/entry/common.c:296
    [<0000000003d1e05e>] entry_SYSCALL_64_after_hwframe+0x49/0xbe

This is because in sctp_do_bind, if sctp_get_port_local is to
create hash bucket successfully, and sctp_add_bind_addr failed
to bind address, e.g return -ENOMEM, so memory leak found, it
needs to destroy allocated bucket.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 net/sctp/socket.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2f810078c91d..69ec3b796197 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -412,11 +412,13 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
 	ret = sctp_add_bind_addr(bp, addr, af->sockaddr_len,
 				 SCTP_ADDR_SRC, GFP_ATOMIC);
 
-	/* Copy back into socket for getsockname() use. */
-	if (!ret) {
-		inet_sk(sk)->inet_sport = htons(inet_sk(sk)->inet_num);
-		sp->pf->to_sk_saddr(addr, sk);
+	if (ret) {
+		sctp_put_port(sk);
+		return ret;
 	}
+	/* Copy back into socket for getsockname() use. */
+	inet_sk(sk)->inet_sport = htons(inet_sk(sk)->inet_num);
+	sp->pf->to_sk_saddr(addr, sk);
 
 	return ret;
 }
-- 
2.20.1

