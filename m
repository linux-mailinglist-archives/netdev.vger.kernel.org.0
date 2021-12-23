Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D536B47DCC5
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345672AbhLWBOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:14:10 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:17822 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238565AbhLWBOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=TCoMVHSYVhkJgtIGjOgzk6pH7Tut5PTIvOcUiLqFDQU=;
        b=f5ysdqv03gdXWYFLzx74xdkovU0c7CKKXPvqkekpBCrwEMB9/+9R6qW7EHY+OqCnaFk6
        cOu8o/9ghIl4ftlm7BGiET/IntCN8AbdIcFPYfYsyNesRji2py+vKnwVQtjadoGRW/JTFW
        dS1y4cfWVCd+vynlPiRnL3iXhotce/qtpTyWTsZ8VC+64Uyn/w9AcTrvP3lsnQir+71t7l
        CoYtq5UnA6Nx37k9MQbZSj1k9c3PyrxrwNlF6CjgeTGMLwTSqZJlvtS7lkwsTGsrfU6ui0
        Z1Rds78oIkt2VGGZ9uCDHYXI+jnMKDqsLNOx/1G63CyukueLg6OcMeeK7qLvZodw==
Received: by filterdrecv-7bf5c69d5-88tll with SMTP id filterdrecv-7bf5c69d5-88tll-1-61C3CD5D-46
        2021-12-23 01:14:05.78637051 +0000 UTC m=+9687224.636323211
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-3-1 (SG)
        with ESMTP
        id hdnbALfbTKOlXMkxIs8p2g
        Thu, 23 Dec 2021 01:14:05.582 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id D75527009E9; Wed, 22 Dec 2021 18:14:04 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 03/50] wilc1000: move receive-queue stats from txq to wilc
 structure
Date:   Thu, 23 Dec 2021 01:14:06 +0000 (UTC)
Message-Id: <20211223011358.4031459-4-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvHpcdJyjK68kH7Sar?=
 =?us-ascii?Q?FuF+9wd2pQ9CycCQS3psyU5a2BgiM9NfanPTTGn?=
 =?us-ascii?Q?r3zYONbprcPrw1z=2FH8X3gZmbkZcyk3dg=2Fs7VQHJ?=
 =?us-ascii?Q?8RL2MyolwdEDrKPjgmSnmyFxcjAwkS56DB5z1dM?=
 =?us-ascii?Q?STQQcWnFGoiIZJjzZadq7CVNokJ96Bg3tymUab?=
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
index c07f58a86bc76..d88fee8f9a6b0 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -256,6 +256,7 @@ struct wilc {
 
 	struct txq_handle txq[NQUEUES];
 	int txq_entries;
+	struct txq_fw_recv_queue_stat fw[NQUEUES];
 
 	struct wilc_tx_queue_status tx_q_limit;
 	struct rxq_entry_t rxq_head;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 26fa7078acffd..d1f68df1dbeef 100644
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

