Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA5AB17656C
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 21:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgCBUzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 15:55:49 -0500
Received: from gateway32.websitewelcome.com ([192.185.145.184]:18146 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbgCBUzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 15:55:49 -0500
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 58463D1E0F
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 14:55:47 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8s6Njg7UivBMd8s6Njaw3n; Mon, 02 Mar 2020 14:55:47 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rYEKNB2xeEEAIH3u+o59ZWiVdW8Nt6lUauwpDu4HpeM=; b=yhHC5b0qJjrbsVOvLuWo/XERei
        2zjq64Us6Bp75AXG5cZLdQGwWlmD9jGC07wEUdLsy8zhXKnkHUEkixRyivNfeDNOw5OwtCeAPJEcZ
        h0xFasQYVM4l2fIR6tHBoDjF+Ghr1deJBhNj+r/xWOPw2y09fCyymQYJCvHMVklaPyd/iDuhvROqU
        XTxTOPfZNiKYS1StIl5LHIUfjWlExWT/krTBDEWOS1lvLrXSeYpq6OAPTy0Jhoq/B9gkONZ0xErQx
        /ZUfvJUPMWMcnYGaDoqako1i8fU6CDhaw/TiwjJcjuDPWNTLkWTMrAoaP58xGV/07UzGyfFYJIhrr
        y+0JdsDQ==;
Received: from [201.166.169.19] (port=7379 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j8s6L-004OPt-92; Mon, 02 Mar 2020 14:55:45 -0600
Date:   Mon, 2 Mar 2020 14:58:47 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] liquidio: Replace zero-length array with
 flexible-array member
Message-ID: <20200302205847.GA18593@embeddedor>
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
X-Source-IP: 201.166.169.19
X-Source-L: No
X-Exim-ID: 1j8s6L-004OPt-92
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.169.19]:7379
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 11
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
 drivers/net/ethernet/cavium/liquidio/octeon_console.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/octeon_console.c b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
index dfc77507b159..d0d581e98734 100644
--- a/drivers/net/ethernet/cavium/liquidio/octeon_console.c
+++ b/drivers/net/ethernet/cavium/liquidio/octeon_console.c
@@ -127,7 +127,7 @@ struct octeon_pci_console_desc {
 	u32 pad;
 	/* must be 64 bit aligned here... */
 	/* Array of addresses of octeon_pci_console structures */
-	u64 console_addr_array[0];
+	u64 console_addr_array[];
 	/* Implicit storage for console_addr_array */
 };
 
-- 
2.25.0

