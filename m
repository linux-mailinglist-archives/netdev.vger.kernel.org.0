Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CBE4CE75E
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 23:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbiCEWOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 17:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCEWOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 17:14:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B70517FD
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 14:13:18 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646518396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t+y+wsLXJ2N2picgDAR53A5GkB2/WvIC1ArRsV+KuXo=;
        b=WBZa1G/rUHxgpOT62AIxnLvkoiFbHCv9FC3N40FBdlbU2Az1P8IxbcpvhmeXmkn1VPDjLp
        q73G94pjm+t1dbEQmFMX4fRHEt0qhoqY4CTEOIx+xnL3lAIBnE0gvygd1RNF1r99zgCv1y
        ZagA4NdEsIKSr3w9Q56gsjNwHFBUJ+UVCGKrIlLZKlwbKJGi+YD7os0/X/DH7z4TubXAta
        yy162jm6zcmz5f86lK798AJ89FEMYZLL95974qbk+LIdM5ane//qUcNj66cfrTuQL2YFWv
        GVMXXt+9OuuhpAyW3zpHo8LSwdU7eeVv9eokmEBmYP5K6v2lowS8XDUfaOhSew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646518396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t+y+wsLXJ2N2picgDAR53A5GkB2/WvIC1ArRsV+KuXo=;
        b=itreT8Va2bpW7yN+0RunbZ5lwuPQRp68c253fNYvYSBtXwEQTWaZwooyPEuiGhgvYAXpIT
        A5c318RfYMqthjBw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 1/8] net: phy: Use netif_rx().
Date:   Sat,  5 Mar 2022 23:12:45 +0100
Message-Id: <20220305221252.3063812-2-bigeasy@linutronix.de>
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

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/phy/dp83640.c         | 6 +++---
 drivers/net/phy/mscc/mscc_ptp.c   | 2 +-
 drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index c2d1a85ec5591..c0a617311e2d4 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -886,7 +886,7 @@ static void decode_rxts(struct dp83640_private *dp83640,
 	spin_unlock_irqrestore(&dp83640->rx_lock, flags);
=20
 	if (shhwtstamps)
-		netif_rx_ni(skb);
+		netif_rx(skb);
 }
=20
 static void decode_txts(struct dp83640_private *dp83640,
@@ -1329,7 +1329,7 @@ static void rx_timestamp_work(struct work_struct *wor=
k)
 			break;
 		}
=20
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
=20
 	if (!skb_queue_empty(&dp83640->rx_queue))
@@ -1380,7 +1380,7 @@ static bool dp83640_rxtstamp(struct mii_timestamper *=
mii_ts,
 		skb_queue_tail(&dp83640->rx_queue, skb);
 		schedule_delayed_work(&dp83640->ts_work, SKB_TIMESTAMP_TIMEOUT);
 	} else {
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
=20
 	return true;
diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_pt=
p.c
index 34f829845d067..cf728bfd83e22 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1212,7 +1212,7 @@ static bool vsc85xx_rxtstamp(struct mii_timestamper *=
mii_ts,
 		ts.tv_sec--;
=20
 	shhwtstamps->hwtstamp =3D ktime_set(ts.tv_sec, ns);
-	netif_rx_ni(skb);
+	netif_rx(skb);
=20
 	return true;
 }
diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tj=
a11xx.c
index 06fdbae509a79..047c581457e34 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -478,7 +478,7 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *=
ptp)
 		shhwtstamps_rx =3D skb_hwtstamps(skb);
 		shhwtstamps_rx->hwtstamp =3D ns_to_ktime(timespec64_to_ns(&ts));
 		NXP_C45_SKB_CB(skb)->header->reserved2 =3D 0;
-		netif_rx_ni(skb);
+		netif_rx(skb);
 	}
=20
 	if (priv->extts) {
--=20
2.35.1

