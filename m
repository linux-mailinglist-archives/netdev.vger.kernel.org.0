Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B27F815926E
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgBKPAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:00:49 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:34135 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgBKPAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 10:00:49 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id dd66e016;
        Tue, 11 Feb 2020 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=JzV6toZzstw9vzB/ziu+YJh5G
        mY=; b=dovs/oz2vUL3klrd1VlAbhcgO9Iz0Zo6IoF576bOZEQtWLc8IfPDhH2vk
        zlllqR2eK//rIsfPHYSdxi8oTRKXfnlerEh1GFT5ILy7fgJbMj6uuA2f4vWEsUP0
        5Xmc8ERs3FmVGVjANcjmOAEyjy5K8p5znhjbOHLJLhHUcO2lfY58FfJw5xYeiV3b
        eHazUCL3Na/pA+wQ+P4c6Gsok4Gm1S10jXMqMMH9fvyXG21/da13JovqFsDXPVsr
        LnsmpRkxevkzhcP/nYx9DESj4iyBYJVNVmq39iUWikY15DL+iyLfRueEH9XISDXu
        jRY4jewcpObkNkZwaciEZLlZtTBPg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 51f42231 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 14:59:03 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Harald Welte <laforge@gnumonks.org>
Subject: [PATCH v3 net 2/9] gtp: use icmp_ndo_send helper
Date:   Tue, 11 Feb 2020 16:00:21 +0100
Message-Id: <20200211150028.688073-3-Jason@zx2c4.com>
In-Reply-To: <20200211150028.688073-1-Jason@zx2c4.com>
References: <20200210141423.173790-2-Jason@zx2c4.com>
 <20200211150028.688073-1-Jason@zx2c4.com>
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

