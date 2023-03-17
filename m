Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF916BECE4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjCQP3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjCQP27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:28:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4B19AA38;
        Fri, 17 Mar 2023 08:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679066935; x=1710602935;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PhgPMRlzJGtfWwjQyD+11Koj0Sg2pM5m2q9ird249rU=;
  b=VIvfjEw69n9lAc69Tk3VZWBfRbSDRHVC9GeLWsBhA7mvG46wo7yuFsVo
   1/vshHMDplaBRfb4m2js4zkT680Gl9oEtKJSfZayxWLp65jAuz7oUo4Jf
   hx02+wKqUd6bjTjlcmccJ9OdMYDJhs3uhBe4y1TSBNuwvcy7PF6ng54Cx
   f4B/jS/jkwzdQvLE+r1tpgsVswJ1ucxm/PFhS9tYuDE1t0wCMTSHXtY2V
   ODCmPANbKvqHL0kjB+/voMz+Bjv7lnqpicaLVNroA6ye+g7Swj+M7bfjV
   Jw3A7yFWv4pqsroLs5SFUUFkAYzGsOmhr8iHcSOaynuQR9Qc8X0kQvltL
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,268,1673938800"; 
   d="scan'208";a="205973694"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2023 08:28:54 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 17 Mar 2023 08:28:49 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 17 Mar 2023 08:28:47 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <david.laight@aculab.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 2/2] net: lan966x: Stop using packing library
Date:   Fri, 17 Mar 2023 16:27:13 +0100
Message-ID: <20230317152713.4141614-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230317152713.4141614-1-horatiu.vultur@microchip.com>
References: <20230317152713.4141614-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a frame is injected from CPU, it is required to create an IFH(Inter
frame header) which sits in front of the frame that is transmitted.
This IFH, contains different fields like destination port, to bypass the
analyzer, priotity, etc. Lan966x it is using packing library to set and
get the fields of this IFH. But this seems to be an expensive
operations.
If this is changed with a simpler implementation, the RX will be
improved with ~5Mbit while on the TX is a much bigger improvement as it
is required to set more fields. Below are the numbers for TX.

Before:
[  5]   0.00-10.02  sec   439 MBytes   367 Mbits/sec    0 sender

After:
[  5]   0.00-10.00  sec   578 MBytes   485 Mbits/sec    0 sender

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Kconfig    |  1 -
 .../ethernet/microchip/lan966x/lan966x_main.c | 74 +++++++++++++------
 2 files changed, 50 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
index 8bcd60f17d6d3..571e6d4da1e9d 100644
--- a/drivers/net/ethernet/microchip/lan966x/Kconfig
+++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
@@ -6,7 +6,6 @@ config LAN966X_SWITCH
 	depends on NET_SWITCHDEV
 	depends on BRIDGE || BRIDGE=n
 	select PHYLINK
-	select PACKING
 	select PAGE_POOL
 	select VCAP
 	help
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 4584a78c6ecbd..9be6462f1cc56 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -7,7 +7,6 @@
 #include <linux/ip.h>
 #include <linux/of_platform.h>
 #include <linux/of_net.h>
-#include <linux/packing.h>
 #include <linux/phy/phy.h>
 #include <linux/reset.h>
 #include <net/addrconf.h>
@@ -305,46 +304,57 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
 	return NETDEV_TX_BUSY;
 }
 
+static void lan966x_ifh_set(u8 *ifh, size_t val, size_t pos, size_t length)
+{
+	int i = 0;
+
+	do {
+		u8 p = IFH_LEN_BYTES - (pos + i) / 8 - 1;
+		u8 v = val >> i & 0xff;
+
+		/* There is no need to check for limits of the array, as these
+		 * will never be written
+		 */
+		ifh[p] |= v << ((pos + i) % 8);
+		ifh[p - 1] |= v >> (8 - (pos + i) % 8);
+
+		i += 8;
+	} while (i < length);
+}
+
 void lan966x_ifh_set_bypass(void *ifh, u64 bypass)
 {
-	packing(ifh, &bypass, IFH_POS_BYPASS + IFH_WID_BYPASS - 1,
-		IFH_POS_BYPASS, IFH_LEN * 4, PACK, 0);
+	lan966x_ifh_set(ifh, bypass, IFH_POS_BYPASS, IFH_WID_BYPASS);
 }
 
-void lan966x_ifh_set_port(void *ifh, u64 bypass)
+void lan966x_ifh_set_port(void *ifh, u64 port)
 {
-	packing(ifh, &bypass, IFH_POS_DSTS + IFH_WID_DSTS - 1,
-		IFH_POS_DSTS, IFH_LEN * 4, PACK, 0);
+	lan966x_ifh_set(ifh, port, IFH_POS_DSTS, IFH_WID_DSTS);
 }
 
-static void lan966x_ifh_set_qos_class(void *ifh, u64 bypass)
+static void lan966x_ifh_set_qos_class(void *ifh, u64 qos)
 {
-	packing(ifh, &bypass, IFH_POS_QOS_CLASS + IFH_WID_QOS_CLASS - 1,
-		IFH_POS_QOS_CLASS, IFH_LEN * 4, PACK, 0);
+	lan966x_ifh_set(ifh, qos, IFH_POS_QOS_CLASS, IFH_WID_QOS_CLASS);
 }
 
-static void lan966x_ifh_set_ipv(void *ifh, u64 bypass)
+static void lan966x_ifh_set_ipv(void *ifh, u64 ipv)
 {
-	packing(ifh, &bypass, IFH_POS_IPV + IFH_WID_IPV - 1,
-		IFH_POS_IPV, IFH_LEN * 4, PACK, 0);
+	lan966x_ifh_set(ifh, ipv, IFH_POS_IPV, IFH_WID_IPV);
 }
 
 static void lan966x_ifh_set_vid(void *ifh, u64 vid)
 {
-	packing(ifh, &vid, IFH_POS_TCI + IFH_WID_TCI - 1,
-		IFH_POS_TCI, IFH_LEN * 4, PACK, 0);
+	lan966x_ifh_set(ifh, vid, IFH_POS_TCI, IFH_WID_TCI);
 }
 
 static void lan966x_ifh_set_rew_op(void *ifh, u64 rew_op)
 {
-	packing(ifh, &rew_op, IFH_POS_REW_CMD + IFH_WID_REW_CMD - 1,
-		IFH_POS_REW_CMD, IFH_LEN * 4, PACK, 0);
+	lan966x_ifh_set(ifh, rew_op, IFH_POS_REW_CMD, IFH_WID_REW_CMD);
 }
 
 static void lan966x_ifh_set_timestamp(void *ifh, u64 timestamp)
 {
-	packing(ifh, &timestamp, IFH_POS_TIMESTAMP + IFH_WID_TIMESTAMP - 1,
-		IFH_POS_TIMESTAMP, IFH_LEN * 4, PACK, 0);
+	lan966x_ifh_set(ifh, timestamp, IFH_POS_TIMESTAMP, IFH_WID_TIMESTAMP);
 }
 
 static netdev_tx_t lan966x_port_xmit(struct sk_buff *skb,
@@ -582,22 +592,38 @@ static int lan966x_rx_frame_word(struct lan966x *lan966x, u8 grp, u32 *rval)
 	}
 }
 
+static u64 lan966x_ifh_get(u8 *ifh, size_t pos, size_t length)
+{
+	u64 val = 0;
+	u8 v;
+
+	for (int i = 0; i < length ; i++) {
+		int j = pos + i;
+		int k = j % 8;
+
+		if (i == 0 || k == 0)
+			v = ifh[IFH_LEN_BYTES - (j / 8) - 1];
+
+		if (v & (1 << k))
+			val |= (1 << i);
+	}
+
+	return val;
+}
+
 void lan966x_ifh_get_src_port(void *ifh, u64 *src_port)
 {
-	packing(ifh, src_port, IFH_POS_SRCPORT + IFH_WID_SRCPORT - 1,
-		IFH_POS_SRCPORT, IFH_LEN * 4, UNPACK, 0);
+	*src_port = lan966x_ifh_get(ifh, IFH_POS_SRCPORT, IFH_WID_SRCPORT);
 }
 
 static void lan966x_ifh_get_len(void *ifh, u64 *len)
 {
-	packing(ifh, len, IFH_POS_LEN + IFH_WID_LEN - 1,
-		IFH_POS_LEN, IFH_LEN * 4, UNPACK, 0);
+	*len = lan966x_ifh_get(ifh, IFH_POS_LEN, IFH_WID_LEN);
 }
 
 void lan966x_ifh_get_timestamp(void *ifh, u64 *timestamp)
 {
-	packing(ifh, timestamp, IFH_POS_TIMESTAMP + IFH_WID_TIMESTAMP - 1,
-		IFH_POS_TIMESTAMP, IFH_LEN * 4, UNPACK, 0);
+	*timestamp = lan966x_ifh_get(ifh, IFH_POS_TIMESTAMP, IFH_WID_TIMESTAMP);
 }
 
 static irqreturn_t lan966x_xtr_irq_handler(int irq, void *args)
-- 
2.38.0

