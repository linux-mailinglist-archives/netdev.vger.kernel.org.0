Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCEF3AB035
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 11:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhFQJvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 05:51:49 -0400
Received: from first.geanix.com ([116.203.34.67]:41964 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231945AbhFQJvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 05:51:39 -0400
Received: from localhost (unknown [185.17.218.86])
        by first.geanix.com (Postfix) with ESMTPSA id 7C79F4C329F;
        Thu, 17 Jun 2021 09:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1623923369; bh=feNRlUYMtFeRKEObT62vVB8ErOgRqSori+/2ECKwuUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=F4gY/oqMXIkpltdc8EckPCqLjHXZdafUjLweVqy2phE2PidsqCBeqaeZj5KBn7Qdl
         vRZL48V+IlkLUWz4TIL9tPzhlupmNWa4yqG00ji0baSUdfqOYw1n7i28YkrmH3w9hU
         cdj3+UkeMvOSOhJTz8aRGR/ndoDn5iLZfjocLMC7RB6OVksFXhf3+oddVArgLpM0Rs
         PeBflBvD8MBW6SngntdM6unsSE+ZS6vY8AJA7/oj0cncAqaj1FcEn61Eg7IDoVJto7
         86fFK2gfFMeq2z9xIWhv1207Cf5tiQIDJrMi8ZXqQZKzSnntAG8Rkk4s5tsFE7C2ps
         vYGxcsZYCPRTQ==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6/6] net: gianfar: Implement rx_missed_errors counter
Date:   Thu, 17 Jun 2021 11:49:28 +0200
Message-Id: <6786b85ee59f57f64cfe60683fc7be498ad8cf47.1623922686.git.esben@geanix.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1623922686.git.esben@geanix.com>
References: <cover.1623922686.git.esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on 93bd6fdb21b5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devices with RMON support has a 16-bit RDRP counter.  It provides: "Receive
dropped packets counter. Increments for frames received which are streamed
to system but are later dropped due to lack of system resources."

To handle more than 2^16 dropped packets, a carry bit in CAR1 register is
set on overflow, so we enable irq when this is set, extending the counter
to 2^64 for handling situations where lots of packets are missed (e.g.
during heavy network storms).

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 50 ++++++++++++++++++++++--
 drivers/net/ethernet/freescale/gianfar.h | 10 +++++
 2 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 4608c0c337bc..9646483137c4 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -289,6 +289,29 @@ static void gfar_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *s
 		stats->tx_bytes += priv->tx_queue[i]->stats.tx_bytes;
 		stats->tx_packets += priv->tx_queue[i]->stats.tx_packets;
 	}
+
+	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_RMON) {
+		struct rmon_mib __iomem *rmon = &priv->gfargrp[0].regs->rmon;
+		unsigned long flags;
+		u32 rdrp, car, car_before;
+		u64 rdrp_offset;
+
+		spin_lock_irqsave(&priv->rmon_overflow.lock, flags);
+		car = gfar_read(&rmon->car1) & CAR1_C1RDR;
+		do {
+			car_before = car;
+			rdrp = gfar_read(&rmon->rdrp);
+			car = gfar_read(&rmon->car1) & CAR1_C1RDR;
+		} while (car != car_before);
+		if (car) {
+			priv->rmon_overflow.rdrp++;
+			gfar_write(&rmon->car1, car);
+		}
+		rdrp_offset = priv->rmon_overflow.rdrp;
+		spin_unlock_irqrestore(&priv->rmon_overflow.lock, flags);
+
+		stats->rx_missed_errors = rdrp + (rdrp_offset << 16);
+	}
 }
 
 /* Set the appropriate hash bit for the given addr */
@@ -379,7 +402,8 @@ static void gfar_ints_enable(struct gfar_private *priv)
 	for (i = 0; i < priv->num_grps; i++) {
 		struct gfar __iomem *regs = priv->gfargrp[i].regs;
 		/* Unmask the interrupts we look for */
-		gfar_write(&regs->imask, IMASK_DEFAULT);
+		gfar_write(&regs->imask,
+			   IMASK_DEFAULT | priv->rmon_overflow.imask);
 	}
 }
 
@@ -2287,7 +2311,7 @@ static irqreturn_t gfar_receive(int irq, void *grp_id)
 	if (likely(napi_schedule_prep(&grp->napi_rx))) {
 		spin_lock_irqsave(&grp->grplock, flags);
 		imask = gfar_read(&grp->regs->imask);
-		imask &= IMASK_RX_DISABLED;
+		imask &= IMASK_RX_DISABLED | grp->priv->rmon_overflow.imask;
 		gfar_write(&grp->regs->imask, imask);
 		spin_unlock_irqrestore(&grp->grplock, flags);
 		__napi_schedule(&grp->napi_rx);
@@ -2311,7 +2335,7 @@ static irqreturn_t gfar_transmit(int irq, void *grp_id)
 	if (likely(napi_schedule_prep(&grp->napi_tx))) {
 		spin_lock_irqsave(&grp->grplock, flags);
 		imask = gfar_read(&grp->regs->imask);
-		imask &= IMASK_TX_DISABLED;
+		imask &= IMASK_TX_DISABLED | grp->priv->rmon_overflow.imask;
 		gfar_write(&grp->regs->imask, imask);
 		spin_unlock_irqrestore(&grp->grplock, flags);
 		__napi_schedule(&grp->napi_tx);
@@ -2682,6 +2706,18 @@ static irqreturn_t gfar_error(int irq, void *grp_id)
 		}
 		netif_dbg(priv, tx_err, dev, "Transmit Error\n");
 	}
+	if (events & IEVENT_MSRO) {
+		struct rmon_mib __iomem *rmon = &regs->rmon;
+		u32 car;
+
+		spin_lock(&priv->rmon_overflow.lock);
+		car = gfar_read(&rmon->car1) & CAR1_C1RDR;
+		if (car) {
+			priv->rmon_overflow.rdrp++;
+			gfar_write(&rmon->car1, car);
+		}
+		spin_unlock(&priv->rmon_overflow.lock);
+	}
 	if (events & IEVENT_BSY) {
 		dev->stats.rx_over_errors++;
 		atomic64_inc(&priv->extra_stats.rx_bsy);
@@ -3259,6 +3295,14 @@ static int gfar_probe(struct platform_device *ofdev)
 
 	gfar_hw_init(priv);
 
+	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_RMON) {
+		struct rmon_mib __iomem *rmon = &priv->gfargrp[0].regs->rmon;
+
+		spin_lock_init(&priv->rmon_overflow.lock);
+		priv->rmon_overflow.imask = IMASK_MSRO;
+		gfar_write(&rmon->cam1, gfar_read(&rmon->cam1) & ~CAM1_M1RDR);
+	}
+
 	/* Carrier starts down, phylib will bring it up */
 	netif_carrier_off(dev);
 
diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index c8aa140a910f..ca5e14f908fe 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -663,6 +663,15 @@ struct rmon_mib
 	u32	cam2;	/* 0x.73c - Carry Mask Register Two */
 };
 
+struct rmon_overflow {
+	/* lock for synchronization of the rdrp field of this struct, and
+	 * CAR1/CAR2 registers
+	 */
+	spinlock_t lock;
+	u32	imask;
+	u64	rdrp;
+};
+
 struct gfar_extra_stats {
 	atomic64_t rx_alloc_err;
 	atomic64_t rx_large;
@@ -1150,6 +1159,7 @@ struct gfar_private {
 
 	/* Network Statistics */
 	struct gfar_extra_stats extra_stats;
+	struct rmon_overflow rmon_overflow;
 
 	/* PHY stuff */
 	phy_interface_t interface;
-- 
2.32.0

