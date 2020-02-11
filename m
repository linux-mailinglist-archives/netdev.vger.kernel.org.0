Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3073159A05
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731111AbgBKTrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:47:33 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52685 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731108AbgBKTrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 14:47:32 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c50135e5;
        Tue, 11 Feb 2020 19:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=6IxQnhqna6P4699fOE6/+Cvkl
        kY=; b=xOveijOXTkIEdHJN31LXPsz6zMxHiT/5NJ4MT7zNyReDn27GfbLbt9JP+
        N0C0vd3vdziwS+fDrgHBSGqdgJUSVT70ODgN0zTWX4mtO2hdGEoaL6TIaK0IKT7A
        R0Z/LSw2FAR+exGfR34VfFe2kay1ofqo+QZ26a+IGGbHt9MdVs/Ox6/PO5tSp8gt
        4+PR0XGxqy+qGCMYML1vIsH5q63v5D8cH1XpARdhuWU4Fl+r47yZY1RFDrlvurt+
        bJ3/Pj2mbxk78diOsmluQDlouVP2RculAFSMYpBSI48hdyNfXxtabuWjHl/16Ubj
        rb9UlcPUuoefozlDdQ5NWo5UC7MoQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9b6d0f0b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 19:45:44 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Shannon Nelson <shannon.nelson@oracle.com>
Subject: [PATCH v4 net 3/5] sunvnet: use icmp_ndo_send helper
Date:   Tue, 11 Feb 2020 20:47:07 +0100
Message-Id: <20200211194709.723383-4-Jason@zx2c4.com>
In-Reply-To: <20200211194709.723383-1-Jason@zx2c4.com>
References: <20200211194709.723383-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because sunvnet is calling icmp from network device context, it should use
the ndo helper so that the rate limiting applies correctly. While we're
at it, doing the additional route lookup before calling icmp_ndo_send is
superfluous, since this is the job of the icmp code in the first place.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Shannon Nelson <shannon.nelson@oracle.com>
---
 drivers/net/ethernet/sun/sunvnet_common.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index c23ce838ff63..8dc6c9ff22e1 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1350,27 +1350,12 @@ sunvnet_start_xmit_common(struct sk_buff *skb, struct net_device *dev,
 		if (vio_version_after_eq(&port->vio, 1, 3))
 			localmtu -= VLAN_HLEN;
 
-		if (skb->protocol == htons(ETH_P_IP)) {
-			struct flowi4 fl4;
-			struct rtable *rt = NULL;
-
-			memset(&fl4, 0, sizeof(fl4));
-			fl4.flowi4_oif = dev->ifindex;
-			fl4.flowi4_tos = RT_TOS(ip_hdr(skb)->tos);
-			fl4.daddr = ip_hdr(skb)->daddr;
-			fl4.saddr = ip_hdr(skb)->saddr;
-
-			rt = ip_route_output_key(dev_net(dev), &fl4);
-			if (!IS_ERR(rt)) {
-				skb_dst_set(skb, &rt->dst);
-				icmp_send(skb, ICMP_DEST_UNREACH,
-					  ICMP_FRAG_NEEDED,
-					  htonl(localmtu));
-			}
-		}
+		if (skb->protocol == htons(ETH_P_IP))
+			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+				      htonl(localmtu));
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (skb->protocol == htons(ETH_P_IPV6))
-			icmpv6_send(skb, ICMPV6_PKT_TOOBIG, 0, localmtu);
+			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, localmtu);
 #endif
 		goto out_dropped;
 	}
-- 
2.25.0

