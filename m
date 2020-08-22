Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265EF24E62C
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 09:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgHVHw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 03:52:27 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57878 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727103AbgHVHw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 03:52:26 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EAC197C982E4271AA703;
        Sat, 22 Aug 2020 15:52:24 +0800 (CST)
Received: from huawei.com (10.179.179.12) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Sat, 22 Aug 2020
 15:52:17 +0800
From:   guodeqing <geffrey.guo@huawei.com>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <dsahern@gmail.com>, <netdev@vger.kernel.org>,
        <geffrey.guo@huawei.com>
Subject: [PATCH] ipv4: fix the problem of ping failure in some cases
Date:   Sat, 22 Aug 2020 15:46:37 +0800
Message-ID: <1598082397-115790-1-git-send-email-geffrey.guo@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.179.179.12]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ie.,
$ ifconfig eth0 9.9.9.9 netmask 255.255.255.0

$ ping -I lo 9.9.9.9
ping: Warning: source address might be selected on device other than lo.
PING 9.9.9.9 (9.9.9.9) from 9.9.9.9 lo: 56(84) bytes of data.

4 packets transmitted, 0 received, 100% packet loss, time 3068ms

This is because the return value of __raw_v4_lookup in raw_v4_input
is null, the packets cannot be sent to the ping application.
The reason of the __raw_v4_lookup failure is that sk_bound_dev_if and
dif/sdif are not equal in raw_sk_bound_dev_eq.

Here I add a check of whether the sk_bound_dev_if is LOOPBACK_IFINDEX
to solve this problem.

Fixes: 19e4e768064a8 ("ipv4: Fix raw socket lookup for local traffic")
Signed-off-by: guodeqing <geffrey.guo@huawei.com>
---
 include/net/inet_sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index a3702d1..7707b1d 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -144,7 +144,7 @@ static inline bool inet_bound_dev_eq(bool l3mdev_accept, int bound_dev_if,
 {
 	if (!bound_dev_if)
 		return !sdif || l3mdev_accept;
-	return bound_dev_if == dif || bound_dev_if == sdif;
+	return bound_dev_if == dif || bound_dev_if == sdif || bound_dev_if == LOOPBACK_IFINDEX;
 }
 
 struct inet_cork {
-- 
2.7.4

