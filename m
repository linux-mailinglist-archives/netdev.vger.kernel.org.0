Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A87250FE7
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 05:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgHYDVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 23:21:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34686 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728039AbgHYDVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 23:21:48 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 819D2C7853B8487B524F;
        Tue, 25 Aug 2020 11:21:45 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Tue, 25 Aug 2020
 11:21:37 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH v2] net: gain ipv4 mtu when mtu is not locked
Date:   Mon, 24 Aug 2020 23:20:28 -0400
Message-ID: <20200825032028.50760-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mtu is locked, we should not obtain ipv4 mtu as we return immediately
in this case and leave acquired ipv4 mtu unused.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 8ca6bcab7b03..18c8baf32de5 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1013,13 +1013,14 @@ out:	kfree_skb(skb);
 static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 {
 	struct dst_entry *dst = &rt->dst;
-	u32 old_mtu = ipv4_mtu(dst);
 	struct fib_result res;
 	bool lock = false;
+	u32 old_mtu;
 
 	if (ip_mtu_locked(dst))
 		return;
 
+	old_mtu = ipv4_mtu(dst);
 	if (old_mtu < mtu)
 		return;
 
-- 
2.19.1

