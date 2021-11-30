Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F62C462DE4
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 08:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239196AbhK3Hyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 02:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239212AbhK3Hye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 02:54:34 -0500
X-Greylist: delayed 672 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Nov 2021 23:51:14 PST
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51F7C061746
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 23:51:14 -0800 (PST)
Received: from miraculix.mork.no ([IPv6:2a01:799:95f:8b0a:1e21:3a05:ad2e:f4a6])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 1AU7djYS3670446
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 30 Nov 2021 08:39:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1638257986; bh=MdhgJmRuBVPrlLFEYYA6UyP1RKqvOI80nMgCe14kU2s=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=CUhC0MCf92fzae7EfBY4huOT0cS7KQqIyPuD0jz4X+UoIDdT1KTp0LilEEqDabRxP
         br83M6iUWKKTF22r3ncX6GtEBOvP0YgMxL/YTWFUDEg4XZGw6W7wSGhhZGgYKSROLa
         7BNWCvVTdo9UGZq4tku2Wfdl8MNSZkdHaLPfbIhQ=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1mrxjn-001a4V-GF; Tue, 30 Nov 2021 08:39:39 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        =?UTF-8?q?=E7=85=A7=E5=B1=B1=E5=91=A8=E4=B8=80=E9=83=8E?= 
        <teruyama@springboard-inc.jp>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net,stable] phy: sfp: fix high power modules without diag mode
Date:   Tue, 30 Nov 2021 08:39:29 +0100
Message-Id: <20211130073929.376942-1-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change
modules") changed semantics for high power modules without diag mode.
We repeatedly try to read the current power status from the non-existing
0xa2 address, in the futile hope this failure is temporary:

[    8.856051] sfp sfp-eth3: module NTT              0000000000000000 rev 0000 sn 0000000000000000 dc 160408
[    8.865843] mvpp2 f4000000.ethernet eth3: switched to inband/1000base-x link mode
[    8.873469] sfp sfp-eth3: Failed to read EEPROM: -5
[    8.983251] sfp sfp-eth3: Failed to read EEPROM: -5
[    9.103250] sfp sfp-eth3: Failed to read EEPROM: -5

Eeprom dump:

0x0000: 03 04 01 00 00 00 80 00 00 00 00 01 0d 00 0a 64
0x0010: 00 00 00 00 4e 54 54 20 20 20 20 20 20 20 20 20
0x0020: 20 20 20 20 00 00 00 00 30 30 30 30 30 30 30 30
0x0030: 30 30 30 30 30 30 30 30 30 30 30 30 05 1e 00 7d
0x0040: 02 00 00 00 30 30 30 30 30 30 30 30 30 30 30 30
0x0050: 30 30 30 30 31 36 30 34 30 38 20 20 00 00 00 75
0x0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x0090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0x00f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Previously we assumed such modules were powered up in the correct
mode, continuing without further configuration as long as the
required power class was supported by the host.

Revert to that behaviour, refactoring to keep the improved
diagnostic messages.

Fixes: 7cfa9c92d0a3 ("net: sfp: avoid power switch on address-change modules")
Reported-and-tested-by: 照山周一郎 <teruyama@springboard-inc.jp>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/phy/sfp.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index ab77a9f439ef..9742469a1e58 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1647,27 +1647,6 @@ static int sfp_module_parse_power(struct sfp *sfp)
 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
 		power_mW = 2000;
 
-	if (power_mW > sfp->max_power_mW) {
-		/* Module power specification exceeds the allowed maximum. */
-		if (sfp->id.ext.sff8472_compliance ==
-			SFP_SFF8472_COMPLIANCE_NONE &&
-		    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
-			/* The module appears not to implement bus address
-			 * 0xa2, so assume that the module powers up in the
-			 * indicated mode.
-			 */
-			dev_err(sfp->dev,
-				"Host does not support %u.%uW modules\n",
-				power_mW / 1000, (power_mW / 100) % 10);
-			return -EINVAL;
-		} else {
-			dev_warn(sfp->dev,
-				 "Host does not support %u.%uW modules, module left in power mode 1\n",
-				 power_mW / 1000, (power_mW / 100) % 10);
-			return 0;
-		}
-	}
-
 	/* If the module requires a higher power mode, but also requires
 	 * an address change sequence, warn the user that the module may
 	 * not be functional.
@@ -1679,6 +1658,27 @@ static int sfp_module_parse_power(struct sfp *sfp)
 		return 0;
 	}
 
+	if (sfp->id.ext.sff8472_compliance == SFP_SFF8472_COMPLIANCE_NONE &&
+	    !(sfp->id.ext.diagmon & SFP_DIAGMON_DDM)) {
+		/* The module appears not to implement bus address
+		 * 0xa2, so assume that the module powers up in the
+		 * indicated mode.
+		 */
+		if (power_mW <= sfp->max_power_mW)
+			return 0;
+
+		dev_err(sfp->dev, "Host does not support %u.%uW modules\n",
+			power_mW / 1000, (power_mW / 100) % 10);
+		return -EINVAL;
+	}
+
+	if (power_mW > sfp->max_power_mW) {
+		dev_warn(sfp->dev,
+			 "Host does not support %u.%uW modules, module left in power mode 1\n",
+			 power_mW / 1000, (power_mW / 100) % 10);
+		return 0;
+	}
+
 	sfp->module_power_mW = power_mW;
 
 	return 0;
-- 
2.30.2

