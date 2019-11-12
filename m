Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1017FF9364
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfKLOzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:55:14 -0500
Received: from inva021.nxp.com ([92.121.34.21]:47826 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726659AbfKLOzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 09:55:14 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5C60B200228;
        Tue, 12 Nov 2019 15:55:12 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4E74B2001AB;
        Tue, 12 Nov 2019 15:55:12 +0100 (CET)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 21019205E9;
        Tue, 12 Nov 2019 15:55:12 +0100 (CET)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, danielwa@cisco.com
Subject: [PATCH net] gianfar: Don't force RGMII mode after reset, use defaults
Date:   Tue, 12 Nov 2019 16:55:11 +0200
Message-Id: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We received reports that forcing the MAC into RGMII (1 Gbps)
interface mode after MAC reset occasionally disrupts operation
of PHYs capable only of 100Mbps, even after adjust_link kicks
in and re-adjusts the interface mode in MACCFG2 accordingly.
Instead of forcing MACCFG2 into RGMII mode, let's use the default
reset value of MACCFG2 (that leaves the IF_Mode field unset) and
let adjust_link configure the correct mode from the beginning.
MACCFG2_INIT_SETTINGS is dropped, only the PAD_CRC bit is preserved,
the remaining fields (IF_Mode and Duplex) are left for adjust_link.
Tested on boards with gigabit PHYs.

MACCFG2_INIT_SETTINGS is there since day one, but the issue
got visible after introducing the MAC reset and reconfig support,
which added MAC reset at runtime, at interface open.

Fixes: a328ac92d314 ("gianfar: Implement MAC reset and reconfig procedure")

Reported-by: Daniel Walker <danielwa@cisco.com>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 3 ++-
 drivers/net/ethernet/freescale/gianfar.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 51ad864..0f4d13d 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3173,7 +3173,8 @@ void gfar_mac_reset(struct gfar_private *priv)
 	gfar_write(&regs->minflr, MINFLR_INIT_SETTINGS);
 
 	/* Initialize MACCFG2. */
-	tempval = MACCFG2_INIT_SETTINGS;
+	tempval = gfar_read(&regs->maccfg2);
+	tempval |= MACCFG2_PAD_CRC;
 
 	/* eTSEC74 erratum: Rx frames of length MAXFRM or MAXFRM-1
 	 * are marked as truncated.  Avoid this by MACCFG2[Huge Frame]=1,
diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index f472a6d..cc70e03 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -150,8 +150,8 @@ extern const char gfar_driver_version[];
 #define MACCFG1_SYNCD_TX_EN	0x00000002
 #define MACCFG1_TX_EN		0x00000001
 
-#define MACCFG2_INIT_SETTINGS	0x00007205
 #define MACCFG2_FULL_DUPLEX	0x00000001
+#define MACCFG2_PAD_CRC         0x00000004
 #define MACCFG2_IF              0x00000300
 #define MACCFG2_MII             0x00000100
 #define MACCFG2_GMII            0x00000200
-- 
2.7.4

