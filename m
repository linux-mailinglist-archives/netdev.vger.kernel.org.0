Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F6B31AD4C
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 18:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhBMRGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 12:06:05 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:52216 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMRGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 12:06:04 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1613235922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JJEOBuOjzmwW6/pSsqT7bNUyGEmlyOp1VIAaMUDaRVY=;
        b=DYW5HuEkpeCTBdAW7M31I45+ATB3cwn8OlDi6Oi+edM1Rcuwv3IP5iLB2pu0AEfycAwDMF
        wYtVIG5YcU5ujZLN/YoOKgj0W3TP08CLKkdaK8jLTPlMH+Tb44vBJA/1l6tJwy0/c0dBQZ
        /aRJp5ycXo0Ssv7tUGl87PQtkz+H4NkE1/5/89cz/khCL2IXjHAGOVXFH3QU5JFkBaybJJ
        7/+yO5slEnjqHACtsJ15F+5IXfvvLKH4UJtzXTP7FlHcBcSOOnsazPcghBR4aAY9IBiNDR
        fanOh0MA2UhvxUKnTjVttngaDtn5SUVEOFP0Vf/GOIiuyMhUSfHijGWHPivHsA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1613235922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JJEOBuOjzmwW6/pSsqT7bNUyGEmlyOp1VIAaMUDaRVY=;
        b=WOkik4hZMpQywf6iDBUy7u8wJiRRpdJ3dGamGYCXhtzJwxygq4Ytdu/1MMOl1QI7ea6Nhz
        0rMfBYXRGX0Rk2CQ==
To:     netdev@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next] net: caif: Use netif_rx_any_context().
Date:   Sat, 13 Feb 2021 18:05:14 +0100
Message-Id: <20210213170514.3092234-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The usage of in_interrupt() in non-core code is phased out. Ideally the
information of the calling context should be passed by the callers or the
functions be split as appropriate.

The attempt to consolidate the code by passing an arguemnt or by
distangling it failed due lack of knowledge about this driver and because
the call chains are hard to follow.

As a stop gap use netif_rx_any_context() which invokes the correct code path
depending on context and confines the in_interrupt() usage to core code.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/caif/chnl_net.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index 79b6a04d8eb61..fadc7c8a3107f 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -115,10 +115,7 @@ static int chnl_recv_cb(struct cflayer *layr, struct c=
fpkt *pkt)
 	else
 		skb->ip_summed =3D CHECKSUM_NONE;
=20
-	if (in_interrupt())
-		netif_rx(skb);
-	else
-		netif_rx_ni(skb);
+	netif_rx_any_context(skb);
=20
 	/* Update statistics. */
 	priv->netdev->stats.rx_packets++;
--=20
2.30.0

