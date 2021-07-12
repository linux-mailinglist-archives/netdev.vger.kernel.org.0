Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924503C5D7C
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhGLNm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:42:57 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:11266 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhGLNm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:42:56 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GNl9f4df4z1CGb7;
        Mon, 12 Jul 2021 21:34:30 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 21:40:05 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 12
 Jul 2021 21:40:04 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <0x7f454c46@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] xfrm/compat: Fix general protection fault in xfrm_user_rcv_msg_compat()
Date:   Mon, 12 Jul 2021 21:40:02 +0800
Message-ID: <20210712134002.34048-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In xfrm_user_rcv_msg_compat() if maxtype is not zero and less than
XFRMA_MAX, nlmsg_parse_deprecated() do not initialize attrs array fully.
xfrm_xlate32() will access uninit 'attrs[i]' while iterating all attrs
array.

KASAN: probably user-memory-access in range [0x0000000041b58ab0-0x0000000041b58ab7]
CPU: 0 PID: 15799 Comm: syz-executor.2 Tainted: G        W         5.14.0-rc1-syzkaller #0
RIP: 0010:nla_type include/net/netlink.h:1130 [inline]
RIP: 0010:xfrm_xlate32_attr net/xfrm/xfrm_compat.c:410 [inline]
RIP: 0010:xfrm_xlate32 net/xfrm/xfrm_compat.c:532 [inline]
RIP: 0010:xfrm_user_rcv_msg_compat+0x5e5/0x1070 net/xfrm/xfrm_compat.c:577
[...]
Call Trace:
 xfrm_user_rcv_msg+0x556/0x8b0 net/xfrm/xfrm_user.c:2774
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2824
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:702 [inline]

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/xfrm/xfrm_compat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index a20aec9d7393..4738660cadea 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -559,8 +559,8 @@ static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
 	    (h32->nlmsg_flags & NLM_F_DUMP))
 		return NULL;
 
-	err = nlmsg_parse_deprecated(h32, compat_msg_min[type], attrs,
-			maxtype ? : XFRMA_MAX, policy ? : compat_policy, extack);
+	err = nlmsg_parse_deprecated(h32, compat_msg_min[type], attrs, XFRMA_MAX,
+				     policy ? : compat_policy, extack);
 	if (err < 0)
 		return ERR_PTR(err);
 
-- 
2.20.1

