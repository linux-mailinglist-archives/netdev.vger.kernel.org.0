Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF19D157D3B
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 15:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgBJOPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 09:15:23 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:46911 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgBJOPW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 09:15:22 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ca70e53b;
        Mon, 10 Feb 2020 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=6IxQnhqna6P4699fOE6/+Cvkl
        kY=; b=n3YLXU6/2CaDkap5U1etT7L3ak89C7TzxvaDWZ2GngD7B0yTMNq5mLlub
        k8N7WykBPk8ICvxijVB3c5eRDnqYnTNrpYYA91Glu4/voDc+M1hQPD85HULncPuf
        5yCrUMYqVCmYbk8ypOcbH7P8FskaNIJLsd7LcvWtBrTDK+YgTc2hemc9zVhwJuxa
        akdfAdzgkXxFWoTNqn+L27t2yWzJ41uIadX+z7OUBDhP/ShVmxTX+ANxTqy8oMhV
        f09xc1uMnX0H5/tF+eEcs2gWujW/nh8QC95emSJvAXvBqvSwlon8aXk9Oo+27wzW
        nOEDAFUND2Dx5/eQAIoLYyGYq2hVQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 97722a5e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 10 Feb 2020 14:13:44 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Shannon Nelson <shannon.nelson@oracle.com>
Subject: [PATCH v2 net 3/5] sunvnet: use icmp_ndo_send helper
Date:   Mon, 10 Feb 2020 15:14:21 +0100
Message-Id: <20200210141423.173790-4-Jason@zx2c4.com>
In-Reply-To: <20200210141423.173790-1-Jason@zx2c4.com>
References: <20200210141423.173790-1-Jason@zx2c4.com>
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

