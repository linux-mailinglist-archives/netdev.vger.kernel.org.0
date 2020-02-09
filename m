Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5758B156AE2
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 15:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBIOcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 09:32:06 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:50091 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727784AbgBIOcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Feb 2020 09:32:05 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 8c84ce3f;
        Sun, 9 Feb 2020 14:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=wfT3X7qXqNUU0/0EQjnwE4gcH
        QY=; b=XfSLWJP93VNOn4AO6xAeKWmMReuP+xW/cnPOzccBpIcqaXeNLYwjUzGQc
        mQA6ExsXhuC2a/fbqhjjX9v/A+2xNhBlY+HusFQ1AbFhcKPs/MuU7lP36CP1UAIU
        kkBdAjDOhqfOWpcyU7uxI/cb8q/cdtumT6rN8eoAYAcHHl+DRTMoqPLRC/Db43nb
        WK2AZxJPmx1x5p65TXwaKZwVYehkX1d3RA+DfoTieXJhup4D6aVYqN1GBpNeOA/9
        a/I1llPajZBwjNfJOVPQX96pJgFMagOr1dsnvc0zNMDjHrzfQ2yNE2595DqmjlJq
        GvtAsmk5FY8T8KfUhUCLRDtmY/LtQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 99debeb5 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 9 Feb 2020 14:30:35 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH net 5/5] xfrm: interface: use icmp_ndo_send helper
Date:   Sun,  9 Feb 2020 15:31:43 +0100
Message-Id: <20200209143143.151632-5-Jason@zx2c4.com>
In-Reply-To: <20200209143143.151632-1-Jason@zx2c4.com>
References: <20200209143143.151632-1-Jason@zx2c4.com>
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

