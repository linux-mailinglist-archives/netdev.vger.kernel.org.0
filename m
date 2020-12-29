Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DD12E6F33
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 09:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgL2I6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 03:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgL2I6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 03:58:11 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B45C0613D6
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 00:57:31 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id jx16so17243494ejb.10
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 00:57:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=4BKDQFRNAHSeOiyru8NytyDNhN1pLBHkEktSKiJ9/eM=;
        b=G/h+pxLI8fC0vF9qZ2BamshTMZRIb10sv7TPlWPbKTa7fbqyFrU80MZp+BI1Myocr7
         SbX+ynagiRXOsywbCA8y7/1j1plZ0/9aiuoOUAskm+EI4VBclQ80q5qEJb6LH+eClt6H
         4TGwOZq3VagByzQ3MtQ+vDT85kZpFGC838PxYx21W9TtzGNuCKmSZgL4EpT0px7e50TP
         A7JAU44aL/ctTdVH2WEb5S5JSHA86J9ZzjlwfhBL8C9gNV/uk4LQ4Iq4TUFxRhGxTiuq
         doiKtkWwwZVhBbE8c5SWAif0MuWZSwSIiyAb3SL+FVx9j7dy2Qa6GP6tJ0WJRPpfDjXK
         wwxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4BKDQFRNAHSeOiyru8NytyDNhN1pLBHkEktSKiJ9/eM=;
        b=oLhi8yYmMUYeFg4uHC+C3u37TvO1BC00jDUsexLpSik3HN5/YjawY+DolO3oKSeu3H
         vJ6LwAwVynSQrNLR8VXBEKwBPaJWRutjr05U559Dvh1QwR3ikK3A/aoU2+B7FF4FnXAl
         KutWH6CN26chiy6bHZmehclIFBCa4O6WRcpLTqXPlrt6iwGb80RM20v8Z2zPVkWQkhKG
         Ov5grbtqhuoq7DIYzVel0flfFzcQmGUzCW6978S0RcD3Zi0YFQRdA+u41Y5T4YfQGxWI
         ioL0vPgRiiCDrthwCh7SRHGBCw7kzafChGYpnRB5UMP3xHRLy0nYFUFlrXqOkQ1wuSih
         ssAg==
X-Gm-Message-State: AOAM530li+a6E1sYY77ZK35J9F8WIREfroVY1Vgdvsj1JW8Aj4MsmUVQ
        9QaDhiYkYgjqS3lsBvu+iQOt6A==
X-Google-Smtp-Source: ABdhPJwzjWZO5gmcLJrmYGSFXtvIcT2ebYIUB4xMQUgzFF9mMmXGpTZzCHSxD5+9EEF8UkCsWUBxHA==
X-Received: by 2002:a17:907:111c:: with SMTP id qu28mr44302617ejb.540.1609232250139;
        Tue, 29 Dec 2020 00:57:30 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:6f69:290a:2b46:b9])
        by smtp.gmail.com with ESMTPSA id j3sm11782680eja.2.2020.12.29.00.57.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Dec 2020 00:57:29 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3] net: mhi: Add raw IP mode support
Date:   Tue, 29 Dec 2020 10:04:54 +0100
Message-Id: <1609232694-10858-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MHI net is protocol agnostic, the payload protocol depends on the modem
configuration, which can be either RMNET (IP muxing and aggregation) or
raw IP. This patch adds support for incomming IPv4/IPv6 packets, that
was previously unconditionnaly reported as RMNET packets.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi_net.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index e3f9c0d..478e78f 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -121,7 +121,7 @@ static const struct net_device_ops mhi_netdev_ops = {
 static void mhi_net_setup(struct net_device *ndev)
 {
 	ndev->header_ops = NULL;  /* No header */
-	ndev->type = ARPHRD_NONE; /* QMAP... */
+	ndev->type = ARPHRD_RAWIP;
 	ndev->hard_header_len = 0;
 	ndev->addr_len = 0;
 	ndev->flags = IFF_POINTOPOINT | IFF_NOARP;
@@ -157,7 +157,18 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 		u64_stats_add(&mhi_netdev->stats.rx_bytes, mhi_res->bytes_xferd);
 		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
 
-		skb->protocol = htons(ETH_P_MAP);
+		switch (skb->data[0] & 0xf0) {
+		case 0x40:
+			skb->protocol = htons(ETH_P_IP);
+			break;
+		case 0x60:
+			skb->protocol = htons(ETH_P_IPV6);
+			break;
+		default:
+			skb->protocol = htons(ETH_P_MAP);
+			break;
+		}
+
 		skb_put(skb, mhi_res->bytes_xferd);
 		netif_rx(skb);
 	}
-- 
2.7.4

