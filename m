Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBFE7156AE1
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 15:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgBIOcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 09:32:05 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:50091 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727707AbgBIOcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Feb 2020 09:32:04 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id cf90af9c;
        Sun, 9 Feb 2020 14:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=l05ky+REA+M+7GRJvz85D2lrR
        VQ=; b=u6Xc1NWCIsJSF3qV4hMNCm7H7D0NVIxpMjgmaOcfez7t55pOkGNcdOOVJ
        5zikRBS7ndYU3ky9U4RCpxgZTfcmrrfvNeqWMGY7SyeKgbxvo/Ji+E2+0jp63rZb
        lnBBbMNB7bNnWj40MYGFOqAW8MsENuVOazgCUeSfsa5f2oeB+APfBEg4YmKxFSGK
        JZ3pCA0sLi8tIzqbxaAhFmnduOU1SurnoID6PGSPFo64MnX3KjQeNNgYPKmgLexZ
        M4BirMtEA3xSduhNSbKINx9uP0+AwHDhakO/mR+w3Zs0nzriDvE/FRQlMcNi/m2l
        0LqRv5w5cSiuVUDrDPiBiiFVCnKCQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ac609492 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 9 Feb 2020 14:30:33 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 4/5] wireguard: use icmp_ndo_send helper
Date:   Sun,  9 Feb 2020 15:31:42 +0100
Message-Id: <20200209143143.151632-4-Jason@zx2c4.com>
In-Reply-To: <20200209143143.151632-1-Jason@zx2c4.com>
References: <20200209143143.151632-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because wireguard is calling icmp from network device context, it should use
the ndo helper so that the rate limiting applies correctly.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 16b19824b9ad..43db442b1373 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -203,9 +203,9 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 err:
 	++dev->stats.tx_errors;
 	if (skb->protocol == htons(ETH_P_IP))
-		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
+		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
 	else if (skb->protocol == htons(ETH_P_IPV6))
-		icmpv6_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH, 0);
+		icmpv6_ndo_send(skb, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH, 0);
 	kfree_skb(skb);
 	return ret;
 }
-- 
2.25.0

