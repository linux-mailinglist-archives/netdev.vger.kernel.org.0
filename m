Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B54FA156ADD
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 15:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgBIOcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 09:32:01 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:50091 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbgBIOcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Feb 2020 09:32:01 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 390d1be5;
        Sun, 9 Feb 2020 14:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=rf9rKvRL4CbLATzMEqkECuQxf
        ZA=; b=RH0srbom4kXp+qL16lGxIQB/liuBAd3wa0SfhzkfXOs9AXq6ZQaIqiwTj
        cS5iGW/kTWTx5Atl5NYJyMqoBMp9agq4paoILC8pKeNEwn5+LW54GgxxfUsPUbyn
        jiq8xZZSasjRMb+QH14jlj4jRwdKJQBr06/xm8Rwk7/5sWOJF18ac9UTo0Q9bqz9
        cjrVk5aklSdp0PCjpKh/X1NsEDLBHAWmHzRIh03scQY7Asm2G+6llwwl1fcmbnWR
        IYrO1WeMhgm66lefycg+MLjNyKEREyOHX0UIy9MJbNXt661rDPYhJXcer35fd0Xi
        cwtgTsvzQDknCjziHSdTpzyzrs8hA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b547cfa0 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 9 Feb 2020 14:30:32 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Shannon Nelson <shannon.nelson@oracle.com>
Subject: [PATCH net 3/5] sunvnet: use icmp_ndo_send helper
Date:   Sun,  9 Feb 2020 15:31:41 +0100
Message-Id: <20200209143143.151632-3-Jason@zx2c4.com>
In-Reply-To: <20200209143143.151632-1-Jason@zx2c4.com>
References: <20200209143143.151632-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because sunvnet is calling icmp from network device context, it should use
the ndo helper so that the rate limiting applies correctly.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Shannon Nelson <shannon.nelson@oracle.com>
---
 drivers/net/ethernet/sun/sunvnet_common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index c23ce838ff63..9948c00fe625 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1363,14 +1363,14 @@ sunvnet_start_xmit_common(struct sk_buff *skb, struct net_device *dev,
 			rt = ip_route_output_key(dev_net(dev), &fl4);
 			if (!IS_ERR(rt)) {
 				skb_dst_set(skb, &rt->dst);
-				icmp_send(skb, ICMP_DEST_UNREACH,
-					  ICMP_FRAG_NEEDED,
-					  htonl(localmtu));
+				icmp_ndo_send(skb, ICMP_DEST_UNREACH,
+					      ICMP_FRAG_NEEDED,
+					      htonl(localmtu));
 			}
 		}
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (skb->protocol == htons(ETH_P_IPV6))
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, localmtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, localmtu);
 #endif
 		goto out_dropped;
 	}
-- 
2.25.0

