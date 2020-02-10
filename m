Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61AE157D3C
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 15:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgBJOP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 09:15:27 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:46911 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbgBJOP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 09:15:26 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 00978ed8;
        Mon, 10 Feb 2020 14:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=wfT3X7qXqNUU0/0EQjnwE4gcH
        QY=; b=BgH17Baw9mm7gtUdQ6q0Floaw0Z45PT3ip3MEiicUt3DEaZXBopaDoc8N
        DJ7jZIsKpWNeJ8ujbnV90qKBmxR56sFIyrCw+zHn9bk7osSQEERRmnSvs9awF390
        CEdhB2dQwFvK7GZdxfA9UGZcD9Td3K/rtZLcdWD9B2p5Old0xSWuZr4C5mAhuQ9k
        OdoJwQMGSLf8mK/KIGXxwzFmXmLoapujMcB85PS/B2QaHq5r8XVASK8uu2nVGfQ3
        b05loncOVxxJ+ZNGkwovxnUBF8K4LxAl7NaP4zpvNT6Izdq1TlFYX+FAu2gsz2JI
        tWKLgsoBkwHECP50QM/B1cIlKykdQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 50f5887d (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 10 Feb 2020 14:13:48 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v2 net 5/5] xfrm: interface: use icmp_ndo_send helper
Date:   Mon, 10 Feb 2020 15:14:23 +0100
Message-Id: <20200210141423.173790-6-Jason@zx2c4.com>
In-Reply-To: <20200210141423.173790-1-Jason@zx2c4.com>
References: <20200210141423.173790-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because xfrmi is calling icmp from network device context, it should use
the ndo helper so that the rate limiting applies correctly.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index dc651a628dcf..3361e3ac5714 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -300,10 +300,10 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 			if (mtu < IPV6_MIN_MTU)
 				mtu = IPV6_MIN_MTU;
 
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
 		} else {
-			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-				  htonl(mtu));
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+				      htonl(mtu));
 		}
 
 		dst_release(dst);
-- 
2.25.0

