Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0165018A9D0
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgCSAa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:30:56 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:39393 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCSAaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 20:30:55 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bf45f4c4;
        Thu, 19 Mar 2020 00:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=LFpBGwNRgFHGa/caMU+O/krcQ
        xk=; b=qSpAdg8qiGQBTilxRdDjFwwC+GB/8pp90ogTxiZAQFzon4fvMQldJyXEI
        r5xIiUoK2hLtHrFwqG3op2AlmY9eGqudkls4/WTmQgu4p+0wrDNYXE5n+KmcOuQR
        tsMGDDK8r8MblI1KqMAzj8Kf9fQlvg42ZxcPD6UjhMkl17NIAy4BufWwdlBehhe+
        fABFVYtF03pTHT9rsjp3cELl5XbvskVBzav0fIbi/dr9WM8JAJZ1Xo4faYecWnuq
        VDUyIG56apbmVZ2DY7yvgh2F9+3VnZRC2tTVwuzfaQ2DkrsPt0byaLufLoUJM+O9
        OphFZs0a2CaC8dnM72fxglNq2g39g==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 764842ee (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Mar 2020 00:24:28 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 4/5] wireguard: receive: remove dead code from default packet type case
Date:   Wed, 18 Mar 2020 18:30:46 -0600
Message-Id: <20200319003047.113501-5-Jason@zx2c4.com>
In-Reply-To: <20200319003047.113501-1-Jason@zx2c4.com>
References: <20200319003047.113501-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The situation in which we wind up hitting the default case here
indicates a major bug in earlier parsing code. It is not a usual thing
that should ever happen, which means a "friendly" message for it doesn't
make sense. Rather, replace this with a WARN_ON, just like we do earlier
in the file for a similar situation, so that somebody sends us a bug
report and we can fix it.

Reported-by: Fabian Freyer <fabianfreyer@radicallyopensecurity.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/receive.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 243ed7172dd2..da3b782ab7d3 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -587,8 +587,7 @@ void wg_packet_receive(struct wg_device *wg, struct sk_buff *skb)
 		wg_packet_consume_data(wg, skb);
 		break;
 	default:
-		net_dbg_skb_ratelimited("%s: Invalid packet from %pISpfsc\n",
-					wg->dev->name, skb);
+		WARN(1, "Non-exhaustive parsing of packet header lead to unknown packet type!\n");
 		goto err;
 	}
 	return;
-- 
2.25.1

