Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5179175A72
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 13:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbgCBM1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 07:27:46 -0500
Received: from gateway20.websitewelcome.com ([192.185.63.14]:44055 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727519AbgCBM1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 07:27:45 -0500
X-Greylist: delayed 1382 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Mar 2020 07:27:45 EST
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id D48A4400D9803
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 04:50:08 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 8joRjM3Rq8vkB8joRjGJZp; Mon, 02 Mar 2020 06:04:43 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aC9iqi902jVDV0FwmY0WOb2/TDDXpbbOOU6f3WzG29g=; b=mOEtgKW1jkzprYDuuFXqL8PGw+
        9zyI/mXwqkhBBkwsdeW11YwLIVppno33x2MLEK2vpAFxVA6xKiNGgcd2/SAjDBC9YwG4TKrGMlFhe
        ffNBd+qxsUFI/mNes7I1eJAy2/lFnPa21G06lJszUoFfXAr04aGtbzsIMKTJSrQ6AJIm2Jt5nbncQ
        TcQ8WZS61Y7R8u1jnE8SsTjD0pGYVsemJx+kFDksZwh6VqblfNBhnFzC05Iv/Se1+dhcb/lFxt6fx
        8isAEHEFVk6SS2ih0U9u9MjtVVGHvP+D/Nd7AaTnVFu6knt+SEbXQcIPEZl1waOE0zWJPzWgodJnw
        uFIqLwFQ==;
Received: from [200.76.83.37] (port=42254 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j8joP-003ugb-GT; Mon, 02 Mar 2020 06:04:41 -0600
Date:   Mon, 2 Mar 2020 06:07:42 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: inet_sock: Replace zero-length array with
 flexible-array member
Message-ID: <20200302120742.GA16158@embeddedor>
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
X-Source-IP: 200.76.83.37
X-Source-L: No
X-Exim-ID: 1j8joP-003ugb-GT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.76.83.37]:42254
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 15
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
 include/net/inet_sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 34c4436fd18f..a7ce00af6c44 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -52,7 +52,7 @@ struct ip_options {
 	unsigned char	router_alert;
 	unsigned char	cipso;
 	unsigned char	__pad2;
-	unsigned char	__data[0];
+	unsigned char	__data[];
 };
 
 struct ip_options_rcu {
-- 
2.25.0

