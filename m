Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D49156ADF
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 15:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgBIOcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 09:32:01 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:50091 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727514AbgBIOcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Feb 2020 09:32:00 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b67120f7;
        Sun, 9 Feb 2020 14:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=JzV6toZzstw9vzB/ziu+YJh5G
        mY=; b=OLKv/2b+aVhhwgl47Nx2vGuvO0KNl1ZtiLCEuQPqfOGeRHvppi87cD67/
        LGE4PLe+DMH3FF2Me9sdNv7LMLvl05iRoayjtB/gNF9A8OgokoNHHfnkNiR+03Tr
        0N3vzUyCDr+khqtMBORltzbG16W5DHuDFcHUGUvdtSM8j62oPObW/2VhqEcPJSUL
        29wFd0orhmGaeu/BNXrzitKdhOE6glKMFl+pnmLdU0VvE5miktemr80Arqc0crUs
        p/9h1+3eiubXqW3/efnilVldVaNYoKyv69ICHkfk/bNx2JZKLJzc8Kqdms+BsibP
        iAxIsTSNHgyTiRBDy1wI1wFUIFk9g==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3f9a9807 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Sun, 9 Feb 2020 14:30:30 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Harald Welte <laforge@gnumonks.org>
Subject: [PATCH net 2/5] gtp: use icmp_ndo_send helper
Date:   Sun,  9 Feb 2020 15:31:40 +0100
Message-Id: <20200209143143.151632-2-Jason@zx2c4.com>
In-Reply-To: <20200209143143.151632-1-Jason@zx2c4.com>
References: <20200209143143.151632-1-Jason@zx2c4.com>
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

