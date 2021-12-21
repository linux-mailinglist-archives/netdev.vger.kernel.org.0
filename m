Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D52847C8A1
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 22:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhLUVFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 16:05:47 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:49170 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235987AbhLUVFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 16:05:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=PCLxbgdBZ3OmOEZffUOW/vzohu7fhG9S+D6KwRelZrI=;
        b=TEoSoAf/raJ7bNVDKFilgD9bYyhhQA7YU+HLl8TcFycG3GnzkGLWDGV0briVUm2vD38Y
        cE0MuagTvp6YUv5czL7mRSKfpQqgsxKXRcxYZjQ6s+JwZOZt1n8WsbKfC45oaVddhTVMLY
        hkcSrB4LwPIr0UJ4j52RBK+JAeFB01+bJmBGg6kPuwPySiO6UgW1L/DYuBIb3JvvwQ59c5
        PgT+v0ZMAL0ZDUE5iCEB0OVkbxkVJI8PuUpG4Zr1KBPb0zGQMtq/Y/OATQ/Zdqx4g5UZKf
        yAc52yWRHRPZ9vdf59fl2oIxLFIZzg27x7Dv+4wu5nkutU9X7+nEgptpoBTXuPTA==
Received: by filterdrecv-75ff7b5ffb-t2q6v with SMTP id filterdrecv-75ff7b5ffb-t2q6v-1-61C241A5-67
        2021-12-21 21:05:41.484513094 +0000 UTC m=+9585906.758609592
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-canary-0 (SG)
        with ESMTP
        id tXJaUxzDSBa_RJ4rkk52vg
        Tue, 21 Dec 2021 21:05:41.329 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 946A8700264; Tue, 21 Dec 2021 14:05:40 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2] wilc1000: Convert static "chipid" variable to device-local
 variable
Date:   Tue, 21 Dec 2021 21:05:41 +0000 (UTC)
Message-Id: <20211221210538.4011227-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvIHcFai2cBcIjEWEk?=
 =?us-ascii?Q?xqh=2FhG9hvKnEvkpirPvP4YZZ6D1CKF1urmoep2B?=
 =?us-ascii?Q?E3mWIuaztXnFLfbqKSzWvbe=2FyQqmD8QvoBS8u7i?=
 =?us-ascii?Q?JJzJikW8X+ldMK5oi8PkkgIblDM9UNBGdwxlh6G?=
 =?us-ascii?Q?AUu1NYYCPdC5QT9QZP3rY9=2Ful12F8ae4EtZwQO?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
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
v2: Rebase to latest wireless-drivers-next.

 .../net/wireless/microchip/wilc1000/netdev.h  |  1 +
 .../net/wireless/microchip/wilc1000/wlan.c    | 27 +++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index 6c0e634d02499..a067274c20144 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -212,6 +212,7 @@ struct wilc {
 	s8 mac_status;
 	struct clk *rtc_clk;
 	bool initialized;
+	u32 chipid;
 	bool power_save_mode;
 	int dev_irq_num;
 	int close;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 3f339c2f46f11..a2aa8894320f2 100644
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

