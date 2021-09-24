Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEEF416F48
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245337AbhIXJof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:44:35 -0400
Received: from inva020.nxp.com ([92.121.34.13]:44762 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245259AbhIXJoV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 05:44:21 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4D9981A3060;
        Fri, 24 Sep 2021 11:42:44 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DF0801A3058;
        Fri, 24 Sep 2021 11:42:43 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id EC8A0183AD0B;
        Fri, 24 Sep 2021 17:42:40 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com
Subject: [PATCH v5 net-next 2/9] net: mscc: ocelot: export struct ocelot_mact_entry
Date:   Fri, 24 Sep 2021 17:52:19 +0800
Message-Id: <20210924095226.38079-3-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210924095226.38079-1-xiaoliang.yang_1@nxp.com>
References: <20210924095226.38079-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Felix DSA needs to use this struct to export MAC table write and lookup
operations as well, for its stream identification functions, so export
them in preparation of that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c |  6 ------
 drivers/net/ethernet/mscc/ocelot.h | 13 -------------
 include/soc/mscc/ocelot.h          | 19 +++++++++++++++++++
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9f481cf19931..35006b0fb963 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -14,12 +14,6 @@
 #define TABLE_UPDATE_SLEEP_US 10
 #define TABLE_UPDATE_TIMEOUT_US 100000
 
-struct ocelot_mact_entry {
-	u8 mac[ETH_ALEN];
-	u16 vid;
-	enum macaccess_entry_type type;
-};
-
 /* Must be called with &ocelot->mact_lock held */
 static inline u32 ocelot_mact_read_macaccess(struct ocelot *ocelot)
 {
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 1952d6a1b98a..a77050b13d18 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -54,19 +54,6 @@ struct ocelot_dump_ctx {
 	int idx;
 };
 
-/* MAC table entry types.
- * ENTRYTYPE_NORMAL is subject to aging.
- * ENTRYTYPE_LOCKED is not subject to aging.
- * ENTRYTYPE_MACv4 is not subject to aging. For IPv4 multicast.
- * ENTRYTYPE_MACv6 is not subject to aging. For IPv6 multicast.
- */
-enum macaccess_entry_type {
-	ENTRYTYPE_NORMAL = 0,
-	ENTRYTYPE_LOCKED,
-	ENTRYTYPE_MACv4,
-	ENTRYTYPE_MACv6,
-};
-
 /* A (PGID) port mask structure, encoding the 2^ocelot->num_phys_ports
  * possibilities of egress port masks for L2 multicast traffic.
  * For a switch with 9 user ports, there are 512 possible port masks, but the
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 682cd058096c..e6773f4d09ce 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -701,6 +701,25 @@ struct ocelot_skb_cb {
 	u8 ts_id;
 };
 
+/* MAC table entry types.
+ * ENTRYTYPE_NORMAL is subject to aging.
+ * ENTRYTYPE_LOCKED is not subject to aging.
+ * ENTRYTYPE_MACv4 is not subject to aging. For IPv4 multicast.
+ * ENTRYTYPE_MACv6 is not subject to aging. For IPv6 multicast.
+ */
+enum macaccess_entry_type {
+	ENTRYTYPE_NORMAL = 0,
+	ENTRYTYPE_LOCKED,
+	ENTRYTYPE_MACv4,
+	ENTRYTYPE_MACv6,
+};
+
+struct ocelot_mact_entry {
+	u8 mac[ETH_ALEN];
+	u16 vid;
+	enum macaccess_entry_type type;
+};
+
 #define OCELOT_SKB_CB(skb) \
 	((struct ocelot_skb_cb *)((skb)->cb))
 
-- 
2.17.1

