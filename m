Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC9F511E70B
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbfLMPuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:50:35 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:43859 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbfLMPuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:50:32 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 7EE4D4000D;
        Fri, 13 Dec 2019 15:50:29 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v3 15/15] net: macsec: add support for offloading to the MAC
Date:   Fri, 13 Dec 2019 16:48:44 +0100
Message-Id: <20191213154844.635389-16-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213154844.635389-1-antoine.tenart@bootlin.com>
References: <20191213154844.635389-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new MACsec offloading option, MACSEC_OFFLOAD_MAC,
allowing a user to select a MAC as a provider for MACsec offloading
operations.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/macsec.c               | 16 +++++++++++++---
 include/uapi/linux/if_link.h       |  1 +
 tools/include/uapi/linux/if_link.h |  1 +
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 8247eb652f57..222b6ed93b27 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -324,7 +324,8 @@ static void macsec_set_shortlen(struct macsec_eth_header *h, size_t data_len)
 /* Checks if a MACsec interface is being offloaded to an hardware engine */
 static bool macsec_is_offloaded(struct macsec_dev *macsec)
 {
-	if (macsec->offload == MACSEC_OFFLOAD_PHY)
+	if (macsec->offload == MACSEC_OFFLOAD_MAC ||
+	    macsec->offload == MACSEC_OFFLOAD_PHY)
 		return true;
 
 	return false;
@@ -340,6 +341,9 @@ static bool macsec_check_offload(enum macsec_offload offload,
 	if (offload == MACSEC_OFFLOAD_PHY)
 		return macsec->real_dev->phydev &&
 		       macsec->real_dev->phydev->macsec_ops;
+	else if (offload == MACSEC_OFFLOAD_MAC)
+		return macsec->real_dev->features & NETIF_F_HW_MACSEC &&
+		       macsec->real_dev->macsec_ops;
 
 	return false;
 }
@@ -354,9 +358,14 @@ static const struct macsec_ops *__macsec_get_ops(enum macsec_offload offload,
 
 		if (offload == MACSEC_OFFLOAD_PHY)
 			ctx->phydev = macsec->real_dev->phydev;
+		else if (offload == MACSEC_OFFLOAD_MAC)
+			ctx->netdev = macsec->real_dev;
 	}
 
-	return macsec->real_dev->phydev->macsec_ops;
+	if (offload == MACSEC_OFFLOAD_PHY)
+		return macsec->real_dev->phydev->macsec_ops;
+	else
+		return macsec->real_dev->macsec_ops;
 }
 
 /* Returns a pointer to the MACsec ops struct if any and updates the MACsec
@@ -2414,7 +2423,8 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 
 			priv = macsec_priv(loop_dev);
 
-			if (!macsec_check_offload(MACSEC_OFFLOAD_PHY, priv))
+			if (!macsec_check_offload(MACSEC_OFFLOAD_PHY, priv) &&
+			    !macsec_check_offload(MACSEC_OFFLOAD_MAC, priv))
 				continue;
 
 			if (priv->offload != MACSEC_OFFLOAD_OFF)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 024af2d1d0af..771371d5b996 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -489,6 +489,7 @@ enum macsec_validation_type {
 enum macsec_offload {
 	MACSEC_OFFLOAD_OFF = 0,
 	MACSEC_OFFLOAD_PHY = 1,
+	MACSEC_OFFLOAD_MAC = 2,
 	__MACSEC_OFFLOAD_END,
 	MACSEC_OFFLOAD_MAX = __MACSEC_OFFLOAD_END - 1,
 };
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 42efdb84d189..7bf406d3ce62 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -488,6 +488,7 @@ enum macsec_validation_type {
 enum macsec_offload {
 	MACSEC_OFFLOAD_OFF = 0,
 	MACSEC_OFFLOAD_PHY = 1,
+	MACSEC_OFFLOAD_MAC = 2,
 	__MACSEC_OFFLOAD_END,
 	MACSEC_OFFLOAD_MAX = __MACSEC_OFFLOAD_END - 1,
 };
-- 
2.23.0

