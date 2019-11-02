Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEE5ECF18
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 15:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfKBOQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 10:16:44 -0400
Received: from m12-18.163.com ([220.181.12.18]:41647 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbfKBOQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 10:16:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=upMwnxxtmPdSyhEleA
        aGyaHylHaIDhhTNnhqXu70lCM=; b=pqVeUJvyF9DkczJMX7j1RHgJssl3jyTqGM
        77Rc+p34YdeAMb6j9oOkY/YCbrU4u6n0kjrzOnkHI0uAuxwt6/z2Ej2K4Daq2yGY
        WgJbc26pMdg37QgA1k63tUKn0OdMpLFdtL9w1cdyJKiRv/Ilnqp41MQTehB/Fx0e
        GRJyM+Llw=
Received: from localhost.localdomain (unknown [101.87.165.211])
        by smtp14 (Coremail) with SMTP id EsCowAAXJYx+j71ds_ZaFw--.24895S2;
        Sat, 02 Nov 2019 22:15:39 +0800 (CST)
From:   Hansen Yang <yanghansen1@163.com>
To:     andrew@lunn.ch
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        496645649@qq.com, Hansen Yang <yanghansen1@163.com>
Subject: [PATCH] net: phy: marvell: Fix bits clear bug
Date:   Sat,  2 Nov 2019 22:15:08 +0800
Message-Id: <20191102141508.4416-1-yanghansen1@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EsCowAAXJYx+j71ds_ZaFw--.24895S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw4rGFy3Gw13tFWDWF1rZwb_yoW8Jw4xpF
        4DuryxGr4qqa40kws8Kr48GFy0g3s7A3y3CF1Ikwn8CrnxCFy7XrW3Ja4vqr1UXrW8uF4j
        vrsY9FZrZFn8W37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jbcTPUUUUU=
X-Originating-IP: [101.87.165.211]
X-CM-SenderInfo: p1dqwxpdqvv0qr6rljoofrz/1tbi8BVhGFuoVeH1agAAsE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The correct way to clear bits before setting some of them is using
"& = ~BIT_MASK".
The wrong operation "& = BIT_MASK" will clear other bits.

m88e1116r_config_init() calls marvell_set_polarity() to config
MDI crossover mode by modifying reg MII_M1011_PHY_SCR, then it
calls marvell_set_downshift() to config downshift by modifying
the same reg. According to the bug, marvell_set_downshift()
clears other bits and set MDI Crossover Mode to Manual MDI
configuration. If we connect two devices both using this driver
with a wrong Ethernet cable, they can't automatically adjust
their crossover mode. Finally they fail to link.

Signed-off-by: Hansen Yang <yanghansen1@163.com>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index a7796134e3be..6ab8fe339043 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -282,7 +282,7 @@ static int marvell_set_downshift(struct phy_device *phydev, bool enable,
 	if (reg < 0)
 		return reg;
 
-	reg &= MII_M1011_PHY_SRC_DOWNSHIFT_MASK;
+	reg &= ~MII_M1011_PHY_SRC_DOWNSHIFT_MASK;
 	reg |= ((retries - 1) << MII_M1011_PHY_SCR_DOWNSHIFT_SHIFT);
 	if (enable)
 		reg |= MII_M1011_PHY_SCR_DOWNSHIFT_EN;
-- 
2.17.1


