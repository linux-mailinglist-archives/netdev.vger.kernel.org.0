Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 739591743A5
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 01:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgB2AIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 19:08:10 -0500
Received: from gateway33.websitewelcome.com ([192.185.145.221]:29960 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgB2AIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 19:08:09 -0500
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 264E8187B7C
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 18:08:08 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7pfsjcbTbAGTX7pfsjlT27; Fri, 28 Feb 2020 18:08:08 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zfaaTppUw/YMS2SHvO7uOLQjxhi/2WNpD6bDMsCd+WU=; b=tRctQ/gtfM+yfdtCBct6yCTOYK
        p4IaMOXmC3ve32NhJZ5OGIAXtY8Du6SqDiPoCaO4MCsPxCjqHlSQvLq2KxkRQoQP7NfzbzBU16C/Y
        LSkGzGx3gnCbAqLJ3X/S9Yh7v0H0XGES3WKVDY2VpDvBKiGY0OBU1d011I79L2AfWqG3GiQW/Rzhr
        D6UtIcV+E1Y5hWpJZsVy8DgmvLns4z5o1fbt76O/pju18PsjbrxGm33lTdYUXFzxHAQeIqDW7JaiE
        QAV+pIbY/BOMnWHW1mbtPy6420c3fGB9Hgy2VwOUyfO/45hX69U1X0LB+rDK6jnyjvsMHPfJ2eSZw
        F0MRS4hw==;
Received: from [200.39.15.57] (port=9598 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7pfq-002cpS-Bo; Fri, 28 Feb 2020 18:08:06 -0600
Date:   Fri, 28 Feb 2020 18:11:02 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: sock_reuseport: Replace zero-length array with
 flexible-array member
Message-ID: <20200229001102.GA6418@embeddedor>
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
X-Exim-ID: 1j7pfq-002cpS-Bo
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.39.15.57]:9598
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
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
 include/net/sock_reuseport.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
index 3ecaa15d1850..505f1e18e9bf 100644
--- a/include/net/sock_reuseport.h
+++ b/include/net/sock_reuseport.h
@@ -24,7 +24,7 @@ struct sock_reuseport {
 	unsigned int		bind_inany:1;
 	unsigned int		has_conns:1;
 	struct bpf_prog __rcu	*prog;		/* optional BPF sock selector */
-	struct sock		*socks[0];	/* array of sock pointers */
+	struct sock		*socks[];	/* array of sock pointers */
 };
 
 extern int reuseport_alloc(struct sock *sk, bool bind_inany);
-- 
2.25.0

