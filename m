Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4862159A04
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731094AbgBKTrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:47:31 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52685 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729525AbgBKTr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 14:47:29 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6b9363c0;
        Tue, 11 Feb 2020 19:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=JzV6toZzstw9vzB/ziu+YJh5G
        mY=; b=P2ychzB1fiPpHbKLH5pu3loY8Fdgy1/VeuQN9mRxc4/Y2chhz3n8aXP0N
        3XH29lQRMIpwnaDTQFP1rfZMIQSWVbwjeHirTpGeKym62d0VHo90RR3kjUB9QPDX
        m1w7BVuZBihtJevm6XKMSFaW5LBUV3jaQbPrv6bGzZ3nbcsM9YSlYDIsMf4RQ7Mt
        4YDkQOz9juORcDjTsXRJq+3NW2lE5pWe7N1lOjC6m1q82OuKA40/BjOzY9/ZBlru
        Fyr9V+coNxRKLV+P4EkJfVeb9eYisP4ytWzbL6S7liBZS1BHvhJFkFKyLr+rXN0O
        zVuM6dgWcLBZrV+MZvy8Mw7oV7jNA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cd5744c0 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 19:45:43 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Harald Welte <laforge@gnumonks.org>
Subject: [PATCH v4 net 2/5] gtp: use icmp_ndo_send helper
Date:   Tue, 11 Feb 2020 20:47:06 +0100
Message-Id: <20200211194709.723383-3-Jason@zx2c4.com>
In-Reply-To: <20200211194709.723383-1-Jason@zx2c4.com>
References: <20200211194709.723383-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because gtp is calling icmp from network device context, it should use
the ndo helper so that the rate limiting applies correctly.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index af07ea760b35..672cd2caf2fb 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -546,8 +546,8 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 	    mtu < ntohs(iph->tot_len)) {
 		netdev_dbg(dev, "packet too big, fragmentation needed\n");
 		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
-		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
-			  htonl(mtu));
+		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
+			      htonl(mtu));
 		goto err_rt;
 	}
 
-- 
2.25.0

