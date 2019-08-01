Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668AA7E474
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732878AbfHAUpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 16:45:31 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40051 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfHAUpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 16:45:30 -0400
Received: by mail-qk1-f194.google.com with SMTP id s145so53148829qke.7
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 13:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starry.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f/9yTZ0Ue7j6Tn2THMVYQdLlVot0FQzq0AJj/HStoA4=;
        b=KORIZMZoY1KY2nQJsCLHreLSYSOY/Zk9fXEbsiZI0FkfUvrvRHJAkEwLK78pC39HAW
         xrLdZ1R/Fd6CqBsHTyvFur92p/pOAsJYfuuydkQdAMxkoglcH62lZUkoQGsE3WBmsUJC
         yFMUmJCwqHZnVfJlime3tpD2dxAx1yEpMBMwo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/9yTZ0Ue7j6Tn2THMVYQdLlVot0FQzq0AJj/HStoA4=;
        b=gwcIxMtVRghcsfYUpejZgPUb3Yb8LIFsE10nBeXnX0JUBQsOpsnx/Dqf6mBvuR4EgA
         iEGzBCXbSJcPKHyNmBMCmVMTleJ5rWpI5zQiya38LfYGCGhiy+qI/727ZJ7Vy3pjrtir
         GeiJ5rUaZ9xOgsxd8/NZ0G9HrNTn+L7yBv4/4rT9sTga2lR95gmr7ZtffsPYErIgJ9mb
         v2Jf7AnbuPrInPaH4gq7vLpfTCiVW/Tp6Xg0CJflJxrkFckAjsqtAjaRK6ngJSH2vEek
         P9otB4SWijWyfyXhnKYUq3uqIeDKpITKg+7xp10z8k/daOWOjvtJ8FevhISUAJczJPgi
         gasQ==
X-Gm-Message-State: APjAAAWYiImqsNSU5T4orajFkiOdXp48kXwzQYhAAxcO5ElOUZc4Xo2Y
        eApkDVkJIBkfcYrZEY2IapGAyCw6Rh8=
X-Google-Smtp-Source: APXvYqzd+9sQkVWdPDIPdPz3AbsD24+5IkwIR71AExg2a5md1nT4P694lAcrgmr2qbCxmezsvI/BVQ==
X-Received: by 2002:ae9:f443:: with SMTP id z3mr88709399qkl.203.1564692329588;
        Thu, 01 Aug 2019 13:45:29 -0700 (PDT)
Received: from localhost.localdomain (205-201-16-55.starry-inc.net. [205.201.16.55])
        by smtp.gmail.com with ESMTPSA id b23sm42724059qte.19.2019.08.01.13.45.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 13:45:28 -0700 (PDT)
From:   Matt Pelland <mpelland@starry.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, Matt Pelland <mpelland@starry.com>
Subject: [PATCH 1/2] net: mvpp2: implement RXAUI support
Date:   Thu,  1 Aug 2019 16:45:22 -0400
Message-Id: <20190801204523.26454-2-mpelland@starry.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801204523.26454-1-mpelland@starry.com>
References: <20190801204523.26454-1-mpelland@starry.com>
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
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 30 +++++++++++++++++++
 2 files changed, 31 insertions(+)

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
index e9d8ffe897e9..8b633af4a684 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -968,6 +968,7 @@ mvpp2_shared_interrupt_mask_unmask(struct mvpp2_port *port, bool mask)
 static bool mvpp2_is_xlg(phy_interface_t interface)
 {
 	return interface == PHY_INTERFACE_MODE_10GKR ||
+	       interface == PHY_INTERFACE_MODE_RXAUI ||
 	       interface == PHY_INTERFACE_MODE_XAUI;
 }
 
@@ -1008,6 +1009,27 @@ static void mvpp22_gop_init_sgmii(struct mvpp2_port *port)
 	}
 }
 
+static void mvpp22_gop_init_rxaui(struct mvpp2_port *port)
+{
+	struct mvpp2 *priv = port->priv;
+	void __iomem *xpcs = priv->iface_base + MVPP22_XPCS_BASE(port->gop_id);
+	u32 val;
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
@@ -1053,6 +1075,9 @@ static int mvpp22_gop_init(struct mvpp2_port *port)
 	case PHY_INTERFACE_MODE_2500BASEX:
 		mvpp22_gop_init_sgmii(port);
 		break;
+	case PHY_INTERFACE_MODE_RXAUI:
+		mvpp22_gop_init_rxaui(port);
+		break;
 	case PHY_INTERFACE_MODE_10GKR:
 		if (port->gop_id != 0)
 			goto invalid_conf;
@@ -4570,6 +4595,7 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_10GKR:
 	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_RXAUI:
 		if (port->gop_id != 0)
 			goto empty_set;
 		break;
@@ -4592,6 +4618,7 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_10GKR:
 	case PHY_INTERFACE_MODE_XAUI:
+	case PHY_INTERFACE_MODE_RXAUI:
 	case PHY_INTERFACE_MODE_NA:
 		if (port->gop_id == 0) {
 			phylink_set(mask, 10000baseT_Full);
@@ -4744,6 +4771,9 @@ static void mvpp2_xlg_config(struct mvpp2_port *port, unsigned int mode,
 	ctrl4 |= MVPP22_XLG_CTRL4_FWD_FC | MVPP22_XLG_CTRL4_FWD_PFC |
 		 MVPP22_XLG_CTRL4_EN_IDLE_CHECK;
 
+	if (state->interface == PHY_INTERFACE_MODE_RXAUI)
+		ctrl4 |= MVPP22_XLG_CTRL4_USE_XPCS;
+
 	if (old_ctrl0 != ctrl0)
 		writel(ctrl0, port->base + MVPP22_XLG_CTRL0_REG);
 	if (old_ctrl4 != ctrl4)
-- 
2.21.0

