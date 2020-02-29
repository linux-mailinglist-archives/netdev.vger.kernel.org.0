Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B29331743E9
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 01:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgB2Ara (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 19:47:30 -0500
Received: from gateway31.websitewelcome.com ([192.185.143.40]:28825 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgB2Ara (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 19:47:30 -0500
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 03AF28C6978
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 18:47:29 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7qHwjdEJXAGTX7qHwjm5bf; Fri, 28 Feb 2020 18:47:28 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1kBV8i/FuTFc7scOAcfC0C6xpXRKNE9rNfOuADX0M/c=; b=BjbkhLEsUj8bHs+lF5w2ihZ8UW
        qDZfDEkx+e7uMeSGP2NdQE3qmb4H2nBZ2eOhNhmwy411TjZ+eQj4lW1596PvEOcCDTFXJZfIxRyGA
        j6RzqCGkG53ileexILqk0iQp72QcuZzmf850ZLFabF2V7+qoByb7JZGXsfTzJaZlRANnKtCp1Cm1V
        8sjw8VyP8NqeVIaGuBbFGDqqP/6EN8YvmedNDnCEOy4YmSWqg4iXwy5L6fIAwPv0nw5m39JGLbuNi
        0C7j2OhyPkMWKYUcHz33EzOjCa8FbEzp8ejjML5LQ2tDayXYtEOXRf4Q4Iehahoa2vAjlaIH6U2cm
        eUzHzjFQ==;
Received: from [200.39.15.57] (port=26146 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7qHu-002tbk-Qn; Fri, 28 Feb 2020 18:47:27 -0600
Date:   Fri, 28 Feb 2020 18:50:23 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: lwtunnel: Replace zero-length array with
 flexible-array member
Message-ID: <20200229005023.GA8657@embeddedor>
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
X-Exim-ID: 1j7qHu-002tbk-Qn
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.39.15.57]:26146
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 26
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
 include/net/lwtunnel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/lwtunnel.h b/include/net/lwtunnel.h
index 5d6c5b1fc695..b5e6edf74b70 100644
--- a/include/net/lwtunnel.h
+++ b/include/net/lwtunnel.h
@@ -30,7 +30,7 @@ struct lwtunnel_state {
 	int		(*orig_output)(struct net *net, struct sock *sk, struct sk_buff *skb);
 	int		(*orig_input)(struct sk_buff *);
 	struct		rcu_head rcu;
-	__u8            data[0];
+	__u8            data[];
 };
 
 struct lwtunnel_encap_ops {
-- 
2.25.0

