Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECF36B6B0B
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 21:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjCLUYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 16:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjCLUYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 16:24:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E903F30E8B;
        Sun, 12 Mar 2023 13:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678652674; x=1710188674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6TSoduTKtHoMLMkH03ur3wZe+9SRdv82LM/LbipnRYY=;
  b=B3bzkBVtDawTz1EcRk5g55jE41hHynK7BdpvNaCoBXEZxXkgfpJVikfh
   JlXu1EapmFq30VcSDVrnD1FXgSkYVP4FgHnOva96ohz+2jtjwHKLOeQWZ
   GNcJcYNx70t/XvY60ljroScfXqQAs6T6GCjGO1g315m/NkN1YUsv4TMNk
   ANZONum+3TBecAGGP7T/bW0d5RR2XzzF2LSyWU9UQTsvdoLofpGbyG7bp
   x3dkqgFavGVNm74MQkHkfjpjMCRGB8sOSEDYPBMN4sOnr8Vnd67qNVmhJ
   yzWIEa1Ur3TO8tfJfzqB6c+XdUgkulbJOCtYKgSRTVEkKQtlhIyWBvgnC
   w==;
X-IronPort-AV: E=Sophos;i="5.98,254,1673938800"; 
   d="scan'208";a="141624485"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Mar 2023 13:24:34 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 13:24:33 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 13:24:32 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/2] net: lan966x: Stop using packing library
Date:   Sun, 12 Mar 2023 21:24:24 +0100
Message-ID: <20230312202424.1495439-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230312202424.1495439-1-horatiu.vultur@microchip.com>
References: <20230312202424.1495439-1-horatiu.vultur@microchip.com>
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
[  5]   0.00-10.00  sec   563 MBytes   472 Mbits/sec    0 sender

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Kconfig    |  1 -
 .../ethernet/microchip/lan966x/lan966x_main.c | 75 +++++++++++++------
 2 files changed, 51 insertions(+), 25 deletions(-)

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
index 4584a78c6ecbd..9134716b62a55 100644
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
@@ -305,46 +304,58 @@ static int lan966x_port_ifh_xmit(struct sk_buff *skb,
 	return NETDEV_TX_BUSY;
 }
 
+static void lan966x_ifh_set(u8 *ifh, size_t val, size_t pos, size_t length)
+{
+	u32 v = 0;
+
+	for (int i = 0; i < length ; i++) {
+		int j = pos + i;
+		int k = j % 8;
+
+		if (i == 0 || k == 0)
+			v = ifh[IFH_LEN_BYTES - (j / 8) - 1];
+
+		if (val & (1 << i))
+			v |= (1 << k);
+
+		if (i == (length - 1) || k == 7)
+			ifh[IFH_LEN_BYTES - (j / 8) - 1] = v;
+	}
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
@@ -582,22 +593,38 @@ static int lan966x_rx_frame_word(struct lan966x *lan966x, u8 grp, u32 *rval)
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

