Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEF1216DEB
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 15:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgGGNj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 09:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbgGGNj0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 09:39:26 -0400
Received: from C02YQ0RWLVCF.hsd1.co.comcast.net (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE9B720658;
        Tue,  7 Jul 2020 13:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594129166;
        bh=Dx4c+jrBHzOqyxwrHqLVy/fOZ0kITgDq23OvGApOanc=;
        h=From:To:Cc:Subject:Date:From;
        b=o1w4Cx3LkOpws1BAmLpwoTfPlpRy6lFxtHgT10NTbdjOjQsdw7AIFTU8eVGzNsL8A
         ltNJ3n/sLUY3iDRxlmsMCPQflSqV+FtrV2VC+WOWMWY0Tn58O/qpacggAVSEOMjV81
         A4TzuiCz5DN0ThzCXTSjsRNAq7vPEs5hmdnDFpEU=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     thomas.gambier@nexedi.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH net] ipv6: Fix use of anycast address with loopback
Date:   Tue,  7 Jul 2020 07:39:24 -0600
Message-Id: <20200707133924.24919-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas reported a regression with IPv6 and anycast using the following
reproducer:

    echo 1 >  /proc/sys/net/ipv6/conf/all/forwarding
    ip -6 a add fc12::1/16 dev lo
    sleep 2
    echo "pinging lo"
    ping6 -c 2 fc12::

The conversion of addrconf_f6i_alloc to use ip6_route_info_create missed
the use of fib6_is_reject which checks addresses added to the loopback
interface and sets the REJECT flag as needed. Update fib6_is_reject for
loopback checks to handle RTF_ANYCAST addresses.

Fixes: c7a1ce397ada ("ipv6: Change addrconf_f6i_alloc to use ip6_route_info_create")
Reported-by: thomas.gambier@nexedi.com
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index ea0be7cf3d93..f3279810d765 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3405,7 +3405,7 @@ static bool fib6_is_reject(u32 flags, struct net_device *dev, int addr_type)
 	if ((flags & RTF_REJECT) ||
 	    (dev && (dev->flags & IFF_LOOPBACK) &&
 	     !(addr_type & IPV6_ADDR_LOOPBACK) &&
-	     !(flags & RTF_LOCAL)))
+	     !(flags & (RTF_ANYCAST | RTF_LOCAL))))
 		return true;
 
 	return false;
-- 
2.17.1

