Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76B7159A07
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731679AbgBKTrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:47:37 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52685 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728843AbgBKTrh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 14:47:37 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b3c86b54;
        Tue, 11 Feb 2020 19:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=wfT3X7qXqNUU0/0EQjnwE4gcH
        QY=; b=kGfPYgI7khpGxqrgvKyOGHqF0lGCviqfszWdwuieFH6l41wtG5s5Kl3AR
        Ix6fbuk/2GGPbIHh2QNc01I0vw96ARsi+5D3Q+4wKP2u5aGcDUemn41vViih+avn
        wX+F20HNzgnZ89vgsVW1PZ+BwKSvK6DFZUbP38mQVzhRSIAxZ7MLcDaIJddhUaky
        Xe2c10DIfAtXpU3RCarAv+KMGOIMMIMr/gy452hHxX2E0HwMrz2Tap7BwIbXjFXj
        yvwXKucj116ddU3LnWdGDHrzCdrtXIkw0sANJW36jfIi0x8ePt8+US2OKCddZTbF
        ZpbrSeSlQzwpo0BGsF33fWKGqhHIg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0d49104b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 19:45:48 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH v4 net 5/5] xfrm: interface: use icmp_ndo_send helper
Date:   Tue, 11 Feb 2020 20:47:09 +0100
Message-Id: <20200211194709.723383-6-Jason@zx2c4.com>
In-Reply-To: <20200211194709.723383-1-Jason@zx2c4.com>
References: <20200211194709.723383-1-Jason@zx2c4.com>
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

