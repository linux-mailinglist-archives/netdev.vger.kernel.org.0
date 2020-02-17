Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5A8161C1A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 21:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgBQUEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 15:04:43 -0500
Received: from gateway36.websitewelcome.com ([192.185.200.11]:12765 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727241AbgBQUEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 15:04:42 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id D2E2E400C5CF0
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 13:18:59 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 3mdDjicQS8vkB3mdDjfZjz; Mon, 17 Feb 2020 14:04:39 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5z9m63kd28Ot+M5QQVB7v0R9bZGcWNPML78KZuOVhHU=; b=cuFQS8U3qeUC4Djbx+zGs37Pr6
        a6QknbdqGQS1I4hszFnbzNrGV0t5zPRF0NHMDUsRQnHOqts4uTW71TxoA6e0HQyBkC3inbZ+oxLeO
        qOGXpPkJs/pHKLXnA7YjmecF86foEzfQvCQVBeeyYRNPOjzGd6SotNfBzjNTsKrEquXAPK/Hssw9Z
        ZF5v187TuqQPACLBd9HvcqDdnvqY10kOhskoIkymvgvPq/Ep7/7YLPgtIXv600YSuqRWLWQYEbJpW
        tUXSlkzIWsxPxXJbm6G436s06MjdLe2/uX4+SvZrjT3XLmNa+ga/tv6W50B+QOe1dwz4XQqhFFiWK
        yha1BMFA==;
Received: from [200.68.140.26] (port=27988 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j3mdB-000RJy-Mc; Mon, 17 Feb 2020 14:04:37 -0600
Date:   Mon, 17 Feb 2020 14:07:19 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: netlink: Replace zero-length array with
 flexible-array member
Message-ID: <20200217200719.GA8545@embeddedor>
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
X-Source-IP: 200.68.140.26
X-Source-L: No
X-Exim-ID: 1j3mdB-000RJy-Mc
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.26]:27988
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 12
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
 net/netlink/af_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4e31721e7293..bced11032681 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -71,7 +71,7 @@
 
 struct listeners {
 	struct rcu_head		rcu;
-	unsigned long		masks[0];
+	unsigned long		masks[];
 };
 
 /* state bits */
-- 
2.25.0

