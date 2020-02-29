Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D2617440F
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 02:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgB2BEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 20:04:07 -0500
Received: from gateway20.websitewelcome.com ([192.185.69.18]:12071 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgB2BEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 20:04:07 -0500
X-Greylist: delayed 918 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2020 20:04:06 EST
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 0062C4012986A
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 17:49:39 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7qY2jXqayRP4z7qY2jwAIv; Fri, 28 Feb 2020 19:04:06 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vvupL0C0NS9tkoKlwv3g8aYAD+hhxqruyG0GLjGtntI=; b=v0aKr7r6gdPxVVp8v4Me+VFpon
        LGCJeChvsl7MqZYZPjVhj6za2m25Cv3nMW9RTqoswNR3m81ztAIu3S2iLnNHyfzra/2kEc+DorOjw
        k7WZjB2DsQ752gKgpbQVmBoKDtBjKalaRHzd1bXM3oXNE+MPO6PXm0jNDzQJ+cAx+UwMXsIwxadzS
        fdzPP1Qi7eyfNIRA2wtd74maw4UhUVaxhjm7zGhTk2IWFl9RSH0zrUSlDl+g9VFS8Hrfmo/eC4icv
        dgEZ54YPPq5Rk48BbtuwwJGYXQJdot/IEl4IRGjBos92b+FyWb3pzamufRik0ToBfgOYJtpYuIhqQ
        Y0IVbZ8g==;
Received: from [200.39.15.57] (port=19448 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7qY0-0032Jb-Dw; Fri, 28 Feb 2020 19:04:04 -0600
Date:   Fri, 28 Feb 2020 19:07:01 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] arcnet: Replace zero-length array with flexible-array
 member
Message-ID: <20200229010701.GA9883@embeddedor>
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
X-Exim-ID: 1j7qY0-0032Jb-Dw
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.39.15.57]:19448
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
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
 include/uapi/linux/if_arcnet.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if_arcnet.h b/include/uapi/linux/if_arcnet.h
index 683878036d76..b122cfac7128 100644
--- a/include/uapi/linux/if_arcnet.h
+++ b/include/uapi/linux/if_arcnet.h
@@ -60,7 +60,7 @@ struct arc_rfc1201 {
 	__u8  proto;		/* protocol ID field - varies		*/
 	__u8  split_flag;	/* for use with split packets		*/
 	__be16   sequence;	/* sequence number			*/
-	__u8  payload[0];	/* space remaining in packet (504 bytes)*/
+	__u8  payload[];	/* space remaining in packet (504 bytes)*/
 };
 #define RFC1201_HDR_SIZE 4
 
@@ -69,7 +69,7 @@ struct arc_rfc1201 {
  */
 struct arc_rfc1051 {
 	__u8 proto;		/* ARC_P_RFC1051_ARP/RFC1051_IP	*/
-	__u8 payload[0];	/* 507 bytes			*/
+	__u8 payload[];	/* 507 bytes			*/
 };
 #define RFC1051_HDR_SIZE 1
 
@@ -80,7 +80,7 @@ struct arc_rfc1051 {
 struct arc_eth_encap {
 	__u8 proto;		/* Always ARC_P_ETHER			*/
 	struct ethhdr eth;	/* standard ethernet header (yuck!)	*/
-	__u8 payload[0];	/* 493 bytes				*/
+	__u8 payload[];	/* 493 bytes				*/
 };
 #define ETH_ENCAP_HDR_SIZE 14
 
-- 
2.25.0

