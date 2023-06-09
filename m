Return-Path: <netdev+bounces-9406-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA675728C93
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:44:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07CFD281819
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 00:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22828A28;
	Fri,  9 Jun 2023 00:44:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20A27E6
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 00:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5617C433EF;
	Fri,  9 Jun 2023 00:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686271449;
	bh=oFl1ctWy7/glp8560QE8q/ej4NMXhIT/XZ+QgSz3Gi8=;
	h=From:To:Cc:Subject:Date:From;
	b=BFbT7GPg8HPOXtsa/eo8RN9irKObw0TfjyTO0mn5nJhGnW7XzA58N0MHCAx6yyUK8
	 Qed7N5YOYTpLY4+Oilz6gVUtkHWG9px0SddOqbtPBfOwqoF00y9B2FZJ91aYlvLmu2
	 pTJF9w/0fzmuY3/oi9aWa7Om2gbx39zA68XpDSAMzsSsMmhUaWaNsZdi7CMBAHCyL3
	 8UrGfd6DbMuuYOFOwx8/9eMUQ6GcvoycPbKUZ8Kv0jYYswxg4PTP8uV3RVOkoYzo+O
	 UVJRVJh7e1cBneEZ5cCzQGkUEKIW3A5/a7fucEiKmaiXLtRquJmb55YtMQtL56zhE+
	 1fRlgP1cy1Qjg==
From: Jakub Kicinski <kuba@kernel.org>
To: mkubecek@suse.cz
Cc: danieller@nvidia.com,
	idosch@nvidia.com,
	netdev@vger.kernel.org,
	vladyslavt@nvidia.com,
	linux@armlinux.org.uk,
	andrew@lunn.ch,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next] sff-8636: report LOL / LOS / Tx Fault
Date: Thu,  8 Jun 2023 17:44:00 -0700
Message-Id: <20230609004400.1276734-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Report whether Loss of Lock, of Signal and Tx Faults were detected.
Print "None" in case no lane has the problem, and per-lane "Yes" /
"No"  if at least one of the lanes reports true.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
I was asked if "Linux reports" this information.
I'm not very confident on the merits, I'm going by the spec.
If it makes sense I'll send a similar patch for CMIS.
---
 qsfp.c       | 30 ++++++++++++++++++++++++++++++
 qsfp.h       |  8 ++++++++
 sff-common.c | 17 +++++++++++++++++
 sff-common.h |  2 ++
 4 files changed, 57 insertions(+)

diff --git a/qsfp.c b/qsfp.c
index 1fe5de1a863f..5a535c5c092b 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -872,6 +872,35 @@ static void sff8636_show_dom(const struct sff8636_memory_map *map)
 	}
 }
 
+static void sff8636_show_signals(const struct sff8636_memory_map *map)
+{
+	unsigned int v;
+
+	/* There appears to be no Rx LOS support bit, use Tx for both */
+	if (map->page_00h[SFF8636_OPTION_4_OFFSET] & SFF8636_O4_TX_LOS) {
+		v = map->lower_memory[SFF8636_LOS_AW_OFFSET] & 0xf;
+		sff_show_lane_status("Rx loss of signal", 4, "Yes", "No", v);
+		v = map->lower_memory[SFF8636_LOS_AW_OFFSET] >> 4;
+		sff_show_lane_status("Tx loss of signal", 4, "Yes", "No", v);
+	}
+
+	v = map->lower_memory[SFF8636_LOL_AW_OFFSET] & 0xf;
+	if (map->page_00h[SFF8636_OPTION_3_OFFSET] & SFF8636_O3_RX_LOL)
+		sff_show_lane_status("Rx loss of lock", 4, "Yes", "No", v);
+
+	v = map->lower_memory[SFF8636_LOL_AW_OFFSET] >> 4;
+	if (map->page_00h[SFF8636_OPTION_3_OFFSET] & SFF8636_O3_TX_LOL)
+		sff_show_lane_status("Tx loss of lock", 4, "Yes", "No", v);
+
+	v = map->lower_memory[SFF8636_FAULT_AW_OFFSET] & 0xf;
+	if (map->page_00h[SFF8636_OPTION_4_OFFSET] & SFF8636_O4_TX_FAULT)
+		sff_show_lane_status("Tx fault", 4, "Yes", "No", v);
+
+	v = map->lower_memory[SFF8636_FAULT_AW_OFFSET] >> 4;
+	if (map->page_00h[SFF8636_OPTION_2_OFFSET] & SFF8636_O2_TX_EQ_AUTO)
+		sff_show_lane_status("Tx adaptive eq fault", 4, "Yes", "No", v);
+}
+
 static void sff8636_show_page_zero(const struct sff8636_memory_map *map)
 {
 	sff8636_show_ext_identifier(map);
@@ -905,6 +934,7 @@ static void sff8636_show_page_zero(const struct sff8636_memory_map *map)
 		       SFF8636_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
 	sff_show_revision_compliance(map->lower_memory,
 				     SFF8636_REV_COMPLIANCE_OFFSET);
+	sff8636_show_signals(map);
 }
 
 static void sff8636_show_all_common(const struct sff8636_memory_map *map)
diff --git a/qsfp.h b/qsfp.h
index aabf09fdc623..b4a0ffe06da1 100644
--- a/qsfp.h
+++ b/qsfp.h
@@ -55,6 +55,8 @@
 #define	 SFF8636_TX2_FAULT_AW	(1 << 1)
 #define	 SFF8636_TX1_FAULT_AW	(1 << 0)
 
+#define	SFF8636_LOL_AW_OFFSET	0x05
+
 /* Module Monitor Interrupt Flags - 6-8 */
 #define	SFF8636_TEMP_AW_OFFSET	0x06
 #define	 SFF8636_TEMP_HALARM_STATUS		(1 << 7)
@@ -525,9 +527,15 @@
 /*  56h-5Fh reserved */
 
 #define	 SFF8636_OPTION_2_OFFSET	0xC1
+/* Tx input equalizers auto-adaptive */
+#define	  SFF8636_O2_TX_EQ_AUTO		(1 << 3)
 /* Rx output amplitude */
 #define	  SFF8636_O2_RX_OUTPUT_AMP	(1 << 0)
 #define	 SFF8636_OPTION_3_OFFSET	0xC2
+/* Rx CDR Loss of Lock */
+#define	  SFF8636_O3_RX_LOL		(1 << 5)
+/* Tx CDR Loss of Lock */
+#define	  SFF8636_O3_TX_LOL		(1 << 4)
 /* Rx Squelch Disable */
 #define	  SFF8636_O3_RX_SQL_DSBL	(1 << 3)
 /* Rx Output Disable capable */
diff --git a/sff-common.c b/sff-common.c
index e951cf15c1d6..a5c1510302a6 100644
--- a/sff-common.c
+++ b/sff-common.c
@@ -53,6 +53,23 @@ void sff_show_ascii(const __u8 *id, unsigned int first_reg,
 	printf("\n");
 }
 
+void sff_show_lane_status(const char *name, unsigned int lane_cnt,
+			  const char *yes, const char *no, unsigned int value)
+{
+	printf("\t%-41s : ", name);
+	if (!value) {
+		printf("None\n");
+		return;
+	}
+
+	printf("[");
+	while (lane_cnt--) {
+		printf(" %s%c", value & 1 ? yes : no, lane_cnt ? ',': ' ');
+		value >>= 1;
+	}
+	printf("]\n");
+}
+
 void sff8024_show_oui(const __u8 *id, int id_offset)
 {
 	printf("\t%-41s : %02x:%02x:%02x\n", "Vendor OUI",
diff --git a/sff-common.h b/sff-common.h
index dd12dda7bbce..57bcc4a415fe 100644
--- a/sff-common.h
+++ b/sff-common.h
@@ -198,6 +198,8 @@ void sff_show_value_with_unit(const __u8 *id, unsigned int reg,
 			      const char *unit);
 void sff_show_ascii(const __u8 *id, unsigned int first_reg,
 		    unsigned int last_reg, const char *name);
+void sff_show_lane_status(const char *name, unsigned int lane_cnt,
+			  const char *yes, const char *no, unsigned int value);
 void sff_show_thresholds(struct sff_diags sd);
 
 void sff8024_show_oui(const __u8 *id, int id_offset);
-- 
2.40.1


