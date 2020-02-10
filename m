Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EBE157D3A
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 15:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgBJOPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 09:15:24 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:46911 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgBJOPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 09:15:23 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c3f22eda;
        Mon, 10 Feb 2020 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=l05ky+REA+M+7GRJvz85D2lrR
        VQ=; b=UyrABgfnhkcYV6+Pe0ZeBhUo3jqU2lBhynHdrmkjN0VXaAWdxVALYg6WA
        tC1qGv52toLOjvShNq8534eKu0j1TnUTZTw/MBg3v/B2LTd32yDYofiCBgy8jEV0
        fWJqTZnRx+Zg7LegJMKnsfSLgUMA5yx+GP04GowHWVMtS5XwXqCFM+Qfzdi4DPy3
        J3PY89qHS2cyg5NZAp3GBB8YSyHlV++otg1wZRgdaKB2be3DDpV+avLzEtbRdtBf
        GGjmNfT8sYD8m6L/e46MUrsac596RkmxhbqpEK6ttGII/v2Jfm/e/ovtyJXdRDuW
        0WDGJkP41ESmeiyNPoAsBAdhUFPxw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e597b062 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 10 Feb 2020 14:13:46 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2 net 4/5] wireguard: use icmp_ndo_send helper
Date:   Mon, 10 Feb 2020 15:14:22 +0100
Message-Id: <20200210141423.173790-5-Jason@zx2c4.com>
In-Reply-To: <20200210141423.173790-1-Jason@zx2c4.com>
References: <20200210141423.173790-1-Jason@zx2c4.com>
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

