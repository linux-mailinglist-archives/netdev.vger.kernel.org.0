Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5D24CEE0C
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 22:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiCFV7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 16:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbiCFV7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 16:59:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4701EAEE
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 13:58:06 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646603883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9iqhR7wOpt14o8SWxa1auGl70g18S7XMunJngf1hH6w=;
        b=4G1Pj9C2ssAnDu0dt9ay0bzrkLLTHZEGoPAG9gpy+OBiZKJOe8f7NIqe/sG/zNfQ6CR+a3
        QNviUe+qKnyuRiMjGXOCkVH2UpwCNw6OVjAwtn+r6CmYv2EC+HsOmVDsUpCtCXXcwqXK0x
        J+hf6/JOR2reUnc0p/8GIUxos37bFdsjrYKJyfROiEZEkibkM4RPbXD3/gy86TzXjTg5rV
        NtU4WOSS9LQNb44cL+rOoQdiQMiribA3jgFdhUSymwTVqjU3BkkpD4wBV3aCyYW3rIk1jO
        J/EcCVJCl/6dqGHeN9M9TZ6EHiB6fWqSkFhxk8brqnIX+tadr/QO3jbysuQJ3w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646603883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9iqhR7wOpt14o8SWxa1auGl70g18S7XMunJngf1hH6w=;
        b=cXqE1GNSEwbpSBnIlRMOIZsz5wur+bghVFzjOFPrHfeycTBphzw1nyROiR5QZJhCOmt0f5
        Ay+S3B3pTtkngWAQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Divya Koppera <Divya.Koppera@microchip.com>
Subject: [PATCH net-next 10/10] net: phy: micrel: Move netif_rx() outside of IRQ-off section.
Date:   Sun,  6 Mar 2022 22:57:53 +0100
Message-Id: <20220306215753.3156276-11-bigeasy@linutronix.de>
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

lan8814_match_rx_ts() invokes netif_rx() with disables interrupts
outside which will create a warning. Invoking netif_rx_ni() with
disabled interrupts is wrong even without the recent rework because
netif_rx_ni() would enable interrupts while processing the softirq. This
in turn can lead to dead lock if an interrupts triggers and attempts to
acquire kszphy_ptp_priv::rx_ts_lock.

Move netif_rx() outside the IRQ-off section.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Divya Koppera <Divya.Koppera@microchip.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/phy/micrel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index cbae1524a420f..ce3992383766d 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2045,8 +2045,6 @@ static bool lan8814_match_rx_ts(struct kszphy_ptp_pri=
v *ptp_priv,
 		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
 		shhwtstamps->hwtstamp =3D ktime_set(rx_ts->seconds,
 						  rx_ts->nsec);
-		netif_rx(skb);
-
 		list_del(&rx_ts->list);
 		kfree(rx_ts);
=20
@@ -2055,6 +2053,8 @@ static bool lan8814_match_rx_ts(struct kszphy_ptp_pri=
v *ptp_priv,
 	}
 	spin_unlock_irqrestore(&ptp_priv->rx_ts_lock, flags);
=20
+	if (ret)
+		netif_rx(skb);
 	return ret;
 }
=20
--=20
2.35.1

