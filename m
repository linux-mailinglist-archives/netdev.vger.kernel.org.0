Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71D81739B2
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgB1OV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 09:21:27 -0500
Received: from gateway20.websitewelcome.com ([192.185.51.6]:21398 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbgB1OV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 09:21:26 -0500
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 46037400CDC0B
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 06:19:22 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7flzjJDugvBMd7flzjEeGb; Fri, 28 Feb 2020 07:33:47 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aSkfaOdswRAcwEgvUUD/jHq/wDo0j5Z3Rpp7rEjxwzs=; b=i4RC3P4Avjr5/G58F/ZCoUScku
        V2MZjVGzvtC0nv8YdtVWvd9isNstfUIr57yO9H29QcPyRMmclXVrL0z+IjE6h7dTTir/qus4H/0zU
        YubdgMsnax0gy0nwo8M7D3Sw/c3JBl1QPxZmaBvLC3DGwKh1oU7CCHp+oQOOEKPHMeFEU76+u2Qta
        O/gMwWzNhBKAlR85ODVU55wHW1VyxB5Ki7RSLqzUH7oUKDTeC1Vp4oA+hMn3mvqMSmayCu6basPBs
        UeerteqSSs7bKV2sibVhqFCUsIm5q50vG4ClBWWhUddW5LMWf2e9S5CdseXJ/r8XLQlpDkDw9icTE
        46rqtnjw==;
Received: from [201.162.240.44] (port=20057 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7flx-001O1V-J7; Fri, 28 Feb 2020 07:33:46 -0600
Date:   Fri, 28 Feb 2020 07:36:41 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] ipv6: Replace zero-length array with flexible-array
 member
Message-ID: <20200228133641.GA27169@embeddedor>
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
X-Exim-ID: 1j7flx-001O1V-J7
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.240.44]:20057
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 39
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
 net/ipv6/ah6.c           | 2 +-
 net/ipv6/seg6_iptunnel.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 95835e8d99aa..871d6e52ec67 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -36,7 +36,7 @@ struct tmp_ext {
 		struct in6_addr saddr;
 #endif
 		struct in6_addr daddr;
-		char hdrs[0];
+		char hdrs[];
 };
 
 struct ah_skb_cb {
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index ab7f124ff5d7..d8afe7290de8 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -29,7 +29,7 @@
 
 struct seg6_lwt {
 	struct dst_cache cache;
-	struct seg6_iptunnel_encap tuninfo[0];
+	struct seg6_iptunnel_encap tuninfo[];
 };
 
 static inline struct seg6_lwt *seg6_lwt_lwtunnel(struct lwtunnel_state *lwt)
-- 
2.25.0

