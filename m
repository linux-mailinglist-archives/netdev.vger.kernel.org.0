Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE87161D05
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgBQWCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:02:42 -0500
Received: from gateway23.websitewelcome.com ([192.185.48.104]:14870 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbgBQWCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 17:02:39 -0500
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 26E6D4D33
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 15:40:20 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 3o7ojqPi3RP4z3o7ojH0hP; Mon, 17 Feb 2020 15:40:20 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Up3NXkZ9MtOum0S7bVKL3huOyiNJmhlgLtMxveQ6vXs=; b=fQRsoHfiS305ia7mB6Tk7BCDh/
        zu8WsjITjAx40ENo5SGDIPWQAysvcReMoY1px5no4omSD8BUVo+NaTDaafIhYlocD9N2uhjf129cn
        q0LrXgtBRbkzJYjXJ5febzafT1u6lqfyUVKdIkDfNQaGdjCGxWnwYObZn+SMeBVTO+xO5+UsOgntB
        SUD4DLY8MuqHtf5wrhfWuTpdfgHWmUnDQ8/voYHayRkfOjtIKD4VOmLHOsm1sDkVCxG/hxiIk1r7b
        1ZsQSv8vO8GDPS5aWRsW0yXwDR4pHyPBTbPq6F4TZltM4pCR5sOSQ6mLRLRAqxOxlL3kIdTOAInYL
        nPOEal+w==;
Received: from [200.68.140.26] (port=16142 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j3o7m-001GXx-EB; Mon, 17 Feb 2020 15:40:18 -0600
Date:   Mon, 17 Feb 2020 15:43:00 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] batman-adv: Replace zero-length array with
 flexible-array member
Message-ID: <20200217214300.GA14129@embeddedor>
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
X-Exim-ID: 1j3o7m-001GXx-EB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.26]:16142
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 9
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
 net/batman-adv/distributed-arp-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index 3d21dd83f8cc..b85da4b7a77b 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -88,7 +88,7 @@ struct batadv_dhcp_packet {
 	__u8 sname[64];
 	__u8 file[128];
 	__be32 magic;
-	__u8 options[0];
+	__u8 options[];
 };
 
 #define BATADV_DHCP_YIADDR_LEN sizeof(((struct batadv_dhcp_packet *)0)->yiaddr)
-- 
2.25.0

