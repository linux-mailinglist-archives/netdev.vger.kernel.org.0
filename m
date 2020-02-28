Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF521739B3
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgB1OVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 09:21:30 -0500
Received: from gateway20.websitewelcome.com ([192.185.51.6]:24423 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbgB1OVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 09:21:30 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 80806400C4A46
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 06:42:41 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7g8ZjD11K8vkB7g8Zj7mvb; Fri, 28 Feb 2020 07:57:07 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pJ55MoBgiHzpl8kAnbu/YiwbH1syaoq6Pgucy8z9yhQ=; b=sxaH/oyQ6D3/Y76B6w4QjSjS3i
        oagEf+gooAwg7En6IhyrywYfqPaabNp6rnN2rj0vmobFvKcPxNZ0uLdxeDt+5sqOZdb71TEJTbGNH
        BnJD6POBt560LnLA483c8JsJGM+g7Uknv209Y9sLz/vlyVSobSY2D5E2orhip4k3nCDu1vql4HksH
        LO6+kxvRCaOB9SF/AShWe8uQsuefMvMe9IQd+jaU9UdHwWt22Pg7PbYD5cofLsVtT9P9q7wcMZ2Nd
        KhnmaJNKalTcn5qzenynTqbWn5JD4HPMJHhcgPlhrbbvv+1Rx6X9CePcZbUTbqIiRPLlW9DRYBm56
        4N2u8I+w==;
Received: from [201.162.240.44] (port=3402 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7g8X-001adL-6K; Fri, 28 Feb 2020 07:57:05 -0600
Date:   Fri, 28 Feb 2020 07:59:59 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] cfg802154: Replace zero-length array with
 flexible-array member
Message-ID: <20200228135959.GA30464@embeddedor>
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
X-Exim-ID: 1j7g8X-001adL-6K
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.240.44]:3402
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 71
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
 include/net/cfg802154.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
index 6f86073a5d7d..6ed07844eb24 100644
--- a/include/net/cfg802154.h
+++ b/include/net/cfg802154.h
@@ -214,7 +214,7 @@ struct wpan_phy {
 	/* the network namespace this phy lives in currently */
 	possible_net_t _net;
 
-	char priv[0] __aligned(NETDEV_ALIGN);
+	char priv[] __aligned(NETDEV_ALIGN);
 };
 
 static inline struct net *wpan_phy_net(struct wpan_phy *wpan_phy)
-- 
2.25.0

