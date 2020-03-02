Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06BF5175AD5
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 13:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgCBMwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 07:52:36 -0500
Received: from gateway36.websitewelcome.com ([50.116.124.69]:38648 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727267AbgCBMwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 07:52:36 -0500
X-Greylist: delayed 1493 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Mar 2020 07:52:35 EST
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id D6ACD408E8C9B
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 05:18:13 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8jmujShzTvBMd8jmujNcBP; Mon, 02 Mar 2020 06:03:08 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R89dgEYKQnx5o1J3Vnuz1dXFwA4KgrUXTckEdxlKpP4=; b=oQ5hR5XCnjLsav/jq8TM5BwWdy
        kt8OFIsKWOYCqnOFOO5/ZdhuxgaHmEhamjUNQUP0ucg5d/BaiXmHHWR16iEnOUkUQeg1E6BIww8Jn
        8AaeNQOS/6ieSW8TMWhtZNAjzqyGC4gIOouGC50aCEXdhVT+akgvJNaXqilKy6tdW+akeHN7Itr8c
        QLZ1f99zg4sz3j1df8KgBpVam/xEEF1OjLEqj2CvwWc7OfMTr+A0Zg4om4Ezt8omFHGwovKq7RoVD
        b33iop/NzfIi5HveYiag1eofdspDfwi8I2Mzs+09QyXmOERYMEYjgBbnffveb7RPcx7kDCpZ8PdIp
        vpaJBarw==;
Received: from [201.162.161.208] (port=42252 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j8jms-003tp3-Cn; Mon, 02 Mar 2020 06:03:06 -0600
Date:   Mon, 2 Mar 2020 06:06:07 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: ip6_fib: Replace zero-length array with
 flexible-array member
Message-ID: <20200302120607.GA15995@embeddedor>
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
X-Source-IP: 201.162.161.208
X-Source-L: No
X-Exim-ID: 1j8jms-003tp3-Cn
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.161.208]:42252
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
 include/net/ip6_fib.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index fd60a8ac02ee..6ec26e4d7f11 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -198,7 +198,7 @@ struct fib6_info {
 
 	struct rcu_head			rcu;
 	struct nexthop			*nh;
-	struct fib6_nh			fib6_nh[0];
+	struct fib6_nh			fib6_nh[];
 };
 
 struct rt6_info {
-- 
2.25.0

