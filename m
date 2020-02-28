Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2FF5173998
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgB1OQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 09:16:27 -0500
Received: from gateway20.websitewelcome.com ([192.185.51.6]:13650 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726838AbgB1OQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 09:16:27 -0500
X-Greylist: delayed 1371 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2020 09:16:26 EST
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id DD9D7400C69AD
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 06:39:09 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7g59jCxKa8vkB7g59j7jGV; Fri, 28 Feb 2020 07:53:35 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9MXNMsFMVcQPW05en/+q2B+/a2FtM4H6ysZ3B1RIBDk=; b=B+V7j6MeZu508oeK16Ehu6kE4l
        B4N9bGNmNfz2MQeZTw3MOkptYpEx+6YM4C4y1GoskBI+88i/zz7eqS+6k3QmMy4CVRsw4JiqFDuUH
        eTyxYHzsIxZZLnzlExQgbxRYeEF+bCpFqx5OBWkTFhHXnt/HTIQzzKjZqCy37JuWEN6lDl6gM/YGP
        /GCQCz4O7R/cxW4B4odibyMNvXHuqyzwKZJ42c7lVaZkNTlyyEBKk6/moesUH0UKHaWSNf9gzMmoT
        mISuU4Urz7Tjk+byhp8FhXKDD/2Fs9cgnNWPpir8I8InGkxqXY7ixxd15SXA0gzwiokJiY1YiDh4r
        i/7CRnyw==;
Received: from [201.162.240.44] (port=6756 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7g57-001Yph-42; Fri, 28 Feb 2020 07:53:33 -0600
Date:   Fri, 28 Feb 2020 07:56:29 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] bonding: Replace zero-length array with flexible-array
 member
Message-ID: <20200228135629.GA30289@embeddedor>
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
X-Source-IP: 201.162.240.44
X-Source-L: No
X-Exim-ID: 1j7g57-001Yph-42
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.240.44]:6756
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 64
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
 include/net/bonding.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/bonding.h b/include/net/bonding.h
index 3d56b026bb9e..dc2ce31a1f52 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -183,7 +183,7 @@ struct slave {
 struct bond_up_slave {
 	unsigned int	count;
 	struct rcu_head rcu;
-	struct slave	*arr[0];
+	struct slave	*arr[];
 };
 
 /*
-- 
2.25.0

