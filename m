Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D70E15B135
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 20:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgBLTgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 14:36:36 -0500
Received: from gateway23.websitewelcome.com ([192.185.50.141]:31929 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728911AbgBLTgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 14:36:35 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id AEA524B72
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 13:36:34 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 1xoIjWM2eEfyq1xoIjg3ja; Wed, 12 Feb 2020 13:36:34 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ej4epKkgtd78pmu2soBpc7h1dUAyIncXzyPzor29u0Q=; b=GKdpEggZVyr3zWD2G0+2JmrFq/
        lAYolu14OCpJjaibWW7sCc9mBM3WR98A5yx6uizd/LTleIQ3V1ub3bEaLRccXFd7S7rbgZAFmdJJN
        AfE5M9qOTEYuHbscThqnpVVpRWpksIfx9KhK6fP+1o/ElwZGo8KHaHlBN9z6qsUX1WjmYRZvyNHlr
        Sbsjf7THeVS4vd/eyF8IF3ax9NrfGRRVLAoN0KeN9sq10fqOSyP6v6eOJsZ00DXfvX1C6EWR/KP2g
        jjJqU0+mRKqvj+dW+TLHJJiJbltLNnN7cLTrgMq6en+sI7F+kj7nWE8SF+4SQ/NquuVnIrl/vhK4l
        IdhGjnCA==;
Received: from [201.144.174.25] (port=7008 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j1xoH-001AQk-1y; Wed, 12 Feb 2020 13:36:33 -0600
Date:   Wed, 12 Feb 2020 13:39:08 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] net: devlink: Replace zero-length array with
 flexible-array member
Message-ID: <20200212193908.GA30620@embeddedor>
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
X-Source-IP: 201.144.174.25
X-Source-L: No
X-Exim-ID: 1j1xoH-001AQk-1y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.144.174.25]:7008
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 35
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
inadvertenly introduced[3] to the codebase from now on.

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
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 549ee56b7a21..a8c1f46319da 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4232,7 +4232,7 @@ struct devlink_fmsg_item {
 	int attrtype;
 	u8 nla_type;
 	u16 len;
-	int value[0];
+	int value[];
 };
 
 struct devlink_fmsg {
-- 
2.25.0

