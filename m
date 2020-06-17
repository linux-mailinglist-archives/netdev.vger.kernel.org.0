Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5D61FC406
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 04:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgFQCLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 22:11:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6350 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726275AbgFQCLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 22:11:19 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B965FC71FD1D614718BB;
        Wed, 17 Jun 2020 10:11:17 +0800 (CST)
Received: from huawei.com (10.179.179.12) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 17 Jun 2020
 10:11:10 +0800
From:   guodeqing <geffrey.guo@huawei.com>
To:     <davem@davemloft.net>
CC:     <kuznet@ms2.inr.ac.ru>, <netdev@vger.kernel.org>,
        <dsa@cumulusnetworks.com>, <kuba@kernel.org>,
        <geffrey.guo@huawei.com>
Subject: [PATCH] net: Fix the arp error in some cases
Date:   Wed, 17 Jun 2020 10:07:16 +0800
Message-ID: <1592359636-107798-1-git-send-email-geffrey.guo@huawei.com>
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

3 packets transmitted, 0 received, 100% packet loss, time 2079ms

$ arp
Address     HWtype  HWaddress           Flags Mask            Iface
6.6.6.6             (incomplete)                              eth0

The arp request address is error, this is because fib_table_lookup in 
fib_check_nh lookup the destnation 9.9.9.9 nexthop, the scope of 
the fib result is RT_SCOPE_LINK,the correct scope is RT_SCOPE_HOST.  
Here I add a check of whether this is RT_TABLE_MAIN to solve this problem. 

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

