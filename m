Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E9C1743B7
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 01:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgB2ALS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 19:11:18 -0500
Received: from gateway34.websitewelcome.com ([192.185.148.212]:20692 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726892AbgB2ALS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 19:11:18 -0500
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 642204CEC35
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 18:11:17 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7pivj8kl3Sl8q7pivjmdnG; Fri, 28 Feb 2020 18:11:17 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5b/2M8suuafk8OeTPNdtw9kguzC0VV2KliEDV8H4iH0=; b=y8Dn6BzyXZs47uWtFFyTX03RMH
        azDCmEAktwjGR/0Dhtif3bovuvGmHyrrBuPp+L3/e3vV30/b11fIBWloQ9uP+RkUAom+NRS27KQk7
        4glYaXzsWF47Otdm3tqGcfKFa9yWMmQau48ru/o8k0/7GEEYkUgdmKmALKDPKFeHptIt8BuOT3td0
        VTANAshuvEdzITPxkRAv9fIreRD3F2FTSUsPppfnCyPs/8sNQkg+YFkwDFIxl5ehHCE5upWaFrQPx
        oeXU6LCVL/Oq42QIkm/VmAh7T0rpvD0P/LBUbQ9E+s1kEXimn9bKP3fWNxsSVT1/skF1veiE1Mi0t
        PrZcK8aA==;
Received: from [200.39.15.57] (port=32151 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7pit-002eIL-I1; Fri, 28 Feb 2020 18:11:15 -0600
Date:   Fri, 28 Feb 2020 18:14:11 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: nexthop: Replace zero-length array with
 flexible-array member
Message-ID: <20200229001411.GA7580@embeddedor>
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
X-Exim-ID: 1j7pit-002eIL-I1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.39.15.57]:32151
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 16
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
 include/net/nexthop.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 331ebbc94fe7..c440ccc861fc 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -73,7 +73,7 @@ struct nh_group {
 	u16			num_nh;
 	bool			mpath;
 	bool			has_v4;
-	struct nh_grp_entry	nh_entries[0];
+	struct nh_grp_entry	nh_entries[];
 };
 
 struct nexthop {
-- 
2.25.0

