Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5966157D39
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 15:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgBJOPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 09:15:21 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:46911 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgBJOPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Feb 2020 09:15:20 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 40660c54;
        Mon, 10 Feb 2020 14:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=JzV6toZzstw9vzB/ziu+YJh5G
        mY=; b=GNANlymw9Y3vA+xIyurrnFRwFlIA4mIlaALOcSpBdHVMwzu61vaeJZjJd
        9RqHWpEvbEwoY1CT/jequMOc8eeqqsVOM9Ei1KrkwnRqP9deZ3ki67h59vDH18so
        YrkmYOKHoPEa/Esgh+HyQwR7YUifLS8lPnE4k9oa5rHM92bf8tz1H5lXh7KH7ELU
        lyvtNDElIgIq4mF+vgV9HWzl5bk88IlnKMdFvegz4jFwhGyi9jr8k/MOdiA90HJF
        wBgCj/G0+arZJz3eVGx1rr4yhNNpdlg4PIOp7H5LPVGViWprxgaS99i62AqXqQv4
        10+UKMh7UrFJ8kge37YdbRCA4bu4g==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9fb1664a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 10 Feb 2020 14:13:42 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Harald Welte <laforge@gnumonks.org>
Subject: [PATCH v2 net 2/5] gtp: use icmp_ndo_send helper
Date:   Mon, 10 Feb 2020 15:14:20 +0100
Message-Id: <20200210141423.173790-3-Jason@zx2c4.com>
In-Reply-To: <20200210141423.173790-1-Jason@zx2c4.com>
References: <20200210141423.173790-1-Jason@zx2c4.com>
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

