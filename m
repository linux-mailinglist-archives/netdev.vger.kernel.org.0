Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA3D3620C5
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 15:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244157AbhDPNSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 09:18:48 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:30700 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243841AbhDPNSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 09:18:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1618579061; x=1650115061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YUjQTCGV1knJIY+0jW6ozAejYlUkq0fxZRD0iIhSX74=;
  b=TG3FCPX7//hNkgvvzq/VnVLPnjXmljWAIlb/FNTbcGhTVa9t6SsBnpDv
   InL889/to3SjVWmIx0es3qEf9TRfOzFNK8g4dJEM0UMZacFS5Ka6hl2G0
   P75NXNEaed2mD4bV8ysmwgzS1tVrPdjJIC6UV5o0tuQj6WbaNOpG8+oD+
   GwpT9NXxkQYoo+u//1QnSfoU1ScRgdrsw6jFYebWVskfljer4wjImmhSR
   kE4DA1o4ygd+VyMgJGRH60fK1qxSGW6z2Bjd/TueRLPjrC9Udmz9R+vKL
   MJSOW54MFVy2cCeok9S8wdfUED2tcgqotumsV7GFiDe5cgXrzZRj51yz1
   Q==;
IronPort-SDR: 2/pzjN2pnS+IdtD1KKXz62pWuwn4zlHgKAslrB1+0SyEronht0CpmeiByR0+P1wnMhPmmXeoxF
 +JG7GK8loWunqUIgmQKjpp4N1SsDEiXFgv6xtgWz4IElWnioXY+ez6JYkwBcVYt3re6/Nw6D77
 tG0xB6fSMnyttPbkiDC6i4H2WhYAld6vR0hIRkSqtHrmSFE8KBp8mhISbzh1FS9kqJhEWCA+A2
 zLgqLGXvK9uxWutMgIlFkC+vYcSNz/xo4R163LB7UPfvCWd93cQAGjnB9v4VlFcAqfYHzqv7p2
 BK8=
X-IronPort-AV: E=Sophos;i="5.82,226,1613458800"; 
   d="scan'208";a="116731302"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Apr 2021 06:17:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 06:17:38 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 16 Apr 2021 06:17:35 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next 09/10] net: sparx5: add ethtool configuration and statistics support
Date:   Fri, 16 Apr 2021 15:16:56 +0200
Message-ID: <20210416131657.3151464-10-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210416131657.3151464-1-steen.hegelund@microchip.com>
References: <20210416131657.3151464-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds statistic counters for the network interfaces provided
by the driver.  It also adds CPU port counters (which are not
exposed by ethtool).
This also adds support for configuring the network interface
parameters via ethtool: speed, duplex, aneg etc.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
---
 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../microchip/sparx5/sparx5_ethtool.c         | 999 ++++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_main.c   |   4 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |  12 +
 .../ethernet/microchip/sparx5/sparx5_netdev.c |   2 +
 5 files changed, 1018 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c

diff --git a/drivers/net/ethernet/microchip/sparx5/Makefile b/drivers/net/ethernet/microchip/sparx5/Makefile
index e7dea25eb479..5df99f9a12e9 100644
--- a/drivers/net/ethernet/microchip/sparx5/Makefile
+++ b/drivers/net/ethernet/microchip/sparx5/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_SPARX5_SWITCH) += sparx5-switch.o
 
 sparx5-switch-objs  := sparx5_main.o sparx5_packet.o \
  sparx5_netdev.o sparx5_port.o sparx5_phylink.o sparx5_mactable.o sparx5_vlan.o \
- sparx5_switchdev.o sparx5_calendar.o
+ sparx5_switchdev.o sparx5_calendar.o sparx5_ethtool.o
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
new file mode 100644
index 000000000000..5cbde50533b9
--- /dev/null
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
@@ -0,0 +1,999 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Microchip Sparx5 Switch driver
+ *
+ * Copyright (c) 2021 Microchip Technology Inc. and its subsidiaries.
+ */
+
+#include <linux/ethtool.h>
+
+#include "sparx5_main_regs.h"
+#include "sparx5_main.h"
+#include "sparx5_port.h"
+
+/* Index of ANA_AC port counters */
+#define SPX5_PORT_POLICER_DROPS 0
+
+/* Add a potentially wrapping 32 bit value to a 64 bit counter */
+static void sparx5_update_counter(u64 *cnt, u32 val)
+{
+	if (val < (*cnt & U32_MAX))
+		*cnt += (u64)1 << 32; /* value has wrapped */
+
+	*cnt = (*cnt & ~(u64)U32_MAX) + val;
+}
+
+/* Get a set of Queue System statistics */
+static void sparx5_xqs_prio_stats(struct sparx5 *sparx5,
+				  u32 addr,
+				  u64 *stats)
+{
+	int idx;
+
+	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx, ++addr, ++stats)
+		sparx5_update_counter(stats, spx5_rd(sparx5, XQS_CNT(addr)));
+}
+
+#define SPX5_STAT_GET(sname)        portstats[spx5_stats_##sname]
+#define SPX5_STAT_SUM(sname)        (portstats[spx5_stats_##sname] + \
+				     portstats[spx5_stats_pmac_##sname])
+#define SPX5_STAT_XQS_PRIOS_COUNTER_SUM(sname)    \
+	(portstats[spx5_stats_green_p0_##sname] + \
+	portstats[spx5_stats_green_p1_##sname] +  \
+	portstats[spx5_stats_green_p2_##sname] +  \
+	portstats[spx5_stats_green_p3_##sname] +  \
+	portstats[spx5_stats_green_p4_##sname] +  \
+	portstats[spx5_stats_green_p5_##sname] +  \
+	portstats[spx5_stats_green_p6_##sname] +  \
+	portstats[spx5_stats_green_p7_##sname] +  \
+	portstats[spx5_stats_yellow_p0_##sname] + \
+	portstats[spx5_stats_yellow_p1_##sname] + \
+	portstats[spx5_stats_yellow_p2_##sname] + \
+	portstats[spx5_stats_yellow_p3_##sname] + \
+	portstats[spx5_stats_yellow_p4_##sname] + \
+	portstats[spx5_stats_yellow_p5_##sname] + \
+	portstats[spx5_stats_yellow_p6_##sname] + \
+	portstats[spx5_stats_yellow_p7_##sname])
+
+enum sparx5_stats_entry {
+	spx5_stats_rx_in_bytes,
+	spx5_stats_rx_symbol_err,
+	spx5_stats_rx_pause,
+	spx5_stats_rx_unsup_opcode,
+	spx5_stats_rx_ok_bytes,
+	spx5_stats_rx_bad_bytes,
+	spx5_stats_rx_unicast,
+	spx5_stats_rx_multicast,
+	spx5_stats_rx_broadcast,
+	spx5_stats_rx_crc_err,
+	spx5_stats_rx_undersize,
+	spx5_stats_rx_fragments,
+	spx5_stats_rx_inrangelen_err,
+	spx5_stats_rx_outofrangelen_err,
+	spx5_stats_rx_oversize,
+	spx5_stats_rx_jabbers,
+	spx5_stats_rx_size64,
+	spx5_stats_rx_size65_127,
+	spx5_stats_rx_size128_255,
+	spx5_stats_rx_size256_511,
+	spx5_stats_rx_size512_1023,
+	spx5_stats_rx_size1024_1518,
+	spx5_stats_rx_size1519_max,
+	spx5_stats_pmac_rx_symbol_err,
+	spx5_stats_pmac_rx_pause,
+	spx5_stats_pmac_rx_unsup_opcode,
+	spx5_stats_pmac_rx_ok_bytes,
+	spx5_stats_pmac_rx_bad_bytes,
+	spx5_stats_pmac_rx_unicast,
+	spx5_stats_pmac_rx_multicast,
+	spx5_stats_pmac_rx_broadcast,
+	spx5_stats_pmac_rx_crc_err,
+	spx5_stats_pmac_rx_undersize,
+	spx5_stats_pmac_rx_fragments,
+	spx5_stats_pmac_rx_inrangelen_err,
+	spx5_stats_pmac_rx_outofrangelen_err,
+	spx5_stats_pmac_rx_oversize,
+	spx5_stats_pmac_rx_jabbers,
+	spx5_stats_pmac_rx_size64,
+	spx5_stats_pmac_rx_size65_127,
+	spx5_stats_pmac_rx_size128_255,
+	spx5_stats_pmac_rx_size256_511,
+	spx5_stats_pmac_rx_size512_1023,
+	spx5_stats_pmac_rx_size1024_1518,
+	spx5_stats_pmac_rx_size1519_max,
+	spx5_stats_green_p0_rx_fwd,
+	spx5_stats_green_p1_rx_fwd,
+	spx5_stats_green_p2_rx_fwd,
+	spx5_stats_green_p3_rx_fwd,
+	spx5_stats_green_p4_rx_fwd,
+	spx5_stats_green_p5_rx_fwd,
+	spx5_stats_green_p6_rx_fwd,
+	spx5_stats_green_p7_rx_fwd,
+	spx5_stats_yellow_p0_rx_fwd,
+	spx5_stats_yellow_p1_rx_fwd,
+	spx5_stats_yellow_p2_rx_fwd,
+	spx5_stats_yellow_p3_rx_fwd,
+	spx5_stats_yellow_p4_rx_fwd,
+	spx5_stats_yellow_p5_rx_fwd,
+	spx5_stats_yellow_p6_rx_fwd,
+	spx5_stats_yellow_p7_rx_fwd,
+	spx5_stats_green_p0_rx_port_drop,
+	spx5_stats_green_p1_rx_port_drop,
+	spx5_stats_green_p2_rx_port_drop,
+	spx5_stats_green_p3_rx_port_drop,
+	spx5_stats_green_p4_rx_port_drop,
+	spx5_stats_green_p5_rx_port_drop,
+	spx5_stats_green_p6_rx_port_drop,
+	spx5_stats_green_p7_rx_port_drop,
+	spx5_stats_yellow_p0_rx_port_drop,
+	spx5_stats_yellow_p1_rx_port_drop,
+	spx5_stats_yellow_p2_rx_port_drop,
+	spx5_stats_yellow_p3_rx_port_drop,
+	spx5_stats_yellow_p4_rx_port_drop,
+	spx5_stats_yellow_p5_rx_port_drop,
+	spx5_stats_yellow_p6_rx_port_drop,
+	spx5_stats_yellow_p7_rx_port_drop,
+	spx5_stats_rx_local_drop,
+	spx5_stats_rx_port_policer_drop,
+	spx5_stats_tx_out_bytes,
+	spx5_stats_tx_pause,
+	spx5_stats_tx_ok_bytes,
+	spx5_stats_tx_unicast,
+	spx5_stats_tx_multicast,
+	spx5_stats_tx_broadcast,
+	spx5_stats_tx_size64,
+	spx5_stats_tx_size65_127,
+	spx5_stats_tx_size128_255,
+	spx5_stats_tx_size256_511,
+	spx5_stats_tx_size512_1023,
+	spx5_stats_tx_size1024_1518,
+	spx5_stats_tx_size1519_max,
+	spx5_stats_tx_multi_coll,
+	spx5_stats_tx_late_coll,
+	spx5_stats_tx_xcoll,
+	spx5_stats_tx_defer,
+	spx5_stats_tx_xdefer,
+	spx5_stats_tx_backoff1,
+	spx5_stats_pmac_tx_pause,
+	spx5_stats_pmac_tx_ok_bytes,
+	spx5_stats_pmac_tx_unicast,
+	spx5_stats_pmac_tx_multicast,
+	spx5_stats_pmac_tx_broadcast,
+	spx5_stats_pmac_tx_size64,
+	spx5_stats_pmac_tx_size65_127,
+	spx5_stats_pmac_tx_size128_255,
+	spx5_stats_pmac_tx_size256_511,
+	spx5_stats_pmac_tx_size512_1023,
+	spx5_stats_pmac_tx_size1024_1518,
+	spx5_stats_pmac_tx_size1519_max,
+	spx5_stats_green_p0_tx_port,
+	spx5_stats_green_p1_tx_port,
+	spx5_stats_green_p2_tx_port,
+	spx5_stats_green_p3_tx_port,
+	spx5_stats_green_p4_tx_port,
+	spx5_stats_green_p5_tx_port,
+	spx5_stats_green_p6_tx_port,
+	spx5_stats_green_p7_tx_port,
+	spx5_stats_yellow_p0_tx_port,
+	spx5_stats_yellow_p1_tx_port,
+	spx5_stats_yellow_p2_tx_port,
+	spx5_stats_yellow_p3_tx_port,
+	spx5_stats_yellow_p4_tx_port,
+	spx5_stats_yellow_p5_tx_port,
+	spx5_stats_yellow_p6_tx_port,
+	spx5_stats_yellow_p7_tx_port,
+	spx5_stats_tx_local_drop,
+};
+
+static const char *const sparx5_stats_layout[] = {
+	"rx_in_bytes",
+	"rx_symbol_err",
+	"rx_pause",
+	"rx_unsup_opcode",
+	"rx_ok_bytes",
+	"rx_bad_bytes",
+	"rx_unicast",
+	"rx_multicast",
+	"rx_broadcast",
+	"rx_crc_err",
+	"rx_undersize",
+	"rx_fragments",
+	"rx_inrangelen_err",
+	"rx_outofrangelen_err",
+	"rx_oversize",
+	"rx_jabbers",
+	"rx_size64",
+	"rx_size65_127",
+	"rx_size128_255",
+	"rx_size256_511",
+	"rx_size512_1023",
+	"rx_size1024_1518",
+	"rx_size1519_max",
+	"pmac_rx_symbol_err",
+	"pmac_rx_pause",
+	"pmac_rx_unsup_opcode",
+	"pmac_rx_ok_bytes",
+	"pmac_rx_bad_bytes",
+	"pmac_rx_unicast",
+	"pmac_rx_multicast",
+	"pmac_rx_broadcast",
+	"pmac_rx_crc_err",
+	"pmac_rx_undersize",
+	"pmac_rx_fragments",
+	"pmac_rx_inrangelen_err",
+	"pmac_rx_outofrangelen_err",
+	"pmac_rx_oversize",
+	"pmac_rx_jabbers",
+	"pmac_rx_size64",
+	"pmac_rx_size65_127",
+	"pmac_rx_size128_255",
+	"pmac_rx_size256_511",
+	"pmac_rx_size512_1023",
+	"pmac_rx_size1024_1518",
+	"pmac_rx_size1519_max",
+	"rx_fwd_green_p0_q",
+	"rx_fwd_green_p1_q",
+	"rx_fwd_green_p2_q",
+	"rx_fwd_green_p3_q",
+	"rx_fwd_green_p4_q",
+	"rx_fwd_green_p5_q",
+	"rx_fwd_green_p6_q",
+	"rx_fwd_green_p7_q",
+	"rx_fwd_yellow_p0_q",
+	"rx_fwd_yellow_p1_q",
+	"rx_fwd_yellow_p2_q",
+	"rx_fwd_yellow_p3_q",
+	"rx_fwd_yellow_p4_q",
+	"rx_fwd_yellow_p5_q",
+	"rx_fwd_yellow_p6_q",
+	"rx_fwd_yellow_p7_q",
+	"rx_port_drop_green_p0_q",
+	"rx_port_drop_green_p1_q",
+	"rx_port_drop_green_p2_q",
+	"rx_port_drop_green_p3_q",
+	"rx_port_drop_green_p4_q",
+	"rx_port_drop_green_p5_q",
+	"rx_port_drop_green_p6_q",
+	"rx_port_drop_green_p7_q",
+	"rx_port_drop_yellow_p0_q",
+	"rx_port_drop_yellow_p1_q",
+	"rx_port_drop_yellow_p2_q",
+	"rx_port_drop_yellow_p3_q",
+	"rx_port_drop_yellow_p4_q",
+	"rx_port_drop_yellow_p5_q",
+	"rx_port_drop_yellow_p6_q",
+	"rx_port_drop_yellow_p7_q",
+	"rx_local_drop",
+	"rx_port_policer_drop",
+	"tx_out_bytes",
+	"tx_pause",
+	"tx_ok_bytes",
+	"tx_unicast",
+	"tx_multicast",
+	"tx_broadcast",
+	"tx_size64",
+	"tx_size65_127",
+	"tx_size128_255",
+	"tx_size256_511",
+	"tx_size512_1023",
+	"tx_size1024_1518",
+	"tx_size1519_max",
+	"tx_multi_coll",
+	"tx_late_coll",
+	"tx_xcoll",
+	"tx_defer",
+	"tx_xdefer",
+	"tx_backoff1",
+	"pmac_tx_pause",
+	"pmac_tx_ok_bytes",
+	"pmac_tx_unicast",
+	"pmac_tx_multicast",
+	"pmac_tx_broadcast",
+	"pmac_tx_size64",
+	"pmac_tx_size65_127",
+	"pmac_tx_size128_255",
+	"pmac_tx_size256_511",
+	"pmac_tx_size512_1023",
+	"pmac_tx_size1024_1518",
+	"pmac_tx_size1519_max",
+	"tx_port_green_p0_q",
+	"tx_port_green_p1_q",
+	"tx_port_green_p2_q",
+	"tx_port_green_p3_q",
+	"tx_port_green_p4_q",
+	"tx_port_green_p5_q",
+	"tx_port_green_p6_q",
+	"tx_port_green_p7_q",
+	"tx_port_yellow_p0_q",
+	"tx_port_yellow_p1_q",
+	"tx_port_yellow_p2_q",
+	"tx_port_yellow_p3_q",
+	"tx_port_yellow_p4_q",
+	"tx_port_yellow_p5_q",
+	"tx_port_yellow_p6_q",
+	"tx_port_yellow_p7_q",
+	"tx_local_drop",
+};
+
+/* Device Statistics */
+static void sparx5_get_device_stats(struct sparx5 *sparx5, int portno)
+{
+	u64 *portstats = &sparx5->stats[portno * sparx5->num_stats];
+	u32 tinst = sparx5_port_dev_index(portno);
+	u32 dev = sparx5_to_high_dev(portno);
+	void __iomem *inst;
+
+	inst = spx5_inst_get(sparx5, dev, tinst);
+	sparx5_update_counter(&portstats[spx5_stats_rx_in_bytes],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_IN_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_symbol_err],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SYMBOL_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_pause],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_unsup_opcode],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_UNSUP_OPCODE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_ok_bytes],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_bad_bytes],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_BAD_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_unicast],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_multicast],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_broadcast],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_crc_err],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_CRC_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_undersize],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_UNDERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_fragments],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_FRAGMENTS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_inrangelen_err],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_IN_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_outofrangelen_err],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_OUT_OF_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_oversize],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_OVERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_jabbers],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_JABBERS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size64],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size65_127],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size128_255],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size256_511],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size512_1023],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1024_1518],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1519_max],
+			      spx5_inst_rd(inst,
+					   DEV5G_RX_SIZE1519TOMAX_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_symbol_err],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SYMBOL_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_pause],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_unsup_opcode],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_UNSUP_OPCODE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_ok_bytes],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_bad_bytes],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_BAD_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_unicast],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_multicast],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_broadcast],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_crc_err],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_CRC_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_undersize],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_UNDERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_fragments],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_FRAGMENTS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_inrangelen_err],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_IN_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_outofrangelen_err],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_oversize],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_OVERSIZE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_jabbers],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_JABBERS_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size64],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size65_127],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size128_255],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size256_511],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size512_1023],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1024_1518],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1519_max],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_RX_SIZE1519TOMAX_CNT(tinst)));
+	sparx5_xqs_prio_stats(sparx5,
+			      0,
+			      &portstats[spx5_stats_green_p0_rx_fwd]);
+	sparx5_xqs_prio_stats(sparx5,
+			      16,
+			      &portstats[spx5_stats_green_p0_rx_port_drop]);
+	sparx5_update_counter(&portstats[spx5_stats_rx_local_drop],
+			      spx5_rd(sparx5, XQS_CNT(32)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_port_policer_drop],
+			      spx5_rd(sparx5,
+				      ANA_AC_PORT_STAT_LSB_CNT(portno,
+							       SPX5_PORT_POLICER_DROPS)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_out_bytes],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_OUT_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_pause],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_ok_bytes],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_unicast],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_multicast],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_broadcast],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size64],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size65_127],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size128_255],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size256_511],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size512_1023],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1024_1518],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1519_max],
+			      spx5_inst_rd(inst,
+					   DEV5G_TX_SIZE1519TOMAX_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_pause],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_PAUSE_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_ok_bytes],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_OK_BYTES_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_unicast],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_UC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_multicast],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_MC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_broadcast],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_BC_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size64],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE64_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size65_127],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE65TO127_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size128_255],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE128TO255_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size256_511],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE256TO511_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size512_1023],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE512TO1023_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1024_1518],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE1024TO1518_CNT(tinst)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1519_max],
+			      spx5_inst_rd(inst,
+					   DEV5G_PMAC_TX_SIZE1519TOMAX_CNT(tinst)));
+	sparx5_xqs_prio_stats(sparx5,
+			      256,
+			      &portstats[spx5_stats_green_p0_tx_port]);
+	sparx5_update_counter(&portstats[spx5_stats_tx_local_drop],
+			      spx5_rd(sparx5, XQS_CNT(272)));
+}
+
+/* ASM Statistics */
+static void sparx5_get_asm_stats(struct sparx5 *sparx5, int portno)
+{
+	u64 *portstats = &sparx5->stats[portno * sparx5->num_stats];
+	void __iomem *inst = spx5_inst_get(sparx5, TARGET_ASM, 0);
+
+	sparx5_update_counter(&portstats[spx5_stats_rx_in_bytes],
+			      spx5_inst_rd(inst,
+					   ASM_RX_IN_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_symbol_err],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SYMBOL_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_pause],
+			      spx5_inst_rd(inst,
+					   ASM_RX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_unsup_opcode],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_UNSUP_OPCODE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_ok_bytes],
+			      spx5_inst_rd(inst,
+					   ASM_RX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_bad_bytes],
+			      spx5_inst_rd(inst,
+					   ASM_RX_BAD_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_unicast],
+			      spx5_inst_rd(inst,
+					   ASM_RX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_multicast],
+			      spx5_inst_rd(inst,
+					   ASM_RX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_broadcast],
+			      spx5_inst_rd(inst,
+					   ASM_RX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_crc_err],
+			      spx5_inst_rd(inst,
+					   ASM_RX_CRC_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_undersize],
+			      spx5_inst_rd(inst,
+					   ASM_RX_UNDERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_fragments],
+			      spx5_inst_rd(inst,
+					   ASM_RX_FRAGMENTS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_inrangelen_err],
+			      spx5_inst_rd(inst,
+					   ASM_RX_IN_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_outofrangelen_err],
+			      spx5_inst_rd(inst,
+					   ASM_RX_OUT_OF_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_oversize],
+			      spx5_inst_rd(inst,
+					   ASM_RX_OVERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_jabbers],
+			      spx5_inst_rd(inst,
+					   ASM_RX_JABBERS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size64],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size65_127],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size128_255],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size256_511],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size512_1023],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1024_1518],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_size1519_max],
+			      spx5_inst_rd(inst,
+					   ASM_RX_SIZE1519TOMAX_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_symbol_err],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SYMBOL_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_pause],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_unsup_opcode],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_UNSUP_OPCODE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_ok_bytes],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_bad_bytes],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_BAD_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_unicast],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_multicast],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_broadcast],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_crc_err],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_CRC_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_undersize],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_UNDERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_fragments],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_FRAGMENTS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_inrangelen_err],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_IN_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_outofrangelen_err],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_OUT_OF_RANGE_LEN_ERR_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_oversize],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_OVERSIZE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_jabbers],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_JABBERS_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size64],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size65_127],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size128_255],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size256_511],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size512_1023],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1024_1518],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_rx_size1519_max],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_RX_SIZE1519TOMAX_CNT(portno)));
+	sparx5_xqs_prio_stats(sparx5,
+			      0,
+			      &portstats[spx5_stats_green_p0_rx_fwd]);
+	sparx5_xqs_prio_stats(sparx5,
+			      16,
+			      &portstats[spx5_stats_green_p0_rx_port_drop]);
+	sparx5_update_counter(&portstats[spx5_stats_rx_local_drop],
+			      spx5_rd(sparx5, XQS_CNT(32)));
+	sparx5_update_counter(&portstats[spx5_stats_rx_port_policer_drop],
+			      spx5_rd(sparx5,
+				      ANA_AC_PORT_STAT_LSB_CNT(portno,
+							       SPX5_PORT_POLICER_DROPS)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_out_bytes],
+			      spx5_inst_rd(inst,
+					   ASM_TX_OUT_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_pause],
+			      spx5_inst_rd(inst,
+					   ASM_TX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_ok_bytes],
+			      spx5_inst_rd(inst,
+					   ASM_TX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_unicast],
+			      spx5_inst_rd(inst,
+					   ASM_TX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_multicast],
+			      spx5_inst_rd(inst,
+					   ASM_TX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_broadcast],
+			      spx5_inst_rd(inst,
+					   ASM_TX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size64],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size65_127],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size128_255],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size256_511],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size512_1023],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1024_1518],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_size1519_max],
+			      spx5_inst_rd(inst,
+					   ASM_TX_SIZE1519TOMAX_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_multi_coll],
+			      spx5_inst_rd(inst,
+					   ASM_TX_MULTI_COLL_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_late_coll],
+			      spx5_inst_rd(inst,
+					   ASM_TX_LATE_COLL_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_xcoll],
+			      spx5_inst_rd(inst,
+					   ASM_TX_XCOLL_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_defer],
+			      spx5_inst_rd(inst,
+					   ASM_TX_DEFER_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_xdefer],
+			      spx5_inst_rd(inst,
+					   ASM_TX_XDEFER_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_tx_backoff1],
+			      spx5_inst_rd(inst,
+					   ASM_TX_BACKOFF1_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_pause],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_PAUSE_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_ok_bytes],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_OK_BYTES_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_unicast],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_UC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_multicast],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_MC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_broadcast],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_BC_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size64],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE64_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size65_127],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE65TO127_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size128_255],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE128TO255_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size256_511],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE256TO511_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size512_1023],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE512TO1023_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1024_1518],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE1024TO1518_CNT(portno)));
+	sparx5_update_counter(&portstats[spx5_stats_pmac_tx_size1519_max],
+			      spx5_inst_rd(inst,
+					   ASM_PMAC_TX_SIZE1519TOMAX_CNT(portno)));
+	sparx5_xqs_prio_stats(sparx5,
+			      256,
+			      &portstats[spx5_stats_green_p0_tx_port]);
+	sparx5_update_counter(&portstats[spx5_stats_tx_local_drop],
+			      spx5_rd(sparx5, XQS_CNT(272)));
+}
+
+static void sparx5_config_stats(struct sparx5 *sparx5)
+{
+	/* Enable global events for port policer drops */
+	spx5_rmw(ANA_AC_PORT_SGE_CFG_MASK_SET(0xf0f0),
+		 ANA_AC_PORT_SGE_CFG_MASK,
+		 sparx5,
+		 ANA_AC_PORT_SGE_CFG(SPX5_PORT_POLICER_DROPS));
+}
+
+static void sparx5_config_port_stats(struct sparx5 *sparx5, int portno)
+{
+	/* Clear Queue System counters */
+	spx5_wr(XQS_STAT_CFG_STAT_VIEW_SET(portno) |
+		XQS_STAT_CFG_STAT_CLEAR_SHOT_SET(3), sparx5,
+		XQS_STAT_CFG);
+
+	/* Use counter for port policer drop count */
+	spx5_rmw(ANA_AC_PORT_STAT_CFG_CFG_CNT_FRM_TYPE_SET(1) |
+		 ANA_AC_PORT_STAT_CFG_CFG_CNT_BYTE_SET(0) |
+		 ANA_AC_PORT_STAT_CFG_CFG_PRIO_MASK_SET(0xff),
+		 ANA_AC_PORT_STAT_CFG_CFG_CNT_FRM_TYPE |
+		 ANA_AC_PORT_STAT_CFG_CFG_CNT_BYTE |
+		 ANA_AC_PORT_STAT_CFG_CFG_PRIO_MASK,
+		 sparx5, ANA_AC_PORT_STAT_CFG(portno, SPX5_PORT_POLICER_DROPS));
+}
+
+static void sparx5_update_port_stats(struct sparx5 *sparx5, int portno)
+{
+	/* Set XQS port number */
+	spx5_wr(XQS_STAT_CFG_STAT_VIEW_SET(portno), sparx5, XQS_STAT_CFG);
+	if (sparx5_is_high_speed_device(&sparx5->ports[portno]->conf))
+		sparx5_get_device_stats(sparx5, portno);
+	else
+		sparx5_get_asm_stats(sparx5, portno);
+}
+
+static void sparx5_update_stats(struct sparx5 *sparx5)
+{
+	int idx;
+
+	for (idx = 0; idx < SPX5_PORTS; idx++)
+		if (sparx5->ports[idx])
+			sparx5_update_port_stats(sparx5, idx);
+}
+
+static void sparx5_check_stats_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct sparx5 *sparx5 = container_of(dwork,
+					     struct sparx5,
+					     stats_work);
+
+	sparx5_update_stats(sparx5);
+
+	queue_delayed_work(sparx5->stats_queue, &sparx5->stats_work,
+			   SPX5_STATS_CHECK_DELAY);
+}
+
+static int sparx5_get_sset_count(struct net_device *ndev, int sset)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5  *sparx5 = port->sparx5;
+
+	if (sset != ETH_SS_STATS)
+		return -EOPNOTSUPP;
+	return sparx5->num_stats;
+}
+
+static void sparx5_get_sset_strings(struct net_device *ndev, u32 sset, u8 *data)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5  *sparx5 = port->sparx5;
+	int idx;
+
+	if (sset != ETH_SS_STATS)
+		return;
+
+	for (idx = 0; idx < sparx5->num_stats; idx++)
+		strncpy(data + idx * ETH_GSTRING_LEN,
+			sparx5->stats_layout[idx], ETH_GSTRING_LEN);
+}
+
+static void sparx5_get_stats(struct net_device *ndev,
+			     struct ethtool_stats *stats, u64 *data)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	u64 *portstats;
+	int idx;
+
+	portstats = &sparx5->stats[port->portno * sparx5->num_stats];
+	/* Copy port counters to the ethtool buffer */
+	for (idx = 0; idx < sparx5->num_stats; idx++)
+		*data++ = portstats[idx];
+}
+
+void sparx5_get_stats64(struct net_device *ndev,
+			struct rtnl_link_stats64 *stats)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	u64 *portstats;
+
+	if (!sparx5->stats)
+		return; /* Not initialized yet */
+
+	portstats = &sparx5->stats[port->portno * sparx5->num_stats];
+
+	stats->rx_errors = SPX5_STAT_SUM(rx_crc_err) +
+		SPX5_STAT_SUM(rx_undersize) + SPX5_STAT_SUM(rx_oversize) +
+		SPX5_STAT_SUM(rx_outofrangelen_err) +
+		SPX5_STAT_SUM(rx_symbol_err) + SPX5_STAT_SUM(rx_jabbers) +
+		SPX5_STAT_SUM(rx_fragments);
+
+	stats->rx_bytes = SPX5_STAT_SUM(rx_ok_bytes) +
+		SPX5_STAT_SUM(rx_bad_bytes);
+
+	stats->rx_packets = SPX5_STAT_SUM(rx_unicast) +
+		SPX5_STAT_SUM(rx_multicast) + SPX5_STAT_SUM(rx_broadcast) +
+		stats->rx_errors;
+
+	stats->multicast = SPX5_STAT_SUM(rx_unicast);
+
+	stats->rx_dropped = SPX5_STAT_GET(rx_port_policer_drop) +
+		SPX5_STAT_XQS_PRIOS_COUNTER_SUM(rx_port_drop);
+
+	/* Get Tx stats */
+	stats->tx_bytes = SPX5_STAT_SUM(tx_ok_bytes);
+
+	stats->tx_packets = SPX5_STAT_SUM(tx_unicast) +
+		SPX5_STAT_SUM(tx_multicast) + SPX5_STAT_SUM(tx_broadcast);
+
+	stats->tx_dropped = SPX5_STAT_GET(tx_local_drop);
+
+	stats->collisions = SPX5_STAT_GET(tx_multi_coll) +
+		SPX5_STAT_GET(tx_late_coll) +
+		SPX5_STAT_GET(tx_xcoll) +
+		SPX5_STAT_GET(tx_backoff1);
+}
+
+static int sparx5_get_link_settings(struct net_device *ndev,
+				    struct ethtool_link_ksettings *cmd)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_get(port->phylink, cmd);
+}
+
+static int sparx5_set_link_settings(struct net_device *ndev,
+				    const struct ethtool_link_ksettings *cmd)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+
+	return phylink_ethtool_ksettings_set(port->phylink, cmd);
+}
+
+const struct ethtool_ops sparx5_ethtool_ops = {
+	.get_sset_count         = sparx5_get_sset_count,
+	.get_strings            = sparx5_get_sset_strings,
+	.get_ethtool_stats      = sparx5_get_stats,
+	.get_link_ksettings	= sparx5_get_link_settings,
+	.set_link_ksettings	= sparx5_set_link_settings,
+	.get_link               = ethtool_op_get_link,
+};
+
+int sparx_stats_init(struct sparx5 *sparx5)
+{
+	char queue_name[32];
+	int portno;
+
+	sparx5->stats_layout = sparx5_stats_layout;
+	sparx5->num_stats = ARRAY_SIZE(sparx5_stats_layout);
+	sparx5->stats = devm_kcalloc(sparx5->dev,
+				     SPX5_PORTS_ALL * sparx5->num_stats,
+				     sizeof(u64), GFP_KERNEL);
+	if (!sparx5->stats)
+		return -ENOMEM;
+
+	sparx5_config_stats(sparx5);
+	for (portno = 0; portno < SPX5_PORTS; portno++)
+		if (sparx5->ports[portno])
+			sparx5_config_port_stats(sparx5, portno);
+
+	snprintf(queue_name, sizeof(queue_name), "%s-stats",
+		 dev_name(sparx5->dev));
+	sparx5->stats_queue = create_singlethread_workqueue(queue_name);
+	INIT_DELAYED_WORK(&sparx5->stats_work, sparx5_check_stats_work);
+	queue_delayed_work(sparx5->stats_queue, &sparx5->stats_work,
+			   SPX5_STATS_CHECK_DELAY);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 7c101afc7322..7ffd4b61dd33 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -624,6 +624,10 @@ static int sparx5_start(struct sparx5 *sparx5)
 	if (err)
 		return err;
 
+	/* Init stats */
+	err = sparx_stats_init(sparx5);
+	if (err)
+		return err;
 
 	/* Init mact_sw struct */
 	mutex_init(&sparx5->mact_lock);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index e9c48915842d..863f7a081ccb 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -133,6 +133,13 @@ struct sparx5 {
 	/* port structures are in net device */
 	struct sparx5_port *ports[SPX5_PORTS];
 	enum sparx5_core_clockfreq coreclock;
+	/* Statistics */
+	u32 num_stats;
+	const char * const *stats_layout;
+	u64 *stats;
+	/* Workqueue for reading stats */
+	struct delayed_work stats_work;
+	struct workqueue_struct *stats_queue;
 	/* Notifiers */
 	struct notifier_block netdevice_nb;
 	struct notifier_block switchdev_nb;
@@ -200,6 +207,10 @@ void sparx5_vlan_port_apply(struct sparx5 *sparx5, struct sparx5_port *port);
 int sparx5_config_auto_calendar(struct sparx5 *sparx5);
 int sparx5_config_dsm_calendar(struct sparx5 *sparx5);
 
+/* sparx5_ethtool.c */
+void sparx5_get_stats64(struct net_device *ndev, struct rtnl_link_stats64 *stats);
+int sparx_stats_init(struct sparx5 *sparx5);
+
 /* sparx5_netdev.c */
 bool sparx5_netdevice_check(const struct net_device *dev);
 struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno);
@@ -221,6 +232,7 @@ static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
 }
 
 extern const struct phylink_mac_ops sparx5_phylink_mac_ops;
+extern const struct ethtool_ops sparx5_ethtool_ops;
 
 /* Calculate raw offset */
 static inline __pure int spx5_offset(int id, int tinst, int tcnt,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 6b0bfd512dfb..feb71a8f4348 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -177,6 +177,7 @@ static const struct net_device_ops sparx5_port_netdev_ops = {
 	.ndo_get_phys_port_name = sparx5_port_get_phys_port_name,
 	.ndo_set_mac_address    = sparx5_set_mac_address,
 	.ndo_validate_addr      = eth_validate_addr,
+	.ndo_get_stats64        = sparx5_get_stats64,
 	.ndo_get_port_parent_id = sparx5_get_port_parent_id,
 };
 
@@ -204,6 +205,7 @@ struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
 	snprintf(ndev->name, IFNAMSIZ, "eth%d", portno);
 
 	ndev->netdev_ops = &sparx5_port_netdev_ops;
+	ndev->ethtool_ops = &sparx5_ethtool_ops;
 	ndev->features |= NETIF_F_LLTX; /* software tx */
 
 	val = ether_addr_to_u64(sparx5->base_mac) + portno + 1;
-- 
2.31.1

