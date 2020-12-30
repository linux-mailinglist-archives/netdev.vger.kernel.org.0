Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838192E7AAC
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 16:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgL3PtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 10:49:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726503AbgL3PtO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 10:49:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 303CE2226A;
        Wed, 30 Dec 2020 15:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609343305;
        bh=Awk7q1ExXD7Z9lZQDOFC5znJcmFblLnxGitRya5UfYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NEV2DHLDRI3LkegT0vlCrbnjjpxF2dgcm59fZM2S8IJArr/SUAN4UV5JbqzpxMDKm
         yQ5kStEqLo2gssE0Mr8tesfOeh+u2F29N6f/tDLJh40mK4MSCZrTtOjTs2OPVeK2wx
         Oiz5mKZgvyaVWafCaeIreY5I2uX518j0ClqX6J3nMojixIo+QNu2piItKoJ3q2K2MV
         dlDVrrKX5w3yzvifN5moebP/DqRcS0AdouTPybVDyYiR4h7wixaxcJ1nxNwJcvfL5d
         UyvZCI3pf3hNtQgoMEOYEuIFcrw5K0EFNoDCtI+IUkNRE8fB31v4eSCYl3gUod2KcF
         Z66JFoWJ1iI6w==
Received: by pali.im (Postfix)
        id 891E89F8; Wed, 30 Dec 2020 16:48:23 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant
Date:   Wed, 30 Dec 2020 16:47:55 +0100
Message-Id: <20201230154755.14746-5-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201230154755.14746-1-pali@kernel.org>
References: <20201230154755.14746-1-pali@kernel.org>
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
 drivers/net/phy/sfp-bus.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

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
 
-- 
2.20.1

