Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66C54CEE0F
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiCFV7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiCFV67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:58:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DC41EAE2
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 13:58:06 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646603883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uz2IIPVuQKx3/pILSWn2S3QDmjUlhowGxJ2Zh1uUMFI=;
        b=2xiEY5r1xWUPLU1Ez7MHaa7p+BlM+YQrythV/rPkE+xzTr2NV7XaUzXDOs4EOGbMjHRIwc
        0QBPE5yIiGanmcTpUXAIpZHacz3qRADeAa82Ei4wyoWISrm0hbidneJokp7dDdfOTQnJfD
        T7EhV34NLpwitsLGD7ThDN1sVhuxIlieclBmVKhg538e7bdBXoN3kQkginY8eEuIYS0S9k
        z4wcCYyop1z1T1VMoRV1RWOhwuHOkwEbPHUImNexwV09SPVOVedEK98BqVa5DBEr6Wgpo3
        Uj0saDhhN2SyUIEm5z+SHlWUMWAb8l4XDgT/e+oPDdz0hdDVGon2XKlC7162Qg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646603883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uz2IIPVuQKx3/pILSWn2S3QDmjUlhowGxJ2Zh1uUMFI=;
        b=yAUAfeynSwNpESFRooUndNnL9K2soJd3M0YjFPwt3h3ofzI9wPabZ2GIRSiKeeoGQZ3iIQ
        xjtqBHzvSC/aUMAQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Divya Koppera <Divya.Koppera@microchip.com>
Subject: [PATCH net-next 08/10] net: phy: micrel: Use netif_rx().
Date:   Sun,  6 Mar 2022 22:57:51 +0100
Message-Id: <20220306215753.3156276-9-bigeasy@linutronix.de>
In-Reply-To: <20220306215753.3156276-1-bigeasy@linutronix.de>
References: <20220306215753.3156276-1-bigeasy@linutronix.de>
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

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Divya Koppera <Divya.Koppera@microchip.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/phy/micrel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 81a76322254c5..cbae1524a420f 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2045,7 +2045,7 @@ static bool lan8814_match_rx_ts(struct kszphy_ptp_pri=
v *ptp_priv,
 		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
 		shhwtstamps->hwtstamp =3D ktime_set(rx_ts->seconds,
 						  rx_ts->nsec);
-		netif_rx_ni(skb);
+		netif_rx(skb);
=20
 		list_del(&rx_ts->list);
 		kfree(rx_ts);
@@ -2398,7 +2398,7 @@ static bool lan8814_match_skb(struct kszphy_ptp_priv =
*ptp_priv,
 		shhwtstamps =3D skb_hwtstamps(skb);
 		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
 		shhwtstamps->hwtstamp =3D ktime_set(rx_ts->seconds, rx_ts->nsec);
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
=20
 	return ret;
--=20
2.35.1

