Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B362EC085
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 16:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbhAFPj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 10:39:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbhAFPjY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 10:39:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8FEE23120;
        Wed,  6 Jan 2021 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609947523;
        bh=ULOW1MbfEc92miB+HDwds4nm4ZJaMXzTrInSe+HvzKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAs0zfHQS07/sykdHjoDmwuenSHb4Mnpegxhgh+jstmG7kUdThulfvo5t/V/oXHA8
         0N5/6+UlLtHYRwVt+eHuQO2NzMe+T2bvAxDDTgfqZlMnniL3+1EFqVRXG8/FW0wwbW
         LvVbM8jLUMvWOhUxasjbzMDsezn4zbacWcz9GN+b35kCRAnmNR7BJnUUgbcMPVjetH
         1SxEUThBhpvYIAU+/8SDctSdTGR1V5sC8XJTG9w7WgqeUmzOHEYWSXPqUO8h/Cg2Ce
         iupE+oyiZdTIttjmvhW2qtP8LDSeJ5+2ilGWLAWwAfKhzQaiNep5CNK63OI+XjJeD/
         Z9DwZZVJYzOog==
Received: by pali.im (Postfix)
        id 112D944E; Wed,  6 Jan 2021 16:38:42 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] net: sfp: assume that LOS is not implemented if both LOS normal and inverted is set
Date:   Wed,  6 Jan 2021 16:37:48 +0100
Message-Id: <20210106153749.6748-3-pali@kernel.org>
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

From: Russell King <rmk+kernel@armlinux.org.uk>

Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set both
SFP_OPTIONS_LOS_INVERTED and SFP_OPTIONS_LOS_NORMAL bits in their EEPROM.

Such combination of bits is meaningless so assume that LOS signal is not
implemented.

This patch fixes link carrier for GPON SFP module Ubiquiti U-Fiber Instant.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Pali Rohár <pali@kernel.org>

---
Changes in v2:
* Fix author/signed-off-by lines
---
 drivers/net/phy/sfp.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index c0a891cdcd73..15fb8f7dfe5b 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1488,15 +1488,19 @@ static void sfp_sm_link_down(struct sfp *sfp)
 
 static void sfp_sm_link_check_los(struct sfp *sfp)
 {
-	unsigned int los = sfp->state & SFP_F_LOS;
+	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
+	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
+	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
+	bool los = false;
 
 	/* If neither SFP_OPTIONS_LOS_INVERTED nor SFP_OPTIONS_LOS_NORMAL
-	 * are set, we assume that no LOS signal is available.
+	 * are set, we assume that no LOS signal is available. If both are
+	 * set, we assume LOS is not implemented (and is meaningless.)
 	 */
-	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED))
-		los ^= SFP_F_LOS;
-	else if (!(sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL)))
-		los = 0;
+	if (los_options == los_inverted)
+		los = !(sfp->state & SFP_F_LOS);
+	else if (los_options == los_normal)
+		los = !!(sfp->state & SFP_F_LOS);
 
 	if (los)
 		sfp_sm_next(sfp, SFP_S_WAIT_LOS, 0);
@@ -1506,18 +1510,22 @@ static void sfp_sm_link_check_los(struct sfp *sfp)
 
 static bool sfp_los_event_active(struct sfp *sfp, unsigned int event)
 {
-	return (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED) &&
-		event == SFP_E_LOS_LOW) ||
-	       (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL) &&
-		event == SFP_E_LOS_HIGH);
+	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
+	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
+	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
+
+	return (los_options == los_inverted && event == SFP_E_LOS_LOW) ||
+	       (los_options == los_normal && event == SFP_E_LOS_HIGH);
 }
 
 static bool sfp_los_event_inactive(struct sfp *sfp, unsigned int event)
 {
-	return (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED) &&
-		event == SFP_E_LOS_HIGH) ||
-	       (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL) &&
-		event == SFP_E_LOS_LOW);
+	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
+	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
+	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
+
+	return (los_options == los_inverted && event == SFP_E_LOS_HIGH) ||
+	       (los_options == los_normal && event == SFP_E_LOS_LOW);
 }
 
 static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
-- 
2.20.1

