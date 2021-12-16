Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7454768AA
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 04:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhLPD0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 22:26:32 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:33740 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbhLPD00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 22:26:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=KRpEVBdV5fyCa6LhCrnHan24UbFb7eiesIdyenFXa7Y=;
        b=vrzxiOGv3LXZ9VKE49ikXabLbdri6NRpcRJNvESo8vdYblH205CB1m0Mb7T2DD3dKFZk
        FJrtbsObpkQc6pjlxYePUR+M/GcOcveepG0hBQMs1z04zTNRtEd5gnbMRJpZ/BmC53kOcY
        8OwswO3ATqxPbx2cnPB4IJLn9/K6/W7JDxGZHcuxCgchcCPt0lw0LjuMz/2babccmmHRac
        k18ADIRXXntkkX4yJD02IecllySf8wOdSIaEfHGoAm+VwUnHkJVLSb8oI60yQRRa2Y+Q5R
        hpGcX4QshnS/cJyPvTM3bvNsr4wqg/QdOnO8pa019rs/MW00PJ1Q45mW3t4Dh52w==
Received: by filterdrecv-75ff7b5ffb-96rhp with SMTP id filterdrecv-75ff7b5ffb-96rhp-1-61BAB1E0-2B
        2021-12-16 03:26:24.932642305 +0000 UTC m=+9090364.813149035
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-1 (SG)
        with ESMTP
        id nfkc_PERRVCbY_jCotLESg
        Thu, 16 Dec 2021 03:26:24.779 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 03B46700E72; Wed, 15 Dec 2021 20:26:24 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH] wilc1000: Convert static "chipid" variable to device-local
 variable
Date:   Thu, 16 Dec 2021 03:26:25 +0000 (UTC)
Message-Id: <20211216032612.3798573-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvBvrXi7igiw3S+MCi?=
 =?us-ascii?Q?w8n5f20b4RWHzEw2hbU+cN3vLQB7L=2FZRmxUZZYa?=
 =?us-ascii?Q?ONJ7E9hp73OJnR2yp4FRhnQ=2FZ5xror6KigESjXJ?=
 =?us-ascii?Q?rG88vDe8mjVvSkJ6TKAUczSDLnmxrASQmmwYsav?=
 =?us-ascii?Q?+47Hrpx0YejyrOAN33ZfKHjoG8HSpbyLHGngq0?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move "chipid" variable into the per-driver structure so the code
doesn't break if more than one wilc1000 module is present.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/netdev.h  |  1 +
 .../net/wireless/microchip/wilc1000/wlan.c    | 27 +++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index b9a88b3e322f..41a92a1368ab 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -212,6 +212,7 @@ struct wilc {
 	s8 mac_status;
 	struct clk *rtc_clk;
 	bool initialized;
+	u32 chipid;
 	int dev_irq_num;
 	int close;
 	u8 vif_num;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 1aa4236a2fe4..c8e103500235 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1443,31 +1443,30 @@ static int init_chip(struct net_device *dev)
 
 u32 wilc_get_chipid(struct wilc *wilc, bool update)
 {
-	static u32 chipid;
-	u32 tempchipid = 0;
+	u32 chipid = 0;
 	u32 rfrevid = 0;
 
-	if (chipid == 0 || update) {
-		wilc->hif_func->hif_read_reg(wilc, WILC_CHIPID, &tempchipid);
+	if (wilc->chipid == 0 || update) {
+		wilc->hif_func->hif_read_reg(wilc, WILC_CHIPID, &chipid);
 		wilc->hif_func->hif_read_reg(wilc, WILC_RF_REVISION_ID,
 					     &rfrevid);
-		if (!is_wilc1000(tempchipid)) {
-			chipid = 0;
-			return chipid;
+		if (!is_wilc1000(chipid)) {
+			wilc->chipid = 0;
+			return wilc->chipid;
 		}
-		if (tempchipid == WILC_1000_BASE_ID_2A) { /* 0x1002A0 */
+		if (chipid == WILC_1000_BASE_ID_2A) { /* 0x1002A0 */
 			if (rfrevid != 0x1)
-				tempchipid = WILC_1000_BASE_ID_2A_REV1;
-		} else if (tempchipid == WILC_1000_BASE_ID_2B) { /* 0x1002B0 */
+				chipid = WILC_1000_BASE_ID_2A_REV1;
+		} else if (chipid == WILC_1000_BASE_ID_2B) { /* 0x1002B0 */
 			if (rfrevid == 0x4)
-				tempchipid = WILC_1000_BASE_ID_2B_REV1;
+				chipid = WILC_1000_BASE_ID_2B_REV1;
 			else if (rfrevid != 0x3)
-				tempchipid = WILC_1000_BASE_ID_2B_REV2;
+				chipid = WILC_1000_BASE_ID_2B_REV2;
 		}
 
-		chipid = tempchipid;
+		wilc->chipid = chipid;
 	}
-	return chipid;
+	return wilc->chipid;
 }
 
 int wilc_wlan_init(struct net_device *dev)
-- 
2.25.1

