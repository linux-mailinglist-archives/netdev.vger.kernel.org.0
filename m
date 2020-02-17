Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532FD161CE5
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 22:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbgBQVlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 16:41:44 -0500
Received: from gateway34.websitewelcome.com ([192.185.148.119]:43969 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728935AbgBQVlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 16:41:44 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 497E8413978
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 15:41:43 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 3o99jkbRr8vkB3o99jhXt5; Mon, 17 Feb 2020 15:41:43 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8exBLdInKXUzJxq+ZuAOxKExTTscVDb1+bUsC6sGG8g=; b=HgN+9rsp3fFCj0fJUhjufn2/l7
        VUbRynRSy0CAxMQY1KjfA6V0LtIYanqWDAcf8yWC0eCA4k6KrY0nHZXuU/xZc13RL7fkTFbpblB9Z
        oaw0tEO4v2iCjRJSKPg7FVGlJmBpyn54igDPdhEvFipu6bdIypiYf2GXKs6TVHrC6ONCP579pTBsD
        k6d1SyEurDwqrzaiQ1aIEJb6Ekg+EqhR2woGKuNkFF0iOLmuHVv8PsANnufrSfgeIw47Z2AM++650
        z398+1TN/CWW5k09Ld5ZremaZw19BRvbwk+wOE0VJUTDklJDkNpaX6tXERWgdq/NvwlKLQ1s2lOvv
        y6pqb2rA==;
Received: from [200.68.140.26] (port=12036 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j3o97-001HA1-II; Mon, 17 Feb 2020 15:41:41 -0600
Date:   Mon, 17 Feb 2020 15:44:23 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] netfilter: ebtables: Replace zero-length array with
 flexible-array member
Message-ID: <20200217214423.GA15008@embeddedor>
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
X-Exim-ID: 1j3o97-001HA1-II
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.26]:12036
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 21
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
 net/bridge/netfilter/ebtables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index e1256e03a9a8..78db58c7aec2 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1561,7 +1561,7 @@ struct compat_ebt_entry_mwt {
 		compat_uptr_t ptr;
 	} u;
 	compat_uint_t match_size;
-	compat_uint_t data[0] __attribute__ ((aligned (__alignof__(struct compat_ebt_replace))));
+	compat_uint_t data[] __aligned(__alignof__(struct compat_ebt_replace));
 };
 
 /* account for possible padding between match_size and ->data */
-- 
2.25.0

