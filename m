Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 410C4173905
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgB1Nwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:52:41 -0500
Received: from gateway31.websitewelcome.com ([192.185.144.218]:47302 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726388AbgB1Nwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:52:40 -0500
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id CF084845893
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 07:27:52 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7fgGjJ3nZvBMd7fgGjEUCg; Fri, 28 Feb 2020 07:27:52 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=arRYXiDb6WyCDYMZcCGJW6no8X0qWd9RaYLstjwKJ2w=; b=h39UGB4ezyb2xE4jBSWQqhkIod
        lJeFub8UQJBNs+j2o0LWtStK171i/ElA8nicf7KHRm8xDV8Gmh+baHKzzKGmXA1CEBq63n7CrJAte
        T9fWIA9L1c87GSWcvG19FwzHKYXmQ1LotZPGXckZ71Saa7nSdks57J+m8kTRAWjlhXFAxs0cjjPS+
        itahoJUYalOZy7N8oeWXkUijIvXB2sROEkDWX2kxkFiePUoJOyH4QzWqEYOW/Q79glG1cGUOtcSwC
        h+Kt2BYBaEupo67wwvxsXCfGfUYZWplKkH2qpaUK0dGrOP15U+JmFFokntPgeWGhTNQaOUUI3+kRH
        ENvcqPgQ==;
Received: from [201.162.240.44] (port=22657 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7fgD-001Kes-Ip; Fri, 28 Feb 2020 07:27:51 -0600
Date:   Fri, 28 Feb 2020 07:30:45 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] l2tp: Replace zero-length array with flexible-array
 member
Message-ID: <20200228133045.GA22318@embeddedor>
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
X-Exim-ID: 1j7fgD-001Kes-Ip
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.240.44]:22657
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 25
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

Lastly, fix the following checkpatch warning:
CHECK: Prefer kernel type 'u8' over 'uint8_t'
#50: FILE: net/l2tp/l2tp_core.h:119:
+	uint8_t			priv[];	/* private data */

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/l2tp/l2tp_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 2db3d50d10a4..10cf7c3dcbb3 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -116,7 +116,7 @@ struct l2tp_session {
 	void (*recv_skb)(struct l2tp_session *session, struct sk_buff *skb, int data_len);
 	void (*session_close)(struct l2tp_session *session);
 	void (*show)(struct seq_file *m, void *priv);
-	uint8_t			priv[0];	/* private data */
+	u8			priv[];	/* private data */
 };
 
 /* Describes the tunnel. It contains info to track all the associated
-- 
2.25.0

