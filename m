Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2712ACA18
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730140AbgKJBLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:11:11 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7472 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKJBLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 20:11:10 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CVVDR70Hwzhjr5;
        Tue, 10 Nov 2020 09:11:03 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Tue, 10 Nov 2020
 09:10:58 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <0x7f454c46@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <zhangxiaoxu5@huawei.com>
Subject: [PATCH] net: xfrm: fix memory leak in xfrm_user_policy()
Date:   Tue, 10 Nov 2020 09:14:43 +0800
Message-ID: <20201110011443.2482437-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if xfrm_get_translator() failed, xfrm_user_policy() return without
freeing 'data', which is allocated in memdup_sockptr().

Fixes: 96392ee5a13b ("xfrm/compat: Translate 32-bit user_policy from sockptr")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 net/xfrm/xfrm_state.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index a77da7aae6fe..2f1517827995 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2382,8 +2382,10 @@ int xfrm_user_policy(struct sock *sk, int optname, sockptr_t optval, int optlen)
 	if (in_compat_syscall()) {
 		struct xfrm_translator *xtr = xfrm_get_translator();
 
-		if (!xtr)
+		if (!xtr) {
+			kfree(data);
 			return -EOPNOTSUPP;
+		}
 
 		err = xtr->xlate_user_policy_sockptr(&data, optlen);
 		xfrm_put_translator(xtr);
-- 
2.25.4

