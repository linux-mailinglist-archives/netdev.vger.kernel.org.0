Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168FE12A99F
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 03:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfLZCQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 21:16:31 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:55983 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfLZCQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 21:16:30 -0500
Received: by mail-pj1-f66.google.com with SMTP id d5so2739976pjz.5;
        Wed, 25 Dec 2019 18:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LZ93AY1+fKpm1lkv7HOM3paCh/zw2D/T/ZiNFPokrAw=;
        b=gFeDQIxBzQ3wAhjnnkxCr1x4RxM5lL0docYg1WyFZYcTeKiWS18oRNGsjZSheGcc9S
         aZCaN6b4igAeyuOvfWYzV/6JcTu06FJlGvG0XwXqLBnsfUgYMELk6Ne4Z5ABLlY/rRnm
         RbH7BBp5e9IWcCA8UqBAwx3OoUXmxOzmO9YpSmPvHbDTQjVPEQfTYAl3M2swZdS9gZr+
         tDlnrAGlaFal/uUlFNzl+ApDwE2tKeKddXpbHNzq+4/ADepzWGtsFMoM6U9/5PaTkHro
         3SpzPPI1O5R8Ug/5aQgilKYBqx928Q1+KQq7z6xHNOFpToIOdebZX1sCoytr9IhQvBVr
         6JHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LZ93AY1+fKpm1lkv7HOM3paCh/zw2D/T/ZiNFPokrAw=;
        b=tk6+aeJxNDo2MA8xTgwlALhVir2Kb/edsfUffrehIvv5phVM7DSE3YfEhCanM3AXFM
         NnoUuOAqru3fqrMp/AbB+zw30EMhjX2PV6IrBaznlzGA3BQYUQEGFk6bQhzlmX0jpdAI
         sfIyU7YIfkzHVn5UKzA3bw4xaw9raZ4ZiMNvViERPhLR1p0Ktqszm1GBJ+kkTgZ7ymIN
         K7IsH9YzNyFKbkn65X/jv3BOm3Sk9M1KwpiqtA5PLNtwFvLzSYm3bVJyLv4jYiStawUH
         hlbMBnhywj9hb1XOll4wnmSTeteuJ4CjiXlh6kKIa2gEhNQjqvfBc0toNsVrlEEbIxVx
         f9Ug==
X-Gm-Message-State: APjAAAVf4Be1bWAkVr/rQE5Q9fyWCbFxQwWDndZbQMQJ4oW9Cvt/SgfF
        1bnX9qEMBBWnqrPrwWjteTtkaYMU
X-Google-Smtp-Source: APXvYqyUnvCgxqM0q+Zr67zjCbEqIiuA2Vck5mYyZ94YnWFgv7bv+gMsDQgqzFqdNgrdq0VKsidffg==
X-Received: by 2002:a17:90a:b010:: with SMTP id x16mr16926072pjq.130.1577326589347;
        Wed, 25 Dec 2019 18:16:29 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b65sm31880723pgc.18.2019.12.25.18.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 18:16:28 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V9 net-next 05/12] net: netcp_ethss: Use the PHY time stamping interface.
Date:   Wed, 25 Dec 2019 18:16:13 -0800
Message-Id: <76cd58c2032f894184aeb2f1e23a59b368f3eb2c.1577326042.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1577326042.git.richardcochran@gmail.com>
References: <cover.1577326042.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netcp_ethss driver tests fields of the phy_device in order to
determine whether to defer to the PHY's time stamping functionality.
This patch replaces the open coded logic with an invocation of the
proper methods.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/ti/netcp_ethss.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 86a3f42a3dcc..1280ccd581d4 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -2533,8 +2533,6 @@ static int gbe_del_vid(void *intf_priv, int vid)
 }
 
 #if IS_ENABLED(CONFIG_TI_CPTS)
-#define HAS_PHY_TXTSTAMP(p) ((p)->drv && (p)->drv->txtstamp)
-#define HAS_PHY_RXTSTAMP(p) ((p)->drv && (p)->drv->rxtstamp)
 
 static void gbe_txtstamp(void *context, struct sk_buff *skb)
 {
@@ -2566,7 +2564,7 @@ static int gbe_txtstamp_mark_pkt(struct gbe_intf *gbe_intf,
 	 * We mark it here because skb_tx_timestamp() is called
 	 * after all the txhooks are called.
 	 */
-	if (phydev && HAS_PHY_TXTSTAMP(phydev)) {
+	if (phy_has_txtstamp(phydev)) {
 		skb_shinfo(p_info->skb)->tx_flags |= SKBTX_IN_PROGRESS;
 		return 0;
 	}
@@ -2588,7 +2586,7 @@ static int gbe_rxtstamp(struct gbe_intf *gbe_intf, struct netcp_packet *p_info)
 	if (p_info->rxtstamp_complete)
 		return 0;
 
-	if (phydev && HAS_PHY_RXTSTAMP(phydev)) {
+	if (phy_has_rxtstamp(phydev)) {
 		p_info->rxtstamp_complete = true;
 		return 0;
 	}
@@ -2830,7 +2828,7 @@ static int gbe_ioctl(void *intf_priv, struct ifreq *req, int cmd)
 	struct gbe_intf *gbe_intf = intf_priv;
 	struct phy_device *phy = gbe_intf->slave->phy;
 
-	if (!phy || !phy->drv->hwtstamp) {
+	if (!phy_has_hwtstamp(phy)) {
 		switch (cmd) {
 		case SIOCGHWTSTAMP:
 			return gbe_hwtstamp_get(gbe_intf, req);
-- 
2.20.1

