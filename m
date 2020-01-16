Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4275A13F6A3
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388154AbgAPRBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387789AbgAPRBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09B892077B;
        Thu, 16 Jan 2020 17:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194099;
        bh=xT1Gpv1UHI9N1TVk5JwQf/3ZW9V+yemShCShsoP/9+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naJ2G5MN3i7Mu46sHGG94YpQRSnmrVMNtO09/tyv/oCtcqK+EYXb1whedh2zhwmvw
         jaSPJzEpueRfLZSuM6KCQsCIJsgol8lTrWmEnyMUt6BMi/2Nmk6C0ltbX10fxnzOPa
         kkFPRnVesvlkEJgz6IVvjtMi6q1Arg+3jFhgJBq8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        =?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 200/671] net: dsa: qca8k: Enable delay for RGMII_ID mode
Date:   Thu, 16 Jan 2020 11:51:49 -0500
Message-Id: <20200116165940.10720-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit a968b5e9d5879f9535d6099505f9e14abcafb623 ]

RGMII_ID specifies that we should have internal delay, so resurrect the
delay addition routine but under the RGMII_ID mode.

Fixes: 40269aa9f40a ("net: dsa: qca8k: disable delay for RGMII mode")
Tested-by: Michal Vokáč <michal.vokac@ysoft.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca8k.c | 12 ++++++++++++
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 33232cc9fb04..6c04f32e9641 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -451,6 +451,18 @@ qca8k_set_pad_ctrl(struct qca8k_priv *priv, int port, int mode)
 		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
 			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		/* RGMII_ID needs internal delay. This is enabled through
+		 * PORT5_PAD_CTRL for all ports, rather than individual port
+		 * registers
+		 */
+		qca8k_write(priv, reg,
+			    QCA8K_PORT_PAD_RGMII_EN |
+			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
+		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
+		break;
 	case PHY_INTERFACE_MODE_SGMII:
 		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
 		break;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 613fe5c50236..d146e54c8a6c 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -40,6 +40,7 @@
 						((0x8 + (x & 0x3)) << 22)
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		\
 						((0x10 + (x & 0x3)) << 20)
+#define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
 #define QCA8K_REG_MODULE_EN				0x030
-- 
2.20.1

