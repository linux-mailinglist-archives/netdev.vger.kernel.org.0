Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA7B2EC087
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 16:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbhAFPja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 10:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbhAFPj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 10:39:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A43F23121;
        Wed,  6 Jan 2021 15:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609947526;
        bh=17tJUBRoR9N7Dis3fpYvNsowe4Tvb8Y31WB2QigVwX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sae8kcBYdz5xHk5oYcoSeIjsRjHA8Y26R+y8w66wJ+TqFvOABh1Yq/bdNojzyrek3
         kSNv5fb2CiwyjOpHxNw0tqlRdUaA4AAiVmn+fxVbqoHd9ruj5a4sdJzE4jVLpcyCQ7
         NBOH/yCZB0GVN/HbhmvYqeuD8W1HwTMJLTTUUK5DQbAPn7+q0QRzyq1lhOUEmCNsW1
         2PiFbH2U7MwYz8VqPab3Xbe4viB1N5KVFCg32m6elk7SZmj6kBkRuXfYVlHnpLcspN
         RgvnkEs9nBkA/XX10AqaDblke4WP0WOqxCgVfd3dipm2nRZPy2Rh1LmtYVUJMH5Gvv
         rClYmJ35Uddjw==
Received: by pali.im (Postfix)
        id E50FB44E; Wed,  6 Jan 2021 16:38:44 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant
Date:   Wed,  6 Jan 2021 16:37:49 +0100
Message-Id: <20210106153749.6748-4-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210106153749.6748-1-pali@kernel.org>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SFP GPON module Ubiquiti U-Fiber Instant has in its EEPROM stored nonsense
information. It claims that support all transceiver types including 10G
Ethernet which is not truth. So clear all claimed modes and set only one
mode which module supports: 1000baseX_Full.

Also this module have set SFF phys_id in its EEPROM. Kernel SFP subsustem
currently does not allow to use SFP modules detected as SFF. Therefore add
and exception for this module so it can be detected as supported.

This change finally allows to detect and use SFP GPON module Ubiquiti
U-Fiber Instant on Linux system.

EEPROM content of this SFP module is (where XX is serial number):

00: 02 04 0b ff ff ff ff ff ff ff ff 03 0c 00 14 c8    ???........??.??
10: 00 00 00 00 55 42 4e 54 20 20 20 20 20 20 20 20    ....UBNT
20: 20 20 20 20 00 18 e8 29 55 46 2d 49 4e 53 54 41        .??)UF-INSTA
30: 4e 54 20 20 20 20 20 20 34 20 20 20 05 1e 00 36    NT      4   ??.6
40: 00 06 00 00 55 42 4e 54 XX XX XX XX XX XX XX XX    .?..UBNTXXXXXXXX
50: 20 20 20 20 31 34 30 31 32 33 20 20 60 80 02 41        140123  `??A

Signed-off-by: Pali Rohár <pali@kernel.org>

---
Changes in v2:
* add this module also into sfp_module_supported() function
---
 drivers/net/phy/sfp-bus.c | 15 +++++++++++++++
 drivers/net/phy/sfp.c     | 17 +++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 20b91f5dfc6e..4cf874fb5c5b 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -44,6 +44,17 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 	phylink_set(modes, 2500baseX_Full);
 }
 
+static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
+				      unsigned long *modes)
+{
+	/* Ubiquiti U-Fiber Instant module claims that support all transceiver
+	 * types including 10G Ethernet which is not truth. So clear all claimed
+	 * modes and set only one mode which module supports: 1000baseX_Full.
+	 */
+	phylink_zero(modes);
+	phylink_set(modes, 1000baseX_Full);
+}
+
 static const struct sfp_quirk sfp_quirks[] = {
 	{
 		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
@@ -63,6 +74,10 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "HUAWEI",
 		.part = "MA5671A",
 		.modes = sfp_quirk_2500basex,
+	}, {
+		.vendor = "UBNT",
+		.part = "UF-INSTANT",
+		.modes = sfp_quirk_ubnt_uf_instant,
 	},
 };
 
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 15fb8f7dfe5b..c3a0dcc737fd 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -273,8 +273,21 @@ static const struct sff_data sff_data = {
 
 static bool sfp_module_supported(const struct sfp_eeprom_id *id)
 {
-	return id->base.phys_id == SFF8024_ID_SFP &&
-	       id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP;
+	if (id->base.phys_id == SFF8024_ID_SFP &&
+	    id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP)
+		return true;
+
+	/* SFP GPON module Ubiquiti U-Fiber Instant has in its EEPROM stored
+	 * phys id SFF instead of SFP. Therefore mark this module explicitly
+	 * as supported based on vendor name and pn match.
+	 */
+	if (id->base.phys_id == SFF8024_ID_SFF_8472 &&
+	    id->base.phys_ext_id == SFP_PHYS_EXT_ID_SFP &&
+	    !memcmp(id->base.vendor_name, "UBNT            ", 16) &&
+	    !memcmp(id->base.vendor_pn, "UF-INSTANT      ", 16))
+		return true;
+
+	return false;
 }
 
 static const struct sff_data sfp_data = {
-- 
2.20.1

