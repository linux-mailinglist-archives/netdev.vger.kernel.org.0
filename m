Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A42687A9F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjBBKqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjBBKom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:44:42 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F8CB772;
        Thu,  2 Feb 2023 02:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675334675; x=1706870675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RlHqwbRkqmZvvcQjDwz7tIh9TRfFRhSX37oKL8r7jxM=;
  b=W0m93gfx8Vnx8AurrXXgAGV3yqMVK+/FTXea/1JIFBrWIt+KVmmnN+r5
   KNnz1UNeQza8Ph9NZi/CpjJb+Ri9NW5TVS2yaPsp3Acx/hFFo5OHhjgOG
   TyuZQrHWM2JSW1dME879FeLQ2/bwerkQe1W/9nNlOxiVKH+TpP7h6dgwb
   Gs4BBZ3JuYQ+xTl8Fhbn/pyrKaKCvlcIu+z+APHrXDTbADyOlj+ATPX4m
   mZUIooqAiJod1rIWL3yGAxjJAcPVYrnCWVisDp4CN0ozJZgUON4NH7odk
   /JjGSF1d+/hjQXoIwg3I60H6AcysPwCxrlfmriG1tiFdXZF68bSIB+W/5
   w==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="199055482"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 03:44:35 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 03:44:34 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 03:44:30 -0700
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
Subject: [PATCH net-next 04/10] net: microchip: sparx5: add support for service policers
Date:   Thu, 2 Feb 2023 11:43:49 +0100
Message-ID: <20230202104355.1612823-5-daniel.machon@microchip.com>
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

Add initial API for configuring policers. This patch add support for
service policers.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |  2 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   | 16 ++++++
 .../ethernet/microchip/sparx5/sparx5_police.c | 53 +++++++++++++++++++
 3 files changed, 70 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_police.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index b3de8490db38..9f35b0dc3212 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -10,7 +10,7 @@ sparx5-switch-y  := sparx5_main.o sparx5_packet.o \
  sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
  sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o \
  sparx5_vcap_impl.o sparx5_vcap_ag_api.o sparx5_tc_flower.o \
- sparx5_tc_matchall.o sparx5_pool.o sparx5_sdlb.o
+ sparx5_tc_matchall.o sparx5_pool.o sparx5_sdlb.o sparx5_police.o
 
 sparx5-switch-$(CONFIG_SPARX5_DCB) += sparx5_dcb.o
 sparx5-switch-$(CONFIG_DEBUG_FS) += sparx5_vcap_debugfs.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index daaaa670365b..c8bb50bbdcdf 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -455,6 +455,22 @@ int sparx5_sdlb_group_del(struct sparx5 *sparx5, u32 group, u32 idx);
 
 void sparx5_sdlb_group_init(struct sparx5 *sparx5, u64 max_rate, u32 min_burst,
 			    u32 frame_size, u32 idx);
+/* sparx5_police.c */
+enum {
+	/* More policer types will be added later */
+	SPX5_POL_SERVICE
+};
+
+struct sparx5_policer {
+	u32 type;
+	u32 idx;
+	u64 rate;
+	u32 burst;
+	u32 group;
+	u8 event_mask;
+};
+
+int sparx5_policer_conf_set(struct sparx5 *sparx5, struct sparx5_policer *pol);
 
 /* Clock period in picoseconds */
 static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_police.c b/drivers/net/ethernet/microchip/sparx5/sparx5_police.c
new file mode 100644
index 000000000000..8ada5cee1342
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_police.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2023 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+static int sparx5_policer_service_conf_set(struct sparx5 *sparx5,
+					   struct sparx5_policer *pol)
+{
+	u32 idx, pup_tokens, max_pup_tokens, burst, thres;
+	struct sparx5_sdlb_group *g;
+	u64 rate;
+
+	g = &sdlb_groups[pol->group];
+	idx = pol->idx;
+
+	rate = pol->rate * 1000;
+	burst = pol->burst;
+
+	pup_tokens = sparx5_sdlb_pup_token_get(sparx5, g->pup_interval, rate);
+	max_pup_tokens =
+		sparx5_sdlb_pup_token_get(sparx5, g->pup_interval, g->max_rate);
+
+	thres = DIV_ROUND_UP(burst, g->min_burst);
+
+	spx5_wr(ANA_AC_SDLB_PUP_TOKENS_PUP_TOKENS_SET(pup_tokens), sparx5,
+		ANA_AC_SDLB_PUP_TOKENS(idx, 0));
+
+	spx5_rmw(ANA_AC_SDLB_INH_CTRL_PUP_TOKENS_MAX_SET(max_pup_tokens),
+		 ANA_AC_SDLB_INH_CTRL_PUP_TOKENS_MAX, sparx5,
+		 ANA_AC_SDLB_INH_CTRL(idx, 0));
+
+	spx5_rmw(ANA_AC_SDLB_THRES_THRES_SET(thres), ANA_AC_SDLB_THRES_THRES,
+		 sparx5, ANA_AC_SDLB_THRES(idx, 0));
+
+	return 0;
+}
+
+int sparx5_policer_conf_set(struct sparx5 *sparx5, struct sparx5_policer *pol)
+{
+	/* More policer types will be added later */
+	switch (pol->type) {
+	case SPX5_POL_SERVICE:
+		return sparx5_policer_service_conf_set(sparx5, pol);
+	default:
+		break;
+	}
+
+	return 0;
+}
-- 
2.34.1

