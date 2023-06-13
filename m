Return-Path: <netdev+bounces-10287-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3649B72D8F2
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:05:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5880F1C20C26
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 05:05:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF39D361;
	Tue, 13 Jun 2023 05:05:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A32080C
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 05:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0A0C4339B;
	Tue, 13 Jun 2023 05:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686632714;
	bh=GuGVmle0N8FkXfqj7L3VzZNLIMwvbzdGHHK5AAR+atQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjPJccGVWG5RkThGmNb0PY8Hpq2BfNegFpigtABEwGqTtxdjje/hRGTpH0Iu0weu3
	 14TKaYm3wLvytf5rOLZr7hz2zQdatDM4UEliFWMa91RKx2fpy0Ta3j8PhceM6J3ooh
	 9PIgKOWKxJiqMVd0Bd8ebze75RO97a2B5FHia9xX/VydTHM8RH/bRjotQySpNZcwxh
	 s2YM+l5VAFe6qEpNPf1Allx8iGQZ3cFz/BmOYVzpZOjh8LRx/KxagJHLHS4QkTpvXx
	 PwzWTM8yRs3KMxHBnpQ/zWAQLzxMgwc+B04fpzxazxaNdBKS09fl58bPGJEUov7pcH
	 ZA+Mzk8PeA3ig==
From: Jakub Kicinski <kuba@kernel.org>
To: mkubecek@suse.cz,
	idosch@nvidia.com
Cc: danieller@nvidia.com,
	netdev@vger.kernel.org,
	vladyslavt@nvidia.com,
	linux@armlinux.org.uk,
	andrew@lunn.ch,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next v2 2/2] cmis: report LOL / LOS / Tx Fault
Date: Mon, 12 Jun 2023 22:05:07 -0700
Message-Id: <20230613050507.1899596-2-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230613050507.1899596-1-kuba@kernel.org>
References: <20230613050507.1899596-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Report whether Loss of Lock, of Signal and Tx Faults were detected.
Print "None" in case no lane has the problem, and per-lane "Yes" /
"No" if at least one of the lanes reports true.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Turns out I don't have access to any host with CMIS optics at this
point so untested. I can only confirm it correctly shows nothing
with a DAC...
---
 cmis.c | 39 +++++++++++++++++++++++++++++++++++++++
 cmis.h | 17 +++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/cmis.c b/cmis.c
index d0b62728e998..531932ee7eeb 100644
--- a/cmis.c
+++ b/cmis.c
@@ -139,6 +139,44 @@ static void cmis_show_rev_compliance(const struct cmis_memory_map *map)
 	printf("\t%-41s : Rev. %d.%d\n", "Revision compliance", major, minor);
 }
 
+static void
+cmis_show_signals_one(const struct cmis_memory_map *map, const char *name,
+		      int off, int ioff, unsigned int imask)
+{
+	unsigned int v;
+	int i;
+
+	if (!map->page_01h)
+		return;
+
+	v = 0;
+	for (i = 0; i < CMIS_MAX_BANKS && map->upper_memory[i][0x11]; i++)
+		v |= map->upper_memory[i][0x11][off] << (i * 8);
+
+	if (map->page_01h[ioff] & imask)
+		sff_show_lane_status(name, i * 8, "Yes", "No", v);
+}
+
+static void cmis_show_signals(const struct cmis_memory_map *map)
+{
+	cmis_show_signals_one(map, "Rx loss of signal", CMIS_RX_LOS_OFFSET,
+			      CMIS_DIAG_FLAGS_RX_OFFSET, CMIS_DIAG_FL_RX_LOS);
+	cmis_show_signals_one(map, "Tx loss of signal", CMIS_TX_LOS_OFFSET,
+			      CMIS_DIAG_FLAGS_TX_OFFSET, CMIS_DIAG_FL_TX_LOS);
+
+	cmis_show_signals_one(map, "Rx loss of lock", CMIS_RX_LOL_OFFSET,
+			      CMIS_DIAG_FLAGS_RX_OFFSET, CMIS_DIAG_FL_RX_LOL);
+	cmis_show_signals_one(map, "Tx loss of lock", CMIS_TX_LOL_OFFSET,
+			      CMIS_DIAG_FLAGS_TX_OFFSET, CMIS_DIAG_FL_TX_LOL);
+
+	cmis_show_signals_one(map, "Tx fault", CMIS_TX_FAIL_OFFSET,
+			      CMIS_DIAG_FLAGS_TX_OFFSET, CMIS_DIAG_FL_TX_FAIL);
+
+	cmis_show_signals_one(map, "Tx adaptive eq fault",
+			      CMIS_TX_EQ_FAIL_OFFSET, CMIS_DIAG_FLAGS_TX_OFFSET,
+			      CMIS_DIAG_FL_TX_ADAPTIVE_EQ_FAIL);
+}
+
 /**
  * Print information about the device's power consumption.
  * Relevant documents:
@@ -857,6 +895,7 @@ static void cmis_show_all_common(const struct cmis_memory_map *map)
 	cmis_show_link_len(map);
 	cmis_show_vendor_info(map);
 	cmis_show_rev_compliance(map);
+	cmis_show_signals(map);
 	cmis_show_mod_state(map);
 	cmis_show_mod_fault_cause(map);
 	cmis_show_mod_lvl_controls(map);
diff --git a/cmis.h b/cmis.h
index 46797081f13c..8d66f92dd971 100644
--- a/cmis.h
+++ b/cmis.h
@@ -158,6 +158,17 @@
 #define CMIS_DIAG_TYPE_OFFSET			0x97
 #define CMIS_RX_PWR_TYPE_MASK			0x10
 
+/* Supported Flags Advertisement (Page 1) */
+#define CMIS_DIAG_FLAGS_TX_OFFSET		0x9d
+#define CMIS_DIAG_FL_TX_ADAPTIVE_EQ_FAIL	(1 << 3)
+#define CMIS_DIAG_FL_TX_LOL			(1 << 2)
+#define CMIS_DIAG_FL_TX_LOS			(1 << 1)
+#define CMIS_DIAG_FL_TX_FAIL			(1 << 0)
+
+#define CMIS_DIAG_FLAGS_RX_OFFSET		0x9e
+#define CMIS_DIAG_FL_RX_LOL			(1 << 2)
+#define CMIS_DIAG_FL_RX_LOS			(1 << 1)
+
 /* Supported Monitors Advertisement (Page 1) */
 #define CMIS_DIAG_CHAN_ADVER_OFFSET		0xA0
 #define CMIS_TX_BIAS_MON_MASK			0x01
@@ -207,6 +218,10 @@
  */
 
 /* Media Lane-Specific Flags (Page 0x11) */
+#define CMIS_TX_FAIL_OFFSET			0x87
+#define CMIS_TX_LOS_OFFSET			0x88
+#define CMIS_TX_LOL_OFFSET			0x89
+#define CMIS_TX_EQ_FAIL_OFFSET			0x8a
 #define CMIS_TX_PWR_AW_HALARM_OFFSET		0x8B
 #define CMIS_TX_PWR_AW_LALARM_OFFSET		0x8C
 #define CMIS_TX_PWR_AW_HWARN_OFFSET		0x8D
@@ -215,6 +230,8 @@
 #define CMIS_TX_BIAS_AW_LALARM_OFFSET		0x90
 #define CMIS_TX_BIAS_AW_HWARN_OFFSET		0x91
 #define CMIS_TX_BIAS_AW_LWARN_OFFSET		0x92
+#define CMIS_RX_LOS_OFFSET			0x93
+#define CMIS_RX_LOL_OFFSET			0x94
 #define CMIS_RX_PWR_AW_HALARM_OFFSET		0x95
 #define CMIS_RX_PWR_AW_LALARM_OFFSET		0x96
 #define CMIS_RX_PWR_AW_HWARN_OFFSET		0x97
-- 
2.40.1


