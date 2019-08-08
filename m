Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 636E686D9D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 01:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404258AbfHHXG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 19:06:29 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41229 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHHXG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 19:06:28 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so15082921qtj.8
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 16:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starry.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7CESWyLAKrOwsgDy9PwqBoy2s0nfZt+bK+V9JG/yxhg=;
        b=D+V4ofB8N+Gu3noRFTcK+yjz+TdN9uQwYKjRC1Yho6R0E0aX2Dk8e2VH/qLdIIX33h
         Tn3gBPj2HpbtW7l1nOSeclyfUm93YPuSkYs8DiD7vF4boYsBBop3DA+zB/W9bRJsrvPh
         Z7YYNe5NM9BXIcyXPJCaGWZUoiY9qXa02PL9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7CESWyLAKrOwsgDy9PwqBoy2s0nfZt+bK+V9JG/yxhg=;
        b=Wvb+ZRlW+FTkbWkozW/RNSH5Vyrf3OwEM/CYnn0vEOVaaWNBIi3FKLmQV2S9plnJVF
         2O14sS0aN2sSOCB44XGLhg4ysAIzdbShxtO3iuZL7Axuv2Z/icTCMzFoAnWlu9FWFAzY
         q5cqTPVVUF3pGyg4zAsv5XPuqWPMIwk28ymGkbH3G2d4g/oocwIRvKgGqumE5+8oSqS1
         g/Y0lAtMREqmTANgAvwX0NLmoImmb4pHsO2+gfoSL7KtbfP3m3C2hjEdbYeqe0u1mYQT
         WFsslDTF+llBXXMpqpYCixEb9tNMO8aC9twcYkD1BY+F1DTxt0khQrFnvggIi9+mdeCE
         asag==
X-Gm-Message-State: APjAAAUvgLSe4x2GPLoHrNUBxDuX7FKXBLISGZ6i7Vr9+bcxrO85w4y+
        EIAUbUADKN4yl9UJfVh/P38ih1slwurh3g==
X-Google-Smtp-Source: APXvYqyWSDudPIA+5lzyVwPHdoUJ69vAJAy8ZbKRBSyBr6kFSl9l2Njfm+vbuiH/hDYGT7vTzfGACg==
X-Received: by 2002:ac8:2c35:: with SMTP id d50mr14987549qta.313.1565305587689;
        Thu, 08 Aug 2019 16:06:27 -0700 (PDT)
Received: from localhost.localdomain (205-201-16-55.starry-inc.net. [205.201.16.55])
        by smtp.gmail.com with ESMTPSA id u1sm51299554qth.21.2019.08.08.16.06.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 16:06:27 -0700 (PDT)
From:   Matt Pelland <mpelland@starry.com>
To:     netdev@vger.kernel.org
Cc:     Matt Pelland <mpelland@starry.com>, davem@davemloft.com,
        maxime.chevallier@bootlin.com, antoine.tenart@bootlin.com
Subject: [PATCH v2 net-next 1/2] net: mvpp2: implement RXAUI support
Date:   Thu,  8 Aug 2019 19:06:05 -0400
Message-Id: <20190808230606.7900-2-mpelland@starry.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808230606.7900-1-mpelland@starry.com>
References: <20190808230606.7900-1-mpelland@starry.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marvell's mvpp2 packet processor supports RXAUI on port zero in a
similar manner to the existing 10G protocols that have already been
implemented. This patch implements the miscellaneous extra configuration
steps required for RXAUI operation.

Signed-off-by: Matt Pelland <mpelland@starry.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  1 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 32 +++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 4d9564ba68f6..256e7c796631 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -481,6 +481,7 @@
 #define MVPP22_XLG_CTRL4_REG			0x184
 #define     MVPP22_XLG_CTRL4_FWD_FC		BIT(5)
 #define     MVPP22_XLG_CTRL4_FWD_PFC		BIT(6)
+#define     MVPP22_XLG_CTRL4_USE_XPCS		BIT(8)
 #define     MVPP22_XLG_CTRL4_MACMODSELECT_GMAC	BIT(12)
 #define     MVPP22_XLG_CTRL4_EN_IDLE_CHECK	BIT(14)
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 74fd9e171865..1a5037a398fc 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -980,6 +980,7 @@ mvpp2_shared_interrupt_mask_unmask(struct mvpp2_port *port, bool mask)
 static bool mvpp2_is_xlg(phy_interface_t interface)
 {
 	return interface == PHY_INTERFACE_MODE_10GKR ||
+	       interface == PHY_INTERFACE_MODE_RXAUI ||
 	       interface == PHY_INTERFACE_MODE_XAUI;
 }
 
@@ -1020,6 +1021,29 @@ static void mvpp22_gop_init_sgmii(struct mvpp2_port *port)
 	}
 }
 
+static void mvpp22_gop_init_rxaui(struct mvpp2_port *port)
+{
+	struct mvpp2 *priv = port->priv;
+	void __iomem *xpcs;
+	u32 val;
+
+	xpcs = priv->iface_base + MVPP22_XPCS_BASE(port->gop_id);
+
+	val = readl(xpcs + MVPP22_XPCS_CFG0);
+	val &= ~MVPP22_XPCS_CFG0_RESET_DIS;
+	writel(val, xpcs + MVPP22_XPCS_CFG0);
+
+	val = readl(xpcs + MVPP22_XPCS_CFG0);
+	val &= ~(MVPP22_XPCS_CFG0_PCS_MODE(0x3) |
+		 MVPP22_XPCS_CFG0_ACTIVE_LANE(0x3));
+	val |= MVPP22_XPCS_CFG0_ACTIVE_LANE(2);
+	writel(val, xpcs + MVPP22_XPCS_CFG0);
+
+	val = readl(xpcs + MVPP22_XPCS_CFG0);
+	val |= MVPP22_XPCS_CFG0_RESET_DIS;
+	writel(val, xpcs + MVPP22_XPCS_CFG0);
+}
+
 static void mvpp22_gop_init_10gkr(struct mvpp2_port *port)
 {
 	struct mvpp2 *priv = port->priv;
@@ -1065,6 +1089,9 @@ static int mvpp22_gop_init(struct mvpp2_port *port)
 	case PHY_INTERFACE_MODE_2500BASEX:
 		mvpp22_gop_init_sgmii(port);
 		break;
+	case PHY_INTERFACE_MODE_RXAUI:
+		mvpp22_gop_init_rxaui(port);
+		break;
 	case PHY_INTERFACE_MODE_10GKR:
 		if (port->gop_id != 0)
 			goto invalid_conf;
@@ -4567,6 +4594,7 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_10GKR:
 	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_RXAUI:
 		if (port->gop_id != 0)
 			goto empty_set;
 		break;
@@ -4589,6 +4617,7 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_10GKR:
 	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_RXAUI:
 	case PHY_INTERFACE_MODE_NA:
 		if (port->gop_id == 0) {
 			phylink_set(mask, 10000baseT_Full);
@@ -4741,6 +4770,9 @@ static void mvpp2_xlg_config(struct mvpp2_port *port, unsigned int mode,
 		   MVPP22_XLG_CTRL4_EN_IDLE_CHECK);
 	ctrl4 |= MVPP22_XLG_CTRL4_FWD_FC | MVPP22_XLG_CTRL4_FWD_PFC;
 
+	if (state->interface == PHY_INTERFACE_MODE_RXAUI)
+		ctrl4 |= MVPP22_XLG_CTRL4_USE_XPCS;
+
 	if (old_ctrl0 != ctrl0)
 		writel(ctrl0, port->base + MVPP22_XLG_CTRL0_REG);
 	if (old_ctrl4 != ctrl4)
-- 
2.21.0

