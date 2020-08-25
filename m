Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04A22517F6
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbgHYLmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:42:10 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56174 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729882AbgHYLmH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 07:42:07 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BEE726C774DC068FFEC6;
        Tue, 25 Aug 2020 19:42:05 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 25 Aug 2020
 19:41:57 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Avoid unnecessary inet_addr_type() call when addr is INADDR_ANY
Date:   Tue, 25 Aug 2020 07:40:48 -0400
Message-ID: <20200825114048.24515-1-linmiaohe@huawei.com>
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

We can avoid unnecessary inet_addr_type() call by check addr against
INADDR_ANY first.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/ping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index cc09d1135ce2..19a947bf0faa 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -310,10 +310,10 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 		pr_debug("ping_check_bind_addr(sk=%p,addr=%pI4,port=%d)\n",
 			 sk, &addr->sin_addr.s_addr, ntohs(addr->sin_port));
 
-		chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
-
 		if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
 			chk_addr_ret = RTN_LOCAL;
+		else
+			chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
 
 		if ((!inet_can_nonlocal_bind(net, isk) &&
 		     chk_addr_ret != RTN_LOCAL) ||
-- 
2.19.1

