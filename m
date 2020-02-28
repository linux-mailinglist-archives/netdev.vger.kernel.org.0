Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC4C7173942
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgB1N6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:58:51 -0500
Received: from gateway24.websitewelcome.com ([192.185.51.202]:37964 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726987AbgB1N6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:58:50 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id AA07E21AB88
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 07:58:49 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7gADjpWk6Efyq7gADjuqdS; Fri, 28 Feb 2020 07:58:49 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VmWd0kawVjFDVrC58A0HNwnFKmgLjI3Oqnx2bR0eAVQ=; b=VIuaiMohhZXQfd3PZHOPz8KL2P
        xmeCR3nBB+XF0F6FAAbckyFmLrh2dAB5ooRqkhA4ISAuiBKVlPE9PYmgKnQxaAtvpnY0Exv0dKFYc
        XwG5I6JsCh9sBMChthQO5jfwxJgMG0uTLoFATzLrBwBCZaqImWS6BpS9eRKtqv9CXzynQCQtd99GK
        ZWOsN0ci3huFrVZmIOzp6cw5icqYYRiDLer5Rn1K+u6J8W0SrTYqxsY7psj7JIPkle1Xj0J64nPbF
        xU0OQPPyswEBmEDUXhmztDb0YFEzBTd6qucLCQ9XBe1RdlZJyyicqyhJS4L0T1XAVxFbVVs/ffuPf
        3Rwiv9Pw==;
Received: from [201.162.240.44] (port=31926 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7gAB-001bTU-Pt; Fri, 28 Feb 2020 07:58:48 -0600
Date:   Fri, 28 Feb 2020 08:01:43 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] af_unix: Replace zero-length array with flexible-array
 member
Message-ID: <20200228140143.GA30654@embeddedor>
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
X-Exim-ID: 1j7gAB-001bTU-Pt
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.240.44]:31926
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 75
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
 include/net/af_unix.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 17e10fba2152..e51d727cc3cd 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -27,7 +27,7 @@ struct unix_address {
 	refcount_t	refcnt;
 	int		len;
 	unsigned int	hash;
-	struct sockaddr_un name[0];
+	struct sockaddr_un name[];
 };
 
 struct unix_skb_parms {
-- 
2.25.0

