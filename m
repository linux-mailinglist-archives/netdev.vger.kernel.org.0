Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC02F211984
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgGBBft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728316AbgGBBXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1C5720748;
        Thu,  2 Jul 2020 01:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653003;
        bh=KWQ4e3p+UIInG0QsWaTKjw4uJUmUUZQzFdKT60LPMKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yy3it853cghdNRbF9XTBt2aPNvrQfUClzx4xpBjFSWdHCtVHpo2YFxAR5+R29gSHw
         KMYk9ms4sns9EdfEoYwGuWSXaMs9ue1i3h1pqBANBZjO+Kp0w1+5txJumekHhqF21i
         CE4PE+GM2fKr4TSsI4yzYPrqJs+CuJTtDVaLgK7I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 23/53] net: ethernet: mvneta: Add 2500BaseX support for SoCs without comphy
Date:   Wed,  1 Jul 2020 21:21:32 -0400
Message-Id: <20200702012202.2700645-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 1a642ca7f38992b086101fe204a1ae3c90ed8016 ]

The older SoCs like Armada XP support a 2500BaseX mode in the datasheets
referred to as DR-SGMII (Double rated SGMII) or HS-SGMII (High Speed
SGMII). This is an upclocked 1000BaseX mode, thus
PHY_INTERFACE_MODE_2500BASEX is the appropriate mode define for it.
adding support for it merely means writing the correct magic value into
the MVNETA_SERDES_CFG register.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 401eeeca89660..af578a5813bd2 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -110,6 +110,7 @@
 #define MVNETA_SERDES_CFG			 0x24A0
 #define      MVNETA_SGMII_SERDES_PROTO		 0x0cc7
 #define      MVNETA_QSGMII_SERDES_PROTO		 0x0667
+#define      MVNETA_HSGMII_SERDES_PROTO		 0x1107
 #define MVNETA_TYPE_PRIO                         0x24bc
 #define      MVNETA_FORCE_UNI                    BIT(21)
 #define MVNETA_TXQ_CMD_1                         0x24e4
@@ -3558,6 +3559,11 @@ static int mvneta_config_interface(struct mvneta_port *pp,
 			mvreg_write(pp, MVNETA_SERDES_CFG,
 				    MVNETA_SGMII_SERDES_PROTO);
 			break;
+
+		case PHY_INTERFACE_MODE_2500BASEX:
+			mvreg_write(pp, MVNETA_SERDES_CFG,
+				    MVNETA_HSGMII_SERDES_PROTO);
+			break;
 		default:
 			return -EINVAL;
 		}
-- 
2.25.1

