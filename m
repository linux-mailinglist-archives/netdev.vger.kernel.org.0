Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA143A1104
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhFIK0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:26:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38484 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238773AbhFIK0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:26:47 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lqvOC-0007LI-Ov; Wed, 09 Jun 2021 10:24:48 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2][next][V2] net: usb: asix: Fix less than zero comparison of a u16
Date:   Wed,  9 Jun 2021 11:24:47 +0100
Message-Id: <20210609102448.182798-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The comparison of the u16 priv->phy_addr < 0 is always false because
phy_addr is unsigned. Fix this by assigning the return from the call
to function asix_read_phy_addr to int ret and using this for the
less than zero error check comparison.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: Add new line, return ret instead of priv->phy_addr on error return path

---
 drivers/net/usb/asix_devices.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 57dafb3262d9..334741a8595d 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -704,9 +704,11 @@ static int ax88772_init_phy(struct usbnet *dev)
 	struct asix_common_private *priv = dev->driver_priv;
 	int ret;
 
-	priv->phy_addr = asix_read_phy_addr(dev, true);
-	if (priv->phy_addr < 0)
-		return priv->phy_addr;
+	ret = asix_read_phy_addr(dev, true);
+	if (ret < 0)
+		return ret;
+
+	priv->phy_addr = ret;
 
 	snprintf(priv->phy_name, sizeof(priv->phy_name), PHY_ID_FMT,
 		 priv->mdio->id, priv->phy_addr);
-- 
2.31.1

