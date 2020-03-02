Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFFE1759E9
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 13:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgCBMA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 07:00:59 -0500
Received: from gateway21.websitewelcome.com ([192.185.45.38]:48764 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727228AbgCBMA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 07:00:59 -0500
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 25E57400E8738
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 06:00:58 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8jknjygWNEfyq8jkoj3H4w; Mon, 02 Mar 2020 06:00:58 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GsVRQOnb9R+wqSrh14nCUTJamDpoQJdhIGejpnhlXaA=; b=tmiFV/pSqdqUxQvzZwfKRvcuQS
        nrNndKakapvjXA0g0gKntJ6AhvL1DnrIFbwCsXPy8l/ryCB9TlAFLAV7Y0VW7B1NZyXdwYNLS8iXg
        u1y6y+ZHIiWqVKuijfVp/svaWo1s1gXhwElBBfXD0LSBaF0ip4pA/kLD3s10PYe9ffCtSZ3o6zuTi
        u4UezfLVleRxobvznz19V01GnExwJe6m6OZPvd4fpRoUkB7LEBO7a5G0MCcqMK6WxU4mdkdMD/Vz/
        TpfgwLB2WL8n4nj8pBN5DeTT04e3m5I80ya8RkEc/eCGzFCZdxbXnNhX612LRN5AkUfmOKehs+QJg
        6vzz+BiQ==;
Received: from [201.166.157.55] (port=42220 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j8jkl-003r5x-Ct; Mon, 02 Mar 2020 06:00:56 -0600
Date:   Mon, 2 Mar 2020 06:03:52 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: ip_fib: Replace zero-length array with
 flexible-array member
Message-ID: <20200302120352.GA15843@embeddedor>
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
X-Source-IP: 201.166.157.55
X-Source-L: No
X-Exim-ID: 1j8jkl-003r5x-Ct
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.157.55]:42220
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
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
 include/net/ip_fib.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 6a1ae49809de..dabe398bee4c 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -153,7 +153,7 @@ struct fib_info {
 	bool			nh_updated;
 	struct nexthop		*nh;
 	struct rcu_head		rcu;
-	struct fib_nh		fib_nh[0];
+	struct fib_nh		fib_nh[];
 };
 
 
@@ -250,7 +250,7 @@ struct fib_table {
 	int			tb_num_default;
 	struct rcu_head		rcu;
 	unsigned long 		*tb_data;
-	unsigned long		__data[0];
+	unsigned long		__data[];
 };
 
 struct fib_dump_filter {
-- 
2.25.0

