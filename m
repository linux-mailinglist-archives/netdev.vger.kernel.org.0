Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8791B1759D7
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 12:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgCBL5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 06:57:51 -0500
Received: from gateway23.websitewelcome.com ([192.185.49.177]:25240 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727484AbgCBL5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 06:57:51 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 95153F251
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 05:57:49 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8jhljybhyEfyq8jhlj3CJ3; Mon, 02 Mar 2020 05:57:49 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fD33KKIGr5Ws4cdK1zZKSQCUmd1HtH/IrzzI0B9tVZk=; b=I9eNO2X8rRUSzk2heYkwGIuw0X
        +/ZEcjQxldRQKpOyIl+x8nhMx4obQrDGOeUoOZIsWl5ppTBC+yj7HCWiz6ziDIia8O4s7+PdL6f8r
        Lc5MldPhyzewK8qhCoKNehP7HgL5Axd1Y0TDcsI8JIKw+ym+frNC24Ck3Da3g9xVRyp74TYRg1Jee
        gNZRaQw9K0z3hvbCUSY5MGb9Vi+abl8xXdPWJXxmhNtuLbhhcTQHyIZQK+0t6IbzNA9xFDWj83hm7
        8miG8QVr9vk+fb7O46mTASO7PYGuMiTYH5sE4Zxm8P1oSYJxavszjgEQ+f2zfEhQROjUVs/MpOG8/
        EyHJnUmA==;
Received: from [200.39.29.189] (port=42212 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j8jhj-003pLb-GS; Mon, 02 Mar 2020 05:57:48 -0600
Date:   Mon, 2 Mar 2020 06:00:48 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: mip6: Replace zero-length array with
 flexible-array member
Message-ID: <20200302120048.GA15566@embeddedor>
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
X-Source-IP: 200.39.29.189
X-Source-L: No
X-Exim-ID: 1j8jhj-003pLb-GS
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.39.29.189]:42212
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
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
 include/net/mip6.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/mip6.h b/include/net/mip6.h
index f1c28971c362..67cd7e50804c 100644
--- a/include/net/mip6.h
+++ b/include/net/mip6.h
@@ -25,7 +25,7 @@ struct ip6_mh {
 	__u8	ip6mh_reserved;
 	__u16	ip6mh_cksum;
 	/* Followed by type specific messages */
-	__u8	data[0];
+	__u8	data[];
 } __packed;
 
 #define IP6_MH_TYPE_BRR		0   /* Binding Refresh Request */
-- 
2.25.0

