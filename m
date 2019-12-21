Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7D6128B1E
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 20:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfLUTgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 14:36:54 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35177 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbfLUTgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 14:36:49 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so5545575plt.2;
        Sat, 21 Dec 2019 11:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LZ93AY1+fKpm1lkv7HOM3paCh/zw2D/T/ZiNFPokrAw=;
        b=ahk83Fg5iFOr5LxXXHbH5RT9e9MD2eV6kteRw7B8tdtbjaxE+slOVsiWHsEo35v5GR
         sK9oMVGLBtYa6d+3a/DpIGtXcQx+kJ0LZLcbxmIXzi/WuTmnln4bX1RUvDQiISxFC9E6
         a3B7g52k+dTMXcQH85oc1mReOWpRaT1QfKjM1/785S9Bju/30w1TQk5PXo/TN0LFW2A7
         4gayD9A/Oz76q42h8xFgFZw4butA6ciZGKRbiYpWEYKYsw8oRlU4HRMRNZK+iFsXpzVG
         1uSEkcwOzR7OZJWOLR5BFiqH8WXTZf2qwyVmRAAHKBc4kKxh5/TKbPBk5kqUn/AOP8/L
         T5LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LZ93AY1+fKpm1lkv7HOM3paCh/zw2D/T/ZiNFPokrAw=;
        b=IMrZ8TpGTVY2EfrNle7nZ7jIgX5X4gq/OlahgKGKGCVu/5vwdwAlrrnKluDN+WwUsF
         q2NV4wnrN/twPzh+ChEo/QU1sfRPR2LGaObNU347xDO3NclzrFlzSEk2wFCdwY2HRVTJ
         7WeyIczfWdfpOeSlOsM5zvmJaPCkhgCmccMLxGCcJeULpvrcQUmk6cuQdtV/edqz2fUX
         Zls6JpblyVk61z9siZ4uGAIZCjy4DnbVzvL7/vCp3RgX0AuflIVLK18BEOFV8Jdu71We
         lqhwzI1WdPCBp3jrV+F3yMbHhocVeB8W4E0ttyjbm1hu6GGhozkjwiA7zjppQ6EWJZmb
         am+Q==
X-Gm-Message-State: APjAAAUQAMqjCo+V+hJY3nFKjUTeEOZNr82qb6579ubPv+QKlni3zLgG
        TaN7aO8J2Ic36kqvni6X8+rCCvyT
X-Google-Smtp-Source: APXvYqyaWfVImWgFzZFryPWHuiQ/Oc9qphIn8ajBahnOWf9g3de5R8OF0TwGPiyXMIvf8xAio76BMA==
X-Received: by 2002:a17:90a:a88d:: with SMTP id h13mr23038652pjq.55.1576957008437;
        Sat, 21 Dec 2019 11:36:48 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y197sm18512603pfc.79.2019.12.21.11.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 11:36:47 -0800 (PST)
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
Subject: [PATCH V8 net-next 05/12] net: netcp_ethss: Use the PHY time stamping interface.
Date:   Sat, 21 Dec 2019 11:36:31 -0800
Message-Id: <76cd58c2032f894184aeb2f1e23a59b368f3eb2c.1576956342.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576956342.git.richardcochran@gmail.com>
References: <cover.1576956342.git.richardcochran@gmail.com>
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

