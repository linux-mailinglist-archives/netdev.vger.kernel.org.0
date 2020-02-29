Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760661743DB
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 01:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgB2AlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 19:41:17 -0500
Received: from gateway22.websitewelcome.com ([192.185.47.163]:21598 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgB2AlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 19:41:17 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 248119919
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 18:41:16 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7qBwjRbKx8vkB7qBwjMICl; Fri, 28 Feb 2020 18:41:16 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=N/hhIq6iWRTBqUapgvxGTLwwi+HQloiivG28+tCAbEo=; b=Ww8/bVXSclbVP/+MIayGTzCmfS
        xZBKuynEcQo5CgQKN18XhIp8Ohyxpypm9XYfr9aUiYjVzYAYIVLov0nD0fzzDV0Xl2UUnTWK5cjNi
        3hfhXN83gSGatiNVgtabPW6FeIJJwgQB+KJFaEnn5X1WoGNkTwlF4c0LAZpUVhdKde/tSerMi6Tlj
        ZlC8WyJvN88g2fws0JQlRwnHokd2aj2NSkTXNmrFvAysUhMkYGV2DxuDMoK57G9IcH10yPZJM3aCe
        ebUQxj43Sqcrchdj4JQcWw9oI2r9Td9FFzXfccZ8DEobpfXrJVnOCsjSj2daUS1IbLY6A0W5ZlaYc
        zNtLTykQ==;
Received: from [200.39.15.57] (port=1520 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7qBu-002qxf-5o; Fri, 28 Feb 2020 18:41:14 -0600
Date:   Fri, 28 Feb 2020 18:44:10 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: ip6_route: Replace zero-length array with
 flexible-array member
Message-ID: <20200229004410.GA8069@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.39.15.57
X-Source-L: No
X-Exim-ID: 1j7qBu-002qxf-5o
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.39.15.57]:1520
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 22
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 include/net/ip6_route.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index b69c16cbbf71..f7543c095b33 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -16,7 +16,7 @@ struct route_info {
 				reserved_h:3;
 #endif
 	__be32			lifetime;
-	__u8			prefix[0];	/* 0,8 or 16 */
+	__u8			prefix[];	/* 0,8 or 16 */
 };
 
 #include <net/addrconf.h>
-- 
2.25.0

