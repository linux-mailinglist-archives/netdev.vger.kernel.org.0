Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7A5687A86
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjBBKoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbjBBKos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:44:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C074A709BC;
        Thu,  2 Feb 2023 02:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675334680; x=1706870680;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nPLdB8aEqcsL733U+so7NPCf2aRqmAVkeWDEL6p8u1g=;
  b=Qyt7O17DfTPxOcHyzc9RbYPWhExZR4yeNc84LJi1VSqwG8g4bND3u0Bn
   LaH+t9tJgiEgwHjI5FE4UsQPdXnOtY3sBrehFZ9bLUTZZaU51AfTN/5oJ
   JzRrhhc3rCuR83a0R0/VPN9K6kt8DSElS91RJaabz/Va/o5dAQaEdpCre
   qnI7oeQcvl9OIA9Jf+nwPdKtq791+K82oND4mM66dY/YtqMkHe2ez/eES
   mra8I6mjcb5/JMvJF8xhLEUqtBk92T1ewmGXu31IHwlOlYuY/bq2Brljt
   cdwOO/49AdL3ffEYuioHyPwcmnkpZP2Y9YKrrJC0IMaV+hi6p+RXUvWIV
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="195044122"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 03:44:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 03:44:38 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 03:44:34 -0700
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
Subject: [PATCH net-next 05/10] net: microchip: sparx5: add support for PSFP flow-meters
Date:   Thu, 2 Feb 2023 11:43:50 +0100
Message-ID: <20230202104355.1612823-6-daniel.machon@microchip.com>
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

Add support for configuring PSFP flow-meters (IEEE 802.1Q-2018,
8.6.5.1.3).

The VCAP CLM (VCAP IS0 ingress classifier) classifies streams,
identified by ISDX (Ingress Service Index, frame metadata), and maps
ISDX to flow-meters. SDLB's provide the flow-meter parameters.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |  2 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   |  9 ++
 .../ethernet/microchip/sparx5/sparx5_psfp.c   | 88 +++++++++++++++++++
 3 files changed, 98 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index 9f35b0dc3212..1cb1cc3f1a85 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -10,7 +10,7 @@ sparx5-switch-y  := sparx5_main.o sparx5_packet.o \
  sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
  sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o \
  sparx5_vcap_impl.o sparx5_vcap_ag_api.o sparx5_tc_flower.o \
- sparx5_tc_matchall.o sparx5_pool.o sparx5_sdlb.o sparx5_police.o
+ sparx5_tc_matchall.o sparx5_pool.o sparx5_sdlb.o sparx5_police.o sparx5_psfp.o
 
 sparx5-switch-$(CONFIG_SPARX5_DCB) += sparx5_dcb.o
 sparx5-switch-$(CONFIG_DEBUG_FS) += sparx5_vcap_debugfs.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index c8bb50bbdcdf..709cad534f50 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -472,6 +472,15 @@ struct sparx5_policer {
 
 int sparx5_policer_conf_set(struct sparx5 *sparx5, struct sparx5_policer *pol);
 
+/* sparx5_psfp.c */
+struct sparx5_psfp_fm {
+	struct sparx5_policer pol;
+};
+
+int sparx5_psfp_fm_add(struct sparx5 *sparx5, u32 uidx,
+		       struct sparx5_psfp_fm *fm, u32 *id);
+int sparx5_psfp_fm_del(struct sparx5 *sparx5, u32 id);
+
 /* Clock period in picoseconds */
 static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
 {
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
new file mode 100644
index 000000000000..7c7390372c71
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2023 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+/* Pool of available service policers */
+static struct sparx5_pool_entry sparx5_psfp_fm_pool[SPX5_SDLB_CNT];
+
+static int sparx5_psfp_fm_get(u32 idx, u32 *id)
+{
+	return sparx5_pool_get_with_idx(sparx5_psfp_fm_pool, SPX5_SDLB_CNT, idx,
+					id);
+}
+
+static int sparx5_psfp_fm_put(u32 id)
+{
+	return sparx5_pool_put(sparx5_psfp_fm_pool, SPX5_SDLB_CNT, id);
+}
+
+static int sparx5_sdlb_conf_set(struct sparx5 *sparx5,
+				struct sparx5_psfp_fm *fm)
+{
+	int (*sparx5_sdlb_group_action)(struct sparx5 *sparx5, u32 group,
+					u32 idx);
+
+	if (!fm->pol.rate && !fm->pol.burst)
+		sparx5_sdlb_group_action = &sparx5_sdlb_group_del;
+	else
+		sparx5_sdlb_group_action = &sparx5_sdlb_group_add;
+
+	sparx5_policer_conf_set(sparx5, &fm->pol);
+
+	return sparx5_sdlb_group_action(sparx5, fm->pol.group, fm->pol.idx);
+}
+
+int sparx5_psfp_fm_add(struct sparx5 *sparx5, u32 uidx,
+		       struct sparx5_psfp_fm *fm, u32 *id)
+{
+	struct sparx5_policer *pol = &fm->pol;
+	int ret;
+
+	/* Get flow meter */
+	ret = sparx5_psfp_fm_get(uidx, &fm->pol.idx);
+	if (ret < 0)
+		return ret;
+	/* Was already in use, no need to reconfigure */
+	if (ret > 1)
+		return 0;
+
+	ret = sparx5_sdlb_group_get_by_rate(sparx5, pol->rate, pol->burst);
+	if (ret < 0)
+		return ret;
+
+	fm->pol.group = ret;
+
+	ret = sparx5_sdlb_conf_set(sparx5, fm);
+	if (ret < 0)
+		return ret;
+
+	*id = fm->pol.idx;
+
+	return 0;
+}
+
+int sparx5_psfp_fm_del(struct sparx5 *sparx5, u32 id)
+{
+	struct sparx5_psfp_fm fm = { .pol.idx = id,
+				     .pol.type = SPX5_POL_SERVICE };
+	int ret;
+
+	/* Find the group that this lb belongs to */
+	ret = sparx5_sdlb_group_get_by_index(sparx5, id, &fm.pol.group);
+	if (ret < 0)
+		return ret;
+
+	ret = sparx5_psfp_fm_put(id);
+	if (ret < 0)
+		return ret;
+	/* Do not reset flow-meter if still in use. */
+	if (ret > 0)
+		return 0;
+
+	return sparx5_sdlb_conf_set(sparx5, &fm);
+}
-- 
2.34.1

