Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C024CE764
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 23:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232707AbiCEWON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 17:14:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiCEWOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 17:14:10 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C25522C6
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 14:13:18 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646518397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z9PNgvP8TGwygrt5YPHFKcckZNRFvMHdr0LA7AKXEoA=;
        b=4i6hN2WRdEVgBdElFrebDTDo35xNm8KfCYU7LEaVzub+5YSOhC1Au9+dIiRf4LT69yrEIy
        TabJuYXhm0LVosdjLWCG8IgkgUx+IKZoRhMErA1904ps4TQLzFky4b4f81OCz5MrcDQCh7
        kilY4qfQ6w57XqYlcRij1XajfUg67+6CaCNttddT6GWiwwAmbWUySjicQ9UvpykqelXf2A
        gD3I9mZMkdumu32sB0/pi0RQX3pPTAQtkXcJWxhfe6mY45bFuQSchPA04y/lYfKNpcE04n
        RCtId/cyDfyEytIraFgVwAPIsC+RsTGTHGfVvDtcWzFYHKpiYydfXajZWlNEMA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646518397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z9PNgvP8TGwygrt5YPHFKcckZNRFvMHdr0LA7AKXEoA=;
        b=MkxmGiOm7DqJoxdtTEdDc8Uj/Sf9McYrlLOROEAp3pz5vVHWFsmP/iOnzDgWRVV848t1eq
        kWi0RZ7T29sjUHDw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 4/8] slip/plip: Use netif_rx().
Date:   Sat,  5 Mar 2022 23:12:48 +0100
Message-Id: <20220305221252.3063812-5-bigeasy@linutronix.de>
In-Reply-To: <20220305221252.3063812-1-bigeasy@linutronix.de>
References: <20220305221252.3063812-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit
   baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any co=
ntext.")

the function netif_rx() can be used in preemptible/thread context as
well as in interrupt context.

Use netif_rx().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/plip/plip.c | 2 +-
 drivers/net/slip/slip.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 0d491b4d66675..dafd3e9ebbf87 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -676,7 +676,7 @@ plip_receive_packet(struct net_device *dev, struct net_=
local *nl,
 	case PLIP_PK_DONE:
 		/* Inform the upper layer for the arrival of a packet. */
 		rcv->skb->protocol=3Dplip_type_trans(rcv->skb, dev);
-		netif_rx_ni(rcv->skb);
+		netif_rx(rcv->skb);
 		dev->stats.rx_bytes +=3D rcv->length.h;
 		dev->stats.rx_packets++;
 		rcv->skb =3D NULL;
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 98f586f910fb1..88396ff99f03f 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -368,7 +368,7 @@ static void sl_bump(struct slip *sl)
 	skb_put_data(skb, sl->rbuff, count);
 	skb_reset_mac_header(skb);
 	skb->protocol =3D htons(ETH_P_IP);
-	netif_rx_ni(skb);
+	netif_rx(skb);
 	dev->stats.rx_packets++;
 }
=20
--=20
2.35.1

