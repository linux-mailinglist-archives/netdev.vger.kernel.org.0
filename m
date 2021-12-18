Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BC5479E36
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhLRXyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:18 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25304 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhLRXyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=v7mhVC8oOz6jVz3FqzbpHDEQb0xvpcFgFAT/KNJ3tFk=;
        b=WJFXWzdfsC+OIXaa1TNfd8VY4OQ2FWZf1DjV8liOWlGms/iixnxWf2IYxLyoeTwTp+3O
        9ArahNQ+sZXvIjuDpwp2BK77RAnPBOtAh4Q8iYeR0wjBle+ocyLm3rbmSQ8i3zvyd3x8DN
        t6UiHLThfQyfXQUnnLyfrMR/5AZlk9ohYmgOWXoCCm3P/h5gmEvPsWmIZ99IZo1B+Vcv4Z
        PPwrz+2enC0XolwrrurT6wMwHAFks0NgwNgrJlc+gr08rGd4CDHrDaHTtzO+5iecG6B3rI
        +tKFvlelVI7ACUX6HIPNYljIHcr4f5ZeZw2M9MBgAgq52dYHBFF2u9GC/R1B2d9g==
Received: by filterdrecv-64fcb979b9-5m6bg with SMTP id filterdrecv-64fcb979b9-5m6bg-1-61BE74A8-15
        2021-12-18 23:54:16.521131114 +0000 UTC m=+8294248.488193823
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-5-0 (SG)
        with ESMTP
        id 9_004Y47RlWVNmE_OdvBYw
        Sat, 18 Dec 2021 23:54:16.323 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 89CAD700694; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 03/23] wilc1000: move receive-queue stats from txq to wilc
 structure
Date:   Sat, 18 Dec 2021 23:54:16 +0000 (UTC)
Message-Id: <20211218235404.3963475-4-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvOefZa1KROfX6WNE6?=
 =?us-ascii?Q?WJTSIBXCw4Y8gXfoILR78bvyRBoeZwMCihyeVhc?=
 =?us-ascii?Q?XVgjU00tWHB+j8HM7ZkWNzKPPFf4W9Luh3g2qY+?=
 =?us-ascii?Q?25OQys9aOFEmn7rTzn8acrdVfaMN8I89J8vK83G?=
 =?us-ascii?Q?xLbNi4=2FbLEjJtk0nu=2FRLZk2dFtIZC6xbA8e8UL?=
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

This is in preparation of switching the transmit queue to struct
sk_buffs.  There is no functional change other than moving the
location of the structure.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/netdev.h  |  1 +
 .../net/wireless/microchip/wilc1000/wlan.c    | 28 +++++++++----------
 .../net/wireless/microchip/wilc1000/wlan.h    |  1 -
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index 65cf296a8689e..ce79bdcc28000 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -254,6 +254,7 @@ struct wilc {
 
 	struct txq_handle txq[NQUEUES];
 	int txq_entries;
+	struct txq_fw_recv_queue_stat fw[NQUEUES];
 
 	struct wilc_tx_queue_status tx_q_limit;
 	struct rxq_entry_t rxq_head;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index fafeabe2537a3..2d103131b2e93 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -373,32 +373,32 @@ static inline int ac_balance(struct wilc *wl, u8 *ratio)
 		return -EINVAL;
 
 	for (i = 0; i < NQUEUES; i++)
-		if (wl->txq[i].fw.count > max_count)
-			max_count = wl->txq[i].fw.count;
+		if (wl->fw[i].count > max_count)
+			max_count = wl->fw[i].count;
 
 	for (i = 0; i < NQUEUES; i++)
-		ratio[i] = max_count - wl->txq[i].fw.count;
+		ratio[i] = max_count - wl->fw[i].count;
 
 	return 0;
 }
 
 static inline void ac_update_fw_ac_pkt_info(struct wilc *wl, u32 reg)
 {
-	wl->txq[AC_BK_Q].fw.count = FIELD_GET(BK_AC_COUNT_FIELD, reg);
-	wl->txq[AC_BE_Q].fw.count = FIELD_GET(BE_AC_COUNT_FIELD, reg);
-	wl->txq[AC_VI_Q].fw.count = FIELD_GET(VI_AC_COUNT_FIELD, reg);
-	wl->txq[AC_VO_Q].fw.count = FIELD_GET(VO_AC_COUNT_FIELD, reg);
-
-	wl->txq[AC_BK_Q].fw.acm = FIELD_GET(BK_AC_ACM_STAT_FIELD, reg);
-	wl->txq[AC_BE_Q].fw.acm = FIELD_GET(BE_AC_ACM_STAT_FIELD, reg);
-	wl->txq[AC_VI_Q].fw.acm = FIELD_GET(VI_AC_ACM_STAT_FIELD, reg);
-	wl->txq[AC_VO_Q].fw.acm = FIELD_GET(VO_AC_ACM_STAT_FIELD, reg);
+	wl->fw[AC_BK_Q].count = FIELD_GET(BK_AC_COUNT_FIELD, reg);
+	wl->fw[AC_BE_Q].count = FIELD_GET(BE_AC_COUNT_FIELD, reg);
+	wl->fw[AC_VI_Q].count = FIELD_GET(VI_AC_COUNT_FIELD, reg);
+	wl->fw[AC_VO_Q].count = FIELD_GET(VO_AC_COUNT_FIELD, reg);
+
+	wl->fw[AC_BK_Q].acm = FIELD_GET(BK_AC_ACM_STAT_FIELD, reg);
+	wl->fw[AC_BE_Q].acm = FIELD_GET(BE_AC_ACM_STAT_FIELD, reg);
+	wl->fw[AC_VI_Q].acm = FIELD_GET(VI_AC_ACM_STAT_FIELD, reg);
+	wl->fw[AC_VO_Q].acm = FIELD_GET(VO_AC_ACM_STAT_FIELD, reg);
 }
 
 static inline u8 ac_change(struct wilc *wilc, u8 *ac)
 {
 	do {
-		if (wilc->txq[*ac].fw.acm == 0)
+		if (wilc->fw[*ac].acm == 0)
 			return 0;
 		(*ac)++;
 	} while (*ac < NQUEUES);
@@ -920,7 +920,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 		kfree(tqe);
 	} while (--entries);
 	for (i = 0; i < NQUEUES; i++)
-		wilc->txq[i].fw.count += ac_pkt_num_to_chip[i];
+		wilc->fw[i].count += ac_pkt_num_to_chip[i];
 
 	acquire_bus(wilc, WILC_BUS_ACQUIRE_AND_WAKEUP);
 
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.h b/drivers/net/wireless/microchip/wilc1000/wlan.h
index eb7978166d73e..9b33262909e2f 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.h
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.h
@@ -341,7 +341,6 @@ struct txq_fw_recv_queue_stat {
 struct txq_handle {
 	struct txq_entry_t txq_head;
 	u16 count;
-	struct txq_fw_recv_queue_stat fw;
 };
 
 struct rxq_entry_t {
-- 
2.25.1

