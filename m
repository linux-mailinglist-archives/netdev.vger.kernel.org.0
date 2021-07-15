Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73783C9E7A
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 14:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbhGOMSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 08:18:31 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:11283 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhGOMSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 08:18:30 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GQY8g5rNnz1CKCD;
        Thu, 15 Jul 2021 20:09:55 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 15 Jul 2021 20:15:34 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <sjur.brandeland@stericsson.com>
Subject: [PATCH net-next] net: fix uninit-value in caif_seqpkt_sendmsg
Date:   Thu, 15 Jul 2021 20:22:04 +0800
Message-ID: <20210715122204.14043-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When nr_segs equal to zero in iovec_from_user, the object
msg->msg_iter.iov is uninit stack memory in caif_seqpkt_sendmsg
which is defined in ___sys_sendmsg. So we cann't just judge
msg->msg_iter.iov->base directlly. We can use nr_segs to judge
msg in caif_seqpkt_sendmsg whether has data buffers.

=====================================================
BUG: KMSAN: uninit-value in caif_seqpkt_sendmsg+0x693/0xf60 net/caif/caif_socket.c:542
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 caif_seqpkt_sendmsg+0x693/0xf60 net/caif/caif_socket.c:542
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2343
 ___sys_sendmsg net/socket.c:2397 [inline]
 __sys_sendmmsg+0x808/0xc90 net/socket.c:2480
 __compat_sys_sendmmsg net/compat.c:656 [inline]

Reported-by: syzbot+09a5d591c1f98cf5efcb@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=1ace85e8fc9b0d5a45c08c2656c3e91762daa9b8
Fixes: bece7b2398d0 ("caif: Rewritten socket implementation")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/caif/caif_socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 647554c..e12fd3c 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -539,7 +539,8 @@ static int caif_seqpkt_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto err;
 
 	ret = -EINVAL;
-	if (unlikely(msg->msg_iter.iov->iov_base == NULL))
+	if (unlikely(msg->msg_iter.nr_segs == 0) ||
+	    unlikely(msg->msg_iter.iov->iov_base == NULL))
 		goto err;
 	noblock = msg->msg_flags & MSG_DONTWAIT;
 
-- 
2.9.5

