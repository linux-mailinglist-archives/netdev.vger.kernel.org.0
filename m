Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCE5161C46
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 21:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgBQUZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 15:25:06 -0500
Received: from gateway31.websitewelcome.com ([192.185.143.40]:47172 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728615AbgBQUZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 15:25:05 -0500
X-Greylist: delayed 1363 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Feb 2020 15:25:04 EST
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id B56661026D34
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 14:02:20 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 3mayjVK65XVkQ3mayjsQ0p; Mon, 17 Feb 2020 14:02:20 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ecty6MerGyd7wX45GYrcBWDuJacrGQZzyDnGictr5cU=; b=gHGlMLhH/8NwV+4WcyPOTRykq/
        Habr4VE/lVhtlFHsYItOo+hL9NTTW56IU2lJ8eGl1qfEf86QE6sJhsb1LUT+k7QS5FBgH/tJAPzIo
        Px0tsesC+EQj8bcXjlR+XbKKH9KmMUEv+6W5gSg/ydaU+W7A+FKL4R+4E6v3iHUZsYOSiAkXCJ/54
        Ule61XOWKpBeAkgzX1D0TpNShvbRdycWsUB0j1fyw/Oaei+VE9ecNQSUgIjTbCspp9+mXKU3kZhXF
        5NJoeeilulftg49oTqYf9IqAeOCUVeRc0Zmwivo4/6O+aaMo/E5JdzL5g42onE87HssaHFRBC0CWM
        B1TpV0jg==;
Received: from [200.68.140.26] (port=23900 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j3max-000Q8w-00; Mon, 17 Feb 2020 14:02:19 -0600
Date:   Mon, 17 Feb 2020 14:05:00 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] svcrdma: Replace zero-length array with flexible-array
 member
Message-ID: <20200217200500.GA7628@embeddedor>
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
X-Exim-ID: 1j3max-000Q8w-00
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.26]:23900
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
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
 net/sunrpc/xprtrdma/svc_rdma_rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 48fe3b16b0d9..003610ce00bc 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -41,7 +41,7 @@ struct svc_rdma_rw_ctxt {
 	struct rdma_rw_ctx	rw_ctx;
 	int			rw_nents;
 	struct sg_table		rw_sg_table;
-	struct scatterlist	rw_first_sgl[0];
+	struct scatterlist	rw_first_sgl[];
 };
 
 static inline struct svc_rdma_rw_ctxt *
-- 
2.25.0

