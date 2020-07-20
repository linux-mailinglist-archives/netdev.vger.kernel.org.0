Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0423B226E55
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbgGTSdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:33:13 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22250 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730597AbgGTSdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:33:11 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06KIGHiH021998;
        Mon, 20 Jul 2020 11:33:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=91wX8OTL/obnsZMDDQuzgzTEgudFgCc/yvo+dw4lPHk=;
 b=w+EBYpApDnuYrFBKE0xK6cK8hH7jY/+YLTpt/28RBs897iPK2JUzRrz/GqesMe0iXg6Q
 jHWsQ1IDnSYjJ9peRUpH+YLrG4oDlBxjN7IbbeG0Q4SWZIVUEk9aXDRwahGGESKRvm4b
 uv6U8cS9pqf16Vharx28xsiuLAkbn2fIEmbbFrkqoh6s/GqVU7NJwDnCd+W/P7/vjls4
 V78brS8qNFrLWczX5CoZanIRZe3wPrYxUN9wwi2AHg2oSnaLwG4NWQYmRFjkOYNWIo6J
 ZXKtXBdwjhsglSvQTWy8cNWAjz0tL60pzBNq0idhBYZZga7J/IbapFRHIIuSUNyKlMHY eg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkfb99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 11:33:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:33:06 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 11:33:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 20 Jul 2020 11:33:06 -0700
Received: from NN-LT0044.marvell.com (NN-LT0044.marvell.com [10.193.54.8])
        by maili.marvell.com (Postfix) with ESMTP id 313043F7041;
        Mon, 20 Jul 2020 11:33:03 -0700 (PDT)
From:   Mark Starovoytov <mstarovoitov@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>, <netdev@vger.kernel.org>,
        "Pavel Belous" <pbelous@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>
Subject: [PATCH v3 net-next 07/13] net: atlantic: PTP statistics
Date:   Mon, 20 Jul 2020 21:32:38 +0300
Message-ID: <20200720183244.10029-8-mstarovoitov@marvell.com>
X-Mailer: git-send-email 2.26.2.windows.1
In-Reply-To: <20200720183244.10029-1-mstarovoitov@marvell.com>
References: <20200720183244.10029-1-mstarovoitov@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_09:2020-07-20,2020-07-20 signatures=0
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
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 37 ++++++++++++
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   | 60 +++++++++++++------
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   | 27 ++++++++-
 3 files changed, 105 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 9e18d30d2e44..1ab5314c4c1b 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -177,6 +177,11 @@ static u32 aq_ethtool_n_stats(struct net_device *ndev)
 	u32 n_stats = ARRAY_SIZE(aq_ethtool_stat_names) +
 		      (rx_stat_cnt + tx_stat_cnt) * cfg->vecs * cfg->tcs;
 
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
+	n_stats += rx_stat_cnt * aq_ptp_get_ring_cnt(nic, ATL_RING_RX) +
+		   tx_stat_cnt * aq_ptp_get_ring_cnt(nic, ATL_RING_TX);
+#endif
+
 #if IS_ENABLED(CONFIG_MACSEC)
 	if (nic->macsec_cfg) {
 		n_stats += ARRAY_SIZE(aq_macsec_stat_names) +
@@ -199,6 +204,9 @@ static void aq_ethtool_stats(struct net_device *ndev,
 
 	memset(data, 0, aq_ethtool_n_stats(ndev) * sizeof(u64));
 	data = aq_nic_get_stats(aq_nic, data);
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
+	data = aq_ptp_get_stats(aq_nic, data);
+#endif
 #if IS_ENABLED(CONFIG_MACSEC)
 	data = aq_macsec_get_stats(aq_nic, data);
 #endif
@@ -275,6 +283,35 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 				}
 			}
 		}
+#if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
+		if (nic->aq_ptp) {
+			const int rx_ring_cnt = aq_ptp_get_ring_cnt(nic, ATL_RING_RX);
+			const int tx_ring_cnt = aq_ptp_get_ring_cnt(nic, ATL_RING_TX);
+			unsigned int ptp_ring_idx =
+				aq_ptp_ring_idx(nic->aq_nic_cfg.tc_mode);
+
+			snprintf(tc_string, 8, "PTP ");
+
+			for (i = 0; i < max(rx_ring_cnt, tx_ring_cnt); i++) {
+				for (si = 0; si < rx_stat_cnt; si++) {
+					snprintf(p, ETH_GSTRING_LEN,
+						 aq_ethtool_queue_rx_stat_names[si],
+						 tc_string,
+						 i ? PTP_HWST_RING_IDX : ptp_ring_idx);
+					p += ETH_GSTRING_LEN;
+				}
+				if (i >= tx_ring_cnt)
+					continue;
+				for (si = 0; si < tx_stat_cnt; si++) {
+					snprintf(p, ETH_GSTRING_LEN,
+						 aq_ethtool_queue_tx_stat_names[si],
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
index ec6aa9bb7dfc..06de19f63287 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -81,6 +81,8 @@ struct aq_ptp_s {
 
 	bool extts_pin_enabled;
 	u64 last_sync1588_ts;
+
+	bool a1_ptp;
 };
 
 struct ptp_tm_offset {
@@ -947,21 +949,6 @@ void aq_ptp_ring_deinit(struct aq_nic_s *aq_nic)
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
@@ -973,7 +960,7 @@ int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 	if (!aq_ptp)
 		return 0;
 
-	tx_ring_idx = ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
+	tx_ring_idx = aq_ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
 
 	ring = aq_ring_tx_alloc(&aq_ptp->ptp_tx, aq_nic,
 				tx_ring_idx, &aq_nic->aq_nic_cfg);
@@ -982,7 +969,7 @@ int aq_ptp_ring_alloc(struct aq_nic_s *aq_nic)
 		goto err_exit;
 	}
 
-	rx_ring_idx = ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
+	rx_ring_idx = aq_ptp_ring_idx(aq_nic->aq_nic_cfg.tc_mode);
 
 	ring = aq_ring_rx_alloc(&aq_ptp->ptp_rx, aq_nic,
 				rx_ring_idx, &aq_nic->aq_nic_cfg);
@@ -1174,11 +1161,17 @@ static void aq_ptp_poll_sync_work_cb(struct work_struct *w);
 
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
@@ -1205,6 +1198,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
 	}
 
 	aq_ptp->aq_nic = aq_nic;
+	aq_ptp->a1_ptp = a1_ptp;
 
 	spin_lock_init(&aq_ptp->ptp_lock);
 	spin_lock_init(&aq_ptp->ptp_ring_lock);
@@ -1395,4 +1389,36 @@ static void aq_ptp_poll_sync_work_cb(struct work_struct *w)
 		schedule_delayed_work(&aq_ptp->poll_sync, timeout);
 	}
 }
+
+int aq_ptp_get_ring_cnt(struct aq_nic_s *aq_nic, const enum atl_ring_type ring_type)
+{
+	if (!aq_nic->aq_ptp)
+		return 0;
+
+	/* Additional RX ring is allocated for PTP HWTS on A1 */
+	return (aq_nic->aq_ptp->a1_ptp && ring_type == ATL_RING_RX) ? 2 : 1;
+}
+
+u64 *aq_ptp_get_stats(struct aq_nic_s *aq_nic, u64 *data)
+{
+	struct aq_ptp_s *aq_ptp = aq_nic->aq_ptp;
+	unsigned int count = 0U;
+
+	if (!aq_ptp)
+		return data;
+
+	count = aq_ring_fill_stats_data(&aq_ptp->ptp_rx, data);
+	data += count;
+	count = aq_ring_fill_stats_data(&aq_ptp->ptp_tx, data);
+	data += count;
+
+	if (aq_ptp->a1_ptp) {
+		/* Only Receive ring for HWTS */
+		count = aq_ring_fill_stats_data(&aq_ptp->hwts_rx, data);
+		data += count;
+	}
+
+	return data;
+}
+
 #endif
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.h
index 231906431a48..28ccb7ca2df9 100644
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
@@ -10,6 +12,23 @@
 
 #include <linux/net_tstamp.h>
 
+#include "aq_ring.h"
+
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
@@ -55,6 +74,10 @@ struct ptp_clock *aq_ptp_get_ptp_clock(struct aq_ptp_s *aq_ptp);
 
 int aq_ptp_link_change(struct aq_nic_s *aq_nic);
 
+/* PTP ring statistics */
+int aq_ptp_get_ring_cnt(struct aq_nic_s *aq_nic, const enum atl_ring_type ring_type);
+u64 *aq_ptp_get_stats(struct aq_nic_s *aq_nic, u64 *data);
+
 #else
 
 static inline int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
-- 
2.25.1

