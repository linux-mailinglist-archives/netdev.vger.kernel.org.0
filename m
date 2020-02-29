Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A0C174416
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 02:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgB2BMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 20:12:30 -0500
Received: from gateway20.websitewelcome.com ([192.185.69.18]:29316 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbgB2BMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 20:12:30 -0500
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 86D61401C96E3
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 17:34:20 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7qJDjEdg3XVkQ7qJDjZRdw; Fri, 28 Feb 2020 18:48:47 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rkgKkwh+Uy7zbmDqvHdqXDUel6G9tCsRpBolNnwM8dI=; b=efrLuhQPWVnz12w0pxW8O9tDfX
        YgxeX0EVNDJtNTJEb2XROl3trqu3klTXskiynIlVuifHQgq/31YmmcshPBDTuIqEtaGrNuSLvVgoT
        2pltiZpQGgZ5PcPW3syE+hy9m3Eq/By106w/TYiT1Rp+I3kBbg3YSFfs1k0iOAEM4kexRv0zKWEZb
        VXCyEdvvXVlhcIEQNW6LlYEte5wiNiHaTxVD8Nu7L2NyHDWl1Gh1ZqdSktf1QHxN7NuB2Qs/26RY+
        D0/ZKWdPjFyiEL+2ZmGsO+XBo2H0MLxx2SbftJizxannL3DmkNgmclUgJSAmBYKV3EXnLugcCmTSX
        rkZ3wBhA==;
Received: from [200.39.15.57] (port=18879 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7qJB-002uCH-20; Fri, 28 Feb 2020 18:48:45 -0600
Date:   Fri, 28 Feb 2020 18:51:41 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: ipv6: mld: Replace zero-length array with
 flexible-array member
Message-ID: <20200229005141.GA8807@embeddedor>
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
X-Exim-ID: 1j7qJB-002uCH-20
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.39.15.57]:18879
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 30
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
 include/net/mld.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/mld.h b/include/net/mld.h
index b0f5b3105ef0..496bddb59942 100644
--- a/include/net/mld.h
+++ b/include/net/mld.h
@@ -24,12 +24,12 @@ struct mld2_grec {
 	__u8		grec_auxwords;
 	__be16		grec_nsrcs;
 	struct in6_addr	grec_mca;
-	struct in6_addr	grec_src[0];
+	struct in6_addr	grec_src[];
 };
 
 struct mld2_report {
 	struct icmp6hdr		mld2r_hdr;
-	struct mld2_grec	mld2r_grec[0];
+	struct mld2_grec	mld2r_grec[];
 };
 
 #define mld2r_type		mld2r_hdr.icmp6_type
@@ -55,7 +55,7 @@ struct mld2_query {
 #endif
 	__u8			mld2q_qqic;
 	__be16			mld2q_nsrcs;
-	struct in6_addr		mld2q_srcs[0];
+	struct in6_addr		mld2q_srcs[];
 };
 
 #define mld2q_type		mld2q_hdr.icmp6_type
-- 
2.25.0

