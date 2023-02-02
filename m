Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD8687A84
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjBBKon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbjBBKoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:44:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CF689373;
        Thu,  2 Feb 2023 02:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675334672; x=1706870672;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o2cl6cHZ7QHEPNxYFBJDxO848jSMUo6NK33S0B3qKZU=;
  b=yvhuai5C/HTkIMDLSl+95ojrcVEJc8TmUvFytlH8uRon62CgvNUupekK
   ovBLNPWDs3+Slwk3Vi2PHdmkAJOPKKQlb9h3skD7MIci9X+bOXRHwaz64
   6/URSmdmzbWoWV1CjM8mAXjU3xGWTnneN6sDjCG5075+5tq4A841Biwhy
   yVKZJUSN2EYUfx6b6QIShdZTr9Xf/xjrDsEpcxjwHQJXMQEcZykSorw8t
   mvqFY4MZ+662t+g3bBAzF7nn3f/ifUE8Pq8UzTluKLxv4SQ4a7b9g89OE
   woEB5C6JMsw+FNt1lwc1pSy6b2lQqqpkqwbPIEJ4f1YwKLqyHN1AgUdE2
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="135232926"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 03:44:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 03:44:30 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 03:44:27 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <richardcochran@gmail.com>, <casper.casan@gmail.com>,
        <horatiu.vultur@microchip.com>, <shangxiaojing@huawei.com>,
        <rmk+kernel@armlinux.org.uk>, <nhuck@google.com>,
        <error27@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next 03/10] net: microchip: sparx5: add support for Service Dual Leacky Buckets
Date:   Thu, 2 Feb 2023 11:43:48 +0100
Message-ID: <20230202104355.1612823-4-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202104355.1612823-1-daniel.machon@microchip.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for Service Dual Leacky Buckets (SDLB), used to implement
PSFP flow-meters. Buckets are linked together in a leak chain of a leak
group. Leak groups a preconfigured to serve buckets within a certain
rate interval.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   |  31 ++
 .../ethernet/microchip/sparx5/sparx5_sdlb.c   | 335 ++++++++++++++++++
 3 files changed, 367 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_sdlb.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index 6bb4609107b4..b3de8490db38 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -10,7 +10,7 @@ sparx5-switch-y  := sparx5_main.o sparx5_packet.o \
  sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
  sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o \
  sparx5_vcap_impl.o sparx5_vcap_ag_api.o sparx5_tc_flower.o \
- sparx5_tc_matchall.o sparx5_pool.o
+ sparx5_tc_matchall.o sparx5_pool.o sparx5_sdlb.o
 
 sparx5-switch-$(CONFIG_SPARX5_DCB) += sparx5_dcb.o
 sparx5-switch-$(CONFIG_DEBUG_FS) += sparx5_vcap_debugfs.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 4d0556e2ff24..daaaa670365b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -425,6 +425,37 @@ int sparx5_pool_get(struct sparx5_pool_entry *pool, int size, u32 *id);
 int sparx5_pool_get_with_idx(struct sparx5_pool_entry *pool, int size, u32 idx,
 			     u32 *id);
 
+/* sparx5_sdlb.c */
+#define SPX5_SDLB_PUP_TOKEN_DISABLE 0x1FFF
+#define SPX5_SDLB_PUP_TOKEN_MAX (SPX5_SDLB_PUP_TOKEN_DISABLE - 1)
+#define SPX5_SDLB_GROUP_RATE_MAX 25000000000ULL
+#define SPX5_SDLB_2CYCLES_TYPE2_THRES_OFFSET 13
+#define SPX5_SDLB_CNT 4096
+#define SPX5_SDLB_GROUP_CNT 10
+#define SPX5_CLK_PER_100PS_DEFAULT 16
+
+struct sparx5_sdlb_group {
+	u64 max_rate;
+	u32 min_burst;
+	u32 frame_size;
+	u32 pup_interval;
+	u32 nsets;
+};
+
+extern struct sparx5_sdlb_group sdlb_groups[SPX5_SDLB_GROUP_CNT];
+int sparx5_sdlb_pup_token_get(struct sparx5 *sparx5, u32 pup_interval,
+			      u64 rate);
+
+int sparx5_sdlb_clk_hz_get(struct sparx5 *sparx5);
+int sparx5_sdlb_group_get_by_rate(struct sparx5 *sparx5, u32 rate, u32 burst);
+int sparx5_sdlb_group_get_by_index(struct sparx5 *sparx5, u32 idx, u32 *group);
+
+int sparx5_sdlb_group_add(struct sparx5 *sparx5, u32 group, u32 idx);
+int sparx5_sdlb_group_del(struct sparx5 *sparx5, u32 group, u32 idx);
+
+void sparx5_sdlb_group_init(struct sparx5 *sparx5, u64 max_rate, u32 min_burst,
+			    u32 frame_size, u32 idx);
+
 /* Clock period in picoseconds */
 static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
 {
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_sdlb.c b/drivers/net/ethernet/microchip/sparx5/sparx5_sdlb.c
new file mode 100644
index 000000000000..f5267218caeb
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_sdlb.c
@@ -0,0 +1,335 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2023 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+struct sparx5_sdlb_group sdlb_groups[SPX5_SDLB_GROUP_CNT] = {
+	{ SPX5_SDLB_GROUP_RATE_MAX,    8192 / 1, 64 }, /*  25 G */
+	{ 15000000000ULL,              8192 / 1, 64 }, /*  15 G */
+	{ 10000000000ULL,              8192 / 1, 64 }, /*  10 G */
+	{  5000000000ULL,              8192 / 1, 64 }, /*   5 G */
+	{  2500000000ULL,              8192 / 1, 64 }, /* 2.5 G */
+	{  1000000000ULL,              8192 / 2, 64 }, /*   1 G */
+	{   500000000ULL,              8192 / 2, 64 }, /* 500 M */
+	{   100000000ULL,              8192 / 4, 64 }, /* 100 M */
+	{    50000000ULL,              8192 / 4, 64 }, /*  50 M */
+	{     5000000ULL,              8192 / 8, 64 }  /*   5 M */
+};
+
+int sparx5_sdlb_clk_hz_get(struct sparx5 *sparx5)
+{
+	u32 clk_per_100ps;
+	u64 clk_hz;
+
+	clk_per_100ps = HSCH_SYS_CLK_PER_100PS_GET(spx5_rd(sparx5,
+							   HSCH_SYS_CLK_PER));
+	if (!clk_per_100ps)
+		clk_per_100ps = SPX5_CLK_PER_100PS_DEFAULT;
+
+	clk_hz = (10 * 1000 * 1000) / clk_per_100ps;
+	return clk_hz *= 1000;
+}
+
+static int sparx5_sdlb_pup_interval_get(struct sparx5 *sparx5, u32 max_token,
+					u64 max_rate)
+{
+	u64 clk_hz;
+
+	clk_hz = sparx5_sdlb_clk_hz_get(sparx5);
+
+	return div64_u64((8 * clk_hz * max_token), max_rate);
+}
+
+int sparx5_sdlb_pup_token_get(struct sparx5 *sparx5, u32 pup_interval, u64 rate)
+{
+	u64 clk_hz;
+
+	if (!rate)
+		return SPX5_SDLB_PUP_TOKEN_DISABLE;
+
+	clk_hz = sparx5_sdlb_clk_hz_get(sparx5);
+
+	return DIV64_U64_ROUND_UP((rate * pup_interval), (clk_hz * 8));
+}
+
+static void sparx5_sdlb_group_disable(struct sparx5 *sparx5, u32 group)
+{
+	spx5_rmw(ANA_AC_SDLB_PUP_CTRL_PUP_ENA_SET(0),
+		 ANA_AC_SDLB_PUP_CTRL_PUP_ENA, sparx5,
+		 ANA_AC_SDLB_PUP_CTRL(group));
+}
+
+static void sparx5_sdlb_group_enable(struct sparx5 *sparx5, u32 group)
+{
+	spx5_rmw(ANA_AC_SDLB_PUP_CTRL_PUP_ENA_SET(1),
+		 ANA_AC_SDLB_PUP_CTRL_PUP_ENA, sparx5,
+		 ANA_AC_SDLB_PUP_CTRL(group));
+}
+
+static u32 sparx5_sdlb_group_get_first(struct sparx5 *sparx5, u32 group)
+{
+	u32 val;
+
+	val = spx5_rd(sparx5, ANA_AC_SDLB_XLB_START(group));
+
+	return ANA_AC_SDLB_XLB_START_LBSET_START_GET(val);
+}
+
+static u32 sparx5_sdlb_group_get_next(struct sparx5 *sparx5, u32 group,
+				      u32 lb)
+{
+	u32 val;
+
+	val = spx5_rd(sparx5, ANA_AC_SDLB_XLB_NEXT(lb));
+
+	return ANA_AC_SDLB_XLB_NEXT_LBSET_NEXT_GET(val);
+}
+
+static bool sparx5_sdlb_group_is_first(struct sparx5 *sparx5, u32 group,
+				       u32 lb)
+{
+	return lb == sparx5_sdlb_group_get_first(sparx5, group);
+}
+
+static bool sparx5_sdlb_group_is_last(struct sparx5 *sparx5, u32 group,
+				      u32 lb)
+{
+	return lb == sparx5_sdlb_group_get_next(sparx5, group, lb);
+}
+
+static bool sparx5_sdlb_group_is_empty(struct sparx5 *sparx5, u32 group)
+{
+	u32 val;
+
+	val = spx5_rd(sparx5, ANA_AC_SDLB_PUP_CTRL(group));
+
+	return ANA_AC_SDLB_PUP_CTRL_PUP_ENA_GET(val) == 0;
+}
+
+static u32 sparx5_sdlb_group_get_last(struct sparx5 *sparx5, u32 group)
+{
+	u32 itr, next;
+
+	itr = sparx5_sdlb_group_get_first(sparx5, group);
+
+	for (;;) {
+		next = sparx5_sdlb_group_get_next(sparx5, group, itr);
+		if (itr == next)
+			return itr;
+
+		itr = next;
+	}
+}
+
+static bool sparx5_sdlb_group_is_singular(struct sparx5 *sparx5, u32 group)
+{
+	if (sparx5_sdlb_group_is_empty(sparx5, group))
+		return false;
+
+	return sparx5_sdlb_group_get_first(sparx5, group) ==
+	       sparx5_sdlb_group_get_last(sparx5, group);
+}
+
+static int sparx5_sdlb_group_get_adjacent(struct sparx5 *sparx5, u32 group,
+					  u32 idx, u32 *prev, u32 *next,
+					  u32 *first)
+{
+	u32 itr;
+
+	*first = sparx5_sdlb_group_get_first(sparx5, group);
+	*prev = *first;
+	*next = *first;
+	itr = *first;
+
+	for (;;) {
+		*next = sparx5_sdlb_group_get_next(sparx5, group, itr);
+
+		if (itr == idx)
+			return 0; /* Found it */
+
+		if (itr == *next)
+			return -EINVAL; /* Was not found */
+
+		*prev = itr;
+		itr = *next;
+	}
+}
+
+static int sparx5_sdlb_group_get_count(struct sparx5 *sparx5, u32 group)
+{
+	u32 itr, next;
+	int count = 0;
+
+	itr = sparx5_sdlb_group_get_first(sparx5, group);
+
+	for (;;) {
+		next = sparx5_sdlb_group_get_next(sparx5, group, itr);
+		if (itr == next)
+			return count;
+
+		itr = next;
+		count++;
+	}
+}
+
+int sparx5_sdlb_group_get_by_rate(struct sparx5 *sparx5, u32 rate, u32 burst)
+{
+	const struct sparx5_sdlb_group *group;
+	u64 rate_bps;
+	int i, count;
+
+	rate_bps = rate * 1000;
+
+	for (i = SPX5_SDLB_GROUP_CNT - 1; i >= 0; i--) {
+		group = &sdlb_groups[i];
+
+		count = sparx5_sdlb_group_get_count(sparx5, i);
+
+		/* Check that this group is not full.
+		 * According to LB group configuration rules: the number of XLBs
+		 * in a group must not exceed PUP_INTERVAL/4 - 1.
+		 */
+		if (count > ((group->pup_interval / 4) - 1))
+			continue;
+
+		if (rate_bps < group->max_rate)
+			return i;
+	}
+
+	return -ENOSPC;
+}
+
+int sparx5_sdlb_group_get_by_index(struct sparx5 *sparx5, u32 idx, u32 *group)
+{
+	u32 itr, next;
+	int i;
+
+	for (i = 0; i < SPX5_SDLB_GROUP_CNT; i++) {
+		if (sparx5_sdlb_group_is_empty(sparx5, i))
+			continue;
+
+		itr = sparx5_sdlb_group_get_first(sparx5, i);
+
+		for (;;) {
+			next = sparx5_sdlb_group_get_next(sparx5, i, itr);
+
+			if (itr == idx) {
+				*group = i;
+				return 0; /* Found it */
+			}
+			if (itr == next)
+				break; /* Was not found */
+
+			itr = next;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int sparx5_sdlb_group_link(struct sparx5 *sparx5, u32 group, u32 idx,
+				  u32 first, u32 next, bool empty)
+{
+	/* Stop leaking */
+	sparx5_sdlb_group_disable(sparx5, group);
+
+	if (empty)
+		return 0;
+
+	/* Link insertion lb to next lb */
+	spx5_wr(ANA_AC_SDLB_XLB_NEXT_LBSET_NEXT_SET(next) |
+			ANA_AC_SDLB_XLB_NEXT_LBGRP_SET(group),
+		sparx5, ANA_AC_SDLB_XLB_NEXT(idx));
+
+	/* Set the first lb */
+	spx5_wr(ANA_AC_SDLB_XLB_START_LBSET_START_SET(first), sparx5,
+		ANA_AC_SDLB_XLB_START(group));
+
+	/* Start leaking */
+	sparx5_sdlb_group_enable(sparx5, group);
+
+	return 0;
+};
+
+int sparx5_sdlb_group_add(struct sparx5 *sparx5, u32 group, u32 idx)
+{
+	u32 first, next;
+
+	/* We always add to head of the list */
+	first = idx;
+
+	if (sparx5_sdlb_group_is_empty(sparx5, group))
+		next = idx;
+	else
+		next = sparx5_sdlb_group_get_first(sparx5, group);
+
+	return sparx5_sdlb_group_link(sparx5, group, idx, first, next, false);
+}
+
+int sparx5_sdlb_group_del(struct sparx5 *sparx5, u32 group, u32 idx)
+{
+	u32 first, next, prev;
+	bool empty = false;
+
+	if (sparx5_sdlb_group_get_adjacent(sparx5, group, idx, &prev, &next,
+					   &first) < 0) {
+		pr_err("%s:%d Could not find idx: %d in group: %d", __func__,
+		       __LINE__, idx, group);
+		return -EINVAL;
+	}
+
+	if (sparx5_sdlb_group_is_singular(sparx5, group)) {
+		empty = true;
+	} else if (sparx5_sdlb_group_is_last(sparx5, group, idx)) {
+		/* idx is removed, prev is now last */
+		idx = prev;
+		next = prev;
+	} else if (sparx5_sdlb_group_is_first(sparx5, group, idx)) {
+		/* idx is removed and points to itself, first is next */
+		first = next;
+		next = idx;
+	} else {
+		/* Next is not touched */
+		idx = prev;
+	}
+
+	return sparx5_sdlb_group_link(sparx5, group, idx, first, next, empty);
+}
+
+void sparx5_sdlb_group_init(struct sparx5 *sparx5, u64 max_rate, u32 min_burst,
+			    u32 frame_size, u32 idx)
+{
+	u32 thres_shift, mask = 0x01, power = 0;
+	struct sparx5_sdlb_group *group;
+	u64 max_token;
+
+	group = &sdlb_groups[idx];
+
+	/* Number of positions to right-shift LB's threshold value. */
+	while ((min_burst & mask) == 0) {
+		power++;
+		mask <<= 1;
+	}
+	thres_shift = SPX5_SDLB_2CYCLES_TYPE2_THRES_OFFSET - power;
+
+	max_token = (min_burst > SPX5_SDLB_PUP_TOKEN_MAX) ?
+			    SPX5_SDLB_PUP_TOKEN_MAX :
+			    min_burst;
+	group->pup_interval =
+		sparx5_sdlb_pup_interval_get(sparx5, max_token, max_rate);
+
+	group->frame_size = frame_size;
+
+	spx5_wr(ANA_AC_SDLB_PUP_INTERVAL_PUP_INTERVAL_SET(group->pup_interval),
+		sparx5, ANA_AC_SDLB_PUP_INTERVAL(idx));
+
+	spx5_wr(ANA_AC_SDLB_FRM_RATE_TOKENS_FRM_RATE_TOKENS_SET(frame_size),
+		sparx5, ANA_AC_SDLB_FRM_RATE_TOKENS(idx));
+
+	spx5_wr(ANA_AC_SDLB_LBGRP_MISC_THRES_SHIFT_SET(thres_shift), sparx5,
+		ANA_AC_SDLB_LBGRP_MISC(idx));
+}
-- 
2.34.1

