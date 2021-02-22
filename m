Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7DD321D01
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhBVQ3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:29:43 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:60986 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231615AbhBVQ2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 11:28:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614011162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iys7Zy8lEPOpQwY9fqMEdYkFEKZRM2Rey0ir2dZq0gU=;
        b=S+HX8SB7MjZydRm0jDEeQaB90c8/pW+0qUIiL8MWz4UtXKZ0wpLVSiZZvzAPC9qTt5oid1
        3MP6NNn6/T99hZHRxv7RrMrzzfHFZ7Q3M//zogdugt/L4lAM0QztjhTFlMoYv7YVMEFTXt
        lFsechFAjT8dhrBP2s8KK4EEtcHaK+s=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3d0a66d4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 22 Feb 2021 16:26:02 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH net 5/7] wireguard: device: do not generate ICMP for non-IP packets
Date:   Mon, 22 Feb 2021 17:25:47 +0100
Message-Id: <20210222162549.3252778-6-Jason@zx2c4.com>
In-Reply-To: <20210222162549.3252778-1-Jason@zx2c4.com>
References: <20210222162549.3252778-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If skb->protocol doesn't match the actual skb->data header, it's
probably not a good idea to pass it off to icmp{,v6}_ndo_send, which is
expecting to reply to a valid IP packet. So this commit has that early
mismatch case jump to a later error label.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/device.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index cd51a2afa28e..8502e1b083ff 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -138,7 +138,7 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 		else if (skb->protocol == htons(ETH_P_IPV6))
 			net_dbg_ratelimited("%s: No peer has allowed IPs matching %pI6\n",
 					    dev->name, &ipv6_hdr(skb)->daddr);
-		goto err;
+		goto err_icmp;
 	}
 
 	family = READ_ONCE(peer->endpoint.addr.sa_family);
@@ -201,12 +201,13 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 
 err_peer:
 	wg_peer_put(peer);
-err:
-	++dev->stats.tx_errors;
+err_icmp:
 	if (skb->protocol == htons(ETH_P_IP))
 		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
 	else if (skb->protocol == htons(ETH_P_IPV6))
 		icmpv6_ndo_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH, 0);
+err:
+	++dev->stats.tx_errors;
 	kfree_skb(skb);
 	return ret;
 }
-- 
2.30.1

