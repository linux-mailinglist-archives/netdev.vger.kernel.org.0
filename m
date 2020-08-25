Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E734251851
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 14:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbgHYMMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 08:12:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:10263 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730181AbgHYML4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 08:11:56 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 73DCBBFAFAAE71C95194;
        Tue, 25 Aug 2020 20:11:53 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Tue, 25 Aug 2020
 20:11:45 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: Remove duplicated midx check against 0
Date:   Tue, 25 Aug 2020 08:10:37 -0400
Message-ID: <20200825121037.10061-1-linmiaohe@huawei.com>
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

Check midx against 0 is always equal to check midx against sk_bound_dev_if
when sk_bound_dev_if is known not equal to 0 in these case.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/ip_sockglue.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index d2c223554ff7..ec6036713e2c 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1124,8 +1124,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 		dev_put(dev);
 
 		err = -EINVAL;
-		if (sk->sk_bound_dev_if &&
-		    (!midx || midx != sk->sk_bound_dev_if))
+		if (sk->sk_bound_dev_if && midx != sk->sk_bound_dev_if)
 			break;
 
 		inet->uc_index = ifindex;
@@ -1189,7 +1188,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 		err = -EINVAL;
 		if (sk->sk_bound_dev_if &&
 		    mreq.imr_ifindex != sk->sk_bound_dev_if &&
-		    (!midx || midx != sk->sk_bound_dev_if))
+		    midx != sk->sk_bound_dev_if)
 			break;
 
 		inet->mc_index = mreq.imr_ifindex;
-- 
2.19.1

