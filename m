Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B612B18C378
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 00:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgCSXGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 19:06:20 -0400
Received: from gateway21.websitewelcome.com ([192.185.46.113]:40229 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727258AbgCSXGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 19:06:20 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 2E365400CE6A1
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 18:06:19 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id F4F1j0tTT1s2xF4F1jjGMw; Thu, 19 Mar 2020 18:06:19 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EQ6+e94EbbRCvZN1MHbBCIYfPJUa31xR11Y1UAO3a5Y=; b=bbqQ6UjBbYS5lZK6jibj0Q4RXr
        oGcRafr24mHM8HhpT4wDedr92j84t6b0jdCXWe0is43cEy1Ujyy3ZjOtE9t2enNCbCdei3K+kQkat
        HXShAyF6UW1HNm+XK2AhwzQVvmS9huGrxmFtLnSUPM/Qb505GQAVwcUbnsi8YKxSfz9tg9UhF5hkr
        0hOfKzvPAicZY+VG7ixmCq8Cb8s1ekqv/Tb02B6gotHYfQse5cd+KYmRBUIz921QyaPkz0I8Z4StN
        5xvYwQs31KTH7kje1G0n1hvEVxlI8ypofez7QX81axcFUCOHt3YRTWu6f12EgPvgVpm64Knv9zgcm
        238nrMFw==;
Received: from cablelink-189-218-116-241.hosts.intercable.net ([189.218.116.241]:54032 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jF4Ez-002P1y-OU; Thu, 19 Mar 2020 18:06:17 -0500
Date:   Thu, 19 Mar 2020 18:06:17 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: wireless: wl3501.h: Replace zero-length array
 with flexible-array member
Message-ID: <20200319230617.GA15035@embeddedor.com>
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
X-Source-IP: 189.218.116.241
X-Source-L: No
X-Exim-ID: 1jF4Ez-002P1y-OU
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: cablelink-189-218-116-241.hosts.intercable.net (embeddedor) [189.218.116.241]:54032
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 9
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
 drivers/net/wireless/wl3501.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/wl3501.h b/drivers/net/wireless/wl3501.h
index efdce9ae36ea..b446cb369557 100644
--- a/drivers/net/wireless/wl3501.h
+++ b/drivers/net/wireless/wl3501.h
@@ -231,7 +231,7 @@ struct iw_mgmt_info_element {
 	u8 id; /* one of enum iw_mgmt_info_element_ids,
 		  but sizeof(enum) > sizeof(u8) :-( */
 	u8 len;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct iw_mgmt_essid_pset {
-- 
2.23.0

