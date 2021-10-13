Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C8A42BD91
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhJMKsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:48:02 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:46721 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229795AbhJMKsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 06:48:01 -0400
Received: from ersatz.molgen.mpg.de (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5F1F661E64760;
        Wed, 13 Oct 2021 12:45:56 +0200 (CEST)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Paul Menzel <pmenzel@molgen.mpg.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: sfp: add quirk for Finisar FTLF8536P4BCL
Date:   Wed, 13 Oct 2021 12:45:42 +0200
Message-Id: <20211013104542.14146-1-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taras Chornyi <taras.chornyi@plvision.eu>

Finisar FTLF8536P4BCL can operate at 1000base-X and 10000base-SR, but
reports 25G & 100GBd SR in it's EEPROM.

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>

[Upstream from https://github.com/dentproject/dentOS/pull/133/commits/b87b10ef72ea4638e80588facf3c9c2c1be67b40]

Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 drivers/net/phy/sfp-bus.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 7362f8c3271c..162b4030a863 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -55,6 +55,13 @@ static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
 	phylink_set(modes, 1000baseX_Full);
 }
 
+static void sfp_quirk_finisar_25g(const struct sfp_eeprom_id *id,
+				  unsigned long *modes)
+{
+	phylink_set(modes, 1000baseX_Full);
+	phylink_set(modes, 10000baseSR_Full);
+}
+
 static const struct sfp_quirk sfp_quirks[] = {
 	{
 		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
@@ -78,7 +85,13 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "UBNT",
 		.part = "UF-INSTANT",
 		.modes = sfp_quirk_ubnt_uf_instant,
-	},
+	}, {
+		// Finisar FTLF8536P4BCL can operate at 1000base-X and 10000base-SR,
+		// but reports 25G & 100GBd SR in it's EEPROM
+		.vendor = "FINISAR CORP.",
+		.part = "FTLF8536P4BCL",
+		.modes = sfp_quirk_finisar_25g,
+	}
 };
 
 static size_t sfp_strlen(const char *str, size_t maxlen)
-- 
2.33.0

