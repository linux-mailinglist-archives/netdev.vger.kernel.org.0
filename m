Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7CC5749AF
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 11:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbiGNJwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 05:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbiGNJwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 05:52:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3961E1CFEC
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 02:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657792334; x=1689328334;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3WFFj5ZaEbfwQe99l8OLu6bnQMMxdBTZWjfWCuMG0ts=;
  b=1TMFtNfzvpK/70kALfOISwPTAlEmV6lzYgiy5FAV/EleGRccsrrHpxFs
   9ay+GVkhMVSoFhnH/WoO3rOnRks8Z+WlxjChNGtD9FewK7KPoounBGUFS
   Nbb5stbmAsOfTuUnahPWC2qJbR7r0M9hVge5oEWVnRC7IEGf2T/hIgNFP
   3whtCchT49a7hpZG39ZIZxAggZKY58QBxOCPTRAo+o8czzcDcS/tZThjn
   3nXCe3r+Sk6bxxWje/UJLE6tytddpT94JJW6OpUdDmfn3P3VreXnXqsxv
   QgioWhNsfho1ah9Y8P1eys0Q0K1mqraydTxpeUmjvqvBNCBYbXvnDUekA
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="104432966"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2022 02:52:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 14 Jul 2022 02:52:12 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 14 Jul 2022 02:52:10 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <mkubecek@suse.cz>,
        <UNGLinuxDriver@microchip.com>
Subject: [PATCH ethtool] ethtool: add register dump support for lan743x chiptes
Date:   Thu, 14 Jul 2022 15:22:06 +0530
Message-ID: <20220714095206.168187-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LAN743x register dump

Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
---
 Makefile.am |  2 +-
 ethtool.c   |  1 +
 internal.h  |  3 +++
 lan743x.c   | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100644 lan743x.c

diff --git a/Makefile.am b/Makefile.am
index dc5fbec..b90bb9b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -18,7 +18,7 @@ ethtool_SOURCES += \
 		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
 		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
 		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
-		  igc.c cmis.c cmis.h bnxt.c
+		  igc.c cmis.c cmis.h bnxt.c lan743x.c
 endif
 
 if ENABLE_BASH_COMPLETION
diff --git a/ethtool.c b/ethtool.c
index 911f26b..0eff9da 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1129,6 +1129,7 @@ static const struct {
 	{ "fec", fec_dump_regs },
 	{ "igc", igc_dump_regs },
 	{ "bnxt_en", bnxt_dump_regs },
+	{ "lan743x", lan743x_dump_regs },
 };
 #endif
 
diff --git a/internal.h b/internal.h
index 0d9d816..54ae4c6 100644
--- a/internal.h
+++ b/internal.h
@@ -412,4 +412,7 @@ int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 /* Broadcom Ethernet Controller */
 int bnxt_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 
+/* Microchip Ethernet Controller */
+int lan743x_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
+
 #endif /* ETHTOOL_INTERNAL_H__ */
diff --git a/lan743x.c b/lan743x.c
new file mode 100644
index 0000000..f430ee8
--- /dev/null
+++ b/lan743x.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries. */
+
+#include <stdio.h>
+#include <string.h>
+#include "internal.h"
+
+#define LAN743X_ETH_REG_VERSION		1
+
+enum {
+	ETH_PRIV_FLAGS,
+	ETH_ID_REV,
+	ETH_FPGA_REV,
+	ETH_STRAP_READ,
+	ETH_INT_STS,
+	ETH_HW_CFG,
+	ETH_PMT_CTL,
+	ETH_E2P_CMD,
+	ETH_E2P_DATA,
+	ETH_MAC_CR,
+	ETH_MAC_RX,
+	ETH_MAC_TX,
+	ETH_FLOW,
+	ETH_MII_ACC,
+	ETH_MII_DATA,
+	ETH_EEE_TX_LPI_REQ_DLY,
+	ETH_WUCSR,
+	ETH_WK_SRC,
+
+	/* Add new registers above */
+	MAX_LAN743X_ETH_REGS
+};
+
+void lan743x_comm_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
+			    struct ethtool_regs *regs)
+{
+	u32 *lan743x_reg = (u32 *)regs->data;
+
+	fprintf(stdout, "LAN743x Registers:\n");
+	fprintf(stdout, "------------------\n");
+	fprintf(stdout, "CHIP_ID_REV  = 0x%08X\n", lan743x_reg[ETH_ID_REV]);
+	fprintf(stdout, "FPGA_REV     = 0x%08X\n", lan743x_reg[ETH_FPGA_REV]);
+	fprintf(stdout, "STRAP_READ   = 0x%08X\n", lan743x_reg[ETH_STRAP_READ]);
+	fprintf(stdout, "INT_STS      = 0x%08X\n", lan743x_reg[ETH_INT_STS]);
+	fprintf(stdout, "HW_CFG       = 0x%08X\n", lan743x_reg[ETH_HW_CFG]);
+	fprintf(stdout, "PMT_CTRL     = 0x%08X\n", lan743x_reg[ETH_PMT_CTL]);
+	fprintf(stdout, "E2P_CMD      = 0x%08X\n", lan743x_reg[ETH_E2P_CMD]);
+	fprintf(stdout, "E2P_DATA     = 0x%08X\n", lan743x_reg[ETH_E2P_DATA]);
+	fprintf(stdout, "\n");
+
+	fprintf(stdout, "MAC Registers:\n");
+	fprintf(stdout, "--------------\n");
+	fprintf(stdout, "MAC_CR       = 0x%08X\n", lan743x_reg[ETH_MAC_CR]);
+	fprintf(stdout, "MAC_RX       = 0x%08X\n", lan743x_reg[ETH_MAC_RX]);
+	fprintf(stdout, "MAC_TX       = 0x%08X\n", lan743x_reg[ETH_MAC_TX]);
+	fprintf(stdout, "FLOW         = 0x%08X\n", lan743x_reg[ETH_FLOW]);
+	fprintf(stdout, "MII_ACC      = 0x%08X\n", lan743x_reg[ETH_MII_ACC]);
+	fprintf(stdout, "MII_DATA     = 0x%08X\n", lan743x_reg[ETH_MII_DATA]);
+	fprintf(stdout, "WUCSR        = 0x%08X\n", lan743x_reg[ETH_WUCSR]);
+	fprintf(stdout, "WK_SRC       = 0x%08X\n", lan743x_reg[ETH_WK_SRC]);
+	fprintf(stdout, "EEE_TX_LPI_REQ_DLY = 0x%08X\n",
+					lan743x_reg[ETH_EEE_TX_LPI_REQ_DLY]);
+	fprintf(stdout, "\n");
+}
+
+int lan743x_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
+		      struct ethtool_regs *regs)
+{
+
+	lan743x_comm_dump_regs(info, regs);
+
+	return 0;
+}
-- 
2.25.1

