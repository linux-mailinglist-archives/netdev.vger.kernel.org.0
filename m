Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AB31F8165
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 08:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgFMGxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 02:53:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5822 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725783AbgFMGxy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 02:53:54 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4B46BACB3D9C8199A159;
        Sat, 13 Jun 2020 14:53:51 +0800 (CST)
Received: from huawei.com (10.179.179.12) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sat, 13 Jun 2020
 14:53:43 +0800
From:   guodeqing <geffrey.guo@huawei.com>
To:     <davem@davemloft.net>
CC:     <kuznet@ms2.inr.ac.ru>, <netdev@vger.kernel.org>,
        <dsa@cumulusnetworks.com>, <kuba@kernel.org>,
        <geffrey.guo@huawei.com>
Subject: [PATCH] net: Fix the arp error in some cases
Date:   Sat, 13 Jun 2020 14:49:55 +0800
Message-ID: <1592030995-111190-1-git-send-email-geffrey.guo@huawei.com>
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
$ ifconfig eth0 6.6.6.6 netmask 255.255.255.0

$ ip rule add from 6.6.6.6 table 6666

$ ip route add 9.9.9.9 via 6.6.6.6

$ ping -I 6.6.6.6 9.9.9.9
PING 9.9.9.9 (9.9.9.9) from 6.6.6.6 : 56(84) bytes of data.

^C
--- 9.9.9.9 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2079ms

$ arp
Address     HWtype  HWaddress           Flags Mask            Iface
6.6.6.6             (incomplete)                              eth0

The arp request address is error, this problem can be reproduced easily.

Fixes: 3bfd847203c6("net: Use passed in table for nexthop lookups")
Signed-off-by: guodeqing <geffrey.guo@huawei.com>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index e53871e..1f75dc6 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1109,7 +1109,7 @@ static int fib_check_nh_v4_gw(struct net *net, struct fib_nh *nh, u32 table,
 		if (fl4.flowi4_scope < RT_SCOPE_LINK)
 			fl4.flowi4_scope = RT_SCOPE_LINK;
 
-		if (table)
+		if (table && table != RT_TABLE_MAIN)
 			tbl = fib_get_table(net, table);
 
 		if (tbl)
-- 
2.7.4

