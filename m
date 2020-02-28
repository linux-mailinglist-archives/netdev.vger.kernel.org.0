Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0468C173874
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgB1NgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:36:21 -0500
Received: from gateway32.websitewelcome.com ([192.185.144.98]:39047 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726151AbgB1NgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:36:20 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2020 08:36:20 EST
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 0452B1A2BB
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 07:30:44 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7fj1jCUij8vkB7fj1j7Goa; Fri, 28 Feb 2020 07:30:44 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Lu2UNNDEeNiF01lLdVnT5hMzc2S6yAIGWedaWMTmuQY=; b=ZSBryY7s+UYvF2h7EmzUfUGGpi
        kkz4X1ZLl+3mp2mk9lDTwGX65cXpHnsQhZ2EcB3P8Z/D54g7jJG2nr3QHB7tA4jXWJbBQ0QBxeDwf
        td+c/BkT3XeCR0T1djdkEW4i9iUL4dcK4Fw0/pNnf4SS14Q7/6kBp666BJh400eWmZP7TO5O6uT3/
        VxFZ2ug1JFD+u6KhwirQsDfLIrsI4vG+Df9EF6hswflK0CORs8wY5F2krITiFRgy3yrM+sxeBDsrS
        EkZmGzxB8hEaktOoZPEF1invSKxbjrb5cHfpiu85L/4xq2hCY9MSpicokh1bbapMwETkH99A+mSVI
        gFPCmWGA==;
Received: from [201.162.240.44] (port=16592 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7fiz-001MVV-WD; Fri, 28 Feb 2020 07:30:42 -0600
Date:   Fri, 28 Feb 2020 07:33:37 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     dccp@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: dccp: Replace zero-length array with
 flexible-array member
Message-ID: <20200228133337.GA23619@embeddedor>
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
X-Exim-ID: 1j7fiz-001MVV-WD
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.240.44]:16592
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 32
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
 include/linux/dccp.h | 2 +-
 net/dccp/ccid.h      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dccp.h b/include/linux/dccp.h
index 6b64b6cc2175..07e547c02fd8 100644
--- a/include/linux/dccp.h
+++ b/include/linux/dccp.h
@@ -198,7 +198,7 @@ enum dccp_role {
 
 struct dccp_service_list {
 	__u32	dccpsl_nr;
-	__be32	dccpsl_list[0];
+	__be32	dccpsl_list[];
 };
 
 #define DCCP_SERVICE_INVALID_VALUE htonl((__u32)-1)
diff --git a/net/dccp/ccid.h b/net/dccp/ccid.h
index 70f88f2b4456..105f3734dadb 100644
--- a/net/dccp/ccid.h
+++ b/net/dccp/ccid.h
@@ -95,7 +95,7 @@ void ccid_cleanup_builtins(void);
 
 struct ccid {
 	struct ccid_operations *ccid_ops;
-	char		       ccid_priv[0];
+	char		       ccid_priv[];
 };
 
 static inline void *ccid_priv(const struct ccid *ccid)
-- 
2.25.0

