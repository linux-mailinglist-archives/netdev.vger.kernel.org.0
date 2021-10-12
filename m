Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062D142A232
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235945AbhJLKgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:36:40 -0400
Received: from mx1.tq-group.com ([93.104.207.81]:7153 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235881AbhJLKgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 06:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634034878; x=1665570878;
  h=from:to:cc:subject:date:message-id;
  bh=N3FxWyyAhPx0EQn+niL7GP8WkVwBY4Mf5vip22eXHKQ=;
  b=oisi1YQHZX/o3Zs3AalhyqsJ8n7eLL/lGFaSYe481griVrVOoR0fYiHA
   0PlCxQxmcJsbPy5VwiiSuWwVPzvFgOShQrcbEe9UWYVz3zYC/yYTF1vUR
   63t7yGze1TAaE9lsZfYPgyRsMIqF2AGYa5jWubyMZyWnVbt/KNAVkntxU
   g6VGSJ8nkubL+++ARph2UACllAv1fRLaLup+SVCYZY+C8KHp2CwUp49hv
   ASs/vGDs+LJxCZyFKRBIELl5de7uE31q7GgcWIyM9vVL7kh1PhxcX1CAr
   qdcrAsU+CD2qno9PfwdVUSMg+8oIP7X9+AoM3be4bt3cMJSn8xcq+T7tR
   g==;
X-IronPort-AV: E=Sophos;i="5.85,367,1624312800"; 
   d="scan'208";a="19994409"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 12 Oct 2021 12:34:37 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Tue, 12 Oct 2021 12:34:37 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Tue, 12 Oct 2021 12:34:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634034877; x=1665570877;
  h=from:to:cc:subject:date:message-id;
  bh=N3FxWyyAhPx0EQn+niL7GP8WkVwBY4Mf5vip22eXHKQ=;
  b=BXiFBM8bd0rxV9Wmf0T+NviUMvxMUlOMnnm7mrpWRDMSudr2sIV/9cO5
   wtGV++GuxiQIcAPA2oyT4VQK6ldQnKbZ1o53Y65Nlw5xSgKmN4+/8v5a6
   xeF9wok3VEzG/RaHxs5QJr2DUV7zufZoBftJhdsOU5PSOiPCP+yKTQzyB
   +Wy1bBmxcOTg4Xzloh39cF4Hjd6oYsoEFo3Zlg8ke0BU7Z0mBMSc4/K5C
   M1njpVoB1XqBFT4Ak14QTnKck9hw+G1I+MhMowb2/lnK3VpNaLCbIzK6W
   GpFKtuCFLLmcY2VCGy44W5w/ksSo0FvoeWhcTFEKVFPdHI84L3CNAHz8z
   w==;
X-IronPort-AV: E=Sophos;i="5.85,367,1624312800"; 
   d="scan'208";a="19994408"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 12 Oct 2021 12:34:37 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id EB084280065;
        Tue, 12 Oct 2021 12:34:36 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH] net: phy: micrel: make *-skew-ps check more lenient
Date:   Tue, 12 Oct 2021 12:34:02 +0200
Message-Id: <20211012103402.21438-1-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems reasonable to fine-tune only some of the skew values when using
one of the rgmii-*id PHY modes, and even when all skew values are
specified, using the correct ID PHY mode makes sense for documentation
purposes. Such a configuration also appears in the binding docs in
Documentation/devicetree/bindings/net/micrel-ksz90x1.txt, so the driver
should not warn about it.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/phy/micrel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index c330a5a9f665..03e58ebf68af 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -863,9 +863,9 @@ static int ksz9031_config_init(struct phy_device *phydev)
 				MII_KSZ9031RN_TX_DATA_PAD_SKEW, 4,
 				tx_data_skews, 4, &update);
 
-		if (update && phydev->interface != PHY_INTERFACE_MODE_RGMII)
+		if (update && !phy_interface_is_rgmii(phydev))
 			phydev_warn(phydev,
-				    "*-skew-ps values should be used only with phy-mode = \"rgmii\"\n");
+				    "*-skew-ps values should be used only with RGMII PHY modes\n");
 
 		/* Silicon Errata Sheet (DS80000691D or DS80000692D):
 		 * When the device links in the 1000BASE-T slave mode only,
-- 
2.17.1

