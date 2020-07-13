Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FC921D52E
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgGMLnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:43:01 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18740 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729668AbgGMLnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:43:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DBeSxT024173;
        Mon, 13 Jul 2020 04:42:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=uZjFimt73w2TaYn68tAQhem/v2HfQAXWHSsmSmUL83k=;
 b=ecTwZpUI8LTA00XTNyKhfwgFZyypxGXtgbORtMrUnHvF9F7hiAqwRb100nRCe+ZxXsnf
 F33ppBXGCd1zT6qvYKV3fmJyeZqSnOkg7wDfOwrWQt/PV4O0Yd9kLluwGQqyTe44yC9V
 /q/fV3KEInPfaeeRUDH0siBzBCYyIX0nmjSvDhYn0iQrb1JSHDsFTlIkKuRambT4xqv8
 VC7yEdWVc5HmLDnFiLrSgyOuW74T15Cqpf6vSJOcN8jHRjcdP6qVWCrPzNSd0rm7qrDU
 GfguvKgDCK9geVqcrtEBNWdIB2oTD/s0Y1XeYZQ4aL2u3tyaSBWJufht0eEcGUUzMaFh lw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 327asn76mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Jul 2020 04:42:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:42:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 04:42:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 13 Jul 2020 04:42:56 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.6.200.41])
        by maili.marvell.com (Postfix) with ESMTP id 134D13F703F;
        Mon, 13 Jul 2020 04:42:53 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Belous <pbelous@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 04/10] net: atlantic: PTP statistics
Date:   Mon, 13 Jul 2020 14:42:27 +0300
Message-ID: <20200713114233.436-5-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713114233.436-1-irusskikh@marvell.com>
References: <20200713114233.436-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_10:2020-07-13,2020-07-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Belous <pbelous@marvell.com>

This patch adds PTP rings statistics. Before that
these were missing from overall stats, hardening debugging
and analysis.

Signed-off-by: Pavel Belous <pbelous@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 31 ++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 57 +++++++++++++------
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   | 25 +++++++-
 3 files changed, 94 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 44f2ddfcd202..e55bcc7f64f3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -175,6 +175,14 @@ static u32 aq_ethtool_n_stats(struct net_device *ndev)
 		      ARRAY_SIZE(aq_ethtool_queue_stat_names) * cfg->vecs *
 			cfg->tcs;
 
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
+	if (nic->aq_ptp) {
+		int ring_cnt = aq_ptp_get_ring_cnt(nic);
+
+		n_stats += ARRAY_SIZE(aq_ethtool_queue_stat_names) * ring_cnt;
+	}
+#endif
+
 #if IS_ENABLED(CONFIG_MACSEC)
 	if (nic->macsec_cfg) {
 		n_stats += ARRAY_SIZE(aq_macsec_stat_names) +
@@ -197,6 +205,10 @@ static void aq_ethtool_stats(struct net_device *ndev,
 
 	memset(data, 0, aq_ethtool_n_stats(ndev) * sizeof(u64));
 	data = aq_nic_get_stats(aq_nic, data);
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
+	if (aq_nic->aq_ptp)
+		data = aq_ptp_get_stats(aq_nic, data);
+#endif
 #if IS_ENABLED(CONFIG_MACSEC)
 	data = aq_macsec_get_stats(aq_nic, data);
 #endif
@@ -265,6 +277,25 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 				}
 			}
 		}
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
+		if (nic->aq_ptp) {
+			int ptp_ring_cnt = aq_ptp_get_ring_cnt(nic);
+			unsigned int ptp_ring_idx =
+				aq_ptp_ring_idx(nic->aq_nic_cfg.tc_mode);
+
+			snprintf(tc_string, 8, "PTP ");
+
+			for (i = 0; i < ptp_ring_cnt; i++) {
+				for (si = 0; si < stat_cnt; si++) {
+					snprintf(p, ETH_GSTRING_LEN,
+						 aq_ethtool_queue_stat_names[si],
+						 tc_string,
+						 i ? PTP_HWST_RING_IDX : ptp_ring_idx);
+					p += ETH_GSTRING_LEN;
+				}
+			}
+		}
+#endif
 #if IS_ENABLED(CONFIG_MACSEC)
 		if (!nic->macsec_cfg)
 			break;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index cb9bf41470fd..b4cf9e310e1f 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -81,6 +81,8 @@ struct aq_ptp_s {
 
 	bool extts_pin_enabled;
 	u64 last_sync1588_ts;
+
+	bool a1_ptp;
 };
 
 struct ptp_tm_offset {
@@ -945,21 +947,6 @@ void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic)
 	aq_ring_rx_deinit(&aq_ptp->ptp_rx);
 }
 
-#define PTP_8TC_RING_IDX             8
-#define PTP_4TC_RING_IDX            16
-#define PTP_HWST_RING_IDX           31
-
-/* Index must be 8 (8 TCs) or 16 (4 TCs).
- * It depends on Traffic Class mode.
- */
-static unsigned int ptp_ring_idx(const enum aq_tc_mode tc_mode)
-{
-	if (tc_mode == AQ_TC_MODE_8TCS)
-		return PTP_8TC_RING_IDX;
-
-	return PTP_4TC_RING_IDX;
-}
-
 int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 {
 	struct aq_ptp_s *aq_ptp = aq_nic->aq_ptp;
@@ -971,7 +958,7 @@ int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 	if (!aq_ptp)
 		return 0;
 
-	tx_ring_idx = ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
+	tx_ring_idx = aq_ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
 
 	ring = aq_ring_tx_alloc(&aq_ptp->ptp_tx, aq_nic,
 				tx_ring_idx, &aq_nic->aq_nic_cfg);
@@ -980,7 +967,7 @@ int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 		goto err_exit;
 	}
 
-	rx_ring_idx = ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
+	rx_ring_idx = aq_ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
 
 	ring = aq_ring_rx_alloc(&aq_ptp->ptp_rx, aq_nic,
 				rx_ring_idx, &aq_nic->aq_nic_cfg);
@@ -1172,11 +1159,17 @@ static void aq_ptp_poll_sync_work_cb(struct work_struct *w);
 
 int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
 {
+	bool a1_ptp = ATL_HW_IS_CHIP_FEATURE(aq_nic->aq_hw, ATLANTIC);
 	struct hw_atl_utils_mbox mbox;
 	struct ptp_clock *clock;
 	struct aq_ptp_s *aq_ptp;
 	int err = 0;
 
+	if (!a1_ptp) {
+		aq_nic->aq_ptp = NULL;
+		return 0;
+	}
+
 	if (!aq_nic->aq_hw_ops->hw_get_ptp_ts) {
 		aq_nic->aq_ptp = NULL;
 		return 0;
@@ -1203,6 +1196,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
 	}
 
 	aq_ptp->aq_nic = aq_nic;
+	aq_ptp->a1_ptp = a1_ptp;
 
 	spin_lock_init(&aq_ptp->ptp_lock);
 	spin_lock_init(&aq_ptp->ptp_ring_lock);
@@ -1393,4 +1387,33 @@ static void aq_ptp_poll_sync_work_cb(struct work_struct *w)
 		schedule_delayed_work(&aq_ptp->poll_sync, timeout);
 	}
 }
+
+int aq_ptp_get_ring_cnt(struct aq_nic_s *aq_nic)
+{
+	return aq_nic->aq_ptp->a1_ptp ? 2 : 1;
+}
+
+u64 *aq_ptp_get_stats(struct aq_nic_s *aq_nic, u64 *data)
+{
+	struct aq_ptp_s *aq_ptp = aq_nic->aq_ptp;
+	struct aq_ring_stats_rx_s *stats_rx;
+	struct aq_ring_stats_tx_s *stats_tx;
+	unsigned int count = 0U;
+
+	stats_rx = &aq_ptp->ptp_rx.stats.rx;
+	stats_tx = &aq_ptp->ptp_tx.stats.tx;
+
+	aq_nic_fill_stats_data(stats_rx, stats_tx, data, &count);
+
+	if (aq_ptp->a1_ptp) {
+		data += count;
+		stats_rx = &aq_ptp->hwts_rx.stats.rx;
+		/* Only Receive ring for HWTS */
+		memset(stats_tx, 0, sizeof(struct aq_ring_stats_tx_s));
+		aq_nic_fill_stats_data(stats_rx, stats_tx, data, &count);
+	}
+
+	return data;
+}
+
 #endif
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
index 231906431a48..ccf0f4d0156c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
@@ -1,6 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Aquantia Corporation Network Driver
- * Copyright (C) 2014-2019 Aquantia Corporation. All rights reserved
+/* Atlantic Network Driver
+ *
+ * Copyright (C) 2014-2019 aQuantia Corporation
+ * Copyright (C) 2019-2020 Marvell International Ltd.
  */
 
 /* File aq_ptp.h: Declaration of PTP functions.
@@ -10,6 +12,21 @@
 
 #include <linux/net_tstamp.h>
 
+#define PTP_8TC_RING_IDX             8
+#define PTP_4TC_RING_IDX            16
+#define PTP_HWST_RING_IDX           31
+
+/* Index must to be 8 (8 TCs) or 16 (4 TCs).
+ * It depends from Traffic Class mode.
+ */
+static inline unsigned int aq_ptp_ring_idx(const enum aq_tc_mode tc_mode)
+{
+	if (tc_mode == AQ_TC_MODE_8TCS)
+		return PTP_8TC_RING_IDX;
+
+	return PTP_4TC_RING_IDX;
+}
+
 #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
 
 /* Common functions */
@@ -55,6 +72,10 @@ struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_ptp_s *aq_ptp);
 
 int aq_ptp_link_change(struct aq_nic_s *aq_nic);
 
+/* PTP ring statistics */
+int aq_ptp_get_ring_cnt(struct aq_nic_s *aq_nic);
+u64 *aq_ptp_get_stats(struct aq_nic_s *aq_nic, u64 *data);
+
 #else
 
 static inline int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
-- 
2.17.1

