Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C303687A81
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjBBKoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBBKof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:44:35 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDA58934F;
        Thu,  2 Feb 2023 02:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675334668; x=1706870668;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oD+wF0ZnGy/0QGCtcFWo3YT53d2TV6yTWtIHhR94mTE=;
  b=jRnUh5WNBg+yfi73jG5Z1vCmvSFGmR7E2wIrN/P+l59g0FbVVH7wS4FX
   A+bFdVBuAX38FSRBegnbZubycaWPwyE6kSyzJp6e5zWC4JsPI58iUSCi4
   JSENGMA4a7qC3EBdoVrVqt29QRJ4CeA/CFrA+6SG3AnrJM80l/v5J8QNW
   riYcyFjHZ3vn6HQhKzXsnh9pOrMO60SgPaMOxPmr7wjSgS5jYbbLxgJwG
   hrSUMxNFG31oD7Z7XWPY32GjwcKZpr9wgyiNNe+e8UNB682rF8UC4ZQBZ
   NVUdzj3UdW5bMknzGUm3bFmbdcXOLanjiycv0OMJRjTqr4m95S8DJ+N7C
   g==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="198600161"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 03:44:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 03:44:26 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 03:44:23 -0700
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
Subject: [PATCH net-next 02/10] net: microchip: sparx5: add resource pools
Date:   Thu, 2 Feb 2023 11:43:47 +0100
Message-ID: <20230202104355.1612823-3-daniel.machon@microchip.com>
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

Add resource pools and accessor functions. These pools can be queried by
the driver, whenever a finite resource is required. Some resources can
be reused, in which case an index and a reference count is used to keep
track of users.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |  3 +-
 .../ethernet/microchip/sparx5/sparx5_main.h   | 12 +++
 .../ethernet/microchip/sparx5/sparx5_pool.c   | 81 +++++++++++++++++++
 3 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_pool.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index d0ed7090aa54..6bb4609107b4 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -9,7 +9,8 @@ sparx5-switch-y  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_phylink.o sparx5_port.o sparx5_mactable.o sparx5_vlan.o \
  sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o sparx5_fdma.o \
  sparx5_ptp.o sparx5_pgid.o sparx5_tc.o sparx5_qos.o \
- sparx5_vcap_impl.o sparx5_vcap_ag_api.o sparx5_tc_flower.o sparx5_tc_matchall.o
+ sparx5_vcap_impl.o sparx5_vcap_ag_api.o sparx5_tc_flower.o \
+ sparx5_tc_matchall.o sparx5_pool.o
 
 sparx5-switch-$(CONFIG_SPARX5_DCB) += sparx5_dcb.o
 sparx5-switch-$(CONFIG_DEBUG_FS) += sparx5_vcap_debugfs.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 4a574cdcb584..4d0556e2ff24 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -413,6 +413,18 @@ int sparx5_pgid_alloc_glag(struct sparx5 *spx5, u16 *idx);
 int sparx5_pgid_alloc_mcast(struct sparx5 *spx5, u16 *idx);
 int sparx5_pgid_free(struct sparx5 *spx5, u16 idx);
 
+/* sparx5_pool.c */
+struct sparx5_pool_entry {
+	u16 ref_cnt;
+	u32 idx; /* tc index */
+};
+
+u32 sparx5_pool_idx_to_id(u32 idx);
+int sparx5_pool_put(struct sparx5_pool_entry *pool, int size, u32 id);
+int sparx5_pool_get(struct sparx5_pool_entry *pool, int size, u32 *id);
+int sparx5_pool_get_with_idx(struct sparx5_pool_entry *pool, int size, u32 idx,
+			     u32 *id);
+
 /* Clock period in picoseconds */
 static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
 {
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_pool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_pool.c
new file mode 100644
index 000000000000..b4b280c6138b
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_pool.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2023 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+
+static u32 sparx5_pool_id_to_idx(u32 id)
+{
+	return --id;
+}
+
+u32 sparx5_pool_idx_to_id(u32 idx)
+{
+	return ++idx;
+}
+
+/* Release resource from pool.
+ * Return reference count on success, otherwise return error.
+ */
+int sparx5_pool_put(struct sparx5_pool_entry *pool, int size, u32 id)
+{
+	struct sparx5_pool_entry *e_itr;
+
+	e_itr = (pool + sparx5_pool_id_to_idx(id));
+	if (e_itr->ref_cnt == 0)
+		return -EINVAL;
+
+	return --e_itr->ref_cnt;
+}
+
+/* Get resource from pool.
+ * Return reference count on success, otherwise return error.
+ */
+int sparx5_pool_get(struct sparx5_pool_entry *pool, int size, u32 *id)
+{
+	struct sparx5_pool_entry *e_itr;
+	int i;
+
+	for (i = 0, e_itr = pool; i < size; i++, e_itr++) {
+		if (e_itr->ref_cnt == 0) {
+			*id = sparx5_pool_idx_to_id(i);
+			return ++e_itr->ref_cnt;
+		}
+	}
+
+	return -ENOSPC;
+}
+
+/* Get resource from pool that matches index.
+ * Return reference count on success, otherwise return error.
+ */
+int sparx5_pool_get_with_idx(struct sparx5_pool_entry *pool, int size, u32 idx,
+			     u32 *id)
+{
+	struct sparx5_pool_entry *e_itr;
+	int i, ret = -ENOSPC;
+
+	for (i = 0, e_itr = pool; i < size; i++, e_itr++) {
+		/* Pool index of first free entry */
+		if (e_itr->ref_cnt == 0 && ret == -ENOSPC)
+			ret = i;
+		/* Tc index already in use ? */
+		if (e_itr->idx == idx && e_itr->ref_cnt > 0) {
+			ret = i;
+			break;
+		}
+	}
+
+	/* Did we find a free entry? */
+	if (ret >= 0) {
+		*id = sparx5_pool_idx_to_id(ret);
+		e_itr = (pool + ret);
+		e_itr->idx = idx;
+		return ++e_itr->ref_cnt;
+	}
+
+	return ret;
+}
-- 
2.34.1

